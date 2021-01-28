/*//#########################################################################################
Projeto : Aprova��o Controle de Al�ada
Modulo  : SIGACOM
Fonte   : MTALCDOC
Objetivo: O Ponto de entrada é executado após geração ou atualização da alçada do compras
          que está sendo utilizado no módulo Faturamento
*///#########################################################################################

#INCLUDE 'TOTVS.CH'
#include "FWMVCDEF.CH"


/*/{Protheus.doc} MTALCDOC

	Ponto de Entrada MTALCDOC

	@author Bruno Alves de Oliveira
	@since 19/01/2021
	@version 1.0
/*/



User Function MTALCDOC()

	Local dData 	:= PARAMIXB[2]
	Local nTp 		:= PARAMIXB[3]
	Local cGrpIT 	:= PARAMIXB[4]
	Local aArea	    := GetArea()
	Local aAreaTMP

	Local cMsg		:= ""
	Local oFiles

	Private aDoc       := PARAMIXB[1]
	Private cChaveSCR	:= xFilial("SCR") + aDoc[2] + Alltrim(aDoc[1])
	Private cTmp       := ""
	Private cCampoApr  := ""
	Private cCampoObs  := ""
	Private cCampoSit  := ""


	/*
		Variavel nTp
		1: Inclusão do documento
		2: Transferência da alçada para o superior
		3: Exclusão do documento
		4: Aprovação do documento
		5: Estorno da aprovação
		6: Bloqueio manual
	*/

	//Todo o controle pelo ponto de entrada é devido a solicitação de compras.
	If aDoc[2] == "A1"

		DbSelectArea("SCR");DbSetOrder(1)
		DbSeek(cChaveSCR)

		//Localizo o registro
		DbSelectArea("SZS");DbSetOrder(1)
		If Dbseek(xFilial("SZS") + Alltrim(aDoc[1]))


			If nTp == 1

				If SZS->ZS_CONTRAT == "1"

					u_LiberaSZS(DATE(),"Libera��o automatica - Autoriza��o de Entrega",SZS->ZS_CONTRAT)

				Else

					RecLock("SZS",.F.)
					SZS->ZS_DTLIB 	:= CTOD("//")
					SZS->ZS_LIBERAD := "P"
					SZS->ZS_OBSLIB 	:= ""
					MsUnLock()

				EndIf




			ElseIf nTp == 3

				RecLock("SZS",.F.)
				SZS->ZS_DTLIB 	:= CTOD("//")
				SZS->ZS_LIBERAD := "P"
				SZS->ZS_OBSLIB 	:= ""
				MsUnLock()



			ElseIf nTp == 4


				//Verifico se todos os niveis foram aprovados
				If AnalisaApr()

					DbSelectArea("SCR");DbSetOrder(1)
					DbSeek(cChaveSCR)

					//Aprovo o documento
					RecLock("SZS",.F.)
					SZS->ZS_DTLIB 	:= SCR->CR_DATALIB
					SZS->ZS_LIBERAD := "L"
					MsUnLock()

					MsgInfo("Documento " + Alltrim(aDoc[1]) + " aprovado com sucesso!","MTALCDOC - Aprovacao")

				Else

					MsgInfo("Nivel aprovado com sucesso!","MTALCDOC - Aprovacao")

				EndIf




				//Verifico se foi rejei��o ou bloqueio do nivel
			ElseIf nTp == 7 .or. nTp == 6

				//reprovo o documento
				RecLock("SZS",.F.)
				SZS->ZS_DTLIB 	:= SCR->CR_DATALIB
				SZS->ZS_LIBERAD := "B"
				SZS->ZS_OBSLIB 	:= SCR->CR_OBS
				MsUnLock()

				MsgInfo("Documento " + Alltrim(aDoc[1]) + " reprovado com sucesso!","MTALCDOC")

			EndIf

		EndIf

	EndIf

	RestArea(aArea)
Return



/*/{Protheus.doc} AnalisaApr
O objetivo da função é verificar se todos os níveis de uma determinada SC
(solicitação de compra) estão aprovados. Caso esteja irá retornar .T. e
vice-versa.
@author rubens.redel
@since 25/09/2014
@version 1.0
@param _cFilSC, char, Filial da solicitação
@param _cNumSC, char, Número da solicitação
@return logical, .T. se houve aprovação total e .F. se falta níveis para aprovar
/*/
Static function AnalisaApr()


	Local lOk		:= .T.

	DbSelectArea("SCR");DbSetOrder(1)
	If DbSeek(cChaveSCR)


		while !SCR->(EOF()) .AND. cChaveSCR == (SCR->CR_FILIAL + SCR->CR_TIPO + Alltrim(SCR->CR_NUM))

			// se encontrar algum nível não aprovado
			if !(SCR->CR_STATUS $ '03/05')
				// retorna falso
				lOk := .F.
			endif

			SCR->(dbSkip())

		endDo

	Else

		Alert("Documento n�o encontrado no controle de al�ada. Favor Verificar. Filial - Tipo - Numero: " + Alltrim(cChaveSCR),"AnalisaApr")
		lOk := .F.

	EndIf




return lOk




/*//#########################################################################################
Module   : Faturamento
Source   : ImpAprov
Autor	 : Bruno Alves de Oliveira
Objective: Função responsavel por buscar quais são os aprovadores e o status da aprovação
*///#########################################################################################


Static Function SitAprov(cFil,cCodigo)

	Local cAprov := ""


	dbSelectArea("SCR");dbSetOrder(1)
	dbSeek(xFilial("SCR") + aDoc[2] + Alltrim(aDoc[1]))
	While !Eof() .And. (SCR->CR_FILIAL+SCR->CR_TIPO+Alltrim(SCR->CR_NUM))==(xFilial("SCR") + aDoc[2] + Alltrim(aDoc[1]))
		cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
		Do Case
			Case SCR->CR_STATUS=="02" //Pendente
				cAprov += "PEN"
			Case SCR->CR_STATUS=="03" //Liberado
				cAprov += "Ok"
			Case SCR->CR_STATUS=="04" //Bloqueado
				cAprov += "BLQ"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "##"
			Case SCR->CR_STATUS=="06" //Rejeitado
				cAprov += "REJ"
			OtherWise                 //Aguar.Lib
				cAprov += "??"
		EndCase
		cAprov += "] - "
		dbSelectArea("SCR")
		dbSkip()
	Enddo


Return(Alltrim(cAprov))
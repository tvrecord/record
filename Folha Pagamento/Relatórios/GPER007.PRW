#INCLUDE "TOTVS.CH"
#include "topconn.ch"

User Function GPER007()
	PRIVATE cPerg := "GPER007"

		ValidPerg(cPerg)

		If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou, em caso de cancelamento fecha o programa e retorna
		MsgAlert("Operação Cancelada!")
		RestArea(aArea)
		Return //Retorna a tela anterior e fecha o relatorio
		EndIf

		WordImp()

Return

Static Function WordImp()
	Private cPathDot	:= "C:\Docs\Pensao.docx"
	Private aArea     := GetArea()
	Private aAreaSA2  := GetArea()
	//Private cRetro :=  Substring(DTOC(mv_par08),1,6)
	Private cEmissao := Substring(DTOC(mv_par01),6,1) + " de "  + MesExtenso(mv_par01) + " de " + Substring(DTOC(mv_par01),1,4)
	Private	hWord


		If !Empty(mv_par02) .and. PswSeek( 	mv_par02, .T. )
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin1 := Alltrim(aUsuario[1][4])
		cDepart1 := Alltrim(aUsuario[1][13])
		EndIf

		If !Empty(mv_par03) .and. PswSeek( 	mv_par03, .T. )
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin2 := Alltrim(aUsuario[1][4])
		cDepart2 := Alltrim(aUsuario[1][13])
		EndIf

		If !Empty(mv_par06) .and. PswSeek( 	mv_par06, .T. )
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin3 := Alltrim(aUsuario[1][4])
		cCargo3 := Alltrim(aUsuario[1][13])
		EndIf

		/*If (mv_par07) = 2   //Seleciono se o é Mês atual(1) ou retroativo(2) de acordo com o parâmetro

		cQuery := "SELECT CTT_DESC01,RA_NOME, RD_PD, RV_DESC, RQ_PERCENT,RD_VALOR, RD_PERIODO "
		cQuery += "FROM SRA010 "
		cQuery += "INNER JOIN CTT010 "
		cQuery += "ON CTT_FILIAL = RA_FILIAL "
		cQuery += "AND CTT_CUSTO = RA_CC "
		cQuery += "INNER JOIN SRD010 "
		cQuery += "ON RD_FILIAL = RA_FILIAL "
		cQuery += "AND RD_MAT = RA_MAT "
		cQuery += "AND RD_PERIODO = '" + cRetro + "' "
		cQuery += "INNER JOIN SRV010 "
		cQuery += "ON RV_COD = RD_PD "
		cQuery += "INNER JOIN SRQ010 "
		cQuery += "ON RQ_FILIAL = RA_FILIAL "
		cQuery += "AND RQ_MAT = RA_MAT "
		cQuery += "AND RQ_SEQUENC = '01' "
		cQuery += "WHERE RA_MAT ='" + (MV_PAR04) + "' "
		cQuery += "AND RD_PD IN ('450','148') "

			else*/

		cQuery := "SELECT CTT_DESC01,RA_NOME, RC_PD, RV_DESC, RQ_PERCENT,RC_VALOR, RC_PERIODO "
		cQuery += "FROM SRA010 "
		cQuery += "INNER JOIN CTT010 "
		cQuery += "ON CTT_FILIAL = RA_FILIAL "
		cQuery += "AND CTT_CUSTO = RA_CC "
		cQuery += "INNER JOIN SRC010 "
		cQuery += "ON RC_FILIAL = RA_FILIAL "
		cQuery += "AND RC_MAT = RA_MAT "
		cQuery += "INNER JOIN SRV010 "
		cQuery += "ON RV_COD = RC_PD "
		cQuery += "INNER JOIN SRQ010 "
		cQuery += "ON RQ_FILIAL = RA_FILIAL "
		cQuery += "AND RQ_MAT = RA_MAT "
		cQuery += "AND RQ_SEQUENC = '01' "
		cQuery += "WHERE RA_MAT ='" + (MV_PAR04) + "' "
		cQuery += "AND RC_PD IN ('450','148') "

		//endIf

		//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'FUN', .T., .T.)
		tcQuery cQuery New Alias "FUN"
		dbSelectArea("FUN")

		//Conecta ao word
		hWord	:= OLE_CreateLink()
		OLE_NewFile(hWord, cPathDot )

		//Montagem das variaveis do cabecalho
		OLE_SetDocumentVar(hWord, 'Prt_DtDiaEm'  ,day(mv_par01))
		OLE_SetDocumentVar(hWord, 'Prt_DtMesEtEm',mes(mv_par01))
		OLE_SetDocumentVar(hWord, 'Prt_DtAnoEm'  ,ano(mv_par01))
		OLE_SetDocumentVar(hWord, 'Prt_DeDep', cDepart1)
		OLE_SetDocumentVar(hWord, 'Prt_De', cAssin1)
		OLE_SetDocumentVar(hWord, 'Prt_PaDep', cDepart2)
		OLE_SetDocumentVar(hWord, 'Prt_Pa', cAssin2)
		OLE_SetDocumentVar(hWord, 'Prt_Assin', cAssin3)
		OLE_SetDocumentVar(hWord, 'Prt_AsDep', cCargo3)


		//Informações do Funcionário Mês atual
		cComp 		:= MesExtenso(mv_par01) + "/" + cValToChar(ano(mv_par01))
		cExtenso 	:= Extenso(RC_VALOR,.F.,1,,"1",.T.,.F.)
		OLE_SetDocumentVar(hWord,'Prt_Func',FUN->(RA_NOME))
		OLE_SetDocumentVar(hWord,'Prt_Comp',cComp)
		OLE_SetDocumentVar(hWord,'Prt_Perc',FUN->(RQ_PERCENT))
		OLE_SetDocumentVar(hWord,'Prt_Valor',FUN->(RC_VALOR))
		OLE_SetDocumentVar(hWord,'Prt_Exten',FUN->(cExtenso))

		/*else

		//Informações do Funcionário Mês retroativo
		cComp := MesExtenso(FUN->(RD_PERIODO))
		cExtenso 	:= Extenso(RD_VALOR,.F.,1,,"1",.T.,.F.)
		OLE_SetDocumentVar(hWord,'Prt_Func',FUN->(RA_NOME))
		OLE_SetDocumentVar(hWord,'Prt_Comp',cComp)
		OLE_SetDocumentVar(hWord,'Prt_Perc',FUN->(RQ_PERCENT))
		OLE_SetDocumentVar(hWord,'Prt_Valor',FUN->(RD_VALOR))
		OLE_SetDocumentVar(hWord,'Prt_Exten',FUN->(cExtenso))

		endIf*/


		FUN->(DbCloseArea())

		//BENEFICIÁRIO
		cQuery := "SELECT A2_COD, A2_NOME, A2_CGC, A2_BANCO, A2_DESCBAN,A2_AGENCIA,A2_DGAGEN, A2_NUMCON,A2_DGCONTA,A2_OPERAC, A2_COMPLEM, A2_DEPTO FROM SA2010 "
		cQuery += "WHERE A2_COD = '" + (mv_par05) + "'"

		tcQuery cQuery New Alias "SA2"

		//dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'FUN', .T., .T.)
		dbSelectArea("SA2")

		OLE_SetDocumentVar(hWord,'Prt_Forn',SA2->(A2_NOME))
		OLE_SetDocumentVar(hWord,'Prt_Cgc',SA2->(A2_CGC))
		OLE_SetDocumentVar(hWord,'Prt_Banc',SA2->(A2_DESCBAN))
		OLE_SetDocumentVar(hWord,'Prt_Agenc',SA2->(A2_AGENCIA))
		OLE_SetDocumentVar(hWord,'Prt_DigA',SA2->(A2_DGAGEN))
		OLE_SetDocumentVar(hWord,'Prt_Conta',SA2->(A2_NUMCON))
		OLE_SetDocumentVar(hWord,'Prt_DigC',SA2->(A2_DGCONTA))
		OLE_SetDocumentVar(hWord,'Prt_Op',SA2->(A2_OPERAC))
		OLE_SetDocumentVar(hWord,'Prt_Complem',SA2->(A2_COMPLEM))
		OLE_SetDocumentVar(hWord,'Prt_Proces',SA2->(A2_DEPTO))


		SA2->(DbCloseArea())

		OLE_UpdateFields(hWord)	// Atualizando as variaveis do documento do Word
		OLE_CloseLink( hWord, .F. )

Return()
//Programa usado para criar perguntas na tabela SX1 (Tabela de perguntas)
Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}


	AADD(aRegs,{cPerg,"01","Emissão:"				,"","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","De:"					,"","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	AADD(aRegs,{cPerg,"03","Para:"					,"","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	AADD(aRegs,{cPerg,"04","Funcionário:"			,"","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"05","Favorecida:"			,"","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"06","Assinatura:"			,"","","mv_ch06","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	/*AADD(aRegs,{cPerg,"07","Tipo:"					,"","","mv_ch07","N",01,0,1,"C","","mv_par07","Mês Atual","","","","","Retroativo","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Mês Retroativo:"		,"","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})*/



	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return


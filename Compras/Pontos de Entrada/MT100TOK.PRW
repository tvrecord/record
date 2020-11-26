#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100OK ºAutor  ³Bruno Alves           º Data ³  11/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validacao da inclusao de Nota Fiscal   ±±
±±º          ³deEntrada.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Clientes Microsiga                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100TOK()

	Local nPosPrd  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_COD'})
	Local nPosItem 	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_ITEM'})
	Local nPosRat  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_RATEIO'})
	Local nPosCC   	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_CC'})
	Local nPosPed  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_PEDIDO'})
	Local aSvAlias

	Private nPosPerm   := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_PERMUTA'})
	Private nPosPos    := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_ITEMPER'})
	Private nTes   	   := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_TES'})
	Private cAutoriz   := ""
	Private cFornece   := ""
	Private cLoja	   := ""
	Private nAutori	   := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_AUTORIZ'})
	Private nFornece   := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_FORNECE'})
	Private nLoja	   := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_LOJA'})
	Private cFornece   := ""
	Private lValido    := .T.
	Private lTes       := .T.
	Private cContrato  := Space(06)
	Private cAutoriz   := Space(06)
	Private nPosNat    := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_NATUREZ'})
	Private nPosFil    := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_FILIAL'})
	Private cNumRep    := Space(20)
	Private dDataIni   := CTOD("//")
	Private dDataFim   := CTOD("//")
	Private lRepasse     := IIF(ALLTRIM(aCols[1][nPosNat]) == GETMV("RR_NATREP"),.T.,.F.)
	Private lPeriodo     := IIF(POSICIONE("SED",1,xFilial("SED")+aCols[1][nPosNat],"ED_COMBV") == "1",.T.,.F.)

	/* Posições
	1: Documento de Entrada + Fornecedor
	2: Numero do RP
	*/
	Public aXNumRep	   := {}

	//Grava a Posicao atual
	aSvAlias :={Alias(),IndexOrd(),Recno()}

	DbSelectArea("SA2")
	_nRecSA2   := Recno()
	_cIndSA2   := IndexOrd()
	DbSelectArea("SF1")
	_nRecSF1   := Recno()
	_cIndSF1   := IndexOrd()
	DbSelectArea("SD1")
	_nRecSD1   := Recno()
	_cIndSD1   := IndexOrd()
	DbSelectArea("SEV")
	_nRecSEV   := Recno()
	_cIndSEV   := IndexOrd()
	DbSelectArea("SF3")
	_nRecSF3   := Recno()
	_cIndSF3   := IndexOrd()
	DbSelectArea("SFT")
	_nRecSFT   := Recno()
	_cIndSFT   := IndexOrd()
	DbSelectArea("SE2")
	_nRecSE2   := Recno()
	_cIndSE2   := IndexOrd()

	IF ALLTRIM(FUNNAME()) $ "MATA103"


		IF aCols[n][nPosRat] == "1"
			lValido := .T.
		ELSE
			IF EMPTY(aCols[n][nPosCC] )
				Help(" ",1,"D1_CC")
				lValido  := .F.
			ENDIF
		ENDIF

		//Verifico se a natureza é repasse
		If (lRepasse .or. lPeriodo).and. lValido

			@ 000,003 TO 145,315 DIALOG oDlg TITLE "Repasse - Periodo Faturamento"
			@ 005,003 Say "Informe o Numero do Repasse"
			@ 015,003 Say "Nº Repasse:"
			@ 014,040 Get cNumRep  F3 "XREP"  WHEN lRepasse Valid  !Vazio() //EXISTCPO("SC5",cNumRep,10) .AND. !Vazio() //Rafael França - 26/11/20 - Retirada a validação da SC5, porque tem RPs que só vão ser lançadas depois
			@ 030,003 Say "Informe o Periodo do Faturamento"
			@ 040,003 Say "Data Inicial:"
			@ 039,036 Get dDataIni Picture "99/99/9999" WHEN lPeriodo Valid !Vazio() SIZE 40,020
			@ 040,080 Say "Data Fim:"
			@ 039,105 Get dDataFim Picture "99/99/9999" WHEN lPeriodo Valid !Vazio() SIZE 40,020
			@ 060,095 BMPBUTTON TYPE 01 ACTION ValidRep(2)
			@ 060,125 BMPBUTTON TYPE 02 ACTION ValidRep(3)//Close(oDlg)
			ACTIVATE DIALOG oDlg CENTERED

		EndIf


		//Nao permite incluir um novo produto alem dos que foram importados pelo pedido
		//Essa validacao vale somente para as  notas fiscais que estao vinculadas aos pedidos de compras
		//Autor: Bruno Alves

		If Ascan(aCols,{|x| Alltrim(x[nPosPed]) != ''}) > 0 //Vinculado com pedido de compra?

			For i := 1 To Len(aCols)
				//Valida Linha do delete
				IF EMPTY(aCols[i][nPosPed]) .AND. aCols[i][Len(aHeader) + 1] == .F.       //Verifica se o registro esta deletado e nao pertence a um pedido de compra ou contrato?
					Alert("Não é permitido inserir um novo produto quando vinculado o pedido de compra com a nota fiscal!!!")
					lValido := .F.
					Exit
				EndIf

				//Retirado 29/10/2013 - Conforme orientação da Eurilene
				//Verifica se existe alguma TES que gera financeiro, pois o contrato de permuta é utilizado somente com notas que não gerem financeiro
				IF Posicione("SF4",1,xFilial("SF4") + ALLTRIM(aCols[i][nTes]),"F4_DUPLIC") == "S" .AND. aCols[i][Len(aHeader) + 1] == .F.
					lTes := .F.
					//Exit
				EndIf


			Next i

			// Utilizado para controlar contratos de PERMUTA
			// Irá poder acessar a rotina caso a nota esteja vinculada a um pedido
			If lValido == .T. //.AND. lTes == .T.
				@ 000,000 TO 145,315 DIALOG oDlg TITLE "Contrato - PERMUTA / Autorização de pagamento"
				@ 010,005 Say "Deseja descontar o Valor Total em algum Contrato de Permuta ou Autorização?"
				@ 025,040 Say "Contrato:"
				@ 025,070 Get cContrato  F3 "SC3PER" Valid  !EMPTY(cContrato)
				//			@ 045,040 Say "Autorização:"
				//			@ 045,070 Get cAutiriz  F3 "SZS" Valid  !EMPTY(cAutiriz)
				@ 045,055 BMPBUTTON TYPE 01 ACTION TelaDes()
				@ 045,085 BMPBUTTON TYPE 02 ACTION Close(oDlg)
				ACTIVATE DIALOG oDlg CENTERED

			EndIf

		EndIf


		If lValido == .T. .AND. lTes == .T. .AND. Posicione("SED",1,xFilial("SED") + ALLTRIM(aCols[1][nPosNat]),"ED_AUTNF") == "1" .AND. ;
				xFilial("SF1") <> "05" .AND. !(AllTrim(cUserName) $ "Marina de Jesus Santana - Radio%Administrador%WYLL VICTOR DE SOUSA MARTINS - wvsmartins%WYLL MARTINS - wyllmartins") .AND. Posicione("SA2",1,xFilial("SA2")+ cA100FOR + CLOJA,"A2_AUTNF") == "1"

			lValido  := .F.

			@ 000,000 TO 145,315 DIALOG oDlg TITLE "Autorização de pagamento"
			@ 010,005 Say "Deseja vincular a nota a autorização de pagamento?"
			@ 025,040 Say "Autorização:"
			@ 025,070 Get cAutoriz  F3 "SZS" //Valid  !EMPTY(cAutiriz)
			@ 045,085 BMPBUTTON TYPE 01 ACTION TelaAut()
			//@ 045,085 BMPBUTTON TYPE 02 ACTION Close(oDlg)
			ACTIVATE DIALOG oDlg CENTERED

		EndIf

	ENDIF

	DbSelectArea("SA2")
	SA2->(DbSetOrder(_cIndSA2))
	SA2->(DbGoto(_cIndSA2))
	DbSelectArea("SF1")
	SF1->(DbSetOrder(_cIndSF1))
	SF1->(DbGoto(_cIndSF1))
	DbSelectArea("SD1")
	SD1->(DbSetOrder(_cIndSD1))
	SD1->(DbGoto(_cIndSD1))
	DbSelectArea("SEV")
	SEV->(DbSetOrder(_cIndSEV))
	SEV->(DbGoto(_cIndSEV))
	DbSelectArea("SFT")
	SFT->(DbSetOrder(_cIndSFT))
	SFT->(DbGoto(_cIndSFT))
	DbSelectArea("SF3")
	SF3->(DbSetOrder(_cIndSF3))
	SF3->(DbGoto(_cIndSF3))
	DbSelectArea("SE2")
	SE2->(DbSetOrder(_cIndSE2))
	SE2->(DbGoto(_cIndSE2))

	DbSelectArea(aSvAlias[1])
	DbSetOrder(aSvAlias[2])
	DbGoto(aSvAlias[3])



Return(lValido)


Static Function TelaDes()

	Local cItem      := ""
	Local nDesconto  	 := 0
	Local i := 0

	DBSelectArea("SC3")
	DbSetOrder(1)
	If DbSeek(xFilial("SC3") + cContrato) // Encontra o Contrato

		//Verifica Qual item do contrato será utilizado
		While !EOF() .AND. SC3->C3_NUM == cContrato .AND. EMPTY(cItem) .AND. SC3->C3_PERMUTA == "1"

			If EMPTY(SC3->C3_RENOVA)
				cItem := SC3->C3_ITEM
			EndIf

			If EMPTY(cItem)
				DBskip()
			Endif

		EndDo

		If EMPTY(cItem)//Verifica se a configuração do contrato foi realizada com sucesso
			Close(oDlg)
			MsgInfo("É necessário configurar o contrato:  (" + cContrato + ") corretamente!!")
			lValido := .F.
			Return // Se não utilizar o Return, o ponto de entrada se perde
		Endif


		nDesconto := SC3->C3_TOTAL - MaFisRet(,"NF_TOTAL")

		If (nDesconto) < 0 // Saldo do Contrato não pode ficar negativo
			Close(oDlg)
			Alert("Não existe saldo suficiente para concluir a transação, favor verificar o saldo do Contrato (" + cContrato + ")")
			lValido := .F.
			Return // Se não utilizar o Return, o ponto de entrada se perde

		Else

			//GRava na tabela do contrato o valor atual do contrato
			Reclock("SC3",.F.)
			SC3->C3_TOTAL 		:= (nDesconto)
			SC3->C3_PRECO       := (nDesconto)
			MsUnlock()

			For i := 1 to Len(aCols)


				aCols[i][nPosPerm] :=  ALLTRIM(SC3->C3_NUM)
				aCols[i][nPosPos]  :=  ALLTRIM(SC3->C3_ITEM)

			Next i

			Close(oDlg)
			MsgInfo("Valor do Contrato: " + aCols[1][nPosPerm] + " Item: " + aCols[1][nPosPos] + " alterado para: " + cValToChar(nDesconto) + "" )

			DBSelectArea("SC3")
			DBCloseArea("SC3")

		EndIf

	Else

		Close(oDlg)
		MsgInfo(" Contrato: " + cContrato + " não encontrado!!! Favor verificar com o Administrador do Sistema!", "Validação - Contrato")
		lValido  := .F.
		Return

	Endif

Return

Static Function TelaAut()

	Local cStatus := ""

	lValido  := .F.

	cStatus := Posicione("SZS",1,"01" + cAutoriz,"ZS_LIBERAD")
	cFornece := Posicione("SZS",1,"01" + cAutoriz,"ZS_FORNECE")

	IF cStatus == "L" .AND. cFornece == cA100FOR
		lValido  := .T.
		aCols[1][nAutori] := cAutoriz
		Close(oDlg)
	ELSE
		MsgInfo("Digite o numero de uma autorização de pagamento não utilizada, do mesmo fornecedor e liberada!", "Validação - Autorização")
	ENDIF

Return




/*/{Protheus.doc} ValidRep
Validação do preenchimento do código do repasse
@type function
@version
@author Bruno Alves
@since 01/10/2020
@return lValido (verifica se está tudo certo)
/*/

Static Function ValidRep(nOpc)

	Local   cTmp    := GetNextAlias()
	//Fecho a Tela e não concluo a transação
	If nOpc == 3
		If MsgYesno("Tem certeza que deseja cancelar a tela?","ValidRep")
			Close(oDlg)
			lValido := .F.
			Return
		EndIf
	EndIf

	//Verifico se existe repasse cadastrado se for o caso
	If lRepasse

		// Busca os registros a serem impressos no relatório
		BeginSql Alias cTmp

		SELECT
		F1_SERIE,F1_DOC,F1_FORNECE,F1_LOJA,COUNT(*) AS QTD
		FROM %table:SF1% AS SF1 WHERE
		F1_XNUMREP = %Exp:Alltrim(cNumRep)% AND
		SF1.D_E_L_E_T_ = ''
		GROUP BY F1_SERIE,F1_DOC,F1_FORNECE,F1_LOJA

		EndSql

		(cTmp)->(DbGoTop())
		//Se encontrou algum repasse cadastrado retorna .F., pois só deve ter um repasse cadastrado por nota fiscal
		If (cTmp)->QTD > 0
			MsgAlert("Não é possivel incluir o número repasse em mais de uma nota fiscal, favor verificar, pois foi cadastrado na NF: " + Alltrim((cTmp)->F1_DOC) + " - Fornecedor: " + Alltrim((cTmp)->F1_FORNECE),"NatRep")
			lValido := .F.
			Return
		Else
			lValido := .T.
		EndIf

		(cTmp)->(DbCloseArea())

	EndIf

	//Fecho a tela após clicar no botão OK
	If nOpc == 2 .and. lValido
		//Adiciono no vetor para ser utilizado no ponto de entrada SF1100I
		aAdd(aXNumRep , { Alltrim(cNFiscal) + Alltrim(cA100FOR),; // 1 Nota Fiscal + Forncedor
			Alltrim(cNumRep),; // 2 Numero do RP
			dDataIni,; // 3 Data Inicial do Faturamento
			dDataFim }) // 4 Data Final do Faturamento

		Close(oDlg)
	EndIf



Return()


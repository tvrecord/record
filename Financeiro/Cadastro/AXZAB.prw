#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AxSZK     º Autor ³ Rafael Franca      º Data ³  13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de situacoes de ativos no sistema.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Record Centro-Oeste                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AXZAB

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cCadastro := "Cadastro BV"
	Private nOpca := 0
	Private aParam := {}

	Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","AxInclui",0,3},;
		{"Alterar","AxAltera",0,4},;
		{"Excluir","AxDeleta",0,5},;
		{"Importar","u_IMPORTSE2",0,5},;
		{"Rel BV","u_RelBV()",0,5},;
		{"Export xls","u_COMISSBV()",0,2}}

	Private cString := "ZAB"

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,)

Return

User Function IMPORTSE2

	Private dBaixa1 	:= CtoD("//")
	Private dBaixa2 	:= CtoD("//")
	Private dFat1		:= CtoD("//")
	Private dFat2		:= CtoD("//")

	@ 000,000 TO 160,500 DIALOG oDlg TITLE "Importar Titulos de Comissoes"
	@ 011,020 Say "Da Baixa:"
	@ 010,060 Get dBaixa1  SIZE 40,020
	@ 011,150 Say "Ate a Baixa:"
	@ 010,190 Get dBaixa2 SIZE 40,020
	@ 035,020 Say "Do Faturamento:"
	@ 035,060 Get dFat1 SIZE 40,020
	@ 035,150 Say "Ate o Faturamento:"
	@ 035,190 Get dFat2 SIZE 40,020
	@ 060,170 BMPBUTTON TYPE 01 ACTION IMPORTBV(dBaixa1,dBaixa2,dFat1,dFat2)
	@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return

Static Function IMPORTBV(dBaixa1,dBaixa2,dFat1,dFat2)

	Local cQuery 	:= ""
	Local cNotas	:= ""
	Local cNotas1	:= ""
	Local cNotas2  	:= ""
	Local cNotas3	:= ""
	Local cNotas4  	:= ""
	Local nFatGov	:= 0
	Local nFatVar	:= 0
	Local nFatTot	:= 0
	Local aContrato := {}
	Local nPerc 	:= 0
	Local lOk		:= .T.
	Local nCont		:= 0

	cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,E2_BAIXA,(E2_ISS + E2_IRRF + E2_VALOR) AS E2_VALOR,E2_NATUREZ,E2_HIST,A2_CGC "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SED010 ON E2_NATUREZ = ED_CODIGO "
	cQuery += "INNER JOIN SA2010 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA "
	cQuery += "WHERE SED010.D_E_L_E_T_ = '' AND SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' "
	cQuery += "AND ED_COMBV = '1' "
	cQuery += "AND E2_BAIXA BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "' "
	//cQuery += "AND E2_VENCREA BETWEEN '" + DTOS(dFat1) + "' AND '" + DTOS(dFat2) + "' "
	cQuery += "ORDER BY E2_NATUREZ "

	tcQuery cQuery New Alias "TMPBV"

	If Eof()
		MsgInfo("Não existem dados no periodo informado!","Verifique")
		dbSelectArea("TMPBV" )
		dbCloseArea("TMPBV" )
		Return
	Endif

	Count To nRec

	dbSelectArea("TMPBV")
	dbGoTop()

	ProcRegua(nRec)

	While !EOF()

		IncProc()

		dbSelectArea("ZAB")
		dBSetOrder(1)
		If !dbSeek(xFilial("ZAB") + TMPBV->E2_PREFIXO + TMPBV->E2_NUM + TMPBV->E2_PARCELA + TMPBV->E2_TIPO + TMPBV->E2_FORNECE + TMPBV->E2_LOJA)
			Reclock("ZAB",.T.)
			ZAB->ZAB_FILIAL := xFilial("ZAB")
			ZAB->ZAB_PREFIX := TMPBV->E2_PREFIXO
			ZAB->ZAB_TITULO := TMPBV->E2_NUM
			ZAB->ZAB_PARC   := TMPBV->E2_PARCELA
			ZAB->ZAB_TIPO   := TMPBV->E2_TIPO
			ZAB->ZAB_FORNEC := TMPBV->E2_FORNECE
			ZAB->ZAB_LOJA 	:= TMPBV->E2_LOJA
			ZAB->ZAB_NOME	:= TMPBV->E2_NOMFOR
			ZAB->ZAB_EMISSA := STOD(TMPBV->E2_EMISSAO)
			ZAB->ZAB_VENCTO := STOD(TMPBV->E2_VENCREA)
			ZAB->ZAB_BAIXA 	:= STOD(TMPBV->E2_BAIXA)
			ZAB->ZAB_NATURE := TMPBV->E2_NATUREZ
			ZAB->ZAB_OBS    := TMPBV->E2_HIST
			ZAB->ZAB_VLSE2	:= TMPBV->E2_VALOR
			ZAB->ZAB_VEND   := Posicione("SA3",3,xFilial("SA3")+TMPBV->A2_CGC,"A3_COD")
			ZAB->ZAB_FATINI := dFat1
			ZAB->ZAB_FATFIN := dFat2
			MsUnlock()
		ELSE
			Reclock("ZAB",.F.)
			ZAB->ZAB_NOME	:= TMPBV->E2_NOMFOR
			ZAB->ZAB_EMISSA := STOD(TMPBV->E2_EMISSAO)
			ZAB->ZAB_VENCTO := STOD(TMPBV->E2_VENCREA)
			ZAB->ZAB_BAIXA 	:= STOD(TMPBV->E2_BAIXA)
			ZAB->ZAB_NATURE := TMPBV->E2_NATUREZ
			ZAB->ZAB_OBS    := TMPBV->E2_HIST
			ZAB->ZAB_VLSE2	:= TMPBV->E2_VALOR
			MsUnlock()
		END

		dbSelectArea("TMPBV")
		dbSkip()

	EndDo

	dbSelectArea("TMPBV")
	dbCloseArea("TMPBV")

	//Agora são separados os titulos para gravação das notas de faturamento.

	cQuery := "SELECT ZAB_PREFIX, ZAB_TITULO, ZAB_PARC, ZAB_TIPO, ZAB_FORNEC, ZAB_LOJA, ZAB_NOME, ZAB_VEND, ZAB_FATINI, ZAB_FATFIN FROM ZAB010 "
	cQuery += "WHERE D_E_L_E_T_ = '' AND ZAB_BAIXA BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "'  "

	tcQuery cQuery New Alias "TMPBV"

	If Eof()
		dbSelectArea("TMPBV" )
		dbCloseArea("TMPBV" )
	Endif

	dbSelectArea("TMPBV")
	dbGoTop()
	While !EOF()

		cQuery := "SELECT "
		cQuery += "E1_FILIAL,E1_VEND1,A3_NOME,A3_CGC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_PREFIXO,E1_TIPO,E1_NATUREZ,E1_NUM,E1_PARCELA,E1_VALOR,(E1_VALOR - E1_SALDO) AS VALORLIQUIDO,E1_COMIS1, (E1_VALOR - E1_SALDO) - ((E1_COMIS1 / 100) * ((E1_VALOR - E1_SALDO))) AS LIQUIDO, (E1_VALOR) - ((E1_COMIS1 / 100) * ((E1_VALOR))) AS LIQUIDO2,E1_EMISSAO,E1_VENCTO,E1_BAIXA,"
		cQuery += "ZU_DEFX1,ZU_ATEFX1,ZU_DEFX2,ZU_ATEFX2,ZU_DEFX3,ZU_ATEFX3,ZU_DEFX4,ZU_ATEFX4,ZU_DEFX5,ZU_ATEFX5,ZU_DEFX6,ZU_ATEFX6,ZU_DEFX7,ZU_ATEFX7,ZU_PERC1,ZU_PERC2,ZU_PERC3,ZU_PERC4,ZU_PERC5,ZU_PERC6,ZU_PERC7,ZU_ATEVALI,ZU_VALIDA,ZU_EXCECAO,ZU_DIAS,ED_DESCRIC,ED_TIPNAT,ED_TIPNAT, ED_TPGOV "
		cQuery += "FROM SE1010 "
		cQuery += "INNER JOIN SA3010 ON SE1010.E1_VEND1 = SA3010.A3_COD "
		cQuery += "INNER JOIN SA1010 ON SE1010.E1_CLIENTE = SA1010.A1_COD AND SE1010.E1_LOJA = SA1010.A1_LOJA "
		cQuery += "INNER JOIN SZU010 ON SE1010.E1_VEND1 = SZU010.ZU_VEND "
		cQuery += "INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "SE1010.E1_FILIAL = '01' AND "

		cQuery += "SE1010.E1_VEND1 = '" + ALLTRIM(TMPBV->ZAB_VEND) + "' AND SE1010.E1_VEND1 <> '' AND "

		cQuery += "SE1010.E1_EMISSAO BETWEEN '" + (TMPBV->ZAB_FATINI) + "' AND '" + (TMPBV->ZAB_FATFIN) + "'  AND "
		cQuery += "SE1010.E1_NATUREZ <> '1101006' AND "
		cQuery += "SA1010.D_E_L_E_T_ <> '*'  AND "
		cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SZU010.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY E1_VEND1,E1_NUM "

		tcQuery cQuery New Alias "TMPFAT"

		If Eof()
			dbSelectArea("TMPFAT" )
			dbCloseArea("TMPFAT" )
			lOk := .F.
		Endif

		If lOk
			dbSelectArea("TMPFAT")
			dbGoTop()
			While !EOF()

				If !EMPTY(ZU_PERC1)
					aAdd(aContrato,{TMPFAT->ZU_DEFX1,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX1,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC1}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC2)
					aAdd(aContrato,{TMPFAT->ZU_DEFX2,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX2,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC2}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC3)
					aAdd(aContrato,{TMPFAT->ZU_DEFX3,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX3,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC3}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC4)
					aAdd(aContrato,{TMPFAT->ZU_DEFX4,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX4,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC4}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC5)
					aAdd(aContrato,{TMPFAT->ZU_DEFX5,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX5,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC5}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC6)
					aAdd(aContrato,{TMPFAT->ZU_DEFX6,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX6,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC6}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC7)
					aAdd(aContrato,{TMPFAT->ZU_DEFX7,;  		// 1 - De Valor
						TMPFAT->ZU_ATEFX7,;	// 2 - Ate Valor
						TMPFAT->ZU_PERC7}) // 3 - Porcentagem
				EndIf

				If (!EMPTY(TMPFAT->E1_BAIXA) .AND. STOD(TMPFAT->E1_BAIXA) <= (STOD(TMPFAT->E1_VENCTO) + TMPFAT->ZU_DIAS)) .AND. TMPFAT->E1_NATUREZ <> "1101006" .OR. (TMPFAT->ZU_EXCECAO == "1" .AND. !EMPTY(TMPFAT->E1_BAIXA) .AND. TMPFAT->E1_NATUREZ <> "1101006")// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna

					IF nCont <= 14
						cNotas := cNotas + ALLTRIM(E1_NUM) + " "
					ELSEIF nCont <= 28
						cNotas1 := cNotas1 + ALLTRIM(E1_NUM) + " "
					ELSEIF nCont <= 42
						cNotas2 := cNotas2 + ALLTRIM(E1_NUM) + " "
					ELSEIF nCont <= 56
						cNotas3 := cNotas3 + ALLTRIM(E1_NUM) + " "
					ELSEIF nCont <= 70
						cNotas4 := cNotas4 + ALLTRIM(E1_NUM) + " "
					ENDIF

					nCont  += 1

					IF TMPFAT->ED_TPGOV == "1"
						nFatGov	+= TMPFAT->LIQUIDO
					ELSE
						nFatVar	+= TMPFAT->LIQUIDO
					ENDIF
					nFatTot	+= TMPFAT->LIQUIDO
				Endif

				DBSelectArea("TMPFAT")
				dbSkip()

			Enddo

			For I := 1 To Len(aContrato)

				If nFatTot >= aContrato[I][1] .AND. nFatTot <= aContrato[I][2]
					nRecLiq := nFatTot * (aContrato[I][3] / 100)
					nPerc   := aContrato[I][3]
					Exit
				EndIf

			Next I
			aContrato := {}

			dbSelectArea("TMPFAT")
			dbCloseArea("TMPFAT")

			dbSelectArea("ZAB")
			dBSetOrder(1)
			If dbSeek(xFilial("ZAB") + TMPBV->ZAB_PREFIX + TMPBV->ZAB_TITULO + TMPBV->ZAB_PARC + TMPBV->ZAB_TIPO + TMPBV->ZAB_FORNEC + TMPBV->ZAB_LOJA)
				Reclock("ZAB",.F.)
				ZAB->ZAB_NOTAS	:= cNotas
				ZAB->ZAB_NOTAS1 := cNotas1
				ZAB->ZAB_NOTAS2	:= cNotas2
				ZAB->ZAB_NOTAS3 := cNotas3
				ZAB->ZAB_NOTAS4 := cNotas4
				ZAB->ZAB_PERC 	:= nPerc
				ZAB->ZAB_VLNF 	:= nFatTot
				ZAB->ZAB_LOCAL 	:= (nFatVar * nPerc) / 100
				ZAB->ZAB_SPOT   := (nFatGov * nPerc) / 100
				ZAB->ZAB_VALOR	:= (nFatTot * nPerc) / 100
				MsUnlock()
			ENDIF

			cNotas		:= ""
			cNotas1		:= ""
			cNotas2  	:= ""
			cNotas3		:= ""
			cNotas4  	:= ""
			nFatGov		:= 0
			nFatVar		:= 0
			nFatTot		:= 0
			aContrato 	:= {}
			nPerc 		:= 0
			nCont		:= 0

		Endif

		dbSelectArea("TMPBV")
		dbSkip()

		lOk := .T.

	EndDo

	dbSelectArea("TMPBV" )
	dbCloseArea("TMPBV" )

	Close(oDlg)

RETURN
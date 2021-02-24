#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

//RAfael França - 25/09/2020 - Calculo de pagamento de BV com base no contas a pagar SE2 e folha de pagamento SRD

User Function AXZAB

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cCadastro := "Calculo BV"
	Private nOpca := 0
	Private aParam := {}

	Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","AxInclui",0,3},;
		{"Alterar","AxAltera",0,4},;
		{"Excluir","AxDeleta",0,5},;
		{"Importar","u_IMPORTSE2",0,5},;
		{"Relatorio","u_RGovVar()",0,2},;
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
	@ 010,200 Get dBaixa2 SIZE 40,020
	@ 035,020 Say "Do Faturamento:"
	@ 035,060 Get dFat1 SIZE 40,020
	@ 035,150 Say "Ate o Faturamento:"
	@ 035,200 Get dFat2 SIZE 40,020
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

	//Consulta no conta a pagar e gravação na tabela ZAB

	cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,E2_BAIXA,(E2_IRRF + E2_VALOR) AS E2_VALOR,E2_NATUREZ,E2_HIST,A2_CGC, E2_FATINI, E2_FATFIM "
	cQuery += ", CASE WHEN E2_BASECOF <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASECOF "
	cQuery += "WHEN E2_BASECSL > 0 AND E2_DESDOBR <> 'S' THEN E2_BASECSL "
	cQuery += "WHEN E2_BASEINS > 0 AND E2_DESDOBR <> 'S' THEN E2_BASEINS "
	cQuery += "WHEN E2_BASEIRF > 0 AND E2_DESDOBR <> 'S' THEN E2_BASEIRF "
	cQuery += "WHEN E2_BASEISS > 0 AND E2_DESDOBR <> 'S' THEN E2_BASEISS "
	cQuery += "WHEN E2_BASEPIS > 0 AND E2_DESDOBR <> 'S' THEN E2_BASEPIS "
	cQuery += "WHEN E2_VALOR   > 0 THEN E2_VALOR END AS VLBRUTO "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SED010 ON E2_NATUREZ = ED_CODIGO "
	cQuery += "INNER JOIN SA2010 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA "
	cQuery += "WHERE SED010.D_E_L_E_T_ = '' AND SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' "
	// Filtro os titulos das naturezas de pagamento de BV baixados dentro dos parametros
	cQuery += "AND ED_COMBV = '1' "
	cQuery += "AND E2_BAIXA BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "' "
	cQuery += "ORDER BY E2_NATUREZ "

	tcQuery cQuery New Alias "TMPBV"

	If Eof()
		MsgInfo("Não existem dados no contas a pagar do periodo informado!","Verifique")
		dbSelectArea("TMPBV")
		dbCloseArea()
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
			ZAB->ZAB_VLSE2	:= TMPBV->VLBRUTO
			ZAB->ZAB_VEND   := Posicione("SA3",3,xFilial("SA3")+TMPBV->A2_CGC,"A3_COD")
			IF ALLTRIM(TMPBV->E2_FORNECE) $ "000970/005191"
			ZAB->ZAB_VALOR	:= TMPBV->VLBRUTO
			ZAB->ZAB_SPOT	:= TMPBV->VLBRUTO
			ENDIF
			IF EMPTY(TMPBV->E2_FATINI) .AND. EMPTY(TMPBV->E2_FATFIM)
				ZAB->ZAB_FATINI := dFat1
				ZAB->ZAB_FATFIN := dFat2
			ELSE
				ZAB->ZAB_FATINI := STOD(TMPBV->E2_FATINI)
				ZAB->ZAB_FATFIN := STOD(TMPBV->E2_FATFIM)
			ENDIF
			MsUnlock()
		ELSE
			Reclock("ZAB",.F.)
			ZAB->ZAB_NOME	:= TMPBV->E2_NOMFOR
			ZAB->ZAB_EMISSA := STOD(TMPBV->E2_EMISSAO)
			ZAB->ZAB_VENCTO := STOD(TMPBV->E2_VENCREA)
			ZAB->ZAB_BAIXA 	:= STOD(TMPBV->E2_BAIXA)
			ZAB->ZAB_NATURE := TMPBV->E2_NATUREZ
			ZAB->ZAB_OBS    := TMPBV->E2_HIST
			ZAB->ZAB_VLSE2	:= TMPBV->VLBRUTO
			IF ALLTRIM(TMPBV->E2_FORNECE) $ "000970/005191"
			ZAB->ZAB_VALOR	:= TMPBV->VLBRUTO
			ZAB->ZAB_SPOT	:= TMPBV->VLBRUTO
			ENDIF
			MsUnlock()
		END

		dbSelectArea("TMPBV")
		dbSkip()

	EndDo

	dbSelectArea("TMPBV")
	dbCloseArea()

	//Consulta no movimento da folha SRD e gravação na tabela ZAB

	cQuery := "SELECT SUBSTRING(RD_DATPGT,1,6) AS DOCUMENTO, RD_MAT AS MATRICULA, RA_NOME AS NOME, RD_PD AS VERBA, RD_DATPGT AS DTPAG, RD_VALOR AS VALOR FROM SRD010 "
	cQuery += "INNER JOIN SRA010 ON RA_MAT = RD_MAT "
	cQuery += "WHERE SRD010.D_E_L_E_T_ = '' AND SRA010.D_E_L_E_T_ = '' "
	//Filtro os pagamentos na folha referentes a BV. Verba 135.
	cQuery += "AND RD_PD = '135' AND RD_DATPGT BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "' "
	cQuery += "ORDER BY RD_DATPGT "

	tcQuery cQuery New Alias "TMPBV"

	If Eof()
		MsgInfo("Não existem dados no folha do periodo informado!","Verifique")
		dbSelectArea("TMPBV")
		dbCloseArea()
Else

	Count To nRec

	dbSelectArea("TMPBV")
	dbGoTop()

	ProcRegua(nRec)

	While !EOF()

		IncProc()

		dbSelectArea("ZAB")
		dBSetOrder(1)
		If !dbSeek(xFilial("ZAB") + "FOL" + TMPBV->DOCUMENTO + "   " + "   " + TMPBV->MATRICULA + "  ") .AND. TMPBV->MATRICULA <> "000784"
			Reclock("ZAB",.T.)
			ZAB->ZAB_FILIAL := xFilial("ZAB")
			ZAB->ZAB_PREFIX := "FOL"
			ZAB->ZAB_TITULO := TMPBV->DOCUMENTO
			ZAB->ZAB_PARC   := "   "
			ZAB->ZAB_TIPO   := "   "
			ZAB->ZAB_FORNEC := TMPBV->MATRICULA
			ZAB->ZAB_LOJA 	:= "  "
			ZAB->ZAB_NOME	:= TMPBV->NOME
			ZAB->ZAB_EMISSA := STOD(TMPBV->DTPAG)
			ZAB->ZAB_VENCTO := STOD(TMPBV->DTPAG)
			ZAB->ZAB_BAIXA 	:= STOD(TMPBV->DTPAG)
			ZAB->ZAB_NATURE := "1204001"
			ZAB->ZAB_OBS    := "VALOR RECIBIDO POR MEIO DA FOLHA DE PAGAMENTO VERBA 135, DATA: " + DTOC(STOD(TMPBV->DTPAG))
			ZAB->ZAB_VLSE2	:= TMPBV->VALOR
			ZAB->ZAB_VALOR	:= TMPBV->VALOR
			IF ALLTRIM(TMPBV->MATRICULA) $ "000398/001599/001567"
			ZAB->ZAB_SPOT	:= TMPBV->VALOR
			ELSEIF ALLTRIM(TMPBV->MATRICULA) $ "001563/001284"
			ZAB->ZAB_LOCAL	:= TMPBV->VALOR
			ENDIF
			MsUnlock()
		ELSEIF dbSeek(xFilial("ZAB") + "FOL" + TMPBV->DOCUMENTO + "   " + "   " + TMPBV->MATRICULA + "  ") .AND. TMPBV->MATRICULA <> "000784"
			Reclock("ZAB",.F.)
			ZAB->ZAB_NOME	:= TMPBV->NOME
			ZAB->ZAB_EMISSA := STOD(TMPBV->DTPAG)
			ZAB->ZAB_VENCTO := STOD(TMPBV->DTPAG)
			ZAB->ZAB_BAIXA 	:= STOD(TMPBV->DTPAG)
			ZAB->ZAB_NATURE := "1204001"
			ZAB->ZAB_OBS    := "VALOR RECIBIDO POR FOLHA DE PAGAMENTO VERBA 135, DATA: " + DTOC(STOD(TMPBV->DTPAG))
			ZAB->ZAB_VLSE2	:= TMPBV->VALOR
			ZAB->ZAB_VALOR	:= TMPBV->VALOR
			IF ALLTRIM(TMPBV->MATRICULA) $ "000398/001599/001567/001627/001516"
			ZAB->ZAB_SPOT	:= TMPBV->VALOR
			ELSEIF ALLTRIM(TMPBV->MATRICULA) $ "001563/001284"
			ZAB->ZAB_LOCAL	:= TMPBV->VALOR
			ENDIF
			MsUnlock()
		END

		dbSelectArea("TMPBV")
		dbSkip()

	EndDo

	dbSelectArea("TMPBV")
	dbCloseArea()

	EndIF

	//Agora são separados os titulos para conferencia no contas a receber SE1 e gravação das notas de faturamento na ZAB.

	cQuery := "SELECT ZAB_PREFIX, ZAB_TITULO, ZAB_PARC, ZAB_TIPO, ZAB_FORNEC, ZAB_LOJA, ZAB_NOME, ZAB_VEND, ZAB_FATINI, ZAB_FATFIN FROM ZAB010 "
	cQuery += "WHERE D_E_L_E_T_ = '' AND ZAB_BAIXA BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "'  AND ZAB_LOJA <> '' "
	cQuery += "AND ZAB_FORNEC NOT IN ('000970','005191') "

	tcQuery cQuery New Alias "TMPBV"

	If Eof()
		dbSelectArea("TMPBV")
		dbCloseArea()
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
			dbSelectArea("TMPFAT")
			dbCloseArea()
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
			dbCloseArea()

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

	dbSelectArea("TMPBV")
	dbCloseArea()

	Close(oDlg)

RETURN

User Function RGOVVAR


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := ""
	Local titulo       	:= "Relatorio BV"
	Local nLin         	:= 80
	Local Cabec1		:= UPPER(" Empresa                         Nota        Emissão         Baixa                 Governo              Varejo                Total")
	Local Cabec2       	:= ""
	Local aOrd := {}

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite          := 132
	Private tamanho         := "M"
	Private nomeprog        := "RGOVVAR" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cPerg      := "RGOVVAR"
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RGOVVAR" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cQuery     := ""

	Private cString := "ZAB"

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("Operação cancelada pelo usuário")
		return
	ENDIF

	titulo := "Relatorio Período " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	cQuery2 := "SELECT ZAB_NATURE, ZAB_NOME, ZAB_TITULO, ZAB_EMISSA, ZAB_BAIXA, ZAB_SPOT, ZAB_LOCAL, ZAB_VALOR FROM ZAB010 "
	cQuery2 += "WHERE D_E_L_E_T_ = '' AND ZAB_BAIXA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery2 += "ORDER BY ZAB_NATURE, ZAB_TITULO "

	tcQuery cQuery2 New Alias "TMPZAB"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMPZAB")
		dbCloseArea()
		Return
	Endif

	If nLastKey == 27
		dbSelectArea("TMPZAB")
		dbCloseArea()
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		dbSelectArea("TMPZAB")
		dbCloseArea()
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Private nVlTotalV	 := 0
	Private nVlTotalG	 := 0
	Private cNaturez	 := ""
	Private nSubTotV	 := 0
	Private nSubTotG	 := 0
	Private lok		 := .T.
	Private cQuery2  := ""

	dbSelectArea("TMPZAB")

	SetRegua(RecCount())

	dbGoTop()
	While !EOF()


		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 50  // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF (cNaturez != TMPZAB->ZAB_NATURE)
			nLin 	:= nLin + 1
			@nLin, 001 PSAY TMPZAB->ZAB_NATURE
			@nLin, 010 PSAY ALLTRIM(Posicione("SED",1,xFilial("SED")+TMPZAB->ZAB_NATURE,"ED_DESCRIC"))
			nLin 	:= nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin 	:= nLin + 1 // Avanca a linha de impressao
		ENDIF

		@nLin, 001 PSAY SUBSTR(TMPZAB->ZAB_NOME,1,30)
		@nLin, 033 PSAY SUBSTR(TMPZAB->ZAB_TITULO,1,6)
		@nLin, 045 PSAY STOD(TMPZAB->ZAB_EMISSA)
		@nLin, 060 PSAY STOD(TMPZAB->ZAB_BAIXA)
		@nLin, 080 PSAY TMPZAB->ZAB_SPOT  PICTURE "@E 999,999.99"
		@nLin, 100 PSAY TMPZAB->ZAB_LOCAL PICTURE "@E 999,999.99"
		@nLin, 122 PSAY TMPZAB->ZAB_VALOR PICTURE "@E 999,999.99"

		nVlTotalV	 += TMPZAB->ZAB_LOCAL
		nVlTotalG	 += TMPZAB->ZAB_SPOT
		cNaturez	 := TMPZAB->ZAB_NATURE
		nSubTotV	 += TMPZAB->ZAB_LOCAL
		nSubTotG	 += TMPZAB->ZAB_SPOT

		dbSelectArea("TMPZAB")


		dbSkip() // Avanca o ponteiro do registro no arquivo

		IF (cNaturez != TMPZAB->ZAB_NATURE)
			nLin     := nLin + 1
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1
			@nLin, 001 PSAY "SUBTOTAL:"
			@nLin, 010 PSAY ALLTRIM(Posicione("SED",1,xFilial("SED")+cNaturez,"ED_DESCRIC"))
			@nLin, 080 PSAY nSubTotG  PICTURE "@E 999,999.99"
			@nLin, 100 PSAY nSubTotV  PICTURE "@E 999,999.99"
			@nLin, 122 PSAY nSubTotV + nSubTotG PICTURE "@E 999,999.99"
			nSubTotV	 := 0
			nSubTotG	 := 0
		ENDIF

		nLin := nLin + 1 // Avanca a linha de impressao

	EndDo

	nLin += 1
	@nLin, 001 PSAY "TOTAL:"
	@nLin, 080 PSAY nVlTotalG  PICTURE "@E 999,999.99"
	@nLin, 100 PSAY nVlTotalV  PICTURE "@E 999,999.99"
	@nLin, 122 PSAY nVlTotalG + nVlTotalV PICTURE "@E 999,999.99"

	nLin := nLin + 10

	@nLin, 030 PSAY "___________________          ___________________         ___________________"
	nLin += 1
	@nLin, 030 PSAY "   Alarico Neves               Elenn Caldeira               Pâmela Aguiar   "
	nLin += 1
	@nLin, 030 PSAY " Diretor Comercial          Gerente Adm/Financeiro         Ass. Financeiro  "

	dbSelectArea("TMPZAB")
	dbCloseArea()

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Da Baixa			","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Ate a Baixa		 	","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return
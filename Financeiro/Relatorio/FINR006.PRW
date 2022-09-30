#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_LIN_RED 07
#DEFINE REL_LIN_STD 14
#DEFINE REL_LIN_TOT 21
#DEFINE REL_START  65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 700 //Retrato
#DEFINE REL_RIGHT 580
#DEFINE REL_LEFT 10

// Rafael França - 16/03/21 - Relatório de bonIficação de volume (BV) BSB e comissão de agência

User Function FINR006()

	Private _cPerg    	:= "FINR006A"
	Private oPrint
	Private cSubTitle 	:= ""
	Private nPag      	:= 0
	Private nLin      	:= 0
	Private oFonte    	:= u_xFonte(10,,,,"Arial")
	Private oFonteN   	:= u_xFonte(10,.T.,,,"Arial")
	Private oFonte11   	:= u_xFonte(11,,,,"Arial")
	Private oFonte11N  	:= u_xFonte(11,.T.,,,"Arial")

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )

	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

// fProcPdf - Imprime relatório em PDF
Static Function fProcPdf()

	Local nTotReg := 0
	Local cDir    := Alltrim(MV_PAR12) + "\"
	Local cAssin1 := ""
	Local cAssin2 := ""
	Local cAssin3 := ""
	Local cAssin4 := ""
	Local cCargo1 := ""
	Local cCargo2 := ""
	Local cCargo3 := ""
	Local cCargo4 := ""
	Local I       := 0

	Private lOk			:= .T.
	Private lVend		:= .T.
	Private cAlias     	:= GetNextAlias()
	Private cAlias1    	:= GetNextAlias()
	Private cAlias2    	:= GetNextAlias()
	Private cVend		:= ""
	Private cNomeVend	:= ""
	Private cMesFat		:= ""
	Private aContrato	:= {}
	Private aRegistro	:= {}
	Private nPos		:= 0
	Private cFileName 	:= ""
	Private lPagar		:= .F.
	Private nFatAge		:= 0
	Private nBVAge		:= 0
	Private nTotFat1	:= 0
	Private nTotFat2	:= 0
	Private nTotBV1		:= 0
	Private nTotBV2		:= 0
	Private nMesFat		:= 0
	Private nMesBV		:= 0
	Private dIniBxA		:= DTOS(FirstDate(MonthSub(MV_PAR06,1)))
	Private dFimBxA		:= DTOS(LastDate(MonthSub(MV_PAR07,1)))
	Private cFiltro1	:= ""
	Private cFiltro2	:= ""
	Private cFiltro3	:= ""
	Private cFiltro4	:= "% (E1_NUM IN  " + FormatIn(ALLTRIM(MV_PAR16),"/") + " )" + "  %"
	Private cFiltro5 	:= "% (E1_NUM IN  " + FormatIn(ALLTRIM(MV_PAR17),"/") + " )" + "  %"
	Private cApura		:= SUBSTRING(DTOC(MV_PAR18),1,5) + "-" + SUBSTRING(DTOC(MV_PAR19),1,5)



	// Query para buscar as informações
	cFiltro1	:= "% (E1_EMISSAO BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"' AND E1_BAIXA BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' AND E1_VEND1 BETWEEN '"+(MV_PAR02)+"' AND '"+(MV_PAR03)+"' AND E1_NUM NOT IN " + FormatIn(ALLTRIM(MV_PAR14),"/") + ")" +  "  %"

	// Busca os registros a serem impressos no relatório - BonIficação de volume
	BeginSql Alias cAlias

		SELECT E1_FILIAL, E1_VEND1, A3_NOME, A3_CGC, E1_CLIENTE, E1_LOJA, A1_NOME, E1_PREFIXO, E1_TIPO,
		E1_NATUREZ, E1_NUM, E1_PARCELA, E1_VALOR, E1_EMISSAO, E1_VENCTO, E1_BAIXA, ED_DESCRIC, ED_TIPNAT, SUBSTRING(E1_EMISSAO, 1, 6) AS MESFAT,
		(E1_VALOR - E1_SALDO) AS VALORLIQUIDO, E1_COMIS1,
		(E1_VALOR - E1_SALDO) - ((E1_COMIS1 / 100) * ((E1_VALOR - E1_SALDO))) AS LIQUIDO,
		(E1_VALOR) - ((E1_COMIS1 / 100) * ((E1_VALOR))) AS LIQUIDO2,
		ZU_DEFX1, ZU_ATEFX1, ZU_PERC1, ZU_DEFX2, ZU_ATEFX2, ZU_PERC2, ZU_DEFX3, ZU_ATEFX3, ZU_PERC3,
		ZU_DEFX4, ZU_ATEFX4, ZU_PERC4, ZU_DEFX5, ZU_ATEFX5, ZU_PERC5, ZU_DEFX6, ZU_ATEFX6, ZU_PERC6,
		ZU_DEFX7, ZU_ATEFX7, ZU_PERC7, ZU_ATEVALI, ZU_VALIDA, ZU_EXCECAO, ZU_DIAS
		FROM %table:SE1%
		INNER JOIN %table:SA3% // Tabela de Vendedor/Agência - Faço uma consulta do seu CNPJ
		ON E1_VEND1 = A3_COD
		INNER JOIN SA1010 // Tabela de Cliente - Busco dados do cliente
		ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ <> '*'
		INNER JOIN SZU010 // Tabela de Contrato Agências - VerIficos as regras para contrato
		ON E1_VEND1 = ZU_VEND AND SZU010.D_E_L_E_T_ <> '*' AND E1_EMISSAO BETWEEN ZU_VALIDA AND ZU_ATEVALI // Valido a emissão dentro do periodo do contrato
		INNER JOIN %table:SED% // Tabela de Natureza - Busco dados da natureza
		ON E1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ <> '*'
		WHERE E1_FILIAL = '01' AND %table:SE1%.D_E_L_E_T_ <> '*' AND %table:SE1%.E1_NATUREZ <> '1101006'
		AND %exp:cFiltro1%
		OR %exp:cFiltro4%
		AND ( E1_CLIENTE <> '001689' OR E1_VEND1 <> '000219' )
		ORDER BY E1_VEND1, MESFAT, E1_CLIENTE, E1_LOJA, E1_NUM, E1_PARCELA, E1_VENCTO

	EndSql

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verIficar os parâmetros","FINR006")
		(cAlias)->(DbCloseArea())
		Return
	EndIf

	(cAlias)->(DbGoTop())

	cFileName 	:= "RELBV_FINR006"
	oPrint:= FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetPortrait()//Retrato
	//	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	ImpProxPag()//Monta cabeçario da primeira e proxima pagina

	nLin += 5

	DBSelectArea(cAlias)
	DBGotop()
	While !(cAlias)->(EOF())
		//VerIfica se o titulo cumpre as regras determinadas para o pagamento da comissão
		If (!EMPTY((cAlias)->E1_BAIXA) .AND. STOD((cAlias)->E1_BAIXA) <= (STOD((cAlias)->E1_VENCTO) + (cAlias)->ZU_DIAS)) .OR. ((cAlias)->ZU_EXCECAO == "1" .AND. !EMPTY((cAlias)->E1_BAIXA) .AND. (cAlias)->E1_NATUREZ <> "1101006") .OR. MV_PAR13 = 1 // Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna

			//VerIfica os totais por vendedor para ver qual será o percentual de faixa de pagamento
			If cVend != (cAlias)->E1_VEND1 .OR. cMesFat != (cAlias)->MESFAT
				aAdd(aRegistro,{(cAlias)->E1_VEND1,(cAlias)->MESFAT,(cAlias)->LIQUIDO})
			Else
				nPos := aScan(aRegistro, { |x| x[1] == (cAlias)->E1_VEND1 .AND. x[2] == (cAlias)->MESFAT})
				aRegistro[nPos][3] += (cAlias)->LIQUIDO
			EndIf

			cMesFat := (cAlias)->MESFAT
			cVend 	:= (cAlias)->E1_VEND1

		EndIf

		dbSkip() // Avanca o ponteiro do registro no arquivo

	EndDo

	DBSelectArea(cAlias)
	DBGotop()
	While !(cAlias)->(EOF())

		//Coloca as faixas de comissões dentro do vetor a contrato
		If !EMPTY(ZU_PERC1)
			aAdd(aContrato,{(cAlias)->ZU_DEFX1,(cAlias)->ZU_ATEFX1,(cAlias)->ZU_PERC1})
		EndIf

		If !EMPTY(ZU_PERC2)
			aAdd(aContrato,{(cAlias)->ZU_DEFX2,(cAlias)->ZU_ATEFX2,(cAlias)->ZU_PERC2})
		EndIf

		If !EMPTY(ZU_PERC3)
			aAdd(aContrato,{(cAlias)->ZU_DEFX3,(cAlias)->ZU_ATEFX3,(cAlias)->ZU_PERC3})
		EndIf

		If !EMPTY(ZU_PERC4)
			aAdd(aContrato,{(cAlias)->ZU_DEFX4,(cAlias)->ZU_ATEFX4,(cAlias)->ZU_PERC4})
		EndIf

		If !EMPTY(ZU_PERC5)
			aAdd(aContrato,{(cAlias)->ZU_DEFX5,(cAlias)->ZU_ATEFX5,(cAlias)->ZU_PERC5})
		EndIf

		If !EMPTY(ZU_PERC6)
			aAdd(aContrato,{(cAlias)->ZU_DEFX6,(cAlias)->ZU_ATEFX6,(cAlias)->ZU_PERC6})
		EndIf

		If !EMPTY(ZU_PERC7)
			aAdd(aContrato,{(cAlias)->ZU_DEFX7,(cAlias)->ZU_ATEFX7,(cAlias)->ZU_PERC7})
		EndIf

		//VerIfica se o titulo cumpre as regras determinadas para o pagamento da comissão
		If (!EMPTY((cAlias)->E1_BAIXA) .AND. STOD((cAlias)->E1_BAIXA) <= (STOD((cAlias)->E1_VENCTO) + (cAlias)->ZU_DIAS)) .AND. (cAlias)->E1_NATUREZ <> "1101006" .OR. ((cAlias)->ZU_EXCECAO == "1" .AND. !EMPTY((cAlias)->E1_BAIXA) .AND. (cAlias)->E1_NATUREZ <> "1101006") .OR. MV_PAR13 = 1 // Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna
			lPagar := .T.
		Else
			lPagar := .F.
		EndIf

		If lPagar //VerfIfica a faixa de comissão de acordo com o faturamento do vendedor/agência

			nPerc 	:= 0
			nPos 	:= aScan(aRegistro, { |x| x[1] == (cAlias)->E1_VEND1 .AND. x[2] == (cAlias)->MESFAT})
			If nPos > 0
				For I := 1 To Len(aContrato)
					If aRegistro[nPos][3] >= aContrato[I][1] .AND. aRegistro[nPos][3] <= aContrato[I][2]
						//nRecLiq :=	aRegistro[nPos][2] * (aContrato[I][3] / 100) // Valor Liquido a Receber
						nPerc := aContrato[I][3]
						Exit
					EndIf
				Next I
			EndIf

		EndIf

		If (cAlias)->LIQUIDO > 0 .AND. lPagar .AND. nPerc > 0

			//VerIfica se por causa dos dias de prazo (ZU_DIAS) para pagamento atrasado a agencia deixou de receber algo no mês anterior
			If (STOD((cAlias)->E1_BAIXA) > STOD((cAlias)->E1_VENCTO)) .AND. (STOD((cAlias)->E1_BAIXA)) <= (STOD((cAlias)->E1_VENCTO) + (cAlias)->ZU_DIAS) .AND. lVend

				// Query para buscar as informações
				cFiltro2	:= "% AND (SUBSTRING(E1_EMISSAO,1,6) = '"+(cAlias)->MESFAT+"' AND E1_BAIXA BETWEEN '"+dIniBxA+"' AND '"+dFimBxA+"' AND E1_VEND1 = '"+(cAlias)->E1_VEND1+"' OR E1_NUM IN " + FormatIn(ALLTRIM(MV_PAR14),"/") + " %"
				//FatMesAnt()

			EndIf //Fim do controle do mês anterior

			If nLin > REL_END //Vericica a necessidade de pular página
				u_PXRODAPE(@oPrint,"FINR006.PRW","")
				oPrint:EndPage()
				ImpProxPag()//Monta cabeçario da proxima página
			EndIf

			If Empty(SUBSTR((cAlias)->A1_NOME,35,1))
				oPrint:Say(nLin,020, SUBSTRING((cAlias)->A1_NOME,1,35)	    	  	,oFonte)
			Else
				oPrint:Say(nLin,020, SUBSTRING((cAlias)->A1_NOME,1,34) + "."		,oFonte)
			EndIf

			oPrint:Say(nLin,200, ALLTRIM((cAlias)->E1_NUM) + IIf(EMPTY((cAlias)->E1_PARCELA),"","/" + (cAlias)->E1_PARCELA)	,oFonte)
			oPrint:Say(nLin,260, DTOC(STOD((cAlias)->E1_EMISSAO))										,oFonte)
			oPrint:Say(nLin,320, DTOC(STOD((cAlias)->E1_BAIXA))										,oFonte)
			oPrint:Say(nLin,395, PADL(transform((cAlias)->LIQUIDO,"@E 999,999,999.99"),14) 			,oFonte)
			oPrint:Say(nLin,475, PADL(transform(nPerc,"@E 99.99%"),6)									,oFonte)
			oPrint:Say(nLin,530, PADL(transform((cAlias)->LIQUIDO*nPerc/100,"@E 999,999,999.99"),14)	,oFonte)

			nLin += REL_LIN_STD

			If lPagar .AND. nPerc > 0
				nMesFat		+= (cAlias)->LIQUIDO
				nMesBV		+= (cAlias)->LIQUIDO * (nPerc/100)
				nFatAge 	+= (cAlias)->LIQUIDO
				nBVAge 		+= (cAlias)->LIQUIDO * (nPerc/100)
				nTotFat1	+= (cAlias)->LIQUIDO
				nTotBV1		+= (cAlias)->LIQUIDO * (nPerc/100)
			EndIf

		EndIf

		cVend 		:= (cAlias)->E1_VEND1
		cNomeVend	:= (cAlias)->A3_NOME
		cMesFat		:= (cAlias)->MESFAT
		aContrato 	:= {} //Zera Vetor

		DBSelectArea(cAlias)
		dbSkip() // Avanca o ponteiro do registro no arquivo

		If cMesFat != (cAlias)->MESFAT .AND. nPerc > 0 .AND. cVend == (cAlias)->E1_VEND1

			oPrint:Say(nLin,270, SUBSTRING(cMesFat,5,2)+"/"+SUBSTRING(cMesFat,3,2)		,oFonteN)
			oPrint:Say(nLin,395, PADL(transform(nMesFat,"@E 999,999,999.99"),14) 		,oFonteN)
			oPrint:Say(nLin,475, PADL(transform(nPerc,"@E 99.99%"),6)					,oFonteN)
			oPrint:Say(nLin,530, PADL(transform(nMesBV,"@E 999,999,999.99"),14)			,oFonteN)

			nMesFat	:= 0
			nMesBV	:= 0
			nLin 	+= REL_LIN_STD

		EndIf

		If cVend != (cAlias)->E1_VEND1 .AND. nPerc > 0

			If Empty(SUBSTR(cNomeVend,50,1))
				oPrint:Say(nLin,020,"AGÊNCIA: " + cVend + " - " + SUBSTRING(cNomeVend,1,50)	   	,oFonteN)
			Else
				oPrint:Say(nLin,020,"AGÊNCIA: " + cVend + " - " + SUBSTRING(cNomeVend,1,49) + "."	,oFonteN)
			EndIf
			oPrint:Say(nLin,395, PADL(transform(nFatAge,"@E 999,999,999.99"),14) 		,oFonteN)
			//oPrint:Say(nLin,475, PADL(transform(nPerc,"@E 99.99%"),6)				,oFonteN)
			oPrint:Say(nLin,530, PADL(transform(nBVAge,"@E 999,999,999.99"),14)		,oFonteN)
			nLin 	+= REL_LIN_RED
			oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")

			nMesFat	:= 0
			nMesBV	:= 0
			nFatAge := 0
			nBVAge 	:= 0
			nPerc 	:= 0
			lVend	:= .T.
			nLin 	+= REL_LIN_TOT

		EndIf

	EndDo

	(cAlias)->(DbCloseArea())

	//Impressão do total de todas as praças
	nLin    -= REL_LIN_RED
	oPrint:Say(nLin,020,"TOTAL BONIFICAÇÃO VOLUME: "							,oFonte11N)
	oPrint:Say(nLin,395, PADL(Transform(nTotFat1, "@E 999,999,999.99"),14)		,oFonte11N)
	oPrint:Say(nLin,530, PADL(transform(nTotBV1,"@E 999,999,999.99"),14) 		,oFonte11N)
	nLin 	+= (REL_LIN_TOT * 2)

	nFatAge  := 0
	nBVAge 	 := 0
	nPerc 	 := 0
	cFiltro3 := "% (E1_EMISSAO BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"' AND E1_BAIXA BETWEEN '"+DTOS(MV_PAR06)+"' AND '"+DTOS(MV_PAR07)+"' AND E1_VEND1 BETWEEN '"+(MV_PAR02)+"' AND '"+(MV_PAR03)+"' AND E1_NUM NOT IN " + FormatIn(ALLTRIM(MV_PAR15),"/") + " )" + "  %"

	// Busca os registros a serem impressos no relatório - Comissão de Agência
	BeginSql Alias cAlias1

		SELECT SUBSTRING(E1_EMISSAO, 1, 6) AS MESFAT, E1_VEND1 AS AGENCIA, A3_NOME AS NOMEVEND, E1_NUM AS NOTA,
		E1_CLIENTE AS CLIENTE, E1_NOMCLI AS NOMECLI, E1_COMIS1 AS PERC, E1_EMISSAO AS EMISSAO, E1_VENCREA AS VENCIMENTO,
		(E1_VALOR + E1_MULTA) AS VALOR, ((E1_VALOR + E1_MULTA) * E1_COMIS1 / 100) AS COMISSAO,
		E1_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO, E1_BAIXA AS BAIXA
		FROM %table:SE1%
		INNER JOIN %table:SA3% ON E1_VEND1 = A3_COD AND %table:SA3%.D_E_L_E_T_ = ''
		INNER JOIN %table:SED% ON E1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ = ''
		WHERE %table:SE1%.D_E_L_E_T_ = '' AND E1_COMIS1 > 0
		AND %exp:cFiltro3%  // Coloque sua exceção aqui
		OR %exp:cFiltro5%

		ORDER BY A3_COD, MESFAT

	EndSql //FINALIZO A MINHA QUERY

	oPrint:Say(nLin,020, "COMISSÃO DE AGÊNCIA: "						,oFonte11N)
	nLin 	+= REL_LIN_RED
	oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
	nLin 	+= REL_LIN_STD

			DBSelectArea(cAlias1)
			DBGotop()
			While !(cAlias1)->(EOF())

			If nLin > REL_END
			u_PXRODAPE(@oPrint, "FINR006.PRW", "")
			oPrint:EndPage()
			ImpProxPag() //Monta cabeçario da proxima pagina
			nLin 	+= REL_LIN_RED
			EndIf

			If Empty(SUBSTR((cAlias1)->NOMECLI, 35, 1))
			oPrint:Say(nLin,020,SUBSTRING((cAlias1)->NOMECLI, 1, 35),oFonte)
			Else
			oPrint:Say(nLin,020,SUBSTRING((cAlias1)->NOMECLI, 1, 34) + ".",oFonte)
			EndIf

			oPrint:Say(nLin,200,ALLTRIM((cAlias1)->NOTA), oFonte)
			oPrint:Say(nLin,260,DTOC(STOD((cAlias1)->EMISSAO)), oFonte)
			oPrint:Say(nLin,320,DTOC(STOD((cAlias1)->BAIXA)), oFonte)
			oPrint:Say(nLin,395,PADL(transform((cAlias1)->VALOR, "@E 999,999,999.99"),14),oFonte)
			oPrint:Say(nLin,475,PADL(transform((cAlias1)->PERC, "@E 99.99%"), 6),oFonte)
			oPrint:Say(nLin,530,PADL(transform((cAlias1)->COMISSAO, "@E 999,999,999.99"),14),oFonte)

			nLin += REL_LIN_STD

			cVend 		:= (cAlias1)->AGENCIA
			cNomeVend 	:= (cAlias1)->NOMEVEND
			nFatAge 	+= (cAlias1)->VALOR
			nBVAge 		+= (cAlias1)->COMISSAO
			nPerc 		:= (cAlias1)->PERC
			nTotFat2 	+= (cAlias1)->VALOR
			nTotBV2 	+= (cAlias1)->COMISSAO

			DBSelectArea(cAlias1)
			dbSkip() // Avanca o ponteiro do registro no arquivo

			If cVend != (cAlias1)->AGENCIA
			If Empty(SUBSTR(cNomeVend, 50, 1))
			oPrint:Say(nLin,020,"AGÊNCIA: " + cVend + " - " + SUBSTRING(cNomeVend, 1, 50),oFonteN)
			Else
			oPrint:Say(nLin,020,"AGÊNCIA: " + cVend + " - " + SUBSTRING(cNomeVend, 1, 49) + ".",oFonteN)
			EndIf

			oPrint:Say(nLin,395,PADL(transform(nFatAge, "@E 999,999,999.99"), 14),oFonteN)
			oPrint:Say(nLin,475,PADL(transform(nPerc, "@E 99.99%"), 6),oFonteN)
			oPrint:Say(nLin,530,PADL(transform(nBVAge, "@E 999,999,999.99"), 14),oFonteN)

			nLin += REL_LIN_RED
			oPrint:Line(nLin, REL_LEFT, nLin, REL_RIGHT, CLR_HGRAY, "-9")
			nLin += REL_LIN_TOT

			nFatAge := 0
			nBVAge := 0
			nPerc := 0

			EndIf

			EndDo

			nLin -= REL_LIN_RED

			oPrint:Say(nLin,020, "TOTAL COMISSÃO DE AGÊNCIA: "						,oFonte11N)
			oPrint:Say(nLin,395,PADL(Transform(nTotFat2, "@E 999,999,999.99"), 14)	,oFonte11N)
			oPrint:Say(nLin,530,PADL(transform(nTotBV2, "@E 999,999,999.99"), 14)	,oFonte11N)

			nLin += REL_LIN_STD
			oPrint:Say(nLin,020, "TOTAL: "														,oFonte11N)
			oPrint:Say(nLin,395,PADL(Transform(nTotFat1 + nTotFat2, "@E 999,999,999.99"), 14)	,oFonte11N)
			oPrint:Say(nLin,530,PADL(transform(nTotBV1 + nTotBV2, "@E 999,999,999.99"), 14)		,oFonte11N)
			nLin += (REL_LIN_TOT * 3)

			DBSelectArea(cAlias1)
			DBCloseArea() //Imprime linha das assinaturas

			If !Empty(MV_PAR08).and.PswSeek(MV_PAR08,.T.)
			oPrint:Say(nLin, 024, "_________________________", oFonteN)
			aUsuario := PswRet() // Retorna vetor com informações do usuário
			cAssin1  := Alltrim(aUsuario[1][4])
			cCargo1  := Alltrim(aUsuario[1][13])
			EndIf

			If !Empty(MV_PAR09).and.PswSeek(MV_PAR09,.T.)
			oPrint:Say(nLin, 175, "_________________________", oFonteN)
			aUsuario := PswRet() // Retorna vetor com informações do usuário
			cAssin2  := Alltrim(aUsuario[1][4])
			cCargo2  := Alltrim(aUsuario[1][13])
			EndIf

			If !Empty(MV_PAR10).and.PswSeek(MV_PAR10,.T.)
			oPrint:Say(nLin, 318, "_________________________", oFonteN)
			aUsuario := PswRet() // Retorna vetor com informações do usuário
			cAssin3  := Alltrim(aUsuario[1][4])
			cCargo3  := Alltrim(aUsuario[1][13])
			EndIf

			If !Empty(MV_PAR11).and.PswSeek(MV_PAR11,.T.)
			oPrint:Say(nLin, 470, "_________________________", oFonteN)
			aUsuario := PswRet() // Retorna vetor com informações do usuário
			cAssin4  := Alltrim(aUsuario[1][4])
			cCargo4  := Alltrim(aUsuario[1][13])
			EndIf

			nLin += REL_LIN_STD //Imprime o nome das assinaturas

			If !Empty(cAssin1)
			oPrint:Say(nLin, 024, PADC(cAssin1, 40), oFonte)
			EndIf

			If !Empty(cAssin2)
			oPrint:Say(nLin, 175, PADC(cAssin2, 40), oFonte)
			EndIf

			If !Empty(cAssin3)
			oPrint:Say(nLin, 318, PADC(cAssin3, 40), oFonte)
			EndIf

			If !Empty(cAssin4)
			oPrint:Say(nLin, 470, PADC(cAssin4, 40), oFonte)
			EndIf

			nLin += REL_LIN_STD

			If !Empty(cCargo1)
			oPrint:Say(nLin, 024, PADC(cCargo1, 33), oFonteN)
			EndIf

			If !Empty(cCargo2)
			oPrint:Say(nLin, 175, PADC(cCargo2, 33), oFonteN)
			EndIf

			If !Empty(cCargo3)
			oPrint:Say(nLin, 318, PADC(cCargo3, 33), oFonteN)
			EndIf

			If !Empty(cCargo4)
			oPrint:Say(nLin, 470, PADC(cCargo4, 33), oFonteN)
			EndIf

			u_PXRODAPE(@oPrint, "FINR006.PRW", "")
			oPrint:EndPage()
			oPrint:Preview()
			Return

			// Query para buscar as informações
			// Busca os registros a serem impressos no relatório
			Static Function FatMesAnt() // Busca os registros a serem impressos no relatório - BonIficação de volume - Mês anterior

		BeginSql Alias cAlias2
		SELECT E1_FILIAL, E1_VEND1, A3_NOME, A3_CGC, E1_CLIENTE, E1_LOJA, A1_NOME, E1_PREFIXO, E1_TIPO, E1_NATUREZ,
		E1_NUM, E1_PARCELA, E1_VALOR, E1_EMISSAO, E1_VENCTO, E1_BAIXA, ED_DESCRIC, ED_TIPNAT,
		SUBSTRING(E1_EMISSAO, 1, 6) AS MESFAT, (E1_VALOR - E1_SALDO) AS VALORLIQUIDO,
		E1_COMIS1, (E1_VALOR - E1_SALDO) - ((E1_COMIS1 / 100) * ((E1_VALOR - E1_SALDO))) AS LIQUIDO,
		(E1_VALOR) - ((E1_COMIS1 / 100) * ((E1_VALOR))) AS LIQUIDO2
		FROM %table:SE1%
		INNER JOIN %table:SA3% // Tabela de Vendedor/Agência - Faço uma consulta do seu CNPJ
		ON E1_VEND1 = A3_COD
		INNER JOIN SA1010 // Tabela de Cliente - Busco dados do cliente
		ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ <> '*'
		INNER JOIN SZU010 // Tabela de Contrato Agências - VerIficos as regras para contrato
		ON E1_VEND1 = ZU_VEND AND SZU010.D_E_L_E_T_ <> '*' AND E1_EMISSAO BETWEEN ZU_VALIDA AND ZU_ATEVALI // Valido a emissão dentro do periodo do contrato
		INNER JOIN %table:SED% // Tabela de Natureza - Busco dados da natureza
		ON E1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ <> '*'
		WHERE E1_FILIAL = '01' AND %table:SE1%.D_E_L_E_T_ <> '*' AND E1_NATUREZ <> '1101006'
		AND %exp:cFiltro1%
		OR %exp:cFiltro4%
		AND (E1_CLIENTE <> '001689' OR E1_VEND1 <> '000219')
		ORDER BY E1_VEND1, MESFAT, E1_CLIENTE, E1_LOJA, E1_NUM, E1_PARCELA, E1_VENCTO
		EndSql

		DBSelectArea(cAlias2)
		DBGotop()
		While !(cAlias2)->(EOF())

		If nLin > REL_END //Vericica a necessidade de pular página
			u_PXRODAPE(@oPrint,"FINR006.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima página
		EndIf

		If STOD((cAlias2)->E1_BAIXA) <= STOD((cAlias2)->E1_VENCTO)

			If Empty(SUBSTR((cAlias2)->A1_NOME,35,1))
				oPrint:Say(nLin,020, SUBSTRING((cAlias2)->A1_NOME,1,35)	    	,oFonte)
			Else
				oPrint:Say(nLin,020, SUBSTRING((cAlias2)->A1_NOME,1,34) + "."		,oFonte)
			EndIf

			oPrint:Say(nLin,200, ALLTRIM((cAlias2)->E1_NUM) + IIf(EMPTY((cAlias)->E1_PARCELA),"","/" + (cAlias)->E1_PARCELA)	,oFonte)
			oPrint:Say(nLin,260, DTOC(STOD((cAlias2)->E1_EMISSAO))										,oFonte)
			oPrint:Say(nLin,320, DTOC(STOD((cAlias2)->E1_BAIXA))										,oFonte)
			oPrint:Say(nLin,395, PADL(transform((cAlias2)->LIQUIDO,"@E 999,999,999.99"),14) 			,oFonte)
			oPrint:Say(nLin,475, PADL(transform(nPerc,"@E 99.99%"),6)									,oFonte)
			oPrint:Say(nLin,530, PADL(transform((cAlias2)->LIQUIDO*nPerc/100,"@E 999,999,999.99"),14)	,oFonte)

			nLin += REL_LIN_STD

			If lPagar .AND. nPerc > 0
				nMesFat		+= (cAlias2)->LIQUIDO
				nMesBV		+= (cAlias2)->LIQUIDO * (nPerc/100)
				nFatAge 	+= (cAlias2)->LIQUIDO
				nBVAge 		+= (cAlias2)->LIQUIDO * (nPerc/100)
				nTotFat1	+= (cAlias2)->LIQUIDO
				nTotBV1		+= (cAlias2)->LIQUIDO * (nPerc/100)
			EndIf

		EndIf

		DBSelectArea(cAlias2)
		dbSkip() // Avanca o ponteiro do registro no arquivo

	EndDo

	DBSelectArea(cAlias2)
	DBCloseArea()

	lVend 	:= .F.

Return

// ImpProxPag - Imprime cabeçalho da próxima página
Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "PAGAMENTO DIA " + DTOC(MV_PAR01) + " -> APURAÇÃO(" + cApura + ")"
	nLin := u_PXCABECA(@oPrint, "BONIFICAÇÃO DE VOLUME BSB E COMISSÃO DE AGÊNCIA", cSubTitle  , nPag)

	oPrint:Say(nLin,020, "CLIENTE"		,oFonteN)
	oPrint:Say(nLin,200, "NF CLIENTE"	,oFonteN)
	oPrint:Say(nLin,260, "EMISSÃO"		,oFonteN)
	oPrint:Say(nLin,320, "RECEBIMENTO"	,oFonteN)
	oPrint:Say(nLin,400, "VALOR NF"		,oFonteN)
	oPrint:Say(nLin,470, "% PERC."		,oFonteN)
	oPrint:Say(nLin,535, "VALOR BV"		,oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_LIN_STD

Return

//Validação e criação do cPerg (SX1 - Perguntas)
Static Function ValidPerg(cPerg)

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10)

	//          Grupo Ordem Desc Por               Desc Espa   Desc Ingl  Variavel  Tipo  Tamanho  Decimal  PreSel  GSC  Valid   Var01       Def01     DefSpa01  DefEng01  CNT01  Var02  Def02     DefSpa02  DefEng02  CNT02  Var03  Def03  DefEsp03  DefEng03  CNT03     Var04  Def04  DefEsp04  DefEng04  CNT04  Var05  Def05  DefEsp05  DefEng05  CNT05  F3        PYME  GRPSXG   HELP  PICTURE  IDFIL
	AADD(aRegs,{cPerg,"01","Dia do Pagamento:	","","","mv_ch01","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Vendedor:			","","","mv_ch02","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"03","Vendedor:			","","","mv_ch03","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"04","De  Emissão:		","","","mv_ch04","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Ate Emissão:		","","","mv_ch05","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","De  Baixa:			","","","mv_ch06","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Ate Baixa:			","","","mv_ch07","D",08,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Assinatura 1:		","","","mv_ch08","C",06,00,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"09","Assinatura 2:		","","","mv_ch09","C",06,00,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"10","Assinatura 3:		","","","mv_ch10","C",06,00,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"11","Assinatura 4:		","","","mv_ch11","C",06,00,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"12","Destino do(s) Arq.: ","","","mv_ch12","C",99,00,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Imprime Não Pagos:	","","","mv_ch13","N",01,00,0,"C","","mv_par13","Sim","","","","","Não","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","Exceção NF BV: 		","","","mv_ch14","C",35,00,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","SE1"})
	AADD(aRegs,{cPerg,"15","Exceção NF Agência: ","","","mv_ch15","C",35,00,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","SE1"})
	AADD(aRegs,{cPerg,"16","Incluir NF BV: 		","","","mv_ch16","C",35,00,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","SE1"})
	AADD(aRegs,{cPerg,"17","Incluir NF Agência: ","","","mv_ch17","C",35,00,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","SE1"})
	AADD(aRegs,{cPerg,"18","Apuração de:		","","","mv_ch18","D",08,00,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"19","Até:				","","","mv_ch19","D",08,00,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})


	For i:=1 to Len(aRegs)
		If !dbSeek(PADR(cPerg,10)+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	RestArea(aArea)

Return()
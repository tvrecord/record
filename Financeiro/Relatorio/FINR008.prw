#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_LIN_RED 07
#DEFINE REL_LIN_STD 13
#DEFINE REL_LIN_TOT 20
#DEFINE REL_START  	65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 	700 //Retrato
//#DEFINE REL_RIGHT 820 //Paisagem
#DEFINE REL_RIGHT 	580 //Retrato
#DEFINE REL_LEFT 	10
#DEFINE PAD_LEFT    0
#DEFINE PAD_RIGHT   1
#DEFINE PAD_CENTER  2

// Rafael França - 01/03/22 - Relatório com o novo processo de pagamento de comissão contato
// Alterações
// Rafael França - 30/03/22 - ModIFicação de estrutura de regra de pagamento de acordo com as novas tabelas

User Function FINR008()

	Local _cPerg    := "FINR008A"

	Private oPrint
	Private cSubTitle	:= ""
	Private nPag 		:= 0
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(09,   ,,,"Arial")
	Private oFonteN 	:= u_xFonte(09,.T.,,,"Arial")
	Private oFonte10 	:= u_xFonte(10,   ,,,"Arial")
	Private oFonte10N 	:= u_xFonte(10,.T.,,,"Arial")

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	IF !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	ENDIF

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

// fProcPdf - Imprime relatório em PDF
Static Function fProcPdf()

	Local nRegAtu		:= 0
	Local nTotReg		:= 0
	Local cDir 			:= Alltrim(MV_PAR03) + "\"
	//Assinatura
	Local cAssin1 		:= ""
	Local cAssin2 		:= ""
	Local cCargo1 		:= ""
	Local cCargo2 		:= ""

	//Totais e SubTotais
	Private nTotalCom  	:= 0
	Private nTotalPre  	:= 0
	Private nComAge 	:= 0
	Private cSubTot		:= ""
	Private nSubTotC	:= 0
	Private nSubTotI	:= 0
	Private cGrupo		:= ""
	Private nTotGrupoC 	:= 0
	Private nTotGrupoI 	:= 0
	Private cNatureza	:= ""
	Private cDescricao	:= ""
	Private nValNatC	:= 0
	Private nValNatI	:= 0
	Private cVendedor	:= ""
	Private cNome		:= ""
	//Tabelas temporarias
	Private cAlias1    	:= GetNextAlias()
	Private cAlias2    	:= GetNextAlias()
	Private cAlias3    	:= GetNextAlias()
	Private cAlias4    	:= GetNextAlias()
	//Informações importantes / parametros para calculo
	Private cPeriodo 	:= (MV_PAR04+MV_PAR05)
	Private aNatPerc	:= {}
	Private aMetas		:= {}
	Private nPos		:= 0
	Private nPerc		:= 0
	Private nPosCom		:= 0
	Private nPercCom	:= 0
	Private lOk			:= .F.
	Private lOk1		:= .T.
	//Filtros
	Private cFiltro1	:= "%AND SUBSTRING(E1_EMISSAO,1,6) = '"+cPeriodo+"' AND E1_TIPO NOT IN " + FormatIn(MV_PAR06,"/") + " AND E1_FILIAL = '01' %"
	Private cFiltro2	:= "%AND A3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' %"
	Private cFiltro3	:= "%AND ZAJ_VEND BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'AND ZAK_ANO = '"+(MV_PAR04)+"' %"
	//Calculo e regras de descontos do contato
	Private nDescAge	:= 0
	Private nDescBV		:= 0
	Private nDescCac	:= 0
	Private lDescAge	:= .F.
	Private lDescBV		:= .F.
	Private lDescCac	:= .F.
	Private nDescAge1	:= 0
	Private nDescBV1	:= 0
	Private nDescCac1	:= 0

	//Calcula os descontos de Agência, Bonificação Volume e Cachê
	CalcDesc()

	// Query para buscar as informações
	//Pega as regras de comissões e transforma em vetor para uso posterior
	BeginSql Alias cAlias1

		SELECT ZAJ_VEND AS VENDEDOR, ZAK_ANO AS ANO, ZAK_GRPNAT AS GRUPO, ZAK_TPSUB AS TPSUB, ZAK_PERC AS PERC_COM, ZAL_MES AS MES
		, ZAL_TIPO AS TIPO, ZAL_PERC AS PERC_COL, ZAL_VALOR AS VL_COM, ZAL_MTCOLE AS META_COL
		, ZAL_ATCOLE AS VL_COL, ZAL_MTINDI AS META_IND, ZAL_ATINDI AS VL_IND, ZAL_PERCIN AS PERC_IND
		FROM %table:ZAJ%
		INNER JOIN %table:ZAK% ON ZAJ_FILIAL = ZAK_FILIAL AND ZAJ_VEND = ZAK_VEND AND %table:ZAK%.D_E_L_E_T_ = ''
		INNER JOIN %table:ZAL% ON ZAK_FILIAL = ZAL_FILIAL AND ZAK_VEND = ZAL_VEND AND ZAK_ANO = ZAL_ANO AND ZAK_GRPNAT = ZAL_GRPNAT AND %table:ZAL%.D_E_L_E_T_ = ''
		WHERE %table:ZAJ%.D_E_L_E_T_ = ''
		%Exp:cFiltro3%
		ORDER BY VENDEDOR, ANO, GRUPO, MES

	EndSql

	(cAlias1)->(DbGoTop())

	While (cAlias1)->(!Eof())

		//Grava os percentuais do faturamento total da natureza por vendedor
		aAdd(aNatPerc,{(cAlias1)->VENDEDOR,;	//01 - Vendedor
		(cAlias1)->ANO,;			//02 - Ano
		(cAlias1)->GRUPO,;			//03 - Grupo
		(cAlias1)->PERC_COM,;		//04 - Percentual do GRupo
		(cAlias1)->MES,;			//05 - Mes da meta
		(cAlias1)->TIPO,;			//06 - Tipo de comissão coletiva
		(cAlias1)->PERC_COL,;		//07 - Percentual da comissão (Quando for %)
		(cAlias1)->VL_COM,;			//08 - Valor da comissão (Quando for valor)
		(cAlias1)->META_COL,;		//09 - Meta coletiva
		(cAlias1)->VL_COL,;			//10 - Valor coletivo atingido
		(cAlias1)->META_IND,;		//11 - Meta individual
		(cAlias1)->VL_IND,;			//12 - Valor atingido indvidual
		(cAlias1)->PERC_IND,;		//13 - Percentual da comissão individual
		(cAlias1)->TPSUB})			//14 - Tipo do subtotal do Grupo, 1=Calcula; 2=Não Calcula; 3=Calc. Com Descontos

		(cAlias1)->(DbSkip())

	EndDo

	(cAlias1)->(DbCloseArea())

	// Busca os registros a serem impressos no relatório, vendedores e titulos a receber lançados no periodo
	BeginSql Alias cAlias2

		SELECT VENDEDOR, NOME, DESCAG, DESCBV, DESCCA, GRUPOS, PERCENTUAL, NAT_COMISS, NATUREZA, DESCRICAO, SUM(VL_BRUTO) AS VL_BRUTO, SUM(COMISSAO) AS COMISSAO, SUM(VL_IND) AS VL_IND FROM (

		SELECT A3_COD AS VENDEDOR, A3_NOME AS NOME, ZAJ_DESCAG AS DESCAG, ZAJ_DESCBV AS DESCBV, ZAJ_DESCCA AS DESCCA
		, ZAM_GRPNAT AS GRUPOS, ZAM_PERC AS PERCENTUAL, ED_NATCOM AS NAT_COMISS, E1_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO
		, SUM(E1_VALOR) AS VL_BRUTO, SUM(E1_VALOR * E1_COMIS1 / 100) AS COMISSAO
		, SUM(CASE WHEN E1_VEND2 = A3_COD THEN E1_VALOR - (E1_VALOR * E1_COMIS1 / 100) ELSE 0 END) AS VL_IND
		FROM %table:SA3%
		INNER JOIN %table:ZAM% ON A3_COD = ZAM_VEND AND %table:ZAM%.D_E_L_E_T_ = ''
		INNER JOIN %table:SED% ON %table:SED%.D_E_L_E_T_ = '' AND ED_NATCOM <> '' AND ED_NATCOM = ZAM_GRPNAT
		INNER JOIN %table:SE1% ON %table:SE1%.D_E_L_E_T_ = '' AND E1_NATUREZ = ED_CODIGO AND E1_MULTNAT <> '1'
		%Exp:cFiltro1%
		INNER JOIN %table:SA1% ON %table:SA1%.D_E_L_E_T_ = '' AND E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
		WHERE %table:SA3%.D_E_L_E_T_ = ''
		%Exp:cFiltro2%
		GROUP BY A3_COD, A3_NOME, ZAJ_DESCAG, ZAJ_DESCBV, ZAJ_DESCCA, ZAM_GRPNAT, ZAM_PERC, ED_NATCOM, E1_NATUREZ, ED_DESCRIC
		UNION ALL
		SELECT A3_COD AS VENDEDOR, A3_NOME AS NOME, ZAJ_DESCAG AS DESCAG, ZAJ_DESCBV AS DESCBV, ZAJ_DESCCA AS DESCCA
		, ZAM_GRPNAT AS GRUPOS, ZAM_PERC AS PERCENTUAL, ED_NATCOM AS NAT_COMISS, EV_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO
		, SUM(EV_VALOR) AS VL_BRUTO, SUM(EV_VALOR * E1_COMIS1 / 100) AS COMISSAO
		, SUM(CASE WHEN E1_VEND2 = A3_COD THEN EV_VALOR - (EV_VALOR * E1_COMIS1 / 100) ELSE 0 END) AS VL_IND
		FROM %table:SA3%
		INNER JOIN %table:ZAM% ON A3_COD = ZAM_VEND AND %table:ZAM%.D_E_L_E_T_ = ''
		INNER JOIN %table:SED% ON %table:SED%.D_E_L_E_T_ = '' AND ED_NATCOM <> '' AND ED_NATCOM = ZAM_GRPNAT
		INNER JOIN %table:SEV% ON %table:SEV%.D_E_L_E_T_ = '' AND EV_NATUREZ = ED_CODIGO
		INNER JOIN %table:SE1% ON %table:SE1%.D_E_L_E_T_ = ''
		AND E1_PREFIXO = EV_PREFIXO AND E1_NUM = EV_NUM AND E1_PARCELA = EV_PARCELA AND E1_TIPO = EV_TIPO AND EV_RECPAG = 'R'
		%Exp:cFiltro1%
		INNER JOIN %table:SA1% ON %table:SA1%.D_E_L_E_T_ = '' AND E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
		WHERE %table:SA3%.D_E_L_E_T_ = ''
		%Exp:cFiltro2%
		GROUP BY A3_COD, A3_NOME, ZAJ_DESCAG, ZAJ_DESCBV, ZAJ_DESCCA, ZAM_GRPNAT, ZAM_PERC, ED_NATCOM, EV_NATUREZ, ED_DESCRIC) AS CONTATOS

		GROUP BY VENDEDOR, NOME, DESCAG, DESCBV, DESCCA, GRUPOS, PERCENTUAL, NAT_COMISS, NATUREZA, DESCRICAO
		ORDER BY VENDEDOR, NAT_COMISS, NATUREZA

	EndSql

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	IF nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parâmetros","FINR008")
		(cAlias2)->(DbCloseArea())
		Return
	ENDIF

	dbSelectArea(cAlias2)
	DbGoTop()

	While (cAlias2)->(!Eof())

		IF nLin > REL_END .or. cVendedor != Alltrim((cAlias2)->VENDEDOR)

			cFileName 	:= "FINR008_COMISSAO_"+cPeriodo+"_"+(cAlias2)->VENDEDOR+"_"+Alltrim((cAlias2)->NOME)
			oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
			oPrint:SetPortrait()//Retrato
			//	oPrint:SetLandScape()//Paisagem
			oPrint:SetPaperSize(DMPAPER_A4)
			oPrint:cPathPDF := cDir

			cVendedor := (cAlias2)->VENDEDOR
			cNome     := (cAlias2)->NOME
			ImpProxPag(cVendedor,cNome,cPeriodo) //Monta cabeçario da primeira e proxima pagina
			nLin += REL_LIN_RED

		ENDIF

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		IF (cNatureza != (cAlias2)->NATUREZA .or. cGrupo != (cAlias2)->NAT_COMISS) .and. lOk .and. MV_PAR11 == 2
			oPrint:Say( nLin,020, cNatureza					  									,oFonte)
			oPrint:Say( nLin,080, cDescricao						  			  				,oFonte)
			IF aNatPerc[nPos][11] > 0
				oPrint:Say( nLin,410, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
			ENDIf
			oPrint:Say( nLin,520, PADR(Transform(nValNatC, "@E 999,999,999.99"),14) 			,oFonte)
			nLin += REL_LIN_STD
			nValNatI		:= 0
			nValNatC		:= 0
		ENDIF

		IF cGrupo != (cAlias2)->NAT_COMISS .and. lOk //Impressão do totalizador por grupo de comissao de natureza

			ImpSubTot()

		ENDIF

		IF cSubTot != Substring((cAlias2)->NAT_COMISS,1,2) .AND. lOk //Impressão do totalizador por grupo de comissao de natureza

			ImpTotais()

		ENDIF

		IF nLin > REL_END
			u_PXRODAPE(@oPrint,"FINR008.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
		ENDIF

		cNatureza	:= (cAlias2)->NATUREZA
		cDescricao	:= (cAlias2)->DESCRICAO
		cVendedor	:= Alltrim((cAlias2)->VENDEDOR)
		cGrupo   	:= Alltrim((cAlias2)->NAT_COMISS)
		cSubTot		:= Substring((cAlias2)->NAT_COMISS,1,2)
		nPos 		:= ASCAN(aNatPerc,{ |x| x[01] == ALLTRIM(cVendedor) .AND. x[03] == ALLTRIM(cSubTot) .AND. (x[05] == ALLTRIM(MV_PAR05) .OR. x[05] == "99")})
		nPerc		:= (cAlias2)->PERCENTUAL
		nPercCom	:= aNatPerc[nPos][04]
		cTipoSub	:= aNatPerc[nPos][14]
		nValNatI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nValNatC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		nTotGrupoI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nTotGrupoC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		nSubTotI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nSubTotC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		lDescAge	:= IIF((cAlias2)->DESCAG == "1",.T.,.F.)
		lDescBV		:= IIF((cAlias2)->DESCBV == "1",.T.,.F.)
		lDescCac	:= IIF((cAlias2)->DESCCA == "1",.T.,.F.)
		lOk			:= .T.

		(cAlias2)->(DbSkip())

		IF nLin > REL_END .or. cVendedor != Alltrim((cAlias2)->VENDEDOR)

			IF (cNatureza != (cAlias2)->NATUREZA .or. cGrupo != (cAlias2)->NAT_COMISS .or. cVendedor != Alltrim((cAlias2)->VENDEDOR)) .and. MV_PAR11 == 2
				oPrint:Say( nLin,020, cNatureza					  									,oFonte)
				oPrint:Say( nLin,080, cDescricao						  			  				,oFonte)
				IF aNatPerc[nPos][11] > 0
					oPrint:Say( nLin,410, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
				ENDIF
				oPrint:Say( nLin,520, PADR(Transform(nValNatC, "@E 999,999,999.99"),14) 			,oFonte)
				nValNatI		:= 0
				nValNatC		:= 0
				nLin += REL_LIN_STD
			ENDIF

			IF cGrupo != (cAlias2)->NAT_COMISS .or. cVendedor != Alltrim((cAlias2)->VENDEDOR) //Impressão do totalizador por subgrupo de comissao de natureza

				ImpSubTot()

			ENDIF

			IF cSubTot != Substring((cAlias2)->NAT_COMISS,1,2) .or. cVendedor != Alltrim((cAlias2)->VENDEDOR) //Impressão do totalizador por grupo de comissao de natureza

				ImpTotais()

			ENDIF

			//Impressão do total do vendedor
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"										,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform( nTotalCom, "@E 999,999,999.99"),14)	,oFonteN)
			//IF nTotalPre > 0
			nLin += (REL_LIN_STD)
			oPrint:Say( nLin,020, "VALOR PRÊMIO:"										,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform( nTotalPre, "@E 999,999,999.99"),14)	,oFonteN)
			//ENDIF
			nLin += (REL_LIN_STD)
			oPrint:Say( nLin,020, "TOTAL:"														,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform(nTotalCom + nTotalPre, "@E 999,999,999.99"),14),oFonteN)

			//Pula mais linhas para assinatura
			nLin += (REL_LIN_TOT * 3)

			//Renovo a variavel para imprimir proximo vendedor
			lOk			:= .F.
			//nComAge 	:= 0
			nTotalCom  	:= 0
			nTotalPre	:= 0

			//Imprime linha das assinaturas
			IF !Empty(MV_PAR07) .and. PswSeek( 	MV_PAR07, .T. )
				oPrint:Say( nLin,024, "_________________________" ,oFonte10N)
				aUsuario := PswRet() // Retorna vetor com informações do usuário
				cAssin1  := Alltrim(aUsuario[1][4])
				cCargo1  := Alltrim(aUsuario[1][13])
			ENDIF

			IF !Empty(MV_PAR08) .and. PswSeek( 	MV_PAR08, .T. )
				oPrint:Say( nLin,175, "_________________________" ,oFonte10N)
				aUsuario := PswRet() // Retorna vetor com informações do usuário
				cAssin2  := Alltrim(aUsuario[1][4])
				cCargo2  := Alltrim(aUsuario[1][13])
			ENDIF

			nLin += REL_LIN_STD

			//Imprime o nome das assinaturas
			IF !Empty(cAssin1)
				oPrint:Say( nLin,024, PADC(cAssin1,40) ,oFonte10)
			ENDIF

			IF !Empty(cAssin2)
				oPrint:Say( nLin,175, PADC(cAssin2,40) ,oFonte10)
			ENDIF

			nLin += REL_LIN_STD

			IF !Empty(cCargo1)
				oPrint:Say( nLin,024, PADC(cCargo1,33) ,oFonte10N)
			ENDIF

			IF !Empty(cCargo2)
				oPrint:Say( nLin,175, PADC(cCargo2,33) ,oFonte10N)
			ENDIF

			u_PXRODAPE(@oPrint,"FINR008.PRW","")
			oPrint:EndPage()
			oPrint:Preview()

		ENDIF

	EndDo

	(cAlias2)->(DbCloseArea())

Return

// ImpProxPag - Imprime cabeçalho da próxima página
Static Function ImpProxPag(cVendedor,cNome,cPeriodo)

	nPag++
	oPrint:StartPage()
	cSubTitle := cVendedor + " - " + Alltrim(cNome)
	nLin := u_PXCABECA(@oPrint, UPPER("RELATÓRIO DE COMISSÃO DE VENDAS " + MesExtenso(Val(SUBSTRING(cPeriodo,5,2))) + "/" + SUBSTRING(cPeriodo,1,4)), cSubTitle  , nPag)

	oPrint:Say( nLin,020, "NATUREZA"	,oFonteN)
	oPrint:Say( nLin,080, "DESCRIÇÃO"	,oFonteN)
	oPrint:Say( nLin,290, "PERC %"		,oFonteN)
	oPrint:Say( nLin,410, "INDIVIDUAL"	,oFonteN)
	oPrint:Say( nLin,525, "COLETIVO"	,oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_LIN_STD

Return

// CalcDesc() - Calcula os totais dos descontos
Static Function CalcDesc()

	// Query paraccalcular o comissão agência
	BeginSql Alias cAlias3

		SELECT SUM(E1_VALOR * E1_COMIS1 / 100) AS DESCAGE
		FROM %table:SE1%
		WHERE %table:SE1%.D_E_L_E_T_ = '' AND E1_COMIS1 > 0
		%Exp:cFiltro1%

	EndSql

	(cAlias3)->(DbGoTop())

	While (cAlias3)->(!Eof())

	nDescAge := (cAlias3)->DESCAGE

	(cAlias3)->(DbSkip())

	EndDo

	(cAlias3)->(DbCloseArea())


	// Query para calcular bonificação de volume provisionado pelo faturamento - Pedido Sra. Elenn
	BeginSql Alias cAlias4

		SELECT E1_VEND1 AS AGENCIABV, A3_NOME AS NOME
		, CASE
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX1 AND ZU_ATEFX1 THEN ZU_PERC1
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX2 AND ZU_ATEFX2 THEN ZU_PERC2
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX3 AND ZU_ATEFX3 THEN ZU_PERC3
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX4 AND ZU_ATEFX4 THEN ZU_PERC4
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX5 AND ZU_ATEFX5 THEN ZU_PERC5
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX6 AND ZU_ATEFX6 THEN ZU_PERC6
		WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX7 AND ZU_ATEFX7 THEN ZU_PERC7
		ELSE 0
		END AS PERCENTUAL
		, SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) AS LIQUIDO
		FROM %table:SE1%
		INNER JOIN %table:SA3% ON E1_VEND1 = A3_COD AND %table:SA3%.D_E_L_E_T_ = ''
		INNER JOIN %table:SZU% ON E1_VEND1 = ZU_VEND AND %table:SZU% .D_E_L_E_T_ = '' AND E1_EMISSAO BETWEEN ZU_VALIDA AND ZU_ATEVALI
		WHERE %table:SE1%.D_E_L_E_T_ = '' AND E1_VEND1 <> ''
		%Exp:cFiltro1%
		GROUP BY E1_VEND1, A3_NOME
		, ZU_DEFX1, ZU_ATEFX1, ZU_PERC1
		, ZU_DEFX2, ZU_ATEFX2, ZU_PERC2
		, ZU_DEFX3, ZU_ATEFX3, ZU_PERC3
		, ZU_DEFX4, ZU_ATEFX4, ZU_PERC4
		, ZU_DEFX5, ZU_ATEFX5, ZU_PERC5
		, ZU_DEFX6, ZU_ATEFX6, ZU_PERC6
		, ZU_DEFX7, ZU_ATEFX7, ZU_PERC7
		ORDER BY AGENCIABV

	EndSql

	(cAlias4)->(DbGoTop())

	While (cAlias4)->(!Eof())

		//IF !EMPTY((cAlias4)->PERCENTUAL) //> 0 .AND. (cAlias4)->PERCENTUAL < 100
		nDescBV += (cAlias4)->LIQUIDO * (cAlias4)->PERCENTUAL / 100
		//ENDIF

		(cAlias4)->(DbSkip())

	EndDo

	(cAlias4)->(DbCloseArea())

	// Calculo manual Cachê
	nDescCac := MV_PAR10

Return()

// ImpSubTot() - Imprime os subtotais das naturezas
Static Function ImpSubTot()

	oPrint:Say( nLin,020, cGrupo 					  										,oFonteN)
	oPrint:Say( nLin,080, Posicione("SX5",1,xFilial("SX5")+"Z0" + cGrupo ,"X5_DESCRI")		,oFonteN)
	oPrint:Say( nLin,300, PADR(Transform(nPerc, "999%"),6)									,oFonteN)
	IF aNatPerc[nPos][11] > 0
		oPrint:Say( nLin,410, PADR(Transform(nTotGrupoI, "@E 999,999,999.99"),14)				,oFonteN)
	ENDIF
	oPrint:Say( nLin,520, PADR(Transform(nTotGrupoC, "@E 999,999,999.99"),14)				,oFonteN)
	nTotGrupoI	:= 0
	nTotGrupoC	:= 0
	IF MV_PAR11 == 2
		nLin += REL_LIN_STD+REL_LIN_RED
	ELSE
		nLin += REL_LIN_STD
	ENDIF

Return

// ImpTotais() - Imprime os totais por grupo de natureza
Static Function ImpTotais()

	IF MV_PAR11 == 2 .AND. cTipoSub <> "2" // Quando não calcula os totais (cTipoSub = 2) continua imprimindo as naturezas sem considerar o subtotal
		nLin -= REL_LIN_RED
	ENDIF

	//Verifica quais serão os descontos do contato
	IF lDescAge
		nDescAge1 := nDescAge
	ELSE
		nDescAge1 := 0
	ENDIF

	IF lDescBV
		nDescBV1 := nDescBV
	ELSE
		nDescBV1 := 0
	ENDIF

	IF lDescCac
		nDescCac1 := nDescCac
	ELSE
		nDescCac1 := 0
	ENDIF

	IF cTipoSub == "3"

		oPrint:Say( nLin,020, "SUBTOTAL:"				  						,oFonteN)
		IF aNatPerc[nPos][11] > 0
			oPrint:Say( nLin,410, PADR(Transform(nSubTotI, "@E 999,999,999.99"),14)	,oFonteN)
		ENDIF
		oPrint:Say( nLin,520, PADR(Transform(nSubTotC, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_TOT
		oPrint:Say( nLin,020, "(-) COMISSÃO AGÊNCIA:"			  				,oFonteN)
		oPrint:Say( nLin,300, PADR(Transform(20, "999%"),6)						,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescAge1, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_TOT
		oPrint:Say( nLin,020, "(-) BONIFICAÇÃO DE VOLUME:"		  				,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescBV1, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) CACHE:"				  						,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescCac1,"@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		nTotGrupoC := nSubTotC-nDescAge1-nDescBV1-nDescCac1
		oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"				  					,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nTotGrupoC, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  						,oFonteN)
		oPrint:Say( nLin,290, PADR(Transform(nPercCom, "999.9999%"),9)				,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform((nTotGrupoC)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)

		IF aNatPerc[nPos][11] <> 0 .OR. aNatPerc[nPos][09] <> 0
			nLin += REL_LIN_TOT
			IF aNatPerc[nPos][11] <> 0
				oPrint:Say( nLin,020, "META INDIVIDUAL:   " +ALLTRIM(Transform(aNatPerc[nPos][11], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,160, "VALOR ATINGIDO:    " +ALLTRIM(Transform(nSubTotI, "@E 999,999,999.99"))				,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO INDIVIDUAL (" +ALLTRIM(Transform(aNatPerc[nPos][13], "999.999%")) +"):"		,oFonteN)
				oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotI > aNatPerc[nPos][11],(nSubTotI*aNatPerc[nPos][13]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
				nTotalPre  += IIF(nSubTotI > aNatPerc[nPos][11],(nSubTotI*aNatPerc[nPos][13]/100),0)
				nLin += REL_LIN_STD
			END

			IF aNatPerc[nPos][09] <> 0
				oPrint:Say( nLin,020, "META COLETIVA:   " +ALLTRIM(Transform(aNatPerc[nPos][09], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,160, "VALOR ATINGIDO:  " +ALLTRIM(Transform(nTotGrupoC, "@E 999,999,999.99")) 			,oFonteN)
				IF aNatPerc[nPos][06] == "P"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO (" +ALLTRIM(Transform(aNatPerc[nPos][07], "999.99%")) + "):"	,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF((nTotGrupoC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF((nTotGrupoC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0)
				ELSEIF aNatPerc[nPos][06] == "V"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO: " 					,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF(nTotGrupoC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF(nTotGrupoC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0)
				ENDIF
			ENDIF
		ENDIF

		nLin += REL_LIN_RED
		oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
		nTotalCom  	+= (nTotGrupoC)*nPercCom/100
		nTotGrupoI 	:= 0
		nTotGrupoC 	:= 0
		nSubTotI	:= 0
		nSubTotC	:= 0
		nLin += REL_LIN_STD

	ELSEIF cTipoSub == "1"

		nLin += REL_LIN_RED
		nTotGrupoC 	:= nSubTotC
		oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"		  						,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nSubTotC, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
		oPrint:Say( nLin,290, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform((nSubTotC)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)

		IF aNatPerc[nPos][11] <> 0 .OR. aNatPerc[nPos][09] <> 0
			nLin += REL_LIN_TOT
			IF aNatPerc[nPos][11] <> 0
				oPrint:Say( nLin,020, "META INDIVIDUAL:   " +ALLTRIM(Transform(aNatPerc[nPos][11], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,160, "VALOR ATINGIDO:    " +ALLTRIM(Transform(nSubTotI, "@E 999,999,999.99")) 				,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO INDIVIDUAL (" +ALLTRIM(Transform(aNatPerc[nPos][13], "999.999%")) +"):"		,oFonteN)
				oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotI > aNatPerc[nPos][11],(nSubTotI*aNatPerc[nPos][13]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
				nTotalPre  += IIF(nSubTotI > aNatPerc[nPos][11],(nSubTotI*aNatPerc[nPos][13]/100),0)
				IF aNatPerc[nPos][09] <> 0
					nLin += REL_LIN_STD
				ENDIF
			END

			IF aNatPerc[nPos][09] <> 0
				oPrint:Say( nLin,020, "META COLETIVA:   " +ALLTRIM(Transform(aNatPerc[nPos][09], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,160, "VALOR ATINGIDO:  " +ALLTRIM(Transform(nTotGrupoC, "@E 999,999,999.99")) 			,oFonteN)
				IF aNatPerc[nPos][06] == "P"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO (" +ALLTRIM(Transform(aNatPerc[nPos][07], "999.999%")) + "):"	,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF((nTotGrupoC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF((nTotGrupoC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0)
				ELSEIF aNatPerc[nPos][06] == "V"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO: " 					,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF(nTotGrupoC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF(nTotGrupoC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0)
				ENDIF
			ENDIF
		ENDIF

		nLin += REL_LIN_RED
		oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
		nTotalCom  	+= (nTotGrupoC)*nPercCom/100
		nTotGrupoI 	:= 0
		nTotGrupoC 	:= 0
		nSubTotI	:= 0
		nSubTotC	:= 0
		nLin += REL_LIN_STD

	ENDIF

Return

//Validação e criação do cPerg (SX1 - Perguntas)
Static Function ValidPerg(cPerg)

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10) //cPerg = "FINR008A"
	//          Grupo Ordem Desc Por               Desc Espa   Desc Ingl  Variavel  Tipo  Tamanho  Decimal  PreSel  GSC  Valid   Var01       Def01     DefSpa01  DefEng01  CNT01  Var02  Def02     DefSpa02  DefEng02  CNT02  Var03  Def03  DefEsp03  DefEng03  CNT03     Var04  Def04  DefEsp04  DefEng04  CNT04  Var05  Def05  DefEsp05  DefEng05  CNT05  F3        PYME  GRPSXG   HELP  PICTURE  IDFIL
	aAdd(aRegs,{cPerg,"01","Do Vendedor:"			,"","","mv_ch01" ,"C",06,00,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"02","Até o Vendedor:"		,"","","mv_ch02" ,"C",06,00,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"03","Destino do(s) Arq.:"	,"","","mv_ch03" ,"C",99,00,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ano:"	 				,"","","mv_ch04" ,"C",04,00,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Mês:"			  		,"","","mv_ch05" ,"C",02,00,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Não imprimir Tipos:"	,"","","mv_ch06" ,"C",40,00,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Assinatura 1:" 		 	,"","","mv_ch07" ,"C",06,00,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"08","Assinatura 2:"		 	,"","","mv_ch08" ,"C",06,00,0, "G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"09","Valor do BV:"			,"","","mv_ch09" ,"N",12,02,0, "C","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Cachê:"					,"","","mv_ch10" ,"N",12,02,0, "C","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","Tipo Relatório:"		,"","","mv_ch11" ,"N",01,00,1, "C","","MV_PAR11","Sintético","","","","","Resumido","","","","","Analítico Xml","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		IF !dbSeek(PADR(cPerg,10)+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next
			MsUnlock()
		ENDIF
	Next

	RestArea(aArea)

Return()
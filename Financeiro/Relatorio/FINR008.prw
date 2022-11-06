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

	Local _cPerg    := "FINR008B"

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

	FwMsgRun(Nil, { || fProcPdf() }, "Processando", "Emitindo relatorio em PDF..." )

Return

// fProcPdf - Imprime relatório em PDF
Static Function fProcPdf(cCodVend)

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
	Private cTipoCom	:= ""
	//Tabelas temporarias
	Private cAlias1    	:= GetNextAlias()
	Private cAlias2    	:= GetNextAlias()
	Private cAlias3    	:= GetNextAlias()
	Private cAlias4    	:= GetNextAlias()
	Private cAlias5    	:= GetNextAlias()
	Private cAlias6    	:= GetNextAlias()
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
	Private cFiltro4	:= "%AND SUBSTRING(E1_EMISSAO,1,6) = '"+cPeriodo+"' AND E1_TIPO NOT IN " + FormatIn(MV_PAR06,"/") + " AND E1_FILIAL = '01' %"
	//Calculo e regras de descontos do contato
	Private nDescAge	:= 0
	Private nDescBV		:= 0
	Private nDescSP		:= 0
	Private nDescCac	:= 0
	Private nCancNF		:= 0
	Private nOutDesc	:= 0
	Private nBvSP		:= 0
	Private lDescAge	:= .F.
	Private lDescBV		:= .F.
	Private lDescBVSP		:= .F.
	Private lDescCac	:= .F.
	Private nDescAge1	:= 0
	Private nDescBV1	:= 0
	Private nDBVSP1 	:= 0
	Private nDescCac1	:= 0
	Private nCacheJulho	:= 0
	Private nCorrecao	:= (MV_PAR12)

	// Query para buscar as informações
	//Pega as regras de comissões e transforma em vetor para uso posterior
	BeginSql Alias cAlias1
		SELECT
			ZAJ_VEND AS VENDEDOR,
			ZAK_ANO AS ANO,
			ZAK_GRPNAT AS GRUPO,
			ZAK_TPSUB AS TPSUB,
			ZAK_PERC AS PERC_COM,
			ZAL_MES AS MES,
			ZAL_TIPO AS TIPO,
			ZAL_PERC AS PERC_COL,
			ZAL_VALOR AS VL_COM,
			ZAL_MTCOLE AS META_COL,
			ZAL_ATCOLE AS VL_COL,
			ZAL_MTINDI AS META_IND,
			ZAL_ATINDI AS VL_IND,
			ZAL_PERCIN AS PERC_IND,
			ZAJ_TIPO AS TIPOCOM
		FROM
			%table:ZAJ%
		INNER JOIN %table:ZAK%
		ON ZAJ_FILIAL = ZAK_FILIAL
			AND ZAJ_VEND = ZAK_VEND
			AND %table:ZAK% .D_E_L_E_T_ = ''
		INNER JOIN %table:ZAL%
		ON ZAK_FILIAL = ZAL_FILIAL
			AND ZAK_VEND = ZAL_VEND
			AND ZAK_ANO = ZAL_ANO
			AND ZAK_GRPNAT = ZAL_GRPNAT
			AND %table:ZAL% .D_E_L_E_T_ = ''
		WHERE
			%table:ZAJ% .D_E_L_E_T_ = '' %Exp:cFiltro3%
		ORDER BY
			VENDEDOR,
			ANO,
			GRUPO,
			MES
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
			(cAlias1)->TPSUB,;			//14 - Tipo do subtotal do Grupo, 1=Calcula; 2=Não Calcula; 3=Calc. Com Descontos
			(cAlias1)->TIPOCOM})		//15 - Tipo de impressão no relatório:Individual, Coletivo ou ambos

		cTipoCom	:= (cAlias1)->TIPOCOM
		cVendedor2	:= (cAlias1)->VENDEDOR

		(cAlias1)->(DbSkip())

	EndDo

	(cAlias1)->(DbCloseArea())

	// Busca os registros a serem impressos no relatório, vendedores e titulos a receber lançados no periodo
	BeginSql Alias cAlias2
		SELECT
			VENDEDOR,
			NOME,
			DESCAG,
			DESCBV,
			DESCBVSP,
			DESCCA,
			GRUPOS,
			PERCENTUAL,
			NAT_COMISS,
			NATUREZA,
			DESCRICAO,
			SUM(VL_BRUTO) AS VL_BRUTO,
			SUM(COMISSAO) AS COMISSAO,
			SUM(VL_IND) AS VL_IND,
			TIPOCOM
		FROM
			(
				SELECT
					A3_COD AS VENDEDOR,
					A3_NOME AS NOME,
					ZAJ_DESCAG AS DESCAG,
					ZAJ_DESCBV AS DESCBV,
					ZAJ_DESCSP AS DESCBVSP,
					ZAJ_DESCCA AS DESCCA,
					ZAM_GRPNAT AS GRUPOS,
					ZAM_PERC AS PERCENTUAL,
					ED_NATCOM AS NAT_COMISS,
					E1_NATUREZ AS NATUREZA,
					ED_DESCRIC AS DESCRICAO,
					SUM(E1_VALOR) AS VL_BRUTO,
					SUM(E1_VALOR * E1_COMIS1 / 100) AS COMISSAO,
					SUM(
						CASE
							WHEN E1_VEND2 = A3_COD
								THEN E1_VALOR
							ELSE 0
						END
					) AS VL_IND,
					ZAJ_TIPO AS TIPOCOM
				FROM
					%table:SA3%
				INNER JOIN %table:ZAJ%
				ON A3_COD = ZAJ_VEND
					AND %table:ZAJ% .D_E_L_E_T_ = ''
				INNER JOIN %table:ZAM%
				ON A3_COD = ZAM_VEND
					AND %table:ZAM% .D_E_L_E_T_ = ''
				INNER JOIN %table:SED%
				ON %table:SED% .D_E_L_E_T_ = ''
					AND ED_NATCOM <> ''
					AND ED_NATCOM = ZAM_GRPNAT
				INNER JOIN %table:SE1%
				ON %table:SE1% .D_E_L_E_T_ = ''
					AND E1_NATUREZ = ED_CODIGO
					AND E1_MULTNAT <> '1' %Exp:cFiltro1%
				INNER JOIN %table:SA1%
				ON %table:SA1% .D_E_L_E_T_ = ''
					AND E1_CLIENTE = A1_COD
					AND E1_LOJA = A1_LOJA
				WHERE
					%table:SA3% .D_E_L_E_T_ = '' %Exp:cFiltro2%
				GROUP BY
					A3_COD,
					A3_NOME,
					ZAJ_DESCAG,
					ZAJ_DESCBV,
					ZAJ_DESCSP,
					ZAJ_DESCCA,
					ZAM_GRPNAT,
					ZAM_PERC,
					ED_NATCOM,
					E1_NATUREZ,
					ED_DESCRIC,
					ZAJ_TIPO
				UNION
				ALL
				SELECT
					A3_COD AS VENDEDOR,
					A3_NOME AS NOME,
					ZAJ_DESCAG AS DESCAG,
					ZAJ_DESCBV AS DESCBV,
					ZAJ_DESCSP AS DESCBVSP,
					ZAJ_DESCCA AS DESCCA,
					ZAM_GRPNAT AS GRUPOS,
					ZAM_PERC AS PERCENTUAL,
					ED_NATCOM AS NAT_COMISS,
					EV_NATUREZ AS NATUREZA,
					ED_DESCRIC AS DESCRICAO,
					SUM(EV_VALOR) AS VL_BRUTO,
					SUM(EV_VALOR * E1_COMIS1 / 100) AS COMISSAO,
					SUM(
						CASE
							WHEN E1_VEND2 = A3_COD
								THEN EV_VALOR
							ELSE 0
						END
					) AS VL_IND,
					ZAJ_TIPO AS TIPOCOM
				FROM
					%table:SA3%
				INNER JOIN %table:ZAJ%
				ON A3_COD = ZAJ_VEND
					AND %table:ZAJ% .D_E_L_E_T_ = ''
				INNER JOIN %table:ZAM%
				ON A3_COD = ZAM_VEND
					AND %table:ZAM% .D_E_L_E_T_ = ''
				INNER JOIN %table:SED%
				ON %table:SED% .D_E_L_E_T_ = ''
					AND ED_NATCOM <> ''
					AND ED_NATCOM = ZAM_GRPNAT
				INNER JOIN %table:SEV%
				ON %table:SEV% .D_E_L_E_T_ = ''
					AND EV_NATUREZ = ED_CODIGO
				INNER JOIN %table:SE1%
				ON %table:SE1% .D_E_L_E_T_ = ''
					AND E1_PREFIXO = EV_PREFIXO
					AND E1_NUM = EV_NUM
					AND E1_PARCELA = EV_PARCELA
					AND E1_TIPO = EV_TIPO
					AND EV_RECPAG = 'R' %Exp:cFiltro1%
				INNER JOIN %table:SA1%
				ON %table:SA1% .D_E_L_E_T_ = ''
					AND E1_CLIENTE = A1_COD
					AND E1_LOJA = A1_LOJA
				WHERE
					%table:SA3% .D_E_L_E_T_ = '' %Exp:cFiltro2%
				GROUP BY
					A3_COD,
					A3_NOME,
					ZAJ_DESCAG,
					ZAJ_DESCBV,
					ZAJ_DESCSP,
					ZAJ_DESCCA,
					ZAM_GRPNAT,
					ZAM_PERC,
					ED_NATCOM,
					EV_NATUREZ,
					ED_DESCRIC,
					ZAJ_TIPO
			) AS CONTATOS
		GROUP BY
			VENDEDOR,
			NOME,
			DESCAG,
			DESCBV,
			DESCBVSP,
			DESCCA,
			GRUPOS,
			PERCENTUAL,
			NAT_COMISS,
			NATUREZA,
			DESCRICAO,
			TIPOCOM
		ORDER BY
			VENDEDOR,
			NAT_COMISS,
			NATUREZA
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
			cTipoCom  := (cAlias2)->TIPOCOM
			ImpProxPag(cVendedor,cNome,cPeriodo,cTipoCom) //Monta cabeçario da primeira e proxima pagina
			nLin += REL_LIN_RED

		ENDIF

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		IF (cNatureza != (cAlias2)->NATUREZA .or. cGrupo != (cAlias2)->NAT_COMISS) .and. lOk .and. MV_PAR11 == 2
			oPrint:Say( nLin,020, cNatureza					  									,oFonte)
			oPrint:Say( nLin,080, cDescricao						  			  				,oFonte)
			IF aNatPerc[nPos][11] > 0 .and. cTipoCom = "3"
				oPrint:Say( nLin,410, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
			ELSEIF cTipoCom = "1"
				oPrint:Say( nLin,520, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
			ENDIf

			IF cTipoCom = "3" .or. cTipoCom = "2"
				oPrint:Say( nLin,520, PADR(Transform(nValNatC, "@E 999,999,999.99"),14) 		,oFonte)
			ENDIF
			nLin += REL_LIN_STD
			nValNatI		:= 0
			nValNatC		:= 0
		ENDIF

		IF cGrupo != (cAlias2)->NAT_COMISS .and. lOk //Impressão do totalizador por grupo de comissao de natureza

			ImpSubTot()

		ENDIF

		IF cSubTot != Substring((cAlias2)->NAT_COMISS,1,2) .AND. lOk //Impressão do totalizador por grupo de comissao de natureza

			ImpTotais(Alltrim((cAlias2)->VENDEDOR),Substring(cGrupo,1,2))

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
		cTipoCom	:= aNatPerc[nPos][15]
		nValNatI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nValNatC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		nTotGrupoI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nTotGrupoC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		nSubTotI	+= ((cAlias2)->VL_IND   * nPerc) / 100
		nSubTotC	+= ((cAlias2)->VL_BRUTO * nPerc) / 100
		lDescAge	:= IIF((cAlias2)->DESCAG == "1",.T.,.F.)
		lDescBV		:= IIF((cAlias2)->DESCBV == "1",.T.,.F.)
		lDescBVSP	:= IIF((cAlias2)->DESCBVSP == "1",.T.,.F.)
		lDescCac	:= IIF((cAlias2)->DESCCA == "1",.T.,.F.)
		lOk			:= .T.

		(cAlias2)->(DbSkip())

		IF nLin > REL_END .or. cVendedor != Alltrim((cAlias2)->VENDEDOR)

			IF (cNatureza != (cAlias2)->NATUREZA .or. cGrupo != (cAlias2)->NAT_COMISS .or. cVendedor != Alltrim((cAlias2)->VENDEDOR)) .and. MV_PAR11 == 2
				oPrint:Say( nLin,020, cNatureza					  									,oFonte)
				oPrint:Say( nLin,080, cDescricao						  			  				,oFonte)
				IF aNatPerc[nPos][11] > 0 .and. cTipoCom = "3"
					oPrint:Say( nLin,410, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
				ELSEIF cTipoCom = "1"
					oPrint:Say( nLin,520, PADR(Transform(nValNatI, "@E 999,999,999.99"),14) 		,oFonte)
				ENDIF

				IF cTipoCom = "3" .or. cTipoCom = "2"
					oPrint:Say( nLin,520, PADR(Transform(nValNatC, "@E 999,999,999.99"),14) 		,oFonte)
				ENDIF

				nValNatI		:= 0
				nValNatC		:= 0
				nLin += REL_LIN_STD
			ENDIF

			IF cGrupo != (cAlias2)->NAT_COMISS .or. cVendedor != Alltrim((cAlias2)->VENDEDOR) //Impressão do totalizador por subgrupo de comissao de natureza

				ImpSubTot()

			ENDIF

			IF cSubTot != Substring((cAlias2)->NAT_COMISS,1,2) .or. cVendedor != Alltrim((cAlias2)->VENDEDOR) //Impressão do totalizador por grupo de comissao de natureza

				ImpTotais(cVendedor,Substring(cGrupo,1,2))

			ENDIF

			//Impressão do total do vendedor
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"										,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform( nTotalCom, "@E 999,999,999.99"),14)	,oFonteN)
			//IF nTotalPre > 0
			nLin += (REL_LIN_STD)
			oPrint:Say( nLin,020, "VALOR PRÊMIO:"										,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform( nTotalPre, "@E 999,999,999.99"),14)	,oFonteN)
			//Correção de desconto de agência descontado duplicadamente nos meses anteriores (apagar após folha de outubro)
			/*nLin += (REL_LIN_STD)
			oPrint:Say( nLin,020, "ACRÉSCIMO REF. DESCONTO COMISSÃO AGÊNCIA(FEV/MAR/ABR/MAI/JUN/JUL/AGO/SET):"		,oFonteN)
			oPrint:Say( nLin,520, PADL(Transform( nCorrecao, "@E 999,999,999.99"),14)	,oFonteN)*/
			//ENDIF
			IF cVendedor != "000608" .and. cVendedor != "000609"
				//nLin += (REL_LIN_STD)
				//oPrint:Say( nLin,020, "CORREÇÃO REFERENTE CACHE JULHO:"						,oFonteN)
				//oPrint:Say( nLin,520, PADL(Transform( nCacheJulho, "@E 999,999,999.99"),14)	,oFonteN)
				nLin += (REL_LIN_STD)
				oPrint:Say( nLin,020, "TOTAL:"												,oFonteN)
				oPrint:Say( nLin,520, PADL(Transform(nTotalCom + nTotalPre + nCacheJulho + nCorrecao, "@E 999,999,999.99"),14)	,oFonteN)
			ELSE
				nLin += (REL_LIN_STD)
				oPrint:Say( nLin,020, "TOTAL:"												,oFonteN)
				oPrint:Say( nLin,520, PADL(Transform(nTotalCom + nTotalPre + nCorrecao, "@E 999,999,999.99"),14)	,oFonteN)
			ENDIF

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
Static Function ImpProxPag(cVendedor,cNome,cPeriodo,cTipoCom)

	nPag++
	oPrint:StartPage()
	cSubTitle := cVendedor + " - " + Alltrim(cNome)
	nLin := u_PXCABECA(@oPrint, UPPER("RELATÓRIO DE COMISSÃO DE VENDAS " + MesExtenso(Val(SUBSTRING(cPeriodo,5,2))) + "/" + SUBSTRING(cPeriodo,1,4)), cSubTitle  , nPag)

	oPrint:Say( nLin,020, "NATUREZA"		,oFonteN)
	oPrint:Say( nLin,080, "DESCRIÇÃO"		,oFonteN)
	oPrint:Say( nLin,290, "PERC %"			,oFonteN)
	IF cTipoCom = "1"
		oPrint:Say( nLin,525, "INDIVIDUAL"	,oFonteN)
	ELSEIF cTipoCom = "2"
		oPrint:Say( nLin,525, "COLETIVO"	,oFonteN)
	ELSE
		oPrint:Say( nLin,410, "INDIVIDUAL"	,oFonteN)
		oPrint:Say( nLin,525, "COLETIVO"	,oFonteN)
	ENDIF

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_LIN_STD

Return

//Rotina responsavel pelo Calculo dos totais dos descontos
Static Function CalcDesc(cCodVend,cNatCom)

	//Desconto Comissão de Agencia
	nDescAge := ComisAgencia(cCodVend,cNatCom)

	//calcular desconto bonificação de volume provisionado pelo faturamento
	nDescBV := BonifVolume(cCodVend,cNatCom)

	//calcular desconto bonificação de volume provisionado pelo faturamento SP
	nDescSP := BVSP()

	//calcular desconto do cache
	If cCodVend = "000608"
		nDescCac := Cache("000070",cNatCom)
	Else
		nDescCac := Cache(cCodVend,cNatCom)
	EndIf

	//calcular desconto das nf - Bruno Alves
	nCancNF := CancNF(cCodVend,cNatCom)

	//Localiza valores de outros descontos
	nOutDesc := OutrosDesc(cCodVend,cNatCom)

Return()

// ImpSubTot() - Imprime os subtotais das naturezas gerenciais
Static Function ImpSubTot()

	oPrint:Say( nLin,020, cGrupo 					  											,oFonteN)
	oPrint:Say( nLin,080, Posicione("SX5",1,xFilial("SX5")+"Z0" + cGrupo ,"X5_DESCRI")			,oFonteN)
	oPrint:Say( nLin,300, PADR(Transform(nPerc, "999%"),6)										,oFonteN)
	IF aNatPerc[nPos][11] > 0 .and. cTipoCom = '3'
		oPrint:Say( nLin,410, PADR(Transform(nTotGrupoI, "@E 999,999,999.99"),14)				,oFonteN)
	ELSEIF cTipoCom = '1'
		oPrint:Say( nLin,520, PADR(Transform(nTotGrupoI, "@E 999,999,999.99"),14)				,oFonteN)
	ENDIF

	IF cTipoCom = '3' .or. cTipoCom = '2'
		oPrint:Say( nLin,520, PADR(Transform(nTotGrupoC, "@E 999,999,999.99"),14)				,oFonteN)
	ENDIf

	nTotGrupoI	:= 0
	nTotGrupoC	:= 0
	IF MV_PAR11 == 2
		nLin += REL_LIN_STD+REL_LIN_RED
	ELSE
		nLin += REL_LIN_STD
	ENDIF

Return

// ImpTotais() - Imprime os totais por grupo de natureza
Static Function ImpTotais(cCodVend,cGrpNat)

	//Meses Trimestral
	Local cMeses 		:= ""
	Local cAno			:= "01/02/03/04/05/06/07/08/09/10/11/12"

	If MV_PAR05 $ "01/02/03"
		cMeses := "01/02/03"
	ElseIf MV_PAR05 $ "04/05/06"
		cMeses := "04/05/06"
	ElseIf MV_PAR05 $ "07/08/09"
		cMeses := "07/08/09"
	ElseIf MV_PAR05 $ "10/11/12"
		cMeses := "10/11/12"
	EndIf

	IF MV_PAR11 == 2 .AND. cTipoSub <> "2" // Quando não calcula os totais (cTipoSub = 2) continua imprimindo as naturezas sem considerar o subtotal
		nLin -= REL_LIN_RED
	ENDIF

	CalcDesc(cCodVend,cGrpNat) //Calcula os totais antes de se fazer os descontos

	//Verifica quais serão os descontos do contato
	IF lDescAge
		nDescAge1 := nDescAge
	ELSE
		nDescAge1 := 0
	ENDIF

	IF cVendedor == "000608"
	nDescAge1 := 41917.60
	ENDIF

	IF lDescBV
		nDescBV1 := nDescBV
	ELSE
		nDescBV1 := 0
	ENDIF

	IF lDescBVSP
		nDBVSP1 := nDescSP
	ELSE
		nDBVSP1 := 0
	ENDIF

	IF lDescCac
		nDescCac1 := nDescCac
	ELSE
		nDescCac1 := 0
	ENDIF

	IF cTipoSub == "3"

		oPrint:Say( nLin,020, "FATURAMENTO BRUTO:"				  					,oFonteN)
		IF aNatPerc[nPos][11] > 0 .and. cTipoCom = "3"
			oPrint:Say( nLin,410, PADR(Transform(nSubTotI, "@E 999,999,999.99"),14)	,oFonteN)
		elseif cTipoCom = "1"
			oPrint:Say( nLin,520, PADR(Transform(nSubTotI, "@E 999,999,999.99"),14)	,oFonteN)
		ENDIF
		IF cTipoCom = "3" .or. cTipoCom = "2"
			oPrint:Say( nLin,520, PADR(Transform(nSubTotC, "@E 999,999,999.99"),14)	,oFonteN)
		ENDIF

		nLin += REL_LIN_TOT
		oPrint:Say( nLin,020, "(-) COMISSÃO AGÊNCIA:"			  					,oFonteN)
		oPrint:Say( nLin,300, PADR(Transform(20, "999%"),6)							,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescAge1, "@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) BONIFICAÇÃO DE VOLUME:"		  				,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescBV1, "@E 999,999,999.99"),14)	,oFonteN)

		//Verificar regra do desconto para acrescentar a variavel nBvSP1 - Bruno Alves
		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) BONIFICAÇÃO DE VOLUME SP:"	 				,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDBVSP1, "@E 999,999,999.99"),14)	,oFonteN)


		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) CACHE:"				  						,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nDescCac1,"@E 999,999,999.99"),14)	,oFonteN)

		//Verificar regra do desconto para acrescentar a variavel nCancNF - Bruno Alves
		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) CANCELAMENTO NF:"	  						,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nCancNF,"@E 999,999,999.99"),14)	,oFonteN)

		//Imprime valor dos outros descontos
		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "(-) COMISSÃO MÊS 10/22:"		  					,oFonteN)
		oPrint:Say( nLin,520, PADR(Transform(nOutDesc,"@E 999,999,999.99"),14)	,oFonteN)

		nLin += REL_LIN_STD
		nSubTotC -= nDescAge1
		nSubTotI -= nDescAge1
		nTotGrupoC := nSubTotC-nDescBV1-nDBVSP1-nDescCac1-nOutDesc
		nTotGrupoI := nSubTotI-nDescBV1-nDBVSP1-nDescCac1-nOutDesc
		oPrint:Say( nLin,020, "BASE DE CÁLCULO:"				  					,oFonteN)

		IF cTipoCom = "2" .or. cTipoCom = "3"
			oPrint:Say( nLin,520, PADR(Transform(nTotGrupoC, "@E 999,999,999.99"),14)	,oFonteN)
		ELSE
			oPrint:Say( nLin,520, PADR(Transform(nTotGrupoI, "@E 999,999,999.99"),14)	,oFonteN)
		ENDIF

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  						,oFonteN)
		oPrint:Say( nLin,290, PADR(Transform(nPercCom, "999.9999%"),9)				,oFonteN)
		IF cTipoCom = "2" .or. cTipoCom = "3"
			oPrint:Say( nLin,520, PADR(Transform((nTotGrupoC)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
		else
			oPrint:Say( nLin,520, PADR(Transform((nTotGrupoI)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
		endif

		IF aNatPerc[nPos][11] <> 0 .OR. aNatPerc[nPos][09] <> 0
			nLin += REL_LIN_TOT

			IF aNatPerc[nPos][11] <> 0
				oPrint:Say( nLin,020, "META INDIVIDUAL:   " +ALLTRIM(Transform(aNatPerc[nPos][11], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR LIQ. ATINGIDO:    " +ALLTRIM(Transform(nSubTotI, "@E 999,999,999.99"))				,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO INDIVIDUAL (" +ALLTRIM(Transform(aNatPerc[nPos][13], "999.999%")) +"):"		,oFonteN)
				oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotI > aNatPerc[nPos][11],(nTotGrupoI*aNatPerc[nPos][13]/100),0), "@E 999,999,999.99"),14)	,oFonteN)

				nTotalPre  += IIF(nSubTotI > aNatPerc[nPos][11],(nTotGrupoI*aNatPerc[nPos][13]/100),0)
				nLin += REL_LIN_STD

				//Verifico se vou gravar a tabela ou não
				If PerCalc() .AND. GetMv("RR_GRVZAL")
					//Gravo o valor calculado, pois o registro já se encontra posicionado devido a função CalcDesc()
					RECLOCK("ZAL",.F.)
					ZAL->ZAL_ATINDI := nSubTotI
					ZAL->ZAL_ATCOLE := nSubTotC
					ZAL->ZAL_CAINDI := IIF(nSubTotI > aNatPerc[nPos][11],(nTotGrupoI*aNatPerc[nPos][13]/100),0)

					IF aNatPerc[nPos][06] == "P"
						ZAL->ZAL_CACOLE :=	IIF((nSubTotC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0)
					ELSEIF aNatPerc[nPos][06] == "V"
						ZAL->ZAL_CACOLE := 	IIF(nSubTotC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0)
					EndIf


					If MV_PAR05 $ "03/06/09/12" //Faço os calculos trimestrais
						ZAL->ZAL_CATRII := CalcTri(cCodVend,cGrpNat,"I",cMeses)
					EndIf

					ZAL->(MSUNLOCK())

				EndIf



				oPrint:Say( nLin,020, "META TRIMESTRAL:   " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"M","I",cMeses), "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:    " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"V","I",cMeses), "@E 999,999,999.99"))				,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO RETROATIVO (" + "MES: " + MV_PAR05 + " - " + ALLTRIM(Transform(aNatPerc[nPos][13], "999.999%")) +"):"		,oFonteN)


				If MV_PAR05 $ "03/06/09/12"
					oPrint:Say( nLin,520, PADR(Transform(ZAL->ZAL_CATRII, "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += ZAL->ZAL_CATRII
				Else
					oPrint:Say( nLin,520, PADR(Transform(0, "@E 999,999,999.99"),14)	,oFonteN)
				EndIf


			EndIf


			// Rafael França - Utilizar o valor sem desconto para meta coletiva, nSubTotC no lugar de nTotGrupoC. Pedido Sra. Elenn 03/06/2022.
			IF aNatPerc[nPos][09] <> 0

				nLin += REL_LIN_STD


				oPrint:Say( nLin,020, "META COLETIVA:   " +ALLTRIM(Transform(aNatPerc[nPos][09], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:  " +ALLTRIM(Transform(nSubTotC, "@E 999,999,999.99")) 			,oFonteN)
				IF aNatPerc[nPos][06] == "P"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO (" +ALLTRIM(Transform(aNatPerc[nPos][07], "999.99%")) + "):"	,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF((nSubTotC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF((nSubTotC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0)
				ELSEIF aNatPerc[nPos][06] == "V"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO: " 					,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF(nSubTotC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0)
				ENDIF


				nLin += REL_LIN_STD


				oPrint:Say( nLin,020, "META COLETIVA TRIMESTRAL:   " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"M","C",cMeses), "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:  " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"V","C",cMeses), "@E 999,999,999.99")) 			,oFonteN)

				oPrint:Say( nLin,340, "PRÊMIO RETROATIVO (" + "MES: " + MV_PAR05 + " - " + ALLTRIM(Transform(aNatPerc[nPos][07], "999.99%")) + "):"	,oFonteN)
				If MV_PAR05 $ "03/06/09/12"
					oPrint:Say( nLin,520, PADR(Transform(ZAL->ZAL_CATRIC, "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += ZAL->ZAL_CATRIC
				Else
					oPrint:Say( nLin,520, PADR(Transform(0, "@E 999,999,999.99"),14)	,oFonteN)
				EndIf



				nLin += REL_LIN_STD


				oPrint:Say( nLin,020, "META ANUAL:   " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"M","I",cAno), "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:  " +ALLTRIM(Transform(SumTri(cCodVend,cGrpNat,"V","I",cAno), "@E 999,999,999.99")) 			,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO ANUAL: (MÊS: " + MV_PAR05 + ")" 					,oFonteN)
				If MV_PAR05 == '12'
					oPrint:Say( nLin,520, PADR(Transform(IIF(SumTri(cCodVend,cGrpNat,"V","I",cAno) > SumTri(cCodVend,cGrpNat,"M","I",cAno),(SumTri(cCodVend,cGrpNat,"V","C",cAno)*aNatPerc[nPos][08]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF(SumTri(cCodVend,cGrpNat,"V","C",cAno) > SumTri(cCodVend,cGrpNat,"M","C",cAno),(SumTri(cCodVend,cGrpNat,"V","C",cAno)*aNatPerc[nPos][08]/100),0)
				Else
					oPrint:Say( nLin,520, PADR(Transform(0, "@E 999,999,999.99"),14)	,oFonteN)
				EndIf?

			ENDIF

		ENDIF

		nLin += REL_LIN_RED
		oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")

		IF cTipoCom = "2" .or. cTipoCom = "3"
			nTotalCom  	+= (nTotGrupoC)*nPercCom/100
		else
			nTotalCom  	+= (nTotGrupoI)*nPercCom/100
		endif
		nTotGrupoI 	:= 0
		nTotGrupoC 	:= 0
		nSubTotI	:= 0
		nSubTotC	:= 0
		nLin += REL_LIN_STD

	ELSEIF cTipoSub == "1"

		nLin += REL_LIN_RED
		oPrint:Say( nLin,020, "BASE DE CÁLCULO:"		  						,oFonteN)

		IF cTipoCom = "2" .or. cTipoCom = "3"
			oPrint:Say( nLin,520, PADR(Transform(nSubTotC, "@E 999,999,999.99"),14)	,oFonteN)
		ELSE
			oPrint:Say( nLin,520, PADR(Transform(nSubTotI, "@E 999,999,999.99"),14)	,oFonteN)
		ENDIF

		nLin += REL_LIN_STD
		oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
		oPrint:Say( nLin,290, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
		IF cTipoCom = "2" .or. cTipoCom = "3"
			oPrint:Say( nLin,520, PADR(Transform((nSubTotC)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN) //aki
		else
			oPrint:Say( nLin,520, PADR(Transform((nSubTotI)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
		endif


		IF aNatPerc[nPos][11] <> 0 .OR. aNatPerc[nPos][09] <> 0
			nLin += REL_LIN_TOT
			IF aNatPerc[nPos][11] <> 0
				oPrint:Say( nLin,020, "META INDIVIDUAL:   " +ALLTRIM(Transform(aNatPerc[nPos][11], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:    " +ALLTRIM(Transform(nSubTotI, "@E 999,999,999.99")) 				,oFonteN)
				oPrint:Say( nLin,340, "PRÊMIO INDIVIDUAL (" +ALLTRIM(Transform(aNatPerc[nPos][13], "999.999%")) +"):"		,oFonteN)
				oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotI > aNatPerc[nPos][11],(nTotGrupoI*aNatPerc[nPos][13]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
				nTotalPre  += IIF(nSubTotI > aNatPerc[nPos][11],(nTotGrupoI*aNatPerc[nPos][13]/100),0)
				IF aNatPerc[nPos][09] <> 0
					nLin += REL_LIN_STD
				ENDIF
			END

			// Rafael França - Utilizar o valor sem desconto para meta coletiva, nSubTotC no lugar de nTotGrupoC. Pedido Sra. Elenn 03/06/2022.
			IF aNatPerc[nPos][09] <> 0
				oPrint:Say( nLin,020, "META COLETIVA:   " +ALLTRIM(Transform(aNatPerc[nPos][09], "@E 999,999,999.99")) 	,oFonteN)
				oPrint:Say( nLin,190, "VALOR ATINGIDO:  " +ALLTRIM(Transform(nSubTotC, "@E 999,999,999.99")) 			,oFonteN)
				IF aNatPerc[nPos][06] == "P"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO (" +ALLTRIM(Transform(aNatPerc[nPos][07], "999.999%")) + "):",oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF((nSubTotC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF((nSubTotC) > aNatPerc[nPos][09],(nTotGrupoC*aNatPerc[nPos][07]/100),0)
				ELSEIF aNatPerc[nPos][06] == "V"
					oPrint:Say( nLin,340, "PRÊMIO COLETIVO: " 					,oFonteN)
					oPrint:Say( nLin,520, PADR(Transform(IIF(nSubTotC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0), "@E 999,999,999.99"),14)	,oFonteN)
					nTotalPre  += IIF(nSubTotC >= aNatPerc[nPos][09],aNatPerc[nPos][08],0)
				ENDIF
			ENDIF
		ENDIF

		nLin += REL_LIN_RED
		oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")

		IF cTipoCom = "2" .or. cTipoCom = "3"
			nTotalCom  	+= (nSubTotC)*nPercCom/100
		else
			nTotalCom  	+= (nTotGrupoI)*nPercCom/100
		endif
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
	aAdd(aRegs,{cPerg,"12","Acréscimo C.A.:"		,"","","mv_ch12" ,"N",12,02,0, "C","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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




//Calcula o desconto da comissao de agencia

Static Function ComisAgencia(cCodVend,cNatCom)

	Local nValor 		:= 0
	Local cFiltDesc		:= ""

	IF cTipoCom = "1"
		cFiltDesc	:= "%AND SUBSTRING(E1_EMISSAO,1,6) = '"+cPeriodo+"' AND E1_TIPO NOT IN " + FormatIn(MV_PAR06,"/") + " AND E1_FILIAL = '01' AND E1_VEND2 = '"+cCodVend+"' %"
	ELSE
		cFiltDesc	:= cFiltro1
	ENDIF

	// Query para calcular o comissão agência
	BeginSql Alias cAlias3
		SELECT
			SUM(E1_VALOR * E1_COMIS1 / 100) AS DESCAGE
		FROM
			%table:SE1%
		INNER JOIN %table:SED%
		ON ED_CODIGO = E1_NATUREZ
		WHERE
			%table:SE1% .D_E_L_E_T_ = ''
			AND %table:SED% .D_E_L_E_T_ = ''
			AND E1_COMIS1 > 0 %Exp:cFiltDesc%
			AND SUBSTRING(ED_NATCOM, 1, 2) = %exp:cNatCom%
	EndSql

	(cAlias3)->(DbGoTop())

	While (cAlias3)->(!Eof())

		nValor := (cAlias3)->DESCAGE

		(cAlias3)->(DbSkip())

	EndDo

	(cAlias3)->(DbCloseArea())

Return(nValor)


//Rotina responsavel por calcular o dsconto da bonificação de volume

Static Function BonifVolume(cCodVend,cNatCom)

	Local nValor := 0

	BeginSql Alias cAlias4
		SELECT
			E1_VEND1 AS AGENCIABV,
			A3_NOME AS NOME,
			CASE
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX1 AND ZU_ATEFX1
					THEN ZU_PERC1
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX2 AND ZU_ATEFX2
					THEN ZU_PERC2
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX3 AND ZU_ATEFX3
					THEN ZU_PERC3
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX4 AND ZU_ATEFX4
					THEN ZU_PERC4
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX5 AND ZU_ATEFX5
					THEN ZU_PERC5
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX6 AND ZU_ATEFX6
					THEN ZU_PERC6
				WHEN SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) BETWEEN ZU_DEFX7 AND ZU_ATEFX7
					THEN ZU_PERC7
				ELSE 0
			END AS PERCENTUAL,
			SUM(E1_VALOR - (E1_VALOR * E1_COMIS1 / 100)) AS LIQUIDO,
			E1_VEND2 AS VENDEDOR2
		FROM
			%table:SE1%
		INNER JOIN %table:SA3%
		ON E1_VEND1 = A3_COD
			AND %table:SA3% .D_E_L_E_T_ = ''
		INNER JOIN %table:SZU%
		ON E1_VEND1 = ZU_VEND
			AND %table:SZU% .D_E_L_E_T_ = ''
			AND E1_EMISSAO BETWEEN ZU_VALIDA AND ZU_ATEVALI
		INNER JOIN %table:SED%
		ON ED_CODIGO = E1_NATUREZ
			AND %table:SED% .D_E_L_E_T_ = ''
		WHERE
			%table:SE1% .D_E_L_E_T_ = ''
			AND SUBSTRING(ED_NATCOM, 1, 2) = %exp:cNatCom%
			AND E1_VEND1 <> '' %Exp:cFiltro1%
		GROUP BY
			E1_VEND1,
			A3_NOME,
			ZU_DEFX1,
			ZU_ATEFX1,
			ZU_PERC1,
			ZU_DEFX2,
			ZU_ATEFX2,
			ZU_PERC2,
			ZU_DEFX3,
			ZU_ATEFX3,
			ZU_PERC3,
			ZU_DEFX4,
			ZU_ATEFX4,
			ZU_PERC4,
			ZU_DEFX5,
			ZU_ATEFX5,
			ZU_PERC5,
			ZU_DEFX6,
			ZU_ATEFX6,
			ZU_PERC6,
			ZU_DEFX7,
			ZU_ATEFX7,
			ZU_PERC7,
			E1_VEND2
		ORDER BY
			AGENCIABV
	EndSql

	(cAlias4)->(DbGoTop())

	While (cAlias4)->(!Eof())

		IF (cAlias4)->VENDEDOR2 == cCodVend .and. cTipoCom == "1"
			nValor += (cAlias4)->LIQUIDO * (cAlias4)->PERCENTUAL / 100
		elseif cTipoCom <> "1"
			nValor += (cAlias4)->LIQUIDO * (cAlias4)->PERCENTUAL / 100
		ENDIF

		(cAlias4)->(DbSkip())

	EndDo

	(cAlias4)->(DbCloseArea())

Return(nValor)


//Rotina responsavel por calcular o dsconto da bonificação de volume

Static Function BVSP()

	Local nValor    := 0
	Local cNatureza := "1204018"
	Local cDataIni  := MV_PAR04 + MV_PAR05 + "01"
	Local cDataFim  := MV_PAR04 + MV_PAR05 + "31"

	BeginSql Alias cAlias4
		SELECT
			SUM(E2_VALOR + E2_VRETISS) AS VALOR
		FROM
			%table:SE2%
		WHERE
			E2_NATUREZ = %Exp:cNatureza%
			and E2_EMISSAO BETWEEN %exp:cDataIni% AND %exp:cDataFim%
			AND D_E_L_E_T_ = ''
	EndSql

	(cAlias4)->(DbGoTop())

	While (cAlias4)->(!Eof())

		nValor += (cAlias4)->VALOR

		(cAlias4)->(DbSkip())

	EndDo

	(cAlias4)->(DbCloseArea())

Return(nValor)


//Rotina responsavel pelo calculo do desconto do cache

Static Function Cache(cCodVend,cNatCom)

	Local nValor := 0
	Local cDataIni  := MV_PAR04 + MV_PAR05 + "01"
	Local cDataFim  := MV_PAR04 + MV_PAR05 + "31"


	// Query responsavel pelo desconto do cache
	BeginSql Alias cAlias5
		SELECT
			SUM(ZS_VALOR) AS VALCACHE
		FROM
			%table:SZS% SZS
		INNER JOIN %table:SC5% SC5
		ON C5_FILIAL = ZS_FILIAL
			AND C5_NUMRP = ZS_NUMRP
			AND C5_NOTA = ZS_NOTAFAT
		INNER JOIN %table:SED% SED
		ON ED_CODIGO = C5_NATUREZ
		WHERE
			ZS_TIPO = '22'
			AND ZS_EMISSAO BETWEEN %exp:cDataIni% AND %exp:cDataFim%
			AND C5_VEND2 = %exp:cCodVend%
			AND SUBSTRING(ED_NATCOM, 1, 2) = %exp:cNatCom%
			AND ZS_LIBERAD = 'L'
			AND SZS.D_E_L_E_T_ = ''
			AND SC5.D_E_L_E_T_ = ''
			AND SED.D_E_L_E_T_ = ''
	EndSql

	(cAlias5)->(DbGoTop())

	While (cAlias5)->(!Eof())

		nValor := (cAlias5)->VALCACHE

		(cAlias5)->(DbSkip())

	EndDo

	(cAlias5)->(DbCloseArea())


Return(nValor)


//Rotina responsavel pelo calculo do desconto cancelamento da NF

Static Function CancNF(cCodVend,cNatCom)

	Local nValor := 0
	Local cDataIni  := MV_PAR04 + MV_PAR05 + "01"
	Local cDataFim  := MV_PAR04 + MV_PAR05 + "31"


	// Query responsavel pelo desconto do cache
	BeginSql Alias cAlias6
		SELECT
			E5_VALOR AS VALOR
		FROM
			%table:SE1% SE1
		INNER JOIN %table:SE5% SE5
		ON E5_FILIAL = E1_FILIAL
			AND E5_PREFIXO = E1_PREFIXO
			AND E5_NUMERO = E1_NUM
			AND E5_PARCELA = E1_PARCELA
			AND E5_CLIFOR = E1_CLIENTE
			AND E5_LOJA = E1_LOJA
			AND E5_DATA = E1_BAIXA
		INNER JOIN %table:SED% SED
		ON ED_CODIGO = E1_NATUREZ
		WHERE
			E1_VEND2 = %exp:cCodVend%
			AND E1_EMISSAO >= '20220101'
			AND E1_BAIXA BETWEEN %exp:cDataIni% AND %exp:cDataFim%
			AND E5_MOTBX IN ('BIN', 'BDE')
			AND SUBSTRING(ED_NATCOM, 1, 2) = %exp:cNatCom%
			AND SE1.D_E_L_E_T_ = ''
			AND SE5.D_E_L_E_T_ = ''
			AND SED.D_E_L_E_T_ = ''
	EndSql

	(cAlias6)->(DbGoTop())

	While (cAlias6)->(!Eof())

		nValor := (cAlias6)->VALOR

		(cAlias6)->(DbSkip())

	EndDo

	(cAlias6)->(DbCloseArea())


Return(nValor)



//Rotina responsavel por buscar o valor de outros descontos

Static Function OutrosDesc(cCodVend,cNatCom)

	Local nValor := 0

	DbSelectArea("ZAL");DbSetorder(1)
	If DbSeek(xFilial("ZAL") + cCodVend + cNatCom + MV_PAR04 + MV_PAR05 )
		nValor := ZAL->ZAL_DESCON
	EndIf

Return(nValor)


//Rotina responsavel por verificar se existe periodo superior calculado

Static Function PerCalc()

	Local lQtd 		:= .F.
	Local cAlias    := GetNextAlias()

	BeginSql Alias cAlias
		SELECT
			COUNT(*) AS QTD
		FROM
			%table:ZAL%
		WHERE
			ZAL_ANO = %Exp:MV_PAR04%
			AND ZAL_MES > %Exp:MV_PAR05%
			AND ZAL_ATINDI > 0
			AND D_E_L_E_T_ = ''
	EndSql

	//Verifico se encontrou informação nos meses superiores
	If (cAlias)->(!Eof()) .AND. (cAlias)->QTD == 0

		lQtd := .T.

		(cAlias)->(DbCloseArea())

	EndIf



Return(lQtd)

//Rotina responsavel por somar o valor e meta trimestral do vendedor
//nOpcao: V = Valor, M = Meta
//cTpTri: I = Individual, C = Coletiva

Static Function SumTri(cCodVend,cNatCom,cOpcao,cTpTri,cMeses)

	Local cAlias      := GetNextAlias()
	Local nValor	  := 0
	Local nMeta	  	  := 0
	Local cMes := "%" + FormatIn(cMeses,"/") + "%"

	BeginSql Alias cAlias
		SELECT
			SUM(ZAL_MTINDI) as META_INDIVIDUAL,
			SUM(ZAL_ATINDI) as VALOR_INDIVIDUAL,
			SUM(ZAL_MTCOLE) as META_COLETIVO,
			SUM(ZAL_ATCOLE) as VALOR_COLETIVO
		FROM
			%table:ZAL%
		WHERE
			ZAL_ANO = %Exp:MV_PAR04%
			AND ZAL_MES IN %Exp:cMes%
			AND ZAL_VEND = %Exp:cCodVend%
			AND ZAL_GRPNAT = %Exp:cNatCom%
			AND D_E_L_E_T_ = ''
	EndSql

	(cAlias)->(DbGoTop())

	While (cAlias)->(!Eof())

		If cTpTri == "I" //Meta indivudal

			nValor := (cAlias)->VALOR_INDIVIDUAL
			nMeta  := (cAlias)->META_INDIVIDUAL

		Else		// Meta Coletiva

			nValor := (cAlias)->VALOR_COLETIVO
			nMeta  := (cAlias)->META_COLETIVO

		EndIf


		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())

	If cOpcao == "M"
		nValor := nMeta
	EndIf

Return(nValor)



//Rotina responsavel por calcular comissão
//cTpTri: I = Individual, C = Coletiva

Static Function CalcTri(cCodVend,cNatCom,cTpTri,cMeses)

	Local cAlias      := GetNextAlias()
	Local nValor	  := 0
	Local cMes := "%" + FormatIn(cMeses,"/") + "%"

	BeginSql Alias cAlias
		SELECT
			SUM(ZAL_MTINDI) as META_INDIVIDUAL,
			SUM(ZAL_ATINDI) as VALOR_INDIVIDUAL,
			SUM(ZAL_CAINDI) as CALC_INDIVIDUAL,
			SUM(ZAL_PERCIN) as PERC_INDIVIDUAL,
			SUM(ZAL_MTCOLE) as META_COLETIVO,
			SUM(ZAL_ATCOLE) as VALOR_COLETIVO,
			SUM(ZAL_CACOLE) as CALC_COLETIVO,
			SUM(ZAL_PERC) as PERC_COLETIVO,
			COUNT(*) as QTD
		FROM
			%table:ZAL%
		WHERE
			ZAL_ANO = %Exp:MV_PAR04%
			AND ZAL_MES IN %Exp:cMes%
			AND ZAL_VEND = %Exp:cCodVend%
			AND ZAL_GRPNAT = %Exp:cNatCom%
			AND D_E_L_E_T_ = ''
	EndSql

	(cAlias)->(DbGoTop())

	While (cAlias)->(!Eof())

		If cTpTri == "I" //Calculo indivudal

			If CALC_INDIVIDUAL > (cAlias)->META_INDIVIDUAL

				nValor :=  nTotGrupoI * (((cAlias)->PERC_INDIVIDUAL/(cAlias)->QTD)/100)
				nValor := nValor - (cAlias)->CALC_INDIVIDUAL
				If nValor < 0
					nValor := 0
				EndIf

			EndIf

		Else		// Meta Coletiva

			nValor := 0

		EndIf


		(cAlias)->(DbSkip())

	EndDo

	(cAlias)->(DbCloseArea())

Return(nValor)


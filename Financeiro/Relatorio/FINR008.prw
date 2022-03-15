#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_LIN_RED 07
#DEFINE REL_LIN_STD 13
#DEFINE REL_LIN_TOT 20
#DEFINE REL_START  65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 700 //Retrato
//#DEFINE REL_RIGHT 820 //Paisagem
#DEFINE REL_RIGHT 580 //Retrato
#DEFINE REL_LEFT 10

// Rafael França - 01/03/22 - Relatório com o novo processo de pagamento de comissão

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
	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

/*/{Protheus.doc} fProcPdf
Imprime relatório em PDF
/*/

Static Function fProcPdf()

	Local nRegAtu		:= 0
	Local nTotReg		:= 0
	Local cDir 			:= Alltrim(MV_PAR03) + "\"
	Local cAssin1 		:= ""
	Local cAssin2 		:= ""
	Local cCargo1 		:= ""
	Local cCargo2 		:= ""

	Private nTotalVend  := 0
	Private nComAge 	:= 0
	Private cSubTot		:= ""
	Private nSubTot		:= 0
	Private cGrupo		:= ""
	Private nTotGrupo 	:= 0
	Private cNatureza	:= ""
	Private cDescricao	:= ""
	Private nValNat		:= 0
	Private cVendedor	:= ""
	Private cNome		:= ""
	Private cAlias1    	:= GetNextAlias()
	Private cAlias2    	:= GetNextAlias()
	Private cAlias3    	:= GetNextAlias()
	Private cPeriodo 	:= SUBSTRING(DTOS(MV_PAR05),1,6)
	Private cDataIni	:= DTOS(MV_PAR04)
	Private cDataFin	:= DTOS(MV_PAR05)
	Private aNatPerc	:= {}
	Private aGrpPerc	:= {}
	Private nPos		:= 0
	Private nPerc		:= 0
	Private nPosCom		:= 0
	Private nPercCom	:= 0
	Private lOk			:= .F.
	Private lOk1		:= .T.
	Private cFiltro1	:= "%AND E1_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFin+"' AND E1_TIPO NOT IN " + FormatIn(MV_PAR06,"/") + " AND E1_FILIAL = '01' %"
	Private cFiltro2	:= "%AND A3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' %"

// Query para buscar as informações
// Busca os registros a serem impressos no relatório
BeginSql Alias cAlias1

SELECT A3_COD AS VENDEDOR, A3_NOME AS NOME, A3_NATCOM AS GRUPOS, A3_NATPER AS PERCENTUAL, ED_NATCOM AS NAT_COMISS, E1_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO
, A3_GNAT1 AS GRP_COM1, A3_PGRUPO1 AS GRP_PERC1, A3_GNAT2 AS GRP_COM2, A3_PGRUPO2 AS GRP_PERC2, A3_GNAT3 AS GRP_COM3, A3_PGRUPO3 AS GRP_PERC3
, SUM(E1_VALOR) AS VL_BRUTO, SUM(E1_VALOR * E1_COMIS1 / 100) AS COMISSAO
FROM %table:SA3%
INNER JOIN %table:SED% ON %table:SED%.D_E_L_E_T_ = '' AND ED_NATCOM <> ''
AND ED_NATCOM IN (SUBSTRING(A3_NATCOM,1,4),SUBSTRING(A3_NATCOM,6,4),SUBSTRING(A3_NATCOM,11,4),SUBSTRING(A3_NATCOM,16,4),SUBSTRING(A3_NATCOM,21,4),SUBSTRING(A3_NATCOM,26,4)
,SUBSTRING(A3_NATCOM,31,4),SUBSTRING(A3_NATCOM,36,4),SUBSTRING(A3_NATCOM,41,4),SUBSTRING(A3_NATCOM,46,4))
INNER JOIN %table:SE1% ON %table:SE1%.D_E_L_E_T_ = '' AND E1_NATUREZ = ED_CODIGO AND E1_MULTNAT <> '1'
%Exp:cFiltro1%
INNER JOIN %table:SA1% ON %table:SA1%.D_E_L_E_T_ = '' AND E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
WHERE %table:SA3%.D_E_L_E_T_ = ''
%Exp:cFiltro2%
GROUP BY A3_COD, A3_NOME, A3_NATCOM, A3_NATPER, ED_NATCOM, E1_NATUREZ, ED_DESCRIC, A3_GNAT1, A3_PGRUPO1, A3_GNAT2, A3_PGRUPO2, A3_GNAT3, A3_PGRUPO3
UNION
SELECT A3_COD AS VENDEDOR, A3_NOME AS NOME, A3_NATCOM AS GRUPOS, A3_NATPER AS PERCENTUAL, ED_NATCOM AS NAT_COMISS, EV_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO
, A3_GNAT1 AS GRP_COM1, A3_PGRUPO1 AS GRP_PERC1, A3_GNAT2 AS GRP_COM2, A3_PGRUPO2 AS GRP_PERC2, A3_GNAT3 AS GRP_COM3, A3_PGRUPO3 AS GRP_PERC3
, SUM(EV_VALOR) AS VL_BRUTO, SUM(EV_VALOR * E1_COMIS1 / 100) AS COMISSAO
FROM %table:SA3%
INNER JOIN %table:SED% ON %table:SED%.D_E_L_E_T_ = '' AND ED_NATCOM <> ''
AND ED_NATCOM IN (SUBSTRING(A3_NATCOM,1,4),SUBSTRING(A3_NATCOM,6,4),SUBSTRING(A3_NATCOM,11,4),SUBSTRING(A3_NATCOM,16,4),SUBSTRING(A3_NATCOM,21,4),SUBSTRING(A3_NATCOM,26,4)
,SUBSTRING(A3_NATCOM,31,4),SUBSTRING(A3_NATCOM,36,4),SUBSTRING(A3_NATCOM,41,4),SUBSTRING(A3_NATCOM,46,4))
INNER JOIN %table:SEV% ON %table:SEV%.D_E_L_E_T_ = '' AND EV_NATUREZ = ED_CODIGO
INNER JOIN %table:SE1% ON %table:SE1%.D_E_L_E_T_ = ''
AND E1_PREFIXO = EV_PREFIXO AND E1_NUM = EV_NUM AND E1_PARCELA = EV_PARCELA AND E1_TIPO = EV_TIPO AND EV_RECPAG = 'R'
%Exp:cFiltro1%
INNER JOIN %table:SA1% ON %table:SA1%.D_E_L_E_T_ = '' AND E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
WHERE %table:SA3%.D_E_L_E_T_ = ''
%Exp:cFiltro2%
GROUP BY A3_COD, A3_NOME, A3_NATCOM, A3_NATPER, ED_NATCOM, EV_NATUREZ, ED_DESCRIC, A3_GNAT1, A3_PGRUPO1, A3_GNAT2, A3_PGRUPO2, A3_GNAT3, A3_PGRUPO3
ORDER BY VENDEDOR, NAT_COMISS, NATUREZA

EndSql

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","FINR008")
		(cAlias1)->(DbCloseArea())
		Return
	EndIf

	(cAlias1)->(DbGoTop())

	While (cAlias1)->(!Eof())

	If nLin > REL_END .or. cVendedor != Alltrim((cAlias1)->VENDEDOR)

//Grava os percentuais do faturamento total da natureza por vendedor
	aNatPerc	:= {{SUBSTRING((cAlias1)->GRUPOS,01,4),SUBSTRING((cAlias1)->PERCENTUAL,01,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,06,4),SUBSTRING((cAlias1)->PERCENTUAL,05,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,11,4),SUBSTRING((cAlias1)->PERCENTUAL,09,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,16,4),SUBSTRING((cAlias1)->PERCENTUAL,13,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,21,4),SUBSTRING((cAlias1)->PERCENTUAL,17,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,26,4),SUBSTRING((cAlias1)->PERCENTUAL,21,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,31,4),SUBSTRING((cAlias1)->PERCENTUAL,25,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,36,4),SUBSTRING((cAlias1)->PERCENTUAL,29,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,41,4),SUBSTRING((cAlias1)->PERCENTUAL,33,3)},;
					{SUBSTRING((cAlias1)->GRUPOS,46,4),SUBSTRING((cAlias1)->PERCENTUAL,37,3)}}

//Grava os percentuais de comissão por grupo do vendedor
	aGrpPerc	:= {{(cAlias1)->GRP_COM1,(cAlias1)->GRP_PERC1},;
					{(cAlias1)->GRP_COM2,(cAlias1)->GRP_PERC2},;
					{(cAlias1)->GRP_COM3,(cAlias1)->GRP_PERC3}}

	cFileName 	:= "FINR008_COMISSAO_"+cPeriodo+"_"+(cAlias1)->VENDEDOR+"_"+Alltrim((cAlias1)->NOME)
	oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetPortrait()//Retrato
	//	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	cVendedor := (cAlias1)->VENDEDOR
	cNome     := (cAlias1)->NOME
	ImpProxPag(cVendedor,cNome,cPeriodo) //Monta cabeçario da primeira e proxima pagina
	nLin += REL_LIN_RED

	EndIf

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		If (cNatureza != (cAlias1)->NATUREZA .or. cGrupo != (cAlias1)->NAT_COMISS) .and. lOk .and. MV_PAR10 == 2
		oPrint:Say( nLin,020, cNatureza					  									,oFonte)
		oPrint:Say( nLin,080, cDescricao						  			  				,oFonte)
		oPrint:Say( nLin,520, PADR(Transform(nValNat, "@E 999,999,999.99"),14) 				,oFonte)
		nLin += REL_LIN_STD
		nValNat		:= 0
		EndIf

		If cGrupo != (cAlias1)->NAT_COMISS .and. lOk //Impressão do totalizador por grupo de comissao de natureza
			oPrint:Say( nLin,020, cGrupo 					  										,oFonteN)
			oPrint:Say( nLin,080, Posicione("SX5",1,xFilial("SX5")+"Z0" + cGrupo ,"X5_DESCRI")		,oFonteN)
			oPrint:Say( nLin,320, PADR(Transform(nPerc, "999%"),6)									,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nTotGrupo, "@E 999,999,999.99"),14)				,oFonteN)
			nTotGrupo	:= 0
			If MV_PAR10 == 2
			nLin += REL_LIN_STD + REL_LIN_RED
			Else
			nLin += REL_LIN_STD
			EndIf
		EndIf

		If cSubTot != Substring((cAlias1)->NAT_COMISS,1,2) .and. lOk //Impressão do totalizador por grupo de comissao de natureza

			If MV_PAR10 == 2
			nLin -= REL_LIN_RED
			EndIf

			If cSubTot == aGrpPerc[1][1] .and. lOk1 //.and. cVendedor <> "000608" .or. cSubTot > "01" .and. cSubTot < "10" .and. cVendedor == "000608"
			oPrint:Say( nLin,020, "SUBTOTAL:"				  						,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_TOT
			oPrint:Say( nLin,020, "(-) COMISSÃO AGENCIA:"			  				,oFonteN)
			oPrint:Say( nLin,320, PADR(Transform(20, "999%"),6)						,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nComAge, "@E 999,999,999.99"),14),oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "(-) CACHE:"				  						,oFonteN)
			//oPrint:Say( nLin,318, PADR(Transform(MV_PAR09, "99.99%"),6)			,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(MV_PAR09, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"				  								,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot-MV_PAR09-nComAge, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
			oPrint:Say( nLin,310, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform((nSubTot-MV_PAR09-nComAge)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_RED
			oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
			nTotalVend  	+= (nSubTot-MV_PAR09-nComAge)*nPercCom/100
			nSubTot	:= 0
			nLin += REL_LIN_STD
			ElseIf cSubTot == aGrpPerc[1][1]  .and. cVendedor == "000608"
			nTotalVend  	+= nSubTot
			nLin += REL_LIN_STD
			ElseIf cSubTot <> aGrpPerc[1][1] .and. lOk1 // .and. cVendedor <> "000608" .or. cSubTot >= "10" .and. cVendedor == "000608"
			//oPrint:Say( nLin,020, "(-) CACHE:"					  						,oFonteN)
			//oPrint:Say( nLin,318, PADR(Transform(MV_PAR09, "99.99%"),6)				,oFonteN)
			//oPrint:Say( nLin,520, PADR(Transform(MV_PAR09, "@E 999,999,999.99"),14)		,oFonteN)
			//nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"		  							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot, "@E 999,999,999.99"),14)		,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
			oPrint:Say( nLin,310, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform((nSubTot)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_RED
			oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
			nTotalVend  	+= (nSubTot)*nPercCom/100
			nSubTot	:= 0
			nLin += REL_LIN_STD
			EndIf

		EndIf

		If nLin > REL_END
			u_PXRODAPE(@oPrint,"FINR008.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
		EndIf

		cNatureza	:= (cAlias1)->NATUREZA
		cDescricao	:= (cAlias1)->DESCRICAO
		cVendedor	:= Alltrim((cAlias1)->VENDEDOR)
		cGrupo   	:= Alltrim((cAlias1)->NAT_COMISS)
		nPos 		:= ASCAN(aNatPerc,{ |x| x[01] == ALLTRIM(cGrupo)})
		nPerc		:= Val(aNatPerc[nPos][2])
		nPosCom 	:= ASCAN(aGrpPerc,{ |x| x[01] == ALLTRIM(SUBSTRING(cGrupo,1,2))})
		If nPosCom 	!= 0
		nPercCom	:= aGrpPerc[nPosCom][2]
		lOk1		:= .T.
		Else
		nPercCom	:= 0
		lOk1		:= .F.
		EndIf
		nValNat		+= ((cAlias1)->VL_BRUTO * nPerc) / 100
		nTotGrupo	+= ((cAlias1)->VL_BRUTO * nPerc) / 100
		cSubTot		:= Substring((cAlias1)->NAT_COMISS,1,2)
		nSubTot		+= ((cAlias1)->VL_BRUTO * nPerc) / 100
		nComAge		+= (cAlias1)->COMISSAO
		lOk			:= .T.

		(cAlias1)->(DbSkip())

	If nLin > REL_END .or. cVendedor != Alltrim((cAlias1)->VENDEDOR)

		If (cNatureza != (cAlias1)->NATUREZA .or. cGrupo != (cAlias1)->NAT_COMISS .or. cVendedor != Alltrim((cAlias1)->VENDEDOR)) .and. MV_PAR10 == 2
		oPrint:Say( nLin,020, cNatureza					  							,oFonte)
		oPrint:Say( nLin,080, cDescricao						  			  		,oFonte)
		oPrint:Say( nLin,520, PADR(Transform(nValNat, "@E 999,999,999.99"),14) 		,oFonte)
		nValNat		:= 0
		nLin += REL_LIN_STD
		EndIf

		If cGrupo != (cAlias1)->NAT_COMISS .or. cVendedor != Alltrim((cAlias1)->VENDEDOR) //Impressão do totalizador por grupo de comissao de natureza
			oPrint:Say( nLin,020, cGrupo 					  										,oFonteN)
			oPrint:Say( nLin,080, Posicione("SX5",1,xFilial("SX5")+"Z0" + cGrupo ,"X5_DESCRI")		,oFonteN)
			oPrint:Say( nLin,320, PADR(Transform(nPerc, "999%"),6)									,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nTotGrupo, "@E 999,999,999.99"),14)				,oFonteN)
			nTotGrupo	:= 0
			If MV_PAR10 == 2
			nLin += REL_LIN_STD+REL_LIN_RED
			Else
			nLin += REL_LIN_STD
			EndIf
		EndIf

		If cSubTot != Substring((cAlias1)->NAT_COMISS,1,2) .or. cVendedor != Alltrim((cAlias1)->VENDEDOR) //Impressão do totalizador por grupo de comissao de natureza

			If MV_PAR10 == 2
			nLin -= REL_LIN_RED
			EndIf

			If cSubTot == aGrpPerc[1][1] .and. lOk1 //.and. cVendedor <> "000608" .or. cSubTot > "01" .and. cSubTot < "10" .and. cVendedor == "000608"
			oPrint:Say( nLin,020, "SUBTOTAL:"				  						,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_TOT
			oPrint:Say( nLin,020, "(-) COMISSÃO AGENCIA:"			  				,oFonteN)
			oPrint:Say( nLin,320, PADR(Transform(20, "999%"),6)						,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nComAge, "@E 999,999,999.99"),14),oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "(-) CACHE:"				  						,oFonteN)
			//oPrint:Say( nLin,318, PADR(Transform(MV_PAR09, "99.99%"),6)			,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(MV_PAR09, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"				  								,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot-MV_PAR09-nComAge, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
			oPrint:Say( nLin,310, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform((nSubTot-MV_PAR09-nComAge)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_RED
			oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
			nTotalVend  	+= (nSubTot-MV_PAR09-nComAge)*nPercCom/100
			nSubTot	:= 0
			nLin += REL_LIN_STD
			ElseIf cSubTot == aGrpPerc[1][1] .and. lOk1 == .F.
			nTotalVend  	+= nSubTot
			nLin += REL_LIN_STD
			ElseIf cSubTot <> aGrpPerc[1][1] .and. lOk1 // .and. cVendedor <> "000608" .or. cSubTot >= "10" .and. cVendedor == "000608"
			//oPrint:Say( nLin,020, "(-) CACHE:"					  						,oFonteN)
			//oPrint:Say( nLin,318, PADR(Transform(MV_PAR09, "99.99%"),6)				,oFonteN)
			//oPrint:Say( nLin,520, PADR(Transform(MV_PAR09, "@E 999,999,999.99"),14)		,oFonteN)
			//nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "TOTAL PARA CÁLCULO:"		  							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform(nSubTot, "@E 999,999,999.99"),14)		,oFonteN)
			nLin += REL_LIN_STD
			oPrint:Say( nLin,020, "VALOR COMISSÃO:"				  									,oFonteN)
			oPrint:Say( nLin,310, PADR(Transform(nPercCom, "999.9999%"),9)							,oFonteN)
			oPrint:Say( nLin,520, PADR(Transform((nSubTot)*nPercCom/100, "@E 999,999,999.99"),14)	,oFonteN)
			nLin += REL_LIN_RED
			oPrint:Line(nLin,REL_LEFT,nLin,REL_RIGHT,CLR_HGRAY,"-9")
			nTotalVend  	+= (nSubTot)*nPercCom/100
			nSubTot	:= 0
			nLin += REL_LIN_STD
			EndIf

		EndIf

	//Impressão do total do vendedor
	oPrint:Say( nLin,020, "COMISSÃO TOTAL:"										,oFonteN)
	oPrint:Say( nLin,520, PADL(Transform( nTotalVend, "@E 999,999,999.99"),14)	,oFonteN)

	//Pula mais linhas para assinatura
	nLin += (REL_LIN_TOT * 3)

	//Renovo a variavel para imprimir proximo vendedor
	lOk			:= .F.
	nComAge 	:= 0
	nTotalVend  := 0

	//Imprime linha das assinaturas
	If !Empty(MV_PAR07) .and. PswSeek( 	MV_PAR07, .T. )
		oPrint:Say( nLin,024, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin1  := Alltrim(aUsuario[1][4])
		cCargo1  := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR08) .and. PswSeek( 	MV_PAR08, .T. )
		oPrint:Say( nLin,175, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin2  := Alltrim(aUsuario[1][4])
		cCargo2  := Alltrim(aUsuario[1][13])
	EndIf

	nLin += REL_LIN_STD

	//Imprime o nome das assinaturas
	If !Empty(cAssin1)
		oPrint:Say( nLin,024, PADC(cAssin1,40) ,oFonte10)
	EndIf

	If !Empty(cAssin2)
		oPrint:Say( nLin,175, PADC(cAssin2,40) ,oFonte10)
	EndIf

	nLin += REL_LIN_STD

	If !Empty(cCargo1)
		oPrint:Say( nLin,024, PADC(cCargo1,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo2)
		oPrint:Say( nLin,175, PADC(cCargo2,33) ,oFonte10N)
	EndIf

	u_PXRODAPE(@oPrint,"FINR008.PRW","")
	oPrint:EndPage()
	oPrint:Preview()

	EndIF

	EndDo

	(cAlias1)->(DbCloseArea())

Return

/*/{Protheus.doc} ImpProxPag
    Imprime cabeçlho da proxima pagina
    @author  Rafael França
    @since   28-08-2020
/*/

Static Function ImpProxPag(cVendedor,cNome,cPeriodo)

	nPag++
	oPrint:StartPage()
	cSubTitle := cVendedor + " - " + Alltrim(cNome)
	nLin := u_PXCABECA(@oPrint, UPPER("RELATÓRIO DE COMISSÃO DE VENDAS " + MesExtenso(Val(SUBSTRING(cPeriodo,5,2))) + "/" + SUBSTRING(cPeriodo,1,4)), cSubTitle  , nPag)

	oPrint:Say( nLin,020, "NATUREZA"	,oFonteN)
	oPrint:Say( nLin,080, "DESCRIÇÃO"	,oFonteN)
	oPrint:Say( nLin,290, "PERCENTUAL"	,oFonteN)
	oPrint:Say( nLin,540, "VALOR"		,oFonteN)

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
	aAdd(aRegs,{cPerg,"01","Do Vendedor:"			,"","","mv_ch01" ,"C",06,00,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"02","Até o Vendedor:"		,"","","mv_ch02" ,"C",06,00,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	aAdd(aRegs,{cPerg,"03","Destino do(s) Arq.:"	,"","","mv_ch03" ,"C",99,00,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Da Emissão:"	 		,"","","mv_ch04" ,"D",08,00,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Até a Emissão:"  		,"","","mv_ch05" ,"D",08,00,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Não imprimir Tipos:"	,"","","mv_ch06" ,"C",40,00,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Assinatura 1:" 		 	,"","","mv_ch07" ,"C",06,00,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"08","Assinatura 2:"		 	,"","","mv_ch08" ,"C",06,00,0, "G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	//aAdd(aRegs,{cPerg,"09","Comissão de Agência:"	,"","","mv_ch09" ,"N",12,02,0, "C","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09","Cache"					,"","","mv_ch09" ,"N",12,02,0, "C","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Tipo Relatório:"		,"","","mv_ch10" ,"N",01,00,1, "C","","MV_PAR10","Sintético","","","","","Resumido","","","","","Analítico Xml","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(PADR(cPerg,10)+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return()
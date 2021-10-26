#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_VERT_STD 16
#DEFINE REL_START  65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 700 //Retrato
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

/*/{Protheus.doc} FINR005
Relatorio totalizador do repasse
@type function
@version
@author Rafael França
@since 09/11/2020
@return return_type, return_description
/*/

User Function FINR005()

	Local _cPerg    := "FINR005A"

	Private oPrint
	Private cSubTitle	:= ""
	Private nPag 		:= 0
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(12,,,,"Arial")
	Private oFonteN 	:= u_xFonte(12,.T.,,,"Arial")
	Private oFonte10 	:= u_xFonte(10,,,,"Arial")
	Private oFonte10N 	:= u_xFonte(10,.T.,,,"Arial")

	//If !lLogin
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN"
	//EndIf

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

/*/{Protheus.doc} fProcPdf
imprimir relatorio em pdf
@type function
@version
@author Rafael França
@since 09/11/2020
@return return_type, return_description
/*/

Static Function fProcPdf()

	Local nTotRat   := 0
	Local nTotal    := 0
	Local nRegAtu	:= 0
	Local nTotReg	:= 0
	Local cDir 		:= Alltrim(MV_PAR05) + "\"
	Local cTipo 	:= ""

	Local cAssin1 := ""
	Local cAssin2 := ""
	Local cAssin3 := ""
	Local cAssin4 := ""

	Local cCargo1 := ""
	Local cCargo2 := ""
	Local cCargo3 := ""
	Local cCargo4 := ""

	Private cAlias     	:= GetNextAlias()
	Private cPeriodo 	:= SUBSTRING(DTOS(MV_PAR07),5,2) + SUBSTRING(DTOS(MV_PAR07),1,4)
	Private cPerTitulo	:= SUBSTRING(DTOS(MV_PAR07),5,2) + "/" + SUBSTRING(DTOS(MV_PAR07),1,4)
	Private cPeriodoAnt,cDataIni,cDataFin

	cDataIni	:= DTOS(MV_PAR06)
	cDataFin	:= DTOS(MV_PAR07)
	cPeriodo 	:= SUBSTRING(DTOS(MV_PAR07),5,2) + SUBSTRING(DTOS(MV_PAR07),1,4)
	cPeriodoAnt := SUBSTRING(DTOS(MonthSub(MV_PAR07,1)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR07,1)),1,4)

	// Query para buscar as informações
	GetData(cPeriodo,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","FINR005")
		(cAlias)->(DbCloseArea())
		Return
	EndIf

	(cAlias)->(DbGoTop())

	cFileName 	:= "TOTAL_REPASSE_PAGAR_"+cPeriodo+"_FINR005" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")
	oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetPortrait()//Retrato
	//	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	ImpProxPag()//Monta cabeçario da primeira e proxima pagina

	While (cAlias)->(!Eof())

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		oPrint:Say( nLin,020, (cAlias)->ZAF_CODIGO			  				  ,oFonte)
		oPrint:Say( nLin,060, (cAlias)->TIPO  					  			  ,oFonte)
		oPrint:Say( nLin,110, (cAlias)->ZAF_DESCRI				  			  ,oFonte)
		oPrint:Say( nLin,350, (cAlias)->ZAF_CITY					  			  ,oFonte)
		oPrint:Say( nLin,460, (cAlias)->ZAF_EST 					  			  ,oFonte)
		oPrint:Say( nLin,520, PADL(Transform( (cAlias)->VALOR, "@E 999,999,999.99"),14) ,oFonte)

		nLin += REL_VERT_STD

		If nLin > REL_END
			u_PXRODAPE(@oPrint,"FINR005.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
		EndIf

		cTipo   := (cAlias)->TIPO
		nTotal  += (cAlias)->VALOR
		nTotRat += (cAlias)->VALOR

		(cAlias)->(DbSkip())

		If cTipo != (cAlias)->TIPO

			//Impressão do totalizador por tipo
			oPrint:Say( nLin,520, PADL(Transform( nTotRat, "@E 999,999,999.99"),14),oFonteN)
			nTotRat	:= 0

			nLin += REL_VERT_STD
			nLin += REL_VERT_STD

		EndIf

	EndDo

	//Impressão do total de todas as praças
	nLin -= REL_VERT_STD
	oPrint:Say( nLin,520, PADL(Transform( nTotal, "@E 999,999,999.99"),14),oFonteN)

	nLin += (REL_VERT_STD * 3)

	//Imprime linha das assinaturas
	If !Empty(MV_PAR08) .and. PswSeek( 	MV_PAR08, .T. )
		oPrint:Say( nLin,024, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin1 := Alltrim(aUsuario[1][4])
		cCargo1 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR09) .and. PswSeek( 	MV_PAR09, .T. )
		oPrint:Say( nLin,175, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin2 := Alltrim(aUsuario[1][4])
		cCargo2 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR10) .and. PswSeek( 	MV_PAR10, .T. )
		oPrint:Say( nLin,318, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin3 := Alltrim(aUsuario[1][4])
		cCargo3 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR11) .and. PswSeek( 	MV_PAR11, .T. )
		oPrint:Say( nLin,470, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin4 := Alltrim(aUsuario[1][4])
		cCargo4 := Alltrim(aUsuario[1][13])
	EndIf

	nLin += REL_VERT_STD

	//Imprime o nome das assinaturas

	If !Empty(cAssin1)
		oPrint:Say( nLin,024, PADC(cAssin1,40) ,oFonte10)
	EndIf

	If !Empty(cAssin2)
		oPrint:Say( nLin,175, PADC(cAssin2,40) ,oFonte10)
	EndIf

	If !Empty(cAssin3)
		oPrint:Say( nLin,318, PADC(cAssin3,40) ,oFonte10)
	EndIf

	If !Empty(cAssin4)
		oPrint:Say( nLin,470, PADC(cAssin4,40) ,oFonte10)
	EndIf

	nLin += REL_VERT_STD

	If !Empty(cCargo1)
		oPrint:Say( nLin,024, PADC(cCargo1,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo2)
		oPrint:Say( nLin,175, PADC(cCargo2,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo3)
		oPrint:Say( nLin,318, PADC(cCargo3,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo4)
		oPrint:Say( nLin,470, PADC(cCargo4,33) ,oFonte10N)
	EndIf

	u_PXRODAPE(@oPrint,"FINR005.PRW","")
	oPrint:EndPage()
	oPrint:Preview()
	(cAlias)->(DbCloseArea())

Return

/*/{Protheus.doc} GetData
    Busca dados no banco
    @author  Rafael França de Oliveira
    @since   24-08-2020
/*/

Static Function GetData(cPPeriodo,cPPracaDe,cPPracaAte,cPRpDe,cPRpAte)

	// Busca os registros a serem impressos no relatório
	BeginSql Alias cAlias

	SELECT ZAF_CODIGO,ZAF_CITY,
	CASE
	WHEN ZAF_TIPO = '1'  THEN 'Filiada'
	WHEN ZAF_TIPO = '2'  THEN 'Afiliada'
	WHEN ZAF_TIPO = '3'  THEN 'Cabeça de Rede'
	END AS TIPO,
	ZAF_DESCRI,ZAF_CITY,ZAF_EST,SUM(E2_VALOR) AS VALOR
		FROM
			%table:ZAG% AS ZAG
		INNER JOIN %table:ZAH% AS ZAH
		ON ZAH_FILIAL = ZAG_FILIAL
			AND ZAH_CODIGO = ZAG_CODIGO
			AND ZAH_PRACA = ZAG_PRACA
			AND ZAH_NUMRP = ZAG_NUMRP
			AND ZAH_PERIOD = ZAG_PERIOD
		INNER JOIN %table:ZAF% AS ZAF
		ON ZAF_FILIAL = ZAG_FILIAL
			AND ZAF_CODIGO = ZAG_PRACA
		INNER JOIN %table:SC5% AS SC5
		ON C5_FILIAL = ZAG_FILIAL
			AND C5_NUMRP = ZAG_NUMRP
			AND C5_NOTA <> ''
			AND SC5.D_E_L_E_T_ = ''
		INNER JOIN %table:SA1% AS SA1
		ON A1_COD = C5_CLIENTE
			AND A1_LOJA = C5_LOJACLI
			AND SA1.D_E_L_E_T_ = ''
		INNER JOIN %table:SF2% AS SF2
		ON F2_FILIAL = C5_FILIAL
			AND F2_SERIE = C5_SERIE
			AND F2_DOC = C5_NOTA
			AND F2_CLIENTE = C5_CLIENTE
			AND F2_LOJA = C5_LOJACLI
			AND SF2.D_E_L_E_T_ = ''
		INNER JOIN %table:SE1% AS SE1
		ON E1_FILIAL = F2_FILIAL
			AND E1_PREFIXO = F2_SERIE
			AND E1_NUM = F2_DOC
			AND E1_TIPO = 'NF'
			AND E1_CLIENTE = F2_CLIENTE
			AND E1_LOJA = F2_LOJA
			AND E1_PARCELA IN ('', '001')
			AND SE1.D_E_L_E_T_ = ''
			//AND E1_BAIXA BETWEEN %Exp:cDataIni% AND %Exp:cDataFin%
		INNER JOIN %table:SE2% AS SE2
		ON E2_FILIAL = F2_FILIAL
			AND E2_XNUMRP = ZAG_NUMRP
			//AND E2_EMISSAO BETWEEN '' AND %Exp:cDataFin%
			//AND E2_BAIXA = ''
			AND (E2_VALOR = ZAH_VLRAT OR E2_XNUMRP IN ('234777'))
			AND SE2.D_E_L_E_T_ = ''
			AND E2_VENCTO BETWEEN %Exp:cDataIni% AND %Exp:cDataFin%
		WHERE
			ZAG_FILIAL = '01'
			AND ZAG_EMISSA BETWEEN '' AND %Exp:cDataFin%
			AND ZAG_PRACA BETWEEN %Exp:cPPracaDe% AND %Exp:cPPracaAte%
			//AND ZAG_NUMRP BETWEEN %Exp:cPRpDe% AND %Exp:cPRpAte%
			AND (ZAG_PERIOD <> '072021' OR ZAG_NUMRP NOT IN ('234575'))
			AND ZAH_VLRAT > 0
			AND ZAF.D_E_L_E_T_ = ''
			AND ZAG.D_E_L_E_T_ = ''
			AND ZAH.D_E_L_E_T_ = ''
	GROUP BY ZAF_CODIGO,ZAF_CITY,ZAF_TIPO,ZAF_DESCRI,ZAF_CITY,ZAF_EST
	ORDER BY ZAF_TIPO DESC, VALOR DESC

	EndSql

Return

/*/{Protheus.doc} ImpProxPag
    Imprime cabeçlho da proxima pagina
    @author  Rafael França de Oliveira
    @since   28-08-2020
/*/

Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "VENCIMENTO: " + DTOC(MV_PAR12)
	nLin := u_PXCABECA(@oPrint, "REPASSE A PAGAR REFERENTE FATURAMENTO SPOT", cSubTitle  , nPag)

	oPrint:Say( nLin,020, "PRAÇA",oFonteN)
	oPrint:Say( nLin,060, "STATUS",oFonteN)
	oPrint:Say( nLin,110, "TV",oFonteN)
	oPrint:Say( nLin,350, "CIDADE",oFonteN)
	oPrint:Say( nLin,460, "ESTADO",oFonteN)
	oPrint:Say( nLin,540, "VALOR",oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_VERT_STD

Return

/*/{Protheus.doc} ValidPerg
//TODO Funï¿½ï¿½o que cria as perguntas.
@author Eduardo Cevoli
@since 01/06/2020
@version 1.0
@return ${return}, ${return_description}
@param cPerg, characters, descricao
@type function
/*/

Static Function ValidPerg(cPerg)

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10)
	//          Grupo Ordem Desc Por               Desc Espa   Desc Ingl  Variavel  Tipo  Tamanho  Decimal  PreSel  GSC  Valid   Var01       Def01     DefSpa01  DefEng01  CNT01  Var02  Def02     DefSpa02  DefEng02  CNT02  Var03  Def03  DefEsp03  DefEng03  CNT03     Var04  Def04  DefEsp04  DefEng04  CNT04  Var05  Def05  DefEsp05  DefEng05  CNT05  F3        PYME  GRPSXG   HELP  PICTURE  IDFIL
	aAdd(aRegs,{cPerg,"01", "Da Praça:"			 ,"","","mv_ch1" ,"C",03,00,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","ZAF"})
	aAdd(aRegs,{cPerg,"02", "Ate Praça:"		 ,"","","mv_ch2" ,"C",03,00,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ZAF"})
	aAdd(aRegs,{cPerg,"03", "Do Nº RP:"			 ,"","","mv_ch3" ,"C",06,00,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04", "Ate Nº RP:"		 ,"","","mv_ch4" ,"C",06,00,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05", "Destino do(s) Arq.:","","","mv_ch5" ,"C",99,00,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06", "Do Vencimento:"	 ,"","","mv_ch6" ,"D",08,00,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07", "Até o Vencimento:"  ,"","","mv_ch7" ,"D",08,00,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","Assinatura 1:" 		 ,"","","mv_ch8" ,"C",06,00,0, "G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"09","Assinatura 2:"		 ,"","","mv_ch9" ,"C",06,00,0, "G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"10","Assinatura 3:" 		 ,"","","mv_ch10","C",06,00,0, "G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"11","Assinatura 4:"		 ,"","","mv_ch11","C",06,00,0, "G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"12","Vencimento:"  		 ,"","","mv_ch12","D",08,00,0, "G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
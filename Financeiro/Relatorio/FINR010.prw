#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_VERT_STD 16
#DEFINE REL_START 65
#DEFINE REL_END 560
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

/*/{Protheus.doc} FINR010
Relatorio detalhado do CACHE para ser utilizado na conferencia da comissão do vendedor
@type function
@version
@author Bruno Alves de Oliveira
@since 07/09/2022
@return return_type, return_description
/*/

User Function FINR010()

	Local _cPerg    := "FINR010"

	Private nTotCalc 	:= 0

	//Private lLogin    := Type("cEmpAnt") != "U"
	Private cTmp1     := GetNextAlias()
	Private cPeriodo,cPeriodoAnt,cDataIni,cDataFin
	Private oPrint
	Private cSubTitle	:= ""
	Private nPag 		:= 0
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(8,,,,"Arial")
	Private oFonteN 	:= u_xFonte(8,.T.,,,"Arial")

	Private aImpNeg := {}

	//If !lLogin
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN"
	//EndIf

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	If Empty(MV_PAR05)
		ApMsgStop("Favor preencher o caminho do destino aonde será gravado os arquivos gerados pelo relatório!")
		Return
	EndIf


	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

/*/{Protheus.doc} fProcPdf
imprimir relatorio em pdf
@type function
@version
@author Rafael França
@since 24/08/2020
@return return_type, return_description
/*/

Static Function fProcPdf()

	Local aUsuario	:= {}
	Local cUsuario	:= ""
	Local cVendedor := ""
	Local _nTotReg  := 0            // Total de Registros
	Local _nRegAtu  := 0            // Registro atual da regua de processamento
	Local cDir 		:= Alltrim(MV_PAR05) + "\"
	Local cAssin1 	:= ""
	Local cAssin2 	:= ""
	Local cCargo1 	:= ""
	Local cCargo2 	:= ""

	// Query para buscar as informações
	GetData()

	// Carrega regua de processamento
	Count To _nTotReg
	ProcRegua( _nTotReg )

	(cTmp1)->(DbGoTop())

	While (cTmp1)->(!Eof())

		If nLin > REL_END .or. cVendedor != Alltrim((cTmp1)->E1_VEND2)

			cFileName 	:= "VENDEDOR_"+Alltrim((cTmp1)->E1_VEND2)+"_PERIODO_"+SUBSTRING((cTmp1)->ZS_EMISSAO,1,6)+"_FINR010" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")
			oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
			//oPrint:SetPortrait()//Retrato
			oPrint:SetLandScape()//Paisagem
			oPrint:SetPaperSize(DMPAPER_A4)
			oPrint:cPathPDF := cDir

			ImpProxPag()//Monta cabeçario da primeira e proxima pagina

		EndIf

		nQtd++

		cVendedor  := Alltrim((cTmp1)->E1_VEND2)

		//Usuario responsavel pela assinatura
		If Empty(cUsuario)
			//cUsuario	:= Substr(Embaralha((cTmp1)->ZAG_USERGI,1),3,6)
			cUsuario	:= RetCodUsr()
		EndIf

		// Atualiza regua de processamento
		_nRegAtu++
		IncProc( "Imprimindo Registro " + cValToChar( _nRegAtu ) + " De " + cValToChar( _nTotReg ) + " [" + StrZero( Round( ( _nRegAtu / _nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		//Imprime o detalhe do relatório

		ImpDetalhe()

		(cTmp1)->(DbSkip())

		If cVendedor != Alltrim((cTmp1)->E1_VEND2)

			//ImpressÃ£o dos totalizadores
			oPrint:Say( nLin,780, Transform( nTotCalc, "@E 999,999,999.99"),oFonteN)
			nTotCalc  := 0


			nLin += (REL_VERT_STD*3)

			If !Empty(MV_PAR06) //.and. FWSFALLUSERS(MV_PAR05,.T.)
				oPrint:Say(nLin,458, "_________________________" ,oFonteN)
				aUsuario := FWSFALLUSERS({MV_PAR06}) // Retorna vetor com informações do usuário
				cAssin1 := Alltrim(aUsuario[1][4])
				cCargo1 := Alltrim(aUsuario[1][7])
				nLin += REL_VERT_STD
				oPrint:Say(nLin,458, PADC(cAssin1,40) ,oFonte)
				nLin += REL_VERT_STD
				oPrint:Say(nLin,458, PADC(cCargo1,33) ,oFonteN)
			EndIf

			If !Empty(MV_PAR06) .and. !Empty(MV_PAR07)  //.and. FWSFALLUSERS(MV_PAR06,.T.)
				nLin -= (REL_VERT_STD*2)
				oPrint:Say(nLin,620, "_________________________" ,oFonteN)
				aUsuario := FWSFALLUSERS({MV_PAR07})// Retorna vetor com informações do usuário
				cAssin2 := Alltrim(aUsuario[1][4])
				cCargo2 := Alltrim(aUsuario[1][7])
				nLin += REL_VERT_STD
				oPrint:Say(nLin,620, PADC(cAssin2,40) ,oFonte)
				nLin += REL_VERT_STD
				oPrint:Say(nLin,620, PADC(cCargo2,33) ,oFonteN)
			EndIf

			//Zero o vetor para o proxima praça
			aInfo := {}

			u_PXRODAPE(@oPrint,"FINR010.PRW","")
			oPrint:EndPage()
			oPrint:Preview()

		EndIf

	EndDo

	If nQtd == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","FINR004")
	EndIf

	(cTmp1)->(DbCloseArea())

Return

/*/{Protheus.doc} ImpProxPag
    Imprime cabeçlho da proxima pagina
    @author  Rafael França
    @since   28-08-2020
/*/

Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "DEFINIR SUBTITULO"
	nLin := u_PXCABECA(@oPrint, UPPER("DEFINIR CABEÇALHO") , cSubTitle  , nPag)

	oPrint:Say( nLin,020, "RP"	   			 ,oFonteN)
	oPrint:Say( nLin,052, "NF Rec."			 ,oFonteN)
	oPrint:Say( nLin,084, "Emissao"			 ,oFonteN)
	oPrint:Say( nLin,128, "Receb."  		 ,oFonteN)
	oPrint:Say( nLin,170, "Cliente"			 ,oFonteN)
	oPrint:Say( nLin,340, "Agencia"			 ,oFonteN)
	oPrint:Say( nLin,492, "NF Pag."			 ,oFonteN)
	oPrint:Say( nLin,524, "Emissão"			 ,oFonteN)
	oPrint:Say( nLin,568, "Vencto" 			 ,oFonteN)
	oPrint:Say( nLin,795, "Valor"  			 ,oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_VERT_STD

Return

/*/{Protheus.doc} GetData
    Busca dados no banco
    @author  Rafael França
    @since   24-08-2020
/*/

Static Function GetData()

	// Busca os registros a serem impressos no relatório
	BeginSql Alias cTmp1
		SELECT
			DISTINCT ZS_FILIAL,
			E1_VEND2,
			ZS_NOTAFAT,
			ZS_CODIGO,
			ZS_EMISSAO,
			ZS_VALOR,
			A3_NOME,
			ZS_NUMRP,
			ZS_NOTAFAT,
			E1_EMISSAO,
			E1_BAIXA,
			A1_NOME
		FROM
			%table:SZS% SZS
		INNER JOIN %table:SC5% AS SC5
		ON C5_FILIAL = ZS_FILIAL
			AND C5_NUMRP = ZS_NUMRP
			AND C5_NOTA = ZS_NOTAFAT
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
		INNER JOIN %table:SA3% AS SA3
		ON A3_COD = E1_VEND2
			AND SA3.D_E_L_E_T_ = ''
		WHERE
			E1_VEND2 BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND ZS_LIBERAD = 'L'
			AND ZS_EMISSAO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND ZS_TIPO = '22'
			AND SZS.D_E_L_E_T_ = ''
		ORDER BY
			1,
			2,
			3
	EndSql

Return

/*/{Protheus.doc} ValidPerg
//TODO Funï¿½ï¿½o que cria as perguntas.
@author Rafael França
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
	aAdd(aRegs,{cPerg,"01","Do Vendedor:" 	,"","","mv_ch01","C",06,00,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","ZA3"})
	aAdd(aRegs,{cPerg,"02","Ate Vendedor:" 	,"","","mv_ch02","C",06,00,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ZA3"})
	aAdd(aRegs,{cPerg,"03","Da Emissao:"	,"","","mv_ch03","D",08,00,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Até Emissao:"	,"","","mv_ch04","D",08,00,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Destino do(s) Arq.:"	,"","","mv_ch05","C",99,00,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Assinatura 1:" 		 	,"","","mv_ch06","C",06,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	aAdd(aRegs,{cPerg,"07","Assinatura 2:"		 	,"","","mv_ch07","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","USR"})



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

/*/{Protheus.doc} ImpDetalhe
//Função responsavel pela impressão do detalhe
@author Rafael França
@since 22/10/2020
@version 1.0
@return ${return}, ${return_description}
@param cPerg, characters, descricao
@type function
/*/

Static Function ImpDetalhe()

	oPrint:Say( nLin,020, (cTmp1)->ZAG_NUMRP			  					  ,oFonte)
	oPrint:Say( nLin,052, (cTmp1)->F2_DOC				  					  ,oFonte)
	oPrint:Say( nLin,084, DTOC(STOD((cTmp1)->F2_EMISSAO)) 					  ,oFonte)
	oPrint:Say( nLin,128, DTOC(STOD((cTmp1)->E1_BAIXA)) 					  ,oFonte)

	If Empty(SUBSTR((cTmp1)->ZAH_CLIENT,35,1))
		oPrint:Say( nLin,170, Substring((cTmp1)->ZAH_CLIENT,1,35)	    	  ,oFonte)
	Else
		oPrint:Say(nLin,170, SUBSTR((cTmp1)->ZAH_CLIENT,1,34) + "."			  ,oFonte)
	EndIf

	If Empty(SUBSTR((cTmp1)->ZAH_AGENCI,25,1))
		oPrint:Say( nLin,340, Substring((cTmp1)->ZAH_AGENCI,1,25)			  ,oFonte)
	Else
		oPrint:Say(nLin,340, SUBSTR((cTmp1)->ZAH_CLIENT,1,24) + "."			  ,oFonte)
	EndIf

	oPrint:Say( nLin,492, (cTmp1)->E2_NUM				  					  ,oFonte)
	oPrint:Say( nLin,524, DTOC(STOD((cTmp1)->E2_EMISSAO)) 					  ,oFonte)
	oPrint:Say( nLin,568, DTOC(STOD((cTmp1)->E2_VENCTO)) 					  ,oFonte)
	oPrint:Say( nLin,780, Transform( (cTmp1)->E2_VALOR, "@E 999,999,999.99"),oFonte)

	nLin += REL_VERT_STD

	nTotCalc 	+= (cTmp1)->ZS_VALOR


	If nLin > REL_END
		oPrint:EndPage()
		ImpProxPag()//Monta cabeçario da proxima pagina
	EndIf

Return
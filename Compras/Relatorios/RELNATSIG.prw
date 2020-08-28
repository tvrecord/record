#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELNATSIG   º Autor ³ RAFAEL FRANÇA      º Data ³  04/02/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CONTROLE DE PEDIDOS/AUTORIZAÇOES POR CONTA SIG             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELNATSIG

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := ""
	Local cPict         := ""
	Local titulo       	:= "PEDIDOS POR CONTA SIG"
	Local nLin         	:= 80
	Local Cabec1       	:= " Pedido   Tp  Emissao     Fornece Lj  Nome                                 Descrição                                                                                              Orçado Liberado   Data               Valor"
	Local Cabec2       	:= "                                                                           Continuação"
	Local imprime      	:= .T.
	Local aOrd 			:= {}

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "RELNATSIG"
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cPerg       := "RELNATS2"
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "RELNATSIG"
	Private cString 	:= "SC7"

	dbSelectArea("SC7")
	dbSetOrder(1)

	ValidPerg()

	Pergunte(cPerg,.T.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local aPedidos	:= {}
	Local aPedidosF	:= {}
	Local nVlr		:= 0
	Local cQuery	:= ""
	Local cSIG		:= ""
	Local nSIG		:= 0
	Local nTotal	:= 0
	Local lOk		:= .F.
	Local cCampo	:= "ZY_MES" + MV_PAR03
	Local cMemo		:= ""
	Local nAprov    := 0
	Local nBApro	:= 0
	Local cAprov	:= ""
	Local nOrcSig	:= 0
	Local nAprovF    := 0
	Local nBAproF	:= 0
	Local cAprovF	:= ""
	Local nOrcSigF	:= 0
	Local cSIGF		:= ""
	Local nSIGF		:= 0
	Local nTotalF	:= 0

	If AllTrim(Substring(cUsuario,7,15)) $ "Luciano Ribeiro%Eleni Caldeira (Elenn)%Adauto Pereira%bruno alves%Claudinei Girotti%Josiel Ferreira%Wagner Lima%Artur Fernandes Dias Junior%"

		MV_PAR04 := SUBSTR(DTOS(dDatabase),1,4)
		MV_PAR03 := SUBSTR(DTOS(dDatabase),5,2)
		MV_PAR01 := ""
		MV_PAR02 := "ZZZZZZZZZZZ"
		MV_PAR07 := ""
		MV_PAR08 := "ZZZZZZZZZZZ"

		cCampo   := "ZY_MES" + MV_PAR03

		DBSelectArea("SC7")
		DBSetOrder(1)
		If DBSeek(ALLTRIM(xFilial("SCR")) + ALLTRIM(SCR->CR_NUM))
			iF SC7->C7_TIPO == 1
				MV_PAR05 := Posicione("SC1",6,xFilial("SCR") + ALLTRIM(SCR->CR_NUM),"C1_NATUREZ")
				MV_PAR06 := Posicione("SC1",6,xFilial("SCR") + ALLTRIM(SCR->CR_NUM),"C1_NATUREZ")
			Else
				MV_PAR05 := Posicione("SC3",1,xFilial("SCR") + C7_NUMSC + C7_ITEMSC,"C3_NATUREZ")
				MV_PAR06 := Posicione("SC3",1,xFilial("SCR") + C7_NUMSC + C7_ITEMSC,"C3_NATUREZ")
			Endif

		EndIf
	Endif

	IF MV_PAR12 == 1 //Query estoque

		cQuery := "SELECT D3_COD,SUM(D3_QUANT) AS D3_QUANT, B1_DESC,SUM(D3_CUSTO1) AS CUSTO,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI, "
		cQuery += "ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
		cQuery += "FROM SD3010 "
		cQuery += "INNER JOIN SB1010 ON "
		cQuery += "B1_COD = D3_COD "
		cQuery += "INNER JOIN CT1010 ON "
		cQuery += "B1_CONTA = CT1_CONTA "
		cQuery += "INNER JOIN SZY010 ON "
		cQuery += "ZY_CODIGO = CT1_SIG AND "
		cQuery += "ZY_ANO = '" + (MV_PAR04) + "' "
		cQuery += "WHERE "
		cQuery += "SZY010.D_E_L_E_T_ <> '*' AND "
		cQuery += "CT1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SD3010.D_E_L_E_T_ <> '*' AND "
		cQuery += "D3_ESTORNO = '' AND "
		cQuery += "D3_TM NOT IN ('998','498') AND "
		cQuery += "D3_TM > '500' AND "
		cQuery += "D3_CF <> 'RE4' AND " //Retira as transferencias
		cQuery += "CT1_SIG BETWEEN '" + (MV_PAR05) + "' AND  '" + (MV_PAR06) + "' AND "//CT1_SIG < '19999' AND "  Tira o controle por semestre
		cQuery += "D3_COD BETWEEN '" + (MV_PAR01) + "' AND  '" + (MV_PAR02) + "' AND "
		cQuery += "D3_EMISSAO BETWEEN '" + (MV_PAR04) + (MV_PAR03) + "01" + "' AND '" + (MV_PAR04) + (MV_PAR03) + "31" + "' "
		cQuery += "GROUP BY D3_COD,B1_DESC,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI,ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
		//cQuery += "ORDER BY CT1_SIG "

		/*
		cQuery += "UNION  "  //Separa o bloco investimento como semestral

		cQuery += "SELECT D3_COD,SUM(D3_QUANT) AS D3_QUANT, B1_DESC,SUM(D3_CUSTO1) AS CUSTO,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI, "
		cQuery += "ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
		cQuery += "FROM SD3010 "
		cQuery += "INNER JOIN SB1010 ON "
		cQuery += "B1_COD = D3_COD "
		cQuery += "INNER JOIN CT1010 ON "
		cQuery += "B1_CONTA = CT1_CONTA "
		cQuery += "INNER JOIN SZY010 ON "
		cQuery += "ZY_CODIGO = CT1_SIG "
		cQuery += "WHERE "
		cQuery += "SZY010.D_E_L_E_T_ <> '*' AND "
		cQuery += "CT1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SD3010.D_E_L_E_T_ <> '*' AND "
		cQuery += "D3_ESTORNO = '' AND "
		cQuery += "D3_TM > '500' AND "
		cQuery += "D3_CF <> 'RE4' AND " //Retira as transferencias
		cQuery += "CT1_SIG BETWEEN '" + (MV_PAR05) + "' AND  '" + (MV_PAR06) + "' AND CT1_SIG > '19999' AND "
		cQuery += "D3_COD BETWEEN '" + (MV_PAR01) + "' AND  '" + (MV_PAR02) + "' AND "
		IF MV_PAR03 < "07"
		cQuery += "D3_EMISSAO BETWEEN '" + (MV_PAR04) + "0101' AND '" + (MV_PAR04) + "0631' "
		ELSE
		cQuery += "D3_EMISSAO BETWEEN '" + (MV_PAR04) + "0701' AND '" + (MV_PAR04) + "1231' "
		ENDIF
		cQuery += "GROUP BY D3_COD,B1_DESC,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI,ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
		cQuery += "ORDER BY CT1_SIG "
		*/

		TcQuery cQuery New Alias "TMP"


		dbSelectArea("TMP")

		SetRegua(RecCount())

		dbGoTop()
		While !EOF()

			aAdd(aPedidos,{TMP->CT1_SIG,TMP->D3_COD,"AM","",TMP->B1_DESC,"","",TMP->B1_CONTA,TMP->CT1_DESC01,TMP->D3_QUANT,"","L",TMP->CUSTO})
			//aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM})
			dbSkip()

		EndDo

		dbSelectArea("TMP")
		dbCloseArea("TMP")

	ENDIF

	cQuery := " SELECT ED_CONTSIG AS SIG1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
	//	cQuery += " ,'PC' AS TIPO,C7_PRODUTO AS PRODUTO,C7_DESCRI AS DESCRI,C7_QUANT AS QTD,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR "
	cQuery += " ,'PC' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,C7_CONAPRO AS LIBERADO "
	cQuery += " ,(SELECT MAX(CR_DATALIB) FROM SCR010 WHERE CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '') AS LIBERACAO "
	cQuery += " ,SUM(C7_TOTAL + C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR " //AGRUPADO POR PEDIDO
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL "
	//cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER = '000192' AND CR_TIPO = 'PC' "
	cQuery += " INNER JOIN SED010 ON C1_NATUREZ = ED_CODIGO "
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 "
	cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES
	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) <= '" + MV_PAR04 + MV_PAR03 + "' "
	//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND C7_RESIDUO <> 'S' "
	cQuery += " AND C7_ENCER = '' "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' "
	//cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "
	cQuery += " GROUP BY ED_CONTSIG,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,C7_CONAPRO " //AGRUPADO POR PEDIDO
	cQuery += " UNION "
	cQuery += " SELECT ED_CONTSIG AS SIG1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
	cQuery += " ,'AE' AS TIPO,C7_PRODUTO AS PRODUTO,C3_OBS AS DESCRI,C7_QUANT AS QTD,C7_CONAPRO AS LIBERADO "
	cQuery += " ,CR_DATALIB AS LIBERACAO "
	cQuery += " ,(C7_TOTAL + C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR "
	//	cQuery += " ,'AE' AS TIPO,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR " //AGRUPADO POR AP
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC3010 ON C7_NUMSC = C3_NUM AND C7_ITEMSC = C3_ITEM AND C7_FILIAL = C3_FILIAL "
	cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER = '000002' AND CR_TIPO = 'AE'  "
	cQuery += " INNER JOIN SED010 ON C3_NATUREZ = ED_CODIGO "
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND C7_TIPO = 2 "
	cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES
	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) <= '" + MV_PAR04 + MV_PAR03 + "' "
	//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND C7_RESIDUO <> 'S' "
	cQuery += " AND C7_ENCER = '' "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' "
	cQuery += " AND SC3010.D_E_L_E_T_ = '' "
	cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "
	//	cQuery += " GROUP BY C3_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'AE' "//AGRUPADO POR PEDIDO
	cQuery += " UNION "
	cQuery += " SELECT ED_CONTSIG AS SIG1,ZS_CODIGO AS NUM,ZS_EMISSAO AS EMISSAO,ZS_FORNECE AS FORNECE,ZS_LOJA AS LOJA,ZS_NOME AS NOMEFOR "
	//	cQuery += " ,'AP' AS TIPO,'AUTORIZACAO DE PAGAMENTO' AS PRODUTO,'' AS DESCRI,0 AS QTD,ZS_VALOR AS VALOR "
	cQuery += " ,'AP' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,'L' AS LIBERADO,ZS_DTLIB AS LIBERACAO,ZS_VALOR AS VALOR "	//AGRUPADO POR PEDIDO
	cQuery += " FROM SZS010 "
	cQuery += " INNER JOIN SED010 ON ZS_NATUREZ = ED_CODIGO "
	cQuery += " WHERE SZS010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
	cQuery += " AND SUBSTRING(ZS_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND ZS_TIPO <> '21' "
	cQuery += " AND ZS_LIBERAD <> 'B' "
	cQuery += " AND ZS_CONTRAT <> '1' "
	cQuery += " AND ZS_ATUEST <> '1' "
	cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND ZS_CODIGO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND ZS_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND ZS_CODIGO NOT IN (SELECT D1_AUTORIZ FROM SD1010 WHERE D1_AUTORIZ <> '' AND D_E_L_E_T_ = '')
	cQuery += " ORDER BY SIG1,TIPO,EMISSAO "


	TcQuery cQuery New Alias "TMP1"

	dbSelectArea("TMP1")

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP1")
		dbCloseArea("TMP1")
		Return
	Endif

	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		IF !(TMP1->TIPO == "PC" .AND. (!EMPTY(TMP1->LIBERACAO) .AND. SUBSTR(TMP1->LIBERACAO,1,6) < (MV_PAR04+MV_PAR03)))
			//ELSE
			IF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "B"
				aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,"",TMP1->VALOR,TMP1->NUM})
			ELSE
				aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM})
				//aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->VALOR})
			ENDIF

		ENDIF

		dbSkip()

	EndDo


	dbSelectArea("TMP1")
	dbCloseArea("TMP1")

	cQuery := " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
	cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
	cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
	cQuery += " FROM SD1010 "
	cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
	//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
	cQuery += " INNER JOIN CT1010 ON D1_CONTA = CT1_CONTA "
	cQuery += " WHERE F4_ESTOQUE = 'N' AND "
	cQuery += " SA2010.D_E_L_E_T_ = '' AND "
	cQuery += " SD1010.D_E_L_E_T_ = '' AND "
	cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
	//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
	cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
	cQuery += " F4_CTBDESP = '2' AND "
	cQuery += " D1_FILIAL = '01' AND "
	cQuery += " D1_DOC <> '" + MV_PAR13 + "' AND " //Remove exceções, colocado a pedido da Sra. Simone dia 04/05/17 - Rafael
	//cQuery += " EV_FILIAL = '01' AND "
	cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "//CT1_SIG < '19999' AND " Rafael - Tira as contas semestrais
	cQuery += " SUBSTRING(D1_DTDIGIT,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " GROUP BY CT1_SIG,D1_DOC,D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
	cQuery += " D1_COD,D1_DESCRI,D1_QUANT "
	cQuery += " UNION "
	cQuery += " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
	cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
	cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
	cQuery += " FROM SD1010 "
	cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
	//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
	cQuery += " INNER JOIN CT1010 ON F4_CCONTA = CT1_CONTA "
	cQuery += " WHERE F4_ESTOQUE = 'N' AND "
	cQuery += " SA2010.D_E_L_E_T_ = '' AND "
	cQuery += " SD1010.D_E_L_E_T_ = '' AND "
	cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
	//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
	cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
	cQuery += " F4_CTBDESP = '1' AND "
	cQuery += " D1_FILIAL = '01' AND "
	cQuery += " D1_DOC <> '" + MV_PAR13 + "' AND " //Remove exceções, colocado a pedido da Sra. Simone dia 04/05/17 - Rafael
	//cQuery += " EV_FILIAL = '01' AND "
	cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "//CT1_SIG < '19999' AND " Tira o controle por semestre
	cQuery += " SUBSTRING(D1_DTDIGIT,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " GROUP BY CT1_SIG,D1_DOC,D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
	cQuery += " D1_COD,D1_DESCRI,D1_QUANT "
	cQuery += " ORDER BY SIG1,EMISSAO,TIPO "

	/*

	cQuery += " UNION " // separa notas semestrais

	cQuery := " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
	cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
	cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
	cQuery += " FROM SD1010 "
	cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
	//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
	cQuery += " INNER JOIN CT1010 ON D1_CONTA = CT1_CONTA "
	cQuery += " WHERE F4_ESTOQUE = 'N' AND "
	cQuery += " SD1010.D_E_L_E_T_ = '' AND "
	cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
	//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
	cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
	cQuery += " F4_CTBDESP = '2' AND "
	cQuery += " D1_FILIAL = '01' AND "
	//cQuery += " EV_FILIAL = '01' AND "
	cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND CT1_SIG > '19999' AND "
	IF MV_PAR03 < "07"
	cQuery += " SUBSTR(D1_DTDIGIT,1,6) BETWEEN '" + MV_PAR04 + "01' AND '" + MV_PAR04 + "06' "
	ELSE
	cQuery += " SUBSTR(D1_DTDIGIT,1,6) BETWEEN '" + MV_PAR04 + "07' AND '" + MV_PAR04 + "12' "
	ENDIF
	cQuery += " GROUP BY CT1_SIG,D1_DOC,'NF',D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
	cQuery += " D1_COD,D1_DESCRI,D1_QUANT,'' "
	cQuery += " UNION "
	cQuery += " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
	cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
	cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
	cQuery += " FROM SD1010 "
	cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
	//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
	cQuery += " INNER JOIN CT1010 ON F4_CCONTA = CT1_CONTA "
	cQuery += " WHERE F4_ESTOQUE = 'N' AND "
	cQuery += " SD1010.D_E_L_E_T_ = '' AND "
	cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
	//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
	cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
	cQuery += " F4_CTBDESP = '1' AND "
	cQuery += " D1_FILIAL = '01' AND "
	//cQuery += " EV_FILIAL = '01' AND "
	cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND CT1_SIG > '19999' AND "
	IF MV_PAR03 < "07"
	cQuery += " SUBSTR(D1_DTDIGIT,1,6) BETWEEN '" + MV_PAR04 + "01' AND '" + MV_PAR04 + "06' "
	ELSE
	cQuery += " SUBSTR(D1_DTDIGIT,1,6) BETWEEN '" + MV_PAR04 + "07' AND '" + MV_PAR04 + "12' "
	ENDIF
	cQuery += " GROUP BY CT1_SIG,D1_DOC,'NF',D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
	cQuery += " D1_COD,D1_DESCRI,D1_QUANT,'' "
	cQuery += " ORDER BY SIG1,EMISSAO,TIPO "

	*/

	TcQuery cQuery New Alias "TMP2"

	dbSelectArea("TMP2")

	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

		aAdd(aPedidos,{TMP2->SIG1,TMP2->NUM,TMP2->TIPO,TMP2->EMISSAO,TMP2->FORNECE,TMP2->LOJA,TMP2->NOMEFOR,TMP2->PRODUTO,TMP2->DESCRI,TMP2->QTD,TMP2->LIBERADO,"L",TMP2->VALOR,TMP2->PEDIDO})

		dbSkip()

	EndDo


	dbSelectArea("TMP2")
	dbCloseArea("TMP2")

	ASORT(aPedidos,,,{|x,y|x[1]+x[3]+x[4]+x[2] < y[1]+y[3]+y[4]+y[2]})

	nLin 	+= 1
	@nLin,001 PSAY "CONTROLE SIG"
	nLin    += 2

	For _I := 1 To Len(aPedidos)

		IF STOD(aPedidos[_I,4]) <= MV_PAR10 .OR. EMPTY(MV_PAR10)

			IF !(aPedidos[_I,3] == "PC" .AND. ALLTRIM(aPedidos[_I,2]) <> MV_PAR11 .AND. (ALLTRIM(aPedidos[_I,1]) == "10007" .OR. ALLTRIM(aPedidos[_I,1]) == "08005")) //Rafael - Filtra apenas os pedido corrente na conta SIG 10008 e 8005 solicitado pela Srta Janaina e aprovado pela Sra Elenn // Wesley - Alterado conta 10008 para 10007 para o novo plano conta sig de 2020


				IF  	!EMPTY(aPedidos[_I,12]) .AND. aPedidos[_I,3] <> "AM"
					cAprov	:= "SIM"
				ELSEIF  EMPTY(aPedidos[_I,12]) .AND. aPedidos[_I,3] <> "AM"
					cAprov	:= "NÃO"
				ELSEIF  !EMPTY(aPedidos[_I,12]) .AND. aPedidos[_I,3] == "AM"
					cAprov	:= "SIM"
				ENDIF

				IF ALLTRIM(aPedidos[_I,2]) $ "017889%017888%017887%017880%017879%017885%017884%017886%017898%017899" .AND. ALLTRIM(aPedidos[_I,2]) <> MV_PAR11

					cAprov	:= "INFORMATIVO"

				ENDIF

				/*

				IF cSIG > '19999' //Calculo semestral

				IF MV_PAR03 < "07"
				cQuery := "SELECT ZY_CODIGO,(ZY_MES01+ZY_MES02+ZY_MES03+ZY_MES04+ZY_MES05+ZY_MES06) AS SEMESTRE "
				ELSE
				cQuery := "SELECT ZY_CODIGO,(ZY_MES07+ZY_MES08+ZY_MES09+ZY_MES10+ZY_MES11+ZY_MES12) AS SEMESTRE "
				ENDIF

				cQuery += "FROM SZY010 "
				cQuery += "WHERE D_E_L_E_T_ = '' AND ZY_CODIGO = '" + cSIG + "'"

				TcQuery cQuery New Alias "TMP3"

				dbSelectArea("TMP3")

				SetRegua(RecCount())

				dbGoTop()
				While !EOF()

				nOrcSig := TMP3->SEMESTRE

				dbSkip()

				ENDDO

				dbSelectArea("TMP3")
				dbCloseArea("TMP3")

				ELSE // Calculo Normal

				*/

				nOrcSig := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIG),6)+MV_PAR04,@cCampo)

				//ENDIF

				If cSIG	!= aPedidos[_I,1] .AND. lOk
					@nLin,001 PSAY REPLICATE("-",LIMITE)
					nLin 	+= 1
					@nLin,001 PSAY "BLOQUEADO --->"
					@nLin,179 PSAY "BLOQUEADO:"
					@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
					nLin 	+= 1
					@nLin,001 PSAY "APROVADO  --->"
					@nLin,095 PSAY "SALDO ATUAL:"
					@nLin,125 PSAY (nOrcSig - nAprov) PICTURE "@E 999,999,999.99"
					@nLin,179 PSAY "APROVADO:"
					@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
					nLin 	+= 1
					//		@nLin,001 PSAY "TOTAL"
					//IF cSIG < "19999"
					@nLin,001 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIG),6)+MV_PAR04,"ZY_DESCRI")
					//ELSE
					//	@nLin,001 PSAY SUBSTR(Posicione("SZY",1,xFilial("SZY")+cSIG,"ZY_DESCRI"),1,30) + " - SEMESTRE"
					//ENDIF
					@nLin,050 PSAY "VL. ORÇADO:"
					@nLin,065 PSAY nOrcSig PICTURE "@E 999,999,999.99"
					@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
					@nLin,125 PSAY (nOrcSig - nSIG) PICTURE "@E 999,999,999.99"
					@nLin,179 PSAY "TOTAL:"
					@nLin,206 PSAY nSIG PICTURE "@E 999,999,999.99"
					nLin 	+= 2
					nAprov  := 0
					nBApro	:= 0
					nSIG	:= 0
				Endif

				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif

				If nLin > 55 // Salto de Página. Neste caso o formulario tem 65 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
					nLin 	+= 1
					@nLin,001 PSAY aPedidos[_I,1]
					@nLin,011 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(aPedidos[_I,1]),6)+MV_PAR04,"ZY_DESCRI")
					@nLin,150 PSAY "(Continuação)"
					nLin 	+= 1
					@nLin,001 PSAY REPLICATE("-",LIMITE)
					nLin 	+= 1
				Endif

				If cSIG	!= aPedidos[_I,1]  .AND. !EMPTY(aPedidos[_I,1])
					nLin 	+= 1
					@nLin,001 PSAY aPedidos[_I,1]
					//IF cSIG < "19999"
					@nLin,011 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(aPedidos[_I,1]),6)+MV_PAR04,"ZY_DESCRI")
					//ELSE
					//	@nLin,011 PSAY ALLTRIM(Posicione("SZY",1,xFilial("SZY")+aPedidos[_I,1],"ZY_DESCRI")) + " - SEMESTRE"
					//ENDIF
					nLin 	+= 1
					@nLin,001 PSAY REPLICATE("-",LIMITE)
					nLin 	+= 1
				ELSEIF EMPTY(aPedidos[_I,1]) .AND. cSIG == ""
					nLin 	+= 1
					@nLin,001 PSAY "00000"
					@nLin,011 PSAY "SEM CONTA SIG"
					nLin 	+= 1
					@nLin,001 PSAY REPLICATE("-",LIMITE)
					nLin 	+= 1
				Endif

				@nLin,001 PSAY ALLTRIM(aPedidos[_I,2])		//PEDIDO
				@nLin,010 PSAY aPedidos[_I,3]				//TIPO
				IF aPedidos[_I,3] <> "AM"
					@nLin,014 PSAY STOD(aPedidos[_I,4])			//EMISSAO
					@nLin,026 PSAY aPedidos[_I,5] 				//COD FORNECE
					@nLin,034 PSAY aPedidos[_I,6]  				//LOJA
					@nLin,038 PSAY SUBSTR(aPedidos[_I,7],1,34)  //NOME
					IF aPedidos[_I,3] == "PC"
						IF Posicione("SZL",3,xFilial("SZL") + aPedidos[_I,2],"ZL_PEDORC") == "1"
							@nLin,178 PSAY "ORÇADO"
						ELSE
							@nLin,178 PSAY "NÃO ORÇADO"
						ENDIF
					ELSEIF aPedidos[_I,3] == "AE"
						@nLin,178 PSAY "ORÇADO"
					ENDIF
					@nLin,189 PSAY cAprov						//LIBERADO
					@nLin,193 PSAY STOD(aPedidos[_I,12]) 		//DT LIBERAÇÃO
					@nLin,206 PSAY aPedidos[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
				ELSE
					//IF cSig < "19999"
					@nLin,017 PSAY (MV_PAR03) + "/" + (MV_PAR04)
					//ELSE
					//	IF MV_PAR03 < "07"
					//		@nLin,014 PSAY "1 SEM 2014"
					//	ELSE
					//		@nLin,014 PSAY "2 SEM 2014"
					//	ENDIF
					//ENDIF
					@nLin,026 PSAY aPedidos[_I,5]
					@nLin,038 PSAY "                         "  //NOME
					@nLin,189 PSAY cAprov				    	//LIBERADO
					@nLin,194 PSAY STOD(aPedidos[_I,12]) 		//DT LIBERAÇÃO
					@nLin,207 PSAY aPedidos[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
				ENDIF

				IF aPedidos[_I,3] == "AE"
					//@nLin,075 PSAY ALLTRIM(aPedidos[_I,8])    	//PRODUTO
					@nLin,076 PSAY SUBSTR(aPedidos[_I,9],1,80)  //DESCRI PRODUTO
					//@nLin,137 PSAY aPedidos[_I,10] PICTURE "@E 999"			//QUANTIDADE
				ELSEIF aPedidos[_I,3] == "PC"
					dbSelectArea ("SZL")
					dbSetOrder(2)
					IF DbSeek(xFilial("SZL") + aPedidos[_I,2])
						cMemo := MemoLine(ZL_OBS1,100,1)
						@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
						IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,101,100)))
							cMemo := MemoLine(ZL_OBS1,100,2)
							nLin 	+= 1
							@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,201,100)))
								cMemo := MemoLine(ZL_OBS1,100,3)
								nLin 	+= 1
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							ENDIF
						ENDIF
						IF !EMPTY(ALLTRIM(SUBSTR(ZL_EXCLUSI,001,100)))
							cMemo := MemoLine(ZL_EXCLUSI,100,1)
							nLin 	+= 1
							@nLin,001 PSAY "MOTIVO FORNECEDOR EXCLUSIVO:"
							@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							IF !EMPTY(ALLTRIM(SUBSTR(ZL_EXCLUSI,101,100)))
								cMemo := MemoLine(ZL_EXCLUSI,100,2)
								nLin 	+= 1
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,201,100)))
									cMemo := MemoLine(ZL_OBS1,100,3)
									nLin 	+= 1
									@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ELSEIF aPedidos[_I,3] == "AP"
					dbSelectArea ("SZS")
					dbSetOrder(1)
					IF DbSeek(xFilial("SZS") + aPedidos[_I,2])
						cMemo := MemoLine(ZS_HISTORI,100,1)
						@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
						IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,101,100)))
							nLin 	+= 1
							cMemo 	:= MemoLine(ZS_HISTORI,100,2)
							@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,201,100)))
								nLin 	+= 1
								cMemo 	:= MemoLine(ZS_HISTORI,100,3)
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							ENDIF
						ENDIF
					ENDIF
				ELSEIF aPedidos[_I,3] == "NF"
					@nLin,076 PSAY ALLTRIM(aPedidos[_I,8])    	//PRODUTO
					@nLin,085 PSAY SUBSTR(aPedidos[_I,9],1,80)  //DESCRIÇÃO
				ELSEIF aPedidos[_I,3] == "AM"
					@nLin,076 PSAY ALLTRIM(aPedidos[_I,8])    	//PRODUTO
					@nLin,087 PSAY SUBSTR(aPedidos[_I,9],1,78)  //DESCRIÇÃO
				ENDIF

				lOk 	:= .T.
				cSIG	:= aPedidos[_I,1]
				IF ALLTRIM(aPedidos[_I,2]) $ "017889%017888%017887%017880%017879%017885%017884%017886%017898%017899" .AND. ALLTRIM(aPedidos[_I,2]) <> MV_PAR11

				ELSE

					IF  	!EMPTY(aPedidos[_I,12])
						nAprov  += aPedidos[_I,13]
					ELSEIF  EMPTY(aPedidos[_I,12])
						nBApro	+= aPedidos[_I,13]
					ENDIF
					nSIG	+= aPedidos[_I,13]
					nTotal	+= aPedidos[_I,13]

				ENDIF

				nLin 	+= 1 // Avanca a linha de impressao

			ENDIF

		ENDIF

	Next _I

	/*

	IF cSIG > '19999' //Calculo semestral

	IF MV_PAR03 < "07"
	cQuery := "SELECT ZY_CODIGO,(ZY_MES01+ZY_MES02+ZY_MES03+ZY_MES04+ZY_MES05+ZY_MES06) AS SEMESTRE "
	ELSE
	cQuery := "SELECT ZY_CODIGO,(ZY_MES07+ZY_MES08+ZY_MES09+ZY_MES10+ZY_MES11+ZY_MES12) AS SEMESTRE "
	ENDIF

	cQuery += "FROM SZY010 "
	cQuery += "WHERE D_E_L_E_T_ = '' AND ZY_CODIGO = '" + cSIG + "'"

	TcQuery cQuery New Alias "TMP3"

	dbSelectArea("TMP3")

	SetRegua(RecCount())

	dbGoTop()
	While !EOF()

	nOrcSig := TMP3->SEMESTRE

	dbSkip()

	ENDDO

	dbSelectArea("TMP3")
	dbCloseArea("TMP3")

	ELSE // Calculo Normal

	*/
	nOrcSig := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIG),6)+MV_PAR04,@cCampo)

	//ENDIF

	@nLin,001 PSAY REPLICATE("-",LIMITE)
	nLin 	+= 1
	@nLin,001 PSAY "BLOQUEADO --->"
	@nLin,179 PSAY "BLOQUEADO:"
	@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
	nLin 	+= 1
	@nLin,001 PSAY "APROVADO  --->"
	@nLin,095 PSAY "SALDO ATUAL:"
	@nLin,125 PSAY (nOrcSig - nAprov) PICTURE "@E 999,999,999.99"
	@nLin,179 PSAY "APROVADO:"
	@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
	nLin 	+= 1
	//		@nLin,001 PSAY "TOTAL"
	//IF cSIG < "19999"
	@nLin,001 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIG),6)+MV_PAR04,"ZY_DESCRI")
	//ELSE
	//	@nLin,001 PSAY SUBSTR(Posicione("SZY",1,xFilial("SZY")+cSIG,"ZY_DESCRI"),1,30) + " - SEMESTRE"
	//ENDIF

	@nLin,050 PSAY "VL. ORÇADO:"
	@nLin,065 PSAY nOrcSig PICTURE "@E 999,999,999.99"
	@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
	@nLin,125 PSAY (nOrcSig - nSIG) PICTURE "@E 999,999,999.99"
	@nLin,179 PSAY "TOTAL:"
	@nLin,206 PSAY nSIG PICTURE "@E 999,999,999.99"
	nLin 	+= 2
	nAprov  := 0
	nBApro	:= 0
	nSIG	:= 0
	nLin 	+= 2
	@nLin,001 PSAY "Legenda: AM = Almoxarifado (Saidas Estoque)   |   NF = Nota Fiscal   |   PC = Pedido de Compras   |   AE = Autorização de Entrega   |   AP = Autorização de pagamento"
	//@nLin,206 PSAY nTotal PICTURE "@E 999,999,999.99"

	IF MV_PAR14 == 1

		lOk		:= .F.
		nLin 	+= 2

		@nLin,001 PSAY "CONTROLE FINANCEIRO"
		nLin += 1

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 65 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		cQuery := " SELECT ED_CONTSIG AS SIG1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
		cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
		//	cQuery += " ,'PC' AS TIPO,C7_PRODUTO AS PRODUTO,C7_DESCRI AS DESCRI,C7_QUANT AS QTD,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR "
		cQuery += " ,'PC' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,C7_CONAPRO AS LIBERADO "
		cQuery += " ,(SELECT MAX(CR_DATALIB) FROM SCR010 WHERE CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '') AS LIBERACAO "
		cQuery += " ,SUM(C7_TOTAL + C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR " //AGRUPADO POR PEDIDO
		cQuery += " FROM SC7010 "
		cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
		cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL "
		//cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER = '000192' AND CR_TIPO = 'PC' "
		cQuery += " INNER JOIN SED010 ON C1_NATUREZ = ED_CODIGO "
		cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 "
		cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES
		cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) <= '" + MV_PAR04 + MV_PAR03 + "' "
		//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
		cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
		cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
		cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
		cQuery += " AND C7_RESIDUO <> 'S' "
		cQuery += " AND C7_ENCER = '' "
		cQuery += " AND SA2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
		//cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "
		cQuery += " GROUP BY ED_CONTSIG,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,C7_CONAPRO " //AGRUPADO POR PEDIDO
		cQuery += " UNION "
		cQuery += " SELECT ED_CONTSIG AS SIG1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
		cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
		cQuery += " ,'AE' AS TIPO,C7_PRODUTO AS PRODUTO,C3_OBS AS DESCRI,C7_QUANT AS QTD,C7_CONAPRO AS LIBERADO "
		cQuery += " ,CR_DATALIB AS LIBERACAO "
		cQuery += " ,(C7_TOTAL + C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR "
		//	cQuery += " ,'AE' AS TIPO,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR " //AGRUPADO POR AP
		cQuery += " FROM SC7010 "
		cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
		cQuery += " INNER JOIN SC3010 ON C7_NUMSC = C3_NUM AND C7_ITEMSC = C3_ITEM AND C7_FILIAL = C3_FILIAL "
		cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER = '000002' AND CR_TIPO = 'AE'  "
		cQuery += " INNER JOIN SED010 ON C3_NATUREZ = ED_CODIGO "
		cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND C7_TIPO = 2 "
		cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES
		cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) <= '" + MV_PAR04 + MV_PAR03 + "' "
		//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
		cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
		cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
		cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
		cQuery += " AND C7_RESIDUO <> 'S' "
		cQuery += " AND C7_ENCER = '' "
		cQuery += " AND SA2010.D_E_L_E_T_ = '' "
		cQuery += " AND SC3010.D_E_L_E_T_ = '' "
		cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "
		//	cQuery += " GROUP BY C3_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'AE' "//AGRUPADO POR PEDIDO
		cQuery += " UNION "
		cQuery += " SELECT ED_CONTSIG AS SIG1,ZS_CODIGO AS NUM,ZS_EMISSAO AS EMISSAO,ZS_FORNECE AS FORNECE,ZS_LOJA AS LOJA,ZS_NOME AS NOMEFOR "
		//	cQuery += " ,'AP' AS TIPO,'AUTORIZACAO DE PAGAMENTO' AS PRODUTO,'' AS DESCRI,0 AS QTD,ZS_VALOR AS VALOR "
		cQuery += " ,'AP' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,'L' AS LIBERADO,ZS_DTLIB AS LIBERACAO,ZS_VALOR AS VALOR "	//AGRUPADO POR PEDIDO
		cQuery += " FROM SZS010 "
		cQuery += " INNER JOIN SED010 ON ZS_NATUREZ = ED_CODIGO "
		cQuery += " WHERE SZS010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
		cQuery += " AND SUBSTRING(ZS_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
		cQuery += " AND ZS_TIPO <> '21' "
		cQuery += " AND ZS_LIBERAD <> 'B' "
		cQuery += " AND ZS_CONTRAT <> '1' "
		//cQuery += " AND ZS_ATUEST <> '1' "
		cQuery += " AND ED_CONTSIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
		cQuery += " AND ZS_CODIGO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
		cQuery += " AND ZS_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
		cQuery += " AND ZS_CODIGO NOT IN (SELECT D1_AUTORIZ FROM SD1010 WHERE D1_AUTORIZ <> '' AND D_E_L_E_T_ = '')
		cQuery += " ORDER BY SIG1,TIPO,EMISSAO "

		TcQuery cQuery New Alias "TMP1"

		dbSelectArea("TMP1")

		If Eof()
			MsgInfo("Nao existem dados a serem impressos!","Verifique")
			dbSelectArea("TMP1")
			dbCloseArea("TMP1")
			Return
		Endif

		//dbSelectArea("TMP1")
		SetRegua(RecCount())

		dbGoTop()
		While !EOF()

			IF !(TMP1->TIPO == "PC" .AND. (!EMPTY(TMP1->LIBERACAO) .AND. SUBSTR(TMP1->LIBERACAO,1,6) < (MV_PAR04+MV_PAR03)))
				IF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "B"
					aAdd(aPedidosF,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,"",TMP1->VALOR,TMP1->NUM})
				ELSE
					aAdd(aPedidosF,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM})
				ENDIF

			ENDIF

			dbSkip()

		EndDo


		dbSelectArea("TMP1")
		dbCloseArea("TMP1")

		cQuery := " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
		cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
		cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
		cQuery += " FROM SD1010 "
		cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
		cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
		//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
		cQuery += " INNER JOIN CT1010 ON D1_CONTA = CT1_CONTA "
		cQuery += " WHERE "//F4_ESTOQUE = 'N' AND "
		cQuery += " SA2010.D_E_L_E_T_ = '' AND "
		cQuery += " SD1010.D_E_L_E_T_ = '' AND "
		cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
		//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
		cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
		//	cQuery += " F4_CTBDESP = '2' AND "
		cQuery += " (F4_CTBDESP = '2' OR F4_CCONTA = '116010001') AND "
		cQuery += " D1_FILIAL = '01' AND "
		cQuery += " D1_DOC <> '" + MV_PAR13 + "' AND " //Remove exceções, colocado a pedido da Sra. Simone dia 04/05/17 - Rafael
		//cQuery += " EV_FILIAL = '01' AND "
		cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "//CT1_SIG < '19999' AND " Rafael - Tira as contas semestrais
		cQuery += " SUBSTRING(D1_DTDIGIT,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
		cQuery += " GROUP BY CT1_SIG,D1_DOC,D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
		cQuery += " D1_COD,D1_DESCRI,D1_QUANT "
		cQuery += " UNION "
		cQuery += " SELECT CT1_SIG AS SIG1,D1_DOC AS NUM,'NF' AS TIPO,D1_SERIE,D1_PEDIDO AS PEDIDO,D1_DTDIGIT AS EMISSAO,D1_TES,F4_ESTOQUE, "
		cQuery += " D1_FORNECE AS FORNECE,D1_LOJA AS LOJA,A2_NOME AS NOMEFOR,D1_COD AS PRODUTO,D1_DESCRI AS DESCRI,D1_QUANT AS QTD,'L' AS LIBERADO, "
		cQuery += " '' AS LIBERACAO,SUM(D1_TOTAL) AS VALOR "
		cQuery += " FROM SD1010 "
		cQuery += " INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
		cQuery += " INNER JOIN SF4010 ON D1_TES = F4_CODIGO "
		//cQuery += " INNER JOIN SEV010 ON D1_DOC = EV_NUM AND D1_SERIE = EV_PREFIXO AND D1_FORNECE = EV_CLIFOR AND D1_LOJA = EV_LOJA "
		cQuery += " INNER JOIN CT1010 ON F4_CCONTA = CT1_CONTA "
		cQuery += " WHERE "//F4_ESTOQUE = 'N' AND "
		cQuery += " SA2010.D_E_L_E_T_ = '' AND "
		cQuery += " SD1010.D_E_L_E_T_ = '' AND "
		cQuery += " SF4010.D_E_L_E_T_ = ''  AND "
		//cQuery += " SEV010.D_E_L_E_T_ = ''  AND "
		cQuery += " CT1010.D_E_L_E_T_ = ''  AND "
		//	cQuery += " F4_CTBDESP = '1' AND "
		cQuery += " (F4_CTBDESP = '1' AND F4_CCONTA <> '116010001') AND "
		cQuery += " D1_FILIAL = '01' AND "
		cQuery += " D1_DOC <> '" + MV_PAR13 + "' AND " //Remove exceções, colocado a pedido da Sra. Simone dia 04/05/17 - Rafael
		//cQuery += " EV_FILIAL = '01' AND "
		cQuery += " CT1_SIG BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "//CT1_SIG < '19999' AND " Tira o controle por semestre
		cQuery += " SUBSTRING(D1_DTDIGIT,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
		cQuery += " GROUP BY CT1_SIG,D1_DOC,D1_SERIE,D1_PEDIDO,D1_DTDIGIT,D1_TES,F4_ESTOQUE,D1_FORNECE,D1_LOJA,A2_NOME, "
		cQuery += " D1_COD,D1_DESCRI,D1_QUANT "
		cQuery += " ORDER BY SIG1,EMISSAO,TIPO "

		TcQuery cQuery New Alias "TMP2"

		dbSelectArea("TMP2")

		SetRegua(RecCount())

		dbGoTop()
		While !EOF()

			aAdd(aPedidosF,{TMP2->SIG1,TMP2->NUM,TMP2->TIPO,TMP2->EMISSAO,TMP2->FORNECE,TMP2->LOJA,TMP2->NOMEFOR,TMP2->PRODUTO,TMP2->DESCRI,TMP2->QTD,TMP2->LIBERADO,"L",TMP2->VALOR,TMP2->PEDIDO})

			dbSkip()

		EndDo

		dbSelectArea("TMP2")
		dbCloseArea("TMP2")

		ASORT(aPedidosF,,,{|x,y|x[1]+x[3]+x[4]+x[2] < y[1]+y[3]+y[4]+y[2]})

		For _I := 1 To Len(aPedidosF)

			IF STOD(aPedidosF[_I,4]) <= MV_PAR10 .OR. EMPTY(MV_PAR10)

				IF !(aPedidosF[_I,3] == "PC" .AND. ALLTRIM(aPedidosF[_I,2]) <> MV_PAR11 .AND. (ALLTRIM(aPedidosF[_I,1]) == "10008" .OR. ALLTRIM(aPedidosF[_I,1]) == "08005")) //Rafael - Filtra apenas os pedido corrente na conta SIG 10008 e 8005 solicitado pela Srta Janaina e aprovado pela Sra Elenn


					IF  	!EMPTY(aPedidosF[_I,12]) .AND. aPedidosF[_I,3] <> "AM"
						cAprovF	:= "SIM"
					ELSEIF  EMPTY(aPedidosF[_I,12]) .AND. aPedidosF[_I,3] <> "AM"
						cAprovF	:= "NÃO"
					ELSEIF  !EMPTY(aPedidosF[_I,12]) .AND. aPedidosF[_I,3] == "AM"
						cAprovF	:= "SIM"
					ENDIF

					IF ALLTRIM(aPedidosF[_I,2]) $ "017889%017888%017887%017880%017879%017885%017884%017886%017898%017899" .AND. ALLTRIM(aPedidosF[_I,2]) <> MV_PAR11

						cAprovF	:= "INFORMATIVO"

					ENDIF

					nOrcSigF := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIGF),6)+MV_PAR04,@cCampo)


					If cSIGF	!= aPedidosF[_I,1] .AND. lOk
						@nLin,001 PSAY REPLICATE("-",LIMITE)
						nLin 	+= 1
						@nLin,001 PSAY "BLOQUEADO --->"
						@nLin,179 PSAY "BLOQUEADO:"
						@nLin,206 PSAY nBAproF PICTURE "@E 999,999,999.99"
						nLin 	+= 1
						@nLin,001 PSAY "APROVADO  --->"
						@nLin,095 PSAY "SALDO ATUAL:"
						@nLin,125 PSAY (nOrcSigF - nAprovF) PICTURE "@E 999,999,999.99"
						@nLin,179 PSAY "APROVADO:"
						@nLin,206 PSAY nAprovF PICTURE "@E 999,999,999.99"
						nLin 	+= 1
						@nLin,001 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIGF),6)+MV_PAR04,"ZY_DESCRI")
						@nLin,050 PSAY "VL. ORÇADO:"
						@nLin,065 PSAY nOrcSigF PICTURE "@E 999,999,999.99"
						@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
						@nLin,125 PSAY (nOrcSigF - nSIGF) PICTURE "@E 999,999,999.99"
						@nLin,179 PSAY "TOTAL:"
						@nLin,206 PSAY nSIGF PICTURE "@E 999,999,999.99"
						nLin 	+= 2
						nAprovF  := 0
						nBAproF	:= 0
						nSIGF	:= 0
					Endif

					If lAbortPrint
						@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
						Exit
					Endif

					If nLin > 55 // Salto de Página. Neste caso o formulario tem 65 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif

					If cSIGF	!= aPedidosF[_I,1]  .AND. !EMPTY(aPedidosF[_I,1])
						nLin 	+= 1
						@nLin,001 PSAY aPedidosF[_I,1]
						@nLin,011 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(aPedidosF[_I,1]),6)+MV_PAR04,"ZY_DESCRI")
						nLin 	+= 1
						@nLin,001 PSAY REPLICATE("-",LIMITE)
						nLin 	+= 1
					ELSEIF EMPTY(aPedidosF[_I,1]) .AND. cSIGF == ""
						nLin 	+= 1
						@nLin,001 PSAY "00000"
						@nLin,011 PSAY "SEM CONTA SIG"
						nLin 	+= 1
						@nLin,001 PSAY REPLICATE("-",LIMITE)
						nLin 	+= 1
					Endif

					@nLin,001 PSAY ALLTRIM(aPedidosF[_I,2])		//PEDIDO
					@nLin,010 PSAY aPedidosF[_I,3]				//TIPO
					IF aPedidosF[_I,3] <> "AM"
						@nLin,014 PSAY STOD(aPedidosF[_I,4])			//EMISSAO
						@nLin,026 PSAY aPedidosF[_I,5] 				//COD FORNECE
						@nLin,034 PSAY aPedidosF[_I,6]  				//LOJA
						@nLin,038 PSAY SUBSTR(aPedidosF[_I,7],1,34)  //NOME
						IF aPedidosF[_I,3] == "PC"
							IF Posicione("SZL",2,xFilial("SZL") + aPedidosF[_I,2],"ZL_PEDORC") == "1"
								@nLin,178 PSAY "ORÇADO"
							ELSE
								@nLin,178 PSAY "NÃO ORÇADO"
							ENDIF
						ELSEIF aPedidosF[_I,3] == "AE"
							@nLin,178 PSAY "ORÇADO"
						ENDIF
						@nLin,188 PSAY cAprovF						//LIBERADO
						@nLin,193 PSAY STOD(aPedidosF[_I,12]) 		//DT LIBERAÇÃO
						@nLin,206 PSAY aPedidosF[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
					ELSE
						@nLin,017 PSAY (MV_PAR03) + "/" + (MV_PAR04)
						@nLin,026 PSAY aPedidosF[_I,5]
						@nLin,038 PSAY "                         "  //NOME
						@nLin,189 PSAY cAprovF				    	//LIBERADO
						@nLin,194 PSAY STOD(aPedidosF[_I,12]) 		//DT LIBERAÇÃO
						@nLin,207 PSAY aPedidosF[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
					ENDIF

					IF aPedidosF[_I,3] == "AE"
						//@nLin,075 PSAY ALLTRIM(aPedidosF[_I,8])    	//PRODUTO
						@nLin,076 PSAY SUBSTR(aPedidosF[_I,9],1,80)  //DESCRI PRODUTO
						//@nLin,137 PSAY aPedidosF[_I,10] PICTURE "@E 999"			//QUANTIDADE
					ELSEIF aPedidosF[_I,3] == "PC"
						dbSelectArea ("SZL")
						dbSetOrder(2)
						IF DbSeek(xFilial("SZL") + aPedidosF[_I,2])
							cMemo := MemoLine(ZL_OBS1,100,1)
							@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,101,100)))
								cMemo := MemoLine(ZL_OBS1,100,2)
								nLin 	+= 1
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,201,100)))
									cMemo := MemoLine(ZL_OBS1,100,3)
									nLin 	+= 1
									@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								ENDIF
							ENDIF
							IF !EMPTY(ALLTRIM(SUBSTR(ZL_EXCLUSI,001,100)))
								cMemo := MemoLine(ZL_EXCLUSI,100,1)
								nLin 	+= 1
								@nLin,001 PSAY "MOTIVO FORNECEDOR EXCLUSIVO:"
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								IF !EMPTY(ALLTRIM(SUBSTR(ZL_EXCLUSI,101,100)))
									cMemo := MemoLine(ZL_EXCLUSI,100,2)
									nLin 	+= 1
									@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								ENDIF
							ENDIF
						ENDIF
					ELSEIF aPedidosF[_I,3] == "AP"
						dbSelectArea ("SZS")
						dbSetOrder(1)
						IF DbSeek(xFilial("SZS") + aPedidosF[_I,2])
							cMemo := MemoLine(ZS_HISTORI,100,1)
							@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
							IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,101,100)))
								nLin 	+= 1
								cMemo 	:= MemoLine(ZS_HISTORI,100,2)
								@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,201,100)))
									nLin 	+= 1
									cMemo 	:= MemoLine(ZS_HISTORI,100,3)
									@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
								ENDIF
							ENDIF
						ENDIF
					ELSEIF aPedidosF[_I,3] == "NF"
						@nLin,076 PSAY ALLTRIM(aPedidosF[_I,8])    	//PRODUTO
						@nLin,085 PSAY SUBSTR(aPedidosF[_I,9],1,80)  //DESCRIÇÃO
					ELSEIF aPedidosF[_I,3] == "AM"
						@nLin,076 PSAY ALLTRIM(aPedidosF[_I,8])    	//PRODUTO
						@nLin,087 PSAY SUBSTR(aPedidosF[_I,9],1,78)  //DESCRIÇÃO
					ENDIF

					lOk 	:= .T.
					cSIGF	:= aPedidosF[_I,1]

					IF ALLTRIM(aPedidosF[_I,2]) $ "017889%017888%017887%017880%017879%017885%017884%017886%017898%017899" .AND. ALLTRIM(aPedidosF[_I,2]) <> MV_PAR11

					ELSE

						IF  	!EMPTY(aPedidosF[_I,12])
							nAprovF  += aPedidosF[_I,13]
						ELSEIF  EMPTY(aPedidosF[_I,12])
							nBAproF	+= aPedidosF[_I,13]
						ENDIF
						nSIGF	+= aPedidosF[_I,13]
						nTotalF	+= aPedidosF[_I,13]

					ENDIF

					nLin 	+= 1 // Avanca a linha de impressao

				ENDIF

			ENDIF

		Next _I

		nOrcSigF := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIGF),6)+MV_PAR04,@cCampo)


		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
		@nLin,001 PSAY Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cSIGF),6)+MV_PAR04,"ZY_DESCRI")
		@nLin,050 PSAY "VL. ORÇADO:"
		@nLin,065 PSAY nOrcSigF PICTURE "@E 999,999,999.99"
		@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
		@nLin,125 PSAY (nOrcSigF - nSIGF) PICTURE "@E 999,999,999.99"
		@nLin,179 PSAY "TOTAL:"
		@nLin,206 PSAY nSIGF PICTURE "@E 999,999,999.99"
		nLin 	+= 2
		nAprovF  := 0
		nBAproF	:= 0
		nSIGF	:= 0

	ENDIF

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","Do Documento       	","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
	aAdd(aRegs,{cPerg,"02","Ate o Documento		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
	aAdd(aRegs,{cPerg,"03","Mes			   		","","","mv_ch3","C",02,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ano					","","","mv_ch4","C",04,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Da Conta SIG       	","","","mv_ch5","C",09,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZY",""})
	aAdd(aRegs,{cPerg,"06","Ate a Conta SIG		","","","mv_ch6","C",09,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZY",""})
	aAdd(aRegs,{cPerg,"07","Do Fornecedor      	","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	aAdd(aRegs,{cPerg,"08","Ate o Fornecedor	","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
	aAdd(aRegs,{cPerg,"09","Considera Rateios? 	","","","mv_ch9","N",01,00,1,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","" })
	AADD(aRegs,{cPerg,"10","Dt Referencia:      ","","","mv_ch10","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","Pedido Figurino		","","","mv_ch11","C",06,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
	aAdd(aRegs,{cPerg,"12","Imprime Estoque?   	","","","mv_ch12","N",01,00,1,"C","","mv_par12","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","" })
	aAdd(aRegs,{cPerg,"13","Remove Documento	","","","mv_ch13","C",06,00,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Controle Financeiro?","","","mv_ch14","N",01,00,1,"C","","mv_par14","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","" })

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
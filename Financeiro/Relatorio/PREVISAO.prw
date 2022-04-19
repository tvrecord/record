#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³previsaoº Autor ³ Bruno Alves       º Data ³    15/04/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fluxo de Caixa a Pagar - PREVISAO
±±          ±± 	                     									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PREVISAO()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cDesc1         := "Este programa tem como objetivo imprimir relatorio"
	Private cDesc2         := "de acordo com os parametros informados pelo usuario."
	Private cDesc3         := ""
	Private cPict          := ""
	Private nLin           := 100

	Private Cabec1         := ""
	Private Cabec2         := ""
	Private Cabec3         := ""
	Private imprime        := .T.
	Private aOrd := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 180
	Private tamanho      := "M"
	Private nomeprog     := "PREVISAO" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "PREVISAO" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "08PREVISA"
	Private cString      := "SC7"
	Private cQuery       := ""
	Private titulo       := "Realatorio de Previsão"
	Private aRet 		:= {}
	Private aPedidos 	:= {}
	Private aFiltPed 	:= {}
	Private aRealiza 	:= {}
	Private aMes 	 	:= {}
	Private _aIExcel 	:= {}
	Private cNaturez := ""
	Private cNatGer := ""
	Private nSubTotal := 0
	Private nTotal := 0
	Private nTotalDesp := 0
	Private nVec := 0
	Private nRec := 0
	Private cMes01 := ""
	Private cMes02 := ""
	Private cMes03 := ""
	Private nMes01 := 0
	Private nMes02 := 0
	Private nMes03 := 0
	Private nMes01Tot := 0
	Private nMes02Tot := 0
	Private nMes03Tot := 0
	Private nMesMedTot := 0
	Private nValPrev := 0
	Private cForPrev := ""
	Private cCampo := ""
	Private nDiv := 3
	Private nVlComp := 0
	Private cNumPed := ""
	Private lOK  := .T.

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAÇÃO CANCELADA")
		return
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	Processa({|| Relatorio()},"Gerando Relatório")

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function Relatorio()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Query da duplicidade das Previsões                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR,ZA6_VENC FROM ZA6010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "ZA6_NATURE = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "ZA6_MES = '" + (MV_PAR19) + "' AND "
	cQuery += "ZA6_ANO = '" + (MV_PAR20) + "' AND "
	cQuery += "ED_PREVISA = '2' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "ZA6010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR,ZA6_VENC "
	cQuery += "HAVING COUNT(ZA6_MES) > 1 "

	tcQuery cQuery New Alias "DUPPREV" // Previsao Vencimento

	COUNT TO nVec

	cQuery := "SELECT ZA6_MES,ZA6_ANO,ZA6_NATURE,ED_NATGER,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR FROM ZA6010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "ZA6_NATURE = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "ZA6_MES = '" + (MV_PAR19) + "' AND "
	cQuery += "ZA6_ANO = '" + (MV_PAR20) + "' AND "
	cQuery += "ED_PREVISA = '1' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "ZA6010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY ZA6_MES,ZA6_ANO,ZA6_NATURE,ED_NATGER,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR "
	cQuery += "HAVING COUNT(ZA6_MES) > 1 "

	tcQuery cQuery New Alias "DUPPREV1" // Previsao Valor

	COUNT TO nRec

	If nRec != 0 .OR. nVec != 0 // Não permite imprimir o relatório caso alguma informação esteja duplicada!
		Alert("Existe informações duplicadas no cadastro de Previsões, favor corrigi-las")
		DBSELECTAREA("DUPPREV")
		DBCloseArea("DUPPREV")
		DBSELECTAREA("DUPPREV1")
		DBCloseArea("DUPPREV1")
		REturn
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query das Previsões³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT * FROM ZA6010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "ZA6_NATURE = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "ZA6_MES = '" + (MV_PAR19) + "' AND "
	cQuery += "ZA6_ANO = '" + (MV_PAR20) + "' AND "
	cQuery += "ZA6_FORNEC BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
	cQuery += "ZA6_NATURE BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "ZA6_VENCRE BETWEEN '" + DTOS(MV_PAR27) + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "ZA6010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY ZA6_NATURE,ZA6_FORNEC"

	tcQuery cQuery New Alias "PREV"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx6Mäªîäªî¿
	//³Query dos pedidos de Compras³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx6MÄ:Ä:Ù

	cQuery := "SELECT "
	cQuery += "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_NUMSC,A2_NOME,C7_COND,((SUM(C7_TOTAL) + SUM(C7_DESPESA) + SUM(C7_VALFRE)) - SUM(C7_VLDESC)) AS TOTAL,C1_NATUREZ FROM SC7010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "C7_FORNECE = A2_COD AND "
	cQuery += "C7_LOJA = A2_LOJA "
	cQuery += "INNER JOIN SC1010 ON "
	cQuery += "C1_FILIAL = C7_FILIAL AND "
	cQuery += "C1_PEDIDO = C7_NUM AND "
	cQuery += "C1_ITEM = C7_ITEMSC "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "C1_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "C7_RESIDUO <> 'S' AND "
	cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoção de pedido do fluxo de caixa a pagar
	cQuery += "C7_ENCER = '' AND "
	cQuery += "C7_COND <> '006' AND "
	cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
	cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
	cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
	cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
	cQuery += "C1_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "C7_TIPO = 1 AND "
	cQuery += "C7_NUM NOT IN ('019078','019079') AND " //LISTA DE EXCEÇOES - RAFAEL FRANÇA - 04/10/16
	cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SC1010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,A2_NOME,C7_COND,C1_NATUREZ "
	cQuery += "ORDER BY C7_EMISSAO "

	tcQuery cQuery New Alias "TMP"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD_ÿD_ÿ¿
	//³Query dos titulos do Financeiro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ:Â:Ù

	cQuery := "SELECT "//Titulos em aberto
	cQuery += "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,ED_NATGER, "
	cQuery += "E2_NATUREZ,ED_DESCRIC,E2_FORNECE,E2_LOJA,A2_NOME, "
	cQuery += "E2_EMISSAO,E2_VENCREA,E2_BAIXA, "
	cQuery += "E2_MOVIMEN,E2_VALOR - (E2_PIS + E2_COFINS + E2_CSLL) AS E2_VALOR,E2_SALDO,E2_VALLIQ,E2_HIST,E2_DESDOBR "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
	cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E2_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "E2_PREFIXO <> 'CXA' AND "
	cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
	cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
	cQuery += "SE2010.E2_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "SE2010.E2_VENCREA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' AND "
	cQuery += "SE2010.E2_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // Solicitação feita pela Dona Elenn, Edna enviou o e-mail solicitando a não impressão desses fornecedores no dia 28/04/2014 as 12:56h
	cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
	cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "E2_BAIXA = '' AND "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
	cQuery += "E2_FLUXO <> 'N' AND "
	cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' "
	cQuery += "UNION "
	cQuery += "SELECT "// Titulos baixados conforme data de referencia
	cQuery += "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,ED_NATGER, "
	cQuery += "E2_NATUREZ,ED_DESCRIC,E2_FORNECE,E2_LOJA,A2_NOME, "
	cQuery += "E2_EMISSAO,E2_VENCREA,E2_BAIXA, "
	cQuery += "E2_MOVIMEN,E2_VALOR - (E2_PIS + E2_COFINS + E2_CSLL) AS E2_VALOR,E2_SALDO,E2_VALLIQ,E2_HIST,E2_DESDOBR "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
	cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
	cQuery += "E2_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "E2_PREFIXO <> 'CXA' AND "
	cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
	cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
	cQuery += "SE2010.E2_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "SE2010.E2_VENCREA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' AND "
	cQuery += "SE2010.E2_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // Solicitação feita pela Dona Elenn, Edna enviou o e-mail solicitando a não impressão desses fornecedores no dia 28/04/2014 as 12:56h
	cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
	cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "E2_BAIXA >= '" + DTOS(MV_PAR28) + "' AND "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
	cQuery += "E2_FLUXO <> 'N' AND "
	cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' "
	cQuery += "UNION "
	cQuery += "SELECT "// Adiciona baixas parciais
	cQuery += "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,ED_NATGER, "
	cQuery += "E2_NATUREZ,ED_DESCRIC,E2_FORNECE,E2_LOJA,A2_NOME, "
	cQuery += "E2_EMISSAO,E2_VENCREA,E2_BAIXA, "
	cQuery += "E2_MOVIMEN,E2_SALDO AS E2_VALOR,E2_VALOR AS E2_SALDO,E2_VALLIQ,E2_HIST,E2_DESDOBR "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
	cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E2_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "E2_PREFIXO <> 'CXA' AND "
	cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
	cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
	cQuery += "SE2010.E2_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "SE2010.E2_VENCREA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' AND "
	cQuery += "SE2010.E2_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // Solicitação feita pela Dona Elenn, Edna enviou o e-mail solicitando a não impressão desses fornecedores no dia 28/04/2014 as 12:56h
	cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
	cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "E2_BAIXA < '" + DTOS(MV_PAR28) + "' AND "
	cQuery += "E2_BAIXA <> '' AND "
	cQuery += "E2_SALDO  <> 0 AND "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
	cQuery += "E2_FLUXO <> 'N' AND "
	cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY E2_FILIAL,E2_VENCREA "

	tcQuery cQuery New Alias "FIN"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query das previsões dos contratos que estão pendentes para vinculação do mes atual³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT C3_NUM,C3_ITEM,C3_FORNECE,C3_LOJA,A2_NOME,C3_PRODUTO,C3_QUANT,(C3_PRECO-C3_VALIMP) AS C3_PRECO,C3_TOTAL,C3_DATPRI,C3_DATPRF,C3_OBS,C3_CONTATO,C3_FLUXO,C3_VENC,C3_NATUREZ,ED_DESCRIC,ED_NATGER "
	cQuery += "FROM SC3010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "SC3010.C3_FORNECE = SA2010.A2_COD AND "
	cQuery += "SC3010.C3_LOJA = SA2010.A2_LOJA "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "C3_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "C3_FILIAL = '01' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "C3_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "C3_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "SC3010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "C3_ENCER <> 'E' AND "
	cQuery += "'"+DTOS(MV_PAR08)+"' BETWEEN C3_DATPRI AND C3_DATPRF AND " //Rafael França - 17/08/2020 - Valida vigencia do contrato
	cQuery += "C3_RENOVA = '' AND "
	cQuery += "C3_PERMUTA <> '1' AND "
	cQuery += "C3_FLUXO = '1' AND "
	cQuery += "C3_MESPAG = '1' AND "
	cQuery += "C3_NUM+C3_ITEM NOT IN (SELECT C7_NUMSC+C7_ITEMSC FROM SC7010 WHERE "
	cQuery += "C7_NUMSC = C3_NUM AND "
	cQuery += "C7_ITEMSC = C3_ITEM AND "
	cQuery += "C7_TIPO = 2 AND "
	//cQuery += "C7_COND <> '006' AND "
	cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "C7_EMISSAO BETWEEN '" + MV_PAR20 + MV_PAR19 + "01" + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' "
	cQuery += "GROUP BY C7_NUMSC,C7_ITEMSC) "

	tcQuery cQuery New Alias "CONTR"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query das Autorizações de Entrega que estão pendentes para vinculação do mes seguinte ³
	//³Busco o mes anterior, provavelmente vão exitir poucas, pois as notas já foram lançadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT "
	cQuery += "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_NUMSC,C7_ITEMSC,A2_NOME,C7_COND,(((SUM(C7_TOTAL) + SUM(C7_DESPESA) + SUM(C7_VALFRE)) - SUM(C7_VLDESC)) * (1-(SUM(C3_IMPOSTO) / 100))) AS TOTAL,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS FROM SC7010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "C7_FORNECE = A2_COD AND "
	cQuery += "C7_LOJA = A2_LOJA "
	cQuery += "INNER JOIN SC3010 ON "
	cQuery += "C7_FILIAL = C3_FILIAL AND "
	cQuery += "C7_NUMSC = C3_NUM AND "
	cQuery += "C7_ITEMSC = C3_ITEM "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "C3_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "C7_RESIDUO <> 'S' AND "
	cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoção de pedido do fluxo de caixa a pagar
	cQuery += "C7_ENCER = '' AND "
	cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
	cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1)) + "' AND '" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),1,6) + "31" + "' AND "
	cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
	cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
	cQuery += "C7_TIPO = 2 AND "
	cQuery += "C3_PERMUTA <> '1' AND "
	//cQuery += "C3_FLUXO = '1' AND "
	cQuery += "(C3_MESPAG = '2' OR C7_NUM IN ('028057','028058','028059','028062','028064')) AND " //Rafael França - 02/06/2019 - Coloca a pedido do Wallace para não validar a regra do mês atual nesses casos.
	cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SC3010.D_E_L_E_T_ <> '*' OR "
	cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SC3010.D_E_L_E_T_ <> '*' AND "
	cQuery += "C7_ENCER = '' AND "
	cQuery += "C7_RESIDUO <> 'S' AND "
	cQuery += "(C7_NUM IN ('016065','016772','016737','020270','020238','021169','021227') AND ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "')" //Lista de exceções
	cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,C7_ITEMSC,A2_NOME,C7_COND,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS "
	cQuery += "ORDER BY C7_NUMSC,C7_ITEMSC "

	tcQuery cQuery New Alias "ANTAENT"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query das autorizações de Entrega³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT "
	cQuery += "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_NUMSC,C7_ITEMSC,A2_NOME,C7_COND,(((SUM(C7_TOTAL) + SUM(C7_DESPESA) + SUM(C7_VALFRE)) - SUM(C7_VLDESC)) * (1-(SUM(C3_IMPOSTO) / 100))) AS TOTAL,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS FROM SC7010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "C7_FORNECE = A2_COD AND "
	cQuery += "C7_LOJA = A2_LOJA "
	cQuery += "INNER JOIN SC3010 ON "
	cQuery += "C7_FILIAL = C3_FILIAL AND "
	cQuery += "C7_NUMSC = C3_NUM AND "
	cQuery += "C7_ITEMSC = C3_ITEM "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "C3_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "C7_RESIDUO <> 'S' AND "
	cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoção de pedido do fluxo de caixa a pagar
	cQuery += "C7_ENCER = '' AND "
	cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
	cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "C7_EMISSAO BETWEEN '" + MV_PAR20 + MV_PAR19 + "01" + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
	cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
	cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
	cQuery += "C7_TIPO = 2 AND "
	cQuery += "C3_PERMUTA <> '1' AND "
	cQuery += "C3_NUM <> '000085' AND "
	//cQuery += "C3_FLUXO = '1' AND "
	cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SC3010.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,C7_ITEMSC,A2_NOME,C7_COND,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS "
	cQuery += "ORDER BY C7_NUMSC,C7_ITEMSC "

	tcQuery cQuery New Alias "AENT"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query das previsões dos contratos que estão pendentes para vinculação do mes SEGUINTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT C3_NUM,C3_ITEM,C3_FORNECE,C3_LOJA,A2_NOME,C3_PRODUTO,C3_QUANT,(C3_PRECO - C3_VALIMP) AS C3_PRECO,C3_TOTAL,C3_DATPRI,C3_DATPRF,C3_OBS,C3_CONTATO,C3_FLUXO,C3_VENC,C3_NATUREZ,ED_DESCRIC,ED_NATGER "
	cQuery += "FROM SC3010 "
	cQuery += "INNER JOIN SA2010 ON "
	cQuery += "SC3010.C3_FORNECE = SA2010.A2_COD AND "
	cQuery += "SC3010.C3_LOJA = SA2010.A2_LOJA "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "C3_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "C3_FILIAL = '01' AND "
	cQuery += "C3_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "C3_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "SC3010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "C3_ENCER <> 'E' AND "
	cQuery += "'"+DTOS(MV_PAR08)+"' BETWEEN C3_DATPRI AND C3_DATPRF AND " //Rafael França - 17/08/2020 - Valida vigencia do contrato
	cQuery += "C3_RENOVA = '' AND "
	cQuery += "C3_PERMUTA <> '1' AND "
	cQuery += "C3_FLUXO = '1' AND "
	cQuery += "C3_MESPAG = '2' AND "
	cQuery += "C3_NUM+C3_ITEM NOT IN (SELECT C7_NUMSC+C7_ITEMSC FROM SC7010 WHERE "
	cQuery += "C7_NUMSC = C3_NUM AND "
	cQuery += "C7_ITEMSC = C3_ITEM AND "
	cQuery += "C7_TIPO = 2 AND "
	cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "' AND "
	cQuery += "SC7010.D_E_L_E_T_ = '' "
	cQuery += "GROUP BY C7_NUMSC,C7_ITEMSC) "

	tcQuery cQuery New Alias "ANTCONTR"

	// Query para montar as medias dos titulos que já foram baixados no periodo

	If MV_PAR23 == 1//Depende da ordem da Anapoli
		cQuery := "SELECT E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	ELSE
		cQuery := "SELECT E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	EndIf
	cQuery += "FROM SE5010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E5_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE5010.D_E_L_E_T_ = ''  AND "
	cQuery += "SED010.D_E_L_E_T_ = '' AND "
	cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "E5_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "E5_NUMERO BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
	cQuery += "E5_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "E5_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
	cQuery += "E5_CLIFOR BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "E5_FILIAL = '01'  AND "
	cQuery += "E5_TIPODOC <> 'CH' AND "
	cQuery += "E5_SITUACA <> 'C' AND "
	cQuery += "E5_RECONC = 'x' AND "
	cQuery += "E5_TIPO <> 'DC' AND "
	iF MV_PAR26 == 1 // Mes fechado, SIM OU NÃO?
		cQuery += "E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,3)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "'  AND "
	ELSE
		cQuery += "E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,4)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,2)),5,2) + "31" + "'  AND "
	Endif
	cQuery += "E5_RECPAG = 'P' AND "
	cQuery += "E5_NATUREZ <> '1503001' "
	If MV_PAR23 == 1
		cQuery += "GROUP BY E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	ELSE
		cQuery += "GROUP BY E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	EndIf

	tcQuery cQuery New Alias "REALIZAD"


	If MV_PAR23 == 1//Depende da ordem da Anapoli
		cQuery := "SELECT E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	ELSE
		cQuery := "SELECT E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	EndIf
	cQuery += "FROM SE5010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E5_NATUREZ = ED_CODIGO "
	cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
	cQuery += "AND SED010.D_E_L_E_T_ = ''  "
	cQuery += "AND E5_TIPODOC = 'BA' "
	cQuery += "AND ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' "
	cQuery += "AND E5_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' "
	iF MV_PAR26 == 1 // Mes fechado, SIM OU NÃO?
		cQuery += "AND E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,3)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "' "
	ELSE
		cQuery += "AND E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,4)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,2)),5,2) + "31" + "' "
	Endif
	cQuery += "AND E5_NATUREZ <> '1503001' "
	cQuery += "AND E5_NUMCHEQ <> '' "
	If MV_PAR23 == 1
		cQuery += "GROUP BY E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	ELSE
		cQuery += "GROUP BY E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	EndIf

	tcQuery cQuery New Alias "CHQREAL"



	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },titulo)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


	//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


	// **************************** Cria Arquivo Temporario
	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"EMISSAO"      	, "D" , 013 , 00 } ) //01
	aadd( _aCExcel , {"DOC	"			, "C" , 010 , 00 } ) //02
	aadd( _aCExcel , {"TIPO	"			, "C" , 010 , 00 } ) //03
	aadd( _aCExcel , {"NUMERO"			, "C" , 010 , 00 } ) //04
	aadd( _aCExcel , {"VENC"			, "D" , 013 , 00 } ) //05
	aadd( _aCExcel , {"FORNECEDOR"		, "C" , 050 , 00 } ) //06
	aadd( _aCExcel , {"HISTORICO"		, "C" , 150 , 00 } ) //07
	aadd( _aCExcel , {"VALOR"			, "N" , 015 , 02 } ) //08
	aadd( _aCExcel , {"CODNAT" 			, "C" , 010 , 00 } ) //09
	aadd( _aCExcel , {"DESCNAT"			, "C" , 040 , 00 } ) //10
	aadd( _aCExcel , {"ORCADO"			, "N" , 015 , 02 } ) //11

	If MV_PAR26 == 1

		cMes01 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,3)),5,2)
		cMes02 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,2)),5,2)
		cMes03 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2)

		For i := 1 to 3
			aadd( _aCExcel , {"MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,i)),5,2), "N" , 015 , 02 } )//Verifica o mes do realizado
		Next

	ELSE

		cMes01 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,4)),5,2)
		cMes02 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,3)),5,2)
		cMes03 := "TMP1->MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,2)),5,2)

		For i := 1 to 3
			J := i
			J++
			aadd( _aCExcel , {"MES" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,J)),5,2), "N" , 015 , 02 } )//Verifica o mes do realizado
		Next

	EndIf


	aadd( _aCExcel , {"MEDIA"			, "N" , 015 , 02 } )

	//_cTemp := CriaTrab(_aCExcel, .T.)
	//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor a AUTORIZAÇAO DE ENTREGA que ainda não LANÇADA UMA NOTA NO MES DA PREVISAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("AENT")
	DBGotop()

	While !EOF()

		aRet := Condicao(AENT->TOTAL,AENT->C7_COND,,STOD(AENT->C7_EMISSAO),)

		For i := 1 to Len(aRet)

			If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08

				aAdd(aPedidos,{STOD(AENT->C7_EMISSAO),;  //01 Emissao
					"PREVISAO",; //02 Numero
					DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
					AENT->A2_NOME,; //04
					FwNoAccent(UPPER(AENT->C7_OBS)),;                    //05
					aREt[i][2],; // Valor do Pagamento //06
					AENT->ED_NATGER,; // SubNatureza 07
					Posicione("SX5",1,xFilial("SX5") + "ZV" + AENT->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
					AENT->ED_CODIGO,;// Cod Natureza 09
					AENT->ED_DESCRIC,;// Descrição Natureza 10
					"AENTREGASEG",; // Tipo 11
					AENT->C7_NUM}) // Numero 12

			EndIf

		Next

		DBSelectArea("AENT")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor o movimento realizado e sua media³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Adiciona no vetor os movimentos bancarios (- Cheques)

	DBSelectArea("REALIZAD")
	DBGotop()

	While !EOF()

		IF MV_PAR23 == 1

			aAdd(aRealiza,{ALLTRIM(REALIZAD->ED_NATGER),;  //01 NATUREZA GERENCIAL
				REALIZAD->MES,; //02 MES
				REALIZAD->VALOR}) // 03 VALOR

		Else

			aAdd(aRealiza,{ALLTRIM(REALIZAD->E5_NATUREZ),;  //01 NATUREZA
				REALIZAD->MES,; //02 MES
				REALIZAD->VALOR}) // 03 VALOR

		EndIf

		DBSelectArea("REALIZAD")
		DBSkip()

	eNDDO

	// Adiciona ou soma no vetor os movimentos bancarios de cheques para impressão das medias

	DBSelectArea("CHQREAL")
	DBGotop()

	While !EOF()

		IF MV_PAR23 == 1

			If Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->ED_NATGER) .And. X[2] == CHQREAL->MES }) == 0   // Adiciona no Vetor

				aAdd(aRealiza,{ALLTRIM(CHQREAL->ED_NATGER),;  //01 NATUREZA GERENCIAL
					CHQREAL->MES,; //02 MES
					CHQREAL->VALOR}) // 03 VALOR

			ELSE    // Soma o valor no vetor

				aRealiza[Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->ED_NATGER) .And. X[2] == CHQREAL->MES })][3] := aRealiza[Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->ED_NATGER) .And. X[2] == CHQREAL->MES })][3] + CHQREAL->VALOR

			EndIf

		Else

			If Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->E5_NATUREZ) .And. X[2] == CHQREAL->MES }) == 0 // Adiciona no Vetor

				aAdd(aRealiza,{ALLTRIM(CHQREAL->E5_NATUREZ),;  //01 NATUREZA
					CHQREAL->MES,; //02 MES
					CHQREAL->VALOR}) // 03 VALOR

			ELSE // Soma o valor no vetor

				aRealiza[Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->E5_NATUREZ) .And. X[2] == CHQREAL->MES })][3] := aRealiza[Ascan(aRealiza, { |X| X[1] == ALLTRIM(CHQREAL->E5_NATUREZ) .And. X[2] == CHQREAL->MES })][3] + CHQREAL->VALOR

			EndIf

		Endif

		DBSelectArea("CHQREAL")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor a AUTORIZAÇAO DE ENTREGA que ainda não LANÇADA UMA NOTA NO MES ANTERIOR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("ANTAENT")
	DBGotop()

	While !EOF()

		aRet := Condicao(ANTAENT->TOTAL,ANTAENT->C7_COND,,STOD(ANTAENT->C7_EMISSAO),)

		For i := 1 to Len(aRet)

			If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08

				aAdd(aPedidos,{STOD(ANTAENT->C7_EMISSAO),;  //01 Emissao
					"PREVISAO",; //02 Numero
					DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
					ANTAENT->A2_NOME,; //04
					FwNoAccent(UPPER(ANTAENT->C7_OBS)),;                    //05
					aREt[i][2],; // Valor do Pagamento //06
					ANTAENT->ED_NATGER,; // SubNatureza 07
					Posicione("SX5",1,xFilial("SX5") + "ZV" + ANTAENT->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
					ANTAENT->ED_CODIGO,;// Cod Natureza 09
					ANTAENT->ED_DESCRIC,;// Descrição Natureza 10
					"AENTREGA",; // Tipo 11
					ANTAENT->C7_NUM}) // Numero 12

			EndIf

		Next

		DBSelectArea("ANTAENT")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor a Previsão dos Contratos do pagamento mes seguinte (periodo anterior) que ainda não foram lançados na autorização de entrega dos mes seguinte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	DBSelectArea("ANTCONTR")
	DBGotop()

	While !EOF()

		If STOD(ANTCONTR->C3_DATPRI) <= LastDate(STOD(MV_PAR20 + MV_PAR19 + "01")) //.AND. STOD(MV_PAR20 + MV_PAR19 + ANTCONTR->C3_VENC) <= STOD(ANTCONTR->C3_DATPRF) //Não pode imprimir o relatório que ainda não se iniciou ou que ja esta com o prazo finalizado.

			If (SUBSTR(ANTCONTR->C3_DATPRI,1,6) != (MV_PAR20 + MV_PAR19))//Todo contrato que se inicia no mes da previsão e está configurado para o mes seguinte não pode aparecer no relatório.

				aAdd(aPedidos,{MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1),;  //01 Emissao
					"PREVISAO",; //02 Numero
					STOD(MV_PAR20 + MV_PAR19 + ANTCONTR->C3_VENC),;//Data do Vencimento  03
					ANTCONTR->A2_NOME,; //Nome do Fornecedor 04
					FwNoAccent(UPPER(ANTCONTR->C3_OBS)),; // HISTORICO //05
					ANTCONTR->C3_PRECO,; // Valor do Pagamento //06
					ANTCONTR->ED_NATGER,; // SubNatureza 07
					Posicione("SX5",1,xFilial("SX5") + "ZV" + ANTCONTR->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
					ANTCONTR->C3_NATUREZ,;// Cod Natureza 09
					ANTCONTR->ED_DESCRIC,; // Descrição Natureza 10
					"ANTCONTRATO",;  // Tipo 11
					ANTCONTR->C3_NUM + ANTCONTR->C3_ITEM }) // Numero 12

			EndIf

		EndIf

		DBSelectArea("ANTCONTR")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor a Previsão dos Contratos que ainda não foram lançados na autorização de entrega dos mes seguinte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("CONTR")
	DBGotop()

	While !EOF()

		If STOD(CONTR->C3_DATPRI) <= LastDate(STOD(MV_PAR20 + MV_PAR19 + "01"))//Não pode imprimir o relatório que ainda não se iniciou

			aAdd(aPedidos,{STOD(MV_PAR20 + MV_PAR19 + "01"),;  //01 Emissao
				"PREVISAO",; //02 Numero
				STOD(MV_PAR20 + MV_PAR19 + CONTR->C3_VENC),;//Data do Vencimento  03
				CONTR->A2_NOME,; //Nome do Fornecedor 04
				FwNoAccent(UPPER(CONTR->C3_OBS)),; // HISTORICO //05
				CONTR->C3_PRECO,; // Valor do Pagamento //06
				CONTR->ED_NATGER,; // SubNatureza 07
				Posicione("SX5",1,xFilial("SX5") + "ZV" + CONTR->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
				CONTR->C3_NATUREZ,;// Cod Natureza 09
				CONTR->ED_DESCRIC,; // Descrição Natureza 10
				"CONTRATO",;  // Tipo 11
				CONTR->C3_NUM + CONTR->C3_ITEM }) // Numero 12

		EndIf

		DBSelectArea("CONTR")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor as previsões do cadastro das provisões já com os descontos abatidos
	//³ da previsão de compras e do titulos a pagar caso existam
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("PREV")
	DBGotop()

	While !EOF()


		iF PREV->ZA6_CODIGO == "000181"
			nValPrev := 0
		EndIf

		//	iF PREV->ZA6_CODIGO == "000538"  //Teste aqui
		//	Alert("Teste")
		//	EndIf
		//IF ALLTRIM(PREV->ZA6_NATURE) = "1205004" .OR. ALLTRIM(PREV->ZA6_NATURE) = "1205005"
		//nValPrev := PREV->ZA6_VALOR - AbatSE5()
		//ENDIF

		nValPrev := PREV->ZA6_VALOR - AbaFin()
		nValPrev := nValPrev - AbaCom()

		//Quando for previsão do RH não é para abater e sim substituir
		If PREV->ED_PREVISA == "2"
			IF PREV->ZA6_NATGER = '0001'
				If nValPrev != PREV->ZA6_VALOR .AND. PREV->ZA6_CODIGO != "003849"
					DBSelectArea("PREV")
					DBSkip()
					loop
				EndIf
			EndIf
		EndIf

		If nValPrev > 0

			If EMPTY(PREV->ZA6_NMFOR)
				cForPrev := PREV->ZA6_NMNAT
			ELSE
				cForPrev := PREV->ZA6_NMFOR
			EndIf


			aAdd(aPedidos,{STOD(MV_PAR20 + MV_PAR19 + "01"),;  //01 Emissao
				"PREVISAO",; //02 Numero
				STOD(PREV->ZA6_VENCRE),;//Data do Vencimento  03
				cForPrev,; //Nome do Fornecedor 04
				FwNoAccent(UPPER(PREV->ZA6_HIST)),; // HISTORICO //05
				nValPrev,; // Valor do Pagamento //06
				PREV->ED_NATGER,; // SubNatureza 07
				Posicione("SX5",1,xFilial("SX5") + "ZV" + PREV->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
				PREV->ZA6_NATURE,;// Cod Natureza 09
				PREV->ZA6_NMNAT,; // Descrição Natureza 10
				"PREVISAO",;  // Tipo 11
				PREV->ZA6_CODIGO}) // Numero 12

		EndIf

		DBSelectArea("PREV")
		DBSkip()

	eNDDO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no vetor as previsões dos pedidos de compras³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("TMP")
	DBGotop()

	While !TMP->(EOF())

		aRet := Condicao(TMP->TOTAL,TMP->C7_COND,,STOD(TMP->C7_EMISSAO) + Posicione("SC8",11,TMP->C7_FILIAL + TMP->C7_NUM,"C8_PRAZO"),)
		cNumPed := alltrim(TMP->C7_NUM)
		nVlComp := AbaAdiant()

		For i := 1 to Len(aRet)

			If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08


				nVlComp	:= aREt[i][2] - nVlComp

				If nVlComp <= 0
					nVlComp * (-1)

				else

					dbSelectArea("SZL")
					dbSetOrder(2)
					DbSeek(xFilial("SZL") + TMP->C7_NUM)   //Consulta detalhe do pedido para buscar o historico

					aAdd(aPedidos,{STOD(TMP->C7_EMISSAO),;  //01 Emissao
						"PREVISAO",; //02 Numero
						DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
						TMP->A2_NOME,; //04
						FwNoAccent(UPPER(SZL->ZL_OBS1)),;                    //05
						nVlComp,; // Valor do Pagamento //06
						POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_NATGER"),; // SubNatureza 07
						Posicione("SX5",1,xFilial("SX5") + "ZV" + POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_NATGER"),"X5_DESCRI"),;// Descrição  da SubNatureza 08
						TMP->C1_NATUREZ,;// Cod Natureza 09
						POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_DESCRIC"),;// Descrição Natureza 10
						"PEDIDO",; // Tipo 11
						TMP->C7_NUM}) // Numero 12


				EndIf

			EndIf

		Next


		DBSelectArea("TMP")
		DBSkip()

	Enddo


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona no Vetor os titulos a pagar que precisam ser pagos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	DBSelectArea("FIN")
	DBGotop()


	While !EOF()

		IF !(ALLTRIM(FIN->E2_NATUREZ) == "1206004" .AND. ALLTRIM(FIN->E2_FORNECE) == "000073")// Solicitado pela Pamela no dia 07/11/2014 pela Pamela

			IF (Posicione("SF1",1,FIN->E2_FILIAL + FIN->E2_NUM + FIN->E2_PREFIXO + FIN->E2_FORNECE + FIN->E2_LOJA ,"F1_COND") != "006") // Se for permuta não adiciona no vetor

				If !(FIN->E2_DESDOBR == "S" .AND. EMPTY(FIN->E2_PARCELA))//Não adiciona titulo que foi desdobrado para não gerar duplicidade


					aAdd(aPedidos,{STOD(FIN->E2_EMISSAO),;  //01 Emissao
						FIN->E2_NUM,; //02 Numero
						STOD(FIN->E2_VENCREA),;//Data do Vencimento  03
						FIN->A2_NOME,; //Nome do Fornecedor 04
						IIF(EMPTY(FIN->E2_HIST),FIN->ED_DESCRIC,FwNoAccent(UPPER(FIN->E2_HIST))),;// HISTORICO //05
						FIN->E2_VALOR,; // Valor do Pagamento //06
						FIN->ED_NATGER,; // SubNatureza 07
						Posicione("SX5",1,xFilial("SX5") + "ZV" + FIN->ED_NATGER,"X5_DESCRI"),;// Descrição  da SubNatureza 08
						FIN->E2_NATUREZ,;// Cod Natureza 09
						FIN->ED_DESCRIC,; // Descrição Natureza 10
						"NOTA",;  // Tipo 11
						FIN->E2_NUM}) // Numero 12

				EndIf

			EndIf

		EndIf

		DBSelectArea("FIN")
		DBSkip()

	eNDDO




	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordenar o relatório por ordem Napoli ou Natureza³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	If MV_PAR23 == 1 //Ordena todas as informações por Natureza GErencial + Data de Vencimento

		ASORT(aPedidos,,,{|x,y|x[7]+DTOS(x[3]) < y[7]+DTOS(y[3])})


		//Filtra os vencimentos conforme informado nos parametros

		For i:=1 to Len(aPedidos)

			If DATAVALIDA(aPedidos[i][3]) >= MV_PAR07 .AND. DATAVALIDA(aPedidos[i][3]) <= MV_PAR08

				aAdd(aFiltPed,{aPedidos[i][1],;  //01 Emissao
					aPedidos[i][2],; //02 Numero
					aPedidos[i][3],;//Data do Vencimento  03
					aPedidos[i][4],; //Nome do Fornecedor 04
					aPedidos[i][5],;// HISTORICO //05
					aPedidos[i][6],; // Valor do Pagamento //06
					aPedidos[i][7],; // SubNatureza 07
					aPedidos[i][8],;// Descrição  da SubNatureza 08
					aPedidos[i][9],;// Cod Natureza 09
					aPedidos[i][10],; // Descrição Natureza 10
					aPedidos[i][11],;  // Tipo 11
					aPedidos[i][12]}) // Numero 12

			EndIf


		Next


		For i:=1 to LEN(aFiltPed)

			If i == 1
				cNatGer := ALLTRIM(aFiltPed[i][7])
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[06]		:= aFiltPed[i][8]
				AADD(_aIExcel,_aItem)
				_aItem := {}
			EndIf

			If cNatGer != ALLTRIM(aFiltPed[i][7])

				cCampo	:= "ED_MES" + MV_PAR19

				nMes01 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) })][3])
				nMes02 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) })][3])
				nMes03 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) })][3])
				nDiv := 3

				iif(nMes01 == 0,nDiv--,)
				iif(nMes02 == 0,nDiv--,)
				iif(nMes03 == 0,nDiv--,)

				//SubTotal
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[08] 			:= nSubTotal
				_aItem[12] 	    	:= nMes01
				_aItem[13]          := nMes02
				_aItem[14]          := nMes03
				_aItem[15]			:= (nMes01 + nMes02 + nMes03)/nDiv
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Total Geral
				nMes01Tot += nMes01
				nMes02Tot += nMes02
				nMes03Tot += nMes03
				nMesMedTot += (nMes01 + nMes02 + nMes03)/nDiv

				// Pula Linha
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Cabeçalho
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[06]		:= aFiltPed[i][8]
				AADD(_aIExcel,_aItem)
				_aItem := {}

				nSubTotal := 0

			EndIf



			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= aFiltPed[i][1]
			_aItem[02]			:= aFiltPed[i][2]
			_aItem[03]			:= aFiltPed[i][11]
			_aItem[04]		:= aFiltPed[i][12]
			_aItem[05]			:= DATAVALIDA(aFiltPed[i][3])
			_aItem[06]	:= aFiltPed[i][4]
			_aItem[07]		:= aFiltPed[i][5]
			_aItem[08] 		:= aFiltPed[i][6]
			_aItem[09]		:= aFiltPed[i][9]
			_aItem[10]		:= aFiltPed[i][10]
			AADD(_aIExcel,_aItem)
			_aItem := {}

			nSubTotal += aFiltPed[i][6]
			If aFiltPed[i][7] != "0009"// Transferencia entre contas não soma no valor total da despesa conforme informado pela Sra. Elenn no dia 29/04/2014 as 12:00h
				nTotalDesp += aFiltPed[i][6]
			EndIf
			nTotal += aFiltPed[i][6]
			cNatGer := ALLTRIM(aFiltPed[i][7])


			If  i == len(aFiltPed)// imprimir o ultimo registro

				cCampo	:= "ED_MES" + MV_PAR19

				nMes01 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) })][3])
				nMes02 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) })][3])
				nMes03 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) })][3])
				nDiv := 3
				iif(nMes01 == 0,nDiv--,)
				iif(nMes02 == 0,nDiv--,)
				iif(nMes03 == 0,nDiv--,)

				//SubTotal
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[08] 		:= nSubTotal
				_aItem[12]      := nMes01
				_aItem[13]      := nMes02
				_aItem[14]      := nMes03
				_aItem[15]		:= (nMes01 + nMes02 + nMes03)/nDiv
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Total Geral
				nMes01Tot += nMes01
				nMes02Tot += nMes02
				nMes03Tot += nMes03
				nMesMedTot += (nMes01 + nMes02 + nMes03)/nDiv

			EndIf

		Next

	ELSE

		ASORT(aPedidos,,,{|x,y|x[9]+DTOS(x[3]) < y[9]+DTOS(y[3])})

		//Filtra os vencimentos conforme informado nos parametros

		For i:=1 to Len(aPedidos)

			If DATAVALIDA(aPedidos[i][3]) >= MV_PAR07 .AND. DATAVALIDA(aPedidos[i][3]) <= MV_PAR08

				aAdd(aFiltPed,{aPedidos[i][1],;  //01 Emissao
					aPedidos[i][2],; //02 Numero
					aPedidos[i][3],;//Data do Vencimento  03
					aPedidos[i][4],; //Nome do Fornecedor 04
					aPedidos[i][5],;// HISTORICO //05
					aPedidos[i][6],; // Valor do Pagamento //06
					aPedidos[i][7],; // SubNatureza 07
					aPedidos[i][8],;// Descrição  da SubNatureza 08
					aPedidos[i][9],;// Cod Natureza 09
					aPedidos[i][10],; // Descrição Natureza 10
					aPedidos[i][11],;  // Tipo 11
					aPedidos[i][12]}) // Numero 12

			EndIf


		Next

		For i:=1 to Len(aFiltPed)

			If i == 1
				cNatGer := ALLTRIM(aFiltPed[i][9])
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[06]		:= aFiltPed[i][10]
				AADD(_aIExcel,_aItem)
				_aItem := {}
			EndIf

			If cNatGer != ALLTRIM(aFiltPed[i][9])

				cCampo	:= "ED_MES" + MV_PAR19

				nMes01 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) })][3])
				nMes02 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) })][3])
				nMes03 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) })][3])
				nDiv := 3

				iif(nMes01 == 0,nDiv--,)
				iif(nMes02 == 0,nDiv--,)
				iif(nMes03 == 0,nDiv--,)

				//SubTotal
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[08] 		:= nSubTotal
				_aItem[11] 		:= POSICIONE("SED",1,xFilial("SED")+cNatGer,@cCampo)// Mes orçado na Natureza
				_aItem[12]      := nMes01
				_aItem[13]      := nMes02
				_aItem[14]      := nMes03
				_aItem[15]		:= (nMes01 + nMes02 + nMes03)/nDiv
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Total Geral
				nMes01Tot += nMes01
				nMes02Tot += nMes02
				nMes03Tot += nMes03
				nMesMedTot += (nMes01 + nMes02 + nMes03)/nDiv


				// Pula Linha
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Cabeçalho
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[06]		:= aFiltPed[i][10]
				AADD(_aIExcel,_aItem)
				_aItem := {}

				nSubTotal := 0

			EndIf



			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= aFiltPed[i][1]
			_aItem[02]		:= aFiltPed[i][2]
			_aItem[03]		:= aFiltPed[i][11]
			_aItem[04]		:= aFiltPed[i][12]
			_aItem[05]		:= DATAVALIDA(aFiltPed[i][3])
			_aItem[06]		:= aFiltPed[i][4]
			_aItem[07]		:= aFiltPed[i][5]
			_aItem[08] 		:= aFiltPed[i][6]
			_aItem[09]		:= aFiltPed[i][9]
			_aItem[10]		:= aFiltPed[i][10]
			AADD(_aIExcel,_aItem)
			_aItem := {}

			nSubTotal += aFiltPed[i][6]


			If aFiltPed[i][7] != "0009"// Transferencia entre contas não soma no valor total da despesa conforme informado pela Sra. Elenn no dia 29/04/2014 as 12:00h
				nTotalDesp += aFiltPed[i][6]
			EndIf


			nTotal += aFiltPed[i][6]
			cNatGer := ALLTRIM(aFiltPed[i][9])


			If  i == len(aFiltPed)// imprimir o ultimo registro

				cCampo	:= "ED_MES" + MV_PAR19

				nMes01 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes01,10,2) })][3])
				nMes02 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes02,10,2) })][3])
				nMes03 := IIF(Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) }) == 0,0,aRealiza[Ascan(aRealiza, { |X| X[1] == cNatGer .And. X[2] == SUBSTR(cMes03,10,2) })][3])
				nDiv := 3
				iif(nMes01 == 0,nDiv--,)
				iif(nMes02 == 0,nDiv--,)
				iif(nMes03 == 0,nDiv--,)

				//SubTotal
				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[08] 		:= nSubTotal
				_aItem[11] 		:= POSICIONE("SED",1,xFilial("SED")+cNatGer,@cCampo)// Mes orçado na Natureza
				_aItem[12]      := nMes01
				_aItem[13]      := nMes02
				_aItem[14]      := nMes03
				_aItem[15]		:= (nMes01 + nMes02 + nMes03)/nDiv
				AADD(_aIExcel,_aItem)
				_aItem := {}

				//Total Geral
				nMes01Tot += nMes01
				nMes02Tot += nMes02
				nMes03Tot += nMes03
				nMesMedTot += (nMes01 + nMes02 + nMes03)/nDiv

			EndIf

		Next

	EndIf

	// Subtotal do ultimo registro que não será impresso no FOR
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[08] 		:= nSubTotal
	AADD(_aIExcel,_aItem)
	_aItem := {}

	// Pula Linha
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	AADD(_aIExcel,_aItem)
	_aItem := {}

	// Total
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[07]		:= UPPER("Total Despesas:")
	_aItem[08] 		:= nTotalDesp
	_aItem[12]      := nMes01Tot
	_aItem[13]      := nMes02Tot
	_aItem[14]      := nMes03Tot
	_aItem[15]		:= nMesMedTot
	AADD(_aIExcel,_aItem)
	_aItem := {}

	// Total
	//_aItem := ARRAY(LEN(_aCExcel) + 1)
	//_aItem[07]		:= UPPER("Total com Transferencias:")
	//_aItem[08] 		:= nTotal
	//	AADD(_aIExcel,_aItem)
	//	_aItem := {}


	//If !ApOleClient("MsExcel")
	//	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	//	Return
	//EndIf

	//cArq     := _cTemp+".DBF"

	//DBSelectArea("TMP1")
	//DBCloseARea("TMP1")
	DBSelectArea("TMP")
	DBCloseARea("TMP")
	DBSelectArea("FIN")
	DBCloseARea("FIN")
	DBSelectArea("DUPPREV")
	DBCloseARea("DUPPREV")
	DBSelectArea("DUPPREV1")
	DBCloseARea("DUPPREV1")
	DBSelectArea("CONTR")
	DBCloseARea("CONTR")
	DBSelectArea("AENT")
	DBCloseARea("AENT")
	DBSelectArea("PREV")
	DBCloseARea("PREV")
	DBSelectArea("ANTAENT")
	DBCloseARea("ANTAENT")
	DBSelectArea("ANTCONTR")
	DBCloseARea("ANTCONTR")
	DBSelectArea("REALIZAD")
	DBCloseARea("REALIZAD")
	DBSelectArea("CHQREAL")
	DBCloseARea("CHQREAL")

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
			{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Previsão Pagar - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","REALIZADO")
		_lRet := .F.
	ENDIF


	//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

	//oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
	//oExcelApp:SetVisible(.T.)

Return

Static Function AbaFin()

	Local nValAbat := 0



	If POSICIONE("SED",1,xFilial("SED") + PREV->ZA6_NATURE,"ED_PREVISA") == "2" // Filtra pelo Vencimento

		cQuery := "SELECT "
		cQuery += "E2_VALOR,E2_PARCELA,E2_DESDOBR,E2_NUM,E2_PREFIXO,E2_FORNECE "
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
		cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "E2_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
		cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
		cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
		cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "E2_BAIXA >= '" + DTOS(MV_PAR28) + "' AND "
		cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
		cQuery += "SE2010.E2_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
		cQuery += "SE2010.E2_VENCREA = '" + PREV->ZA6_VENCRE + "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "SE2010.E2_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		EndIf
		cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' "
		cQuery += "UNION "
		cQuery += "SELECT "
		cQuery += "E2_VALOR,E2_PARCELA,E2_DESDOBR,E2_NUM,E2_PREFIXO,E2_FORNECE "
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
		cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "E2_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
		cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
		cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
		cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "E2_BAIXA = '' AND "
		cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
		cQuery += "SE2010.E2_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
		cQuery += "SE2010.E2_VENCREA = '" + PREV->ZA6_VENCRE + "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "SE2010.E2_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		EndIf
		cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' "

		tcQuery cQuery New Alias "ABAT"

		DBSelectArea("ABAT")
		DBGotop()


		While !EOF()//Não soma o titulo principal do desdobramento

			cQuery := "SELECT C7_NUMSC,C7_ITEM FROM SD1010 "
			cQuery += "INNER JOIN SC7010 ON "
			cQuery += "C7_NUM = D1_PEDIDO "
			cQuery += "INNER JOIN SC3010 ON "
			cQuery += "C3_NUM = C7_NUMSC AND "
			cQuery += "C3_ITEM = C7_ITEM "
			cQuery += "WHERE "
			cQuery += "D1_DOC = '" + (ABAT->E2_NUM) + "' AND "
			//		cQuery += "C7_EMISSAO = '" + (ABAT->E2_EMISSAO) + "'  AND "
			cQuery += "C7_TIPO = 2 AND "
			cQuery += "C3_PERMUTA <> '1' AND "
			cQuery += "C3_FLUXO = '1' AND "
			//		cQuery += "C3_MESPAG = '2' AND "
			cQuery += "C7_RESIDUO <> 'S' AND "
			cQuery += "C7_ENCER <> '' AND "
			cQuery += "D1_SERIE = '" + (ABAT->E2_PREFIXO) + "' AND "
			cQuery += "C7_FORNECE = '" + (ABAT->E2_FORNECE) + "' AND "
			cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
			cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
			cQuery += "SC3010.D_E_L_E_T_ <> '*' "
			cQuery += "GROUP BY C7_NUMSC,C7_ITEM "

			tcQuery cQuery New Alias "OKCON"

			DBSelectArea("OKCON")

			lOkCon := .T.

			If !OKCON->(EOF())
				lOkCon := .F.
			EndIf

			DBSelectArea("OKCON")
			DBCLOSEAREA("OKCON")

			DBSelectArea("ABAT")

			If lOkCon

				If ABAT->E2_DESDOBR == "S"

					If !EMPTY(ABAT->E2_PARCELA)
						nValAbat += ABAT->E2_VALOR
					EndIF

				else

					nValAbat += ABAT->E2_VALOR

				EndIf

			EndIf

			DBSelectArea("ABAT")
			DBSkip()

		EndDo

		DBSElectArea("ABAT")
		DBCloseArea("ABAT")

	ELSEIF POSICIONE("SED",1,xFilial("SED") + PREV->ZA6_NATURE,"ED_PREVISA") == "1"    // Filtra pelo valor

		cQuery := "SELECT "
		cQuery += "E2_VALOR,E2_PARCELA,E2_DESDOBR,E2_NUM,E2_PREFIXO,E2_FORNECE "
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
		cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "E2_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
		cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
		cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
		cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
		cQuery += "SE2010.E2_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "SE2010.E2_BAIXA >= '" + DTOS(MV_PAR28) + "' AND "
		cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
		cQuery += "SE2010.E2_FLUXO <> 'N' AND "
		cQuery += "SE2010.E2_VENCREA BETWEEN '" + MV_PAR20 + MV_PAR19 + "01" + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "SE2010.E2_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		EndIf
		cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' "
		cQuery += "UNION "
		cQuery += "SELECT "
		cQuery += "E2_VALOR,E2_PARCELA,E2_DESDOBR,E2_NUM,E2_PREFIXO,E2_FORNECE "
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
		cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "E2_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
		cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
		cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
		cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
		cQuery += "SE2010.E2_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "SE2010.E2_BAIXA = '' AND "
		cQuery += "SE2010.E2_FLUXO <> 'N' AND "
		cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para não apresentar o título gerado por aglutinação, não gerando duplicidade
		cQuery += "SE2010.E2_VENCREA BETWEEN '" + MV_PAR20 + MV_PAR19 + "01" + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "SE2010.E2_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		EndIf
		cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' "



		tcQuery cQuery New Alias "ABAT"


		DBSelectArea("ABAT")
		DBGotop()


		While !EOF()//Não soma o titulo principal do desdobramento e notas vinculadas aos contratos

			cQuery := "SELECT C7_NUMSC,C7_ITEM FROM SD1010 "
			cQuery += "INNER JOIN SC7010 ON "
			cQuery += "C7_NUM = D1_PEDIDO "
			cQuery += "INNER JOIN SC3010 ON "
			cQuery += "C3_NUM = C7_NUMSC AND "
			cQuery += "C3_ITEM = C7_ITEM "
			cQuery += "WHERE "
			cQuery += "D1_DOC = '" + (ABAT->E2_NUM) + "' AND "
			//		cQuery += "C7_EMISSAO = '" + (ABAT->E2_EMISSAO) + "'  AND "
			cQuery += "C7_TIPO = 2 AND "
			cQuery += "C3_PERMUTA <> '1' AND "
			cQuery += "C3_FLUXO = '1' AND "
			//		cQuery += "C3_MESPAG = '2' AND "
			cQuery += "C7_RESIDUO <> 'S' AND "
			cQuery += "C7_ENCER <> '' AND "
			cQuery += "D1_SERIE = '" + (ABAT->E2_PREFIXO) + "' AND "
			cQuery += "C7_FORNECE = '" + (ABAT->E2_FORNECE) + "' AND "
			cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
			cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
			cQuery += "SC3010.D_E_L_E_T_ <> '*' "
			cQuery += "GROUP BY C7_NUMSC,C7_ITEM "

			tcQuery cQuery New Alias "OKCON"

			DBSelectArea("OKCON")

			lOkCon := .T.

			If !OKCON->(EOF())
				lOkCon := .F.
			EndIf

			DBSelectArea("OKCON")
			DBCLOSEAREA("OKCON")

			DBSelectArea("ABAT")

			if lOkCon

				If EMPTY(PREV->ZA6_FORNEC) // Não permite abater o valor de uma previsão inserida em uma natureza e fornecedor ja existente quando preencher o fornecedor em branco, evitando a duplicidade de infor,ações

					DBSelectArea("ZA6")
					DBSetOrder(2)
					IF(DBSeek(PREV->ZA6_FILIAL + PREV->ZA6_MES + PREV->ZA6_ANO + PREV->ZA6_NATURE + ABAT->E2_FORNECE))

						DBSelectArea("ABAT")
						DBskip()
						loop

					EndIf
				EndIf



				If ABAT->E2_DESDOBR == "S"

					If !EMPTY(ABAT->E2_PARCELA)
						nValAbat += ABAT->E2_VALOR
					EndIF

				else
					nValAbat += ABAT->E2_VALOR

				EndIf

			EndIf

			DBSelectArea("ABAT")
			DBSkip()

		EndDo

		DBSElectArea("ABAT")
		DBCloseArea("ABAT")

	Endif



Return(nValAbat)




Static Function AbaCom()

	Local nValAbat := 0


	If POSICIONE("SED",1,xFilial("SED") + PREV->ZA6_NATURE,"ED_PREVISA") == "2" // Filtra pelo Vencimento

		cQuery := "SELECT "
		cQuery += "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_NUMSC,A2_NOME,C7_COND,((SUM(C7_TOTAL) + SUM(C7_DESPESA) + SUM(C7_VALFRE)) - SUM(C7_VLDESC)) AS TOTAL,C1_NATUREZ FROM SC7010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "C7_FORNECE = A2_COD AND "
		cQuery += "C7_LOJA = A2_LOJA "
		cQuery += "INNER JOIN SC1010 ON "
		cQuery += "C1_FILIAL = C7_FILIAL AND "
		cQuery += "C1_PEDIDO = C7_NUM AND "
		cQuery += "C1_ITEM = C7_ITEMSC "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "C1_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "C7_RESIDUO <> 'S' AND "
		cQuery += "C7_ENCER = '' AND "
		cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
		cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "C7_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		Endif
		cQuery += "C1_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "C7_TIPO = 1 AND "
		cQuery += "C7_COND <> '006' AND "
		cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,A2_NOME,C7_COND,C1_NATUREZ "
		cQuery += "ORDER BY C7_EMISSAO "

		tcQuery cQuery New Alias "ABAT"

		DBSelectArea("ABAT")
		DBGOTOP()

		While !EOF()

			aRet := Condicao(ABAT->TOTAL,ABAT->C7_COND,,STOD(ABAT->C7_EMISSAO) + Posicione("SC8",11,ABAT->C7_FILIAL + ABAT->C7_NUM,"C8_PRAZO"),)
			cNumPed := alltrim(ABAT->C7_NUM)
			nVlComp := AbaAdiant()

			For i := 1 to Len(aRet)

				If DATAVALIDA(aRet[i][1]) == STOD(PREV->ZA6_VENCREA)
					IF (aREt[i][2] - nVlComp) <= 0
						nValAbat += 0
					ELSE
						nValAbat += aREt[i][2] - nVlComp
					ENDIF
				EndIf

			Next

			DBSelectArea("ABAT")
			DBskip()

		EndDo

		DBSelectArea("ABAT")
		DBCloseArea("ABAT")


	ELSEIF POSICIONE("SED",1,xFilial("SED") + PREV->ZA6_NATURE,"ED_PREVISA") == "1"    // Filtra pelo valor e vencimento fechado conforme inserido no parametro

		cQuery := "SELECT "
		cQuery += "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_NUMSC,A2_NOME,C7_COND,((SUM(C7_TOTAL) + SUM(C7_DESPESA) + SUM(C7_VALFRE)) - SUM(C7_VLDESC)) AS TOTAL,C1_NATUREZ,C7_FORNECE FROM SC7010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "C7_FORNECE = A2_COD AND "
		cQuery += "C7_LOJA = A2_LOJA "
		cQuery += "INNER JOIN SC1010 ON "
		cQuery += "C1_FILIAL = C7_FILIAL AND "
		cQuery += "C1_PEDIDO = C7_NUM AND "
		cQuery += "C1_ITEM = C7_ITEMSC "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "C1_NATUREZ = ED_CODIGO "
		cQuery += "WHERE "
		cQuery += "C7_RESIDUO <> 'S' AND "
		cQuery += "C7_ENCER = '' AND "
		cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
		cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
		cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
		If !EMPTY(PREV->ZA6_FORNEC)
			cQuery += "C7_FORNECE = '" + PREV->ZA6_FORNEC + "' AND "
		Endif
		cQuery += "C1_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
		cQuery += "C7_TIPO = 1 AND "
		cQuery += "C7_COND <> '006' AND "
		cQuery += "C7_NUM NOT IN ('019078','019079') AND " //LISTA DE EXCEÇOES - RAFAEL FRANÇA - 04/10/16
		cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
		cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC1010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SA2010.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,A2_NOME,C7_COND,C1_NATUREZ,C7_FORNECE "
		cQuery += "ORDER BY C7_EMISSAO "

		tcQuery cQuery New Alias "ABAT"

		DBSelectArea("ABAT")
		DBGOTOP()

		While !EOF()

			aRet := Condicao(ABAT->TOTAL,ABAT->C7_COND,,STOD(ABAT->C7_EMISSAO) + Posicione("SC8",11,ABAT->C7_FILIAL + ABAT->C7_NUM,"C8_PRAZO"),)
			cNumPed := alltrim(ABAT->C7_NUM)
			nVlComp := AbaAdiant()

			For i := 1 to Len(aRet)
				If DATAVALIDA(aRet[i][1]) >= STOD( MV_PAR20 + MV_PAR19 + "01" ) .AND. DATAVALIDA(aRet[i][1]) <= stod(MV_PAR20 + MV_PAR19 + cvaltochar((Last_Day( STOD( MV_PAR20 + MV_PAR19 + "01" ) ))) )

					If EMPTY(PREV->ZA6_FORNEC) // Não permite abater o valor de uma previsão inserida em uma natureza e fornecedor ja existente quando preencher o fornecedor em branco, evitando a duplicidade de infor,ações

						DBSelectArea("ZA6")
						DBSetOrder(2)
						IF(DBSeek(PREV->ZA6_FILIAL + PREV->ZA6_MES + PREV->ZA6_ANO + PREV->ZA6_NATURE + ABAT->C7_FORNECE))
							i++
							loop
						EndIf
					EndIf


					IF (aREt[i][2] - nVlComp) <= 0
						nValAbat += 0
					ELSE
						nValAbat += aREt[i][2] - nVlComp
					ENDIF

				EndIf

			Next

			DBSelectArea("ABAT")
			DBskip()

		EndDo

		DBSelectArea("ABAT")
		DBCloseArea("ABAT")


	EndIf


Return(nValAbat)


// Abate o valor do adiantamento dos pedidos de compras
Static Function AbaAdiant()

	Local nValAbat := 0
	Local cQuery := ""

	cQuery := "SELECT SUM(E2_VALOR) AS E2_VALOR FROM SE2010 WHERE "
	cQuery += "E2_PEDIDO = '" + (cNumPed) + "' AND "
	cQuery += "D_E_L_E_T_ <> '*' "

	tcQuery cQuery New Alias "ABAT1"

	nValAbat := ABAT1->E2_VALOR

	DBSElectArea("ABAT1")
	DBCloseArea("ABAT1")

Return(nValAbat)


//Rafael França - 19/09/17 - A pedido de Sra. Janaina foi colocado o abatimento nas naturezas de encargos financeiros (1205004 e 1205005)

Static Function AbatSE5()

	Local nValSE5 := 0
	Local cQuery := ""

	If MV_PAR23 == 1//Depende da ordem da Anapoli
		cQuery := "SELECT E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	ELSE
		cQuery := "SELECT E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) AS MES,SUM(E5_VALOR) AS VALOR "
	EndIf
	cQuery += "FROM SE5010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E5_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE5010.D_E_L_E_T_ = ''  AND "
	cQuery += "SED010.D_E_L_E_T_ = '' AND "
	cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
	cQuery += "E5_PREFIXO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "E5_NUMERO BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "' AND "
	cQuery += "E5_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "E5_PARCELA BETWEEN '" + (MV_PAR15) + "' AND '" + (MV_PAR16) + "' AND "
	cQuery += "E5_CLIFOR BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
	cQuery += "E5_FILIAL = '01'  AND "
	cQuery += "E5_TIPODOC <> 'CH' AND "
	cQuery += "E5_SITUACA <> 'C' AND "
	cQuery += "E5_RECONC = 'x' AND "
	cQuery += "E5_TIPO <> 'DC' AND "
	iF MV_PAR26 == 1 // Mes fechado, SIM OU NÃO?
		cQuery += "E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,3)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "'  AND "
	ELSE
		cQuery += "E5_DATA BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,4)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,2)),5,2) + "31" + "'  AND "
	Endif
	cQuery += "E5_RECPAG = 'P' AND "
	cQuery += "E5_NATUREZ = '" +ALLTRIM(PREV->ZA6_NATURE)+ "' "
	If MV_PAR23 == 1
		cQuery += "GROUP BY E5_FILIAL,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	ELSE
		cQuery += "GROUP BY E5_FILIAL,E5_NATUREZ,ED_DESCRIC,ED_NATGER,SUBSTRING(E5_DATA,5,2) "
	EndIf

	tcQuery cQuery New Alias "ABATSE5"

	nValSE5 := ABATSE5->VALOR

	DBSElectArea("ABATSE5")
	DBCloseArea("ABATSE5")

Return(nValSE5)

Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Da  Emissao 	  ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Ate Emissao 	  ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Do Pedido  		  ?","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"04","Ate Pedido 		  ?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"05","Da Natureza  	  ?","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"06","Ate Natureza      ?","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"07","Do Vencimento 	  ?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Ate Vencimento 	  ?","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Do Fornecedor 	  ?","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"10","Ate Fornecedor    ?","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"11","Do  Prefixo		?","","","mv_ch11","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Ate Preifxo		?","","","mv_ch12","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Do  Numero 		?","","","mv_ch13","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","Ate Numero 		?","","","mv_ch14","C",06,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"15","Da  Parcela 	?","","","mv_ch15","C",03,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"16","Ate Parcela 	?","","","mv_ch16","C",03,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"17","Do Tipo 	?","","","mv_ch17","C",03,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","05"})
	AADD(aRegs,{cPerg,"18","Ate Tipo 	?","","","mv_ch18","C",03,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","05"})
	AADD(aRegs,{cPerg,"19","Previsao do Mes?","","","mv_ch19","C",02,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"20","Previsao do Ano?","","","mv_ch20","C",04,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"21","Do Contrato ?","","","mv_ch21","C",06,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","SC3"})
	AADD(aRegs,{cPerg,"22","Ate Contrato ?","","","mv_ch22","C",06,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","SC3"})
	AADD(aRegs,{cPerg,"23","Ordem ?","","","mv_ch23","N",01,0,2,"C","","mv_par23","Napoli","","","","","Natureza","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"24","Do Bloco  ?","","","mv_ch24","C",06,0,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
	AADD(aRegs,{cPerg,"25","Ate Bloco ?","","","mv_ch25","C",06,0,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
	AADD(aRegs,{cPerg,"26","Mes Anterior ?","","","mv_ch26","N",01,0,2,"C","","mv_par26","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"27","Dt Referencia Previsao	  ?","","","mv_ch27","D",08,0,0,"G","","mv_par27","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"28","Dt Referencia Financeiro  ?","","","mv_ch28","D",08,0,0,"G","","mv_par28","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
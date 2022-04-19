#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FLUXODIA() Autor ≥ Rafael F       ∫ Data ≥    30/04/2014    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Valores pagos e a serem pagos 								±
±±          ±± 	                     									  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6 IDEs                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function FLUXODIA()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio"
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := ""
Private cPict          := ""
Private nLin           := 100

Private Cabec1         := ""
Private Cabec2         := ""
Private Cabec3         := ""
Private imprime        := .T.
Private aOrd 		   := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "FLUXODIA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FLUXODIA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "FLUXODIA5"
Private cString      := "SC7"
Private cQuery       := ""
Private titulo       := "Fluxo por dia"
Private aRet 	 	:= {}
Private aPedidos 	:= {}
Private aRegistro 	:= {}
Private cDias	 	:= ""
Private cNatureza	:= ""
Private nVec     	:= 0
Private nRec 		:= 0
Private nUlDia		:= 0
Private nValPrev 	:= 0
Private cForPrev 	:= ""
Private cCampo 		:= ""
Private nDias		:= 0
Private nPos		:= 0
Private nCol		:= 0
Private cCampo		:= ""
Private nNum		:= 0
Private nNum1		:= 0
Private nNum2		:= 0
Private nTotGer		:= 0
Private	lOk 		:= .T.
Private nVlComp 	:= 0
Private cNumPed 	:= ""
Private _aIExcel 	:= {}

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA«√O CANCELADA")
	return
ENDIF

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta a interface padrao com o usuario...                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando RelatÛrio")

Return

/*BEGINDOC
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Entrada dos ultimos 3 meses via Nota Fiscal≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
*/

Static Function Relatorio()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Verifica o realizado                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

cQuery := "SELECT E5_FILIAL,E5_DATA,E5_NATUREZ,ED_DESCRIC,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_FILIAL, "
cQuery += "E5_PREFIXO,E5_NUMERO,E5_TIPO,E5_PARCELA,E5_RECPAG,E5_CLIFOR,E5_LOJA,E5_HISTOR,ED_NATGER, E5_ORIGEM, "
cQuery += "E5_VALOR,E5_SEQ "
cQuery += "FROM SE5010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
cQuery += "AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E5_FILIAL = '01' "
cQuery += "AND E5_SITUACA <> 'C' AND E5_RECONC = 'x' AND E5_TIPO <> 'DC' "
cQuery += "AND SUBSTRING(E5_DATA,1,6) = '" + ALLTRIM(MV_PAR20) + ALLTRIM(MV_PAR19) + "' "
cQuery += "AND E5_RECPAG = 'P' "
cQuery += "AND E5_TIPODOC <> 'CH' "
cQuery += "AND E5_BANCO <> 'CXG' "
cQuery += "AND E5_NATUREZ <> '1503001' "
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR24+"' AND '"+MV_PAR25+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "ORDER BY E5_DATA,E5_NATUREZ "

tcQuery cQuery New Alias "REALIZ"

COUNT TO nVec

//Query cheques realizados

cQuery := "SELECT E5_DATA,E5_NUMCHEQ,E5_NATUREZ,ED_DESCRIC,ED_NATGER,E5_BANCO,E5_AGENCIA,E5_CONTA,SUM(E5_VALOR) AS VALOR "
cQuery += "FROM SE5010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
cQuery += "AND SED010.D_E_L_E_T_ = ''  "
cQuery += "AND E5_TIPODOC = 'BA' "
cQuery += "AND E5_BANCO <> 'CXG' "
cQuery += "AND SUBSTRING(E5_DATA,1,6) = '" + ALLTRIM(MV_PAR20) + ALLTRIM(MV_PAR19) + "' "
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR24+"' AND '"+MV_PAR25+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
//cQuery += "AND E5_DATA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
cQuery += "AND E5_NUMCHEQ <> '' "
cQuery += "AND E5_FILIAL = '01' "
cQuery += "GROUP BY E5_DATA,E5_NUMCHEQ,E5_NATUREZ,ED_DESCRIC,ED_NATGER,E5_BANCO,E5_AGENCIA,E5_CONTA "
cQuery += "ORDER BY E5_DATA,E5_NUMCHEQ,E5_NATUREZ,ED_DESCRIC,ED_NATGER,E5_BANCO,E5_AGENCIA,E5_CONTA "

tcQuery cQuery New Alias "CHEQUE"

COUNT TO nVec

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Query da duplicidade das Previsıes                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

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

tcQuery cQuery New Alias "DUPPREV" // FLUXODIA Vencimento

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

tcQuery cQuery New Alias "DUPPREV1" // FLUXODIA Valor

COUNT TO nRec

If nRec != 0 .OR. nVec != 0 // N„o permite imprimir o relatÛrio caso alguma informaÁ„o esteja duplicada!
	Alert("Existe informaÁıes duplicadas no cadastro de Previsıes, favor corrigi-las")
	DBSELECTAREA("DUPPREV")
	DBCloseArea()
	DBSELECTAREA("DUPPREV1")
	DBCloseArea()
	REturn
EndIf

//≥Query das Previsıes≥

cQuery := "SELECT * FROM ZA6010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "ZA6_NATURE = ED_CODIGO "
cQuery += "WHERE "
cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
cQuery += "ZA6_MES = '" + (MV_PAR19) + "' AND "
cQuery += "ZA6_ANO = '" + (MV_PAR20) + "' AND "
cQuery += "ZA6_FORNEC BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
cQuery += "ZA6_NATURE BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "ZA6_VENCRE BETWEEN '" + DTOS(MV_PAR26) + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "ZA6010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ZA6_NATURE,ZA6_FORNEC"

tcQuery cQuery New Alias "PREV"

//≥Query dos pedidos de Compras≥

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
cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoÁ„o de pedido do fluxo de caixa a pagar
cQuery += "C7_ENCER = '' AND "
cQuery += "C7_COND <> '006' AND "
cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
cQuery += "C1_NATUREZ BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "C7_TIPO = 1 AND "
cQuery += "C7_NUM NOT IN ('019078','019079') AND " //LISTA DE EXCE«OES - RAFAEL FRAN«A - 04/10/16
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,A2_NOME,C7_COND,C1_NATUREZ "
cQuery += "ORDER BY C7_EMISSAO "

tcQuery cQuery New Alias "TMP"

//≥Query dos titulos do Financeiro≥

cQuery := "SELECT "
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
cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // SolicitaÁ„o feita pela Dona Elenn, Edna enviou o e-mail solicitando a n„o impress„o desses fornecedores no dia 28/04/2014 as 12:56h
cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
cQuery += "E2_BAIXA = '' AND "
cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
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
cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // SolicitaÁ„o feita pela Dona Elenn, Edna enviou o e-mail solicitando a n„o impress„o desses fornecedores no dia 28/04/2014 as 12:56h
cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
cQuery += "E2_BAIXA >= '" + DTOS(MV_PAR26) +"' AND "
cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
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
cQuery += "SE2010.E2_FORNECE NOT IN ('000676') AND " // SolicitaÁ„o feita pela Dona Elenn, Edna enviou o e-mail solicitando a n„o impress„o desses fornecedores no dia 28/04/2014 as 12:56h
cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
cQuery += "E2_BAIXA < '" + DTOS(MV_PAR26) + "' AND "
cQuery += "E2_BAIXA <> '' AND "
cQuery += "E2_SALDO  <> 0 AND "
cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
cQuery += "E2_FLUXO <> 'N' AND "
cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*'  AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY E2_FILIAL,E2_VENCREA "

tcQuery cQuery New Alias "FIN"

//≥Query das previsıes dos contratos que est„o pendentes para vinculaÁ„o do mes atual≥

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

//≥Query das AutorizaÁıes de Entrega que est„o pendentes para vinculaÁ„o do mes seguinte ≥
//≥Busco o mes anterior, provavelmente v„o exitir poucas, pois as notas j· foram lanÁadas≥

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
cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoÁ„o de pedido do fluxo de caixa a pagar
cQuery += "C7_ENCER = '' AND "
cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1)) + "' AND '" + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),1,6) + "31" + "' AND "
//cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "' AND "
cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
cQuery += "C7_TIPO = 2 AND "
cQuery += "C3_PERMUTA <> '1' AND "
//cQuery += "C3_FLUXO = '1' AND "
cQuery += "(C3_MESPAG = '2' OR  C7_NUM IN ('028057','028058','028059','028062','028064')) AND " //Rafael FranÁa - 02/06/2019 - Coloca a pedido do Wallace para n„o validar a regra do mÍs atual nesses casos.
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
cQuery += "(C7_NUM IN ('016065','016772','016737','020270','020238','021169','021227') AND ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "')" //Lista de exceÁıes
cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,C7_ITEMSC,A2_NOME,C7_COND,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS "
cQuery += "ORDER BY C7_NUMSC,C7_ITEMSC "

tcQuery cQuery New Alias "ANTAENT"

//≥Query das autorizaÁıes de Entrega≥


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
cQUery += "C7_FLUXO <> 'N' AND " //Pedro Leonardo 17/09/21 - Regra de remoÁ„o de pedido do fluxo de caixa a pagar
cQuery += "C7_ENCER = '' AND "
cQuery += "C7_FILIAL = '" + xFilial("SC7") + "' AND "
cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "ED_NATGER BETWEEN '" + (MV_PAR24) + "' AND '" + (MV_PAR25) + "' AND "
cQuery += "C7_EMISSAO BETWEEN '" + MV_PAR20 + MV_PAR19 + "01" + "' AND '" + MV_PAR20 + MV_PAR19 + "31" + "' AND "
cQuery += "C7_NUM BETWEEN '" + (MV_PAR03) +  "' AND '" + (MV_PAR04) +  "' AND "
cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) +  "' AND '" + (MV_PAR10) +  "' AND "
cQuery += "C7_TIPO = 2 AND "
cQuery += "C3_NUM <> '000085' AND "
cQuery += "C3_PERMUTA <> '1' AND "
//cQuery += "C3_FLUXO = '1' AND "
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY C7_FILIAL,C7_EMISSAO,C7_NUMSC,C7_NUM,C7_ITEMSC,A2_NOME,C7_COND,ED_CODIGO,ED_DESCRIC,ED_NATGER,C7_OBS "
cQuery += "ORDER BY C7_NUMSC,C7_ITEMSC "

tcQuery cQuery New Alias "AENT"

//≥Query das previsıes dos contratos que est„o pendentes para vinculaÁ„o do mes SEGUINTE≥

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
cQuery += "C3_RENOVA = '' AND "
cQuery += "C3_PERMUTA <> '1' AND "
cQuery += "C3_FLUXO = '1' AND "
cQuery += "C3_MESPAG = '2' AND "
cQuery += "C3_NUM+C3_ITEM NOT IN (SELECT C7_NUMSC+C7_ITEMSC FROM SC7010 WHERE "
cQuery += "C7_NUMSC = C3_NUM AND "
cQuery += "C7_ITEMSC = C3_ITEM AND "
cQuery += "C7_TIPO = 2 AND "
cQuery += "C7_FORNECE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
cQuery += "C7_EMISSAO BETWEEN '" + DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1)) + "' AND '" + MV_PAR20 + SUBSTR(DTOS(MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "25") ,1)),5,2) + "31" + "' "
cQuery += "GROUP BY C7_NUMSC,C7_ITEMSC) "

tcQuery cQuery New Alias "ANTCONTR"

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },titulo)

Return

//Programa de impressao

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Adiciona Realizado

DBSelectArea("REALIZ")
DBGotop()

While !EOF() .AND. DATAVALIDA(STOD(REALIZ->E5_DATA)) < MV_PAR27

	If (TemBxCanc(REALIZ->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .OR. REALIZ->E5_ORIGEM = "FINA100" ) .AND. REALIZ->E5_NATUREZ <> "1205005"
		REALIZ->(dbSkip())
		Loop
	EndIf

	aAdd(aPedidos,{,;  //01 Emissao
	,; //02 Numero
	DATAVALIDA(STOD(REALIZ->E5_DATA)),;//Data do Vencimento  03
	,; //04
	,;                    //05
	REALIZ->E5_VALOR,; // Valor do Pagamento //06
	REALIZ->ED_NATGER,; // SubNatureza 07
	,;// DescriÁ„o  da SubNatureza 08
	REALIZ->E5_NATUREZ,;// Cod Natureza 09
	REALIZ->ED_DESCRIC,;// DescriÁ„o Natureza 10
	"REALIZADO",; // Tipo 11
	}) // Numero 12

	DBSelectArea("REALIZ")
	DBSkip()

ENDDO

//Adiciona CHEQUES Realizado

DBSelectArea("CHEQUE")
DBGotop()

While !EOF() .AND. DATAVALIDA(STOD(CHEQUE->E5_DATA)) < MV_PAR27

	aAdd(aPedidos,{,;  //01 Emissao
	,; //02 Numero
	DATAVALIDA(STOD(CHEQUE->E5_DATA)),;//Data do Vencimento  03
	,; //04
	,;                    //05
	CHEQUE->VALOR,; // Valor do Pagamento //06
	CHEQUE->ED_NATGER,; // SubNatureza 07
	,;// DescriÁ„o  da SubNatureza 08
	CHEQUE->E5_NATUREZ,;// Cod Natureza 09
	CHEQUE->ED_DESCRIC,;// DescriÁ„o Natureza 10
	"CHEQUE",; // Tipo 11
	}) // Numero 12

	DBSelectArea("CHEQUE")
	DBSkip()

ENDDO

//≥Adiciona no Vetor a AUTORIZA«AO DE ENTREGA que ainda n„o LAN«ADA UMA NOTA NO MES DA FLUXODIA≥

DBSelectArea("AENT")
DBGotop()

While !EOF()

	aRet := Condicao(AENT->TOTAL,AENT->C7_COND,,STOD(AENT->C7_EMISSAO),)

	For i := 1 to Len(aRet)

		If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08 .AND. DATAVALIDA(aRet[i][1]) >= MV_PAR27

			aAdd(aPedidos,{STOD(AENT->C7_EMISSAO),;  //01 Emissao
			"FLUXODIA",; //02 Numero
			DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
			AENT->A2_NOME,; //04
			FwNoAccent(UPPER(AENT->C7_OBS)),;                    //05
			aREt[i][2],; // Valor do Pagamento //06
			AENT->ED_NATGER,; // SubNatureza 07
			Posicione("SX5",1,xFilial("SX5") + "ZV" + AENT->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
			AENT->ED_CODIGO,;// Cod Natureza 09
			AENT->ED_DESCRIC,;// DescriÁ„o Natureza 10
			"AENTREGASEG",; // Tipo 11
			AENT->C7_NUM}) // Numero 12

		EndIf

	Next

	DBSelectArea("AENT")
	DBSkip()

eNDDO

//≥Adiciona no Vetor a AUTORIZA«AO DE ENTREGA que ainda n„o LAN«ADA UMA NOTA NO MES ANTERIOR≥


DBSelectArea("ANTAENT")
DBGotop()

While !EOF()

	aRet := Condicao(ANTAENT->TOTAL,ANTAENT->C7_COND,,STOD(ANTAENT->C7_EMISSAO),)

	For i := 1 to Len(aRet)

		If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08 .AND. DATAVALIDA(aRet[i][1]) >= MV_PAR27

			aAdd(aPedidos,{STOD(ANTAENT->C7_EMISSAO),;  //01 Emissao
			"FLUXODIA",; //02 Numero
			DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
			ANTAENT->A2_NOME,; //04
			FwNoAccent(UPPER(ANTAENT->C7_OBS)),;                    //05
			aREt[i][2],; // Valor do Pagamento //06
			ANTAENT->ED_NATGER,; // SubNatureza 07
			Posicione("SX5",1,xFilial("SX5") + "ZV" + ANTAENT->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
			ANTAENT->ED_CODIGO,;// Cod Natureza 09
			ANTAENT->ED_DESCRIC,;// DescriÁ„o Natureza 10
			"AENTREGA",; // Tipo 11
			ANTAENT->C7_NUM}) // Numero 12

		EndIf

	Next

	DBSelectArea("ANTAENT")
	DBSkip()

eNDDO

//≥Adiciona no Vetor a Previs„o dos Contratos do pagamento mes seguinte (periodo anterior) que ainda n„o foram lanÁados na autorizaÁ„o de entrega dos mes seguinte≥

DBSelectArea("ANTCONTR")
DBGotop()

While !EOF()

	If STOD(ANTCONTR->C3_DATPRI) <= LastDate(STOD(MV_PAR20 + MV_PAR19 + "01"))//N„o pode imprimir o relatÛrio que ainda n„o se iniciou

		IF DATAVALIDA(STOD(MV_PAR20 + MV_PAR19 + ANTCONTR->C3_VENC)) >= MV_PAR27

			If (SUBSTR(ANTCONTR->C3_DATPRI,1,6) != (MV_PAR20 + MV_PAR19))//Todo contrato que se inicia no mes da previs„o e est· configurado para o mes seguinte n„o pode aparecer no relatÛrio.

				aAdd(aPedidos,{MONTHSUB(STOD(MV_PAR20 + MV_PAR19 + "01") ,1),;  //01 Emissao
				"FLUXODIA",; //02 Numero
				DATAVALIDA(STOD(MV_PAR20 + MV_PAR19 + ANTCONTR->C3_VENC)),;//Data do Vencimento  03
				ANTCONTR->A2_NOME,; //Nome do Fornecedor 04
				FwNoAccent(UPPER(ANTCONTR->C3_OBS)),; // HISTORICO //05
				ANTCONTR->C3_PRECO,; // Valor do Pagamento //06
				ANTCONTR->ED_NATGER,; // SubNatureza 07
				Posicione("SX5",1,xFilial("SX5") + "ZV" + ANTCONTR->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
				ANTCONTR->C3_NATUREZ,;// Cod Natureza 09
				ANTCONTR->ED_DESCRIC,; // DescriÁ„o Natureza 10
				"ANTCONTRATO",;  // Tipo 11
				ANTCONTR->C3_NUM + ANTCONTR->C3_ITEM }) // Numero 12

			ENDIF

		ENDIF

	ENDIF

	DBSelectArea("ANTCONTR")
	DBSkip()

eNDDO

//≥Adiciona no Vetor a Previs„o dos Contratos que ainda n„o foram lanÁados na autorizaÁ„o de entrega dos mes seguinte≥

DBSelectArea("CONTR")
DBGotop()

While !EOF()

	If STOD(CONTR->C3_DATPRI) <= LastDate(STOD(MV_PAR20 + MV_PAR19 + "01"))//N„o pode imprimir o relatÛrio que ainda n„o se iniciou

		IF DATAVALIDA(STOD(MV_PAR20 + MV_PAR19 + CONTR->C3_VENC)) >= MV_PAR27

			aAdd(aPedidos,{STOD(MV_PAR20 + MV_PAR19 + "01"),;  //01 Emissao
			"FLUXODIA",; //02 Numero
			DATAVALIDA(STOD(MV_PAR20 + MV_PAR19 + CONTR->C3_VENC)),;//Data do Vencimento  03
			CONTR->A2_NOME,; //Nome do Fornecedor 04
			FwNoAccent(UPPER(CONTR->C3_OBS)),; // HISTORICO //05
			CONTR->C3_PRECO,; // Valor do Pagamento //06
			CONTR->ED_NATGER,; // SubNatureza 07
			Posicione("SX5",1,xFilial("SX5") + "ZV" + CONTR->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
			CONTR->C3_NATUREZ,;// Cod Natureza 09
			CONTR->ED_DESCRIC,; // DescriÁ„o Natureza 10
			"CONTRATO",;  // Tipo 11
			CONTR->C3_NUM + CONTR->C3_ITEM }) // Numero 12

		ENDIF

	ENDIF

	DBSelectArea("CONTR")
	DBSkip()

eNDDO

//≥Adiciona no Vetor as previsıes do cadastro das provisıes j· com os descontos abatidos
//≥ da previs„o de compras e do titulos a pagar caso existam

DBSelectArea("PREV")
DBGotop()

While !EOF()

	nValPrev := PREV->ZA6_VALOR

	IF ALLTRIM(PREV->ZA6_NATURE) == "1205004" .OR. ALLTRIM(PREV->ZA6_NATURE) == "1205005"
		nValPrev := PREV->ZA6_VALOR - AbatSE5()
	ENDIF

	nValPrev := nValPrev - AbaFin()
	nValPrev := nValPrev - AbaCom()

	If nValPrev > 0

		//Quando for previs„o do RH n„o È para abater e sim substituir
		If PREV->ED_PREVISA == "2"
			IF PREV->ZA6_NATGER = '0001'
				If nValPrev != PREV->ZA6_VALOR
					DBSelectArea("PREV")
					DBSkip()
					loop
				EndIf
			EndIf
		EndIf

		If EMPTY(PREV->ZA6_NMFOR)
			cForPrev := PREV->ZA6_NMNAT
		ELSE
			cForPrev := PREV->ZA6_NMFOR
		EndIf

		IF 	DATAVALIDA(STOD(PREV->ZA6_VENCRE)) >= MV_PAR27

			aAdd(aPedidos,{STOD(MV_PAR20 + MV_PAR19 + "01"),;  //01 Emissao
			"FLUXODIA",; //02 Numero
			DATAVALIDA(STOD(PREV->ZA6_VENCRE)),;//Data do Vencimento  03
			cForPrev,; //Nome do Fornecedor 04
			FwNoAccent(UPPER(PREV->ZA6_HIST)),; // HISTORICO //05
			nValPrev,; // Valor do Pagamento //06
			PREV->ED_NATGER,; // SubNatureza 07
			Posicione("SX5",1,xFilial("SX5") + "ZV" + PREV->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
			PREV->ZA6_NATURE,;// Cod Natureza 09
			PREV->ZA6_NMNAT,; // DescriÁ„o Natureza 10
			"FLUXODIA",;  // Tipo 11
			PREV->ZA6_CODIGO}) // Numero 12

		ENDIF

	EndIf

	DBSelectArea("PREV")
	DBSkip()

ENDDO

//≥Adiciona no vetor as previsıes dos pedidos de compras≥

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())

	aRet := Condicao(TMP->TOTAL,TMP->C7_COND,,STOD(TMP->C7_EMISSAO) + Posicione("SC8",11,TMP->C7_FILIAL + TMP->C7_NUM,"C8_PRAZO"),)
	cNumPed := alltrim(TMP->C7_NUM)
	nVlComp := AbaAdiant()

	For i := 1 to Len(aRet)

		If DATAVALIDA(aRet[i][1]) >= MV_PAR07 .AND. DATAVALIDA(aRet[i][1]) <= MV_PAR08 .AND. DATAVALIDA(aRet[i][1]) >= MV_PAR27

			nVlComp := aREt[i][2] - nVlComp

			If nVlComp <= 0
				nVlComp * -1

			else

				dbSelectArea("SZL")
				dbSetOrder(2)
				DbSeek(xFilial("SZL") + TMP->C7_NUM)   //Consulta detalhe do pedido para buscar o historico

				aAdd(aPedidos,{STOD(TMP->C7_EMISSAO),;  //01 Emissao
				"FLUXODIA",; //02 Numero
				DATAVALIDA(aRet[i][1]),;//Data do Vencimento  03
				TMP->A2_NOME,; //04
				FwNoAccent(UPPER(SZL->ZL_OBS1)),;                    //05
				nVlComp,; // Valor do Pagamento //06
				POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_NATGER"),; // SubNatureza 07
				Posicione("SX5",1,xFilial("SX5") + "ZV" + POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_NATGER"),"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
				TMP->C1_NATUREZ,;// Cod Natureza 09
				POSICIONE("SED",1,xFilial("SED")+TMP->C1_NATUREZ,"ED_DESCRIC"),;// DescriÁ„o Natureza 10
				"PEDIDO",; // Tipo 11
				TMP->C7_NUM}) // Numero 12

			EndIf

		EndIf

	Next

	DBSelectArea("TMP")
	DBSkip()

Enddo

//≥Adiciona no Vetor os titulos a pagar que precisam ser pagos≥

DBSelectArea("FIN")
DBGotop()


While !EOF()

	IF DATAVALIDA(STOD(FIN->E2_VENCREA)) >= MV_PAR27

		IF !(ALLTRIM(FIN->E2_NATUREZ) == "1206004" .AND. ALLTRIM(FIN->E2_FORNECE) == "000073")// Solicitado pela Pamela no dia 07/11/2014 pela Pamela

			IF (Posicione("SF1",1,FIN->E2_FILIAL + FIN->E2_NUM + FIN->E2_PREFIXO + FIN->E2_FORNECE + FIN->E2_LOJA ,"F1_COND") != "006") // Se for permuta n„o adiciona no vetor

				If !(FIN->E2_DESDOBR == "S" .AND. EMPTY(FIN->E2_PARCELA))//N„o adiciona titulo que foi desdobrado para n„o gerar duplicidade

					aAdd(aPedidos,{STOD(FIN->E2_EMISSAO),;  //01 Emissao
					FIN->E2_NUM,; //02 Numero
					DATAVALIDA(STOD(FIN->E2_VENCREA)),;//Data do Vencimento  03
					FIN->A2_NOME,; //Nome do Fornecedor 04
					IIF(EMPTY(FIN->E2_HIST),FIN->ED_DESCRIC,FwNoAccent(UPPER(FIN->E2_HIST))),;// HISTORICO //05
					FIN->E2_VALOR,; // Valor do Pagamento //06
					FIN->ED_NATGER,; // SubNatureza 07
					Posicione("SX5",1,xFilial("SX5") + "ZV" + FIN->ED_NATGER,"X5_DESCRI"),;// DescriÁ„o  da SubNatureza 08
					FIN->E2_NATUREZ,;// Cod Natureza 09
					FIN->ED_DESCRIC,; // DescriÁ„o Natureza 10
					"NOTA",;  // Tipo 11
					FIN->E2_NUM}) // Numero 12

				ENDIF

			ENDIF

		ENDIF

	ENDIF

	DBSelectArea("FIN")
	DBSkip()

eNDDO

IF MV_PAR23 == 2  //≥Ordenar o relatÛrio por ordem Napoli ou Natureza≥

	ASORT(aPedidos,,,{|x,y|x[9]+DTOS(x[3]) < y[9]+DTOS(y[3])})

	nNum := 1
	nNum1 := 1
	nNum2 := 1

	For i:=1 to Len(aPedidos)


		IF ALLTRIM(aPedidos[i][9]) <> cNatureza .AND. ALLTRIM(aPedidos[i][9]) <> "1205017" .AND. ALLTRIM(aPedidos[i][7]) <> "0007"  //SEPARA AS TRANSFERENCIAS E INVESTIMENTOS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][9]),aPedidos[i][10],;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0})

			nNum += 1
			nNum1 += 1
			nNum2 += 1

		ENDIF

		cNatureza  := ALLTRIM(aPedidos[i][9])

	Next
	aAdd(aRegistro,{"SUBTOTAL","PAGAMENTOS DO DIA --->",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})

	nNum += 1
	nNum2 += 1

	aAdd(aRegistro,{"","",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})

	nNum += 1
	nNum2 += 1

	//INVESTIMENTOS

	For i:=1 to Len(aPedidos)

		IF ALLTRIM(aPedidos[i][9]) <> cNatureza .AND. ALLTRIM(aPedidos[i][9]) <> "1205017" .AND. ALLTRIM(aPedidos[i][7]) == "0007"  //SEPARA AS TRANSFERENCIAS E INVESTIMENTOS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][9]),aPedidos[i][10],;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0})

			nNum += 1
			nNum2 += 1

		ENDIF

		cNatureza  := ALLTRIM(aPedidos[i][9])

	Next

	aAdd(aRegistro,{"SUBTOTAL","INVESTIMENTOS     --->",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,ª0})

	nNum += 1

	aAdd(aRegistro,{"","",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})

	nNum += 1

	aAdd(aRegistro,{"TOTAL   ","--------->",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})

	For i:=1 to Len(aPedidos)


		IF ALLTRIM(aPedidos[i][9]) == "1205017" .AND. lOk //SEPARA AS TRANSFERENCIAS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][9]),aPedidos[i][10],;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0})

			lOk := .F.

		ENDIF

	Next


	For i:=1 to Len(aPedidos)

		nPos := aScan(aRegistro, { |x| x[1] == ALLTRIM(aPedidos[i][9])})
		nCol := (day(DATAVALIDA(aPedidos[i][3])) + 2)

		IF month(DATAVALIDA(aPedidos[i][3])) == val(mv_par19)

			IF ALLTRIM(aPedidos[i][9]) <> "1205017"  .AND. ALLTRIM(aPedidos[i][7]) <> "0007"   //SEPARA AS TRANSFERENCIAS

				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nNum][nCol] += aPedidos[i][6]
				aRegistro[nNum1][nCol] += aPedidos[i][6]
				aRegistro[nPos][34]   += aPedidos[i][6]
				aRegistro[nNum][34]	  += aPedidos[i][6]
				aRegistro[nNum1][34]	  += aPedidos[i][6]
			ELSEIF ALLTRIM(aPedidos[i][9]) <> "1205017"  .AND. ALLTRIM(aPedidos[i][7]) == "0007"
				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nNum][nCol] += aPedidos[i][6]
				aRegistro[nNum2][nCol] += aPedidos[i][6]
				aRegistro[nPos][34]   += aPedidos[i][6]
				aRegistro[nNum][34]	  += aPedidos[i][6]
				aRegistro[nNum2][34]	  += aPedidos[i][6]
			ELSE
				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nPos][34]   += aPedidos[i][6]
			ENDIF

		ENDIF

	Next

	//Monta Estrutura da planilha

	nUlDia := Day(LastDay(STOD(MV_PAR20 + MV_PAR19 + "01"),0)) //Verifica o ultimo dia

	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"CODNAT"       	, "C" , 010 , 00 } )
	aadd( _aCExcel , {"DESCRICAO"		, "C" , 030 , 00 } )

	For i := 1  to nUlDia
		nDias += 1
		aadd( _aCExcel ,{"DIA_" + STRZERO(nDias,2)	, "N" , 010 , 02 } )
	Next

	aadd( _aCExcel ,{"TOTAL"	, "N" , 012 , 02 } )

	//	_cTemp := CriaTrab(_aCExcel,.T.)
	//	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

	nDias 	:= 0
	nCol 	:= 2

	For i:=1 to Len(aRegistro)

		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01] 		:= aRegistro[i][1]
		_aItem[02] 		:= aRegistro[i][2]
		_aItem[03]        := aRegistro[i][3]
		_aItem[04]        := aRegistro[i][4]
		_aItem[05]        := aRegistro[i][5]
		_aItem[06]        := aRegistro[i][6]
		_aItem[07]        := aRegistro[i][7]
		_aItem[08]        := aRegistro[i][8]
		_aItem[09]        := aRegistro[i][9]
		_aItem[10]        := aRegistro[i][10]
		_aItem[11]        := aRegistro[i][11]
		_aItem[12]        := aRegistro[i][12]
		_aItem[13]        := aRegistro[i][13]
		_aItem[14]        := aRegistro[i][14]
		_aItem[15]        := aRegistro[i][15]
		_aItem[16]        := aRegistro[i][16]
		_aItem[17]        := aRegistro[i][17]
		_aItem[18]        := aRegistro[i][18]
		_aItem[19]        := aRegistro[i][19]
		_aItem[20]        := aRegistro[i][20]
		_aItem[21]        := aRegistro[i][21]
		_aItem[22]        := aRegistro[i][22]
		_aItem[23]        := aRegistro[i][23]
		_aItem[24]        := aRegistro[i][24]
		_aItem[25]        := aRegistro[i][25]
		_aItem[26]        := aRegistro[i][26]
		_aItem[27]        := aRegistro[i][27]
		_aItem[28]        := aRegistro[i][28]
		_aItem[29]        := aRegistro[i][29]
		_aItem[30]        := aRegistro[i][30]

		IF nUlDia == 28
			_aItem[31]       := aRegistro[i][34]
		END

		IF nUlDia == 29
			_aItem[31]        := aRegistro[i][31]
			_aItem[32]       := aRegistro[i][34]
		END

		IF nUlDia == 30
			_aItem[31]        := aRegistro[i][31]
			_aItem[32]        := aRegistro[i][32]
			_aItem[33]       := aRegistro[i][34]
		END

		IF nUlDia == 31
			_aItem[31]        := aRegistro[i][31]
			_aItem[32]        := aRegistro[i][32]
			_aItem[33]        := aRegistro[i][33]
			_aItem[34]       := aRegistro[i][34]
		END

		AADD(_aIExcel,_aItem)
		_aItem := {}

	Next

ELSEIF MV_PAR23 == 1

	ASORT(aPedidos,,,{|x,y|x[7]+DTOS(x[3]) < y[7]+DTOS(y[3])})

	nNum := 1
	nNum1 := 1
	nNum2 := 1

	For i:=1 to Len(aPedidos)


		IF ALLTRIM(aPedidos[i][7]) <> cNatureza .AND. ALLTRIM(aPedidos[i][9]) <> "1205017" .AND. ALLTRIM(aPedidos[i][7]) <> "0007"  //SEPARA AS TRANSFERENCIAS E INVESTIMENTOS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][7]),Posicione("SX5",1,xFilial("SX5") + "ZV" + alltrim(aPedidos[i][7]),"X5_DESCRI"),0,0,0})

			nNum += 1
			nNum1 += 1
			nNum2 += 1

		ENDIF

		cNatureza  := ALLTRIM(aPedidos[i][7])

	Next
	aAdd(aRegistro,{"SUBTOTAL","------->",0,0,0})

	nNum += 1

	//INVESTIMENTOS

	For i:=1 to Len(aPedidos)

		IF ALLTRIM(aPedidos[i][7]) <> cNatureza .AND. ALLTRIM(aPedidos[i][9]) <> "1205017" .AND. ALLTRIM(aPedidos[i][7]) == "0007"  //SEPARA AS TRANSFERENCIAS E INVESTIMENTOS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][7]),Posicione("SX5",1,xFilial("SX5") + "ZV" + alltrim(aPedidos[i][7]),"X5_DESCRI"),0,0,0})

			nNum += 1
			nNum2 += 1

		ENDIF

		cNatureza  := ALLTRIM(aPedidos[i][7])

	Next

	aAdd(aRegistro,{"TOTAL   ","--------->",0,0,0})

	For i:=1 to Len(aPedidos)


		IF ALLTRIM(aPedidos[i][9]) == "1205017" .AND. lOk //SEPARA AS TRANSFERENCIAS

			aAdd(aRegistro,{ALLTRIM(aPedidos[i][7]),Posicione("SX5",1,xFilial("SX5") + "ZV" + alltrim(aPedidos[i][7]),"X5_DESCRI"),0,0,0})

			lOk := .F.

		ENDIF

	Next


	For i:=1 to Len(aPedidos)

		nPos := aScan(aRegistro, { |x| x[1] == ALLTRIM(aPedidos[i][7])})
		IF DATAVALIDA(aPedidos[i][3]) < MV_PAR27
			nCol := 3
		ELSE
			nCol := 4
		ENDIF

		If nPos > 0

		IF month(DATAVALIDA(aPedidos[i][3])) == val(mv_par19)

			IF ALLTRIM(aPedidos[i][9]) <> "1205017"  .AND. ALLTRIM(aPedidos[i][7]) <> "0007"   //SEPARA AS TRANSFERENCIAS

				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nNum][nCol] += aPedidos[i][6]
				aRegistro[nNum1][nCol] += aPedidos[i][6]
				aRegistro[nPos][5]   += aPedidos[i][6]
				aRegistro[nNum][5]	  += aPedidos[i][6]
				aRegistro[nNum1][5]	  += aPedidos[i][6]
			ELSEIF ALLTRIM(aPedidos[i][9]) <> "1205017"  .AND. ALLTRIM(aPedidos[i][7]) == "0007"
				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nNum][nCol] += aPedidos[i][6]
				aRegistro[nPos][5]   += aPedidos[i][6]
				aRegistro[nNum][5]	  += aPedidos[i][6]
			ELSE
				aRegistro[nPos][nCol] += aPedidos[i][6]
				aRegistro[nPos][5]   += aPedidos[i][6]
			ENDIF

		ENDIF

		EndIf

	Next

	//Monta Estrutura da planilha

	nUlDia := Day(LastDay(STOD(MV_PAR20 + MV_PAR19 + "01"),0)) //Verifica o ultimo dia

	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"CODNAT"       	, "C" , 010 , 00 } )
	aadd( _aCExcel , {"DESCRICAO"		, "C" , 030 , 00 } )
	aadd( _aCExcel ,{"REALIZADO"	, "N" , 012 , 02 } )
	aadd( _aCExcel ,{"PREVISAO"	, "N" , 012 , 02 } )
	aadd( _aCExcel ,{"TOTAL"	, "N" , 012 , 02 } )

	//_cTemp := CriaTrab(_aIExcel,.T.)
	//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

	nDias 	:= 0
	nCol 	:= 2

	For i:=1 to Len(aRegistro)

		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= aRegistro[i][1]
		_aItem[02]		:= aRegistro[i][2]
		_aItem[03]        := aRegistro[i][3]
		_aItem[04]        := aRegistro[i][4]
		_aItem[05]       := aRegistro[i][5]
		AADD(_aIExcel,_aItem)
		_aItem := {}

	Next


ENDIF


If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

//DBSelectArea("TMP1")
//DBCloseARea("TMP1")
DBSelectArea("TMP")
DBCloseARea()
DBSelectArea("FIN")
DBCloseARea()
DBSelectArea("DUPPREV")
DBCloseARea()
DBSelectArea("DUPPREV1")
DBCloseARea()
DBSelectArea("CONTR")
DBCloseARea()
DBSelectArea("AENT")
DBCloseARea()
DBSelectArea("PREV")
DBCloseARea()
DBSelectArea("ANTAENT")
DBCloseARea()
DBSelectArea("ANTCONTR")
DBCloseARea()
DBSelectArea("REALIZ")
DBCloseARea()
DBSelectArea("CHEQUE")
DBCloseARea()


//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Fluxo a Pagar por Dia - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","FLUXODIA")
	_lRet := .F.
ENDIF

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
	cQuery += "E2_BAIXA >= '" + DTOS(MV_PAR26) + "' AND "
	cQuery += "E2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "' AND "
	cQuery += "SE2010.E2_TIPO BETWEEN '" + (MV_PAR17) + "' AND '" + (MV_PAR18) + "' AND "
	cQuery += "SE2010.E2_NATUREZ = '" + PREV->ZA6_NATURE + "' AND "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
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
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
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


	While !EOF()//N„o soma o titulo principal do desdobramento

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
		DBCLOSEAREA()

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

ELSEIF POSICIONE("SED",1,xFilial("SED") + PREV->ZA6_NATURE,"ED_PREVISA") == "1"    // Filtra pelo valor e vencimento fechado conforme inserido no parametro

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
	cQuery += "SE2010.E2_BAIXA >= '" + DTOS(MV_PAR26) + "' AND "
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
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
	cQuery += "E2_FATURA <> 'NOTFAT' AND "	//Regra para n„o apresentar o tÌtulo gerado por aglutinaÁ„o, n„o gerando duplicidade
	cQuery += "SE2010.E2_FLUXO <> 'N' AND "
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


	While !EOF()//N„o soma o titulo principal do desdobramento e notas vinculadas aos contratos

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
		DBCLOSEAREA()

		DBSelectArea("ABAT")

		if lOkCon

			If EMPTY(PREV->ZA6_FORNEC) // N„o permite abater o valor de uma previs„o inserida em uma natureza e fornecedor ja existente quando preencher o fornecedor em branco, evitando a duplicidade de infor,aÁıes

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

Endif

DBSElectArea("ABAT")
DBCloseArea()


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
	cQuery += "C7_NUM NOT IN ('019078','019079') AND " //LISTA DE EXCE«OES - RAFAEL FRAN«A - 04/10/16
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

				If EMPTY(PREV->ZA6_FORNEC) // N„o permite abater o valor de uma previs„o inserida em uma natureza e fornecedor ja existente quando preencher o fornecedor em branco, evitando a duplicidade de infor,aÁıes

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

EndIf

DBSElectArea("ABAT")
DBCloseArea()

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
DBCloseArea()

Return(nValAbat)


//Rafael FranÁa - 19/09/17 - A pedido de Sra. Janaina foi colocado o abatimento nas naturezas de encargos financeiros (1205004 e 1205005)

Static Function AbatSE5()

Local nValSE5 := 0
Local cQuery := ""

cQuery := "SELECT SUM(E5_VALOR) AS VALOR "
cQuery += "FROM SE5010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
cQuery += "AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E5_FILIAL = '01' "
cQuery += "AND E5_SITUACA <> 'C' AND E5_RECONC = 'x' AND E5_TIPO <> 'DC' "
cQuery += "AND SUBSTRING(E5_DATA,1,6) = '" + ALLTRIM(MV_PAR20) + ALLTRIM(MV_PAR19) + "' "
cQuery += "AND E5_RECPAG = 'P' "
cQuery += "AND E5_TIPODOC <> 'CH' "
cQuery += "AND E5_BANCO <> 'CXG' "
cQuery += "AND E5_NATUREZ = '"+ALLTRIM(PREV->ZA6_NATURE)+"' "
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR24+"' AND '"+MV_PAR25+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery += "GROUP BY E5_NATUREZ "

tcQuery cQuery New Alias "ABATSE5"

nValSE5 := ABATSE5->VALOR

DBSElectArea("ABATSE5")
DBCloseArea()

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
AADD(aRegs,{cPerg,"19","Fluxo do Mes?","","","mv_ch19","C",02,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"20","Fluxo do Ano?","","","mv_ch20","C",04,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"21","Do Contrato ?","","","mv_ch21","C",06,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","SC3"})
AADD(aRegs,{cPerg,"22","Ate Contrato ?","","","mv_ch22","C",06,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","SC3"})
AADD(aRegs,{cPerg,"23","Ordem ?","","","mv_ch23","N",01,0,2,"C","","mv_par23","Napoli","","","","","Natureza","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"24","Do Bloco  ?","","","mv_ch24","C",06,0,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
AADD(aRegs,{cPerg,"25","Ate Bloco ?","","","mv_ch25","C",06,0,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
AADD(aRegs,{cPerg,"26","Dt Referencia Financeiro","","","mv_ch26","D",08,0,0,"G","","mv_par26","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"27","Dt Realizado / Previsto","","","mv_ch27","D",08,0,0,"G","","mv_par27","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
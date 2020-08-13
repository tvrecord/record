#include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160OK    ºAutor  ³Bruno Alves       º Data ³  03/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Não deixa criar um pedido atraves da analise cotação        º±±
±±º          ³quando ultrapassa o limite do saldo por natureza            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT160OK()

Local aArea			:= GetArea()
Local cQuery := ""
Local nRec := 0
Local cNaturez := SC1->C1_NATUREZ
Local cDescNat := Posicione("SED",1,xFilial("SED")+SC1->C1_NATUREZ,"ED_DESCRIC")
local nValor := 0
local nTotal := 0
Local cMes := SUBSTR(DTOS(DDATABASE),1,6) //Mes e Ano
Local nSaldo := 0
Local nLimite := 0
Local lOk := .F.           

For I := 1 to LEN(PARAMIXB)
	
	For J := 1 to LEN((PARAMIXB)[I])
		
		If !EMPTY(PARAMIXB[I][J][1]) //Localizar o ganhador e somar os valores
			
			nValor += (PARAMIXB)[I][J][6]  // Soma o valor do Produto escolhido pelo fornecedor
			
			
		EndIf
		
	Next
	
Next

cQuery := "SELECT C1_NATUREZ AS NATUREZA, SUM(C7_TOTAL + C7_VALFRE + C7_DESPESA - C7_VLDESC + C7_VALIPI) AS VALOR FROM SC7010 "
cQuery += "INNER JOIN SC1010 ON "
cQuery += "C1_NUM = C7_NUMSC AND "
cQuery += "C1_PEDIDO = C7_NUM AND "
cQuery += "C7_ITEMSC = C1_ITEM "
cQuery += "INNER JOIN SCR010 ON "
cQuery += "CR_NUM = C7_NUM AND "
cQuery += "CR_FILIAL = C7_FILIAL "
cQuery += "WHERE "
cQuery += "C7_TIPO = 1 AND "
cQuery += "C7_RESIDUO <> 'S' AND "
cQuery += "C1_NATUREZ =  '" + (cNaturez) + "'    AND "
cQuery += "CR_USER IN ('000192','000157') AND "
cQuery += "CR_STATUS = '03' AND "
cQuery += "C7_EMISSAO >= '20130726' AND "
cQuery += "CR_DATALIB BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' AND "
cQuery += "SCR010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC1010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY C1_NATUREZ "
cQuery += "UNION "
cQuery += "SELECT C3_NATUREZ AS NATUREZA,SUM(C7_TOTAL + C7_VALFRE + C7_DESPESA - C7_VLDESC + C7_VALIPI) AS VALOR FROM SC7010 "    // Busca Autorização de Contratos
cQuery += "INNER JOIN SC3010 ON "
cQuery += "C7_NUMSC = C3_NUM AND "
cQuery += "C7_ITEMSC = C3_ITEM "
cQuery += "INNER JOIN SCR010 ON "
cQuery += "CR_NUM = C7_NUM AND "
cQuery += "CR_FILIAL = C7_FILIAL "
cQuery += "WHERE "
cQuery += "C7_TIPO = 2 AND "
cQuery += "C7_RESIDUO <> 'S' AND "
cQuery += "C3_NATUREZ =  '" + (cNaturez) + "'    AND "
cQuery += "CR_USER = '000192' AND "
cQuery += "CR_STATUS = '03' AND "
cQuery += "C7_EMISSAO >= '20130726' AND "
cQuery += "CR_DATALIB BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' AND "
cQuery += "SCR010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY C3_NATUREZ "
cQuery += "UNION "
cQuery += "SELECT ZS_NATUREZ AS NATUREZA,SUM(ZS_VALOR) AS VALOR FROM SZS010 WHERE " // Busca Autorização de Pagamentos
cQuery += "D_E_L_E_T_ <> '*' AND "
cQuery += "ZS_TIPO <> '21' AND "	
cQuery += "ZS_LIBERAD = 'L' AND "	
cQuery += "ZS_CONTRAT <> '1' AND "
cQuery += "ZS_NATUREZ = '" + (cNaturez) + "' AND "
cQuery += "ZS_EMISSAO BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' "
cQuery += "GROUP BY ZS_NATUREZ "
cQuery += "ORDER BY NATUREZA "

tcQuery cQuery New Alias "TMP"

DBSelectArea("TMP")

While !EOF()
	
	nTotal += TMP->VALOR
	
	DbSkip()
	
EndDo

nTotal += nValor


nLimite := Posicione("SED",1,xFilial("SED")+SC1->C1_NATUREZ, @"ED_MES" + SUBSTR(CMES,5,2))
nSaldo := nLimite - nTotal


@ 000,000 TO 170,450 DIALOG oDlg TITLE "Limite de Compra por Natureza"
@ 011,020 Say "Mes: " + Substr(cMes,5,2) + "/" + Substr(cMes,1,4)
@ 021,020 Say "Natureza: " + cNaturez + " - " + ALLTRIM(cDescNat)
@ 031,020 Say "Limite: " + cValtoChar(nLimite)
@ 041,020 Say "Valor Utilizado: " + cValtoChar(nTotal)
@ 051,020 Say "Saldo: " + cValToChar(nSaldo)
If nSaldo < 0
	@ 061,020 Say "ATENÇÃO!! Orçamento foi Estourado."
	lOk := .T.
ELSE
	@ 061,020 Say "PEDIDO LIBERADO"
	lOk := .T.
Endif
@ 070,170 BMPBUTTON TYPE 01 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED



DbSelectArea("TMP")
DbCloseArea("TMP")

RestArea(aArea)


Return(lOk)
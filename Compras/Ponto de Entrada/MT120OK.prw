#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPraograma  ณMT120OK   บAutor  ณBruno Alves	     บ Data ณ  01/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para informar a quantidade de meses 		   ฑฑ
ฑฑบ          ณfaltantes para encerrar o contrato escolhido na rotina	   ฑฑ
ฑฑบautoriza็ใo de entrega e essa informa็ใo sera fornecida caso o contrato ฑฑ
ฑฑบesteja com o prazo de vencimento menor ou igual 45 dias			       ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณClientes Microsiga                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120OK()


Local lReturn := .T.
Local cQuery := ""
Local dData := ""
Local nQtdMes := 0


IF ALLTRIM(FUNNAME()) $ "MATA122"
	
	cQuery := "SELECT C3_DATPRF FROM SC3010 WHERE "
	cQuery += "C3_NUM = '" + (aCols[1][12]) + "' AND " // Codigo do Contrato localizado na tabela autorizacao de entrega
	cQuery += "C3_ITEM = '" + (aCols[1][14]) + "' AND " // Codigo do Item do contrato relacionado na autoriza็ใo de entrega	
	cQuery += "D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY R_E_C_N_O_ "
	
	TcQuery cQuery New Alias "TMP"
	
	
	If STOD(TMP->C3_DATPRF) > DATE()
		dData := STOD(TMP->C3_DATPRF)
		
		nQtdMes := dData - DATE()
		
		If(nQtdMes <= 45)
			MsgInfo("Falta(m) " + alltrim(str(nQtdMes)) + " dias para vencer o contrato " + (aCols[1][12]) + "")
		EndIf
		
	EndIf
	
EndIf


DBSelectArea("TMP")
DBCloseArea("TMP")

Return(lReturn)

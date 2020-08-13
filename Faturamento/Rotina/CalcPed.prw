#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"



User Function CalcPed()

Local nTotal  := 0
Local nTotemp := 0
Local cQuery  := ""


cQuery:= "SELECT C7_FILIAL,C7_TOTAL,C7_VLDESC,C7_VALFRE FROM " + RetSqlName("SC7") + " WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND C7_NUM = '" + (M->ZM_PEDIDO) + "' AND D_E_L_E_T_ <> '*'"

TcQuery cQuery New Alias "TMP"

DBSelectArea("TMP")
DBGotop()          	

SZM->(dbSetOrder(4))
iF SZM->(dbSeek(TMP->C7_FILIAL + M->ZM_PEDIDO))
	MsgBox("Pedido Cadastrado!!.","Alerta","Alert")
	DBSelectArea("TMP")
	DBCloseArea("TMP")
	DBSelectArea("SZM")
	DBCloseArea("SZM")
	Return
EndIf



While !EOF()
	
	
	nTotemp := (TMP->C7_TOTAL) - (TMP->C7_VLDESC) + (TMP->C7_VALFRE)
	nTotal += nTotemp
	
	
	dbSkip()
	
Enddo

DBSelectArea("TMP")
DBCloseArea("TMP")
DBSelectArea("SZM")
DBCloseArea("SZM")

Return(nTotal)

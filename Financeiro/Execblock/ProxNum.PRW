#INCLUDE "TOPCONN.CH"

User Function ProxNum()
Local cQry
Local cRet := "" //TamSX3("E1_NUM")[1]

If M->E1_PREFIXO $ "MF "
	cQry  := "SELECT COALESCE(MAX(SUBSTRING(E1_NUM,1,6)),0)  SEQUEN "
	cQry  += "  FROM " + RetSQLName("SE1") +"  "
	cQry  += " WHERE E1_PREFIXO = '"+ M->E1_PREFIXO  +"' "
	cQry  += "   AND D_E_L_E_T_ = ' ' "
	TCQUERY cQry NEW ALIAS "TMP"	
	
	dbSelectArea("TMP")
	cRet  := StrZero(TMP->SEQUEN+1,6)
	dbCloseArea()
	dbSelectArea("SE1")
	
	ElseIf M->E1_PREFIXO $ "NDC"
	cQry  := "SELECT COALESCE(MAX(SUBSTRING(E1_NUM,1,6)),0)  SEQUEN "
	cQry  += "  FROM " + RetSQLName("SE1") +"  "
	cQry  += " WHERE E1_PREFIXO = '"+ M->E1_PREFIXO  +"' "
	cQry  += "   AND D_E_L_E_T_ = ' ' "
	TCQUERY cQry NEW ALIAS "TMP"	
	
	dbSelectArea("TMP")
	cRet  := StrZero(TMP->SEQUEN+1,6)
	dbCloseArea()
	dbSelectArea("SE1")
EndIf

Return (cRet)
  
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"

User Function FOLBVT()

Local _nValorPD		:= 0
Local cQuery1		:= ""
Local cVerba1		:= "587" // BASE VA EMPRESA     

//cQuery1		:= "SELECT SUM(RG2_CUSEMP) AS VALOR FROM RG2010 WHERE D_E_L_E_T_ = '' AND RG2_MAT = '"+SRA->RA_MAT+"' AND RG2_PERIOD = '"+SUBSTR(RCH->RCH_PER,1,4)+" "+SUBSTR(RCH->RCH_PER,5,2)+"'"
cQuery1		:= "SELECT (ZO_VALOR * ZO_PERC / 100) AS VALOR FROM SZO010 WHERE D_E_L_E_T_ = '' AND ZO_MAT = '"+SRA->RA_MAT+"' AND ZO_ANO = '"+SUBSTR(RCH->RCH_PER,1,4)+"' AND ZO_MES = '"+SUBSTR(RCH->RCH_PER,5,2)+"'"

TcQuery cQuery1 New Alias "TMP1"

IF Eof()
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
	
ELSE
	
	DbSelectArea("TMP1")
	dbGoTop()
	
	While !TMP1->(Eof())
		
		_nValorPD		+= TMP1->VALOR
		
		TMP1->(dbSkip())
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
	ENDDO
	
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	
ENDIF

Return
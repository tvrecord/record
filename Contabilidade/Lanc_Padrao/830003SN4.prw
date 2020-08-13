#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"

User Function 830003SN4()   

Private nVal   := 0
Private cQuery := ""

_aArea := GetArea()


IF SN3->N3_TIPO == "01"
	
	cQuery := "SELECT SUM(N4_VLROC1) AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + SN3->N3_TIPO + "' AND N4_CBASE = '" + SN3->N3_CBASE + "' AND N4_ITEM = '" + SN3->N3_ITEM + "' AND N4_OCORR = '06' AND N4_TIPOCNT = '4' AND SUBSTRING(N4_DATA,1,4) = '" + STRZERO( YEAR(DDATABASE),4) + "' "
	
ELSEIF SN3->N3_TIPO == "10"
	
	cQuery := "SELECT SUM(N4_VLROC1) AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + SN3->N3_TIPO + "' AND N4_CBASE = '" + SN3->N3_CBASE + "' AND N4_ITEM = '" + SN3->N3_ITEM + "' AND N4_OCORR = '20' AND N4_TIPOCNT = '4' AND SUBSTRING(N4_DATA,1,4) = '" + STRZERO( YEAR(DDATABASE),4) + "' "
	
ENDIF

TcQuery cQuery New Alias "TMPSN4"

DBSelectArea("TMPSN4")
DBGotop()
While !EOF()
	
	nVal := TMPSN4->VALOR  
	
dbSkip()
	
ENDDO  

DBSelectArea("TMPSN4")
DBCloseArea("TMPSN4")

_aArea	:= RestArea(_aArea)

Return(nVal)
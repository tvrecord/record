#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROTF40  º Autor ³ Rorilson        º Data ³  10/12/08		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMONTA O VALOR DO SALARIO(COMPOSICAO)DO FUNCIONÁRIO NAS FERIAS,CONSIDERAN-±±º
±±ºDO O VALOR DAS HORAS CONTRATUAIS                                       º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TESTERH()    //

aSvAlias :={Alias(),IndexOrd(),Recno()}
cQuery096 	:= ""
nVal096		:= 0
cQuery243 	:= ""
nVal243		:= 0

IF FBUSCAPD("096") > 0
	
	cQuery096 := "SELECT RD_MAT,'096' AS VERBA, "
	cQuery096 += "ROUND(SUM(RD_VALOR)/12,2) AS VALOR12 "
	cQuery096 += "FROM SRD010 WHERE D_E_L_E_T_ = '' "
	cQuery096 += "AND RD_MAT = '"+SRA->RA_MAT+"' " "
	cQuery096 += "AND RD_PD IN ('009','011','014','019','329') "
	cQuery096 += "AND RD_DATARQ >= '201701' "
	cQuery096 += "GROUP BY RD_MAT "
	
	TcQuery :=  ChangeQuery(cQuery096)
	TcQuery cQuery096 New Alias "TMP096"
	
	If Eof()
		dbSelectArea("TMP096")
		dbCloseArea("TMP096")
		dbSelectArea(aSvAlias[1])
		dbSetOrder(aSvAlias[2])
		dbGoto(aSvAlias[3])
		Return
	Endif
	
	fDelPD("096")
	
	Dbselectarea("TMP096")
	While !TMP096->(Eof())
		
		fGeraVerba("096",TMP096->VALOR12,,,,,,,,,.T.)
		
		TMP096->(DbSkip())
		
	ENDDO
	
	dbSelectArea("TMP096")
	dbCloseArea("TMP096")
	
ENDIF


IF FBUSCAPD("243") > 0
	
	cQuery243 := "SELECT RD_MAT,'243' AS VERBA, "
	cQuery243 += "ROUND(SUM(RD_VALOR)/12,2) AS VALOR12 "
	cQuery243 += "FROM SRD010 WHERE D_E_L_E_T_ = '' "
	cQuery243 += "AND RD_MAT = '"+SRA->RA_MAT+"' " "
	cQuery243 += "AND RD_PD IN ('016','017','114','292','135','168','225') "
	cQuery243 += "AND RD_DATARQ >= '201701' "
	cQuery243 += "GROUP BY RD_MAT "
	
	TcQuery :=  ChangeQuery(cQuery243)
	TcQuery cQuery243 New Alias "TMP243"
	
	If Eof()
		dbSelectArea("TMP243")
		dbCloseArea("TMP243")
		dbSelectArea(aSvAlias[1])
		dbSetOrder(aSvAlias[2])
		dbGoto(aSvAlias[3])
		Return
	Endif
	
	fDelPD("243")
	
	Dbselectarea("TMP243")
	While !TMP243->(Eof())
		
		fGeraVerba("243",TMP243->VALOR12,,,,,,,,,.T.)
		
		TMP243->(DbSkip())
		
	ENDDO
	
	dbSelectArea("TMP243")
	dbCloseArea("TMP243")
	
ENDIF

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return

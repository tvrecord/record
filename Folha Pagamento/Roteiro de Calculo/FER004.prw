#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//19/12/19 - Rafael França - Ajusta o quinquenio nas ferias

User Function FER005()

	Local nVal 			:= 0 
	Local _nDUteis		:= 25 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
	Local _nDiasDSR		:= 5 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12
	Local nVerba996 	:= 0 //FBUSCAPD("996")

	nDiasFer := 0
	lMesSeguinte := .F.

	nBase 	:= Salmes // SRA->RA_SALARIO 

	If Month2Str(RH_DATAINI) != Month2Str(RH_DATAFIM) //Verifica os dias de ferias no mes e no mes seguinte
		nDiasFer := LastDate(RH_DATAINI) - RH_DATAINI + 1
		lMesSeguinte := .T.
	else
		nDiasFer := RH_DFERIAS                                     
	EndIf

	IF FBUSCAPD("282") > 0 .OR. SRA->RA_PERCQ > 0
		fGeraVerba("282",ROUND((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100 / 30 * nDiasFer,2),nDiasFer,,,,,,,,.T.)
		fGeraVerba("608",ROUND((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100,2),SRA->RA_PERCQ,,,,,,,,.T.)

	ENDIF

	IF nVerba996 > 0
		fDelPD("996")
		fGeraVerba("996",nVerba996 + fbuscapd("282") + fbuscapd("330"),70,,,,,,,,.T.)
	EndIf

	IF FBUSCAPD("330") > 0 .OR. lMesSeguinte .AND. SRA->RA_PERCQ > 0 
		fGeraVerba("330",ROUND((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100 / 30 * (RH_DFERIAS - nDiasFer),2),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)   
	ENDIF                                                                                                                                                

Return
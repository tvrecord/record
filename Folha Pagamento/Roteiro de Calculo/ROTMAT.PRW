#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROTMAT  º Autor ³ Rorilson        º Data ³  10/12/08		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ Calculo de Maternidade                  					  º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Rotina tbm inclui salario maternidade

User Function ROTMAT()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS

	Private aSvAlias 		:= {Alias(),IndexOrd(),Recno()}
	Private nValMedia		:= 0
	Private nValHCont		:= 0
	Private nValTot			:= 0
	Private nValHeCont		:= 0
	Private cData			:= ""
	Private nDia			:= 0
	Private _HE118			:= 0
	Private _HE122			:= 0
	Private nValT 			:= 0
	Private _nDUteis		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
	Private _nDiasDSR		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12

	nDia := FBUSCAPD("035","H") //Dias Trabalhados


	If fbuscapd("001") == 0

		IF  FBUSCAPD("023") <> 0

			DBSELECTAREA("SRC")
			DBSetOrder(1)
			DBSeek(xFilial("SRC") + SRA->RA_MAT + "023")

			If SRA->RA_HEFIX25="S"
				HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*25)/30 * (nDia - SRC->RC_HORAS)
				//			DsrHorasExtra:=((HorasExtras/SR6->R6_HRNORMA)*SR6->R6_HRDESC)
				DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
				nValHeCont += (HorasExtras +  DsrHorasExtra)
			Endif

			If SRA->RA_HEFIX50="S"
				HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*50)/30 * (nDia - SRC->RC_HORAS)
				//			DsrHorasExtra:=((HorasExtras/SR6->R6_HRNORMA)*SR6->R6_HRDESC)
				DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
				nValHeCont += (HorasExtras +  DsrHorasExtra)
			Endif


			nValHeCont += fbuscapd("035")/27*28 // TEMPORARIO


		ELSE

			If SRA->RA_HEFIX25="S"
				HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*25)
				//		DsrHorasExtra:=((HorasExtras/SR6->R6_HRNORMA)*SR6->R6_HRDESC)
				DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
				nValHeCont += (HorasExtras +  DsrHorasExtra)
			Endif

			If SRA->RA_HEFIX50="S"
				HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*50)
				//		DsrHorasExtra:=((HorasExtras/SR6->R6_HRNORMA)*SR6->R6_HRDESC)
				DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
				nValHeCont += (HorasExtras +  DsrHorasExtra)
			Endif

			nValHeCont += fbuscapd("035")

		ENDIF

		FdelPd("060")
		FdelPd("118")
		FdelPd("122")
		FdelPd("035")
		fGeraVerba("035",nValHeCont,nDia,,,,,,,,.T.)

	else



		FdelPd("118")
		FdelPd("060")
		FdelPd("122")

		_HE118 := FBUSCAPD("035")
		_HE122 := FBUSCAPD("035")

		IF _HE118 > 0 .and. SRA->RA_HEFIX25="S" //   IF ALLTRIM(FUNNAME()) =  "GPEM020"
			fGeraVerba("118",(((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(DiasTrab),,,,,,,,,.T.)
			nValHeCont := fbuscapd("118")
			//		fGeraVerba("060",((nValHeCont/SR6->R6_HRNORMA) * SR6->R6_HRDESC),,,,,,,,,.T.)
			fGeraVerba("060",((nValHeCont/_nDUteis) * _nDiasDSR),,,,,,,,,.T.)
			nValHCont  += fbuscapd("060")
		ENDIF

		IF _HE122 > 0 .and. SRA->RA_HEFIX50="S" //   IF ALLTRIM(FUNNAME()) =  "GPEM020"
			fGeraVerba("118",(((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*50)/30)*(DiasTrab),,,,,,,,,.T.)
			nValHeCont := fbuscapd("122")
			//		fGeraVerba("060",((nValHeCont/SR6->R6_HRNORMA) * SR6->R6_HRDESC),,,,,,,,,.T.)
			fGeraVerba("060",((nValHeCont/_nDUteis) * _nDiasDSR),,,,,,,,,.T.)
			nValHCont  += fbuscapd("060")
		ENDIF


		//FdelPd("311")
		//fGeraVerba("311",nValMedia,nDia,,,,,,,,.T.)

		If SRA->RA_HEFIX25="S"
			//	nValT    := (((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia) + ((((((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia)/SR6->R6_HRNORMA) * SR6->R6_HRDESC))
			nValT    := (((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia) + ((((((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia)/_nDUteis) * _nDiasDSR))
		EndIf

		If SRA->RA_HEFIX50="S"
			//	nValT    := (((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia) + ((((((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(nDia)/SR6->R6_HRNORMA) * SR6->R6_HRDESC))
			nValT    := (((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*50)/30)*(nDia) + ((((((((salmes+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*50)/30)*(nDia)/_nDUteis) * _nDiasDSR))
		EndIf


		nValT    += fbuscapd("035")

		FdelPd("035")
		fGeraVerba("035",nValT,nDia,,,,,,,,.T.)

	EndIf



	dbSelectArea(aSvAlias[1])
	dbSetOrder(aSvAlias[2])
	dbGoto(aSvAlias[3])

Return

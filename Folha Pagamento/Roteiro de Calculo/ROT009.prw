#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROT009    º Autor ³ Silvano Franca     º Data ³  16/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula e gera a verba 292 dsr sobre adicional noturno     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rede Record                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ROT009()
                                                                 
//Local _nHorasAd 	:= 0
//Local _nSalHoraAd	:= 0
Local _nDUteis		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
Local _nDiasDSR		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12
Local _nValorPD		:= 0
Local cQuery1		:= ""
Local cVerba1		:= ""
Local nPerc1		:= 2
//_nHorasAd 	:= Round(fBuscaPD("114","H")/_nDUteis,2)
//_nSalHoraAd := Round((SalHora *0.40)*_nDiasDSR,2)

IF fBuscaPD("114") != 0
	IF fBuscaPD("292") != 0
		FdelPd("292")
	Endif
	fGeraVerba("292",Round(fBuscaPD("114")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END

IF fBuscaPD("022") != 0                    
	IF fBuscaPD("129") != 0
		FdelPd("129")
	Endif
	fGeraVerba("129",Round(fBuscaPD("022")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END  

IF fBuscaPD("118") != 0
	IF fBuscaPD("060") != 0
		FdelPd("060")
	Endif
	fGeraVerba("060",Round(fBuscaPD("118")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END

IF fBuscaPD("122") != 0
	IF fBuscaPD("060") != 0
		FdelPd("060")
	Endif
	fGeraVerba("060",Round(fBuscaPD("122")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END

IF fBuscaPD("009,011,014,019") != 0
	IF fBuscaPD("016") != 0
		FdelPd("016")
	Endif
	fGeraVerba("016",Round(fBuscaPD("009,011,014,019")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END 

IF fBuscaPD("013,112,087,216") != 0
	IF fBuscaPD("017") != 0
		FdelPd("017")
	Endif
	fGeraVerba("017",Round(fBuscaPD("013,112,087,216")/_nDUteis*_nDiasDSR,2),,,,,,,,,.T.)
END

//	dbselectarea("SRC")
//		DbSetOrder(1)
//	DbSeek(xFilial("SRC")+SRA->RA_MAT,.T.)
//	while xFilial("SRA")+SRA->RA_MAT == xFilial("SRC")+SRC->RC_MAT
//		fGeraVerba("117",nBase * 0.40,40,,,,,,,,.T.)
//      fGeraVerba("292",Round(fBuscaPD("114","H")/RCF->RCF_DIATRA,2)*Round((SalHora *0.40)*RCF->RCF_DIADSR,2),,,,,,,,,.T.)
//	   SRC->(dbSkip())
//	Enddo


IF ALLTRIM(FUNNAME()) == "GPEM690"  //Executa no dissidio
	
	IF fBuscaPD("023") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "023"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
				
		While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("024") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "024"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()		
		
		While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("025") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "025"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()		
		
		While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("026") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "026"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("027") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "027"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
	While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("050") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "050"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
	While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
	IF fBuscaPD("060") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
		
		cVerba1         := "060"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof())
			
			_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	 
	IF fBuscaPD("118") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "118"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF	

	IF fBuscaPD("122") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "122"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF  
	
		IF fBuscaPD("116") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "116"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF
	
		IF fBuscaPD("225") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "225"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF                      
	
	IF fBuscaPD("282") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "282"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF	                   
	
	IF fBuscaPD("333") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "333"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF 
	
	IF fBuscaPD("345") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "345"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF 
	
	IF fBuscaPD("562") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "562"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")
	dbCloseArea("TMP1")
		
	ENDIF			            
	
	IF fBuscaPD("563") != 0 .OR. (MV_PAR05 == "042018" .AND. SRA->RA_MAT $ "000082/001316/000742/000585/000734/000258/001410")
	   
		cVerba1         := "563"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("169") != 0
	   
		cVerba1         := "169"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("035") != 0
	   
		cVerba1         := "035"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("009") != 0
	   
		cVerba1         := "009"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("011") != 0
	   
		cVerba1         := "011"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("016") != 0
	   
		cVerba1         := "016"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	IF fBuscaPD("169") != 0
	   
		cVerba1         := "169"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	           
		IF fBuscaPD("114") != 0
	   
		cVerba1         := "114"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
		IF fBuscaPD("292") != 0
	   
		cVerba1         := "292"
		_nValorPD		:= 0
		
		cQuery1		:= "SELECT RD_VALOR FROM SRD010 WHERE RD_MAT = '"+SRA->RA_MAT+"' AND RD_PD = '"+cVerba1+"' AND RD_PERIODO = '"+SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2)+"'"
		
		TcQuery cQuery1 New Alias "TMP1"
		
		DbSelectArea("TMP1")
		dbGoTop()
		
		While !TMP1->(Eof()) 
		
		_nValorPD		+= TMP1->RD_VALOR + (TMP1->RD_VALOR/100*nPerc1)
			
			TMP1->(dbSkip())
			
		ENDDO
		
		FdelPd(cVerba1)
		
		fGeraVerba(cVerba1,_nValorPD,,,,,,,,,.T.)
		
			dbSelectArea("TMP1")                               
	dbCloseArea("TMP1")
		
	ENDIF	
	
	
	
ENDIF

Return
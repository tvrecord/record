User Function CCLP01()

Local _cRet

//if SRZ->RZ_VAL > 0
	
	if(SUBSTR(POSICIONE("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"RV_CONTA"),1,1)=="4")
		
		_cRet := iif(SRV->RV_CONTA >="400000000",SRZ->RZ_CC,"")
		
endif
	
 if(SUBSTR(POSICIONE("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"RV_CTACRED"),1,1)=="4")
	   _cRet := iif(SRV->RV_CTACRED >="400000000",SRZ->RZ_CC,"")                                                           
endif

Return(_cRet)
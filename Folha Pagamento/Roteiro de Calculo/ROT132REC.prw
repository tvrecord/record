#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//10/12/18 - Rafael França - Alterado o programa para gerar verbas personalizadas da Record DF no roterio de calculo 132. Antes era feita a composição do salario por meio da variavel SalMes

User Function ROT132REC()

Local nVal := 0 
Local _nDUteis		:= 25 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
Local _nDiasDSR		:= 5 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12   

HorasExtras:=0
DsrHorasExtra:=0
nCalcAdi:=0
nQuinquenio := 0

nBase 	:= Salmes // SRA->RA_SALARIO 

IF SRA->RA_ACFUNC == "S" .AND. SRA->RA_ACUMULA == 0 // ACUMULO DE FUNCAO PADRAO 40% 
	fGeraVerba("603", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.) 
	fGeraVerba("932", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)/12*nAvos  	
ELSEIF SRA->RA_ACUMULA > 0 // ACUMULO DE FUNCAO VARIAVEL 
	fGeraVerba("603", (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100)/12*nAvos,SRA->RA_ACUMULA,,,,,,,,.T.)  
	fGeraVerba("932", (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100)/12*nAvos,SRA->RA_ACUMULA,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) 
	nBase +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100)/12*nAvos  				
EndIf

IF SRA->RA_CALCADI == "S"  // SERVIÇO ADICIONAL 40%
	fGeraVerba("604", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.) 
	fGeraVerba("933", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.) 	
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)/12*nAvos   		
EndIf

If SRA->RA_GRATFUN = "S" // GRATIFICAÇÃO DE FUNÇÃO 40%
	fGeraVerba("602", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.)	
	fGeraVerba("931", (SRA->RA_SALARIO * 0.40)/12*nAvos,nAvos,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)/12*nAvos   	
EndIf

nBase += (SRA->RA_SALARIO / 100 * SRA->RA_PERCQ) 

If SRA->RA_HEFIX25 == "S" // H.E FIXA CONTRATUAL 25 
	HorasExtras:=((((nBase/12*nAvos)/SRA->RA_HRSMES) * 1.7)*25) 
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)  
	fGeraVerba("605", (HorasExtras)  ,nAvos,,,,,,,,.T.)  
	fGeraVerba("934", (HorasExtras)  ,nAvos,,,,,,,,.T.) 	
	fGeraVerba("607", (DsrHorasExtra),nAvos,,,,,,,,.T.) 
	fGeraVerba("936", (DsrHorasExtra),nAvos,,,,,,,,.T.)	 	
	nBase +=  (HorasExtras +  DsrHorasExtra)/12*nAvos    	
Endif

IF SRA->RA_HEFIX50 == "S" // H.E FIXA CONTRATUAL 50 
	HorasExtras:=((((nBase/12*nAvos)/SRA->RA_HRSMES) * 1.7)*50)
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)  
	fGeraVerba("606", (HorasExtras)  ,,,,,,,,,.T.)  
	fGeraVerba("935", (HorasExtras)  ,,,,,,,,,.T.) 	
	fGeraVerba("607", (DsrHorasExtra),,,,,,,,,.T.) 
	fGeraVerba("936", (DsrHorasExtra),,,,,,,,,.T.)	 	
	nBase +=  (HorasExtras +  DsrHorasExtra)/12*nAvos     	   	
Endif  
	
Return
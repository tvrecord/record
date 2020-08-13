#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//18/02/19 - Rafael França - Alterado o programa para gerar verbas personalizadas da Record DF no roterio de calculo 131. Antes era feita a composição do salario por meio da variavel SalMes

User Function ROT131REC()

Local nVal := 0 
Local _nDUteis		:= 25 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
Local _nDiasDSR		:= 5 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12   
Local _nPosPd 		:= 1
Local _nPerc		:= 1 
Local _nMeses		:= 0

HorasExtras:=0
DsrHorasExtra:=0
nCalcAdi:=0
nQuinquenio := 0

IF FlocaliaPd("041") > 0 
_nPosPd   := FlocaliaPd("041")
_nMeses	  := aPd[_nPosPd,4]
_nPerc    := _nMeses / 12
ENDIF

nBase 	:= Salmes // SRA->RA_SALARIO 

IF SRA->RA_ACFUNC == "S" .AND. SRA->RA_ACUMULA == 0 // ACUMULO DE FUNCAO PADRAO 40% 
	fGeraVerba("113", (SRA->RA_SALARIO * 0.40 * _nPerc),_nMeses,,,,,,,,.T.) 
	fGeraVerba("578", (SRA->RA_SALARIO * 0.40),40,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)	
ELSEIF SRA->RA_ACUMULA > 0 // ACUMULO DE FUNCAO VARIAVEL 
	fGeraVerba("113", (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100 * _nPerc),_nMeses,,,,,,,,.T.)  
	fGeraVerba("578", (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100),SRA->RA_ACUMULA,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) 
	nBase +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) 				
EndIf

IF SRA->RA_CALCADI == "S"  // SERVIÇO ADICIONAL 40%
	fGeraVerba("121", (SRA->RA_SALARIO * 0.40 * _nPerc),_nMeses,,,,,,,,.T.) 
	fGeraVerba("576", (SRA->RA_SALARIO * 0.40),40,,,,,,,,.T.) 	
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)  		
EndIf

If SRA->RA_GRATFUN = "S" // GRATIFICAÇÃO DE FUNÇÃO 40%
	fGeraVerba("105", (SRA->RA_SALARIO * 0.40 * _nPerc),_nMeses,,,,,,,,.T.)	
	fGeraVerba("577", (SRA->RA_SALARIO * 0.40),40,,,,,,,,.T.) 
	//Salmes +=  (SRA->RA_SALARIO * 0.40) 
	nBase +=  (SRA->RA_SALARIO * 0.40)   	
EndIf

nBase += (SRA->RA_SALARIO / 100 * SRA->RA_PERCQ) 

If SRA->RA_HEFIX25 == "S" // H.E FIXA CONTRATUAL 25 
	HorasExtras:=((((nBase)/SRA->RA_HRSMES) * 1.7)*25) 
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)  
	fGeraVerba("195", (HorasExtras) * _nPerc ,_nMeses,,,,,,,,.T.)  
	fGeraVerba("579", (HorasExtras)  ,25,,,,,,,,.T.) 	
	fGeraVerba("197", (DsrHorasExtra) * _nPerc,,,,,,,,,.T.) 
	fGeraVerba("581", (DsrHorasExtra),,,,,,,,,.T.)	 	
	nBase +=  (HorasExtras +  DsrHorasExtra)   	
Endif

IF SRA->RA_HEFIX50 == "S" // H.E FIXA CONTRATUAL 50 
	HorasExtras:=((((nBase)/SRA->RA_HRSMES) * 1.7)*50)
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)  
	fGeraVerba("196", (HorasExtras) * _nPerc  ,_nMeses,,,,,,,,.T.)  
	fGeraVerba("580", (HorasExtras)  ,50,,,,,,,,.T.) 	
	fGeraVerba("197", (DsrHorasExtra) * _nPerc,,,,,,,,,.T.) 
	fGeraVerba("581", (DsrHorasExtra),,,,,,,,,.T.)	 	
	nBase +=  (HorasExtras +  DsrHorasExtra)    	   	
Endif  
	
Return
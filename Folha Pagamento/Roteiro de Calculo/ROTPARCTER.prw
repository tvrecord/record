#INCLUDE "PROTHEUS.CH"

//Programa para calcular hora contratual 25 e 50 ("118","122")na base (Salmes) da primeira parcela do 13. Formula: 131008 Roreiro: 131

User Function ROTPARCTER() 
                             
Local _nDUteis		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
Local _nDiasDSR		:= Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCES + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12   
//aSvAlias :={Alias(),IndexOrd(),Recno()}


// 20/11/18 - Rafael - Alterado a pedido da Sra. Giselly, fixar o dsr para hora contratual
_nDUteis		:= 25
_nDiasDSR		:= 5 

HorasExtras:=0
DsrHorasExtra:=0
Acumulo := 0

If SRA->RA_ACFUNC == "N" .AND. SRA->RA_ACUMULA != 0  // Verifica se funcionario tem acumulo de função
	
	Salmes      += (Salmes * (SRA->RA_ACUMULA/100))
	
ElseIf SRA->RA_ACFUNC == "S"
	
	Salmes      += (Salmes * 0.4)
	
Endif

If SRA->RA_HEFIX25="S" //Regra para calculo de hora extra 25 sobre base 13
	HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*25)
	DsrHorasExtra:=(HorasExtras/_nDUteis)* _nDiasDSR
Endif

If SRA->RA_HEFIX50="S"  //Rafael França - 26/06/18 - Regra para calculo de hora extra 50 sobre base 13
	HorasExtras:=(((SalMes/SRA->RA_HRSMES) * 1.7)*50)
	DsrHorasExtra:=(HorasExtras/_nDUteis)* _nDiasDSR
Endif

If SRA->RA_HEFIX25="S" .OR. SRA->RA_HEFIX50="S"
	SalMes += (Acumulo + HorasExtras +  DsrHorasExtra)
EndIf

//dbSelectArea(aSvAlias[1])
//dbSetOrder(aSvAlias[2])
//dbGoto(aSvAlias[3])

Return

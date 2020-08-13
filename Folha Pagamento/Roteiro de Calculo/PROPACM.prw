#INCLUDE "PROTHEUS.CH"  
#INCLUDE "Topconn.ch"  

User Function PROPACM() //Rafael e Giselly - 26/06/18 - Programa para proporcionalizar o acumulo de função em meses de ferias                                   
            
Public SalmesAnt1 := Salmes 

_Acum117 := 0     
_Acum127 := 0
_Acum169 := 0

IF SRA->RA_ACFUNC == "S" // ACUMULO DE FUNCAO (117)                 
    _Acum117 := FBUSCAPD("023")  
    IF _Acum117 > 0 //IF ALLTRIM(FUNNAME()) = "GPEM020" 
      FDelPD("117")
      fGeraVerba("117",Round(((SRA->RA_SALARIO/30)*(DIASTRAB) * 0.40),2),DIASTRAB,,,,,,,,.F.) 
    Else  
          FDelPD("117")
      fGeraVerba("117",Round((SRA->RA_SALARIO * 0.40),2),DiasTrab+nDiasAfas,,,,,,,,.F.)
//      fGeraVerba("117",(Round(SRA->RA_SALARIO/30,2)*(DiasTrab+nDiasAfas) * 0.40),,,,,,,,,.F.)      
    ENDIF
ENDIF 

IF SRA->RA_ACUMULA > 0 // ACUMULO DE FUNCAO (127)                 
     _Acum127 := FBUSCAPD("023")
    IF _Acum127 > 0 //    IF ALLTRIM(FUNNAME()) = "GPEM020" 
          FDelPD("127")
       fGeraVerba("127",Round(((SRA->RA_SALARIO/30)*(diastrab)*(SRA->RA_ACUMULA)/100),2),diastrab,,,,,,,,.F.)  
    Else 
          FDelPD("127") 
      fGeraVerba("127",Round(((SRA->RA_SALARIO/30)*(DiasTrab+nDiasAfas)*(SRA->RA_ACUMULA)/100),2),DiasTrab+nDiasAfas,,,,,,,,.F.) 
    ENDIF
ENDIF                

IF SRA->RA_CALCADI == "S" // CALC ADCIONAL (169)                 
    _Acum169 := FBUSCAPD("023")  
    IF _Acum169 > 0 //IF ALLTRIM(FUNNAME()) = "GPEM020" 
      FDelPD("169")
      fGeraVerba("169",Round(((SRA->RA_SALARIO/30)*(DIASTRAB) * 0.40),2),DIASTRAB,,,,,,,,.F.) 
    Else  
    FDelPD("169")
      fGeraVerba("169",Round((SRA->RA_SALARIO * 0.40),2),DiasTrab+nDiasAfas,,,,,,,,.F.)
//      fGeraVerba("117",(Round(SRA->RA_SALARIO/30,2)*(DiasTrab+nDiasAfas) * 0.40),,,,,,,,,.F.)      
    ENDIF
ENDIF 
 
//salmes := SalmesAnt

Return
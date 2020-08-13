#INCLUDE "PROTHEUS.CH"  
#INCLUDE "Topconn.ch"  

//Rafael França - 17/12/18 - Passa todas as verbas customizadas da folha de pagamente para um só programa. 

User Function ROT013()                                   
 
//Calcula Acumulo de função 
             
_Acum117 := 0     
_Acum127 := 0

IF SRA->RA_ACFUNC == "S" // ACUMULO DE FUNCAO (117)                 
    _Acum117 := FBUSCAPD("023")
    IF _Acum117 > 0 
      fGeraVerba("117",Round(((SRA->RA_SALARIO/30)*(30) * 0.40),2),30,,,,,,,,.F.)
    Else  
      fGeraVerba("117",Round((SRA->RA_SALARIO * 0.40),2),DiasTrab+nDiasAfas,,,,,,,,.F.)  
    ENDIF
ENDIF 


IF SRA->RA_ACUMULA > 0 // ACUMULO DE FUNCAO (127)                 
     _Acum127 := FBUSCAPD("023")
    IF _Acum127 > 0
        fGeraVerba("127",Round(((SRA->RA_SALARIO/30)*(30)*(SRA->RA_ACUMULA)/100),2),30,,,,,,,,.F.)
    Else  
      fGeraVerba("127",Round(((SRA->RA_SALARIO/30)*(DiasTrab+nDiasAfas)*(SRA->RA_ACUMULA)/100),2),DiasTrab+nDiasAfas,,,,,,,,.F.) 
    ENDIF
ENDIF 

Return
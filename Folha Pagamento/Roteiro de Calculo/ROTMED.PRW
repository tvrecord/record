#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณCALCISS  บ Autor ณ Rorilson        บ Data ณ  10/12/08		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ ALTERAR VALOR HORA DA MEDIA DE 13 SALARIO                  บฑฑ
ฑฑษออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ROTMED()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS

aSvAlias :={Alias(),IndexOrd(),Recno()}


IF ALLTRIM(FUNNAME()) <> "GPEM040"

  IF SRA->RA_ACFUNC == "S"  .AND. SRA->RA_HEFIX25="N"
     SalMes += Round((SRA->RA_SALARIO * 0.40),2)     
  Endif  

  If SRA->RA_ACUMULA > 0 .AND. SRA->RA_HEFIX25="N"
    SalMes += Round((SRA->RA_SALARIO * SRA->RA_ACUMULA/100),2)   
  Endif                 
  

  If SRA->RA_CALCADI == "S" 
    SalMes += Round((SRA->RA_SALARIO * 0.40),2)          
  Endif

  If SRA->RA_GRATFUN =="S"
    SalMes += Round((SRA->RA_SALARIO * 0.40),2)          
  Endif                                                                      
            

  


Endif  
  
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])


Return
                                         
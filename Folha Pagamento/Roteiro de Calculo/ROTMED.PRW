#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �CALCISS  � Autor � Rorilson        � Data �  10/12/08		  ���
�������������������������������������������������������������������������͹��
��� Desc.    � ALTERAR VALOR HORA DA MEDIA DE 13 SALARIO                  ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
                                         
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MGPE001   � Autor � Silvano Franca     � Data �  16/05/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula e gera a verba 117 (Acumulo de funcao) nos         ���
���          � lancamentos mensais.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MGPE001()

Local nBase                       
Local nCont := 0

nBase 	:= Round(SalDia,2)*DiasTrab  
if SRA->RA_ACFUNC == "S"  
	dbselectarea("SRC")
	DbSetOrder(1)
	DbSeek(xFilial("SRC")+SRA->RA_MAT,.T.)
	while !EOF() .and. xFilial("SRA")+SRA->RA_MAT == xFilial("SRC")+SRC->RC_MAT
            /*
	   if nCont == 0
	      if !dbSeek(xFilial("SRC")+SRC->RC_MAT+"117")
	    		fGeraVerba("117",nBase * 0.40,40,,,,,,,,.T.)
	     		nCont:= 1
	     	   SRC->(dbSkip())
	     	else
	     		nCont := 1	
	     	endif	
	  	Endif

	  	if nCont == 1
	  	   if SRC->RC_TIPO2 == "I" .and. SRC->RC_PD == "117"
	  	      FDelPD("117")
   	      FGeraVerba("117",SRC->RC_VALOR,SRC->RC_HORAS,,,,,,,,.T.)
			   SRC->(dbSkip()) 
			else
			   SRC->(dbSkip())   
   	   endif   
		endif */
		if nCont == 0
	      if !dbSeek(xFilial("SRC")+SRC->RC_MAT+"169")
	   		fGeraVerba("169",nBase * 0.40,40,,,,,,,,.T.)
	   		nCont:= 1
	     	   SRC->(dbSkip())
	     	else
	     		nCont := 1	
	     	endif	
	  	Endif

	  	if nCont == 1
	  	   if SRC->RC_TIPO2 == "I" .and. SRC->RC_PD == "169"
	  	      FDelPD("169")
   	      FGeraVerba("169",SRC->RC_VALOR,SRC->RC_HORAS,,,,,,,,.T.)
			   SRC->(dbSkip()) 
			else
			   SRC->(dbSkip())   
   	   endif   
	   endif 	     		
	     		
	Enddo                           
endif
Return

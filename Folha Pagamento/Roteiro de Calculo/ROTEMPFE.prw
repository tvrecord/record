#INCLUDE "RWMAKE.CH"  
#INCLUDE "Topconn.ch"  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �CALCISS  � Autor � RORILSON          a �  10/12/08 			  ���
�������������������������������������������������������������������������͹��
��� Desc.    � AJUSTE LANCAMENTOS FUTUROS                                 ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ROTEMPFE()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS       
           
aSvAlias :={Alias(),IndexOrd(),Recno()}


if SELECT("TMP") > 0                                
  TMP->(DBCLOSEAREA())
Endif

cQuery := "SELECT RK_VALORTO, RK_VLRPAGO, RK_VALORPA,RK_PARCPAG, RK_PD" //<===== COLOCAR O CAMPO DA DATA DE NASCIMENTO...
cQuery += " FROM " +RetSqlName("SRK")
//cQuery += " WHERE RB_FILIAL = '" + XFilial("SRB") + "' "
cQuery += " WHERE RK_MAT = '" + SRA->RA_MAT + "' "
//cQuery += " AND   RB_GRAUPAR = 'F' " 
cQuery += " AND   D_E_L_E_T_ = ' ' "            
	      
TcQuery :=  ChangeQuery(cQuery) 
TcQuery cQuery New Alias "TMP"
                                     
Dbselectarea("TMP")
_ValorPac := 0                         
Cont := 0
While !TMP->(Eof())
  
  IF (TMP->RK_VALORTO - TMP->RK_VLRPAGO) > 0
  
     fGeraVerba('464',TMP->RK_VALORPA,RK_PARCPAG+1,,,,,,,,.t.)
 
  Endif
  
  TMP->(DbSkip())                              
 
Enddo
              
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])


return

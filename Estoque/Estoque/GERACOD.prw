#INCLUDE "rwmake.ch"      
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERACOD   �Autor  �Rafael Franca       � Data �  06/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gerar codigo automatico quando o produto for do departamen ���
���          � to de maquiagem                                            ���
�����������������������������������������������������������������������������
*/

User Function GERACOD()

Local cSeqProd	:= "" 
Local cCodProd	:= "" 

cSeqProd  	:= StrZero(Val(Posicione("SBM",1,xFilial("SBM")+M->B1_GRUPO,"BM_PROXNUM"))+1,4)
cCodProd	:= Alltrim(M->B1_GRUPO) + Alltrim(cSeqProd)

dbSelectArea("SB1")

Return(cCodProd)   
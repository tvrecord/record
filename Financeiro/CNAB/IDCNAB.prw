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
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function XIDCNAB()

Local cSeqCNAB	:= "" 

cSeqCNAB  	:= StrZero(Val(Posicione("SEE",1,xFilial("SEE")+"237"+"34169","EE_ULTDSK"))+1,9)

	dbSelectArea("SEE")
	dbsetOrder(1)
	dbSeek (xFilial("SEE")+ "237" + "34169")
	RECLOCK("SEE",.F.)
	SEE->EE_ULTDSK := StrZero(Val(SEE->EE_ULTDSK)+1,6)
	MSUNLOCK()         

Return(cSeqCNAB) 

// ID unico do registro    

User Function XIDCNAB1()

Local cSeqCNAB1	:= "" 

cSeqCNAB1  	:= StrZero(Val(Posicione("SEE",1,xFilial("SEE")+"237"+"34169","EE_ULTDSK")),10) + SRA->RA_MAT

Return(cSeqCNAB1) 
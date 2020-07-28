#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �A103VLEX   � Autor � Bruno Alves� Data �  20/05/2014  ���
�������������������������������������������������������������������������͹��
��� Retorna o valor da permuta se a nota estiver vinculada com algum 	   ��
��� contrato de permuta                 								   ��
��� 								                                       ��
��                                                                        ���
�������������������������������������������������������������������������͹��
��������������������������������������	�����������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A103VLEX()
Local lOk := .T.

IF ALLTRIM(FUNNAME()) $ "MATA103"
	
	If  !EMPTY(SD1->D1_PERMUTA) .AND. !EMPTY(SD1->D1_ITEMPER)
		
		DBSelectArea("SC3")
		DbSetOrder(1)
		If DbSeek(xFilial("SC3") + SD1->D1_PERMUTA + SD1->D1_ITEMPER) // Encontra o Contrato
			
			Reclock("SC3",.F.)
			SC3->C3_TOTAL 		:= SC3->C3_TOTAL + MaFisRet(,"NF_TOTAL")
			SC3->C3_PRECO       := SC3->C3_PRECO + MaFisRet(,"NF_TOTAL")
			MsUnlock()
			
		else
			
			Alert("Contrato de Permuta com Numero: " + SD1->D1_PERMUTA + " e Item: " + SD1->D1_ITEMPER + " n�o localizado para estornar o valor, favor verificar com o administrador do Sistema")
			
		EndIf
		
	EndIf
	
EndIf

Return(lOk)

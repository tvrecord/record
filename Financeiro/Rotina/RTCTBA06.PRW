#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RTCTBA06     �Autor  �Edmilson D. Santos � Data �  22/01/08 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa executado atrav�s do ponto de entrada FA080TIT(), ���
���          � Gravando o proximo n�mero de cheque no cadastro de Banco.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RTCTBA06()

Local xCheque 
Local aSvAlias       
Local lRetorno := .T.

IF !Empty(cCheque390)   //CHEQUE AVULSO

	Dbselectarea("SA6")
	DbSetOrder(1)
	Dbseek(xFilial("SA6")+cBanco390+cAgencia390+cConta390)
	IF FOUND()
     	xCheque := STRZERO(VAL(cCheque390)+1,6)
      RecLock("SA6",.F.)
      SA6->A6_XULTCHE := xCheque
      MsUnLock()
   ENDIF
	
Endif          

Return 


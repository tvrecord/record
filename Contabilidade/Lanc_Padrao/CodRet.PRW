#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Programa  �505001�Autor  �Microsiga           � Data �  01/03/13       ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra para o novo plano de contas                           ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Verifica o codigo de reten��o do imposto e altera para a conta correta

User Function CodRet()

Private cConta := ""

_aArea := GetArea()

IF TYPE ("cCodRet") == "C"
	
	If !Empty(cCodRet)
		
		If cCodRet == "8045"
			cConta := "215100006"
		else
			cConta := "215100005"
		Endif
		
	Endif
	
ELSE
	cConta := "215100005"
ENDIF

_aArea	:= RestArea(_aArea)

Return(cConta)
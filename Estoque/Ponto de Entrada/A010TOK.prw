#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �Bruno Alves         � Data �  06/02/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Informar via tela os campos que dever�o ser obrigatorios   ���
���          � Caso precise cadastrar produtos do departamento de       	���
Maquiagem											      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function A010TOK

Local lOk := .T.

If M->B1_GERCOD == "2"
	
	If EMPTY(M->B1_MARCA) .AND. EMPTY(M->B1_TAMANHO) .AND. EMPTY(M->B1_COR) .AND. EMPTY(M->B1_SEXO)
		Alert("Favor preencher os seguintes campos: Marca , Tamanho , Cor , Sexo")
		lOk := .F.
	EndIf
	
ElseIf M->B1_GERCOD == "3"
	
	If EMPTY(M->B1_CATEGOR)
		Alert("Favor preencher o campo Categoria")
		lOk := .F.
	EndIf
	
	Return lOk
	
EndIf

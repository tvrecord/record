#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �Rafael Franca       � Data �  01/30/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para validar a conta contabil                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RECORD DF                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT241TOK()

Local lRet := .T.

//If SF5->F5_CODIGO == "502" .AND.  M->D3_LOCAL <> "Z1" .OR.  SF5->F5_CODIGO <> "502" .AND.  M->D3_LOCAL == "Z1"// Condi��o de n�o valida��o do documento pelo usu�rio     
//Aviso("Tipo de movimenta��o incorreta","Caro Usu�rio, voc� s� poder� baixar produtos do armaz�m Z1 com o tipo de movimenta��o 502!",{"Ok"}, 2)
//lRet := .F.  
//ELSE
//lRet := .T. 
//EndIf

Return lRet                                                
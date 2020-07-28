#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

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


User Function A010TOK()

Local lExecuta := .T.
/* 
Local cQuery := ""

cQuery := "SELECT * FROM SC7010 WHERE C7_NUM = '009203'"

TcQuery cQuery New Alias "TMP"

*/


IF (EMPTY(M->B1_CONTA) .OR. EMPTY(M->B1_POSIPI) .OR. EMPTY(M->B1_ORIGEM)) 
MsgInfo("N�o foi preenchido o campo conta contabil / Pos. IPI / Origem.","Aten��o")  
lExecuta := .T.
ENDIF                                                  

Return (lExecuta)
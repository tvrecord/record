#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALMUN    � Autor � Cristiano D. Alves � Data �  03/11/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida Cadastro de Munic�pios.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record - brasilia                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VALMUN()

Local _lRet := .T.

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

dbSelectArea("SZB")
dbSetOrder(2)

If FunName()=="MATA030" //Cadastro de Clientes                                                                        
	If !SZB->(dbSeek(xFilial()+M->A1_MUN))
		_lRet := .F.
		MsgStop("Nome do Munic�pio incorreto!!!")
	EndIf
EndIf   

If FunName()=="MATA020" //Cadastro de Fornecedores                                                                        
	If !SZB->(dbSeek(xFilial()+M->A2_MUN))
		_lRet := .F.
		MsgStop("Nome do Munic�pio incorreto!!!")
	EndIf
EndIf   

Return(_lRet)

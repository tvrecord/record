#INCLUDE "rwmake.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADFAIXA  � Autor � DANIEL CARVALHO    � Data �  17/05/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE											  ���
���          �       																	  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                 	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CADFAIX
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZ7"

dbSelectArea("SZ7")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Faixas de Comiss�es",cVldExc,cVldAlt)

Return
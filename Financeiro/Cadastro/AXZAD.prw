#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXZAD     � Autor � Rafael Fran�a      � Data �  24/05/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXZAD

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
                          
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cPerg   := "AXZAD"
Private cString := "ZAD"

dbSelectArea("ZAD")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Cache",cVldExc,cVldAlt)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return
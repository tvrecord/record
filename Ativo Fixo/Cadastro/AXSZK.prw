#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AxSZK     � Autor � Rafael Franca      � Data �  13/09/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de situacoes de ativos no sistema.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Record Centro-Oeste                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZK

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := "AXSZK"                             
//Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
//Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZK"

dbSelectArea("SZK")
dbSetOrder(1)

cPerg   := "AXSZK"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro de Situacoes",,)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return
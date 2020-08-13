#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXZAF     �Autor  �Bruno Alves         � Data �  26/12/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro das Pra�as 		                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AXZAF

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
                          
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cPerg   := "AXZAF"
Private cString := "ZAF"

dbSelectArea("ZAF")
dbSetOrder(1)

AxCadastro(cString,"Cadastro das Pra�as",cVldExc,cVldAlt)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return
	

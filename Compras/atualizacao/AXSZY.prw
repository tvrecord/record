#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO9     � Autor � AP6 IDE            � Data �  27/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZY

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cCadastro 	:= "Cadastro de Or�amento SIG"
Private aRotina   	:= {	{"Pesquisar" ,"AxPesqui",0,1}  	,;
						 	{"Visualizar","AxVisual",0,2} 	,;
							{"Incluir"	 ,"AxInclui",0,3}   ,;
							{"Alterar"	 ,"AxAltera",0,4}   ,; 
							{"Excluir"	 ,"AxDeleta",0,5}	,;
							{"Importar"	 ,"U_IMPORTSIG",0,2}}    //(" + (cPedido) + ")
Private cDelFunc  	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock   
Private cString   	:= "SZY"  

dbSelectArea(cString)
dbSetOrder(1)                                                  
mBrowse( 6,1,22,75,cString,,,,,,)
Return
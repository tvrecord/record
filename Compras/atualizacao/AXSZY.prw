#INCLUDE "rwmake.ch"

// Rafael Fran�a - 27/02/2014 - Cadastro de contas SIG com or�amento
// Compras -> Atualiza��es -> Especificos -> Contas SIG

User Function AXSZY

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

//Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
//Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cCadastro 	:= "Cadastro de Or�amento SIG"
Private aRotina   	:= {	{"Pesquisar" ,"AxPesqui",0,1}  	,;
						 	{"Visualizar","AxVisual",0,2} 	,;
							{"Incluir"	 ,"AxInclui",0,3}   ,;
							{"Alterar"	 ,"AxAltera",0,4}   ,;
							{"Excluir"	 ,"AxDeleta",0,5}	,;
							{"Importar CSV"	 ,"U_IMPORTSIG",0,2}}

Private cDelFunc  	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   	:= "SZY"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)
Return
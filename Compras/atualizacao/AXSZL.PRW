#INCLUDE "rwmake.ch"  
#INCLUDE "Protheus.ch"  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZL     � Autor � RAFAEL FRANCA      � Data �  08/12/10   ���
�������������������������������������������������������������������������͹��
���Descricao � CADASTRO DE DETALHES DO PEDIDO DE COMPRAS                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RECORD DF                                                  ���
����������������������������������������������������^���������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZL

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cCadastro 	:= "Cadastro de Autoriza��o"
Private aRotina   	:= {	{"Pesquisar" ,"AxPesqui",0,1}  ,;
						 	{"Visualizar","AxVisual",0,2} 	,;
							{"Incluir"	 ,"AxInclui",0,3}   ,;
							{"Alterar"	 ,"U_AxAlt1",0,4}    ,;
							{"Excluir"	 ,"AxDeleta",0,5}}    //(" + (cPedido) + ")
Private cDelFunc  	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock   
Private cString   	:= "SZL"    

dbSelectArea(cString)
dbSetOrder(1)                                                  
mBrowse( 6,1,22,75,cString,,,,,,)
Return
                  
User Function AxAlt1()                     
 
Private cPedido 	:= SZL->ZL_PEDIDO      
Private cSolic		:= SZL->ZL_SOLICIT  
Private cLib := Posicione("SCR",1,xFilial("SCR") + "PC" + cPedido,"CR_DATALIB")

IF EMPTY(cLib) .OR. AllTrim(cUserName) $ "Administrador"

dbSelectArea("SZL")  
dbSetOrder (2)     
dbSeek(xFilial("SZL") + cPedido )
AxAltera("SZL",SZL->(Recno()),4,,,,,".T.",,,,,,,.F.) 

ELSE 

MsgInfo("Pedidos liberados n�o podem ser alterados","Aten��o!")   
Return 

ENDIF                                                                            

Return 
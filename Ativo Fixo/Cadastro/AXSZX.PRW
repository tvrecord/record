#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZX     � Autor � RAFAEL FRANCA      � Data �  29/02/13   ���
�������������������������������������������������������������������������͹��
���Descricao �CADASTRO DE BENS EMPRESTADOS                                ���
�������������������������������������������������������������������������͹��
���Uso       �RECORD DF                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZX

Private cCadastro := "Bens em terceiros"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Legenda","u_LegSZX()",0,4}}
//Private aCores := {{'EMPTY(Z_DTDEVOL)','BR_VERDE'},{'!EMPTY(ZN_DTDEVOL)','BR_VERMELHO'}}
//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZX"
 
dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,) //aCores)

Return

User Function LegSZX

Local aLegenda := {{"ENABLE","Devolvido"},{"DISABLE","Disponivel"}}

BrwLegenda("Cadastro de Autoriza��o Fornecedor","Legenda",aLegenda)

Return(.t.)

Return()
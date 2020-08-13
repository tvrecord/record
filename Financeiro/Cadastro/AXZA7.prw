#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXZA7     �Autor  �Bruno Alves         � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Previs�es a receber                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AXZA7

Private cCadastro := "Previs�es a receber"
Private nOpca := 0
Private aParam := {}

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5},; 
{"Relatorio","u_FLUXOREC()",0,2},;
{"Inadimplentes","u_INADIMP()",0,2}}

Private cString := "ZA7"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return
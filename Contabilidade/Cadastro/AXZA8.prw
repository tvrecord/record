#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXZA8     �Autor  �Bruno Alves         � Data �  03/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Custo por Programa de Tv - Brasilia                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AXZA8

Private cCadastro := "Custo por Programa"
Private nOpca := 0
Private aParam := {}

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5},; 
{"Relatorio","u_CustPro()",0,2}}


Private cString := "ZA8"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return


User Function CustPro

Alert("Em Constru��o..........")

Return
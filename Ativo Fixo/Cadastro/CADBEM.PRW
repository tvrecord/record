#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADBEM    � Autor � Edmilson Santos    � Data �  17/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa destinado ao cadastro de bem, onde o usu�rio ir�  ���
���          � efetuado a Classifica��o do Bem automaticamente ele adici  ���
���          � ona a Descri��o do bem no Browse pertencente ao mesmo.     ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record-DF - modulo Ativo Fixo                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
    
/*

User Function CADBEM()

LOCAL aDesc := M->N1_DESCRIC
SetPrvt("CDESCR,OLBX,NX,ACOLS,LCONSLOJA,NLBXNAT")

IF ALLTRIM(FUNNAME()) $ "ATFA010/ATFA240"
	                                     
	//+----------------------------------------------------------+
	//� Inicializar colunas da GetDados.                         �
	//+----------------------------------------------------------+
	For nX := 1 To Len(aHeader)
		Do Case
			Case Trim(aHeader[nX][2]) == "N3_HISTOR"
				aCols[n][nX] := aDesc
		EndCase
	Next nX
	
ENDIF
RETURN (.t.)
  
*/
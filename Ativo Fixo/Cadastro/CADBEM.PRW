#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADBEM    º Autor ³ Edmilson Santos    º Data ³  17/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa destinado ao cadastro de bem, onde o usuário irá  º±±
±±º          ³ efetuado a Classificação do Bem automaticamente ele adici  º±±
±±º          ³ ona a Descrição do bem no Browse pertencente ao mesmo.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rede Record-DF - modulo Ativo Fixo                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
    
/*

User Function CADBEM()

LOCAL aDesc := M->N1_DESCRIC
SetPrvt("CDESCR,OLBX,NX,ACOLS,LCONSLOJA,NLBXNAT")

IF ALLTRIM(FUNNAME()) $ "ATFA010/ATFA240"
	                                     
	//+----------------------------------------------------------+
	//¦ Inicializar colunas da GetDados.                         ¦
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
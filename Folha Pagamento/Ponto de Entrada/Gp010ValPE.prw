#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³CALC    º Autor ³ Rorilson        º Data ³  10/12/08		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Antes de efetivar a Gravacao da Rescisao. Será alterado o salário base ±±
±±º para o salário composto, de acordo com o função Salmes como o conteúdo ±±
±±º previsto no final do cálculo.                                          ±±
±±                                                                        º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Gp010ValPE()
Local	_aArea	:= GetArea()
Local lOk := .T.

IF M->RA_ACFUNC == "S" .OR. M->RA_ACUMULA != 0 .OR. M->RA_CALCADI == "S"
	
	IF EMPTY(M->RA_DESCACU)
		Alert("Favor, preencher o campo Desc. Acumulo na pasta Beneficio")
		lOk := .F.
	ELSEIF EMPTY(M->RA_CCACUM) .OR. EMPTY(M->RA_ACUM) .OR. EMPTY(M->RA_INIACUM) 
	Alert("Favor, preencher todos esses campos na pasta Beneficio: C. Custo  Acum; Descrição C. Custo; Ini CC Acum")
		lOk := .F.
	ENDIF 
	
EndIf

RESTAREA(_aArea)

Return(lOk)



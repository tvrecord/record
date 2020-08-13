#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT130LOK  ºAutor  ³Rafael França       º Data ³  01/31/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORD DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT130LOK

Local aArea 	:= GetArea() 
Private lRetorno 	:= .T.
Private cProduto 	:= "" + ALLTRIM(SC1->C1_PRODUTO) + " " + SUBSTR(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_DESC"),1,20) + ""
Private cConta	 	:= Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_CONTA")
Private cPis		:= Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_POSIPI")
Private cOrigem		:= Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_ORIGEM")

IF EMPTY(cConta) .OR. EMPTY(cPis) .OR. EMPTY(cOrigem)
	MsgInfo("Produto " + ALLTRIM(cProduto) + " náo contem Conta Contabil; Pos. IPI ou Origem.")
	
	lRetorno := .F.	
	
	@ 000,000 TO 140,240 DIALOG oDlg TITLE "Cadastro de Produto"
	@ 005,010 Say "Para continuar com o processo de cotação "
	@ 015,018 Say "é preciso inserir a Conta Contabil;"
	@ 025,020 Say "Pos. IPI e Origem do Produto."
	@ 040,017 Say "Gostaria de Atualizar o cadastro?"
	@ 055,035 BUTTON "Sim" SIZE 26,10 ACTION AltProd()
	@ 055,065 BUTTON "Nao" SIZE 26,10 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
	
	
EndIf

IF !EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_CONTA")) .AND. !EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_POSIPI")) .AND. !EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_ORIGEM"))
	lRetorno := .T.
//	MsgInfo("Gravação realizada com sucesso!!!") Retirado para melhor performace
Else
	MsgInfo("Ainda faltam campos a serem inseridos, favor preencher.")
Endif


RestArea(aArea)

Return (lRetorno)



Static Function AltProd



Private cCCtb		:= Space(20)
Private cPis		:= Space(20)
Private cOrigem	 	:= Space(01)

Close(oDlg)

//Linha - Coluna
@ 000,000 TO 175,240 DIALOG oDlg TITLE "Altera Produto"
@ 010,015 Say "Conta Contabil:"
@ 009,055 Get cCCtb  F3 "CT1" Valid !EMPTY(cCCtb) .AND. Ctb105Cta() when iif(!EMPTY(cConta) ,.F.,.T. )
@ 025,015 Say "Pos.IPI/NCM:"
@ 024,055 Get cPis  F3 "SYD" Valid  !EMPTY(cPis) .AND. ExistCpo("SYD",cPis) when iif(!EMPTY(cPis) ,.F.,.T. )
@ 040,015 Say "Origem:"
@ 039,055 Get cOrigem  F3 "S0" Valid  !EMPTY(cOrigem) .AND. ExistCpo("SX5","S0"+cOrigem) when iif(!EMPTY(cOrigem),.F.,.T. )
@ 065,030 BMPBUTTON TYPE 01 ACTION GravaSB1()
@ 065,065 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED      



Return(lRetorno)


Static Function GravaSB1

DBSelectARea("SB1")
DBSetOrder(1)
DBSeek(xFilial("SB1") + SC1->C1_PRODUTO)
If Found()

	RecLock("SB1",.F.)
	If 	EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_CONTA"))
		SB1->B1_CONTA := cCCtb
	ENDIF
	If	EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_POSIPI"))
		SB1->B1_POSIPI := cPis
	ENDIF	
	If EMPTY(Posicione("SB1",1,xFilial("SB1") + SC1->C1_PRODUTO,"B1_ORIGEM"))
		SB1->B1_ORIGEM := cOrigem
	ENDIF	
	MSUNLOCK() 
	
EndIf 



Close(oDlg)
      
Return(lRetorno)
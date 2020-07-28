#Include "rwmake.ch"
#Include "Topconn.ch"

//Rafael França - 19/03/13 - Criação do registro na SZL após o OK da solicitação de compras.

User Function MT110TOK() 

Private lRetorno := .F.
Private cSolicit := cA110Num
Private cNomeSol := SPACE(40)
Private cObjet	 := SPACE(40)
Private cJustif  := SPACE(250)

dbSelectArea("SZL")
dbSetOrder(3)
IF DbSeek(xFilial("SZL") + cSolicit)   //Verifica se ja existe o detalhe do pedido SZL
	IF MsgYesNo("Deseja alterar o registro de detalhes do pedido?")
		cNomeSol := ZL_NOMESOL
		cJustif  := ZL_JUSTIFI
		cObjet 	 := ZL_OBJETIV
		TelaJust(cJustif,cObjet,cSolicit,cNomeSol) 
	ELSE
		lRetorno	:= .T.   //Fecha o programa no caso de resposta negativa
		Return (lRetorno)
	ENDIF
ELSE
	TelaJust(cJustif,cObjet,cSolicit,cNomeSol) 
ENDIF

Return (lRetorno)

STATIC FUNCTION TelaJust(cJustif,cObjet,cSolicit,cNomeSol,lRetorno)  


@ 000,000 TO 200,500 DIALOG oDlg TITLE "Justificativa solicitação de compras"
@ 010,005 Say "Objetivo:"
@ 010,040 Get cObjet VALID !EMPTY(cObjet)
@ 025,005 Say "Justificativa:"
@ 025,040 Get cJustif MEMO SIZE 200,040 VALID !EMPTY(cJustif)
@ 070,005 Say "Solicitante:"
@ 070,040 Get cNomeSol VALID !EMPTY(cNomeSol)
@ 085,005 BMPBUTTON TYPE 01 ACTION GravaJust(cJustif,cObjet,cSolicit,cNomeSol,lRetorno)
@ 085,035 BMPBUTTON TYPE 02 ACTION FechaTela()
ACTIVATE DIALOG oDlg CENTERED

Return()

Static Function GravaJust(cJustif,cObjet,cSolicit,cNomeSol)

dbSelectArea("SZL")
dbSetOrder(3)
IF DbSeek(xFilial("SZL") + cSolicit)
	Reclock("SZL",.F.)
	ZL_NOMESOL := cNomeSol
	ZL_JUSTIFI := cJustif
	ZL_OBJETIV := cObjet
	SZL->(MsUnlock())
ELSE
	Reclock("SZL",.T.)
	ZL_SOLICIT := cSolicit
	ZL_NOMESOL := cNomeSol
	ZL_JUSTIFI := cJustif
	ZL_OBJETIV := cObjet
	SZL->(MsUnlock())
ENDIF

lRetorno := .T.

Close(oDlg)

Return()

Static Function FechaTela(lRetorno)

lRetorno := .F.

Close(oDlg)

Return(lRetorno)
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT490	    º Autor ³Rafael Franca       º Data ³  15/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para corrigir depreciação acumulada        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Record DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AF010BUT()

Local aButtons := {}              

AADD(aButtons,{'EDITABLE', {||aAltDepre()},"Altera Depreciacao", "Alt Depre"})

Return(aButtons)

Static Function aAltDepre	//15/06/16 - Rafael França - Criado a pedido do Sr. Mateus para corrigir a depreciação de itens no sistema

//Private cFilial	:= xFilial("SN3")
Private cCbase	:= SN1->N1_CBASE
Private cItem	:= SN1->N1_ITEM
Private cTipo 	:= SPACE(2)
Private nValAcm := 0
Private nNovAcm	:= 0
Private cObs	:= PADR("CORRECAO DEPRECIACAO ACUMULADA",100)

@ 000,000 TO 200,600 DIALOG oDlg TITLE "Alterar Depreciação Acumulada"
@ 010,010 Say "Tipo Ativo:"
@ 010,060 Get cTipo F3 "G1"
@ 030,010 Say "Novo Valor:"
@ 030,060 Get nNovAcm PICTURE "@E 999,999,999.99" SIZE 70,10
@ 050,010 Say "Observação:"
@ 050,060 Get cObs
@ 080,220 BMPBUTTON TYPE 01 ACTION AltAcm()
@ 080,260 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function AltAcm()

If Empty(cTipo) .OR. Empty(nNovAcm)  
MsgInfo("Informe todos os campos!","VAZIO")
Return
Endif 

DbselectArea("SN3")
DbSetOrder(1)
IF DbSeek(xFilial("SN3") + cCBase + cItem + cTipo)

Processa({|| TcSqlExec("UPDATE SN3010 SET N3_VLANT = N3_VRDACM1 , N3_VRDBAL1 = " + cValToChar(nNovAcm) +",N3_VRDACM1 = " + cValToChar(nNovAcm) +", N3_OBS  = '" + cObs + "' WHERE N3_FILIAL = '01' AND N3_CBASE = '" + cCBase + "' AND N3_ITEM = '" + CItem + "' AND N3_TIPO = '" + cTipo + "' AND D_E_L_E_T_ = ''")},"Atualizando Valores")

/*
RecLock("SN3",.F.)
SN3->N3_VLANT 		:= SN3->N3_VRCACM1  
SN3->N3_VRCACM1 	:= nNovAcm
SN3->N3_OBS 		:= cObs                            
MsUnLock() 
*/

ENDIF

Close(oDlg)

Return
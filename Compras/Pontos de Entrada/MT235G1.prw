#Include "Protheus.ch"
#Include "Rwmake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT235G1   ºAutor  ³Bruno Alves         º Data ³  05/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para inserir um motivo em cada produto    º±±
±±º          ³ que foi eliminado pela rotina eliminar residuos            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT235G1()


	Public cPedido


	If SC7->C7_NUM != cPedido
		ExecBlock("TelaMot",.F.,.F.)
	else
		Reclock("SC7",.F.)
		SC7->C7_MOTIVO	:= cMotivo
		SC7->C7_DTMOT	:= DATE()
		MsUnlock()
	EndIf


Return .T.



User Function TelaMot()

	Public cMotivo	:= Space(80)

	@ 000,000 TO 100,500 DIALOG oDlg TITLE "Motivo - Eliminação Residuo"
	@ 037,148 Say "Pedido: " + SC7->C7_NUM + ""
	@ 017,020 Say "Motivo:"
	@ 016,060 Get cMotivo   Valid !EMPTY(cMotivo)
	@ 035,190 BMPBUTTON TYPE 01 ACTION InserMot(cMotivo)
	ACTIVATE DIALOG oDlg CENTERED


	Static Function InserMot(cMotivo)

		Close(oDlg)

		Reclock("SC7",.F.)
		SC7->C7_MOTIVO	:= cMotivo
		SC7->C7_DTMOT	:= DATE()
		MsUnlock()

		cPedido := SC7->C7_NUM

	Return




#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

User Function MATA094()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ""
	Local cIdPonto := ""
	Local cIdModel := ""
	Local lIsGrid := .F.
	Local nLinha := 0
	Local nQtdLinhas := 0
	Local cMsg := ""
	Local nOp

	If (aParam <> NIL)
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := (Len(aParam) > 3)

		nOpc := oObj:GetOperation() // PEGA A OPERAÇÃO

		If (cIdPonto =="BUTTONBAR")
			xRet := {{"Consulta", "Consulta", {|| ConsultPed()}},;
				{"Mapa Cotação", "Mapa Cotação", {|| u_CCI31U()}}}
		EndIf
	EndIf

Return (xRet)



Static Function ConsultPed()

	u_RELCOM01(2) // 1 = Relatorio / 2 = Consulta

Return



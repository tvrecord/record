#Include "rwmake.ch" 
#Include "Topconn.ch" 

User Function MT160OK()

Local aPlanilha := PARAMIXB // Array contendo todos os dados da Planilha de Cotação para validação
 
Local lContinua := .T.
ExecBlock("TelaOBS")  
Return ( lContinua )   
//User Function TelaOBS1 


/*
Local cOBS 		:= Space(35)
Local cNum	 	:= SC8->C8_NUM   

@ 000,000 TO 150,350 DIALOG oDlg TITLE "Registra Observacao"
@ 015,015 Say "Observacao"
@ 015,050 Get cOBS
@ 050,090 BMPBUTTON TYPE 01 ACTION AlteraOBS2(cNum,cOBS)
@ 050,125 BMPBUTTON TYPE 02 ACTION Close(oDlg) 
ACTIVATE DIALOG oDlg CENTERED

lContinua := .T.
Return (lContinua)                                                         

Static Function AlteraOBS2(cNum,cOBS)

Local cQuery 	:= ""  
SC8->C8_MOTIVO := cObs                                           
                                                                           
cQuery := "UPDATE SC8010 SET C8_MOTIVO = '" + (cOBS) + "' "
cQuery += "WHERE D_E_L_E_T_ <> '*' AND C8_NUM = '" + (cNum) + "'"  
  If (TCSQLExec(cQuery) < 0)
    lContinua := .F.
    Return MsgStop("TCSQLError() " + TCSQLError())
  EndIf

MsgInfo("Obsercação foi alterada com sucesso","Fim")  
lContinua := .T.
Close(oDlg)

Return (lContinua)
*/
  
#Include "rwmake.ch"
#INCLUDE "TopConn.ch"

User Function MT121BRW()

aadd(aRotina,{'Altera entrega',"U_ALTENT",0,2,0,NIL})

Return

User Function ALTENT()

Private cPedido		:= SC7->C7_NUM 
Private cItem		:= SC7->C7_ITEM    
Private dEmissao	:= SC7->C7_EMISSAO
Private nVal		:= SC7->C7_TOTAL  
Private cCond		:= SC7->C7_COND
Private nPrazo		:= 0                                                              
Private dPrazoAnt	:= CtoD("//")
Private dPrazoDep	:= CtoD("//")
Private dVenc		:= CtoD("//")  
Private aRet		:= {}   

DBSelectARea("SC8")
DBSetOrder(11)
IF DBSeek(xFilial("SC8") + cPedido + cItem)
                                        
nPrazo		:= SC8->C8_PRAZO                                                              
dPrazoAnt	:= (dEmissao + SC8->C8_PRAZO)
dPrazoDep	:= (dEmissao + SC8->C8_PRAZO)
aRet 		:= Condicao(nVal,cCond,,dPrazoDep,) 
dVenc		:= DATAVALIDA(aRet[1][1])   

ELSE  

	Alert("Só poderão ser alterados pedidos com cotação!")
	Return()

ENDIF

//Linha - Coluna
@ 000,000 TO 250,300 DIALOG oDlg TITLE "Altera Prazo de entrega do pedido " + cPedido + ""
@ 010,015 Say "DT Emissão:"
@ 009,070 Get dEmissao when .F. SIZE 40,020 
@ 025,015 Say "Prazo atual:" 
@ 024,070 Get dPrazoAnt when .F. SIZE 40,020 
@ 040,015 Say "Prazo em dias:"
@ 039,070 Get nPrazo PICTURE "@E 999" valid AtualTela()
@ 055,015 Say "Prazo após alteração:"
@ 054,070 Get dPrazoDep when .F. SIZE 40,020             
@ 070,015 Say "Vencimento:"
@ 069,070 Get dVenc when .F. SIZE 40,020 
@ 090,045 BMPBUTTON TYPE 01 ACTION GravaSC8()
@ 090,075 BMPBUTTON TYPE 02 ACTION Close(oDlg)   
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function AtualTela()

dPrazoDep 	:= dEmissao + nPrazo  
aRet 		:= Condicao(nVal,cCond,,dPrazoDep,) 
dVenc		:= DATAVALIDA(aRet[1][1])
oDlg:Refresh()
Return

Static Function GravaSC8

If EMPTY(nPrazo) 
	Alert("É necessario o preenchimento do novo prazo para a alteração!")
	Return
EndIf

DBSelectARea("SC8")
DBSetOrder(11)
DBSeek(xFilial("SC8") + cPedido)
If Found()
	
	If !EMPTY(nPrazo) // ALTERA PRAZO DE ENTREGA
		
		//Altera Pedido de Compra
		_cUpd := " UPDATE " + RetSqlName("SC8")
		_cUpd += " SET"
		_cUpd += " C8_PRAZO = "+ CVALTOCHAR(nPrazo) +" "
		_cUpd += " WHERE D_E_L_E_T_ = ' '"
		_cUpd += " AND C8_NUMPED = '"+ (cPedido) +"'"
		
		
		If TcSqlExec(_cUpd) < 0
			MsgStop("Ocorreu um erro na atualização na tabela SC8!!!")
			Final()
		EndIf

	EndIf	
	
	MsgInfo("Alteração realizada com sucesso!")
	
else
	
	Alert("Alteração não realizada!")
	
EndIf

Close(oDlg)

Return  
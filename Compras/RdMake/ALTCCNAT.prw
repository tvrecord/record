#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130LOK  บAutor  ณRafael Fran็a       บ Data ณ  01/31/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRECORD DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ALTCCNAT


Private cNum		:= Space(06)
Private cCC		    := Space(20)
Private cNat		:= Space(20)
                                    

//Linha - Coluna
@ 000,000 TO 175,240 DIALOG oDlg TITLE "Altera Centro de Custo e Natureza"
@ 010,015 Say "Nบ Pedido:"
@ 009,055 Get cNum  F3 "SC7" Valid !EMPTY(cNum) .AND.ExistCpo("SC7",cNum) 
@ 025,015 Say "Natureza:"
@ 024,055 Get cNat  F3 "SED" Valid  VAZIO() .OR. ExistCpo("SED",cNat) when iif(EMPTY(cNum) ,.F.,.T. )
@ 040,015 Say "C. de Custo:"
@ 039,055 Get cCC   F3 "CTT" Valid VAZIO() .OR. Ctb105CC() when iif(EMPTY(cNum) ,.F.,.T. )
@ 065,030 BMPBUTTON TYPE 01 ACTION Grava()
@ 065,065 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED   




Return



Static Function Grava         

If EMPTY(cCC) .AND. EMPTY(cNat)
Alert("ษ necessario o preenchimento do Centro de Custou ou natureza para realizar as altera็๕es")
Return
EndIf

DBSelectARea("SC7")
DBSetOrder(1)
DBSeek(xFilial("SC7") + cNum)
If Found()
	
	If !EMPTY(cCC) // ALTERA CENTRO DE CUSTO
		
		//Altera Pedido de Compra
		_cUpd := " UPDATE " + RetSqlName("SC7")
		_cUpd += " SET"
		_cUpd += " C7_CC = '"+ (cCC) +"', C7_USERLGA = 'PROTHEUSALT' "
		_cUpd += " WHERE D_E_L_E_T_ = ' '"
		_cUpd += " AND C7_NUM = '"+ (cNum) +"'"
		
		
		If TcSqlExec(_cUpd) < 0
			MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE1!!!")
			Final()
		EndIf
		
		//Altera Solicitacao
		_cUpd1 := " UPDATE " + RetSqlName("SC1")
		_cUpd1 += " SET"
		_cUpd1 += " C1_CC = '"+ (cCC) +"', C1_USERLGA = 'PROTHEUSALT' "
		_cUpd1 += " WHERE D_E_L_E_T_ = ' '"
		_cUpd1 += " AND C1_PEDIDO = '"+ (cNum) +"'"
		
		If TcSqlExec(_cUpd1) < 0
			MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE1!!!")
			Final()
		EndIf
		
		
	EndIf
	
	If !EMPTY(cNat) //ALTERA NATUREZA
		
		//Altera Solicitacao
		_cUpd2 := " UPDATE " + RetSqlName("SC1")
		_cUpd2 += " SET"
		_cUpd2 += " C1_NATUREZ = '"+ (cNat) +"', C1_USERLGA = 'PROTHEUSALT' "
		_cUpd2 += " WHERE D_E_L_E_T_ = ' '"
		_cUpd2 += " AND C1_PEDIDO = '"+ (cNum) +"'"
		
		If TcSqlExec(_cUpd2) < 0
			MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE1!!!")
			Final()
		EndIf
		
	EndIf
	
	
	MsgInfo("Altera็ใo realizada com sucesso!")
	
else
	
	Alert("Altera็ใo nใo realizada!")
	
EndIf

Close(oDlg)

Return





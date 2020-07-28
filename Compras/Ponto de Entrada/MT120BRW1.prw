#Include "rwmake.ch" 
#Include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097BUT  �Autor  �Rafael Franca       � Data �  26/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do mapa de cotacao na liberacao do pedido de     ���
���          � compras                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � RECORD DF                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120BRW

aadd(aRotina,{'Observacao','u_TelaOBS',0,4})

Return

User Function TelaOBS 
Local cOBS 		:= Space(35)
Local cPedido 	:= Space(6) 
Local cCotacao	:= Space(6) 
//IF !EMPTY (SC7->C7_NUM)
//cPedido 		:= SC7->C7_NUMPED 
//cCotacao        := SC7->C7_NUM
//EndIF

@ 000,000 TO 200,350 DIALOG oDlg TITLE "Registra Detalhes do Pedido"
@ 010,015 Say "Pedido:"
@ 010,050 Get cPedido F3 "SC7"
@ 030,015 Say "Cotacao:"
@ 030,050 Get cCotacao F3 "SC8" 
@ 050,015 Say "Observacao:"
@ 050,050 Get cOBS           
@ 080,105 BMPBUTTON TYPE 01 ACTION AlteraOBS(cPedido,cCotacao,cOBS)
@ 080,140 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function AlteraOBS(cPedido,cCotacao,cOBS)

Local cCotacao  := ""
Local cCotFor	:= ""
Local cQuery 	:= ""  
Local cQuery1 	:= ""

cCotFor := Posicione("SC7",1,xFilial("SC7")+cPedido+"0001","C7_FORNECE")

If Empty(cPedido)
	MsgInfo("Informe o Pedido","Vazio")
	Return
Endif

If Empty(cOBS)
	MsgInfo("Coloque a observa��o","Vazio")
	Return
Endif

If Empty(cNumCot)
	MsgAlert("Pedido n�o foi gerado por cota��o","Atencao")
	Return
Endif  



Return

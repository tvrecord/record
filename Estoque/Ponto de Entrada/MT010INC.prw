#Include "Rwmake.ch"  
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010INC ºAutor  ³Bruno Alves de Oli   º Data ³  11/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para inclusão do produto IPI no modulo      ±±
±±º          ³Medicina e controle de Trabalho, caso contrario iria precisar
vincular produto com o fornecedor para todos os produtos que
iriam efetuar emprestimo ao Funcionario					  				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Clientes Microsiga                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT010INC()

Private nNum := 0

/*

DBSelectArea("TN3")
DBSetOrder(1)
DBSeek(xFilial("TN3") + "999999" + "01" + SB1->B1_COD)
If !Found()
	
	RecLock("TN3",.T.)
	TN3->TN3_FILIAL := xFilial("TN3")
	TN3->TN3_CODEPI := SB1->B1_COD
	TN3->TN3_FORNEC := "999999"
	TN3->TN3_LOJA   := "01"
	TN3->TN3_NUMCAP := ""
	TN3->TN3_DTVENC := STOD("20121212")
	TN3->TN3_INDEVO := "1"
	TN3->TN3_DTAVAL := STOD("20121212")
	TN3->TN3_NUMCRF := ""
	TN3->TN3_NUMCRI := ""
	TN3->TN3_OBSAVA := ""
	TN3->TN3_TIPEPI := ""
	TN3->TN3_AREEPI := ""
	TN3->TN3_PERMAN := 0
	TN3->(MsUnLock())
	
EndIf 
*/

	dbSelectArea("SBM")
	dbsetOrder(1)
	dbSeek (xFilial("SBM")+ SB1->B1_GRUPO)
	RECLOCK("SBM",.F.)
	SBM->BM_PROXNUM := StrZero(Val(SBM->BM_PROXNUM)+1,4)
	MSUNLOCK()          
	
	dbSelectArea("SBM")	
	dbcloseArea("SBM")
	
Return .T.

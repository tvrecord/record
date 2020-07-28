#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT130WF   ºAutor  ³Bruno Alves		 º Data ³  15/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada apos finalizado a geração da cotacao		  º±±
±±º          ³Objetivo: Chamar o programa de alteracao fornecedor apos	  º±±
±±º          ³gravacao na tabela SC8 									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT130WF

Private cNat		:= Space(09)
Private nPrazo		:= 0

//Linha - Coluna
@ 000,000 TO 100,250 DIALOG oDlg TITLE "Inserir Natureza e Prazo de Entrega"
@ 005,015 Say "Natureza:"
@ 006,055 Get cNat  F3 "SED" Valid  !EMPTY(cNat) .AND. ExistCPO("SED",cNat) 
@ 018,015 Say "Dias p/ Entrega:"
@ 019,055 Get nPrazo  PICTURE "@E 999"//Valid  !EMPTY(dEntrega) //Data da entrega - Grava em todos os fornecedores
@ 035,045 BMPBUTTON TYPE 01 ACTION GravaSC8()
@ 035,080 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaSC8  ºAutor  ³Bruno Alves		 º Data ³  15/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa utilizado para alterar os fornecedores conforme	  º±±
±±º          ³gravado na tabela SC8 pela rotina MATA130 (Gerar Cotacao),  º±±
±±º          ³lembrando que as vezes será inclusos novos fornecedores 	  º±±
±±º        	 ³na tabela .												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaSC8


Local cQuery   	:= ""
Local cQuery5  	:= ""
Local cContato 	:= ""
Local cNumCot 	:= SC8->C8_NUMSC



//A cQuery busca todas as informacoes criadas pela geracao da cotacao que ainda esta em aberta e ordena por filial e produto conforme inserido na solicitacao.

cQuery := "SELECT * FROM " + RetSqlName("SC8") + " WHERE "
cQuery += "C8_NUMSC = '" + (SC8->C8_NUMSC) + "' AND D_E_L_E_T_ <> '*' AND C8_NUMPED = '' "
cQuery += "ORDER BY C8_FILIAL,C8_PRODUTO,C8_IDENT"

TcQuery cQuery New Alias "TMP"

dbSelectArea("TMP")
dbGotop()


While !EOF() .OR. TMP->C8_NUMSC == SC8->C8_NUMSC

	
	dbSelectARea("SC8")
	dbSetOrder(3)
	dbSeek(TMP->C8_FILIAL + TMP->C8_NUM + TMP->C8_PRODUTO + TMP->C8_FORNECE + TMP->C8_LOJA)
	
	
	RECLOCK("SC8",.F.)
	SC8->C8_PRAZO	:= nPrazo
	MSUNLOCK()
	
	
	
	dbSelectArea("TMP")
	Dbskip()
	
Enddo   

cQuery5 := "UPDATE " + RetSqlName("SC1") + " SET "
cQuery5 += "C1_NATUREZ = '" + (cNat) + "' WHERE "
cQuery5 += "C1_NUM = '" + (SC8->C8_NUMSC) + "' AND D_E_L_E_T_ <> '*'"
                                                                                                              
If TcSqlExec(cQuery5) < 0
	MsgStop("Ocorreu um erro na atualização na tabela SC8!")
	Final()
EndIf

dbSelectArea("TMP")
dbCloseARea("TMP")
dbSelectArea("SC8")
dbCloseARea("SC8")



MsgInfo("Natureza e Prazo de entrega inserido com sucesso!")
Close(oDlg)

Return



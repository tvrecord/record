#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBHIS    ºAutor  ³Microsiga           º Data ³  12/28/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ATRIBUI O HISTORICO BASEADO PARA A CONTABILIDADE ATRAVÉS   º±±
±±º          ³ DO LP - 650/660.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBHIS()

Local aArea 	:= GetArea()
Local pHisto	:= ""

//Programa de contabilização dos itens da nota fiscal, dados da tabela SD1
IF (Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CODIGO") $ "192,196,198")
    pHisto := "RETORNO REM. S/NF " + SD1->D1_DOC + " " + TRIM(SA2->A2_NREDUZ) + " " + SD1->D1_FORNECE
ELSE
    pHisto := "AQUIS. NF " + SD1->D1_DOC + " F. " + SD1->D1_FORNECE + "-" + SUBSTRING(SA2->A2_NREDUZ,1,20) + " - " + ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC"))
ENDIF

//Rafael França - Historico das salas em contrato
//IF !Empty(Posicione("SF1",1,xFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ,"F1_SALAS"))
	//pHisto := pHisto + " - " + Posicione("SF1",1,xFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ,"F1_SALAS")
//ENDIF
IF !Empty(__cCamNovo01)
	pHisto := pHisto + " - " + __cCamNovo01
ENDIF

RestArea(aArea)

Return(pHisto)

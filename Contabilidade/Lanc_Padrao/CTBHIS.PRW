#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
���Programa  �CTBHIS    �Autor  �Microsiga           � Data �  12/28/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � ATRIBUI O HISTORICO BASEADO PARA A CONTABILIDADE ATRAV�S   ���
���          � DO LP - 650/660.                                           ���
�����������������������������������������������������������������������������
*/

User Function CTBHIS()

Local aArea 	:= GetArea()
Local pHisto	:= ""

//Programa de contabiliza��o dos itens da nota fiscal, dados da tabela SD1
IF (Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CODIGO") $ "192,196,198")
    pHisto := "RETORNO REM. S/NF " + SD1->D1_DOC + " " + TRIM(SA2->A2_NREDUZ) + " " + SD1->D1_FORNECE
ELSE
    pHisto := "AQUIS. NF " + SD1->D1_DOC + " F. " + SD1->D1_FORNECE + "-" + SUBSTRING(SA2->A2_NREDUZ,1,20) + " - " + ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC"))
ENDIF

//Rafael Fran�a - Historico das salas em contrato. Se for na rotina de Documento de Entrada, contabiliza pela variavel pubplica __cCamNovo01, se for pela contabiliza��o de documento de entrada grava pelo campo F1_SALAS
IF Alltrim(FUNNAME()) <> "CTBANFE"
	IF !Empty(__cCamNovo01)
	pHisto := pHisto + " - " + __cCamNovo01
	ENDIF
ELSE
	IF !Empty(Posicione("SF1",1,xFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ,"F1_SALAS"))
	pHisto := pHisto + " - " + Posicione("SF1",1,xFilial("SF1") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ,"F1_SALAS")
	ENDIF
ENDIF

RestArea(aArea)

Return(pHisto)

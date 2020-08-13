#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTCTBA01  ºAutor  ³Edmilson Dias Santos º Data ³05/12/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD - LP 590/591                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTCTBA01() //PROGRAMA QUE IRÁ EFETUAR O POSICIONAMENTO DA TABELA SE2

Local _nVLR01 	:= 0
Local _nCheque := SEF->EF_NUM
Local _nVlTit  := SEF->EF_VALOR
Local _nFornece:= SEF->EF_FORNECE
Local _OrigCheq:= ORIGCHEQ

Private _aArea
Private _Histor

_aArea := GetArea()

DBSELECTAREA("SE2")
_aOrdSE2 := IndexOrd()
_aRecSE2 := Recno()

DBSELECTAREA("SE1")
_aOrdSE1 := IndexOrd()
_aRecSE1 := Recno()

DBSELECTAREA("SE5")
_aOrdSE5 := IndexOrd()
_aRecSE5 := Recno()

DBSELECTAREA("SEF")
_aOrdSEF := IndexOrd()
_aRecSEF := Recno()

IF !ALLTRIM(FUNNAME()) $ "FINA190"
	IF !EMPTY(_nCheque)   //BAIXA 1 PARA 1 (IMPRESSAO DE CHEQUE)               
		DBSELECTAREA("SE2")
		DBSETORDER(1)
		DBSEEK(xFilial("SEF")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
		_nVLR01 := _nVlTit+SE2->E2_DESCONT
	ELSEIF ALLTRIM(_OrigCheq) <> "FINA190" .AND. _nCheque == NUMCHEQUE   //GERACAO DE CHEQUE - JUNTAR (BAIXA MANUAL)
		DBSELECTAREA("SE2")
		DBSETORDER(17) 	//INDICE DE CHEQUE PARA SER UTILIZADO NO LP 590 QUANDO FOR BAIXA ATRAVÉS DA IMPRESSAO DE CHEQUE
		DBSEEK(xFilial("SE2")+NUMCHEQUE)
		IF Found()
			_nVLR01 := SE2->E2_VALLIQ+SE2->E2_DESCONT-SE2->E2_JUROS-SE2->E2_MULTA-SE2->E2_CORREC
		ENDIF                            
		
	ELSEIF ALLTRIM(_OrigCheq) <> "FINA190" .AND. _nCheque <> NUMCHEQUE	 //IMPRESSAO DE CHEQUE NUMERANDO AUTOMATICO
	  	DBSELECTAREA("SE2")
		DBSETORDER(17) 	//INDICE DE CHEQUE PARA SER UTILIZADO NO LP 590 QUANDO FOR BAIXA ATRAVÉS DA IMPRESSAO DE CHEQUE
		DBSEEK(xFilial("SE2")+NUMCHEQUE)
		IF Found()
			_nVLR01 := SE2->E2_VALLIQ+SE2->E2_DESCONT-SE2->E2_JUROS-SE2->E2_MULTA-SE2->E2_CORREC
		ENDIF                            

	ENDIF
ELSE
	_nVLR01 := SE2->E2_VALLIQ+SE2->E2_DESCONT-SE2->E2_JUROS-SE2->E2_MULTA-SE2->E2_CORREC
ENDIF

DBSELECTAREA("SE2")
DBSETORDER(_aOrdSE2)
DBGOTO(_aRecSE2)

DBSELECTAREA("SE1")
DBSETORDER(_aOrdSE1)
DBGOTO(_aRecSE1)

DBSELECTAREA("SE5")
DBSETORDER(_aOrdSE5)
DBGOTO(_aRecSE5)

DBSELECTAREA("SEF")
DBSETORDER(_aOrdSEF)
DBGOTO(_aRecSEF)

_aArea	:= RestArea(_aArea)

Return(_nVLR01)

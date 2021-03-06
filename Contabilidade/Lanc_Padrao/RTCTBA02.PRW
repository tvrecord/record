#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RECTB590  �Autor  �MARCIO T. SUZAKI    � Data �26/11/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � RECORD - LP 590/591                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RTCTBA02() //PROGRAMA QUE IR� EFETUAR O POSICIONAMENTO DA TABELA SE2

Local _nVLR01 	:= 0   
Local _OrigChe := SEF->EF_NUM     
Local _nVlTit  := SEF->EF_VALOR
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

IF !EMPTY(_OrigChe)
   _Histor := "BX. S/TIT. "+ALLTRIM(SEF->EF_TITULO)+" "+ALLTRIM(SEF->EF_BENEF)+" CF. CH "+ALLTRIM(SEF->EF_NUM)
ELSE
	DBSELECTAREA("SE2")
	DBSETORDER(17) 	//INDICE DE CHEQUE PARA SER UTILIZADO NO LP 590
	DBSEEK(xFilial("SE2")+NUMCHEQUE)
	IF Found()
      _Histor := "BX. S/TIT. "+ALLTRIM(SE2->E2_NUM)+" "+ALLTRIM(SE2->E2_NOMFOR)+" CF. CH "+ALLTRIM(SE2->E2_NUMBCO)
	ENDIF   
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

Return(_Histor)
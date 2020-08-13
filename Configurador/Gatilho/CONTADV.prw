#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONTADV     �Autor  �Bruno Alves         � Data �14/07/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Informa a quantidade de advertencias e suspens�es recebidas���
���          � por cada funcionario										  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


USER FUNCTION CONTADV

Local cQuery   := ""
Local cAdv     := ""
Local cSusp    := ""
Local nQtdAdv  := 0
Local nQtdSusp := 0    

dBSelectArea("SZG")
dBSetOrder(1)




cQuery := "SELECT ZG_MAT,ZG_TIPOADV,ZG_MOTIVO,COUNT(ZG_TIPOADV) AS ZG_QUANT FROM " + RetSqlName("SZG") + "  WHERE ZG_FILIAL = '" + SZG->ZG_FILIAL + "' AND ZG_MAT = '" + M->ZG_MAT + "' AND ZG_MOTIVO = '" + M->ZG_MOTIVO + "' AND ZG_EMISSAO >=  '" + SUBSTR(DTOS(DATE()),1,4) + "0101" + "' AND D_E_L_E_T_ <> '*' GROUP BY ZG_MAT,ZG_TIPOADV,ZG_MOTIVO ORDER BY ZG_TIPOADV"
tcQuery cQuery New Alias "TMP" // Faz a contagem das suspens�es e advertencias do funcionario.

If Eof()
	MsgInfo("Funcionario com Suspens�o: 0; Advertencia: 0") // Se n�o existir advertencia ou suspens�o o usuario � informado.
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

dbSelectArea("TMP")
dbGotop()

While !Eof()
	
	If(TMP->ZG_TIPOADV == "A")
		cAdv := "Advertencia"
		nQtdAdv := TMP->ZG_QUANT
	EndIf
	
	If(TMP->ZG_TIPOADV == "S")
		cSusp := "Suspensao"
		nQtdSusp := TMP->ZG_QUANT
	EndIf 
	
	dbskip()
	
EndDo

If(!Empty(cAdv) .and. !Empty(cSusp))
	MsgInfo("Funcionario com Advertencia: " + Alltrim(STR(nQtdAdv)) + "; Suspens�o: " + Alltrim(STR(nQtdSusp)) + ".")
ElseIf (!Empty(cAdv) .and. Empty(cSusp))
	MsgInfo("Funcionario com Advertencia: " + Alltrim(STR(nQtdAdv)) + "; Suspens�o: " + Alltrim(STR(nQtdSusp)) + ".")
ElseIf(Empty(cAdv) .and. !Empty(cSusp))
	MsgInfo("Funcionario com Advertencia: " + Alltrim(STR(nQtdAdv)) + "; Suspens�o: " + Alltrim(STR(nQtdSusp)) + ".")
EndIf


dbCloseArea("TMP")


RETURN

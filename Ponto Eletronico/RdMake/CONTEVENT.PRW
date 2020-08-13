#INCLUDE "rwmake.ch"
#INCLUDE "protheus.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONTEVENT ºAutor  ³Bruno Alves         º Data ³  08/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ INFORMA A QUANTIDADE DE EVENTO INSERIDO PARA O DETERMINADO º±±
±±º          ³ FUNCIONARIO                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function CONTEVENT()

Local cQuery1 := ""
//Local cQuery2 := ""
Local nTotal  := 0
Local cIniDt  := CVALTOCHAR(YEAR(aCols[n][1]) - 1) + SUBSTR(DTOS(aCols[n][1]),5,4)
Local cFimDt  := DTOS(aCols[n][1])
Local nQtd    := 0

IF(M->PC_ABONO) == "132"

cQuery1 := "SELECT COUNT(PH_MAT) AS QUANTIDADE FROM SPH010 WHERE "
cQuery1 += "PH_FILIAL = '01' AND "
cQuery1 += "PH_MAT = '" + (SPC->PC_MAT) + "' AND "
cQuery1 += "PH_ABONO = '132' AND "
cQuery1 += "PH_DATA BETWEEN '" + (cIniDt) + "' AND '" + (cFimDt) + "' AND "
cQuery1 += "D_E_L_E_T_ <> '*' "

tcQuery cQuery1 New Alias "QSPH"

/*
cQuery2 := "SELECT COUNT(PC_MAT) AS QUANTIDADE FROM SPC010 WHERE "
cQuery2 += "PC_FILIAL = '01' AND "
cQuery2 += "PC_MAT = '" + (SPC->PC_MAT) + "' AND "
cQuery2 += "PC_ABONO = '132' AND "
cQuery2 += "PC_DATA BETWEEN '" + (cIniDt) + "' AND '" + (cFimDt) + "' AND "
cQuery2 += "D_E_L_E_T_ <> '*' "

tcQuery cQuery2 New Alias "QSPC"
*/

For i:=1 to Len(aCols)
If aCols[i][8] == "132"
nQtd++
EndIf
Next


//nTotal := QSPH->QUANTIDADE + QSPC->QUANTIDADE
nTotal := QSPH->QUANTIDADE + nQtd
nTotal += 1 //Somar o que já está incluindo 

Alert("No periodo de um ano foram ou foi cadastrado " + CVALTOCHAR(nTotal) + " evento(s) 132")


DBSelectARea("QSPH")
DBCloseARea("QSPH")

/*
DBSelectARea("QSPC")
DBCloseARea("QSPC")
*/


ENDIF


Return .T.



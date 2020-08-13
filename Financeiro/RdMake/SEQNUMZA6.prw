#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


// Foi criada essa função para executar o numero sequencial, houve falha utilizando o controle SXE/SXF
// Bruno Alves 22/04/2014

User Function ZA6NUMSEQ()       

Private cNumZA6 := ""
Private cQuery := ""


cQuery := "SELECT MAX(ZA6_CODIGO) AS NUMERO FROM ZA6010 WHERE "
cQuery += "D_E_L_E_T_ <> '*' "

tcQuery cQuery New Alias "NUMZA6"

DBSelectArea("NUMZA6")
DBGotop()

cNumZA6 := strzero(val(NUMZA6->NUMERO)+1,6)

dbSelectArea("NUMZA6")
dbCloseArea("NUMZA6")


Return(cNumZA6)
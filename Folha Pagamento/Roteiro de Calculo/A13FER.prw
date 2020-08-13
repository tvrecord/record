#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//10/12/18 - Rafael França - Correção do pagamento da 1 parcela do 13 com base no salario composto.

User Function A13FER() 

IF fBuscaPD("041") > 0 //Verifica sem tem a 1 pacela do 13
fDelPD("041")  
	fGeraVerba("041", (salmes  / 100 * RH_PERC13S) ,RH_PERC13S,,,,,,,,.T.)
ENDIF
	
Return()
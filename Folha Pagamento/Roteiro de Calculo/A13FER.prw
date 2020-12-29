#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//10/12/18 - Rafael França - Correção do pagamento da 1 parcela do 13 com base no salario composto.

User Function A13FER()

IF fBuscaPD("041") > 0 //Verifica sem tem a 1 pacela do 13
fDelPD("041")
//Rafael França - 17/12/20 - Alterado o valor do salario Salmes - > (SRA->RA_SALARIO + SRA->RA_REMUNEN) - Alguns funcionarios estavam com salmes errado no roteiro de calculo
	fGeraVerba("041", ((SRA->RA_SALARIO + SRA->RA_REMUNEN)  / 100 * RH_PERC13S) ,RH_PERC13S,,,,,,,,.T.)
ENDIF

Return()
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//02/04/2019 - Rafael França - Verbas de banco de horas

User Function FOLBCH()

Local nSaldo  := Posicione( "SZF", 1, xFilial("SZF") + (SRA->RA_MAT) + (RCH->RCH_PER), "ZF_SALDANT" )
Local nSaldoP := 0
Local nSaldoN := 0
Local cQuery1 := ""

cQuery1 := "SELECT PI_MAT,PI_PD,PI_QUANT,P9_TIPOCOD FROM SPI010 "
cQuery1 += "INNER JOIN SP9010 ON PI_PD = P9_CODIGO "
cQuery1 += "WHERE SPI010.D_E_L_E_T_ = '' AND SP9010.D_E_L_E_T_ = ''  "
cQuery1 += "AND PI_MAT = '" + ALLTRIM(SRA->RA_MAT) + "' "
cQuery1 += "AND SUBSTRING(PI_DATA,1,6) = '" + ALLTRIM(RCH->RCH_PER) + "' "

tcQuery cQuery1 New Alias "TMPSPI"

DbSelectArea("TMPSPI")
DBGotop()
                             
While !TMPSPI->(Eof())
	
	If TMPSPI->P9_TIPOCOD == "1"
		nSaldoP   := SomaHoras(nSaldoP,TMPSPI->PI_QUANT)
	Else
		nSaldoN   := SomaHoras(nSaldoN,TMPSPI->PI_QUANT)
	Endif  
	
	dbskip()
	
END 

	dbSelectArea("TMPSPI")
	dbCloseArea("TMPSPI")

If nSaldo <> 0 .AND. RCH->RCH_PER == "201903" //Data de implantação do saldo inicial no ESocial - Giselly
	If nSaldo > 0
		fGeraVerba("283",nSaldo,nSaldo,,,"H",,,,,.T.)
	Else
		fGeraVerba("600",nSaldo * (-1),nSaldo * (-1),,,"H",,,,,.T.)
	EndIf
EndIf

If nSaldoP > 0
	fGeraVerba("438",nSaldoP,nSaldoP,,,"H",,,,,.T.)
EndIf

If nSaldoN > 0
	fGeraVerba("302",nSaldoN,nSaldoN,,,"H",,,,,.T.)
EndIf

Return()
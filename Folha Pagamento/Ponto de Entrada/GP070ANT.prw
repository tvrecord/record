#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±º Programa ³GP070ANT  º Autor ³ Bruno Alves     º Data ³  27/06/2012    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ altera os campos das medias nas verba 060,118 quando altera ±±
±±  o codigo do funcionario que está sendo processado  .                   ±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±]±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GP070ANT() 


Local _cUpd := ""

If Posicione("SRA",1,xFilial("SRA")+SRC->RC_MAT,"SRA->RA_SITFOLH") != "D"
	
	//Atualizando baixas
	_cUpd := "UPDATE SRV010 SET "
	_cUpd += "RV_MED13 = 'S', RV_MEDFER = 'S', RV_MEDAVI = 'S' WHERE "
	_cUpd += "RV_COD IN ('060','118') AND "
	_cUpd += "D_E_L_E_T_ <> '*' "
	
	If TcSqlExec(_cUpd) < 0
		MsgStop("Ocorreu um erro na atualização das verbas!!!")
		Final()
	EndIf

ELSE	

	//Atualizando baixas
	_cUpd := "UPDATE SRV010 SET "
	_cUpd += "RV_MED13 = 'N', RV_MEDFER = 'N', RV_MEDAVI = 'N' WHERE "
	_cUpd += "RV_COD IN ('060','118') AND "
	_cUpd += "D_E_L_E_T_ <> '*' "
	
	If TcSqlExec(_cUpd) < 0
		MsgStop("Ocorreu um erro na atualização das verbas!!!")
		Final()
	EndIf
	
	
Endif


Return




#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"

USER FUNCTION GPA130MN()

Local aRotina 	:= ParamIXB[1]
Local aSubMenu
Local aUserMenu  

aSubMenu := 	{{ "Alterar Periodo" 			,"U_ALTTRANS"	, 0 , 2}}


aUserMenu :=	{ 'Menu User'       ,aSubMenu    , 0 , 2}
AADD(aRotina, aUserMenu)

Return aClone(aRotina) 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTTRANS    บAutor  ณBruno Alves         บ Data ณ  04/02/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo do periodo do calculo do vale transporte          บฑฑ
ฑฑบ          ณpara realizar uma integra็ใo                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ALTTRANS

Private dData1 	:= CtoD("//")
Private dData2 	:= CtoD("//")       

DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


@ 000,000 TO 150,300 DIALOG oDlg TITLE "Periodo Vale Transporte"
@ 011,020 Say "Da Data:"
@ 010,060 Get dData1 SIZE 40,020
@ 025,020 Say "Para Data:"
@ 024,060 Get dData2 SIZE 40,020
@ 061,090 BMPBUTTON TYPE 01 ACTION TelaRG2()
@ 060,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



Static Function TelaRG2()

Close(oDlg)

Processa({|| AlteraRG2() },"Alterando periodo requisitado...")

Return


Static Function AlteraRG2

Local _cUpd		:= ""
Local _cQuery 	:= ""

cQuery := "SELECT COUNT(RG2_MAT) AS NUM FROM RG2010 WHERE "
cQuery += "RG2_PERIOD = '" + SUBSTR(DTOS(dData2),1,6) + "' AND "
cQuery += "D_E_L_E_T_ <> '*' "

TcQuery cQuery New Alias "TMP"

If TMP->NUM > 0
	Alert("Existe registro nesse periodo, por esse motivo a altera็ใo nใo serแ realizada!!")
	DBCloseArea("TMP")
	Return
Endif

DBCloseArea("TMP")




_cUpd := "UPDATE RG2010 SET "
_cUpd += "RG2_PERIOD = '" + SUBSTR(DTOS(dData2),1,6) + "', RG2_ANOMES = '" + SUBSTR(DTOS(dData2),1,6) + "' WHERE "
_cUpd += "RG2_PERIOD = '" + SUBSTR(DTOS(dData1),1,6) + "' AND "
_cUpd += "D_E_L_E_T_ <> '*' "

If TcSqlExec(_cUpd) < 0
	MsgStop("Ocorreu um erro na altera็ใo do periodo!!!")
	Final()
EndIf

_cUpd := "UPDATE SR0010 SET "
_cUpd += "R0_DIASPRO = 0 "

If TcSqlExec(_cUpd) < 0
	MsgStop("Ocorreu um erro na zera็ใo do dias proporcionais!!!")
	Final()
EndIf

Return


#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTEDISSบ Autor ณ Bruno Alves        บ Data ณ  25/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ajuste dissidio devido otimiza็ใo de acumulo no roteiro    บฑฑ
ฑฑบ           de calculo da folha de pagamento                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DISSFER

Private cPerg	:= "DISSFER"

ValidPerg()
If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

IF MV_PAR10 == 1
	
	Processa({|| GravaFer() },"Alterando Ferias...")
	
EndIf

Static Function GravaFer

cQuery	:= "SELECT RHH_FILIAL,RHH_CC,RHH_MAT,RHH_DATA,RHH_MESANO,(SUM(RHH_VL)  * "+cValToChar(MV_PAR11) +") / 100 AS VALOR "
cQuery	+= "FROM RHH010 WHERE "
cQuery	+= "RHH_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery	+= "RHH_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery	+= "RHH_CC BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery	+= "RHH_DATA BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery	+= "RHH_MESANO = '" + (MV_PAR09) + "' AND "
cQuery	+= "RHH_VB IN ('023','024','025','027','028','029','050','116','102','115','562','563') AND "
cQuery	+= "D_E_L_E_T_ <> '*' "
cQuery	+= "GROUP BY RHH_FILIAL,RHH_CC,RHH_MAT,RHH_DATA,RHH_MESANO "
cQuery	+= "ORDER BY RHH_MAT "

TcQuery cQuery New Alias "TMP"

COUNT TO nRec

DbSelectArea("TMP")
dbGoTop()

procregua(nRec)


While !TMP->(Eof())
	
	IncProc("Gravando ajuste da Verba 056")
	
	DbSelectArea("RHH")
	dbSetOrder(2)
	DbSeek(TMP->RHH_FILIAL+TMP->RHH_MAT+TMP->RHH_DATA+TMP->RHH_MESANO+"056")
	If Found()
		
		RecLock("RHH",.F.)
		RHH_CALC := ROUND(TMP->VALOR,2)
		RHH_VALOR := ROUND(TMP->VALOR,2)
		RHH->(MSUNLOCK())
		
	ELSE
		
		RecLock("RHH",.T.)
		RHH->RHH_FILIAL  := TMP->RHH_FILIAL
		RHH->RHH_MAT := TMP->RHH_MAT
		RHH->RHH_CC := TMP->RHH_CC
		RHH->RHH_VB := "056"
		RHH->RHH_DATA := TMP->RHH_DATA
		RHH->RHH_VERBA := "236"
		RHH->RHH_CALC := ROUND(TMP->VALOR,2)
		RHH->RHH_VALOR := ROUND(TMP->VALOR,2)
		RHH->RHH_TPOAUM := "003"
		RHH->RHH_COMPL_ := "S"
		RHH->RHH_MESANO := MV_PAR09
		RHH->RHH_TIPO1 := "V"
		RHH->RHH_TIPO2 := "C"
		RHH->RHH_HORAS := 30
		RHH->(MSUNLOCK())
		
	EndIf
	
	
	
	
	TMP->(dbSkip())
	
	
End

MsgInfo("Altera็๕es realizadas com sucesso!!!")

DBSelectARea("TMP")
DBCloseARea("TMP")


Return


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Da Filial        ?","","","mv_ch1","C",02,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{cPerg,"02","Ate Filial     ?","","","mv_ch2","C",02,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{cPerg,"03","Da Matricula         ?","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"04","Ate Matricula      ?","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"05","De C. Custo        ?","","","mv_ch5","C",09,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"06","Ate C. Custo     ?","","","mv_ch6","C",09,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"07","De Data (AAAAMM)        ?","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate Data (AAAAMM)      ?","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ano/Mes do Calculo (AAAAMM)      ?","","","mv_ch9","C",06,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Processo      ?","","","mv_ch10","N",01,00,0,"C","","mv_par10","Gravar","","","","","Relat๓rio","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Porcentagem      ?","","","mv_ch11","N",05,2,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})



For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTURNOALT บ Autor ณ Bruno Alves        บ Data ณ  22/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Alterar o turno conforme parametriza็ใo					  บฑฑ
ฑฑบ          ณ 												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TURNOALT

Local nCount	:=	0

Private cPerg      := "TURNOALT1"
Private cUpd       := ""
Private cQuery     := ""

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

If MsgYesNo("Tem certeza que deseja alterar a hora trabalhada dos turnos para " + cValToChar(MV_PAR03) + " e a hora de descanso para " + cValToChar(MV_PAR04) + " ?")
	
	cQuery := "SELECT * FROM SR6010 WHERE "
	cQuery += "R6_HRNORMA = " + cValtoChar(MV_PAR01) + " AND "
	cQuery += "R6_HRDESC = " + cValtoChar(MV_PAR02) + " AND "
	cQuery += "D_E_L_E_T_ <> '*' "
	
	TcQuery cQuery New Alias "TMP"
	
	Count to nCount
	
	DbSelectArea("TMP")
	DbCloseArea("TMP")
	
	If nCount > 0  // Se existir dados, executa o update
		
		
		//Altera Horario dos turnos
		cUpd := "UPDATE SR6010 SET "
		cUpd += "R6_HRNORMA = " + cValtoChar(MV_PAR03) + " ,R6_HRDESC = " + cValtoChar(MV_PAR04) + " WHERE "
		cUpd += "R6_HRNORMA = " + cValtoChar(MV_PAR01) + " AND "
		cUpd += "R6_HRDESC =  " + cValtoChar(MV_PAR02) + " AND "
		cUpd += "D_E_L_E_T_ <> '*' "
		
		If TcSqlExec(cUpd) < 0
			MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE1!!!")
			Return
		EndIf
		
		MsgInfo("" + cValToChar(nCount) + " registro(s) foram processado(s) com sucesso!! ","Processamento....")
		
		
	ELSE
		
		Alert("Nenhum Registro Encontrado!!!")
		
	EndIf
	
EndIf

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","De H. Normais?	","","","mv_ch01","N",06,02,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","De H. Descanso?	","","","mv_ch02","N",06,02,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Para H. Normais ?","","","mv_ch03","N",06,02,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Para H. Descanso ?","","","mv_ch04","N",06,02,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})



For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)
Return





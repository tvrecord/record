#include "rwmake.ch"
#include "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesquisaDeบAutor  ณBruno Alves	     บ Data ณ  28/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta Motivo dos funcionarios Demitidos				  บฑฑ
ฑฑบ          ณ 												              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ APx                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function PesquisaDe
SetPrvt("cMat, CQUERY, CQUERY2")

cMat := Space(6)

@ 01,01  TO 080,270 Dialog oConsulta Title "Consulta Demissใo Funcionario"
@ 02,02  TO 20,133
@ 06,04  Say OemToAnsi("Digite a Matricula do Funcionario:")
@ 05,085 Get cMat F3 "SRA"  Picture "@!"
@ 25,077 BmpButton Type 1 Action Pesquisa(cMat)
@ 25,107 BmpButton Type 2 Action Close(oConsulta)
Activate Dialog oConsulta Centered

cMat := ""

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPESQUISA  บAutor  ณJulio Cesar Nobre   บ Data ณ  25/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pesquisa Geral por parte de nomes de Clientes              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ APx                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pesquisa(cMat)
Local aCampos := {}
Local aStru := {}
Local nRecnos := 0
Close(oConsulta)

AADD(aStru,{"FILIAL"	,"C",2,0})
AADD(aStru,{"MATRICULA"	,"C",6,0})
AADD(aStru,{"NOME"		,"C",40,0})
AADD(aStru,{"MOTIVO1"	,"C",40,0})
AADD(aStru,{"MOTIVO2"	,"C",40,0})
AADD(aStru,{"MOTIVO3"	,"C",40,0})


If (Select("TMPDem") <> 0)
	dbSelectArea("TMPDem")
	dbCloseArea("TMPDem")
Endif

cArqTmp := CriaTrab(aStru,.t.)
dbUseArea(.T.,__LocalDriver, cArqTmp, "TMPDem", nil, .f.)

//Alert("Nome ou parte pesquisada " +cMat)

cQuery := "SELECT RG_FILIAL ,RG_MAT ,RG_MOT1 ,RG_MOT2 ,RG_MOT3 FROM SRG010 WHERE D_E_L_E_T_<> '*' AND RG_MAT = '" + (cMat) + "' AND RG_DEM1 <> '' "

If (Select("xSRG") <> 0)
	dbSelectArea("xSRG")
	dbCloseArea("xSRG")
Endif

tcQuery cQuery New Alias "xSRG"

dbSelectArea("xSRG")
dbGoTop()

DBSelectArea("SRA")
DBSetOrder(1)
DBSeek(xFilial("SRA") + cMat)
If !Found()
	MsgBox ("Funcionario nใo cadastrado!","Informaใo","INFO")
	dbCloseArea("SRA")
	Return
Endif

dbSelectArea("xSRG")
dbGoTop()

If eof()
	MsgBox ("Favor, realizar a Recisใo do funcionแrio!","Informaใo","INFO")
	Return
Endif

While !eof()
	
	DBSelectArea("SRA")
	DBSetOrder(1)
	DBGotop()
	DBSeek(xFilial("SRA") + cMat)
	
	RecLock("TMPDem",.T.)
	TMPDem->FILIAL		:= xSRG->RG_FILIAL
	TMPDem->MATRICULA	:= xSRG->RG_MAT
	TMPDem->NOME		:= SRA->RA_NOME
	TMPDem->MOTIVO1		:= xSRG->RG_MOT1
	TMPDem->MOTIVO2	    := xSRG->RG_MOT2
	TMPDem->MOTIVO3		:= xSRG->RG_MOT3
	MsUnLock()
	nRecnos := nRecnos + 1
	dbSelectArea("xSRG")
	dbSkip()
End

dbSelectArea("TMPDem")
dbGoTop()

AADD(aCampos,{"FILIAL"		,"Filial","@!"})
AADD(aCampos,{"MATRICULA"	,"Matricula","@!"})
AADD(aCampos,{"NOME"		,"Nome","@!"})
AADD(aCampos,{"MOTIVO1"		,"Motivo 1","@!"})
AADD(aCampos,{"MOTIVO2"		,"Motivo 2","@!"})
AADD(aCampos,{"MOTIVO3"		,"Motivo 3","@!"})



@ 200,1 TO 450,810 DIALOG oTela TITLE "Consulta Geral de Funcionario Demitido"
@ 6,5 TO 90,400 BROWSE "TMPDem" FIELDS aCampos
@ 100,010 Say OemToAnsi("TV Capital")
@ 110,010 Say OemToAnsi("Registros Encontrados : ") + Str(nRecnos,6)
@ 100,340 BUTTON "_Ok" SIZE 40,15 ACTION Close(oTela)
ACTIVATE DIALOG oTela CENTERED
dbCloseArea("TMPDem")

Return

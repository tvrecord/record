#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXZA0     บAutor  ณRafael Fran็a        บ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRAteio de centro de custo por nota de entrada               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AXZA0

Private cCadastro := "Rateio C Custo NF"
Private nOpca := 0
Private aParam := {}

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5},;
{"Importa Rateio","U_IMPRAT",0,3}}

Private cString := "ZA0"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncTecnicoบAutor  ณRafael Fran็a       บ Data ณ  23/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIncluir dados de um xls no sistema.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPRAT()

Local cArq    := ""
Local cLinha  := ""
Local nNum	  := 0
Local cCusto  := ""
Local cRP	  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local cQuery  := ""
Local cCusto  := ""
Local cDescri := ""

Private aErro := {}
Private cPerg := "IMPRAT01"

ValidPerg()
Pergunte(cPerg,.T.)

cArq := MV_PAR03

If !MsgYesNo("Processa arquivo: " + alltrim(cArq) + " e substitui dados anteriores?")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + alltrim(cArq) + " nใo foi encontrado. A importa็ใo serแ abortada!","ATENCAO")
	Return
EndIf

IF MsgYesNo("O sistema irแ apagar os lan็amentos anteriores antes de executar o programa. Deseja continuar?","Aten็ใo")
	
	cQuery := "DELETE FROM	" + RetSqlName("ZA0") + ""
	
	If TcSqlExec(cQuery) < 0
		MsgStop("Ocorreu um erro na exclusใo da tabela ZA0!")
		Final()
		REturn
	EndIf
	
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo de rateio...")
	
	cLinha := FT_FREADLN()
	
	AADD(aDados,Separa(cLinha,";",.T.))
	
	FT_FSKIP()
EndDo

Begin Transaction
ProcRegua(Len(aDados))
For i:=1 to Len(aDados)
	
	IncProc("Processando ZA0")
	
	dbSelectArea("ZA0")
	dbSetOrder(1)
	
	cQuery := "SELECT CTT_CUSTO,CTT_DESC01 FROM CTT010 "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND CTT_DESC01 LIKE '" + ALLTRIM(SUBSTR(aDados[i,1],1,9)) + "%' "
	cQuery += "AND CTT_CLASSE = '2' "
	cQuery += "AND CTT_BLOQ = '2' "
	cQuery += "AND CTT_NORMAL = '2' "
	
	If Select("TMP1") > 0
		TMP->(DbCloseArea())
	Endif
	
	TCQUERY cQuery NEW ALIAS "TMP1"
	
	dbSelectArea("TMP1")
	DBGotop()
	While !EOF()
		
		cCusto 	:= TMP1->CTT_CUSTO
		cDescri := TMP1->CTT_DESC01
		
		dbskip()
		
	EndDo
	
	IF cCusto == ""
		
		cCusto := "2019001"
		
	ENDIF
	
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	
	Reclock("ZA0",.T.)
	ZA0_FILIAL  := "01"
	ZA0_CCDESC  := UPPER(aDados[i,1])
	ZA0_RP		:= UPPER(aDados[i,3])
	ZA0_NOMCLI	:= UPPER(aDados[i,6])
	ZA0_NF	  	:= UPPER(aDados[i,2])
	ZA0_CCUSTO  := cCusto
	ZA0_VLRBRU	:= VAL(StrTran(StrTran(StrTran(StrTran(aDados[i,8],"(","",1,),")","",1,),".","",1,),",",".",1,))
	ZA0_VLRLIQ	:= VAL(StrTran(StrTran(StrTran(StrTran(aDados[i,9],"(","",1,),")","",1,),".","",1,),",",".",1,))
	ZA0_VLRFAT	:= VAL(StrTran(StrTran(StrTran(StrTran(aDados[i,10],"(","",1,),")","",1,),".","",1,),",",".",1,))
	ZA0->(MsUnlock())
	
Next i

IF 	nNum == 0
	
	ApMsgInfo("Cadastro dos rateios realizado com Sucesso!","SUCESSO")
	
ELSE
	
	ApMsgInfo("Foram localizados "+STRZERO(nNum,3)+" duplicados!","ATENวรO")
	
ENDIF

End Transaction

FT_FUSE()

Return

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Mes:			","","","mv_ch1","C",02,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ano:			","","","mv_ch2","C",04,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Arquivo:        ","","","mv_ch3","C",30,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
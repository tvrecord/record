#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

User Function TelaSol

Private cPerg	     := "TelaSol"

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

Processa({|| IncluiPro()},"Incluindo Produto no Array")

Return

Static Function IncluiPro()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncluiProºAutor  ³Bruno Alves         º Data ³  06/05/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Incluir dados de um txt no array.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local cArq    := "C:\SOLICITACAO\COMPRAS.CSV"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local _cUpd	  := ""

Private aErro := {}
Private aProd := {}

If !MsgYesNo("Processa arquivo: " + cArq + "?")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

Begin Transaction
ProcRegua(Len(aDados))

For i:=1 to Len(aDados)
	
	IncProc("Incluindo Produtos no Array")
	
	aAdd(aProd,{	aDados[i][1],;     //01.Codigo do Produto
	aDados[i][3]})		//02 Quantidade
	
	
Next i
End Transaction

FT_FUSE()

Processa({|| MyMata110()},"Gerando Solicitação")

//ApMsgInfo("Alteração CT2010 feito com Sucesso!","SUCESSO")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MYMATA110 ºAutor  ³Bruno Alves         º Data ³  05/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criado para criar solicitação atraves de uma importacao   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


static Function MyMata110()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.

Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM" TABLES "SC1","SB1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificacao do ambiente para teste                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


For I := 1 to LEN(aProd)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If !SB1->(MsSeek(xFilial("SB1") + aProd[I][1]))
		lOk := .F.
		msginfo("Para concluir a execução será preciso cadastrar o produto: " + aProd[I][1])
	elseIf Posicione("CT1",1,xfilial("SB1")+SB1->B1_CONTA,"CT1_BLOQ") == "1"
		msginfo("Conta Contabil do Produto " + aProd[I][1] + " BLOQUEADA!! ")
		lOk := .F.
	EndIf
	
Next I

If EMPTY(MV_PAR01) .OR. EMPTY(MV_PAR02)
	Alert("É preciso preencher os parametros (Centro de Custo e Finalidade) para concluir o cadastramento!!!! ")
	lOk := .F.
EndIf



If lOk
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Verifica numero da SC       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cDoc := GetSXENum("SC1","C1_NUM")
	SC1->(dbSetOrder(1))
	ConfirmSX8()
	
	
	
	aadd(aCabec,{"C1_NUM"    ,cDoc})
	aadd(aCabec,{"C1_SOLICIT",AllTrim(Substring(cUsuario,7,15))})
	aadd(aCabec,{"C1_EMISSAO",dDataBase})
	
	
	
	
	For nx := 1 to Len(aProd)
		aadd(aLinha,{"C1_ITEM"   ,StrZero(nx,len(SC1->C1_ITEM)),Nil})
		aadd(aLinha,{"C1_PRODUTO",aProd[nx][1],Nil})
		aadd(aLinha,{"C1_QUANT"  ,VAL(aProd[nx][2])   ,Nil})
		aadd(aLinha,{"C1_CC",(MV_PAR01),Nil})
		aadd(aLinha,{"C1_FINALID",(MV_PAR02),Nil})
		aadd(aItens,aLinha)
		aLinha := {}
	Next nx
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	
	MSExecAuto({|x,y| mata110(x,y)},aCabec,aItens)
	
	If !lMsErroAuto
		
		msginfo("Incluido com sucesso! " + cDoc)
		
	Else
		
		alert("Erro na inclusao!")
		
	EndIf
	
	
	
EndIf

//RESET ENVIRONMENT

Return(.T.)

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","C. Custo   ?","","","mv_ch01","C",09,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"02","Finalidade ?","","","mv_ch02","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SZ6",""})



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

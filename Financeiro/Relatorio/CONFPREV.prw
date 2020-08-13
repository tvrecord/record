#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 CONFPREV  : Autor 3 Bruno Alves        : Data 3  07/05/2014 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Conferencia da Previsão                :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Conferir Notas e Titulos a Pagar a serem lançadas          :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function CONFPREV

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Conferencia Previsao"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "CONFPREV"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "CONFPREV"
Private cString    := "SRA"
Private N		   := 00001
Private cQuery   := ""
Private _aStrut := {}
Private lTit 	:= .T.
Private lSubTit := .T.
Private cTipo := ""
Private cNaturez := ""
Private cPrevisao := ""

ValidPerg(cPerg)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//EndIf
Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Funo    3RUNREPORT : Autor 3 AP6 IDE            : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descrio 3 Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS :11
11:          3 monta a janela com a regua de processamento.               :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQuery:=""
SetRegua(5000)
Pergunte(cPerg,.f.)


cQuery := "SELECT ZA6_CODIGO,ED_CODIGO,ED_DESCRIC,ZA6_FORNEC,A2_NOME,ZA6_VENCRE,ZA6_VALOR,ZA6_HIST,ED_PREVISA,ED_NATGER FROM ZA6010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "ZA6_NATURE = ED_CODIGO "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "ZA6_FORNEC = A2_COD AND "
cQuery += "ZA6_LOJA = A2_LOJA "
cQuery += "WHERE "
cQuery += "ZA6_CODIGO BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery += "ED_CODIGO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "'  AND "
cQuery += "ZA6_FORNEC BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "ZA6_VENCRE BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "'  AND "
cQuery += "ED_NATGER BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "ZA6_MES = '" + (MV_PAR01) + "' AND "
cQuery += "ZA6_ANO = '" + (MV_PAR02) + "' AND "
cQuery += "ZA6010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ED_PREVISA,ED_CODIGO,ZA6_FORNEC,ZA6_VENCRE "


If Select("PREV") > 0
	PREV->(DbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "PREV"

PREV->(DbGoTop())




// **************************** Cria Arquivo Temporario
_aStrut:={}//SRASQL->(DbStruct())
aadd( _aStrut , {"TIPO"      		, "C" , 010 , 00 } )
aadd( _aStrut , {"CODIGO"      		, "C" , 010 , 00 } )
aadd( _aStrut , {"NOMENAT" 			, "C" , 050 , 00 } )
aadd( _aStrut , {"FORNECEDOR"		, "C" , 010 , 00 } )
aadd( _aStrut , {"NOMEFOR"			, "C" , 050,  00 } )
aadd( _aStrut , {"VENCIMENTO"		, "D" , 013 , 00 } )
aadd( _aStrut , {"VALOR"	   		, "N" , 015 , 02 } )
aadd( _aStrut , {"HISTORICO"   	  	, "C" , 100 , 00 } )
aadd( _aStrut , {"NATGER"     		, "C" , 006 , 00 } )
aadd( _aStrut , {"NOMENTGER"		, "C" , 030 , 00 } )

_cTemp := CriaTrab(_aStrut, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)


DbSelectArea("PREV")
dbgOTOP()

While PREV->(!Eof())
	
	
	
	If lTit == .T.
	
		Reclock("TMP",.T.)
		MsUnlock()
		
		Reclock("TMP",.T.)
		TMP->TIPO	:=	IIF(PREV->ED_PREVISA == "1","VALOR","VENCIMENTO")
		MsUnlock()
		cTipo := IIF(PREV->ED_PREVISA == "1","VALOR","VENCIMENTO")
		
		Reclock("TMP",.T.)
		MsUnlock()
		
		lTit := .F.
		
	eNDiF
	
	


	Reclock("TMP",.T.)
	TMP->CODIGO			:=	PREV->ZA6_CODIGO
	TMP->NOMENAT		:=  PREV->ED_DESCRIC
	TMP->FORNECEDOR		:=	PREV->ZA6_FORNEC
	TMP->NOMEFOR		:=	PREV->A2_NOME
	TMP->VENCIMENTO		:=	STOD(PREV->ZA6_VENCRE)
	TMP->VALOR			:=	PREV->ZA6_VALOR
	TMP->HISTORICO		:=	FwNoAccent(UPPER(PREV->ZA6_HIST))
	TMP->NATGER			:=	PREV->ED_NATGER
	TMP->NOMENTGER		:=	Posicione("SX5",1,xFilial("SX5") + "ZV" + PREV->ED_NATGER,"X5_DESCRI")
	MsUnlock()
	
	
	cPrevisao := PREV->ED_PREVISA
	
	
	PREV->(DbSkip())
	
	If cPrevisao != PREV->ED_PREVISA
		lTit := .T.
	EndIf
	
	
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

cArq     := _cTemp+".DBF"

DbSelectArea("TMP")
TMP->(DbCloseArea())
DbSelectArea("PREV")
PREV->(DbCloseArea())

__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
oExcelApp:SetVisible(.T.)


Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3ValidPerg : Autor 3                    : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Cria/Valida Parametros do sistema                          :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Mes ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ano ?","","","mv_ch02","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Codigo  		  ?","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","ZA6"})
AADD(aRegs,{cPerg,"04","Ate Codigo 		  ?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","ZA6"})
AADD(aRegs,{cPerg,"05","Da Natureza  	  ?","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"06","Ate Natureza      ?","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"07","Do Vencimento 	  ?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Vencimento 	  ?","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Fornecedor 	  ?","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"10","Ate Fornecedor    ?","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"11","Do  Prefixo		?","","","mv_ch11","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Preifxo		?","","","mv_ch12","C",03,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Do Bloco  ?","","","mv_ch13","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
AADD(aRegs,{cPerg,"14","Ate Bloco ?","","","mv_ch14","C",06,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})



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

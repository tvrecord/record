#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    06/04/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ COMISSAO BV 					    	                        ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMISSBV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := ""
Private cPict          := ""
Private nLin           := 100

Private Cabec1         := ""
Private Cabec2         := ""
Private Cabec3         := ""
Private imprime        := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "COMISSBV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMISSBV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "COMISSBV8"
Private cString      := "ZAB"
Private cQuery       := ""
Private cfiltro      := ""
Private titulo       := "COMISSAO BV"
Private aTitulos 	 := {}
Private nVal1		:= 0
Private nVal2		:= 0
Private nVal3		:= 0
Private nVal4		:= 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando Relatório")

Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Relatorio()

cQuery := "SELECT * FROM ZAB010 "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZAB_BAIXA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "

tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// **************************** Cria Arquivo Temporario
_aStru1:={}//SPCSQL->(DbStruct())
aadd( _aStru1 , {"NF"      			, "C" , 020,00 })
aadd( _aStru1 , {"EMPRESA"			, "C" , 030,00 })
aadd( _aStru1 , {"EMISSAO"		    , "D" , 010,00 })
aadd( _aStru1 , {"BAIXA"		    , "D" , 010,00 })
aadd( _aStru1 , {"VALOR"			, "N" , 014,02 })
aadd( _aStru1 , {"LOCAL"			, "N" , 014,02 })
aadd( _aStru1 , {"SPOT"				, "N" , 014,02 })

_cTemp := CriaTrab(_aStru1, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())
	
	aAdd(aTitulos,{TMP->ZAB_TITULO,;
	TMP->ZAB_NOME,;
	STOD(TMP->ZAB_EMISSA),;
	STOD(TMP->ZAB_BAIXA),;
	TMP->ZAB_VALOR,;
	TMP->ZAB_LOCAL,;
	TMP->ZAB_SPOT,;
	TMP->ZAB_VLSE2,;
	TMP->ZAB_FORNEC,;
	TMP->ZAB_NATURE})
	
	nVal1   += TMP->ZAB_VALOR
	nVal2	+= TMP->ZAB_LOCAL
	nVal3	+= TMP->ZAB_SPOT 
		IF ALLTRIM(TMP->ZAB_FORNEC) == "000970" .OR. ALLTRIM(TMP->ZAB_FORNEC) == "005082" .OR. ALLTRIM(TMP->ZAB_FORNEC) == "005191"
		nVal4	+= TMP->ZAB_VLSE2
		ENDIF
	
	DBSelectArea("TMP")
	DBSkip()
	
Enddo

ASORT(aTitulos,,,{|x,y|x[2] < y[2]})

For i:=1 to Len(aTitulos)
	
	IF aTitulos[i][5] <> 0
		
		Reclock("TMP1",.T.)
		TMP1->NF		:= aTitulos[i][1]
		TMP1->EMPRESA	:= aTitulos[i][2]
		TMP1->EMISSAO	:= aTitulos[i][3]
		TMP1->BAIXA		:= aTitulos[i][4]
		TMP1->VALOR		:= aTitulos[i][5]
		TMP1->LOCAL		:= aTitulos[i][6]
		TMP1->SPOT		:= aTitulos[i][7]
		MsUnlock()
		
	ENDIF
	
Next

Reclock("TMP1",.T.)
TMP1->NF		:= "SUBTOTAL"
TMP1->VALOR		:= nVal1
TMP1->LOCAL		:= nVal2
TMP1->SPOT		:= nVal3
MsUnlock()

Reclock("TMP1",.T.)
TMP1->LOCAL		:= 100
TMP1->SPOT		:= 30
MsUnlock()

Reclock("TMP1",.T.)
TMP1->LOCAL		:= nVal2
TMP1->SPOT		:= (nVal3 * 0.3)
MsUnlock()    

Reclock("TMP1",.T.)
MsUnlock()    

Reclock("TMP1",.T.) 
TMP1->EMPRESA	:= "MERCHANDISING/CACHE"
MsUnlock()

ASORT(aTitulos,,,{|x,y|x[2] < y[2]})

For i:=1 to Len(aTitulos)
	
	IF ALLTRIM(aTitulos[i][9]) == "000970" .OR. ALLTRIM(aTitulos[i][9]) == "005082" .OR. ALLTRIM(aTitulos[i][9]) == "005191"
		
		Reclock("TMP1",.T.)
		TMP1->NF		:= aTitulos[i][1]
		TMP1->EMPRESA	:= aTitulos[i][2]
		TMP1->EMISSAO	:= aTitulos[i][3]
		TMP1->BAIXA		:= aTitulos[i][4]
		TMP1->VALOR		:= aTitulos[i][8]
		MsUnlock()
		
	ENDIF
	
Next                  

Reclock("TMP1",.T.)
TMP1->NF		:= "SUBTOTAL"
TMP1->VALOR		:= nVal4
MsUnlock()

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	DBSelectArea("TMP1")
	DBCloseARea("TMP1")
	DBSelectArea("TMP")
	DBCloseARea("TMP")
	Return
EndIf

cArq     := _cTemp+".DBF"

DBSelectArea("TMP1")
DBCloseARea("TMP1")
DBSelectArea("TMP")
DBCloseARea("TMP")

__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
oExcelApp:SetVisible(.T.)


Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Da Baixa 		  	","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Baixa 	  	","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
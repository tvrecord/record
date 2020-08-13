#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOSIMOB บ Autor ณ Bruno Alves       บ Data ณ    15/05/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Planilha para informar quais produtos estใo no estoque ฑ
ฑฑ          ฑฑ e sใo imobilizados   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function POSIMOB()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
Private nomeprog     := "POSIMOB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "POSIMOB1" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "POSIMOB1"
Private cString      := "SD1"
Private cQuery       := ""
Private titulo       := "Posi็ใo de Estoque - IMOBILIZADO"
Private nQuant       := 0
Private nCusto       := 0
Private aSaldos		 := {}
Private _aIExcel 	 := {}


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando Relat๓rio")

Return

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEntrada dos ultimos 3 meses via Nota Fiscalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

//1บ Entrada

Static Function Relatorio()

cQuery := "SELECT D1_COD,B1_DESC,D1_TES,D1_QUANT,B1_LOCPAD,B2_QATU,D1_DOC,D1_EMISSAO,D1_VUNIT,D1_TOTAL,B2_VFIM1 FROM SD1010 "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "D1_TES = F4_CODIGO "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "D1_COD = B1_COD "
cQuery += "INNER JOIN SB2010 ON "
cQuery += "B2_COD = D1_COD AND "
cQuery += "B1_LOCPAD = D1_LOCAL "
cQuery += "WHERE "
cQuery += "D1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "'  AND "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "'  AND "
cQuery += "F4_ESTOQUE = 'S' AND "
IF MV_PAR10 == 1
	cQuery += "F4_ATUATF <> 'S' AND "
ELSE
	cQuery += "F4_ATUATF = 'S' AND "
ENDIF
//cQuery += "B2_QATU > 0 AND "
cQuery += "SB2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SF4010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY D1_COD,D1_EMISSAO "

tcQuery cQuery New Alias "TMP"

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },titulo)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cProduto := ""

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

// **************************** Cria Arquivo Temporario
_aCExcel:={}//SPCSQL->(DbStruct())
aadd( _aCExcel , {"CODIGO"      	, "C" , 10 , 00 } ) //01
aadd( _aCExcel , {"DESC	"			, "C" , 50 , 00 } ) //02
aadd( _aCExcel , {"LOCAL	"		, "C" , 10 , 00 } ) //03
IF MV_PAR09 == 1
	aadd( _aCExcel , {"SALDO"		, "C" , 10 , 00 } ) //04
	aadd( _aCExcel , {"CUSTO"     	, "C" , 20 , 00 } ) //05
	aadd( _aCExcel , {"QUANTIDADE"	, "C" , 10 , 00 } ) //06
	aadd( _aCExcel , {"VLUNIT"	    , "C" , 20 , 00 } ) //07
	aadd( _aCExcel , {"VLTOTAL"	    , "C" , 20 , 00 } ) //08
ELSE
	aadd( _aCExcel , {"SALDO"		, "N" , 10 , 00 } ) //09
	aadd( _aCExcel , {"CUSTO"     	, "N" , 14 , 02 } ) //10
ENDIF

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

IF MV_PAR09 == 1
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[2]			:= "DOCUMENTO"
	_aItem[3]			:= "TES"
	_aItem[4]			:= "EMISSAO"
	_aItem[5]			:= "CUSTO"
	_aItem[6]			:= "QUANTIDADE"
	_aItem[7] 	   		:= "VALOR UNITARIO"
	_aItem[8]		:= "VALOR TOTAL"
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
ENDIF

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())
	
	IF MV_PAR09 == 1
		
		IF (ALLTRIM(TMP->D1_COD) == "0350072" .OR. ALLTRIM(TMP->D1_COD) == "0400007" .OR. ALLTRIM(TMP->D1_COD) == "0400008" .OR. ALLTRIM(TMP->D1_COD) == "0400013") .AND. MV_PAR10 == 2 
			DBSelectArea("TMP")
			Dbskip()
			loop
		EndIf
		
		aSaldos:=CalcEst(PADL(TMP->D1_COD,15),TMP->B1_LOCPAD,MV_PAR07 + 1)
		nQuant := aSaldos[1]
		nCusto := aSaldos[2]
		
		If MV_PAR08 == 2
			If nQuant == 0
				DBSelectArea("TMP")
				Dbskip()
				loop
			EndIf
		EndIf
				
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]		:= TMP->D1_COD
		_aItem[2]			:= TMP->B1_DESC
		_aItem[3]			:= TMP->B1_LOCPAD
		_aItem[4] 		:= cValToChar(nQuant)
		_aItem[5]			:= cValToChar(nCusto)
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[2] 			:= TMP->D1_DOC
		_aItem[3]			:= TMP->D1_TES
		_aItem[4] 		:= DTOC(STOD(TMP->D1_EMISSAO))
		_aItem[6]	:= cValToChar(TMP->D1_QUANT)
		_aItem[7]		:= cValToChar(TMP->D1_VUNIT)
		_aItem[8]		:= cValToChar(TMP->D1_TOTAL)
		
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
		cProduto := TMP->D1_COD
		
		DBSelectArea("TMP")
		DBSkip()
		
		If cProduto == TMP->D1_COD
			While cProduto == TMP->D1_COD
				
	_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[2] 			:= TMP->D1_DOC
				_aItem[3]			:= TMP->D1_TES
				_aItem[4] 			:= DTOC(STOD(TMP->D1_EMISSAO))
				_aItem[6]			:= cValToChar(TMP->D1_QUANT)
				_aItem[7]			:= cValToChar(TMP->D1_VUNIT)
				_aItem[8]			:= cValToChar(TMP->D1_TOTAL)
				
	AADD(_aIExcel,_aItem)
	_aItem := {}
				DBSelectArea("TMP")
				DBSkip()
				
			Enddo
		EndIf
		
		//Pular Linha
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
	ELSE   
		
		IF (ALLTRIM(TMP->D1_COD) == "0350072" .OR. ALLTRIM(TMP->D1_COD) == "0400007" .OR. ALLTRIM(TMP->D1_COD) == "0400008" .OR. ALLTRIM(TMP->D1_COD) == "0400013") .AND. MV_PAR10 == 2 
			DBSelectArea("TMP")
			Dbskip()
			loop
		EndIf	
		
		IF cProduto <> TMP->D1_COD
			
			aSaldos:=CalcEst(PADL(TMP->D1_COD,15),TMP->B1_LOCPAD,MV_PAR07 + 1)
			nQuant := aSaldos[1]
			nCusto := aSaldos[2]
			
			If MV_PAR08 == 2
				If nQuant == 0
					DBSelectArea("TMP")
					Dbskip()
					loop
				EndIf
			EndIf
			
	_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]			:= TMP->D1_COD
			_aItem[2]			:= TMP->B1_DESC
			_aItem[3]			:= TMP->B1_LOCPAD
			_aItem[4]	 		:= nQuant
			_aItem[5]			:= nCusto
	AADD(_aIExcel,_aItem)
	_aItem := {}
			
			cProduto := TMP->D1_COD
			
			DBSelectArea("TMP")
			DBSkip()
			
		ELSE
		
			DBSelectArea("TMP")
			DBSkip() 
		ENDIF
		
	ENDIF
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

//DBSelectArea("TMP1")
//DBCloseARea("TMP1")
DBSelectArea("TMP")
DBCloseARea("TMP")

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Posicao de estoque - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","POSIMOB")
	_lRet := .F.
ENDIF

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Da  Data 			","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Data 	   		","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Produto  		","","","mv_ch03","C",15,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"04","Ate Produto 		","","","mv_ch04","C",15,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AADD(aRegs,{cPerg,"05","Armazem  			","","","mv_ch05","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Armazem  			","","","mv_ch06","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Dt Referencia		","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Listar Saldo Zero	","","","mv_ch08","N",01,0,2,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Tipo Relatorio		","","","mv_ch09","N",01,0,2,"C","","mv_par09","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Estoque / Imobilizado","","","mv_ch10","N",01,0,2,"C","","mv_par10","Estoque","","","","","Imobilizado","","","","","","","","","","","","","","","","","","","","","","",""})

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
#Include "RwMake.ch"
#Include "topconn.ch"

/*/
Rafael França,20/04/17,HORASSPI,Solicitantes: Giselly e Judson, Relatorio com o objetivo de mostrar os atrasos e horas extras dos funcionarios por centro de custo
/*/

User Function HORASSPI

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Atrasos e Horas Extras por C. Custo"
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
Private nomeprog   := "HORASSPI"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "HORASSPI"
Private cString    := "SPI"
Private N		   := 00001
Private cQuery     := ""
Private _aStruSRA  := {}
Private _aIExcel 	 := {}

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
Local cQuery		:= ""
Local cCcusto 		:= ""
Local cDescricao	:= ""
Local cMatricula	:= ""
Local cNome			:= ""
Local nQTDHE		:= 0
Local nHRSHE		:= 0
Local nQTDATR		:= 0
Local nHRSATR		:= 0
Local nCCQTDHE		:= 0
Local nCCHRSHE		:= 0
Local nCCQTDATR		:= 0
Local nCCHRSATR		:= 0
Local nTOTQTDHE		:= 0
Local nTOTHRSHE		:= 0
Local nTOTQTDATR	:= 0
Local nTOTHRSATR	:= 0
Local cData			:= ""
Local lOk			:= .T.
Local lOk1			:= .F.
//SetRegua(5000)
Pergunte(cPerg,.f.)

cQuery := "SELECT PI_CC AS CCUSTO,CTT_DESC01 AS DESCRICAO,PI_MAT AS MATRICULA,RA_NOME AS NOME,PI_DATA AS DATA1,PI_PD AS TIPO,PI_QUANT AS QTD "
cQuery += "FROM SPI010 "
cQuery += "INNER JOIN SRA010 ON PI_FILIAL = RA_FILIAL AND PI_MAT = RA_MAT "
cQuery += "INNER JOIN CTT010 ON PI_CC = CTT_CUSTO "
cQuery += "WHERE SPI010.D_E_L_E_T_ = '' AND SRA010.D_E_L_E_T_ = '' AND CTT010.D_E_L_E_T_ = '' "
cQuery += "AND PI_CC BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "  
cQuery += "AND PI_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' "
cQuery += "AND PI_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' " 
//19/05/17 - Rafael França - Função coloca a pedido da Sra. Giselly para remover abonos do tipo '014'
cQuery += "AND PI_DATA NOT IN (SELECT PC_DATA FROM SPC010 WHERE SPC010.D_E_L_E_T_ = '' AND PC_MAT = PI_MAT AND PC_ABONO = '014' AND PC_DATA = PI_DATA GROUP BY PC_DATA) "
IF MV_PAR07 == 2 // 11/05/17 - Rafael França - Colocado a pedido da Giselly RH para retirar feriados do relatorio de horas extras.
cQuery += "AND PI_DATA NOT IN (SELECT P3_DATA FROM SP3010 WHERE D_E_L_E_T_ = '' GROUP BY P3_DATA) "   
ENDIF
cQuery += "ORDER BY PI_CC,RA_NOME,PI_DATA "

If Select("TMPSPI") > 0
	TMPSPI->(DbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMPSPI"

TMPSPI->(DbGoTop())

// **************************** Cria Arquivo Temporario
_aCExcel:={}//TMP->(DbStruct()) //_aCExcel
aadd( _aCExcel , {"MATRICULA"	   		, "C" , 12 , 00 } ) //01
aadd( _aCExcel , {"NOME"	     		, "C" , 35 , 00 } ) //02
aadd( _aCExcel , {"QTDHE"   	  		, "N" , 10 , 00 } ) //03
aadd( _aCExcel , {"HRSHE"   	  		, "C" , 10 , 00 } ) //04
aadd( _aCExcel , {"QTDATR"  			, "N" , 10 , 00 } ) //05
aadd( _aCExcel , {"HRSATR"		   	  	, "C" , 10 , 00 } ) //06

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DbSelectArea("TMPSPI")
Do While TMPSPI->(!Eof())
	
	IF lOk
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]		:= TMPSPI->CCUSTO
		_aItem[2]			:= TMPSPI->DESCRICAO
	AADD(_aIExcel,_aItem)
	_aItem := {}
	ENDIF
		
	IF TMPSPI->TIPO <= "399"
		nHRSHE			:= SomaHoras(nHRSHE,TMPSPI->QTD)
		nCCHRSHE		:= SomaHoras(nCCHRSHE,TMPSPI->QTD)
		nTOTHRSHE		:= SomaHoras(nTOTHRSHE,TMPSPI->QTD)
		IF TMPSPI->DATA1 <> cData .OR. cMatricula <> TMPSPI->MATRICULA
			nQTDHE			+= 1
			nCCQTDHE		+= 1
			nTOTQTDHE		+= 1
		ENDIF
	ELSE
		nHRSATR			:= SomaHoras(nHRSATR,TMPSPI->QTD)
		nCCHRSATR		:= SomaHoras(nCCHRSATR,TMPSPI->QTD)
		nTOTHRSATR		:= SomaHoras(nTOTHRSATR,TMPSPI->QTD)
		IF TMPSPI->DATA1 <> cData .OR. cMatricula <> TMPSPI->MATRICULA
			nQTDATR			+= 1
			nCCQTDATR		+= 1
			nTOTQTDATR		+= 1
		ENDIF
	ENDIF   
	
	cCCusto 		:= TMPSPI->CCUSTO
	cDescricao		:= TMPSPI->DESCRICAO
	cMatricula		:= TMPSPI->MATRICULA
	cNome			:= TMPSPI->NOME  
	cData			:= TMPSPI->DATA1 
	lOk1            := .T.	
	lOk				:= .F.	
	
	TMPSPI->(DbSkip())   
	
	IF cMatricula <> TMPSPI->MATRICULA .AND. lOk1
		
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]		:= cMatricula
		_aItem[2]			:= cNome
		_aItem[3]			:= nQTDHE
		_aItem[4]			:= strtran(strzero(nHRSHE,5,2), '.', ':' )
		_aItem[5]		:= nQTDATR
		_aItem[6]		:= strtran(strzero(nHRSATR,5,2), '.', ':' )    
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
		nHRSHE			:= 0
		nQTDHE			:= 0
		nHRSATR			:= 0
		nQTDATR			:= 0
		
	ENDIF
	
	IF cCCusto <> TMPSPI->CCUSTO
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]		:= cCCusto
		_aItem[2]			:= cDescricao
		_aItem[3]			:= nCCQTDHE
		_aItem[4]			:= strtran(strzero(nCCHRSHE,6,2), '.', ':' )  
		_aItem[5]		:= nCCQTDATR
		_aItem[6]		:= strtran(strzero(nCCHRSATR,6,2), '.', ':' )  
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
		nCCHRSHE			:= 0
		nCCQTDHE			:= 0
		nCCHRSATR			:= 0
		nCCQTDATR			:= 0
		lOk					:= .T.
	ENDIF
	
Enddo 

	_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]		:= "TOTAL"
		_aItem[2]			:= ""
		_aItem[3]			:= nTOTQTDHE
		_aItem[4]			:= strtran(strzero(nTOTHRSHE,6,2), '.', ':' )  
		_aItem[5]		:= nTOTQTDATR
		_aItem[6]		:= strtran(strzero(nTOTHRSATR,6,2), '.', ':' )  
	AADD(_aIExcel,_aItem)
	_aItem := {}

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

DbSelectArea("TMPSPI")
TMPSPI->(DbCloseArea())
//DbSelectArea("TMP1")
//TMP1->(DbCloseArea())

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)     

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Controle de registros profissionais - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","HORASSPI")
	_lRet := .F.
ENDIF

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

AADD(aRegs,{cPerg,"01","Do  C. Custo: ","","","mv_ch01","C",07,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"02","Ate C. Custo: ","","","mv_ch02","C",07,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"03","Da  Matricula:","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Ate Matricula:","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"05","Da  Data:	  ","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Data:	  ","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Feriados:     ","","","mv_ch07","N",01,0,2,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})

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
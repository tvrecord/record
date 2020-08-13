#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROVCC  บ Autor ณ Bruno Alves       บ Data ณ    05/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Soma dos proventos por centro de custo 						 ฑ
ฑฑ          ฑฑ 	                     									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PROVCC()
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
	Private nomeprog     := "PROVCC" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "PROVCC" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "PROVCC1"
	Private cString      := "SRD"
	Private cQuery       := ""
	Private titulo       := "Soma dos Proventos x Centro de Custo"
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

Static Function Relatorio()

	cQuery := "SELECT RD_CC,CTT_DESC01,RD_DATARQ,SUM(RD_VALOR) AS VALOR FROM SRD010 "
	cQuery += "INNER JOIN SRV010 ON "
	cQuery += "RD_PD = RV_COD "
	cQuery += "INNER JOIN CTT010 ON "
	cQuery += "RD_FILIAL = CTT_FILIAL AND "
	cQuery += "RD_CC = CTT_CUSTO "
	cQuery += "WHERE "
	cQuery += "RD_DATARQ BETWEEN '" + SUBSTR(DTOS(MV_PAR01),1,6) + "' AND '" + SUBSTR(DTOS(MV_PAR02),1,6) + "' AND "
	cQuery += "RD_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
	cQuery += "RD_FILIAL BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	cQuery += "RD_CC BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
	cQuery += "RV_TIPOCOD = '1' AND "
	cQuery += "SRD010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SRV010.D_E_L_E_T_ <> '*' AND "
	cQuery += "CTT010.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY RD_CC,RD_DATARQ,CTT_DESC01 "

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

	
//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


// **************************** Cria Arquivo Temporario
	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"CCUSTO"      	, "C" , 10 , 00 } )
	aadd( _aCExcel , {"DESC	"		, "C" , 50 , 00 } )
	aadd( _aCExcel , {"PERIODO"		, "C" , 10 , 00 } )
	aadd( _aCExcel , {"VALOR"		, "N" , 10 , 02 } )

//	_cTemp := CriaTrab(_aCExcel, .T.)
//	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

	DBSelectArea("TMP")
	DBGotop()

	While !TMP->(EOF())
	
	
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= TMP->RD_CC
		_aItem[02]		:= TMP->CTT_DESC01
		_aItem[03]		:= SUBSTR(TMP->RD_DATARQ,5,2) + "/" + SUBSTR(TMP->RD_DATARQ,1,4)
		_aItem[04]		:= TMP->VALOR
		AADD(_aIExcel,_aItem)
		_aItem := {}
	
		DBSelectArea("TMP")
		DBSkip()
				
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
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Proventos por C. Custo - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","PROVCC")
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
	AADD(aRegs,{cPerg,"01","Da  Data 	  ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Ate Data 	  ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Da Matricula  ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"04","Ate Matricula ?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"05","Da Filial  	  ?","","","mv_ch05","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"06","Ate Filial    ?","","","mv_ch06","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"07","Do C. Custo   ?","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"08","Ate C. Custo  ?","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})

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
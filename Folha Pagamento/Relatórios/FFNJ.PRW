#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFFNJ  บ Autor ณ Bruno Alves       บ Data ณ    05/11/2013    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Folgas e faltas justificadas e nใo justificadas  		   ฑ
ฑฑ          ฑฑ 	                     									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FFNJ()

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
Private nomeprog     := "FFNJ" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FFNJ" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "FFNJ1"
Private cString      := "SRD"
Private cQuery       := ""
Private titulo       := "Folgas e Faltas Nใo Justificadas"
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

If MV_PAR07 == 2
	
	cQuery := "SELECT RA_MAT,RA_NOME,PI_DATA,PI_PD,PH_QUANTC FROM SPI010 "
	cQuery += "INNER JOIN SRA010 ON "
	cQuery += "RA_FILIAL = PI_FILIAL AND "
	cQuery += "RA_MAT = PI_MAT "
	cQuery += "INNER JOIN SPH010 ON "
	cQuery += "PI_FILIAL = PH_FILIAL AND "
	cQuery += "PI_MAT = PH_MAT AND "
	cQuery += "PH_DATA = PI_DATA AND "
	cQuery += "PH_PD = PI_PD "
	cQuery += "WHERE "
	cQuery += "PI_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
	cQuery += "RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
	cQuery += "PI_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuery += "PI_PD IN ('409','498') AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPI010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPH010.D_E_L_E_T_ <> '*' AND "
	cQuery += "RA_REGRA <> '07' AND "
	cQuery += "PH_ABONO <> '015' AND "
	cQuery += "PH_QTABONO = 0 "
	cQuery += "GROUP BY RA_MAT,RA_NOME,PI_DATA,PI_PD,PH_QUANTC,PH_ABONO,PH_QTABONO "
	cQuery += "ORDER BY RA_MAT,PI_DATA "
	
Else
	
	cQuery := "SELECT RA_MAT,RA_NOME,PH_DATA,PH_PD,PH_QUANTC,PH_ABONO,P6_DESC,PH_QTABONO FROM SPH010 "
	cQuery += "INNER JOIN SRA010 ON "
	cQuery += "RA_FILIAL = PH_FILIAL AND "
	cQuery += "RA_MAT = PH_MAT "
	cQuery += "INNER JOIN SP6010 ON "
	cQuery += "P6_CODIGO = PH_ABONO "
	cQuery += "WHERE "
	cQuery += "PH_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
	cQuery += "RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
	cQuery += "PH_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND "
	cQuery += "PH_PD IN ('409','498') AND "
	cQuery += "PH_QTABONO > 0 AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPH010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SP6010.D_E_L_E_T_ <> '*' AND "
	cQuery += "PH_ABONO <> '015' AND "
	cQuery += "RA_REGRA <> '07' AND "
	cQuery += "PH_FILIAL = '01' "
	cQuery += "ORDER BY PH_MAT,PH_DATA "
	
EndIf

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

If MV_PAR07 == 2
	
	// **************************** Cria Arquivo Temporario
	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"MAT"		    , "C" , 10 , 00 } ) //01
	aadd( _aCExcel , {"NOME	"		, "C" , 50 , 00 } ) //02
	aadd( _aCExcel , {"DAT"			, "C" , 10 , 00 } ) //03
	aadd( _aCExcel , {"EVENTO"		, "C" , 06 , 00 } ) //04
	aadd( _aCExcel , {"HORAS"		, "C" , 10 , 00 } ) //05
	
	//	_cTemp := CriaTrab(_aCExcel, .T.)
	//	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	DBSelectArea("TMP")
	DBGotop()
	
	While !TMP->(EOF())
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= TMP->RA_MAT
		_aItem[02]		:= TMP->RA_NOME
		_aItem[03]		:= DTOC(STOD(TMP->PI_DATA))
		_aItem[04]  	:= TMP->PI_PD
		_aItem[05]		:= StrTran(cvaltoChar(TMP->PH_QUANTC),".",":")
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		DBSelectArea("TMP")
		DBSkip()
		
	Enddo
	
Else
	
	// **************************** Cria Arquivo Temporario
	_aCExcel:={}//SPCSQL->(DbStruct())
	aadd( _aCExcel , {"MAT"		    , "C" , 10 , 00 } ) //01
	aadd( _aCExcel , {"NOME	"		, "C" , 50 , 00 } ) //02
	aadd( _aCExcel , {"DAT"			, "C" , 10 , 00 } ) //03
	aadd( _aCExcel , {"EVENTO"		, "C" , 06 , 00 } ) //04
	aadd( _aCExcel , {"HORAS"		, "C" , 10 , 00 } ) //05
	aadd( _aCExcel , {"ABONO"		, "C" , 07 , 00 } ) //06
	aadd( _aCExcel , {"DESC"		, "C" , 45 , 00 } ) //07
	aadd( _aCExcel , {"ABONADO"		, "C" , 07 , 00 } )	//08
	
	//_cTemp := CriaTrab(_aCExcel, .T.)
	//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	DBSelectArea("TMP")
	DBGotop()
	
	While !TMP->(EOF())
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= TMP->RA_MAT
		_aItem[02]		:= TMP->RA_NOME
		_aItem[03]		:= DTOC(STOD(TMP->PH_DATA))
		_aItem[04]		:= TMP->PH_PD
		_aItem[05]		:= StrTran(cvaltoChar(TMP->PH_QUANTC),".",":")
		_aItem[06]  	:= TMP->PH_ABONO
		_aItem[07]      := TMP->P6_DESC
		_aItem[08]	   	:= StrTran(cvaltoChar(TMP->PH_QTABONO),".",":")
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		DBSelectArea("TMP")
		DBSkip()
		
	Enddo
	
Endif

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
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Folgas e Faltas - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","REALIZADO")
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
AADD(aRegs,{cPerg,"07","Justificada ?","","","mv_ch07","N",01,0,2,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

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
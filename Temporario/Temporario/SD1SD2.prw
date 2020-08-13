#Include "RwMake.ch"
#Include "topconn.ch"

/*
SD1SD2 - Rafael França - 29/06/2020 - Programa criado com objetivo de facilitar a importaçao das informaçoes do sistema para o BI
*/

User Function SD1SD2

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de entradas e saídas"
Local cPict        := ""
Local titulo       := "Tabela de Entradas e Saídas"
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
Private nomeprog   := "SD1SD2"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "SD1SD2"
Private cString    := "SD1"
Private cQuery   := ""
Private _aStruSRA := {}
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

Return



Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery	:= ""  

Pergunte(cPerg,.F.)

cQuery := "SELECT 'SAIDA' AS TIPO, '01' AS EMPRESA,D2_FILIAL AS FILIAL,D2_TIPO AS TIPONF, D2_DOC AS NFISCAL, D2_SERIE AS SERIE, D2_ITEM AS ITEM, D2_COD AS PRODUTO "
cQuery += ", AH_UMRES AS MEDIDA, B1_DESC AS DESCRICAOP, D2_QUANT AS QUANTIDADE,D2_PRCVEN AS VLUNIT, D2_TOTAL AS VLTOTAL, D2_LOCAL AS ARMAZEM,NNR_DESCRI AS DESCRICAOA "
cQuery += ", D2_LOTECTL AS LOTE, D2_DTVALID AS VALIDADE, D2_EMISSAO AS ENTRADA, D2_EMISSAO AS EMISSAO "
cQuery += ", D2_TES AS TES, F4_FINALID AS FINALIDADE, F4_ESTOQUE AS ESTOQUE, F4_DUPLIC AS FINANCEIRO, D2_CF AS CFOP  "
cQuery += ", D2_CLIENTE AS CLIFOR, D2_LOJA AS LOJA, CASE  "
cQuery += "WHEN D2_TIPO = 'D' THEN (SELECT A2_NOME FROM SA2010 WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' )  "
cQuery += "WHEN D2_TIPO <> 'D' THEN (SELECT A1_NOME FROM SA1010 WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS NOME "
cQuery += ", CASE WHEN D2_TIPO = 'D' THEN (SELECT A2_EST FROM SA2010 WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' )  "
cQuery += "WHEN D2_TIPO <> 'D' THEN (SELECT A1_EST FROM SA1010 WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS ESTADO "
cQuery += ", CASE WHEN D2_TIPO = 'D' THEN (SELECT A2_TIPO FROM SA2010 WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' )  "
cQuery += "WHEN D2_TIPO <> 'D' THEN (SELECT A1_PESSOA FROM SA1010 WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS PESSOA "
cQuery += "FROM SD2010 "
cQuery += "INNER JOIN SB1010 ON D2_COD = B1_COD AND SB1010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SF4010 ON D2_TES = F4_CODIGO AND SF4010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN NNR010 ON D2_LOCAL = NNR_CODIGO AND NNR010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SAH010 ON D2_UM = AH_UNIMED AND SAH010.D_E_L_E_T_ = '' "
cQuery += "WHERE SD2010.D_E_L_E_T_ = '' AND D2_EMISSAO BETWEEN '20200101' AND '20200131'  "
cQuery += "UNION  "
cQuery += "SELECT 'ENTRADA' AS TIPO, '01' AS EMPRESA,D1_FILIAL AS FILIAL,D1_TIPO AS TIPONF "
cQuery += ", D1_DOC AS NFISCAL, D1_SERIE AS SERIE, D1_ITEM AS ITEM, D1_COD AS PRODUTO "
cQuery += ", AH_UMRES AS MEDIDA, B1_DESC AS DESCRICAOP, D1_QUANT AS QUANTIDADE,D1_VUNIT AS VLUNIT, D1_TOTAL AS VLTOTAL, D1_LOCAL AS ARMAZEM,NNR_DESCRI AS DESCRICAOA "
cQuery += ", D1_LOTECTL AS LOTE, D1_DTVALID AS VALIDADE, D1_DTDIGIT AS ENTRADA, D1_EMISSAO AS EMISSAO "
cQuery += ", D1_TES AS TES, F4_FINALID AS FINALIDADE, F4_ESTOQUE AS ESTOQUE, F4_DUPLIC AS FINANCEIRO, D1_CF AS CFOP "
cQuery += ", D1_FORNECE AS CLIFOR, D1_LOJA AS LOJA "
cQuery += ", CASE WHEN D1_TIPO <> 'D' THEN (SELECT A2_NOME FROM SA2010 WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' )  "
cQuery += "WHEN D1_TIPO = 'D' THEN (SELECT A1_NOME FROM SA1010 WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS NOME "
cQuery += ", CASE WHEN D1_TIPO <> 'D' THEN (SELECT A2_EST FROM SA2010 WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' ) " 
cQuery += "WHEN D1_TIPO = 'D' THEN (SELECT A1_EST FROM SA1010 WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS ESTADO "
cQuery += ", CASE WHEN D1_TIPO <> 'D' THEN (SELECT A2_TIPO FROM SA2010 WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' ) " 
cQuery += "WHEN D1_TIPO = 'D' THEN (SELECT A1_PESSOA FROM SA1010 WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND SA1010.D_E_L_E_T_ = '' ) END AS PESSOA "
cQuery += "FROM SD1010  "
cQuery += "INNER JOIN SB1010 ON D1_COD = B1_COD AND SB1010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SF4010 ON D1_TES = F4_CODIGO AND SF4010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN NNR010 ON D1_LOCAL = NNR_CODIGO AND NNR010.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SAH010 ON D1_UM = AH_UNIMED AND SAH010.D_E_L_E_T_ = '' "
cQuery += "WHERE SD1010.D_E_L_E_T_ = '' AND D1_DTDIGIT BETWEEN '20200101' AND '2020013' "

If Select("TMP1") > 0
	TMP1->(DbCloseArea())                
Endif

TCQUERY cQuery NEW ALIAS "TMP1"

TMP1->(DbGoTop())

_aCExcel:={}//TMP->(DbStruct()) //_aCExcel

aadd( _aCExcel , {"TIPO"   			, "C" , 10 , 00 } ) //01
aadd( _aCExcel , {"EMPRESA"			, "C" , 12 , 00 } ) //02
aadd( _aCExcel , {"FILIAL"	   		, "C" , 05 , 00 } ) //03  
aadd( _aCExcel , {"TIPONF"	       	, "C" , 05 , 00 } ) //04
aadd( _aCExcel , {"NFISCAL"  		, "C" , 10 , 00 } ) //05
aadd( _aCExcel , {"SERIE"   	  	, "C" , 05 , 00 } ) //06
aadd( _aCExcel , {"ITEM"   	  		, "C" , 05 , 00 } ) //07
aadd( _aCExcel , {"PRODUTO"   		, "C" , 10 , 00 } ) //08
aadd( _aCExcel , {"DESCRICAOP"		, "C" , 30 , 00 } ) //09
aadd( _aCExcel , {"QUANTIDADE"	   	, "N" , 12 , 04 } ) //10  
aadd( _aCExcel , {"VLUNIT"	       	, "N" , 15 , 04 } ) //11
aadd( _aCExcel , {"VLTOTAL"  		, "N" , 18 , 04 } ) //12
aadd( _aCExcel , {"ARMAZEM"   	  	, "C" , 05 , 00 } ) //13
aadd( _aCExcel , {"DESCRICAOA"  	, "C" , 30 , 00 } ) //14
aadd( _aCExcel , {"LOTE" 	 		, "C" , 10 , 00 } ) //15
aadd( _aCExcel , {"VALIDADE"   	  	, "C" , 10 , 00 } ) //16
aadd( _aCExcel , {"ENTRADA"   	  	, "C" , 10 , 00 } ) //17
aadd( _aCExcel , {"EMISSAO"   		, "C" , 10 , 00 } ) //18
aadd( _aCExcel , {"TES"				, "C" , 05 , 00 } ) //19
aadd( _aCExcel , {"FINALIDADE"	   	, "C" , 20 , 04 } ) //20
aadd( _aCExcel , {"ESTOQUE"   		, "C" , 05 , 00 } ) //21
aadd( _aCExcel , {"FINANCEIRO"		, "C" , 05 , 00 } ) //22
aadd( _aCExcel , {"CFOP"	   		, "C" , 05 , 00 } ) //23  
aadd( _aCExcel , {"CLIFOR"	       	, "C" , 10 , 00 } ) //24
aadd( _aCExcel , {"NOME"  			, "C" , 30 , 00 } ) //25
aadd( _aCExcel , {"ESTADO"   	  	, "C" , 05 , 00 } ) //26
aadd( _aCExcel , {"PESSOA"   	  	, "C" , 05 , 00 } ) //27

DbSelectArea("TMP1")
Do While TMP1->(!Eof())
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)                                                                       
_aItem[01]  := TMP1->TIPO  		//01
_aItem[02]  := TMP1->EMPRESA	//02
_aItem[03]  := TMP1->FILIAL 	//03  
_aItem[04]  := TMP1->TIPONF 	//04
_aItem[05]  := TMP1->NFISCAL 	//05
_aItem[06]  := TMP1->SERIE 		//06
_aItem[07]  := TMP1->ITEM 		//07
_aItem[08]  := TMP1->PRODUTO 	//08
_aItem[09]  := TMP1->DESCRICAOP //09
_aItem[10]  := TMP1->QUANTIDADE //10  
_aItem[11]  := TMP1->VLUNIT 	//11
_aItem[12]  := TMP1->VLTOTAL 	//12
_aItem[13]  := TMP1->ARMAZEM 	//13
_aItem[14]  := TMP1->DESCRICAOA //14
_aItem[15]  := TMP1->LOTE 		//15
_aItem[16]  := STOD(TMP1->VALIDADE) //16
_aItem[17]  := STOD(TMP1->ENTRADA) 	//17
_aItem[18]  := STOD(TMP1->EMISSAO) 	//18
_aItem[19]  := TMP1->TES 		//19
_aItem[20]  := TMP1->FINALIDADE //20
_aItem[21]  := TMP1->ESTOQUE 	//21
_aItem[22]  := TMP1->FINANCEIRO //22
_aItem[23]  := TMP1->CFOP 		//23  
_aItem[24]  := TMP1->CLIFOR 	//24
_aItem[25]  := TMP1->NOME 		//25
_aItem[26]  := TMP1->ESTADO 	//26
_aItem[27]  := TMP1->PESSOA 	//27
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	TMP1->(DbSkip())
			
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

DbSelectArea("TMP1")
TMP1->(DbCloseArea())

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Tabela de Entradas e Saídas", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","SD1SD2")
	_lRet := .F.
ENDIF

Return



Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Da Filial:		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Até Filial: 	","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Da Data:  		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Até a Data: 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","TP Relatorio: 	","","","mv_ch05","N",01,0,0,"C","","mv_par05","Ent/Saida","","","","","Estoque","","","","","","","","","","","","","","","","","","",""})

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

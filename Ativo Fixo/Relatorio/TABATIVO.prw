#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 TABATIVO : Autor 3 Bruno Alves        : Data 3  14/01/2014 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Tabela do Ativo Fixo em Excel    :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Auditoria                                                  :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function TABATIVO

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Tabela Mensal Ativo"
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
Private nomeprog   := "TABATIVO"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "TABATIVO"
Private cString    := "SRA"
Private N		   := 00001
Private cQuery     := ""
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
Local cQuery	:=""
Local nCol		:= 0
Local cCol  	:= ""
//Local dUltDepr	:= MonthSum(GetMv("MV_ULTDEPR"),1)  // Somado 1 mês para considerar ativos que tiveram movimentações como baixa ou transferencia
Local aRegistros := {}
SetRegua(5000)
Pergunte(cPerg,.f.)


cQuery:= "SELECT N3_FILIAL AS FILIAL,N3_CBASE AS CBASE,N3_ITEM AS ITEM,N3_TIPO AS TIPO "
cQuery+= ",(SELECT N1_CHAPA FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS PLAQUETA "
cQuery+= ",(SELECT N1_DESCRIC FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS DESCRICAO "
cQuery+= ",(SELECT N1_FABRIC FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS MARCA "
cQuery+= ",(SELECT N1_MODELO FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS MODELO "
cQuery+= ",N3_OBS AS OBS "
cQuery+= ",(SELECT N1_FORNEC FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS FORNECE "
cQuery+= ",(SELECT A2_NOME   FROM SA2010 WHERE A2_COD = (SELECT N1_FORNEC FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AND A2_LOJA = '01' AND SA2010.D_E_L_E_T_ <> '*') AS NOME "
cQuery+= ",(SELECT N1_SERIE1 FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS NSERIE "
cQuery+= ",SUBSTRING(N3_AQUISIC,7,2) + '/' + SUBSTRING(N3_AQUISIC,5,2) + '/'+  SUBSTRING(N3_AQUISIC,1,4) AS DTAQUISICAO "
cQuery+= ",N3_VORIG1 AS VALOR,N3_TXDEPR1 AS TAXA,N3_VRDBAL1 AS DEPREBAL,N3_VRDMES1 AS DEPREMES,N3_VRDACM1 AS DEPREACM "
cQuery+= ",SUBSTRING(N3_DTBAIXA,7,2) + '/' + SUBSTRING(N3_DTBAIXA,5,2) + '/'+  SUBSTRING(N3_DTBAIXA,1,4) AS DTBAIXA "
cQuery+= ",(SELECT N1_GRUPO FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS GRUPO "
cQuery+= ",SUBSTRING(N3_DINDEPR,7,2) + '/' + SUBSTRING(N3_DINDEPR,5,2) + '/'+  SUBSTRING(N3_DINDEPR,1,4) AS DTINIDEPRE "
cQuery+= ",N3_CUSTBEM,(SELECT CTT_DESC01 FROM CTT010 WHERE CTT010.D_E_L_E_T_ = '' AND CTT_CUSTO = N3_CUSTBEM AND CTT_FILIAL = N3_FILIAL) AS CCUSTO "
cQuery+= ",N3_CCONTAB,(SELECT CT1_DESC01 FROM CT1010 WHERE CT1010.D_E_L_E_T_ = '' AND CT1_CONTA = N3_CCONTAB) AS CONTA "
cQuery+= ",N3_CCDEPR, (SELECT CT1_DESC01 FROM CT1010 WHERE CT1010.D_E_L_E_T_ = '' AND CT1_CONTA = N3_CCDEPR)  AS CONTADEPR "
cQuery+= ",N3_CDEPREC,(SELECT CT1_DESC01 FROM CT1010 WHERE CT1010.D_E_L_E_T_ = '' AND CT1_CONTA = N3_CDEPREC) AS CONTADESPESA "
cQuery+= ",(SELECT N1_ORIGEM FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS ORIGEM "
cQuery+= ",(SELECT N1_NFISCAL FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS NFISCAL "
cQuery+= ",(SELECT N1_APOLICE FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS APOLICE "
cQuery+= ",(SELECT SUBSTRING(N1_DTVENC,7,2) + '/' + SUBSTRING(N1_DTVENC,5,2) + '/'+  SUBSTRING(N1_DTVENC,1,4) FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS DTVENCSEGURO "
cQuery+= ",(SELECT N1_CODSEG FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS SEGURADORA "
cQuery+= "FROM SN3010 "
cQuery+= "WHERE SN3010.D_E_L_E_T_ = '' "  //AND N3_TIPO <> '12' //AND N3_CCONTAB = '126510001' AND SUBSTR(N3_CUSTBEM,1,1) <> '2'
cQuery+= "AND N3_CBASE BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' "
cQuery+= "AND N3_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "
cQuery+= "ORDER BY N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO "

If Select("TMP") > 0
	TMP->(DbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGoTop())

// **************************** Cria Arquivo Temporario
_aCExcel:={}//TMP->(DbStruct())
aadd( _aCExcel , {"FILIAL"      	, "C" , 06 , 00 } ) //01
aadd( _aCExcel , {"CBASE"   		, "C" , 10 , 00 } ) //02
aadd( _aCExcel , {"ITEM"  			, "C" , 05 , 00 } ) //03
aadd( _aCExcel , {"TIPO"			, "C" , 05 , 00 } ) //04
aadd( _aCExcel , {"DESCRICAO"		, "C" , 50,  00 } ) //05
aadd( _aCExcel , {"PLAQUETA"   		, "C" , 09 , 00 } ) //06
aadd( _aCExcel , {"MARCA"		   	, "C" , 30 , 00 } ) //07
aadd( _aCExcel , {"MODELO"	   		, "C" , 30 , 00 } ) //08
aadd( _aCExcel , {"OBS"	   			, "C" , 50 , 00 } ) //09
aadd( _aCExcel , {"FORNEC"	   		, "C" , 10 , 00 } ) //10
aadd( _aCExcel , {"NOMEFOR"   	  	, "C" , 40 , 00 } ) //11
aadd( _aCExcel , {"NSERIE"   	  	, "C" , 10 , 00 } ) //12
aadd( _aCExcel , {"DAQUISICAO"     	, "C" , 16 , 00 } ) //13
aadd( _aCExcel , {"VALOR"  			, "N" , 20 , 02 } ) //14
aadd( _aCExcel , {"TAXA"	  		, "N" , 12 , 04 } ) //15
aadd( _aCExcel , {"DEPREBAL"	   	, "N" , 16,  02 } ) //16
aadd( _aCExcel , {"DEPREMES"   		, "N" , 16 , 02 } ) //17
aadd( _aCExcel , {"DEPREACM"	 	, "N" , 16 , 02 } ) //18
aadd( _aCExcel , {"DTBAIXA"     	, "C" , 16 , 00 } ) //19
aadd( _aCExcel , {"GRUPO"  		 	, "C" , 10 , 00 } ) //20
aadd( _aCExcel , {"DTINIDEPRE"  	, "C" , 16 , 00 } ) //21
aadd( _aCExcel , {"CCUSTO"	   		, "C" , 10 , 00 } ) //22
aadd( _aCExcel , {"DESCRICAO1"	   	, "C" , 35,  00 } ) //23
aadd( _aCExcel , {"CONTA"	 		, "C" , 10 , 00 } ) //24
aadd( _aCExcel , {"DESCRICAO2"  	, "C" , 35 , 00 } ) //25
aadd( _aCExcel , {"CONTADEPR"	  	, "C" , 10 , 00 } ) //26
aadd( _aCExcel , {"DESCRICAO3"	   	, "C" , 35,  00 } ) //27
aadd( _aCExcel , {"CTDESPESA"   	, "C" , 10 , 00 } ) //28
aadd( _aCExcel , {"DESCRICAO4"	 	, "C" , 35 , 00 } ) //29
aadd( _aCExcel , {"ORIGEM"     		, "C" , 20 , 00 } ) //30
aadd( _aCExcel , {"NFISCAL"  		, "C" , 15 , 00 } ) //31
aadd( _aCExcel , {"APOLICE"  		, "C" , 15 , 00 } ) //32
aadd( _aCExcel , {"DTVENCSEG"	   	, "C" , 16 , 00 } ) //33
aadd( _aCExcel , {"SEGURADORA"	   	, "C" , 20,  00 } ) //34
aadd( _aCExcel , {"CALCDEPRE"	   	, "N" , 16,  02 } ) //35

/*
IF MV_PAR06 == 1 .AND. MV_PAR05 == 1

WHILE nCol < 200

cCol := "MES" + SUBSTR(DTOS(MonthSub(dUltDepr,nCol)),1,6)

aadd( _aCExcel , {cCol	   		, "N" , 12,  02 } )

nCol += 1

ENDDO

ENDIF

*/

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DbSelectArea("TMP")
Do While TMP->(!Eof())
	
	nVal 		:= 0
	
	
	IF MV_PAR05 == 1 .AND. MV_PAR06 == 2 //Calcula depreciação SN4
		
		IF TMP->TIPO  == "01"
			
			cQuery := "SELECT SUM(N4_VLROC1) AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '06' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
			
		ELSEIF TMP->TIPO  == "10"
			
			cQuery := "SELECT SUM(N4_VLROC1) AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE  + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '20' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
			
		ELSEIF TMP->TIPO  == "12"
			
			cQuery := "SELECT SUM(N4_VLROC1) AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE  + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '20' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
			
		ENDIF
		
		TcQuery cQuery New Alias "TMPSN4"
		
		DBSelectArea("TMPSN4")
		DBGotop()
		While !EOF()
			
			nVal := TMPSN4->VALOR
			DBSelectArea("TMPSN4")
			dbSkip()
			
		ENDDO
		
		DBSelectArea("TMPSN4")
		DBCloseArea("TMPSN4")
		
	ENDIF    /*  ELSEIF MV_PAR05 == 1 .AND. MV_PAR06 == 1  //Calcula depreciação SN4 + Depreciação horizontal
	
	cCol 		:= ""
	aRegistros 	:= {}
	nVal 		:= 0
	
	IF TMP->TIPO  == "01"
	
	cQuery := "SELECT SUBSTR(N4_DATA,1,6) AS DATA1,N4_VLROC1 AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '06' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
	
	ELSEIF TMP->TIPO  == "10"
	
	cQuery := "SELECT SUBSTR(N4_DATA,1,6) AS DATA1,N4_VLROC1 AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE  + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '20' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
	
	ELSEIF TMP->TIPO  == "12"
	
	cQuery := "SELECT SUBSTR(N4_DATA,1,6) AS DATA1,N4_VLROC1 AS VALOR FROM SN4010 WHERE D_E_L_E_T_ = '' AND N4_TIPO = '" + TMP->TIPO + "' AND N4_CBASE = '" + TMP->CBASE  + "' AND N4_ITEM = '" + TMP->ITEM + "' AND N4_OCORR = '20' AND N4_TIPOCNT = '4' AND N4_FILIAL = '" + TMP->FILIAL + "'"
	
	ENDIF
	
	TcQuery cQuery New Alias "TMPSN4"
	
	DBSelectArea("TMPSN4")
	DBGotop()
	While !EOF()
	
	cCol := "TMP1->MES" + TMPSN4->DATA1
	//cCol := "TMP1->MES" + STRZERO((DateDiffMonth( dUltDepr  , STOD(TMPSN4->DATA1)) + 1),03)
	nVal += TMPSN4->VALOR
	
	AADD(aRegistros,{cCol,TMPSN4->VALOR})
	
	DBSelectArea("TMPSN4")
	dbSkip()
	
	ENDDO
	
	DBSelectArea("TMPSN4")
	DBCloseArea("TMPSN4")
	
	ENDIF
	
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[01]	:= 	TMP->FILIAL
	_aItem[02]	:=	TMP->CBASE
	_aItem[03]	:=	TMP->ITEM
	_aItem[04]	:=  TMP->TIPO
	_aItem[05]	:=	TMP->DESCRICAO
	_aItem[06]	:=  TMP->PLAQUETA
	_aItem[07]	:=	TMP->MARCA
	_aItem[08]	:=	TMP->MODELO
	_aItem[09]	:=	TMP->OBS
	_aItem[10]	:=	TMP->FORNECE
	_aItem[11]	:=	TMP->NOME
	_aItem[12]	:= 	TMP->NSERIE
	_aItem[13]	:= 	TMP->DTAQUISICAO
	_aItem[14]	:= 	TMP->VALOR
	_aItem[15]	:= 	TMP->TAXA
	_aItem[16]	:=	TMP->DEPREBAL
	_aItem[17]	:=	TMP->DEPREMES
	_aItem[18]	:=	TMP->DEPREACM
	_aItem[19]	:= 	TMP->DTBAIXA
	_aItem[20]	:= 	TMP->GRUPO
	_aItem[21]	:= 	TMP->DTINIDEPRE
	_aItem[22]	:=	TMP->N3_CUSTBEM
	_aItem[23]	:=	TMP->CCUSTO
	_aItem[24]  :=  TMP->N3_CCONTAB
	_aItem[25]	:=	TMP->CONTA
	_aItem[26]	:=	TMP->N3_CCDEPR
	_aItem[27]	:=  TMP->CONTADEPR
	_aItem[28]	:= 	TMP->N3_CDEPREC
	_aItem[29]	:= 	TMP->CONTADESPESA
	_aItem[30]	:=	TMP->ORIGEM
	_aItem[31]	:=  TMP->NFISCAL
	_aItem[32]	:=	TMP->APOLICE
	_aItem[33]	:=	TMP->DTVENCSEGURO
	_aItem[34]	:=	TMP->SEGURADORA
	_aItem[35]	:=	nVal
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	//	IF LEN(aRegistros) > 0 .AND. MV_PAR06 == 1 .AND. MV_PAR05 == 1
	//
	//		For i:=1 to Len(aRegistros)
	//
	//			Reclock("TMP1",.F.)
	//			&(aRegistros[i][1])  := aRegistros[i][2]
	//			MsUnlock()
	//
	//		Next
	//
	//	ENDIF
	
	DbSelectArea("TMP")
	TMP->(DbSkip())
	
	N++
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

DbSelectArea("TMP")
TMP->(DbCloseArea())
//DbSelectArea("TMP1")
//TMP1->(DbCloseArea())

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Tabela de Ativos - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","TABATIVO")
	_lRet := .F.
ENDIF

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

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

AADD(aRegs,{cPerg,"01","Da Filial	   ","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Ate Filial     ","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Do Ativo Fixo  ","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"04","Ate Ativo Fixo ","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"05","Calc Depreciação","","","mv_ch05","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Depr Horizontal ","","","mv_ch06","N",01,0,0,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

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

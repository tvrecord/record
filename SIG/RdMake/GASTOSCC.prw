#Include "RwMake.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGASTOSCC  บAutor  ณRafael Fran็a       บ Data ณ  26/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPlanilha com gastos por Natureza/Conta com rateio por       บฑฑ
ฑฑบ          ณCentro de Custos                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRecord DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GASTOSCC()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "SIG Excel"
Local cPict        := ""
Local titulo       := "Despesas por Natureza/Conta"
Local nLin         := 80
Local Cabec1       := "Mat.    Nome                                                Data      Evento  Nome                 Horario    C. Custo  Descri็ใo"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "GASTOSCC1"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "GASTOSCC6"
Private cString    := "SZR"
Private cQueryMes  := ""
Private dMES01     := CTOD("//")
Private dMES02     := CTOD("//")
Private dMES03     := CTOD("//")
Private dMES04     := CTOD("//")
Private dMES05     := CTOD("//")
Private dMES06     := CTOD("//")
Private dMES07     := CTOD("//")
Private dMES08     := CTOD("//")
Private dMES09     := CTOD("//")
Private dMES10     := CTOD("//")
Private dMES11     := CTOD("//")
Private dMES12     := CTOD("//")
Private nQtdMes    := 1
Private _aIExcel 	 := {}

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERACAO CANCELADA")
	return
ENDIF

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

cQueryMes := "SELECT SUBSTRING(ZR_EMISSAO,1,6) AS MES FROM SZR010 "
//cQueryMes += "INNER JOIN CT1010 ON CT1_CONTA = ZR_CONTA "
cQueryMes += "INNER JOIN CTT010 ON CTT_CUSTO = ZR_CC "
cQueryMes += "WHERE SZR010.D_E_L_E_T_ = '' "
cQueryMes += "AND CTT010.D_E_L_E_T_ = '' "
//cQueryMes += "AND CT1010.D_E_L_E_T_ = '' "
cQueryMes += "AND ZR_TIPO = 'D' "
//cQueryMes += "AND ZR_PREFIXO <> 'ATF' "
IF MV_PAR16 == 1
	cQueryMes += "AND SUBSTRING(ZR_CONTA,1,1) = '4' "
ENDIF
cQueryMes += "AND ZR_CONTA BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
cQueryMes += "AND ZR_CC BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "
cQueryMes += "AND ZR_EMISSAO BETWEEN '"+ DTOS(MV_PAR05) +"' AND '"+ DTOS(MV_PAR06) +"' "

IF !EMPTY(MV_PAR12)
	cQueryMes += "AND ZR_CC IN " + FormatIn(ALLTRIM(MV_PAR12),";")+ " "
ENDIF

cQueryMes += "GROUP BY SUBSTRING(ZR_EMISSAO,1,6) "
cQueryMes += "ORDER BY SUBSTRING(ZR_EMISSAO,1,6) "

If Select("TMPMES") > 0
	TMPMES->(DbCloseArea())
Endif

TCQUERY cQueryMes NEW ALIAS "TMPMES"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMPMES")
	dbCloseArea("TMPMES")
	Return
Endif

DbSelectArea("TMPMES")
Do While TMPMES->(!Eof())
	
	IF nQtdMes == 1
		dMES01     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 2
		dMES02     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 3
		dMES03     := STOD(TMPMES->MES + "01")
	ENDIF
	
	IF nQtdMes == 4 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
		dMES04     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 5 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
		dMES05     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 6 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
		dMES06     := STOD(TMPMES->MES + "01")
	ENDIF
	
	
	IF nQtdMes == 7 .AND. MV_PAR09 == 3
		dMES07     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 8 .AND. MV_PAR09 == 3
		dMES08     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 9 .AND. MV_PAR09 == 3
		dMES09     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 10 .AND. MV_PAR09 == 3
		dMES10     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 11 .AND. MV_PAR09 == 3
		dMES11     := STOD(TMPMES->MES + "01")
	ELSEIF nQtdMes == 12 .AND. MV_PAR09 == 3
		dMES12     := STOD(TMPMES->MES + "01")
	ENDIF
	
	nQtdMes ++
	
	dbSkip()
	
ENDDO


SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

// RunReport -> Programa para a gera็ใo do arquivo.

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery 		:= ""
Local cCC			:= ""
Local nCCVlTT		:= 0
Local cConta		:= ""
Local cContaDesc	:= ""
Local nVlConta01	:= 0
Local nVlConta02	:= 0
Local nVlConta03	:= 0
Local nVlConta04	:= 0
Local nVlConta05	:= 0
Local nVlConta06	:= 0
Local nVlConta07	:= 0
Local nVlConta08	:= 0
Local nVlConta09	:= 0
Local nVlConta10	:= 0
Local nVlConta11	:= 0
Local nVlConta12	:= 0
Local nVlContaTT	:= 0
Local nVlTT01		:= 0
Local nVlTT02		:= 0
Local nVlTT03		:= 0
Local nVlTT04		:= 0
Local nVlTT05		:= 0
Local nVlTT06		:= 0
Local nVlTT07		:= 0
Local nVlTT08		:= 0
Local nVlTT09		:= 0
Local nVlTT10		:= 0
Local nVlTT11		:= 0
Local nVlTT12		:= 0
Local nVlTotal		:= 0
Local lOk			:= .T.  
Local lOk2			:= .F. 

Pergunte(cPerg,.F.)

IF MV_PAR10 == 1
	
	cQuery := "SELECT ZR_CTASIG AS ZR_CONTA,X5_DESCRI AS CT1_DESC01,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) AS MES,SUM(ZR_VALOR) AS VALOR FROM SZR010 "
	cQuery += "INNER JOIN SX5010 ON ZR_CTASIG = X5_CHAVE AND X5_TABELA = 'Z8' "
	cQuery += "INNER JOIN CTT010 ON CTT_CUSTO = ZR_CC "
	cQuery += "WHERE SZR010.D_E_L_E_T_ = '' "
	cQuery += "AND CTT010.D_E_L_E_T_ = '' "
	cQuery += "AND SX5010.D_E_L_E_T_ = '' "
	cQuery += "AND ZR_TIPO = 'D' "
	//cQuery += "AND ZR_PREFIXO <> 'ATF' "
	IF MV_PAR16 == 1
		cQueryMes += "AND SUBSTRING(ZR_CONTA,1,1) = '4' "
	ENDIF
	cQuery += "AND ZR_CONTA BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
	cQuery += "AND ZR_CTASIG BETWEEN '"+ MV_PAR14 +"' AND '"+ MV_PAR15 +"' "
	cQuery += "AND ZR_CC BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "
	cQuery += "AND ZR_EMISSAO BETWEEN '"+ DTOS(MV_PAR05) +"' AND '"+ DTOS(MV_PAR06) +"' "
	IF !EMPTY(MV_PAR12)
		cQuery += "AND ZR_CC IN " + FormatIn(ALLTRIM(MV_PAR12),";")+ " "
	ENDIF
	IF MV_PAR13 == 2
		cQuery += "GROUP BY ZR_CTASIG,X5_DESCRI,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) "
		cQuery += "ORDER BY ZR_CTASIG,ZR_CC,SUBSTRING(ZR_EMISSAO,1,6) "
	ELSEIF MV_PAR13 == 1
		cQuery += "GROUP BY ZR_CTASIG,X5_DESCRI,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) "
		cQuery += "ORDER BY ZR_CC,ZR_CTASIG,SUBSTRING(ZR_EMISSAO,1,6) "
	ENDIF
	
ELSE
	
	cQuery := "SELECT ZR_CONTA,CT1_DESC01,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) AS MES,SUM(ZR_VALOR) AS VALOR FROM SZR010 "
	cQuery += "INNER JOIN CT1010 ON CT1_CONTA = ZR_CONTA "
	cQuery += "INNER JOIN CTT010 ON CTT_CUSTO = ZR_CC "
	cQuery += "WHERE SZR010.D_E_L_E_T_ = '' "
	cQuery += "AND CTT010.D_E_L_E_T_ = '' "
	cQuery += "AND CT1010.D_E_L_E_T_ = '' "
	cQuery += "AND ZR_TIPO = 'D' "
	//cQuery += "AND ZR_PREFIXO <> 'ATF' "
	IF MV_PAR16 == 1
		cQueryMes += "AND SUBSTRING(ZR_CONTA,1,1) = '4' "
	ENDIF
	cQuery += "AND ZR_CONTA BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
	cQuery += "AND ZR_CTASIG BETWEEN '"+ MV_PAR14 +"' AND '"+ MV_PAR15 +"' "
	cQuery += "AND ZR_CC BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "
	cQuery += "AND ZR_EMISSAO BETWEEN '"+ DTOS(MV_PAR05) +"' AND '"+ DTOS(MV_PAR06) +"' "
	IF !EMPTY(MV_PAR12)
		cQuery += "AND ZR_CC IN " + FormatIn(ALLTRIM(MV_PAR12),";")+ " "
	ENDIF
	IF MV_PAR13 == 2
		cQuery += "GROUP BY ZR_CONTA,CT1_DESC01,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) "
		cQuery += "ORDER BY ZR_CONTA,ZR_CC,SUBSTRING(ZR_EMISSAO,1,6) "
	ELSEIF MV_PAR13 == 1
		cQuery += "GROUP BY ZR_CONTA,CT1_DESC01,ZR_CC,CTT_DESC01,SUBSTRING(ZR_EMISSAO,1,6) "
		cQuery += "ORDER BY ZR_CC,ZR_CONTA,SUBSTRING(ZR_EMISSAO,1,6) "
	ENDIF
	
ENDIF


If Select("TMPCC") > 0
	TMPCC->(DbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMPCC"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMPCC")
	dbCloseArea("TMPCC")
	Return
Endif

TMPCC->(DbGoTop())

IF MV_PAR07 == 1
	
	// Rafael Fran็a - Cria Arquivo Temporario
	
	_aCExcel	:= {}  //TMPCC->(DbStruct())
	aadd( _aCExcel , {"CCUSTO"      		, "C" , 12 , 00 } )  //01
	aadd( _aCExcel , {"DESCRICAO"			, "C" , 40 , 00 } )  //02
	aadd( _aCExcel , {"VL_MES_01"  	   		, "N" , 14 , 02 } )  //03
	aadd( _aCExcel , {"VL_MES_02"  	   		, "N" , 14 , 02 } )  //04
	aadd( _aCExcel , {"VL_MES_03"			, "N" , 14 , 02 } )  //05
	
	IF MV_PAR09 == 2 .OR. MV_PAR09 == 3
		aadd( _aCExcel , {"VL_MES_04"  	   		, "N" , 14 , 02 } ) //06
		aadd( _aCExcel , {"VL_MES_05"  	   		, "N" , 14 , 02 } ) //07
		aadd( _aCExcel , {"VL_MES_06"			, "N" , 14 , 02 } ) //08
	ENDIF
	
	IF MV_PAR09 == 3
		aadd( _aCExcel , {"VL_MES_07"  	   		, "N" , 14 , 02 } ) //09
		aadd( _aCExcel , {"VL_MES_08"  	   		, "N" , 14 , 02 } ) //10
		aadd( _aCExcel , {"VL_MES_09"			, "N" , 14 , 02 } ) //11
		aadd( _aCExcel , {"VL_MES_10"  	  		, "N" , 14 , 02 } ) //12
		aadd( _aCExcel , {"VL_MES_11"  	 		, "N" , 14 , 02 } ) //13
		aadd( _aCExcel , {"VL_MES_12"			, "N" , 14 , 02 } ) //14
	ENDIF
	
	IF MV_PAR08 	== 1
		aadd( _aCExcel , {"TOTAL"		   		, "N" , 14,  02 } ) //15
	ELSE
		aadd( _aCExcel , {"MEDIA"		   		, "N" , 14,  02 } ) //16
	ENDIF
	
	//_cTemp := CriaTrab(_aCExcel, .T.)
	//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
	
	DbSelectArea("TMPCC")
	Do While TMPCC->(!Eof())
		
		IF cConta 	!= TMPCC->ZR_CONTA .AND. MV_PAR13 == 2
			
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= SUBSTR(TMPCC->ZR_CONTA,1,12)
			_aItem[2]	:= ALLTRIM(TMPCC->CT1_DESC01)
			AADD(_aIExcel,_aItem)
			_aItem := {}
			
		ELSEIF cConta 	!= TMPCC->ZR_CC .AND. MV_PAR13 == 1
			
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= SUBSTR(TMPCC->ZR_CC,1,12)
			_aItem[2]	:= ALLTRIM(TMPCC->CTT_DESC01)
			AADD(_aIExcel,_aItem)
			_aItem := {}
			
		ENDIF
		
		nCCVlTT		+= TMPCC->VALOR
		
		IF lOk 
			_aItem := ARRAY(LEN(_aCExcel) + 1)
		ENDIF
		
		IF MV_PAR13 == 2
			_aItem[1]	:= TMPCC->ZR_CC
			_aItem[2]	:= TMPCC->CTT_DESC01
		ELSEIF MV_PAR13 == 1
			_aItem[1]	:= SUBSTR(TMPCC->ZR_CONTA,1,12)
			_aItem[2]	:= ALLTRIM(TMPCC->CT1_DESC01)
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES01
			_aItem[3] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES02
			_aItem[4] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES03
			_aItem[5] 	:= TMPCC->VALOR
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES04 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			_aItem[6] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES05 .AND.(MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			_aItem[7] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES06 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			_aItem[8] 	:= TMPCC->VALOR
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES07 .AND. MV_PAR09 == 3
			_aItem[9] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES08 .AND. MV_PAR09 == 3
			_aItem[10] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES09 .AND. MV_PAR09 == 3
			_aItem[11] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES10 .AND. MV_PAR09 == 3
			_aItem[12] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES11 .AND. MV_PAR09 == 3
			_aItem[13] 	:= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES12 .AND. MV_PAR09 == 3
			_aItem[14] 	:= TMPCC->VALOR
		ENDIF
		
		IF MV_PAR08 	== 1 .AND. MV_PAR09 == 1
			_aItem[6]		:= nCCVlTT   
		ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 2
			_aItem[9]		:= nCCVlTT
		ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 3
			_aItem[15]		:= nCCVlTT
		ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 1
			_aItem[6]		:= (nCCVlTT/3)
		ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 2
			_aItem[9]		:= (nCCVlTT/6)
		ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 3
			_aItem[15]		:= (nCCVlTT/12)
		ENDIF
		
		//IF lOk
		//	AADD(_aIExcel,_aItem)
		//	_aItem := {}
		//ENDIF
		
		IF MV_PAR13 == 2
			
			cCC  		:= TMPCC->ZR_CC
			cConta		:= TMPCC->ZR_CONTA
			cContaDesc	:= TMPCC->CT1_DESC01
			
		ELSEIF MV_PAR13 == 1
			
			cCC  		:= TMPCC->ZR_CONTA
			cConta		:= TMPCC->ZR_CC
			cContaDesc	:= TMPCC->CTT_DESC01
			
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES01
			nVlConta01	+= TMPCC->VALOR
			nVlTT01		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES02
			nVlConta02	+= TMPCC->VALOR
			nVlTT02		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES03
			nVlConta03	+= TMPCC->VALOR
			nVlTT03		+= TMPCC->VALOR
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES04 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			nVlConta04	+= TMPCC->VALOR
			nVlTT04		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES05 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			nVlConta05	+= TMPCC->VALOR
			nVlTT05		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES06 .AND. (MV_PAR09 == 2 .OR. MV_PAR09 == 3)
			nVlConta06	+= TMPCC->VALOR
			nVlTT06		+= TMPCC->VALOR
		ENDIF
		
		IF STOD(TMPCC->MES + "01") 		== dMES07 .AND. MV_PAR09 == 3
			nVlConta07	+= TMPCC->VALOR
			nVlTT07		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES08 .AND. MV_PAR09 == 3
			nVlConta08	+= TMPCC->VALOR
			nVlTT08		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES09 .AND. MV_PAR09 == 3
			nVlConta09	+= TMPCC->VALOR
			nVlTT09		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES10 .AND. MV_PAR09 == 3
			nVlConta10	+= TMPCC->VALOR
			nVlTT10		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES11 .AND. MV_PAR09 == 3
			nVlConta11	+= TMPCC->VALOR
			nVlTT11		+= TMPCC->VALOR
		ELSEIF STOD(TMPCC->MES + "01") 	== dMES12 .AND. MV_PAR09 == 3
			nVlConta12	+= TMPCC->VALOR
			nVlTT12		+= TMPCC->VALOR
		ENDIF
		
		nVlContaTT	+= TMPCC->VALOR
		nVlTotal	+= TMPCC->VALOR
		
		TMPCC->(DbSkip())
					
		IF     cCC  != TMPCC->ZR_CC .AND. MV_PAR13 == 2 .AND. cConta == TMPCC->ZR_CONTA
			AADD(_aIExcel,_aItem)
			_aItem := {}  
			nCCVlTT		:= 0
			lOk 		:= .T.	 
		ELSEIF cCC  != TMPCC->ZR_CONTA .AND. MV_PAR13 == 1 .AND. cConta == TMPCC->ZR_CC
			AADD(_aIExcel,_aItem)
			_aItem := {}  
			nCCVlTT		:= 0
			lOk 		:= .T.								
		ELSE
			lOk 		:= .F.			
		ENDIF
		
		IF cConta 	!= TMPCC->ZR_CONTA .AND. MV_PAR13 == 2
			
			IF !lOk
			AADD(_aIExcel,_aItem)
			_aItem := {} 
			ENDIF 
			
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= "TOTAL"
			_aItem[2] 	:= SUBSTR(cContaDesc,1,30)
			_aItem[3] 	:= nVlConta01
			_aItem[4] 	:= nVlConta02
			_aItem[5] 	:= nVlConta03
			
			IF  MV_PAR09 == 2 .OR. MV_PAR09 == 3
				_aItem[6] 	:= nVlConta04
				_aItem[7] 	:= nVlConta05
				_aItem[9] 	:= nVlConta06
			ENDIF
			
			IF  MV_PAR09 == 3
				_aItem[9] 	:= nVlConta07
				_aItem[10] 	:= nVlConta08
				_aItem[11] 	:= nVlConta09
				_aItem[12] 	:= nVlConta10
				_aItem[13] 	:= nVlConta11
				_aItem[14] 	:= nVlConta12
			ENDIF
			
			IF MV_PAR08 	== 1 .AND. MV_PAR09 == 1
				_aItem[6]		:= nVlContaTT
			ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 2
				_aItem[9]		:= nVlContaTT
			ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 3
				_aItem[15]		:= nVlContaTT				
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 1
				_aItem[6]		:= (nVlContaTT/3)
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 2
				_aItem[9]		:= (nVlContaTT/6)
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 3
				_aItem[15]		:= (nVlContaTT/12)
			ENDIF
			
			AADD(_aIExcel,_aItem)
			_aItem := {}
			
			lOk 			:= .T.
			nVlConta01		:= 0
			nVlConta02		:= 0
			nVlConta03		:= 0
			nVlConta04		:= 0
			nVlConta05		:= 0
			nVlConta06		:= 0
			nVlConta07		:= 0
			nVlConta08		:= 0
			nVlConta09		:= 0
			nVlConta10		:= 0
			nVlConta11		:= 0
			nVlConta12		:= 0
			nVlContaTT		:= 0
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= ""
			_aItem[2] 	:= ""
			AADD(_aIExcel,_aItem)
			_aItem := {}
			
			
		ENDIF
		
		IF cConta 	!= TMPCC->ZR_CC .AND. MV_PAR13 == 1    
		
			IF !lOk
			AADD(_aIExcel,_aItem)
			_aItem := {} 
			ENDIF 
			
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= "TOTAL"
			_aItem[2] 	:= SUBSTR(cContaDesc,1,30)
			_aItem[3] 	:= nVlConta01
			_aItem[4] 	:= nVlConta02
			_aItem[5] 	:= nVlConta03
			
			IF  MV_PAR09 == 2 .OR. MV_PAR09 == 3
				_aItem[6] 	:= nVlConta04
				_aItem[7] 	:= nVlConta05
				_aItem[8] 	:= nVlConta06
			ENDIF
			
			IF  MV_PAR09 == 3
				_aItem[9] 	:= nVlConta07
				_aItem[10] 	:= nVlConta08
				_aItem[11] 	:= nVlConta09
				_aItem[12] 	:= nVlConta10
				_aItem[13] 	:= nVlConta11
				_aItem[14] 	:= nVlConta12
			ENDIF
			
			IF MV_PAR08 	== 1 .AND. MV_PAR09 == 1
				_aItem[6]		:= nVlContaTT
			ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 2
				_aItem[9]		:= nVlContaTT
			ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 3
				_aItem[15]		:= nVlContaTT				
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 1
				_aItem[6]		:= (nVlContaTT/3)
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 2
				_aItem[9]		:= (nVlContaTT/6)
			ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 3
				_aItem[15]		:= (nVlContaTT/12)
			ENDIF
			
			AADD(_aIExcel,_aItem)
			_aItem := {}
			
			lOk 			:= .T.
			nVlConta01		:= 0
			nVlConta02		:= 0
			nVlConta03		:= 0
			nVlConta04		:= 0
			nVlConta05		:= 0
			nVlConta06		:= 0
			nVlConta07		:= 0
			nVlConta08		:= 0
			nVlConta09		:= 0
			nVlConta10		:= 0
			nVlConta11		:= 0
			nVlConta12		:= 0
			nVlContaTT		:= 0
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1]	:= ""
			_aItem[2] 	:= ""
			AADD(_aIExcel,_aItem)
			_aItem := {}
						
		ENDIF
		
	ENDDO
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[1]	:= ""
	_aItem[2] 	:= "TOTAL GERAL"
	_aItem[3] 	:= nVlTT01
	_aItem[4] 	:= nVlTT02
	_aItem[5] 	:= nVlTT03
	
	
	IF  MV_PAR09 == 2 .OR. MV_PAR09 == 3
		_aItem[6] 	:= nVlTT04
		_aItem[7] 	:= nVlTT05
		_aItem[8] 	:= nVlTT06
	ENDIF
	
	IF  MV_PAR09 == 3
		_aItem[9] 	:= nVlTT07
		_aItem[10] 	:= nVlTT08
		_aItem[11] 	:= nVlTT09
		_aItem[12] 	:= nVlTT10
		_aItem[13] 	:= nVlTT11
		_aItem[14] 	:= nVlTT12
	ENDIF
	
	IF MV_PAR08 	== 1 .AND. MV_PAR09 == 1
		_aItem[6]		:= nVlContaTT
	ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 2
		_aItem[9]		:= nVlContaTT
	ELSEIF MV_PAR08 == 1 .AND. MV_PAR09 == 3
		_aItem[15]		:= nVlContaTT		
	ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 1
		_aItem[6]		:= (nVlContaTT/3)
	ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 2
		_aItem[9]		:= (nVlContaTT/6)
	ELSEIF MV_PAR08 == 2 .AND. MV_PAR09 == 3
		_aItem[15]		:= (nVlContaTT/12)
	ENDIF
	
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
		Return
	EndIf
	
	//cArq     := _cTemp + ".DBF"
	
	//DbSelectArea("TMP")
	//TMP->(DbCloseArea())
	
	//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")
	
	//oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
	//oExcelApp:SetVisible(.T.)
	
	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "SIG Excel - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","GASTOSCC")
		_lRet := .F.
	ENDIF
	
ENDIF

DbSelectArea("TMPCC")
TMPCC->(DbCloseArea())

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Da  Conta	  		","","","mv_ch01","C",20,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"02","Ate Conta	  		","","","mv_ch02","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"03","Do  C. Custo		","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"04","Ate C. Custo 		","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
Aadd(aRegs,{cPerg,"05","Da  Data			","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Ate Data			","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Tipo do Relatorio	","","","mv_ch07","N",01,0,0,"C","","mv_par07","Planilha","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Imprime Valor		","","","mv_ch08","N",01,0,0,"C","","mv_par08","Total","","","","","Medio","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Periodo				","","","mv_ch09","N",01,0,0,"C","","mv_par09","Trimestral","","","","","Semestral","","","","","Anual","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Tipo da C. Contabil	","","","mv_ch10","N",01,0,0,"C","","mv_par10","SIG","","","","","Normal","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Tipo do C. Custo	","","","mv_ch11","N",01,0,0,"C","","mv_par11","SIG","","","","","Normal","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Filtra CC			","","","mv_ch12","C",25,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"13","Totaliza por     	","","","mv_ch13","N",01,0,0,"C","","mv_par13","C Custo","","","","","Conta","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Da  Conta SIG  		","","","mv_ch14","C",05,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
AADD(aRegs,{cPerg,"15","Ate Conta SIG  		","","","mv_ch15","C",05,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
Aadd(aRegs,{cPerg,"16","Apenas Despesas    	","","","mv_ch16","N",01,0,0,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","",""})

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
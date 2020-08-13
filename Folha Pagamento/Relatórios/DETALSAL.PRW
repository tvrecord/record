#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATECC    บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o total pago ao funcionario					  บฑฑ
ฑฑ          ฑฑ  					   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DETALSAL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       	 := "Cargos e Salarios"
	Local nLin           := 100
	Local cTpVal		 := ""
	Local Cabec1         := ""
	Local Cabec2         := ""
	Local Cabec3         := ""
	Local imprime        := .T.
	Local aOrd := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "DETALSAL" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "DETALSAL" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "DETALS1"
	Private cString      := "SRA"
	Private cQuery       := ""
	Private cQuery1      := ""
	Private nCont		 := 0
	Private cObs		 := ""
	Private lBarra 		 := .F.
	Private _aIExcel 	 := {}


	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAวรO CANCELADA")
		return
	ENDIF

	If MV_PAR07 != 1
		Cabec1         := "Mat.    Nome                                    Admissao    C. Custo                  Fun็ใo                        Sal. Base    Acumulo    Adicional  Gratifica็ใo  H. Extras  Quinquenio    Peric.  Insalubridade  Sal. Tot."
	else
		Cabec1         := "Mat.    Nome                               Admissao    C. Custo                  Fun็ใo              Sal. Base    Acumulo    Adicional  Gratifica็ใo  H. Extras  Dsr. Extra  Quinquenio    Peric.  Insalubridade  Sal. Tot."
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

	//Imprimir relatorio com dados Financeiros ou de Clientes

	cQuery := "SELECT "
	cQuery += "RJ_CODCBO,RA_TPDEFFI,RA_DTVTEST,RA_CATFUNC,RA_CODFUNC,(SELECT MIN(R7_DATA) FROM SR7010 WHERE R7_MAT = RA_MAT AND D_E_L_E_T_ <> '*' AND R7_FUNCAO = RA_CODFUNC) AS DATAFUNC,RA_ADMISSA,RA_NASC, "
	cQuery += "RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEPTO,RA_SINDICA,CTT_DESC01,RJ_DESC,RA_SALARIO,RA_ACFUNC,RA_ACUMULA,RA_CALCADI,RA_GRATFUN,RA_ADTPOSE,RA_HRSMES,RA_HEFIX25,RA_HEFIX50,RA_PERICUL,RA_INSMED,RA_PERCQ "
	cQuery += "FROM SRA010 "
	cQuery += "INNER JOIN CTT010 ON RA_FILIAL = CTT_FILIAL AND RA_CC = CTT_CUSTO "
	cQuery += "INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO "
	cQuery += "WHERE "
	cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
	cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
	cQuery += "CTT010.CTT_CUSTO BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
	cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
	If MV_PAR06 == 2
		cQuery += "SRA010.RA_CATFUNC <> 'E' AND "
	EndIf
	cQuery += "SRJ010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND  "
	cQuery += "CTT010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY CTT_DESC01,RJ_DESC,RA_NOME "


	tcQuery cQuery New Alias "TMP"



	cQuery1 := "SELECT SUBSTRING(RX_TXT,07,6) AS SALMIN FROM SRX010 WHERE "
	cQuery1 += "RX_TIP = '11' AND "
	//cQuery1 += "RX_COD = '" + (TMP->RA_FILIAL + SUBSTR(DTOS(MV_PAR08),1,6) ) + "' AND "
	cQuery1 += "D_E_L_E_T_ <> '*' "

	tcQuery cQuery1 New Alias "TMP1"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		dbSelectArea("TMP1")
		dbCloseArea("TMP1")
		Return
	Endif

	If nLastKey == 27
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		dbSelectArea("TMP1")
		dbCloseArea("TMP1")
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

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
	nAcumulo   		:= 0
	nAdicional		:= 0
	nGratificacao 	:= 0
	nAno  			:= 0
	nPerc			:= 0
	nHorasExtras	:= 0
	nDsrExtra		:= 0
	nQuinquenio		:= 0
	nPericu			:= 0
	nInsalu			:= 0
	nSalTot			:= 0
	nTotSalario			:= 0
	nTotAcumulo   		:= 0
	nTotAdicional		:= 0
	nTotGratifica 	    := 0
	nTotHoraExtra	    := 0
	nTotDsrExtra		:= 0
	nTotQuinquenio		:= 0
	nTotPericu			:= 0
	nTotInsalu			:= 0
	nTotSalTot			:= 0

	cMesSind := ""

	If MV_PAR07 != 1
		// **************************** Cria Arquivo Temporario
		_aCExcel:={}//SPCSQL->(DbStruct())
		aadd( _aCExcel , {"MAT"		    , "C" , 20 , 00 } ) //01
		aadd( _aCExcel , {"NOME"		, "C" , 50 , 00 } ) //02
		aadd( _aCExcel , {"ADMISSA"		, "C" , 10 , 00 } ) //03
		aadd( _aCExcel , {"NASCIMENTO"	, "C" , 10 , 00 } ) //04
		aadd( _aCExcel , {"CCUSTO"		, "C" , 50 , 00 } ) //05
		aadd( _aCExcel , {"FUNCAO"		, "C" , 30 , 00 } ) //06
		aadd( _aCExcel , {"DTFUNCAO"	, "C" , 10 , 00 } ) //07
		aadd( _aCExcel , {"CBO"		    , "C" , 10 , 00 } ) //08
		aadd( _aCExcel , {"SALARIO"		, "N" , 10 , 02 } ) //09
		aadd( _aCExcel , {"ACUMULO"		, "N" , 10 , 02 } ) //10
		aadd( _aCExcel , {"ADICIONAL"	, "N" , 10 , 02 } ) //11
		aadd( _aCExcel , {"GRATIFIC"	, "N" , 10 , 02 } ) //12
		aadd( _aCExcel , {"HEXTRA"		, "N" , 10 , 02 } ) //13
		aadd( _aCExcel , {"QUINQ"		, "N" , 10 , 02 } ) //14
		aadd( _aCExcel , {"PERICU"		, "N" , 10 , 02 } ) //15
		aadd( _aCExcel , {"INSALU"		, "N" , 10 , 02 } ) //16
		aadd( _aCExcel , {"SALTOT"		, "N" , 10 , 02 } ) //17
		aadd( _aCExcel , {"OBS"			, "C" , 70 , 00 } ) //18
		aadd( _aCExcel , {"DEPARTAMENTO", "C" , 15 , 00 } ) //19
		aadd( _aCExcel , {"DESCRICAO"	, "C" , 70 , 00 } ) //20
		aadd( _aCExcel , {"SINDICATO"	, "C" , 05 , 00 } ) //21
		aadd( _aCExcel , {"DESCRICAO"	, "C" , 70 , 00 } ) //22
		aadd( _aCExcel , {"MESDTBASE"	, "C" , 10 , 00 } ) //23
	else
		_aCExcel:={}//SPCSQL->(DbStruct())
		aadd( _aCExcel , {"MAT"		    , "C" , 20 , 00 } ) //01
		aadd( _aCExcel , {"NOME"	    , "C" , 50 , 00 } ) //02
		aadd( _aCExcel , {"ADMISSA"		, "C" , 10 , 00 } ) //03
		aadd( _aCExcel , {"NASCIMENTO"	, "C" , 10 , 00 } ) //04
		aadd( _aCExcel , {"CCUSTO"		, "C" , 50 , 00 } ) //05
		aadd( _aCExcel , {"FUNCAO"		, "C" , 30 , 00 } ) //06
		aadd( _aCExcel , {"DTFUNCAO"	, "C" , 10 , 00 } ) //07
		aadd( _aCExcel , {"CBO"		    , "C" , 10 , 00 } ) //08
		aadd( _aCExcel , {"SALARIO"		, "N" , 10 , 02 } ) //09
		aadd( _aCExcel , {"ACUMULO"		, "N" , 10 , 02 } ) //10
		aadd( _aCExcel , {"ADICIONAL"	, "N" , 10 , 02 } ) //11
		aadd( _aCExcel , {"GRATIFIC"	, "N" , 10 , 02 } ) //12
		aadd( _aCExcel , {"HEXTRA"		, "N" , 10 , 02 } ) //13
		aadd( _aCExcel , {"DSREXTRA"	, "N" , 10 , 02 } ) //14
		aadd( _aCExcel , {"QUINQ"		, "N" , 10 , 02 } ) //15
		aadd( _aCExcel , {"PERICU"		, "N" , 10 , 02 } ) //16
		aadd( _aCExcel , {"INSALU"		, "N" , 10 , 02 } ) //17
		aadd( _aCExcel , {"SALTOT"		, "N" , 10 , 02 } ) //18
		aadd( _aCExcel , {"OBS"			, "C" , 70 , 00 } ) //19
		aadd( _aCExcel , {"DEPARTAMENTO", "C" , 70 , 00 } ) //20
		aadd( _aCExcel , {"DESCRICAO"	, "C" , 70 , 00 } ) //21
		aadd( _aCExcel , {"SINDICATO"	, "C" , 70 , 00 } ) //22
		aadd( _aCExcel , {"DESCRICAO"	, "C" , 70 , 00 } ) //23
		aadd( _aCExcel , {"MESDTBASE"	, "C" , 70 , 00 } ) //24	

	EndIf


	//	_cTemp := CriaTrab(_aCExcel, .T.)
	//	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP2",.F.,.F.)


	DBSelectArea("TMP")
	DBGotop()

	While !EOF()

		SetRegua(RecCount())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		// Calculo do Acumulo de Funcao
		If TMP->RA_ACFUNC == "S" .AND. TMP->RA_ACUMULA == 0
			nAcumulo := TMP->RA_SALARIO * 0.40
		ElseIf TMP->RA_ACFUNC == "N" .AND. TMP->RA_ACUMULA != 0
			nAcumulo := TMP->RA_SALARIO * (TMP->RA_ACUMULA / 100)
		EndIf

		// Calculo do Calculo Adicional
		If TMP->RA_CALCADI == "S"
			nAdicional := TMP->RA_SALARIO * 0.40
		EndIf

		// Calculo de Gratificacao
		If TMP->RA_GRATFUN == "S"
			nGratificacao := TMP->RA_SALARIO * 0.40
		EndIF

		//Calculo de Quinquenio
		If SUBSTR(TMP->RA_ADTPOSE,5,1) ==  "Q"
			/*
			nAno := ROUND(((DATE() - STOD(TMP->RA_ADMISSA)) / 365),1)
			nPerc := nAno / 5
			If nPerc < 10
				nTot := Val(SUBSTR(cValTOChar(nPerc),1,1))
			else
				nTot := Val(SUBSTR(cValTOChar(nPerc),1,2))
			EndIf

			nQuinquenio := TMP->RA_SALARIO * ((nTot * 3)/100)
*/

		nQuinquenio := TMP->RA_SALARIO * TMP->RA_PERCQ / 100
		 
		 EndIf

		//Calculo de Periculosidade

		If !EMPTY(TMP->RA_PERICUL)
			nPericu := TMP->RA_SALARIO * 0.30
		EndIf

		//Calculo de Insalubridade

		If !EMPTY(TMP->RA_INSMED)
			nInsalu := VAL(TMP1->SALMIN) * 0.20
		EndIf



		nSalTot += nAcumulo + nAdicional + nGratificacao + nQuinquenio + nPericu + nInsalu + TMP->RA_SALARIO

		//Calculo Hora Extra
		If TMP->RA_HEFIX25="S"
			nHorasExtras:=(((nSalTot/TMP->RA_HRSMES) * 1.7)*25)
			nDsrExtra := ((nHorasExtras/25)*5)
		Endif
		
		If TMP->RA_HEFIX50="S"
			nHorasExtras:=(((nSalTot/TMP->RA_HRSMES) * 1.7)*50)
			nDsrExtra := ((nHorasExtras/50)*5)
		Endif

		cObs 	:= ""
		lBarra 	:= .F.

		If !EMPTY(TMP->RA_TPDEFFI) .AND. TMP->RA_TPDEFFI != "0"
			cObs := "PPD"
			lBarra := .T.
		ELSEIF !EMPTY(TMP->RA_DTVTEST)
			If lBarra == .T.
				cObs += " / "
			endIf
			cObs += "ESTABILIDADE"
			lBarra := .T.
		ELSEIF TMP->RA_CATFUNC == "E"
			If lBarra == .T.
				cObs += " / "
			EndIf
			cObs += "ESTAGIARIO"
			lBarra := .T.
		ELSEIF TMP->RA_CATFUNC == "P"
			If lBarra == .T.
				cObs += " / "
			EndIf
			cObs += "PRO LABORE"
			lBarra := .T.
		ELSEIF TMP->RA_CODFUNC == "00098"
			If lBarra == .T.
				cObs += " / "
			EndIf
			cObs += "APRENDIZ"
			lBarra := .T.
		EndIf

		//Localiza Afastamento no periodo
		DBSelectARea("SR8")
		DBSetOrder(1)
		iF (DBSeek(TMP->RA_FILIAL + TMP->RA_MAT))


			// Localiza o periodo das f้rias no pagamento do vale transporte

			While !EOF() .AND. TMP->RA_MAT == SR8->R8_MAT



				If (SR8->R8_TIPO != "001" .AND. MV_PAR08 >= SR8->R8_DATAINI .AND. MV_PAR08 <= SR8->R8_DATAFIM) .OR. EMPTY(SR8->R8_DATAFIM)

					If lBarra == .T.
						cObs += " / "
					EndIf

					cObs += Posicione("SX5",1,xFilial("SX5") + "30" + SR8->R8_TIPO,"X5_DESCRI")

				EndIf

				Dbskip()

			EndDo

		EndIf

		//Mes de pagamento do Sindicato

		If MV_PAR07 != 1

			If Alltrim(TMP->RA_SINDICA) == "01"
				cMesSind := "10"
			ElseIf Alltrim(TMP->RA_SINDICA) == "02"
				cMesSind := "4"
			Else
				cMesSind := ""
			EndIf

			nSalTot += nHorasExtras

			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= Alltrim(TMP->RA_MAT)
			_aItem[02]		:= TMP->RA_NOME
			_aItem[03]		:= DTOC(STOD(TMP->RA_ADMISSA))
			_aItem[04]		:= DTOC(STOD(TMP->RA_NASC))
			_aItem[05]		:= TMP->CTT_DESC01
			_aItem[06]		:= TMP->RJ_DESC
			If EMPTY(TMP->DATAFUNC)
				_aItem[07]		:= DTOC(STOD(TMP->RA_ADMISSA))
			Else
				_aItem[07]		:= DTOC(STOD(TMP->DATAFUNC))
			Endif
			_aItem[08]		:= TMP->RJ_CODCBO
			_aItem[09]		:= TMP->RA_SALARIO
			_aItem[10]		:= nAcumulo
			_aItem[11]		:= nAdicional
			_aItem[12]		:= nGratificacao
			_aItem[13]		:= nHorasExtras
			_aItem[14]		:= nQuinquenio
			_aItem[15]		:= nPericu
			_aItem[16]		:= nInsalu
			_aItem[17]		:= nSalTot
			_aItem[18]		:= cObs
			_aItem[19]		:= Alltrim(TMP->RA_DEPTO)
			_aItem[20]		:= Posicione("SQB",1,xFilial("SQB") + TMP->RA_DEPTO,"QB_DESCRIC")
			_aItem[21]		:= Alltrim(TMP->RA_SINDICA)
			_aItem[22]		:= Posicione("RCE",1,xFilial("RCE") + TMP->RA_SINDICA,"RCE_DESCRI")
			_aItem[23]		:= cMesSind


			AADD(_aIExcel,_aItem)
			_aItem := {}

			/*
			@nLin, 000 PSAY Alltrim(TMP->RA_MAT)
			@nLin, 008 PSAY SUBSTR(TMP->RA_NOME,1,38)
			@nLin, 048 PSAY STOD(TMP->RA_ADMISSA)
			@nLin, 060 PSAY SUBSTR(TMP->CTT_DESC01,1,20)
			@nLin, 082 PSAY SUBSTR(TMP->RJ_DESC,1,20)
			@nLin, 114 PSAY TMP->RA_SALARIO	PICTURE "@E 999,999.99"
			@nLin, 126 PSAY nAcumulo   		PICTURE "@E 999,999.99"
			@nLin, 138 PSAY nAdicional		PICTURE "@E 999,999.99"
			@nLin, 150 PSAY nGratificacao 	PICTURE "@E 999,999.99"
			@nLin, 162 PSAY nHorasExtras	PICTURE "@E 999,999.99"
			@nLin, 174 PSAY nQuinquenio		PICTURE "@E 999,999.99"
			@nLin, 186 PSAY nPericu			PICTURE "@E 999,999.99"
			@nLin, 198 PSAY nInsalu			PICTURE "@E 999,999.99"
			@nLin, 210 PSAY nSalTot			PICTURE "@E 999,999.99"
			*/

		else

			nSalTot += nHorasExtras + nDsrExtra

			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]			:= Alltrim(TMP->RA_MAT)
			_aItem[02]			:= TMP->RA_NOME
			_aItem[03]		:= DTOC(STOD(TMP->RA_ADMISSA))
			_aItem[04]		:= DTOC(STOD(TMP->RA_NASC))
			_aItem[05]		:= TMP->CTT_DESC01
			_aItem[06]		:= TMP->RJ_DESC
			If EMPTY(TMP->DATAFUNC)
				_aItem[07]		:= DTOC(STOD(TMP->RA_ADMISSA))
			Else
				_aItem[07]		:= DTOC(STOD(TMP->DATAFUNC))
			Endif
			_aItem[08]			:= TMP->RJ_CODCBO
			_aItem[09]		:= TMP->RA_SALARIO
			_aItem[10]		:= nAcumulo
			_aItem[11]		:= nAdicional
			_aItem[12]		:= nGratificacao
			_aItem[13]		:= nHorasExtras
			_aItem[14]		:= nDsrExtra
			_aItem[15]		:= nQuinquenio
			_aItem[16]		:= nPericu
			_aItem[17]		:= nInsalu
			_aItem[18]		:= nSalTot
			_aItem[19]		:= cObs
			_aItem[20]		:= TMP->RA_DEPTO
			_aItem[21]		:= Posicione("SQB",1,xFilial("SQB") + TMP->RA_DEPTO,"QB_DESCRIC")
			_aItem[22]		:= TMP->RA_SINDICA
			_aItem[23]		:= Posicione("RCE",1,xFilial("RCE") + TMP->RA_SINDICA,"RCE_DESCRI")
			_aItem[24]		:= cMesSind
			AADD(_aIExcel,_aItem)
			_aItem := {}

			/*
			@nLin, 000 PSAY Alltrim(TMP->RA_MAT)
			@nLin, 008 PSAY SUBSTR(TMP->RA_NOME,1,33)
			@nLin, 043 PSAY STOD(TMP->RA_ADMISSA)
			@nLin, 055 PSAY SUBSTR(TMP->CTT_DESC01,1,20)
			@nLin, 077 PSAY SUBSTR(TMP->RJ_DESC,1,20)
			@nLin, 099 PSAY TMP->RA_SALARIO	PICTURE "@E 999,999.99"
			@nLin, 111 PSAY nAcumulo   		PICTURE "@E 999,999.99"
			@nLin, 123 PSAY nAdicional		PICTURE "@E 999,999.99"
			@nLin, 135 PSAY nGratificacao 	PICTURE "@E 999,999.99"
			@nLin, 147 PSAY nHorasExtras	PICTURE "@E 999,999.99"
			@nLin, 159 PSAY nDsrExtra		PICTURE "@E 999,999.99"
			@nLin, 171 PSAY nQuinquenio		PICTURE "@E 999,999.99"
			@nLin, 183 PSAY nPericu			PICTURE "@E 999,999.99"
			@nLin, 195 PSAY nInsalu			PICTURE "@E 999,999.99"
			@nLin, 207 PSAY nSalTot			PICTURE "@E 999,999.99"
			*/

		EndIf


		// Soma dos Totalizadores
		nTotSalario			+= TMP->RA_SALARIO
		nTotAcumulo   		+= nAcumulo
		nTotAdicional		+= nAdicional
		nTotGratifica 	    += nGratificacao
		nTotHoraExtra	    += nHorasExtras
		nTotQuinquenio		+= nQuinquenio
		nTotInsalu			+= nInsalu
		nTotPericu			+= nPericu
		nTotSalTot			+= nSalTot
		nTotDsrExta			+= nDsrExtra


		dbselectARea("TMP")
		dbskip()

		nAcumulo   		:= 0
		nAdicional		:= 0
		nGratificacao 	:= 0
		nAno  			:= 0
		nPerc			:= 0
		nHorasExtras	:= 0
		nQuinquenio		:= 0
		nPericu			:= 0
		nInsalu			:= 0
		nSalTot			:= 0
		nDrsExtra		:= 0

		nLin 			+= 1 // Avanca a linha de impressao
		nCont			+= 1


	ENDDO


	//Impressใo dos totalizadores

	If MV_PAR07 != 1

		_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
		_aItem := {}

		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]			:= "Qtd. Funcionarios:"
		_aItem[02]			:= cValToChar(nCont)
		_aItem[09]		:= nTotSalario
		_aItem[10]		:= nTotAcumulo
		_aItem[11]		:= nTotAdicional
		_aItem[12]		:= nTotGratifica
		_aItem[13]		:= nTotHoraExtra
		_aItem[14]		:= nTotQuinquenio
		_aItem[15]		:= nTotPericu
		_aItem[16]		:= nTotInsalu
		_aItem[17]		:= nTotSalTot
		AADD(_aIExcel,_aItem)
		_aItem := {}


		/*

		@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		nLin 			+= 1 // Avanca a linha de impressao

		@nLin, 000 PSAY "Qtd. Funcionarios: "
		@nLin, 019 PSAY nCont
		@nLin, 114 PSAY nTotSalario			PICTURE "@E 999,999.99"
		@nLin, 126 PSAY nTotAcumulo 		PICTURE "@E 999,999.99"
		@nLin, 138 PSAY nTotAdicional		PICTURE "@E 999,999.99"
		@nLin, 150 PSAY nTotGratifica 	    PICTURE "@E 999,999.99"
		@nLin, 162 PSAY nTotHoraExtra	    PICTURE "@E 999,999.99"
		@nLin, 174 PSAY nTotQuinquenio		PICTURE "@E 999,999.99"
		@nLin, 186 PSAY nTotPericu			PICTURE "@E 999,999.99"
		@nLin, 198 PSAY nTotInsalu			PICTURE "@E 999,999.99"
		@nLin, 210 PSAY nTotSalTot			PICTURE "@E 999,999.99"

		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

		*/

	Else

		_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
		_aItem := {}


		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= "Qtd. Funcionarios:"
		_aItem[02]		:= cValToChar(nCont)
		_aItem[09]		:= nTotSalario
		_aItem[10]		:= nTotAcumulo
		_aItem[11]		:= nTotAdicional
		_aItem[12]		:= nTotGratifica
		_aItem[13]		:= nTotHoraExtra
		_aItem[14]		:= nTotDsrExta
		_aItem[15]		:= nTotQuinquenio
		_aItem[16]		:= nTotPericu
		_aItem[17]		:= nTotInsalu
		_aItem[18]		:= nTotSalTot
		AADD(_aIExcel,_aItem)
		_aItem := {}

		/*

		@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		nLin 			+= 1 // Avanca a linha de impressao

		@nLin, 000 PSAY "Qtd. Funcionarios: "
		@nLin, 019 PSAY nCont
		@nLin, 099 PSAY nTotSalario			PICTURE "@E 999,999.99"
		@nLin, 111 PSAY nTotAcumulo 		PICTURE "@E 999,999.99"
		@nLin, 123 PSAY nTotAdicional		PICTURE "@E 999,999.99"
		@nLin, 135 PSAY nTotGratifica 	    PICTURE "@E 999,999.99"
		@nLin, 147 PSAY nTotHoraExtra	    PICTURE "@E 999,999.99"
		@nLin, 159 PSAY nDsrExtra			PICTURE "@E 999,999.99"
		@nLin, 171 PSAY nTotQuinquenio		PICTURE "@E 999,999.99"
		@nLin, 183 PSAY nTotPericu			PICTURE "@E 999,999.99"
		@nLin, 195 PSAY nTotInsalu			PICTURE "@E 999,999.99"
		@nLin, 207 PSAY nTotSalTot			PICTURE "@E 999,999.99"


		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		*/

	EndIf


	//	If !ApOleClient("MsExcel")
	//		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	//	Return
	//	EndIf

	//	cArq     := _cTemp+".DBF"
	//	DBSelectArea("TMP2")
	//	DBCloseARea("TMP2")
	DBSelectArea("TMP1")
	DBCloseARea("TMP1")
	DBSelectArea("TMP")
	DBCloseARea("TMP")
	DBSelectArea("SR8")
	DBCloseARea("SR8")


	//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

	//oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
	//oExcelApp:SetVisible(.T.)

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Realizado Pagar - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","REALIZADO")
		_lRet := .F.
	ENDIF

Return


/*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
dbCommitAll()
SET PRINTER TO
OurSpool(wnrel)
Endif

MS_FLUSH()

dbSelectArea("TMP")
dbCloseArea("TMP")
dbSelectArea("TMP1")
dbCloseArea("TMP1")

Return

*/


Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Filial ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Matricula De ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"03","Matricula Ate ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"04","C. Custo De ?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"05","C. Custo Ate ?","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"06","Estagiario(a) ?","","","mv_ch06","N",01,0,2,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Calcula DSR ?","","","mv_ch07","N",01,0,2,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Dt Referencia    ","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


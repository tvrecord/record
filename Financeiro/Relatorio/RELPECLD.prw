#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 RELPECLD : Autor 3 Rafael França      : Data 3  06/05/2019 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Provisão de perdas estimadas                               :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Auditoria                                                  :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function RELPECLD

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := ""
	Local cPict        := ""
	Local titulo       := "Provisão de perdas estimadas"
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
	Private nomeprog   := "RELPECLD"
	Private nTipo      := 18
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := ""
	Private cPerg      := "RELPECLD7"
	Private cString    := "SE1"
	Private cQuery     := ""
	Private _aIExcel 	 := {}

	ValidPerg(cPerg)

	Pergunte(cPerg,.T.)

	titulo       := "PECLD " + ALLTRIM(MV_PAR05)

	IF MV_PAR02 == 1
		titulo       += " - E. PRIVADAS"
	ELSEIF MV_PAR02 == 2
		titulo       += " - GOVERNO"
	ELSEIF MV_PAR02 == 3
		titulo       += " - PERMUTA / OUTROS"
	ELSEIF MV_PAR02 == 4
		titulo       += " - GERAL"
	ENDIF

	IF MV_PAR01 == 1
		titulo       += " - INADIMPLÊNCIA"
	ELSEIF MV_PAR01 == 2
		titulo       += " - RECEBIMENTO"
	ELSEIF MV_PAR01 == 3
		titulo       += " - ANALITICO"
	ENDIF

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

	Local cQuery	:= ""
	Local aRegistro := {}
	Local nLin		:= 0
	Local nLinT		:= 1
	Local nCol		:= 0
	Local nColA		:= 0
	Local nColF		:= 0
	Local cCol  	:= ""
	Local cCol1  	:= ""
	Local nDAtraso  := 0
	Local cFiltro   := ""
	Local nTotal 	:= 0
	Local nPerc		:= 0
	Local cMes		:= "01"
	Local nTotMes	:= 0
	Local nTot1		:= 0
	Local nTotGer	:= 0
	Local nSaldo 	:= 0
	Local nVlBx 	:= 0
	Local cTipo 	:= ""
	Local dBaixa	:= CTOD("//")

	// Filtro para as querys
	cFiltro := "WHERE SE1010.D_E_L_E_T_ = '' AND SUBSTRING(E1_VENCREA,1,4) IN " + FormatIn(ALLTRIM(MV_PAR05),"/") + " "
	cFiltro	+= "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-','RA') AND E1_PREFIXO NOT IN ('MAX') "
	IF MV_PAR01 <> 3
		IF MV_PAR02 == 1  //06/05/19 - Rafael França - Colocado para atender a solicitação de SP no relatorio Aging List. O objetivo da mudança é separar os titulos do governo dos demais.
			cFiltro += "AND E1_NATUREZ NOT IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049','1101048','1101046','1101013','1101006',1101007,'1101008','1101042','1101050') "
		ELSEIF MV_PAR02 == 2
			cFiltro += "AND E1_NATUREZ IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049','1101048','1101046','1101013') "
		ELSEIF MV_PAR02 == 3
			cFiltro += "AND E1_NATUREZ IN ('1101006',1101007,'1101008','1101042','1101050') "
		END
	ENDIF

	IF MV_PAR01 == 1

		nCol		:= MV_PAR03

		// **************************** Cria Arquivo Temporario
		_aCExcel:={}//TMP1->(DbStruct())
		aadd( _aCExcel , {"MES"      	    , "C" , 08 , 00 }) //01
		aadd( _aCExcel , {"DESCRICAO"       , "C" , 12 , 00 }) //02
		aadd( _aCExcel , {"TOTAL"  			, "N" , 12 , 02 }) //03
		aadd( _aCExcel , {"DENTROMES"  		, "N" , 12 , 02 }) //04
		aadd( _aCExcel , {"%DENTROMES"  	, "N" , 05 , 02 }) //05

		WHILE nCol <= MV_PAR04 //Verifica a quantidade de colunas necessarias ate o limite

			cCol 	:= STRZERO(nCol,4) + "_DFM"
			cCol1 	:= "%_" + STRZERO(nCol,4) + "_DFM"

			aadd( _aCExcel , {cCol	   		, "N" , 12,  02 })
			aadd( _aCExcel , {cCol1	   		, "N" , 05,  02 })

			nColF		+= 1
			nCol 		+= MV_PAR03

		ENDDO

		// TMP1 - Separa os meses e totais do relatorio, para ciar as tres primeiras colunas

		cQuery := "SELECT SUBSTRING(E1_VENCREA,1,6) AS MES, SUM(E1_VALOR) AS VALOR "
		cQuery += "FROM SE1010 "
		cQuery += cFiltro
		cQuery += "GROUP BY SUBSTRING(E1_VENCREA,1,6)"
		cQuery += "ORDER BY SUBSTRING(E1_VENCREA,1,6)"

		TCQUERY cQuery NEW ALIAS "TMP1"

		If Eof()  //Verifica se tem dados
			MsgInfo("Nao existem dados a serem impressos!","Verifique")
			dbSelectArea("TMP1")
			dbCloseArea("TMP1")
			Return
		Endif

		DbSelectArea("TMP1")
		DBGotop()

		//Adciona os meses no vetor

		While !TMP1->(EOF())
			aAdd(aRegistro,{TMP1->MES,;
				UPPER(MesExtenso(VAL(SUBSTR(TMP1->MES,5,2)))),;
				TMP1->VALOR,;
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})

			nLinT 	+= 1
			nTotal 	+= TMP1->VALOR

			DbSelectArea("TMP1")
			DBSkip()
		ENDDO

		aAdd(aRegistro,{STRZERO(MV_PAR05,4),;
			"TOTAL",;
			nTotal,;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})

		DbSelectArea("TMP1")
		dbCloseArea("TMP1")

		//TMP2 - Separa os registros para analisar a quantidade de dias de atraso e qual coluna ira cair. Usa o mesmo filtro da TMP1

		cQuery := "SELECT SUBSTRING(E1_VENCREA,1,6) AS MES, E1_VENCREA AS VENCREAL, E1_BAIXA AS BAIXA, E1_VALOR AS VALOR "
		cQuery += ",(E1_CLIENTE + ' - ' + E1_NOMCLI) AS CLIENTE,(E1_PREFIXO + '-' + SUBSTRING(E1_NUM,1,6) + '-' + E1_PARCELA) AS TITULO,E1_EMISSAO AS EMISSAO "
		cQuery += ",E1_SALDO AS SALDO "
		cQuery += "FROM SE1010 "
		cQuery += cFiltro
		cQuery += "ORDER BY SUBSTRING(E1_VENCREA,1,6),E1_BAIXA"

		TCQUERY cQuery NEW ALIAS "TMP2"

		DbSelectArea("TMP2")
		TMP2->(DbGoTop())

		While TMP2->(!Eof())

			nLin 	:= aScan(aRegistro, { |x| x[1] == TMP2->MES})
			nTotMes := aRegistro[nLin][3]

			nDAtraso  	:= STOD(TMP2->BAIXA) - LastDate(STOD(TMP2->VENCREAL))

			IF nDAtraso <= 0
				nCol 	:= 4 // Dentro do mes
				aRegistro[nLin][nCol] 	+= TMP2->VALOR // Soma o valor na coluna e linha corretas
				aRegistro[nLinT][nCol] 	+= TMP2->VALOR // Soma o valor na coluna e linha corretas
				nTot1 	+= TMP2->VALOR
			ELSEIF nDAtraso > MV_PAR04
				nTot1 	+= TMP2->VALOR
			ELSE
				nCol	:= NOROUND(nDAtraso / MV_PAR03,0) + 6
				aRegistro[nLin][nCol] 	+= TMP2->VALOR // Soma o valor na coluna e linha corretas
				aRegistro[nLinT][nCol] 	+= TMP2->VALOR // Soma o valor na coluna e linha corretas
				nTot1 	+= TMP2->VALOR
			ENDIF

			cMes 		:= SUBSTR(TMP2->MES,5,2)

			DbSelectArea("TMP2")
			TMP2->(DbSkip())

			IF cMes <> SUBSTR(TMP2->MES,5,2) .OR. TMP2->(Eof())
				nCol 		:= nColF + 6
				aRegistro[nLin][nCol] := nTotMes - nTot1
				nTot1		:= 0
				nTotMes 	:= 0
			ENDIF

		Enddo

		DbSelectArea("TMP2")
		dbCloseArea("TMP2")

		For i:=1 to Len(aRegistro)

			nCol 	:= 0
			nTotMes := 0

			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]			:= aRegistro[i][1]
			_aItem[02]			:= aRegistro[i][2]
			_aItem[03]      	:= aRegistro[i][3]
			nTotMes := (aRegistro[i][3]-aRegistro[i][4])
			_aItem[04]        	:= nTotMes
			_aItem[05]        	:= 0	 //Verifica a % em relação ao ultimo perido MV_PAR04
			While nCol < nColF
				nTotMes -= aRegistro[i][nCol+6]
				_aItem[(nCol*2) + 6]	:= nTotMes
				_aItem[(nCol*2) + 7]	:= 0	 //Verifica a % em relação ao ultimo perido MV_PAR04
				nCol += 1
			EndDo
			AADD(_aIExcel,_aItem)
			_aItem := {}

		Next

	ELSEIF MV_PAR01 == 2 // Recebimento

		nCol		:= MV_PAR03

		// **************************** Cria Arquivo Temporario
		_aCExcel:={}//TMP1->(DbStruct())
		aadd( _aCExcel , {"MES"      	    , "C" , 08 , 00 }) //01
		aadd( _aCExcel , {"DESCRICAO"       , "C" , 12 , 00 }) //02
		aadd( _aCExcel , {"DENTROMES"  		, "N" , 12 , 02 }) //03

		WHILE nCol <= MV_PAR04 //Verifica a quantidade de colunas necessarias ate o limite

			cCol 	:= STRZERO(nCol,4) + "_DFM"

			aadd( _aCExcel , {cCol	   		, "N" , 12,  02 })

			nColF		+= 1
			nColA		+= 1
			nCol 		+= MV_PAR03

		ENDDO

		nColA		+= 1
		cCol 	:= "MAISDE_" + STRZERO(MV_PAR04,3)

		//Mais que o limite e tirulos em aberto

		aadd( _aCExcel , {cCol 			, "N" , 12 , 02 }) //nColF
		aadd( _aCExcel , {"ARECEBER"    , "N" , 12 , 02 }) //nColA
		aadd( _aCExcel , {"TOTAL"       , "N" , 12 , 02 }) //nColA + 1

		// TMP1 - Separa os meses e totais do relatorio, para ciar as tres primeiras colunas

		cQuery := "SELECT SUBSTRING(E1_VENCREA,1,6) AS MES, SUM(E1_VALOR) AS VALOR "
		cQuery += "FROM SE1010 "
		cQuery += cFiltro
		cQuery += "GROUP BY SUBSTRING(E1_VENCREA,1,6)"
		cQuery += "ORDER BY SUBSTRING(E1_VENCREA,1,6)"

		TCQUERY cQuery NEW ALIAS "TMP1"

		If Eof()  //Verifica se tem dados
			MsgInfo("Nao existem dados a serem impressos!","Verifique")
			dbSelectArea("TMP1")
			dbCloseArea("TMP1")
			Return
		Endif

		DbSelectArea("TMP1")
		DBGotop()

		//Adciona os meses no vetor

		While !TMP1->(EOF())

			aAdd(aRegistro,{TMP1->MES,;
				UPPER(MesExtenso(VAL(SUBSTR(TMP1->MES,5,2)))),;
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
			nLinT += 1

			DbSelectArea("TMP1")
			DBSkip()
		ENDDO

		aAdd(aRegistro,{STRZERO(MV_PAR05,4),;
			"TOTAL",;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})

		aAdd(aRegistro,{STRZERO(MV_PAR05,4),;
			"PERCENTUAL",;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})

		DbSelectArea("TMP1")
		dbCloseArea("TMP1")

		//TMP2 - Separa os registros para analisar a quantidade de dias de atraso e qual coluna ira cair. Usa o mesmo filtro da TMP1

		cQuery := "SELECT SUBSTRING(E1_VENCREA,1,6) AS MES, E1_VENCREA AS VENCREAL, E1_BAIXA AS BAIXA, E1_VALOR AS VALOR "
		cQuery += ",(E1_CLIENTE + ' - ' + E1_NOMCLI) AS CLIENTE,(E1_PREFIXO + '-' + SUBSTRING(E1_NUM,1,6) + '-' + E1_PARCELA) AS TITULO,E1_EMISSAO AS EMISSAO "
		cQuery += ",E1_SALDO AS SALDO "
		cQuery += "FROM SE1010 "
		cQuery += cFiltro
		cQuery += "ORDER BY SUBSTRING(E1_VENCREA,1,6),E1_BAIXA"

		TCQUERY cQuery NEW ALIAS "TMP2"

		DbSelectArea("TMP2")
		TMP2->(DbGoTop())

		While TMP2->(!Eof())

			IF !EMPTY((TMP2->BAIXA)) // Processo para verificar qual a coluna
				nDAtraso  	:= STOD(TMP2->BAIXA) - LastDate(STOD(TMP2->VENCREAL))
				IF nDAtraso <= 0
					nCol 	:= 3 // Dentro do mes
				ELSE
					IF nDAtraso <= MV_PAR04
						nCol	:= NOROUND(nDAtraso / MV_PAR03,0) + 4
					ELSE
						nCol	:= nColF + 4
					ENDIF
				ENDIF
			ELSE
				nCol 		:= nColA + 4
			ENDIF

			nLin := aScan(aRegistro, { |x| x[1] == TMP2->MES})

			aRegistro[nLin][nCol] 		+= TMP2->VALOR // Soma o valor na coluna e linha corretas
			aRegistro[nLinT][nCol] 		+= TMP2->VALOR
			aRegistro[nLinT+1][nCol] 	+= TMP2->VALOR

			nTotGer += TMP2->VALOR
			nTotMes += TMP2->VALOR
			cMes 	:= SUBSTR(TMP2->MES,5,2)

			DbSelectArea("TMP2")
			TMP2->(DbSkip())

			IF cMes <> SUBSTR(TMP2->MES,5,2) .OR. TMP2->(Eof())
				nCol 		:= nColA + 5
				aRegistro[nLin][nCol] 		:= nTotMes
				aRegistro[nLin + 1][nCol] 	:= nTotMes
				nTotMes := 0
			ENDIF

		Enddo

		DbSelectArea("TMP2")
		dbCloseArea("TMP2")

		For i:=1 to Len(aRegistro)

			nCol := 0

			IF aRegistro[i][2] <> "PERCENTUAL" .AND. aRegistro[i][2] <> "TOTAL"

				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[01]			:= aRegistro[i][1]
				_aItem[02]			:= aRegistro[i][2]
				_aItem[03]        	:= aRegistro[i][3]
				While nCol < nColF
					_aItem[(nCol) + 4]	:= aRegistro[i][nCol + 4]
					nCol += 1
				EndDo
				_aItem[(nColF)+4]       := aRegistro[i][nColF+4]
				_aItem[(nColA)+4]       := aRegistro[i][nColA+4]
				_aItem[(nColA)+5]       := aRegistro[i][nColA+5]
				AADD(_aIExcel,_aItem)
				_aItem := {}

			ELSEIF aRegistro[i][2] == "TOTAL"

				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[01]			:= aRegistro[i][1]
				_aItem[02]			:= aRegistro[i][2]
				_aItem[03]        	:= aRegistro[i][3]
				While nCol < nColF
					_aItem[(nCol) + 4]	:= aRegistro[i][nCol + 4]
					nCol += 1
				EndDo
				_aItem[(nColF)+4]       := aRegistro[i][nColF+4]
				_aItem[(nColA)+4]       := aRegistro[i][nColA+4]
				_aItem[(nColA)+5]       := nTotGer
				AADD(_aIExcel,_aItem)
				_aItem := {}

			ELSEIF aRegistro[i][2] == "PERCENTUAL"

				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[01]			:= aRegistro[i][1]
				_aItem[02]			:= aRegistro[i][2]
				_aItem[03]        	:= ROUND(((aRegistro[i][3]) / nTotGer) * 100,2)
				While nCol < nColF
					_aItem[(nCol) + 4]	:= ROUND(((aRegistro[i][nCol + 4]) / nTotGer) * 100,2)
					nCol += 1
				EndDo
				_aItem[(nColF)+4]       := ROUND(((aRegistro[i][nColF+4]) / nTotGer) * 100,2)
				_aItem[(nColA)+4]       := ROUND(((aRegistro[i][nColA+4]) / nTotGer) * 100,2)
				_aItem[(nColA)+5]       := 100
				AADD(_aIExcel,_aItem)
				_aItem := {}

			ENDIF

		Next

	ELSEIF MV_PAR01 == 3

		_aCExcel:={}//TMP1->(DbStruct())
		aadd( _aCExcel , {"TIPO"			, "C" , 10 , 00 }) //01
		aadd( _aCExcel , {"VENCIMENTO"		, "D" , 10 , 00 }) //02
		aadd( _aCExcel , {"ULTIMODIA"		, "D" , 10 , 00 }) //03
		aadd( _aCExcel , {"ANO"      	    , "C" , 04 , 00 }) //04
		aadd( _aCExcel , {"MES"      	    , "C" , 02 , 00 }) //05
		aadd( _aCExcel , {"DESCRICAO"       , "C" , 12 , 00 }) //06
		aadd( _aCExcel , {"BAIXA"			, "D" , 10 , 00 }) //07
		aadd( _aCExcel , {"ANOBX"			, "C" , 04 , 00 }) //08
		aadd( _aCExcel , {"MESBX"			, "C" , 02 , 00 }) //09
		aadd( _aCExcel , {"DESCRI BX"		, "C" , 12 , 00 }) //10
		aadd( _aCExcel , {"STATUS" 			, "C" , 01 , 00 }) //11
		aadd( _aCExcel , {"LEGENDA"  		, "C" , 12 , 00 }) //12
		aadd( _aCExcel , {"DFM"  			, "N" , 04 , 00 }) //13
		aadd( _aCExcel , {"VALOR"  			, "N" , 12 , 02 }) //14
		aadd( _aCExcel , {"VLLIQUIDO"		, "N" , 12 , 02 }) //15
		aadd( _aCExcel , {"VLBAIXADO"		, "N" , 12 , 02 }) //16
		aadd( _aCExcel , {"CLIENTE"       	, "C" , 25 , 00 }) //17
		aadd( _aCExcel , {"NATUREZA"   		, "C" , 20 , 00 }) //18
		aadd( _aCExcel , {"EMISSAO"			, "D" , 10 , 00 }) //19
		aadd( _aCExcel , {"TITULO"			, "C" , 15 , 00 }) //20
		aadd( _aCExcel , {"REFERENCIA"		, "D" , 10 , 00 }) //21
		aadd( _aCExcel , {"CLASSIFICACAO"	, "C" , 12 , 00 }) //22
		aadd( _aCExcel , {"FILIAL"			, "C" , 12 , 00 }) //23
		aadd( _aCExcel , {"HISTORICO"		, "C" , 50 , 00 }) //24

		//TMP2 - Separa os registros para analisar a quantidade de dias de atraso e qual coluna ira cair. Usa o mesmo filtro da TMP1

		cQuery := "SELECT SUBSTRING(E1_VENCREA,1,4) AS ANO, SUBSTRING(E1_VENCREA,5,2) AS MES, E1_VENCREA AS VENCREAL, E1_BAIXA AS BAIXA, E1_VALOR AS VALOR "
		cQuery += ",(E1_CLIENTE + ' - ' + E1_NOMCLI) AS CLIENTE,(E1_PREFIXO + '-' + SUBSTRING(E1_NUM,1,6) + '-' + E1_PARCELA + '-' + E1_TIPO) AS TITULO, E1_EMISSAO AS EMISSAO "
		cQuery += ",ED_DESCRIC AS NATUREZA"
		cQuery += ",E1_FILIAL AS FILIAL, E1_PREFIXO AS PREFIXO, E1_NUM AS NUMERO, E1_PARCELA AS PARCELA, E1_TIPO AS TIPO"
		cQuery += ",E1_VALOR AS VALOR "
		cQuery += ",E1_VALOR - E1_IRRF - E1_ISS - E1_INSS - E1_CSLL - E1_COFINS - E1_PIS AS VLLIQUI "
		cQuery += ",E1_SALDO AS SALDO "
		cQuery += ",E1_PORTADO AS CLASSIF "
		cQuery += ",E1_HIST AS HIST "
		cQuery += ",CASE E1_FILIAL "
		cQuery += "WHEN '01' THEN 'MATRIZ' "
		cQuery += "WHEN '05' THEN 'RADIO' "
		cQuery += "ELSE 'SEM FILIAL' END AS FILIAL1 "
		cQuery += ",CASE "
		cQuery += "WHEN E1_NATUREZ NOT IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049','1101048','1101006',1101007,'1101008','1101042','1101050','1101046','1101013') THEN 'PRIVADO' "
		cQuery += "WHEN E1_NATUREZ IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049','1101048','1101046','1101013') THEN 'GOVERNO' "
		cQuery += "WHEN E1_NATUREZ IN ('1101006',1101007,'1101008','1101042','1101050') THEN 'PER / PART' "
		cQuery += "ELSE '' END AS TIPO1 "
		cQuery += "FROM SE1010 "
		cQuery += "INNER JOIN SED010 ON "
		cQuery += "E1_NATUREZ = ED_CODIGO "
		cQuery += cFiltro
		cQuery += "AND SED010.D_E_L_E_T_ = '' "
		cQuery += "ORDER BY E1_VENCREA,E1_BAIXA "

		TCQUERY cQuery NEW ALIAS "TMP2"

		DbSelectArea("TMP2")
		TMP2->(DbGoTop())

		While TMP2->(!Eof())

			nSaldo := 0
			nDAtraso  	:= IIF(EMPTY(TMP2->BAIXA) .OR. STOD(TMP2->BAIXA) > MV_PAR06,9999,STOD(TMP2->BAIXA) - LastDate(STOD(TMP2->VENCREAL)))

			IF STOD(TMP2->BAIXA) > MV_PAR06 .AND. !EMPTY(TMP2->BAIXA) .OR. TMP2->SALDO > 0 .AND. STOD(TMP2->BAIXA) < MV_PAR06 .AND. !EMPTY(TMP2->BAIXA)// Verifica se a baixa do titulo foi depois da data de referencia.

				DbSelectArea("SE1")
				DbSetOrder(1)
				DbSeek(TMP2->FILIAL + TMP2->PREFIXO + TMP2->NUMERO + TMP2->PARCELA + TMP2->TIPO)

				nSaldo 		:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,MV_PAR06,MV_PAR06,SE1->E1_LOJA,SE1->E1_FILIAL)
				nVlBx 		:= TMP2->VLLIQUI - nSaldo

			ELSEIF STOD(TMP2->BAIXA) <= MV_PAR06 .AND. !EMPTY(TMP2->BAIXA) .AND. TMP2->SALDO = 0

				nVlBx 		:= TMP2->VALOR

			ELSE

				nVlBx 		:= 0

			ENDIF

			IF nDAtraso > 0 .AND. nDAtraso <> 9999 // Verficia se o atraso e maior do que o limite de pagamento da planilha - MV_PAR04
				nCol		:= NOROUND(nDAtraso / MV_PAR03,0) + 1
				cCol        := "ATE " + STRZERO(nCol * MV_PAR03,4) + " DFM"
				dBaixa		:= STOD(TMP2->BAIXA)
			ELSEIF nDAtraso <= 0
				nCol		:= 0
				cCol        := "DENTRO DO MÊS"
				dBaixa		:= STOD(TMP2->BAIXA)
			ELSE
				nDAtraso  	:= MV_PAR06 - LastDate(STOD(TMP2->VENCREAL))
				nCol		:= 9999
				cCol        := "EM ABERTO"
				dBaixa		:= CTOD("//")
			ENDIF

			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= TMP2->TIPO1
			_aItem[02]		:= STOD(TMP2->VENCREAL)
			_aItem[03]		:= LastDate(STOD(TMP2->VENCREAL))
			_aItem[04]      := TMP2->ANO
			_aItem[05]      := TMP2->MES
			_aItem[06]      := UPPER(MesExtenso(VAL(TMP2->MES)))
			_aItem[07]      := dBaixa
			_aItem[08]      := year(dBaixa)
			_aItem[09]      := month(dBaixa)
			_aItem[10]		:= UPPER(MesExtenso(month(dBaixa)))
			_aItem[11]      := IIF(nCol == 9999,"X",STRZERO(nCol,2))
			_aItem[12]      := cCol
			_aItem[13]      := nDAtraso
			_aItem[14]      := TMP2->VALOR
			_aItem[15]      := TMP2->VLLIQUI
			_aItem[16]      := nVlBx
			_aItem[17]      := TMP2->CLIENTE
			_aItem[18]      := TMP2->NATUREZA
			_aItem[19]      := STOD(TMP2->EMISSAO)
			_aItem[20]      := TMP2->TITULO
			_aItem[21]      := MV_PAR06
			_aItem[22]      := TMP2->CLASSIF
			_aItem[23]      := TMP2->FILIAL1
			_aItem[24]      := TMP2->HIST
			AADD(_aIExcel,_aItem)
			_aItem := {}

			DbSelectArea("TMP2")
			TMP2->(DbSkip())

		Enddo

		DbSelectArea("TMP2")
		dbCloseArea("TMP2")

	ENDIF

	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
		Return
	EndIf

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
			{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", titulo, _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","RELPECLD")
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

	AADD(aRegs,{cPerg,"01","Tipo:			","","","mv_ch01","N",01,0,0,"C","","mv_par01","Inadimplencia","","","","","Recebimento","","","","","Analitico","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Tp. Cliente:	","","","mv_ch02","N",01,0,0,"C","","mv_par02","E. Privadas","","","","","Governo","","","","","Permuta","","","","","Todos","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Intervalo Dias:	","","","mv_ch03","N",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Maximo de Dias:	","","","mv_ch04","N",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Ano Referencia:	","","","mv_ch05","C",40,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Dt Referencia:  ","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
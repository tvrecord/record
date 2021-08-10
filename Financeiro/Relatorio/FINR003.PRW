#INCLUDE 'TOTVS.CH'
#INCLUDE 'RPTDEF.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} FINR003

    Impressão do rateio do repasse

    @author  Bruno Alves
    @example Example
    @param   [Parameter_Name],Parameter_type,Parameter_Description
    @return  Return
    @table   Tables
    @since   12-11-2020
/*/

User Function FINR003()

	Local   cPerg		:= "FINR003A"

	Private cFileName	:= ""
	Private TMP         := GetNextAlias()
	Private cPeriodo	:= ""
	Private cDir        :=  GetTempPath(.T.) + "totvsprinter\"


	// Cria e abre a tela de pergunta
	ValidPerg( cPerg )
	If !Pergunte(cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	cPeriodo := SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)
	cFileName := "REPASSE_RATEIO_" + cPeriodo + "_" + StrTran(Time(),":","")


	//Busca as informações
	BusDados()

	//Imprime em Excel
	FwMsgRun(, { || PrintExcel() }, , "Relatório de Pensões"  )

	(TMP)->(DbCloseArea())

Return


/*/{Protheus.doc} PrintExcel

   Imprime as informações em excel

   @author  Bruno Alves de OLiveira
   @example Exemple
   @param   [Parameter_Name],Parameter_type,Parameter_Description
   @return  Return
   @table   Tables
   @since   12-11-2020
/*/

Static Function PrintExcel()

	Local aDetRel := {}
	Local nTotREG := 0
	Local nTotal  := 0
	Local cTitle := "Repasse Rateio - " + cPeriodo
	Private cTitWorkSheet := cTitle
	Private cTitTable := cTitle
	Private nNum := 0

	(TMP)->(DbGoTop())

	oExcel := FWMsExcelEx():New()
	oExcel:AddworkSheet(cTitWorkSheet)
	oExcel:AddTable (cTitWorkSheet,cTitTable)

	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Sequencia",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Praca",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Nome Praca",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"NF Fornecedor",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Emissao",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Valor NF",1,2)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Vencimento NF",1,2)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Cliente",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"Natureza",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"NF RP",1,1)
	oExcel:AddColumn(cTitWorkSheet,cTitTable,"RP",1,1)


	While( (TMP)->(!Eof()) )
		nNUm += 1
		aDetRel := {}
		AADD(aDetRel, cValToChar(nNum))
		AADD(aDetRel, Alltrim((TMP)->ZAH_PRACA))
		AADD(aDetRel, Alltrim((TMP)->ZAF_DESCRI))
		AADD(aDetRel, SPACE(9))
		AADD(aDetRel, SPACE(9))
		AADD(aDetRel, (TMP)->ZAH_VLRAT)
		AADD(aDetRel, SPACE(9))
		AADD(aDetRel, Alltrim((TMP)->ZAH_CLIENT))
		AADD(aDetRel, "REPASSE SPOT")
		AADD(aDetRel, Posicione("SC5",10,xFilial("SC5") + Alltrim((TMP)->ZAH_NUMRP)), "C5_NUM")
		AADD(aDetRel, Alltrim((TMP)->ZAH_NUMRP))


		nTotal += (TMP)->ZAH_VLRAT
		oExcel:AddRow(cTitWorkSheet,cTitTable,aDetRel)
		(TMP)->(DbSkip())

	EndDo

	(TMP)->(dbEval({|| nTotREG++}))

	oExcel:AddRow(cTitWorkSheet,cTitTable,{"TOTAL","","", "",nTotal})

	oExcel:Activate()
	oExcel:GetXMLFile(cDir+cFileName+".xml")
	shellExecute("Open", cDir+cFileName +".xml", "", "C:\",1 )

Return

/*/{Protheus.doc} BusDados
    (long_description)
    @type  Static Function
    @author Igor Guimarães
    @since 26/11/2019
/*/

Static Function BusDados()

	BeginSql Alias TMP
		SELECT
			ZAH_PERIOD,
			ZAH_PRACA,
			ZAH_NUMRP,
			ZAH_CLIENT,
			ZAH_VLRAT,
			ZAF_DESCRI
		FROM
			%table:ZAH%
		INNER JOIN %table:ZAF%
		ON ZAH_PRACA = ZAF_CODIGO
			AND %table:ZAF%.D_E_L_E_T_ = ''
			AND ZAH_FILIAL = ZAF_FILIAL
		WHERE
			ZAH_PERIOD = %exp:cPeriodo%
			AND ZAH_PRACA BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
			AND ZAH_NUMRP BETWEEN %exp:MV_PAR04% AND %exp:MV_PAR05%
			AND ZAH_VLRAT > 0
			AND %table:ZAH%.D_E_L_E_T_ = ''
	EndSql

Return

/*/{Protheus.doc} ValidPerg
//TODO Funï¿½ï¿½o que cria as perguntas.
@author Eduardo Cevoli
@since 01/06/2020
@version 1.0
@return ${return}, ${return_description}
@param cPerg, characters, descricao
@type function
/*/
Static Function ValidPerg(cPerg)

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10)
	//          Grupo Ordem Desc Por               Desc Espa   Desc Ingl  Variavel  Tipo  Tamanho  Decimal  PreSel  GSC  Valid   Var01       Def01     DefSpa01  DefEng01  CNT01  Var02  Def02     DefSpa02  DefEng02  CNT02  Var03  Def03  DefEsp03  DefEng03  CNT03     Var04  Def04  DefEsp04  DefEng04  CNT04  Var05  Def05  DefEsp05  DefEng05  CNT05  F3        PYME  GRPSXG   HELP  PICTURE  IDFIL
	aAdd(aRegs,{cPerg,"01", "Periodo Apuracao?"	 , "",         "",        "mv_ch1", "D",  08,      00,      0,      "G", "",     "mv_par01", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"02", "Da Praça?"			 , "",         "",        "mv_ch2", "C",  03,      00,      0,      "G", "",     "mv_par02", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "ZAF",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"03", "Ate Praça?"		 , "",         "",        "mv_ch3", "C",  03,      00,      0,      "G", "",     "mv_par03", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "ZAF",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"04", "Do Repasse?"		 , "",         "",        "mv_ch4", "C",  06,      00,      0,      "G", "",     "mv_par04", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"05", "Ate Repasse?"		 , "",         "",        "mv_ch5", "C",  06,      00,      0,      "G", "",     "mv_par05", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })

	For i:=1 to Len(aRegs)
		If !dbSeek(PADR(cPerg,10)+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	RestArea(aArea)
Return()
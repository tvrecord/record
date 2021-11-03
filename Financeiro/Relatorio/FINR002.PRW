#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'


#DEFINE REL_VERT_STD 13
#DEFINE REL_START  65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 770 //Retrato
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

/*/{Protheus.doc} FINR002
Relatorio totalizador do repasse
@type function
@version
@author Bruno Alves
@since 09/11/2020
@return return_type, return_description
/*/
User Function FINR002()

	Local _cPerg    := "FINR002B"

	Private oPrint
	Private cSubTitle	:= ""
	Private nPag 		:= 0
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(11,,,,"Arial")
	Private oFonteN 	:= u_xFonte(11,.T.,,,"Arial")
	Private oFonte10 	:= u_xFonte(11,,,,"Arial")
	Private oFonte10N 	:= u_xFonte(11,.T.,,,"Arial")

	//If !lLogin
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN"
	//EndIf

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

/*/{Protheus.doc} fProcPdf
imprimir relatorio em pdf
@type function
@version
@author Bruno Alves
@since 09/11/2020
@return return_type, return_description
/*/
Static Function fProcPdf()

	Local nTotRat   := 0
	Local nTotal    := 0
	Local nRegAtu	:= 0
	Local nTotReg	:= 0
	Local cDir 		:= Alltrim(MV_PAR04) + "\"
	Local cTipo 	:= ""
	Local cAssin1 := ""
	Local cAssin2 := ""
	Local cAssin3 := ""
	Local cAssin4 := ""
	Local cCargo1 := ""
	Local cCargo2 := ""
	Local cCargo3 := ""
	Local cCargo4 := ""

	Private cTmp1     	:= GetNextAlias()
	Private cPeriodo 	:= SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)

	// Query para buscar as informações
	GetData(cPeriodo,MV_PAR02,MV_PAR03)

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","FINR002")
		(cTmp1)->(DbCloseArea())
		Return
	EndIf

	(cTmp1)->(DbGoTop())

	cFileName 	:= "TOTAL_REPASSE_PERIODO_"+cPeriodo+"_FINR002" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")
	oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetPortrait()//Retrato
	//	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	ImpProxPag()//Monta cabeçario da primeira e proxima pagina

	While (cTmp1)->(!Eof())

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		oPrint:Say( nLin,020, (cTmp1)->ZAF_CODIGO			  				  ,oFonte)
		oPrint:Say( nLin,060, (cTmp1)->TIPO  					  			  ,oFonte)
		oPrint:Say( nLin,110, (cTmp1)->ZAF_DESCRI				  			  ,oFonte)
		oPrint:Say( nLin,330, (cTmp1)->ZAF_CITY					  			  ,oFonte)
		oPrint:Say( nLin,460, (cTmp1)->ZAF_EST 					  			  ,oFonte)
		oPrint:Say( nLin,520, PADL(Transform( (cTmp1)->VALOR, "@E 999,999,999.99"),14) ,oFonte)

		nLin += REL_VERT_STD

		If nLin > REL_END
			u_PXRODAPE(@oPrint,"FINR002.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
		EndIf

		cTipo   := (cTmp1)->TIPO
		nTotal  += (cTmp1)->VALOR
		nTotRat += (cTmp1)->VALOR

		(cTmp1)->(DbSkip())


		If cTipo != (cTmp1)->TIPO

			//Impressão do totalizador por tipo
			oPrint:Say( nLin,520, PADL(Transform( nTotRat, "@E 999,999,999.99"),14),oFonteN)
			nTotRat := 0

			nLin += (REL_VERT_STD * 2)


		EndIf

	EndDo

	//Impressão do total de todas as praças
	oPrint:Say( nLin,520, PADL(Transform( nTotal, "@E 999,999,999.99"),14),oFonteN)

	nLin += (REL_VERT_STD * 3)
	/*
	If nLin > REL_END .OR. (REL_END - nLin) < 3
		u_PXRODAPE(@oPrint,"FINR002.PRW","")
		oPrint:EndPage()
		ImpProxPag()//Monta cabeçario da proxima pagina
		nLin += (REL_VERT_STD * 6)
	EndIf
	*/

	//Imprime linha das assinaturas
	If !Empty(MV_PAR05) .and. PswSeek( 	MV_PAR05, .T. )
		oPrint:Say( nLin,024, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin1 := Alltrim(aUsuario[1][4])
		cCargo1 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR06) .and. PswSeek( 	MV_PAR06, .T. )
		oPrint:Say( nLin,175, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin2 := Alltrim(aUsuario[1][4])
		cCargo2 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR07) .and. PswSeek( 	MV_PAR07, .T. )
		oPrint:Say( nLin,318, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin3 := Alltrim(aUsuario[1][4])
		cCargo3 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR08) .and. PswSeek( 	MV_PAR08, .T. )
		oPrint:Say( nLin,470, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin4 := Alltrim(aUsuario[1][4])
		cCargo4 := Alltrim(aUsuario[1][13])
	EndIf

	nLin += REL_VERT_STD

	//Imprime o nome das assinaturas

	If !Empty(cAssin1)
		oPrint:Say( nLin,024, PADC(cAssin1,40) ,oFonte10)
	EndIf

	If !Empty(cAssin2)
		oPrint:Say( nLin,175, PADC(cAssin2,40) ,oFonte10)
	EndIf

	If !Empty(cAssin3)
		oPrint:Say( nLin,318, PADC(cAssin3,40) ,oFonte10)
	EndIf

	If !Empty(cAssin4)
		oPrint:Say( nLin,470, PADC(cAssin4,40) ,oFonte10)
	EndIf

	nLin += REL_VERT_STD

	If !Empty(cCargo1)
		oPrint:Say( nLin,024, PADC(cCargo1,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo2)
		oPrint:Say( nLin,175, PADC(cCargo2,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo3)
		oPrint:Say( nLin,318, PADC(cCargo3,33) ,oFonte10N)
	EndIf

	If !Empty(cCargo4)
		oPrint:Say( nLin,470, PADC(cCargo4,33) ,oFonte10N)
	EndIf

	u_PXRODAPE(@oPrint,"FINR002.PRW","")
	oPrint:EndPage()
	oPrint:Preview()
	(cTmp1)->(DbCloseArea())

Return

/*/{Protheus.doc} ImpProxPag
    Imprime cabeçlho da proxima pagina
    @author  Bruno Alves de Oliveira
    @since   28-08-2020
/*/

Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "COMPETÊNCIA: " + UPPER(Alltrim(MesExtenso(Val(Substring(cPeriodo,1,2))))) + "/" + Substring(cPeriodo,3,4)
	nLin := u_PXCABECA(@oPrint, "REPASSE A PAGAR REFERENTE- FATURAMENTO SPOT", cSubTitle  , nPag)

	oPrint:Say( nLin,020, "PRAÇA",oFonteN)
	oPrint:Say( nLin,060, "STATUS",oFonteN)
	oPrint:Say( nLin,110, "TV",oFonteN)
	oPrint:Say( nLin,330, "CIDADE",oFonteN)
	oPrint:Say( nLin,460, "ESTADO",oFonteN)
	oPrint:Say( nLin,540, "VALOR",oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_VERT_STD

Return

/*/{Protheus.doc} GetData

    Busca dados no banco

    @author  Bruno Alves de Oliveira
    @since   24-08-2020
/*/
Static Function GetData(cPeriodo,cPracaDe,cPracaAte)

	// Busca os registros a serem impressos no relatório
	BeginSql Alias cTmp1

	SELECT ZAF_CODIGO,ZAF_CITY,
	CASE
	WHEN ZAF_TIPO = '1'  THEN 'C. de Rede'
	WHEN ZAF_TIPO = '2'  THEN 'Filiada'
	WHEN ZAF_TIPO = '3'  THEN 'Afiliada'
	END AS TIPO,
	ZAF_DESCRI,ZAF_CITY,ZAF_EST,SUM(ZAH_VLRAT) AS VALOR FROM %table:ZAH% AS ZAH
	INNER JOIN %table:ZAF% ZAF ON
	ZAF_FILIAL = ZAH_FILIAL AND
	ZAF_CODIGO = ZAH_PRACA
	WHERE
	ZAH_PERIOD = %Exp:cPeriodo% AND
	ZAH_PRACA BETWEEN %Exp:cPracaDe% AND %Exp:cPracaAte% AND
	ZAF.D_E_L_E_T_ = '' AND
	ZAH.D_E_L_E_T_ = ''
	GROUP BY ZAF_CODIGO,ZAF_TIPO,ZAF_DESCRI,ZAF_CITY,ZAF_EST
	HAVING SUM(ZAH_VLRAT) > 0
	ORDER BY ZAF_TIPO, VALOR DESC

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
	aAdd(aRegs,{cPerg,"04", "Destino do(s) Arq.?", "",         "",        "mv_ch4", "C",  99,      00,      0,      "G", "",     "mv_par04", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"05", "Assinatura 1?"		 , "",         "",        "mv_ch5", "C",  06,      00,      0,      "G", "",     "mv_par05", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "USR",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"06", "Assinatura 2?"		 , "",         "",        "mv_ch6", "C",  06,      00,      0,      "G", "",     "mv_par06", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "USR",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"07", "Assinatura 3?"		 , "",         "",        "mv_ch7", "C",  06,      00,      0,      "G", "",     "mv_par07", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "USR",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"08", "Assinatura 4?"		 , "",         "",        "mv_ch8", "C",  06,      00,      0,      "G", "",     "mv_par08", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "USR",       "",   "",      "",   "",      ""   })

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
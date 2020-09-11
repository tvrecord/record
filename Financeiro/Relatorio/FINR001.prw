#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'



#DEFINE REL_VERT_STD 16
#DEFINE REL_START  65
#DEFINE REL_END 560
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

/*/{Protheus.doc} FINR001
Relatorio do rateio do Repasse
@type function
@version
@author Bruno Alves
@since 24/08/2020
@return return_type, return_description
/*/
User Function FINR001()

	Local oSay      := Nil
	Local _cPerg    := "FINR001A"
	Local _lOk      := .T.

	//Private lLogin    := Type("cEmpAnt") != "U"
	Private cTmp1     := GetNextAlias()
	Private _nTotReg  := 0            // Total de Registros
	Private _nRegAtu  := 0            // Registro atual da regua de processamento
	Private cPeriodo,cPeriodoAnt

	//If !lLogin
	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN"
	//EndIf


	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	If !Pergunte(_cPerg)
		ApMsgStop("Opera��o cancelada pelo usu�rio!")
		Return
	EndIf


	cPeriodo 	:= SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)
	cPeriodoAnt := SUBSTRING(DTOS(MonthSub(MV_PAR01,1)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR01,1)),1,4)


	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )



Return


/*/{Protheus.doc} fProcPdf
imprimir relatorio em pdf
@type function
@version
@author Bruno Alves
@since 24/08/2020
@return return_type, return_description
/*/
Static Function fProcPdf()


	Local nTotCalc 	:= 0
	Local nTotRepas := 0
	Local nTotRat   := 0
	Local nComissao := 0
	Local i
	Local cPraca 	:= ""
	Local aInfo		:= {}
	Local cDep		:= ""
	Local aUsuario	:= {}
	Local cUsuario	:= ""


	Private cSubTitle	:= ""
	Private nPag 		:= 1
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(8,,,,"Arial")
	Private oFonteN 	:= u_xFonte(8,.T.,,,"Arial")
	Private cDir 		:= GetTempPath(.T.) + "totvsprinter\"
	Private cFileName 	:= "RELATORIO_RATEIO_FINR001" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")

	// Query para buscar as informa��es
	GetData()

	// Carrega regua de processamento
	Count To _nTotReg
	ProcRegua( _nTotReg )

	(cTmp1)->(DbGoTop())

	oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetLandScape()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir



	oPrint:StartPage()
	cSubTitle := "COMPET�NCIA: " + Alltrim(MesExtenso(Val(Substring((cTmp1)->ZAG_PERIOD,1,2)))) + "/" + Substring((cTmp1)->ZAG_PERIOD,3,4) + " - CNPJ: " + Transform(Alltrim((cTmp1)->ZAF_CGC),"@R 99.999.999/9999-99")
	nLin := PXCABECA(@oPrint, "REPASSE A PAGAR (" + Alltrim((cTmp1)->ZAF_CODIGO) + " - " + Alltrim((cTmp1)->ZAF_DESCRI) + ")" , cSubTitle  , nPag)

	oPrint:Say( nLin,020, "RP",oFonteN)
	oPrint:Say( nLin,048, "Utiliza��o",oFonteN)
	oPrint:Say( nLin,088, "NF",oFonte)
	oPrint:Say( nLin,116, "Emissao",oFonte)
	oPrint:Say( nLin,160, "Venc.",oFonteN)
	oPrint:Say( nLin,200, "Cliente",oFonteN)
	oPrint:Say( nLin,300, "Agencia",oFonteN)
	oPrint:Say( nLin,410, "Val Liq.",oFonteN)
	oPrint:Say( nLin,458, "Ded Ag.",oFonteN)
	oPrint:Say( nLin,500, "Desc Fin",oFonteN)
	oPrint:Say( nLin,535, "Inad.",oFonteN)
	oPrint:Say( nLin,565, "Ded Imp.",oFonteN)
	oPrint:Say( nLin,600, "Ded Comis",oFonteN)
	oPrint:Say( nLin,640, "Ded BV",oFonteN)
	oPrint:Say( nLin,685, "Vl Calc",oFonteN)
	oPrint:Say( nLin,740, "Repasse",oFonteN)
	oPrint:Say( nLin,780, "Rep. Comp.",oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )
	nLin += REL_VERT_STD

	While (cTmp1)->(!Eof())


		cPraca := Alltrim((cTmp1)->ZAG_PRACA)
		//Usuario responsavel pela assinatura
		If Empty(cUsuario)
			cUsuario	:= Substr(Embaralha((cTmp1)->ZAG_USERGI,1),3,6)
		EndIf
		//Adiciono as informa��es do rateio para sempre impressas ap�s os totalizadores
		If (cTmp1)->ZAH_VLRAT > 0
			aAdd(aInfo,{(cTmp1)->ZAG_NUMRP,;
				(cTmp1)->F2_DOC,;
				(cTmp1)->ZAH_CLIENT,;
				(cTmp1)->ZAH_RATEIO,;
				(cTmp1)->ZAH_VLRAT })
		EndIf

		// Atualiza regua de processamento
		_nRegAtu++
		IncProc( "Imprimindo Registro " + cValToChar( _nRegAtu ) + " De " + cValToChar( _nTotReg ) + " [" + StrZero( Round( ( _nRegAtu / _nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		If Alltrim((cTmp1)->C5_XTPFAT) == "2"
			nComissao := 20
		Else
			nComissao := (cTmp1)->C5_COMIS1
		EndIf


		oPrint:Say( nLin,020, (cTmp1)->ZAG_NUMRP			  					  ,oFonte)
		oPrint:Say( nLin,052, (cTmp1)->ZAH_UTILIZ  					  			  ,oFonte)
		oPrint:Say( nLin,084, (cTmp1)->F2_DOC				  					  ,oFonte)
		oPrint:Say( nLin,116, DTOC(STOD((cTmp1)->F2_EMISSAO)) 					  ,oFonte)
		oPrint:Say( nLin,160, DTOC(STOD((cTmp1)->E1_VENCREA)) 					  ,oFonte)
		oPrint:Say( nLin,200, Substring((cTmp1)->ZAH_CLIENT,1,22)	    		  ,oFonte)
		oPrint:Say( nLin,300, Substring((cTmp1)->ZAH_AGENCI,1,17)				  ,oFonte)
		oPrint:Say( nLin,400, Transform( (cTmp1)->ZAH_VALLIQ, "@E 999,999,999.99"),oFonte)
		oPrint:Say( nLin,465, Transform( nComissao, "@E 999.99%")		  		  ,oFonte)
		oPrint:Say( nLin,500, Transform( (cTmp1)->ZAH_DESCFI, "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,535, Transform( (cTmp1)->ZAH_INADIM, "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,570, Transform( (cTmp1)->ZAH_DEDUCO, "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,605, Transform( (cTmp1)->ZAH_COMREP, "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,640, Transform( (cTmp1)->ZAH_BV,	  "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,675, Transform( (cTmp1)->ZAH_VLCALC, "@E 999,999,999.99"),oFonte)
		oPrint:Say( nLin,745, Transform( (cTmp1)->ZAH_REPASS, "@E 999.99%")		  ,oFonte)
		oPrint:Say( nLin,780, Transform( (cTmp1)->ZAH_REPCOM, "@E 999,999,999.99"),oFonte)

		nLin += REL_VERT_STD


		nTotCalc 	+= (cTmp1)->ZAH_VLCALC
		nTotRepas 	+= (cTmp1)->ZAH_REPCOM


		(cTmp1)->(DbSkip())


		If cPraca != Alltrim((cTmp1)->ZAG_PRACA)


			//Impressão dos totalizadores
			oPrint:Say( nLin,675, Transform( nTotCalc,  "@E 999,999,999.99"),oFonteN)
			oPrint:Say( nLin,780, Transform( nTotRepas, "@E 999,999,999.99"),oFonteN)
			nTotCalc  := 0
			nTotRepas := 0
			nTotRat	  := 0

			nLin += REL_VERT_STD

			oPrint:Say( nLin,020, "RP"			,oFonteN)
			oPrint:Say( nLin,052, "NF"			,oFonteN)
			oPrint:Say( nLin,084, "CLIENTE"		,oFonteN)
			oPrint:Say( nLin,300, "RATEIO"		,oFonteN)
			oPrint:Say( nLin,345, "VALOR"		,oFonteN)

			nLin += REL_VERT_STD

			//Criar uma array para impress�o das NFs
			For i:=1 to Len(aInfo)

				oPrint:Say( nLin,020, aInfo[i][1] ,oFonte)
				oPrint:Say( nLin,052, aInfo[i][2] ,oFonte)
				oPrint:Say( nLin,084, aInfo[i][3] ,oFonte)
				oPrint:Say( nLin,300, Transform( aInfo[i][4], "@E 999.99%") ,oFonte)
				oPrint:Say( nLin,335, Transform( aInfo[i][5], "@E 999,999,999.99") ,oFonte)

				nTotRat += aInfo[i][5]

				nLin += REL_VERT_STD

				If nLin > REL_END
					ImpProxPag()//Monta cabe�ario da proxima pagina

					oPrint:Say( nLin,020, "RP"			,oFonteN)
					oPrint:Say( nLin,052, "NF"			,oFonteN)
					oPrint:Say( nLin,084, "CLIENTE"		,oFonteN)
					oPrint:Say( nLin,300, "RATEIO"		,oFonteN)
					oPrint:Say( nLin,345, "VALOR"		,oFonteN)

					nLin += REL_VERT_STD

				EndIf


			Next

			oPrint:Say( nLin,335, Transform( nTotRat, "@E 999,999,999.99") ,oFonteN)

			nLin := 420

			//Imprime as Assinaturas
			oPrint:Say( nLin,458, "_______________________________" ,oFonteN)
			oPrint:Say( nLin,620, "_______________________________" ,oFonteN)

			nLin += REL_VERT_STD

			If PswSeek( cUsuario, .T. )

				aUsuario := PswRet() // Retorna vetor com informa��es do usu�rio


				oPrint:Say( nLin,458, PADC("Eleni Caldeira (Elenn)",50) ,oFonte)
				oPrint:Say( nLin,620, PADC(Alltrim(aUsuario[1][4]),50) ,oFonte)


				nLin += REL_VERT_STD

				oPrint:Say( nLin,458, PADC("Gerente Adm./Financeiro",50) ,oFonteN)
				oPrint:Say( nLin,620, PADC(Alltrim(aUsuario[1][12]),50) ,oFonteN)

			EndIf


			If !(cTmp1)->(Eof())
				ImpProxPag()//Monta cabe�ario da proxima pagina
			EndIf

			//Zero o vetor para o proxima pra�a
			aInfo := {}


		EndIf

		If nLin > REL_END .And. !(cTmp1)->(Eof())
			ImpProxPag()//Monta cabe�ario da proxima pagina
		EndIf

	EndDo



	PXRODAPE(@oPrint,"FINR001.PRW","")
	oPrint:EndPage()

	oPrint:Preview()

	(cTmp1)->(DbCloseArea())

Return

/*/{Protheus.doc} ImpProxPag

    Imprime cabe�lho da proxima pagina

    @author  Bruno Alves de Oliveira
    @since   28-08-2020
/*/


Static Function ImpProxPag()

	PXRODAPE(@oPrint,"FINR001.PRW","")
	oPrint:EndPage()
	nPag++
	oPrint:StartPage()
	cSubTitle := "COMPET�NCIA: " + Alltrim(MesExtenso(Val(Substring((cTmp1)->ZAG_PERIOD,1,2)))) + "/" + Substring((cTmp1)->ZAG_PERIOD,3,4)  + " - CNPJ: " + Transform(Alltrim((cTmp1)->ZAF_CGC),"@R 99.999.999/9999-99")
	nLin := PXCABECA(@oPrint, "REPASSE A PAGAR (" + Alltrim((cTmp1)->ZAF_CODIGO) + " - " + Alltrim((cTmp1)->ZAF_DESCRI) + ")" , cSubTitle  , nPag)


	oPrint:Say( nLin,020, "RP",oFonteN)
	oPrint:Say( nLin,048, "Utiliza��o",oFonteN)
	oPrint:Say( nLin,088, "NF",oFonte)
	oPrint:Say( nLin,116, "Emissao",oFonte)
	oPrint:Say( nLin,160, "Venc.",oFonteN)
	oPrint:Say( nLin,200, "Cliente",oFonteN)
	oPrint:Say( nLin,300, "Agencia",oFonteN)
	oPrint:Say( nLin,410, "Val Liq.",oFonteN)
	oPrint:Say( nLin,458, "Ded Ag.",oFonteN)
	oPrint:Say( nLin,500, "Desc Fin",oFonteN)
	oPrint:Say( nLin,535, "Inad.",oFonteN)
	oPrint:Say( nLin,565, "Ded Imp.",oFonteN)
	oPrint:Say( nLin,600, "Ded Comis",oFonteN)
	oPrint:Say( nLin,640, "Ded BV",oFonteN)
	oPrint:Say( nLin,685, "Vl Calc",oFonteN)
	oPrint:Say( nLin,740, "Repasse",oFonteN)
	oPrint:Say( nLin,780, "Rep. Comp.",oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_VERT_STD

Return

/*/{Protheus.doc} GetData

    Busca dados no banco

    @author  Bruno Alves de Oliveira
    @since   24-08-2020
/*/
Static Function GetData()

	// Busca os registros a serem impressos no relat�rio
	BeginSql Alias cTmp1

		SELECT
		ZAG_PRACA,ZAG_NUMRP,ZAG_EMISSA,ZAG_PERIOD,ZAG_USERGI,
		ZAF_CODIGO,ZAF_DESCRI,ZAF_CGC,
		ZAH_REPTOT,ZAH_DESCFI,ZAH_INADIM,ZAH_DEDUCO,ZAH_COMREP,ZAH_BV,ZAH_VLCALC,ZAH_REPASS,ZAH_REPCOM,ZAH_AGENCI,ZAH_VALLIQ,ZAH_CLIENT,ZAH_RATEIO,ZAH_VLRAT,ZAH_UTILIZ,
		QTD,
		C5_XTPFAT,C5_COMIS1,
		F2_SERIE,F2_DOC,F2_EMISSAO,F2_VALBRUT,F2_CLIENTE,F2_LOJA,
		A1_NOME,
		E1_VENCREA
		FROM %table:ZAG% AS ZAG
		INNER JOIN %table:ZAH% AS ZAH ON
		ZAH_FILIAL = ZAG_FILIAL AND
		ZAH_CODIGO = ZAG_CODIGO AND
		ZAH_PRACA = ZAG_PRACA AND
		ZAH_NUMRP = ZAG_NUMRP AND
		ZAH_PERIOD = ZAG_PERIOD
		LEFT JOIN (
		SELECT  ZAH_FILIAL,ZAH_PRACA,ZAH_PERIOD,COUNT(*) AS QTD FROM %table:ZAH% ZAH01
		WHERE
		ZAH01.D_E_L_E_T_ = ''
		GROUP BY ZAH_FILIAL,ZAH_PRACA,ZAH_PERIOD
		)  ZA  ON
		ZA.ZAH_FILIAL   = ZAG_FILIAL AND
		ZA.ZAH_PRACA	= ZAG_PRACA AND
		ZA.ZAH_PERIOD	= %Exp:cPeriodoAnt%
		INNER JOIN %table:ZAF% AS ZAF ON
		ZAF_FILIAL = ZAG_FILIAL AND
		ZAF_CODIGO = ZAG_PRACA
		LEFT JOIN %table:SC5%  AS SC5 ON
		C5_FILIAL = ZAG_FILIAL AND
		C5_NUMRP = ZAG_NUMRP AND
		C5_NOTA <> '' AND
		SC5.D_E_L_E_T_ = ''
		LEFT JOIN %table:SA1% AS SA1 ON
		A1_COD = C5_CLIENTE AND
		A1_LOJA = C5_LOJACLI AND
		SA1.D_E_L_E_T_ = ''
		LEFT JOIN %table:SF2% AS SF2 ON
		F2_FILIAL = C5_FILIAL AND
		F2_SERIE = C5_SERIE AND
		F2_DOC = C5_NOTA AND
		F2_CLIENTE = C5_CLIENTE AND
		F2_LOJA = C5_LOJACLI AND
		SF2.D_E_L_E_T_ = ''
		LEFT JOIN %table:SE1% AS SE1 ON
		E1_FILIAL = F2_FILIAL  AND
		E1_PREFIXO = F2_SERIE AND
		E1_NUM = F2_DOC AND
		E1_TIPO = 'NF' AND
		E1_CLIENTE = F2_CLIENTE AND
		E1_LOJA = F2_LOJA AND
		SE1.D_E_L_E_T_ = ''
		WHERE
		ZAG_FILIAL = '01' AND
		ZAG_PERIOD = %Exp:cPeriodo% AND
		ZAG_PRACA BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% AND
		ZAG_NUMRP BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR05% AND
		ZAF.D_E_L_E_T_ = '' AND
		ZAG.D_E_L_E_T_ = '' AND
		ZAH.D_E_L_E_T_ = ''
		ORDER BY 1,2

	EndSql

Return

/*/{Protheus.doc} xFonte

	Descrição: Realiza o encapsulamento da função TFONT

	@author    Bruno Alves
	@version   1.00
	@since     05/07/2020
/*/

User Function xFonte(nTam,lBold,lLine,lItalic,cFont)

	Local oFonte

	lBold 	:= If ( lBold	==	Nil	,	.F.	, 	lBold	)
	lLine	:= If ( lLine	==	Nil	,	.F.	,	lLine	)
	lItalic	:= If ( lItalic	==	Nil	,	.F.	,	lItalic )
	cFont	:= If ( cFont	==	Nil	,"Arial"	,	cFont )

	oFonte:=TFont():New( cFont,,nTam,,lBold,,,,,lLine,lItalic)

Return oFonte

/*/{Protheus.doc} PXCABECA

	Monta um cabeçalho pré-definido de acordo com a orientação do objeto

	@author    Bruno Alves
	@version   1.0
	@since     05/07/2020
/*/

Static Function PXCABECA(oPrint,cTitle,cSubTitle,nPage, lBlackWhite)

	Local oFont24 := u_xFonte(16,,,,"Arial")
	Local oFont14 := u_xFonte(14,,,,"Arial")
	Local cData := DTOS(DATE()) //DTOC Não está funcionando
	Local cData := SUBSTRING(cData,7,2) + "/" +  SUBSTRING(cData,5,2)  + "/" + SUBSTRING(cData,1,4)

	Default cSubTitle := ""


	If oPrint:GetOrientation() == 1

		oPrint:SayBitmap(30,15,"\system\LOGO01.png",80,40)
		oPrint:SayAlign(35,155,Capital(AllTrim(Posicione("SM0", 1, cEmpAnt+cFilAnt , "M0_NOMECOM"))),oFont14, 580, 20, , 0, 2)
		oPrint:SayAlign(51,155, "ERP | " + oApp:cModDesc ,oFont14,580,20,,0,2)

		oPrint:SayAlign(20,20,"Emitido em: " + cData,oFont14, 535, 20, , 1, 1)
		oPrint:SayAlign(40,20,"Hora: " + Time(),oFont14, 535, 20, , 1, 1)
		oPrint:SayAlign(60,20,"Pagina: " + cValtoChar(nPage),oFont14, 535, 20, , 1, 1)

		oPrint:Line(80,10,80,580,CLR_HGRAY,"-9")

		oPrint:SayAlign(80,10,cTitle,oFont24, 580, 20, /*[ nClrText]*/, 2, 1)
		oPrint:SayAlign(105,10,cSubTitle,oFont14, 580, 20, /*[ nClrText]*/, 2, 1)

		oPrint:Line(118,10,118,580,CLR_HGRAY,"-9")

	Else

		oPrint:Line(20,10,20,820,CLR_HGRAY,"-9")
		oPrint:SayBitmap(30,15,"\system\LOGO01.PNG",80,40)

		oPrint:SayAlign(70,18,Capital(AllTrim(Posicione("SM0", 1, cEmpAnt+cFilAnt , "M0_NOMECOM"))),oFont14, 820, 20, /*[ nClrText]*/, 0, 1)
		oPrint:SayAlign(85,18, "ERP | " + oApp:cModDesc ,oFont14,580,20,,0,2)

		oPrint:SayAlign(30,20,"Emitido em: " + cData,oFont14, 800, 20, /*[ nClrText]*/, 1, 1)
		oPrint:SayAlign(50,20,"Hora: " + Time(),oFont14, 800, 20, /*[ nClrText]*/, 1, 1)
		oPrint:SayAlign(70,20,"Pagina: " + cValtoChar(nPage),oFont14, 800, 20, /*[ nClrText]*/, 1, 1)

		oPrint:SayAlign(40,10,cTitle,oFont24, 830, 20, /*[ nClrText]*/, 2, 1)
		oPrint:SayAlign(65,10,cSubTitle,oFont14, 830, 20, /*[ nClrText]*/, 2, 1)
		oPrint:Line(105,10,105,820,CLR_HGRAY,"-9")
	EndIf

Return 130

/*/{Protheus.doc} PXRODAPE

	Monta um rodapé pré-definido de acordo com a orientação do objeto

	@author    Bruno Alves
	@version   1.0
	@since     05/07/2020
/*/

Static Function PXRODAPE(oPrint,cFonteBase,cMsgPad)
	Local oFont8 := u_xFonte(8)
	cMsgPad := If(cMsgPad == Nil,"",AllTrim(cMsgPad) + " ")

	If oPrint:GetOrientation() == 1
		oPrint:Box (815, 10, 830, 580, "-4")

		oPrint:SayAlign(819,20,cMsgPad + u_InspFonte(cFonteBase),oFont8, 555, 20, /*[ nClrText]*/, 1, 1)
	Else
		oPrint:Box (580, 10, 595, 830, "-4")
		oPrint:SayAlign(584,20,cMsgPad + u_InspFonte(cFonteBase),oFont8, 805, 20, /*[ nClrText]*/, 1, 1)
	EndIf

Return


User function InspFonte(cFonte)
	Local cRet			:= ""
	Local aData			:= {}
	Local cData         := DTOS(DATE()) //DTOC Não está funcionando
	Local cData := SUBSTRING(cData,7,2) + "/" +  SUBSTRING(cData,5,2)  + "/" + SUBSTRING(cData,1,4)

	Default __cUserId	:= ""

	U_PXVERSAO()
	aData := GetAPOInfo(cFonte)//aFontes[nI])
	/*
    Modos de compilação:
    Valor                     Descrição
    0 - BUILD_FULL            Usuário tem permissão para compilar qualquer tipo de fonte
    2 - BUILD_PARTNER         Permissão de compilação da Fábrica de Software TOTVS
    3 - BUILD_PATCH           Aplicação de Patch
    1 - BUILD_USER            Usuário só pode compilar User Functions
	*/

	//cRet := aData[1] + "(" + dtoc(aData[4]) + " - " +  aData[5] + ")"
	cRet := aData[1] + "(" + cData + " - " +  aData[5] + ")"
	cRet += " ENV " + AllTrim(GetEnvServer())
	cRet += " VER " + cPXVersao
	cRet += " USR " + __cUserId
	//cRet += " EMITIDO " + dtoc(DATE()) + " - " + TIME()
	cRet += " EMITIDO " + cData + " - " + TIME()
Return cRet


/*/{Protheus.doc} PXVERSAO

	Cria uma variável pública baseada no CHANGELOG. MD

	@author  Bruno Alves de Oliveira
	@since   05/07/2020
/*/

User Function PXVERSAO()
	Local cChangeLog	:= cValToChar(GetApoRes("CHANGELOG.MD"))
	Local nIni			:= At( "## [", cChangeLog) + 4//remove os caracteres procurados
	Local nFim			:= At( "]", cChangeLog,nIni)
	Public cPXVersao	:= ""

	If nIni > 0 .AND. nFim > 0
		cPXVersao	:= SubStr(cChangeLog,nIni,nFim-nIni)
	EndIf
Return cPXVersao

/*/{Protheus.doc} ValidPerg
//TODO Fun��o que cria as perguntas.
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
	aAdd(aRegs,{cPerg,"01", "Periodo Apuracao?"	, "",         "",        "mv_ch1", "D",  08,      00,      0,      "G", "",     "mv_par01", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"02", "Da Pra�a?"			, "",         "",        "mv_ch2", "C",  03,      00,      0,      "G", "",     "mv_par02", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "ZAF",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"03", "Ate Pra�a?"		, "",         "",        "mv_ch3", "C",  03,      00,      0,      "G", "",     "mv_par03", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "ZAF",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"04", "Do N� RP?"			, "",         "",        "mv_ch4", "C",  06,      00,      0,      "G", "",     "mv_par04", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })
	aAdd(aRegs,{cPerg,"05", "Ate N� RP?"		, "",         "",        "mv_ch5", "C",  06,      00,      0,      "G", "",     "mv_par05", "",       "",       "",       "",    "",    "",       "",       "",       "",    "",    "",    "",       "",       "",       "",    "",    "",       "",       "",    "",    "",    "",       "",       "",    "",       "",   "",      "",   "",      ""   })

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


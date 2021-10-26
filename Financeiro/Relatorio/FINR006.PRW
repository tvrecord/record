#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

#DEFINE REL_VERT_STD 16
#DEFINE REL_START  65
//#DEFINE REL_END 560 //Paisagem
#DEFINE REL_END 700 //Retrato
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

/*/{Protheus.doc} FINR006
Relatorio de bonificação de volume (BV) BSB e comissão de agencia
@type function
@version
@author Rafael França
@since 05/10/2021
@return return_type, return_description
/*/

User Function FINR006()

	Local _cPerg    := "FINR006A"

	Private oPrint
	Private cSubTitle	:= ""
	Private nPag 		:= 0
	Private nLin 		:= 0
	Private oFonte 		:= u_xFonte(12,,,,"Arial")
	Private oFonteN 	:= u_xFonte(12,.T.,,,"Arial")
	Private oFonte10 	:= u_xFonte(10,,,,"Arial")
	Private oFonte10N 	:= u_xFonte(10,.T.,,,"Arial")

	// Cria e abre a tela de pergunta
	ValidPerg( _cPerg )
	If !Pergunte(_cPerg)
		ApMsgStop("Operação cancelada pelo usuário!")
		Return
	EndIf

	FwMsgRun(Nil, { || fProcPDF() }, "Processando", "Emitindo relatorio em PDF..." )

Return

/*/{Protheus.doc} fProcPdf
Imprime relatório em pdf
@type function
@version
@author Rafael França
@since 05/10/2021
@return return_type, return_description
/*/

Static Function fProcPdf()

	Local nTotRat   := 0
	Local nTotal    := 0
	Local nRegAtu	:= 0
	Local nTotReg	:= 0
	Local cDir 		:= Alltrim(MV_PAR05) + "\"
	Local cTipo 	:= ""

	Local cAssin1 := ""
	Local cAssin2 := ""
	Local cAssin3 := ""
	Local cAssin4 := ""

	Local cCargo1 := ""
	Local cCargo2 := ""
	Local cCargo3 := ""
	Local cCargo4 := ""

	Private lOk			:= .T.
	Private cAlias     	:= GetNextAlias()
	Private cAlias1    	:= GetNextAlias()
	Private cPeriodo 	:= SUBSTRING(DTOS(MV_PAR07),5,2) + SUBSTRING(DTOS(MV_PAR07),1,4)
	Private cPerTitulo	:= SUBSTRING(DTOS(MV_PAR07),5,2) + "/" + SUBSTRING(DTOS(MV_PAR07),1,4)
	Private cDataIni,cDataFin

	cDataIni	:= DTOS(MV_PAR06)
	cDataFin	:= DTOS(MV_PAR07)
	cPeriodo 	:= SUBSTRING(DTOS(MV_PAR07),5,2) + SUBSTRING(DTOS(MV_PAR07),1,4)
	cPeriodoAnt := SUBSTRING(DTOS(MonthSub(MV_PAR07,1)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR07,1)),1,4)

	// Query para buscar as informações
	GetData(cPeriodo,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)

	// Carrega regua de processamento
	Count To nTotReg
	ProcRegua( nTotReg )

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","FINR006")
		(cAlias)->(DbCloseArea())
		Return
	EndIf

	(cAlias)->(DbGoTop())

	cFileName 	:= "TOTAL_REPASSE_PAGAR_"+cPeriodo+"_FINR006" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")
	oPrint := FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	oPrint:SetPortrait()//Retrato
	//	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	ImpProxPag()//Monta cabeçario da primeira e proxima pagina

	DBSelectArea(cAlias)
	DBGotop()
	While !cAlias->(EOF())

			If (!EMPTY(cAlias->E1_BAIXA) .AND. STOD(cAlias->E1_BAIXA) <= (STOD(cAlias->E1_VENCTO) + cAlias->ZU_DIAS)) .AND. cAlias->E1_NATUREZ <> "1101006" .OR. (cAlias->ZU_EXCECAO == "1" .AND. !EMPTY(cAlias->E1_BAIXA) .AND. cAlias->E1_NATUREZ <> "1101006")// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna

				IF cVend != cAlias->E1_VEND1
					aAdd(aRegistro,{cAlias->E1_VEND1,cAlias->LIQUIDO})
				ELSEIF cVend == cAlias->E1_VEND1
					nPos := aScan(aRegistro, { |x| x[1] == cAlias->E1_VEND1})
					aRegistro[nPos][2] += cAlias->LIQUIDO
				ENDIF

				cVend := cAlias->E1_VEND1

			ENDIF

			dbSkip() // Avanca o ponteiro do registro no arquivo

	ENDDO

	DBSelectArea(cAlias)
	DBGotop()
	While !cAlias->(EOF())

			If !EMPTY(ZU_PERC1)
				aAdd(aContrato,{cAlias->ZU_DEFX1,;  		// 1 - De Valor
					cAlias->ZU_ATEFX1,;	// 2 - Ate Valor
					cAlias->ZU_PERC1}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC2)
				aAdd(aContrato,{cAlias->ZU_DEFX2,;  		// 1 - De Valor
					cAlias->ZU_ATEFX2,;	// 2 - Ate Valor
					cAlias->ZU_PERC2}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC3)
				aAdd(aContrato,{cAlias->ZU_DEFX3,;  		// 1 - De Valor
					cAlias->ZU_ATEFX3,;	// 2 - Ate Valor
					cAlias->ZU_PERC3}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC4)
				aAdd(aContrato,{cAlias->ZU_DEFX4,;  		// 1 - De Valor
					cAlias->ZU_ATEFX4,;	// 2 - Ate Valor
					cAlias->ZU_PERC4}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC5)
				aAdd(aContrato,{cAlias->ZU_DEFX5,;  		// 1 - De Valor
					cAlias->ZU_ATEFX5,;	// 2 - Ate Valor
					cAlias->ZU_PERC5}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC6)
				aAdd(aContrato,{cAlias->ZU_DEFX6,;  		// 1 - De Valor
					cAlias->ZU_ATEFX6,;	// 2 - Ate Valor
					cAlias->ZU_PERC6}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC7)
				aAdd(aContrato,{cAlias->ZU_DEFX7,;  		// 1 - De Valor
					cAlias->ZU_ATEFX7,;	// 2 - Ate Valor
					cAlias->ZU_PERC7}) // 3 - Porcentagem
			EndIf

			If (!EMPTY(cAlias->E1_BAIXA) .AND. STOD(cAlias->E1_BAIXA) <= (STOD(cAlias->E1_VENCTO) + cAlias->ZU_DIAS)) .AND. cAlias->E1_NATUREZ <> "1101006" .OR. (cAlias->ZU_EXCECAO == "1" .AND. !EMPTY(cAlias->E1_BAIXA) .AND. cAlias->E1_NATUREZ <> "1101006") .OR. MV_PAR23 = 1// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna
				lPagar := .T.
			Else
				lPagar := .F.
			Endif

			IF cVend != cAlias->E1_VEND1 .AND. lPagar

				nTotBV := 0
				nTotNoBV := 0
				nPerc := 0

				nPos := aScan(aRegistro, { |x| x[1] == cAlias->E1_VEND1})

				IF 	nPos > 0

					For I := 1 To Len(aContrato)

						If aRegistro[nPos][2] >= aContrato[I][1] .AND. aRegistro[nPos][2] <= aContrato[I][2]
							//nRecLiq :=	aRegistro[nPos][2] * (aContrato[I][3] / 100) // Valor Liquido a Receber
							nPerc := aContrato[I][3]
							Exit
						EndIf

					Next I

				ENDIF

			ENDIF

			IF cAlias->LIQUIDO > 0 .AND. lPagar

			nLin += REL_VERT_STD

			If nLin > REL_END
			u_PXRODAPE(@oPrint,"FINR006.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
			EndIf

			oPrint:Say( nLin,020, cAlias->A1_NOME								,oFonte)
			oPrint:Say( nLin,120, cAlias->E1_NUM + "/" + cAlias->E1_PARCELA		,oFonte)
			oPrint:Say( nLin,170, STOD(cAlias->E1_EMISSAO)						,oFonte)
			oPrint:Say( nLin,210, STOD(cAlias->E1_BAIXA)						,oFonte)
			oPrint:Say( nLin,250, cAlias->LIQUIDO PICTURE "@E 999,999,999.99" 	,oFonte)
			oPrint:Say( nLin,300, nPerc PICTURE "@E 99.99%"						,oFonte)

			ENDIF

			cVend := cAlias->E1_VEND1

			If lPagar == .T.
				nTotBV += cAlias->LIQUIDO
				nTotNoBV += cAlias->LIQUIDO * (nPerc / 100)
			EndIf

			DBSelectArea("cAlias")
			dbSkip() // Avanca o ponteiro do registro no arquivo

			IF cVend != cAlias->E1_VEND1 .AND. lPagar

				// Imprime Totais Aqui

			ENDIF

		ENDDO

	//Impressão do total de todas as praças
	nLin -= REL_VERT_STD
	oPrint:Say( nLin,520, PADL(Transform( nTotal, "@E 999,999,999.99"),14),oFonteN)

	nLin += (REL_VERT_STD * 3)

	//Imprime linha das assinaturas
	If !Empty(MV_PAR08) .and. PswSeek( 	MV_PAR08, .T. )
		oPrint:Say( nLin,024, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin1 := Alltrim(aUsuario[1][4])
		cCargo1 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR09) .and. PswSeek( 	MV_PAR09, .T. )
		oPrint:Say( nLin,175, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin2 := Alltrim(aUsuario[1][4])
		cCargo2 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR10) .and. PswSeek( 	MV_PAR10, .T. )
		oPrint:Say( nLin,318, "_________________________" ,oFonte10N)
		aUsuario := PswRet() // Retorna vetor com informações do usuário
		cAssin3 := Alltrim(aUsuario[1][4])
		cCargo3 := Alltrim(aUsuario[1][13])
	EndIf

	If !Empty(MV_PAR11) .and. PswSeek( 	MV_PAR11, .T. )
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

	u_PXRODAPE(@oPrint,"FINR006.PRW","")
	oPrint:EndPage()
	oPrint:Preview()
	(cAlias)->(DbCloseArea())

Return

/*/{Protheus.doc} GetData
    Busca dados no banco
    @author  Rafael França de Oliveira
    @since   24-08-2020
/*/

Static Function GetData(cPPeriodo,cPPracaDe,cPPracaAte,cPRpDe,cPRpAte)

	// Busca os registros a serem impressos no relatório
	BeginSql Alias cAlias

SELECT
E1_FILIAL,E1_VEND1,A3_NOME,A3_CGC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_PREFIXO,E1_TIPO,E1_NATUREZ,E1_NUM,E1_PARCELA,E1_VALOR
,(E1_VALOR - E1_SALDO) AS VALORLIQUIDO,E1_COMIS1, (E1_VALOR - E1_SALDO) - ((E1_COMIS1 / 100) * ((E1_VALOR - E1_SALDO))) AS LIQUIDO,
(E1_VALOR) - ((E1_COMIS1 / 100) * ((E1_VALOR))) AS LIQUIDO2,E1_EMISSAO,E1_VENCTO,E1_BAIXA,
ZU_DEFX1,ZU_ATEFX1,ZU_DEFX2,ZU_ATEFX2,ZU_DEFX3,ZU_ATEFX3,ZU_DEFX4,ZU_ATEFX4,ZU_DEFX5,ZU_ATEFX5,
ZU_DEFX6,ZU_ATEFX6,ZU_DEFX7,ZU_ATEFX7,ZU_PERC1,ZU_PERC2,ZU_PERC3,ZU_PERC4,ZU_PERC5,ZU_PERC6,
ZU_PERC7,ZU_ATEVALI,ZU_VALIDA,ZU_EXCECAO,ZU_DIAS,ED_DESCRIC,ED_TIPNAT,ED_TIPNAT
FROM SE1010
INNER JOIN SA3010 ON // Tabela de Vendedor/Agencia - Faço uma consulta do seu CNPJ
SE1010.E1_VEND1 = SA3010.A3_COD
INNER JOIN SA1010 ON  // Tabela de Cliente - Busco dados do cliente
SE1010.E1_CLIENTE = SA1010.A1_COD AND
SE1010.E1_LOJA = SA1010.A1_LOJA
INNER JOIN SZU010 ON // Tabela de Contrato Agencias - Verificos as regras para contrato
SE1010.E1_VEND1 = SZU010.ZU_VEND AND
SE1010.E1_EMISSAO BETWEEN SZU010.ZU_VALIDA AND SZU010.ZU_ATEVALI // Valido a emissão dentro do periodo do contrato
INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO // Tabela de Natureza - Busco dados da natureza
WHERE
SE1010.E1_FILIAL = '01' AND
SE1010.E1_EMISSAO BETWEEN '20210701' AND '20210731' AND
SE1010.E1_BAIXA BETWEEN '' AND '20501231' AND
SE1010.E1_NATUREZ <> '1101006' AND
SA1010.D_E_L_E_T_ <> '*'  AND
SE1010.D_E_L_E_T_ <> '*' AND
SED010.D_E_L_E_T_ <> '*' AND
SZU010.D_E_L_E_T_ <> '*'
ORDER BY E1_VEND1,E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA,E1_VENCTO

	EndSql

Return

/*/{Protheus.doc} ImpProxPag
    Imprime cabeçlho da proxima pagina
    @author  Rafael França de Oliveira
    @since   28-08-2020
/*/

Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "DEPARTAMENTO: FINANCEIRO"
	nLin := u_PXCABECA(@oPrint, "REPASSE A PAGAR - VENCIMENTO DE " + DTOC(MV_PAR06) + " ATÉ "+ DTOC(MV_PAR07), cSubTitle  , nPag)

	oPrint:Say( nLin,020, "PRAÇA",oFonteN)
	oPrint:Say( nLin,060, "STATUS",oFonteN)
	oPrint:Say( nLin,110, "TV",oFonteN)
	oPrint:Say( nLin,350, "CIDADE",oFonteN)
	oPrint:Say( nLin,460, "ESTADO",oFonteN)
	oPrint:Say( nLin,540, "VALOR",oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLin += REL_VERT_STD

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
	AADD(aRegs,{cPerg,"01","Dia do Pagamento:	","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Vendedor:			","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"03","Vendedor:			","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"04","De  Emissao:		","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Ate Emissao:		","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","De  Baixa:			","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Ate Baixa:			","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
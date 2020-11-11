#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATECC    บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o valor e a porcentagem pago de vale de refeicao บฑฑ
ฑฑ          ฑฑ  por centro de custo   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RATECC

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       	 := "Rateio"
	Local nLin           := 100
	Local cTpVal		 := ""
	Local Cabec1         := "C.Custo    Descri็ใo                             Quantidade              Rateio"
	Local Cabec2         := ""
	Local Cabec3         := ""
	Local imprime        := .T.
	Local aOrd := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 180
	Private tamanho      := "M"
	Private nomeprog     := "RATECC" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RATECC" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "RATECC9"
	Private cString      := "SRA"
	Private cQuery       := ""
	Private nPerc		 := 0
	Private	nPercTot 	 := 0
	Private	nValTot 	 := 0
	Private nTot		 := 0
	Private lOk 		 := .T.
	Private cPath		 := ""
	Private nArq 		 := 0
	Private cCusto		 := ""
	Private cDescri		 := ""


	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAวรO CANCELADA")
		return
	ENDIF


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If MV_PAR06 == 1
		titulo := "Rateio do Seguro de Vida Referente ao Perํodo: " + SUBSTR(DTOS(MV_PAR09),5,2) + "/" + SUBSTR(DTOS(MV_PAR09),1,4) + ""
	elseIf MV_PAR06 == 2
		titulo := "Rateio de Atendimento M้dico Ocupacional Referente ao Perํodo: " + SUBSTR(DTOS(MV_PAR09),5,2) + "/" + SUBSTR(DTOS(MV_PAR09),1,4) + ""
	elseIf MV_PAR06 == 3
		titulo := "Rateio do Plano Odontologico Referente ao Perํodo: " + SUBSTR(DTOS(MV_PAR09),5,2) + "/" + SUBSTR(DTOS(MV_PAR09),1,4) + ""
	elseIf MV_PAR06 == 4
		titulo := "Rateio de Plano Medico Referente ao Perํodo: " + SUBSTR(DTOS(MV_PAR09),5,2) + "/" + SUBSTR(DTOS(MV_PAR09),1,4) + ""
	EndIf


	wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

	If MV_PAR06 == 1 .OR. MV_PAR06 == 2

		cQuery := "SELECT RA_FILIAL,RA_CC,CTT_DESC01,COUNT(RA_CC) AS QUANTIDADE FROM SRA010 "
		cQuery += "INNER JOIN CTT010 ON "
		cQuery += "SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND "
		cQuery += "SRA010.RA_CC = CTT010.CTT_CUSTO "
		cQuery += "WHERE "
		cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
		cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
		cQuery += "SRA010.RA_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
		cQuery += "SRA010.RA_DEMISSA = '' AND "
		cQuery += "SRA010.RA_CATFUNC NOT IN ('E','P') AND "
		cQuery += "SRA010.RA_DEMISSA <> 'D' AND "
		cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
		cQuery += "CTT010.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY RA_FILIAL,RA_CC,CTT_DESC01 "
		cQuery += "ORDER BY RA_CC "

	Else

		If MV_PAR06 == 3
			cRCC_Cod := 'S008'
			cTpForn  := '1'
			cCodFor := '002'
		ElseIf MV_PAR06 == 4
			cRCC_Cod := 'S013'
			cTpForn  := '2'
			cCodFor := '003'
		EndIf

		cQuery := "SELECT RA_FILIAL,RA_CC,CTT_DESC01, "
		cQuery += "( "
		cQuery += "CASE WHEN SUM(RHK010.QTD_TITULAR) IS NULL THEN 0 "
		cQuery += "ELSE "
		cQuery += "SUM(RHK010.QTD_TITULAR) "
		cQuery += "END "
		cQuery += "+ "
		cQuery += "CASE WHEN SUM(RHL010.QTD_DEPENDENTE) IS NULL THEN 0 "
		cQuery += "ELSE "
		cQuery += "SUM(RHL010.QTD_DEPENDENTE) "
		cQuery += "END "
		cQuery += ") AS QUANTIDADE "

		cQuery += "FROM SRA010 "
		cQuery += "INNER JOIN CTT010 ON  "
		cQuery += "SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND  "
		cQuery += "SRA010.RA_CC = CTT010.CTT_CUSTO "

		cQuery += "LEFT JOIN (SELECT COUNT(RHK_MAT) AS QTD_TITULAR,RHK_FILIAL,RHK_PLANO,RHK_MAT,RHK_PERFIM, "
		cQuery += "RHK_TPFORN,RHK_CODFOR "
		cQuery += "FROM RHK010 "
		cQuery += "INNER JOIN RCC010 ON "
		cQuery += "RHK_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND "
		cQuery += "RCC_CODIGO = '" + cRCC_Cod + "'  AND "
		cQuery += "RCC010.D_E_L_E_T_ = '' "
		cQuery += "WHERE "
		cQuery += "RHK010.D_E_L_E_T_ = '' AND "
		cQuery += "RHK_PERFIM = '' AND "
		cQuery += "RHK_TPFORN = '" + cTpForn + "' AND "
		cQuery += "RHK_CODFOR = '" + cCodFor + "' "
		cQuery += "GROUP BY RHK_FILIAL,RHK_PLANO,RHK_MAT,RHK_PERFIM,RHK_TPFORN,RHK_CODFOR) AS RHK010 ON "
		cQuery += "RHK_FILIAL = RA_FILIAL AND "
		cQuery += "RHK_MAT = RA_MAT "

		cQuery += "LEFT JOIN (SELECT COUNT(RHL_MAT) AS QTD_DEPENDENTE,RHL_FILIAL,RHL_PLANO,RHL_MAT,RHL_PERFIM, "
		cQuery += "RHL_TPFORN,RHL_CODFOR "
		cQuery += "FROM RHL010 "
		cQuery += "INNER JOIN RCC010 ON "
		cQuery += "RHL_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND "
		cQuery += "RCC_CODIGO = '" + cRCC_Cod + "'  AND "
		cQuery += "RCC010.D_E_L_E_T_ = '' "
		cQuery += "WHERE "
		cQuery += "RHL010.D_E_L_E_T_ = '' AND "
		cQuery += "RHL_PERFIM = '' AND "
		cQuery += "RHL_TPFORN = '" + cTpForn + "' AND "
		cQuery += "RHL_CODFOR = '" + cCodFor + "' "
		cQuery += "GROUP BY RHL_FILIAL,RHL_PLANO,RHL_MAT,RHL_PERFIM,RHL_TPFORN,RHL_CODFOR) AS RHL010 ON "
		cQuery += "RHL_FILIAL = RA_FILIAL AND "
		cQuery += "RHL_MAT = RA_MAT "

		cQuery += "WHERE "

		cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
		cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
		cQuery += "SRA010.RA_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
		cQuery += "RA_SITFOLH <> 'D' AND "
		cQuery += "RA_CC BETWEEN '' AND 'zzzzzzzzz'  AND "
		cQuery += "SRA010.D_E_L_E_T_ = ''  AND "
		cQuery += "CTT010.D_E_L_E_T_ = ''  "
		cQuery += "AND (RHK010.QTD_TITULAR > 0 OR RHL010.QTD_DEPENDENTE > 0) "
		cQuery += "GROUP BY RA_FILIAL,RA_CC,CTT_DESC01 "
		cQuery += "ORDER BY RA_CC "



	EndIf

	tcQuery cQuery New Alias "TMP"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return
	Endif

	If nLastKey == 27
		dbSelectArea("TMP")
		dbCloseArea("TMP")
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

	IF MV_PAR08 == 1

		DBSelectArea("TMP")
		DBGotop()

		While !EOF()
			nTot += TMP->QUANTIDADE
			dbSkip()
		Enddo

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


			If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			nPerc := (TMP->QUANTIDADE * 100)/nTot

			@nLin, 000 PSAY TMP->RA_CC
			@nLin, 011 PSAY TMP->CTT_DESC01
			@nLin, 051 PSAY TMP->QUANTIDADE PICTURE "@E 999.99"
			@nLin, 073 PSAY nPerc PICTURE "99.99%"

			nPercTot += nPerc
			nValTot += TMP->QUANTIDADE


			dbskip()

			nLin 			+= 1 // Avanca a linha de impressao


		ENDDO

		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 051 PSAY nValTot PICTURE "@E 999.99"
		@nLin, 073 PSAY nPercTot PICTURE "999.99%"
		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"


		If !EMPTY(MV_PAR07)
			nLin += 3
			@nLin, 000 PSAY "----------------------------------------------------------------------------------"
			nLin++
			@nLin, 000 PSAY "Observa็ใo: " + ALLTRIM(MV_PAR07)
			nLin++
			@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		Endif


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

		DBSelectArea("TMP")
		DBCloseArea("TMP")

		Return

	ELSE

		Processa({|| RatMedImp() },"Exportando Rateio...")

	ENDIF

Static Function RatMedImp

	If MV_PAR06 == 1
		cPath := "C:\RATEIO\SEGVIDA.CSV"
	ELSEIF MV_PAR06 == 2
		cPath := "C:\RATEIO\PREVERMED.CSV"
	ELSEIF MV_PAR06 == 3
		cPath := "C:\RATEIO\ODONTOLOGICO.CSV"
	ELSEIF MV_PAR06 == 4
		cPath := "C:\RATEIO\MEDICO.CSV"
	EndIf

	nArq  := FCreate(cPath)

	If nArq == -1
		DBSelectARea("TMP")
		DBCloseARea("TMP")
		MsgAlert("Nao conseguiu criar o arquivo!")
		Return
	EndIf

	DBSelectArea("TMP")
	DBGotop()

	While !EOF()
		nValTot += TMP->QUANTIDADE
		dbSkip()
	Enddo

	FWrite(nArq, "CCUSTO" + ";" + "DESCRICAO" + ";" + "PERCENTUAL" + Chr(13) + Chr(10))

	DBSelectArea("TMP")
	DBGotop()

	While !EOF()

		cCusto 		:= TMP->RA_CC
		cDescri 	:= TMP->CTT_DESC01
		nPerc 		:= (TMP->QUANTIDADE * 100)/nValTot

		FWrite(nArq, ALLTRIM(cCusto) + ";" + ALLTRIM(cDescri) + ";" + Transform(ROUND(nPerc,2),"@R 99.99") + Chr(13) + Chr(10))

		dbskip()

	ENDDO


	FClose(nArq)

	DBSelectARea("TMP")
	DBCloseARea("TMP")

	oExcel := MSExcel():New()
	oExcel:WorkBooks:Open(cPath + ".CSV")
	oExcel:SetVisible(.T.)
	oExcel:Destroy()

	FErase(cPath + ".CSV")

Return

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
	AADD(aRegs,{cPerg,"06","Rateio De ?","","","mv_ch06","N",01,0,2,"C","","mv_par06","Seguro de Vida","","","","","Prevermed","","","","","Plano Odontologico","","","","","Plano Medico","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Observa็ใo ","","","mv_ch07","C",99,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Formato 		","","","mv_ch08","N",01,0,2,"C","","mv_par08","Relatorio","","","","","CSV","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Periodo?","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
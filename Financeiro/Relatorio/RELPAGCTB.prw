#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

// Relatório localizado no Financeiro/Relatorios/Especificos/Entradas a pagar Contabil
// Objetivo e conferencia de entradas no contas a pagar de acordo com a entrada - Contabilidade - Eurilene.
// Rafael França - 03/04/2020

User Function RELPAGCTB

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2    := "de acordo com os parametros informados pelo usuario."
	Local cDesc3    := "Entradas a Pagar"
	Local cPict     := ""
	Local titulo    := "Relatório por entradas - Contas a Pagar"
	Local nLin      := 80
	Local Cabec1    := "Documento       Codigo    CNPJ            Fornecedor                                  Entrada         Vlr Bruto         Historico                                                                     Emissao     Dt Baixa"
	Local Cabec2    := ""
	Local imprime   := .T.
	Local aOrd 		:= {}

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "RELPAGCTB" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "RELPAGCTB" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString    	:= "SE2"
	Private cPerg      	:= "RELPAGCTB1"
	Private cQuery 		:= ""
	Private nTotBase  	:= 0
	Private nTotComis 	:= 0

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("Operação Cancelada")
		return
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	cQuery := "SELECT E2_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO, ED_CONTA AS CCONTABIL "
	cQuery += ",E2_PREFIXO AS PREFIXO, E2_NUM AS NUMERO, E2_PARCELA AS PARCELA, E2_TIPO AS TIPO "
	cQuery += ",E2_FORNECE AS FORNECE, E2_LOJA AS LOJA, A2_CGC AS CNPJ, A2_NOME AS NOME "
	cQuery += ",E2_EMIS1 AS ENTRADA "
	cQuery += ",CASE WHEN E2_BASECOF <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASECOF "
	cQuery += "WHEN E2_BASECSL <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASECSL "
	cQuery += "WHEN E2_BASEINS <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASEINS "
	cQuery += "WHEN E2_BASEIRF <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASEIRF "
	cQuery += "WHEN E2_BASEISS <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASEISS "
	cQuery += "WHEN E2_BASEPIS <> 0 AND E2_DESDOBR <> 'S' THEN E2_BASEPIS "
	cQuery += "WHEN E2_VALOR   <> 0 THEN E2_VALOR END AS VLBRUTO "
	cQuery += ",E2_HIST AS HISTORICO "
	cQuery += ",E2_EMISSAO AS EMISSAO "
	cQuery += ",E2_BAIXA AS BAIXA "
	cQuery += ",E2_VALOR AS VALOR "
	cQuery += ",E2_MULTNAT AS RATEIO "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' "
	cQuery += "INNER JOIN SED010 ON E2_NATUREZ = ED_CODIGO AND SED010.D_E_L_E_T_ = '' "
	cQuery += "WHERE SE2010.D_E_L_E_T_ = '' "
	cQuery += "AND E2_EMIS1 BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery += "AND E2_BAIXA BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' "
	cQuery += "AND E2_NATUREZ BETWEEN '" +  (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "
	cQuery += "AND E2_FORNECE BETWEEN '" +  (MV_PAR09) + "' AND '" + (MV_PAR10) + "' "
	cQuery += "AND E2_TIPO NOT IN ('ISS','INS','PA','TX') " // Impostos e pagamentos antecipados
	cQuery += "AND E2_STATUS NOT IN ('D') "	// Desdobramentos
	cQuery += "AND E2_FILIAL = '" + (MV_PAR05) + "' AND E2_MULTNAT <> '1' "
	cQuery += "UNION "
	cQuery += "SELECT EV_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO, ED_CONTA AS CCONTABIL "
	cQuery += ",E2_PREFIXO AS PREFIXO, E2_NUM AS NUMERO, E2_PARCELA AS PARCELA, E2_TIPO AS TIPO "
	cQuery += ",E2_FORNECE AS FORNECE, E2_LOJA AS LOJA, A2_CGC AS CNPJ, A2_NOME AS NOME "
	cQuery += ",E2_EMIS1 AS ENTRADA "
	cQuery += ",EV_VALOR AS VLBRUTO "
	cQuery += ",E2_HIST AS HISTORICO "
	cQuery += ",E2_EMISSAO AS EMISSAO "
	cQuery += ",E2_BAIXA AS BAIXA "
	cQuery += ",E2_VALOR AS VALOR "
	cQuery += ",E2_MULTNAT AS RATEIO "
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND SA2010.D_E_L_E_T_ = '' "
	cQuery += "INNER JOIN SEV010 ON EV_FILIAL = E2_FILIAL AND EV_PREFIXO = E2_PREFIXO AND EV_NUM = E2_NUM AND EV_TIPO = E2_TIPO AND EV_PARCELA = E2_PARCELA AND EV_CLIFOR = E2_FORNECE AND EV_LOJA = E2_LOJA AND SEV010.D_E_L_E_T_ = '' "
	cQuery += "INNER JOIN SED010 ON EV_NATUREZ = ED_CODIGO AND SED010.D_E_L_E_T_ = '' "
	cQuery += "WHERE SE2010.D_E_L_E_T_ = '' "
	cQuery += "AND E2_EMIS1 BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery += "AND E2_BAIXA BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' "
	cQuery += "AND EV_NATUREZ BETWEEN '" +  (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "
	cQuery += "AND E2_FORNECE BETWEEN '" +  (MV_PAR09) + "' AND '" + (MV_PAR10) + "' "
	cQuery += "AND E2_TIPO NOT IN ('ISS','INS','PA','TX') " // Impostos e pagamentos antecipados
	cQuery += "AND E2_STATUS NOT IN ('D') "	// Desdobramentos
	cQuery += "AND E2_FILIAL = '" + (MV_PAR05) + "' AND E2_MULTNAT = '1' "
	IF MV_PAR08 == 1
	cQuery += "ORDER BY NATUREZA, ENTRADA, NUMERO, PREFIXO, PARCELA "
	ELSEIF MV_PAR08 == 2
	cQuery += "ORDER BY NATUREZA, NUMERO, PREFIXO, PARCELA "
	ELSE
	cQuery += "ORDER BY NATUREZA, FORNECE, ENTRADA, NUMERO, PREFIXO, PARCELA "
	ENDIF

	TcQuery cQuery New Alias "TMPSE2"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMPSE2")
		dbCloseArea("TMPSE2")
		Return
	Endif

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  24/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local lOk 		:= .F.
	Local nReg 		:= 0
	Local cNat 		:= ""
	Local cDescri	:= ""
	Local cConta	:= ""
	Local nNat		:= 0
	Local nTotal 	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetRegua(RecCount())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
	//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
	//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
	//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
	//³                                                                     ³
	//³ dbSeek(xFilial())                                                   ³
	//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DBSelectArea("TMPSE2")
	DBgotop()
	While !EOF()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:

		If cNat <> TMPSE2->NATUREZA

			@nLin,00 PSAY TMPSE2->NATUREZA
			@nLin,10 PSAY TMPSE2->DESCRICAO
			@nLin,60 PSAY TMPSE2->CCONTABIL

			nLin += 1

			@nLin,00 PSAY REPLICATE("-",limite)

			nLin += 1

		Endif

		@nLin,000 PSAY ALLTRIM(TMPSE2->NUMERO) + "/" + TMPSE2->PARCELA
		@nLin,016 PSAY ALLTRIM(TMPSE2->FORNECE) + "/" + TMPSE2->LOJA
		@nLin,026 PSAY TMPSE2->CNPJ
		@nLin,042 PSAY SUBSTR(TMPSE2->NOME,1,40)
		@nLin,086 PSAY STOD(TMPSE2->ENTRADA)
		@nLin,098 PSAY TRANSFORM(TMPSE2->VLBRUTO,"@e 99,999,999.99")
		@nLin,120 PSAY SUBSTR(TMPSE2->HISTORICO,1,75)
		@nLin,198 PSAY STOD(TMPSE2->EMISSAO)
		@nLin,210 PSAY STOD(TMPSE2->BAIXA)

		cNat 		:= TMPSE2->NATUREZA
		cDescri		:= TMPSE2->DESCRICAO
		cConta		:= TMPSE2->CCONTABIL
		nNat		+= TMPSE2->VLBRUTO
		nTotal 		+= TMPSE2->VLBRUTO

		nReg	+= 1

		nLin 	+= 1 // Avanca a linha de impressao

		DBSelectArea("TMPSE2")
		dbSkip() // Avanca o ponteiro do registro no arquivo

		If cNat <> TMPSE2->NATUREZA

			@nLin,00 PSAY REPLICATE("-",limite)

			nLin 	+= 1

			@nLin,000 PSAY cNat
			@nLin,010 PSAY cDescri
			@nLin,060 PSAY cConta
			@nLin,098 PSAY TRANSFORM(nNat,"@e 99,999,999.99")

			nNat := 0

			nLin += 2

		EndIf

	EndDo

	@nLin,000 PSAY "TOTAL GERAL ---->"
	@nLin,098 PSAY TRANSFORM(nTotal,"@e 99,999,999.99")

	DBSelectARea("TMPSE2")
	DBCloseArea("TMPSE2")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Da Natureza		","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"02","Ate Natureza	","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"03","Da Entrada 		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Ate a Entrada 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Filial			","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"06","Da Baixa 		","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Ate a Baixa	 	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Ordem			","","","mv_ch08","C",01,0,0,"C","","mv_par08","Dt. Digitação","","","","","Titulo","","","","","Fornecedor","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Do Fornecedor	","","","mv_ch09","C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
	AADD(aRegs,{cPerg,"10","Ate o Fornecedor	","","","mv_ch10","C",09,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})

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
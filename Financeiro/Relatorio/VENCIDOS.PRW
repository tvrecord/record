#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATFDEPR   º Autor ³ Rafael Franca      º Data ³ 14/12/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Posição dos titulos por tempo de vencimento                 º±±
±±|          |     														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VENCREC

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variavei                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       	 := "Títulos a Receber por vencimento"

	Local Cabec1         := " Conta  Cliente                                   Titulo              Emissao    Vencimento           Valor        Dias Venc."
	Local Cabec2         := ""
	Local Cabec3         := ""
	Local imprime        := .T.
	Local aOrd := {}

	Private nLin         := 100
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "VENCREC"// Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "VENCREC"// Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "VENCREC9"
	Private cString      := "SE1"
	Private cQuery       := ""
	Private nCont	     := 0

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAÇÃO CANCELADA")
		return
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

	IF MV_PAR20 == 1

		cQuery := "SELECT SUBSTRING(A1_CONTA,1,5) AS CONTA, "
		cQuery += "(E1_CLIENTE + ' - ' + E1_NOMCLI) AS CLIFOR,(E1_PREFIXO + '-' + E1_NUM) AS TITULO,E1_EMISSAO AS EMISSAO,E1_VENCREA AS VENCREA, "
		cQuery += "(E1_SALDO + E1_JUROS + E1_ACRESC) AS VALOR, E1_NATUREZ AS NATUREZA,E1_PREFIXO AS PREFIXO,E1_NUM AS NUMERO,E1_PARCELA AS PARCELA,E1_TIPO AS TIPO, "
		cQuery += "E1_CLIENTE AS CLIFOR2, E1_LOJA AS LOJA,E1_FILIAL AS FILIAL "
		cQuery += "FROM SE1010 "
		cQuery += "INNER JOIN SA1010 ON "
		cQuery += "A1_COD = E1_CLIENTE "
		cQuery += "AND A1_LOJA = E1_LOJA "
		cQuery += "WHERE SE1010.D_E_L_E_T_ = '' AND SA1010.D_E_L_E_T_ = '' AND (E1_SALDO > 0 OR E1_BAIXA >= '"+DTOS(MV_PAR19)+"') "
		cQuery += "AND E1_EMIS1 <= '"+DTOS(MV_PAR19)+"' "
		cQuery += "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-','RA') AND E1_PREFIXO NOT IN ('MAX') "
		IF MV_PAR24 == 1  //03/12/18 - Rafael França - Colocado para atender a solicitação de SP no relatorio Aging List. O objetivo da mudança é separar os titulos do governo dos demais.
			cQuery += "AND E1_NATUREZ IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049') "
		ELSEIF MV_PAR24 == 2
			cQuery += "AND E1_NATUREZ NOT IN ('1101001','110100101','1101012','110101701','110101702','1101019','1101045','110104701','1101049') "
		END
		cQuery += "AND E1_FILIAL BETWEEN '"+(MV_PAR17)+"' AND '"+(MV_PAR18)+"' "
		cQuery += "AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR19)+"' "
		cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' "
		cQuery += "AND E1_NUM BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
		cQuery += "AND A1_CONTA BETWEEN '"+(MV_PAR22)+"' AND '"+(MV_PAR23)+"' "
		cQuery += "ORDER BY VENCREA,CLIFOR "

	ELSE

		cQuery := "SELECT SUBSTRING(A2_CONTA,1,5) AS CONTA, "
		cQuery += "(E2_FORNECE + ' - ' + E2_NOMFOR) AS CLIFOR,(E2_PREFIXO + '-' + E2_NUM) AS TITULO,E2_EMISSAO AS EMISSAO,E2_VENCREA AS VENCREA, "
		cQuery += "(E2_SALDO + E2_JUROS + E2_ACRESC) AS VALOR, E2_NATUREZ AS NATUREZA,E2_PREFIXO AS PREFIXO,E2_NUM AS NUMERO,E2_PARCELA AS PARCELA,E2_TIPO AS TIPO, "
		cQuery += "E2_FORNECE AS CLIFOR2, E2_LOJA AS LOJA,E2_FILIAL AS FILIAL "
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON "
		cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD "
		cQuery += "AND E2_LOJA = SA2010.A2_LOJA "
		cQuery += "WHERE SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' AND (E2_SALDO > 0 OR E2_BAIXA >= '"+DTOS(MV_PAR19)+"') "
		cQuery += "AND E2_TIPO NOT IN ('CS-','IR-','PI-','CF-','PA') "
		cQuery += "AND E2_EMIS1 <= '"+DTOS(MV_PAR19)+"' "
		cQuery += "AND E2_FILIAL BETWEEN '"+(MV_PAR17)+"' AND '"+(MV_PAR18)+"' "
		cQuery += "AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		cQuery += "AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR19)+"' "
		cQuery += "AND E2_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' "
		cQuery += "AND E2_NUM BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
		cQuery += "AND A2_CONTA BETWEEN '"+(MV_PAR22)+"' AND '"+(MV_PAR23)+"' "
		cQuery += "ORDER BY VENCREA,CLIFOR "

	ENDIF

	tcQuery cQuery New Alias "TMPVEN"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMPVEN")
		dbCloseArea("TMPVEN")
		Return
	Endif

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	IF MV_PAR20 == 1
		titulo 	:= "Títulos a Receber por vencimento - " + DTOC(MV_PAR19)
		Cabec1  := " Conta  Cliente                                   Titulo              Emissao    Vencimento           Valor        Dias Venc."
	ELSE
		titulo 	:= "Títulos a Pagar por vencimento - " + DTOC(MV_PAR19)
		Cabec1 	:= " Conta  Fornecedor                                Titulo              Emissao    Vencimento           Valor        Dias Venc."
	ENDIF
	nTipo  := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/09   º±±
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

	Local aTitulos 	 	:= {}
	Local aSubTotal		:= {}
	Local aSubTotal1	:= {}
	Local nDiasVenc		:= 0   	//Verifica a quantidade de dias vencidos
	Local cSubTotal		:= ""  	//Subtotal para vencimentos de acordo com os parametros 10-16
	Local cSubTotal1	:= ""   //SubTotal entre vencidos e a vencer
	Local cSubDesc		:= ""
	Local nSubTotal		:= 0  	//Subtotal para vencimentos de acordo com os parametros 10-16
	Local nSubTotal1	:= 0   	//SubTotal entre vencidos e a vencer
	Local nCont			:= 0    //SubTotal de Quantidades
	Local lOk			:= .F.
	Local nPos          := 0
	Local nCol			:= 0
	Local nNum			:= 0
	Local nSaldo		:= 0
	Local cCarteira		:= "R"
	Local cTabela	    := "SE1"


	DBSelectArea("TMPVEN")
	DBGotop()

	//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

	While !EOF()

		SetRegua(RecCount())

		IF MV_PAR20 == 2

			DbSelectArea("SE2")
			DbSetOrder(1)
			DbSeek(TMPVEN->FILIAL + TMPVEN->PREFIXO +TMPVEN->NUMERO + TMPVEN->PARCELA + TMPVEN->TIPO + TMPVEN->CLIFOR2 + TMPVEN->LOJA)

			nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,MV_PAR19,MV_PAR19,SE2->E2_LOJA,SE2->E2_FILIAL)

		ELSE

			DbSelectArea("SE1")
			DbSetOrder(1)
			DbSeek(TMPVEN->FILIAL + TMPVEN->PREFIXO +TMPVEN->NUMERO + TMPVEN->PARCELA + TMPVEN->TIPO)

			nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,MV_PAR19,MV_PAR19,SE1->E1_LOJA,SE1->E1_FILIAL)

		ENDIF

		IF nSaldo > 0

			nDiasVenc := STOD(TMPVEN->VENCREA) - MV_PAR19

			IF nDiasVenc <= (VAL(MV_PAR16) * -1)  //Separa os Grupos de Vencimentos
				cSubTotal		:= "1"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR16)+1) + " OU +"
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR15) * -1) .AND. nDiasVenc >= (VAL(MV_PAR16) * -1)
				cSubTotal		:= "2"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR15)+1) + " - " + ALLTRIM(MV_PAR16)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR14) * -1) .AND. nDiasVenc >= (VAL(MV_PAR15) * -1)
				cSubTotal		:= "3"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR14)+1) + " - " + ALLTRIM(MV_PAR15)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR13) * -1) .AND. nDiasVenc >= (VAL(MV_PAR14) * -1)
				cSubTotal		:= "4"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR13)+1) + " - " + ALLTRIM(MV_PAR14)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR12) * -1) .AND. nDiasVenc >= (VAL(MV_PAR13) * -1)
				cSubTotal		:= "5"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR12)+1) + " - " + ALLTRIM(MV_PAR13)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR11) * -1) .AND. nDiasVenc >= (VAL(MV_PAR12) * -1)
				cSubTotal		:= "6"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR11)+1) + " - " + ALLTRIM(MV_PAR12)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR10) * -1) .AND. nDiasVenc >= (VAL(MV_PAR11) * -1)
				cSubTotal		:= "7"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR10)+1) + " - " + ALLTRIM(MV_PAR11)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc < (VAL(MV_PAR09) * -1) .AND. nDiasVenc >= (VAL(MV_PAR10) * -1)
				cSubTotal		:= "8"
				cSubDesc		:= "VENCIDOS " + cValToChar(VAL(MV_PAR09)+1) + " - " + ALLTRIM(MV_PAR10)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc >= (VAL(MV_PAR09) * -1) .AND. nDiasVenc < 0
				cSubTotal		:= "9"
				cSubDesc		:= "VENCIDOS 01 - " + ALLTRIM(MV_PAR09)
				cSubTotal1		:= "1"

			ELSEIF nDiasVenc <= VAL(MV_PAR09) .AND. nDiasVenc >= 0
				cSubTotal		:= "10"
				cSubDesc		:= "A VENCER 00 - " + ALLTRIM(MV_PAR09)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR09) .AND. nDiasVenc <= VAL(MV_PAR10)
				cSubTotal		:= "11"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR09)+1) + " - " + ALLTRIM(MV_PAR10)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR10) .AND. nDiasVenc <= VAL(MV_PAR11)
				cSubTotal		:= "12"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR10)+1) + " - " + ALLTRIM(MV_PAR11)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR11) .AND. nDiasVenc <= VAL(MV_PAR12)
				cSubTotal		:= "13"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR11)+1) + " - " + ALLTRIM(MV_PAR12)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR12) .AND. nDiasVenc <= VAL(MV_PAR13)
				cSubTotal		:= "14"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR12)+1) + " - " + ALLTRIM(MV_PAR13)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR13) .AND. nDiasVenc <= VAL(MV_PAR14)
				cSubTotal		:= "15"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR13)+1) + " - " + ALLTRIM(MV_PAR14)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR14) .AND. nDiasVenc <= VAL(MV_PAR15)
				cSubTotal		:= "16"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR14)+1) + " - " + ALLTRIM(MV_PAR15)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR15) .AND. nDiasVenc <= VAL(MV_PAR16)
				cSubTotal		:= "17"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR15)+1) + " - " + ALLTRIM(MV_PAR16)
				cSubTotal1		:= "2"

			ELSEIF nDiasVenc > VAL(MV_PAR16)
				cSubTotal		:= "18"
				cSubDesc		:= "A VENCER " + cValToChar(VAL(MV_PAR16)+1) + " OU +"
				cSubTotal1		:= "2"
			ENDIF

			aAdd(aTitulos,{TMPVEN->CONTA,; //1
				TMPVEN->CLIFOR,; //2
				TMPVEN->TITULO,; //3
				STOD(TMPVEN->EMISSAO),; //4
				STOD(TMPVEN->VENCREA),; //5
				TMPVEN->NATUREZA,;	//6
				nSaldo,; //7
				nDiasVenc,; //8
				cSubTotal,; //9
				cSubDesc,; //10
				cSubTotal1}) //11

		ENDIF

		dbSelectArea ("TMPVEN")
		dbskip()

	ENDDO

	dbSelectArea("TMPVEN")
	dbCloseArea("TMPVEN")

	ASORT(aTitulos,,,{|x,y|x[1] < y[1]})

	//Totais Vencidos

	For i:=1 to Len(aTitulos)

		IF aTitulos[i][11] == "1"

			IF cSubTotal != ALLTRIM(aTitulos[i][1])
				aAdd(aSubTotal,{ALLTRIM(aTitulos[i][1]),0,0,0,0,0,0,0,0,0,0})
				nNum += 1
			ENDIF

			cSubTotal := ALLTRIM(aTitulos[i][1])

		ENDIF

	Next

	aAdd(aSubTotal,{"TOTAL",0,0,0,0,0,0,0,0,0,0})
	nNum += 1
	cSubTotal := ""

	For i:=1 to Len(aTitulos)

		IF aTitulos[i][11] == "1"

			nPos := aScan(aSubTotal, { |x| x[1] == ALLTRIM(aTitulos[i][1])})
			nCol := VAL(aTitulos[i][9]) + 1

			aSubTotal[nPos][nCol] += aTitulos[i][7]
			aSubTotal[nNum][nCol] += aTitulos[i][7]
			aSubTotal[nPos][11]   += aTitulos[i][7]
			aSubTotal[nNum][11]   += aTitulos[i][7]

		Endif

	Next

	//Totais a Vencer

	nNum := 0

	For i:=1 to Len(aTitulos)

		IF aTitulos[i][11] == "2"

			IF cSubTotal != ALLTRIM(aTitulos[i][1])
				aAdd(aSubTotal1,{ALLTRIM(aTitulos[i][1]),0,0,0,0,0,0,0,0,0,0})
				nNum += 1
			ENDIF

			cSubTotal := ALLTRIM(aTitulos[i][1])

		ENDIF

	Next

	aAdd(aSubTotal1,{"TOTAL",0,0,0,0,0,0,0,0,0,0})
	nNum += 1
	cSubTotal := ""

	For i:=1 to Len(aTitulos)

		IF aTitulos[i][11] == "2"

			nPos := aScan(aSubTotal1, { |x| x[1] == ALLTRIM(aTitulos[i][1])})
			nCol := VAL(aTitulos[i][9]) - 8

			aSubTotal1[nPos][nCol] += aTitulos[i][7]
			aSubTotal1[nNum][nCol] += aTitulos[i][7]
			aSubTotal1[nPos][11]   += aTitulos[i][7]
			aSubTotal1[nNum][11]   += aTitulos[i][7]

		Endif

	Next

	ASORT(aTitulos,,,{|x,y|DTOS(x[5])+x[1] < DTOS(y[5])+y[1]})

	cSubTotal		:= ""
	cSubDesc		:= ""

	IF MV_PAR21 != 2

		For i:=1 to Len(aTitulos)

			If lAbortPrint    //Verifica o cancelamento pelo usuario...
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			If nLin > 65 // Salto de Página. Neste caso o formulario tem 65 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			IF cSubTotal != aTitulos[i][9] .AND. lOk
				@nLin, 001 PSAY "SUBTOTAL " + cSubDesc
				@nLin, 093 PSAY nSubTotal PICTURE "@E 999,999,999.99"
				@nLin, 120 PSAY nCont PICTURE "@E 99999"
				nSubTotal  		:= 0
				nCont 			:= 0
				nLin += 2
			ENDIF

			IF cSubTotal != aTitulos[i][9]
				@nLin, 001 PSAY aTitulos[i][10]
				nLin += 1
				lOk := .T.
			ENDIF

			@nLin, 001 PSAY aTitulos[i][1]
			@nLin, 008 PSAY SUBSTR(aTitulos[i][2],1,40)
			@nLin, 050 PSAY aTitulos[i][3]
			@nLin, 069 PSAY aTitulos[i][4]
			@nLin, 081 PSAY aTitulos[i][5]
			@nLin, 093 PSAY aTitulos[i][7] PICTURE "@E 999,999,999.99"
			@nLin, 120 PSAY aTitulos[i][8] PICTURE "@E 99999"

			nLin += 1

			cSubTotal		:= aTitulos[i][9]
			cSubDesc		:= aTitulos[i][10]
			nSubTotal  		+= aTitulos[i][7]
			nCont 			+= 1

		Next

		@nLin, 001 PSAY "SUBTOTAL " + cSubDesc
		@nLin, 093 PSAY nSubTotal PICTURE "@E 999,999,999.99"
		@nLin, 120 PSAY nCont PICTURE "@E 99999"
		nSubTotal  		:= 0
		nCont 			:= 0

	ENDIF

	IF MV_PAR21 != 1

		nLin 			:= 100

		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin, 001 PSAY "VENCIDOS"
		@nLin, 034 PSAY PADL(cValToChar(VAL(MV_PAR16)+1) + " OU +",14)
		@nLin, 053 PSAY PADL(cValToChar(VAL(MV_PAR15)+1) + " - " + ALLTRIM(MV_PAR16),14)
		@nLin, 072 PSAY PADL(cValToChar(VAL(MV_PAR14)+1) + " - " + ALLTRIM(MV_PAR15),14)
		@nLin, 091 PSAY PADL(cValToChar(VAL(MV_PAR13)+1) + " - " + ALLTRIM(MV_PAR14),14)
		@nLin, 110 PSAY PADL(cValToChar(VAL(MV_PAR12)+1) + " - " + ALLTRIM(MV_PAR13),14)
		@nLin, 129 PSAY PADL(cValToChar(VAL(MV_PAR11)+1) + " - " + ALLTRIM(MV_PAR12),14)
		@nLin, 148 PSAY PADL(cValToChar(VAL(MV_PAR10)+1) + " - " + ALLTRIM(MV_PAR11),14)
		@nLin, 167 PSAY PADL(cValToChar(VAL(MV_PAR09)+1) + " - " + ALLTRIM(MV_PAR10),14)
		@nLin, 186 PSAY PADL("01 - " + ALLTRIM(MV_PAR09),14)
		@nLin, 205 PSAY PADL("TOTAL",14)

		nLin 			+= 1

		For i:=1 to Len(aSubTotal)

			@nLin, 001 PSAY aSubTotal[i][1]
			@nLin, 007 PSAY	SUBSTR(Posicione("CT1",1,xfilial("CT1")+aSubTotal[i][1],"CT1_DESC01"),1,19)
			@nLin, 034 PSAY aSubTotal[i][2]  PICTURE "@E 999,999,999.99"
			@nLin, 053 PSAY aSubTotal[i][3]  PICTURE "@E 999,999,999.99"
			@nLin, 072 PSAY aSubTotal[i][4]  PICTURE "@E 999,999,999.99"
			@nLin, 091 PSAY aSubTotal[i][5]  PICTURE "@E 999,999,999.99"
			@nLin, 110 PSAY aSubTotal[i][6]  PICTURE "@E 999,999,999.99"
			@nLin, 129 PSAY aSubTotal[i][7]  PICTURE "@E 999,999,999.99"
			@nLin, 148 PSAY aSubTotal[i][8]  PICTURE "@E 999,999,999.99"
			@nLin, 167 PSAY aSubTotal[i][9]  PICTURE "@E 999,999,999.99"
			@nLin, 186 PSAY aSubTotal[i][10] PICTURE "@E 999,999,999.99"
			@nLin, 205 PSAY aSubTotal[i][11] PICTURE "@E 999,999,999.99"

			nLin 			+= 1

		Next

		nLin 			+= 4

		@nLin, 001 PSAY "A VENCER"
		@nLin, 034 PSAY PADL("00 - " + ALLTRIM(MV_PAR09),14)
		@nLin, 053 PSAY PADL(cValToChar(VAL(MV_PAR09)+1) + " - " + ALLTRIM(MV_PAR10),14)
		@nLin, 072 PSAY PADL(cValToChar(VAL(MV_PAR10)+1) + " - " + ALLTRIM(MV_PAR11),14)
		@nLin, 091 PSAY PADL(cValToChar(VAL(MV_PAR11)+1) + " - " + ALLTRIM(MV_PAR12),14)
		@nLin, 110 PSAY PADL(cValToChar(VAL(MV_PAR12)+1) + " - " + ALLTRIM(MV_PAR13),14)
		@nLin, 129 PSAY PADL(cValToChar(VAL(MV_PAR13)+1) + " - " + ALLTRIM(MV_PAR14),14)
		@nLin, 148 PSAY PADL(cValToChar(VAL(MV_PAR14)+1) + " - " + ALLTRIM(MV_PAR15),14)
		@nLin, 167 PSAY PADL(cValToChar(VAL(MV_PAR15)+1) + " - " + ALLTRIM(MV_PAR16),14)
		@nLin, 186 PSAY PADL(cValToChar(VAL(MV_PAR16)+1) + " OU +",14)
		@nLin, 205 PSAY PADL("TOTAL",14)

		nLin 			+= 1

		For i:=1 to Len(aSubTotal1)

			@nLin, 001 PSAY aSubTotal1[i][1]
			@nLin, 007 PSAY	SUBSTR(Posicione("CT1",1,xfilial("CT1")+aSubTotal1[i][1],"CT1_DESC01"),1,19)
			@nLin, 034 PSAY aSubTotal1[i][2]  PICTURE "@E 999,999,999.99"
			@nLin, 053 PSAY aSubTotal1[i][3]  PICTURE "@E 999,999,999.99"
			@nLin, 072 PSAY aSubTotal1[i][4]  PICTURE "@E 999,999,999.99"
			@nLin, 091 PSAY aSubTotal1[i][5]  PICTURE "@E 999,999,999.99"
			@nLin, 110 PSAY aSubTotal1[i][6]  PICTURE "@E 999,999,999.99"
			@nLin, 129 PSAY aSubTotal1[i][7]  PICTURE "@E 999,999,999.99"
			@nLin, 148 PSAY aSubTotal1[i][8]  PICTURE "@E 999,999,999.99"
			@nLin, 167 PSAY aSubTotal1[i][9]  PICTURE "@E 999,999,999.99"
			@nLin, 186 PSAY aSubTotal1[i][10] PICTURE "@E 999,999,999.99"
			@nLin, 205 PSAY aSubTotal1[i][11] PICTURE "@E 999,999,999.99"

			nLin 			+= 1

		Next

	ENDIF

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

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Do  Cli / For","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Ate Cli / For","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Do  Titulo 	 ","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Ate Titulo 	 ","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Da  Emissao  ","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Ate Emissao  ","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Do  Vencimento","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Ate Vencimento","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"09","Data 1		 ","","","mv_ch09","C",04,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Data 2		 ","","","mv_ch10","C",04,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Data 3 		 ","","","mv_ch11","C",04,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Data 4 		 ","","","mv_ch12","C",04,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Data 5 		 ","","","mv_ch13","C",04,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","Data 6 		 ","","","mv_ch14","C",04,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"15","Data 7 		 ","","","mv_ch15","C",04,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"16","Data 8		 ","","","mv_ch16","C",04,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"17","Da  Filial	 ","","","mv_ch17","C",02,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"18","Ate Filial   ","","","mv_ch18","C",02,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"19","Dt Referencia","","","mv_ch19","D",08,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Da Carteira  ","","","mv_ch20","N",01,0,1,"C","","mv_par20","Receber","","","","","Pagar","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"21","Tp Relatorio ","","","mv_ch21","N",01,0,1,"C","","mv_par21","Analitico","","","","","Sintetico","","","","","Ambos","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"22","Da  Conta    ","","","mv_ch22","C",20,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
	AADD(aRegs,{cPerg,"23","Ate Conta    ","","","mv_ch23","C",20,0,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
	aAdd(aRegs,{cPerg,"24","Filtra Clientes","","","mv_ch24","N",01,0,1,"C","","mv_par24","Governo","","","","","Clientes","","","","","Ambos","","","","","","","","","","","","","","",""})

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
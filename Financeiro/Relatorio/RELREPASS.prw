#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELREPASS   º Autor ³ Rafael Franca      º Data ³ 20/11/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Repasse a pagar por RP                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELREPASS()                                    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       	 := UPPER("Repasse a pagar")
	Local nLin           := 80

	Local Cabec1         := UPPER("NUM. RP  NF        CLIENTE                                                BAIXA          PRAÇA                                             NOTA                     VALOR")
	Local Cabec2         := ""
	Local Cabec3         := ""
	Local imprime        := .T.
	Local aOrd := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RELREPASS" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RELREPASS" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cPerg	     := "RELREPASS2"
	Private cString      := "SC5"
	Private cQuery       := ""
	Private nCont	     := 0
	Private lOk1         := .T.

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAÇÃO CANCELADA")
		return
	ENDIF                 


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)


	//Imprimir relatorio com dados Financeiros ou de Clientes
	IF !Empty (MV_PAR06)
		Titulo := ALLTRIM(Titulo) + " - " + UPPER(MesExtenso(MONTH(MV_PAR06)))
	ENDIF	

	cQuery := "SELECT C5_PRAREP AS PRACA, C5_NUMRP AS RP, C5_NOTA AS NOTA, E1_VALOR AS VALOR "
	cQuery += ", TRIM(E1_CLIENTE) + '/' + TRIM(E1_NOMCLI) AS CLIENTE, E1_BAIXA AS BAIXA, C5_VLREP AS VLREPASSE "
	cQuery += "FROM SC5010 " 
	cQuery += "INNER JOIN SE1010 ON E1_NUM = C5_NUM AND E1_SERIE = C5_SERIE AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA = C5_LOJACLI "
	cQuery += "WHERE SC5010.D_E_L_E_T_ = '' AND SE1010.D_E_L_E_T_ = '' "
	cQuery += "AND C5_NUMRP IN " + FormatIn(MV_PAR02,",") + " "

	tcQuery cQuery New Alias "TMP"

	If Eof()
		MsgInfo("Não foram encontradas as RPs para pagamento!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return
	Endif

	cQuery := "SELECT E2_NUM AS NUMERO, E2_FORNECE AS CODIGO, A2_NOME AS NOME, TRIM(A2_MUN) + '/' + A2_EST AS CIDADE, E2_VALOR AS VALOR, A2_CGC AS CNPJ 
	cQuery += "FROM SE2010 "
	cQuery += "INNER JOIN SA2010 ON E2_FORNECE = A2_COD AND  E2_LOJA = A2_LOJA "
	cQuery += "WHERE SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' AND E2_FORNECE = '" + (MV_PAR01) + "' "
	cQuery += "AND E2_NUM IN " + FormatIn(MV_PAR03,",") + " AND E2_NATUREZ = '1204009' AND SUBSTRING(E2_EMISSAO,1,4) >= '2016'"


	tcQuery cQuery New Alias "TMP1"

	If Eof()
		MsgInfo("Não foram encontradas as notas fiscais para pagamento!","Verifique")
		dbSelectArea("TMP1")
		dbCloseArea("TMP1")
		Return
	Endif

	IF !Empty(MV_PAR04)	

		cQuery := "SELECT C5_PRAREP AS PRACA, C5_NUMRP AS RP, C5_NOTA AS NOTA, E1_VALOR AS VALOR "
		cQuery += ", TRIM(E1_CLIENTE) + '/' + TRIM(E1_NOMCLI) AS CLIENTE, E1_BAIXA AS BAIXA, C5_VLREP AS VLREPASSE "
		cQuery += "FROM SC5010 " 
		cQuery += "INNER JOIN SE1010 ON E1_NUM = C5_NUM AND E1_SERIE = C5_SERIE AND E1_CLIENTE = C5_CLIENTE AND E1_LOJA = C5_LOJACLI "
		cQuery += "WHERE SC5010.D_E_L_E_T_ = '' AND SE1010.D_E_L_E_T_ = '' "
		cQuery += "AND C5_NUMRP IN " + FormatIn(MV_PAR04,",") + " "

		tcQuery cQuery New Alias "TMP2"

		If Eof()
			MsgInfo("Não foram encontradas as RPs em aberto!","Verifique")	
			lOk1 := .F.
			dbSelectArea("TMP2")
			dbCloseArea("TMP2")
		Endif

		cQuery := "SELECT E2_NUM AS NUMERO, E2_FORNECE AS CODIGO, A2_NOME AS NOME, TRIM(A2_MUN) + '/' + A2_EST AS CIDADE, E2_VALOR AS VALOR, A2_CGC AS CNPJ 
		cQuery += "FROM SE2010 "
		cQuery += "INNER JOIN SA2010 ON E2_FORNECE = A2_COD AND  E2_LOJA = A2_LOJA "
		cQuery += "WHERE SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' AND E2_FORNECE = '" + (MV_PAR01) + "' "
		cQuery += "AND E2_NUM IN " + FormatIn(MV_PAR05,",") + " AND E2_NATUREZ = '1204009' AND SUBSTRING(E2_EMISSAO,1,4) >= '2016'"


		tcQuery cQuery New Alias "TMP3"

		If Eof()
			MsgInfo("Não foram encontradas as notas fiscais em aberto!","Verifique")
			dbSelectArea("TMP3")
			dbCloseArea("TMP3")		
		Endif

	ELSE

		lOk1 := .F.

	EndIF

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

	Local cPraca 	 	:= ""
	Local aRegistroP	:= {}
	Local aRegistroA	:= {}	
	Local nCont1		:= 0
	Local nCont2		:= 0
	Local lOk 			:= .T.
	Local nTotalP		:= 0
	Local nTotalA		:= 0	

	//Separa notas em aberto

	IF lOk1

		DBSelectArea("TMP2")
		DBGotop()
		While !EOF()

			nCont1 += 1

			aAdd(aRegistroA,{TMP2->RP,;
			TMP2->NOTA,; 
			SUBSTR(TMP2->CLIENTE,1,50),;			
			STOD(TMP2->BAIXA),;
			"",;
			"",;
			"",;
			"",;									
			0,;
			""})

			dbSkip()

		ENDDO

		DBSelectArea("TMP2")
		DBCloseArea("TMP2")

		DBSelectArea("TMP3")
		DBGotop()
		While !EOF()

			nCont2 += 1

			aRegistroA[nCont2][5] := TMP3->NOME
			aRegistroA[nCont2][6] := TMP3->CIDADE
			aRegistroA[nCont2][7] := TMP3->CNPJ
			aRegistroA[nCont2][8] := TMP3->CODIGO
			aRegistroA[nCont2][9] := TMP3->VALOR
			aRegistroA[nCont2][10]:= TMP3->NUMERO		

			dbSkip()

		ENDDO

		DBSelectArea("TMP3")
		DBCloseArea("TMP3")

		If nCont1 <> nCont2
			MsgInfo("Numero de RPs para pagamento diferente do de notas fiscais!","Verifique")
		Endif	
		
			For i:=1 to Len(aRegistroA)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 45  // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif


		IF (aRegistroA[i][8] != cPraca .or. lOk == .T.)
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY "REPASSE EM ABERTO - " + aRegistroA[i][6]		
			@nLin, 073 PSAY "CNPJ: "  
			@nLin, 080 PSAY	aRegistroA[i][7] PICTURE "@R 99.999.999/9999-99"			
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1 // Avanca a linha de impressao 
		Endif

		@nLin, 000 PSAY aRegistroA[i][1]	
		@nLin, 010 PSAY aRegistroA[i][2]		
		@nLin, 020 PSAY aRegistroA[i][3]
		@nLin, 075 PSAY aRegistroA[i][4]
		@nLin, 090 PSAY aRegistroA[i][5]
		@nLin, 140 PSAY aRegistroA[i][10]
		@nLin, 160 PSAY aRegistroA[i][9] PICTURE "@E 999,999.99" 				

		cPraca := aRegistroA[i][8]
		nTotalA += aRegistroA[i][9]

		nLin += 1 // Avanca a linha de impressao

		lOk := .F.

	Next
	
	@nLin, 000 PSAY Replicate("-",Limite)
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "TOTAL EM ABERTO "	
	@nLin, 159 PSAY	nTotalA  PICTURE "@E 999,999.99" 		
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin, 000 PSAY Replicate("-",Limite)
	nLin += 4 // Avanca a linha de impressao 
	

	EndIf
	//Zera os contadores

	nCont1		:= 0
	nCont2		:= 0
	cPraca      := ""
	lOk 		:= .T.			

	//Separa notas para pagamento

	DBSelectArea("TMP")
	DBGotop()
	While !EOF()

		nCont1 += 1

		aAdd(aRegistroP,{TMP->RP,;
		TMP->NOTA,; 
		SUBSTR(TMP->CLIENTE,1,50),;			
		STOD(TMP->BAIXA),;
		"",;
		"",;
		"",;
		"",;									
		0,;
		""})

		dbSkip()

	ENDDO

	DBSelectArea("TMP")
	DBCloseArea("TMP")

	DBSelectArea("TMP1")
	DBGotop()
	While !EOF()

		nCont2 += 1

		aRegistroP[nCont2][5] := TMP1->NOME
		aRegistroP[nCont2][6] := TMP1->CIDADE
		aRegistroP[nCont2][7] := TMP1->CNPJ
		aRegistroP[nCont2][8] := TMP1->CODIGO
		aRegistroP[nCont2][9] := TMP1->VALOR
		aRegistroP[nCont2][10]:= TMP1->NUMERO		

		dbSkip()

	ENDDO

	DBSelectArea("TMP1")
	DBCloseArea("TMP1")

	If nCont1 <> nCont2
		MsgInfo("Numero de RPs para pagamento diferente do de notas fiscais!","Verifique")
	Endif

	For i:=1 to Len(aRegistroP)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 45  // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif


		IF (aRegistroP[i][8] != cPraca .or. lOk == .T.)
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY "REPASSE A PAGAR - " + aRegistroP[i][6]		
			@nLin, 073 PSAY "CNPJ: "  
			@nLin, 080 PSAY	aRegistroP[i][7] PICTURE "@R 99.999.999/9999-99"			
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1 // Avanca a linha de impressao 
		Endif

		@nLin, 000 PSAY aRegistroP[i][1]	
		@nLin, 010 PSAY aRegistroP[i][2]		
		@nLin, 020 PSAY aRegistroP[i][3]
		@nLin, 075 PSAY aRegistroP[i][4]
		@nLin, 090 PSAY aRegistroP[i][5]
		@nLin, 140 PSAY aRegistroP[i][10]
		@nLin, 160 PSAY aRegistroP[i][9] PICTURE "@E 999,999.99" 				

		cPraca := aRegistroP[i][8]
		nTotalP += aRegistroP[i][9]

		nLin += 1 // Avanca a linha de impressao

		lOk := .F.

	Next

	@nLin, 000 PSAY Replicate("-",Limite)
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "TOTAL A PAGAR"	
	@nLin, 159 PSAY	nTotalP  PICTURE "@E 999,999.99" 		
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin, 000 PSAY Replicate("-",Limite)
	nLin += 2 // Avanca a linha de impressao 

	nLin := 55 
	@nLin,060 PSAY UPPER("       _________________________             _________________________")
	nLin += 2
	@nLin,060 PSAY UPPER("        Eleni Caldeira (Elenn)                    Manuela Costa")
	nLin++
	@nLin,060 PSAY UPPER("         Ger. Adm/Financeiro                 Analista Administrativo")


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
	AADD(aRegs,{cPerg,"01","Fornecedor/Praça:	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})	
	AADD(aRegs,{cPerg,"02","RPs a Pagar: 		","","","mv_ch02","C",60,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Notas a Pagar:		","","","mv_ch03","C",60,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","RPs em Aberto: 		","","","mv_ch04","C",60,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"05","Notas em Aberto:	","","","mv_ch05","C",60,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"06","Data Referencia: 	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})	

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
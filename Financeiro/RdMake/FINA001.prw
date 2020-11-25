#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"
#include "topconn.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINA001    ³Autor ³  Bruno Alves        ³Data³ 26/12/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ A rotina tem o objetivo de cadastrar os valores dos 		   ±±
±±³			 ³ repasses com seus devidos calculos atraves do arquivo .csv ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINA001()

	//Local cArq    := "clientes.csv"
	Local _aArea	:= GetArea()
	Local cLinha  := ""
	Local aCampos := {}
	Local aDados  := {}
	Local cPerg   := "FINA001"
	Local i,j
	Local lValida := .T.
	Local nQtdProd := 0
	Local cTexto := ""

	Private cCodPraca  := ""
	Private cPeriodo   := ""
	Private aErro      := {}
	Private aInfo 	   := {}
	Private lOkGeral   := .T.
	Private cProd 	   := ""
	Private cPracaNeg  := ""
	Private nDifRep    := 0


	cTexto := "Rotina irá fazer o calculo do repasse das praças atraves do arquivo de importação .CSV. As colunas precisam está na seguinte ordem:" + Chr(13) + Chr(10)
	cTexto += "1º : RP					" + Chr(13) + Chr(10)
	cTexto += "2º : UT					" + Chr(13) + Chr(10)
	cTexto += "3º : EMP. VENDA			" + Chr(13) + Chr(10)
	cTexto += "4º : EMP. EXIB			" + Chr(13) + Chr(10)
	cTexto += "5º : SIGLA EXIB.			" + Chr(13) + Chr(10)
	cTexto += "6º : COD EMP REPASSE		" + Chr(13) + Chr(10)
	cTexto += "7º : CLIENTE				" + Chr(13) + Chr(10)
	cTexto += "8º : AGENCIA				" + Chr(13) + Chr(10)
	cTexto += "9º : VALOR				" + Chr(13) + Chr(10)
	cTexto += "10º: NC ESPECIE			" + Chr(13) + Chr(10)
	cTexto += "11º: NC ESPAÇO			" + Chr(13) + Chr(10)
	cTexto += "12º: BAIXA NC ESPAÇO		" + Chr(13) + Chr(10)
	cTexto += "13º: DESC FINANC.		" + Chr(13) + Chr(10)
	cTexto += "14º: % INDAIMPLENCIA		" + Chr(13) + Chr(10)
	cTexto += "15º: FIM INADIMPLENCIA	" + Chr(13) + Chr(10)
	cTexto += "16º: DEDUÇÕES			" + Chr(13) + Chr(10)
	cTexto += "17º: COMISSÃO REPASSE	" + Chr(13) + Chr(10)
	cTexto += "18º: BV					" + Chr(13) + Chr(10)
	cTexto += "19º: VALOR PARA CALCULO	" + Chr(13) + Chr(10)
	cTexto += "20º: % REPASSE			" + Chr(13) + Chr(10)
	cTexto += "21º: REPASSE COMPETENCIA	" + Chr(13) + Chr(10)
	cTexto += "22º: REPASSE TOTA		" + Chr(13) + Chr(10)



	Aviso("Rotina FINA001",cTexto,{"OK"})

	ValidPerg(cPerg)

	If !Pergunte(cPerg)
		MsgAlert("Operação Cancelada!")
		Return
	EndIf

	cDir := Alltrim(MV_PAR01)
	cPeriodo := SUBSTRING(DTOS(MV_PAR02),5,2) + SUBSTRING(DTOS(MV_PAR02),1,4)

	If Substring(cDir,Len(cDir)-2,3) != "csv"
		MsgStop("O arquivo precisa ser com extensão .CSV - ATENCAO - " + Substring(cDir,Len(cDir)-2,3))
		Return
	EndIf

	If !File(cDir)
		MsgStop("O arquivo " +cDir + " não foi encontrado. A importação será abortada!", "ATENCAO")
		Return
	EndIf

	FT_FUSE(cDir)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

		AADD(aDados,Separa(cLinha,";",.T.))


		FT_FSKIP()

	EndDo

	FT_FUSE()

	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)

		IncProc("Validando Informações...")

		//Verifico se existe periodo superior cadastrado, caso tenha irá abortar a execução da rotina
		DbSelectArea("ZAG");DbSetOrder(3)
		If DbSeek(xFilial("ZAG") + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),5,2) + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),1,4)  )
			Alert("Não é possivel iniciar o processamento com periodo superior processado, favor verificar. Periodo processado: " + DTOC(MonthSum(MV_PAR02,1)))
			RestArea(_aARea)
			Return
		EndIf

		//Verifico se existe periodo cadastrado, caso tenha irá abortar a execução da rotina
		DbSelectArea("ZAG");DbSetOrder(3)
		If DbSeek(xFilial("ZAG") + cPeriodo  )
			Alert("Não é possivel iniciar o processamento com periodo "+ SUBSTRING(DTOS(MV_PAR02),5,2) + "/" + SUBSTRING(DTOS(MV_PAR02),1,4) + " processado, favor exclui-lo!" + cPeriodo)
			If MsgYesNo("Deseja excluir o periodo " + SUBSTRING(DTOS(MV_PAR02),5,2) + "/" + SUBSTRING(DTOS(MV_PAR02),1,4) + " de todas as praças?")
				DelPeriodo(cPeriodo,SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),5,2) + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),1,4))
				RestArea(_aARea)
				Return
			Else
				RestArea(_aARea)
				Return
			EndIf
		EndIf


		//Verifico se existe o cadastro da praça
		DbSelectArea("ZAF");DbSetOrder(1)
		If !DbSeek(xFilial("ZAF") + STRZERO(Val(aDados[i][6]),3))
			Alert("Praça não encontrado, favor verificar. Codigo: " + aDados[i][6])
			RestArea(_aARea)
			Return
		Else
			cCodPraca := ZAF->ZAF_CODIGO
		EndIf

		//Verifica duplicidade no arquivo de importação atraves o numero RP
		If aScan( aInfo, { |x| x[1] == aDados[i][1] } ) > 0
			Alert("Numero RP duplicado, favor verificar. RP: " + aDados[i][1])
			RestArea(_aARea)
			Return
		EndIf

		aAdd(aInfo,{;
			aDados[i,01],;//1º : RP
			aDados[i,02],;//2º : UT
			aDados[i,03],;//3º : EMP. VENDA
			aDados[i,04],;//4º : EMP. EXIB
			aDados[i,05],;//5º : SIGLA EXIB.
			cCodPraca,;	 //6º : COD EMP REPASSE
			aDados[i,07],;//7º : CLIENTE
			aDados[i,08],;//8º : AGENCIA
			aDados[i,09],;//9º : VALOR
			aDados[i,10],;//10º: NC ESPECIE
			aDados[i,11],;//11º: NC ESPAÇO
			aDados[i,12],;//12º: BAIXA NC ESPAÇO
			aDados[i,13],;//13º: DESC FINANC.
			aDados[i,14],;//14º: % INDAIMPLENCIA
			aDados[i,15],;//15º: FIM INADIMPLENCIA
			aDados[i,16],;//16º: DEDUÇÕES
			aDados[i,17],;//17º: COMISSÃO REPASSE
			aDados[i,18],;//18º: BV
			aDados[i,19],;//19º: VALOR PARA CALCULO
			aDados[i,20],;//20º: % REPASSE
			aDados[i,21],;//21º: REPASSE COMPETENCIA
			aDados[i,22];//22º: REPASSE TOTA
			})

	Next i


	If Len(aInfo) > 0

		//Ordena todas as informações Praca e Numero RP
		ASORT(aInfo,,,{|x,y|x[6]+x[1] < y[6]+y[1]})

		Processa({||ExecImport()}, "FINA001 - ExecImport", "Importando repasse atraves do  arquivo .csv.")
		Processa({||ExecRateio()}, "FINA001 - ExecRateio", "Executando Rateio após importação.")

	Else

		MsgInfo("Não existem informações para serem importadas, favor verificar","FINA001")
		RestArea(_aARea)
		Return

	EndIf



	RestArea(_aARea)


Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExecImport    ³Autor ³  Bruno Alves      ³Data³ 26/12/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa o Repasse atraves do arquivo  .csv³				   ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ExecImport()

	Local n,i
	Local cCodSeq 	 := ""
	Local cPraca 	 := ""
	Local nAcumulado := 0
	Local cDtAcum	 := ""

	Local nValComp   := 0
	Local nValor     := 0
	Local nValRep    := 0

	ProcRegua(Len(aInfo))


	For n:=1 to Len(aInfo)

		IncProc("Incluindo Numero RP / Calculando Acumulado" + aInfo[n][1])

		//Gera o codigo sequencial para o cadastramento
		If cPraca != aInfo[n][6]
			cCodSeq := GetSXENum("ZAG","ZAG_CODIGO")
			ConfirmSX8()

			//Toda vez que troca a praça do repasse verifico se existe saldo acumulado ate localizar o registro da praça
			For i:= 1 to 999999
				//Função que verifica se existe saldo no acumulado
				If SumTotZAH(2,aInfo[n][6],SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4))
					//Caso existe soma apenas uma vez na variavel acumulado
					If SUM->VALDESC < 0
						nAcumulado := SUM->VLACUM
						cDtAcum	   := SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4)

					EndIf
					//Após localização verifico se tem saldo acumulado e saio do loop do for
					Exit

				EndIf
				//Fecho a tabela temporaria para a função SumTotZAH receber outra chamada dentro do loop
				DBSelectArea("SUM")
				DbCloseArea("SUM")

				//Se chegar no mes que iniciou o controle do repasse sai do loop também
				If SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4) == "112019"
					Exit
				EndIf
			Next

			//Fecho a tabela temporaria caso o exit seja acionado dentro da repetição do FOR
			DBSelectArea("SUM")
			DbCloseArea("SUM")

		EndIf


		RECLOCK("ZAG",.T.)

		//Prepara a mascara para transformar em valor

		nValComp := TrataVal(aInfo[n][21]) // Repasse Competencia
		nValRep :=  TrataVal(aInfo[n][22]) // Valor para Calculo

		//Financeiro solicitou a retirada da regra abaixo - 21/08/2020 - Bruno Alves
		//If nValComp < 0 .and. nValRep == 0
		nValor := nValComp
		/*
		Else
			nValor := nValRep
		EndIf
		*/



		ZAG->ZAG_FILIAL	  	:= xFilial("ZAG")
		ZAG->ZAG_CODIGO     := cCodSeq
		ZAG->ZAG_PRACA    	:= aInfo[n][6] //EMP VENDA
		ZAG->ZAG_NUMRP		:= aInfo[n][1] //RP
		ZAG->ZAG_PERIODO	:= cPeriodo
		ZAG->ZAG_VALOR		:= nValor
		ZAG->ZAG_EMISSA		:= MV_PAR02
		ZAG->ZAG_EMPVEN		:= aInfo[n][3]
		ZAG->ZAG_EMPRES		:= Posicione("SX5",1,xFilial("SX5")+"ZC" + aInfo[n][3],"X5_DESCRI")
		ZAG->ZAG_EMPEXI		:= aInfo[n][4]
		ZAG->ZAG_SIGEXI		:= aInfo[n][5]
		ZAG->ZAG_EMPREP		:= aInfo[n][6]
		ZAG->(MSUNLOCK())


		RECLOCK("ZAH",.T.)
		ZAH->ZAH_FILIAL	  	:= xFilial("ZAH")
		ZAH->ZAH_UTILIZ		:= aInfo[n][2]
		ZAH->ZAH_CODIGO     := cCodSeq
		ZAH->ZAH_PRACA    	:= aInfo[n][6]
		ZAH->ZAH_NUMRP		:= aInfo[n][1]
		ZAH->ZAH_PERIOD		:= cPeriodo
		ZAH->ZAH_DTACUM		:= cDtAcum
		ZAH->ZAH_ACUCAL		:= nAcumulado
		ZAH->ZAH_VLACUM		:= nAcumulado
		ZAH->ZAH_VLDESC		:= IIF(nValor < 0,nValor,0)
		ZAH->ZAH_VALOR		:= IIF(nValor > 0,nValor,0)
		ZAH->ZAH_CLIENT		:= aInfo[n][7]
		ZAH->ZAH_AGENCI		:= aInfo[n][8]
		ZAH->ZAH_VALLIQ		:= TrataVal(aInfo[n][9])
		ZAH->ZAH_NCESPE		:= TrataVal(aInfo[n][10])
		ZAH->ZAH_NCESPA		:= TrataVal(aInfo[n][11])
		ZAH->ZAH_BXNCPA		:= TrataVal(aInfo[n][12])
		ZAH->ZAH_DESCFI		:= TrataVal(aInfo[n][13])
		ZAH->ZAH_INADIM		:= TrataVal(aInfo[n][14])
		ZAH->ZAH_LINADI		:= If(Empty(aInfo[n][15]),.F.,.T.) //Logico
		ZAH->ZAH_DEDUCO		:= TrataVal(aInfo[n][16])
		ZAH->ZAH_COMREP		:= TrataVal(aInfo[n][17])
		ZAH->ZAH_BV    		:= TrataVal(aInfo[n][18])
		ZAH->ZAH_VLCALC		:= TrataVal(aInfo[n][19])
		ZAH->ZAH_REPASS		:= TrataVal(aInfo[n][20])
		ZAH->ZAH_REPCOM		:= TrataVal(aInfo[n][21])
		ZAH->ZAH_REPTOT		:= TrataVal(aInfo[n][22])

		ZAH->(MSUNLOCK())



		nAcumulado := 0
		cPraca := aInfo[n][6]
		cDtAcum := ""

	Next


	MsgInfo("Importação realizada com sucesso. " + Alltrim(STR(Len(aInfo))) + " registro(s).","FINA001")

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ExecRateio    ³Autor ³  Bruno Alves      ³Data³ 26/12/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa o rateio das informações imporadas do arquivo .csv ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function ExecRateio()

	Local lOk     	:= .T.
	Local lRat    	:= .F.
	Local cQuery  	:= ""
	Local nCont   	:= 0
	Local nValTot 	:= 0
	Local nPercRat  := 0
	Local nQtd	    := 0
	Local cRatPraca := ""
	Local nRecno    := 0



	cQuery += "SELECT * FROM ZAH010 WHERE "
	cQuery += "ZAH_PERIOD = '" + cPeriodo + "' AND "
	cQuery += "D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZAH_PRACA "

	tcQuery cQuery New Alias "TMP"

	COUNT TO nCont

	DbSelectArea("TMP")
	DbGotop()

	If Eof()
		MsgInfo("Nao existem informações nesse periodo para ser rateado","Execução do Rateio")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return()
	Endif

	ProcRegua(nCont)

	While !TMP->(EOF())

		lRat := .F.

		IncProc("Rateando o valor do Numero RP" + TMP->ZAH_NUMRP)


		DbSelectArea("ZAH");DbSetOrder(1)
		If DbSeek(xFilial("ZAH") + TMP->ZAH_CODIGO + TMP->ZAH_PRACA + TMP->ZAH_NUMRP)

			//Tratativa da função quando o valor do pagamento é maior do desconto
			If SumTotZAH(1,TMP->ZAH_PRACA,cPeriodo)

				If TMP->ZAH_VALOR > 0

					//nPercRat := Round((TMP->ZAH_VALOR*100)/SUM->VALPAG,2)
					nPercRat := (TMP->ZAH_VALOR*100)/SUM->VALPAG // Rafael - 23/10/2020
					//Quantidade de informações rateadas
					nQtd++


					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= 0
					ZAH->ZAH_RATEIO	:= ROUND(nPercRat,2)
					//ZAH->ZAH_VLRAT  := ROUND(TMP->ZAH_VALOR - ROUND(((SUM->VALDESC*(nPercRat/100))*-1),3),2)
					ZAH->ZAH_VLRAT  := ROUND(TMP->ZAH_VALOR - ((SUM->VALDESC*(nPercRat/100))*-1),2) // Rafael - 23/10/2020
					ZAH->(MSUNLOCK())

					lRat := .T. //Vou verificar no final se teve diferença de centavos por conta do arrendondamento
					nRecno := ZAH->(Recno())
				Else

					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= 0
					ZAH->(MSUNLOCK())

				EndIf
				//Tratativa da função quando o valor do desconto é maior que o valor do pagamento
			Else
				//Entra na condição quando irá incluir valor no acumulado
				//Desconta do acumulado apenas uma vez em cada praça
				If cRatPraca != TMP->ZAH_PRACA
					//Quantidade de informações rateadas
					nQtd++

					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= SUM->VALDESC + SUM->VALPAG
					ZAH->(MSUNLOCK())

				EndIf


			EndIf

			//Fecho a tabela temporaria para a função SumTotZAH receber outra chamada dentro do loop
			DBSelectArea("SUM")
			DbCloseArea("SUM")

		EndIf

		DbSelectArea("TMP")

		cRatPraca := TMP->ZAH_PRACA

		DbSkip()


		//Faço o ajuste do rateio caso seja necessário por questão de arrendondamento
		If cRatPraca != TMP->ZAH_PRACA .and. lRat
			//Verifico se existe diferença
			If !SumTotZAH(3,cRatPraca,cPeriodo)
				//Caso exista, faço a correção
				DbGoto(nRecno)
				RECLOCK("ZAH",.F.)
				ZAH->ZAH_VLRAT  -= nDifRep
				ZAH->(MSUNLOCK())

			EndIf

			//Fecho a tabela temporaria para a função SumTotZAH receber outra chamada dentro do loop
			DBSelectArea("SUM")
			DbCloseArea("SUM")

		EndIf


	EndDo

	MsgInfo("De " + Alltrim(Str(nCont)) + " RP(s) foram rateados " + Alltrim(Str(nQtd)) + " RP(s).")

	dbSelectArea("TMP")
	dbCloseArea("TMP")



Return

//Descobre o valor total da praça no determinado periodo para fazer o rateio
//nOpcao = 1 Tratativa para o rateio; 2 Tratativa para fazer o calculo do acumulado do mes seguinte; valor total do valor rateio
Static Function SumTotZAH(nOpcao,cPraRep,cMesAno)


	Local cQuery  := ""
	Local lOk  	  := .T.
	Local nCont   := 0

	nDifRep := 0

	cQuery := "SELECT ZAH_PRACA,SUM(ZAH_VALOR) AS VALPAG,SUM(ZAH_VLDESC) + SUM(ZAH_ACUCAL) AS VALDESC, SUM(ZAH_VLACUM) AS VLACUM, SUM(ZAH_VLRAT) AS VLRAT,SUM(ZAH_REPCOM) AS VLREP  FROM ZAH010 WHERE "
	cQuery += "ZAH_PRACA = '" + cPraRep + "' AND "
	cQuery += "ZAH_PERIOD = '" + cMesAno + "' AND "
	cQuery += "D_E_L_E_T_ = '' "
	cQuery += "GROUP BY ZAH_PRACA "

	tcQuery cQuery New Alias "SUM"

	COUNT TO nCont

	DbSelectArea("SUM")
	DbGotop()

	//Tratativa para o rateio
	If nOpcao == 1
		If SUM->VALPAG <= (SUM->VALDESC)*-1
			//Não aparecer a mesma mensagem quando tem mais de um  registro na mesma praça
			If cPracaNeg != TMP->ZAH_PRACA
				Alert("Não é possivel fazer o rateio da praça " + SUM->ZAH_PRACA + ". Saldo devedor maior que o saldo do pagamento")
			EndIf
			lOk := .F.
		EndIf

		cPracaNeg := TMP->ZAH_PRACA

	ElseIf nOpcao == 2

		//Tratativa para localizar o acumulado, se não localizar
		If nCont == 0
			lOk := .F.
		EndIf

	ElseIf nOpcao == 3

		nDifRep := SUM->VLRAT - SUM->VLREP
		//Verifico se o valor da praça bateu com o valor do rateio
		If nDifRep >= -0.05 .AND. nDifRep <= 0.05 .AND. nDifRep != 0
			lOk := .F.
		EndIf


	EndIf

Return(lOk)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg    ³Autor ³  Microsiga           ³Data³ 01/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aAdd(aRegs,{cPerg,"01","Busca Arquivo?","","","mv_ch1","C",60,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Periodo?","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})



	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		ElseIf i == 7// Sempre irá renovar o parametro MV_PAR07
			RecLock("SX1",.F.)
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



//Função para excluir o periodo do cadastro do repasse das praças

Static Function DelPeriodo(cPeriodo,cPerSum)


	Local cQuery := ""
	Local cDel	 := ""


	cQuery := "SELECT COUNT(*) as QTD FROM ZAG010 WHERE "
	cQuery += "ZAG_PERIOD = " + cPerSum + " AND D_E_L_E_T_ = '' "

	TcQuery cQuery New Alias "TMP"

	DbSelectArea("TMP")

	If TMP->QTD > 0
		Alert("Existe periodo superior cadastrado, favor exclui-lo. Periodo: " + cPerSum + "(MMAAAA)" )
	Else

		//Exclui tabela ZAG - Cabeçalho Repasse
		cDel := "UPDATE ZAG010 SET "
		cDel += "D_E_L_E_T_ = '*' WHERE "
		cDel += "ZAG_PERIOD = " + cPeriodo + " AND D_E_L_E_T_ = '' "

		If TcSqlExec(cDel) < 0
			MsgAlert("Ocorreu um erro na exclusão na tabela ZAG!","Atenção!")
			Return
		EndIf

		cDel := "UPDATE ZAH010 SET "
		cDel += "D_E_L_E_T_ = '*' WHERE "
		cDel += "ZAH_PERIOD = " + cPeriodo + " AND D_E_L_E_T_ = '' "

		If TcSqlExec(cDel) < 0
			MsgAlert("Ocorreu um erro na atualização na tabela ZAH!","Atenção!")
			Return
		EndIf

	EndIf

	DbSelectArea("TMP")
	DbCloseArea("TMP")

	MsgInfo("Periodo excluido com sucesso, será necessário o reprocessamento da rotina.")

Return




//Trata valores da planilha

Static Function TrataVal(cValor)

	Local nValor := 0
	Local lNeg 	 := .F.


	cValor := StrTran(cValor, ".","")
	cValor := StrTran(cValor,",",".")
	cValor := StrTran(cValor,"%","")

	//Verifico se é valor negativo. Caso seja negativo terá o caracter "(" no inicio e ")" no final
	If ( ")" $ cValor ) .or. ("(" $ cValor ) //Se a variavel estiver com parenteses, entra na tratativa devido o valor ser negativo
		cValor := StrTran(cValor, "(","")
		cValor := StrTran(cValor, ")","")
		lNeg   := .T.
	Endif

	nValor := Val(cValor)

	If lNeg
		nValor := nValor * -1
	EndIf


Return(nValor)
#include "totvs.ch"
#include "protheus.ch"
#INCLUDE "TBICONN.CH"
#include "topconn.ch"


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA001    �Autor �  Bruno Alves        �Data� 26/12/2019 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � A rotina tem o objetivo de cadastrar os valores dos 		   ��
���			 � repasses com seus devidos calculos atraves do arquivo .csv ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

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


	cTexto := "Rotina ir� fazer o calculo do repasse das pra�as atraves do arquivo de importa��o .CSV. As colunas precisam est� na seguinte ordem:" + Chr(13) + Chr(10)
	cTexto += "1� : RP					" + Chr(13) + Chr(10)
	cTexto += "2� : UT					" + Chr(13) + Chr(10)
	cTexto += "3� : EMP. VENDA			" + Chr(13) + Chr(10)
	cTexto += "4� : EMP. EXIB			" + Chr(13) + Chr(10)
	cTexto += "5� : SIGLA EXIB.			" + Chr(13) + Chr(10)
	cTexto += "6� : COD EMP REPASSE		" + Chr(13) + Chr(10)
	cTexto += "7� : CLIENTE				" + Chr(13) + Chr(10)
	cTexto += "8� : AGENCIA				" + Chr(13) + Chr(10)
	cTexto += "9� : VALOR				" + Chr(13) + Chr(10)
	cTexto += "10�: NC ESPECIE			" + Chr(13) + Chr(10)
	cTexto += "11�: NC ESPA�O			" + Chr(13) + Chr(10)
	cTexto += "12�: BAIXA NC ESPA�O		" + Chr(13) + Chr(10)
	cTexto += "13�: DESC FINANC.		" + Chr(13) + Chr(10)
	cTexto += "14�: % INDAIMPLENCIA		" + Chr(13) + Chr(10)
	cTexto += "15�: FIM INADIMPLENCIA	" + Chr(13) + Chr(10)
	cTexto += "16�: DEDU��ES			" + Chr(13) + Chr(10)
	cTexto += "17�: COMISS�O REPASSE	" + Chr(13) + Chr(10)
	cTexto += "18�: BV					" + Chr(13) + Chr(10)
	cTexto += "19�: VALOR PARA CALCULO	" + Chr(13) + Chr(10)
	cTexto += "20�: % REPASSE			" + Chr(13) + Chr(10)
	cTexto += "21�: REPASSE COMPETENCIA	" + Chr(13) + Chr(10)
	cTexto += "22�: REPASSE TOTA		" + Chr(13) + Chr(10)



	Aviso("Rotina FINA001",cTexto,{"OK"})

	ValidPerg(cPerg)

	If !Pergunte(cPerg)
		MsgAlert("Opera��o Cancelada!")
		Return
	EndIf

	cDir := Alltrim(MV_PAR01)
	cPeriodo := SUBSTRING(DTOS(MV_PAR02),5,2) + SUBSTRING(DTOS(MV_PAR02),1,4)

	If Substring(cDir,Len(cDir)-2,3) != "csv"
		MsgStop("O arquivo precisa ser com extens�o .CSV - ATENCAO - " + Substring(cDir,Len(cDir)-2,3))
		Return
	EndIf

	If !File(cDir)
		MsgStop("O arquivo " +cDir + " n�o foi encontrado. A importa��o ser� abortada!", "ATENCAO")
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

		IncProc("Validando Informa��es...")

		//Verifico se existe periodo superior cadastrado, caso tenha ir� abortar a execu��o da rotina
		DbSelectArea("ZAG");DbSetOrder(3)
		If DbSeek(xFilial("ZAG") + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),5,2) + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),1,4)  )
			Alert("N�o � possivel iniciar o processamento com periodo superior processado, favor verificar. Periodo processado: " + DTOC(MonthSum(MV_PAR02,1)))
			RestArea(_aARea)
			Return
		EndIf

		//Verifico se existe periodo cadastrado, caso tenha ir� abortar a execu��o da rotina
		DbSelectArea("ZAG");DbSetOrder(3)
		If DbSeek(xFilial("ZAG") + cPeriodo  )
			Alert("N�o � possivel iniciar o processamento com periodo "+ SUBSTRING(DTOS(MV_PAR02),5,2) + "/" + SUBSTRING(DTOS(MV_PAR02),1,4) + " processado, favor exclui-lo!" + cPeriodo)
			If MsgYesNo("Deseja excluir o periodo " + SUBSTRING(DTOS(MV_PAR02),5,2) + "/" + SUBSTRING(DTOS(MV_PAR02),1,4) + " de todas as pra�as?")
				DelPeriodo(cPeriodo,SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),5,2) + SUBSTRING(DTOS(MonthSum(MV_PAR02,1)),1,4))
				RestArea(_aARea)
				Return
			Else
				RestArea(_aARea)
				Return
			EndIf
		EndIf


		//Verifico se existe o cadastro da pra�a
		DbSelectArea("ZAF");DbSetOrder(1)
		If !DbSeek(xFilial("ZAF") + STRZERO(Val(aDados[i][6]),3))
			Alert("Pra�a n�o encontrado, favor verificar. Codigo: " + aDados[i][6])
			RestArea(_aARea)
			Return
		Else
			cCodPraca := ZAF->ZAF_CODIGO
		EndIf

		//Verifica duplicidade no arquivo de importa��o atraves o numero RP
		If aScan( aInfo, { |x| x[1] == aDados[i][1] } ) > 0
			Alert("Numero RP duplicado, favor verificar. RP: " + aDados[i][1])
			RestArea(_aARea)
			Return
		EndIf

		aAdd(aInfo,{;
			aDados[i,01],;//1� : RP
			aDados[i,02],;//2� : UT
			aDados[i,03],;//3� : EMP. VENDA
			aDados[i,04],;//4� : EMP. EXIB
			aDados[i,05],;//5� : SIGLA EXIB.
			cCodPraca,;	 //6� : COD EMP REPASSE
			aDados[i,07],;//7� : CLIENTE
			aDados[i,08],;//8� : AGENCIA
			aDados[i,09],;//9� : VALOR
			aDados[i,10],;//10�: NC ESPECIE
			aDados[i,11],;//11�: NC ESPA�O
			aDados[i,12],;//12�: BAIXA NC ESPA�O
			aDados[i,13],;//13�: DESC FINANC.
			aDados[i,14],;//14�: % INDAIMPLENCIA
			aDados[i,15],;//15�: FIM INADIMPLENCIA
			aDados[i,16],;//16�: DEDU��ES
			aDados[i,17],;//17�: COMISS�O REPASSE
			aDados[i,18],;//18�: BV
			aDados[i,19],;//19�: VALOR PARA CALCULO
			aDados[i,20],;//20�: % REPASSE
			aDados[i,21],;//21�: REPASSE COMPETENCIA
			aDados[i,22];//22�: REPASSE TOTA
			})

	Next i


	If Len(aInfo) > 0

		//Ordena todas as informa��es Praca e Numero RP
		ASORT(aInfo,,,{|x,y|x[6]+x[1] < y[6]+y[1]})

		Processa({||ExecImport()}, "FINA001 - ExecImport", "Importando repasse atraves do  arquivo .csv.")
		Processa({||ExecRateio()}, "FINA001 - ExecRateio", "Executando Rateio ap�s importa��o.")

	Else

		MsgInfo("N�o existem informa��es para serem importadas, favor verificar","FINA001")
		RestArea(_aARea)
		Return

	EndIf



	RestArea(_aARea)


Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ExecImport    �Autor �  Bruno Alves      �Data� 26/12/2019 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa o Repasse atraves do arquivo  .csv�				   ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

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

			//Toda vez que troca a pra�a do repasse verifico se existe saldo acumulado ate localizar o registro da pra�a
			For i:= 1 to 999999
				//Fun��o que verifica se existe saldo no acumulado
				If SumTotZAH(2,aInfo[n][6],SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4))
					//Caso existe soma apenas uma vez na variavel acumulado
					If SUM->VALDESC < 0
						nAcumulado := SUM->VLACUM
						cDtAcum	   := SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4)

					EndIf
					//Ap�s localiza��o verifico se tem saldo acumulado e saio do loop do for
					Exit

				EndIf
				//Fecho a tabela temporaria para a fun��o SumTotZAH receber outra chamada dentro do loop
				DBSelectArea("SUM")
				DbCloseArea("SUM")

				//Se chegar no mes que iniciou o controle do repasse sai do loop tamb�m
				If SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),5,2) + SUBSTRING(DTOS(MonthSub(MV_PAR02,i)),1,4) == "112019"
					Exit
				EndIf
			Next

			//Fecho a tabela temporaria caso o exit seja acionado dentro da repeti��o do FOR
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


	MsgInfo("Importa��o realizada com sucesso. " + Alltrim(STR(Len(aInfo))) + " registro(s).","FINA001")

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ExecRateio    �Autor �  Bruno Alves      �Data� 26/12/2019 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa o rateio das informa��es imporadas do arquivo .csv ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/


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
		MsgInfo("Nao existem informa��es nesse periodo para ser rateado","Execu��o do Rateio")
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

			//Tratativa da fun��o quando o valor do pagamento � maior do desconto
			If SumTotZAH(1,TMP->ZAH_PRACA,cPeriodo)

				If TMP->ZAH_VALOR > 0

					//nPercRat := Round((TMP->ZAH_VALOR*100)/SUM->VALPAG,2)
					nPercRat := (TMP->ZAH_VALOR*100)/SUM->VALPAG // Rafael - 23/10/2020
					//Quantidade de informa��es rateadas
					nQtd++


					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= 0
					ZAH->ZAH_RATEIO	:= ROUND(nPercRat,2)
					//ZAH->ZAH_VLRAT  := ROUND(TMP->ZAH_VALOR - ROUND(((SUM->VALDESC*(nPercRat/100))*-1),3),2)
					ZAH->ZAH_VLRAT  := ROUND(TMP->ZAH_VALOR - ((SUM->VALDESC*(nPercRat/100))*-1),2) // Rafael - 23/10/2020
					ZAH->(MSUNLOCK())

					lRat := .T. //Vou verificar no final se teve diferen�a de centavos por conta do arrendondamento
					nRecno := ZAH->(Recno())
				Else

					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= 0
					ZAH->(MSUNLOCK())

				EndIf
				//Tratativa da fun��o quando o valor do desconto � maior que o valor do pagamento
			Else
				//Entra na condi��o quando ir� incluir valor no acumulado
				//Desconta do acumulado apenas uma vez em cada pra�a
				If cRatPraca != TMP->ZAH_PRACA
					//Quantidade de informa��es rateadas
					nQtd++

					RECLOCK("ZAH",.F.)
					ZAH->ZAH_VLACUM	:= SUM->VALDESC + SUM->VALPAG
					ZAH->(MSUNLOCK())

				EndIf


			EndIf

			//Fecho a tabela temporaria para a fun��o SumTotZAH receber outra chamada dentro do loop
			DBSelectArea("SUM")
			DbCloseArea("SUM")

		EndIf

		DbSelectArea("TMP")

		cRatPraca := TMP->ZAH_PRACA

		DbSkip()


		//Fa�o o ajuste do rateio caso seja necess�rio por quest�o de arrendondamento
		If cRatPraca != TMP->ZAH_PRACA .and. lRat
			//Verifico se existe diferen�a
			If !SumTotZAH(3,cRatPraca,cPeriodo)
				//Caso exista, fa�o a corre��o
				DbGoto(nRecno)
				RECLOCK("ZAH",.F.)
				ZAH->ZAH_VLRAT  -= nDifRep
				ZAH->(MSUNLOCK())

			EndIf

			//Fecho a tabela temporaria para a fun��o SumTotZAH receber outra chamada dentro do loop
			DBSelectArea("SUM")
			DbCloseArea("SUM")

		EndIf


	EndDo

	MsgInfo("De " + Alltrim(Str(nCont)) + " RP(s) foram rateados " + Alltrim(Str(nQtd)) + " RP(s).")

	dbSelectArea("TMP")
	dbCloseArea("TMP")



Return

//Descobre o valor total da pra�a no determinado periodo para fazer o rateio
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
			//N�o aparecer a mesma mensagem quando tem mais de um  registro na mesma pra�a
			If cPracaNeg != TMP->ZAH_PRACA
				Alert("N�o � possivel fazer o rateio da pra�a " + SUM->ZAH_PRACA + ". Saldo devedor maior que o saldo do pagamento")
			EndIf
			lOk := .F.
		EndIf

		cPracaNeg := TMP->ZAH_PRACA

	ElseIf nOpcao == 2

		//Tratativa para localizar o acumulado, se n�o localizar
		If nCont == 0
			lOk := .F.
		EndIf

	ElseIf nOpcao == 3

		nDifRep := SUM->VLRAT - SUM->VLREP
		//Verifico se o valor da pra�a bateu com o valor do rateio
		If nDifRep >= -0.05 .AND. nDifRep <= 0.05 .AND. nDifRep != 0
			lOk := .F.
		EndIf


	EndIf

Return(lOk)


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidPerg    �Autor �  Microsiga           �Data� 01/11/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
		ElseIf i == 7// Sempre ir� renovar o parametro MV_PAR07
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



//Fun��o para excluir o periodo do cadastro do repasse das pra�as

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

		//Exclui tabela ZAG - Cabe�alho Repasse
		cDel := "UPDATE ZAG010 SET "
		cDel += "D_E_L_E_T_ = '*' WHERE "
		cDel += "ZAG_PERIOD = " + cPeriodo + " AND D_E_L_E_T_ = '' "

		If TcSqlExec(cDel) < 0
			MsgAlert("Ocorreu um erro na exclus�o na tabela ZAG!","Aten��o!")
			Return
		EndIf

		cDel := "UPDATE ZAH010 SET "
		cDel += "D_E_L_E_T_ = '*' WHERE "
		cDel += "ZAH_PERIOD = " + cPeriodo + " AND D_E_L_E_T_ = '' "

		If TcSqlExec(cDel) < 0
			MsgAlert("Ocorreu um erro na atualiza��o na tabela ZAH!","Aten��o!")
			Return
		EndIf

	EndIf

	DbSelectArea("TMP")
	DbCloseArea("TMP")

	MsgInfo("Periodo excluido com sucesso, ser� necess�rio o reprocessamento da rotina.")

Return




//Trata valores da planilha

Static Function TrataVal(cValor)

	Local nValor := 0
	Local lNeg 	 := .F.


	cValor := StrTran(cValor, ".","")
	cValor := StrTran(cValor,",",".")
	cValor := StrTran(cValor,"%","")

	//Verifico se � valor negativo. Caso seja negativo ter� o caracter "(" no inicio e ")" no final
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
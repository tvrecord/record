#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AXZAI    ºAutor  ³Rafael França         º Data ³  02/10/20 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Merchandising                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AXZAI

	Private cCadastro := "Merchandising"
	Private nOpca := 0
	Private aParam := {}

	Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","AxInclui",0,3},;
		{"Alterar","AxAltera",0,4},;
		{"Excluir","AxDeleta",0,5},;
		{"Importar","u_ImpMerch",0,2},;
		{"Relatório","",0,2}}

	Private cString := "ZAI"

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,)

Return

User Function ImpMerch()

	Local _aArea	:= GetArea()
	Local cLinha  := ""
	Local aCampos := {}
	Local aDados  := {}
	Local cPerg   := "ImpMerch"
	Local i,j
	Local lValida := .T.
	Local nQtdProd := 0
	Local cTexto := ""

	Private cPeriodo := ""
	Private aErro := {}
	Private aInfo := {}
	Private lOkGeral := .T.

	ValidPerg(cPerg)

	If !Pergunte(cPerg)
		MsgAlert("Operação Cancelada!")
		Return
	EndIf

	cDir := Alltrim(MV_PAR01)
	cPeriodo := SUBSTRING(DTOS(MV_PAR02),1,4) + SUBSTRING(DTOS(MV_PAR02),5,2)

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

		//Verifico se existe periodo cadastrado, caso tenha irá abortar a execução da rotina
		DbSelectArea("ZAI")
		DbSetOrder(1)

		If DbSeek(xFilial("ZAI") + cPeriodo  )
			Alert("Não é possivel iniciar o processamento com periodo "+ cPeriodo +" processado, favor exclui-lo!")
			If MsgYesNo("Deseja excluir o periodo " + cPeriodo + "?")
				DelPer1(cPeriodo)
				RestArea(_aARea)
				Return
			Else
				RestArea(_aARea)
				Return
			EndIf
		EndIf

		aAdd(aInfo,{;
			aDados[i,01],;//1º : Programa
			aDados[i,05],;//2º : RP
			aDados[i,08],;//3º : Agencia
			aDados[i,17],;//4º : Cliente
			aDados[i,24],;//5º : Produto
			aDados[i,28],;//6º : Inicio Veiculacao
			aDados[i,30],;//7º : Fim Veiculacao
			aDados[i,34],;//8º : Desconto
			aDados[i,35],;//9º: N de Acões
			aDados[i,37],;//10º: Valor Tabela
			aDados[i,40],;//11º: Valor liquido
			aDados[i,43],;//12º: Valor Fatudado
			})

	Next i


	If Len(aInfo) > 0

		//Ordena todas as informações Praca e Numero RP
		ASORT(aInfo,,,{|x,y|x[6]+x[1] < y[6]+y[1]})

		Processa({||ExecImp1()}, "ImpMerch - ExecImport", "Importando Merchandising atraves do  arquivo .csv.")
		//Processa({||ExecRateio()}, "ImpMerch - ExecRateio", "Executando Merchandising após importação.")

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
±±³Fun‡…o    ³ ExecImp1    ³Autor ³  Bruno Alves      ³Data³ 26/12/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa o Repasse atraves do arquivo  .csv³				   ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ExecImp1()

	Local n,i
	Local nValTab   := 0
	Local nValLiq   := 0
	Local nValFat   := 0

	ProcRegua(Len(aInfo))


	For n:=1 to Len(aInfo)

		IncProc("Importando Merchandising")

		//Gera o codigo sequencial para o cadastramento

		If ALLTRIM(aInfo[n][1]) <> "" .OR. ALLTRIM(aInfo[n][1]) <> "Programa"

			RECLOCK("ZAI",.T.)
			ZAI->ZAI_FILIAL	  	:= xFilial("ZAI")
			ZAI->ZAI_PERIODO	:= cPeriodo
			ZAI->ZAI_PROGR		:= aInfo[n][1]
			ZAI->ZAI_RP			:= aInfo[n][2]
			ZAI->ZAI_NAGENC		:= aInfo[n][3]
			ZAI->ZAI_NCLIEN		:= aInfo[n][4]
			ZAI->ZAI_PRODUT		:= aInfo[n][5]
			// 		ZAI->ZAI_INIVEI		:= DTOS(CTOD(aInfo[n][6]))
			//		ZAI->ZAI_FIMVEI		:= DTOS(CTOD(aInfo[n][7]))
			ZAI->ZAI_DESC		:= TrataVal(aInfo[n][8])
			ZAI->ZAI_ACOES		:= TrataVal(aInfo[n][9])
			ZAI->ZAI_VLTABE		:= TrataVal(aInfo[n][10])
			ZAI->ZAI_VLLIQU		:= TrataVal(aInfo[n][11])
			ZAI->ZAI_VLFAT		:= TrataVal(aInfo[n][12])
			ZAI->(MSUNLOCK())

		EndIf

	Next

	MsgInfo("Importação realizada com sucesso. " + Alltrim(STR(Len(aInfo))) + " registro(s).","ImpMerch")

Return

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

Static Function DelPer1(cPeriodo,cPerSum)

	Local cDel	 := ""

	//Exclui tabela ZAI - Cabeçalho Repasse
	cDel := "UPDATE ZAI010 SET "
	cDel += "D_E_L_E_T_ = '*' WHERE "
	cDel += "ZAI_PERIOD = " + cPeriodo + " AND D_E_L_E_T_ = '' "

	If TcSqlExec(cDel) < 0
		MsgAlert("Ocorreu um erro na exclusão na tabela ZAI!","Atenção!")
		Return
	EndIf

	MsgInfo("Periodo excluido com sucesso, será necessário o reprocessamento da rotina.")

Return

//Trata valores da planilha

Static Function TrataVal(cValor)

	Local nValor := 0

	cValor := StrTran(cValor, ".","")
	cValor := StrTran(cValor,",",".")
	cValor := StrTran(cValor,"%","")

	nValor := Val(cValor)

Return(nValor)
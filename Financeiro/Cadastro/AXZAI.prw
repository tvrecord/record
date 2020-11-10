#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "totvs.ch"

//Rafael França - 02/10/20 - Rotina de importação, impressão e rateio de Merchandising

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
		{"Relatório","u_RelMerch",0,2},;
		{"Exp. Rateio","u_ExpMerch",0,2}}

	Private cString := "ZAI"

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,)

Return

User Function ImpMerch()

	Local _aArea	:= GetArea()
	Local cLinha  := ""
	Local aDados  := {}
	Local cPerg   := "ImpMerch"
	Local i

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
			aDados[i,35],;//9º : N de Acões
			aDados[i,37],;//10º: Valor Tabela
			aDados[i,40],;//11º: Valor liquido
			aDados[i,43],;//12º: Valor Fatudado
			})

	Next i

	If Len(aInfo) > 0

		//Ordena todas as informações Praca e Numero RP
		ASORT(aInfo,,,{|x,y|x[1]+x[2] < y[1]+y[2]})

		Processa({||ExecImp1()}, "ImpMerch - ExecImport", "Importando Merchandising atraves do  arquivo .csv.")

	Else

		MsgInfo("Não existem informações para serem importadas, favor verificar","FINA001")
		RestArea(_aARea)
		Return

	EndIf

	RestArea(_aARea)

Return

//Rafael França - Importa merchandising por meio de arquivo csv
Static Function ExecImp1()

	Local n
	Local cDelete	:= ""

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
			ZAI->ZAI_DESC		:= TrataVal(aInfo[n][8])
			ZAI->ZAI_ACOES		:= TrataVal(aInfo[n][9])
			ZAI->ZAI_VLTABE		:= TrataVal(aInfo[n][10])
			ZAI->ZAI_VLLIQU		:= TrataVal(aInfo[n][11])
			ZAI->ZAI_VLFAT		:= TrataVal(aInfo[n][12])
			ZAI->(MSUNLOCK())

		EndIf

	Next

	//Exclui sujeira de importação da tabela ZAI
	cDelete := "DELETE FROM ZAI010 WHERE (ZAI_RP = '' OR ZAI_RP = 'RP')  "
	cDelete += "AND ZAI_PERIOD = " + cPeriodo + " "

TcSqlExec(cDelete)

	MsgInfo("Importação realizada com sucesso. " + Alltrim(STR(Len(aInfo))) + " registro(s).","ImpMerch")

Return

//Cria e valida as perguntas na tabela de perguntas SX1
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

//Função para excluir o periodo do cadastro de merchandising
Static Function DelPer1(cPeriodo,cPerSum)

	Local cDel	 := ""

	//Exclui tabela ZAI
	cDel := "DELETE FROM ZAI010 WHERE "
	cDel += "ZAI_PERIOD = " + cPeriodo + " "

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

User Function RelMerch()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'RelMerch.xml'

Private cPerg  		:= "RelMerch"
Private cNomeTabela	:= ""
Private cPeriodo	:= ""

	ValidPerg1(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	Pergunte(cPerg,.T.) //FAZ A PERGUNTA PARA USUARIO

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cPeriodo := SUBSTRING(DTOS(MV_PAR01),1,4) + SUBSTRING(DTOS(MV_PAR01),5,2)
cNomeTabela	:= UPPER("MERCHANDISING - " + DTOC(MV_PAR01))

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//Query para selecionar o merchandising do periodo calculado na tabela ZAI
SELECT ZAI_FILIAL AS FILIAL, ZAI_RP AS RP, ZAI_NCLIEN AS CLIENTE, ZAI_NAGENC AS AGENCIA, SUM(ZAI_VLLIQU) AS VLMERCHAN, C5_NUM AS NOTA
, (C5_PARC1 + C5_PARC2 + C5_PARC3 + C5_PARC4) AS VALORNF, C5_NATUREZ AS NATUREZA, ED_DESCRIC AS DESCRICAO, C6_VALOR AS VALORITEM
FROM ZAI010
INNER JOIN SC5010 ON C5_FILIAL = ZAI_FILIAL AND ZAI_RP = C5_NUMRP AND SC5010.D_E_L_E_T_ = '' AND C5_NOTA <> ''
INNER JOIN SED010 ON C5_NATUREZ = ED_CODIGO AND SED010.D_E_L_E_T_ = ''
INNER JOIN SC6010 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6_ITEM = '01' AND SC6010.D_E_L_E_T_ = ''
WHERE ZAI010.D_E_L_E_T_ = '' AND C5_NATUREZ <> '1101047' //Lucilene Financeiro - 04/11/20 - Retira a natureza de FATURAMENTO EVENTOS - LOCAL
AND C5_CLIENTE NOT IN ('002948') //Lucilene Financeiro - 04/11/20 - Remove o cliente APEA Brasil
AND ZAI_PROGR <> '' AND ZAI_PERIOD = %exp:cPeriodo%
GROUP BY ZAI_FILIAL, ZAI_RP, ZAI_NCLIEN, ZAI_NAGENC, C5_NUM, (C5_PARC1 + C5_PARC2 + C5_PARC3 + C5_PARC4), C5_NATUREZ, ED_DESCRIC, C6_VALOR

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Merchandising") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Merchandising",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"RP",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"CLIENTE",1,1)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"AGENCIA",1,1)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"VALOR MERCHANDISING",3,3)
		oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"NOTA FISCAL",1,1)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"VALOR DA NOTA",3,3)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"NATUREZA DA NOTA",1,1)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"DESCRIÇÃO",1,1)
        oFWMsExcel:AddColumn("Merchandising",cNomeTabela,"RATEIO NATUREZA",3,3)

While !(cAlias)->(Eof())

	//Criando as Linhas
    oFWMsExcel:AddRow("Merchandising",cNomeTabela,{RP,CLIENTE,AGENCIA,VLMERCHAN,NOTA,VALORITEM,NATUREZA,DESCRICAO,(VALORITEM - VLMERCHAN)})

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

	RestArea(aArea)

Return

//Programa usado para criar perguntas na tabela SX1 (Tabela de perguntas)
Static Function ValidPerg1(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Periodo: 	","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXSZU     ºAutor  ³Bruno Alves         º Data ³  09/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro da Bonificao de Volume                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AXSZU
	Private cCadastro := "Cadastro de Contratos BV"
	Private lOk1 := .T.
	Private nOpca := 0
	Private aButtons := {}
	Private aParam := {}

	//adiciona botoes na Enchoice
	//aAdd( aButtons, { "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botão Teste" } )

	//adiciona codeblock a ser executado no inicio, meio e fim
	aAdd( aParam,  {|| U_ZUBefore() } )  //antes da abertura
	aAdd( aParam,  {|| U_ZUTudoOK() } )  //ao clicar no botao ok
	aAdd( aParam,  {|| U_ZUTransaction() } )  //durante a transacao
	aAdd( aParam,  {|| U_ZUFim() } )       //termino da transacao



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta um aRotina proprio                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aCores := {{'DATE() > ZU_ATEVALI','BR_VERMELHO'},{'DATE() < ZU_ATEVALI','BR_VERDE'}}
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","AxVisual",0,2} ,;
		{"Incluir","U_IncluSZU",0,3} ,;
		{"Alterar","Axaltera",0,4}    ,;
		{"Excluir","AxDeleta",0,5},;
		{"Rel BV","u_RelBV()",0,2},;
		{"Legenda","u_LegeSZU()",0,4}}

	Private cString := "SZU"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
	//³                                                                     ³
	//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
	//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
	//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
	//³                        use sempre 6,1,22,75 (o que nao impede de    ³
	//³                        criar o browse no lugar desejado da tela).   ³
	//³                        Obs.: Na versao Windows, o browse sera exibi-³
	//³                        do sempre na janela ativa. Caso nenhuma este-³
	//³                        ja ativa no momento, o browse sera exibido na³
	//³                        janela do proprio SIGAADV.                   ³
	//³ Alias                - Alias do arquivo a ser "Browseado".          ³
	//³ aCampos              - Array multidimensional com os campos a serem ³
	//³                        exibidos no browse. Se nao informado, os cam-³
	//³                        pos serao obtidos do dicionario de dados.    ³
	//³                        E util para o uso com arquivos de trabalho.  ³
	//³                        Segue o padrao:                              ³
	//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
	//³                                     {<CAMPO>,<DESCRICAO>},;         ³
	//³                                     . . .                           ³
	//³                                     {<CAMPO>,<DESCRICAO>} }         ³
	//³                        Como por exemplo:                            ³
	//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
	//³                                     {"TRB_COD" ,"Codigo"} }         ³
	//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
	//³                        como "flag". Se o campo estiver vazio, o re- ³
	//³                        gistro ficara de uma cor no browse, senao fi-³
	//³                        cara de outra cor.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return


User Function Incluszu()
	nOpca := 0

	dbSelectArea("SZU")
	//AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
	nOpca := AxInclui("SZU",SZU->(Recno()), 3,, "U_ZUBefore",, "U_ZUTudoOk()", .F., "U_ZUTransactionZU", aButtons, aParam,,,.T.,,,,,)
Return nOpca

User function ZUBefore()
Return .T.

User function ZUTudoOK()

	DbSelectArea(cString)
	DBSetOrder(1)
	DBSeek(xFilial(cString) + M->ZU_VEND) //Evitar registros Duplicados
	If Found()
		lOk1 := .F.
		Alert("Não é permitido a inserção de registro duplicado!!")
	ELSE
		lOk1 := .T.
	EndIf

Return lOk1

User function ZUTransaction()
Return .T.

User function ZUFim()
Return .T.

User Function LegeSZU

	Local aLegenda := {{"ENABLE","Ativo"},{"DISABLE","VENCTOido"}}

	BrwLegenda("Cadastro de Contrato BV","Legenda",aLegenda)

Return(.t.)

User Function RELBV

	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXSZU     ºAutor  ³Bruno Alves         º Data ³  09/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Bonificao de Volume                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       := "Pagamento de Bonificação de Volume - Record Brasília"
	Local nLin         := 80

	Local Cabec1       := "Cli.    Nome                                      Numero   Parc    Emissao    VENCTO.      Recebimento   Valor      Val.Baixado  Comiss  Líquido     Pagar"
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 220
	Private tamanho          := "G"
	Private nomeprog         := "RELBV" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cQuery	   := ""
	Private cPerg	   := "RELBV1"
	Private cString := "SZU"


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAÇÃO CANCELADA")
		return
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	IF MV_PAR21 == 1
		Cabec1       := "Cli.    Nome                                      Numero   Parc    Emissao    Vencto.    Recebimento        Valor      Val.Baixado  Comiss  Líquido      Pagar Tipo     Natureza"
	ENDIF

	cQuery += "SELECT "
	cQuery += "E1_FILIAL,E1_VEND1,A3_NOME,A3_CGC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_PREFIXO,E1_TIPO,E1_NATUREZ,E1_NUM,E1_PARCELA,E1_VALOR,(E1_VALOR - E1_SALDO) AS VALORLIQUIDO,E1_COMIS1, (E1_VALOR - E1_SALDO) - ((E1_COMIS1 / 100) * ((E1_VALOR - E1_SALDO))) AS LIQUIDO, (E1_VALOR) - ((E1_COMIS1 / 100) * ((E1_VALOR))) AS LIQUIDO2,E1_EMISSAO,E1_VENCTO,E1_BAIXA,"
	cQuery += "ZU_DEFX1,ZU_ATEFX1,ZU_DEFX2,ZU_ATEFX2,ZU_DEFX3,ZU_ATEFX3,ZU_DEFX4,ZU_ATEFX4,ZU_DEFX5,ZU_ATEFX5,ZU_DEFX6,ZU_ATEFX6,ZU_DEFX7,ZU_ATEFX7,ZU_PERC1,ZU_PERC2,ZU_PERC3,ZU_PERC4,ZU_PERC5,ZU_PERC6,ZU_PERC7,ZU_ATEVALI,ZU_VALIDA,ZU_EXCECAO,ZU_DIAS,ED_DESCRIC,ED_TIPNAT,ED_TIPNAT "
	cQuery += "FROM SE1010 "
	cQuery += "INNER JOIN SA3010 ON "
	cQuery += "SE1010.E1_VEND1 = SA3010.A3_COD "
	cQuery += "INNER JOIN SA1010 ON "
	cQuery += "SE1010.E1_CLIENTE = SA1010.A1_COD AND "
	cQuery += "SE1010.E1_LOJA = SA1010.A1_LOJA "
	cQuery += "INNER JOIN SZU010 ON "
	cQuery += "SE1010.E1_VEND1 = SZU010.ZU_VEND "
	cQuery += "INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO "
	cQuery += "WHERE "
	cQuery += "SE1010.E1_FILIAL = '" + (MV_PAR01) + "' AND "
	IF EMPTY(MV_PAR20)
		cQuery += "SE1010.E1_VEND1 BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
	ELSE
		cQuery += "SE1010.E1_VEND1 IN " + FormatIn(MV_PAR20,"/") + " AND "
	ENDIF
	cQuery += "SE1010.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' AND "
	cQuery += "SE1010.E1_VENCTO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' AND "
	cQuery += "SE1010.E1_CLIENTE BETWEEN '" + (MV_PAR08) + "' AND '" + (MV_PAR09) + "' AND "
	cQuery += "SE1010.E1_PREFIXO BETWEEN '" + (MV_PAR10) + "' AND '" + (MV_PAR11) + "' AND "
	cQuery += "SE1010.E1_NUM BETWEEN '" + (MV_PAR12) + "' AND '" + (MV_PAR13) + "' AND "
	cQuery += "SE1010.E1_TIPO BETWEEN '" + (MV_PAR14) + "' AND '" + (MV_PAR15) + "' AND "
	cQuery += "SE1010.E1_NATUREZ BETWEEN '" + (MV_PAR16) + "' AND '" + (MV_PAR17) + "' AND "
	cQuery += "SE1010.E1_BAIXA BETWEEN '" + DTOS(MV_PAR18) + "' AND '" + DTOS(MV_PAR19) + "' AND "
	cQuery += "SE1010.E1_NATUREZ <> '1101006' AND "
	cQuery += "SA1010.D_E_L_E_T_ <> '*'  AND "
	cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SZU010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY E1_VEND1,E1_CLIENTE,E1_LOJA,E1_NUM,E1_PARCELA,E1_VENCTO "

	TcQuery cQuery New Alias "TMP"

	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea()
		Return
	Endif

	If nLastKey == 27
		dbSelectArea("TMP")
		dbCloseArea()
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

	Local _aStru1:={}
	Local cVend := ""
	Local cCNPJ	:= ""
	Local cNome := ""
	Local nTotVend  := 0
	Local nPercVend := 0
	Local nBVVend	:= 0
	Local nTotal    := 0
	Local nTotal1   := 0
	Local lOk := .T.
	Local aContrato := {}
	Local aRegistro := {}
	Local aTotais	:= {}
	Local lPagar := .F.
	Local nTotBV := 0
	Local nTotNoBv := 0
	Local nTotVal := 0
	Local nRecLiq := 0
	Local nPerc := 0
	Local cQueConf := "" //Query para validar os pagamentos de todas as parcelas. (Geração BV caso a divida esteja toda quitada)
	Local lRepete := .F. // Verificar o valor repetido quando impresso todas as parcelas de periodos anteriores
	Local nPos := 0

	IF MV_PAR22 == 1 //Não sera implantado nesse momento


		// **************************** Cria Arquivo Temporario
		_aStru1:={}//SPCSQL->(DbStruct())
		aadd( _aStru1 , {"CLIENTE"      	, "C" , 055 , 00 } )
		aadd( _aStru1 , {"NF	"			, "C" , 010 , 00 } )
		aadd( _aStru1 , {"VLIQUIDO"			, "N" , 014 , 02 } )
		aadd( _aStru1 , {"PERC"		    	, "N" , 006 , 00 } )
		aadd( _aStru1 , {"VALORBV"			, "N" , 014 , 02 } )
		aadd( _aStru1 , {"VENCIMENTO"		, "D" , 010 , 00 } )
		aadd( _aStru1 , {"RECEBER"			, "C" , 020 , 00 } )
		aadd( _aStru1 , {"PAGAR"			, "C" , 006 , 00 } )

		_cTemp := CriaTrab(_aStru1, .T.)
		DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

		DBSelectArea("TMP")
		DBGotop()

		While !TMP->(EOF())

			If (!EMPTY(TMP->E1_BAIXA) .AND. STOD(TMP->E1_BAIXA) <= (STOD(TMP->E1_VENCTO) + TMP->ZU_DIAS)) .AND. TMP->E1_NATUREZ <> "1101006" .OR. (TMP->ZU_EXCECAO == "1" .AND. !EMPTY(TMP->E1_BAIXA) .AND. TMP->E1_NATUREZ <> "1101006")// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna

				IF cVend != TMP->E1_VEND1
					aAdd(aRegistro,{TMP->E1_VEND1,TMP->LIQUIDO})
				ELSEIF cVend == TMP->E1_VEND1
					nPos := aScan(aRegistro, { |x| x[1] == TMP->E1_VEND1})
					aRegistro[nPos][2] += TMP->LIQUIDO
				ENDIF

				cVend := TMP->E1_VEND1

			ENDIF

			DBSelectArea("TMP")
			dbSkip() // Avanca o ponteiro do registro no arquivo

		ENDDO

		DBSelectArea("TMP")
		DBGotop()

		While !TMP->(EOF())

			If !EMPTY(ZU_PERC1)
				aAdd(aContrato,{TMP->ZU_DEFX1,;  		// 1 - De Valor
					TMP->ZU_ATEFX1,;	// 2 - Ate Valor
					TMP->ZU_PERC1}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC2)
				aAdd(aContrato,{TMP->ZU_DEFX2,;  		// 1 - De Valor
					TMP->ZU_ATEFX2,;	// 2 - Ate Valor
					TMP->ZU_PERC2}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC3)
				aAdd(aContrato,{TMP->ZU_DEFX3,;  		// 1 - De Valor
					TMP->ZU_ATEFX3,;	// 2 - Ate Valor
					TMP->ZU_PERC3}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC4)
				aAdd(aContrato,{TMP->ZU_DEFX4,;  		// 1 - De Valor
					TMP->ZU_ATEFX4,;	// 2 - Ate Valor
					TMP->ZU_PERC4}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC5)
				aAdd(aContrato,{TMP->ZU_DEFX5,;  		// 1 - De Valor
					TMP->ZU_ATEFX5,;	// 2 - Ate Valor
					TMP->ZU_PERC5}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC6)
				aAdd(aContrato,{TMP->ZU_DEFX6,;  		// 1 - De Valor
					TMP->ZU_ATEFX6,;	// 2 - Ate Valor
					TMP->ZU_PERC6}) // 3 - Porcentagem
			EndIf

			If !EMPTY(ZU_PERC7)
				aAdd(aContrato,{TMP->ZU_DEFX7,;  		// 1 - De Valor
					TMP->ZU_ATEFX7,;	// 2 - Ate Valor
					TMP->ZU_PERC7}) // 3 - Porcentagem
			EndIf

			If (!EMPTY(TMP->E1_BAIXA) .AND. STOD(TMP->E1_BAIXA) <= (STOD(TMP->E1_VENCTO) + TMP->ZU_DIAS)) .AND. TMP->E1_NATUREZ <> "1101006" .OR. (TMP->ZU_EXCECAO == "1" .AND. !EMPTY(TMP->E1_BAIXA) .AND. TMP->E1_NATUREZ <> "1101006") .OR. MV_PAR23 = 1// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna
				lPagar := .T.
			Else
				lPagar := .F.
			Endif

			IF cVend != TMP->E1_VEND1 .AND. lPagar
				Reclock("TMP1",.T.)
				TMP1->CLIENTE 	:= TMP->E1_VEND1 + TMP->A3_NOME
				MsUnlock()

				nTotBV := 0
				nTotNoBV := 0
				nPerc := 0

				nPos := aScan(aRegistro, { |x| x[1] == TMP->E1_VEND1})

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

			IF TMP->LIQUIDO > 0 .AND. lPagar

				Reclock("TMP1",.T.)
				TMP1->CLIENTE		:= TMP->A1_NOME
				TMP1->NF			:= TMP->E1_NUM
				TMP1->VLIQUIDO		:= TMP->VALORLIQUIDO
				TMP1->PERC			:= nPerc
				TMP1->VALORBV		:= TMP->LIQUIDO * (nPerc / 100)
				TMP1->VENCIMENTO	:= STOD(TMP->E1_VENCTO)
				TMP1->RECEBER		:= IIF(TMP->ED_TIPNAT == "1" .OR. TMP->ED_TIPNAT == "3", "LOCAL","SPOT")
				TMP1->PAGAR 		:= IIF(lPagar == .T. .OR. MV_PAR23 = 1, "SIM","NAO")
				MsUnlock()

			ENDIF

			cVend := TMP->E1_VEND1

			If lPagar == .T.
				nTotBV += TMP->LIQUIDO
				nTotNoBV += TMP->LIQUIDO * (nPerc / 100)
			EndIf

			DBSelectArea("TMP")
			dbSkip() // Avanca o ponteiro do registro no arquivo

			IF cVend != TMP->E1_VEND1 .AND. lPagar

				Reclock("TMP1",.T.)
				TMP1->CLIENTE 	:= "TOTAL BV PAGAR"
				TMP1->VLIQUIDO	:= nTotBV
				TMP1->VALORBV   := nTotNoBV
				MsUnlock()

			ENDIF

		ENDDO

		If !ApOleClient("MsExcel")
			MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
			DBSelectArea("TMP")
			DBCloseARea("TMP")
			Return
		EndIf

		cArq     := _cTemp+".DBF"

		DBSelectArea("TMP1")
		DBCloseARea("TMP1")
		DBSelectArea("TMP")
		DBCloseARea("TMP")

		__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
		oExcelApp:SetVisible(.T.)



	ELSE

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

		DBSelectArea("TMP")

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

			If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:

			If lOk == .T.


				//Adicionar os valores De - Ate no vetor

				If !EMPTY(ZU_PERC1)
					aAdd(aContrato,{TMP->ZU_DEFX1,;  		// 1 - De Valor
						TMP->ZU_ATEFX1,;	// 2 - Ate Valor
						TMP->ZU_PERC1}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC2)
					aAdd(aContrato,{TMP->ZU_DEFX2,;  		// 1 - De Valor
						TMP->ZU_ATEFX2,;	// 2 - Ate Valor
						TMP->ZU_PERC2}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC3)
					aAdd(aContrato,{TMP->ZU_DEFX3,;  		// 1 - De Valor
						TMP->ZU_ATEFX3,;	// 2 - Ate Valor
						TMP->ZU_PERC3}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC4)
					aAdd(aContrato,{TMP->ZU_DEFX4,;  		// 1 - De Valor
						TMP->ZU_ATEFX4,;	// 2 - Ate Valor
						TMP->ZU_PERC4}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC5)
					aAdd(aContrato,{TMP->ZU_DEFX5,;  		// 1 - De Valor
						TMP->ZU_ATEFX5,;	// 2 - Ate Valor
						TMP->ZU_PERC5}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC6)
					aAdd(aContrato,{TMP->ZU_DEFX6,;  		// 1 - De Valor
						TMP->ZU_ATEFX6,;	// 2 - Ate Valor
						TMP->ZU_PERC6}) // 3 - Porcentagem
				EndIf

				If !EMPTY(ZU_PERC7)
					aAdd(aContrato,{TMP->ZU_DEFX7,;  		// 1 - De Valor
						TMP->ZU_ATEFX7,;	// 2 - Ate Valor
						TMP->ZU_PERC7}) // 3 - Porcentagem
				EndIf



				@nLin,000 PSAY "Codigo: " + TMP->E1_VEND1
				@nLin,019 PSAY "CNPJ: "
				@nLin,025 PSAY Transform( TMP->A3_CGC , "@R 99.999.999/9999-99")
				nLin++
				@nLin,000 PSAY " TABELA DE BV - " + TMP->A3_NOME
				nLin++

				cVend := TMP->E1_VEND1
				cCNPJ := TMP->A3_CGC
				cNome := TMP->A3_NOME

				For I := 1 To Len(aContrato) // Imprimi Tabela de Valores

					@nLin,000 PSAY aContrato[I][1] PICTURE "@E 999,999,999.99"
					@nLin,015 PSAY " A "
					@nLin,020 PSAY aContrato[I][2] PICTURE "@E 999,999,999.99"
					@nLin,035 PSAY aContrato[I][3] PICTURE "@E 999.99%"

					nLin++

				Next I

				nLin++

				@nLin,000 PSAY "Validade: " + DTOC(STOD(TMP->ZU_VALIDA)) + " a "  + DTOC(STOD(TMP->ZU_ATEVALI)) + "  (Veiculação) "
				nLin++

				@nLin,000 PSAY "_____________________________________________________________________________________"
				nLin += 2


				lOk := .F.


			EndIf

			//Regra para informar se vai entrar no calculo do pagamento BV


			If (!EMPTY(TMP->E1_BAIXA) .AND. STOD(TMP->E1_BAIXA) <= (STOD(TMP->E1_VENCTO) + TMP->ZU_DIAS)) .AND. TMP->E1_NATUREZ <> "1101006" .OR. (TMP->ZU_EXCECAO == "1" .AND. !EMPTY(TMP->E1_BAIXA) .AND. TMP->E1_NATUREZ <> "1101006") .OR. MV_PAR23 = 1// Valida Pagamento no prazo estimado do contrato //Rafael 10/09/14 - Colocado a pedido da Sra. Edna
				lPagar := .T.
			Else
				lPagar := .F.
			Endif


			@nLin,000 PSAY TMP->E1_CLIENTE
			@nLin,008 PSAY TMP->A1_NOME
			@nLin,050 PSAY TMP->E1_NUM
			@nLin,062 PSAY TMP->E1_PARCELA
			@nLin,067 PSAY STOD(TMP->E1_EMISSAO)
			@nLin,078 PSAY STOD(TMP->E1_VENCTO)
			@nLin,090 PSAY STOD(TMP->E1_BAIXA)
			@nLin,101 PSAY TMP->E1_VALOR PICTURE "@E 999,999,999.99" //Linha alterada para que aparecesse 1 milhão no relatorio - wesley da silva 14/06
			@nLin,130 PSAY TMP->E1_COMIS1 PICTURE "@E 99.99%" //valor original 126 - Alterado para ajuste das colunas - Wesley da silva 14/06
			//IF MV_PAR23 = 1	.AND. TMP->VALORLIQUIDO == 0
			@nLin,117 PSAY TMP->VALORLIQUIDO PICTURE "@E 999,999,999.99" //valor original 114 - Alterado para ajuste das colunas - Wesley da silva 14/06
			@nLin,136 PSAY TMP->LIQUIDO PICTURE "@E 999,999,999.99" //valor original 133 - Alterado para ajuste das colunas - Wesley da silva 14/06
			//ELSE
			//@nLin,114 PSAY TMP->E1_VALOR PICTURE "@E 999,999.99"
			//@nLin,133 PSAY TMP->LIQUIDO2 PICTURE "@E 999,999.99"
			//ENDIF
			@nLin,155 PSAY IIF(lPagar == .T. .OR. MV_PAR23 = 1, "SIM","NÃO")
			IF MV_PAR21 == 1
				@nLin,160 PSAY IIF(TMP->ED_TIPNAT == "1" .OR. TMP->ED_TIPNAT == "3", "LOCAL","SPOT")
				@nLin,168 PSAY TMP->ED_DESCRIC
			ENDIF

			IF MV_PAR23 == 2
				If lPagar == .T.
					nTotBV += TMP->LIQUIDO
				else
					nTotNoBV += TMP->LIQUIDO
				EndIf
			ELSE
				If lPagar == .T.
					nTotBV += TMP->LIQUIDO2
				else
					nTotNoBV += TMP->LIQUIDO2
				EndIf
			ENDIF

			nTotVal += TMP->E1_VALOR

			nLin := nLin + 1 // Avanca a linha de impressao

			cVend := TMP->E1_VEND1


			DBSelectArea("TMP")
			dbSkip() // Avanca o ponteiro do registro no arquivo

			If cVend != TMP->E1_VEND1

				nLin++
				@nLin,102 PSAY nTotVal PICTURE "@E 9,999,999.99"
				@nLin,137 PSAY nTotBV PICTURE "@E 9,999,999.99"
				@nLin,154 PSAY "SIM"
				nLin++
				@nLin,137 PSAY nTotNoBV PICTURE "@E 9,999,999.99"
				@nLin,154 PSAY "NAO"
				nLin++
				@nLin,137 PSAY (nTotBV + nTotNoBv) PICTURE "@E 9,999,999.99"
				@nLin,154 PSAY "TOTAL"

				nTotVend := (nTotBV + nTotNoBv)

				nLin += 2

				//Verificar o valor da porcentagem a ser paga para agencia (Vendedor)
				For I := 1 To Len(aContrato)

					If nTotBV >= aContrato[I][1] .AND. nTotBV <= aContrato[I][2]
						nRecLiq :=	nTotBV * (aContrato[I][3] / 100) // Valor Liquido a Receber
						Exit
					EndIf


				Next I


				//Imprimir totalizador do valor a ser pago para Agencia (Vendedor)
				@nLin,00 PSAY "TOTAL DO BV A PAGAR: "
				@nLin,21 PSAY nRecLiq PICTURE "@E 9,999,999.99"
				nBVVend	:= nRecLiq
				nLin++
				If nRecLiq == 0
					@nLin,00 PSAY "PORCENTAGEM: "
					@nLin,15 PSAY nRecLiq PICTURE "@E 99.99%"
					nPercVend := 0
				else
					@nLin,00 PSAY "PORCENTAGEM: "
					@nLin,15 PSAY aContrato[I][3] PICTURE "@E 99.99%"
					nPercVend := aContrato[I][3]
				Endif

				aAdd(aTotais,{cVend,;
					cCNPJ,;
					cNome,;
					nTotVend,;
					nPercVend,;
					nBVVend})

				nLin += 10


				//Linhas

				//@nLin,00 PSAY " ________________________  _________________________  _________________________  __________________________  ___________________________  ___________________________"
				@nLin,00 PSAY " _________________________  _________________________  ___________________________"

				nLin += 2

				//Nomes

				//@nLin,00 PSAY "      Luciano Ribeiro            Wagner Lima           Eleni Caldeira (Elenn)           Alarico Naves            Talita Almeida"
				//@nLin,00 PSAY "  Eleni Caldeira (Elenn)             Alarico Naves             Maria dos Reis"
				@nLin,00 PSAY "  Eleni Caldeira (Elenn)             Ronnie Bragança             Pâmela Aguiar "
				nLin++

				// Cargos
				//@nLin,00 PSAY "       Diretor Geral          Gerente Executivo         Ger. Adm / Financeiro          Diretor Comercial        Auxiliar Financeiro"
				//@nLin,00 PSAY "  Ger. Adm / Financeiro            Diretor Comercial         Assistente Financeiro"
				@nLin,00 PSAY "  Ger. Adm / Financeiro                 Comercial             Assistente Financeiro"


				lOk := .T. //Imprimir o codigo e o nome do vendedor
				nLin := 61 // Para pular a Pagina
				aContrato := {} //Zera Vetor
				nTotBV := 0 // Zera totalizador do valor bruto do BV
				nTotVal := 0 // Zera totalizador do valor normal do titulo
				nTotNoBV := 0 // Zera totalizador do valor bruto que nao foi pago
				nRecLiq := 0 //Zera o valor calculado para o recebimento do BV Liquido

			EndIf

		EndDo


		If MV_PAR24 == 1

			Cabec1 := "Vendedor  CNPJ                Nome                                                 Faturamento        Perc            BV"

			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8

			For I := 1 to Len(aTotais)
				@nLin,001 PSAY aTotais[i][1]
				@nLin,010 PSAY Transform(aTotais[i][2], "@R 99.999.999/9999-99")
				@nLin,030 PSAY SUBSTR(aTotais[i][3],1,30)
				@nLin,080 PSAY aTotais[i][4] Picture "@E 999,999,999.99"
				@nLin,100 PSAY aTotais[i][5] Picture "@E 99.99%"
				@nLin,110 PSAY aTotais[i][6] Picture "@E 999,999.99"
				nTotal   += aTotais[i][4]
				nTotal1  += aTotais[i][6]
				nLin := nLin + 1 // Avanca a linha de impressao

				If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif

			Next I

			@nLin,001 PSAY "TOTAL    ------------------------------------------------>"
			@nLin,080 PSAY nTotal  Picture "@E 999,999,999.99"
			@nLin,110 PSAY nTotal1 Picture "@E 999,999.99"

		Endif

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

		DBSelectARea("TMP")
		DBCloseArea("TMP")

		MS_FLUSH()

	ENDIF

Return

Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}


	AADD(aRegs,{cPerg,"01","Filial?		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"02","Vendedor?		","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"03","Vendedor?		","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
	AADD(aRegs,{cPerg,"04","De  Emissao	?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Ate Emissao	?","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","De  Vencimento	?","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Ate Vencimento	?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","De Cliente?		","","","mv_ch08","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"09","Ate Cliente?	","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
	AADD(aRegs,{cPerg,"10","De Prefixo?		","","","mv_ch10","C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Ate Prefixo?	","","","mv_ch11","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","De Numero?		","","","mv_ch12","C",09,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Ate Numero?	","","","mv_ch13","C",09,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","De Tipo?		","","","mv_ch14","C",03,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"15","Ate Tipo?	","","","mv_ch15","C",03,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"16","De Natureza?		","","","mv_ch16","C",10,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"17","Ate Natureza?	","","","mv_ch17","C",10,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
	AADD(aRegs,{cPerg,"18","De  Baixa	?","","","mv_ch18","D",08,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"19","Ate Baixa	?","","","mv_ch19","D",08,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"20","Filtra Vendedor?","","","mv_ch20","C",20,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"21","Imprime Natureza","","","mv_ch21","N",01,0,0,"C","","mv_par21","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"22","Gera Planilha","","","mv_ch22","N",01,0,0,"C","","mv_par22","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"23","Não Pagos ","","","mv_ch23","N",01,0,0,"C","","mv_par23","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"24","Imprime Totais","","","mv_ch24","N",01,0,0,"C","","mv_par24","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

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

Return
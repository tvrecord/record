#Include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ GERAEXP  บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao de Geracao dos Arquivos de Exportacao para o        บฑฑ
ฑฑบ          ณ sistema SIG-LM                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso      ณ TV Record                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function GERAEXP()
Private _nnn := 0
_cOrigem := "MP8"
U_I_GERAEXP()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณI_GERAEXP บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao de Geracao dos Arquivos de Exportacao para o        บฑฑ
ฑฑบ          ณ sistema SIG-LM. Esta serah chamada direto pelo Job         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function I_GERAEXP()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private _oBxDesp
Private _oBxRec
Private _oClaFinDe
Private _oClaFinRe
Private _oClientes
Private _oDesp
Private _oFornece
Private _oParDesp
Private _oParRec
Private _oRec
Private _oSomenDes
Private _oSomenRec
Private _oTodos

Private _lBxDesp	:= .T.
Private _lBxRec		:= .T.
Private _lClaFinDe	:= .T.
Private _lClaFinRe	:= .T.
Private _lClientes	:= .T.
Private _lDesp		:= .T.
Private _lFornece	:= .T.
Private _lParDesp	:= .T.
Private _lParRec	:= .T.
Private _lRec		:= .T.
Private _lSomenDes	:= .F.
Private _lSomenRec	:= .F.
Private _lTodos		:= .T.

Private _path		:= "" //GetNewPar("MV_DIREXP","C:\Protheus8\Protheus_Data\SIG_FIN\")
Private _lDatado	:= .T.

Private _oDlg
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private cPerg		:= "GERAEX    "
Private _cCodEmiss	:= GetNewPar("MV_CODEMIS","88")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama a Tela de Perguntas e de Escolha se tiver sido chamado do menuณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Type("_cOrigem") <> "U"
	ChamaPerg()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da tela de processamento.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG _oDlg TITLE OemToAnsi("Gerao de Arquivos de Exporta็ใo para o SIG-LM") FROM C(356),C(334) TO C(600),C(904) PIXEL
	// Grupos
	@ C(005),C(002) TO C(067),C(095) LABEL "  Gerais  "	PIXEL OF _oDlg
	@ C(005),C(097) TO C(067),C(190) LABEL "  Despesas  "	PIXEL OF _oDlg
	@ C(005),C(192) TO C(067),C(285) LABEL "  Receitas  "	PIXEL OF _oDlg
	@ C(067),C(002) TO C(104),C(285) LABEL ""					PIXEL OF _oDlg
	// Agrupadores
	@ C(014),C(007) CheckBox _oTodos		Var _lTodos		Prompt	"Todos"																	Size C(075),C(008) on change ChangeT()	PIXEL OF _oDlg
	@ C(024),C(007) CheckBox _oSomenDes		Var _lSomenDes	Prompt	"Somente Despesas"														Size C(075),C(008) ON CHANGE ChangeSD()	PIXEL OF _oDlg
	@ C(034),C(007) CheckBox _oSomenRec		Var _lSomenRec	Prompt	"Somente Receitas"														Size C(075),C(008) ON CHANGE ChangeSR()	PIXEL OF _oDlg
	// Despesas
	@ C(014),C(100) CheckBox _oDesp			Var _lDesp		Prompt	"Despesas"																Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(024),C(100) CheckBox _oClaFinDe		Var _lClaFinDe	Prompt	"Classifica็ใo Financeira"												Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(034),C(100) CheckBox _oParDesp		Var _lParDesp	Prompt	"Parcelamento"															Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(044),C(100) CheckBox _oBxDesp		Var _lBxDesp	Prompt	"Baixa"																	Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(054),C(100) CheckBox _oFornece		Var _lFornece	Prompt	"Fornecedores"															Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	// Receitas
	@ C(014),C(196) CheckBox _oRec			Var _lRec		Prompt	"Receitas"																Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(024),C(196) CheckBox _oClaFinRe		Var _lClaFinRe	Prompt	"Classificacao Financeira"												Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(034),C(196) CheckBox _oParRec		Var _lParRec	Prompt	"Parcelamento"															Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(044),C(196) CheckBox _oBxRec			Var _lBxRec		Prompt	"Baixa"																	Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	@ C(054),C(196) CheckBox _oClientes		Var _lClientes	Prompt	"Clientes"																Size C(075),C(008) ON CHANGE Desmarca()	PIXEL OF _oDlg
	// Observacoes
	@ C(072),C(005) Say "          Este programa irแ gerar vแrios arquivos texto, conforme os parโmetros definidos pelo Usuแrio, e conterแ"	Size C(260),C(008) COLOR CLR_BLACK		PIXEL OF _oDlg
	@ C(082),C(005) Say "todos os registros necessแrios paa a Importa็ใo pelo Sistema SIG-LM."												Size C(168),C(008) COLOR CLR_BLACK		PIXEL OF _oDlg
	@ C(092),C(005) Say "          Os arquivos serใo gravados no diret๓rio informado no parโmetro.                        "					Size C(227),C(008) COLOR CLR_BLACK		PIXEL OF _oDlg
	// Botoes
	@ C(109),C(194) BMPBUTTON TYPE 01 ACTION OkGeraTxt()
	@ C(109),C(221) BMPBUTTON TYPE 02 ACTION Close(_oDlg)
	@ C(109),C(248) BMPBUTTON TYPE 05 ACTION ChamaPerg()
	Activate Dialog _oDlg Centered
else
	// Rotina Executada pelo JOB / Agendamento
	MV_PAR01	:= dDataBase
	MV_PAR02	:= dDataBase
	MV_PAR03	:= xFilial("SE1")
	MV_PAR04	:= MV_PAR03
	MV_PAR05	:= 2
	Geracao()
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณOkGeraTxt บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Chama a Funcao de Geracao dos Arquivos TXT                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function OkGeraTxt

Private oProcess
Private _lProcessa := .T.

If MsgYesNo("Deseja limpar flag para este perํodo para novo envio?")
	Processa({|_lProcessa| FLAGTAB() },"Realizando limpeza de flag...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|_lProcessa| Geracao() },"Gerando Arquivos...")

Close(_oDlg)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ Geracao  บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao de Geracao dos Arquivos TXT                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Geracao()

Private cEOL	:= "CHR(13)+CHR(10)"
Private oProcess

//oProcess:SetRegua1(6)
//oProcess:IncRegua1( "Verificando a Tabelas" )

_path := Alltrim(MV_PAR06) //Diret๓rio informado pelo usuแrio

// Verifica se o usuario nao escolheu acidionar a data no nome do arquivo TXT.
if MV_PAR05 == 2
	_lDatado := .F.
endif

// Prepara Fim de Linha e Retorno do Carro(Cursor)
cEOL := Trim(cEOL)
cEOL := &cEOL

// Se nao for JOB, seto a regua
If Type("_cOrigem") <> "U"
	ProcRegua(10)
endif

if _lDesp .or. _lClaFinDe .or. _lParDesp
	// despesas.txt e/ou classificacao_financeira_despesas.txt e/ou parcelamento_despesas.txt
	Processa({|| GeraArq01(_lDatado) },"Aguarde!!!","Gerando arquivo de despesas...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
if _lBxDesp
	// baixas_despesas.txt
	Processa({|| GeraArq04(_lDatado) },"Aguarde!!!","Gerando arquivo de baixa de despesas...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
if _lFornece
	//GeraArq05(.F.) // fornecedores.txt
	Processa({|| GeraArq05(_lDatado) },"Aguarde!!!","Gerando arquivo de fornecedores...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
if _lRec .or. _lClaFinRe .or. _lParRec
	// receitas.txt e/ou Classificacao_financeira_receitas.txt e/ou parcelamento_despesas.txt
	Processa({|| GeraArq06(_lDatado) },"Aguarde!!!","Gerando arquivo de receitas...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
if _lBxRec
	// baixas_receitas.txt
	Processa({|| GeraArq09(_lDatado) },"Aguarde!!!","Gerando arquivo de baixas receitas...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
if _lClientes
	//clientes.txt
	Processa({|| GeraArq10(_lDatado) },"Aguarde!!!","Gerando arquivo de clientes ...")
	If Type("_cOrigem") <> "U"
		IncProc()
	endif
endif
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq01 บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Despesas                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq01(_lData)
Local _cTxt		:= ""
Local _cLin		:= ""
Local _cQry		:= ""
Local _cNomeArq	:= _path + "despesas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Local _aTps 	:= {}
Local _aParc 	:= {}
Local _nVlRet  	:= 0
Local _nValBrut := 0

Private _aTits		:= {}
Private _aClaFisD	:= {}
Private _aParcDesp	:= {}
Private nValPgto    := 0
Private nOldValPgto := 0

dbSelectArea("SE2")
dbSetOrder(1)


if _lDesp
	Private nHdl	:= fCreate(_cNomeArq)
	if nHdl == -1
		Conout("O arquivo DESPESAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
		Return
	endif
	Conout("Iniciando Gera็ใo do arquivo DESPESAS.TXT")
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se existem titulos com data de emissao anterior a data do  ณ
//ณ parametro e que ainda nao foi enviado.                              ณ
//ณ Ex.: Titulos inseridos com data retroativa.                         ณ
//รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
//ณ Essa parte do programa captura registros antes da data informada nosณ
//ณ parametros e que ainda nao foram enviados para o SIG-LM.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQry := ""
_cQry += "select *"
_cQry += "  from " + RetSqlName("SE2")
_cQry += " where e2_filial >= '"	+ MV_PAR01			+ "'"
_cQry += "   and e2_filial <= '"	+ MV_PAR02			+ "'"
_cQry += "   and e2_emissao <= '"	+ DtoS(MV_PAR04)	+ "'"
_cQry += "   and e2_tipo not in ('PA')"
_cQry += "   and e2_enviado <> 'S'"
_cQry += "   and substr(e2_bcopag,1,2) <> 'CX'" //titulos que serao pagos pelo CX? nao entra - Cristiano
_cQry += "   and d_e_l_e_t_ = ' '"
_cQry += " order by e2_filial, e2_prefixo, e2_num, e2_parcela, e2_tipo, e2_fornece, e2_loja"  //otimizar query - cristiano
TCQUERY _cQry NEW ALIAS "TE2"

ProcRegua(RecCount())

if !TE2->(Eof())
	while !TE2->(Eof())
		
		IncProc()
		
		_nValBrut := 0
		_nVlRet   := 0
		
		//Nใo gera os tํtulos de abatimento: AB-|IR-|IN-|IS-|PI-|CF-|CS-|FU-|FE-. Por Cristiano em 18/09/07 conforme e-mail Luis Ricardo
		If TE2->E2_TIPO $ MVABATIM
			TE2->(dbSkip())
			Loop
		EndiF
		
		//Grava os Registros de Todas as Parcelas para uso no arquivo Parcelamento_despesas.txt
		if _lParDesp
			CriaParc("E2","TE2") // primeiro
		endif
		//Verifica se o tํtulo jแ existe no array. Adicionado o tipo do tํtulo
		If Alltrim(TE2->E2_TIPO) $ ("TX/INS/ISS")
			nY := aScan(_aTits,{|x| x[1] + x[3] + x[2] + x[20] + x[8] + x[4] + x[5] ==;
			TE2->E2_FILIAL + TE2->E2_PREFIXO + TE2->E2_NUM + TE2->E2_PARCELA + TE2->E2_TIPO + TE2->E2_FORNECE + TE2->E2_LOJA})
		Else
			nY := aScan(_aTits,{|x| x[1] + x[2] + x[3] + x[8] + x[4] + x[5] == TE2->E2_FILIAL + TE2->E2_NUM + TE2->E2_PREFIXO + TE2->E2_TIPO + TE2->E2_FORNECE + TE2->E2_LOJA})
		EndIf
		
		
		If nY == 0
			//Somo com estes valores, pois jแ sao deduzidos automaticamente. IRF/ISS/INSS
			_nValBrut := TE2->E2_VALOR + TE2->E2_IRRF + TE2->E2_ISS + TE2->E2_INSS
			//Neste caso, se for maior ou igual a 5000 ja realiza a dedu็ใo, caso contrแrio, ira sem as reten็๕es
			//e o usuแrio alterarแ no SIG manualmente caso haja a retencao.
			If _nValBrut >= GetMv("MV_VL10925") .and. (TE2->E2_COFINS + TE2->E2_PIS + TE2->E2_CSLL) > 0
				_nVlRet := TE2->E2_COFINS + TE2->E2_PIS + TE2->E2_CSLL +;
				TE2->E2_IRRF + TE2->E2_ISS + TE2->E2_INSS
			ElseIf (TE2->E2_IRRF + TE2->E2_ISS + TE2->E2_INSS) > 0 //.and.;
				//(TE2->E2_COFINS + TE2->E2_PIS + TE2->E2_CSLL) == 0
				_nVlRet := TE2->E2_IRRF + TE2->E2_ISS + TE2->E2_INSS
			EndIf
			// Pesquisa se o Titulo esta vinculado a uma NF, pois precisamos da Data de Digitacao da NF que deu origem ao Titulo, se houver.
			_dDigitNF := Posicione("SF1",1,TE2->E2_FILIAL + TE2->E2_NUM + TE2->E2_PREFIXO,"F1_DTDIGIT")
			// Insere no Array esses Titulos a serem enviados
			aadd(_aTits,{	TE2->E2_FILIAL											,; // 01 - Filial
			TE2->E2_NUM												,; // 02 - Numero do Titulo
			TE2->E2_PREFIXO											,; // 03 - Prefixo do Titulo
			TE2->E2_FORNECE											,; // 04 - Fornecedor
			TE2->E2_LOJA											,; // 05 - Loja do Fornecedor
			_nValBrut												,; // 06 - Valor do Titulo
			iif(!Empty(_dDigitNF),_dDigitNF,StoD(TE2->E2_EMISSAO))	,; // 07 - Data de Digitacao da Nota, se branco, pega a Emissao do Titulo
			TE2->E2_TIPO											,; // 08 - Tipo do Titulo
			StoD(TE2->E2_EMISSAO)									,; // 09 - Data da Emissao do Titulo
			TE2->E2_IRRF											,; // 10 - Valor IRRF
			TE2->E2_ISS												,; // 11 - Valor ISS
			TE2->E2_PIS												,; // 12 - Valor PIS
			TE2->E2_COFINS											,; // 13 - Valor COFINS
			TE2->E2_CSLL											,; // 14 - Valor CSLL
			TE2->E2_INSS											,; // 15 - Valor INSS
			TE2->E2_HIST											,; // 16 - Historico
			TE2->E2_ENVIADO											,; // 17 - Enviado
			TE2->R_E_C_N_O_											,; // 18 - RECNO
			TE2->E2_NATUREZ											,; // 19 - Natureza
			TE2->E2_PARCELA											,; // 20 - Parcela do Titulo
			_nVlRet                                                 ,; // 21 - Valor de retencoes
			TE2->E2_MULTNAT											}) // 22 - Multi-naturezas
		else // Incrementa o Titulo que ja existe no array
			_aTits[nY][06] += TE2->E2_VALOR
			_aTits[nY][10] += TE2->E2_IRRF
			_aTits[nY][11] += TE2->E2_ISS
			_aTits[nY][12] += TE2->E2_PIS
			_aTits[nY][13] += TE2->E2_COFINS
			_aTits[nY][14] += TE2->E2_CSLL
			_aTits[nY][15] += TE2->E2_INSS
		endif
		TE2->(DbSkip())
	enddo
endif
TE2->(DbCloseArea())

// Verifica se tambem entrou para gerar as Despesas ou se foi para gerar somente a Classificacao_Financeira_Despesas
// Isto porque preciso usar essa rotina para aproveitar a regra(Filtros) das Despesas para a Classificacao_Financeira_Despesas
if _lDesp
	for _x := 1 to len(_aTits)
		// Verifica se o titulo em questao ja foi enviado anteriormente
		if _aTits[_x][17] <> "S"
			// Testa se o Titulo obedece os Parametros de Filial De-Ate informados pelo Usuario ou JOB
			if _aTits[_x][01] >= MV_PAR01 .and. _aTits[_x][01] <= MV_PAR02
				_cTxt := ""
				_cTxt += _cCodEmiss	+ ";"
				_cTxt += alltrim(_aTits[_x][04]) + alltrim(_aTits[_x][05]) + ";"
				//Alteracao Cristiano 26/06/07. Incrementado no n๚mero do tํtulo com E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
				//pois estava com duplicidade nos titulos TX, ISS, INS.
				If alltrim(_aTits[_x][08]) $ ("TX/INS/ISS")
					_cTxt += alltrim(_aTits[_x][03]) + alltrim(_aTits[_x][02]) + alltrim(_aTits[_x][20]) +;
					alltrim(_aTits[_x][08]) + alltrim(_aTits[_x][04]) + alltrim(_aTits[_x][05]) + ";"
				Else
					_cTxt += alltrim(_aTits[_x][03]) + alltrim(_aTits[_x][02]) + alltrim(_aTits[_x][08]) +;
					alltrim(_aTits[_x][04]) + alltrim(_aTits[_x][05]) + ";"
				EndIf
				_cTxt += VerifTp(_aTits[_x][08]) + ";"
				_cTxt += substr(DtoS(_aTits[_x][09]),1,4) + "/" + substr(DtoS(_aTits[_x][09]),5,2) + "/" + substr(DtoS(_aTits[_x][09]),7,2) + ";"
				_cTxt += substr(DtoS(_aTits[_x][07]),1,4) + "/" + substr(DtoS(_aTits[_x][07]),5,2) + "/" + substr(DtoS(_aTits[_x][07]),7,2) + ";"
				_cTxt += lTrim(Str(_aTits[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
				//_cTxt += lTrim(Str((_aTits[_x][11] + _aTits[_x][12] + _aTits[_x][13] + _aTits[_x][14] + _aTits[_x][15]),14,2)) + ";"
				_cTxt += lTrim(Str(_aTits[_x][21],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
				_cTxt += alltrim(_aTits[_x][16]) + ";"
				_cTxt += cEOL
				
				if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
					if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					endif
				endif
				
				MarcaReg("E2",_aTits[_x][18])
				
			endif
		endif
	next _x
	
	fClose(nHdl)
	
	Conout("Finalizando Gera็ใo do arquivo DESPESAS.TXT")
endif

dbSelectArea("SEV")
dbSetOrder(1) //PREF + NUM + PARC + TIPO + FOR + LOJA            

if _lClaFinDe
	for _x := 1 to Len(_aTits)
		// Prepara o Array de Classificacao_Financeiras_Despesas se estiver marcado para geracao
		if _aTits[_x][17] <> "S"
			_nY := aScan(_aClaFisD,{|x| x[1] + x[2] + x[3] + x[8] + x[4] + x[5] ==; 
				   _aTits[_x][01] + _aTits[_x][02] + _aTits[_x][03] + _aTits[_x][20] + _aTits[_x][04] + _aTits[_x][05] }) 
			if _nY == 0
				//Verifica se o tํtulo possui multiplas naturezas 
				_cQry := ""
				_cQry += "SELECT * "
				_cQry += "FROM " + RetSqlName("SEV")+" SEV "
				_cQry += "WHERE SEV.D_E_L_E_T_ 	= '' "
				_cQry += "AND EV_FILIAL 	= '"+_aTits[_x][01]+"' "
				_cQry += "AND EV_PREFIXO 	= '"+_aTits[_x][03]+"' "
				_cQry += "AND EV_NUM 		= '"+_aTits[_x][02]+"' "
				_cQry += "AND EV_PARCELA 	= '"+_aTits[_x][20]+"' " 
				_cQry += "AND EV_TIPO 		= '"+_aTits[_x][08]+"' " 
				_cQry += "AND EV_CLIFOR 	= '"+_aTits[_x][04]+"' "
				_cQry += "AND EV_LOJA 		= '"+_aTits[_x][05]+"' "
				_cQry += "AND EV_RECPAG 	= 'P' "
				_cQry += "AND EV_PERC 		< 1 "
				             
				TcQuery _cQry New Alias "TEV"
				
				If !TEV->(Eof())

					While !TEV->(Eof()) 
					
						aadd(_aClaFisD,{TEV->EV_FILIAL	,; // 01 - Filial
										TEV->EV_NUM		,; // 02 - Numero do Titulo
										TEV->EV_PREFIXO	,; // 03 - Prefixo do Titulo
										TEV->EV_CLIFOR	,; // 04 - Fornecedor
										TEV->EV_LOJA	,; // 05 - Loja do Fornecedor
										TEV->EV_VALOR 	,; // 06 - Valor do Titulo 
										TEV->EV_NATUREZ	,; // 07 - Natureza financeira
										TEV->EV_PARCELA	,; // 08 - Parcela do Titulo
										TEV->EV_TIPO  	}) // 09 - Tipo do Titulo
	 					TEV->(dbSkip())
	 				EndDo		  				 						  
				Else					 				
					aadd(_aClaFisD,{	_aTits[_x][01]	,; // 01 - Filial
										_aTits[_x][02]	,; // 02 - Numero do Titulo
										_aTits[_x][03]	,; // 03 - Prefixo do Titulo
										_aTits[_x][04]	,; // 04 - Fornecedor
										_aTits[_x][05]	,; // 05 - Loja do Fornecedor
										_aTits[_x][06] -  _aTits[_x][21] ,; // 06 - Valor do Titulo - as reten็๕es
										_aTits[_x][19]	,; // 07 - Natureza financeira
										_aTits[_x][20]	,; // 08 - Parcela do Titulo
										_aTits[_x][08]  }) // 09 - Tipo do Titulo
				EndIf
				If Select("TEV") > 0
					TEV->(dbCloseArea())
				EndIf
			else      
				//Nao seja multi-naturezas
				If _aTits[_x][22] == "2"
					_aClaFisD[_nY][06] += _aTits[_x][06] - (_aTits[_x][10] + _aTits[_x][11] + _aTits[_x][12] + _aTits[_x][13] + _aTits[_x][14] + _aTits[_x][15]) //tamb้m diminui as reten็oes
				Else                                   
					SEV->(dbSetOrder(1))
					SEV->(dbSeek(xFilial("SEV")+_aTits[_x][03]+_aTits[_x][02]+_aTits[_x][20]+_aTits[_x][08]+_aTits[_x][04]+_aTits[_x][05]+_aTits[_x][19],.F.))
					_aClaFisD[_nY][06] += SEV->EV_VALOR
				EndIf	
			endif
		endif
	next _x
	GeraArq02(_lDatado) // Classificacao_Financeira_Despesas.txt
endif

if _lParDesp
	GeraArq03(_lDatado) // Parcelamento_Despesas.txt
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq02 บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Classificacao Financeira - Despesas      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq02(_lData)
Local _cTxt		:= ""
Local _cNomeArq	:= _path + "classificacao_financeira_despesas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo CLASSIFICACAO_FINANCEIRA_DESPESAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo CLASSIFICACAO_FINANCEIRA_DESPESAS.TXT")

for _x := 1 to len(_aClaFisD)
	// Consulta a Natureza para capturar o Codigo SIG
	DbSelectArea("SED")
	DbSetOrder(1)
	if SED->(DbSeek(_aClaFisD[_x][01] + _aClaFisD[_x][07]))
		_ContSig := SED->ED_CONTSIG
	else
		_ContSig := "Nao encontrada Conta-Sig, Verificar Cadastro de Natureza"
	endif
	
	_cTxt := ""
	_cTxt += _cCodEmiss	+ ";"
	_cTxt += alltrim(_aClaFisD[_x][04]) + alltrim(_aClaFisD[_x][05]) + ";" //Adicionado a loja em 08/08/07 por Cristiano
	If alltrim(_aClaFisD[_x][09]) $ ("TX/INS/ISS")
		_cTxt += alltrim(_aClaFisD[_x][03]) + alltrim(_aClaFisD[_x][02]) + alltrim(_aClaFisD[_x][08]) +;
		alltrim(_aClaFisD[_x][09]) + alltrim(_aClaFisD[_x][04]) + alltrim(_aClaFisD[_x][05]) + ";"
	Else
		_cTxt += alltrim(_aClaFisD[_x][03]) + alltrim(_aClaFisD[_x][02]) + alltrim(_aClaFisD[_x][09]) +;
		alltrim(_aClaFisD[_x][04]) + alltrim(_aClaFisD[_x][05]) + ";"
	EndIf
	_cTxt += iif(type("_ContSig")=="N",alltrim(str(_ContSig)),_ContSig) + ";"
	_cTxt += lTrim(Str(_aClaFisD[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
	_cTxt += alltrim(_aClaFisD[_x][07]) + ";"
	_cTxt += cEOL
	
	if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		endif
	endif
	
next _x

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo CLASSIFICACAO_FINANCEIRA_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq03 บ Autor ณ Klaus S. Peres     บ Data ณ  22/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Parcelamento de Despesas                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq03(_lData)
Local _cTxt		:= ""
Local _cNomeArq	:= _path + "parcelamento_despesas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo PARCELAMENTO_DESPESAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo PARCELAMENTO_DESPESAS.TXT")

for _x := 1 to len(_aParcDesp)
	_cTxt := ""
	_cTxt += _cCodEmiss	+ ";"
	_cTxt += alltrim(_aParcDesp[_x][04]) + alltrim(_aParcDesp[_x][05]) + ";" //Adicionado a loja em 08/08/07 por Cristiano
	//Altera็ใo Cristiano em 05/05/08 atender: E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	If alltrim(_aParcDesp[_x][08]) $ ("TX/INS/ISS")
		_cTxt += alltrim(_aParcDesp[_x][02])+alltrim(_aParcDesp[_x][01])+alltrim(_aParcDesp[_x][03]) +;
		alltrim(_aParcDesp[_x][08])+alltrim(_aParcDesp[_x][04]) + alltrim(_aParcDesp[_x][05]) + ";"
	Else
		_cTxt += alltrim(_aParcDesp[_x][02]) + alltrim(_aParcDesp[_x][01]) + alltrim(_aParcDesp[_x][08]) +;
		alltrim(_aParcDesp[_x][04]) + alltrim(_aParcDesp[_x][05]) + ";"
	EndIf
	if type("_aParcDesp[_x][07]") == "D"
		_cTxt += substr(DtoS(_aParcDesp[_x][07]),1,4) + "/" + substr(DtoS(_aParcDesp[_x][07]),5,2) + "/" + substr(DtoS(_aParcDesp[_x][07]),7,2) + ";"
	else
		_cTxt += substr(_aParcDesp[_x][07],1,4) + "/" + substr(_aParcDesp[_x][07],5,2) + "/" + substr(_aParcDesp[_x][07],7,2) + ";"
	endif
	_cTxt += lTrim(Str(_aParcDesp[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
	_cTxt += strzero(val(iif(alltrim(_aParcDesp[_x][03])=="","1",_aParcDesp[_x][03]) ),5) + ";"
	_cTxt += cEOL
	
	if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		endif
	endif
	
next _x

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo PARCELAMENTO_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq04 บ Autor ณ Klaus S. Peres     บ Data ณ  19/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Baixa de Despesas                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq04(_lData)

Local _cTxt		:= ""
Local _cLin		:= ""
Local _cQry		:= ""
Local _cNomeArq	:= _path + "Baixa_despesas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo BAIXA_DESPESAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo BAIXA_DESPESAS.TXT")

_cQry += "SELECT *"
_cQry += "  FROM " + RetSqlName("SE5")+" SE5,"
_cQry += " " +RetSqlName("SE2")+" SE2"
_cQry += " WHERE E5_FILIAL BETWEEN '"+ MV_PAR01+ "' AND '"+MV_PAR02+ "'"
_cQry += "   AND E5_DATA BETWEEN	'"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"'"
_cQry += "   AND E5_RECPAG = 'P'"
_cQry += "   AND E5_TIPO NOT IN ('PA')"
_cQry += "   and E5_NUMERO <> ' '"
_cQry += "   and E5_PREFIXO <> ' '"
_cQry += "	 AND E5_VALOR <> 0"
_cQry += "	 AND E5_ENVIADO <> 'S'"
_cQry += "	 AND SUBSTR(E5_BANCO,1,2) <> 'CX'"
_cQry += "   AND E5_SITUACA NOT IN ('C','E','X')"
_cQry += "	 AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','TL','TR','TE','PA')"
_cQry += "	 AND E5_MOEDA NOT IN ('C1','C2','C3','C4','C5','CH')"
_cQry += "	 AND E5_NUMCHEQ = ' '"
_cQry += "   and SE5.D_E_L_E_T_ = ' '"
_cQry += "   and SE2.D_E_L_E_T_ = ' '"
_cQry += "   AND E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA ="
_cQry += " 	 E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
_cQry += "	 AND E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ NOT IN"
_cQry += " 	 (SELECT E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
_cQry += "   FROM SE5010 SE5CAN"
_cQry += "   WHERE SE5CAN.D_E_L_E_T_ = ' '"
_cQry += "   AND SE5CAN.E5_FILIAL  = SE5.E5_FILIAL"
_cQry += "   AND SE5CAN.E5_PREFIXO = SE5.E5_PREFIXO"
_cQry += "   AND SE5CAN.E5_NUMERO  = SE5.E5_NUMERO"
_cQry += "   AND SE5CAN.E5_PARCELA = SE5.E5_PARCELA"
_cQry += "   AND SE5CAN.E5_TIPO    = SE5.E5_TIPO"
_cQry += "   AND SE5CAN.E5_CLIFOR  = SE5.E5_CLIFOR"
_cQry += "   AND SE5CAN.E5_LOJA    = SE5.E5_LOJA"
_cQry += "   AND SE5CAN.E5_SEQ     = SE5.E5_SEQ"
_cQry += "   AND SE5CAN.E5_TIPODOC = 'ES')"
_cQry += "   ORDER BY E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA"
TCQUERY _cQry NEW ALIAS "TE5"
//Somente para testes
//MemoWrite("c:\despesas.sql",_cQry)

ProcRegua(RecCount())

While !TE5->(Eof())
	
	IncProc()
	
	//Nใo gera os tํtulos de abatimento: AB-|IR-|IN-|IS-|PI-|CF-|CS-|FU-|FE-. Por Cristiano em 18/09/07 conforme e-mail Luis Ricardo
	If TE5->E5_TIPO $ MVABATIM
		TE5->(dbSkip())
		Loop
	EndiF
	_cTxt := ""
	_cTxt += _cCodEmiss + ";"
	_cTxt += alltrim(TE5->E5_CLIFOR) + alltrim(TE5->E5_LOJA) +";" //Adicionado a loja em 08/08/07 por Cristiano
	If alltrim(TE5->E5_TIPO) $ ("TX/INS/ISS")
		_cTxt += alltrim(TE5->E5_PREFIXO)+alltrim(TE5->E5_NUMERO)+alltrim(TE5->E5_PARCELA) +;
		alltrim(TE5->E5_TIPO) + alltrim(TE5->E5_CLIFOR) + alltrim(TE5->E5_LOJA) + ";"
	Else
		_cTxt += alltrim(TE5->E5_PREFIXO)+alltrim(TE5->E5_NUMERO)+ alltrim(TE5->E5_TIPO) + ;
		alltrim(TE5->E5_CLIFOR) + alltrim(TE5->E5_LOJA) + ";"
	EndIf
	_cTxt += strzero(val(iif(!Empty(TE5->E5_PARCELA),alltrim(TE5->E5_PARCELA),"1")),5) + ";"
	_cTxt += substr(TE5->E5_DATA,1,4) + "/" + substr(TE5->E5_DATA,5,2) + "/" + substr(TE5->E5_DATA,7,2) + ";"
	_cTxt += lTrim(Str(TE5->E5_VALOR,TamSX3("E5_VALOR")[1],TamSX3("E5_VALOR")[2])) + ";"
	_cTxt += lTrim(Str(TE5->E5_VLDESCO,TamSX3("E5_VLDESCO")[1],TamSX3("E5_VLDESCO")[2])) + ";"
	_cTxt += lTrim(Str(TE5->E5_VLJUROS+TE5->E5_VLMULTA,TamSX3("E5_VLJUROS")[1],TamSX3("E5_VLJUROS")[2])) + ";"
	//_cTxt += MotivoBx(alltrim(TE5->E5_MOTBX)) + ";" // substr(alltrim(TE5->E5_MOTBX),1,2) + ";"
	_cTxt += IIf((Empty(TE5->E5_BANCO) .or. Substr(TE5->E5_BANCO,1,1) <> "C"),"BA","DI") + ";"
	_cTxt += alltrim(TE5->E5_NUMCHEQ) + ";"
	_cTxt += cEOL
	
	If fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	MarcaReg("E5",TE5->R_E_C_N_O_)
	
	TE5->(DbSkip())
	
Enddo

TE5->(DbCloseArea())

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo BAIXA_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq05 บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Fornecedores                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq05(_lData)
Local _cTxt		:= ""
Local _cLin		:= ""
Local _cQry		:= ""
Local _cNomeArq	:= _path + "Fornecedores" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo FORCEDORES.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo FORCEDORES.TXT")

DbSelectArea("SA2")
SA2->(DbSetOrder(1))
//oProcess:IncRegua1( "Fornecedores" )
//oProcess:SetRegua2(SA2->(LastRec()))

SA2->(DbGoTop())

ProcRegua(RecCount())

While !SA2->(Eof())
	IncProc()
	//oProcess:IncRegua2()
	
	_cTxt := ""
	_cTxt += _cCodEmiss					+ ";"
	_cTxt += alltrim(SA2->A2_COD)		+ alltrim(SA2->A2_LOJA) + ";" //Adicionado por Cristiano em 08/08/2007. Pois existem lojas 01, 02...
	_cTxt += alltrim(SA2->A2_CGC)		+ ";"
	_cTxt += alltrim(SA2->A2_NREDUZ)	+ ";"
	_cTxt += alltrim(SA2->A2_NOME)		+ ";"
	_cTxt += alltrim(SA2->A2_END)		+ ";"
	_cTxt += alltrim(SA2->A2_BAIRRO)	+ ";"
	_cTxt += alltrim(SA2->A2_MUN)		+ ";"
	_cTxt += alltrim(SA2->A2_EST)		+ ";"
	_cTxt += alltrim(SA2->A2_CEP)		+ ";"
	_cTxt += cEOL
	
	If fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif

	RecLock("SA2",.F.)
	SA2->A2_DTSIG := dDataBase
	SA2->(MsUnlock())
	
	SA2->(DbSkip())
	
Enddo

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo FORCEDORES.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq06 บ Autor ณ Klaus S. Peres     บ Data ณ  23/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Receitas                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq06(_lData)
Local	_cTxt		:= ""
Local	_cLin		:= ""
Local	_cQry		:= ""
Local	_cNomeArq	:= _path + "receitas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private _aTitsR		:= {}
Private _aClaFisR	:= {}
Private _aParcRec	:= {}

if _lRec
	Private nHdl	:= fCreate(_cNomeArq)
	if nHdl == -1
		Conout("O arquivo RECEITAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
		Return
	endif
	Conout("Iniciando Gera็ใo do arquivo RECEITAS.TXT")
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se existem titulos com data de emissao anterior a data do  ณ
//ณ parametro e que ainda nao foi enviado.                              ณ
//ณ Ex.: Titulos inseridos com data retroativa.                         ณ
//รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด
//ณ Essa parte do programa captura registros antes da data informada nosณ
//ณ parametros e que ainda nao foram enviados para o SIG-LM.            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cQry := ""
_cQry += "select *"
_cQry += "  from " + RetSqlName("SE1")
_cQry += " where e1_filial >= '"	+ MV_PAR01			+ "'"
_cQry += "   and e1_filial <= '"	+ MV_PAR02			+ "'"
_cQry += "   and e1_emissao <= '"	+ DtoS(MV_PAR04)	+ "'"
_cQry += "   and e1_tipo <> 'RA'"
_cQry += "   and e1_enviado <> 'S'"
_cQry += "   and d_e_l_e_t_ = ' '"
_cQry += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
TCQUERY _cQry NEW ALIAS "TE1"

ProcRegua(RecCount())

if !TE1->(Eof())
	while !TE1->(Eof())
		
		IncProc()
		
		//Nใo gera os tํtulos de abatimento: AB-|IR-|IN-|IS-|PI-|CF-|CS-|FU-|FE-. Por Cristiano em 18/09/07 conforme e-mail Luis Ricardo
		If TE1->E1_TIPO $ MVABATIM
			TE1->(dbSkip())
			Loop
		EndIf
		// Grava os Registros de Todas as Parcelas para uso no arquivo Parcelamento_receitas.txt
		if _lParRec
			CriaParc("E1","TE1") //primeiro
		endif
		//Verifica se o tํtulo jแ existe no array
		nY := aScan(_aTitsR,{|x| x[1] + x[2] + x[3] + x[8] + x[4] + x[5] == TE1->E1_FILIAL + TE1->E1_NUM + TE1->E1_PREFIXO + TE1->E1_TIPO + TE1->E1_CLIENTE + TE1->E1_LOJA})
		If nY == 0 //Se nใo existir
			// Pesquisa se o Titulo esta vinculado a uma NF, pois precisamos da Data de Digitacao da NF que deu origem ao Titulo, se houver.
			_dDigitNF := Posicione("SF2",1,TE1->E1_FILIAL + TE1->E1_NUM + TE1->E1_PREFIXO,"F2_EMISSAO")
			// Insere no Array esses Titulos a serem enviados
			aadd(_aTitsR,{	TE1->E1_FILIAL											,; // 01 - Filial
			TE1->E1_NUM												,; // 02 - Numero do Titulo
			TE1->E1_PREFIXO											,; // 03 - Prefixo do Titulo
			TE1->E1_CLIENTE											,; // 04 - Cliente
			TE1->E1_LOJA											,; // 05 - Loja do Fornecedor
			TE1->E1_VALOR											,; // 06 - Valor do Titulo
			iif(!Empty(_dDigitNF),_dDigitNF,StoD(TE1->E1_EMISSAO))	,; // 07 - Data de Digitacao da Nota, se branco, pega a Emissao do Titulo
			TE1->E1_TIPO											,; // 08 - Tipo do Titulo
			StoD(TE1->E1_EMISSAO)									,; // 09 - Data da Emissao do Titulo
			TE1->E1_IRRF											,; // 10 - Valor IRRF
			TE1->E1_ISS												,; // 11 - Valor ISS
			TE1->E1_PIS												,; // 12 - Valor PIS
			TE1->E1_COFINS											,; // 13 - Valor COFINS
			TE1->E1_CSLL											,; // 14 - Valor CSLL
			TE1->E1_INSS											,; // 15 - Valor INSS
			TE1->E1_HIST											,; // 16 - Historico
			TE1->E1_ENVIADO											,; // 17 - Enviado
			TE1->R_E_C_N_O_											,; // 18 - RECNO
			TE1->E1_NATUREZ											,; // 19 - Natureza
			Stod(TE1->E1_VENCTO)									,; // 20 - Vencimento
			TE1->E1_PARCELA											}) // 21 - Parcela
		else // Incrementa o Titulo que ja existe no array
			_aTitsR[nY][06] += TE1->E1_VALOR
			_aTitsR[nY][10] += TE1->E1_IRRF
			_aTitsR[nY][11] += TE1->E1_ISS
			_aTitsR[nY][12] += TE1->E1_PIS
			_aTitsR[nY][13] += TE1->E1_COFINS
			_aTitsR[nY][14] += TE1->E1_CSLL
			_aTitsR[nY][15] += TE1->E1_INSS
		endif
		TE1->(DbSkip())
	enddo
endif
TE1->(DbCloseArea())
// Verifica se tambem entrou para gerar as Receitas ou se foi para gerar somente a Classificacao_Financeira_Receitas
// Isto porque preciso usar essa rotina para aproveitar a regra(Filtros) das Receitas para a Classificacao_Financeira_Receitas
if _lRec
	for _x := 1 to len(_aTitsR)
		// Verifica se o titulo em questao ja foi enviado anteriormente
		if _aTitsR[_x][17] <> "S"
			// Testa se o Titulo obedece os Parametros de Filial De-Ate informados pelo Usuario ou JOB
			if _aTitsR[_x][01] >= MV_PAR01 .and. _aTitsR[_x][01] <= MV_PAR02
				_cTxt := ""
				_cTxt += _cCodEmiss	+ ";"
				_cTxt += alltrim(_aTitsR[_x][04]) + alltrim(_aTitsR[_x][05]) +";" //Adicionado a loja em 08/08/07 por Cristiano
				_cTxt += alltrim(_aTitsR[_x][03]) + alltrim(_aTitsR[_x][02]) + alltrim(_aTitsR[_x][08]) +";"
				_cTxt += VerifTp(_aTitsR[_x][08]) + ";"
				_cTxt += substr(DtoS(_aTitsR[_x][09]),1,4) + "/" + substr(DtoS(_aTitsR[_x][09]),5,2) + "/" + substr(DtoS(_aTitsR[_x][09]),7,2) + ";"
				_cTxt += substr(DtoS(_aTitsR[_x][20]),1,4) + "/" + substr(DtoS(_aTitsR[_x][20]),5,2) + "/" + substr(DtoS(_aTitsR[_x][20]),7,2) + ";"
				_cTxt += lTrim(Str(_aTitsR[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
				_cTxt += lTrim(Str((_aTitsR[_x][11] + _aTitsR[_x][12] + _aTitsR[_x][13] + _aTitsR[_x][14] + _aTitsR[_x][15]),14,2)) + ";"  //Reten็๕es
				_cTxt += alltrim(_aTitsR[_x][16]) + ";"
				_cTxt += cEOL
				
				if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
					if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					endif
				endif
				MarcaReg("E1",_aTitsR[_x][18])
			endif
		endif
	next _x
	
	fClose(nHdl)
	
	Conout("Finalizando Gera็ใo do arquivo RECEITAS.TXT")
endif

if _lClaFinRe
	for _x := 1 to Len(_aTitsR)
		// Prepara o Array de Classificacao_Financeiras_Despesas se estiver marcado para geracao
		if _aTitsR[_x][17] <> "S"
			if _lClaFinRe
				aadd(_aClaFisR,{	_aTitsR[_x][01]	,; // 01 - Filial
				_aTitsR[_x][02]	,; // 02 - Numero do Titulo
				_aTitsR[_x][03]	,; // 03 - Prefixo do Titulo
				_aTitsR[_x][04]	,; // 04 - Cliente
				_aTitsR[_x][05]	,; // 05 - Loja do cliente
				_aTitsR[_x][06]	- (_aTitsR[_x][10] + _aTitsR[_x][11] + _aTitsR[_x][12] + _aTitsR[_x][13] + _aTitsR[_x][14] + _aTitsR[_x][15]),; // 06 - Valor do Titulo - as reten็oes
				_aTitsR[_x][19]	,; // 07 - Natureza
				_aTitsR[_x][08] ,; // 08 - Tipo
				_aTitsR[_x][21] }) // 09 - Parcela
			endif
		endif
	next _x
	GeraArq07(_lDatado) // classificacao_financeira_receitas.txt
endif

if _lParRec
	GeraArq08(_lDatado) // parcelamento_receitas.txt
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq07 บ Autor ณ Klaus S. Peres     บ Data ณ  23/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Classificacao Financeira - Receitas      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq07(_lData)
Local _cTxt		:= ""
Local _cNomeArq	:= _path + "classificacao_financeira_receitas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo CLASSIFICACAO_FINANCEIRA_RECEITAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo CLASSIFICACAO_FINANCEIRA_RECEITAS.TXT")

for _x := 1 to len(_aClaFisR)
	// Consulta a Natureza para capturar o Codigo SIG
	DbSelectArea("SED")
	DbSetOrder(1)
	if SED->(DbSeek(_aClaFisR[_x][01] + _aClaFisR[_x][07]))
		_ContSig := SED->ED_CONTSIG
	else
		_ContSig := "Nao encontrada Conta-Sig, Verificar Cadastro de Natureza"
	endif
	
	_cTxt := ""
	_cTxt += _cCodEmiss	+ ";"
	_cTxt += alltrim(_aClaFisR[_x][04]) + alltrim(_aClaFisR[_x][05]) + ";" //Adicionado a loja em 08/08/07 por Cristiano
	_cTxt += alltrim(_aClaFisR[_x][03]) + alltrim(_aClaFisR[_x][02]) + Alltrim(_aClaFisR[_x][08]) + ";"
	_cTxt += iif(type("_ContSig")=="N",alltrim(str(_ContSig)),_ContSig) + ";"
	_cTxt += lTrim(Str(_aClaFisR[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
	_cTxt += alltrim(_aClaFisR[_x][07]) + ";"
	_cTxt += cEOL
	
	if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		endif
	endif
	
next _x

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo CLASSIFICACAO_FINANCEIRA_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq08 บ Autor ณ Klaus S. Peres     บ Data ณ  23/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Parcelamento de Receitas                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq08(_lData)
Local _cTxt		:= ""
Local _cNomeArq	:= _path + "parcelamento_receitas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo PARCELAMENTO_RECEITAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo PARCELAMENTO_RECEITAS.TXT")

for _x := 1 to len(_aParcRec)
	_cTxt := ""
	_cTxt += _cCodEmiss	+ ";"
	_cTxt += alltrim(_aParcRec[_x][04]) + Alltrim(_aParcRec[_x][05]) + ";" //Adicionado a loja em 08/08/07 por Cristiano
	_cTxt += alltrim(_aParcRec[_x][02]) + alltrim(_aParcRec[_x][01]) + alltrim(_aParcRec[_x][08]) + ";"
	if type("_aParcRec[_x][07]") == "D"
		_cTxt += substr(DtoS(_aParcRec[_x][07]),1,4) + "/" + substr(DtoS(_aParcRec[_x][07]),5,2) + "/" + substr(DtoS(_aParcRec[_x][07]),7,2) + ";"
	else
		_cTxt += substr(_aParcRec[_x][07],1,4) + "/" + substr(_aParcRec[_x][07],5,2) + "/" + substr(_aParcRec[_x][07],7,2) + ";"
	endif
	_cTxt += lTrim(Str(_aParcRec[_x][06],TamSX3("E2_VALOR")[1],TamSX3("E2_VALOR")[2])) + ";"
	_cTxt += strzero(val(iif(alltrim(_aParcRec[_x][03])=="","1",_aParcRec[_x][03]) ),5) + ";"
	_cTxt += cEOL
	
	if fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		endif
	endif
	
next _x

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo PARCELAMENTO_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq09 บ Autor ณ Klaus S. Peres     บ Data ณ  19/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Baixa de Receitas                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq09(_lData)
Local _cTxt		:= ""
Local _cLin		:= ""
Local _cQry		:= ""
Local _cNomeArq	:= _path + "Baixa_Receitas" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo BAIXA_RECEITAS.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo BAIXA_RECEITAS.TXT")

_cQry += "select *"
_cQry += "  from " + RetSqlName("SE5")+" SE5,"
_cQry += " " +RetSqlName("SE1")+" SE1"
_cQry += " where e5_filial >= '"	+ MV_PAR01			+ "'"
_cQry += "   and e5_filial <= '"	+ MV_PAR02			+ "'"
_cQry += "   and e5_data >= '"	+ DtoS(MV_PAR03)	+ "'"
_cQry += "   and e5_data <= '"	+ DtoS(MV_PAR04)	+ "'"
_cQry += "   and e5_recpag = 'R'"
_cQry += "	 AND E5_TIPO <> 'RA'"
_cQry += "   and e5_numero <> ' '"
_cQry += "	 AND E5_VALOR <> 0"
_cQry += "   AND E5_PREFIXO <> ' '"
_cQry += "	 AND E5_ENVIADO <> 'S'"
_cQry += "   AND E5_SITUACA NOT IN ('C','E','X')"
_cQry += "	 AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','TL','TR','TE','RA')"
_cQry += "	 AND E5_MOEDA NOT IN ('C1','C2','C3','C4','C5','CH')"
_cQry += "	 AND E5_NUMCHEQ = ' '"
_cQry += "   AND SE5.D_E_L_E_T_ = ' '"
_cQry += "   and SE1.D_E_L_E_T_ = ' '"
_cQry += "   AND E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA ="
_cQry += " 	 E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA"
_cQry += "	 AND E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ NOT IN"
_cQry += " 	 (SELECT E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
_cQry += "   FROM SE5010 SE5CAN"
_cQry += "   WHERE SE5CAN.D_E_L_E_T_ = ' '"
_cQry += "   AND SE5CAN.E5_FILIAL  = SE5.E5_FILIAL"
_cQry += "   AND SE5CAN.E5_PREFIXO = SE5.E5_PREFIXO"
_cQry += "   AND SE5CAN.E5_NUMERO  = SE5.E5_NUMERO"
_cQry += "   AND SE5CAN.E5_PARCELA = SE5.E5_PARCELA"
_cQry += "   AND SE5CAN.E5_TIPO    = SE5.E5_TIPO"
_cQry += "   AND SE5CAN.E5_CLIFOR  = SE5.E5_CLIFOR"
_cQry += "   AND SE5CAN.E5_LOJA    = SE5.E5_LOJA"
_cQry += "   AND SE5CAN.E5_SEQ     = SE5.E5_SEQ"
_cQry += "   AND SE5CAN.E5_TIPODOC = 'ES')"
_cQry += "   ORDER BY E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA"
TCQUERY _cQry NEW ALIAS "TE5"

ProcRegua(RecCount())

While !TE5->(Eof())
	
	IncProc()
	
	//Nใo gera os tํtulos de abatimento: AB-|IR-|IN-|IS-|PI-|CF-|CS-|FU-|FE-. Por Cristiano em 18/09/07 conforme e-mail Luis Ricardo
	If TE5->E5_TIPO $ MVABATIM
		TE5->(dbSkip())
		Loop
	EndiF
	_cTxt := ""
	_cTxt += _cCodEmiss + ";"
	_cTxt += alltrim(TE5->E5_CLIFOR) + alltrim(TE5->E5_LOJA) +";" //Adicionado a loja em 08/08/07 por Cristiano
	_cTxt += alltrim(TE5->E5_PREFIXO) + alltrim(TE5->E5_NUMERO) + alltrim(TE5->E5_TIPO) + ";"
	_cTxt += iif(!Empty(TE5->E5_PARCELA),alltrim(TE5->E5_PARCELA),"1") + ";"
	_cTxt += substr(TE5->E5_DATA,1,4) + "/" + substr(TE5->E5_DATA,5,2) + "/" + substr(TE5->E5_DATA,7,2) + ";"
	_cTxt += lTrim(Str(TE5->E5_VALOR,TamSX3("E5_VALOR")[1],TamSX3("E5_VALOR")[2])) + ";"
	_cTxt += IIf((Empty(TE5->E5_BANCO) .or. Substr(TE5->E5_BANCO,1,1) <> "C"),"BA","DI") + ";"
	_cTxt += alltrim(TE5->E5_NUMCHEQ) + ";"
	_cTxt += lTrim(Str(TE5->E5_VLDESCO,TamSX3("E5_VLDESCO")[1],TamSX3("E5_VLDESCO")[2])) + ";"
	_cTxt += lTrim(Str(TE5->E5_VLJUROS+TE5->E5_VLMULTA,TamSX3("E5_VLJUROS")[1],TamSX3("E5_VLJUROS")[2])) + ";"
	_cTxt += cEOL
	
	If fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	MarcaReg("E5",TE5->R_E_C_N_O_)
	
	TE5->(DbSkip())
	
Enddo

TE5->(DbCloseArea())

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo BAIXA_DESPESAS.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณGeraArq10 บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Gera o Arquivo de Clientes                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraArq10(_lData)
Local _cTxt		:= ""
Local _cLin		:= ""
Local _cQry		:= ""
Local _cNomeArq	:= _path + "Clientes" + iif(_lData," - " + DtoS(dDataBase),'') + ".txt"
Private nHdl	:= fCreate(_cNomeArq)

If nHdl == -1
	Conout("O arquivo CLIENTES.TXT nใo pode ser Criado! Verifique as Permiss๕es...","Atenวใo!!!")
	Return
Endif

Conout("Iniciando Gera็ใo do arquivo CLIENTES.TXT")

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbGoTop())

ProcRegua(RecCount())

While !SA1->(Eof())
	
	IncProc()
	
	_cTxt := ""
	_cTxt += _cCodEmiss													+ ";"
	_cTxt += alltrim(SA1->A1_COD) + alltrim(SA1->A1_LOJA)		+ ";" //Adicionado a loja em 08/08/07 por Cristiano
	_cTxt += alltrim(SA1->A1_CGC)										+ ";"
	_cTxt += alltrim(SA1->A1_NREDUZ)									+ ";"
	_cTxt += alltrim(SA1->A1_NOME)									+ ";"
	_cTxt += alltrim(SA1->A1_END)										+ ";"
	_cTxt += alltrim(SA1->A1_BAIRRO)									+ ";"
	_cTxt += alltrim(SA1->A1_MUN)										+ ";"
	_cTxt += alltrim(SA1->A1_EST)										+ ";"
	_cTxt += alltrim(SA1->A1_CEP)										+ ";"
	_cTxt += cEOL
	
	If fWrite(nHdl,_cTxt,Len(_cTxt)) != Len(_cTxt)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif    
	       
	RecLock("SA1",.F.)
	SA1->A1_DTSIG := dDataBase
	SA1->(MsUnlock())
	
	SA1->(DbSkip())
	
Enddo

fClose(nHdl)

Conout("Finalizando Gera็ใo do arquivo CLIENTES.TXT")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ VerifTp  บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Verifica qual o Tipo do Titulo e Classifica                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function VerifTp(_cTemp)
Local _cRet := ""
if alltrim(_cTemp) == "NF"
	_cRet := "NOT"
elseif alltrim(_cTemp) == "RC"
	_cRet := "REC"
elseif alltrim(_cTemp) == "FT"
	_cRet := "FAT"
elseif alltrim(_cTemp) == "RPA"
	_cRet := _cTemp
elseif alltrim(_cTemp) == "IRF"
	_cRet := "DAR"
elseif alltrim(_cTemp) == "BOL"
	_cRet := _cTemp
else
	_cRet := "OUT"
endif
Return (_cRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ CriaParc บ Autor ณ Klaus S. Peres     บ Data ณ  22/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao responsavel para criar o vetor que irah armazenar   บฑฑ
ฑฑบ          ณ todos os registros (Titulos) separados por parcelas        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaParc(_cTabela,_cTab)
if _cTabela == "E2" //&("M->"+x3_campo)
	aadd(_aParcDesp,{	&(_cTab + "->E2_NUM")				,; // 01 - Numero do Titulo
	&(_cTab + "->E2_PREFIXO")			,; // 02 - Prefixo do Titulo
	&(_cTab + "->E2_PARCELA")			,; // 03 - Parcela do Titulo
	&(_cTab + "->E2_FORNECE")			,; // 04 - Fornecedor
	&(_cTab + "->E2_LOJA")				,; // 05 - Loja do Fornecedor
	&(_cTab + "->E2_VALOR")				-; // 06 - Valor do Titulo
	&(_cTab + "->E2_IRRF")              -; // Reten็ใo IR - Por Cristiano em 01/10/07 abate as reten็oes
	&(_cTab + "->E2_ISS")               -; // Reten็ใo ISS
	&(_cTab + "->E2_PIS")               -; // Reten็ใo PIS
	&(_cTab + "->E2_COFINS")            -; // Reten็ใo COFINS
	&(_cTab + "->E2_CSLL")              -; // Reten็ใo CSLL
	&(_cTab + "->E2_INSS")              ,; // Reten็ใo INSS
	&(_cTab + "->E2_VENCREA")		   ,;  // 07 - Data do Vencimento do Titulo (Vencimento Real)
	&(_cTab + "->E2_TIPO")				}) // 08 - Tipo do titulo
	
elseif _cTabela == "E1"
	aadd(_aParcRec,{	&(_cTab + "->E1_NUM")				,; // 01 - Numero do Titulo
	&(_cTab + "->E1_PREFIXO")			,; // 02 - Prefixo do Titulo
	&(_cTab + "->E1_PARCELA")			,; // 03 - Parcela do Titulo
	&(_cTab + "->E1_CLIENTE")			,; // 04 - Cliente
	&(_cTab + "->E1_LOJA")				,; // 05 - Loja do Fornecedor
	&(_cTab + "->E1_VALOR")				-; // 06 - Valor do Titulo
	&(_cTab + "->E1_IRRF")              -; // Reten็ใo IR Por Cristiano em 01/10/07
	&(_cTab + "->E1_ISS")               -; // Reten็ใo ISS
	&(_cTab + "->E1_PIS")               -; // Reten็ใo PIS
	&(_cTab + "->E1_COFINS")            -; // Reten็ใo COFINS
	&(_cTab + "->E1_CSLL")              -; // Reten็ใo CSLL
	&(_cTab + "->E1_INSS")              ,; // Reten็ใo INSS
	&(_cTab + "->E1_VENCREA")			,; // 07 - Data do Vencimento do Titulo (Vencimento Real)
	&(_cTab + "->E1_TIPO")				}) // 08 - Tipo do titulo
endif
_nnn++
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณChamaPerg บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao de Validacao das Perguntes.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ChamaPerg()
ValidPerg(cPerg)
Pergunte(cPerg)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ ChangeT  บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Muda os Check Box (Todos)                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static FunctiON ChangeT()
if _lTodos
	_lBxDesp	:= .T.
	_lBxRec		:= .T.
	_lClaFinDe	:= .T.
	_lClaFinRe	:= .T.
	_lClientes	:= .T.
	_lDesp		:= .T.
	_lFornece	:= .T.
	_lParDesp	:= .T.
	_lParRec	:= .T.
	_lRec		:= .T.
	_lSomenDes	:= .F.
	_lSomenRec	:= .F.
else
	_lBxDesp	:= .F.
	_lBxRec		:= .F.
	_lClaFinDe	:= .F.
	_lClaFinRe	:= .F.
	_lClientes	:= .F.
	_lDesp		:= .F.
	_lFornece	:= .F.
	_lParDesp	:= .F.
	_lParRec	:= .F.
	_lRec		:= .F.
	_lSomenDes	:= .F.
	_lSomenRec	:= .F.
endiF
RefreshAll()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ ChangeSD บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Muda os Check Box (Somente das Despesas)                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static FunctiON ChangeSD()
if _lSomenDes
	_lBxDesp	:= .T.
	_lBxRec		:= .F.
	_lClaFinDe	:= .T.
	_lClaFinRe	:= .F.
	_lClientes	:= .F.
	_lDesp		:= .T.
	_lFornece	:= .T.
	_lParDesp	:= .T.
	_lParRec	:= .F.
	_lRec		:= .F.
	_lTodos		:= .F.
	_lSomenRec	:= .F.
else
	_lBxDesp	:= .F.
	_lBxRec		:= .F.
	_lClaFinDe	:= .F.
	_lClaFinRe	:= .F.
	_lClientes	:= .F.
	_lDesp		:= .F.
	_lFornece	:= .F.
	_lParDesp	:= .F.
	_lParRec	:= .F.
	_lRec		:= .F.
	_lTodos		:= .F.
	_lSomenRec	:= .F.
endiF
RefreshAll()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ ChangeSR บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Muda os Check Box (Somente das Receitas)                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static FunctiON ChangeSR()
if _lSomenRec
	_lBxDesp	:= .F.
	_lBxRec		:= .T.
	_lClaFinDe	:= .F.
	_lClaFinRe	:= .T.
	_lClientes	:= .T.
	_lDesp		:= .F.
	_lFornece	:= .F.
	_lParDesp	:= .F.
	_lParRec	:= .T.
	_lRec		:= .T.
	_lTodos		:= .F.
	_lSomenDes	:= .F.
else
	_lBxDesp	:= .F.
	_lBxRec		:= .F.
	_lClaFinDe	:= .F.
	_lClaFinRe	:= .F.
	_lClientes	:= .F.
	_lDesp		:= .F.
	_lFornece	:= .F.
	_lParDesp	:= .F.
	_lParRec	:= .F.
	_lRec		:= .F.
	_lTodos		:= .F.
	_lSomenDes	:= .F.
endiF
RefreshAll()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ Desmarca บ Autor ณ Klaus S. Peres     บ Data ณ  18/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Desmarca os Check Box Gerais e permanecem os Individuais   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static FunctiON Desmarca()
_lTodos		:= .F.
_lSomenDes	:= .F.
_lSomenRec	:= .F.
RefreshAll()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณRefreshAllบ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Refresh em todos os Objetos Check Box da Tela              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RefreshAll()
_oBxDesp:Refresh()
_oBxRec:Refresh()
_oClaFinDe:Refresh()
_oClaFinRe:Refresh()
_oClientes:Refresh()
_oDesp:Refresh()
_oFornece:Refresh()
_oParDesp:Refresh()
_oParRec:Refresh()
_oRec:Refresh()
_oSomenDes:Refresh()
_oSomenRec:Refresh()
_oTodos:Refresh()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MotivoBx บ Autor ณ Klaus S. Peres     บ Data ณ  26/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Retorna o Motivo de Baixa do SX5 - Tabela: SI              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MotivoBx(_cMotBx)
Local _cQry := ""
_cQry := "select x5_descri"
_cQry += "  from " + RetSqlName ("SX5")
_cQry += " where x5_filial = '" + xFilial("SX5") + "'"
_cQry += "   and x5_tabela = 'SI'"
_cQry += "   and x5_chave = '" + _cMotBx + "'"
TCQUERY _cQry NEW ALIAS "TX5"

if !TX5->(Eof())
	_cDescri := TX5->X5_DESCRI
	DbCloseArea("TX5")
else
	DbCloseArea("TX5")
	Return("Motivo da Baixa nใo encontrado no SX5 - Tabela SI. Favor Verificar...")
endif

Return(alltrim(_cDescri))

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณRefreshAllบ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Refresh em todos os Objetos Check Box da Tela              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MarcaReg(_cTabela,_xRecno)
Local _aArea	:= GetArea()
Local _cQry		:= ""

if _cTabela == "E2"
	
	DbSelectArea("SE2")
	DbGoTo(_xRecno)
	
	RecLock("SE2",.F.)
	SE2->E2_ENVIADO := "S"
	SE2->E2_DTSIG	:= dDataBase
	SE2->E2_ENVINI  := MV_PAR03
	SE2->E2_ENVFIM 	:= MV_PAR04
	SE2->(MsUnLock())
	
elseif _cTabela == "E1"
	
	DbSelectArea("SE1")
	DbGoTo(_xRecno)
	
	RecLock("SE1",.F.)
	SE1->E1_ENVIADO := "S"     
	SE1->E1_DTSIG	:= dDataBase
	SE1->E1_ENVINI  := MV_PAR03
	SE1->E1_ENVFIM 	:= MV_PAR04
	SE1->(MsUnLock())
	
elseif _cTabela == "E5"
	DbSelectArea("SE5")
	DbGoTo(_xRecno)
	
	RecLock("SE5",.F.)
	SE5->E5_ENVIADO := "S"   
	SE5->E5_DTSIG	:= dDataBase
	SE5->E5_ENVINI  := MV_PAR03
	SE5->E5_ENVFIM 	:= MV_PAR04
	SE5->(MsUnLock())
endif

RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณValidPerg บ Autor ณ Klaus S. Peres     บ Data ณ  02/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Funcao de Validacao das Perguntes.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidPerg(cPerg)
Local _aArea := GetArea()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Filial De          ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate         ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data De            ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Datar Arquivos     ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Local arquivos     ?","","","mv_ch6","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else										// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFLAGTAB   บAutor  ณCristiano D. Alves  บ Data ณ  07/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpar flag das tabelas para novo envio.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FLAGTAB()

Local _cUpd 	:= ""


//Atualizando Contas a receber
_cUpd := " UPDATE "+RetSqlName("SE1")
_cUpd += " SET"
_cUpd += " E1_ENVIADO = ' '"
_cUpd += " WHERE D_E_L_E_T_ = ' '"
_cUpd += " AND E1_ENVIADO = 'S'"
_cUpd += " AND E1_ENVINI = '"+ DtoS(MV_PAR03)+"'"
_cUpd += " AND E1_ENVFIM = '"+ DtoS(MV_PAR04)+"'"

If TcSqlExec(_cUpd) < 0
	MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE1!!!")
	Final()
EndIf


//Atualizando Contas a pagar
_cUpd := " UPDATE "+RetSqlName("SE2")
_cUpd += " SET"
_cUpd += " E2_ENVIADO = ' '"
_cUpd += " WHERE D_E_L_E_T_ = ' '"
_cUpd += " AND E2_ENVIADO = 'S'"
_cUpd += " AND E2_ENVINI = '"+ DtoS(MV_PAR03)+"'"
_cUpd += " AND E2_ENVFIM = '"+ DtoS(MV_PAR04)+"'"

If TcSqlExec(_cUpd) < 0
	MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE2!!!")
	Final()
EndIf

//Atualizando baixas
_cUpd := " UPDATE "+RetSqlName("SE5")
_cUpd += " SET"
_cUpd += " E5_ENVIADO = ' '"
_cUpd += " WHERE D_E_L_E_T_ = ' '"
_cUpd += " AND E5_ENVIADO = 'S'"
_cUpd += " AND E5_ENVINI = '"+ DtoS(MV_PAR03)+"'"
_cUpd += " AND E5_ENVFIM = '"+ DtoS(MV_PAR04)+"'"

If TcSqlExec(_cUpd) < 0
	MsgStop("Ocorreu um erro na atualiza็ใo na tabela SE5!!!")
	Final()
EndIf

Return 
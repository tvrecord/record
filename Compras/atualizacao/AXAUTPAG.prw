#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#include "font.ch"
#INCLUDE "protheus.CH"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

User Function AXAUTPAG

	Local 	cFiltro	  	:= ""
	Private cCadastro 	:= "Cadastro de Autorizacao Pagamento"
	Private lOk1 		:= .T.
	Private nOpca 		:= 0
	Private aButtons 	:= {}
	Private aParam 		:= {}
	Private cPerg		:= "AXAUTPAG3"
	/*
	aAdd( aParam,  {|| U_ZSBefore() } )  //antes da abertura
	aAdd( aParam,  {|| U_ZSTudoOK() } )  //ao clicar no botao ok
	aAdd( aParam,  {|| U_ZSTransaction() } )  //durante a transacao
	aAdd( aParam,  {|| U_ZSFim() } )       //termino da transacao
	*/

	Private aCores := {{'ZS_LIBERAD == "B"' ,'BR_VERMELHO'},{'ZS_LIBERAD == "L"','BR_VERDE'},{'ZS_LIBERAD == "P"','BR_AMARELO'}}
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","AxVisual",0,2} ,;
		{"Incluir","U_Inclusao2",0,3} ,;
		{"Alterar","U_Alteracao2",0,4}    ,;
		{"Excluir","U_Exclusao2",0,5} ,;
		{"Impressao","u_RelAutPag()",0,2},;
		{"Cach๊","u_TelaZAD()",0,2},;
		{"Legenda","u_LegeSZS()",0,4}}

	//{"Libera็ใo","u_TelaSZS()",0,2},;
	Private cString := "SZS"

	ValPergAUT()

	Pergunte(cPerg,.T.)

	IF MV_PAR01 == 2
		cFiltro	  	:= "ZS_LIBERAD = 'P'"
	ELSEIF MV_PAR01 == 3
		cFiltro	  	:= "ZS_LIBERAD = 'B'"
	ELSEIF MV_PAR01 == 4
		cFiltro	  	:= "ZS_LIBERAD = 'L'"
	ENDIF


	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,aCores,,,,,,,,cFiltro)

Return

User Function Inclusao2()

	nOpca := 0

	dbSelectArea("SZS")
	//AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
	nOpca := AxInclui("SZS",SZS->(Recno()), 3,, "U_ZSBefore",, "U_ZSTudoOk()", .F., "U_IncluiTrans", aButtons,,,,.T.,,,,,)
Return nOpca


User function ZSBefore()
Return .T.

User function ZSTudoOK()

	lOk1 := .T.


	If M->ZS_TIPO != "21" .AND. EMPTY(M->ZS_NFISCAL)
		lOk1 := .F.
		MsgInfo("Favor, informar o n๚mero da Nota Fiscal.","Verifique")

	EndIf

Return lOk1

//chamada no momento da transa็ใo da inclusใo
User function IncluiTrans()

	//Inclui controle de al็ada
	u_AprovSZS()

Return(.T.)

//chamada no momento da transa็ใo da altera็ใo
User function AlterTrans()

	If !AllTrim(cUserName) $ "Administrador"

		//Deleta controle de al็ada
		u_DelSZS()
		//Inclui controle de al็ada
		u_AprovSZS()

	EndIf

Return(.T.)


User function ZSTransaction()
Return .T.

User function ZSFim()
Return .T.



User Function Alteracao2

	nOpca := 0


	IF(SUBSTR(EMBARALHA(SZS->ZS_USERLGI,1),3,6) == __cUserID) .AND. SZS->ZS_LIBERAD != "L" .OR. AllTrim(cUserName) $ "Administrador"
	dbSelectArea("SZS")
	nOpca := AxAltera("SZS",SZS->(Recno()), 4,,,,,"U_ZSTudoOk()","U_AlterTrans","U_ZSBefore",aButtons,,,.T.,,,,,)
Return nOpca
//	ELSE
//AxAltera("SZS",SZS->(Recno()), 4,,,,,"U_ZSTudoOk()","U_ZSTransactionZS","U_ZSBefore",aButtons,,,.T.,,,,,)
ELSEIF (SUBSTR(EMBARALHA(SZS->ZS_USERLGI,1),3,6) != __cUserID) .OR. SZS->ZS_LIBERAD == "L"
	MsgInfo("Pode alterar somente autoriza็ใo de pagamento inclusa pelo seu usuario e que nใo esta liberada!","Atencao!")
	Return
ELSEIF (SUBSTR(EMBARALHA(SZS->ZS_USERLGI,1),3,6) == __cUserID) .AND. SZS->ZS_LIBERAD == "L"
	MsgInfo("Pedido liberado nใo pode ser alterado!","Atencao!")
	Return
	ENDIF

	Return

	User Function Exclusao2

		IF(SUBSTR(EMBARALHA(SZS->ZS_USERLGI,1),3,6) == __cUserID)
		AxDeleta("SZS",SZS->(Recno()),5,"u_DelSZS",,,,,".t.")
	Else
		MsgInfo("Pode excluir somente autoriza็ใo de pagamento inclusa pelo seu usuario","Atencao!")
		EndIf

	Return

	//Exclui controle de al็ada
	User Function DelSZS()

		MaAlcDoc({SZS->ZS_CODIGO,"A1",SZS->ZS_VALOR,,,,,1,1,},SZS->ZS_EMISSAO,3)

	Return

	// Inclui Controle de al็ada
	User Function AprovSZS()

		MaAlcDoc({SZS->ZS_CODIGO,"A1",SZS->ZS_VALOR,,,Alltrim(GETMV("RR_APRSZS")),,1,1,SZS->ZS_EMISSAO},,1)

	Return

	User Function LegeSZS

		Local aLegenda := {{"ENABLE","Liberado"},{"BR_AMARELO","Pendente"},{"DISABLE","Bloqueado"}}

		BrwLegenda("Cadastro de Autoriza็ใo de Pagamento","Legenda",aLegenda)

	Return(.t.)

	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPENDENCIA บAutor  ณBruno Alves         บ Data ณ  09/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de controle de pendencias da record              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/



	User Function RelAutPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Declaracao de Variaveis                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Local aOrd         := {}
		Local aPergs       := {}
		Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
		Local cDesc2       := "de acordo com os parametros informados pelo usuario."
		Local cDesc3       := "Lista de Pendencias"
		Local cPict        := ""
		Local titulo       := "Autorizacao de Pagamento"
		Local Cabec1       := " "
		Local Cabec2       := " "
		Local imprime      := .T.

		Private cbtxt      := Space(10)
		Private cbcont     := 00
		Private CONTFL     := 01
		Private m_pag      := 01
		Private wnrel      := "RelAutPag" // Coloque aqui o nome do arquivo usado para impressao em disco
		PRIVATE nLin       := 80
		Private lEnd       := .F.
		Private lAbortPrint:= .F.
		Private limite     := 220
		Private Tamanho    := "G"
		Private nomeprog   := "RelAutPag"
		Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
		Private nLastKey   := 0
		Private cString    := "SZS"
		Private cPerg      := "AUTPAG1"
		Private cQuery	   := ""
		Private nTipo      := 15



		ValidPerg(cPerg)

		If !Pergunte(cPerg,.T.)
			alert("OPERAวรO CANCELADA")
			return
		ENDIF



		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta a interface padrao com o usuario...                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

		//Imprimir relatorio com dados Financeiros ou de Clientes

		cQuery := "SELECT * FROM SZS010 WHERE "
		cQuery += "ZS_CODIGO BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
		cQuery += "D_E_L_E_T_ <> '*' "

		tcQuery cQuery New Alias "PEND"

		If Eof()
			MsgInfo("Nao existem dados a serem impressos!","Verifique")
			dbSelectArea("PEND")
			dbCloseArea("PEND")
			Return
		Endif

		If nLastKey == 27
			dbSelectArea("PEND")
			dbCloseArea("PEND")
			Return
		Endif



		SetDefault(aReturn,cString)

		If nLastKey == 27
			DBSelectARea("PEND")
			DBCloseArea("PEND")
			Return
		Endif



		nTipo := If(aReturn[4]==1,15,18)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)




	Return

	/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  12/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	/*/

	Static Function RunReport(Cabec1,Cabec2,Titulo)

		Local nOrdem,nRegAtual
		Local cSitAprov,cAprov,cDeptAprov
		Local aUsuario := {}

		Private  nPag  			:= 1
		Private cLogoTotvs		:= "\IMAGES\RECORD.BMP"
		Private pOrcado 		:= 0
		Private aItensImp		:= {}
		Private cStatus			:= ""
		Private cNecess			:= ""

		//Parโmetros de TFont.New()
		//1.Nome da Fonte (Windows)
		//3.Tamanho em Pixels
		//5.Bold (T/F)

		Private oFont7  := TFont():New("Arial",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
		Private oFont7n := TFont():New("Arial",9, 9,.T.,.T.,5,.T.,5,.T.,.F.) // Negrito
		Private oFont7p := TFont():New("Arial",9, 5,.T.,.F.,5,.T.,5,.T.,.F.)
		Private oFont8  := TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
		Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
		Private oFont08n:= TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
		Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
		Private oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
		Private oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		SetRegua(RecCount())

		DBSelectArea("PEND")
		DBGotop()


		While !EOF()

			cSitAprov 	:= ""
			cAprov	  	:= ""
			cDeptAprov	:= ""
			aUsuario    := {}

			//Localizo o aprovador para impressใo caso tenha feito a aprova็ใo pelo controle de al็ada que foi configurada no dia 21/01/2021
			DbSelectArea("SCR");DbSetOrder(1)
			If DbSeek(SZS->ZS_FILIAL + "A1" + SZS->ZS_CODIGO)


				If PswSeek( SCR->CR_USER, .T. )
					aUsuario := PswRet() // Retorna vetor com informa็๕es do usuแrio
					cDeptAprov := Alltrim(aUsuario[1][13])
				EndIf

				cAprov := Alltrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"AK_NOME"))

			EndIf

			//Verifico se foi aprovado ou nใo
			If PEND->ZS_LIBERAD == "B"
				cSitAprov := "Rejei็ใo Eletr๔nica - " + DTOC(STOD(PEND->ZS_DTLIB))
			ElseIf PEND->ZS_LIBERAD == "L"
				cSitAprov := "Aprova็ใo Eletr๔nica - " + DTOC(STOD(PEND->ZS_DTLIB))
			Else
				cSitAprov := ""//"Aguardando Aprova็ใo" 24/02/2020 - Rafael Fran็a - Removida a mensagem de aguardando aprova็ใo
			EndIf

			//Devido o legado da aprova็ใo eletronica no controle de al็ada na tabela SCR foi necessแrio fazer essa tratativa

			If Empty(cAprov)
				cAprov 	   := PEND->ZS_AUTO01
				cDeptAprov := PEND->ZS_DEP01
			EndIf



			aAdd(aItensImp,{PEND->ZS_CODIGO,;  		// 1 - Codigo
				PEND->ZS_FORNECE,;	// 2 - Codigo do Fornecedor
				PEND->ZS_LOJA,;	// 3 - Loja do Fornecedor
				PEND->ZS_NOME,;   	// 4 - Nome do Fornecedor
				PEND->ZS_CGC,;	// 5 - CNPJ do Fornecedor
				ALLTRIM(PEND->ZS_NATUREZ) + " - " + PEND->ZS_NMNAT,;   	// 6 - Codigo + Nome da Natureza
				PEND->ZS_EMISSAO,;	// 7 - Data da Emissao do documento
				PEND->ZS_VENC,; 	// 8 - Data do Vencimento do documento
				PEND->ZS_VALOR,; // 9 - Valor
				PEND->ZS_NMDEP,;	// 10 - Nome do Departamento solicitante
				PEND->ZS_RATEIO,;	// 11 - Usa Rateio
				PEND->ZS_DESCTP,;   	// 12 - Tipo do Documento
				PEND->ZS_CCDESC,;	// 13 - Descri็ใo do Centro de Custo
				PEND->ZS_DATA,;   	// 14 - Data do lan็amento do documento
				PEND->ZS_PESSOA,;	// 15 - Data da Emissao do documento
				PEND->ZS_SOLICIT,; 	// 16 - Solicitante
				PEND->ZS_DEPSOLI,; // 17 - Departamento do Solicitante
				cAprov,; 	// 18 - Nome do 1บ Aprovador
				cDeptAprov,; // 19 - Departamento do 1บ Aprovador
				PEND->ZS_AUTO02,; 	// 20 - Nome do 2บ Aprovador
				PEND->ZS_DEP02,; // 21 - Departamento do 2บ Aprovador
				PEND->ZS_NFISCAL,; //22
				PEND->ZS_AUTO03,; 	// 23 - Nome do 2บ Aprovador
				PEND->ZS_DEP03,; // 24 - Departamento do 2บ Aprovador
				PEND->ZS_AUTO04,; 	// 25 - Nome do 2บ Aprovador
				PEND->ZS_DEP04,;// 26 - Departamento do 2บ Aprovador
				PEND->ZS_CC,; //27 - Descri็ใo Centro de Custos
				PEND->ZS_AUTO05,; 	// 28 - Nome do 5บ Aprovador
				PEND->ZS_DEP05,; // 29 - Departamento do 5บ Aprovador
				PEND->ZS_AUTO06,; 	// 30 - Nome do 6บ Aprovador
				PEND->ZS_DEP06,; // 31 - Departamento do 6บ Aprovador})
				cSitAprov})  // 32 - Assinatura Digital do aprovador principal



			DBSelectARea("PEND")
			DBSkip()

			IncRegua()

		ENDDO


		oPrint:= TMSPrinter():New( "Autoriza็ใo de Pagamento - RECORD" )
		oPrint:SetSize(210,297)
		oPrint:SetPortrait()//SetLandscape() // ou SetPortrait()

		MontaBox(aItensImp)

		oPrint:EndPage()     // Finaliza a pagina

		oPrint:Preview()     // Visualiza antes de imprimir

		MS_FLUSH()

		DBSelectARea("PEND")
		DBCloseArea("PEND")

	Return

	Static Function MontaBox(aItens)
		Local cMemoDesc
		Local nMemoDesc
		Local _aTxTDesc
		Local cMemoObs
		Local nMemoObs
		Local _aTxTObs
		Local _nLimDesc := 110
		Local _nLimObs  := 110
		Local nLastLnDesc := 0
		Local nLastLnObs  := 0

		//MontaPagina(aItens)

		//oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
		//oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)

		nLin := 50

		For i:=1 to Len(aItens)

			//	If nLin > 1750
			oPrint:EndPage()
			MontaPagina(aItens)

			//		oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
			//		oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)

			nLin := 50
			//	Endif



			dbSelectArea("SZS")
			dbSetOrder(1)
			dbSeek(xFilial("SZS") + aItens[i][1])

			cMemoDesc := alltrim(SZS->ZS_HISTORI)
			nMemoDesc := MlCount( cMemoDesc ,_nLimDesc )
			_aTxTDesc := memoFormata( cMemoDesc, _nLimDesc, nMemoDesc )

			cMemoObs := alltrim(SZS->ZS_JUST)
			nMemoObs := MlCount( cMemoObs, _nLimObs )
			_aTxTObs := memoFormata( cMemoObs, _nLimObs, nMemoObs )


			oPrint:Say (0214 ,1900,		aItens[i][01]					,oFont12)
			oPrint:Say (0424 ,0300,		aItens[i][02] + "-" + aItens[i][03],oFont7)
			//	oPrint:Say (0424 ,0450,		aItens[i][03]					,oFont7)
			oPrint:Say (0424 ,1200,		UPPER(aItens[i][04])			,oFont7)
			oPrint:Say (0494 ,0270,		IIF(Alltrim(aItens[i][15]) == "F",Transform(aItens[i][05],"@R 999.999.999-99"),Transform(aItens[i][05],"@R 99.999.999/9999-99"))					,oFont7)
			oPrint:Say (0494 ,1170,		UPPER(aItens[i][06])			,oFont7)
			oPrint:Say (0564 ,0330,		DtoC(StoD(aItens[i][07]))		,oFont7)
			oPrint:Say (0564 ,1210,		DtoC(StoD(aItens[i][08]))		,oFont7)
			oPrint:Say (0564 ,1900,		Transform(aItens[i][09],"@E 99,999,999.99")	,oFont7)
			oPrint:Say (0634 ,0400,		aItens[i][10]					,oFont7)
			oPrint:Say (0634 ,1715,		IIF(aItens[i][11] == "1","X","")								,oFont7)
			oPrint:Say (0634 ,1915,		IIF(aItens[i][11] == "2","X","")								,oFont7)
			oPrint:Say (0704 ,0220,		UPPER(aItens[i][12])			,oFont7)
			oPrint:Say (0704 ,1800,		aItens[i][22]					,oFont7)
			oPrint:Say (0774 ,0450,		aItens[i][27]  + " - " +  UPPER(aItens[i][13])			,oFont7)
			oPrint:Say (1804 ,0450,		DtoC(StoD(aItens[i][14])) 		,oFont7)
			oPrint:Say (2234 ,0060,		aItens[i][16]					,oFont7)
			oPrint:Say (2304 ,0060,		aItens[i][17]					,oFont7)
			oPrint:Say (2134 ,0850,		PADC(aItens[i][32],50)			,oFont7n)
			oPrint:Say (2234 ,0850,		aItens[i][18]					,oFont7)
			oPrint:Say (2304 ,0850,		aItens[i][19]					,oFont7)
			oPrint:Say (2234 ,1650,		aItens[i][20]					,oFont7)
			oPrint:Say (2304 ,1650,		aItens[i][21]					,oFont7)

			If !EMPTY(aItens[i][23]) .AND. !EMPTY(aItens[i][24])
				oPrint:Say (2714 ,0060,		aItens[i][23]					,oFont7)
				oPrint:Say (2784 ,0060,		aItens[i][24]					,oFont7)
			Endif

			If  !EMPTY(aItens[i][23]) .AND. !EMPTY(aItens[i][24]) .AND. !EMPTY(aItens[i][25]) .AND. !EMPTY(aItens[i][26])
				oPrint:Say (2714 ,0850,		aItens[i][25]					,oFont7)
				oPrint:Say (2784 ,0850,		aItens[i][26]					,oFont7)
			EndIf

			If  !EMPTY(aItens[i][23]) .AND. !EMPTY(aItens[i][24]) .AND. !EMPTY(aItens[i][25]) .AND. !EMPTY(aItens[i][26]) .AND. !EMPTY(aItens[i][28]) .AND. !EMPTY(aItens[i][29])
				oPrint:Say (2714 ,1650,		aItens[i][28]					,oFont7)
				oPrint:Say (2784 ,1650,		aItens[i][29]					,oFont7)
			EndIf

			If  !EMPTY(aItens[i][23]) .AND. !EMPTY(aItens[i][24]) .AND. !EMPTY(aItens[i][25]) .AND. !EMPTY(aItens[i][26]) .AND. !EMPTY(aItens[i][28]) .AND. !EMPTY(aItens[i][29]) .AND. !EMPTY(aItens[i][30]) .AND. !EMPTY(aItens[i][31])
				oPrint:Say (3194 ,0060,		aItens[i][30]					,oFont7)
				oPrint:Say (3264 ,0060,		aItens[i][31]					,oFont7)
			EndIf


			nLin := 0
			For D:=1 to Len(_aTxTDesc)
				oPrint:Say(0925 + nLin,0080,Trim(UPPER(_aTxtDesc[D])),oFont7,9000,,,4,4)
				nLin += 60
			Next

			nLin := 0
			For O:=1 to Len(_aTxtObs)
				oPrint:Say(1485 + nLin,0080,Trim(UPPER(_aTxtObs[O])),oFont7,9000,,,4,4)
				nLin += 60
			Next




			//	oPrint:Line(0420 + nLin,075,0420 + nLin,3285) VERIFICAR

		Next

	Return

	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIT006    บAutor  ณMicrosiga           บ Data ณ  05/29/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

	Static Function memoFormata ( cMemo, _nLimite, nMemCount )

		_nLenCar    := 0
		_nPosSpace  := 0
		_aTxt  := {}

		If !Empty( nMemCount )
			For nLoop := 1 To nMemCount
				cLinha := MemoLine( cMemo, _nLimite, nLoop )
				_nLenCar := Iif(Len(AllTrim(cLinha))<_nLimite-20,21,1)
				While ( Len(Trim(cLinha)) <> _nLimite )
					_nPosSpace := At(' ',SubStr(cLinha,_nLenCar,Len(cLinha)))
					If ( _nPosSpace == 0 )
						Exit
					EndIf
					_nLenCar	+= _nPosSpace
					cLinha	:= SubStr(cLinha,1,_nLenCar-1)+" "+SubStr(cLinha,_nLenCar,Len(cLinha))
					_nLenCar++ // Proxima palavra.
				End
				aAdd(_aTxt,cLinha)

			Next nLoop
		EndIf

	Return ( _aTxt )

	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMIT006    บAutor  ณMicrosiga           บ Data ณ  05/29/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/


	Static Function MontaPagina(aIteq)
		Local aCoord := {0820,040,0900,2250}
		Local aCoord1:= {1370,040,1450,2250}
		Local aCoord2:= {1870,040,1940,1600}
		Local aCoord3:= {}
		Local aCoord4:= {}
		Local aCoord5:= {}
		Local aCoord6:= {}

		If !EMPTY(aIteq[i][20]) .AND. !EMPTY(aIteq[i][21])
			aCoord5:= {1870,1600,1940,2250}
		EndIf

		If !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24])
			aCoord3:= {2350,0040,2420,0800}
		EndIf

		IF !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26])
			aCoord4:= {2350,0800,2420,1600}
		EndIf

		IF !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29])
			aCoord4:= {2350,0800,2420,2250}
		EndIf

		IF !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29]) .AND. !EMPTY(aIteq[i][30]) .AND. !EMPTY(aIteq[i][31])
			aCoord6:= {2830,0040,2900,0800}
		EndIf

		oBrush := TBrush():New(,CLR_HGRAY)

		oPrint:FillRect(aCoord ,oBrush)
		oPrint:FillRect(aCoord1,oBrush)
		oPrint:FillRect(aCoord2,oBrush)
		oPrint:FillRect(aCoord3,oBrush)
		oPrint:FillRect(aCoord4,oBrush)
		oPrint:FillRect(aCoord5,oBrush)
		oPrint:FillRect(aCoord6,oBrush)
		oPrint:StartPage()   // Inicia uma nova pแgina

		//IMAGENS

		//               linI colI            larg alt
		oPrint:SayBitmap(0080,150,cLogoTotvs,0250,200)//imagem da totvs
		//oPrint:SayBitmap(0100,400,cLogoTriade,0340,185)//imagem da triade
		//oPrint:SayBitmap(0100,2700,cLogoCliente,0340,200)//imagem do cliente

		//COLUNAS DA CABECALHO

		oPrint:Line(0040,0500,0300,0500) //1 Coluna
		oPrint:Line(0040,1750,0300,1750) //2 Coluna
		oPrint:Line(0175,0500,0175,2250) //Linha do Meio

		//LINHAS DA PLANILHA

		oPrint:Line(0300,040,0300,2250) //LINHA ABAIXO DAS IMAGENS
		oPrint:Line(0400,040,0400,2250) //1 LINHA
		oPrint:Line(0470,040,0470,2250) //2 LINHA
		oPrint:Line(0540,040,0540,2250) //3 LINHA
		oPrint:Line(0610,040,0610,2250) //4 LINHA
		oPrint:Line(0680,040,0680,2250) //5 LINHA
		oPrint:Line(0750,040,0750,2250) //6 LINHA
		oPrint:Line(0820,040,0820,2250) //7 LINHA
		oPrint:Line(0900,040,0900,2250) //8 LINHA
		oPrint:Line(1370,040,1370,2250) //9 LINHA
		oPrint:Line(1450,040,1450,2250) //10 LINHA
		oPrint:Line(1780,040,1780,2250) //13 LINHA
		oPrint:Line(1870,040,1870,2250) //14 LINHA
		oPrint:Line(1940,040,1940,1600) //15 LINHA

		//COLUNAS E LINHAS DA RODAPE

		oPrint:Line(1870,0800,2350,0800) //1 Coluna
		oPrint:Line(1870,1600,2350,1600) //2 Coluna
		oPrint:Line(2210,0040,2210,1600) //1 LINHA
		oPrint:Line(2280,0040,2280,1600) //2 LINHA

		oPrint:Line (0040,0040,2350,0040) //Coluna da esquerda
		oPrint:Line (0040,2250,1870,2250) //Coluna da direita
		oPrint:Line (0040,0040,0040,2250) //Linha de cima
		oPrint:line (2350,0040,2350,1600) //Linha de baixo

		//IMPLEMENTAวรO DE LINHAS E COLUNAS MOVEIS DEVIDO QUANTIDADE DE ASSINATURAS

		IF !EMPTY(aIteq[i][20]) .AND. !EMPTY(aIteq[i][21])
			// 1 Aprovador Fixo
			oPrint:Line(1940,1600,1940,2250) //13 LINHA
			oPrint:Line(2210,1600,2210,2250) //14 LINHA
			oPrint:Line(2280,1600,2280,2250) //14 LINHA
			oPrint:Line(2350,1600,2350,2250) //14 LINHA
			oPrint:Line(1870,2250,2350,2250) //1 Coluna
		EndIf

		IF !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24])
			// 1 Aprovador Movel
			oPrint:Line(2420,0040,2420,0800) //13 LINHA
			oPrint:Line(2690,0040,2690,0800) //13 LINHA
			oPrint:Line(2760,0040,2760,0800) //14 LINHA
			oPrint:Line(2830,0040,2830,0800) //14 LINHA
			oPrint:Line(2350,0800,2830,0800) //1 Coluna
			oPrint:Line(2350,0040,2830,0040) //1 Coluna

		EndIf

		If  !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26])
			// 2 Aprovador Movel
			oPrint:Line(2420,0040,2420,1600) //13 LINHA
			oPrint:Line(2690,0040,2690,1600) //13 LINHA
			oPrint:Line(2760,0040,2760,1600) //14 LINHA
			oPrint:Line(2830,0040,2830,1600) //14 LINHA
			oPrint:Line(2350,1600,2830,1600) //2 Coluna

		ENDIF

		If  !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29])
			// 3 Aprovador Movel
			oPrint:Line(2420,0040,2420,2250) //13 LINHA
			oPrint:Line(2690,0040,2690,2250) //13 LINHA
			oPrint:Line(2760,0040,2760,2250) //14 LINHA
			oPrint:Line(2830,0040,2830,2250) //14 LINHA
			oPrint:Line(2350,2250,2830,2250) //2 Coluna

		ENDIF

		If  !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29]) .AND. !EMPTY(aIteq[i][30]) .AND. !EMPTY(aIteq[i][31])
			// 4 Aprovador Movel
			oPrint:Line(2900,0040,2900,0800) //13 LINHA
			oPrint:Line(3170,0040,3170,0800) //13 LINHA
			oPrint:Line(3240,0040,3240,0800) //14 LINHA
			oPrint:Line(3310,0040,3310,0800) //14 LINHA
			oPrint:Line(2830,0040,3310,0040) //1 Coluna
			oPrint:Line(2830,0800,3310,0800) //2 Coluna

		ENDIF


		/*
_____________________________________________________
DADOS DO RELATORIO
_____________________________________________________
		*/

		oPrint:Say (080,0660,"AUTORIZAวรO DE PAGAMENTO",oFont16n)
		oPrint:Say (200,0620,"RมDIO E TELEVISรO CAPITAL LTDA"	,oFont16n)
		oPrint:Say (080,1800,"Nบ AUTORIZAวรO"	,oFont12)
		oPrint:Say (0420,0060,"C๓digo:"						,oFont12)
		oPrint:Say (0420,0900,"Fornecedor:"						,oFont12)
		oPrint:Say (0490,0060,"CNPJ:"						,oFont12)
		oPrint:Say (0490,0900,"Natureza:"						,oFont12)
		oPrint:Say (0560,0060,"Emissใo:"						,oFont12)
		oPrint:Say (0560,0900,"Vencimento:"						,oFont12)
		oPrint:Say (0560,1700,"Valor:"						,oFont12)
		oPrint:Say (0630,0060,"Departamento:"						,oFont12)
		oPrint:Say (0630,1350,"Centro de Custo:" ,oFont12)
		oPrint:Say (0630,1700,"(  ) Rateio ", oFont12)
		oPrint:Say (0630,1900,"(  ) Normal", oFont12)
		oPrint:Say (0700,0060,"Tipo:"						,oFont12)
		oPrint:Say (0700,1350,"Nบ Documento / NF:"						,oFont12)
		oPrint:Say (0770,0060,"Centro de Custo:"						,oFont12)
		oPrint:Say (0850,1050,"Historico"						,oFont12)
		oPrint:Say (1400,0930,"Justificativa (Se houver)"					,oFont12)
		oPrint:Say (1800,0060,"Data da Inclusใo:"						,oFont12)
		oPrint:Say (1890,0270,"Solicitado por"						,oFont12)
		//oPrint:Say (2100,1130,"FษRIAS"		         				,oFont12)//TEMPORARIO - FERIAS ELENN - ALTERADO LINHA 2200 PARA 2100
		oPrint:Say (1890,1025,"Autorizado por"						,oFont12)

		If !EMPTY(aIteq[i][20]) .AND. !EMPTY(aIteq[i][21])
			oPrint:Say (1890,1750,"Autorizado por"						,oFont12)
		EndIf

		If !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24])
			oPrint:Say (2370,0270,"Autorizado por"						,oFont12)
		EndIf

		If !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26])
			oPrint:Say (2370,1025,"Autorizado por"						,oFont12)
		EndIf

		If !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29])
			oPrint:Say (2370,1750,"Autorizado por"						,oFont12)
		EndIf

		If !EMPTY(aIteq[i][23]) .AND. !EMPTY(aIteq[i][24]) .AND. !EMPTY(aIteq[i][25]) .AND. !EMPTY(aIteq[i][26]) .AND. !EMPTY(aIteq[i][28]) .AND. !EMPTY(aIteq[i][29]) .AND. !EMPTY(aIteq[i][30]) .AND. !EMPTY(aIteq[i][31])
			oPrint:Say (2850,0270,"Autorizado por"						,oFont12)
		EndIf

	Return

	Static Function ValidPerg(cPerg)



		_sAlias := Alias()
		cPerg := PADR(cPerg,10)
		dbSelectArea("SX1")
		dbSetOrder(1)
		aRegs:={}

		AADD(aRegs,{cPerg,"01","Do Codigo  ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZS"})
		AADD(aRegs,{cPerg,"02","Ate Codigo ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SZS"})



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

	User Function TelaSZS		//  Tela de libera็ใo do documento

		Local dDataLib 	:= DDATABASE //ddatabase
		Local lLibera 	:= .T.
		Local dData		:= SZS->ZS_DATA
		Local mHistori	:= SZS->ZS_HISTORI
		Local cNatureza	:= SZS->ZS_NATUREZ
		Local cNNat		:= SZS->ZS_NMNAT
		Local cAe		:= SZS->ZS_CODIGO
		Local cSolicit	:= SZS->ZS_SOLICIT
		Local cFornece	:= SZS->ZS_FORNECE
		Local cNomeFor	:= SZS->ZS_NOME
		Local cDepart	:= SUBSTR(SZS->ZS_NMDEP,1,20)
		Local nVlAP		:= SZS->ZS_VALOR
		Local lOk		:= .F.
		Local cQuery	:= ""
		local nTotal 	:= 0
		Local nValor	:= 0
		Local cMes 		:= SUBSTR(DTOS(DDATABASE),1,6) //Mes e Ano
		Local nSaldo 	:= 0
		Local nLimite 	:= 0
		Local nSaldoA	:= 0
		Local cObs		:= SPACE(30)

		//If AllTrim(Substring(cUsuario,7,15)) $ "Administrador%Eleni Caldeira (Elenn)%Claudinei Girotti%Josiel Ferreira%Wagner Lima da Silva%Pasquale Zupi(Pasquale))"

		IF SZS->ZS_LIBERAD == "L"
			lOk		:= .F.
		ELSE
			lOk		:= .T.
		ENDIF

		cQuery := "SELECT C1_NATUREZ AS NATUREZA, SUM(C7_TOTAL + C7_VALFRE + C7_DESPESA - C7_VLDESC + C7_VALIPI) AS VALOR FROM SC7010 "
		cQuery += "INNER JOIN SC1010 ON "
		cQuery += "C1_NUM = C7_NUMSC AND "
		cQuery += "C1_PEDIDO = C7_NUM AND "
		cQuery += "C7_ITEMSC = C1_ITEM "
		cQuery += "INNER JOIN SCR010 ON "
		cQuery += "CR_NUM = C7_NUM AND "
		cQuery += "CR_FILIAL = C7_FILIAL "
		cQuery += "WHERE "
		cQuery += "C7_TIPO = 1 AND "
		cQuery += "C7_RESIDUO <> 'S' AND "
		cQuery += "C1_NATUREZ =  '" + (cNatureza) + "'    AND "
		cQuery += "CR_USER IN ('000192','000157') AND "
		cQuery += "CR_STATUS = '03' AND "
		cQuery += "C7_EMISSAO >= '20130726' AND "
		cQuery += "CR_DATALIB BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' AND "
		cQuery += "SCR010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC1010.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY C1_NATUREZ "
		cQuery += "UNION "
		cQuery += "SELECT C3_NATUREZ AS NATUREZA,SUM(C7_TOTAL + C7_VALFRE + C7_DESPESA - C7_VLDESC + C7_VALIPI) AS VALOR FROM SC7010 "    // Busca Autoriza็ใo de Contratos
		cQuery += "INNER JOIN SC3010 ON "
		cQuery += "C7_NUMSC = C3_NUM AND "
		cQuery += "C7_ITEMSC = C3_ITEM "
		cQuery += "INNER JOIN SCR010 ON "
		cQuery += "CR_NUM = C7_NUM AND "
		cQuery += "CR_FILIAL = C7_FILIAL "
		cQuery += "WHERE "
		cQuery += "C7_TIPO = 2 AND "
		cQuery += "C7_RESIDUO <> 'S' AND "
		cQuery += "C3_NATUREZ =  '" + (cNatureza) + "'    AND "
		cQuery += "CR_USER IN ('000192','000157') AND "
		cQuery += "CR_STATUS = '03' AND "
		cQuery += "C7_EMISSAO >= '20130726' AND "
		cQuery += "CR_DATALIB BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' AND "
		cQuery += "SCR010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
		cQuery += "SC3010.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY C3_NATUREZ "
		cQuery += "UNION "
		cQuery += "SELECT ZS_NATUREZ AS NATUREZA,SUM(ZS_VALOR) AS VALOR FROM SZS010 WHERE " // Busca Autoriza็ใo de Pagamentos
		cQuery += "D_E_L_E_T_ <> '*' AND "
		cQuery += "ZS_LIBERAD = 'L' AND "
		cQuery += "ZS_CONTRAT <> '1' AND "
		cQuery += "ZS_TIPO <> '21' AND "
		cQuery += "ZS_NATUREZ = '" + (cNatureza) + "' AND "
		cQuery += "ZS_EMISSAO BETWEEN '" + (cMes + "01") + "' AND '" + (cMes + "31") + "' "
		cQuery += "GROUP BY ZS_NATUREZ "
		cQuery += "ORDER BY NATUREZA "

		tcQuery cQuery New Alias "TMP"

		DBSelectArea("TMP")

		While !EOF()

			nTotal += TMP->VALOR

			DbSkip()

		EndDo

		DBSelectArea("TMP")
		DBCloseArea("TMP")

		nLimite := Posicione("SED",1,xFilial("SED")+cNatureza, @"ED_MES" + SUBSTR(CMES,5,2))

		nSaldo	:= nLimite - nTotal
		IF lOk
			nSaldoA	:= nLimite - nTotal - nVlAP
		ELSE
			nSaldoA	:= nLimite - nTotal
		ENDIF

		@ 000,000 TO 395,500 DIALOG oDlg TITLE "Libera็ใo de Autoriza็ใo de Pagamento"
		@ 001,001 SAY UPPER("Autoriza็ใo de Pagamento Nบ :  " + cAe)
		@ 001,022 SAY UPPER("Data :  " + DTOC(dData))
		@ 002,001 SAY UPPER("Solicitante :  " + cSolicit)
		@ 003,001 SAY UPPER("Departamento :  " + cDepart)
		@ 003,022 SAY UPPER("Valor :  " + Alltrim(Transform(nVlAP,"@e 999,999,999.99")))
		@ 004,001 SAY UPPER("Fornecedor :  " + ALLTRIM(cFornece) + " - " + cNomeFor)
		@ 005,001 GET mHistori MEMO SIZE 228,035 when .F.
		@ 008,001 SAY UPPER("Natureza :  " + ALLTRIM(cNatureza) + " - " + cNNat)
		@ 009,001 SAY UPPER("Limite :  " + Alltrim(Transform(nLimite,"@e 999,999,999.99"))) 		//PICTURE "@E 999,999,999.99"
		@ 010,001 SAY UPPER("Valor Utilizado :  " + Alltrim(Transform(nTotal,"@e 999,999,999.99"))) //PICTURE "@E 999,999,999.99"
		@ 011,001 SAY UPPER("Saldo atual :  " + Alltrim(Transform(nSaldo,"@e 999,999,999.99")))
		@ 012,001 SAY UPPER("Saldo ap๓s aprova็ใo :  " + Alltrim(Transform(nSaldoa,"@e 999,999,999.99")))
		@ 013,001 SAY "OBSERVAวรO :"
		@ 013,007 GET cObs
		//@ 018,022 BUTTON "Pendente"	SIZE 35,10 ACTION PendenteSZS(dDataLib,cObs)
		@ 018,032 BUTTON "Liberar" 	SIZE 35,10 ACTION u_LiberaSZS(dDataLib,cObs,"2")
		@ 018,042 BUTTON "Bloquear" SIZE 35,10 ACTION BloqueiaSZS(dDataLib,cObs)
		@ 018,052 BUTTON "Fechar" 	SIZE 35,10 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
		/*
		ELSE

			MsgInfo("Somente gerente administrativa pode liberar o documento!","Aten็ใo")
			Return

		ENDIF
		*/

	Return

	//faz a libera็ใo do nivel
	User Function LiberaSZS(dDataLib,cObs,cTipo)

		Local aDados := Array(11) //Array com os dados da aprovador.

		DbSelectArea("SZS");DbSetOrder(1)
		If Dbseek(xFilial("SZS") + SCR->CR_NUM)

			//Sempre gravo a observa็ใo dos aprovadores
			RecLock("SZS",.F.)
			SZS->ZS_OBSLIB 	:= cObs
			MsUnLock()

		EndIf

		aDados[1] := SCR->CR_NUM
		aDados[2] := SCR->CR_TIPO
		aDados[3] := SCR->CR_TOTAL
		aDados[4] := SCR->CR_APROV
		aDados[5] := SCR->CR_USER
		aDados[6] := SCR->CR_GRUPO
		aDados[8] := 1 					//MOEDA
		aDados[9] := 1					//TAXA
		aDados[10]:= SCR->CR_EMISSAO
		aDados[11]:= cObs

		//Executa a rotina de aprova็ใo
		//Ponto de entrada MTALCDOC irแ atualizar as tabelas origens
		MaAlcDoc(aDados,date(),4)

		If cTipo != "1"
			Close(oDlg)
		EndIf

	Return

	Static Function BloqueiaSZS(dDataLib,cObs)

		Local aDados := Array(11) //Array com os dados da aprovador.

		aDados[1] := SCR->CR_NUM
		aDados[2] := SCR->CR_TIPO
		aDados[3] := SCR->CR_TOTAL
		aDados[4] := SCR->CR_APROV
		aDados[5] := SCR->CR_USER
		aDados[6] := SCR->CR_GRUPO
		aDados[8] := 1 					//MOEDA
		aDados[9] := 1					//TAXA
		aDados[10]:= SCR->CR_EMISSAO
		aDados[11]:= cObs

		//Executa a rotina de reprova็ใo
		//Ponto de entrada MTALCDOC que irใo atualizar as tabelas origens
		MaAlcDoc(aDados,date(),6)

		Close(oDlg)

	Return

	Static Function PendenteSZS(dDataLib,cObs)

		If Empty(dDataLib)
			MsgInfo("Informe a Data","VAZIO")
			Return
		Endif

		RecLock("SZS",.F.)
		SZS->ZS_DTLIB 	:= CTOD("  /  /  ")
		SZS->ZS_LIBERAD := "P"
		SZS->ZS_OBSLIB 	:= cObs
		MsUnLock()

		Close(oDlg)

	Return

	Static Function ValPergAUT()

		Local _sAlias := Alias()
		Local aRegs := {}
		Local i,j

		dbSelectArea("SX1")
		dbSetOrder(1)
		cPerg := PADR(cPerg,10)

		aAdd(aRegs,{cPerg,"01","Filtra Autoriza็๕es:","","","mv_ch1","N",01,00,1,"C","","mv_par01","Todas","","","","","Pendentes","","","","","Bloqueados","","","","","Liberados","","","","","","","","","" })

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
#Include "rwmake.ch"
#Include "protheus.ch"
#DEFINE ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPRP01NEWบAutor  ณCristiano D. Alves  บ Data ณ  22/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao do Arquivo TV+                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RECORD                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ BOPS ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณCristiano   ณ25/06/07ณ      ณ Incluida variavel _cNumPed (Num pedido)  ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Incluida a variavel _cProdFat (Prod. Ped)ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Efetuada troca no seek do vendedor na im-ณฑฑ
ฑฑณ            ณ        ณ      ณ porta็ใo dos pedidos. Foi colocado       ณฑฑ
ฑฑณ            ณ        ณ      ณ SZ1->Z1_CNPJAGE no lugar de SA1->A1_COD  ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Incluido os campos C5_FILIAL, C6_FILIAL eณฑฑ
ฑฑณ            ณ        ณ      ณ C6_ITEM na grava็ใo dos pedidos.         ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Atribuido o mesmo n๚mero de pedido para oณฑฑ
ฑฑณ            ณ        ณ      ณ cabe็alho e itens.                       ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Criada a fun็ใo ValidPerg()              ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Troca de SZ3_FILIAL por xFilial("SA3").  ณฑฑ
ฑฑณ            ณ25/06/07ณ      ณ Criado o parametro MV_TVMCOND e variavel ณฑฑ
ฑฑณ            ณ        ณ      ณ _cCond para que o usuario informe a cond.ณฑฑ
ฑฑณ            ณ        ณ      ณ de pagamento para os pedidos de venda.   ณฑฑ
ฑฑณ            ณ04/12/09ณ      ณ Por Klaus - Adicionada uma IncProc na    ณฑฑ
ฑฑณ            ณ        ณ      ณ geracao dos pedidos de venda.            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPRP01NEW()

	// Variaveis Locais da Funcao
	Local oPedido

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal

	// Variaveis que definem a Acao do Formulario
	Private VISUAL 		:= .F.
	Private INCLUI 		:= .F.
	Private ALTERA 		:= .F.
	Private DELETA 		:= .F.
	Private lCliente	:= .F.
	Private lPedido		:= .T.
	Private lVendedor	:= .F.
	Private cPerg 		:= "IMPRPN100 "

	ValidPerg()
	Pergunte(cPerg,.T.)

	//Motivo da Grava็ใo os parametros nas variaveis: Ap๓s execu็ใo do execauto os parametros sใo alterados para rotina do execauto

	_dDtIni		:= MV_PAR01 //Data inicial
	_dDtFim		:= MV_PAR02 //Data final
	_cCond 		:= MV_PAR03 //Condi็ใo de pagamento
	_cCondFix 	:= MV_PAR09 //Condi็ใo de pagamento
	_cNat		:= MV_PAR04 //Natureza financeira
	cNatureza 	:= ""
	_cProd		:= MV_PAR05 //Produto
	//178
	DEFINE MSDIALOG _oDlg TITLE "Importa็ใo TV+" FROM C(100),C(210) TO C(380),C(710) PIXEL

	// Cria as Groups do Sistema
	@ C(002),C(014) TO C(067),C(235) LABEL "Marque os arquivos para importa็ใo" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(030),C(018) CheckBox oPedido 	Var lPedido 	Prompt "Pedido" 	Size C(048),C(008) 	PIXEL 	OF _oDlg

	// Observacoes
	@ C(080),C(005) Say "                Este programa irแ importar os arquivos de clientes, vendedores e pedidos de venda exportados "	Size C(260),C(008) COLOR CLR_BLACK		PIXEL OF _oDlg
	@ C(090),C(005) Say "        do sistema TV+.                                                              						  "	Size C(168),C(008) COLOR CLR_BLACK		PIXEL OF _oDlg

	// Bot๕es
	@ C(110),C(105) BMPBUTTON TYPE 01 ACTION OkImpDBF()
	@ C(110),C(150) BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)   //ValidPerg()
	@ C(110),C(195) BMPBUTTON TYPE 02 ACTION Close(_oDlg)

	ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ OkImpDBF บ Autor ณ Cristiano D. Alves บ Data ณ  31/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Importa็ใo dos DBFดs                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function OkImpDBF()

	//Valida o preenchimento dos parametros - Bruno Alves - 24/05/2020
	If Empty(_dDtIni) .OR. Empty(_dDtFim) .OR.	Empty(_cCond) .OR. Empty(_cCondFix) .OR. Empty(_cNat) .OR.  Empty(_cProd) .OR. Empty(MV_PAR09)
		MsgAlert("Favor preencher todos os parametros para continuar com a importa็ใo e gera็ใo dos pedidos de venda","OkImpDBF")
		Return
	EndIf

	If lPedido
		Processa({|| GRVPED() },"Importando Pedidos...")
	EndIf

	Close(_oDlg)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRVPED    บAutor  ณCristiano D. Alves  บ Data ณ  22/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para grava็ใo do pedido de venda                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GRVPED()

	Local _cArqPed		:= Alltrim(MV_PAR06)+"VENDA.TXT"
	//Local _lGrava		:= .F.
	Local _cComp		:= StrTran(DToC(dDataBase),"/")
	Local _aCab			:= {}
	Local  nPos			:= 0
	Local _aItens		:= {}
	Local _cVend		:= ""
	Local _cVend2		:= ""
	Local _lNovo		:= .F.
	Local nTotal		:= 0
	Local nDif			:= 0
	Local nErro			:= 0
	Local cTes			:= ""

	Local i				:= 0
	Local aHeader		:= {}//Titulos
	Local aPed			:= {}//Todos pedidos que serใo importados

	Local nPercAg		:= 0

	//Private _cArqTxt 	:= "Y:\_TV40\LOGS\Pedidos.log" //Arquivo onde serใo gravadas as ocorr๊ncias...
	Private _cArqTxt 	:= Alltrim(MV_PAR06)+"logErro.log" //Arquivo onde serใo gravadas as ocorr๊ncias...
	Private _cMsg 		:= ""
	Private _nCont		:= 0
	Private _dINI		:= CTOD("\\")
	Private _dFIM		:= CTOD("\\")

	dbSelectArea("SA1")
	dbSetOrder(3)

	dbSelectArea("SA3")
	dbSetOrder(2)

	dbSelectArea("SED")
	dbSetOrder(1)

	dbSelectArea("SB1")
	dbSetOrder(1)

	dbSelectArea("SE4")
	dbSetOrder(1)

	dbSelectArea("SC5")
	dbSetOrder(5)


	//Verifico se existe o arquivo no caminho informado
	If File(@_cArqPed)
		//Efetua a c๓pia da mแquina local para o servidor. Servirแ para processamento do temporario e tambem como backup
		__CopyFile(@_cArqPed,"\system\tvm\tv+\VENDA"+_cComp+".TXT")
	Else
		MsgStop("Nใo existe o arquivo " + _cArqPed + ". Verifique!","FRVPED")
		Return
	EndIf

	aHeader 	:= LeituraArq(_cArqPed,.T.)

	nFILIAL   	:= aScan(aHeader[1], { |x| x == "Z1_FILIAL"})
	nCPFCGC	  	:= aScan(aHeader[1], { |x| x == "Z1_CPFCGC"})
	nIDCLI	  	:= aScan(aHeader[1], { |x| x == "Z1_IDCLI"})
	nCONDPAG  	:= aScan(aHeader[1], { |x| x == "Z1_CONDPAG"})
	nCNPJAGE  	:= aScan(aHeader[1], { |x| x == "Z1_CNPJAGE"})
	nPARC1	  	:= aScan(aHeader[1], { |x| x == "Z1_PARC1"})
	nDATA1	  	:= aScan(aHeader[1], { |x| x == "Z1_DATA1"})
	nPARC2	  	:= aScan(aHeader[1], { |x| x == "Z1_PARC2"})
	nDATA2	  	:= aScan(aHeader[1], { |x| x == "Z1_DATA2"})
	nPARC3	  	:= aScan(aHeader[1], { |x| x == "Z1_PARC3"})
	nDATA3	  	:= aScan(aHeader[1], { |x| x == "Z1_DATA3"})
	nPARC4	  	:= aScan(aHeader[1], { |x| x == "Z1_PARC4"})
	nDATA4	  	:= aScan(aHeader[1], { |x| x == "Z1_DATA4"})
	nMENNOTA  	:= aScan(aHeader[1], { |x| x == "Z1_MENNOTA"})
	nDESCRI	  	:= aScan(aHeader[1], { |x| x == "Z1_DESCRI"})
	nPRCVEN	  	:= aScan(aHeader[1], { |x| x == "Z1_PRCVEN"})
	nNUMRP	  	:= aScan(aHeader[1], { |x| x == "Z1_NUMRP"})
	nPREFINI  	:= aScan(aHeader[1], { |x| x == "Z1_PREFINI"})
	nPREFFIM  	:= aScan(aHeader[1], { |x| x == "Z1_PREFFIM"})
	nDESCONT  	:= aScan(aHeader[1], { |x| x == "Z1_DESCONT"})
	nCANCELA  	:= aScan(aHeader[1], { |x| x == "Z1_CANCELA"})
	nNUMPED	  	:= aScan(aHeader[1], { |x| x == "Z1_NUMPED"})
	nNATUREZA 	:= aScan(aHeader[1], { |x| x == "Z1_NATUREZA"})
	nPRACA	  	:= aScan(aHeader[1], { |x| x == "Z1_PRACA"})
	nTIPOFAT  	:= aScan(aHeader[1], { |x| x == "Z1_TIPOFAT"})
	nTIPOVEIC 	:= aScan(aHeader[1], { |x| x == "Z1_TIPOVEIC"})
	nCFOP	  	:= aScan(aHeader[1], { |x| x == "Z1_CFOP"})
	nCODCONTATO := aScan(aHeader[1], { |x| x == "Z1_CODCONTATO"})
	nCONTATO  	:= aScan(aHeader[1], { |x| x == "Z1_CONTATO"})

	nValParc := 0
	nValVend := 0

	aPed 	:= LeituraArq(_cArqPed,.F.)

	If Len(aPed) > 0
		ProcRegua(Len(aPed))
	Else
		MsgInfo("Nใo existe informa็๕es a serem importadas","IMPRP01NEW")
		Return
	EndIf

	For i:=1 to Len(aPed)

		// Tratativas em alguns campos
		//transforma caracter em valores
		aPed[i][nPARC1]		:= Val(StrTran(aPed[i][nPARC1],",", "."))
		aPed[i][nPARC2]		:= Val(StrTran(aPed[i][nPARC2],",", "."))
		aPed[i][nPARC3]		:= Val(StrTran(aPed[i][nPARC3],",", "."))
		aPed[i][nPARC4]		:= Val(StrTran(aPed[i][nPARC4],",", "."))
		aPed[i][nPRCVEN]	:= Val(StrTran(aPed[i][nPRCVEN],",", "."))
		aPed[i][nDESCONT]	:= Val(StrTran(aPed[i][nDESCONT],",", "."))

		aPed[i][nNUMPED]	:= STRZERO(Val(aPed[i][nNUMPED]),6)


		//Transforma datas que estใo em formato caracter em formato data

		aPed[i][nDATA1]		:= CTOD(aPed[i][nDATA1])
		aPed[i][nDATA2]		:= CTOD(aPed[i][nDATA2])
		aPed[i][nDATA3]		:= CTOD(aPed[i][nDATA3])
		aPed[i][nDATA4]		:= CTOD(aPed[i][nDATA4])
		aPed[i][nPREFINI]	:= CTOD(aPed[i][nPREFINI])
		aPed[i][nPREFFIM]	:= CTOD(aPed[i][nPREFFIM])


		// Zero a porcentagem para o proximo pedido
		nPercAg := 0

		IncProc("CPF/CNPJ: "+aPed[i][nCPFCGC]+" RP: "+aPed[i][nNUMRP])

		//Verifico se jแ existe o pedido para a RP, se houver, nใo importa.
		SC5->(dbSetOrder(10))
		If SC5->(dbSeek(xFilial("SC5")+aPed[i][nNUMRP]))
			If Alltrim(aPed[i][nNUMRP]) == Alltrim(SC5->C5_NUMRP)
				_cMsg := "Numero de RP: "+aPed[i][nNUMRP]+" jแ cadastrado no sistema"
				GeraLog(_cMsg) //Grava no arquivo de log
				Loop
			EndIf
		Endif

		//Verifico se jแ existe o pedido de venda, se houver, nใo importa.
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+aPed[i][nNUMPED]))
			Loop
		Endif

		//Filtro apenas o intervalo do pedido de venda - Bruno Alves de Oliveira
		If !(aPed[i][nNUMPED] >= STRZERO(Val(MV_PAR07),6) .AND. aPed[i][nNUMPED] <= STRZERO(Val(MV_PAR08),6))
			Loop
		EndIf


		//Nao importa pedido com valor zerado
		If aPed[i][nPARC1] == 0
			_cMsg := "O pedido de venda para o CGC/CNPJ: "+aPed[i][nCPFCGC]+" RP: "+aPed[i][nNUMRP]+". Estแ com a parcela igual a zero."
			GeraLog(_cMsg) //Grava no arquivo de log
			_nCont ++
			Loop
		EndIf

		//Verifica se existe o cliente cadastrado
		SA1->(dbSetOrder(3))
		If !SA1->(DbSeek(xFilial("SA1")+aPed[i][nCPFCGC],.F.))
			_cMsg := "O pedido de venda para o CGC/CNPJ: "+aPed[i][nCPFCGC]+" RP: "+aPed[i][nNUMRP]+". Sem cadastro de cliente."
			GeraLog(_cMsg) //Grava no arquivo de log
			_nCont ++
			Loop
		Endif

		//Nao importa pedido cancelado
		If aPed[i][nCANCELA] == "S"
			_cMsg := "O pedido de venda para o CGC/CNPJ: "+aPed[i][nCPFCGC]+" RP: "+aPed[i][nNUMRP]+". Nใo foi importado (Pedido Cancelado)."
			GeraLog(_cMsg) //Grava no arquivo de log
			_nCont ++
			Loop
		Endif

		//Cadastro de vendedores - Verifica a Ag๊ncia = VEND1
		SA3->(dbSetOrder(3))
		If SA3->(dbSeek(xFilial("SA3")+aPed[i][nCNPJAGE],.F.))
			_cVend 	:= SA3->A3_COD
		Else
			_cVend	:= ""
		EndIf

		//Cadastro de vendedores - Verifica a Ag๊ncia = VEND1
		SA3->(dbSetOrder(9))
		If SA3->(dbSeek(xFilial("SA3")+aPed[i][nCODCONTATO],.F.))
			_cVend2 := SA3->A3_COD
		Else
			_cVend2	:= ""
		EndIf

		//Rafael - Coloca data de inicio e fim de veicula็ใo nas Ordens de Faturamento
		IF EMPTY(aPed[i][nPREFINI])
			_dINI := dDataBase
		ELSE
			_dINI := aPed[i][nPREFINI]
		ENDIF

		IF EMPTY(aPed[i][nPREFFIM])
			_dFIM := dDataBase
		ELSE
			_dFIM := aPed[i][nPREFFIM]
		ENDIF

		//Tratativa dos valores para gera็ใo do pedido de venda conforme o preenchimento do tipo de faturamento - Bruno Alves - 24/05/2020
		If (aPed[i][nTIPOFAT] == "2" .OR. aPed[i][nTIPOFAT] == "5") .AND. aPed[i][nDESCONT] > 0
			nValParc := Round(aPed[i][nPARC1],2) - (Round(aPed[i][nPARC1],2) * (aPed[i][nDESCONT]/100))
			nValVend := aPed[i][nPRCVEN] - (Round(aPed[i][nPRCVEN],2) * (aPed[i][nDESCONT]/100))
		Else
			nValParc := Round(aPed[i][nPARC1],2)
			nValVend := aPed[i][nPRCVEN]
			nPercAg := aPed[i][nDESCONT]
		EndIf



		//Entra na condi็ใo das parcelas fixas apenas quando a natureza for igual a 1
		If aPed[i][nNATUREZA] == "1" .OR. Empty(aPed[i][nNATUREZA])

			//Regra da Parcela adicionada pelo Bruno Alves - 22/09/2019
			//Verifico se existe NumRP e adiciono valor da parcela caso exista pedido no array _aCab
			nPos := aScan( _aCab , { |x| x[4] == aPed[i][nNUMRP] } )
			//Se localizou insiro a da data e o valor parcela
			If nPos > 0

				//Verifico se ้ duplicidade ou nใo

				//Verifico aonde posso inserir a data e o valor da parcela.
				//Caso a data seja igual ้ necessแrio somar o valor da mensalidade
				If _aCab[nPos][10] == 0 .OR. _aCab[nPos][09] == aPed[i][nDATA1]
					_aCab[nPos][09] := aPed[i][nDATA1]
					_aCab[nPos][10] += nValParc
				ElseIf _aCab[nPos][12] == 0 .OR. _aCab[nPos][11] == aPed[i][nDATA1]
					_aCab[nPos][11] := aPed[i][nDATA1]
					_aCab[nPos][12] += nValParc
				Elseif _aCab[nPos][14] == 0 .OR. _aCab[nPos][13] == aPed[i][nDATA1]
					_aCab[nPos][13] := aPed[i][nDATA1]
					_aCab[nPos][14] += nValParc
				Elseif _aCab[nPos][16] == 0 .OR. _aCab[nPos][15] == aPed[i][nDATA1]
					_aCab[nPos][15] := aPed[i][nDATA1]
					_aCab[nPos][16] += nValParc
				EndIf

				//Passo o registro para nใo incluir um novo cabe็alho com a mesma informa็ใo
				Loop

			EndIf

		EndIf

		nPos := aScan( _aCab , { |x| x[8] == aPed[i][nNUMPED] } )
		//Inserir apenas um item e um cabe็alho em cada pedido de venda
		If nPos == 0

			//Array com o cabe็alho do pedido
			//Acrescentado informa็ใo no array posi็ใo 09 ao 15 - Bruno Alves de OLiveira 22/09/2019
			aAdd(_aCab,{SA1->A1_COD,;		//01.Codigo do cliente
			SA1->A1_LOJA,;			 		//02.Loja do cliente
			_cVend,;     			 		//03.Vendedor
			aPed[i][nNUMRP],;   			//04.RP TV+
			_dINI,;					 		//05.Periodo de veicula็ใo De
			_dFIM,;         		 		//06.Periodo de veicula็ใo ate
			aPed[i][nMENNOTA],;				//07.Mensagem para nota fiscal
			aPed[i][nNUMPED],;		 		//08.N๚mero da NF do TV+ que serแ o num do ped. no Protheus
			IIF(aPed[i][nNATUREZA] == "1" .or. Empty(aPed[i][nNATUREZA]),aPed[i][nDATA1],CTOD("//")),;	//09 Data da 1บ Parcela
			IIF(aPed[i][nNATUREZA] == "1" .or. Empty(aPed[i][nNATUREZA]),nValParc,0),;					//10 Valor da 1บ Parcela
			CTOD("//"),;			 		//11 Data da 2บ Parcela
			0,;						 		//12 Valor da 2บ Parcela
			CTOD("//"),;			 		//13 Data da 3บ Parcela
			0,;						 		//14 Valor da 3บ Parcela
			CTOD("//"),;			 	  	//15 Data da 4บ Parcela
			0,;						 	  	//16 Valor da 4บ Parcela
			Alltrim(aPed[i][nDESCRI]),;	  	//17 Descri็ใo da importa็ใo aonde buscamos dicas do preenchimento da natureza
			Alltrim(aPed[i][nNATUREZA]),; 	//18 Regra da Natureza
			Alltrim(aPed[i][nPRACA]),;	  	//19 Praca
			Alltrim(aPed[i][nTIPOFAT]),;  	//20 Tipo de Faturamento
			Alltrim(aPed[i][nTIPOVEIC]),; 	//21 Tipo de Veiculacao
			Alltrim(aPed[i][nCFOP]),;	  	//22 CFOP
			nPercAg,;						//23 Porcentagem Vendedor (Agencia)
			_cVend2,; 						//24 Contato / Vendedor 2 - Controle de comissใo de contato
			Alltrim(aPed[i][nCONTATO])})	//25 Nome do Contato

			cTes := "5" + Substring(Alltrim(aPed[i][nCFOP]),1,1) + Substring(Alltrim(aPed[i][nCFOP]),3,1)

			//Verifico se a TES ้ valida, caso nใo seja preencho como em branco para fazer a trativa na inclusใo do pedido de venda
			DbSelectArea("SF4")
			DbSetOrder(1)

			If !DbSeek(xFilial("SF4") + cTes)
				cTes := ""
			EndIf

			//Array com os itens do pedido
			aAdd(_aItens,{SA1->A1_COD,;   	//01.Codigo do Cliente
			SA1->A1_LOJA,;    				//02.Loja do cliente
			nValVend,;  					//03.Preco unitario
			aPed[i][nNUMRP],;				//04.RP TV+
			cTes }) 						//05 TES

		Endif

	Next

	//Se nใo tiver erro log, recria para atualizar o arquivo
	If Empty(_cMsg)
		GeraLog("OK")
	EndIf

	//Bruno Alves de Oliveira - 06/10/2019
	If LEN(_aCab) == 0
		MsgAlert("Nใo existem informa็๕es para serem importadas","GRVPED")
		Return
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava Pedido de Vendaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aCab 	:= aSort(_aCab,,,     { |x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4] })
	_aItens := aSort(_aItens,,,   { |x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4] })

	For _I := 1 To Len(_aCab)
		_aAuxItem := {}

		IncProc( "Gerando Ped. Venda " + StrZero(_I,5) + " de " + StrZero(Len(_aCab),5) )

		For _J := 1 To Len(_aItens)
			If _aCab[_I,1] + _aCab[_I,2] + _aCab[_I,4] == _aItens[_J,1] + _aItens[_J,2] + _aItens[_J,4]
				aAdd(_aAuxItem, _aItens[_J])
			Endif
		Next _J

		If Len(_aAuxItem) > 0
			// Carrega o array _aLinha com os itens do pedido
			_aItensC5 := {}
			_cItem := "00"
			_lNovo := .F.
			//_cNumPed := StrZero(Val(_aCab[_I,8]),6)
			_cNumPed := _aCab[_I,8]//Temporario
			nTotal := 0

			For _X := 1 To Len(_aAuxItem)
				_cItem := Soma1(_cItem)
				_aLinha := {}
				aAdd(_aLinha,{"C6_FILIAL",		xFilial("SC6"),Nil})
				aAdd(_aLinha,{"C6_PRODUTO",	_cProd,Nil})
				aAdd(_aLinha,{"C6_UM",			Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_UM"),Nil})
				aAdd(_aLinha,{"C6_QTDVEN",		1,Nil})
				aAdd(_aLinha,{"C6_PRCVEN",		Round(_aAuxItem[_X,03],2),Nil})
				aAdd(_aLinha,{"C6_VALOR",		Round(_aAuxItem[_X,03],2),Nil})
				aAdd(_aLinha,{"C6_QTDLIB",		1,Nil})
				aAdd(_aLinha,{"C6_TES",			IIF(!Empty(_aAuxItem[_X,05]),_aAuxItem[_X,05],Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_TS")),Nil})
				aAdd(_aLinha,{"C6_LOCAL",		Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_LOCPAD"),Nil})
				aAdd(_aLinha,{"C6_ENTREG",		dDataBase,Nil})
				aAdd(_aLinha,{"C6_DESCRI",		Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC"),Nil})
				aAdd(_aLinha,{"C6_CLI",			_aAuxItem[_X,01],Nil})
				aAdd(_aLinha,{"C6_LOJA",		_aAuxItem[_X,02],Nil})
				aAdd(_aLinha,{"C6_NUM",			_cNumPed,Nil})
				aAdd(_aLinha,{"C6_ITEM",		_cItem,Nil})
				aAdd(_aItensC5,_aLinha)

				nTotal += Round(_aAuxItem[_X,03],2) //Soma o valor total dos itens

			Next _X

			/*
			//Natureza Spot cadastrado no cadastro do cliente
			If "PI" $ Substr(_aCab[_I][17],1,3) .AND. !("BRASILIA" $ _aCab[_I][17] ) .AND. !Empty(Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_XNATSPO"))
			cNatureza := Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_XNATSPO")
			//Natureza Informada nos parametros
			ElseIf Empty(Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_NATUREZ"))
			cNatureza := _cNat
			//Natureza Normal cadastro no cadastro do cliente
			Else
			cNatureza := Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_NATUREZ")
			EndIf
			*/

			//Automatiza็ใo no preehcimento das Natureza - Bruno Alves - 24/05/2020
			If Alltrim(_aCab[_I][19]) != "DF" // Rafael Fran็a - 28/07/20 - Foi priorizada a valida็ใo da pra็a diferente de "DF". Mesmo que seja merchandising, ele serแ spot quando for de outra pra็a.
				cNatureza := Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_XNATSPO")
			ElseIf Alltrim(_aCab[_I][21]) == "3"
				cNatureza := Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_XNATMEC")
			Else
				cNatureza := Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_NATUREZ")
			EndIf

			//Caso o campo natureza nใo esteja preenchido, irแ buscar a natureza informado no parametro
			If Empty(cNatureza)
				cNatureza := _cNat
				MsgAlert("Favor preencher o cadastro de natureza do Cliente: " + Alltrim(_aCab[_I][1]) + " Loja: "  + Alltrim(_aCab[_I][2]) + " - Nome: " + Posicione("SA1",1,xFilial("SA1")+_aCab[_I][1]+_aCab[_I][2],"A1_NOME") + ".")
			Endif

			//Carrega o Array _aCabC5 ser gravado o cabe็alho do pedido
			_aCabC5 := {}

			IF _aCab[_I,18] == "1" //Se Natureza for igual a 2 a condi็ใo de pagamento valor fixo ้ desnecessario.
				//Condi็ใo para tratar o valor da soma das parcelas, caso seja diferente do valor total do pedido de venda faz altera็ใo no valor da 1บ parcela
				If _aCab[_I,10] > 0 // Verifico se a condi็ใo de pagamento foi parcela fixa ou condi็ใo de pagamento normal conforme regra do campo Z1_NATUREZA - Bruno Alves - 24/05/2020
					nDif := nTotal - (_aCab[_I,10] + _aCab[_I,12] + _aCab[_I,14] + _aCab[_I,16])
					If nDif > 0
						_aCab[_I,10] := _aCab[_I,10] + nDif
					ElseIf nDif < 0
						_aCab[_I,10] := _aCab[_I,10] + nDif
					EndIf
				EndIf
			EndIf

			aAdd(_aCabC5,{"C5_FILIAL",	xFilial("SC5"),Nil})
			aAdd(_aCabC5,{"C5_TIPO",	"N",Nil})
			aAdd(_aCabC5,{"C5_NUM",		_cNumPed,Nil})
			aAdd(_aCabC5,{"C5_EMISSAO",	dDataBase,Nil})
			aAdd(_aCabC5,{"C5_CLIENTE",	_aCab[_I,01],Nil})
			aAdd(_aCabC5,{"C5_LOJACLI",	_aCab[_I,02],Nil})
			aAdd(_aCabC5,{"C5_CLIPED",	_aCab[_I,01],Nil})
			aAdd(_aCabC5,{"C5_LOJPED",	_aCab[_I,02],Nil})
			aAdd(_aCabC5,{"C5_VEND1",	_aCab[_I,03],Nil})
			aAdd(_aCabC5,{"C5_VEND2",	_aCab[_I,24],Nil}) //24 Contato / Vendedor 2 - Controle de comissใo de contato
			aAdd(_aCabC5,{"C5_CONDPAG",	IIF(_aCab[_I,18] == "1",_cCondFix,_cCond)	,Nil})
			aAdd(_aCabC5,{"C5_TIPLIB",	"1",Nil})
			aAdd(_aCabC5,{"C5_NATUREZ",	cNatureza,Nil})
			aAdd(_aCabC5,{"C5_REPASSE",	"N",Nil})
			aAdd(_aCabC5,{"C5_NUMRP",	_aCab[_I,04],Nil})
			aAdd(_aCabC5,{"C5_PREFINI",	_aCab[_I,05],Nil})
			aAdd(_aCabC5,{"C5_PREFFIM",	_aCab[_I,06],Nil})
			aAdd(_aCabC5,{"C5_CALCCOM",	"S",Nil})
			//Adicionado a regra da parcela pelo Bruno Alves - 22/09/2019
			aAdd(_aCabC5,{"C5_DATA1",	_aCab[_I,09],Nil})
			aAdd(_aCabC5,{"C5_PARC1",	_aCab[_I,10],Nil})
			aAdd(_aCabC5,{"C5_DATA2",	_aCab[_I,11],Nil})
			aAdd(_aCabC5,{"C5_PARC2",	_aCab[_I,12],Nil})
			aAdd(_aCabC5,{"C5_DATA3",	_aCab[_I,13],Nil})
			aAdd(_aCabC5,{"C5_PARC3",	_aCab[_I,14],Nil})
			aAdd(_aCabC5,{"C5_DATA4",	_aCab[_I,15],Nil})
			aAdd(_aCabC5,{"C5_PARC4",	_aCab[_I,16],Nil})
			// Adicionado regra da melhoria do repasse para automatizar 100% o processo de importa็ใo - Bruno Alves - 24/05/2020
			aAdd(_aCabC5,{"C5_XNATURE",	_aCab[_I,18],Nil})
			aAdd(_aCabC5,{"C5_XPRACA",	_aCab[_I,19],Nil})
			aAdd(_aCabC5,{"C5_XTPFAT",	_aCab[_I,20],Nil})
			aAdd(_aCabC5,{"C5_XTPVEIC",	_aCab[_I,21],Nil})
			aAdd(_aCabC5,{"C5_XCFOP",	_aCab[_I,22],Nil})
			aAdd(_aCabC5,{"C5_COMIS1",	_aCab[_I,23],Nil})

			//Verifico se a 1บ parcela estแ com valor positivo por conta do acerto do valor
			If _aCab[_I,10] > 0 .OR. _aCab[_I,18] == "2" //Se Natureza for igual a 2 a condi็ใo de pagamento valor fixo ้ desnecessario.
				// Integra com o Pedido de Venda
				Begin Transaction

					lMsErroAuto := .F.
					MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCabC5,_aItensC5,3)

					If lMsErroAuto
						_cMsg := "O pedido de venda " + Alltrim(_cNumPed) +" para o CGC/CNPJ: "+_aCab[_I,01]+" RP: "+_aCab[_I,04]+" apresentou problemas no momento da inclusใo do pedido de venda pela rotina do execauto."
						GeraLog(_cMsg) //Grava no arquivo de log
						_nCont ++
						RollBackSx8()                            //Acerta o n๚mero sequencial.
						MostraErro()
						DisarmTransaction()
						nErro++
					Else
						If _lNovo
							ConfirmSX8()
							Sleep(400) // andre
						EndIf
					EndIf

				End Transaction

				SC5->(dbSetOrder(1))

			Else

				_cMsg := "O pedido de venda " + Alltrim(_cNumPed) +" para o CGC/CNPJ: "+_aCab[_I,01]+" RP: "+_aCab[_I,04]+" nใo foi incluido devido o valor da 1บ parcela da condi็ใo de pagamento."
				GeraLog(_cMsg) //Grava no arquivo de log
				_nCont ++

			EndIf

		EndIf

	Next _I

	MsgInfo("Foram importado(s) " + Alltrim(Str(Len(_aCab) - nErro)) + " pedido(s) de venda.","GRVPED") //Bruno Alves - 06/10/2019

	If _nCont > 0 //Verifica se houveram inconsist๊ncias
		MsgInfo("Houveram inconsist๊ncias na importa็ใo. Verifique o arquivo: "+_cArqTxt)
	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณCristiano D. Alves  บ Data ณ  26/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas no SX1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rede Record                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","Veiculacao De       ?","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Veiculacao Ate      ?","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Cond. Pgto p/ Pedido?","","","mv_ch3","C",03,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SE4",""})
	aAdd(aRegs,{cPerg,"04","Natureza p/ Pedido  ?","","","mv_ch4","C",10,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
	aAdd(aRegs,{cPerg,"05","Produto p/ Pedido   ?","","","mv_ch5","C",15,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
	aAdd(aRegs,{cPerg,"06","Diret๓rio Arq. Imp. ?","","","mv_ch6","C",60,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Do Pedido  ?","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	aAdd(aRegs,{cPerg,"08","Ate Pedido  ?","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
	aAdd(aRegs,{cPerg,"09","Cond Pg Parc Fixo?","","","mv_ch9","C",03,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SE4",""})

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
	Else	// Resolucao 1024x768 e acima
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraLog   บAutor  ณCristiano D. Alves  บ Data ณ  20/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava log de inconsist๊ncias.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CDL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GeraLog(_cMsg)

	Local _nTamLin, _cLin, _cCpo
	Private _nHdl   := 0
	Private _cEOL    := "CHR(13)+CHR(10)"

	_nHdl	:= fOpen(_cArqTxt,66)

	If _nHdl == -1
		_nHdl :=  fCreate(_cArqTxt)
	EndIf

	FSEEK(_nHdl,0,2)                       // posiciona no final do arquivo

	If Empty(_cEOL)
		_cEOL := CHR(13)+CHR(10)
	Else
		_cEOL := Trim(_cEOL)
		_cEOL := &_cEOL
	Endif

	If _nHdl == -1
		MsgAlert("O arquivo de nome "+_cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	_nTamLin := 200
	_cLin    := Space(_nTamLin)+_cEOL // Variavel para criacao da linha do registros para gravacao

	_cCpo := PADR(dtoc(dDataBase)+" "+Time()+" - "+_cMsg,200)
	_cLin := Stuff(_cLin,01,200,_cCpo)

	fWrite(_nHdl,_cLin,Len(_cLin))

	fClose(_nHdl)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ LeituraArq บ Autor ณ Bruno Alves 	 บ Data ณ  19/05/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Importa็ใo do arquivo .TXT                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function LeituraArq(_cArqPed,lHeader)

	Local aCampos := {}
	Local aDados  := {}
	Local cLinha  := ""
	Local lPrim   := .T.


	FT_FUSE(_cArqPed)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

		If lHeader //Condi็ใo para buscar os titulos
			AADD(aDados,Separa(cLinha,";",.T.))
			Exit
		ElseIf lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()

	EndDo

	FT_FUSE()


Return(aDados)
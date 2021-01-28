#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "Tbiconn.CH"

// Bruno Alves - 24/11/10 - Cadastro de autorização de pagamento / Impressão e integração com msword

User Function AXAUTOR

	Private cCadastro := "Cadastro de Autorização"
	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","AxVisual",0,2} ,;
		{"Incluir","AxInclui",0,3} ,;
		{"Alterar","AxAltera",0,4} ,;
		{"Excluir","AxDeleta",0,5} ,;
		{"Impressao","u_WordAut()",0,2},;
		{"Legenda","u_LegendSZM()",0,4}}

	Private aCores := {{'ZM_IMPRESS == "1"' ,'BR_VERDE'},{'ZM_IMPRESS == "2"','BR_VERMELHO'}} //Cores e regras para legenda
	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString := "SZM"

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function LegendSZM

	// Configuração da legenda

	Local aLegenda := {{"ENABLE","Impresso"},{"DISABLE","Não Impresso"}}

	BrwLegenda("Cadastro de Autorização Fornecedor","Legenda",aLegenda)

Return(.t.)

User Function WordAut()

	Local wcFornecedor, wcCGC, wcEmissao, wcDTAutor, wcValor, wcAprova, wcCompra, wcPedido, wcAno, wcTelefone, wcDDD
	Local cAssina1 	:= ""
	Local cNome1   	:= ""
	Local cDept1	:= ""
	Local cAssina2	:= ""
	Local cNome2	:= ""
	Local cDept2	:= ""
	Local cAssina3	:= ""
	Local cNome3	:= ""
	Local cDept3	:= ""
	Local cChaveSCR := ""
	Local nAprov    := 0
	Local aUsuario  := {}
	//Local waCod		:= {}
	//Local waDescr	:= {}
	//Local waVTot	:= {}
	//Local nAuxTot	:= 0
	//Local nK
	Local nomeArq        := ""
	Local cPathDot       := "\mala\"
	Local cPathLoc       := "C:\TEMP\"
	Private	hWord

	dbSelectArea("SZM")
	dbSetOrder(1)
	dbSeek(xFilial("SZM") + SZM->ZM_CODIGO)

	If !found()
		Alert(" Codigo não cadastrado!!")
		Return()
	EndIf

	//Transfiro o documento word para a pasta temporaria da maquina do usuário
	nomeArq := "autorizacaofor.docx"

	//Verifica se existe a pasta na maquina do usuário e caso não exista faz a criação.
	If !ExistDir(cPathLoc)
		If MakeDir(cPathLoc) <> 0
			Alert("Não foi possivel criar o diretorio " + cPathLoc + " Verifique se o diretorio existe ou se o sistema tem permissão para criar o diretorio e tente novamente.")
			Return
		EndIf
	EndIf

	_lCopy := CpyS2T(cPathDot+nomeArq,cPathLoc)
	If !_lCopy
		Alert("Erro na criação do arquivo, ou existem arquivos modelo(word) abertos "+nomeArq)
		Return
	Endif



	cChaveSCR := SZM->ZM_FILIAL + "PC" + SZM->ZM_PEDIDO

	wcFornecedor	:= Alltrim(SZM->ZM_NOMEFOR)
	wcCGC			:= SZM->ZM_CGC
	wcEmissao		:= Alltrim(str(Day(SZM->ZM_EMISSAO)))  + " de " + Mes(SZM->ZM_EMISSAO)  + " de " + Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
	wcDTAutor		:= Alltrim(str(Day(SZM->ZM_EMISSAO)))  + " de " + Mes(SZM->ZM_EMISSAO)  + " de " + Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
	wcValor			:= Alltrim(Str(SZM->ZM_VALOR)) + " (" + Alltrim(Extenso(SZM->ZM_VALOR))  +  ")"
	wcAprova		:= SZM->ZM_NMAPROV
	wcCompra		:= SZM->ZM_NMCOMPR
	wcPedido		:= SZM->ZM_PEDIDO
	wcAno			:= Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
	wcTelefone		:= Alltrim(cValToChar(Posicione("SA2",1,xFilial("SA2")+ SZM->ZM_FORNECE + SZM->ZM_LOJA,"A2_TEL")))
	wcDDD			:= Posicione("SA2",1,xFilial("SA2")+ SZM->ZM_FORNECE + SZM->ZM_LOJA,"A2_DDD")


	//Verifico quais são os aprovadores do pedido de compra
	DbSelectArea("SCR");DbSetOrder(1)
	iF DbSeek(cChaveSCR)
		//Busca aprovação do primeiro nivel conforme instrução da Dona Elenn 15/01/2021. Por esse motivo foi retirado a repetição whilw

		//While !SCR->(EOF()) .AND. cChaveSCR == SCR->CR_FILIAL + SCR->CR_TIPO + Alltrim(SCR->CR_NUM)

		nAprov++

		If PswSeek( SCR->CR_USER, .T. )
			aUsuario := PswRet() // Retorna vetor com informações do usuário
			&("cDept"   + Alltrim(STR(nAprov)) )	    := Alltrim(aUsuario[1][13])
		EndIf
		//Verifico se foi aprovado ou não
		If SCR->CR_STATUS $ '03/05'
			&("cAssina" + Alltrim(STR(nAprov)) ) 	    := "Liberação Eletrônica - " + DTOC(SCR->CR_DATALIB)
		ElseIf SCR->CR_STATUS $ '04/06'
			&("cAssina" + Alltrim(STR(nAprov)) ) 	    := "Rejeição Eletrônica - " + DTOC(SCR->CR_DATALIB)
		Else
			&("cAssina" + Alltrim(STR(nAprov)) ) 	    := "Aguardando Aprovação"
		EndIf
		&("cNome"   + Alltrim(STR(nAprov)) )   	:= Alltrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"AK_NOME"))

		//	SCR->(DbSkip())

		//EndDo

	EndIf




	//Conecta ao word
	hWord	:= OLE_CreateLink()
	OLE_NewFile(hWord, cPathLoc + nomeArq )

	//Montagem das variaveis do cabecalho
	OLE_SetDocumentVar(hWord, 'Telefone'  ,wcTelefone)
	OLE_SetDocumentVar(hWord, 'DDD'       ,wcDDD)
	OLE_SetDocumentVar(hWord, 'Fornecedor',wcFornecedor)
	OLE_SetDocumentVar(hWord, 'CGC'       ,Transform(wcCGC,"@R 99.999.999/9999-99"))
	OLE_SetDocumentVar(hWord, 'Emissao'   ,wcEmissao)
	OLE_SetDocumentVar(hWord, 'DTAutor'   ,wcDTAutor)
	OLE_SetDocumentVar(hWord, 'Valor'     ,wcValor)
	OLE_SetDocumentVar(hWord, 'Aprova'    ,wcAprova)
	OLE_SetDocumentVar(hWord, 'Compra'    ,wcCompra)
	OLE_SetDocumentVar(hWord, 'Pedido'    ,wcPedido)
	OLE_SetDocumentVar(hWord, 'Ano'       ,wcAno)
	OLE_SetDocumentVar(hWord, 'cAssina1'  ,cAssina1)
	OLE_SetDocumentVar(hWord, 'cNome1'    ,cNome1)
	OLE_SetDocumentVar(hWord, 'cDept1'    ,cDept1)
	OLE_SetDocumentVar(hWord, 'cAssina2'  ,cAssina2)
	OLE_SetDocumentVar(hWord, 'cNome2'    ,cNome2)
	OLE_SetDocumentVar(hWord, 'cDept2'    ,cDept2)
	OLE_SetDocumentVar(hWord, 'cAssina3'  ,cAssina3)
	OLE_SetDocumentVar(hWord, 'cNome3'    ,cNome3)
	OLE_SetDocumentVar(hWord, 'cDept3'    ,cDept3)

	Reclock("SZM",.F.)
	SZM->ZM_DTIMP 		:= Date()
	SZM->ZM_IMPRESS   := "1"
	MsUnlock()

	// Atualizando as variaveis do documento do Word
	OLE_UpdateFields(hWord)
	If MsgYesNo("Imprime o Documento ?")
		Ole_PrintFile(hWord,"ALL",,,1)
	EndIf

	If MsgYesNo("Fecha o Word e Corta o Link ?")
		OLE_CloseFile( hWord )
		OLE_CloseLink( hWord )
	Endif
Return()
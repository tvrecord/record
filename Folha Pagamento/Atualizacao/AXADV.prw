#INCLUDE "rwmake.ch"

User Function AXADV
Private cCadastro := "Cadastro de Advetencia e Supensão"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ³
//³ que apareceram disponiveis para o usuario. Segue o padrao:          ³
//³ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              . . .                                                  ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ³
//³ Onde: <DESCRICAO> - Descricao da opcao do menu                      ³
//³       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ³
//³                     duplas e pode ser uma das funcoes pre-definidas ³
//³                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ³
//³                     e AXDELETA) ou a chamada de um EXECBLOCK.       ³
//³                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-³
//³                     clarar uma variavel chamada CDELFUNC contendo   ³
//³                     uma expressao logica que define se o usuario po-³
//³                     dera ou nao excluir o registro, por exemplo:    ³
//³                     cDelFunc := 'ExecBlock("TESTE")'  ou            ³
//³                     cDelFunc := ".T."                               ³
//³                     Note que ao se utilizar chamada de EXECBLOCKs,  ³
//³                     as aspas simples devem estar SEMPRE por fora da ³
//³                     sintaxe.                                        ³
//³       <TIPO>      - Identifica o tipo de rotina que sera executada. ³
//³                     Por exemplo, 1 identifica que sera uma rotina de³
//³                     pesquisa, portando alteracoes nao podem ser efe-³
//³                     tuadas. 3 indica que a rotina e de inclusao, por³
//³                     tanto, a rotina sera chamada continuamente ao   ³
//³                     final do processamento, ate o pressionamento de ³
//³                     <ESC>. Geralmente ao se usar uma chamada de     ³
//³                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCores := {{'ZG_TIPOADV == "S"' ,'BR_VERMELHO'},{'ZG_TIPOADV == "A"','BR_VERDE'}}
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Impressao","u_WordAdv()",0,2},;
{"Legenda","u_LegendZZ8()",0,4}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZG"

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

User Function LegendZZ8

Local aLegenda := {{"ENABLE","Advertencia"},{"DISABLE","Suspensao"}}

BrwLegenda("Cadastro de Advertências e Suspensões","Legenda",aLegenda)

Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INTWORD  ³   Bruno Alves de Oliveira     ³ Data ³16.07.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz a integracao do Protheus com o MS Word                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³           msiga

³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/

User Function WordAdv()

Private cCod

cCod := Space(6)



@ 96,012 TO 180,370 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 022,170
@ 11,22 Say OemToAnsi("Digite o Codigo da Advertencia ou Suspensão:")
@ 10,135 Get cCod Picture "999999"
@ 25,120 BMPBUTTON TYPE 1 ACTION WordImp(cCod)
@ 25,150 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

return()

Static Function WordImp(cCod)
Local wcMat, wcData, wcNome, wxAdmiss, wcCargo, wcSetor, wcDias, wcDiasEt, wcMotivo, wcDtIni
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot	:= ""
Private	hWord

Close(oDlg)

dbSelectArea("SZG")
dbSetOrder(1)
dbSeek(xFilial("SZG") + cCod)

If !found()
	Alert(" Codigo não cadastrado!!")
	Return()
EndIf

If (SZG->ZG_TIPOADV == "S") .AND. EMPTY(SZG->ZG_DIAS) .AND. EMPTY(SZG->ZG_DTINI)
	Alert(" Favor preencher os campos (SZG->ZG_DIAS) e (ZG_DTINI) no cadastro de Advertencia")
	Return()
EndIf

If (SZG->ZG_TIPOADV == "S") .AND. EMPTY(SZG->ZG_DTINI)
	Alert(" Favor preencher o campo (ZG_DTINI) no cadastro de Advertencia")
	Return()
EndIf

If (SZG->ZG_TIPOADV == "S") .AND. EMPTY(SZG->ZG_DIAS)
	Alert(" Favor preencher o campo (SZG->ZG_DIAS) no cadastro de Advertencia")
	Return()
EndIf



wcMat 	    := SZG->ZG_MAT
wcData		:= SZG->ZG_EMISSAO
wcNome   	:= SZG->ZG_NOME
wcAdmiss    := SZG->ZG_ADMSS
wcCargo     := SZG->ZG_DESFUNC
wcSetor     := SZG->ZG_DESCCC
wcDias		:= SZG->ZG_DIAS
wcDiasEt    := Alltrim(Extenso(SZG->ZG_DIAS,.T.))
wcMotivo    := SZG->ZG_MEMO
wcDtIni     := SZG->ZG_DTINI


If (SZG->ZG_TIPOADV == "S")
	cPathDot := "C:\Docs\suspensao.docx"
Else
	cPathDot := "C:\Docs\advertencia.docx"
EndIf





//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot )

cPathDot := ""

//Montagem das variaveis do cabecalho
OLE_SetDocumentVar(hWord, 'Prt_Cod'      ,(SZG->ZG_COD))
OLE_SetDocumentVar(hWord, 'Prt_Mat'      ,wcMat)
OLE_SetDocumentVar(hWord, 'Prt_Data'     ,wcData)
OLE_SetDocumentVar(hWord, 'Prt_Nome'     ,wcNome)
OLE_SetDocumentVar(hWord, 'Prt_Admiss'   ,wcAdmiss)
OLE_SetDocumentVar(hWord, 'Prt_Cargo'    ,wcCargo)
OLE_SetDocumentVar(hWord, 'Prt_Setor'    ,wcSetor)
OLE_SetDocumentVar(hWord, 'Prt_Dias'     ,wcDias)
OLE_SetDocumentVar(hWord, 'Prt_DiasEt'   ,wcDiasEt)
If (SZG->ZG_TIPOADV == "S")
OLE_SetDocumentVar(hWord, 'Prt_DtDia'    ,day(wcDtIni))
OLE_SetDocumentVar(hWord, 'Prt_DtMesEt'  ,mes(wcDtIni))
OLE_SetDocumentVar(hWord, 'Prt_DtAno'    ,ano(wcDtIni))
endIf
OLE_SetDocumentVar(hWord, 'Prt_DtDiaEm'  ,day(SZG->ZG_EMISSAO))
OLE_SetDocumentVar(hWord, 'Prt_DtMesEtEm',mes(SZG->ZG_EMISSAO))
OLE_SetDocumentVar(hWord, 'Prt_DtAnoEm'  ,ano(SZG->ZG_EMISSAO))
//OLE_SetDocumentVar(hWord, 'Prt_TtNome1'  ,(SZG->ZG_TTNOME1))
//OLE_SetDocumentVar(hWord, 'Prt_TtNome2'  ,(SZG->ZG_NOMETT2))
OLE_SetDocumentVar(hWord, 'Prt_Motivo'   ,wcMotivo)

dBCloseArea("SZG")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)
If MsgYesNo("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf

If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif
Return()

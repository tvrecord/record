#INCLUDE "rwmake.ch"

User Function AXADV
Private cCadastro := "Cadastro de Advetencia e Supens�o"
//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
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

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function LegendZZ8

Local aLegenda := {{"ENABLE","Advertencia"},{"DISABLE","Suspensao"}}

BrwLegenda("Cadastro de Advert�ncias e Suspens�es","Legenda",aLegenda)

Return(.t.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � INTWORD  �   Bruno Alves de Oliveira     � Data �16.07.2010���
�������������������������������������������������������������������������Ĵ��
���Descricao � Faz a integracao do Protheus com o MS Word                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       �           msiga

���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
O objetivo eh fazer a integracao entre o Protheus e o MS Word.

/*/

User Function WordAdv()

Private cCod

cCod := Space(6)



@ 96,012 TO 180,370 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 022,170
@ 11,22 Say OemToAnsi("Digite o Codigo da Advertencia ou Suspens�o:")
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
	Alert(" Codigo n�o cadastrado!!")
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


//�����������������������������������������������������������������������Ŀ
//� Atualizando as variaveis do documento do Word                         �
//�������������������������������������������������������������������������
OLE_UpdateFields(hWord)
If MsgYesNo("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf

If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif
Return()

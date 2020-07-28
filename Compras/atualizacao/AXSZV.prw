#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXSZV		บ Autor ณ Rafael Franca      บ Data ณ  11/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Solicita็ใo de Adiantamento Contratual         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RECORD DF                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AXSZV

Private cCadastro := "Solicitacao de Adiantamento Contratual"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Impressao","u_WordSZV()",0,2},; 
{"Legenda","u_LegeSZV()",0,4}}   

Private aCores := {{'ZV_CODIGO != "1"' ,'BR_VERDE'},{'ZV_CODIGO == "1"','BR_VERMELHO'}}
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZV"
 
dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function LegeSZV

Local aLegenda := {{"ENABLE","Impresso"},{"DISABLE","Nใo Impresso"}}

BrwLegenda("Solicitacao de Adiantamento Contratual","Legenda",aLegenda)

Return(.T.)

User Function WordSZV()

Local wcData,wcFornecedor,wcRazaoSocial	,wcCNPJ,wcCodAtiv,wcInscEst,wcEndereco,wcCEP,wcBairro
Local wcTelefone,wcNome1,wcCPF1,wcRG1,wcEstCiv1,wcNaciona1,wcNome2,wcCPF2,wcRG2,wcEstCiv2
Local wcNaciona2,wcObjeto,wcDescricao,wcVigeIni,wcVigeFim,wcVlrAtual,wcVlrReajus
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot	:= ""
Private	hWord    

//Close(oDlg)

dbSelectArea("SZV")
dbSetOrder(1)
dbSeek(xFilial("SZV") + SZV->ZV_CODIGO)

If !found()
	Alert(" Codigo nใo cadastrado!!")
	Return()
EndIf

wcData			:= SZV->ZV_DATA
wcFornecedor	:= Alltrim(SZV->ZV_NOMEFOR) 
wcRazaoSocial	:= ""
wcCNPJ			:= SZV->ZV_CNPJ 
wcCodAtiv		:= SZV->ZV_CODATIV
wcInscEst		:= SZV->ZV_INSCEST
wcEndereco		:= SZV->ZV_ENDEREC
wcCEP			:= SZV->ZV_CEP
wcBairro		:= SZV->ZV_BAIRRO
wcTelefone		:= SZV->ZV_TELEFON	
wcNome1			:= SZV->ZV_NOME1
wcCPF1			:= SZV->ZV_CPF1
wcRG1           := SZV->ZV_RG1 
wcEstCiv1		:= SZV->ZV_ESTCIV1
wcNaciona1		:= SZV->ZV_NACION1
wcNome2			:= SZV->ZV_NOME2
wcCPF2			:= SZV->ZV_CPF2
wcRG2           := SZV->ZV_RG2 
wcEstCiv2		:= SZV->ZV_ESTCIV2
wcNaciona2		:= SZV->ZV_NACION2  
wcObjeto		:= SZV->ZV_OBJETO                 
wcDescricao		:= SZV->ZV_DESCRI
wcVigeIni		:= SZV->ZV_VIGEINI
wcVigeFim		:= SZV->ZV_VIGEFIM
wcVlrAtual		:= Alltrim(Str(SZV->ZV_VLRATU)) + " (" + Extenso(SZV->ZV_VLRATU) +  ")" 
wcVlrReajus		:= Alltrim(Str(SZV->ZV_VLRREA)) + " (" + Extenso(SZV->ZV_VLRREA) +  ")"   
//wcForPag		:= SZV->ZV_

cPathDot := "X:\SolicitacaoAdi.docx"

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot )

cPathDot := ""

//Montagem das variaveis do cabecalho

OLE_SetDocumentVar(hWord, 'Data'  	 	,wcData)
OLE_SetDocumentVar(hWord, 'Fornecedor'	,wcFornecedor) 
OLE_SetDocumentVar(hWord, 'CNPJ'       	,Transform(wcCNPJ,"@R 99.999.999/9999-99"))
//OLE_SetDocumentVar(hWord, 'Emissao'   	,wcEmissao)
//OLE_SetDocumentVar(hWord, 'DTAutor'   	,wcDTAutor)
//OLE_SetDocumentVar(hWord, 'Valor'     	,wcValor)
//OLE_SetDocumentVar(hWord, 'Aprova'    	,wcAprova)
//OLE_SetDocumentVar(hWord, 'Compra'    	,wcCompra)
//OLE_SetDocumentVar(hWord, 'Pedido'    	,wcPedido)
//OLE_SetDocumentVar(hWord, 'Ano'       	,wcAno)

//Reclock("SZV",.F.)
//SZV->ZV_DTIMP 		:= Date()
//SZV->ZV_IMPRESS   	:= "1"
//MsUnlock()

dBCloseArea("SZV")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualizando as variaveis do documento do Word                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
OLE_UpdateFields(hWord)
If MsgYesNo("Imprime o Documento ?")
	Ole_PrintFile(hWord,"ALL",,,1)
EndIf

If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile( hWord )
	OLE_CloseLink( hWord )
Endif

Return()
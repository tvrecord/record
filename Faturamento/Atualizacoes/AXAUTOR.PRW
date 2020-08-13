#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXAUTORบ Autor ณ Bruno Alves           บ Data ณ  24/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Autoriza็ใo do Faturamento.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AXAUTOR


Private cCadastro := "Cadastro de Autoriza็ใo"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Impressao","u_WordAut()",0,2},;
{"Legenda","u_LegendSZM()",0,4}}
Private aCores := {{'ZM_IMPRESS == "1"' ,'BR_VERDE'},{'ZM_IMPRESS == "2"','BR_VERMELHO'}}
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZM"
 

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)



Return


User Function LegendSZM

Local aLegenda := {{"ENABLE","Impresso"},{"DISABLE","Nใo Impresso"}}

BrwLegenda("Cadastro de Autoriza็ใo Fornecedor","Legenda",aLegenda)

Return(.t.)


/*
User Function WordAut()


Private cCod

cCod := Space(6)



@ 96,012 TO 180,370 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 022,170
@ 11,22 Say OemToAnsi("Digite o Codigo da Advertencia ou Suspensใo:")
@ 10,135 Get cCod Picture "999999"
@ 25,120 BMPBUTTON TYPE 1 ACTION WordImp(cCod)
@ 25,150 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

return()



Static Function WordImp(cCod)
*/
User Function WordAut()
Local wcFornecedor, wcCGC, wcEmissao, wcDTAutor, wcValor, wcAprova, wcCompra, wcPedido, wcAno, wcTelefone, wcDDD
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot	:= ""
Private	hWord    

//Close(oDlg)

dbSelectArea("SZM")
dbSetOrder(1)
dbSeek(xFilial("SZM") + SZM->ZM_CODIGO)

If !found()
	Alert(" Codigo nใo cadastrado!!")
	Return()
EndIf



wcFornecedor	:= Alltrim(SZM->ZM_NOMEFOR)
wcCGC			:= SZM->ZM_CGC 
wcEmissao		:= Alltrim(str(Day(SZM->ZM_EMISSAO)))  + " de " + Mes(SZM->ZM_EMISSAO)  + " de " + Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
wcDTAutor		:= Alltrim(str(Day(SZM->ZM_EMISSAO)))  + " de " + Mes(SZM->ZM_EMISSAO)  + " de " + Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
wcValor			:= Alltrim(Str(SZM->ZM_VALOR)) + " (" + Extenso(SZM->ZM_VALOR)  +  ")"
wcAprova			:= SZM->ZM_NMAPROV
wcCompra			:= SZM->ZM_NMCOMPR
wcPedido			:= SZM->ZM_PEDIDO
wcAno			:= Alltrim(Str(Ano(SZM->ZM_EMISSAO)))
wcTelefone		:= Alltrim(cValToChar(Posicione("SA2",1,xFilial("SA2")+ SZM->ZM_FORNECE + SZM->ZM_LOJA,"A2_TEL")))
wcDDD			:= Posicione("SA2",1,xFilial("SA2")+ SZM->ZM_FORNECE + SZM->ZM_LOJA,"A2_DDD")


cPathDot := "X:\AutorizacaoFor.docx"


//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot )

cPathDot := ""

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



Reclock("SZM",.F.)
SZM->ZM_DTIMP 		:= Date()
SZM->ZM_IMPRESS   := "1"
MsUnlock()


dBCloseArea("SZM")


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



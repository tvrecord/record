#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#Define STR0001 "PED COMPRA"
#Define STR0002 "- PEDIDOS DE COMPRA"
#Define STR0003 "PED VENDA"
#Define STR0004 "- PEDIDOS VENDA"
#Define STR0005 "PEDIDOS PENDENTES" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑsฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCR001   บ Autor ณ MICROSIGA VITORIA  บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Pedidos de Compra.                            บฑฑ
ฑฑบ          ณ Informacoes para o fluxo de caixa.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro - Record                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCR001


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos de Compra - Informacoes Financeiras"
Local cPict          := ""
Local titulo         := "Pedidos de Compra - Informacoes Financeiras"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Private aOrd         := {"Data Pagamento + Natureza + Pedido + Item"}/*;
                        ,"Data Entrega + Numero Pedido + Item Pedido"  ;
                        ,"Produto + Numero Pedido + Item Pedido"       ;
                        ,"Fornecedor + Numero Pedido + Item Pedido"    ;
                        ,"Natureza + Numero Pedido + Item Pedido"      }*/ 
                        
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RTCR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private cPerg		 := "RTCR01    "
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private cString      := "SC7" 
Private wnrel        := "RTCR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private dDeDatPag  //:= MV_PAR01 //Data de pagamento inicial
Private dAteDatPag //:= MV_PAR02 //Data de pagamento final                           
Private dDeDatPre  //:= MV_PAR03 //Data de entrega inicial
Private dAteDatPre //:= MV_PAR04 //Data de entrega final
Private cDeFornece //:= MV_PAR05 //Fornecedor inicial
Private cDeLoja    //:= MV_PAR06 //Loja Fornecedor inicial
Private cAteFornece//:= MV_PAR07 //Fornecedor final
Private cAteLoja   //:= MV_PAR08 //Loja Fornecedor final
Private cDeProduto //:= MV_PAR09 //Produto inicial
Private cAteProduto//:= MV_PAR10 //Produto final
Private cDeNaturez //:= MV_PAR11 //Natureza inicial
Private cAteNaturez//:= MV_PAR12 //Natureza final
Private cDeCTT     //:= MV_PAR13 //Centro de Custo inicial
Private cAteCTT    //:= MV_PAR14 //Centro de Custo final
Private nFormato   //:= MV_PAR15 //Tipo Sintetico ou analitico
Private nNatureza  //:= MV_PAR16 //Totais por natureza
Private nCTT       //:= MV_PAR17 //Totais por C.C.
Private nFornece   //:= MV_PAR18 //Totais por Fornecedor
Private nExporta   //:= MV_PAR19 //Tipo de rotina, relatorio ou excel
Private nLiberado  //:= MV_PAR20 //Pedidos liberados
Private nData      //:= MV_PAR21 //Indica se a data prevista eh ajustada

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa grupo de perguntas.                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !fRTCR001()
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//Paremtros do relatorio
dDeDatPag  := MV_PAR01 //Data de pagamento inicial
dAteDatPag := MV_PAR02 //Data de pagamento final                           
dDeDatPre  := MV_PAR03 //Data de entrega inicial
dAteDatPre := MV_PAR04 //Data de entrega final
cDeFornece := MV_PAR05 //Fornecedor inicial
cDeLoja    := MV_PAR06 //Loja Fornecedor inicial
cAteFornece:= MV_PAR07 //Fornecedor final
cAteLoja   := MV_PAR08 //Loja Fornecedor final
cDeProduto := MV_PAR09 //Produto inicial
cAteProduto:= MV_PAR10 //Produto final
cDeNaturez := MV_PAR11 //Natureza inicial
cAteNaturez:= MV_PAR12 //Natureza final
cDeCTT     := MV_PAR13 //Centro de Custo inicial
cAteCTT    := MV_PAR14 //Centro de Custo final
nFormato   := MV_PAR15 //1 - Analitico ; 2 - Sintetico
nNatureza  := MV_PAR16 //1 - Imprime totais por natureza; 2 - Nao imprime
nCTT       := MV_PAR17 //1 - Imprime totais por centro de custo; 2 - Nao imprime
nFornece   := MV_PAR18 //1 - Imprime totais por fornecedor; 2 - Nao imprime
nExporta   := MV_PAR19 //1 - Relatorio ; 2 - Exporta para excel
nLiberado  := MV_PAR20 //1 - Relatorio ; 2 - Exporta para excel
nData      := MV_PAR21 //1 - Sim ; 2 - Nao

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria arquivo de trabalho temporario.                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| If(!fRTCR002(aReturn[8]),MsgStop("Falha na criacao do arquivo temporario.","RTCR001"),Sleep(1))},"Criando arquivos de trabalho temporario...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria consulta temporaria.                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| If(!fRTCR003(aReturn[8]),MsgStop("Falha na criacao da consulta temporaria.","RTCR001"),Sleep(1))},"Criando consulta temporaria...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Preenche arquivo de trabalho                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| fRTCR004(aReturn[8])},"Preenchendo arquivos de trabalho temporarios...")


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Efetua a cricao do relatorio ou da planilha excel, de acordo com parametro.|
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| If(nExporta == 1,RunReport(Cabec1,Cabec2,Titulo,nLin,aReturn[8]),RunExcel(aReturn[8]))},"Impressao dos dados do relatorio...")
                 
//Fecha arquivos de trabalho utilizados no relatorio
ARQ1->(DbCloseArea())
ARQ2->(DbCloseArea())
ARQ3->(DbCloseArea())
ARQ4->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem)  

Local cChave := ""
Local nTotal := 0
Local nNaTTotal := 0
Local nCTTTotal := 0
Local nForTotal := 0
Local nPosTot   := 0
Local nPosTot2  := 80
Local nPosTot3  := 90

//Compoe o cabecalho do relatorio
Do Case
	Case nOrdem == 1 .and. nFormato == 1
		Cabec1 := "Pedido Item Fornecedor                         Produto                           Data     Natureza                          Centro de Custo                 Condicao                           Valor          Valor"
		Cabec2 := "                                                                                 Entrada                                                                                                       Total          Parcela"
EndCase

//Regua de processamento
SetRegua(ARQ1->(RecCount()))

nTotal := 0

//Percorre todo arquivo temporario
ARQ1->(DbGoTop())
While !ARQ1->(EOF())

   IncRegua() 
   
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   nLin := fRTCR007(nLin,0,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)  
   
   //Compoem totalizadores do relatorio
   Do Case 
		Case nOrdem == 1
			If cChave <> ARQ1->(DTOS(PAGDATA))    
				//Impressao do cabecalho por ordem
				@nLin,000 PSAY ""	
				@nLin,PCol()     PSAY "Data de pagamento: "
	   			@nLin,PCol() + 1 PSAY ARQ1->PAGDATA   
	   			
	   			nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
				
				@nLin,000 PSAY "--------------------------------------------------"		   			   

	   			nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
               
				//Compo chave de controle
				cChave := ARQ1->(DTOS(PAGDATA))
			Endif
   EndCase
   
   //Analitico
   If nFormato == 1
	   @nLin,000 PSAY ""
	   @nLin,PCol()     PSAY ARQ1->PEDNUM //Numero do pedido					
	   @nLin,PCol() + 1 PSAY ARQ1->PEDITEM //Numero do item
	   @nLin,PCol() + 1 PSAY ARQ1->CODFOR  //Codigo do fornecedor
	   @nLin,PCol() + 1 PSAY "/"
	   @nLin,PCol() + 1 PSAY ARQ1->LOJAFOR //Codigo da loja
	   @nLin,PCol() + 1 PSAY "-"
	   @nLin,PCol() + 1 PSAY Left(ARQ1->NOMEFOR,20) //Nome do fornecedor
	   @nLin,PCol() + 1 PSAY ARQ1->CODPRO  //Codigo do produto
	   @nLin,PCol() + 1 PSAY "-"
	   @nLin,PCol() + 1 PSAY Left(ARQ1->DESCPRO,20)  //Decricao do produto
	   @nLin,PCol() + 1 PSAY DTOC(ARQ1->PREDATA)     //Data prevista
	   @nLin,PCol() + 1 PSAY fRTCR006(ARQ1->CODNAT)  //Codigo da natureza
	   @nLin,PCol() + 1 PSAY "-"   
	   @nLin,PCol() + 1 PSAY Left(ARQ1->DESCNAT,20)  //Descricao da natureza
	   @nLin,PCol() + 1 PSAY Mascara(ARQ1->CODCTT)   //Codigo do Centro de Custo
	   @nLin,PCol() + 1 PSAY "-"
	   @nLin,PCol() + 1 PSAY Left(ARQ1->DESCCTT,20)  //Descricao do Centro de Custo
	   @nLin,PCol() + 1 PSAY ARQ1->CODCND  //Codigo da Natureza
	   @nLin,PCol() + 1 PSAY "-"
	   @nLin,PCol() + 1 PSAY ARQ1->DESCCND //Descricao da Natureza
	   @nLin,PCol() + 1 PSAY PadR(ARQ1->PARCELA,5) //Parcela da venda
	   @nLin,PCol() + 1 PSAY Transform(ARQ1->TOTAL ,"@E 999,999,999.99") //Total do item
	   @nLin,PCol() + 1 PSAY Transform(ARQ1->TITULO,"@E 999,999,999.99") //Total da parcela    
	   
	   nPosTot := PCol() //controle da ultima coluna de impressao
	   
	   nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	Endif	   
   
   //Controle dos totalizadores
   nTotal += ARQ1->TITULO
   
   ARQ1->(DbSkip()) // Avanca o ponteiro do registro no arquivo
   
  //Compoem totalizadores do relatorio
  Do Case 
		Case nOrdem == 1
			If cChave <> ARQ1->(DTOS(PAGDATA))    
                
            	//Ajusta alinhamento quanto nao eh sintetico
            	If nFormato == 1
	            	
	           		nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
               
    	           @nLin,000 PSAY ""
			       @nLin,nPosTot - 35 PSAY "Total na data: " 
				   @nLin,nPosTot - 14 PSAY Transform(nTotal,"@E 999,999,999.99") 
			   
			   		nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
            	Endif   
            	
            	//Totais por natureza
            	If nNatureza == 1
					
					nNatTotal := 0
					
					nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	
	            	@nLin,010 PSAY "Totais por Natureza:" 
	            	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	
	            	@nLin,010 PSAY "--------------------"  
	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	              	
	              	If ARQ2->(DbSeek(cChave))
		              	While !ARQ2->(EOF()) .and. DTOS(ARQ2->PAGDATA) == cChave
	              	    
						   @nLin,010 PSAY ""
						   @nLin,PCol()     PSAY fRTCR006(ARQ2->CODNAT)
						   @nLin,PCol() + 1 PSAY "-"
						   @nLin,PCol() + 1 PSAY Padr(ARQ2->DESCNAT,40)             		
						   @nLin,nPosTot2   PSAY Transform(ARQ2->TITULO,"@E 999,999,999.99") 
					       
					   	   nNatTotal += ARQ2->TITULO				           
				           
				           nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            
	                   		ARQ2->(DbSkip())
	              		EndDo
	              		
	              		@nLin,nPosTot3 PSAY Transform(nNatTotal,"@E 999,999,999.99") 
	            		nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	Endif
	           	Endif
	           	
	           	//Totais por centro de custo
            	If nCTT == 1
	            	
	            	nCTTTotal := 0
	            	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao

	            	@nLin,010 PSAY "Totais por Centro de Custo:" 
	            	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	
	            	@nLin,010 PSAY "---------------------------"  
	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	              	
	              	If ARQ3->(DbSeek(cChave))
		              	While !ARQ3->(EOF()) .and. DTOS(ARQ3->PAGDATA) == cChave
	              	    
						   @nLin,010 PSAY ""
						   @nLin,PCol()     PSAY Mascara(ARQ3->CODCTT)
						   @nLin,PCol() + 1 PSAY "-"
						   @nLin,PCol() + 1 PSAY Padr(ARQ3->DESCCTT,40)              		
						   @nLin,nPosTot2   PSAY Transform(ARQ3->TITULO,"@E 999,999,999.99") 
					       
                           nCTTTotal += ARQ3->TITULO
		
				           nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            
	                   		ARQ3->(DbSkip())
	              		EndDo
        			    
        			    @nLin,nPosTot3 PSAY Transform(nCTTTotal,"@E 999,999,999.99") 
	            		nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao

	            	Endif
	           	Endif
	           	
	           	//Totais por fornecedor
            	If nFornece == 1
					
					nForTotal := 0
					
					nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	
	            	@nLin,010 PSAY "Totais por Fornecedor:" 
	            	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	
	            	@nLin,010 PSAY "----------------------"  
	
	            	nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	              	
	              	If ARQ4->(DbSeek(cChave))
		              	While !ARQ4->(EOF()) .and. DTOS(ARQ4->PAGDATA) == cChave
	              	    
						   @nLin,010 PSAY ""
						   @nLin,PCol()     PSAY ARQ4->CODFOR + "/" + ARQ4->LOJAFOR
						   @nLin,PCol() + 1 PSAY "-"
						   @nLin,PCol() + 1 PSAY Padr(ARQ4->NOMEFOR,40)             		
						   @nLin,nPosTot2   PSAY Transform(ARQ4->TITULO,"@E 999,999,999.99") 
					       
					   	   nForTotal += ARQ4->TITULO				           
				           
				           nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            
	                   		ARQ4->(DbSkip())
	              		EndDo
	              		
	              		@nLin,nPosTot3 PSAY Transform(nForTotal,"@E 999,999,999.99") 
	            		nLin := fRTCR007(nLin,1,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
	            	Endif
	           	Endif
			
		   	   nLin := fRTCR007(nLin,2,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) // Avanca a linha de impressao
			   nTotal := 0
		   Endif
	EndCase
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNEXCEL  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Efetua exportacao dos dados do relatorio para excel.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunExcel(nOrdem)  

Local cChave := ""
Local nTotal := 0
Local nNaTTotal := 0
Local nCTTTotal := 0
Local nForTotal := 0
Local aCampos   := {}		//Campos de controle para exportacao para exel
Local BRANCO    := Space(1)
Local f			:= 0     

//Aviso quanto ao uso do Excel
MsgInfo("Antes de executar a rotina, feche o aplicativo 'Excel'." ;
		+ Chr(13) + Chr(10) ;
		+"Outras planilhas abertas poderao ser perdidas.";
		+ Chr(13) + Chr(10),"RTCR001")


//Compoe o cabecalho do relatorio
Do Case
	Case nOrdem == 1 .and. nFormato == 1
		
		AADD(aCampos,{"PEDIDO","ITEM","FORNECEDOR","LOJA","NOME FORNECEDOR","PRODUTO","DESCRICAO","DATA ENTRADA","NATUREZA","DESCRICAO NATUREZA","CENTRO DE CUSTO","DESCRICAO C.C.","CONDICAO","DESCRICAO","PARCELA","VALOR TOTAL","VALOR PARCELA"})		       
EndCase

SetRegua(ARQ1->(RecCount()))

nTotal := 0
ARQ1->(DbGoTop())
While !ARQ1->(EOF())
    
    IncRegua()
    
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If lAbortPrint
      Exit
   Endif

   //Compoem totalizadores do relatorio
   Do Case 
		Case nOrdem == 1
			If cChave <> ARQ1->(DTOS(PAGDATA))    
				//Impressao do cabecalho por ordem
				
				AADD(aCampos,{BRANCO            ,BRANCO             ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				//Linha em branco
				AADD(aCampos,{"Data Pagamento:" ,DTOC(ARQ1->PAGDATA),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				//Linha em branco
	       	    AADD(aCampos,{BRANCO            ,BRANCO             ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				//Compo chave de controle
				
				cChave := ARQ1->(DTOS(PAGDATA))
			Endif
   EndCase
   
   //Analitico
   If nFormato == 1

   		AADD(aCampos,{ARQ1->PEDNUM ;
   		             ,ARQ1->PEDITEM;
   		             ,ARQ1->CODFOR ;
   		             ,ARQ1->LOJAFOR;
   		             ,ARQ1->NOMEFOR;
   		             ,ARQ1->CODPRO ;
   		             ,ARQ1->DESCPRO;
   		             ,DTOC(ARQ1->PREDATA);
   		             ,fRTCR006(ARQ1->CODNAT);
   		             ,ARQ1->DESCNAT;
   		             ,Mascara(ARQ1->CODCTT);
   		             ,ARQ1->DESCCTT;
   		             ,ARQ1->CODCND;
   		             ,ARQ1->DESCCND;
   		             ,ARQ1->PARCELA;
   		             ,Transform(ARQ1->TOTAL ,"@E 999,999,999.99");
   		             ,Transform(ARQ1->TITULO,"@E 999,999,999.99")})
   Endif	   
   
   //Controle dos totalizadores
   nTotal += ARQ1->TITULO
   
   ARQ1->(DbSkip()) // Avanca o ponteiro do registro no arquivo
   
  //Compoem totalizadores do relatorio
  Do Case 
		Case nOrdem == 1
			If cChave <> ARQ1->(DTOS(PAGDATA))    
                
            	//Ajusta alinhamento quanto nao eh sintetico
            	If nFormato == 1
	            
					AADD(aCampos,{BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,"Total Data",Transform(nTotal,"@E 999,999,999.99")})				
					AADD(aCampos,{BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO      ,BRANCO                                })				
            	Endif   
            	
            	//Totais por natureza
            	If nNatureza == 1
					
					nNatTotal := 0
					
					AADD(aCampos,{BRANCO,BRANCO,BRANCO                 ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
					AADD(aCampos,{BRANCO,BRANCO,"Totais por Natureza:" ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
	                         	
	              	If ARQ2->(DbSeek(cChave))
		              	While !ARQ2->(EOF()) .and. DTOS(ARQ2->PAGDATA) == cChave
	              	       
							AADD(aCampos,{BRANCO,BRANCO,fRTCR006(ARQ2->CODNAT),ARQ2->DESCNAT,Transform(ARQ2->TITULO,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    	
					       
					   	    nNatTotal += ARQ2->TITULO				           
				          	            
	                   		ARQ2->(DbSkip())
	              		EndDo
	              		
	              		AADD(aCampos,{BRANCO,BRANCO,BRANCO,BRANCO,Transform(nNatTotal,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    	
	            	Endif
	           	Endif
	           	
	           	//Totais por centro de custo
            	If nCTT == 1
	            	
	            	nCTTTotal := 0
	            	
	            	AADD(aCampos,{BRANCO,BRANCO,BRANCO                        ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
					AADD(aCampos,{BRANCO,BRANCO,"Totais por Centro de Custo:" ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
	              	
	              	If ARQ3->(DbSeek(cChave))
		              	While !ARQ3->(EOF()) .and. DTOS(ARQ3->PAGDATA) == cChave
							
							AADD(aCampos,{BRANCO,BRANCO,Mascara(ARQ3->CODCTT),ARQ3->DESCCTT,Transform(ARQ3->TITULO,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    		              	    
					       
                           nCTTTotal += ARQ3->TITULO
			            
	                   		ARQ3->(DbSkip())
	              		EndDo
        			    
						AADD(aCampos,{BRANCO,BRANCO,BRANCO,BRANCO,Transform(nCTTTotal,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    		              	    
	            	Endif
	           	Endif
	           	
	           	//Totais por fornecedor
            	If nFornece == 1
					
					nForTotal := 0
					
	            	AADD(aCampos,{BRANCO,BRANCO,BRANCO                   ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
					AADD(aCampos,{BRANCO,BRANCO,"Totais por Fornecedor:" ,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})				
	              	                                                                              
	              	
	              	If ARQ4->(DbSeek(cChave))
		              	While !ARQ4->(EOF()) .and. DTOS(ARQ4->PAGDATA) == cChave
							
							AADD(aCampos,{BRANCO,BRANCO,ARQ4->CODFOR + "/" + ARQ4->LOJAFOR,ARQ4->NOMEFOR,Transform(ARQ4->TITULO,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    		              	    	              	    
					       
					   	   nForTotal += ARQ4->TITULO				           
	            
	                   		ARQ4->(DbSkip())
	              		EndDo
						
						AADD(aCampos,{BRANCO,BRANCO,BRANCO,BRANCO,Transform(nForTotal,"@E 999,999,999.99"),BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO,BRANCO})					              	    		              	    	              		
	            	Endif
	           	Endif
		   		nTotal := 0
		   Endif
	EndCase
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria planilha e exporta dados para o excel                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| fRTCR008(aCampos)},"Exportando para o Excel...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR001  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Cria grupo de perguntas                                    บฑฑ
ฑฑบ          ณ Executa os parametros da rotina                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet -> indica correta criacao do arquivo temporario        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fRTCR001()

Local lRet     := .F.
Local aHelpPor := {}		      //Array contendo help da pergunta

/*
//PutSx1(cGrupo,cOrdem,cPergunta,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)

//Cliente de ?
AADD(aHelpPor,"Indique o cliente incial a   ")
AADD(aHelpPor,"ser considerado pela rotina. ")

PutSx1("STCA030","01","Cliente de ?","a","a","MV_CH0","C",6,0,0,"G","","SA1","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,{},{},"")
*/

lRet := Pergunte(cPerg)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR002  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Cria arquivo de trabalho temporario.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณnOrdem -> indica ordem selecionada                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet -> indica correta criacao do arquivo temporario        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fRTCR002(nOrdem)

Local lRet		:= .F.
Local aCampos	:= {}
Local cArqTmp   := ""
Local aAlias    := {"ARQ1","ARQ2","ARQ3","ARQ4"}

SetRegua(Len(aAlias))

////////////////////////////////////////////////////////
// Cria arquivo de trabalho para o controle dos itens //
////////////////////////////////////////////////////////

//Campos a serem utilizados como base da estrutura
aCampos :=	{{"PAGDATA", "D" , 08,0},;
			 {"PEDNUM" , "C" , 06,0},;
			 {"PEDITEM", "C" , 04,0},;
			 {"PREDATA", "D" , 08,0},;
			 {"PARCELA", "C" , 05,0},;
			 {"CODNAT" , "C" , 10,0},;
			 {"DESCNAT", "C" , 30,0},;
			 {"CODCTT" , "C" , 09,0},;
			 {"DESCCTT", "C" , 40,0},;
			 {"CODFOR" , "C" , 06,0},;
			 {"LOJAFOR", "C" , 02,0},;
			 {"NOMEFOR", "C" , 30,0},;
			 {"CODPRO" , "C" , 10,0},;
			 {"DESCPRO", "C" , 30,0},;
			 {"CODCND" , "C" , 03,0},;
			 {"DESCCND", "C" , 15,0},;
			 {"QUANT"  , "N" , 12,2},;
			 {"TITULO" , "N" , 14,2},;
			 {"PRECO"  , "N" , 14,2},;
			 {"TOTAL"  , "N" , 14,2}}

//Verifica se o alias temporario estah em uso
If chkfile("ARQ1")
	dbselectArea("ARQ1")
	dbCloseArea()
EndIf

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea(.T.,__LocalDriver,cArqTmp,"ARQ1",.T.)

//Verifica a ordem a ser criada >>> {"Data Pagamento + Numero Pedido + Item Pedido",""Data Entrega + Numero Pedido + Item Pedido"","Produto + Numero Pedido + Item Pedido","Fornecedor + Numero Pedido + Item Pedido","Natureza + Numero Pedido + Item Pedido"}
Do Case
	
	//Ordem "Data Pagamento + Numero Pedido + Item Pedido"
	Case nOrdem == 1	
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ1",cArqTmp,"DTOS(PAGDATA)+CODNAT+PEDNUM+PEDITEM",,,OemToAnsi("Criando indice temporario..."))  

	//Ordem "Data Entrega + Numero Pedido + Item Pedido"
	Case nOrdem == 2
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ1",cArqTmp,"DTOS(PREDATA)+PEDNUM+PEDITEM",,,OemToAnsi("Criando indice temporario..."))  

	//Ordem "Produto + Numero Pedido + Item Pedido"
	Case nOrdem == 3
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ1",cArqTmp,"CODPRO+PEDNUM+PEDITEM",,,OemToAnsi("Criando indice temporario..."))  		 
		
	//Ordem "Fornecedor + Numero Pedido + Item Pedido"
	Case nOrdem == 4
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ1",cArqTmp,"CODFOR+PEDNUM+PEDITEM",,,OemToAnsi("Criando indice temporario..."))  			

	//Ordem "Natureza + Numero Pedido + Item Pedido"
	Case nOrdem == 5
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ1",cArqTmp,"CODNAT+PEDNUM+PEDITEM",,,OemToAnsi("Criando indice temporario..."))  				

EndCase

//Confirma criacao do arquivo temporario
If chkfile("ARQ1")
	IncRegua()
	lRet := .T.
Else
	lRet := .F.
	MsgStop("Falha na criacao do arquivo de trabalho temporario.","RTCR001")
	Return lRet
Endif


///////////////////////////////////////////////////////////////////////
// Cria arquivo de trabalho para o controle dos totais por naturezas //
///////////////////////////////////////////////////////////////////////

//Campos a serem utilizados como base da estrutura
aCampos :=	{{"PAGDATA", "D" , 08,0},;
			 {"CODNAT" , "C" , 10,0},;
			 {"DESCNAT", "C" , 30,0},;
			 {"TITULO" , "N" , 14,2}}

//Verifica se o alias temporario estah em uso
If chkfile("ARQ2")
	dbselectArea("ARQ2")
	dbCloseArea()
EndIf

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea(.T.,__LocalDriver,cArqTmp,"ARQ2",.T.)

//Verifica a ordem a ser criada >>> {"Data Pagamento + Numero Pedido + Item Pedido",""Data Entrega + Numero Pedido + Item Pedido"","Produto + Numero Pedido + Item Pedido","Fornecedor + Numero Pedido + Item Pedido","Natureza + Numero Pedido + Item Pedido"}
Do Case
	
	//Ordem "Data Pagamento + Numero Pedido + Item Pedido"
	Case nOrdem == 1	
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ2",cArqTmp,"DTOS(PAGDATA)+CODNAT",,,OemToAnsi("Criando indice temporario..."))  
EndCase

//Confirma criacao do arquivo temporario
If chkfile("ARQ2")
	IncRegua()
	lRet := .T.
Else
	lRet := .F.
	MsgStop("Falha na criacao do arquivo de trabalho temporario.","RTCR001")
	Return lRet
Endif

/////////////////////////////////////////////////////////////////////////////
// Cria arquivo de trabalho para o controle dos totais por Centro de Custo //
/////////////////////////////////////////////////////////////////////////////

//Campos a serem utilizados como base da estrutura
aCampos :=	{{"PAGDATA", "D" , 08,0},;
			 {"CODCTT" , "C" , 09,0},;
			 {"DESCCTT", "C" , 40,0},;
			 {"TITULO" , "N" , 14,2}}

//Verifica se o alias temporario estah em uso
If chkfile("ARQ3")
	dbselectArea("ARQ3")
	dbCloseArea()
EndIf

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea(.T.,__LocalDriver,cArqTmp,"ARQ3",.T.)

//Verifica a ordem a ser criada >>> {"Data Pagamento + Numero Pedido + Item Pedido",""Data Entrega + Numero Pedido + Item Pedido"","Produto + Numero Pedido + Item Pedido","Fornecedor + Numero Pedido + Item Pedido","Natureza + Numero Pedido + Item Pedido"}
Do Case
	
	//Ordem "Data Pagamento + Numero Pedido + Item Pedido"
	Case nOrdem == 1	
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ3",cArqTmp,"DTOS(PAGDATA)+CODCTT",,,OemToAnsi("Criando indice temporario..."))  
EndCase

//Confirma criacao do arquivo temporario
If chkfile("ARQ3")
	IncRegua()
	lRet := .T.
Else
	lRet := .F.
	MsgStop("Falha na criacao do arquivo de trabalho temporario.","RTCR001")
	Return lRet
Endif

////////////////////////////////////////////////////////////////////////
// Cria arquivo de trabalho para o controle dos totais por Fornecedor //
////////////////////////////////////////////////////////////////////////

//Campos a serem utilizados como base da estrutura
aCampos :=	{{"PAGDATA", "D" , 08,0},;
			 {"CODFOR" , "C" , 06,0},;
			 {"LOJAFOR", "C" , 02,0},;
			 {"NOMEFOR", "C" , 30,0},;
			 {"TITULO" , "N" , 14,2}}

//Verifica se o alias temporario estah em uso
If chkfile("ARQ4")
	dbselectArea("ARQ4")
	dbCloseArea()
EndIf

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea(.T.,__LocalDriver,cArqTmp,"ARQ4",.T.)

//Verifica a ordem a ser criada >>> {"Data Pagamento + Numero Pedido + Item Pedido",""Data Entrega + Numero Pedido + Item Pedido"","Produto + Numero Pedido + Item Pedido","Fornecedor + Numero Pedido + Item Pedido","Natureza + Numero Pedido + Item Pedido"}
Do Case
	
	//Ordem "Data Pagamento + Numero Pedido + Item Pedido"
	Case nOrdem == 1	
		//Cria indice para arquivo temporario
		IndRegua ( "ARQ4",cArqTmp,"DTOS(PAGDATA)+CODFOR+LOJAFOR",,,OemToAnsi("Criando indice temporario..."))  
EndCase

//Confirma criacao do arquivo temporario
If chkfile("ARQ4")
	IncRegua()
	lRet := .T.
Else
	lRet := .F.
	MsgStop("Falha na criacao do arquivo de trabalho temporario.","RTCR001")
	Return lRet
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR003  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Cria consulta com os dados a serem impressos no            บฑฑ
ฑฑบ          ณ relatorio.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณnOrdem -> indica ordem selecionada                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet -> indica correta criacao do arquivo temporario        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fRTCR003(nOrdem)

Local lRet		:= .F.
Local cQRY 		:= ""                                   //Variavel de controle da consulta
Local cSC7 		:= " " + RetSqlName("SC7") + " SC7 "    //Controle do arquivo a ser utilizado na consulta
Local aAlias    := {"_SC7"}

SetRegua(Len(aAlias))

//Verifica se o alias temporario estah em uso
If chkfile("_SC7")
	dbselectArea("_SC7")
	dbCloseArea()
End If

//Monta consulta
cQRY := " SELECT * FROM " + cSC7
cQRY += " WHERE SC7.D_E_L_E_T_ =  '' "
cQRY += "   AND SC7.C7_FILIAL  =  '" + xFilial("SC7") + "' "
cQRY += "   AND SC7.C7_RESIDUO =  '' "
cQRY += "   AND SC7.C7_FLUXO   <> 'N' "
cQRY += "   AND SC7.C7_QUANT - SC7.C7_QUJE > 0 "
cQRY += "   AND SC7.C7_DATPRF  BETWEEN '" + DTOS(dDeDatPre) + "' AND '" + DTOS(dAteDatPre) + "' "
cQRY += "   AND SC7.C7_PRODUTO BETWEEN '" + cDeProduto      + "' AND '" + cAteProduto      + "' "
cQRY += "   AND SC7.C7_FORNECE BETWEEN '" + cDeFornece      + "' AND '" + cAteFornece      + "' "
cQRY += "   AND SC7.C7_LOJA    BETWEEN '" + cDeLoja         + "' AND '" + cAteLoja         + "' "
cQRY += "   AND SC7.C7_CC      BETWEEN '" + cDeCTT          + "' AND '" + cAteCTT          + "' "
If nLiberado == 1
	cQRY += "   AND SC7.C7_CONAPRO = 'L' "
Endif
cQRY += "ORDER BY SC7.C7_NUM,SC7.C7_ITEM "

//Ajusta a consulta
cQRY := ChangeQuery(cQRY)

//Cria Alias temporario para a consulta
TcQuery cQry New Alias "_SC7"

DbSelectArea("_SC7")

//Verifica se foram encontrados resultados
If Select("_SC7") > 0
	IncRegua()
	lRet := .T.
Else
	MsgStop("Falha na criacao da consulta temporaria.","RTCR001")
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR004  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Preenche arquivo de trabalho com os dados resultantes      บฑฑ
ฑฑบ          ณ da consulta temporaria                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณnOrdem -> indica ordem selecionada                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fRTCR004(nOrdem)

SF4->(DbSetOrder(1)) 
_SC7->(DbGoTop())

SetRegua(_SC7->(RecCount()))

//Percorre todo _SC7
While !_SC7->(Eof())
	
	IncRegua()
	
	// Se TES nao gera duplicata, despreza o registro
	If SF4->(DBSEEK(xFilial("SF4")+_SC7->C7_TES)) ;
		.AND. SF4->F4_DUPLIC == "N"
		
		_SC7->(DbSkip())
		Loop
	Endif
					
	//Calcula valor do item
	nValor := _SC7->(C7_PRECO *(C7_QUANT-C7_QUJE) * (1+C7_IPI/100))
	
	If nValor > 0
		
		//Verifica se o Pedido tem Solicitacao de Compras
		If	!Empty(_SC7->C7_NUMSC)

			//Pesquisa a Solicitacao de Compras do Pedido de Compras
			SC1->(DbSetOrder(1))	//C1_FILIAL+C1_NUM+C1_ITEM                                                                                                                                        
			If SC1->(DbSeek(xFilial("SC1")+_SC7->(C7_NUMSC+C7_ITEMSC)))
				
				//Verifica Natureza parametrizada
				If SC1->C1_NATUREZ < cDeNaturez .or. SC1->C1_NATUREZ > cAteNaturez  						
					_SC7->(DbSkip())
					Loop
				Endif	
	
				//Verifica se a Solicitacao tem Natureza
				If !Empty(SC1->C1_NATUREZ)
				   					
					//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
					fRTCR005({SC1->C1_NATUREZ,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dDataBase}) 
				
				//Pedido sem Natureza vinculada, sera vinculado ao item "Ped Compra" (STR0001)
				Else
				
					//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
					fRTCR005({STR0001,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dDataBase})                 
						
				Endif
			Endif

		//Pedido sem Natureza vinculada, sera vinculado ao item "Ped Compra" (STR0001)
		Else
			
			//Verifica Natureza parametrizada, caso primeira natureza nao seja "          " (branco)
			If Empty(cDeNaturez)
						
				_SC7->(DbSkip())
				Loop
			Endif	
		
			//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
			fRTCR005({STR0001,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dDataBase})                				
		Endif
	Endif
		
	//Proximo registro
	_SC7->(DbSkip())
Enddo	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR005  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Calcula data de pagamento e grava no arquivo temporario    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณArray                                                       บฑฑ
ฑฑบ          ณ[1] - Codigo da natureza a ser avaliada                     บฑฑ
ฑฑบ          ณ[2] - Valor a ser incluido no relatorio                     บฑฑ
ฑฑบ          ณ[3] - Condicao de pagamento                                 บฑฑ
ฑฑบ          ณ[4] - Data de referencia                                    บฑฑ
ฑฑบ          ณ[5] - Tipo de Movimento E - Entrada / S - Saida             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet: T - execucao correta / F - erro na execucao           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fRTCR005(aParm)

Local cNatCalc	:= aParm[1]	  		//Natureza a ser considerada		     	
Local nNatVal	:= aParm[2]	 		//Valor a ser incluido na Natureza    	
Local cCondNat	:= aParm[3] 		//Condicao a ser considerada    	
Local dDatRef	:= STOD(aParm[4]) 	//Data de referencia (data de entrega do pedido de compra)
Local cTipoMov	:= aParm[5] 		//Tipo de Movimento E - Entrada / S - Saida               
Local aParcela	:= {}	   			//Array que recebera as parcelas simuladas
Local lRetCalc	:= .F.	   			//Retorno esperado         
Local cProDesc  := ""
Local cNatDesc  := ""
Local cCTTDesc  := ""

//Verifica valor do movimento
If nNatVal > 0
	
	//Avalia a data a ser considerada, 1 - Ajusta data; 2 - nao ajusta
	If nData == 1 
		dDatRef	:= IIf(dDatRef < dDataBase,dDataBase,dDatRef)
	Endif

	//Gera simulacao para entrada do Pedido de Compra no Fluxo de Caixa
	aParcela := Condicao ( nNatVal,cCondNat,0,dDatRef)
	
	//Inclui simulacao no arquivo de trabalho que controla a impressao do relatorio
	For nX := 1 to Len(aParcela)
		
		//Verifica se a data de pagamento estah dentro dos parametros iniciais do relatorio
		If DataValida(aParcela[nX][1],.T.) >= dDeDatPag .and. DataValida(aParcela[nX][1],.T.) <= dAteDatPag			
			
			//Carrega descricoes
			cForNome  := Posicione("SA2",1,xFilial("SA2")+_SC7->C7_FORNECE+_SC7->C7_LOJA,"A2_NREDUZ")
			cNatDesc  := Posicione("SED",1,xFilial("SED")+cNatCalc,"ED_DESCRIC")
			cCTTDesc  := Posicione("CTT",1,xFilial("CTT")+_SC7->C7_CC,"CTT_DESC01")
			cCNDDesc  := Posicione("SE4",1,xFilial("SE4")+_SC7->C7_COND,"E4_DESCRI")

			RecLock("ARQ1",.T.)
				ARQ1->PEDNUM  := _SC7->C7_NUM
				ARQ1->PEDITEM := _SC7->C7_ITEM
				ARQ1->PREDATA := dDatRef
				ARQ1->CODNAT  := cNatCalc
				ARQ1->DESCNAT := cNatDesc
				ARQ1->CODCTT  := _SC7->C7_CC
				ARQ1->DESCCTT := cCTTDesc
				ARQ1->CODFOR  := _SC7->C7_FORNECE
				ARQ1->LOJAFOR := _SC7->C7_LOJA
				ARQ1->NOMEFOR := cForNome
				ARQ1->CODPRO  := _SC7->C7_PRODUTO
				ARQ1->DESCPRO := _SC7->C7_DESCRI
				ARQ1->QUANT   := _SC7->C7_QUANT
				ARQ1->PRECO   := _SC7->C7_PRECO
				ARQ1->TOTAL   := _SC7->C7_TOTAL
				ARQ1->CODCND  := _SC7->C7_COND
				ARQ1->DESCCND := cCNDDesc
				ARQ1->PARCELA := Alltrim(Str(nx))+"|"+Alltrim(Str(Len(aParcela)))
				ARQ1->PAGDATA := DataValida(aParcela[nX][1],.T.)			
				ARQ1->TITULO  := xMoeda(aParcela[nX][2],1,1)
			MsUnlock()
			
			//Gravacao do arquivo de totalizadores
			//Naturezas
			If ARQ2->(DbSeek(DTOS(DataValida(aParcela[nX][1],.T.))+cNatCalc))
				Reclock("ARQ2",.F.)
					ARQ2->TITULO  += xMoeda(aParcela[nX][2],1,1)
				MsUnlock()
				
			Else
				Reclock("ARQ2",.T.)
					ARQ2->PAGDATA := DataValida(aParcela[nX][1],.T.)
					ARQ2->TITULO  := xMoeda(aParcela[nX][2],1,1)
					ARQ2->CODNAT  := cNatCalc
					ARQ2->DESCNAT := cNatDesc
				MsUnlock()
			Endif
			//Centro de Custos			
			If ARQ3->(DbSeek(DTOS(DataValida(aParcela[nX][1],.T.))+_SC7->C7_CC))
				Reclock("ARQ3",.F.)
					ARQ3->TITULO  += xMoeda(aParcela[nX][2],1,1)
				MsUnlock()
				
			Else
				Reclock("ARQ3",.T.)
					ARQ3->PAGDATA := DataValida(aParcela[nX][1],.T.)
					ARQ3->TITULO  := xMoeda(aParcela[nX][2],1,1)
					ARQ3->CODCTT  := _SC7->C7_CC
					ARQ3->DESCCTT := cCTTDesc
				MsUnlock()
			Endif
			//Fornecedor
			If ARQ4->(DbSeek(DTOS(DataValida(aParcela[nX][1],.T.))+_SC7->C7_FORNECE+_SC7->C7_LOJA))
				Reclock("ARQ4",.F.)
					ARQ4->TITULO  += xMoeda(aParcela[nX][2],1,1)
				MsUnlock()
				
			Else
				Reclock("ARQ4",.T.)
					ARQ4->PAGDATA := DataValida(aParcela[nX][1],.T.)
					ARQ4->TITULO  := xMoeda(aParcela[nX][2],1,1)
					ARQ4->CODFOR  := _SC7->C7_FORNECE
					ARQ4->LOJAFOR := _SC7->C7_LOJA
					ARQ4->NOMEFOR := cForNome
				MsUnlock()
			Endif
		Endif
	Next
EndIf

Return                                                                 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfRTCR006  บ Autor ณ AP6 IDE            บ Data ณ  05/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Carrega mascara da natureza                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RTCR001                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParmetros ณcCodigoNatureza                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณcCodigoNatureza                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fRTCR006(cCodAlt)

Local nCod := Len(SED->ED_CODIGO) //Carrega o tamanho do codigo da Natureza

//Verifica se a natureza nao eh "virtual"  STR0001 / STR0003 (criadas apenas no arquivo temporario _SED)
If	Padr(cCodAlt,nCod) <> Padr(STR0001,nCod) ;
	.and. Padr(cCodAlt,nCod) <> Padr(STR0003,nCod)
	
	cCodAlt := Mascnat(cCodAlt)
Endif
	
Return cCodAlt

Static Function fRTCR007(nImp,nAdc,Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

   
   nImp := nImp + nAdc

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If nImp > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nImp := 10
   Endif

Return nImp






Static Function fRTCR008(aDados)

LOCAL cDirDocs	:= MsDocPath()						//Carrega diretorio onde o arquivo sera gravado 
Local cArquivo 	:= CriaTrab(,.F.)					//Arquivo temporario
Local cPath		:= AllTrim(GetTempPath())			//Diretorio temporario
Local cCrLf 	:= Chr(13) + Chr(10)    			//Fim da linha
Local oExcelApp 									//Objeto da planilha excel
Local nHandle										
Local x,y

SetRegua(Len(aDados)+1)

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

IncRegua()

If nHandle > 0
	
	///////////////////////////////////
	// Grava o cabecalho da planilha //
	///////////////////////////////////
	
	For x:= 1 To Len(aDados)
	    
		For y:= 1 To Len(aDados[x])

			fWrite(nHandle,aDados[x][y]+";" )
		Next y
		fWrite(nHandle, cCrLf ) // Pula linha
		
		IncRegua()
	Next x
			
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert("MsExcel nao instalado")
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	//Tempo para processamento do excel
	MsAguarde({||Sleep(2000)},"RTCR001","Processando planilha...")
	
	//Forca que o usuario salve a planilha
	MsgInfo('Utilize a opcao "salvar como" para gravar a planilha.',"RTCR001")
	oExcelApp:Quit()
	oExcelApp:Destroy()
Else
	MsgAlert("Falha na cria็ใo do arquivo") 
Endif	

Return
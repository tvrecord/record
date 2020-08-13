#INCLUDE "rwmake.ch"
#INCLUDE "protheus.CH"
#include "font.ch"
#INCLUDE "Topconn.ch"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

User Function REQSERV

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFORPPP    บAutor  ณBruno Alves         บ Data ณ  20/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFormulario entregue ao funcionario para efetuar uma consultaบฑฑ
ฑฑบ          ณna Samdel                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Local aOrd         := {}
Local aPergs       := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Lista de Pendencias"
Local cPict        := ""
Local titulo       := "Requisi็ใo"
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.

Private cPedido    := ""
Private nTipo      := 18
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CCI301" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE nLin       := 80
Private CbTxt      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private Tamanho    := "G"
Private nomeprog   := "REQSERV"
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cString    := ""
Private cPerg      := "SERVREQ1"
Private cQuery	   := ""
private cHistFunc := ""

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

cQuery := "SELECT C7_NUM,C7_NUMCOT,C7_NUMSC,C7_EMISSAO,C7_PRODUTO,B1_DESC,C7_FORNECE,A2_LOJA,A2_NOME,C7_PRECO,C7_TOTAL,C7_QUANT,ZL_NOMESOL,E4_CODIGO,E4_DESCRI,CTT_CUSTO,CTT_DESC01,ZL_TIPREQ,"
cQuery += "(SELECT SUM(C7_TOTAL) FROM SC7010 WHERE C7_NUM = '" + (MV_PAR01) + "') AS TOTAL,"
cQuery += "(SELECT SUM(C7_VLDESC) FROM SC7010 WHERE C7_NUM = '" + (MV_PAR01) + "') AS DESCONTO,"
cQuery += "(SELECT SUM(C7_VALIPI) FROM SC7010 WHERE C7_NUM = '" + (MV_PAR01) + "') AS IPI,"
cQuery += "(SELECT SUM(C7_VALFRE) FROM SC7010 WHERE C7_NUM = '" + (MV_PAR01) + "') AS FRETE,"
cQuery += "ZL_OBJETIV FROM SC7010 "
cQuery += "INNER JOIN SE4010  ON "
cQuery += "E4_CODIGO = C7_COND "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "C7_FORNECE = A2_COD AND "
cQuery += "C7_LOJA = A2_LOJA "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = C7_PRODUTO "
cQuery += "INNER JOIN CTT010 ON "
cQuery += "CTT_FILIAL = C7_FILIAL AND "
cQuery += "CTT_CUSTO = C7_CC "
cQuery += "INNER JOIN SZL010 ON "
cQuery += "ZL_COTACAO = C7_NUMCOT "
cQuery += "WHERE "
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SE4010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' AND "
cQuery += "SZL010.D_E_L_E_T_ <> '*' AND "
cQuery += "C7_NUM = '" + (MV_PAR01) + "' "
cQuery += "ORDER BY C7_ITEM "

tcQuery cQuery New Alias "PEND"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("PEND")
	dbCloseArea("PEND")
	Return
Endif

DBSelectArea("SZL")
DBSetorder(1)
DBSeek(xFilial("SZL") + alltrim(PEND->C7_NUMCOT))

cHistFunc := SZL->ZL_JUSTIFI

DBSelectArea("SZL")
DBCloseArea("SZL")

dbSelectArea("PEND")

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
Private  nPag  := 1
Private cLogoTotvs		:= "\IMAGES\RECORD.BMP"
Private pOrcado 		:= 0
Private aItensImp		:= {}
Private cStatus			:= ""
Private cNecess			:= ""

//Parโmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

Private oFont7   := TFont():New("Arial",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont7p  := TFont():New("Arial",9, 5,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont12n := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont09n := TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont08n := TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
Private oFont12  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
Private oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

DBSelectArea("PEND")
DBGotop()


While !EOF()
	
	
	
	
	aAdd(aItensImp,{PEND->C7_NUM,; // 01 Numero do pedido
	DTOC(STOD(PEND->C7_EMISSAO)),; // 02 Data Emissao
	PEND->B1_DESC,; // 03 Descri็ใo do Produto
	cValtoChar(PEND->C7_QUANT),; // 04 Quantidade
	PEND->A2_NOME,; // 05 Nome do Fornecedor
	PEND->C7_PRECO,; // 06 Pre็o do produto
	PEND->C7_TOTAL,; // 07 valor total qtd * valor
	PEND->E4_DESCRI,; // 08 Descri็ใo da condi็ใo de pagamento
	PEND->ZL_NOMESOL,; // 09 Nome do solicitante
	PEND->CTT_DESC01,; // 10 Descri็ใo do Centro de custo
	PEND->TOTAL,; // 11 valor total
	PEND->ZL_OBJETIV,; //12 Objetivo
	PEND->FRETE,; // 13 FRETE
	PEND->IPI,; // 14 IPI
	PEND->DESCONTO,; // 15 DESCONTO
	POSICIONE("SZ6",1,xFilial("SZ6")+POSICIONE("SC1",1,xFilial("SC1")+PEND->C7_NUMSC,"C1_FINALID"),"Z6_DESC"),; // 16 FINALIDADE
	PEND->ZL_TIPREQ}) // 17 Tipo de Requisicao
	
	
	
	DBSelectARea("PEND")
	DBSkip()
	
	
	
	IncRegua()
	
ENDDO




oPrint:= TMSPrinter():New( "Requisi็ใo" )
oPrint:SetSize(020,297)
oPrint:SetLandscape()//SetLandscape() // ou SetPortrait()

MontaBox(aItensImp)

DBSelectARea("PEND")
DBCloseArea("PEND")

oPrint:EndPage()     // Finaliza a pagina

oPrint:Preview()     // Visualiza antes de imprimir

MS_FLUSH()

Return

Static Function MontaBox(aItens)
Private cMemoDesc
Private nMemoDesc
Private _aTxTDesc
Private cMemoObs
Private nMemoObs
Private _aTxTObs
Private _nLimDesc := 170
Private nLastLnDesc := 0
Private lOk := .T.
Private cFuncao := ""




MontaPagina()


//oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
//oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)

nLinl := 540


For i:=1 to Len(aItens)
	
	If nLinl > 1750
		nLinl := 540
		oPrint:EndPage()
		MontaPagina()
	Endif
	
	oPrint:Say (nLinl,0105,aItens[i][4]	,oFont08n)
	oPrint:Say (nLinl,0320,aItens[i][3]	,oFont08n)
	oPrint:Say (nLinl,1493,aItens[i][5]	,oFont08n)
	oPrint:Say (nLinl,2803,TRANSFORM(aItens[i][6],"@EZ 999,999,999.99"),oFont08n,100 )
	oPrint:Say (nLinl,3118,TRANSFORM(aItens[i][7],"@EZ 999,999,999.99"),oFont08n,100 )
	
	
	nLinl += 50
	
	//	oPrint:Line(0420 + nLin,075,0420 + nLin,3285) VERIFICAR
	
Next

MontaRodape()

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


Static Function MontaPagina()

Local  aCoord  := {0020, 0020, 0200,3350}
Local  aCoord1 := {0380,0020,0450,3350}



oBrush := TBrush():New(,CLR_HGRAY)

oPrint:FillRect(aCoord ,oBrush)
oPrint:FillRect(aCoord1 ,oBrush)


oPrint:StartPage()   // Inicia uma nova pแgina
/*
_______________________________________________________
CAIXA
_______________________________________________________
*/

oPrint:Box( 0020, 0020, 2415,3350)  // box do cabe็alho da empresa


/*
_____________________________________________________
IMAGENS
_____________________________________________________
*/

oPrint:SayBitmap(0020,0020,cLogoTotvs,0230,0180)//imagem da totvs


/*
____________________________________________________
BOX CABECALHO
_____________________________________________________
*/

oPrint:Box(0200,0020,0270,3350) // 1
oPrint:Box(0270,0020,0340,3350) // 2
oPrint:Box(0340,0020,0380,3350) // 3
oPrint:Box(0380,0020,0450,3350) // 4
oPrint:Box(0520,0020,0520,3350) // 4


/*
_____________________________________________________
COLUNAS CABECALHO
_____________________________________________________
*/

//1บ Cabe็alho
oPrint:Line(0200,0500,0340,0500) //1 Coluna
oPrint:Line(0200,2800,0340,2800) //2 Coluna

//2บ Cabe็alho
oPrint:Line(0450,0307,1840,0307) //1 Coluna
oPrint:Line(0450,1480,1840,1480) //1 Coluna
oPrint:Line(0450,2800,1840,2800) //1 Coluna
oPrint:Line(0450,3115,1840,3115) //1 Coluna

//Linha Rodape

oPrint:Line( 1840, 0020, 1840,3350)  // box do cabe็alho da empresa

/*
_____________________________________________________
dados do relatorio
_____________________________________________________
*/

// Cabe็alho
iF aItensImp[1][17] == "1"
	oPrint:Say (0050,1380,"Requisi็ใo de Compra",oFont24)
ElseIf aItensImp[1][17] == "2"
	oPrint:Say (0050,1380,"Requisi็ใo de Servi็o",oFont24)
ElseIf aItensImp[1][17] == "3"
	oPrint:Say (0050,0900,"Requisi็ใo de Compra - Ativo Imobilizado",oFont24)
EndIf

oPrint:Say (0220,0070,"Empresa",oFont12)
oPrint:Say (0290,0070,"Objetivo",oFont12)
oPrint:Say (0220,0550,"Rแdio e Televisใo Capital LTDA",oFont12)
oPrint:Say (0290,0550,aItensImp[1][12],oFont12)
oPrint:Say (0220,2900,"Emissใo:",oFont12)
oPrint:Say (0290,2900,"Pedido:",oFont12)
oPrint:Say (0220,3100,aItensImp[1][2],oFont12n)
oPrint:Say (0290,3100,aItensImp[1][1],oFont12n)
oPrint:Say (0395,1400,"Descri็ใo dos Itens a Serem Adquiridos",oFont12)
oPrint:Say (0465,0065,"Quantidade",oFont12)
oPrint:Say (0465,0310,"Produto",oFont12)
oPrint:Say (0465,1500,"Fornecedor",oFont12)
oPrint:Say (0465,2820,"Valor Unitแrio",oFont12)
oPrint:Say (0465,3120,"Valor Total",oFont12)

cPedido := aItensImp[1][1]

Return


Static Function MontaRodape()

Local  aCoord2 := {2140, 0020, 2210,3350}
Local  aCoord3 := {1800, 0020, 1870,3350}
Local  cQuery1  := ""
Local  lAssElen := .F.
Local  dLib01   := CTOD("//")
Local  cAprov01 := ""   
Local  lAssDir  := .F.
Local  dLib02   := CTOD("//")
Local  cAprov02 := ""


oBrush := TBrush():New(,CLR_HGRAY)

oPrint:FillRect(aCoord2 ,oBrush)
oPrint:FillRect(aCoord3 ,oBrush)

oPrint:StartPage()   // Inicia uma nova pแgina

/*
_____________________________________________________
BOX RODAPE
_____________________________________________________
*/
/*
oPrint:Box( 1800, 0020, 1870,3350)  // box do cabe็alho da empresa
oPrint:Box( 1790, 0020, 1940,3350)  // box do cabe็alho da empresa
oPrint:Box( 1940, 0020, 2010,3350)  // box do cabe็alho da empresa
oPrint:Box( 2010, 0020, 1960,3350)  // box do cabe็alho da empresa

oPrint:Box( 1960, 0020, 2210,3350)  // box do cabe็alho da empresa
oPrint:Box( 2210, 0020, 2455,3350)  // box do cabe็alho da empresa
*/

oPrint:Box( 1800, 0020, 1870,3350)  // box do cabe็alho da empresa
oPrint:Box( 1870, 0020, 1940,3350)  // box do cabe็alho da empresa
oPrint:Box( 1940, 0020, 2010,3350)  // box do cabe็alho da empresa
oPrint:Box( 2010, 0020, 2140,3350)  // box do cabe็alho da empresa

oPrint:Box( 2140, 0020, 2210,3350)  // box do cabe็alho da empresa
oPrint:Box( 2210, 0020, 2415,3350)  // box do cabe็alho da empresa

/*
_____________________________________________________
COLUNAS RODAPE
oPrint:Line(2140,0835,2415,0835) //1 Coluna
oPrint:Line(2140,1670,2415,1670) //1 Coluna
_____________________________________________________
*/
// Acima das assinaturas
oPrint:Line( 1870, 0604, 1940,0604)  // box do cabe็alho da empresa
oPrint:Line( 1940, 0327, 2010,0327)  // box do cabe็alho da empresa
oPrint:Line( 1940, 1480, 2010,1480)  // box do cabe็alho da empresa
//oPrint:Line( 1870, 1480, 2010,1480)  // box do cabe็alho da empresa

//Assinaturas - Original com assinatura do diretor
//oPrint:Line(2140,0670,2415,0670) //1 Coluna
//oPrint:Line(2140,1340,2415,1340) //1 Coluna
//oPrint:Line(2140,2010,2415,2010) //1 Coluna
//oPrint:Line(2140,2680,2415,2680) //1 Coluna

//Assinaturas - Modificado sem assinatura do diretor e controladoria lm  Rafael 03/05/2013
oPrint:Line(2140,1110,2415,1110) //1 Coluna
oPrint:Line(2140,2220,2415,2220) //1 Coluna
//oPrint:Line(2140,2505,2415,2505) //1 Coluna
//oPrint:Line(2140,2680,2415,2680) //1 Coluna

// Dados Rodap้
//__________________________________________________________________

//Titulos
oPrint:Say (1810,0080,"Frete: ",oFont12)
oPrint:Say (1810,0480,"IPI: ",oFont12)
oPrint:Say (1810,0880,"Desconto: ",oFont12)
oPrint:Say (1810,1330,"TOTAL: ",oFont12)
oPrint:Say (1810,2800,"SubTotal: ",oFont12)
oPrint:Say (1880,0080,"M้todo de Pagamento",oFont12)
oPrint:Say (1950,0080,"Solicitante",oFont12)
//oPrint:Say (1880,1500,"Finalidade:",oFont12)
oPrint:Say (1950,1500,"Centro de Custo:",oFont12)
oPrint:Say (2020,0080,"Justificativa:",oFont12)

// Informa็๕es dos titulos

oPrint:Say (1813,0200,TRANSFORM(aItensImp[1][13],"@EZ 999,999,999.99"),oFont12n,100 )
oPrint:Say (1813,0600,TRANSFORM(aItensImp[1][14],"@EZ 999,999,999.99"),oFont12n,100 )
oPrint:Say (1813,1000,TRANSFORM(aItensImp[1][15],"@EZ 999,999,999.99"),oFont12n,100 )
oPrint:Say (1813,1450,TRANSFORM(aItensImp[1][11] + aItensImp[1][13] + aItensImp[1][14] - aItensImp[1][15] ,"@EZ 999,999,999.99"),oFont12n,100 )
oPrint:Say (1813,3000,TRANSFORM(aItensImp[1][11],"@EZ 999,999,999.99"),oFont12n,100 )
oPrint:Say (1883,0630,aItensImp[1][8],oFont12n)
oPrint:Say (1953,0350,aItensImp[1][9],oFont12n)
//oPrint:Say (1883,1900,aItensImp[1][16],oFont12n)
oPrint:Say (1953,1900,aItensImp[1][16],oFont12n)


cMemoDesc := alltrim(cHistFunc)
nMemoDesc := MlCount( cMemoDesc ,_nLimDesc )
_aTxTDesc := memoFormata( cMemoDesc, _nLimDesc, nMemoDesc )


nLin := 0

For D:=1 to Len(_aTxTDesc)
	oPrint:Say(2023 + nLin,0400,Trim(_aTxtDesc[D]),oFont08n,9000,,,4,4)
	nLin += 50
Next

//Assinaturas - Modificado sem assinatura controladoria lm Rafael 10/05/2013

oPrint:Say (2160,0360,"Financeiro Solicitante",oFont12)
oPrint:Say (2160,1460,"Ger๊ncia Executiva",oFont12)
//oPrint:Say (2160,1465,"Diretor Solicitante",oFont12)
//oPrint:Say (2160,1955,"Controladoria LM",oFont12)
oPrint:Say (2160,2700,"Diretoria LM",oFont12)
oPrint:Say (2290,0260,"________________________",oFont12n)
//oPrint:Say (2290,1390,"________________________",oFont12n)
//oPrint:Say (2280,1415,"____________________",oFont12n)
oPrint:Say (2340,0410,"Eleni Caldeira (Elenn)",oFont12n) 
//oPrint:Say (2340,1460,"Artur Fernandes Dias Junior",oFont12n)
//oPrint:Say (2340,1460,"Wagner Lima",oFont12n)
//oPrint:Say (2340,1460," Josiel Ferreira",oFont12n)
//oPrint:Say (2340,1460,"Claudinei Girotti",oFont12n)
//oPrint:Say (2330,1455,"Luiz Clแudio Costa",oFont12n)

cQuery1 := ("Select * from SCR010 Where CR_FILIAL = '01' AND CR_NUM = '" + (cPedido) + "' AND CR_TIPO = 'PC' AND D_E_L_E_T_ <> '*' ORDER BY CR_NIVEL")
tcQuery cQuery1 New Alias "TMP1"

IF Eof()
	
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	
Else
	
	DBSelectArea("TMP1")
	While !EOF()
		
		If TMP1->CR_NIVEL == "01" .AND. !EMPTY(TMP1->CR_DATALIB) .AND. !EMPTY(TMP1->CR_USERLIB)
			lAssElen := .T.
			dLib01   := DTOC(STOD(TMP1->CR_DATALIB))
			cAprov01 := Posicione("SAK",1,xFilial("SAK")+TMP1->CR_APROV,"AK_NOME")
		ElseIf TMP1->CR_NIVEL == "02" .AND. EMPTY(TMP1->CR_APRORI) .AND. !EMPTY(TMP1->CR_DATALIB) .AND. !EMPTY(TMP1->CR_USERLIB)
			lAssDir  := .T.
			dLib02   := DTOC(STOD(TMP1->CR_DATALIB))
			cAprov02 := Posicione("SAK",1,xFilial("SAK")+TMP1->CR_APROV,"AK_NOME")
		EndIf
		
		DbSkip()
		
	Enddo
	
	DbSelectArea("TMP1")
	DbCloseARea("TMP1")
	
Endif


IF lAssDir == .T.
	oPrint:Say( 2230, 1250,PadC("Libera็ใo Eletr๔nica",70),oFont8,100 )
	oPrint:Say( 2280, 1250,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont8,100 )
ENDIF

IF lAssElen == .T.
	oPrint:Say( 2230, 0170,PadC("Libera็ใo Eletr๔nica",62),oFont8,100 )
	oPrint:Say( 2280, 0170,PadC(Alltrim(cAprov01) + " - Data: " + (dLib01) + "",60),oFont8,100 )
EndIf

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Pedido ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})

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
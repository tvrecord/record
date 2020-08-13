#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#include "font.ch"
#INCLUDE "protheus.CH"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransferencia บAutor  ณRafael          บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio para controle de transferencia de ativos record  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RelAutTran()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aOrd         := {}
Local aPergs       := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Lista de Transferencias"
Local cPict        := ""
Local titulo       := "Autorizacao de Transferencia"
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.

Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelAutTran" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE nLin       := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private Tamanho    := "G"
Private nomeprog   := "RelAutTran"
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cString    := "ZA1"
Private cPerg      := "AUTTRANS1"
Private cQuery	   := ""
Private cCodigo	   := ""

cCodigo := ZA1->ZA1_CODIGO

ValPerTran(cPerg)

//If !Pergunte(cPerg,.T.)
//	alert("OPERAวรO CANCELADA")
//	return
//ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
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
Local cQuery := ""
Local cEmissao := ""
Local cProcess := ""
Local cCustoSol := ""
Local cSolicit 	:= ""
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

Private oFont9  := TFont():New("Arial",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8  := TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont08n:= TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
Private oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


oPrint:= TMSPrinter():New( "Autoriza็ใo de transferencia - RECORD" )
oPrint:SetSize(210,297)
oPrint:SetPortrait()//SetLandscape() // ou SetPortrait()

//MontaBox(aItensImp)
MontaPagina()

oPrint:EndPage()     // Finaliza a pagina

oPrint:Preview()     // Visualiza antes de imprimir

MS_FLUSH()

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

Static Function MontaPagina()
Local cMemoDesc
Local nMemoDesc
Local _aTxTDesc
Local _nLimDesc := 100
Local nLastLnDesc := 0

Local aCoord := {0700,040,0780,2250}
Local aCoord1:= {1680,040,1760,2250}
Local aCoord2:= {1940,040,2020,2250}
Local aCoord3:= {2600,040,2680,2250}
Local aCoord4:= {}
Local i := 1

oBrush := TBrush():New(,CLR_HGRAY)

oPrint:FillRect(aCoord ,oBrush)
oPrint:FillRect(aCoord1,oBrush)
oPrint:FillRect(aCoord2,oBrush)
oPrint:FillRect(aCoord3,oBrush)
oPrint:FillRect(aCoord4,oBrush)
oPrint:StartPage()   // Inicia uma nova pแgina

//IMAGENS

oPrint:SayBitmap(0120,1050,cLogoTotvs,0300,0250) // Logo Record

//BOX Nบ PATRIMONIO

//Colunas
oPrint:Line (0700,0040,1580,0040)
oPrint:Line (0700,0400,1580,0400)
oPrint:Line (0700,1450,1580,1450)
oPrint:Line (0700,1850,1580,1850)
oPrint:Line (0700,2250,1580,2250)

//Linhas
oPrint:Line(0700,040,0700,2250) // Cabe็alho
oPrint:Line(0780,040,0780,2250) // 1
oPrint:Line(0860,040,0860,2250) // 2
oPrint:Line(0940,040,0940,2250) // 3
oPrint:Line(1020,040,1020,2250) // 4
oPrint:Line(1100,040,1100,2250) // 5
oPrint:Line(1180,040,1180,2250) // 6
oPrint:Line(1260,040,1260,2250) // 7
oPrint:Line(1340,040,1340,2250) // 8
oPrint:Line(1420,040,1420,2250) // 9
oPrint:Line(1500,040,1500,2250) // 10
oPrint:Line(1580,040,1580,2250) // Fim

//BOX SOLICITANTE

//Colunas
oPrint:Line(1680,0040,1840,0040)
oPrint:Line(1680,0777,1840,0777)
oPrint:Line(1680,1513,1840,1513)
oPrint:Line(1680,2250,1840,2250)
//Linhas
oPrint:Line(1680,040,1680,2250) // Cabe็alho
oPrint:Line(1760,040,1760,2250) // 1
oPrint:Line(1840,040,1840,2250) // Fim

//BOX MOTIVO

//Colunas
oPrint:Line(1940,0040,2260,0040)
oPrint:Line(1940,2250,2260,2250)
//Linhas
oPrint:Line(1940,040,1940,2250) // Cabe็alho
oPrint:Line(2020,040,2020,2250) // 1
oPrint:Line(2260,040,2260,2250) // Fim

//BOX AUTORIZAวรO

//Colunas
oPrint:Line(2600,0040,2840,0040)
oPrint:Line(2600,1165,2840,1165)
oPrint:Line(2600,2250,2840,2250)
//Linhas
oPrint:Line(2600,040,2600,2250) // Cabe็alho
oPrint:Line(2680,040,2680,2250) // 1
oPrint:Line(2840,040,2840,2250) // Fim

//DADOS DO RELATORIO

oPrint:Say (0420,0550,"AUTORIZAวรO DE MOVIMENTAวรO DE ATIVO",oFont16n)
oPrint:Say (0560,0080,"   Informamos เ Ger๊ncia Adm.-Financeira, Ger๊ncia Executiva e ao departamento de Patrimonio, que o bem abaixo descrito estแ sendo transferido para o departamento:",oFont9)
//oPrint:Say (0600,0080,"para o departamento:",oFont9)

oPrint:Say (0720,0060,"PATRIMิNIO"							,oFont12)
oPrint:Say (0720,0420,"DESCRIวรO"	    					,oFont12)
oPrint:Say (0720,1470,"CC ORIGEM"							,oFont12)
oPrint:Say (0720,1870,"CC DESTINO"	    					,oFont12)

//Dados do Relatorio  


cQuery := "SELECT ZA1_CODIGO,ZA1_EMISSA,ZA1_USUARI,ZA1_PROCES,ZA1_ADM,ZA1_EXEC,ZA1_CCSOLI,ZA1_SOLICI,  "
cQuery += "ZA2_CBASE,ZA2_ITEM,ZA2_TIPO,ZA2_DESCRI,ZA2_DESC,ZA1_CCDEST "
cQuery += "FROM ZA1010 "
cQuery += "INNER JOIN ZA2010 ON ZA1_CODIGO = ZA2_CODIGO "
cQuery += "WHERE "
cQuery += "ZA1010.D_E_L_E_T_ = '' AND "
cQuery += "ZA2010.D_E_L_E_T_ = '' AND "
cQuery += "ZA2_CODIGO = '" + cCodigo + "'" "

TCQUERY cQuery NEW ALIAS "TMP"

nLin := 800

DBSelectArea("TMP")
DBGotop()
While !EOF()
	
	oPrint:Say (nLin,0060,SUBSTR(TMP->ZA2_CBASE,1,10) 									,oFont10)
	oPrint:Say (nLin,0420,SUBSTR(TMP->ZA2_DESCRI,1,40) 									,oFont10)
	oPrint:Say (nLin,1470,SUBSTR(TMP->ZA2_DESC,1,20)									,oFont10)
	oPrint:Say (nLin,1870,SUBSTR(TMP->ZA1_CCDEST,1,20) 									,oFont10)
	
	cEmissao := TMP->ZA1_EMISSA
	cProcess := TMP->ZA1_PROCES
	cCustoSol 	:= SUBSTR(Posicione("CTT",1,xFilial("CTT")+TMP->ZA1_CCSOLI,"CTT_DESC01"),1,40)
	cSolicit 	:= TMP->ZA1_SOLICI
	
	nLin += 80
	
	DBSKIP()
ENDDO

oPrint:Say (1700,0060,"DEPTO SOLICITANTE"					,oFont12)
oPrint:Say (1700,0797,"SOLICITANTE"							,oFont12)
oPrint:Say (1700,1533,"AUTORIZADO POR"						,oFont12)
oPrint:Say (1780,0060,cCustoSol								,oFont10)
oPrint:Say (1780,0797,cSolicit								,oFont10)
oPrint:Say (1780,1533,""									,oFont10)

oPrint:Say (1960,0600,"MOTIVO DA TRANSFERสNCIA / RETIRADA"	,oFont12)

dbSelectArea("ZA1")
dbSetOrder(1)
dbSeek(xFilial("ZA1") + cCodigo)

cMemoDesc 	:= alltrim(ZA1->ZA1_MOTIVO)
nMemoDesc 	:= MlCount(cMemoDesc,_nLimDesc)
_aTxTDesc 	:= memoFormata(cMemoDesc,_nLimDesc,nMemoDesc)
nLin  		:= 0

For D:=1 to Len(_aTxTDesc)
	oPrint:Say(2040 + nLin,0060,Trim(UPPER(_aTxtDesc[D])),oFont10,9000,,,4,4)
	nLin += 80
Next  

DBSelectArea("TMP")
DBCloseArea("TMP")

oPrint:Say (2380,0600,"Brasํlia - DF, " + SUBSTR(cEmissao,7,2) + " de " + MES(STOD(cEmissao)) + " de " + SUBSTR(cEmissao,1,4),oFont12)
oPrint:Say (2500,0600,"AUTORIZAวรO DA MOVIMENTAวรO"	,oFont16n)

oPrint:Say (2620,0060,"GERสNCIA ADM./FINANCEIRA"			,oFont12)
oPrint:Say (2620,1185,"GERสNCIA EXECUTIVA"					,oFont12)

oPrint:Say (2940,0060,"DATA DE TRANSFERสNCIA NO SISTEMA:  " + DTOC(STOD(cProcess)),oFont10)
Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Codigo:","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZS"})

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

Static Function ValPerTran(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","Nบ Autoriza็ใo:","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.CH"
#include "font.ch"
#INCLUDE "Topconn.ch"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2


User Function FORPPP

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
Local titulo       := "Formulario PPP"
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.

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
Private nomeprog   := "Formulario PPP"
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cString    := ""
Private cPerg      := "FORMPP6"
Private cQuery	   := ""

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

cQuery := "SELECT RA_MAT,RA_NUMCP,RA_SERCP,RA_UFCP,RA_NOME,RA_PIS,RA_NASC,RA_ADMISSA,RA_DEMISSA,RA_CC,(SELECT RJ_DESC FROM SRJ010 WHERE D_E_L_E_T_ = '' AND RJ_FUNCAO = RA_CODFUNC) AS RA_DESCFUN FROM SRA010 "
cQuery += "WHERE "
cQuery += "RA_FILIAL = '" + (MV_PAR01) + "' "
cQuery += "AND RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' "  
cQuery += "AND RA_ADMISSA BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' "
cQuery += "AND RA_DEMISSA BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' " 
IF !Empty (MV_PAR14)
	cQuery += "AND RA_SITFOLH IN " + FormatIn(MV_PAR14,";") + " "
Endif    
IF !Empty (MV_PAR15)
	cQuery += "AND RA_CATFUNC IN " + FormatIn(MV_PAR15,";") + " "
Endif
cQuery += "AND D_E_L_E_T_ <> '*' " 
cQuery += "ORDER BY RA_MAT "

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

Private oFont7  := TFont():New("Arial",9, 9,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont7p := TFont():New("Arial",9, 5,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8  := TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont08n:= TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
Private oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

DBSelectArea("PEND")
DBGotop()

While !EOF()
		
	aAdd(aItensImp,{PEND->RA_NUMCP + " / " + PEND->RA_SERCP + " - " + PEND->RA_UFCP,;	// 1 - CTPS
	TRANSFORM(RTRIM(SM0->M0_CGC),"@R 99.999.999/9999-99"),;   	// 2 - CNPJ da Empresa
	SM0->M0_NOMECOM,;	// 3 - Nome da Empresa
	PEND->RA_NOME,;   	// 4 - Pis do Funcionario
	PEND->RA_PIS,;   	// 5 - Pis do Funcionario
	DtoC(StoD(PEND->RA_NASC)),;	// 6 - Data de Nascimento
	DtoC(StoD(PEND->RA_ADMISSA)),; 	// 7 - Data Admissใo
	PEND->RA_DEMISSA,;  // 8 - Data Demissao
	PEND->RA_MAT,; // 9 - MAtricula 
	Posicione("CTT",1,xFilial("CTT")+PEND->RA_CC,"CTT_DESC01"),; //10 - Centro de custo/Setor	
	PEND->RA_DESCFUN}) //11 - Descri็ใo Fun็ใo	
	
	DBSelectARea("PEND")
	DBSkip()	
		
	IncRegua()
	
ENDDO

DBSelectARea("PEND")
DBCloseArea("PEND")


oPrint:= TMSPrinter():New( "FORMULมRIO PPP - RECORD" )
oPrint:SetSize(210,297)
oPrint:SetLandscape()//SetLandscape() // ou SetPortrait()

MontaBox(aItensImp)

oPrint:EndPage()     // Finaliza a pagina

oPrint:Preview()     // Visualiza antes de imprimir

MS_FLUSH()

Return

Static Function MontaBox(aItens)
Local cMemoDesc
Local nMemoDesc
Local _aTxTDesc
Local cMemoObs
Local nMemoObs
Local _aTxTObs
Local _nLimDesc := 80
Local nLastLnDesc := 0
Local cHistFunc := ""
Local lOk := .T.
Local cFuncao := ""



//MontaPagina()

//oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
//oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)

nLin := 50

For i:=1 to Len(aItens)
	
	//If nLin > 1750
		oPrint:EndPage()
		MontaPagina()
		
		//		oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
		//		oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)
		
		nLin := 50
	//Endif
	
	
	
	dbSelectArea("SR7")
	dbSetOrder(1)
	dbSeek(xFilial("SR7") + aItens[i][09])
	
	
	While !EOF() .AND. SR7->R7_MAT == aItens[i][09]
		
		
		If lOk == .T.
			cHistFunc += ALLTRIM(SR7->R7_DESCFUNC) + " - " + DTOC(SR7->R7_DATA)
		EndIf
		
		If cFuncao != SR7->R7_FUNCAO .AND. lOk == .F.
			cHistFunc += + " At้ " + DTOC(SR7->R7_DATA - 1 ) + " ; " + ALLTRIM(SR7->R7_DESCFUNC)	+ " - " + DTOC(SR7->R7_DATA)
		EndIf
		
		lOk := .F.
		cFuncao := SR7->R7_FUNCAO
		
		
		dbSelectArea("SR7")
		dbSkip()
		
	EndDo
	
	If EMPTY(cHistFunc)
		//cHistFunc := "Nใo existe historico Salarial"  //13/11/2018 - Rafael Fran็a - Colocado a Pedido do Sr. Edson RH para registrar a primeira fun็ใo quando nใo houver altera็๕es de fun็ใo
		If !EMPTY(aItens[i][08])
			cHistFunc := ALLTRIM(aItens[i][11]) + " At้ " + DTOC(STOD(aItens[i][08]))
		else
			cHistFunc := ALLTRIM(aItens[i][11]) + " At้ " + DTOC(DATE())
		EndIf
	Else
		If !EMPTY(aItens[i][08])
			cHistFunc += + " At้ " + DTOC(STOD(aItens[i][08]))
		else
			cHistFunc += + " At้ " + DTOC(DATE())
		EndIf
	EndIf
	
	
	cMemoDesc := alltrim(cHistFunc)
	nMemoDesc := MlCount( cMemoDesc ,_nLimDesc )
	_aTxTDesc := memoFormata( cMemoDesc, _nLimDesc, nMemoDesc )
	
	
	
	oPrint:Say (0590 ,1450,		aItens[i][01]					,oFont7)
	oPrint:Say (0660 ,1450,		aItens[i][02] 					,oFont7)
	oPrint:Say (0730 ,1450,		aItens[i][03]					,oFont7)
	oPrint:Say (0795 ,1450,		UPPER(aItens[i][04])			,oFont12)
	oPrint:Say (0870 ,1450,		aItens[i][05]					,oFont7)
	oPrint:Say (0940 ,1450,		aItens[i][06]		,oFont7)
	oPrint:Say (1010 ,1450,		aItens[i][07]		,oFont7)
	oPrint:Say (1080 ,1450,		DTOC(STOD(aItens[i][08]))		,oFont7)
	oPrint:Say (1738 ,1450,		IIF(cValToChar(MV_PAR10) = "1","SIM","NรO")						,oFont7)
	If MV_PAR10 == 1
		If !EMPTY(MV_PAR12)
			oPrint:Say (1680 ,1700,		"Data: " + DTOC(MV_PAR13)					,oFont7)
			oPrint:Say (1730 ,1700,		"1บ Reg. INSS: " + MV_PAR11					,oFont7)
			oPrint:Say (1780 ,1700,		"2บ Reg. INSS: " + MV_PAR12					,oFont7)
		ELSE
			oPrint:Say (1700 ,1700,		"Data: " + DTOC(MV_PAR13)					,oFont7)
			oPrint:Say (1750 ,1700,		"Reg. INSS: " + MV_PAR11					,oFont7)
		EndIf
	EndIf
	oPrint:Say (1867 ,1450,		UPPER(MV_PAR08)					,oFont7)
	oPrint:Say (1942 ,1450,		UPPER(MV_PAR09)					,oFont7)
	oPrint:Say (2012 ,1450,		UPPER(aItens[i][10])			,oFont7)	
	
	
	
	nLin := 0
	For D:=1 to Len(_aTxTDesc)
		oPrint:Say(1150 + nLin,1450,Trim(UPPER(_aTxtDesc[D])),oFont7,9000,,,4,4)
		nLin += 50
	Next
	
		cHistFunc := ""
		
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


Static Function MontaPagina()
Local aCoord := {350,700,570,2900}


oBrush := TBrush():New(,CLR_HGRAY)

oPrint:FillRect(aCoord ,oBrush)

oPrint:StartPage()   // Inicia uma nova pแgina
/*
_______________________________________________________
CAIXA
_______________________________________________________
*/

oPrint:Line (0350,0450,2070,0450) //Coluna da esquerda
oPrint:Line (0350,2900,2070,2900) //Coluna da direita
oPrint:Line (0350,0450,0350,2900) //Linha de cima
oPrint:line (2070,0450,2070,2900) //Linha de baixo


/*
_____________________________________________________
IMAGENS
_____________________________________________________
*/
//               linI colI            larg alt
oPrint:SayBitmap(0380,485,cLogoTotvs,0205,180)//imagem da totvs
//oPrint:SayBitmap(0100,400,cLogoTriade,0340,185)//imagem da triade
//oPrint:SayBitmap(0100,2700,cLogoCliente,0340,200)//imagem do cliente

/*
_____________________________________________________
COLUNAS DA CABECALHO
_____________________________________________________
*/

oPrint:Line(350,700,570,700) //1 Coluna
oPrint:Line(0570,450,0570,2900) //Linha de baixo

/*
_____________________________________________________
LINHAS DA PLANILHA
_____________________________________________________
*/

oPrint:Line(0570,1380,2070,1380) //COLUNA
oPrint:Line(0640,450,0640,2900) //Linha de baixo
oPrint:Line(0710,450,0710,2900) //1 LINHA
oPrint:Line(0780,450,0780,2900) //2 LINHA
oPrint:Line(0850,450,0850,2900) //3 LINHA
oPrint:Line(0920,450,0920,2900) //4 LINHA
oPrint:Line(0990,450,0990,2900) //5 LINHA
oPrint:Line(1060,450,1060,2900) //6 LINHA
oPrint:Line(1130,450,1130,2900) //7 LINHA
oPrint:Line(1650,450,1650,2900) //9 LINHA
oPrint:Line(1850,450,1850,2900) //10 LINHA
oPrint:Line(1920,450,1920,2900) //11 LINHA
oPrint:Line(1990,450,1990,2900) //12 LINHA

//DADOS DO RELATORIO

oPrint:Say (0420,1420,"FORMULมRIO PPP",oFont24)
oPrint:Say (0582,470,"CTPS Nบ / SษRIE"						,oFont12)
oPrint:Say (0652,470,"CNPJ da Empresa"						,oFont12)
oPrint:Say (0722,470,"Razใo Social da Empresa"						,oFont12)
oPrint:Say (0792,470,"Nome do Funcionแrio"						,oFont12)
oPrint:Say (0862,470,"PIS do Funcionแrio"						,oFont12)
oPrint:Say (0932,470,"Data de Nascimento do Funcionแrio"						,oFont12)
oPrint:Say (1002,470,"Data de Admissใo"						,oFont12)
oPrint:Say (1072,470,"Data de Demissใo"						,oFont12)
oPrint:Say (1142,470,"Cargo / Perํodo de cada cargo" ,oFont12)
oPrint:Say (1670,470,"Jแ houve preenchimento de Comunica็ใo ", oFont12)
oPrint:Say (1730,470,"de acidente do trabalho - CAT deste", oFont12)
oPrint:Say (1790,470,"trabalhador? Nบ do registro no INSS e DATA"	,oFont12)
oPrint:Say (1860,470,"Representante legal da Empresa"						,oFont12)
oPrint:Say (1935,470,"PIS do representante legal da Empresa"						,oFont12)
oPrint:Say (2005,470,"Setor do Funcionแrio"						,oFont12)

Return

Static Function ValidPerg(cPerg)


_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Filial 				","","","mv_ch01","C",02,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Da Matricula		","","","mv_ch02","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Ate Matricula		","","","mv_ch03","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Da Admissao			","","","mv_ch04","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Ate Admissao		","","","mv_ch05","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Da Demissao			","","","mv_ch06","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ate Demissao		","","","mv_ch07","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Representante Emp.	","","","mv_ch08","C",40,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","PIS 				","","","mv_ch09","C",11,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Acidente 			","","","mv_ch10","N",01,0,2,"C","","MV_PAR10","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","1 Reg. INSS 		","","","mv_ch11","C",13,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","2 Reg. INSS 		","","","mv_ch12","C",13,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Data 				","","","mv_ch13","D",08,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Filtra Situa็ใo		","","","mv_ch14","C",12,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Filtra Categorias	","","","mv_ch15","C",12,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
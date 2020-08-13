#INCLUDE "protheus.CH"
#include "font.ch"
#INCLUDE "Topconn.ch"

#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPENDENCIA บAutor  ณBruno Alves         บ Data ณ  09/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de controle de pendencias da record              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function PENDENCIA()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aOrd         := {}
Local aPergs       := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Lista de Pendencias"
Local cPict        := ""
Local titulo       := "Lista de Pendencias"
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.

Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CCI301" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE nLin       := 465
Private CbTxt      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private Tamanho    := "G"
Private nomeprog   := "PENDENCIA"
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cString    := "SZP"
Private cPerg      := "PEND"
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

cQuery := "SELECT * FROM SZP010 WHERE "
cQuery += "ZP_COD BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "ZP_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
cQuery += "ZP_MODULO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "ZP_STATUS IN "+FormatIn(MV_PAR07,";") 
cQuery += " AND ZP_PRAZO BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' AND "
cQuery += "ZP_CONCLUS BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' AND "
cQuery += "D_E_L_E_T_ <> '*' "

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

Private oFont7  := TFont():New("Arial",9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont7p := TFont():New("Arial",9, 5,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont8  := TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont08n:= TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
Private oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
Private oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

DBSelectArea("PEND")
DBGotop()


While !EOF()	

If PEND->ZP_NECESS == "1"
cNecess := "Melhoria"
ElseIf PEND->ZP_NECESS == "2"
cNecess := "Atualizacao"
ElseIf PEND->ZP_NECESS == "3"
cNecess := "Facilitador"
ElseIf PEND->ZP_NECESS == "4"
cNecess := "Relatorio"
ElseIf PEND->ZP_NECESS == "5"
cNecess := "Inconsistencia"
EndIf

If PEND->ZP_STATUS == "1"
cStatus := "Pendente"
ElseIf PEND->ZP_STATUS == "2"
cStatus := "Andamento"
ElseIf PEND->ZP_STATUS == "3"
cStatus := "Concluido"
EndIf

	
	aAdd(aItensImp,{PEND->ZP_COD,;  		// 1 - Codigo
	PEND->ZP_SOLICIT,;	// 2 - Nome do Solicitante
	PEND->ZP_EMISSAO,;	// 3 - Emissao
	PEND->ZP_PRAZO,;   	// 4 - Data Prazo Estimado
	PEND->ZP_CONCLUS,;	// 5 - Data da Conclusใo
	PEND->ZP_DESCRI,;   	// 6 - Descricao resumida do problema
	cNecess,;	// 7 - Tipo da necessidade
	PEND->ZP_MODULO,; 	// 8 - Modulo
	cStatus,; // 9 - Status
	PEND->ZP_CRITICI})	// 10 - Criticidade
	
	
	DBSelectARea("PEND")
	DBSkip()
	
	
	
	IncRegua()
	
ENDDO

DBSelectARea("PEND")
DBCloseArea("PEND")


oPrint:= TMSPrinter():New( "Lista de Pendencias - RECORD" )
oPrint:SetSize(210,297)
oPrint:SetLandscape() // ou SetPortrait()

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
Local _nLimDesc := 50
Local _nLimObs  := 70
Local nLastLnDesc := 0
Local nLastLnObs  := 0

MontaPagina()

//oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
//oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)

nLin := 50

For i:=1 to Len(aItens)
	
	If nLin > 1750
		oPrint:EndPage()
		MontaPagina()
		
  //		oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
  //		oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)
		
		nLin := 50
	Endif
	
	dbSelectArea("SZP")
	dbSetOrder(1)
	dbSeek(xFilial("SZP") + aItens[i][1])
	
	cMemoDesc := alltrim(SZP->ZP_DETALHE)
	nMemoDesc := MlCount( cMemoDesc ,_nLimDesc )
	_aTxTDesc := memoFormata( cMemoDesc, _nLimDesc, nMemoDesc )
	
	cMemoObs := alltrim(SZP->ZP_SOLUCAO)
	nMemoObs := MlCount( cMemoObs, _nLimObs )
	_aTxTObs := memoFormata( cMemoObs, _nLimObs, nMemoObs )
	
	oPrint:Say (0420 + nLin,0085,aItens[i][01]					,oFont7)
	oPrint:Say (0420 + nLin,0220,UPPER(aItens[i][02])			,oFont7)
	oPrint:Say (0420 + nLin,0470,DtoC(StoD(aItens[i][03]))		,oFont7)
	oPrint:Say (0420 + nLin,0600,DtoC(StoD(aItens[i][04]))		,oFont7)
	oPrint:Say (0420 + nLin,0725,DtoC(StoD(aItens[i][05]))		,oFont7)
	oPrint:Say (0420 + nLin,1750,aItens[i][07]					,oFont7)
	oPrint:Say (0420 + nLin,2840,aItens[i][10]					,oFont7)
	oPrint:Say (0420 + nLin,2985,aItens[i][08]					,oFont7)
	oPrint:Say (0420 + nLin,3115,aItens[i][09]					,oFont7)
	
	For D:=1 to Len(_aTxTDesc)
		oPrint:Say(0420 + nLin,0890,Trim(_aTxtDesc[D]),oFont7,2300,,,4,4)
		nLin += 25
		If nLin > 1750
			oPrint:EndPage()
			MontaPagina()
			
	//		oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
	//		oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)
			
			nLin := 50
		Endif
	Next
	nLastLnDesc := nLin
	
	For O:=1 to Len(_aTxtObs)
		If O == 1
			nLin := nLin - (Len(_aTxtDesc) * 25)
		Endif
		oPrint:Say(0420 + nLin,2000,Trim(_aTxtObs[O]),oFont7,2300,,,4,4)
		nLin += 25
		If nLin > 1750
			oPrint:EndPage()
			MontaPagina()
			
//			oPrint:Say (0310,0120,"Cliente: " + aItens[1][3]	,oFont12)
//			oPrint:Say (0350,0120,"Projeto: " + aItens[1][5]	,oFont12)
			
			nLin := 50
		Endif
	Next
	nLastLnObs := nLin
	
	If nLastLnDesc > nLastLnObs
		nLin := nLastLnDesc + 25
	Else
		nLin := nLastLnObs + 25
	Endif
	
	oPrint:Line(0420 + nLin,075,0420 + nLin,3285)
	
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
Local aCoord := {0400,075,0470,3285}

oBrush := TBrush():New(,CLR_HGRAY)

oPrint:FillRect(aCoord,oBrush)
oPrint:StartPage()   // Inicia uma nova pแgina
/*
_______________________________________________________
CAIXA
_______________________________________________________
*/
oPrint:Line (0075,0075,2200,0075) //Coluna da esquerda
oPrint:Line (0075,3285,2200,3285) //Coluna da direita
oPrint:Line (0075,0075,0075,3285) //Linha de cima
oPrint:line (2200,0075,2200,3285) //Linha de baixo

/*
_____________________________________________________
IMAGENS
_____________________________________________________
*/
//               linI colI            larg alt
oPrint:SayBitmap(0100,150,cLogoTotvs,0230,200)//imagem da totvs
//oPrint:SayBitmap(0100,400,cLogoTriade,0340,185)//imagem da triade
//oPrint:SayBitmap(0100,2700,cLogoCliente,0340,200)//imagem do cliente

/*
_____________________________________________________
LINHAS DA PLANILHA
_____________________________________________________
*/


oPrint:Line(0300,075,0300,3285)//LINHA ABAIXO DAS IMAGENS
oPrint:Line(0400,075,0400,3285)//CABECALHO
oPrint:Line(0470,075,0470,3285)
/*


/*
_____________________________________________________
COLUNAS DA PLANILHA
_____________________________________________________
*/

oPrint:Line(0400,0200,2200,0200)
oPrint:Line(0400,0460,2200,0460)
oPrint:Line(0400,0585,2200,0585)
oPrint:Line(0400,0710,2200,0710)
oPrint:Line(0400,0855,2200,0855)
oPrint:Line(0400,1675,2200,1675) 
oPrint:Line(0400,1955,2200,1955)
oPrint:Line(0400,2750,2200,2750)
oPrint:Line(0400,2940,2200,2940)
oPrint:Line(0400,3100,2200,3100)

/*
_____________________________________________________
DADOS DO RELATORIO
_____________________________________________________
*/

oPrint:Say (0180,1350,"Lista de Pendencias - RECORD"	,oFont16n)

oPrint:Say (0413,0090,"Codigo"						,oFont7)
//oPrint:Say (0413,0178,"Cham."						,oFont7)
oPrint:Say (0413,0260,"Solicitante"					,oFont7)
oPrint:Say (0413,0470,"Data"						,oFont7)
oPrint:Say (0413,0600,"Prazo"						,oFont7)
oPrint:Say (0413,0725,"Conclusao"					,oFont7)
oPrint:Say (0413,1215,"Descri็ใo"					,oFont7)
oPrint:Say (0413,1735,"Necessidade"					,oFont7)
//oPrint:Say (0413,1940,"Crit."						,oFont7)
oPrint:Say (0413,2250,"Solu็ใo/Observa็ใo"			,oFont7)
oPrint:Say (0413,2780,"Criticidade"					,oFont7)
oPrint:Say (0413,2960,"Processo"					,oFont7)
oPrint:Say (0413,3140,"Status"						,oFont7)

oPrint:Say (2220,0075,"LEGENDA:"					,oFont08n)
oPrint:Say (2220,0245,"Necessidade:"				,oFont08n)
oPrint:Say (2220,0430,"1 - Melhoria"	    		,oFont08n)
oPrint:Say (2250,0430,"2 - Atualiza็ใo"				,oFont08n)
oPrint:Say (2280,0430,"3 - Facilitador"				,oFont08n)
oPrint:Say (2310,0430,"4 - Relatorio"				,oFont08n)
oPrint:Say (2340,0430,"5 - Inconsistencia"			,oFont08n)
oPrint:Say (2220,0690,"Status:"						,oFont08n)
oPrint:Say (2220,0790,"1 - Pendente"			 	,oFont08n)
oPrint:Say (2250,0790,"2 - Andamento"				,oFont08n)
oPrint:Say (2280,0790,"3 - Concluido"				,oFont08n)
oPrint:Say (2220,1020,"Crit:"						,oFont08n)
oPrint:Say (2220,1100,"A - Imprescindivel"			,oFont08n)
oPrint:Say (2250,1100,"B - Importante"				,oFont08n)
oPrint:Say (2280,1100,"C - Desejavel"				,oFont08n)

oPrint:Say (2220,3025,"Pagina: " + Strzero(oPrint:nPage,3), oFont08n)

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Do Codigo ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZP"})
AADD(aRegs,{cPerg,"02","Ate Codigo ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SZP"})
AADD(aRegs,{cPerg,"03","Da Emissao ?","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Emissao ?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Do Modulo ?","","","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","IA"})
AADD(aRegs,{cPerg,"06","Ate Modulo ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","IA"})
AADD(aRegs,{cPerg,"07","Status ?","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Do Prazo ?","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Ate Prazo ?","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Da Conclusao ?","","","mv_ch10","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Ate Conclusao ?","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

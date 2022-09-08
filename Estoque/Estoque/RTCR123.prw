#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCR123   บ Autor ณ Cristiano D. Alves บ Data ณ  20/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressใo das requisi็๕es ao almoxarifado.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Record - DF                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCR123()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local _aArea		:= GetArea()
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Rela็ใo de Requisi็ใo ao Almoxarifado"
Local cPict        := ""
Local titulo       := "Rela็ใo de Requisi็ใo ao Almoxarifado"
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local nLin       	 := 80
Private aOrd       := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "RTC123" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "RTC123"+space(4)
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTCR123" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD3"

//dbSelectArea("SD3")
//dbSetOrder(1)
/*
If FunName() == "MATA241"
	dbSelectarea("SX1")
	dbSetorder(1)
	If dbSeek(cPerg + "01")
		Reclock("SX1",.F.)
		If Empty(SD3->D3_DOC)
			X1_CNT01 := "999999"
		Else
			X1_CNT01 := //SD3->D3_DOC
		EndIf
		MsUnlock()
	EndIf
	If dbSeek(cPerg + "02")
		Reclock("SX1",.F.)
		If Empty(SD3->D3_DOC)
			X1_CNT01 := "999999"
		Else
			X1_CNT01 := SD3->D3_DOC
		EndIf
		MsUnlock()
	EndIf
	If dbSeek(cPerg + "03")
		Reclock("SX1",.F.)
		If Empty(SD3->D3_EMISSAO)
			X1_CNT01 := "01/01/80"
		Else
			X1_CNT01 := DTOC(SD3->D3_EMISSAO)
		EndIf
		MsUnlock()
	EndIf
	If dbSeek(cPerg + "04")
		Reclock("SX1",.F.)
		If Empty(SD3->D3_EMISSAO)
			X1_CNT01 := "01/01/80"
		Else
			X1_CNT01 := DTOC(SD3->D3_EMISSAO)
		EndIf
		MsUnlock()
	EndIf
	If dbSeek(cPerg + "05")
		Reclock("SX1",.F.)
		X1_CNT01 := "Informe o nome do solicitante"
		MsUnlock()
	EndIf
	//RestArea(_aArea)
EndIf
*/
//Configuracao de parametros por usuario

IF !ALLTRIM(FUNNAME()) $ "MATA241"
	ValidPerg()
	Pergunte(cPerg,.T.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
ENDIF

//Para nใo aparecer o botao de parametros para o usuแrio. Por Cristiano em 12/05/10.
IF ALLTRIM(FUNNAME()) $ "MATA241"
	wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
EndIf

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  20/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _cQuery := ""
Local _nQuant := 0
Local cOBS	  := ""

Private _cUsuario := ""
Private _dData    := ""

_cQuery += "SELECT D3_COD, B1_DESC, D3_QUANT, D3_CF, D3_LOCAL, D3_DOC, D3_EMISSAO, D3_USUARIO, D3_TM, D3_CC, D3_OBS "
_cQuery += "FROM "+RetSqlName("SD3")+" SD3, "
_cQuery += ""+RetSqlName("SB1")+" SB1 "
_cQuery += "WHERE SD3.D_E_L_E_T_ = '' "
_cQuery += " AND  SB1.D_E_L_E_T_ = '' "
//IF MV_PAR06 == 2
_cQuery += "AND D3_ESTORNO <> 'S' "
//ENDIF
IF ALLTRIM(FUNNAME()) $ "MATA241"
	_cQuery += "AND D3_DOC     = '"+cDocumento+"' "
	_cQuery += "AND D3_EMISSAO = '"+DTOS(dA241Data)+"' "
ELSE
	_cQuery += "AND D3_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery += "AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
ENDIF
_cQuery += "AND D3_COD = B1_COD "
_cQuery += "ORDER BY D3_FILIAL, D3_DOC, D3_COD"



TcQuery _cQuery New Alias "QRY"

dbGoTop()
While !QRY->(EOF())

	_cDoc	:= QRY->D3_DOC

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	While !QRY->(EOF()) .and. QRY->D3_DOC == _cDoc

		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
			ImpCabec(@nLin)
			nLin ++
		Endif

		@nLin,004 PSAY QRY->D3_COD
		@nLin,020 PSAY QRY->D3_QUANT Picture "@E 999,999,999.99"
		@nLin,035 PSAY QRY->B1_DESC
		cOBS	:= QRY->D3_OBS
		_nQuant 	+= QRY->D3_QUANT
		_cUsuario:= QRY->D3_USUARIO
		_dData	:= QRY->D3_EMISSAO
		nLin 		:= nLin + 1 // Avanca a linha de impressao
		QRY->(dbSkip())
	EndDo
	@nLin,000 PSay __PrtThinLine()
	nLin ++
	ImpTot(@nLin,@_nQuant,@_cUsuario,@_dData,@cOBS)
EndDo

QRY->(dbCloseArea())

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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo para impressใo do cabe็alhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function ImpCabec(nLin)

@nLin,004 Psay "Movimentacao Interna n.: "+ QRY->D3_DOC +" Emissao: "
@nLin,049 Psay STOD(QRY->D3_EMISSAO)
nLin += 2
@nLin,004 Psay "Tipo de movimentacao.....: "+ QRY->D3_TM +" - "+Posicione("SF5",1,xFilial("SF5")+QRY->D3_TM,"F5_TEXTO")
nLin ++
@nLin,004 Psay "Centro de Custo..........: "+ QRY->D3_CC +" - "+Posicione("CTT",1,xFilial("CTT")+QRY->D3_CC,"CTT_DESC01")
nLin += 3
@nLin,004 Psay "CODIGO                  QUANT. NOME                           "
nLin ++
@nLin,004 PSay __PrtThinLine()
nLin ++

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ[ฟ
//ณFuncใo para impressใo dos totais e rodap้ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ[ู

Static Function ImpTot(nLin,_nQuant,_cUsuario,_dData,cOBS)

@nLin,004 PSAY "T O T A L ----> "
@nLin,020 PSAY _nQuant Picture "@E 999,999,999.99"

nLin := 50

@nLin,022 PSAY "____________________________________               ____________________________________"
nLin ++
If !Empty(_cUsuario)
	@nLin,033 PSAY Alltrim(_cUsuario)
EndIf
If !Empty(MV_PAR05) .AND. !FUNNAME() $ "MATA241" .AND. Empty(cOBS)
	@nLin,082 PSAY Alltrim(MV_PAR05)
ELSE
	@nLin,082 PSAY Alltrim(cOBS)
EndIf
nLin ++
@nLin,033 PSAY "Almoxarifado                                          Solicitante"
nLin ++
@nLin,035 Psay STOD(_dData)
@nLin,089 Psay STOD(_dData)
nLin    := 60
_nQuant := 0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณCristiano D. Alves  บ Data ณ  20/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas no SX1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Record - DF                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Do Documento       ?","","","mv_ch1","C",09,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SD3",""})
aAdd(aRegs,{cPerg,"02","Ate o Documento    ?","","","mv_ch2","C",09,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SD3",""})
aAdd(aRegs,{cPerg,"03","Da Emissao         ?","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?","","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Solicitante        ?","","","mv_ch5","C",30,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Imprime Estornados ?","","","mv_ch6","N",01,0,2,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Do Produto         ?","","","mv_ch3","C",15,00,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","" })
//aAdd(aRegs,{cPerg,"04","Ate o Produto      ?","","","mv_ch4","C",15,00,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
//aAdd(aRegs,{cPerg,"05","Do Armazem         ?","","","mv_ch5","C",02,00,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
//aAdd(aRegs,{cPerg,"06","Ate o Armazem      ?","","","mv_ch6","C",02,00,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


/*
0         10        20        30        40        50        60        70        80        90        100       110       120       130
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

Movimentacao Interna n.: 999999  Emissใo: 99/99/99

Tipo de movimentacao.....: 999 - REQUISICAO DE MATERIAIS AO ALMOX.
Centro de Custo..........: 999999999 - COMERCIAL

CODIGO                  QUANT. NOME                           OBSERVACOES
999999999999999 999,999,999.99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
999999999999999 999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
999999999999999 999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
999999999999999 999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
999999999999999 999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
999999999999999 999.999.999,99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

T O T A L ----> 999.999.999,99





____________________________________               _______________________________
FULANO DE TAL                                    FULANO DE TAL
Almoxarifado                                     Solicitante
99/99/99                                         99/99/99*/
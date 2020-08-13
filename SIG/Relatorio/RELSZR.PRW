#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELSZR   บ Autor ณ RAFAEL FRANวA      บ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RELSZR                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELSZR


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "Relatorio SIG Analitico" 
Local nLin         	:= 80

Local Cabec1		:= UPPER(" Documento    Cli/For Nome                               Emissao                 Valor    Historico")
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite          := 220
Private tamanho         := "M"
Private nomeprog        := "RELSZR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg      := "RELSZR01"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELSZR" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cQuery     := ""

Private cString := "SZR"

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("Opera็ใo cancelada pelo usuแrio")
	return
ENDIF

titulo := "Relatorio SIG Analitico " + DTOC(MV_PAR03) + " - " + DTOC(MV_PAR04)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

cQuery := "SELECT ZR_CODIGO,ZR_PREFIXO AS PREFIXO,ZR_DOC AS DOCUMENTO,ZR_CLIENTE AS CLIENTE,ZR_FORNECE AS FORNECE,ZR_LOJA AS LOJA,ZR_CTASIG,ZR_EMISSAO AS EMISSAO,ZR_TIPO,SUM(ZR_VALOR) AS VALOR "
cQuery += "FROM SZR010 WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZR_CTASIG BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery += "AND ZR_CODIGO BETWEEN '"+SUBSTR(DTOS(MV_PAR03),1,6)+"' AND '"+SUBSTR(DTOS(MV_PAR04),1,6)+"' "
cQuery += "AND ZR_TIPO IN ('C','D') "
//cQuery += "AND ZR_PREFIXO NOT IN ('REQ','GPE','ATF') "
//cQuery += "AND ZR_CTASIG <> '09003' "

IF 	   MV_PAR02 == 1
	cQuery += "AND ZR_TIPO = 'D' "
ELSEIF MV_PAR02 == 2
	cQuery += "AND ZR_TIPO = 'C' "
ENDIF

cQuery += "GROUP BY ZR_CODIGO,ZR_PREFIXO,ZR_DOC,ZR_CLIENTE,ZR_FORNECE,ZR_LOJA,ZR_CTASIG,ZR_EMISSAO,ZR_TIPO "
cQuery += "ORDER BY ZR_CODIGO,ZR_TIPO,ZR_CTASIG,EMISSAO,DOCUMENTO "

tcQuery cQuery New Alias "TMPSZR"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMPSZR")
	dbCloseArea("TMPSZR")
	Return
Endif

If nLastKey == 27 
	dbSelectArea("TMPSZR")
	dbCloseArea("TMPSZR")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27  
	dbSelectArea("TMPSZR")
	dbCloseArea("TMPSZR")
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  08/07/13   บฑฑ
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

Local nOrdem
Local nVlTotalD	 := 0
Local nVlTotalC	 := 0
Local cSubTot	 := ""
Local nSubTot	 := 0 
Local cCtaTot	 := ""
Local nCtaTot	 := 0      
Local cTipo 	 := "" 
Local cQuery1	 := ""     
Local cHist		 := ""       
Local lok		 := .T.

dbSelectArea("TMPSZR")

SetRegua(RecCount())

dbGoTop()
While !EOF()
	
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 50 .AND. (MV_PAR01 == 1 .OR. lOk) // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif 
	
	IF (cTipo != TMPSZR->ZR_TIPO) .AND. cSubTot <> SUBSTR(TMPSZR->ZR_CTASIG,1,2)
				nLin     := nLin + 1 // Avanca a linha de impressao
				IF TMPSZR->ZR_TIPO == "D"
					@nLin, 001 PSAY "DESPESAS"
				ELSEIF TMPSZR->ZR_TIPO == "C"
					@nLin, 001 PSAY "RECEITAS"
				ENDIF
				nLin     := nLin + 1 // Avanca a linha de impressao
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
				nLin     := nLin + 1 // Avanca a linha de impressao
	ENDIF
	
	IF (cSubTot <> SUBSTR(TMPSZR->ZR_CTASIG,1,2))
		nLin 	:= nLin + 1
		@nLin, 001 PSAY SUBSTR(TMPSZR->ZR_CTASIG,1,2)
		@nLin, 022 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR(TMPSZR->ZR_CTASIG,1,2),"X5_DESCRI"))
		nLin 	:= nLin + 1 // Avanca a linha de impressao
		@nLin, 000 PSAY REPLICATE("-",LIMITE)
		nLin 	:= nLin + 1 // Avanca a linha de impressao
		nSubTot	:= 0
	ENDIF      
	
	IF (cCtaTot <> TMPSZR->ZR_CTASIG)
		nLin 	:= nLin + 1
		@nLin, 001 PSAY TMPSZR->ZR_CTASIG
		@nLin, 022 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMPSZR->ZR_CTASIG,"X5_DESCRI"))
		nLin 	:= nLin + 1 // Avanca a linha de impressao
		@nLin, 000 PSAY REPLICATE("-",LIMITE)
		nLin 	:= nLin + 1 // Avanca a linha de impressao
		nCtaTot	:= 0
	ENDIF
	
	@nLin, 001 PSAY ALLTRIM(SUBSTR(TMPSZR->DOCUMENTO,1,08)) + "\" + ALLTRIM(TMPSZR->PREFIXO)   
	cHist 	:= ""   
	lOk		:= .F.
	
	IF !EMPTY(TMPSZR->CLIENTE)
			@nLin, 014 PSAY ALLTRIM(TMPSZR->CLIENTE)// + " " + TMPSZR->LOJA
			IF EMPTY(ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + ALLTRIM(TMPSZR->CLIENTE) + TMPSZR->LOJA,"A1_NOME"),1,30)))
				@nLin, 022 PSAY ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + ALLTRIM(TMPSZR->CLIENTE) + TMPSZR->LOJA,"A2_NOME"),1,30))
			ELSE
				@nLin, 022 PSAY ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + ALLTRIM(TMPSZR->CLIENTE) + TMPSZR->LOJA,"A1_NOME"),1,30))
			ENDIF
		ELSE
			@nLin, 014 PSAY ALLTRIM(TMPSZR->FORNECE)// + " " + TMPSZR->LOJA
			IF EMPTY(ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + ALLTRIM(TMPSZR->FORNECE) + TMPSZR->LOJA,"A2_NOME"),1,30)))
				@nLin, 022 PSAY ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + ALLTRIM(TMPSZR->FORNECE) + TMPSZR->LOJA,"A1_NOME"),1,30))
			ELSE
				@nLin, 022 PSAY ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + ALLTRIM(TMPSZR->FORNECE) + TMPSZR->LOJA,"A2_NOME"),1,30))
			ENDIF
	ENDIF
	
	IF EMPTY(TMPSZR->EMISSAO)
	@nLin, 057 PSAY STOD(SUBSTR(TMPSZR->ZR_CODIGO,1,6) + STRZERO(LAST_DAY(STOD(TMPSZR->ZR_CODIGO + "01")),2))
	ELSE
	@nLin, 057 PSAY STOD(TMPSZR->EMISSAO)
	ENDIF
	 
	@nLin, 072 PSAY TMPSZR->VALOR PICTURE "@E 999,999,999.99"  
	
	cQuery1 := "SELECT ZR_HIST FROM SZR010 WHERE D_E_L_E_T_ = '' AND ZR_CODIGO = '"+TMPSZR->ZR_CODIGO+"' AND ZR_DOC = '"+TMPSZR->DOCUMENTO+"' AND ZR_PREFIXO = '"+TMPSZR->PREFIXO+"' AND ZR_CLIENTE = '"+TMPSZR->CLIENTE+"' AND ZR_FORNECE = '"+TMPSZR->FORNECE+"' AND ZR_EMISSAO = '"+TMPSZR->EMISSAO+"'"
	
	tcQuery cQuery1 New Alias "TMP1"  
	
	dbSelectArea("TMP1")
	dbGoTop()
	While !EOF() 
	
	cHist := ALLTRIM(SUBSTR(TMP1->ZR_HIST,1,40))
	
	dbskip()
	
	ENDDO 
	
		dbSelectArea("TMP1")
		dbCloseArea("TMP1")       
		
	@nLin, 090 PSAY  ALLTRIM(cHist)  
	
	dbSelectArea("TMPSZR")  
	
	IF EMPTY(cHist)
	@nLin, 090 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMPSZR->ZR_CTASIG,"X5_DESCRI"))
	ENDIF
	
	IF TMPSZR->ZR_CTASIG != "01078" .AND. TMPSZR->ZR_CTASIG != "01079" // Rafael Fran็a - Conta SIG apenas informativa, nใo utilizada para resultado.
		IF TMPSZR->ZR_TIPO == "D" //Separa os valores por credito e debito
			nVlTotalD	 += TMPSZR->VALOR
		ELSEIF TMPSZR->ZR_TIPO == "C"
			nVlTotalC	 += TMPSZR->VALOR
		ENDIF
		nSubTot		+= TMPSZR->VALOR 
	ENDIF
	
	nCtaTot		+= TMPSZR->VALOR
	cSubTot 	:= SUBSTR(TMPSZR->ZR_CTASIG,1,2)
	cCtaTot		:= TMPSZR->ZR_CTASIG
	cTipo 		:= TMPSZR->ZR_TIPO
	
	dbSkip() // Avanca o ponteiro do registro no arquivo  
	
	IF (cCtaTot <> TMPSZR->ZR_CTASIG) .OR. (cTipo != TMPSZR->ZR_TIPO) //SubTotais das contas SIG - Tabela SX5 "ZA"
		nLin     := nLin + 1 // Avanca a linha de impressao
		@nLin, 000 PSAY REPLICATE("-",LIMITE)
		nLin     := nLin + 1
		@nLin, 001 PSAY "TOTAL CONTA:"
		@nLin, 022 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+cCtaTot,"X5_DESCRI"))
		@nLin, 072 PSAY nCtaTot PICTURE "@E 999,999,999.99"
		nCtaTot	 	:= 0
	ENDIF  
	
	IF (cSubTot <> SUBSTR(TMPSZR->ZR_CTASIG,1,2)) .OR. (cTipo != TMPSZR->ZR_TIPO)  //SubTotais das contas SIG - Tabela SX5 "ZA"
			nLin     := nLin + 2 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1
			@nLin, 001 PSAY "SUBTOTAL:"
			@nLin, 022 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR(cSubTot,1,2),"X5_DESCRI"))
			@nLin, 072 PSAY nSubTot PICTURE "@E 999,999,999.99"
			nSubTot	 	:= 0
	ENDIF    
	
	IF (cTipo != TMPSZR->ZR_TIPO) 
			nLin += 2
			IF cTipo == "D"
				@nLin, 001 PSAY UPPER("Total de Despesas ------------>")
				@nLin, 072 PSAY nVlTotalD PICTURE "@E 999,999,999.99"
			ELSE
				@nLin, 001 PSAY UPPER("Total de Receitas ------------>")
				@nLin, 072 PSAY nVlTotalC PICTURE "@E 999,999,999.99"
			ENDIF
			nLin += 1
			@nLin, 000 PSAY REPLICATE("-",LIMITE)  
		ENDIF 
		
		nLin := nLin + 1 // Avanca a linha de impressao
	
EndDo

dbSelectArea("TMPSZR")
dbCloseArea("TMPSZR")

SET DEVICE TO SCREEN


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Tipo Relatorio		","","","mv_ch01","N",01,0,0,"C","","mv_par01","Relatorio","","","","","Spool Excel","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tipo do Relatorio	","","","mv_ch02","N",01,0,0,"C","","mv_par02","Despesas","","","","","Receitas","","","","","Ambos","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Data 			","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data		 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Conta SIG		","","","mv_ch05","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
AADD(aRegs,{cPerg,"06","Ate Conta SIG		","","","mv_ch06","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})

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
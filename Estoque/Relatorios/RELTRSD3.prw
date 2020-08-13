#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELTRSD3    º Autor ³RAFAEL FRANCA      º Data ³  14/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³TRANSFERENCIA SD3 ACERVO / ENDEREÇO                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORDTVDF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELTRSD3


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Transferencia Acervo / Endereço"
Local cPict         := ""
Local titulo       	:= "Transferencia Acervo / Endereço"
Local nLin         	:= 80

Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Private aOrd        := {"Documento"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RELTRSD3" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := {"Zebrado",1,"Administracao",2,2,1,"",1}
Private nLastKey    := 0
Private cPerg       := "RELTRSD3"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELTRSD3" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD3"

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

dbSelectArea("SB1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery    := ""
Local cSubtot	:= ""
Local nSubQtd 	:= 0
Local nSubVlr 	:= 0
Local nTotalVlr	:= 0
Local nTotalQtd	:= 0   
Local lOk 		:= .F.

nOrdem := aReturn[8]

IF nOrdem 		== 1
	Cabec1       := "Ar  Ende   Produto Descrição                      Tipo          Marca               Cor            Nº  Sexo     Saldo          Valor"
ELSEIF nOrdem	== 2
	Cabec1       := "Ar  Grup   Produto Descrição                      Tipo          Marca               Cor            Nº  Sexo     Saldo          Valor"
ENDIF

cQuery    	:= "SELECT B1_LOCPAD,B1_GRUPO,B1_COD,B1_DESC,B1_TIPO,B1_MARCA,B1_TAMANHO,B1_COR,B1_SEXO "
cQuery    	+= ",BF_QUANT,B2_CM1,B2_CM1 "
cQuery    	+= ",BF_LOCALIZ,BF_QUANT "
cQuery    	+= "FROM SB1010 "
cQuery    	+= "INNER JOIN SB2010 ON B1_COD = B2_COD AND B1_LOCPAD = B2_LOCAL "
cQuery   	+= "INNER JOIN SBF010 ON B1_COD = BF_PRODUTO AND BF_LOCAL = B1_LOCPAD "
cQuery    	+= "WHERE SB1010.D_E_L_E_T_ = '' AND SB2010.D_E_L_E_T_ = '' AND SBF010.D_E_L_E_T_ = '' "
//cQuery    	+= "AND B1_COD NOT IN (SELECT TNF_CODEPI FROM TNF010 WHERE TNF010.D_E_L_E_T_ = '' AND TNF_DTDEVO = '' GROUP BY TNF_CODEPI) "
cQuery    	+= "AND B1_LOCPAD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery    	+= "AND B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery    	+= "AND B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "

IF nOrdem 		== 1
	cQuery    		+= "ORDER BY B1_LOCPAD,B1_GRUPO,BF_LOCALIZ,B1_COD"
ELSEIF nOrdem	== 2
	cQuery    		+= "ORDER BY B1_LOCPAD,BF_LOCALIZ,B1_GRUPO,B1_COD"
ENDIF

tcQuery cQuery New Alias "TMP1"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
Endif

nOrdem := aReturn[8]

dbSelectArea("TMP1")

//dbSetOrder(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

dbGoTop()
While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 62 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF nOrdem 		== 1 .AND. TMP1->B1_GRUPO <> cSubTot
		If MV_PAR07 == 1 .AND. lOk 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin 	:= 8    
		Endif
		@nLin,000 PSAY TMP1->B1_GRUPO
		@nLin,005 PSAY Posicione("SBM",1,xFilial("SBM")+TMP1->B1_GRUPO,"BM_DESC")
		nLin 		+= 2
	ELSEIF nOrdem	== 2 .AND. TMP1->BF_LOCALIZ <> cSubTot
		If MV_PAR07 == 1 .AND. lOk
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin 	:= 8  
		Endif
		@nLin,000 PSAY TMP1->BF_LOCALIZ
		@nLin,006 PSAY Posicione("SBE",9,xFilial("SBE")+TMP1->BF_LOCALIZ,"BE_DESCRIC")
		nLin 		+= 2
	ENDIF
	
	@nLin,000 PSAY TMP1->B1_LOCPAD
	
	IF nOrdem 		== 1
		@nLin,004 PSAY TMP1->BF_LOCALIZ
	ELSEIF nOrdem	== 2
		@nLin,004 PSAY TMP1->B1_GRUPO
	ENDIF
	
	@nLin,011 PSAY TMP1->B1_COD
	@nLin,020 PSAY SUBSTR(TMP1->B1_DESC,1,28)
	@nLin,051 PSAY SUBSTR(Posicione("SX5",1,xFilial("SX5")+"02"+TMP1->B1_TIPO,"X5_DESCRI"),1,13)
	@nLin,065 PSAY SUBSTR(Posicione("VE1",1,xFilial("VE1")+TMP1->B1_MARCA,"VE1_DESMAR"),1,18)
	@nLin,085 PSAY SUBSTR(Posicione("VVC",3,xFilial("VVC")+TMP1->B1_COR,"VVC_DESCRI"),1,13)
	@nLin,100 PSAY TMP1->B1_TAMANHO
	@nLin,107 PSAY UPPER(TMP1->B1_SEXO)
	@nLin,113 PSAY TMP1->BF_QUANT  PICTURE "9999"
	@nLin,123 PSAY TMP1->B2_CM1 PICTURE "999,999.99"
	
	
	nTotalVlr  	+= TMP1->B2_CM1
	nTotalQtd  	+= TMP1->BF_QUANT
	nSubVlr		+= TMP1->B2_CM1
	nSubQtd 	+= TMP1->BF_QUANT     
	lOk 		:= .T.
	
	IF nOrdem 		== 1
		cSubTot := TMP1->B1_GRUPO
	ELSEIF nOrdem	== 2
		cSubTot := TMP1->BF_LOCALIZ
	ENDIF
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	
	IF nOrdem 		== 1 .AND. TMP1->B1_GRUPO <> cSubTot
		@nLin,000 PSAY Replicate("-",limite)
		nLin ++
		@nLin,000 PSAY "Total:"
		@nLin,007 PSAY Posicione("SBM",1,xFilial("SBM")+cSubTot,"BM_DESC")
		@nLin,113 PSAY nSubQtd   PICTURE "@! 9999"
		@nLin,122 PSAY nSubVlr PICTURE "@! 999,999.99"
		nSubVlr		:= 0
		nSubQtd 	:= 0
		nLin 		+= 2
	ELSEIF nOrdem	== 2 .AND. TMP1->BF_LOCALIZ <> cSubTot
		@nLin,000 PSAY Replicate("-",limite)
		nLin ++
		@nLin,000 PSAY "Total:"
		@nLin,007 PSAY Posicione("SBE",9,xFilial("SBE")+cSubTot,"BE_DESCRIC")
		@nLin,113 PSAY nSubQtd   PICTURE "@! 9999"
		@nLin,122 PSAY nSubVlr PICTURE "@! 999,999.99"
		nSubVlr		:= 0
		nSubQtd 	:= 0
		nLin 		+= 2
	ENDIF
	
EndDo

@nLin,000 PSAY Replicate("-",limite)
nLin ++
@nLin,000 PSAY "Total Geral"
@nLin,113 PSAY nTotalQtd   PICTURE "@! 9999"
@nLin,122 PSAY nTotalVlr PICTURE "@! 999,999.99"
nLin ++
@nLin,000 PSAY Replicate("-",limite)


dbSelectArea("TMP1")
dbCloseArea("TMP1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
AADD(aRegs,{cPerg,"01","Documento:	","","","mv_ch01","C",10,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
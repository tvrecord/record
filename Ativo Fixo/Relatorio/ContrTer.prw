#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณContrTer  บ Autor ณ Rafael Fran็a      บ Data ณ  04/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio para controle de terceiros no ativo fixo.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ record-df                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ContrTer()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Controle de Terceiros"
Local cPict         := ""
Local titulo       	:= "Controle de Terceiros"
Local nLin         	:= 80

Local Cabec1       	:= "Codigo  Ativo      Item  Descri็ใo                        Marca                 Modelo                Nบ Serie                         Valor   NF Entrada     Data       Prazo     NF Saida        Data  "
Local Cabec2       	:= "Situa็ใo                 Historico                                                                    C. Custo    Descri็ใo"
Local imprime      	:= .T.
Private aOrd        := {"Codigo","Entrega","Saida","Ativo","Fornecedor"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ContrTer" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "ContrTer02"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "ContrTer" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZN"

dbSelectArea("SZN")
dbSetOrder(1)

ValidPerg(cPerg)

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

IF MV_PAR23 == 2 .OR. MV_PAR01 == 1
	Cabec2       	:= ""
ENDIF
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  04/03/13   บฑฑ
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
Local cQuery 	:= ""
Local cTipo		:= ""
Local nTotEm    := 0
Local nTotDe	:= 0
Local nQtdEm	:= 0
Local nQtdDe	:= 0
Local nSubTot	:= 0
Local nSubQtd	:= 0
Private cSit		:= ""
Private cSituacao	:= ""

nOrdem := aReturn[8]

cQuery := "SELECT * FROM SZN010 "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZN_COD BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery += "AND ZN_CBASE BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cQuery += "AND ZN_NOTA BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
cQuery += "AND ZN_DTRECEB BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' "
cQuery += "AND ZN_NFSAIDA BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
cQuery += "AND ZN_DTDEVOL BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"' "
cQuery += "AND ZN_CC BETWEEN '"+(MV_PAR15)+"' AND '"+(MV_PAR16)+"' "
cQuery += "AND ZN_FORNECE BETWEEN '"+(MV_PAR17)+"' AND '"+(MV_PAR18)+"' " 
IF MV_PAR25 == 2  //Rafael - Verifica se o bem foi devolvido - Colocado dia 21/08/13 a pedido do Sr. Igleson
	cQuery += "AND (ZN_DTDEVOL <> '' AND ZN_DTRECEB <> '') " 
ELSEIF MV_PAR25 == 3
cQuery += "AND (ZN_DTDEVOL = '' OR ZN_DTRECEB = '') " 
ENDIF
IF !EMPTY(MV_PAR19)
	cQuery += "AND ZN_EMPRESA LIKE '%"+ALLTRIM(MV_PAR19)+"%' "
ENDIF
IF !EMPTY(MV_PAR20)
	cQuery += "AND ZN_DESCRI LIKE '%"+ALLTRIM(MV_PAR20)+"%' "
ENDIF
cQuery += "AND ZN_PRAZO BETWEEN '"+DTOS(MV_PAR21)+"' AND '"+DTOS(MV_PAR22)+"' "
IF !EMPTY(MV_PAR24)
	cQuery += "AND ZN_SIT IN "+FormatIn(MV_PAR24,";")+" "
ENDIF

IF MV_PAR02 == 1  //Bens em terceiros
	cQuery += "AND ZN_TIPO = '1' "
ELSEIF MV_PAR02 == 2 //Bens de terceiros
	cQuery += "AND ZN_TIPO = '2' "
ENDIF

cQuery += "ORDER BY ZN_TIPO,ZN_SIT" 

IF 		nOrdem == 1 
cQuery += ",ZN_COD" 
ELSEIF 	nOrdem == 2
cQuery += ",ZN_DTRECEB,ZN_NOTA" 
ELSEIF	nOrdem == 3
cQuery += ",ZN_DTDEVOL,ZN_NFSAIDA"  
ELSEIF	nOrdem == 4
cQuery += ",ZN_CBASE,ZN_ITEM"   
ELSEIF	nOrdem == 5
cQuery += ",ZN_EMPRESA"  
ENDIF

tcQuery cQuery New Alias "TMPTER"

DBSelectArea("TMPTER")
DBGotop()

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMPTER")
	dbCloseArea("TMPTER")
	MS_FLUSH()
	Return
Endif

While !EOF()
	
	SetRegua(RecCount())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	If 	lAbortPrint
		@nLin,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If 	nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	IF (TMPTER->ZN_TIPO != cTipo) //Verica o tipo do registro para totais
		IF TMPTER->ZN_TIPO == "1"
			@nLin, 000 PSAY "BENS EM TERCEIROS"
		ELSEIF TMPTER->ZN_TIPO == "2"
			@nLin, 000 PSAY "BENS DE TERCEIROS"
		ENDIF
		nLin += 1
		@nLin, 000 PSAY REPLICATE("-",(limite))
		nLin += 1
	ENDIF
	
	IF (TMPTER->ZN_SIT != cSit) .AND. MV_PAR01 == 2 //Verifica a Situta็ใo do ativo
		VerifSit(TMPTER->ZN_SIT)
		@nLin, 000 PSAY cSituacao
		nLin += 1
		@nLin, 000 PSAY REPLICATE("-",(limite))
		nLin += 1
	ENDIF
	
	IF MV_PAR01 == 2 //2 = Analitico
		
		@nLin, 000 PSAY TMPTER->ZN_COD
		@nLin, 008 PSAY TMPTER->ZN_CBASE
		@nLin, 019 PSAY TMPTER->ZN_ITEM
		@nLin, 025 PSAY SUBSTR(TMPTER->ZN_DESCRI,1,30)
		@nLin, 058 PSAY SUBSTR(TMPTER->ZN_MARCA,1,20)
		@nLin, 080 PSAY SUBSTR(TMPTER->ZN_MODELO,1,20)
		@nLin, 102 PSAY SUBSTR(TMPTER->ZN_NSERIE,1,20)
		@nLin, 126 PSAY TMPTER->ZN_VALOR PICTURE "@E 999,999,999.99"
		@nLin, 143 PSAY TMPTER->ZN_NOTA
		@nLin, 155 PSAY STOD(TMPTER->ZN_DTRECEB)
		@nLin, 168 PSAY STOD(TMPTER->ZN_PRAZO)
		@nLin, 180 PSAY TMPTER->ZN_NFSAIDA
		@nLin, 192 PSAY STOD(TMPTER->ZN_DTDEVOL)
		IF MV_PAR23 == 1
			nLin 	+= 1
			IF (EMPTY(TMPTER->ZN_DTDEVOL) .AND. TMPTER->ZN_TIPO == "2" .OR. EMPTY(TMPTER->ZN_DTRECEB) .AND. TMPTER->ZN_TIPO == "1") .AND. (STOD(TMPTER->ZN_PRAZO) - 7) <= DDATABASE .AND. STOD(TMPTER->ZN_PRAZO) >= DDATABASE
				@nLin, 000 PSAY UPPER("Menos de 7 dias do prazo")
			ELSEIF (EMPTY(TMPTER->ZN_DTDEVOL) .AND. TMPTER->ZN_TIPO == "2" .OR. EMPTY(TMPTER->ZN_DTRECEB) .AND. TMPTER->ZN_TIPO == "1") .AND. STOD(TMPTER->ZN_PRAZO) <= DDATABASE .AND. !EMPTY(ZN_PRAZO)
				@nLin, 000 PSAY UPPER("Prazo vencido")
			ELSEIF !EMPTY(ZN_DTDEVOL) .AND. ZN_TIPO == "2" .OR. !EMPTY(ZN_DTRECEB) .AND. ZN_TIPO == "1"
				@nLin, 000 PSAY UPPER("Devolvido")
			ELSE
				@nLin, 000 PSAY UPPER("Situa็ใo normal")
			ENDIF
			@nLin, 025 PSAY SUBSTR(TMPTER->ZN_HIST,1,75)
			@nLin, 102 PSAY TMPTER->ZN_CC
			@nLin, 116 PSAY TMPTER->ZN_CCDESC
		ENDIF
			nLin 	+= 1 // Avanca a linha de impressao
	ENDIF 
	
		nLin 	+= 1
	
	IF TMPTER->ZN_TIPO == "1" //Verica o tipo do registro para totais
		nTotDe	+= TMPTER->ZN_VALOR
		nQtdDe	+= 1
	ELSEIF TMPTER->ZN_TIPO == "2"
		nTotEm  += TMPTER->ZN_VALOR
		nQtdEm	+= 1
	ENDIF
	
	nSubTot	+= TMPTER->ZN_VALOR
	nSubQtd	+= 1
	cSit	:= TMPTER->ZN_SIT
	cTipo   := TMPTER->ZN_TIPO
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	IF (TMPTER->ZN_SIT != cSit) //Verifica a Situta็ใo do ativo
		IF MV_PAR01 == 2
			@nLin, 000 PSAY REPLICATE("-",(limite))
			nLin += 1
		ENDIF
		VerifSit(cSit)
		@nLin, 000 PSAY "TOTAL " + cSituacao
		@nLin, 060 PSAY nSubQTD  PICTURE "@E 9999"
		@nLin, 126 PSAY nSubTot  PICTURE "@E 999,999,999.99"
		nSubTot	:= 0
		nSubQtd	:= 0
		nLin += 1
	ENDIF
	
	IF (TMPTER->ZN_TIPO != cTipo) //Verica o tipo do registro para totais
		nLin += 1
		IF 	cTipo == "1"
			@nLin, 000 PSAY "TOTAL DE BENS EM TERCEIROS:"
			@nLin, 060 PSAY nQTDDe  PICTURE "@E 9999"
			@nLin, 126 PSAY nTotDe  PICTURE "@E 999,999,999.99"
		ELSEIF cTipo == "2"
			@nLin, 000 PSAY "TOTAL DE BENS DE TERCEIROS:"
			@nLin, 060 PSAY nQTDEm  PICTURE "@E 9999"
			@nLin, 126 PSAY nTotEm  PICTURE "@E 999,999,999.99"
		ENDIF
		nLin += 1
		@nLin, 000 PSAY REPLICATE("-",(limite))
		nLin += 2
	ENDIF
	
EndDo

dbSelectArea("TMPTER")
dbCloseArea("TMPTER")
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

Static Function VerifSit(cSit)

IF cSit 	== "1"
	cSituacao	:= "EMPRESTIMOS CONCEDIDOS"
ELSEIF cSit == "2"
	cSituacao	:= "EMPRESTIMOS RECEBIDOS"
ELSEIF cSit == "3"
	cSituacao	:= "LOCACAO"
ELSEIF cSit == "4"
	cSituacao	:= "CONSERTO"
ELSEIF cSit == "5"
	cSituacao	:= "DEMONSTRACAO"
ELSEIF cSit == "6"
	cSituacao	:= "TROCA EM GARANTIA"
ELSEIF cSit == "7"
	cSituacao	:= "ATIVOS PARA USO EXTERNO"
ENDIF

Return(cSituacao)

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Impr. Relatorio:","","","mv_ch01","N",01,0,0,"C","","mv_par01","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tipo Relatorio: ","","","mv_ch02","N",01,0,0,"C","","mv_par02","Em Terceiros","","","","","De Terceiros","","","","","Ambos","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do  Codigo		","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZN"})
AADD(aRegs,{cPerg,"04","Ate Codigo		","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZN"})
AADD(aRegs,{cPerg,"05","Do  Ativo  		","","","mv_ch05","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"06","Ate Ativo   	","","","mv_ch06","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"07","Da  NF Entrada	","","","mv_ch07","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate NF Entrada  ","","","mv_ch08","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Da  Entrada 	","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate Entrada 	","","","mv_ch10","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Da  NF Saida	","","","mv_ch11","C",10,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate NF Saida  	","","","mv_ch12","C",10,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Da  Saida 		","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ate Saida	 	","","","mv_ch14","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Do  C. Custo	","","","mv_ch15","C",10,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"16","Ate C. Custo	","","","mv_ch16","C",10,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"17","Do 	Fornecedor	","","","mv_ch17","C",06,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"18","Ate Fornecedor 	","","","mv_ch18","C",06,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"19","Descr. Contem:	","","","mv_ch19","C",20,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"20","Forne. Contem:  ","","","mv_ch20","C",20,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"21","Do  Prazo 		","","","mv_ch21","D",08,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"22","Ate Prazo	 	","","","mv_ch22","D",08,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"23","Linha Adicional?","","","mv_ch23","N",01,0,0,"C","","mv_par23","Sim","","","","","Nใo","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"24","Filtra Situa็ใo:","","","mv_ch24","C",20,0,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"25","Situa็ใo","","","mv_ch25","N",01,0,0,"C","","mv_par25","Ambos","","","","","Devolvidos","","","","","Em Aberto","","","","","","","","","","","","","",""})

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
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTAPAG    º Autor ³ Rafael Franca      º Data ³ 24/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de Fluxo de caixa Record DF                       º±±
±±|          |    													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Record DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTAPAG()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Fluxo de caixa - Contas a Pagar"
Local nLin           := 110

Local Cabec1         := UPPER("TITULO     NOME FORNECEDOR                          HISTORICO                              VENCTO   VENC. REAL                   VALOR                    SALDO          NATUREZA  DESCRICAO")
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "CTAPAG" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CTAPAG" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "CTAPAG9?"
Private cString      := "SE2"
Private cQuery      := ""
Private nCont	    := 0
Private cOrder		:= ""

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")                                                               
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.F.,Tamanho,,.T.)

IF MV_PAR37 == 1
	cOrder := "E2_FILIAL,E2_VENCREA,E2_NOMFOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
ELSEIF MV_PAR37 == 2
	cOrder := "E2_FILIAL,NATUREZ,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
ELSEIF MV_PAR37 == 3
	cOrder := "E2_FILIAL,E2_FORNECE,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO"
ENDIF

//Imprimir relatorio com dados Financeiros ou de Clientes

cQuery := "SELECT *   FROM SE2010 WHERE E2_FILIAL = '01' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
//cQuery += " AND E2_FORNECE <> '001105'" //Retirado a pedido da Sra Elisangela - 24/03/14
cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'" 
cQuery += " AND E2_SALDO > 0.00 "

If mv_par36 == 2
	cQuery += " AND E2_EMISSAO <= '" + DTOS(MV_PAR33) +"'"
Endif

If mv_par27 == 2
	cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")
	cQuery += " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")
Endif

If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";")
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
EndIf

If mv_par32 == 1
	cQuery += " AND E2_FLUXO <> 'N'"
Endif
cQuery += " ORDER BY "+ cOrder

tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

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

dbSelectArea("TMP")
dbCloseArea("TMP")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Rafael Franca      º Data ³  28/09/09   º±±
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

Local cMesVenc 		:= SUBSTR(TMP->E2_VENCREA,1,6)
Local cDiaVenc	 	:= TMP->E2_VENCREA
Local cNatureza		:= TMP->E2_NATUREZ
Local cFornece		:= TMP->E2_FORNECE
Local cLoja			:= TMP->E2_LOJA
Local nVldia	 	:= 0
Local nVlSub	    := 0
Local nVlTotal	    := 0
Local nVlNat 		:= 0
Local nVlfor 		:= 0
Local nTitulo      	:= 0
Local ntitulototal	:= 0
Local ntitulosub	:= 0
Local nSldia	 	:= 0
Local nSlSub	    := 0
Local nSlTotal	    := 0
Local nSlNat 		:= 0
Local nSlfor 		:= 0

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	SetRegua(RecCount())
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	IF (SUBSTR(TMP->E2_VENCREA,1,6) != cMesVenc) .AND. MV_PAR37 == 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin 	:= nLin + 1
		@nLin, 000 PSAY SUBSTR(TMP->E2_VENCREA,1,6)
		@nLin, 010 PSAY UPPER(Mes(STOD(TMP->E2_VENCREA)))
		nLin 	:= nLin + 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 2
	ElseIf (cNatureza != TMP->E2_NATUREZ) .AND. MV_PAR37 == 2
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin 	:= nLin + 1
		@nLin, 000 PSAY TMP->E2_NATUREZ
		@nLin, 020 PSAY UPPER(Posicione("SED",1,xFilial("SED")+TMP->E2_NATUREZ,"ED_DESCRIC"))
		nLin 	:= nLin + 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 2
	ElseIf (cFornece != TMP->E2_FORNECE) .AND. MV_PAR37 == 3
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin 	:= nLin + 1
		@nLin, 000 PSAY TMP->E2_FORNECE
		@nLin, 020 PSAY UPPER(Posicione("SA2",1,xFilial("SA2")+TMP->E2_FORNECE + TMP->E2_LOJA,"A2_NOME"))
		nLin 	:= nLin + 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 2
	Endif
	
	@nLin, 000 PSAY TMP->E2_NUM
	IF MV_PAR28 == 1
		@nLin, 011 PSAY	SUBSTR(UPPER(Posicione("SA2",1,xFilial("SA2")+TMP->E2_FORNECE + TMP->E2_LOJA,"A2_NOME")),1,32)
	ELSE
		@nLin, 011 PSAY	SUBSTR(UPPER(Posicione("SA2",1,xFilial("SA2")+TMP->E2_FORNECE + TMP->E2_LOJA,"A2_NREDUZ")),1,32)
	ENDIF
	@nLin, 052 PSAY SUBSTR(TMP->E2_HIST,1,35)
	@nLin, 090 PSAY STOD(TMP->E2_VENCTO)
	@nLin, 102 PSAY STOD(TMP->E2_VENCREA)
	@nLin, 120 PSAY TMP->E2_VALOR   PICTURE "@E 999,999,999.99"
	@nLin, 145 PSAY TMP->E2_SALDO   PICTURE "@E 999,999,999.99"
	@nLin, 169 PSAY TMP->E2_NATUREZ
	@nLin, 179 PSAY	Posicione("SED",1,xFilial("SED")+TMP->E2_NATUREZ,"ED_DESCRIC")
	
	//	nLin += 1
	
	nSlSub       += TMP->E2_SALDO
	nSlDia       += TMP->E2_SALDO
	nSlTotal	 += TMP->E2_SALDO
	nTitulo      += 1
	nTitulototal += 1
	nTituloSub	 += 1
	cFornece	 := TMP->E2_FORNECE
	cMesVenc 	 := SUBSTR(TMP->E2_VENCREA,1,6)
	cNatureza	 := TMP->E2_NATUREZ
	cDiaVenc	 := TMP->E2_VENCREA
	nVlSub       += TMP->E2_VALOR
	nVlDia       += TMP->E2_VALOR
	nVlTotal	 += TMP->E2_VALOR
	
	dbskip()
	
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF (TMP->E2_VENCREA != cDiaVenc)
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		@nLin, 000 PSAY "Total do dia:"
		@nLin, 020 PSAY STOD(cDiaVEnc)
		@nLin, 052 PSAY "Titulos:"
		@nLin, 060 PSAY nTitulo    PICTURE "@E 9999"
		@nLin, 120 PSAY nVlDia   PICTURE "@E 999,999,999.99"
		@nLin, 145 PSAY nSlDia   PICTURE "@E 999,999,999.99"
		nLin += 1
		nTitulo		:= 0
		nVlDia 		:= 0
	ENDIF
	
	IF (SUBSTR(TMP->E2_VENCREA,1,6) != cMesVenc) .AND. MV_PAR37 == 1
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		@nLin, 000 PSAY "SUB - TOTAL -->"
		@nLin, 020 PSAY UPPER(Mes(STOD(cMesVenc + "01")))
		@nLin, 052 PSAY "Titulos:"
		@nLin, 060 PSAY nTituloSub PICTURE "@E 9999"
		@nLin, 120 PSAY nVlSub   PICTURE "@E 999,999,999.99"
		@nLin, 145 PSAY nSlSub   PICTURE "@E 999,999,999.99"
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		nTituloSub	:= 0
		nSlSub 		:= 0
		nVlSub 		:= 0
	ELSEIF   (cNatureza != TMP->E2_NATUREZ) .AND. MV_PAR37 == 2
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		@nLin, 000 PSAY "SUB - TOTAL -->"
		@nLin, 020 PSAY UPPER(Posicione("CT1",1,xFilial("CT1")+ cNatureza ,"CT1_DESC01"))
		@nLin, 052 PSAY "Titulos:"
		@nLin, 060 PSAY nTituloSub PICTURE "@E 9999"
		@nLin, 120 PSAY nVlSub   PICTURE "@E 999,999,999.99"
		@nLin, 145 PSAY nSlSub   PICTURE "@E 999,999,999.99"
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		nTituloSub	:= 0
		nSlSub 		:= 0
		nVlSub 		:= 0
	ElseIf (cFornece != TMP->E2_FORNECE) .AND. MV_PAR37 == 3
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		@nLin, 000 PSAY "SUB - TOTAL -->"
		@nLin, 020 PSAY SUBSTR(UPPER(Posicione("SA2",1,xFilial("SA2")+TMP->E2_FORNECE + TMP->E2_LOJA,"A2_NOME")),1,30)
		@nLin, 052 PSAY "Titulos:"
		@nLin, 060 PSAY nTituloSub PICTURE "@E 9999"
		@nLin, 120 PSAY nVlSub   PICTURE "@E 999,999,999.99"
		@nLin, 145 PSAY nSlSub   PICTURE "@E 999,999,999.99"
		nLin += 1
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 1
		nTituloSub	:= 0
		nSlSub 		:= 0
		nVlSub 		:= 0
	ENDIF
	
	nLin += 1  // Avanca a linha de impressao
	
ENDDO

nLin += 1
@nLin, 000 PSAY "Total Geral -->"
@nLin, 052 PSAY "Titulos:"
@nLin, 060 PSAY nTituloTotal PICTURE "@E 9999"
@nLin, 120 PSAY nVlTotal   PICTURE "@E 999,999,999.99"
@nLin, 145 PSAY nSlTotal   PICTURE "@E 999,999,999.99"


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

DBSelectArea("TMP")
DBCloseArea("TMP")


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do Numero	  		","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"02","Ate o Numero  		","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"03","Do Prefixo	  		","","","mv_ch03","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate o Prefixo  		","","","mv_ch04","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Natureza			","","","mv_ch05","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"06","Ate a Natureza		","","","mv_ch06","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"07","Do Vencimento   	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate o Vencimento	","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Banco	  		","","","mv_ch09","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
AADD(aRegs,{cPerg,"10","Ate o Banco  		","","","mv_ch10","C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
AADD(aRegs,{cPerg,"11","Do Fornecedor  		","","","mv_ch11","C",09,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"12","Ate o Fornecedor	","","","mv_ch12","C",09,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"13","Da Emissao	   		","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ate a Emissao		","","","mv_ch14","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Qual Moeda			","","","mv_ch15","C",01,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Imp. Provisorios	","","","mv_ch16","N",01,0,2,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Converte venc pela	","","","mv_ch17","N",01,0,2,"C","","mv_par17","Data Venc.","","","","","Data Base","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"18","Da Dt Contabil   	","","","mv_ch18","D",08,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"19","Ate a Dt Contabil	","","","mv_ch19","D",08,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"20","Imprime Relatorio	","","","mv_ch20","N",01,0,2,"C","","mv_par20","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"21","Saldo Retroativo	","","","mv_ch21","N",01,0,2,"C","","mv_par21","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"22","Considera filiais	","","","mv_ch22","N",01,0,2,"C","","mv_par22","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"23","Da Filial	  		","","","mv_ch23","C",02,0,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"24","Ate a Filial 		","","","mv_ch24","C",02,0,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"25","Da Loja	  			","","","mv_ch25","C",02,0,0,"G","","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"26","Ate a Loja 			","","","mv_ch26","C",02,0,0,"G","","mv_par26","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"27","Considera Adiantam.	","","","mv_ch27","N",01,0,2,"C","","mv_par27","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"28","Imprime Nome		","","","mv_ch28","N",01,0,2,"C","","mv_par28","Razao Social","","","","","Nome Fantazia","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"29","Outras Moedas		","","","mv_ch29","N",01,0,2,"C","","mv_par29","Nao Imprimir","","","","","Imprime","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"30","Imprime tipos	  	","","","mv_ch30","C",30,0,0,"G","","mv_par30","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"31","Nao imprime tipos	","","","mv_ch31","C",30,0,0,"G","","mv_par31","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"32","So Tit. p/ fluxo	","","","mv_ch32","N",01,0,2,"C","","mv_par32","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"33","Data Base			","","","mv_ch33","D",08,0,0,"G","","mv_par33","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"34","Compoe saldo por	","","","mv_ch34","N",01,0,2,"C","","mv_par34","Data da Baixa","","","","","Data Digitacao.","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"35","Quanto a Taxa		","","","mv_ch35","N",01,0,2,"C","","mv_par35","Tx Normal","","","","","Tx Contratada","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"36","Tit. emissao futura	","","","mv_ch36","N",01,0,2,"C","","mv_par36","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"37","Ordem				","","","mv_ch37","N",01,0,2,"C","","mv_par37","Vencimento","","","","","Natureza","","","","","Fornecedor","","","","","","","","","","","","","","","","","",""})

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
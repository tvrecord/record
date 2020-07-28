#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPEDIDO º Autor ³Rafael França       º Data ³  06/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio com detalhes dos pedidos de compras               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORD DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELPEDIDO()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio com detalhes dos pedidos de compras"
Local cPict          := ""
Local titulo       	 := "Relatorio com detalhes dos pedidos de compras"
Local nLin         	 := 80
Local Cabec1      	 := " Item     Produto  Descrição                                   QTD     Vl. Unitario       Vl. Total"
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private aOrd         	:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite       	:= 80
Private tamanho      	:= "M"
Private nomeprog        := "RELPEDIDO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       	:= "RELPEDIDO1"
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELPEDIDO" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC7"

dbSelectArea("SC7")
dbSetOrder(1)

ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery	:= ""
Local cFornece	:= ""
Local cLoj		:= ""
Local cPedido	:= ""
Local nValForn	:= 0
Local nValPed	:= 0
Local nVlTotal	:= 0
Local nOrdem
Local lOk		:= .F.
Local nCount	:= 0

cQuery	:= "SELECT C8_NUM,C7_PRODUTO,C7_ITEM,C7_DESCRI,C7_PRECO,C7_TOTAL,C7_QUANT,ZL_PEDIDO,C7_FORNECE,C7_LOJA,C7_CONAPRO,COUNT(C8_FILIAL) AS QUANTIDADE  FROM SC8010 "
cQuery	+= "INNER JOIN SZL010 ON C8_NUM = ZL_COTACAO "
cQuery	+= "INNER JOIN SC7010 ON ZL_PEDIDO = C7_NUM AND C8_PRODUTO = C7_PRODUTO "
cQuery	+= "WHERE SC8010.D_E_L_E_T_ = '' "
cQuery	+= "AND SZL010.D_E_L_E_T_ = '' "
cQuery	+= "AND SC7010.D_E_L_E_T_ = '' "
cQuery	+= "AND C7_CONAPRO = 'L' "
cQuery	+= "AND ZL_PEDIDO  BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
cQuery	+= "AND C8_EMISSAO BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"' "
cQuery	+= "AND C8_PRODUTO BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "
cQuery	+= "AND C8_FORNECE BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' "
cQuery	+= "GROUP BY C8_NUM,C7_PRODUTO,C7_ITEM,C7_DESCRI,C7_PRECO,C7_TOTAL,C7_QUANT,ZL_PEDIDO,C7_FORNECE,C7_LOJA,C7_CONAPRO "
cQuery	+= "HAVING COUNT(C8_FILIAL) = 1 "
cQuery	+= "ORDER BY C7_FORNECE,ZL_PEDIDO,C7_ITEM,C7_PRODUTO "

TcQuery cQuery New Alias "TMPPED"


dbSelectArea("TMPPED")


SetRegua(RecCount())


dbGoTop()
While !EOF()
	
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	If nLin > 058 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF (TMPPED->C7_FORNECE != cFornece)
		
		IF lOk
			nLin := nLin + 1
		EndIf
		
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		//nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY UPPER(TMPPED->C7_FORNECE + "-" + TMPPED->C7_LOJA)
		@nLin, 012 PSAY UPPER(Posicione("SA2",1,xFilial("SA2")+TMPPED->C7_FORNECE + TMPPED->C7_LOJA,"A2_NOME"))
		//nLin := nLin + 1 // Avanca a linha de impressao            "
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nValForn	:= 0
		lOk			:= .T.
	Endif
	
	IF (cPedido		!= TMPPED->ZL_PEDIDO) .OR. (TMPPED->C7_FORNECE != cFornece)
		
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY "Pedido"
		@nLin, 010 PSAY TMPPED->ZL_PEDIDO
		
		cQuery1	:= "SELECT D1_DOC FROM SD1010 WHERE D_E_L_E_T_ = '' AND D1_COD = '" + TMPPED->C7_PRODUTO + "' AND D1_FORNECE = '" + TMPPED->C7_FORNECE + "' AND D1_PEDIDO = '" + TMPPED->ZL_PEDIDO + "'"
		TcQuery cQuery1 New Alias "TMPPED1"
		dbSelectArea("TMPPED1")
		Count to nCount
		dbGoTop("TMPPED1")
		
		IF nCount > 0
			@nLin, 050 PSAY "Documento"
			@nLin, 062 PSAY TMPPED1->D1_DOC
		ENDIF
		
		dbSelectArea("TMPPED1")
		dbCloseArea("TMPPED1")    
		
		nLin := nLin + 1 // Avanca a linha de impressao"
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		
	Endif
	
	@nLin, 001 PSAY TMPPED->C7_ITEM
	@nLin, 010 PSAY TMPPED->C7_PRODUTO
	@nLin, 020 PSAY SUBSTR(TMPPED->C7_DESCRI,1,38)
	@nLin, 063 PSAY TMPPED->C7_QUANT PICTURE "@E 9999"
	@nLin, 074 PSAY	TMPPED->C7_PRECO PICTURE "@E 999,999.99"
	@nLin, 091 PSAY	TMPPED->C7_TOTAL PICTURE "@E 999,999.99"
	
	
	nValForn	+= TMPPED->C7_TOTAL
	nValPed		+= TMPPED->C7_TOTAL
	nVlTotal	+= TMPPED->C7_TOTAL
	cPedido		:= TMPPED->ZL_PEDIDO
	cFornece	:= TMPPED->C7_FORNECE
	cLoja		:= TMPPED->C7_LOJA
	nLin 		:= nLin + 1 // Avanca a linha de impressao
	
	dbSelectArea("TMPPED")
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	IF (cPedido		!= TMPPED->ZL_PEDIDO) .OR. (TMPPED->C7_FORNECE != cFornece)
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY "Total pedido:"
		@nLin, 015 PSAY cPedido
		@nLin, 090 PSAY nValPed PICTURE "@E 999,999.99"
		nValPed	:= 0
		nLin 	:= nLin + 1 // Avanca a linha de impressao"
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		//nLin := nLin + 2 // Avanca a linha de impressao
	Endif
	
	IF (TMPPED->C7_FORNECE != cFornece)
		IF lOk
			nLin := nLin + 1
		EndIf
		
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		//nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY UPPER("Total fornecedor:")
		@nLin, 022 PSAY UPPER(Posicione("SA2",1,xFilial("SA2")+ cFornece + cLoja,"A2_NOME"))
		@nLin, 090 PSAY nValForn PICTURE "@E 999,999.99" 
		nValForn	:= 0
		//nLin := nLin + 1 // Avanca a linha de impressao"
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 2 // Avanca a linha de impressao
		
	Endif
	
EndDo

nLin := nLin + 1
@nLin, 001 PSAY "TOTAL GERAL:"
@nLin, 090 PSAY nVlTotal

dbSelectArea("TMPPED")
dbCloseArea("TMPPED")


SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Do Pedido       	","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"02","Ate o Pedido		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"03","Da Emissão   		","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Emissão		","","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Produto       	","","","mv_ch5","C",09,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"06","Ate o Produto		","","","mv_ch6","C",09,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"07","Do Fornecedor      	","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"08","Ate o Fornecedor	","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"09","Tipo do Relatorio  	","","","mv_ch9","N",01,00,1,"C","","mv_par09","For. Exclusivo","","","","","Pedidos Pendentes","","","","","Produtos pendentes","","","","","","","","","","","","","","" })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.t.)
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
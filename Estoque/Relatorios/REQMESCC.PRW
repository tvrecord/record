#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREQMES    บ Autor ณ Rafael Franca      บ Data ณ 24/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelacao de requisicoes ao almoxerificado                    บฑฑ
ฑฑ|          |    													      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRecord DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function REQMESCC()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "RELAวรO DE REQUISIวีES DO ESTOQUE"
Local nLin           := 110

Local Cabec1         := ""
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "REQMESCC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "REQMESCC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "REQMESCC"
Private cString      := "SD3"
Private cQuery       := ""
Private nCont	    := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

//Imprimir relatorio com dados Financeiros ou de Clientes

IF MV_PAR14 == 2
	Titulo := Alltrim(Titulo) + " DE " + DTOS(MV_PAR03) + " - " + DTOS(MV_PAR04) + "  (Analitico)"
	Cabec1      := UPPER("DOCUMENTO  PRODUTO  DESCRICAO                                    QTD                    VALOR    EMISSAO   USUARIO")
ELSE
	Titulo := Alltrim(Titulo) + " DE " + DTOS(MV_PAR03) + " - " + DTOS(MV_PAR04) + "  (Sintetico)"
	Cabec1  	:= UPPER("CONTA CONTABIL      DESCRICAO                                              QTD                                         VALOR")
ENDIF


cQuery := "SELECT D3_TM,D3_COD,D3_QUANT,D3_CF,D3_CONTA, "
cQuery += "D3_DOC,D3_EMISSAO,D3_CUSTO1,D3_USUARIO,D3_CC,D3_OBS "
cQuery += "FROM SD3010 WHERE D_E_L_E_T_ <> '*' "
cQuery += "AND D3_CF = 'RE0' "
cQuery += "AND D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += "AND D3_COD BETWEEN '" + (MV_PAR12) + "' AND '" + (MV_PAR13) + "' "
cQuery += "AND D3_DOC BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "
cQuery += "AND D3_LOCAL BETWEEN '" + (MV_PAR16) + "' AND '" + (MV_PAR17) + "' "  
cQuery += "AND D3_TM BETWEEN '" + (MV_PAR18) + "' AND '" + (MV_PAR19) + "' "
cQuery += "AND D3_CONTA BETWEEN '" + (MV_PAR10) + "' AND '" + (MV_PAR11) + "' " 
cQuery += "AND D3_CC BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' "
cQuery += "AND D3_ESTORNO <> 'S' "
IF MV_PAR07 == 1
	cQuery += "ORDER BY D3_EMISSAO,D3_DOC "
ELSE
	cQuery += "ORDER BY D3_CC,D3_CONTA,D3_DOC "
ENDIF

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

dbSelectArea("TMP")
dbCloseArea("TMP")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
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

Local cDtEmissao 	:= SUBSTR(TMP->D3_EMISSAO,1,6)
Local cConta		:= ""
Local cCustos		:= ""
Local nProdutos 	:= 0
Local nProdDOC	    := 0
Local nVlDoc    	:= 0
Local nVlTotal	    := 0
Local nProdMes 		:= 0
Local nVlMes 		:= 0
Local nItem       	:= 0
Local nItemtotal	:= 0
Local nItemMes		:= 0
Local cMes			:= ""
Local lOk 			:= .T.
Local cNomeCC		:= ""

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


While !EOF() 

	If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
	Endif
    
	If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
	Endif

	SetRegua(RecCount())
	
	IF MV_PAR14 == 2 // Relatorio analitico
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		
		IF (SUBSTR(TMP->D3_EMISSAO,1,6) != cDtEmissao) .AND. MV_PAR07 == 1 .AND. MV_PAR21 == 1 
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin 	:= nLin + 1
			@nLin, 000 PSAY SUBSTR(TMP->D3_EMISSAO,1,6)
			@nLin, 010 PSAY UPPER(Mes(STOD(TMP->D3_EMISSAO)))
			nLin 	:= nLin + 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
		Endif
		
		
		IF (TMP->D3_CC != cCustos) .AND. MV_PAR07 == 2
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin 	:= nLin + 1   
			@nLin, 000 PSAY TMP->D3_CC
			@nLin, 010 PSAY Posicione("CTT",1,xFilial("CTT")+ TMP->D3_CC,"CTT_DESC01")
			nLin 	:= nLin + 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
		Endif
		
		IF (cConta != TMP->D3_CONTA) .AND. MV_PAR21 == 1 .OR. (cCustos != TMP->D3_CC) .AND. MV_PAR21 == 1
			@nLin, 000 PSAY ALLTRIM(TMP->D3_CONTA)
			@nLin, 016 PSAY UPPER(Posicione("CT1",1,xFilial("CT1")+TMP->D3_CONTA,"CT1_DESC01"))
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
		ENDIF
		
		@nLin, 000 PSAY ALLTRIM(TMP->D3_DOC)
		@nLin, 011 PSAY ALLTRIM(TMP->D3_COD)
		@nLin, 021 PSAY Posicione("SB1",1,xFilial("SB1") + TMP->D3_COD,"B1_DESC")
		@nLin, 065 PSAY TMP->D3_QUANT PICTURE "@E 9999"
		@nLin, 080 PSAY TMP->D3_CUSTO1 PICTURE "@E 999,999,999.99"
		@nLin, 097 PSAY STOD(TMP->D3_EMISSAO)  
		IF MV_PAR20  == 1
		@nLin, 108 PSAY UPPER(TMP->D3_USUARIO)
		ELSE    
		@nLin, 108 PSAY SUBSTR(UPPER(TMP->D3_OBS),1,25)
		ENDIF
		
		//	nLin += 1
		
		nProdutos  	+= TMP->D3_QUANT
		nProdDOC 	+= TMP->D3_QUANT
		nProdMes 	+= TMP->D3_QUANT
		nItem       += 1
		nItemtotal	+= 1
		nItemMes	+= 1
		cDtEmissao 	:= SUBSTR(TMP->D3_EMISSAO,1,6)
		cCustos		:= TMP->D3_CC
		cConta		:= TMP->D3_CONTA
		nVlMes      += TMP->D3_CUSTO1
		nVlDoc      += TMP->D3_CUSTO1
		nVlTotal	+= TMP->D3_CUSTO1
		cNomeCC 	:= Posicione("CTT",1,xFilial("CTT")+ TMP->D3_CC,"CTT_DESC01")
		
		dbskip()		
		
		IF (TMP->D3_CONTA != cConta) .AND. MV_PAR21 == 1 .OR. (cCustos != TMP->D3_CC) .AND. MV_PAR21 == 1
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY UPPER("Total da Conta:")
			@nLin, 018 PSAY SUBSTR(UPPER(Posicione("CT1",1,xFilial("CT1")+cConta,"CT1_DESC01")),1,40)
			//@nLin, 040 PSAY "Itens:"
			//@nLin, 050 PSAY nItem    PICTURE "@E 9999"
			@nLin, 065 PSAY nProdDOC PICTURE "@E 9999"
			@nLin, 080 PSAY nVlDoc   PICTURE "@E 999,999,999.99"
			nLin += 1
			nItem		:= 0
			nProdDOC 	:= 0 ๚
			nVlDoc 		:= 0
		ENDIF
		
		IF (SUBSTR(TMP->D3_EMISSAO,1,6) != cDtEmissao) .AND. MV_PAR07 == 1 .AND. MV_PAR21 == 1
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY UPPER("Total da Mes:")
			@nLin, 020 PSAY UPPER(Mes(STOD(cDtEmissao + "01")))
			@nLin, 040 PSAY UPPER("Itens:")
			@nLin, 050 PSAY nItemMes PICTURE "@E 9999"
			@nLin, 065 PSAY nProdMes PICTURE "@E 9999"
			@nLin, 080 PSAY nVlMes   PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
			IF MV_PAR15 == 1
				nLin += 70
			ENDIF
			nItemMes	:= 0
			nProdMes 	:= 0 ๚
			nVlMes 		:= 0
		ENDIF
		
		IF (cCustos != TMP->D3_CC) .AND. MV_PAR07 == 2
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY UPPER("Total do C. Custo:")
			@nLin, 020 PSAY cNomeCC
			//		@nLin, 040 PSAY "Itens:"
			//		@nLin, 050 PSAY nItemMes PICTURE "@E 9999"
			@nLin, 065 PSAY nProdMes PICTURE "@E 9999"
			@nLin, 080 PSAY nVlMes   PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
			IF MV_PAR15 == 1
				nLin += 70
			ENDIF
			nItemMes	:= 0
			nProdMes 	:= 0 ๚
			nVlMes 		:= 0
		ENDIF
		
		nLin += 1  // Avanca a linha de impressao
		
	ELSE
		
		IF (cCustos != TMP->D3_CC)
			nLin += 1
			@nLin, 000 PSAY ALLTRIM(TMP->D3_CC)
			@nLin, 010 PSAY Posicione("CTT",1,xFilial("CTT")+TMP->D3_CC,"CTT_DESC01")
			//		@nLin, 040 PSAY "Itens:"
			//		@nLin, 050 PSAY nItemMes PICTURE "@E 9999"
			//@nLin, 074 PSAY nProdMes PICTURE "@E 9999"
			//@nLin, 110 PSAY nVlMes   PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			nItemMes	:= 0
			nProdMes 	:= 0 ๚
			nVlMes 		:= 0
		ENDIF
		
		nProdutos  	+= TMP->D3_QUANT
		nProdDOC 	+= TMP->D3_QUANT
		nProdMes 	+= TMP->D3_QUANT
		nItem       += 1
		nItemtotal	+= 1
		nItemMes	+= 1
		cDtEmissao 	:= SUBSTR(TMP->D3_EMISSAO,1,6)
		cCustos		:= TMP->D3_CC
		cConta		:= TMP->D3_CONTA
		nVlMes      += TMP->D3_CUSTO1
		nVlDoc      += TMP->D3_CUSTO1
		nVlTotal	+= TMP->D3_CUSTO1
		
		dbskip()
		
		IF (TMP->D3_CONTA != cConta) .OR. (cCustos != TMP->D3_CC)
			//@nLin, 000 PSAY "CONTA CONTABIL:"
			@nLin, 001 PSAY ALLTRIM(cConta)
			@nLin, 015 PSAY UPPER(Posicione("CT1",1,xFilial("CT1")+cConta,"CT1_DESC01"))
			//@nLin, 040 PSAY "Itens:"
			//@nLin, 050 PSAY nItem    PICTURE "@E 9999"
			@nLin, 074 PSAY nProdDOC PICTURE "@E 9999"
			@nLin, 110 PSAY nVlDoc   PICTURE "@E 999,999,999.99"
			//nLin += 1
			//@nLin, 000 PSAY Replicate("-",Limite)
			nItem		:= 0
			nProdDOC 	:= 0 ๚
			nVlDoc 		:= 0
			nLin += 1
		ENDIF
		
		IF (SUBSTR(TMP->D3_EMISSAO,1,6) != cDtEmissao) .AND. MV_PAR07 == 1
			
			nLin += 1
			//@nLin, 000 PSAY "Total da Mes:"
			@nLin, 000 PSAY UPPER(Mes(STOD(cDtEmissao + "01")))
			@nLin, 040 PSAY UPPER("Itens:")
			@nLin, 050 PSAY nItemMes PICTURE "@E 9999"
			@nLin, 064 PSAY nProdMes PICTURE "@E 9999"
			@nLin, 079 PSAY nVlMes   PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			nItemMes	:= 0
			nProdMes 	:= 0 ๚
			nVlMes 		:= 0
		ENDIF
		
		IF (cCustos != TMP->D3_CC)
			nLin += 1
			@nLin, 000 PSAY "TOTAL C. CUSTO:"
			@nLin, 020 PSAY Posicione("CTT",1,xFilial("CTT")+ cCustos,"CTT_DESC01")
			@nLin, 074 PSAY nProdMes PICTURE "@E 9999"
			@nLin, 110 PSAY nVlMes   PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			nItemMes	:= 0
			nProdMes 	:= 0 ๚
			nVlMes 		:= 0
		ENDIF
		
		
	ENDIF
	
ENDDO

IF MV_PAR14 == 2
	
	nLin += 1
	@nLin, 000 PSAY UPPER("Total Geral -->")
	@nLin, 040 PSAY UPPER("Itens:")
	@nLin, 050 PSAY nItemTotal PICTURE "@E 9999"
	@nLin, 064 PSAY nProdutos  PICTURE "@E 9999"
	@nLin, 079 PSAY nVlTotal   PICTURE "@E 999,999,999.99"
	
ELSE
	
	nLin += 1
	@nLin, 000 PSAY UPPER("Total Geral -->")
	@nLin, 040 PSAY UPPER("Itens:")
	//@nLin, 050 PSAY nItemTotal PICTURE "@E 9999"
	@nLin, 074 PSAY nProdutos  PICTURE "@E 9999"
	@nLin, 110 PSAY nVlTotal   PICTURE "@E 999,999,999.99"
	
ENDIF

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

DBSelectArea("TMP")
DBCloseArea("TMP")

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do  Documento  ","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SD3"})
AADD(aRegs,{cPerg,"02","Ate Documento  ","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SD3"})
AADD(aRegs,{cPerg,"03","Da  Emissao    ","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Emissao    ","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Do  C. Custos  ","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Ate C. Custos  ","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","Ordem			","","","mv_ch07","N",01,0,2,"C","","mv_par07","Data","","","","","C. Custo","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Da  Dt Contabil","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Ate Dt Contabil","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Da  C. Contabil","","","mv_ch10","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"11","Ate C. Contabil","","","mv_ch11","C",20,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"12","Do  Produto    ","","","mv_ch12","C",07,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"13","Ate Produto    ","","","mv_ch13","C",07,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"14","Tp do Relatorio","","","mv_ch14","N",01,0,2,"C","","mv_par14","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Salta Pag P/ CC","","","mv_ch15","N",01,0,2,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Do  Armazem    ","","","mv_ch16","C",02,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Ate Armazem    ","","","mv_ch17","C",02,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})  
AADD(aRegs,{cPerg,"18","Do Tipo			","","","mv_ch18","C",03,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","SF5"})
AADD(aRegs,{cPerg,"19","Ate o Tipo		","","","mv_ch19","C",03,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","SF5"}) 
AADD(aRegs,{cPerg,"20","Ordem			","","","mv_ch20","N",01,0,2,"C","","mv_par20","Usuario","","","","","OBS","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"21","Totais p/ Conta	","","","mv_ch21","N",01,0,2,"C","","mv_par21","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})

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
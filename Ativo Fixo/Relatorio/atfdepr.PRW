#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFDEPR   บ Autor ณ Rafael Franca      บ Data ณ 08/12/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ ATIVOS DA RECORD POR CONTA CONTABIL / CENTRO DE CUSTOS     บฑฑ
ฑฑ|          |     														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ATFDEPR

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variavei                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Ativos por Conta Contabil"
Local nLin           := 100

Local Cabec1         := " Ativo      Descricao                                            Valor      Aquisicao  In. Depr.  %Anual          Depr. Acumulada"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "ATFDEPR"// Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ATFDEPR1"// Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "ATFDEPR4"
Private cString      := "SN1"
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
IF MV_PAR10 == 2
	titulo       	 := "Ativos por Centro de Custos"
ENDIF

IF MV_PAR09 == 1
	Cabec1         := " Ativo      Descricao                                               Valor   Aquisicao  In. Depr.    %Anual        Depr. Acumulada"
ENDIF

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

IF MV_PAR10 == 2
	cQuery := "SELECT N1_FILIAL,N1_CBASE,N1_ITEM,N1_AQUISIC,N1_DESCRIC,N3_TIPO,N3_CCONTAB,N3_VORIG1,N3_DINDEPR,N3_TXDEPR1,N3_VRDACM1,N3_VRCACM1,N3_CUSTBEM AS CODCC "
ELSE
	cQuery := "SELECT N1_FILIAL,N1_CBASE,N1_ITEM,N1_AQUISIC,N1_DESCRIC,N3_TIPO,N3_CCONTAB AS CODCC,N3_VORIG1,N3_DINDEPR,N3_TXDEPR1,N3_VRDACM1,N3_VRCACM1,N3_CUSTBEM "
END
cQuery += "FROM SN1010 INNER JOIN SN3010 "
cQuery += "ON SN1010.N1_FILIAL = SN3010.N3_FILIAL AND SN1010.N1_CBASE = SN3010.N3_CBASE AND SN1010.N1_ITEM = SN3010.N3_ITEM "
cQuery += "WHERE SN1010.D_E_L_E_T_ <> '*'  AND SN1010.N1_CBASE BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cQuery += "AND SN1010.N1_BAIXA = '' "
IF !EMPTY (MV_PAR07)
	cQuery += "AND SN1010.N1_FILIAL = '"+(MV_PAR07)+"' "
	cQuery += "AND SN3010.N3_FILIAL = '"+(MV_PAR07)+"' "
ENDIF
IF MV_PAR08 == 2
	cQuery += "AND SN1010.N1_CHAPA <> '' "              		
	cQuery += "AND SN3010.N3_CCONTAB <> '' "
ENDIF
cQuery += "AND SN3010.N3_AQUISIC BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' AND SN3010.D_E_L_E_T_ <> '*' "
cQuery += "AND SN3010.N3_CCONTAB BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' "
cQuery += "AND SN3010.N3_CUSTBEM BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
IF MV_PAR10 == 1
	cQuery += "ORDER BY SN3010.N3_CCONTAB,SN1010.N1_CBASE"
ELSE
	cQuery += "ORDER BY SN3010.N3_CCUSTO,SN1010.N1_CBASE"
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

Local cCodCC 	 := ""
Local cConta 	 := ""
Local nDepreCC	 := 0
Local nValorCC   := 0
Local nDepreTT	 := 0
Local nValorTT   := 0
Local cNome 	 := ""
Local cCodATF    := ""
Local nAtivos	 := 0
Local nAtivoTot  := 0 
Local nValorDepr := 0   
Local nQry		 := ""

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	SetRegua(RecCount())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit                                             
		
		
	Endif
	
	If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	 
	cQry 	:= " SELECT SUM(N4_VLROC1) AS VALORDEPR "
	cQry 	+= " FROM " + RetSqlName("SN4")
	cQry	+= " WHERE N4_FILIAL  = '" + xFilial("SN4")	+ "' AND "
	cQry 	+= " N4_CBASE   = '" + TMP->N1_CBASE + "' AND "
	cQry 	+= " N4_ITEM    = '" + TMP->N1_ITEM	 + "' AND "
	cQry 	+= " N4_TIPO    = '" + TMP->N3_TIPO	 + "' AND "
//	cQry 	+= " N4_DATA   >= '" +DTOS(MV_PAR05)+ "' AND "๚
	cQry 	+= " N4_DATA   <= '" +DTOS(MV_PAR06)+ "' AND "
	cQry 	+= " N4_OCORR   = '06' AND "
	cQry 	+= " N4_TIPOCNT = '4'  AND "
	cQry 	+= " D_E_L_E_T_ = ' ' "	 
	cQry 	+= " GROUP BY N4_CBASE,N4_ITEM "			

	TcQuery cQry New Alias "TRX"   
	 
	dbSelectArea ("TRX")
	IF TRX->VALORDEPR > 0 .AND. TRX->VALORDEPR <= (TMP->N3_VRDACM1 * 0.98) 
    nValorDepr := TRX->VALORDEPR
	ELSE
    nValorDepr := TMP->N3_VRDACM1
	ENDIF
	

	
	IF (TMP->CODCC != cCodCC)
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY TMP->CODCC
		IF MV_PAR10 == 1
			@nLin, 015 PSAY Posicione("CT1",1,xFilial("CT1")+TMP->CODCC,"CT1_DESC01")
		ELSE
			@nLin, 015 PSAY Posicione("CTT",1,xFilial("CTT")+TMP->CODCC,"CTT_DESC01")
		ENDIF
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nAtivos 	:= 0
		nDepreCC	:= 0
		nValorCC  	:= 0
	Endif
	
	
	@nLin, 001 PSAY TMP->N1_CBASE
	@nLin, 012 PSAY TMP->N1_DESCRIC
	@nLin, 056 PSAY TMP->N3_VORIG1 + TMP->N3_VRCACM1 PICTURE "@E 999,999,999.99"
	@nLin, 076 PSAY STOD(TMP->N1_AQUISIC)
	@nLin, 087 PSAY STOD(TMP->N3_DINDEPR)
	@nLin, 098 PSAY TMP->N3_TXDEPR1 PICTURE "@E 999,99"
	@nLin, 110 PSAY nValorDepr PICTURE "@E 999,999,999.99"
	
	
	nAtivos   	+= 1
	nAtivoTot 	+= 1
	cCodCC 		:= TMP->CODCC
	nDepreCC	+= nValorDepr
	nValorCC  	+= TMP->N3_VORIG1 + TMP->N3_VRCACM1
	nDepreTT	+= nValorDepr
	nValorTT  	+= TMP->N3_VORIG1 + TMP->N3_VRCACM1
	 
	dbSelectArea ("TRX")
	dbCloseArea  ("TRX")
	
	dbSelectArea ("TMP")
	dbskip()
	
	/*
	
	IF (TMP->RF_MAT != cCodMat)
	nLin += 1
	@nLin, 000 PSAY "Total de Horas do Funcionario "
	@nLin, 030 PSAY cCodMat  + " : "
	@nLin, 040 PSAY nHorasFunc
	nHorasFunc := 0
	nLin += 1
	ENDIF
	
	*/
	
	IF (TMP->CODCC != cCodCC)
		nLin += 2
		IF MV_PAR10 == 1
		@nLin, 001 PSAY "Ativos na Conta Contabil"  
		ELSE  
		@nLin, 001 PSAY "Ativos no Centro de Custo"
		ENDIF
		@nLin, 030 PSAY SUBSTR(cCodCC,1,14)+": "
		@nLin, 046 PSAY nAtivos  PICTURE "@E 999"
		@nLin, 057 PSAY nValorCC PICTURE "@E 999,999,999.99"
		@nLin, 111 PSAY nDepreCC PICTURE "@E 999,999,999.99"
		nLin += 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	ENDIF
	 
	cQry 		:= ""
	nValorDepr  := 0 
	nLin 		:= nLin + 2 // Avanca a linha de impressao
	
ENDDO

@nLin, 001 PSAY "Total de Ativos: "
@nLin, 030 PSAY nAtivoTot PICTURE "@E 99999"
@nLin, 056 PSAY nValorTT  PICTURE "@E 999,999,999.99"                                                          ๚
@nLin, 110 PSAY nDepreTT  PICTURE "@E 999,999,999.99"

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

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Conta ?","","","mv_ch01","C",20,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"02","Ate Conta ?","","","mv_ch02","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"03","Do  Bem    ?","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"04","Ate Bem 	?","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"05","Da  Emissao ?","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Emissao ?","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Consid. Filia?","","","mv_ch07","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Nao Classificados?","","","mv_ch08","N",01,0,0,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Impr. Fornecedores?","","","mv_ch09","N",01,0,0,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ordem Relatorio","","","mv_ch10","N",01,0,0,"C","","mv_par10","Conta","","","","","C. Custo","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Do  C. Custo ?","","","mv_ch11","C",20,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"12","Ate C. Custo ?","","","mv_ch12","C",20,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})

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
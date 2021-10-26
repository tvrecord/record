#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpSIG     บ Autor ณ RAFAEL FRANCA      บ Data ณ  07/03/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRECORD DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ImpSIG

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local titulo       	 := "SIG "
Local nLin           := 100
Local Cabec1         := UPPER(" Cod. SIG     Descricao                                                    Valor")
Local Cabec2         := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "IMPSIG" //Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "IMPSIG" //Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "IMPSIG3"
Private cString      := "SZR"
Private cQuery       := ""
Private nCont	     := 0


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("Opera็ใo cancelada pelo usuแrio")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IF 	   MV_PAR01  == 1
	titulo       += "- Sintetico - " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
ELSEIF MV_PAR01  == 2
	titulo       += "- C. Custo - " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
ELSEIF MV_PAR01  == 3
	titulo       += "- Lan็amentos - " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
	Cabec1		 := UPPER(" Documento    Cli/For    Nome                                                    Valor   Historico")
	limite       := 132
	tamanho      := "M"
ELSEIF MV_PAR01  == 4
	titulo       += "- Erro Log - " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
	Cabec1		 := UPPER("Per.   Documento      Cliente   For.    C. Custo   Ct. Sig       Valor        Modulo   Conta        Descri็ใo")
	limite       := 132
	tamanho      := "M"
ENDIF


wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

IF 	   MV_PAR01 == 1  //Sintetico
	cQuery := "SELECT ZR_TIPO,ZR_CTASIG,SUM(ZR_VALOR) AS VALOR FROM SZR010 "
	//cQuery += "INNER JOIN CTT010 ON CTT_CUSTO = ZR_CC "
	cQuery += "WHERE SZR010.D_E_L_E_T_ = '' "//AND CTT010.D_E_L_E_T_ = '' AND CTT010.CTT_CCSIG <> '' "
	cQuery += "AND ZR_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cQuery += "AND ZR_CTASIG BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
	cQuery += "AND ZR_CONTA BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
	//cQuery += "AND CTT_CCSIG BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
	cQuery += "AND ZR_TIPO NOT IN ('E','F') "
	cQuery += "AND ZR_TIPO IN ('C','D') "
	IF 	   MV_PAR02 == 1
		cQuery += "AND ZR_TIPO = 'D' "
	ELSEIF MV_PAR02 == 2
		cQuery += "AND ZR_TIPO = 'C' "
	ENDIF
	cQuery += "GROUP BY ZR_TIPO,ZR_CTASIG "
	cQuery += "ORDER BY ZR_TIPO,ZR_CTASIG "

ELSEIF MV_PAR01 == 2  //Centro de custo - Sintetico
	cQuery := "SELECT CTT_CCSIG,ZR_TIPO,ZR_CTASIG,SUM(ZR_VALOR) AS VALOR FROM SZR010 INNER JOIN CTT010 ON ZR_CC = CTT_CUSTO  "
	cQuery += "WHERE SZR010.D_E_L_E_T_ = '' AND CTT010.D_E_L_E_T_ = '' AND CTT010.CTT_CCSIG <> '' "
	cQuery += "AND ZR_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cQuery += "AND ZR_CTASIG BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
	cQuery += "AND ZR_CONTA BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
	cQuery += "AND CTT_CCSIG BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
	IF !EMPTY(MV_PAR12)
		cQuery += "AND ZR_CC IN " + FormatIn(MV_PAR12,";") + " "
	ENDIF
	cQuery += "AND ZR_TIPO NOT IN ('E','F') "
	cQuery += "AND ZR_TIPO IN ('C','D') "
	IF 	   MV_PAR02 == 1
		cQuery += "AND ZR_TIPO = 'D' "
	ELSEIF MV_PAR02 == 2
		cQuery += "AND ZR_TIPO = 'C' "
	ENDIF
	cQuery += "GROUP BY CTT_CCSIG,ZR_TIPO,ZR_CTASIG "
	cQuery += "ORDER BY CTT_CCSIG,ZR_TIPO,ZR_CTASIG "

ELSEIF MV_PAR01 == 3 //Analitico por centro de custo
	cQuery	:= "SELECT ZR_DOC,ZR_PREFIXO,ZR_CODEMP,ZR_TIPO,ZR_CLIENTE,ZR_FORNECE,ZR_LOJA,ZR_UNDNEG,CTT_CCSIG,ZR_CTASIG,SUM(ZR_VALOR) AS VALOR, ZR_EMISSAO,ZR_HIST FROM SZR010 "
	cQuery	+= "INNER JOIN CTT010 ON CTT_CUSTO = ZR_CC "
	cQuery	+= "WHERE SZR010.D_E_L_E_T_ = '' AND CTT010.D_E_L_E_T_ = '' AND CTT010.CTT_CCSIG <> '' "
	cQuery += "AND ZR_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cQuery += "AND ZR_CTASIG BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
	cQuery += "AND ZR_CONTA BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
	cQuery += "AND CTT_CCSIG BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' "
	cQuery += "AND ZR_TIPO NOT IN ('E','F') "
	IF !EMPTY(MV_PAR12)
		cQuery += "AND ZR_CC IN " + FormatIn(MV_PAR12,";") + " "
	ENDIF

	IF 	   MV_PAR02 == 1
		cQuery += "AND ZR_TIPO = 'D' "
	ELSEIF MV_PAR02 == 2
		cQuery += "AND ZR_TIPO = 'C' "
	ENDIF
	cQuery	+= "GROUP BY ZR_DOC,ZR_PREFIXO,ZR_CODEMP,ZR_TIPO,ZR_CLIENTE,ZR_FORNECE,ZR_LOJA,ZR_UNDNEG,CTT_CCSIG,ZR_CTASIG,ZR_EMISSAO,ZR_HIST "
	cQuery += "ORDER BY CTT_CCSIG,ZR_TIPO,ZR_CTASIG "

ELSEIF MV_PAR01 == 4 //Verificar os erros Log
	cQuery	:="SELECT * FROM SZR010 WHERE "
	cQuery += "ZR_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND "
	cQuery += "(ZR_VALOR < 0 OR ZR_CTASIG = '' OR ZR_CC = '') AND "
	cQuery += "D_E_L_E_T_ <> '*' "
	IF 	   MV_PAR02 == 1
		cQuery += "AND ZR_TIPO = 'D' "
	ELSEIF MV_PAR02 == 2
		cQuery += "AND ZR_TIPO = 'C' "
	ENDIF
	cQuery += "ORDER BY ZR_CONTA "
ENDIF


tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea()
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

Local nVlTotalD	 := 0
Local nVlTotalC	 := 0
Local nVlTotalC1 := 0
Local nValorCCD	 := 0
Local nValorCCC	 := 0
Local cTipo		 := ""
Local cCustoSIG	 := "  "
Local cSubTot	 := "  "
Local nSubTot	 := 0

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()

	SetRegua(RecCount())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	IF lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	IF MV_PAR01 < 3 ////Rafael Fran็a -> Executado quando o relatorio e "Sintetico,C. Custo e Conta SIG"

		IF nLin > 52 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF MV_PAR01 == 2
			IF (cCustoSIG != TMP->CTT_CCSIG)
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
				nLin     := nLin + 1 // Avanca a linha de impressao
				@nLin, 001 PSAY TMP->CTT_CCSIG
				@nLin, 004 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z9"+TMP->CTT_CCSIG,"X5_DESCRI"))
				nLin     := nLin + 1 // Avanca a linha de impressao
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
				nLin     := nLin + 1 // Avanca a linha de impressao
			ENDIF
		ENDIF

		IF MV_PAR01 == 1

			IF (cTipo != TMP->ZR_TIPO) .AND. MV_PAR11 == 1
				nLin     := nLin + 1 // Avanca a linha de impressao
				IF TMP->ZR_TIPO == "D"
					@nLin, 001 PSAY "DESPESAS"
				ELSEIF TMP->ZR_TIPO == "C"
					@nLin, 001 PSAY "RECEITAS"
				ENDIF
				nLin     := nLin + 1 // Avanca a linha de impressao
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
				nLin     := nLin + 1 // Avanca a linha de impressao
			ENDIF

		ELSEIF MV_PAR01 == 2

			IF MV_PAR11 == 1 .AND. (cCustoSIG != TMP->CTT_CCSIG)
				nLin     := nLin + 1 // Avanca a linha de impressao
				IF TMP->ZR_TIPO == "D"
					@nLin, 001 PSAY "DESPESAS"
				ELSEIF TMP->ZR_TIPO == "C"
					@nLin, 001 PSAY "RECEITAS"
				ENDIF
				nLin     := nLin + 1 // Avanca a linha de impressao
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
				nLin     := nLin + 1 // Avanca a linha de impressao
			ENDIF

		ENDIF

		IF (cSubTot <> SUBSTR(TMP->ZR_CTASIG,1,2))
			nLin 	:= nLin + 1
			@nLin, 001 PSAY SUBSTR(TMP->ZR_CTASIG,1,2)
			@nLin, 004 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR(TMP->ZR_CTASIG,1,2),"X5_DESCRI"))
			nLin 	:= nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin 	:= nLin + 1 // Avanca a linha de impressao
			nSubTot	:= 0
		ENDIF

		@nLin, 001 PSAY ALLTRIM(TMP->ZR_CTASIG)
		@nLin, 014 PSAY ALLTRIM(Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6) + Alltrim(STR(Year(MV_PAR03))),"ZY_DESCRI"))
		@nLin, 065 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"

		IF TMP->ZR_TIPO == "D" //Separa os valores por credito e debito
			IF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6) + Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "1" //CONTA DE SOMA
				nVlTotalD	 += TMP->VALOR
				nValorCCD	 += TMP->VALOR
			ELSEIF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6) + Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "2"
				nVlTotalD	 -= TMP->VALOR
				nValorCCD	 -= TMP->VALOR
			ENDIF
		ELSEIF TMP->ZR_TIPO == "C"
			IF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6) + Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "1"
				nValorCCC	 += TMP->VALOR
				nVlTotalC	 += TMP->VALOR
				IF TMP->ZR_CTASIG <> "01012" // Rafael- 06/10/21 - Colocar conta de receita de aplica็ใo financeira
				nVlTotalC1	 += TMP->VALOR
				ENDIF
			ELSEIF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6) + Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "2"
				nValorCCC	 -= TMP->VALOR
				nVlTotalC	 -= TMP->VALOR

			ENDIF
		ENDIF
		//nSubTot	+= TMP->VALOR

		nSubTot	    += TMP->VALOR
		cSubTot 	:= SUBSTR(TMP->ZR_CTASIG,1,2)
		cTipo  		:= TMP->ZR_TIPO

		IF MV_PAR01 == 2
			cCustoSIG := TMP->CTT_CCSIG
		ENDIF

		dbSelectArea ("TMP")
		dbskip()

		IF (cSubTot <> SUBSTR(TMP->ZR_CTASIG,1,2))  //SubTotais das contas SIG - Tabela SX5 "ZA"
			nLin     := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1
			@nLin, 001 PSAY "TOTAL:"
			IF SUBSTR(cSubTot,1,2) <> "01"
			@nLin, 011 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR(cSubTot,1,2),"X5_DESCRI"))
			ENDIF
			@nLin, 065 PSAY nSubTot PICTURE "@E 999,999,999.99"
			nSubTot	 	:= 0
		ENDIF

		IF (cTipo != TMP->ZR_TIPO) .AND. MV_PAR01 <> 2 .AND. MV_PAR11 == 1
			nLin += 2
			IF cTipo == "D"
				@nLin, 001 PSAY  UPPER("Total de Despesas:")
				@nLin, 065 PSAY nVlTotalD PICTURE "@E 999,999,999.99"
			ELSE
				@nLin, 001 PSAY UPPER("Total de Receitas:")
				@nLin, 065 PSAY nVlTotalC PICTURE "@E 999,999,999.99"
				nLin += 2
				@nLin, 001 PSAY UPPER("Faturamento sem a receita de aplica็ใo:")
				@nLin, 065 PSAY nVlTotalC1 PICTURE "@E 999,999,999.99"
			ENDIF
			nLin += 1
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
		ENDIF

		IF MV_PAR01 == 2  // Por Centro de Custos
			IF ((cTipo != TMP->ZR_TIPO)) .OR. (cCustoSIG != TMP->CTT_CCSIG) .AND. MV_PAR11 == 1
				nLin += 2
				IF cTipo == "D"
					@nLin, 001 PSAY UPPER("Total de Despesas:")
					@nLin, 065 PSAY nValorCCD PICTURE "@E 999,999,999.99"
					nValorCCD := 0
				ELSE
					@nLin, 001 PSAY UPPER("Total de Receitas:")
					@nLin, 065 PSAY nValorCCC PICTURE "@E 999,999,999.99"
					nValorCCC := 0
				ENDIF
				nLin += 1
				@nLin, 000 PSAY REPLICATE("-",LIMITE)
			ENDIF
		ENDIF

		nLin 		+= 1 // Avanca a linha de impressao

	ELSEIF MV_PAR01 == 3 //Rafael Fran็a -> Executado quando o relatorio e por "Lan็amentos"

		IF nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF (cCustoSIG != TMP->CTT_CCSIG)
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1 // Avanca a linha de impressao
			@nLin, 001 PSAY TMP->CTT_CCSIG
			@nLin, 004 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z9"+TMP->CTT_CCSIG,"X5_DESCRI"))
			nLin     := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1 // Avanca a linha de impressao
		ENDIF

		IF MV_PAR11 == 1 .AND. (cCustoSIG != TMP->CTT_CCSIG)
			nLin     := nLin + 1 // Avanca a linha de impressao
			IF TMP->ZR_TIPO == "D"
				@nLin, 001 PSAY "DESPESAS"
			ELSEIF TMP->ZR_TIPO == "C"
				@nLin, 001 PSAY "RECEITAS"
			ENDIF
			nLin     := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1 // Avanca a linha de impressao
		ENDIF

		IF (cSubTot <> TMP->ZR_CTASIG)
			nLin 	:= nLin + 1
			@nLin, 001 PSAY TMP->ZR_CTASIG
			//@nLin, 009 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMP->ZR_CTASIG,"X5_DESCRI"))
			@nLin, 009 PSAY ALLTRIM(Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6)+ Alltrim(STR(Year(MV_PAR03))),"ZY_DESCRI"))
			nLin 	:= nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin 	:= nLin + 1 // Avanca a linha de impressao
			nSubTot	:= 0
		ENDIF

		@nLin, 001 PSAY ALLTRIM(SUBSTR(TMP->ZR_DOC,1,10)) + "\" + TMP->ZR_PREFIXO
		IF !EMPTY(TMP->ZR_CLIENTE)
			@nLin, 014 PSAY ALLTRIM(TMP->ZR_CLIENTE) + " " + TMP->ZR_LOJA
			IF EMPTY(ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + TMP->ZR_CLIENTE + TMP->ZR_LOJA,"A1_NOME"),1,30)))
				@nLin, 025 PSAY ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + TMP->ZR_CLIENTE + TMP->ZR_LOJA,"A2_NOME"),1,30))
			ELSE
				@nLin, 025 PSAY ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + TMP->ZR_CLIENTE + TMP->ZR_LOJA,"A1_NOME"),1,30))
			ENDIF
		ELSE
			@nLin, 014 PSAY ALLTRIM(TMP->ZR_FORNECE) + " " + TMP->ZR_LOJA
			IF EMPTY(ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + TMP->ZR_FORNECE + TMP->ZR_LOJA,"A2_NOME"),1,30)))
				@nLin, 025 PSAY ALLTRIM(SUBSTR(Posicione("SA1",1,xFilial("SA1") + TMP->ZR_FORNECE + TMP->ZR_LOJA,"A1_NOME"),1,30))
			ELSE
				@nLin, 025 PSAY ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2") + TMP->ZR_FORNECE + TMP->ZR_LOJA,"A2_NOME"),1,30))
			ENDIF
		ENDIF
		@nLin, 060 PSAY STOD(TMP->ZR_EMISSAO)
		@nLin, 072 PSAY	TMP->VALOR PICTURE "@E 999,999,999.99"
		@nLin, 089 PSAY	ALLTRIM(SUBSTR(TMP->ZR_HIST,1,40))

		IF TMP->ZR_TIPO == "D" //Separa os valores por credito e debito
			IF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6)+ Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "1" //CONTA DE SOMA
				nVlTotalD	 += TMP->VALOR
				nValorCCD	 += TMP->VALOR
			ELSEIF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6)+ Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "2"
				nVlTotalD	 -= TMP->VALOR
				nValorCCD	 -= TMP->VALOR
			ENDIF
		ELSEIF TMP->ZR_TIPO == "C"
			IF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6)+ Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "1"
				nValorCCC	 += TMP->VALOR
				nVlTotalC	 += TMP->VALOR
			ELSEIF Posicione("SZY",1,xFilial("SZY")+SUBSTRING(TMP->ZR_CTASIG,1,6)+ Alltrim(STR(Year(MV_PAR03))),"ZY_RESULT") == "2"
				nValorCCC	 -= TMP->VALOR
				nVlTotalC	 -= TMP->VALOR
			ENDIF
		ENDIF

		nSubTot	     += TMP->VALOR
		cSubTot 	:= TMP->ZR_CTASIG
		cTipo 		:= TMP->ZR_TIPO
		cCustoSIG 	:= TMP->CTT_CCSIG

		dbSelectArea ("TMP")
		dbskip()

		IF (cSubTot <> TMP->ZR_CTASIG) .OR. (cTipo != TMP->ZR_TIPO) .OR. (cCustoSIG != TMP->CTT_CCSIG) //SubTotais das contas SIG - Tabela SX5 "ZA"
			nLin     := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     := nLin + 1
			@nLin, 001 PSAY "SUBTOTAL:"
			@nLin, 011 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+cSubTot,"X5_DESCRI"))
			@nLin, 072 PSAY nSubTot PICTURE "@E 999,999,999.99"
			nSubTot	 	:= 0
		ENDIF


		IF (cTipo != TMP->ZR_TIPO) .OR. (cCustoSIG != TMP->CTT_CCSIG) .AND. MV_PAR11 == 1
			nLin += 2
			IF cTipo == "D"
				@nLin, 001 PSAY UPPER("Total de Despesas ------------>")
				@nLin, 072 PSAY nValorCCD PICTURE "@E 999,999,999.99"
				nValorCCD := 0
			ELSE
				@nLin, 001 PSAY UPPER("Total de Receitas ------------>")
				@nLin, 072 PSAY nValorCCC PICTURE "@E 999,999,999.99"
				nValorCCC := 0
			ENDIF
			nLin += 1
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
		ENDIF

		nLin 		+= 1 // Avanca a linha de impressao

	ENDIF

	IF MV_PAR01 == 4

		IF nLin > 52 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		@nLin, 000 PSAY TMP->ZR_CODIGO
		@nLin, 008 PSAY TMP->ZR_DOC
		@nLin, 023 PSAY TMP->ZR_CLIENTE
		@nLin, 033 PSAY TMP->ZR_FORNECE
		@nLin, 041 PSAY TMP->ZR_CC
		@nLin, 053 PSAY TMP->ZR_CTASIG
		@nLin, 060 PSAY TMP->ZR_VALOR PICTURE "@E 999,999,999.99"
		@nLin, 079 PSAY TMP->ZR_MODULO
		@nLin, 089 PSAY TMP->ZR_CONTA
		@nLin, 102 PSAY TMP->ZR_CTADESC

		nLin++


		dbskip()

	EndIf

ENDDO

dbSelectArea("TMP")
dbCloseArea()

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
AADD(aRegs,{cPerg,"01","Imprime Relatorio	","","","mv_ch01","N",01,0,0,"C","","mv_par01","Sintetico","","","","","C. Custo","","","","","Analitico","","","","","Validacao","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tipo do Relatorio	","","","mv_ch02","N",01,0,0,"C","","mv_par02","Despesas","","","","","Receitas","","","","","Ambos","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Data 			","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data		 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Conta SIG		","","","mv_ch05","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
AADD(aRegs,{cPerg,"06","Ate Conta SIG		","","","mv_ch06","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
AADD(aRegs,{cPerg,"07","De C. Custo SIG 	","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","Z9"})
AADD(aRegs,{cPerg,"08","Ate C. Custo SIG 	","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","Z9"})
AADD(aRegs,{cPerg,"09","Da  C. Contabil		","","","mv_ch09","C",20,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"10","Ate C. Contabil		","","","mv_ch10","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"11","Imp. totais Rec\Des	","","","mv_ch11","N",01,0,0,"C","","mv_par11","Sim","","","","","Nใo","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Seleciona C. Custo:	","","","mv_ch12","C",30,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
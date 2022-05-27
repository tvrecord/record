#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
//Rafael França - Relatório criado para acompanhamento SIG com base na viewer CONTABILQLIKVIEW
/*/

User Function FINR009

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local titulo       	 := "Relatório de conferencia do SIG"
Local nLin           := 100
Local Cabec1         := UPPER(" Cod. SIG     Descricao                                                    Valor")
Local Cabec2         := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "FINR009" //Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR009" //Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "FINR009"
Private cString      := ""
Private cQuery       := ""
Private nCont	     := 0
Private cAlias1    	 := GetNextAlias()

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("Operação cancelada pelo usuário")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF MV_PAR01 == 1
	titulo	:= "Sintético - " + DTOC(mv_par03) + " a " + DTOC(mv_par04)
ENDIF

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

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

//RUNREPORT - Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS monta a janela com a regua de processamento.

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nVlTotalD	 	:= 0
Local nVlTotalR	 	:= 0
Local nVlNaoFat 	:= 0
Local nContaSIG		:= 0
Local cContaSIG		:= ""
Local nSubTot		:= 0
Local cSubTot 		:= ""
Local cTipo  		:= ""
Local nVlAplFin		:= 0 // Valor da aplicação financeira conta contabil 321100009
Local cAno			:= Alltrim(STR(Year(MV_PAR03)))
Local cFiltro 		:= "% DATA_DE_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND CONTA_SIG BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' %"

IF MV_PAR02 == 1
cFiltro 		:= "% DATA_DE_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND CONTA_SIG BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SUBSTRING(CONTA_SIG,1,2) > '01' %"
ELSEIF MV_PAR02 == 2
cFiltro 		:= "% DATA_DE_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND CONTA_SIG BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SUBSTRING(CONTA_SIG,1,2) = '01' %"
ENDIF

IF 	   MV_PAR01 == 1  //Sintetico

	BeginSql Alias cAlias1

	SELECT SUBSTRING(CONTA_SIG,1,2) AS GRUPO, CONTA_SIG, CONTA_RM AS CCONTABIL, SUM(VALOR) AS VALOR
	FROM CONTABILQLIKVIEW
	WHERE
	%Exp:cFiltro%
	GROUP BY SUBSTRING(CONTA_SIG,1,2), CONTA_SIG, CONTA_RM
	ORDER BY GRUPO, CONTA_SIG, CONTA_RM

	EndSql

	(cAlias1)->(DbGoTop())

	If Eof()
		MsgInfo("Não existem dados a serem impressos!","Verifique")
		dbSelectArea(cAlias1)
		dbCloseArea()
		Return
	Endif

	DBSelectArea(cAlias1)
	DBGotop()
	While !EOF()

		SetRegua(RecCount())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		IF lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		IF nLin > 52 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF (cTipo != (cAlias1)->GRUPO)
			nLin  	+= 1 // Avanca a linha de impressao
			IF (cAlias1)->GRUPO <> "01"
				@nLin, 001 PSAY "DESPESAS"
			ELSEIF (cAlias1)->GRUPO == "01"
				@nLin, 001 PSAY "RECEITAS"
			ENDIF
			nLin  	+= 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin  	+= 1 // Avanca a linha de impressao
		ENDIF

		IF (cSubTot <> SUBSTR((cAlias1)->CONTA_SIG,1,2))
			nLin 	+= 1
			@nLin, 001 PSAY SUBSTR((cAlias1)->CONTA_SIG,1,2)
			@nLin, 004 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR((cAlias1)->CONTA_SIG,1,2),"X5_DESCRI"))
			nLin 	+= 1 // Avanca a linha de impressao
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin 	+= 1 // Avanca a linha de impressao
			nSubTot	:= 0
		ENDIF

		nContaSIG	+= (cAlias1)->VALOR
		cContaSIG	:= (cAlias1)->CONTA_SIG
		nSubTot	    += (cAlias1)->VALOR
		cSubTot 	:= SUBSTR((cAlias1)->CONTA_SIG,1,2)
		cTipo  		:= (cAlias1)->GRUPO

		IF (cAlias1)->GRUPO <> "01" //Separa os valores por credito e debito
			IF Posicione("SZY",2,xFilial("SZY") + cAno + SUBSTRING((cAlias1)->CONTA_SIG,1,6),"ZY_RESULT") == "1" //CONTA DE SOMA
				nVlTotalD	 += (cAlias1)->VALOR
			ELSEIF Posicione("SZY",2,xFilial("SZY") + cAno + SUBSTRING((cAlias1)->CONTA_SIG,1,6),"ZY_RESULT") == "2"
				nVlTotalD	 -= (cAlias1)->VALOR
			ENDIF
		ELSEIF (cAlias1)->GRUPO == "01"
			IF Posicione("SZY",2,xFilial("SZY") + cAno + SUBSTRING((cAlias1)->CONTA_SIG,1,6),"ZY_RESULT") == "1"
				nVlTotalR	 += (cAlias1)->VALOR
				IF (cAlias1)->CCONTABIL > "31" // Rafael- 06/10/21 - Colocar conta de receita de aplicação financeira
					nVlNaoFat	 += (cAlias1)->VALOR
				ENDIF
			ELSEIF Posicione("SZY",2,xFilial("SZY") + cAno + SUBSTRING((cAlias1)->CONTA_SIG,1,6),"ZY_RESULT") == "2"
				nVlTotalR	 -= (cAlias1)->VALOR
			ENDIF
		ENDIF

		IF ALLTRIM((cAlias1)->CCONTABIL) == "311010012"
			nVlAplFin	+= (cAlias1)->VALOR
		EndIF

		(cAlias1)->(DbSkip())

		IF cContaSIG <> (cAlias1)->CONTA_SIG
			@nLin, 001 PSAY ALLTRIM(cContaSIG)
			@nLin, 014 PSAY ALLTRIM(Posicione("SZY",2,xFilial("SZY") + cAno + SUBSTRING(cContaSIG,1,6),"ZY_DESCRI"))
			@nLin, 065 PSAY nContaSIG PICTURE "@E 999,999,999.99"
			nContaSIG	:= 0
			nLin     += 1
		ENDIF

		IF (cSubTot <> SUBSTR((cAlias1)->CONTA_SIG,1,2))  //SubTotais das contas SIG - Tabela SX5 "ZA"
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
			nLin     += 1
			@nLin, 001 PSAY "TOTAL:"
			IF SUBSTR(cSubTot,1,2) <> "01"
				@nLin, 011 PSAY ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZA"+SUBSTR(cSubTot,1,2),"X5_DESCRI"))
			ENDIF
			@nLin, 065 PSAY nSubTot PICTURE "@E 999,999,999.99"
			nSubTot	 	:= 0
		ENDIF

		IF (cTipo != (cAlias1)->GRUPO)
			nLin += 2
			IF cTipo <> "01"
				@nLin, 001 PSAY  UPPER("Total de Despesas:")
				@nLin, 065 PSAY nVlTotalD PICTURE "@E 999,999,999.99"
			ELSE
				@nLin, 001 PSAY UPPER("Total de Receitas:")
				@nLin, 065 PSAY (nVlTotalR - nVlNaoFat) PICTURE "@E 999,999,999.99"
				nLin += 2
				@nLin, 001 PSAY UPPER("Faturamento sem a receita de aplicação (" +ALLTRIM(Transform(nVlAplFin, "@E 999,999,999.99")) +"):"	)
				@nLin, 065 PSAY (nVlTotalR - nVlNaoFat - nVlAplFin) PICTURE "@E 999,999,999.99"
			ENDIF
			nLin += 1
			@nLin, 000 PSAY REPLICATE("-",LIMITE)
		ENDIF

ENDDO

(cAlias1)->(DbCloseArea())

ELSE

		MsgInfo("Apenas o relatório sintético está disponivel, favor verificar os parâmetros","FINR008")

ENDIF

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

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Imprime Relatório	","","","mv_ch01","N",01,0,0,"C","","mv_par01","Sintetico","","","","","C. Custo","","","","","Analitico","","","","","Validacao","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tipo do Relatório	","","","mv_ch02","N",01,0,0,"C","","mv_par02","Despesas","","","","","Receitas","","","","","Ambos","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Data 			","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data		 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Conta SIG		","","","mv_ch05","C",05,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})
AADD(aRegs,{cPerg,"06","Ate Conta SIG		","","","mv_ch06","C",05,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","Z8"})

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

RestArea(aArea)

Return
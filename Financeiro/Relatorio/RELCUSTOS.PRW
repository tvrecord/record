#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOTAPON   º Autor ³ Rafael Franca      º Data ³ 08/04/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de receitas e despesas por centro de custos.     º±±
±±|          |    													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELCUSTOS()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "DESPESAS POR CENTRO DE CUSTOS"
Local nLin           := 110

Local Cabec1         := UPPER("C. CUSTO       DESCRICAO                                                   VALOR")
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RELCUSTOS" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado",1,"Administracao",1,2,1,"",1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELCUSTOS" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RELCUSTO1"
Private cString      := "CT2"                                        ú
Private cQuery       := ""
Private cQuery1      := ""
Private nCont	     := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

IF MV_PAR07 == 1 .AND. MV_PAR09 == 2
	Cabec1         := UPPER("C. CUSTO       DESCRICAO                                                   VALOR")
ELSEIF  MV_PAR07 == 1 .AND. MV_PAR09 == 1
	Cabec1         := UPPER("C. CUSTO       MES                                                         VALOR")
ELSE
	Cabec1         := UPPER("C. CUSTO       HISTORICO                                                   VALOR")
ENDIF


IF MV_PAR10 == 1
	aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
	limite       := 220
	tamanho      := "G"
	Cabec1       := UPPER(PadR("C. CUSTO  DESCRICAO",45) + PadL("Janeiro",13) + PadL("Fevereiro",13) + PadL("Março",13) + PadL("Abril",13) + PadL("Maio",13) + PadL("Junho",13) + PadL("Julho",13) + PadL("Agosto",13) + PadL("Setembro",13) + PadL("Outubro",13) + PadL("Novembro",13) + PadL("Dezembro",13)  + PadL("Total",18))
ENDIF

Titulo := Titulo + "DE " + DTOS(MV_PAR03) + " - " + DTOS(MV_PAR04)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.F.)

//Imprimir relatorio com dados Financeiros ou de Clientes


IF MV_PAR10 == 1   // Query para relatorio no formato planilha
	
	cQuery := "SELECT CT2_DEBITO,CT1_DESC01,CT2_CCD,SUBSTRING(CT2_DATA,5,2) AS MES,SUM(CT2_VALOR) AS VALOR  FROM CT2010 INNER JOIN CT1010 ON CT2_DEBITO = CT1_CONTA "
	cQuery += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
	IF EMPTY(MV_PAR08)
		cQuery += "CT2_CCD BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	ELSE
		cQuery += "CT2_CCD IN " + FormatIn(MV_PAR08,";") + " AND "
	ENDIF
	cQuery += "CT2_DEBITO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	cQuery += "CT2_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND CT2_TPSALD = '1' "
	IF MV_PAR02 == 1
		cQuery += "AND CT2_ROTINA NOT IN ('FINA100','ATFA050') "
	ENDIF
	IF MV_PAR13 == 2
		cQuery += "AND CT2_ROTINA NOT LIKE ('GPE%') "
	ENDIF
	
	cQuery += "GROUP BY CT2_DEBITO,CT1_DESC01,CT2_CCD, SUBSTRING(CT2_DATA,5,2)"
	
	
ELSE       // Formato normal
	
	
	IF MV_PAR07 == 1 .AND. MV_PAR09 == 2  // Sintetico sem subtotais por mes
		cQuery := "SELECT CT2_DEBITO,CT2_CCD,SUM(CT2_VALOR) AS VALOR FROM CT2010 "
	ELSEIF MV_PAR07 == 1 .AND. MV_PAR09 == 1  // Sintetico com subtotais por mes
		cQuery := "SELECT CT2_CCD,SUBSTRING(CT2_DATA,5,2) AS MES,SUM(CT2_VALOR) AS VALOR  FROM CT2010	"
	ELSE  // Analitico
		cQuery := "SELECT CT2_CCD,CT2_DATA,CT2_DOC,CT2_HIST,CT2_VALOR FROM CT2010 "
	ENDIF
	cQuery += "WHERE D_E_L_E_T_ <> '*' AND "
	cQuery += "CT2_DEBITO BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
	IF EMPTY(MV_PAR08)
		cQuery += "CT2_CCD BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
	ELSE
		cQuery += "CT2_CCD IN " + FormatIn(MV_PAR08,";") + " AND "
	ENDIF
	cQuery += "CT2_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND CT2_TPSALD = '1' "
	IF MV_PAR02 == 1
		cQuery += "AND CT2_ROTINA NOT IN ('FINA100','ATFA050') "
	ENDIF
	IF MV_PAR13 == 2
		cQuery += "AND CT2_ROTINA NOT LIKE ('GPE%') "
	ENDIF
	IF MV_PAR07 == 1 .AND. MV_PAR09 == 2
		cQuery += "GROUP BY CT2_DEBITO,CT2_CCD "
	ELSEIF MV_PAR07 == 1 .AND. MV_PAR09 == 1
		cQuery += "GROUP BY CT2_CCD, SUBSTRING(CT2_DATA,5,2)"
	ELSE
		cQuery += "ORDER BY CT2_CCD, CT2_DATA"
	ENDIF
ENDIF

tcQuery cQuery New Alias "TMP"


If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/09   º±±
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

Local cNomeCC		:= ""
Local cCusto		:= ""
Local cNomeConta	:= ""
Local cConta		:= ""
Local cTotal		:= ""
Local nTotal		:= 00
Local nTotConta		:= 00
Local nDespesas		:= 00
Local nDespesasC 	:= 00
Local cMesAtual		:= ""
Local nMeses		:= 00
Local nTotMes		:= 00
Local nMes1			:= 00
Local nMes2			:= 00
Local nMes3			:= 00
Local nMes4			:= 00
Local nMes5			:= 00
Local nMes6			:= 00
Local nMes7			:= 00
Local nMes8			:= 00
Local nMes9			:= 00
Local nMes10		:= 00
Local nMes11		:= 00
Local nMes12		:= 00
Local nMesCC1		:= 00
Local nMesCC2		:= 00
Local nMesCC3		:= 00
Local nMesCC4		:= 00
Local nMesCC5		:= 00
Local nMesCC6		:= 00
Local nMesCC7		:= 00
Local nMesCC8		:= 00
Local nMesCC9		:= 00
Local nMesCC10		:= 00
Local nMesCC11		:= 00
Local nMesCC12		:= 00
Local nMesT1		:= 00
Local nMesT2		:= 00
Local nMesT3		:= 00
Local nMesT4		:= 00
Local nMesT5		:= 00
Local nMesT6		:= 00
Local nMesT7		:= 00
Local nMesT8		:= 00
Local nMesT9		:= 00
Local nMesT10		:= 00
Local nMesT11		:= 00
Local nMesT12		:= 00
Local nCol			:= 35 
Local lOk			:= .T.

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
nMeses := (VAL(SUBSTR(DTOS(MV_PAR04),5,2)) - VAL(SUBSTR(DTOS(MV_PAR03),5,2))) + 1

IF MV_PAR10 == 2 // Impressao do relatorio no formato normal
	
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
		
		IF (TMP->CT2_DEBITO != cConta) .AND. MV_PAR14 == 1
			nLin += 1
			@nLin, 000 PSAY TMP->CT2_DEBITO
			@nLin, 022 PSAY SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01"),1,33)
			cNomeConta := Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01")
			nLin += 1
			@nLin, 000 PSAY Replicate("_",Limite)
			nLin += 1
		ENDIF
		
		IF (TMP->CT2_CCD != cCusto) .AND. MV_PAR07 == 2
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin 	:= nLin + 1
			@nLin, 000 PSAY TMP->CT2_CCD
			@nLin, 010 PSAY Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
			nLin 	:= nLin + 1
			@nLin, 000 PSAY Replicate("-",Limite)
			cNomeCC := Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
			nLin += 1
		ELSEIF	(TMP->CT2_CCD != cCusto) .AND. MV_PAR07 == 1 .AND. MV_PAR09 == 1
			
			nLin 	:= nLin + 1
			@nLin, 000 PSAY TMP->CT2_CCD
			@nLin, 010 PSAY Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
			nLin 	:= nLin + 1
			@nLin, 000 PSAY Replicate("-",Limite)
			cNomeCC := Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
			nLin += 1
		Endif
		
		IF MV_PAR07 == 1 .AND. MV_PAR09 == 2
			@nLin, 000 PSAY TMP->CT2_CCD
			@nLin, 015 PSAY Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
			@nLin, 066 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
			nTotal 		+= TMP->VALOR
			cConta		:= TMP->CT2_DEBITO
			nTotConta 	+= TMP->VALOR
		ELSEIF MV_PAR07 == 1 .AND. MV_PAR09 == 1
			@nLin, 000 PSAY TMP->CT2_CCD
			@nLin, 015 PSAY Mes(STOD("2010" + TMP->MES + "01"))
			@nLin, 066 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
			nTotal 		+= TMP->VALOR
			nDespesas 	+= TMP->VALOR
			cCusto 		:= TMP->CT2_CCD
			//cConta		:= TMP->CT2_DEBITO
			//nTotConta 	+= TMP->VALOR
		ELSE
			@nLin, 000 PSAY TMP->CT2_DOC
			@nLin, 015 PSAY TMP->CT2_HIST
			@nLin, 066 PSAY TMP->CT2_VALOR PICTURE "@E 999,999,999.99"
			nDespesas 	+= TMP->CT2_VALOR
			nTotal 		+= TMP->CT2_VALOR
			cCusto 		:= TMP->CT2_CCD
			nTotMes		:= 0
		ENDIF
		
		If nLin > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		nLin += 1
		
		dbskip()
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		
		IF (TMP->CT2_CCD != cCusto) .AND. MV_PAR07 == 2
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY "Total do Centro de Custos:"
			@nLin, 027 PSAY SUBSTR(UPPER(cNomeCC),1,35)
			@nLin, 066 PSAY nDespesas PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
			
			nDespesas := 0
			
		ELSEIF (TMP->CT2_CCD != cCusto) .AND. MV_PAR07 == 1 .AND. MV_PAR09 == 1
			
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY "Total do Centro de Custos:"
			@nLin, 027 PSAY SUBSTR(UPPER(cNomeCC),1,35)
			@nLin, 066 PSAY nDespesas PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
			
			nDespesas := 0
			
		ENDIF
		
		IF (TMP->CT2_DEBITO != cConta) .AND. MV_PAR07 == 1 .AND. MV_PAR14 == 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 1
			@nLin, 000 PSAY "Total da Conta:"
			@nLin, 025 PSAY SUBSTR(UPPER(cNomeConta),1,35)
			@nLin, 066 PSAY nTotConta PICTURE "@E 999,999,999.99"
			nLin += 1
			@nLin, 000 PSAY Replicate("-",Limite)
			nLin += 2
			
			nTotConta := 0
		END
		
	ENDDO
	
	nLin += 1
	IF EMPTY(MV_PAR01)
		@nLin, 000 PSAY "Total Geral -->"
	ELSE
		@nLin, 000 PSAY "Total"
		@nLin, 008 PSAY Posicione("CTT",1,xfilial("CTT")+MV_PAR01,"CTT_DESC01")
	ENDIF
	@nLin, 066 PSAY nTotal PICTURE "@E 999,999,999.99"
	
ELSE //Impressao no formato planilha
	
	While !EOF()
		
		SetRegua(RecCount())
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		IF MV_PAR16 == 1
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8  
			lOk  := .F.
		Endif
		ENDIF	
		
		IF (TMP->CT2_DEBITO != cConta) .AND. MV_PAR14 == 1
			nLin += 2
			@nLin, 000 PSAY TMP->CT2_DEBITO
			@nLin, 012 PSAY SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01"),1,33)
			cNomeConta := Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01")
			nLin += 1
			@nLin, 000 PSAY Replicate("_",Limite)
			nLin += 2
		ENDIF
		
		IF (TMP->CT2_CCD != cCusto)
			@nLin, 000 PSAY TMP->CT2_CCD
			@nLin, 010 PSAY SUBSTR(Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01"),1,33)
			cNomeCC := Posicione("CTT",1,xfilial("CTT")+TMP->CT2_CCD,"CTT_DESC01")
		ENDIF
		
		nCol := (VAL(TMP->MES) * 13) + 35
		
		@nLin,nCol PSAY TMP->VALOR PICTURE "@E 999,999.99"
		nTotal 		+= TMP->VALOR
		nDespesas 	+= TMP->VALOR
		nDespesasC 	+= TMP->VALOR
		cCusto 		:= TMP->CT2_CCD
		cConta 		:= TMP->CT2_DEBITO
		
		IF TMP->MES == "01"
			nMes1		+= TMP->VALOR
			nMesCC1		+= TMP->VALOR
			nMesT1		+= TMP->VALOR
		ELSEIF TMP->MES == "02"
			nMes2		+= TMP->VALOR
			nMesCC2		+= TMP->VALOR
			nMesT2		+= TMP->VALOR
		ELSEIF TMP->MES == "03"
			nMes3		+= TMP->VALOR
			nMesCC3		+= TMP->VALOR
			nMesT3		+= TMP->VALOR
		ELSEIF TMP->MES == "04"
			nMes4		+= TMP->VALOR
			nMesCC4		+= TMP->VALOR
			nMesT4		+= TMP->VALOR
		ELSEIF TMP->MES == "05"
			nMes5		+= TMP->VALOR
			nMesCC5		+= TMP->VALOR
			nMesT5		+= TMP->VALOR
		ELSEIF TMP->MES == "06"
			nMes6		+= TMP->VALOR
			nMesCC6		+= TMP->VALOR
			nMesT6		+= TMP->VALOR
		ELSEIF TMP->MES == "07"
			nMes7		+= TMP->VALOR
			nMesCC7		+= TMP->VALOR
			nMesT7		+= TMP->VALOR
		ELSEIF TMP->MES == "08"
			nMes8		+= TMP->VALOR
			nMesCC8		+= TMP->VALOR
			nMesT8		+= TMP->VALOR
		ELSEIF TMP->MES == "09"
			nMes9		+= TMP->VALOR
			nMesCC9		+= TMP->VALOR
			nMesT9		+= TMP->VALOR
		ELSEIF TMP->MES == "10"
			nMes10		+= TMP->VALOR
			nMesCC10	+= TMP->VALOR
			nMesT10		+= TMP->VALOR
		ELSEIF TMP->MES == "11"
			nMes11		+= TMP->VALOR
			nMesCC11	+= TMP->VALOR
			nMesT11		+= TMP->VALOR
		ELSEIF TMP->MES == "12"
			nMes12		+= TMP->VALOR
			nMesCC12	+= TMP->VALOR
			nMesT12		+= TMP->VALOR
		ENDIF
		
		dbskip()
		 
		IF MV_PAR16 == 1
		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		ENDIF		
		
		IF (TMP->CT2_CCD != cCusto)
			IF MV_PAR15 == 1
			@nLin, 205 PSAY nDespesas PICTURE "@E 999,999,999.99"
			ELSE 
			@nLin, 205 PSAY (nDespesas/nMeses) PICTURE "@E 999,999,999.99"
			ENDIF
			IF MV_PAR16 == 1
			@nLin, 000 PSAY Replicate("_",Limite)			
			ENDIF
			nLin += 1
			nDespesas := 0
		ENDIF
		
		IF (TMP->CT2_DEBITO != cConta) .AND. MV_PAR14 == 1  
			@nLin += 1
			@nLin, 000 PSAY "Total conta:"
			@nLin, 018 PSAY SUBSTR(Posicione("CT1",1,xfilial("CT1")+cConta,"CT1_DESC01"),1,32)
			nCol := 46
			@nLin,nCol PSAY nMesCC1 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC2 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC3 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC4 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC5 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC6 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC7 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC8 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC9 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC10 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC11 PICTURE "@E 99,999,999.99"
			nCol += 13
			@nLin,nCol PSAY nMesCC12 PICTURE "@E 99,999,999.99"
			nCol += 17 
			IF MV_PAR15 == 1
			@nLin,nCol PSAY nDespesasC PICTURE "@E 999,999,999.99"
			ELSE 
			@nLin,nCol PSAY (nDespesasC/nMeses) PICTURE "@E 999,999,999.99"
			ENDIF
			nLin += 1
			@nLin, 000 PSAY Replicate("_",Limite)
			nLin += 1
			nMesCC1		:= 00
			nMesCC2		:= 00
			nMesCC3		:= 00
			nMesCC4		:= 00
			nMesCC5		:= 00
			nMesCC6		:= 00
			nMesCC7		:= 00
			nMesCC8		:= 00
			nMesCC9		:= 00
			nMesCC10	:= 00
			nMesCC11	:= 00
			nMesCC12	:= 00
			nDespesasC 	:= 0
		ENDIF
		
	ENDDO
	
	@nLin, 000 PSAY "Total Geral --->"
	nCol := 45
	@nLin,nCol PSAY nMes1 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes2 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes3 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes4 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes5 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes6 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes7 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes8 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes9 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes10 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes11 PICTURE "@E 99,999,999.99"
	nCol += 13
	@nLin,nCol PSAY nMes12 PICTURE "@E 99,999,999.99"
	nCol += 17 
	IF MV_PAR15 == 1
	@nLin,nCol PSAY nTotal PICTURE "@E 999,999,999.99"  
	ELSE 
	@nLin,nCol PSAY (nTotal/nMeses) PICTURE "@E 999,999,999.99"  	
	ENDIF
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

DBSelectArea("TMP")
DBCloseArea("TMP")


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","C Custos Sint. ","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"02","Filtra Gastos  ","","","mv_ch02","N",01,0,2,"C","","mv_par02","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Emissao    ","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Emissao    ","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Do  C. Custos  ","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Ate C. Custos  ","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","Tipo Relatorio ","","","mv_ch07","N",01,0,2,"C","","mv_par07","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","CC Aleatorios	","","","mv_ch08","C",50,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Imprime Mes    ","","","mv_ch09","N",01,0,2,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Formato Rel.   ","","","mv_ch10","N",01,0,2,"C","","mv_par10","Planilha","","","","","Relatorio","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Da  C. Contabil","","","mv_ch11","C",20,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"12","Ate C. Contabil","","","mv_ch12","C",20,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"13","Inclui Salarios","","","mv_ch13","N",01,0,2,"C","","mv_par13","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Total por conta","","","mv_ch14","N",01,0,2,"C","","mv_par14","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Imprime Totais ","","","mv_ch15","N",01,0,2,"C","","mv_par15","Total","","","","","Media","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Filtra Gastos  ","","","mv_ch16","N",01,0,2,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"08","Da  Dt Contabil","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"09","Ate Dt Contabil","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AADD(aRegs,{cPerg,"10","Da  C. Contabil","","","mv_ch10","C",20,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
//AADD(aRegs,{cPerg,"11","Ate C. Contabil","","","mv_ch11","C",20,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
//AADD(aRegs,{cPerg,"12","Do  Produto    ","","","mv_ch12","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
//AADD(aRegs,{cPerg,"13","Ate Produto    ","","","mv_ch13","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})

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
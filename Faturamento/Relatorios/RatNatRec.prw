#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLBPedido  บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Informa ao usuario quais os pedidos que foram liberados    บฑฑ
ฑฑ          ฑฑ pelo aprovador informado nos parametros					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RatNatRec

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Rateio de Natureza do Contas a Receber"
Local nLin           := 100

Local Cabec1         := ""
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RatNatRec" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	      := "RatNatRec2"
Private cString      := "SE1"
Private cQuery       := ""
Private lOk 		 := .T.
Private cNat		 := ""
Private cDescNat     := ""
Private nValNat		 := 0
Private nValTot		 := 0
Private nVaLiq		 := 0   
Private nTitulo		 := ""



ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

IF MV_PAR15 == 2
	Cabec1 := "Prf  Numero          Tip. C.Custo      Descri็ใo                                Cliente Lj. Descri็ใo                                 Emissใo    Vencimento       Valor"
ELSE
	Cabec1 := "Natureza      Descri็ใo                                         Valor"
ENDIF



//Imprimir relatorio com dados Financeiros ou de Clientes

cQuery := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ AS NATUREZ,ED_DESCRIC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_EMISSAO,E1_VENCREA,E1_VALOR AS VALOR,E1_IRRF,E1_INSS,E1_ISS,E1_PIS,E1_COFINS,E1_CSLL,1 AS EV_PERC "
cQuery += "FROM SE1010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "SE1010.E1_NATUREZ = SED010.ED_CODIGO "
cQuery += "INNER JOIN SA1010 ON "
cQuery += "SE1010.E1_CLIENTE = SA1010.A1_COD AND SE1010.E1_LOJA = SA1010.A1_LOJA "
cQuery += "WHERE "
cQuery += "SE1010.E1_PREFIXO BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "SE1010.E1_NUM BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
IF !Empty (MV_PAR16)
	cQuery += "SE1010.E1_TIPO NOT IN " + FormatIn(MV_PAR16,"/") + " AND "
ELSE
	cQuery += "SE1010.E1_TIPO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
ENDIF
cQuery += "SE1010.E1_NATUREZ BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery += "SE1010.E1_CLIENTE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
cQuery += "SE1010.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' AND "
cQuery += "SE1010.E1_VENCREA BETWEEN '" + DTOS(MV_PAR13) + "' AND '" + DTOS(MV_PAR14) + "' AND "
//Filtra filial que o usuario esta logado.
cQuery += "SE1010.E1_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += "SA1010.A1_FILIAL = '" + xFilial("SA1") + "' AND "
cQuery += "SED010.ED_FILIAL = '" + xFilial("SED") + "' AND "
//cQuery += "SEV010.EV_FILIAL = '" + xFilial("SEV") + "' AND "
cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "SE1010.E1_MULTNAT <> '1' "
cQuery += "UNION "
cQuery += "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,EV_NATUREZ AS NATUREZ,ED_DESCRIC,E1_CLIENTE,E1_LOJA,A1_NOME,E1_EMISSAO,E1_VENCREA,EV_VALOR AS VALOR,(EV_PERC*E1_IRRF) AS E1_IRRF,(EV_PERC*E1_INSS) AS E1_INSS,(EV_PERC*E1_ISS) AS E1_ISS,(EV_PERC*E1_PIS) AS E1_PIS,(EV_PERC*E1_COFINS) AS E1_COFINS,(EV_PERC*E1_CSLL) AS E1_CSLL,EV_PERC "
cQuery += "FROM SE1010 "
cQuery += "INNER JOIN SEV010 ON "
cQuery += "E1_PREFIXO = EV_PREFIXO AND E1_NUM = EV_NUM AND E1_PARCELA = EV_PARCELA AND E1_TIPO = EV_TIPO "
cQuery += "INNER JOIN SED010 ON "
cQuery += "SEV010.EV_NATUREZ = SED010.ED_CODIGO "
cQuery += "INNER JOIN SA1010 ON "
cQuery += "SE1010.E1_CLIENTE = SA1010.A1_COD AND SE1010.E1_LOJA = SA1010.A1_LOJA "
cQuery += "WHERE "
cQuery += "SE1010.E1_PREFIXO BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "SE1010.E1_NUM BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
IF !Empty (MV_PAR16)
	cQuery += "SE1010.E1_TIPO NOT IN " + FormatIn(MV_PAR16,"/") + " AND "
ELSE
	cQuery += "SE1010.E1_TIPO BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
ENDIF
//cQuery += "SE1010.E1_NATUREZ BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "  
cQuery += "SEV010.EV_NATUREZ BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery += "SE1010.E1_CLIENTE BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
cQuery += "SE1010.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' AND "
cQuery += "SE1010.E1_VENCREA BETWEEN '" + DTOS(MV_PAR13) + "' AND '" + DTOS(MV_PAR14) + "' AND "
cQuery += "SEV010.EV_RECPAG = 'R' AND "
//Filtra filial que o usuario esta logado.
cQuery += "SE1010.E1_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += "SA1010.A1_FILIAL = '" + xFilial("SA1") + "' AND "
cQuery += "SED010.ED_FILIAL = '" + xFilial("SED") + "' AND "
//cQuery += "SEV010.EV_FILIAL = '" + xFilial("SEV") + "' AND "
cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SEV010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY NATUREZ,E1_CLIENTE,E1_PREFIXO,E1_NUM "

tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
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

MontaVetor()

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
	
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If MV_PAR15 == 2        //Imprime Analitico
		
		If lOk == .T.
			
			@nLin, 000 PSAY TMP->NATUREZ + " - " + TMP->ED_DESCRIC
			@nLin, 000 PSAY "________________________________________________________________________________________________________________________________________________________________________________"
			nLin++
			
		EndIf
		
		
		
		@nLin, 000 PSAY TMP->E1_PREFIXO
		@nLin, 005 PSAY TMP->E1_NUM
		@nLin, 016 PSAY TMP->E1_PARCELA
		@nLin, 021 PSAY TMP->E1_TIPO
		@nLin, 026 PSAY TMP->NATUREZ
		@nLin, 038 PSAY TMP->ED_DESCRIC
		@nLin, 080 PSAY TMP->E1_CLIENTE
		@nLin, 088 PSAY TMP->E1_LOJA
		@nLin, 092 PSAY TMP->A1_NOME
		@nLin, 134 PSAY STOD(TMP->E1_EMISSAO)
		@nLin, 146 PSAY STOD(TMP->E1_VENCREA)
		@nLin, 163 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
		
		cNat    := TMP->NATUREZ
		nVaLiq  += TMP->(VALOR - E1_IRRF - E1_INSS - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL)
		nValTot += TMP->VALOR
		nValNat += TMP->VALOR
		
		dbskip()
		
		If cNat != TMP->NATUREZ
			
			lOk := .T.
			nLin++
			@nLin, 000 PSAY "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
			nLin++
			@nLin, 000 PSAY " T O T A L I Z A D O R - N A T U R E Z A ----------------------------------------------->"
			@nLin, 094 PSAY nValNat PICTURE "@E 999,999,999.99"
			nLin++
			
			nValNat := 0 //Totalizador por Natureza
			
		Else
			
			lOk := .F.
			
		EndIf
		
		nLin 			+= 1 // Avanca a linha de impressao
		
	else // Imprime Sintetico	
		
		

		cNat := TMP->NATUREZ
		nValTot += TMP->VALOR
		nValNat += TMP->VALOR
		nVaLiq  += TMP->(VALOR - E1_IRRF - E1_INSS - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL)
		
		If lOk == .T.
			
			@nLin, 000 PSAY TMP->NATUREZ + " - " + TMP->ED_DESCRIC
			@nLin, 000 PSAY "_______________________________________________________________________________________"
			
		EndIf
		
		
		
		dbskip()
		
		If cNat != TMP->NATUREZ
			
			lOk := .T.
			@nLin, 055 PSAY nValNat PICTURE "@E 999,999,999.99"
			nValNat := 0 //Totalizador por Natureza
			nLin++
			
		Else
			
			lOk := .F.			
			
			
		EndIf
		
		
		
		
	EndIf	
	
	
	
	
	
ENDDO

nLin++
@nLin, 000 PSAY "Total Geral -------------------------------------------------------------------->"
@nLin, 085 PSAY nValTot PICTURE "@E 999,999,999,999.99"
//Rafael - 03/08/17 - Foi verificado que exitem diferen็as entre os impostos calculados no titulo para o impostos calculados nas naturezas 1203010 e 1203014. 
//Essa diferen็a acontece porque o vencimento de alguns impostos caem apenas para o mes seguinte ao vencimento do titulo principal.
nLin++  
@nLin, 000 PSAY "Total Liquido (-NCC/RA) - Impostos(PIS/COFINS/CSLL/IRRF/INSS/ISS)--------------->"
@nLin, 085 PSAY nVaLiq PICTURE "@E 999,999,999,999.99"





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

DBSelectArea("TMP")
DBCloseArea("TMP")

Return


Static Function MontaVetor()

DbSelectArea("TMP")
DBGotop()


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do  Prefixo ?","","","mv_ch01","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Prefixo ?","","","mv_ch02","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do  Numero ?","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Numero ?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","do Tipo","","","mv_ch05","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","05"})
AADD(aRegs,{cPerg,"06","Ate Tipo?","","","mv_ch06","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","05"})
AADD(aRegs,{cPerg,"07","Da  Natureza ?","","","mv_ch07","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"08","Ate Natureza ?","","","mv_ch08","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"09","Do  Cliente ?","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"10","Ate Cliente ?","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"11","Da  Emissao ?","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Emissao ?","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Do  Vencimento ?","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ate Vencimento ?","","","mv_ch14","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Tipo ?","","","mv_ch15","N",01,0,2,"C","","mv_par15","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Nao Imprimir Tipos","","","mv_ch16","C",20,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

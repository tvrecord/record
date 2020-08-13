#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTCR111  º Autor ³ Claudio Ferreira    º Data ³  26/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ficha Analitica                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TV Record                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RTCR111()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Ficha Analitica"
Local cPict        := ""
Local titulo       := "Ficha Analitica"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Private nVal01Ct   := 0
Private nVal10Ct   := 0
Private nVal12Ct   := 0
Private aOrd         := {""}
Private nVal01     := 0
Private nVal10     := 0
Private nVal12     := 0
Private nValAt01     := 0
Private nValAt10     := 0
Private nValAt12     := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "RTCR111" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTCR111" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cCentros,cCampos
Private cString := ""
Private aAtivo01 := {}
Private aAtivo10 := {}
Private aAtivo12 := {}
cPerg 		:= "RTC1113   "
ValidPerg()          // Cria pergunta
pergunte(cPerg,.t.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/09/04   º±±
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

Local aFormas:={'Aquisicao    ',;
'Leasing      ',;
'Doação       ',;
'Financiamento',;
'Comodato     ',;
'Outras       '}


cQuery := "SELECT * "
cQuery += "FROM SN3010 A "
cQuery += "WHERE N3_FILIAL='"+ xFilial("SN3") +"' "
cQuery += "AND N3_CCONTAB between '" + mv_par01 + "' AND '" + mv_par02 + "' "
cQuery += "AND N3_CUSTBEM between '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += "AND SUBSTR(N3_CBASE,1,6) between '" + mv_par05 + "' AND '" + mv_par06 + "' "
cQuery += "AND A.D_E_L_E_T_<>'*' "
cQuery += "ORDER BY N3_CBASE "
TCQUERY cQuery NEW ALIAS "QN3"
TCSetField("QN3","N3_AQUISIC","D")
TCSetField("QN3","N3_DINDEPR","D")
dbSelectArea("SN1")
DBSETORDER(1)
dbSelectArea("QN3")
dbGoTop()
sTexto:=''
lPuloup:=.T.
Cabec1:=''
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
SetRegua(RecCount())
While !EOF()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	SN1->(dbseek(xFilial("SN1")+QN3->N3_CBASE,.T.)) //Posiciona SN1
	dbSelectArea("QN3")
	@nLin,02 PSAY "Descricao do Bem.: "+N3_HISTOR
	nLin++
	@nLin,02 PSAY "Codigo do item...: "+N3_CBASE
	@nLin,35 PSAY "Valor Original...: "+Transform(N3_VORIG1,"@E 99,999,999.99")
	@nLin,74 PSAY "Qtde em Ufir´s...: "+Transform(N3_VORIG3,"@E 999,999.9999")
	nLin++
	@nLin,02 PSAY "Data de Aquisicao: "+Dtoc(N3_AQUISIC)
	@nLin,35 PSAY "Valor da Ufir....:     "+Transform(N3_VORIG1/N3_VORIG3,"@E 99.999999")
	@nLin,74 PSAY "Qtde de bens.....: " +Transform(SN1->N1_QUANTD,"@E 999,999")
	nLin++
	@nLin,02 PSAY "Data Inic.Deprec.: "+Dtoc(N3_DINDEPR)
	@nLin,35 PSAY "Taxa de Deprec...: "+Transform(N3_TXDEPR1,"@E 99.9999")+" %"
	nLin++
	@nLin,02 PSAY "Conta Contabil...: "+Alltrim(N3_CCONTAB) + " - "+Posicione("CT1",1,xfilial("CT1")+N3_CCONTAB,"CT1_DESC01")
	nLin++
	@nLin,02 PSAY "Centro de Custo..: "+Alltrim(N3_CUSTBEM) + "   - "+Posicione("CTT",1,xfilial("CTT")+N3_CUSTBEM,"CTT_DESC01")
	nLin++
	cNf:=SN1->N1_NFISCAL
	if !Empty(cNf)
		cNf:='NF '+cNf
	endif
	nForma=Val(SN1->N1_FORAQUI)  //Forma de Aquisição
	cForma:=aFormas[iif(nForma=0,6,nForma)]
	@nLin,02 PSAY "Histor. Aquisicao: "+cForma+" "+cNf
	cFornec:=SN1->N1_FORNEC
	cLoja:=SN1->N1_LOJA
	@nLin,49 PSAY "Fornecedor.: "+cFornec+"/"+cLoja+;
	" - "+Posicione("SA2",1,xfilial("SA2")+cFornec+cLoja,"A2_NOME")
	nLin++
	@nLin,02 PSAY "Cia Seguro.......: "+SN1->N1_CSEGURO+;
	"   No APOLICE.: "+SN1->N1_APOLICE+;
	"   Vecto.: "+Dtoc(SN1->N1_DTVENC)+;
	"   Tipo.: "+SN1->N1_TIPOSEG
	if mv_par07=1 //Depr = Sim
		//Mapa da depreciação
		dbSelectArea("SN4")
		DBSETORDER(4)
		dbseek(xFilial("SN4")+QN3->N3_CBASE+QN3->N3_ITEM+QN3->N3_TIPO+"06",.T.) //Posiciona SN4
		CabDep:=.t.
		nVlrAcm:=QN3->N3_VRDACM1 - QN3->N3_VRDBAL1 //Inicia com o Acumulado
		nVlrAtu:=QN3->N3_VORIG1-nVlrAcm
		While !EOF() .and. QN3->N3_CBASE+QN3->N3_ITEM+QN3->N3_TIPO=N4_CBASE+N4_ITEM+N4_TIPO .AND. N4_DATA <= dDataBase
			if N4_TIPOCNT<>'3'
				DbSkip()
				loop
			endif
			if CabDep
				nLin+=2
				@nLin,02 PSAY "Controle da Depreciação"
				nLin++
				@nLin,02 PSAY "Referência       Do Mês           Acumulado       Vlr. Atualizado   % Depr.
				// 01/2007      999,999,999.99    999,999,999.99     999,999,999.99    999.99
				CabDep:=.f.
			endif
			nVlrAcm+=N4_VLROC1
			nVlrAtu-=N4_VLROC1
			nLin++
			@nLin,02 PSAY " "+substr(dtoc(N4_DATA),4,7)
			
			If substr(dtoc(N4_DATA),4,7) == MV_PAR08 .AND. ((nVlrAcm/QN3->N3_VORIG1)*100 < 100) .AND. N4_TIPO == "01"
				aAdd(aAtivo01,{N4_FILIAL,N4_CBASE,N4_ITEM,N4_TIPO,nVlrAcm,N4_VLROC1})
			ELSEIF substr(dtoc(N4_DATA),4,7) == MV_PAR08 .AND. ((nVlrAcm/QN3->N3_VORIG1)*100 < 100) .AND. N4_TIPO == "10"
				aAdd(aAtivo10,{N4_FILIAL,N4_CBASE,N4_ITEM,N4_TIPO,nVlrAcm,N4_VLROC1})
			ELSEIF substr(dtoc(N4_DATA),4,7) == MV_PAR08 .AND. ((nVlrAcm/QN3->N3_VORIG1)*100 < 100) .AND. N4_TIPO == "12"
				aAdd(aAtivo12,{N4_FILIAL,N4_CBASE,N4_ITEM,N4_TIPO,nVlrAcm,N4_VLROC1})
			EndIf
			
			@nLin,17       PSAY Transform(N4_VLROC1,"@E 999,999,999.99")
			@nLin,PCOL()+4 PSAY Transform(nVlrAcm,"@E 999,999,999.99")
			@nLin,PCOL()+4 PSAY Transform(nVlrAtu,"@E 999,999,999.99")
			@nLin,PCOL()+4 PSAY Transform((nVlrAcm/QN3->N3_VORIG1)*100,"@E 999.99")
			DbSkip()
			If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin,02 PSAY "Descricao do Bem.: "+QN3->N3_HISTOR
				nLin++
				CabDep:=.t.
			Endif
		Enddo
	Endif
	dbSelectArea("QN3")
	@ nLin+1,000 PSAY __PrtThinLine()
	nLin := nLin + 2 // Avanca a linha de impressao
	lPuloup:=.F.
	if mv_par07=1 //Depr = Sim
		nLin:=99 //Avança página por item
		m_pag := 01 //Volta a pagina para 1 qdo for ficha
	endif
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//Imprimir Ativos


If  !EMPTY(aAtivo01)

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
@nLin,40       PSAY "Tipo 01"
nLin += 2
@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao         Contabilidade"
nLin += 2


For i:=1 to Len(aAtivo01)
	
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		
		@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao          Contabilidade"
		nLin += 2
	Endif
	
	@nLin,01       PSAY aAtivo01[i][1]
	@nLin,10       PSAY aAtivo01[i][2]
	@nLin,25       PSAY aAtivo01[i][3]
	@nLin,35       PSAY aAtivo01[i][4]
	@nLin,40       PSAY aAtivo01[i][5]
	@nLin,65       PSAY Posicione("SN3",1,aAtivo01[i][1] + aAtivo01[i][2] + aAtivo01[i][3] + aAtivo01[i][4],"N3_VRDACM1")
	If Posicione("SN3",1,aAtivo01[i][1] + aAtivo01[i][2] + aAtivo01[i][3] + aAtivo01[i][4],"N3_VRDACM1")  <> aAtivo01[i][5]
		@nLin,85       PSAY "INCONSITENCIA"
	ELSE
		@nLin,85       PSAY "OK"
	EndIf
	@nLin,108       PSAY aAtivo01[i][6]	
	nLin++

	
		nVal01 += aAtivo01[i][5]
		nValat01 += Posicione("SN3",1,aAtivo01[i][1] + aAtivo01[i][2] + aAtivo01[i][3] + aAtivo01[i][4],"N3_VRDACM1")
		nVal01Ct += aAtivo01[i][6]
		
		
		

	
Next

nLin+= 5
@nLin,40       PSAY "Valor Relatorio          Valor Sistema         Valor Contabilidade"
nLin++
@nLin,40       PSAY nVal01
@nLin,65       PSAY nValAt01
@nLin,100      PSAY nVal01Ct
nLin+=2

Endif

If  !EMPTY(aAtivo10)

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
@nLin,40       PSAY "Tipo 10"
nLin += 2
@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao         Contabilidade"
nLin += 2


For i:=1 to Len(aAtivo10)
	
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		
		@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao          Contabilidade"
		nLin += 2
	Endif
	
	@nLin,01       PSAY aAtivo10[i][1]
	@nLin,10       PSAY aAtivo10[i][2]
	@nLin,25       PSAY aAtivo10[i][3]
	@nLin,35       PSAY aAtivo10[i][4]
	@nLin,40       PSAY aAtivo10[i][5]
	@nLin,65       PSAY Posicione("SN3",1,aAtivo10[i][1] + aAtivo10[i][2] + aAtivo10[i][3] + aAtivo10[i][4],"N3_VRDACM1")
	If Posicione("SN3",1,aAtivo10[i][1] + aAtivo10[i][2] + aAtivo10[i][3] + aAtivo10[i][4],"N3_VRDACM1")  <> aAtivo10[i][5]
		@nLin,85       PSAY "INCONSITENCIA"
	ELSE
		@nLin,85       PSAY "OK"
	EndIf
	@nLin,108       PSAY aAtivo10[i][6]		
	nLin++
	
		nVal10 += aAtivo10[i][5]
		nValat10 += Posicione("SN3",1,aAtivo10[i][1] + aAtivo10[i][2] + aAtivo10[i][3] + aAtivo10[i][4],"N3_VRDACM1")
		nVal10Ct += aAtivo10[i][6]
		
		
		

	
Next

nLin+= 5
@nLin,40       PSAY "Valor Relatorio          Valor Sistema         Valor Contabilidade"
nLin++
@nLin,40       PSAY nVal10
@nLin,65       PSAY nValAt10
@nLin,100      PSAY nVal10Ct
nLin+=2

Endif

If  !EMPTY(aAtivo12)

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
@nLin,40       PSAY "Tipo 12"
nLin += 2
@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao         Contabilidade"
nLin += 2


For i:=1 to Len(aAtivo12)
	
	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		
		@nLin,01       PSAY "Filial     Bem          Item      TP  Vl Relatorio             Val Ativo           Validacao          Contabilidade"
		nLin += 2
	Endif
	
	@nLin,01       PSAY aAtivo12[i][1]
	@nLin,10       PSAY aAtivo12[i][2]
	@nLin,25       PSAY aAtivo12[i][3]
	@nLin,35       PSAY aAtivo12[i][4]
	@nLin,40       PSAY aAtivo12[i][5]
	@nLin,65       PSAY Posicione("SN3",1,aAtivo12[i][1] + aAtivo12[i][2] + aAtivo12[i][3] + aAtivo12[i][4],"N3_VRDACM1")
	If Posicione("SN3",1,aAtivo12[i][1] + aAtivo12[i][2] + aAtivo12[i][3] + aAtivo12[i][4],"N3_VRDACM1")  <> aAtivo12[i][5]
		@nLin,85       PSAY "INCONSITENCIA"
	ELSE
		@nLin,85       PSAY "OK"
	EndIf
	@nLin,108       PSAY aAtivo12[i][6]		
	nLin++
	
		nVal12 += aAtivo12[i][5]
		nValat12 += Posicione("SN3",1,aAtivo12[i][1] + aAtivo12[i][2] + aAtivo12[i][3] + aAtivo12[i][4],"N3_VRDACM1")
		nVal12Ct += aAtivo12[i][6]
		
		
		

	
Next

nLin+= 5
@nLin,40       PSAY "Valor Relatorio          Valor Sistema         Valor Contabilidade"
nLin++
@nLin,40       PSAY nVal12
@nLin,65       PSAY nValAt12
@nLin,100      PSAY nVal12Ct
nLin+=2

Endif



@nLin,40       PSAY "TOTALIZADOR (Tipo 01 + 10 + 12)               Valor Contabilidade"
nLin++
@nLin,40       PSAY nVal01 + nVal10 + nVal12
@nLin,65       PSAY nValAt01 + nValAt10 + nValAt12
@nLin,100       PSAY nVal01Ct + nVal10Ct + nVal12Ct


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

dbSelectArea("QN3")
dbclosearea()

Return

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
aRegs	:=	{}

AADD(aRegs,{cPerg,"01","Conta   De       ?",Space(20),Space(20),"mv_ch1","C",20,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
AADD(aRegs,{cPerg,"02","Conta   Ate      ?",Space(20),Space(20),"mv_ch2","C",20,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
Aadd(aRegs,{cPerg,"03","C.Custo De       ?",Space(07),Space(07),"mv_ch3","C",10,0,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
Aadd(aRegs,{cPerg,"04","C.Custo Ate      ?",Space(07),Space(07),"mv_ch4","C",10,0,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","",""})
Aadd(aRegs,{cPerg,"05","Bem     De       ?",Space(07),Space(07),"mv_ch5","C",06,0,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SN1","","","","",""})
Aadd(aRegs,{cPerg,"06","Bem     Ate      ?",Space(07),Space(07),"mv_ch6","C",06,0,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SN1","","","","",""})
Aadd(aRegs,{cPerg,"07","Depreciacao      ?",Space(07),Space(07),"mv_ch7","N",01,0,1,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Mes/Ano          ?",Space(07),Space(07),"mv_ch8","C",07,0,0,"C","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return


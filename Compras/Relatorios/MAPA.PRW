#INCLUDE "rwmake.ch"
#include "font.ch"
#INCLUDE "Topconn.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/*/
±±ºPrograma  ³CCI301    º Autor ³ Edmilson Dias Santos  º Data ³  12/07/01º±±
±±ºDescricao ³ Relatorio de Analise de Cotacao - TOMADA DE PRECOS         º±±
±±ºUso       ³ Clientes Microsiga                                         º±±

SIGACOM-> Relatorios -> Especificos -> Mapa grafico

/*/

User Function CCI31U()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local aOrd         := {}
	Local aPergs       := {}
	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "MAPA COMPARATIVO DE PRECOS"
	Local cPict        := ""
	Local titulo       := "MAPA DE COTAÇÃO"
	Local Cabec1       := " "
	Local Cabec2       := " "
	Local imprime      := .T.
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "CCI301" // Coloque aqui o nome do arquivo usado para impressao em disco
	PRIVATE nLin       := 465
	Private cString
	Private CbTxt      := ""
	Private lEnd       := .F.
	Private lAbortPrint:= .F.
	Private limite     := 220
	Private Tamanho    := "G"
	Private nomeprog   := "CCI301"
	Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cString    := "SC8"
	Private cPerg      := "CCI31U1"
	Private cMotivo1   := ""
	Private cMotivo2   := ""
	Private cMotivo3   := ""
	Private nAss	   := 0
	Private nValor	   := 0
	Private cCotaDe		:= ""
	Private cCotaAte	:= ""
	Private nAtuEst		:= ""
	Private nImobi		:= ""




	//dbSelectArea("SC8") Bruno - Ajustar uso
	//dbSetOrder(1)

	//Relatorio sendo chamado pela rotina de aprovação liberar documento
	IF Alltrim(FUNNAME()) == "MATA094"

		cCotaDe		:= POSICIONE("SC8",11,xFilial("SC8")+Alltrim(SCR->CR_NUM) + "0001","C8_NUM")
		cCotaAte	:= POSICIONE("SC8",11,xFilial("SC8")+Alltrim(SCR->CR_NUM) + "0001","C8_NUM")
		nAtuEst		:= 1
		nImobi		:= 1

	Else

		ValidPerg(cPerg)

		If !Pergunte(cPerg,.T.)
			alert("OPERAÇÃO CANCELADA")
			return
		ENDIF

		//cCotaDe		:= MV_PAR01
		//cCotaAte		:= MV_PAR02
		cCotaDe		:= POSICIONE("SC8",11,xFilial("SC8") + MV_PAR01 + "0001","C8_NUM")
		cCotaAte	:= POSICIONE("SC8",11,xFilial("SC8") + MV_PAR02 + "0001","C8_NUM")
		nAtuEst		:= MV_PAR03
		nImobi		:= MV_PAR04

	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  12/07/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

	LOCAL	aPergs := {}
	Local nOrdem,nRegAtual
	Private cCodComp  := ""
	Private cNomeComp := ""
	Private cTel 	  := 0
	Private dLib01    := "//"
	Private dLib02		:= "//"
	Private dLib03		:= "//"
	Private lAprov01 := .F.
	Private lAprov02  := .F.
	Private lAprov03  := .F.
	Private lAssAus  := .F.
	Private lFer  := .F.
	Private cAprov01 := ""
	Private cFuncao01 := ""
	Private cLib01 := ""
	Private	lass01 := .F.
	Private cAprov02 := ""
	Private cFuncao02 := ""
	Private cLib02 := ""
	Private	lass02 := .F.
	Private cAprov03 := ""
	Private cFuncao03 := ""
	Private cLib03 := ""
	Private	lass03 := .F.
	Private cAprovAus:= ""
	Private cQuery   := ""
	Private cPedidoC := ""
	Private cMotivo  := ""
	Private nTotFre  := 0
	Private nTotIPI  := 0
	Private nVlDesc  := 0
	Private nTotVal  := 0
	Private nTot     := 0
	Private nValDesp := 0
	Private cFornece := ""
	Private cTemp    := ""
	PRIVATE aProdutos,aComplemen,aFornCab,aFornece,aPrecos,aSubTotal,aFrete,aDesconto,aIPI,aOrcado,aDesc,aDespesa
	PRIVATE aPrazo,aCondPgto,i,J,cDescri,aMinimos,ij,pMinimo,porcado
	private pCotacao,pData
	Private oFont, cCode, oPrn
	Private lPrimPag :=.t.
	Private lEnc    := .f.
	Private  nPag  := 1
	Private cCGCPict, cCepPict
	Private cBMP001
	Private cUser   := ""
	Private cNomeCC := ""
	Private cCodUser1 := ""
	Private cCodUser2 := ""
	Private cCodUser3 := ""
	Private dPrazo1	 := CTOD("//")
	Private nPrazo1	 := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definir as pictures                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCepPict:=PesqPict("SA2","A2_CEP")
	cCGCPict:=PesqPict("SA2","A2_CGC")

	oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
	oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
	oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont5 := TFont():New( "Arial",,08,,.t.,,,,,.f. )
	oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
	oFont7 := TFont():New( "Arial",,14,,.t.,,,,,.f. )
	oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
	oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
	oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
	oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
	oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )
	oFont13:= TFont():New( "Arial",,25,,.t.,,,,,.f. )
	oFont14 := TFont():New( "Arial",,06,,.t.,,,,,.f. )

	oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
	oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
	oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
	oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
	oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
	oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
	oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
	oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
	oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
	oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetRegua(RecCount())
	pOrcado := 0
	/*Retirado por conta da implementação da rotina de aprovação - Bruno Alves 21-01-2021
	If AllTrim(Substring(cUsuario,7,15)) $ "Luciano Ribeiro%Eleni Caldeira (Elenn)%Claudinei Girotti%Josiel Ferreira%Wagner Lima"
		MV_PAR01 := POSICIONE("SC8",11,xFilial("SC8")+Alltrim(SCR->CR_NUM) + "0001","C8_NUM")
		MV_PAR02 := POSICIONE("SC8",11,xFilial("SC8")+Alltrim(SCR->CR_NUM) + "0001","C8_NUM")
	Endif
	*/




	dbSelectArea("SC8")
	dbSetOrder(1)
	SC8->(DBSEEK(xFilial("SC8")+cCotaDe,.T. ) )


	// Alterado para imprimir intervalo de mapas 17/10/2014
	//While !SC8->(EOF()).AND.SC8->C8_NUM <= MV_PAR01
	While !SC8->(EOF()) .AND. SC8->C8_NUM >= cCotaDe .AND. SC8->C8_NUM <= cCotaAte

		pCotacao	  := SC8->C8_NUM
		pData      := SC8->C8_EMISSAO



		// Monta a Matriz de Fornecedores participantes
		nRegAtual  := RECNO()
		aProdutos  := {}
		aComplemen := {}
		aFornece   := {}
		aPrecos    := {}
		aMinimos   := {}
		aFrete     := {}
		aDesconto  := {}
		aIPI       := {0,0,0,0,0}
		aPrazo     := {0,0,0,0,0}
		aCondPgto  := {"","","","",""}
		aSubTotal  := {0,0,0,0,0}
		aFrete     := {0,0,0,0,0}
		aDesconto  := {0,0,0,0,0}
		aDespesa   := {0,0,0,0,0}
		aDesc      := {0,0,0,0,0}
		aFornCab  := {}

		While !SC8->(EOF()) .AND. SC8->C8_NUM == pCotacao

			If SC8->C8_NUMPED != "XXXXXX"
				cPedidoC := SC8->C8_NUMPED
				cMotivo  := SC8->C8_MOTIVO
				nTotFre  := SC8->C8_TOTFRE
				nTotIPI  := nTotIPI + SC8->C8_VALIPI
				nVlDesc  := nVlDesc + SC8->C8_VLDESC
				cFornece := SC8->C8_FORNECE
				nTotVal  := nTotVal + SC8->C8_TOTAL
				cUser	 := POSICIONE("SC7",1,xFilial("SC7")+SC8->C8_NUMPED,"C7_USER")
				nValDesp := nValDesp + SC8->C8_DESPESA
				nPrazo1	 := SC8->C8_PRAZO
			EndIf
			cBMP001 := "Assinaturas\"+(cUser)+".bmp"

			// Cria Matriz com os Produtos
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			SB1->( DBSEEK(xFilial("SB1")+SC8->C8_PRODUTO,.T.) )

			DBSELECTAREA("SC1")
			DBSETORDER(2)
			SC1->( DBSEEK(xFilial("SC1")+SC8->C8_PRODUTO+SC8->C8_NUMSC+SC8->C8_ITEMSC,.T.) )

			aSolicita := SC1->C1_SOLICIT
			aCusto    := SC1->C1_CC
			aNatureza := SC1->C1_NATUREZ   //INCLUIDO ISTO
			aFinalida := SC1->C1_FINALID   //INCLUIDO ISTO
			//DBSELECTAREA("SB5")
			//DBSETORDER(1)
			//If DBSEEK(xFilial("SB5")+SC8->C8_PRODUTO,.T.)
			//	cDescri := Alltrim(SB5->B5_CEME)
			//Else
			//cDescri := Alltrim(SC1->C1_DESCRI) + IIF(!EMPTY(SC1->C1_OBS)," Obs.: "+SC1->C1_OBS,SPACE(1))
			cDescri := ALLTRIM(SB1->B1_DESC)
			//Endif
			//IF LEFT(SB1->B1_DESC,AT(SPACE(1),SB1->B1_DESC)) <> LEFT(cDescri,AT(SPACE(1),cDescri))
			//  cDescri := LEFT(ALLTRIM(SB1->B1_DESC),AT(SPACE(1),ALLTRIM(SB1->B1_DESC)))+ " " + cDescri
			//ENDIF

			I := ASCAN(aProdutos,SC8->C8_PRODUTO+ALLTRIM(cDescri))
			IF I = 0
				AADD(aProdutos ,SC8->C8_PRODUTO+ALLTRIM(cDescri))
				AADD(aComplemen,{IIF(SC8->C8_QTSEGUM > 0,SC8->C8_QTSEGUM,SC8->C8_QUANT),IIF(SC8->C8_QTSEGUM > 0,SC8->C8_SEGUM,SC8->C8_UM)})
				AADD(aPrecos,{0,0,0,0,0})
				J := LEN(aProdutos)
			ELSE
				J := I
			ENDIF

			// Verifica a Coluna do Preco do Fornecedor
			i :=  ASCAN(aFornCab,SC8->C8_FORNECE+SC8->C8_LOJA)

			IF i == 0
				AADD(aFornCab ,SC8->C8_FORNECE+SC8->C8_LOJA)
				IF LEN(aFornCab) <= 5
					aPrecos[J][LEN(aFornCab)] := IIF(SC8->C8_QTSEGUM > 0,SC8->C8_PRECO,SC8->C8_PRECO)
					aFrete[LEN(aFornCab)]     := SC8->C8_TOTFRE
					aIPI[LEN(aFornCab)]       := SC8->C8_VALIPI
					aDesconto[LEN(aFornCab)]  := SC8->C8_VLDESC
					aPrazo[LEN(aFornCab)]     := SC8->C8_PRAZO
					aDespesa[LEN(aFornCab)]   := SC8->C8_DESPESA
					dbSelectArea("SE4")
					dbSetOrder(1)
					dbSeek(xFilial()+SC8->C8_COND)
					dbSelectArea("SC8")
					aCondPgto[LEN(aFornCab)]  := SubStr(SE4->E4_DESCRI,1,15)
				ENDIF
			ELSE
				IF I <= 5
					aPrecos[J][I]    := IIF(SC8->C8_QTSEGUM > 0,SC8->C8_PRECO,SC8->C8_PRECO)
					aFrete[i]        := SC8->C8_TOTFRE
					aPrazo[i]        := SC8->C8_PRAZO
					aIPI[I]          += SC8->C8_VALIPI
					aDesconto[I]     += SC8->C8_VLDESC
					aDespesa[I]      += SC8->C8_DESPESA


					dbSelectArea("SE4")
					dbSetOrder(1)
					dbSeek(xFilial()+SC8->C8_COND)
					aCondPgto[i] := SubStr(SE4->E4_DESCRI,1,15)
				ENDIF
			ENDIF
			DBSELECTAREA("SC8")
			SC8->(dbSkip())

			IncRegua()

		ENDDO

		nTot :=	 nTotVal + nTotFre + nTotIPI - nVlDesc + nValDesp //Valor total do pedido menos o desconto e o frete


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ImprCabec()

		aSubTotal  := {0,0,0,0,0,0}
		aDesc      := {0,0,0,0,0,0}
		I := 1
		While I <= LEN(aProdutos)

			IF NLIN > 1790
				ImprCabec()
			ENDIF

			oPrn:Say( nLin, 0020,STRZERO(I,4),oFont5,100 )
			oPrn:Say( nLin, 0180,TRANSFORM(aComplemen[i][1],"@E 9999999.99"),oFont5,100 )
			oPrn:Say( nLin, 0330,aComplemen[i][2],oFont5,100 )
			oPrn:Say( nLin, 0440,LEFT(aProdutos[i],8),oFont5,100 )
			oPrn:Say( nLin, 0590,SUBSTR(aProdutos[i],16,800),oFont5,100 )

			/*
		nJ := (Int(Len( ALLTRIM(aProdutos[i]))-15) /905 )
		nI := 1
		While nI < nJ
		IF ni =1
		nlin+=0050
		ENDIF
		oPrn:Say(nLin, 0570,SUBSTR(aProdutos[i],16 + (nI * 905 + 1),905),oFont5,100)
		If nI < nJ - 1
		nLin+=0050
		Endif
		nI++
		EndDo
			*/

			oPrn:Say( nLin, 1520,TRANSFORM(aPrecos[i][1],"@E 999,999,999.99"),oFont5,100 )
			oPrn:Say( nLin, 1900,TRANSFORM(((aPrecos[i][1]*aComplemen[i][1])),"@E 999,999,999.99"),oFont5,100 )

			oPrn:Say( nLin, 2170,TRANSFORM(aPrecos[i][2],"@E 999,999,999.99"),oFont5,100 )
			oPrn:Say( nLin, 2550,TRANSFORM(((aPrecos[i][2]*aComplemen[i][1])),"@E 999,999,999.99"),oFont5,100 )

			oPrn:Say( nLin, 2810,TRANSFORM(aPrecos[i][3],"@E 999,999,999.99"),oFont5,100 )
			oPrn:Say( nLin, 3100,TRANSFORM(((aPrecos[i][3]*aComplemen[i][1])),"@E 999,999,999.99"),oFont5,100 )

			nLin+= 0050

			aSubTotal[1] +=(aPrecos[i][1] * aComplemen[i][1])
			aSubTotal[2] +=(aPrecos[i][2] * aComplemen[i][1])
			aSubTotal[3] +=(aPrecos[i][3] * aComplemen[i][1])
			/*
		aDesc[1]     +=(aDesconto[i][1])
		aDesc[2]     +=(aDesconto[i][2])
		aDesc[3]     +=(aDesconto[i][3])
			*/
			I := I + 1

		ENDDO
		/*
	IF aDesc[1]+aDesc[2]+aDesc[3] > 0
	oPrn:Say( nLin, 1900,"Desconto..",oFont5,100 )
	oPrn:Say( nLin, 1900,TRANSFORM(aDesc[1],"@E 999,999,999.99"),oFont5,100 )
	oPrn:Say( nLin, 2550,TRANSFORM(aDesc[2],"@E 999,999,999.99"),oFont5,100 )
	oPrn:Say( nLin, 3100,TRANSFORM(aDesc[3],"@E 999,999,999.99"),oFont5,100 )
	ENDIF
		*/
		ImprRodape()

	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
If aReturn[5]==1
dbCommitAll()
SET PRINTER TO
OurSpool(wnrel)
Endif
	*/

	If lEnc
		oPrn:Preview()
		//	MS_FLUSH()
	EndIf

	MS_FLUSH()

	DBSelectArea("SA2")
	DBSetOrder(1)
	DBSeek(xFilial("SA2")+ SC7->C7_FORNECE)

Return



STATIC FUNCTION ImprCabec()

	//LOCAL aCoords1 := {0480,0000,0560,0105}
	//LOCAL aCoords2 := {0480,0105,0560,0300}
	//LOCAL oBrush

	If !lPrimPag
		oPrn:EndPage()
		oPrn:StartPage()
		nPag ++
	Else
		lPrimPag := .f.
		lEnc     := .t.
		oPrn  := TMSPrinter():New()
		oPrn:Setup()
	EndIF

	oPrn:Say( 0020, 0000, " ",oFont,100 ) // startando a impressora
	//"Pinta" os Campos com Cinza.
	//oPrn:FillRect(aCoords1,oBrush)
	//oPrn:FillRect(aCoords2,oBrush)

	//Cabecalho ( Orcamentos orcados )
	oPrn:Box( 0020, 0900, 0160,1450)  // box do cabeçalho do Pedido orcados

	//Cabecalho (Enderecos da Empresa e Fornecedor)
	oPrn:Box( 0020, 0000, 0320,0900)  // box do cabeçalho da empresa
	oPrn:Box( 0020, 2740, 0240,3300)  // box do número da cotação e data

	oPrn:Box( 0020, 1450, 0400,3300)  // box da Palavra Mapa de Cotacao

	oPrn:Box( 0160, 1450, 0400,2100)  // box do Nome Cond.Pagto 1
	oPrn:Box( 0160, 2100, 0400,2740)  // box do Nome Cond.Pagto 2
	oPrn:Box( 0160, 2740, 0400,3300)  // box do Nome Cond.Pagto 2

	oPrn:Box( 0240, 1450, 0400,2100)  // box do Nome Fornecedor 1
	oPrn:Box( 0240, 2100, 0400,2740)  // box do Nome Fornecedor 2
	oPrn:Box( 0240, 2740, 0400,3300)  // box do Nome Fornecedor 2

	oPrn:Box( 0320, 0000, 0400,0900)  // box da palavra Controle de Estoque
	oPrn:Box( 0320, 1450, 0400,2100)  // box da 1º TEL.
	oPrn:Box( 0320, 2100, 0400,2740)  // box da 2º TEL.
	oPrn:Box( 0320, 2740, 0400,3300)  // box da 3º TEL.

	oPrn:Box( 0400, 0000, 0480,0900)  // box da palavra Imobilizado
	oPrn:Box( 0400, 1450, 0480,2100)  // box 1 Sr(a)
	oPrn:Box( 0400, 2100, 0480,2740)  // box 2 Sr(a)
	oPrn:Box( 0400, 2740, 0480,3300)  // box 3 Sr(a)

	oPrn:Box( 0480, 0000,0560,0105) //linhas verticais do inicio (coluna ITEM)inicio
	oPrn:Box( 0480, 0105,0560,0300) //linhas verticais do inicio (coluna QTDE)
	oPrn:Box( 0480, 0300,0560,0400) //linhas verticais do inicio (coluna UNID)
	oPrn:Box( 0480, 0400,0560,0570) //linhas verticais do inicio (coluna CODIGO PRODUTO)
	oPrn:Box( 0480, 0570,0560,1450) //linhas verticais do inicio (coluna DESCRICAO MATERIAL)
	oPrn:Box( 0480, 1450,0560,1750) //linhas verticais do inicio (coluna 1 Vlr Unit.)
	oPrn:Box( 0480, 1750,0560,2100) //linhas verticais do inicio (coluna 1 Vlr Total)
	oPrn:Box( 0480, 2100,0560,2400) //linhas verticais do inicio (coluna 2 Vlr Unit.)
	oPrn:Box( 0480, 2400,0560,2740) //linhas verticais do inicio (coluna 2 Vlr Total)
	oPrn:Box( 0480, 2740,0560,3000) //linhas verticais do inicio (coluna 3 Vlr Unit.)
	oPrn:Box( 0480, 3000,0560,3300) //linhas verticais do inicio (coluna 3 Vlr Total)

	oPrn:Box( 0560, 0000,1820,0105) // 1 coluna
	oPrn:Box( 0560, 0105,1820,0300) // 2 coluna
	oPrn:Box( 0560, 0300,1820,0400) // 3 coluna
	oPrn:Box( 0560, 0400,1820,0570) // 4 coluna
	oPrn:Box( 0560, 0570,1820,1450) // 5 coluna
	oPrn:Box( 0560, 1450,1820,1750) // 6 coluna
	oPrn:Box( 0560, 1750,1820,2100) // 7 coluna
	oPrn:Box( 0560, 2100,1820,2400) // 8 coluna
	oPrn:Box( 0560, 2400,1820,2740) // 9 coluna
	oPrn:Box( 0560, 2740,1820,3000) //10 coluna
	oPrn:Box( 0560, 3000,1820,3300) //11 coluna

	//oPrn:SayBitmap( 0100,0040,"logo.bmp",0360,0200 )

	// Grava numero do pedido no documento.

	//oPrn:Say( 0050, 2800,"Nº Pedido : ",oFont3,100 )
	//oPrn:Say( 0050, 3110,cPedidoC,oFont3,100 )

	oPrn:Say( 0050, 2800,"Nº COTAÇÃO: ",oFont3,100 )
	oPrn:Say( 0050, 3110,pCotacao,oFont3,100 )

	//Rafael - Rateio de CC
	DBSELECTAREA("SZL")
	DBSETORDER(1)
	DBSEEK(xFilial("SZL") + pCotacao)


	cMotivo1 := SZL->ZL_OBS1
	cMotivo2 := SZL->ZL_OBS2
	cMotivo3 := SZL->ZL_OBSPO


	oPrn:Say( 0080, 0020,RTRIM(SM0->M0_NOMECOM),oFont3,100 )
	oPrn:Say( 0080, 1800,"MAPA DE COTAÇÃO",oFont1,100 )
	oPrn:Say( 0110, 2800,"EMISSAO: ",oFont3,100 )
	oPrn:Say( 0110, 3100,DTOC(pData),oFont3,100 )
	oPrn:Say( 0140, 0020,"SRTV SUL QD 701 BL. H LT 10R 1º E 2º ANDAR",oFont3,100 )
	oPrn:Say( 0200, 0020,"CNPJ: "+TRANSFORM(RTRIM(SM0->M0_CGC),"@R 99.999.999/9999-99"),oFont3,100 )
	oPrn:Say( 0260, 0020,"INSCRIÇÃO ESTADUAL: "+TRANSFORM(SM0->M0_INSC,"@R 99.999.999/999/99"),oFont3,100 )
	oPrn:Say( 0330, 0020,"CONTROLE DE ESTOQUE ",oFont5,100 )
	oPrn:Say( 0330, 0450,"SIM  |"+IF(nAtuEst==1,"X","")+"     |        NÃO   |"+IF(nAtuEst==2,"X","")+"     | ",oFont5,100 )
	oPrn:Say( 0090, 0920,"PEDIDO ORÇADO: ",oFont5,100 )
	oPrn:Say( 0090, 1170,"SIM  |"+IF(SZL->ZL_PEDORC == "1","X","")+"  |   NÃO   |"+IF(SZL->ZL_PEDORC=="2","X","")+" | ",oFont5,100 )
	IF SZL->ZL_TPPAG == "1"

		oPrn:Say( 0180, 0920,"DADOS PAGAMENTO:",oFont5,100 )
		oPrn:Say( 0260, 0920,"BOLETO",oFont5,100 )

	ELSEIF SZL->ZL_TPPAG == "2"

		DBSelectArea("SA2")
		DBSetorder(1)
		DBSeek(xFilial("SA2") + cFornece)


		oPrn:Say( 0180, 0920,"DADOS PAGAMENTO:",oFont5,100 )
		oPrn:Say( 0260, 0920,"TRANSFERENCIA",oFont5,100 )
		oPrn:Say( 0340, 0920,"BANCO: " + TRANSFORM(SA2->A2_BANCO,"@R 999"),oFont5,100 )
		oPrn:Say( 0340, 1170,"AGENCIA: " + ALLTRIM(SA2->A2_AGENCIA) + "-" + SA2->A2_DGAGEN + "",oFont5,100 )
		oPrn:Say( 0420, 0920,"CONTA: " + ALLTRIM(SA2->A2_NUMCON) + "-" + SA2->A2_DGCONTA + "",oFont5,100 )

	ENDIF

	oPrn:Say( 0330, 1470,"TEL.",oFont5,100 )
	oPrn:Say( 0330, 2120,"TEL.",oFont5,100 )
	oPrn:Say( 0330, 2760,"TEL.",oFont5,100 )
	oPrn:Say( 0420, 1470,"Cod. Fornecedor:",oFont5,100 )
	oPrn:Say( 0420, 2120,"Cod. Fornecedor:",oFont5,100 )
	oPrn:Say( 0420, 2760,"Cod. Fornecedor:",oFont5,100 )
	oPrn:Say( 0420, 0020,"IMOBILIZADO ",oFont5,100 )
	oPrn:Say( 0420, 0450,"SIM  |"+IF(nImobi==1,"X","")+"     |        NÃO   |"+IF(nImobi==2,"X","")+"     | ",oFont5,100 )
	oPrn:Say( 0510, 0020," ITEM",oFont5,100 )
	oPrn:Say( 0510, 0200,"QTDE",oFont5,100 )
	oPrn:Say( 0510, 0320,"UNID",oFont5,100 )
	oPrn:Say( 0510, 0430,"CODIGO",oFont5,100 )

	oPrn:Say( 0510, 0580,"DESCRIÇÃO DO MATERIAL",oFont5,100 )
	oPrn:Say( 0510, 1500,"VALOR UNIT.",oFont5,100 )
	oPrn:Say( 0510, 1850,"VALOR TOTAL",oFont5,100 )
	oPrn:Say( 0510, 2200,"VALOR UNIT.",oFont5,100 )
	oPrn:Say( 0510, 2500,"VALOR TOTAL",oFont5,100 )
	oPrn:Say( 0510, 2800,"VALOR UNIT.",oFont5,100 )
	oPrn:Say( 0510, 3050,"VALOR TOTAL",oFont5,100 )

	nLin := 0560

	DBSELECTAREA("SA2")
	DBSETORDER(1)

	oPrn:Say(0180, 1500,"Cond.Pagto:  "+LEFT(aCondPgto[1],25),oFont5,100 )
	oPrn:Say(0180, 2130,"Cond.Pagto:  "+LEFT(aCondPgto[2],25),oFont5,100 )
	oPrn:Say(0180, 2780,"Cond.Pagto:  "+LEFT(aCondPgto[3],25),oFont5,100 )

	IF LEN(aFornCab) >= 1
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
		oPrn:Say( 0250, 1500,LEFT(SA2->A2_NOME,25),oFont3,100 )
		oPrn:Say( 0415, 1710,Substr(aFornCab[1],1,6),oFont3,100 )
	ENDIF
	IF LEN(aFornCab) >= 2
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
		oPrn:Say( 0250, 2130,LEFT(SA2->A2_NOME,25),oFont3,100 )
		oPrn:Say( 0415, 2360,Substr(aFornCab[2],1,6),oFont3,100 )
	ENDIF
	IF LEN(aFornCab) >= 3
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
		oPrn:Say( 0250, 2780,LEFT(SA2->A2_NOME,25),oFont3,100 )
		oPrn:Say( 0415, 3000,Substr(aFornCab[3],1,6),oFont3,100 )
	ENDIF
	IF LEN(aFornCab) >= 1
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
		oPrn:Say( 0330, 1700,LEFT(SA2->A2_TEL,25),oFont5,100 )
	ENDIF
	IF LEN(aFornCab) >= 2
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
		oPrn:Say( 0330, 2330,LEFT(SA2->A2_TEL,25),oFont5,100 )
	ENDIF
	IF LEN(aFornCab) >= 3
		SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
		oPrn:Say( 0330, 3000,LEFT(SA2->A2_TEL,25),oFont5,100 )
	ENDIF
	/*
IF LEN(aFornCab) >= 1
SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
oPrn:Say( 0420, 1600,LEFT(SA2->A2_CONTATO,25),oFont5,100 )
ENDIF
IF LEN(aFornCab) >= 2
SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
oPrn:Say( 0420, 2270,LEFT(SA2->A2_CONTATO,25),oFont5,100 )
ENDIF
IF LEN(aFornCab) >= 3
SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
oPrn:Say( 0420, 2940,LEFT(SA2->A2_CONTATO,25),oFont5,100 )
ENDIF
	*/

	//Bruno: Insercao da informacao Fornecedor Exclusivo, quando somente e feito cotacao com um fornecedor.
	If LEN(aFornCab) == 1
		oPrn:Say( 690, 2500,"_____________",oFont13,100 )
		oPrn:Say( 980, 2500,"_____________",oFont13,100 )
		oPrn:Say( 815, 2570,"Fornecedor",oFont13,100 )
		oPrn:Say( 940, 2610,"Exclusivo",oFont13,100 )
	EndIF

RETURN NIL


//****//////////////////////////////////////////////////////////////////////////////////
//  R O D A P É                                                                     //
//****/////////////////////////////////////////////////////////////////////////////////

STATIC FUNCTION ImprRodape()

	oPrn:Box( 1820, 0000,1900,1450) // 11 coluna solicitante      //1 coluna Total
	oPrn:Box( 1820, 1450,1900,1750) // 11 coluna solicitante      //2 coluna Total
	oPrn:Box( 1820, 1750,1900,2100) // 11 coluna solicitante      //3 coluna Total
	oPrn:Box( 1820, 2100,1900,2400) // 11 coluna solicitante      //4 coluna Total
	oPrn:Box( 1820, 2400,1900,2740) // 11 coluna solicitante      //5 coluna Total
	oPrn:Box( 1820, 2740,1900,3000) // 11 coluna solicitante      //6 coluna Total
	oPrn:Box( 1820, 3000,1900,3300) // 11 coluna solicitante      //7 coluna Total

	//Bruno: Insercao do frete e desconto do ganhador caso exista.

	oPrn:Say( 1840, 0020,"GANHADOR: " + cFornece,oFont5,100 )
	oPrn:Say( 1840, 0315,"Frete: "    + TRANSFORM(nTotFre,"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1840, 0600,"IPI: "    + TRANSFORM(nTotIPI,"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1840, 0850,"Desconto: " + TRANSFORM(nVlDesc,"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1840, 1150,"Total: "    + TRANSFORM(nTot,"@E 999,999.99"),oFont5,100 )

	//Bruno: Insercao do frete e desconto de cada fornecedor analisadoo
	//1 Fornecedor
	oPrn:Say( 1905, 1460,"Frete: "    + TRANSFORM(aFrete[1],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1905, 1800,"Desconto: " + TRANSFORM(aDesconto[1],"@E 999,999.99"),oFont5,100 )

	oPrn:Say( 1955, 1460,"IPI: " + TRANSFORM(aIPI[1],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1955, 1800,"Total: "    + TRANSFORM(aSubtotal[1] + aIPI[1] + aFrete[1] - aDesconto[1] + aDespesa[1],"@E 999,999.99"),oFont5,100 )

	//2 Fornecedor
	oPrn:Say( 1905, 2115,"Frete: "    + TRANSFORM(aFrete[2],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1905, 2450,"Desconto: " + TRANSFORM(aDesconto[2],"@E 999,999.99"),oFont5,100 )

	oPrn:Say( 1955, 2115,"IPI: " + TRANSFORM(aIPI[2],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1955, 2450,"Total: "    + TRANSFORM(aSubtotal[2] + aIPI[2] + aFrete[2] - aDesconto[2] + aDespesa[2],"@E 999,999.99"),oFont5,100 )

	//3 Fornecedor
	oPrn:Say( 1905, 2750,"Frete: "    + TRANSFORM(aFrete[3],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1905, 2980,"Desconto: " + TRANSFORM(aDesconto[3],"@E 999,999.99"),oFont5,100 )

	oPrn:Say( 1955, 2750,"IPI: " + TRANSFORM(aIPI[3],"@E 999,999.99"),oFont5,100 )
	oPrn:Say( 1955, 2980,"Total: "    + TRANSFORM(aSubtotal[3] + aIPI[3] + aFrete[3] - aDesconto[3] + aDespesa[3],"@E 999,999.99"),oFont5,100 )


	oPrn:Say( 1840, 1490,"S U B T O T A L",oFont5,100 )
	oPrn:Say( 1840, 2140,"S U B T O T A L",oFont5,100 )
	oPrn:Say( 1840, 2780,"S U B T O T A L",oFont5,100 )

	oPrn:Say( 1840, 1900,TRANSFORM(aSubTotal[1],"@E 999,999,999.99"),oFont5,100 )
	oPrn:Say( 1840, 2550,TRANSFORM(aSubTotal[2],"@E 999,999,999.99"),oFont5,100 )
	oPrn:Say( 1840, 3100,TRANSFORM(aSubTotal[3],"@E 999,999,999.99"),oFont5,100 )


	oPrn:Box( 1900, 1450,1950,2100) // Frente - Desconto
	oPrn:Box( 1900, 1450,1950,2740) // Frente - Desconto
	oPrn:Box( 1900, 1450,1950,3300) // Frente - Desconto

	oPrn:Box( 1950, 1450,2000,2100) // + IPI = Total
	oPrn:Box( 1950, 1450,2000,2740) // + IPI = Total
	oPrn:Box( 1950, 1450,2000,3300) // + IPI = Total


	oPrn:Box( 1900, 0000,1950,0300) // 11 coluna solicitante      //Solicitante
	oPrn:Box( 1950, 0000,2000,0300) // 11 coluna solicitante        EDMILSON DIAS SANTOS
	oPrn:Box( 2000, 0000,2050,0300) // 11 coluna solicitante      //Finalidade
	oPrn:Box( 2050, 0000,2100,0300) // 11 coluna solicitante        Reforma da Sala
	oPrn:Box( 2100, 0000,2150,0300) // 11 coluna solicitante      //Centro de Custo
	oPrn:Box( 2150, 0000,2200,0300) // 11 coluna solicitante        Setor de Contabilidade
	oPrn:Box( 2200, 0000,2250,0300) // 11 coluna solicitante      //Natureza
	oPrn:Box( 2250, 0000,2300,0300) // 11 coluna solicitante        Despesas com Agua

	dPrazo1	  := Posicione("SC7",1,xFilial("SC7")+cPedidoC,"C7_DATPRF")
	cCodComp  := Posicione("SC7",1,xFilial("SC7")+cPedidoC,"C7_USER")   //Codigo do comprador
	cNomeComp := Posicione("SY1",3,xFilial("SY1")+cCodComp,"Y1_NOME")   //Nome do comprador
	cTel 	  := Posicione("SY1",3,xFilial("SY1")+cCodComp,"Y1_TEL")    //Telefone do comprador

	oPrn:Say( 0025, 0020,"SETOR DE COMPRAS  - ",oFont3,100 )
	oPrn:Say( 0025, 0450,"TEL: " + cTel,oFont3,100 )

	oPrn:Box( 1900, 0300,1950,0770) // 11 coluna solicitante      //Solicitante
	oPrn:Box( 1950, 0300,2000,0770) // 11 coluna solicitante        EDMILSON DIAS SANTOS
	oPrn:Box( 2000, 0300,2050,0770) // 11 coluna solicitante      //Finalidade
	oPrn:Box( 2050, 0300,2100,0770) // 11 coluna solicitante        Reforma da Sala
	oPrn:Box( 2100, 0300,2150,0770) // 11 coluna solicitante      //Centro de Custo
	oPrn:Box( 2150, 0300,2200,0770) // 11 coluna solicitante        Setor de Contabilidade
	oPrn:Box( 2200, 0300,2250,0770) // 11 coluna solicitante        Despesas com Agua
	oPrn:Box( 2250, 0300,2300,0770) // 11 coluna solicitante        Despesas com Agua

	oPrn:Box( 1900, 0770,2100,1450) //    Coluna Observacao

	oPrn:Say( 1910, 0790,"Observação 1 :",oFont5,100 )
	oPrn:Say( 1918, 0997,SUBSTR(UPPER(Alltrim(cMotivo1)),1,33),oFont14,100 )
	oPrn:Say( 1953, 0790,SUBSTR(UPPER(Alltrim(cMotivo1)),34,49),oFont14,100 )
	oPrn:Say( 1993, 0790,SUBSTR(UPPER(Alltrim(cMotivo1)),83,49),oFont14,100 )
	oPrn:Say( 2033, 0790,SUBSTR(UPPER(Alltrim(cMotivo1)),132,49),oFont14,100 )
	oPrn:Say( 2073, 0790,SUBSTR(UPPER(Alltrim(cMotivo1)),181,49),oFont14,100 )
	IF nPrazo1 > 0 .AND. !EMPTY(dPrazo1)
		oPrn:Say( 2110, 0790,"Prazo de Entrega:",oFont5,100 )
		oPrn:Say( 2118, 1040,DTOC(dPrazo1),oFont14,100)
		oPrn:Say( 2152, 0790,"Obs. Diretor :",oFont5,100 )
		oPrn:Say( 2152, 0997,SUBSTR(UPPER(Alltrim(cMotivo2)),1,33),oFont14,100 )
		oPrn:Say( 2192, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),34,49),oFont14,100 )
		oPrn:Say( 2232, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),83,49),oFont14,100 )
		oPrn:Say( 2272, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),132,49),oFont14,100 )
	ELSE
		oPrn:Say( 2110, 0790,"Obs. Diretor :",oFont5,100 )
		oPrn:Say( 2118, 0997,SUBSTR(UPPER(Alltrim(cMotivo2)),1,33),oFont14,100 )
		oPrn:Say( 2152, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),34,49),oFont14,100 )
		oPrn:Say( 2192, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),83,49),oFont14,100 )
		oPrn:Say( 2232, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),132,49),oFont14,100 )
		oPrn:Say( 2272, 0790,SUBSTR(UPPER(Alltrim(cMotivo2)),181,49),oFont14,100 )
	ENDIF


	//Observacao do Pedido Orcado

	oPrn:Say( 0178, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),1,39),oFont14,100 )
	oPrn:Say( 0218, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),43,39),oFont14,100 )
	oPrn:Say( 0258, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),86,39),oFont14,100 )
	oPrn:Say( 0298, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),129,39),oFont14,100 )
	oPrn:Say( 0338, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),172,39),oFont14,100 )
	oPrn:Say( 0378, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),215,39),oFont14,100 )
	oPrn:Say( 0418, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),258,39),oFont14,100 )
	oPrn:Say( 0458, 0920,SUBSTR(UPPER(Alltrim(cMotivo3)),301,39),oFont14,100 )

	//Rafael França - Naturezas adicional
	oPrn:Say( 2210, 0020,Alltrim(SZL->ZL_NATUREZ),oFont14,100 ) //Colocado o codigo da natureza a pedido da sra Elisangela 30/12/14
	oPrn:Say( 2260, 0020,LEFT(Substr(Alltrim(POSICIONE("SED",1,xFilial("SED")+SZL->ZL_NATUREZ,"ED_DESCRIC")),1,25),25),oFont14,100 ) //Colocado o codigo da natureza a pedido da sra Elisangela
	//oPrn:Say( 2210, 0020,LEFT(Substr(Alltrim(POSICIONE("SED",1,xFilial("SED")+SZL->ZL_NATURE1,"ED_DESCRIC")),1,25),25),oFont14,100 )
	//oPrn:Say( 2260, 0020,LEFT(Substr(Alltrim(POSICIONE("SED",1,xFilial("SED")+SZL->ZL_NATURE2,"ED_DESCRIC")),1,25),25),oFont14,100 )

	If Found()

		oPrn:Say( 1910, 0305,"Centro de Custo:",oFont5,100)
		oPrn:Say( 1960, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+aCusto,"CTT_DESC01"),35),oFont14,100)

		IF EMPTY(SZL->ZL_CCMAN01)  // Rafael - Condiçcao colocada para verificar a utilizaçao de centro de cutos manuais na tabela SZL. 07/02/11

			oPrn:Say( 2010, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC01,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2060, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC02,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2110, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC03,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2160, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC04,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2210, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC05,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2260, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC06,"CTT_DESC01"),35),oFont14,100)

		ELSEIF !EMPTY(SZL->ZL_CCMAN01) .AND. EMPTY(SZL->ZL_CCMAN02)

			oPrn:Say( 2010, 0305,SZL->ZL_CCMAN01,oFont14,100)
			oPrn:Say( 2060, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC01,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2110, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC02,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2160, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC03,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2210, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC04,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2260, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC05,"CTT_DESC01"),35),oFont14,100)

		ELSEIF !EMPTY(SZL->ZL_CCMAN01) .AND. !EMPTY(SZL->ZL_CCMAN02)

			oPrn:Say( 2010, 0305,SZL->ZL_CCMAN01,oFont14,100)
			oPrn:Say( 2060, 0305,SZL->ZL_CCMAN02,oFont14,100)
			oPrn:Say( 2110, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC01,"CTT_DESC01"),35),oFont14,100)
			oPrn:Say( 2160, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC02,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2210, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC03,"CTT_DESC01"),35),oFont14,100)
			//oPrn:Say( 2260, 0305,LEFT(POSICIONE("CTT",1,xFilial("CTT")+SZL->ZL_CC04,"CTT_DESC01"),35),oFont14,100)

		ENDIF

	ELSE

		oPrn:Say( 1910,0305,"Centro de Custo:",oFont5,100)
		cNomeCC := LEFT(POSICIONE("CTT",1,xFilial("CTT")+aCusto,"CTT_DESC01"),25)
		oPrn:Say( 1960,0305,SUBSTR(UPPER(cNomeCC),1,35),oFont14,100 )   //Centro de Custo

	EndIF

	oPrn:Say( 1910, 0020,"SOLIC:",oFont5,100 )
	oPrn:Say( 1910, 0120,SUBSTR(UPPER(aSolicita),1,10),oFont5,100 )
	oPrn:Say( 1960, 0020,"FINALIDADE:",oFont5,100 )
	oPrn:Say( 2010, 0020,LEFT(POSICIONE("SZ6",1,xFilial("SZ6")+aFinalida,"Z6_DESC"),25),oFont14,100 )
	oPrn:Say( 2060, 0020,"NATUREZA:",oFont5,100 )
	oPrn:Say( 2110, 0020,Alltrim(aNatureza),oFont14,100 )
	oPrn:Say( 2160, 0020,LEFT(Substr(Alltrim(POSICIONE("SED",1,xFilial("SED")+aNatureza,"ED_DESCRIC")),1,25),25),oFont14,100 )
	oPrn:Say( 2210, 0305,"PEDIDO:",oFont5,100 )  // Rafael França - Alterado para a segunda coluna do relatorio OS: 000298
	oPrn:Say( 2260, 0305,cPedidoC ,oFont3,100 )

	oPrn:Box( 1900, 0300,2300,1450) // 12 coluna responsavel pelo Setor
	oPrn:Box( 1900, 1450,2300,3300) // 13 coluna Aprovadores

	cQuery := ("Select * from SCR010 Where CR_FILIAL = '01' AND CR_NUM = '" + (cPedidoC) + "' AND CR_TIPO = 'PC' AND D_E_L_E_T_ <> '*' ORDER BY CR_NIVEL")
	tcQuery cQuery New Alias "TMP"

	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")

	else

		nAss := 0

		DBSelectArea("TMP")

		While !EOF()


			If TMP->CR_NIVEL == "01"

				IF TMP->CR_LIBAPROV <> TMP->CR_APROV
					cLib01 := ALLTRIM(TMP->CR_LIBAPRO)
				ELSE
					cLib01 := ALLTRIM(TMP->CR_APROV)
				ENDIF

				If PswSeek( TMP->CR_USER, .T. )
				aUsuario := PswRet() // Retorna vetor com informações do usuário
				cAprov01 	:= Alltrim(aUsuario[1][4])
				cFuncao01 	:= Alltrim(aUsuario[1][13])
				cCodUser1 	:= TMP->CR_APROV
				lass01 		:= .T.
				EndIf

			EndIF

			IF TMP->CR_NIVEL == "02"
				IF TMP->CR_LIBAPROV <> TMP->CR_APROV
					cLib02 := ALLTRIM(TMP->CR_LIBAPRO)
				ELSE
					cLib02 := ALLTRIM(TMP->CR_APROV)
				ENDIF

				If PswSeek( TMP->CR_USER, .T. )
				aUsuario := PswRet()
				cAprov02 := Alltrim(aUsuario[1][4])
				cFuncao02 := Alltrim(aUsuario[1][13])
				cCodUser2 := TMP->CR_APROV
				lass02 := .T.
				EndIf

			EndIF

			If TMP->CR_NIVEL == "03"

				IF TMP->CR_LIBAPROV <> TMP->CR_APROV
					cLib03 := ALLTRIM(TMP->CR_LIBAPRO)
				ELSE
					cLib03 := ALLTRIM(TMP->CR_APROV)
				ENDIF

				If PswSeek( TMP->CR_USER, .T. )
				aUsuario := PswRet()
				cAprov03 := Alltrim(aUsuario[1][4])
				cFuncao03 := Alltrim(aUsuario[1][13])
				cCodUser3 := TMP->CR_APROV
				lass03 := .T.
				EndIf

			EndIF

			If  TMP->CR_NIVEL == "01"  .AND. !EMPTY(TMP->CR_DATALIB) .AND. !EMPTY(TMP->CR_USERLIB)
				lAprov01 := .T.
				dLib01   := DTOC(STOD(TMP->CR_DATALIB))

			ElseIf TMP->CR_NIVEL == "02"  .AND. !EMPTY(TMP->CR_DATALIB) .AND. !EMPTY(TMP->CR_USERLIB)
				lAprov02 := .T.
				dLib02   := DTOC(STOD(TMP->CR_DATALIB))

			ElseIf TMP->CR_NIVEL == "03"  .AND. !EMPTY(TMP->CR_DATALIB) .AND. !EMPTY(TMP->CR_USERLIB)
				lAprov03 := .T.
				dLib03   := DTOC(STOD(TMP->CR_DATALIB))

			EndIf

			nAss += 1
			nValor := TMP->CR_TOTAL

			DbSkip()

		Enddo

/*
		IF dDatabase >= CTOD("02/01/2018") .AND. dDatabase <= CTOD("14/01/2018") .AND. nValor >= 1000 .AND. .F. .AND. !(lAprov03)
			lAprov03 := .T.
			dLib03   := dDatabase
			cAprov03 := "Luciano Ribeiro"
			cFuncao03 := "Diretor Geral"
			cCodUser3 := "000192"
			lass03 := .T.
			nAss += 1
		ENDIF

		IF dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018") .AND. .F. .AND. !(lAprov02)
			lAprov02 := .T.
			dLib02   := dDatabase
			cAprov02 := "Artur Fernandes"
			cFuncao02 := "     Gerente Executivo"
			cCodUser2 := "000219"
			lass02 := .T.
			nAss += 1

		ENDIF

		If dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018") .AND. .T. .AND. !(lAprov01)       // Elenn Caldeira
			lAprov01 := .T.
			dLib01   := dDatabase
			cAprov01 := "Eleni Caldeira (Elenn)"
			cFuncao01 := "Gerente Administrativo / Financeiro"
			cCodUser1 := "000002"
			lass01 := .T.
			nAss += 1
		EndIF

		*/

		//Bruno - Ajuste utilizacao
		DbSelectArea("TMP")
		DbCloseARea("TMP")

	Endif

	IF  nAss == 3 //Rafael França - 10/07/14 Conta as assinaturas para vericar a necessidade de impressao

		oPrn:Say( 2150, 1490,REPLICATE("_",32),oFont3,100 )
		oPrn:Say( 2200, 1610,UPPER(cAprov01),oFont5,100 )
		oPrn:Say( 2240, 1560,cFuncao01,oFont5,100 )

		oPrn:Say( 2150, 2100,REPLICATE("_",32),oFont3,100 )
		oPrn:Say( 2200, 2170,UPPER(cAprov02),oFont5,100 )
		oPrn:Say( 2240, 2135,cFuncao02,oFont5,100 )

		oPrn:Say( 2150, 2700,REPLICATE("_",32),oFont3,100 )
		oPrn:Say( 2200, 2870,UPPER(cAprov03),oFont5,100 )
		oPrn:Say( 2240, 2885,cFuncao03,oFont5,100 )

		//Rafael Franca - Assinatura digital

		IF lAprov01 == .T. .OR. dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")
			if dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")
				oPrn:Say( 2070, 1445,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 1445,PadC("22/01/2018 - 10/02/2018",60),oFont5,100 )
			else
				oPrn:Say( 2070, 1445,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 1445,PadC(Alltrim(cAprov01) + " - Data: " + (dLib01) + "",60),oFont5,100 )
			endif
		EndIf


		IF lAprov02 == .T. .OR. (dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018"))
			if  dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018")
				oPrn:Say( 2070, 2080,PadC("Liberação Automática - Recesso",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC("15/01/2018 - 19/01/2018",60),oFont5,100 )
			ELSE
				oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
			ENDIF
		ENDIF


		IF lAprov03 == .T. .OR. (dDatabase >= CTOD("02/01/2018") .AND. dDatabase <= CTOD("14/01/2018") .AND. nValor >= 1000)
			IF dDatabase >= CTOD("02/01/2018") .AND. dDatabase <= CTOD("14/01/2018")
				oPrn:Say( 2070, 2690,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 2690,PadC("02/01/2018 - 14/01/2018",60),oFont5,100 )
			ELSE
				oPrn:Say( 2070, 2690,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2690,PadC(Alltrim(cAprov03) + " - Data: " + (dLib03) + "",60),oFont5,100 )
			ENDIF
		EndIf


	ELSEIF nAss == 2

		//Rafael Franca - Assinatura digital

		IF lass01 == .T.
			oPrn:Say( 2150, 1760,REPLICATE("_",32),oFont3,100 )
			oPrn:Say( 2200, 1760,PADC(UPPER(Alltrim(cAprov01)),60),oFont5,100 )
			oPrn:Say( 2240, 1770,PADC(Alltrim(cFuncao01),60),oFont5,100 )
		ENDIF

		IF lass02 == .T.
			IF lass01 == .T.
				oPrn:Say( 2150, 2440,REPLICATE("_",32),oFont3,100 )
				oPrn:Say( 2200, 2520,UPPER(cAprov02),oFont5,100 )
				oPrn:Say( 2240, 2475,cFuncao02,oFont5,100 )
			ELSE
				oPrn:Say( 2150, 1760,REPLICATE("_",32),oFont3,100 )
				oPrn:Say( 2200, 1880,UPPER(cAprov02),oFont5,100 )
				oPrn:Say( 2240, 1830,cFuncao02,oFont5,100 )
			ENDIF
		ENDIF

		IF lass03 == .T.
			oPrn:Say( 2150, 2440,REPLICATE("_",32),oFont3,100 )
			oPrn:Say( 2200, 2440,PADC(UPPER(Alltrim(cAprov03)),60),oFont5,100 )
			oPrn:Say( 2240, 2450,PADC(Alltrim(cFuncao03),60),oFont5,100 )
		ENDIF

		IF lAprov01 == .T. .OR. dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")

			if dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")
				oPrn:Say( 2070, 1715,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 1715,PadC("22/01/2018 - 10/02/2018",60),oFont5,100 )
			else
				oPrn:Say( 2070, 1715,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 1715,PadC(Alltrim(cAprov01) + " - Data: " + (dLib01) + "",60),oFont5,100 )
			EndIf
		EndIf

		IF lAprov02 == .T.
			IF lAprov01 == .T. .AND. lass01 == .T.

				IF dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018")
					oPrn:Say( 2070, 2410,PadC("Liberação Automática - Recesso",60),oFont5,100 )
					oPrn:Say( 2120, 2420,PadC("15/01/2018 - 19/01/2018",60),oFont5,100 )
				ELSE
					oPrn:Say( 2070, 2410,PadC("Liberação Eletrônica",60),oFont5,100 )
					oPrn:Say( 2120, 2380,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
				ENDIF

			ELSEIF lAprov01 == .T. .AND. lass01 == .F.

				if dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018")
					oPrn:Say( 2070, 1715,PadC("Liberação Automática - Recesso",60),oFont5,100 )
					oPrn:Say( 2120, 1715,PadC("15/01/2018 - 19/01/2018",60),oFont5,100 )
				else
					oPrn:Say( 2070, 1715,PadC("Liberação Eletrônica",60),oFont5,100 )
					oPrn:Say( 2120, 1715,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
				EndIf

			ELSEIF lAprov01 == .F. .AND. lass01 == .F.
				oPrn:Say( 2070, 1715,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 1715,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
			ENDIF
		ENDIF

		IF lAprov03 == .T.

			IF  (dDatabase >= CTOD("02/01/2018") .AND. dDatabase <= CTOD("14/01/2018") .AND. nValor >= 1000)
				oPrn:Say( 2070, 2410,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 2380,PadC("02/01/2018 - 14/01/2018",60),oFont5,100 )
			ELSE
				oPrn:Say( 2070, 2410,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2380,PadC(Alltrim(cAprov03) + " - Data: " + (dLib03) + "",60),oFont5,100 )
			ENDIF
		ENDIF

	ELSEIF nAss == 1

		//Rafael Franca - Assinatura digital

		IF lass01 == .T.
			oPrn:Say( 2150, 2100,REPLICATE("_",32),oFont3,100 )
			oPrn:Say( 2200, 2100,PADC(UPPER(Alltrim(cAprov01)),60),oFont5,100 )
			oPrn:Say( 2240, 2110,PADC(Alltrim(cFuncao01),60),oFont5,100 )
		ENDIF

		IF lass02 == .T.
			IF lass01 == .T.
				oPrn:Say( 2150, 2100,REPLICATE("_",32),oFont3,100 )
				oPrn:Say( 2200, 2170,UPPER(cAprov02),oFont5,100 )
				oPrn:Say( 2240, 2135,cFuncao02,oFont5,100 )
			ELSE
				oPrn:Say( 2150, 2100,REPLICATE("_",32),oFont3,100 )
				oPrn:Say( 2200, 2170,UPPER(cAprov02),oFont5,100 )
				oPrn:Say( 2240, 2135,cFuncao02,oFont5,100 )
			ENDIF
		ENDIF

		IF lass03 == .T.
			oPrn:Say( 2150, 2100,REPLICATE("_",32),oFont3,100 )
			oPrn:Say( 2200, 2170,UPPER(cAprov03),oFont5,100 )
			oPrn:Say( 2240, 2135,cFuncao03,oFont5,100 )
		ENDIF

		IF lAprov01 == .T. .OR. dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")

			if dDatabase >= CTOD("22/01/2018") .AND. dDatabase <= CTOD("10/02/2018")
				oPrn:Say( 2070, 2080,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC("22/01/2018 - 10/02/2018",60),oFont5,100 )
			else
				oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov01) + " - Data: " + (dLib01) + "",60),oFont5,100 )
			EndIf
		EndIf

		IF lAprov02 == .T.
			IF lAprov01 == .T. .AND. lass01 == .T.

				IF dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018")
					oPrn:Say( 2070, 2080,PadC("Liberação Automática - Recesso",60),oFont5,100 )
					oPrn:Say( 2120, 2050,PadC("15/01/2018 - 19/01/2018",60),oFont5,100 )
				ELSE
					oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
					oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
				ENDIF

			ELSEIF lAprov01 == .T. .AND. lass01 == .F.

				if dDatabase >= CTOD("15/01/2018") .AND. dDatabase <= CTOD("19/01/2018")
					oPrn:Say( 2070, 2080,PadC("Liberação Automática - Recesso",60),oFont5,100 )
					oPrn:Say( 2120, 2050,PadC("15/01/2018 - 19/01/2018",60),oFont5,100 )
				else
					oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
					oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
				EndIf

			ELSEIF lAprov01 == .F. .AND. lass01 == .F.
				oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov02) + " - Data: " + (dLib02) + "",60),oFont5,100 )
			ENDIF
		ENDIF

		IF lAprov03 == .T.

			IF  (dDatabase >= CTOD("02/01/2018") .AND. dDatabase <= CTOD("14/01/2018") .AND. nValor >= 1000)
				oPrn:Say( 2070, 2080,PadC("Liberação Automática - Férias",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC("02/01/2018 - 14/01/2018",60),oFont5,100 )
			ELSE
				oPrn:Say( 2070, 2080,PadC("Liberação Eletrônica",60),oFont5,100 )
				oPrn:Say( 2120, 2050,PadC(Alltrim(cAprov03) + " - Data: " + (dLib03) + "",60),oFont5,100 )
			ENDIF
		ENDIF

	ENDIF

	oPrn:Say( 0030, 0920,"COMPRADOR(A): " + UPPER(cNomeComp) + "",oFont3,100 )
	//oPrn:Say( 2150, 2720,REPLICATE("_",32),oFont3,100 )
	//Zera os valores para o proximo mapa

	nTotFre  := 0
	nTotIPI  := 0
	nVlDesc  := 0
	nTotVal  := 0
	nTot     := 0
	nValDesp := 0

	/*
oPrn:Say( 2200, 2765,"COMPRAS - " + UPPER(cNomeComp) + "",oFont3,100 )
oPrn:Say( 2240, 2840,"               ",oFont3,100 )
oPrn:SayBitmap( 2025, 2775, cBMP001, 0350, 0150 )
	*/

RETURN NIL

Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Do Pedido:		","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"02","Até o Pedido:	","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7"})
	AADD(aRegs,{cPerg,"03","Atual. Estoque:	","","","mv_ch3","N",01,0,2,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Imobilizado:	","","","mv_ch4","N",01,0,2,"C","","mv_par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})

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
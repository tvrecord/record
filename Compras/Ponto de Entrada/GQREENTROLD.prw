/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GQREENTR   ¦ Autor ¦ Leandro Camara       ¦ Data ¦ 16/11/2006 ¦¦¦
¦¦¦                                  Edmilson Dias Santos   Altera: 24/04/2007
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de gravacao da nota fiscal de entrada        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
                Permite a delecao dos registros inclidos pelo sistema da forma
                original e adiciona 1 unico registro contendo o valor total  da
                N.Fiscal de Entrada para itens com a TES 153 (Imobilizado) para
                Adintamento, para no futuro este transforma-se em um bem defini-
                tivo.
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#Include "Rwmake.ch"

User Function GQREENTR()
Local aSvAlias
Local aDatDig,aCCusto,aItem,aClVl,aTes
PRIVATE aCbase
//PRIVATE CcBase := "NFE"+SF1->F1_DOC
	U_GravHist()
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GravHist   ¦ Autor ¦ Leandro Camara       ¦ Data ¦ 16/11/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Gravar Historico de Compras no SE2                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GravHist()

Private cHist := Space(100)


@ 200,1 TO 380,380 DIALOG oGrav TITLE OemToAnsi("Gravacao do Histórico")
@ 02,10 TO 080,190
@ 10,018 Say "Digite o Histórico a ser registrado no Contas a Pagar. "
@ 20,018 Get cHist  Valid !Empty(cHist)  Picture "@!"  SIZE 100,75
@ 70,128 BMPBUTTON TYPE 01 ACTION OkGrav()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGrav)

Activate Dialog oGrav Centered

Return


/*Manipulacao da Tabela */

Static Function OkGrav

Local nCntFor := 0
Local aQuant  := 0
Local aVlrIcm := 0
Local aVlOrig := 0
Local nUsado  := 0
Local aSavaHead:= aClone(aHeader)
Local aSavaCols:= aClone(aCols)
Local nMoeda   := IIf(cPaisLoc == "BRA",1,SF1->F1_MOEDA)
// Grava a Posicao atual
aSvAlias := {Alias(),IndexOrd(),Recno()}

dbSelectArea("SE2")
dbSetOrder(6)
If dbSeek(XFILIAL("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC))
	While !EOF() .and. SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXOE+E2_NUM) = SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
		RecLock("SE2",.F.)
		SE2->E2_HIST   := Alltrim(cHist)
		MsUnLock()
		dbSkip()
	enddo
Endif

***************************************************************************
//aSvAlias := {Alias(),IndexOrd(),Recno()}
/*
aNotafIs := SF1->F1_DOC
aSereFis := SF1->F1_SERIE
aFornFis := SF1->F1_FORNECE
aLojaFis := SF1->F1_LOJA
aFiliFis := SF1->F1_FILIAL

ccBase := {}

DBSELECTAREA("SD1")
DBSETORDER(1)
DBSEEK(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.)

WHILE !EOF() .AND. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ==;
	SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	
	aTes := SD1->D1_TES 
	
	IF SD1->D1_TES == "153" //Adiantamento em Andamento
		
		IF ASCAN(ccBase, SD1->D1_CBASEAF) == 0
			AADD(ccBase, SD1->D1_CBASEAF)
		ENDIF
		                      1616
		aQuant += SD1->D1_QUANT
		aVlrIcm+= SD1->D1_VALICM
		aVlOrig+= SD1->D1_TOTAL
		
		aDatDig:= SD1->D1_DTDIGIT
		aCCusto:= SD1->D1_CC
		aItem  := SD1->D1_ITEMCTA
		aClVl  := SD1->D1_CLVL
		aTes   := SD1->D1_TES
	
		SD1->(DBSKIP())
	
	ELSE
		EXIT
	ENDIF
	
ENDDO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento das Variaveis referentes ao SN1 e SN3                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF aTes == "153"
	
	sDeleta()   //APAGA PRIMEIRO OS REGISTROS SN1 E SN3
	
	DBSELECTAREA("SN1")
	RECLOCK("SN1",.T.)
	N1_FILIAL    := SF1->F1_FILIAL
	N1_CBASE		:= "NFE"+SF1->F1_DOC
	N1_ITEM		:= "0001" //cItem
	N1_AQUISIC	:= aDatDig
	N1_DESCRIC	:= "IMOB. EM ANDAMENTO S/NF "+SF1->F1_DOC+" - "+SF1->F1_SERIE
	N1_QUANTD	:= 1 //aQuant
	N1_FORNEC	:= SF1->F1_FORNECE
	N1_LOJA		:= SF1->F1_LOJA
	N1_NSERIE	:= SF1->F1_SERIE
	N1_INCLUSA  := "1"
	N1_NFISCAL	:= SF1->F1_DOC
	N1_CHASSIS	:= " "//SF1->F1_CHASSI
	N1_PLACA		:= " "//SD1->D1_PLACA
	N1_PATRIM	:= "N"
	N1_CODCIAP	:= " " //cCodCiap
	N1_ICMSAPR	:= aVlrIcm
   
   DBSELECTAREA("SN3")
	RECLOCK("SN3",.T.)
   N3_FILIAL  := SF1->F1_FILIAL
   N3_CBASE   := "NFE"+SF1->F1_DOC
   N3_ITEM    := "0001"
   N3_TIPO    := "01"
   N3_BAIXA   := "0"
   N3_CCONTAB := ""
   N3_CCUSTO  := ""
   N3_SUBCCON := "" 
   N3_CLVLCON := ""   
	N3_AQUISIC := SN1->N1_AQUISIC  // Data de aquisicao
   N3_VORIG1  := xMoeda( aVlOrig,nMoeda,1,SF1->F1_EMISSAO)
   N3_VORIG2  := xMoeda( aVlOrig,nMoeda,2,SF1->F1_EMISSAO)
   N3_VORIG3  := xMoeda( aVlOrig,nMoeda,3,SF1->F1_EMISSAO)
   N3_VORIG4  := xMoeda( aVlOrig,nMoeda,4,SF1->F1_EMISSAO)
   N3_VORIG5  := xMoeda( aVlOrig,nMoeda,5,SF1->F1_EMISSAO)

	SN1->(MsUnLock())
	SN3->(MsUnLock())
	
ENDIF

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

RETURN NIL

//**********
STATIC FUNCTION sDeleta()
Local cQuery
Local cQuery1
Local Ky, Kx

For kX := 1 to Len(ccBase)
	
	DBSELECTAREA("SN1")
	DBSETORDER(1)
	SN1->(DBSEEK(xFilial("SN1")+ccBase[kx],.T.))
	RecLock("SN1",.f.,.t.)
	SN1->(dbdelete())
	MsUnlock("SN1")
	
Next Kx

For ky := 1 to Len(ccBase)
	
	DBSELECTAREA("SN3")
	DBSETORDER(1)
	SN3->(DBSEEK(xFilial("SN3")+ccBase[ky],.T.))
	RecLock("SN3",.f.,.t.)
	SN3->(dbdelete())
	MsUnlock("SN3")
Next ky
*/
Close(oGrav)

Return

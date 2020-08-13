#include "protheus.ch"
#include "topconn.ch"

#define 	COL_SEPARA1			01
#define 	COL_CONTA  			02
#define 	COL_SEPARA2			03
#define 	COL_DESCRICAO		04
#define 	COL_SEPARA3			05
#define 	COL_SALDO_ANT    	06
#define 	COL_SEPARA4			07
#define 	COL_VLR_DEBITO   	08
#define 	COL_SEPARA5			09
#define 	COL_VLR_CREDITO  	10
#define 	COL_SEPARA6			11
#define 	COL_MOVIMENTO 		12
#define 	COL_SEPARA7			13
#define 	COL_SALDO_ATU 		14
#define 	COL_SEPARA8			15
#define 	TAM_VALOR			16

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³RCTBR180  ³ Autor ³ Cicero J. Silva   	³ Data ³ 04.08.06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function XCTBR180()

Local nDivide			:= 01
Local aCtbMoeda		:= {}
Local lOk 				:= .t.
Local aArea 			:=	GetArea()

Private Titulo
Private cTipoAnt		:= ""
Private cPerg	 		:= "XCTR180    "
Private NomeProg  	:= "XCTBR180"

RCTBR180R3()

RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³RCTBR180R3³ Autor ³ Gustavo Henrique  	³ Data ³ 24.08.01   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RCTBR180R3()

Local aSetOfBook
Local aCtbMoeda		:= {}

Local nDivide			:=	01
Local lRet				:= .t.
Local cString			:=	"CT1"
Local wnrel       	:=	"RCTBR180"
Local cSayCC			:= CtbSayApro("CTT")
Local cDesc1 			:= "Este programa ira imprimir o Balancete de " + Upper(cSayCC) + " / CONTA "
Local cDesc2 			:=	"de acordo com os parametros solicitados pelo Usuario.  "
Local Titulo 			:= "Balancete de Verificacao " + Upper(cSayCC) + " / CONTA "

Private nLastKey 		:= 0
Private aLinha			:= {}
Private Tamanho		:=	"M"
Private cPerg	 		:= "CTR180    "
Private nomeProg  	:= "CTBR180"
Private aReturn 		:= { "Zebrado",01,"Administracao",02,02,01,"",01 }

PRIVATE li 	:= 80
m_pag		:= 01

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	   	³
//³ mv_par01				// Data Inicial              	       	³
//³ mv_par02				// Data Final                          ³
//³ mv_par03				// Conta Inicial                       ³
//³ mv_par04				// Conta Final  					   	   ³
//³ mv_par05				// Do Centro de Custo                  ³
//³ mv_par06				// Ate Centro de Custo                 ³
//³ mv_par07				// Imprime Contas: Sintet/Analit/Ambas ³
//³ mv_par08				// Set Of Books				    	   	³
//³ mv_par09				// Saldos Zerados?			     	  	   ³
//³ mv_par10				// Moeda?          			     	   	³
//³ mv_par11				// Pagina Inicial  		     		   	³
//³ mv_par12				// Saldos? Reais / Orcados	/Gerenciais	³
//³ mv_par13				// Quebra por Grupo Contabil?		   	³
//³ mv_par14				// Imprimir ate o Segmento?			   ³
//³ mv_par15				// Filtra Segmento?					   	³
//³ mv_par16				// Conteudo Inicial Segmento?		   	³
//³ mv_par17				// Conteudo Final Segmento?		      ³
//³ mv_par18				// Conteudo Contido em?				   	³
//³ mv_par19				// Imprime Coluna Mov ?				   	³
//³ mv_par20				// Imprime Totalizacao de Itens Sintet.³
//³ mv_par21				// Pula Pagina                         ³
//³ mv_par22				// Salta linha sintetica ?			      ³
//³ mv_par23				// Imprime valor 0.00    ?			      ³
//³ mv_par24				// Imprimir CC?Normal / Reduzido       ³
//³ mv_par25				// Divide por ?                   		³
//³ mv_par26				// Imprime Cod. Conta ? Normal/Reduzido³
//³ mv_par27				// Posicao Ant. L/P? Sim / Nao         ³
//³ mv_par28 				// Data Lucros/Perdas?                	³
//³ mv_par29				// C.Custo ate o Segmento?			   	³
//³ mv_par30				// Filtra Segmento?					   	³
//³ mv_par31				// Conteudo Inicial Segmento?		   	³
//³ mv_par32				// Conteudo Final Segmento?		      ³
//³ mv_par33				// Conteudo Contido em?				   	³
//³ mv_par34				// Imprime C.C: Sintet/Analit/Ambas 	³
//³ mv_par35				// Rec./Desp. Anterior Zeradas?			³
//³ mv_par36				// Grupo Receitas/Despesas?      		³
//³ mv_par37				// Data de Zeramento Receita/Despesas?	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.f.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

lRet 		:=	ct040Valid(mv_par08)
nDivide 	:=	iif( mv_par25 == 2 , 100 , iif( mv_par25 == 3 , 1000 , iif( mv_par25 == 4 , 1000000 , nDivide )))

If lRet
	aSetOfBook 	:=	CtbSetOf(mv_par08)
	aCtbMoeda 	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .f.
	Endif
Endif

If lRet
	If mv_par35 == 1 .and. ( Empty(mv_par36) .or. Empty(mv_par37) )
		cMensagem	:= "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
		cMensagem	+= "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
		lRet := .f.
	EndIf
EndIf
IF lRet          //inserido por edmilson
	if mv_par20 == 1 .and. mv_par34 == 2
		cMensagem	:= "Favor atentar entre os paramentros 20 e 34, quando solicitar a impressao totalizando sinteticamente "
		cMensagem	+= "o parametro 34 deve ser colocado opcao SINTETICA OU AMBOS "
		MsgAlert(cMensagem,"Sintetico ou Ambos")
		lRet := .f.
	endif
endif
If lRet
	Tamanho := iif( mv_par19 == 1 , "G" , Tamanho )
	
	RptStatus( { |lEnd| CTR180Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide) } )
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR180IMP ³ Autor ³ Simone Mie / Gustavo  ³ Data ³ 25.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Conta/Centro de Custo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CTR180Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)

Local CbTxt				:= Space(10)
Local CbCont			:= 0
Local tamanho			:=	"M"
Local cabec1  			:= ""
Local cabec2			:= ""
Local aTotCCSup		:= { 0 , 0 , 0 , 0 , 0 }	//{Saldo Ant,Debito,Credito,Movimento,Saldo Atual}

Local cSepara1  		:= ""
Local cSepara2      	:=	""
Local cPicture
Local cDescMoeda
Local cMascara1
Local cMascara2
Local cGrupo			:= ""
Local cGrupoAnt		:= ""
Local cCCAnt 			:= ""
Local cCCRes			:= ""
Local cSegAte   		:= mv_par14
Local cArqTmp			:= ""
Local cCCSup			:= ""		//Centro de Custo Superior do centro de custo atual
Local cAntCCSup		:= ""		//Centro de Custo Superior do centro de custo anterior

Local dDataLP			:= mv_par28
Local dDataFim			:= mv_par02

Local lImpAntLP		:= iif(mv_par27 == 1,.t.,.f.)
Local lImpTotS			:= iif(mv_par20 == 1,.t.,.f.)
Local lFirstPage		:= .t.
Local lPula				:= .f.
Local lJaPulou			:= .f.
Local lPrintZero		:= iif(mv_par23 == 1,.t.,.f.)
Local lPulaSint		:= iif(mv_par22 == 1,.t.,.f.)
Local l132				:= .t.
Local lImpCCSint		:= .t.
Local lVlrZerado		:= iif(mv_par09 == 1,.t.,.f.)
Local lImpDscCC		:= .f.
Local limite			:= 132

Local nDecimais
Local nTotDeb			:= 0
Local nTotCrd			:= 0
Local nTotMov			:= 0
Local nCCTMov 			:= 0
Local nTamCC			:= 20
Local nTotCCDeb		:= 0
Local nTotCCCrd		:= 0
Local nCCSldAnt		:= 0
Local nCCSldAtu		:= 0
Local nTotSldAnt		:= 0
Local nTotSldAtu		:= 0
Local nDigitAte		:= 0
Local nDigCCAte		:= 0
Local nRegTmp			:= 0
Local n
Local nGrpDeb			:= 0
Local nGrpCrd			:= 0
Local lRecDesp0		:= iif(mv_par35 == 1,.t.,.f.)
Local cRecDesp			:= mv_par36
Local dDtZeraRD		:= mv_par37
Local cMask1
Local cMask2
Local nNivelCT1
Local nNivelCTT
Local nPos
Local lCont				:=	.t.
Local aTotPer			:=	{0,0,0,0,0}
Local nPriNivCTT		:=	0

Local aColunas
Local aSaldos			:=	{}
Local cCustVer			:= ""

mv_par13 := 2

cDescMoeda 	:= aCtbMoeda[2]
cPicture 	:=	aSetOfBook[4]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)
cMascara1 	:=	iif( Empty(aSetOfBook[2]) , GetMv("MV_MASCARA") , RetMasCtb(aSetOfBook[2],@cSepara1) )
cMascara2 	:=	iif( Empty(aSetOfBook[6]) , GetMv("MV_MASCCUS") , RetMasCtb(aSetOfBook[6],@cSepara2) )
nNivelCT1	:=	iif( Len(cMascara1) > 1 , RetQtdNivel( "CT1" , Len(cMascara1) , cMascara1 ) , 1 )
nNivelCTT	:=	iif( Len(cMascara2) > 1 , RetQtdNivel( "CTT" , Len(cMascara2) , cMascara2 ) , 2 )
nPriNivCTT	:=	Val( Substr( cMascara2 , 01 , 01 ) )

//Alert(nNivelCT1)
//Alert(nNivelCTT)

If mv_par19 == 1
	Cabec1 	:= "|  CODIGO                     |      D E S C R I C A O                          |    SALDO ANTERIOR              |    DEBITO       |      CREDITO      |    MOVIMENTO DO PERIODO       |         SALDO ATUAL               |"
	Tamanho 	:= "G"
	Limite	:= 220
	l132		:= .f.
Else
	Cabec1 	:=	"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif

SetDefault(aReturn,cString,,,Tamanho,iif(Tamanho == "G",02,01))

IF mv_par07 == 1
	Titulo	:=	"BALANCETE SINTETICO DE " 	+ Alltrim(Upper(cSayCC)) 	+  "/ CONTA "
ElseIf mv_par07 == 2
	Titulo	:=	"BALANCETE ANALITICO DE " 	+ Alltrim(Upper(cSayCC))	+  "/ CONTA "
ElseIf mv_par07 == 3
	Titulo	:=	"BALANCETE DE " 				+ Alltrim(Upper(cSayCC))	+  "/ CONTA "
EndIf

Titulo += " DE " + DtoC(mv_par01) + " ATE " + DtoC(mv_par02) + " EM " + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .f.) + ")"
EndIf

If nDivide > 1
	Titulo += " (" + "DIV." + Alltrim(Str(nDivide)) + ")"
EndIf

If l132
	aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
Else
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

m_pag := mv_par11

MsgMeter( { | oMeter, oText, oDlg, lEnd | U_XCTGerPlan(	    oMeter   		, oText		, oDlg		    , @lEnd			,;
@cArqTmp		, mv_par01	, mv_par02		, "CT3"			,;
""				, mv_par03	, mv_par04		, mv_par05		,;
mv_par06		,				,					,		,;
, mv_par10	, mv_par12		, aSetOfBook	,;
mv_par15		, mv_par16	, mv_par17		, mv_par18		,;
l132			, .t.			,			,"CTT"			,;
lImpAntLP	    , dDataLP	, nDivide		, lVlrZerado	,;
,			, mv_par30		, mv_par31		,;
mv_par32	    , mv_par33	,				,				,;
,			,				,				,;
,			, aReturn[7]	, lRecDesp0		,;
cRecDesp		, dDtZeraRD	) } , ;
"Criando Arquivo Temporario..." ,;
"Balancete de Verificacao "  + Upper(cSayCC) + " /  CONTA " )

If !Empty(mv_par14)
	cMask1 := Alltrim( cMascara1 )
	For n := 1 to Val( mv_par14 )
		nDigitAte 	+=	Val( Padl( cMask1 , 2 ) )
		cMask1 		:=	Subst( cMask1 , 3 )
	Next n
EndIf

If !Empty(mv_par29)
	cMask2 := Alltrim( cMascara2 )
	For n := 1 to Val( mv_par29 )
		nDigCCAte 	+=	Val( Padl( cMask2 , 2 ) )
		cMask2 		:=	Subst( cMask2 , 3 )
	Next n
EndIf

dbSelectArea("cArqTmp")
dbSetOrder(1)
dbGoTop()

If RecCount() == 0 .and. !Empty(aSetOfBook[5])
	dbCloseArea()
	fErase(cArqTmp+GetDBExtension())
	fErase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

dbSelectArea("cArqTmp")
dbGoTop()

cGrupo := GRUPO
cCCAnt := cArqTmp->CUSTO
cOldCCAnt:= ""

Do While !Eof()
	
	If lEnd
		@Prow()+1,0 psay "***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	IncRegua()
	
	lCont	:=	iif( Len(Alltrim(CONTA)) > nNivelCT1 .or. Len(Alltrim(CUSTO)) > nNivelCTT	, .f. , .t.   )
	lCont	:=	iif( mv_par34 == 1 .and. TIPOCC    == "2" 									, .f. , lCont )
	lCont	:=	iif( mv_par34 == 2 .and. TIPOCC    == "1" 									, .f. , lCont )
	lCont	:=	iif( mv_par07 == 1 .and. TIPOCONTA == "2"									, .f. , lCont )
	lCont	:=	iif( mv_par07 == 2 .and. TIPOCONTA == "1"									, .f. , lCont )
	lCont	:=	iif( !Empty(cSegAte)  .and. Len(Alltrim(CONTA)) > nDigitAte					, .f. , lCont )
	lCont	:=	iif( !Empty(mv_par29) .and. Len(Alltrim(CUSTO)) > nDigCCAte 				, .f. , lCont )
	
	if	!lCont
		dbSkip()
		Loop
	EndIf
	
	If mv_par13 == 1							// Grupo Diferente - Totaliza e Quebra
		
		If cGrupo != GRUPO
			
			nPos := aScan( aSaldos , { |x| x[1] == cArqTmp->GRUPO .and. x[2] == Space(Len(cArqTmp->CUSTO)) } )
			
			@    li,00 psay Replicate("-",limite)
			
			li ++
			
			@ ++ li,00 psay Replicate("-",limite)
			@ ++ li,aColunas[COL_SEPARA1] psay "|"
			@    li,01 psay "T O T A I S  D O  G R U P O (" + cGrupo + ") : "
			@    li,aColunas[COL_SEPARA4] psay "|"
			ValorCTB( aSaldos[nPos,04] , li , aColunas[COL_VLR_DEBITO]  , 16 , nDecimais , .f. , cPicture , "1" , , , , , ,lPrintZero,)
			@    li,aColunas[COL_SEPARA5] psay "|"
			ValorCTB( aSaldos[nPos,05] , li , aColunas[COL_VLR_CREDITO] , 16 , nDecimais , .f. , cPicture , "2" , , , , , ,lPrintZero)
			
			@    li,aColunas[COL_SEPARA6] psay "|"
			@    li,aColunas[COL_SEPARA8] psay "|"
			
			nGrpDeb		:= 0
			nGrpCrd		:= 0
			li				:= 60
			cGrupo		:= GRUPO
		EndIf
	Else
		If	( cCCAnt <> cArqTmp->CUSTO ) .and. !lFirstPage
			
			nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cCCAnt } )
			
			@    li,000 psay	Replicate("-",limite)
			@ ++ li,000 psay "|"
			@    li,001 psay "Totais do "+ rTrim( Upper(cSayCC) ) + " : "
			
			dbSelectArea("CTT")
			dbSetOrder(1)
			
			cCCSup	:=	iif( MsSeek( xFilial("CTT") + cArqTmp->CUSTO ) , CTT->CTT_CCSUP , "" )
			
			If MsSeek( xFilial("CTT") + cCCAnt )
				cAntCCSup 	:= CTT->CTT_CCSUP				//Centro de Custo Superior do Centro de custo anterior.
				cCCRes	  	:= CTT->CTT_RES
			Else
				cAntCCSup 	:= ""
			EndIf
			
			dbSelectArea("cArqTmp")
			
			If	mv_par24 == 2 		// Se Impr. Cod. Red. C.C
				If CTT->CTT_CUSTO == cCCAnt .and. CTT->CTT_CLASSE == '2' //Se for analitico
					EntidadeCTB(cCCRes,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
				Else
					EntidadeCTB(cCCAnt,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
				EndIf
			Else
				EntidadeCTB(cCCAnt,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")			// Se Imprime Cod. normal do C.Custo
			Endif
			
			@ li,aColunas[COL_SEPARA3] psay "|"
			ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4] psay "|"
			ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5] psay "|"
			ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6] psay "|"
			
			If !l132
				nTotMov := ( aSaldos[nPos,05] - aSaldos[nPos,04] )
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) >= 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
				EndIf
				@ li,aColunas[COL_SEPARA7] psay "|"
			Endif
			
			//ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
			ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
			
			@ li,aColunas[COL_SEPARA8] psay "|"
			
			nTotCCDeb := 0
			nTotCCCrd := 0
			nCCSldAnt := 0
			nCCSldAtu := 0
			
			If lImpTotS .and. cCCSup <> cAntCCSup .and. !Empty(cAntCCSup) //Se for centro de custo superior diferente
				
				nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cAntCCSup } )
				
				dbSelectArea("CTT")
				dbSetOrder(1)
				
				cCCSup	:=	Iif( MsSeek( xFilial("CTT") + cArqTmp->CUSTO  ) , CTT->CTT_CCSUP , "" )
				
				IF nPos > 0     //incluido esta linha EDMILSON
					dbSelectArea("cArqTmp")
					@ ++ li,00 psay "|"
					@    li,01 psay "Totais do "+ RTrim( Upper(cSayCC) ) + " : "
					EntidadeCTB(cAntCCSup,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
					@    li,aColunas[COL_SEPARA3] psay "|"
					//ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],16,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
					ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],16,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
					@    li,aColunas[COL_SEPARA4] psay "|"
					ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
					@    li,aColunas[COL_SEPARA5] psay "|"
					ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
					@    li,aColunas[COL_SEPARA6] psay "|"
					
					If !l132
						//nCcTMov := (aTotCCSup[3] - aTotCCSup[2])
						nCcTMov := ( aSaldos[nPos,05] - aSaldos[nPos,04] )
						If Round(NoRound(nCCtMov,3),2) < 0
							ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
						ElseIf Round(NoRound(nCCtMov,3),2) >= 0
							ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
						EndIf
						@ li,aColunas[COL_SEPARA7] psay "|"
					Endif
					
					ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
					
					@    li,aColunas[COL_SEPARA8] psay "|"
					
					dbSelectArea("cArqTmp")
					nRegTmp	:= Recno()
					dbSelectArea("CTT")
					lImpCCSint	:= .t.
					
					While lImpCCSint
						
						dbSelectArea("CTT")
						
						If MsSeek( xFilial() + cAntCCSup ) .and. !Empty( CTT->CTT_CCSUP )
							
							cAntCCSup	:= CTT->CTT_CCSUP
							
							nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cAntCCSup } )
							
							@ ++ li,00 psay "|"
							@    li,01 psay "Totais do "+ RTrim(Upper(cSayCC)) + " : "
							EntidadeCTB(cAntCCSup,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
							
							dbSelectArea("cArqTmp")
							
							@ li,aColunas[COL_SEPARA3] psay "|"
							ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA4] psay "|"
							ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA5] psay "|"
							ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
							@ li,aColunas[COL_SEPARA6] psay "|"
							
							If !l132
								//nCCtMov := (aTotCCSup[3] - aTotCCSup[2])
								nCCtMov := ( aSaldos[nPos,05] - aSaldos[nPos,04] )
								If Round(NoRound(nCCtMov,3),2) < 0
									ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
								ElseIf Round(NoRound(nCCtMov,3),2) >= 0
									ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
								EndIf
								@ li,aColunas[COL_SEPARA7] psay "|"
							Endif
							
							//ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1" , , , , ,lPrintZero)
							ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
							
							@ li,aColunas[COL_SEPARA8] psay "|"
							
							lImpCCSint	:= .t.
						Else
							lImpCCSint	:= .f.
						EndIf
					EndDo
					
					cAntCCSup		:= ""
					cCCSup			:= ""
					aTotCCSup 		:= {0,0,0,0,0}
					dbSelectArea("cArqTmp")
					dbGoto(nRegTmp)
				EndIf
				li++
			EndIf
		EndIf
	ENDIF
	If mv_par13 == 1				       							// Totaliza por Grupo
		If (cGrupo != GRUPO) .or.; 	                     // Grupo Diferente ou
			(mv_par21 == 1 .and. cCCAnt <> cArqTmp->CUSTO) 	// Se quebra pagina por CCusto e o CCusto for diferente do anterior
			lPula := .t.
			li		:= 60
			cGrupo:= GRUPO
		EndIf
	Else
		If mv_par21 == 1
			If cCCAnt <> cArqTmp->CUSTO 							//Se o item atual for diferente do item anterior
				lPula := .t.
				li 	:= 60
			EndIf
		Endif
	EndIf
	
	If li > 58
		
		If !lFirstPage
			@ Prow()+1,00 psay	Replicate("-",limite)
		EndIf
		
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		
		li ++
		
		If lFirstPage
			@ li,000 psay Replicate("-",limite)
			li ++
			@ li,000 psay "|"
			@ li,001 psay Upper(cSayCC) + " : "
			If mv_par24 == 2 .and. cArqTmp->TIPOCC == '2' //Se Imprime Cod. Red. CC e se for analitico
				EntidadeCTB(CCRES,li,17,nTamCC,.f.,cMascara2,cSepara2,"CTT")
			Else
				EntidadeCTB(CUSTO,li,17,nTamCC,.f.,cMascara2,cSepara2,"CTT")
			Endif
			@ li,80 psay " - " +cArqTMP->DESCCC
			@ li,aColunas[COL_SEPARA8] psay "|"
			li ++
			@ li,000 psay Replicate("-",limite)
			li+=1
			lFirstPage 	:= .f.
			lImpDscCC	:= .t.
		EndIf
	Endif
	
	If	( !lImpDscCC .and. (  ( mv_par21 == 2 .and. cCCAnt    <> cArqTmp->CUSTO	) 		.or. ;
		( mv_par21 == 1 .and. cCCAnt    <> cArqTmp->CUSTO ) 		.or. ;
		( mv_par13 == 1 .and. cGrupoAnt <> cArqTmp->GRUPO ) )	) .or. li > 58
		
		
		@ ++ li,000 psay Replicate("-",limite) // bruno
		
		@ ++ li,000 psay "|"
		@    li,001 psay Upper(cSayCC) + " : "
		EntidadeCTB(iif( mv_par24 == 2 .and. cArqTmp->TIPOCC == '2' , CCRES , CUSTO ),li,17,nTamCC,.f.,cMascara2,cSepara2,"CTT")
		@    li,aColunas[COL_CONTA] + Len(CriaVar("CTT_DESC01")) psay " - " +cArqTMP->DESCCC
		@    li,131 psay "|"
		@ ++ li,000 psay Replicate("-",limite)
		
		li ++
	Endif
	
	lImpDscCC	:= .f.
	
	@ li,aColunas[COL_SEPARA1] psay "|"
	
	If mv_par26 == 2 .and. cArqTmp->TIPOCONTA == '2' //Se imprime Cod. Red. conta e se for analitico
		EntidadeCTB(CTARES,li,aColunas[COL_CONTA],20,.f.,cMascara1,cSepara1)
	Else
		EntidadeCTB(CONTA,li,aColunas[COL_CONTA],20,.f.,cMascara1,cSepara1)
	EndIf
	
	dbSelectArea("cArqTmp")
	
	@ li,aColunas[COL_SEPARA2] 	psay "|"
	@ li,aColunas[COL_DESCRICAO] 	psay iif( l132 , Substr(DESCCTA,1,31) , DESCCTA )
	@ li,aColunas[COL_SEPARA3] 	psay "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] psay "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] psay "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] psay "|"
	
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] psay "|"
	Endif
	
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] psay "|"
	
	lJaPulou := .f.
	
	If lPulaSint .and. TIPOCONTA == "1"				// Pula linha entre sinteticas
		@ ++ li,aColunas[COL_SEPARA1] psay "|"
		@    li,aColunas[COL_SEPARA2] psay "|"
		@    li,aColunas[COL_SEPARA3] psay "|"
		@    li,aColunas[COL_SEPARA4] psay "|"
		@    li,aColunas[COL_SEPARA5] psay "|"
		@    li,aColunas[COL_SEPARA6] psay "|"
		If !l132
			@ li,aColunas[COL_SEPARA7] psay "|"
			@ li,aColunas[COL_SEPARA8] psay "|"
		Else
			@ li,aColunas[COL_SEPARA8] psay "|"
		EndIf
		li ++
		lJaPulou := .t.
	Else
		li ++
	EndIf
	
	************************* FIM DA IMPRESSAO *************************
	
	If mv_par07 != 1 													// Imprime Analiticas ou Ambas
		If TIPOCONTA == "2"
			If (mv_par34 != 1 .and. TIPOCC == "2")
				nTotDeb 			+= SALDODEB
				nTotCrd    		+= SALDOCRD
				nTotSldAnt		+= SALDOANT
				nTotSldAtu		+= SALDOATU
				nGrpDeb 			+= SALDODEB
				nGrpCrd 			+= SALDOCRD
			ElseIf (mv_par34 == 1 .and. TIPOCC != "2"	)
				nTotDeb 			+= SALDODEB
				nTotCrd    		+= SALDOCRD
				nTotSldAnt		+= SALDOANT
				nTotSldAtu		+= SALDOATU
				nGrpDeb 			+= SALDODEB
				nGrpCrd 			+= SALDOCRD
			EndIf 
				nTotCCDeb 			+= SALDODEB
				nTotCCCrd 			+= SALDOCRD
				nCCSldAnt			+= SALDOANT
				nCCSldAtu			+= SALDOATU
			If TIPOCC == "1"
				aTotCCSup[1]	+= SALDOANT
				aTotCCSup[2]	+= SALDODEB
				aTotCCSup[3]	+= SALDOCRD
				aTotCCSup[5]	+= SALDOATU
			EndIf
		Endif
	Else
		If (TIPOCONTA == "1" .and. Empty(SUPERIOR))
			If (mv_par34 != 1 .and. TIPOCC == "2")
				nTotDeb 			+= SALDODEB
				nTotCrd    		+= SALDOCRD
				nGrpDeb 			+= SALDODEB
				nGrpCrd 			+= SALDOCRD
				nTotSldAnt		+= SALDOANT
				nTotSldAtu		+= SALDOATU
			ElseIf (mv_par34 == 1 .and. TIPOCC != "2"	)
				nTotDeb 			+= SALDODEB
				nTotCrd    		+= SALDOCRD
				nGrpDeb 			+= SALDODEB
				nGrpCrd 			+= SALDOCRD
				nTotSldAnt		+= SALDOANT
				nTotSldAtu		+= SALDOATU
			  EndIf 
				nTotCCDeb 		+= SALDODEB
				nTotCCCrd 		+= SALDOCRD
				nCCSldAnt		+= SALDOANT
				nCCSldAtu		+= SALDOATU
			If TIPOCC == "1"
				aTotCCSup[1]	+= SALDOANT
				aTotCCSup[2]	+=	SALDODEB
				aTotCCSup[3]	+=	SALDOCRD
				aTotCCSup[5]	+= SALDOATU
			EndIf
		EndIf
	Endif
	
	
	cCCAnt 		:= cArqTmp->CUSTO
	cGrupoAnt	:=	cArqTmp->GRUPO
	
	nPos := aScan( aSaldos , { |x| x[1] == cArqTmp->GRUPO .and. x[2] == Space(Len(cArqTmp->CUSTO)) } )
	
	if	nPos == 0
		aAdd( aSaldos , { "" , "" , 0 , 0 , 0 , 0 , 0 } )
		nPos := Len(aSaldos)
	endif
	
	aSaldos[nPos,01]	:=	cArqTmp->GRUPO
	aSaldos[nPos,02]	:=	Space(Len(cArqTmp->CUSTO))
	aSaldos[nPos,03]	+=	cArqTmp->SALDOANT
	aSaldos[nPos,04]	+=	cArqTmp->SALDODEB
	aSaldos[nPos,05]	+=	cArqTmp->SALDOCRD
	aSaldos[nPos,06]	+=	cArqTmp->MOVIMENTO
	aSaldos[nPos,07]	+=	cArqTmp->SALDOATU
	
	if	!Empty(Alltrim(cArqTmp->CUSTO))
		
		nPos := aScan( aSaldos , { |x| x[1] == cArqTmp->GRUPO .and. x[2] == cArqTmp->CUSTO } )
		
		if	nPos == 0
			aAdd( aSaldos , { "" , "" , 0 , 0 , 0 , 0 , 0 } )
			nPos := Len(aSaldos)
		endif
		
		aSaldos[nPos,01]	:=	cArqTmp->GRUPO
		aSaldos[nPos,02]	:=	cArqTmp->CUSTO
		aSaldos[nPos,03]	+=	cArqTmp->SALDOANT
		aSaldos[nPos,04]	+=	cArqTmp->SALDODEB
		aSaldos[nPos,05]	+=	cArqTmp->SALDOCRD
		aSaldos[nPos,06]	+=	cArqTmp->MOVIMENTO
		aSaldos[nPos,07]	+=	cArqTmp->SALDOATU
		
	endif
	
	if	Len(Alltrim(cArqTmp->CUSTO)) == nPriNivCTT
		
		IF cOldCCAnt <> SubStr( cArqTmp->CUSTO, 1, Len(Alltrim(cArqTmp->CUSTO)))
			aTotPer[01]	+=	cArqTmp->SALDOANT
			aTotPer[02]	+=	cArqTmp->SALDODEB
			aTotPer[03]	+=	cArqTmp->SALDOCRD
			aTotPer[04]	+=	cArqTmp->MOVIMENTO
			aTotPer[05]	+=	cArqTmp->SALDOATU
			cOldCCAnt   :=  SubStr( cArqTmp->CUSTO, 1, Len(Alltrim(cArqTmp->CUSTO)))
		ENDIF
		
	endif
	
	dbSkip()
	
	If lPulaSint .and. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] psay "|"
			@ li,aColunas[COL_SEPARA2] psay "|"
			@ li,aColunas[COL_SEPARA3] psay "|"
			@ li,aColunas[COL_SEPARA4] psay "|"
			@ li,aColunas[COL_SEPARA5] psay "|"
			@ li,aColunas[COL_SEPARA6] psay "|"
			If !l132
				@ li,aColunas[COL_SEPARA7] psay "|"
				@ li,aColunas[COL_SEPARA8] psay "|"
			Else
				@ li,aColunas[COL_SEPARA8] psay "|"
			EndIf
			li++
		EndIf
	EndIf
EndDo

If mv_par13 == 1							// Grupo Diferente - Totaliza e Quebra
	@li,00 psay Replicate("-",limite)
	li+=2
	@li,00 psay Replicate("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] psay "|"
	@li,01 psay "T O T A I S  D O  G R U P O (" + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
	@li,aColunas[COL_SEPARA4] psay "|"
	ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] psay "|"
	ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] psay "|"
	@li,aColunas[COL_SEPARA8] psay "|"
	li++
	
	cGrupo		:= GRUPO
	nGrpDeb		:= 0
	nGrpCrd		:= 0
Else
	
	nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cCCAnt } )
	
	IF nPos > 0 .AND. LEFT(cCCAnt,2) == "99"
		//ImpTotPer()
	ENDIF
	
	//Imprime o total do ultimo item a ser impresso.
	@li,00 psay	Replicate("-",limite)
	li ++
	@li,00 psay "|"
	@li,01 psay "Totais do "+ RTrim(Upper(cSayCC)) + " : "
	
	cCCSup	:=	iif( MsSeek( xFilial("CTT") + cCCAnt ) , CTT->CTT_CCSUP , "" )
	
	If MsSeek( xFilial("CTT") + cCCAnt )
		cAntCCSup 	:= CTT->CTT_CCSUP				//Centro de Custo Superior do Centro de custo anterior.
		cCCRes	  	:= CTT->CTT_RES
	Else
		cAntCCSup 	:= ""
	EndIf
	
	
	If mv_par24 == 2 //Se Imprime Cod. Red. C.custo
		If  CTT->CTT_CUSTO == cCCAnt .and. CTT->CTT_CLASSE == '2'//Se for analitico, imprime cod. reduzido.
			EntidadeCTB(cCCRes,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
		Else
			EntidadeCTB(cCCAnt,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
		Endif
	Else
		EntidadeCTB(cCCAnt,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
	Endif
	If !l132  //alterado
		@ li,aColunas[COL_SEPARA3] psay "|"
		ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA4] psay "|"
		ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA5] psay "|"
		ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA6] psay "|"
	Endif      //alterado
	
	If !l132
		nCCtMov := (nTotCCCrd - nTotCCDeb)
		If Round(NoRound(nCCtMov,3),2) < 0
			ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nCCtMov,3),2) >= 0
			ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@ li,aColunas[COL_SEPARA7] psay "|"
		//	Endif         //alterado
		
		ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
		@    li,aColunas[COL_SEPARA8] psay "|"
	Endif    //alterado
	@ ++ li,00 psay Replicate("-",limite)
	@ ++ li,0 psay " "
	
	nTotCCDeb := 0
	nTotCCCrd := 0
	nCCSldAnt := 0
	nCCSldAtu := 0
	
	If lImpTotS .and. cCCSup <> cAntCCSup .and. !Empty(cAntCCSup) //Se for diferente centro de custo superior
		
		nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cAntCCSup } )
		
		@ ++ li,00 psay "|"
		@    li,01 psay "Totais do "+ RTrim( Upper(cSayCC) ) + " : "
		EntidadeCTB(cAntCCSup,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
		@    li,aColunas[COL_SEPARA3] psay "|"
		ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],16,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
		@    li,aColunas[COL_SEPARA4] psay "|"
		ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
		@    li,aColunas[COL_SEPARA5] psay "|"
		ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
		@    li,aColunas[COL_SEPARA6] psay "|"
		
		If !l132
			//nCCtMov := (aTotCCSup[3] - aTotCCSup[2])
			nCCtMov := ( aSaldos[nPos,05] - aSaldos[nPos,04] )
			If Round(NoRound(nCCtMov,3),2) < 0
				ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
			ElseIf Round(NoRound(nCCtMov,3),2) >= 0
				ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
			EndIf
			@ li,aColunas[COL_SEPARA7] psay "|"
		Endif
		
		ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],16,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA8] psay "|"
		
		dbSelectArea("CTT")
		lImpCCSint	:= .t.
		
		While lImpCCSint
			dbSelectArea("CTT")
			If MsSeek( xFilial() + cAntCCSup ) .and. !Empty(CTT->CTT_CCSUP)
				
				cAntCCSup	:= CTT->CTT_CCSUP
				
				nPos := aScan( aSaldos , { |x| x[1] == cGrupoAnt .and. x[2] == cAntCCSup } )
				
				@ ++ li,00 psay "|"
				@    li,01 psay "Totais do "+ RTrim(Upper(cSayCC)) + " : "
				
				EntidadeCTB(cAntCCSup,li,22,nTamCC,.f.,cMascara2,cSepara2,"CTT")
				@ li,aColunas[COL_SEPARA3] psay "|"
				ValorCTB(aSaldos[nPos,03],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA4] psay "|"
				ValorCTB(aSaldos[nPos,04],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA5] psay "|"
				ValorCTB(aSaldos[nPos,05],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA6] psay "|"
				
				If !l132
					//nCCtMov := (aTotCCSup[3] - aTotCCSup[2])
					nCCtMov := ( aSaldos[nPos,05] - aSaldos[nPos,04] )
					If Round(NoRound(nCCtMov,3),2) < 0
						ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
					ElseIf Round(NoRound(nCCtMov,3),2) >= 0
						ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
					EndIf
					@ li,aColunas[COL_SEPARA7] psay "|"
				Endif
				
				ValorCTB(aSaldos[nPos,07],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA8] psay "|"
				
				lImpCCSint	:= .t.
			Else
				lImpCCSint	:= .f.
			EndIf
		EndDo
	EndIf
EndIf

IF li != 80 .and. !lEnd
	
	IF li > 58
		@Prow()+1,00 psay	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	li++
	@li,00 psay Replicate("-",limite)
	li++
	@li,0 psay "|"
	@li,1 psay "Totais do periodo: "
	@ li,aColunas[COL_SEPARA3] psay "|"
	ValorCTB(aTotPer[01],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] psay "|"
	ValorCTB(aTotPer[02],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] psay "|"
	ValorCTB(aTotPer[03],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] psay "|"
	
	If !l132
		nTotMov := (aTotPer[03] - aTotPer[02])
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) >= 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		
		@ li,aColunas[COL_SEPARA7] psay "|"
	Endif
	
	ValorCTB(aTotPer[05],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
	@    li,aColunas[COL_SEPARA8] psay "|"
	@ ++ li,00 psay Replicate("-",limite)
	@ ++ li,0 psay " "
	
	If !lExterno .and. li < 59
		Roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf
EndIF

If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
FErase(cArqTmp+GetDBExtension())
FErase("cArqInd"+OrdBagExt())
dbselectArea("CT2")

Ms_Flush()

Return
*-----------------------------------------------------------------------------------------------------------
Static Function ImpTotPer()

IF li > 58
	@Prow()+1,00 psay	Replicate("-",limite)
	CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
	li++
End
li++
@li,00 psay Replicate("-",limite)
li++
@li,0 psay "|"
@li,1 psay "Totais do periodo: "
@ li,aColunas[COL_SEPARA3] psay "|"
ValorCTB(aTotPer[01],li,aColunas[COL_SALDO_ANT],17,nDecimais,.t.,cPicture,NORMAL, , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA4] psay "|"
ValorCTB(aTotPer[02],li,aColunas[COL_VLR_DEBITO],16,nDecimais,.f.,cPicture,"1", , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA5] psay "|"
ValorCTB(aTotPer[03],li,aColunas[COL_VLR_CREDITO],16,nDecimais,.f.,cPicture,"2", , , , , ,lPrintZero)
@ li,aColunas[COL_SEPARA6] psay "|"

If !l132
	nTotMov := (aTotPer[03] - aTotPer[02])
	If Round(NoRound(nTotMov,3),2) < 0
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
	ElseIf Round(NoRound(nTotMov,3),2) >= 0
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.t.,cPicture,"2", , , , , ,lPrintZero)
	EndIf
	
	@ li,aColunas[COL_SEPARA7] psay "|"
Endif

ValorCTB(aTotPer[05],li,aColunas[COL_SALDO_ATU],17,nDecimais,.t.,cPicture,"1", , , , , ,lPrintZero)
@    li,aColunas[COL_SEPARA8] psay "|"
li+=1
@ ++ li,00 psay Replicate("-",limite)
@ ++ li,0 psay " "

If !lExterno .and. li < 59
	Roda(cbcont,cbtxt,"M")
	Set Filter To
EndIf

Return(Nil)
*-----------------------------------------------------------------------------------------------------------
Static Function RetQtdNivel( cAlias , nLen , cMascara )

Local w
Local nPos
Local oDlg1
Local oCombo
Local cCombo
Local nRet		:=	0
Local aItens 	:=	{}
Local cTitle	:=	"Nível " + iif( cAlias == "CT1" , "da Conta Contábil" , "do Centro de Custo" )

For w := 1 to nLen
	aAdd( aItens , "Nível " + Alltrim(Str(w)) )
Next w

cCombo := aItens[1]

Define MsDialog oDlg1 Title cTitle From 000,000 To 100,230 Of oMainWnd Pixel
@ 010,010 ComboBox oCombo	Var cCombo	Items aItens 	Size 090,050 Pixel
Define SButton From 030,075 Type 1 Enable Of oDlg1 Action oDlg1:End()
Activate MsDialog oDlg1 Centered

nPos := aScan( aItens , cCombo )

For w := 1 to nPos
	nRet	+=	Val(Substr(cMascara,w,1))
Next w

Return ( nRet )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01-oMeter      = Controle da regua                                  ³±±
±±³          ³ 02-oText       = Controle da regua                                  ³±±
±±³          ³ 03-oDlg        = Janela                                             ³±±
±±³          ³ 04-lEnd        = Controle da regua -> finalizar                     ³±±
±±³          ³ 05-cArqTmp     = Arquivo temporario                                 ³±±
±±³          ³ 06-dDataIni    = Data Inicial de Processamento                      ³±±
±±³          ³ 07-dDataFim    = Data Final de Processamento                        ³±±
±±³          ³ 08-cAlias      = Alias do Arquivo                                   ³±±
±±³          ³ 09-cIdent      = Identificador do arquivo a ser processado          ³±±
±±³          ³ 10-cContaIni   = Conta Inicial                                      ³±±
±±³          ³ 11-cContaFim	= Conta Final                                        ³±±
±±³          ³ 12-cCCIni      = Centro de Custo Inicial                            ³±±
±±³          ³ 13-cCCFim      = Centro de Custo Final                              ³±±
±±³          ³ 14-cItemIni    = Item Inicial                                       ³±±
±±³          ³ 15-cItemFim    = Item Final                                         ³±±
±±³          ³ 16-cClvlIni    = Classe de Valor Inicial                            ³±±
±±³          ³ 17-cClvlFim    = Classe de Valor Final                              ³±±
±±³          ³ 18-cMoeda      = Moeda	                                            ³±±
±±³          ³ 19-cSaldos     = Tipos de Saldo a serem processados                 ³±±
±±³          ³ 20-aSetOfBook  = Matriz de configuracao de livros                   ³±±
±±³          ³ 21-cSegmento   = Indica qual o segmento sera filtrado               ³±±
±±³          ³ 22-cSegIni     = Conteudo Inicial do segmento                       ³±±
±±³          ³ 23-cSegFim     = Conteudo Final do segmento                         ³±±
±±³          ³ 24-cFiltSegm   = Filtra por Segmento   		                       ³±±
±±³          ³ 25-lNImpMov    = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ 26-lImpConta   = Se Imprime Conta                                   ³±±
±±³          ³ 27-nGrupo      = Grupo                                              ³±±
±±³          ³ 28-cHeader     = Identifica qual a Entidade Principal               ³±±
±±³          ³ 29-lImpAntLP   = Se imprime lancamentos Lucros e Perdas             ³±±
±±³          ³ 30-dDataLP     = Data da ultima Apuracao de Lucros e Perdas         ³±±
±±³          ³ 31-nDivide     = Divide valores por (100,1000,1000000)              ³±±
±±³          ³ 32-lVlrZerado  = Grava ou nao valores zerados no arq temporario     ³±±
±±³          ³ 33-cFiltroEnt  = Entidade Gerencial que servira de filtro dentro    ³±±
±±³          ³                  de outra Entidade Gerencial. Ex.: Centro de Custo  ³±±
±±³          ³                  sendo filtrado por Item Contabil (CTH)             ³±±
±±³          ³ 34-cCodFilEnt  = Codigo da Entidade Gerencial utilizada como filtro ³±±
±±³          ³ 35-cSegmentoG  = Filtra por Segmento Gerencial (CC/Item ou ClVl)    ³±±
±±³          ³ 36-cSegIniG    = Segmento Gerencial Inicial                         ³±±
±±³          ³ 37-cSegFimG    = Segmento Gerencial Final                           ³±±
±±³          ³ 38-cFiltSegmG  = Segmento Gerencial Contido em                      ³±±
±±³          ³ 39-lUsGaap     = Se e Balancete de Conversao de moeda               ³±±
±±³          ³ 40-cMoedConv   = Moeda para a qual buscara o criterio de conversao  ³±±
±±³          ³                  no Pl.Contas                                       ³±±
±±³          ³ 41-cConsCrit   = Criterio de conversao utilizado: 1-Diario, 2-Medio,³±±
±±³          ³                  3-Mensal, 4-Informada, 5-Plano de Contas           ³±±
±±³          ³ 42-dDataConv   = Data de Conversao                                  ³±±
±±³          ³ 43-nTaxaConv   = Taxa de Conversao                                  ³±±
±±³          ³ 44-aGeren      = Matriz que armazena os compositores do Pl. Ger.    ³±±
±±³          ³ 			        para efetuar o filtro de relatorio.                ³±±
±±³          ³ 45-lImpMov     = Nao utilizado                                      ³±±
±±³          ³ 46-lImpSint    = Se atualiza sinteticas                             ³±±
±±³          ³ 47-cFilUSU     = Filtro informado pelo usuario                      ³±±
±±³          ³ 48-lRecDesp0   = Se imprime saldo anterior do periodo anterior      ³±±
±±³          ³                  zerado                                             ³±±
±±³          ³ 49-cRecDesp    = Grupo de receitas e despesas                       ³±±
±±³          ³ 50-dDtZeraRD   = Data de zeramento de receitas e despesas           ³±±
±±³          ³ 51-lImp3Ent    = Se e Balancete C.Custo / Conta / Item              ³±±
±±³          ³ 52-lImp4Ent    = Se e Balancete por CC x Cta x Item x Cl.Valor      ³±±
±±³          ³ 53-lImpEntGer  = Se e Balancete de Entidade (C.Custo/Item/Cl.Vlr    ³±±
±±³          ³                  por Entid. Gerencial)                              ³±±
±±³          ³ 54-lFiltraCC   = Se considera o filtro das perguntas para C.Custo   ³±±
±±³          ³ 55-lFiltraIt   = Se considera o filtro das perguntas para Item      ³±±
±±³          ³ 56-lFiltraCV   = Se considera o filtro das perguntas para Cl.Valor  ³±±
±±³          ³ 57-cMoedaDsc   = Codigo da moeda para descricao das entidades       ³±±
±±³          ³ 58-lMovPeriodo = Se imprime movimento do periodo anterior		     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function XCTGerPlan(oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,;
cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,;
cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,cMoedaDsc,;
lMovPeriodo)

Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cCodigo		:= ""
Local cCodGer		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local cMascaraG 	:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.)
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local nCampoLP		:= 0
Local cFilDe		:= xFilial(cAlias)
Local cFilAte		:= xFilial(cAlias), nOrdem := 1
Local cCodMasc		:= ""
Local cMensagem		:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio. ")
Local nPos			:= 0
Local nCont			:= 0
Local lTemQuery		:= .F.

Local lCT1EXDTFIM	:= CtbExDtFim("CT1")
Local lCTTEXDTFIM	:= CtbExDtFim("CTT")
Local lCTDEXDTFIM	:= CtbExDtFim("CTD")
Local lCTHEXDTFIM	:= CtbExDtFim("CTH")

Local nSlAntGap		:= 0	// Saldo Anterior
Local nSlAntGapD	:= 0	// Saldo anterior debito
Local nSlAntGapC	:= 0	// Saldo anterior credito
Local nSlAtuGap		:= 0	// Saldo Atual
Local nSlAtuGapD	:= 0	// Saldo Atual debito
Local nSlAtuGapC	:= 0	// Saldo Atual credito
Local nSlDebGap		:= 0	// Saldo Debito
Local nSlCrdGap		:= 0	// Saldo Credito

#IFDEF TOP
	Local aStruTmp		:= {}
	Local lTemQry		:= .F.
	Local nTrb			:= 0
#ENDIF
Local nDigitos		:= 0
Local nMeter		:= 0
Local nPosG			:= 0
Local nDigitosG		:= 0
DEFAULT cSegmentoG 	:= ""
DEFAULT lUsGaap		:=.F.
DEFAULT cMoedConv	:= ""
DEFAULT	cConsCrit	:= ""
DEFAULT dDataConv	:= CTOD("  /  /  ")
DEFAULT nTaxaConv	:= 0
DEFAULT lImpSint	:= .T.
DEFAULT lImpMov		:= .T.
DEFAULT cSegmento	:= ""
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lImp3Ent	:= .F.
DEFAULT lImp4Ent	:= .F.
DEFAULT lImpEntGer	:= .F.
DEFAULT lImpConta	:= .T.
DEFAULT lFiltraCC	:= .F.
DEFAULT lFiltraIt	:= .F.
DEFAULT lFiltraCV	:= .F.
DEFAULT cMoedaDsc	:= '01'
DEFAULT lMovPeriodo := .F.

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)
cHeader		:= Iif(cHeader == Nil,'',cHeader)
cFiltroEnt	:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt	:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
Private nMin			:= 0
Private nMax			:= 0

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
dMinData := CTOD("")

If ExistBlock("ESPGERPLAN")
	ExecBlock("ESPGERPLAN",.F.,.F.,{oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
	cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,;
	cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
	cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
	nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,;
	cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
	cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
	cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV})
	
	Return(cArqTmp)
EndIf

If cAlias == 'CTY'	//Se for Balancete de 2 Entidades filtrando pela 3a Entidade.
	aCampos := {{ "ENTID1"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
	{ "ENTRES1"	, "C", aTamCtaRes[1],0 },;  			// Codigo Reduzido da Conta
	{ "DESCENT1"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	{ "TIPOENT1"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	{ "ENTSUP1"	, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	{ "ENTID2"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
	{ "ENTRES2"	, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
	{ "DESCENT2"	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
	{ "TIPOENT2"	, "C", 01			, 0 },;				// Item Analitica / Sintetica
	{ "ENTSUP2"	, "C", aTamItem[1]	, 0 },; 			// Codigo do Item Superior
	{ "NORMAL"		, "C", 01			, 0 },;				// Situacao
	{ "SALDOANT"	, "N", aTamVal[1]+2, nDecimais},; 		// Saldo Anterior
	{ "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
	{ "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
	{ "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
	{ "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
	{ "SALDOATU"	, "N", aTamVal[1]+2, nDecimais },;  	// Saldo Atual
	{ "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
	{ "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
	{ "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
	{ "ORDEM"		, "C", 10			, 0 },;				// Ordem
	{ "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
	{ "IDENTIFI"	, "C", 01			, 0 },;
	{ "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se
	// eh de nivel 1 -> usado como
	// totalizador do relatorio
Else
	aCampos := { { "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
	{ "SUPERIOR"	, "C", aTamConta[1], 0 },;				// Conta Superior
	{ "NORMAL"		, "C", 01			, 0 },;				// Situacao
	{ "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
	{ "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	{ "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
	{ "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
	{ "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
	{ "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item
	{ "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
	{ "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	{ "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
	{ "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
	{ "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
	{ "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	{ "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
	{ "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
	{ "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
	{ "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
	{ "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual
	{ "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
	{ "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
	{ "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
	{ "TIPOCONTA"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica
	{ "TIPOCC"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	{ "TIPOITEM"	, "C", 01			, 0 },;				// Item Analitica / Sintetica
	{ "TIPOCLVL"	, "C", 01			, 0 },;				// Classe de Valor Analitica / Sintetica
	{ "CCSUP"		, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	{ "ITSUP"		, "C", aTamItem[1]	, 0 },;				// Codigo do Item Superior
	{ "CLSUP"	    , "C", aTamClVl[1] , 0 },;				// Codigo da Classe de Valor Superior
	{ "ORDEM"		, "C", 10			, 0 },;				// Ordem
	{ "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
	{ "IDENTIFI"	, "C", 01			, 0 },;
	{ "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
	{ "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se
	// eh de nivel 1 -> usado como
	// totalizador do relatorio]
	
	// Usado no mutacoes de patrimonio liquido inclui campo que alem da descricao da entidade
	// Que esta no DESCCTA tem tambem a descricao da conta inicial CTS_CT1INI
	
	If 	Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
		Aadd(aCampos, { "DESCORIG"	, "C", nTamCta		, 0 } )	// Descricao da Origem do Valor
	Endif
EndIf

If CTS->(FieldPos("CTS_COLUNA")) > 0
	Aadd(aCampos, { "COLUNA"   	, "N", 01			, 0 })
Endif
If 	Type("dSemestre") # "U" .And. ValType(dSemestre) = "D"
	Aadd(aCampos, { "SALDOSEM"	, "N", 17		, nDecimais }) 	// Saldo semestre
Endif

If Type("dPeriodo0") # "U" .And. ValType(dPeriodo0) = "D"
	Aadd(aCampos, { "SALDOPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
	Aadd(aCampos, { "MOVIMPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
Endif

If Type("lComNivel") # "U" .And. ValType(lComNivel) = "L"
	Aadd(aCampos, { "NIVEL"   	, "N", 01			, 0 })		// Nivel hieraquirco - Quanto maior mais analitico
Endif

If ( cAlias = "CT7" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTT" .And. GetNewPar("MV_CCSUP","")  == "S")  .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTD" .And. GetNewPar("MV_ITSUP","") == "S") .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTH" .And. GetNewPar("MV_CLSUP","") == "S")
	Aadd(aCampos, { "ORDEMPRN" 	, "N", 06			, 0 })		// Ordem para impressao
Endif

If lMovPeriodo
	Aadd(aCampos, { "MOVPERANT"		, "N" , 17			, nDecimais }) 	// Saldo Periodo Anterior
EndIf


///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
	dIniRep := ctod("")
	If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep)
		//Chama Rotina de Atualizacao de Saldos Basicos.
		oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
		oProcess:Activate()
	EndIf
Endif

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
	Case cAlias == 'CTU'
		//Verificar se tem algum saldo a ser atualizado por entidade
		If cIdent == "CTT"
			cOrigem := 	'CT3'
		ElseIf cIdent == "CTD"
			cOrigem := 	'CT4'
		ElseIf cIdent == "CTH"
			cOrigem := 	'CTI'
		Else
			cOrigem := 	'CTI'
		Endif
	Case cAlias == 'CTV'
		cOrigem := "CT4"
		//Verificar se tem algum saldo a ser atualizado
	Case cAlias == 'CTW'
		cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
		//Verificar se tem algum saldo a ser atualizado
	Case cAlias == 'CTX'
		cOrigem		:= 'CTI'
EndCase

IF cAlias$("CTU/CTV/CTW/CTX")
	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt)
	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt)},"","",.F.)
		oProcess:Activate()
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= "Os saldos compostos estao desatualizados...Favor atualiza-los" //STR0016
			cMensagem	+= "atraves da rotina de saldos compostos	"//STR0017
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los
			Return							//atraves da rotina de saldos compostos
		EndIf
	EndIf
Endif

Do Case
	Case cAlias  == "CT7"
		cEntidIni	:= cContaIni
		cEntidFim	:= cContaFim
		cCodMasc		:= aSetOfBook[2]
		If nGrupo == 2
			cChave := "CONTA"
		Else									// Indice por Grupo -> Totaliza por grupo
			cChave := "CONTA+GRUPO"
		EndIf
		
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				//Se nao tiver plano gerencial.
				If Empty(aSetOfBook[5])
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					U_XCT7BlnQry(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc)
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif
					lTemQuery := .T.
				Endif
			EndIf
		#ENDIF
		
	Case cAlias == 'CT3'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim
		
		If lImpConta
			If cHeader == "CT1"
				cChave		:= "CONTA+CUSTO"
				cCodMasc	:= aSetOfBook[2]
			Else
				If nGrupo == 2
					cChave   := "CUSTO+CONTA"
				Else									// Indice por Grupo -> Totaliza por grupo
					cChave := "CUSTO+CONTA+GRUPO"
				EndIf
				cCodMasc	:= aSetOfBook[2]
				cMascaraG	:= aSetOfBook[6]
			Endif
		Else		//Balancete de Centro de Custo (filtrando por conta)
			cChave	:= "CUSTO"
			cCodMasc:= aSetOfBook[6]
		EndIf
		
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				If lImpConta
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					U_XCT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU)
				Else
					U_XCt3Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
					lRecDesp0,cRecDesp,dDtZeraRD)
				EndIf
				lTemQuery := .T.
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif
			EndIf
		#ENDIF
		
	Case cAlias =='CT4'
		If lImp3Ent	//Balancete CC / Conta / Item
			If cHeader == "CTT"
				#IFDEF TOP
					If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
						If cFilUsu == ".T."
							cFilUsu := ""
						EndIf
						/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
						CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
						cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU)
						lTemQuery := .T.
						If Empty(cFilUSU)
							cFILUSU := ".T."
						Endif
					EndIf
				#ENDIF
				cEntidIni	:= cCCIni
				cEntidFim	:= cCCFim
				cChave		:= "CUSTO+CONTA+ITEM"
				cCodMasc	:= aSetOfBook[2]
			EndIf
		Else
			cEntidIni	:= cItemIni
			cEntidFim	:= cItemFim
			If lImpConta
				If cHeader == "CT1"	//Se for for Balancete Conta x Item
					cChave	:= "CONTA+ITEM"
					cCodMasc		:= aSetOfBook[4]
				Else
					cChave   := "ITEM+CONTA"
					cCodMasc		:= aSetOfBook[2]
				EndIf
			Else	//Balancete de Item filtrando por conta
				cChave		:= "ITEM"
				cCodMasc	:= aSetOfBook[7]
			EndIf
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					If lImpConta
						/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
						CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
						cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU)
					Else
						Ct4Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
						cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
						lRecDesp0,cRecDesp,dDtZeraRD)
					EndIf
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif
				EndIf
			#ENDIF
		EndIf
	Case cAlias == 'CTI'
		If lImp4Ent	//Balancete CC x Cta x Item x Cl.Valor
			If cHeader == "CTT"
				#IFDEF TOP
					If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5]) .and. !lImpAntLP
						If cFilUsu == ".T."
							cFilUsu := ""
						EndIf
						/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
						CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
						cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP)
						lTemQuery := .T.
						If Empty(cFilUSU)
							cFILUSU := ".T."
						Endif
					EndIf
				#ENDIF
				cChave		:= "CUSTO+CONTA+ITEM+CLVL"
				cEntidIni	:= cCCIni
				cEntidFim	:= cCCFim
				cCodMasc	:= aSetOfBook[2]
			EndIf
		Else
			cEntidIni	:= cClVlIni
			cEntidFim	:= cClvlFim
			
			If lImpConta
				If cHeader == "CT1"
					cChave		:= "CONTA+CLVL"
					cCodMasc	:= aSetOfBook[2]
				Else
					cChave   := "CLVL+CONTA"
				EndIf
				#IFDEF TOP
					If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
						If cFilUsu == ".T."
							cFilUsu := ""
						EndIf
						/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
						CTIBlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cClVlIni,cClVlFim,cMoeda,;
						cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU)
						lTemQuery := .T.
						If Empty(cFilUSU)
							cFILUSU := ".T."
						Endif
					EndIf
				#ENDIF
			Else	//Balancete de Cl.Valor filtrando por conta
				cChave   := "CLVL"
				cCodMasc := aSetOfBook[8]
				#IFDEF TOP
					If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
						If cFilUsu == ".T."
							cFilUsu := ""
						EndIf
						CtIBln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
						cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
						lRecDesp0,cRecDesp,dDtZeraRD)
						lTemQuery := .T.
						If Empty(cFilUSU)
							cFILUSU := ".T."
						Endif
					EndIf
				#ENDIF
			EndIf
		EndIf
	Case cAlias == 'CTU'
		If cIdent == 'CTT'
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO"
			cCodMasc		:= aSetOfBook[6]
		ElseIf cIdent == 'CTD'
			cEntidIni	:= cItemIni
			cEntidFim	:= cItemFim
			cChave   := "ITEM"
			cCodMasc		:= aSetOfBook[7]
		ElseIf cIdent == 'CTH'
			cEntidIni	:= cClVlIni
			cEntidFim	:= cClvlFim
			cChave   := "CLVL"
			cCodMasc		:= aSetOfBook[8]
		Endif
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu)
				lTEmQuery := .T.
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif
			EndIf
		#ENDIF
	Case cAlias == 'CTV'
		If cHeader == 'CTT'
			cChave   := "CUSTO+ITEM"
			cEntidIni1	:= cCCIni
			cEntidFim1	:= cCCFim
			cEntidIni2	:= cItemIni
			cEntidFim2	:= cItemFim
		ElseIf cHeader == 'CTD'
			cChave   := "ITEM+CUSTO"
			cEntidIni1	:= cItemIni
			cEntidFim1	:= cItemFim
			cEntidIni2	:= cCCIni
			cEntidFim2	:= cCCFim
		EndIf
	Case cAlias == 'CTW'
		If cHeader	== 'CTT'
			cChave   := "CUSTO+CLVL"
			cEntidIni1	:=	cCCIni
			cEntidFim1	:=	cCCFim
			cEntidIni2	:=	cClVlIni
			cEntidFim2	:=	cClVlFim
		ElseIf cHeader == 'CTH'
			cChave   := "CLVL+CUSTO"
			cEntidIni1	:=	cClVlIni
			cEntidFim1	:=	cClVlFim
			cEntidIni2	:=	cCCIni
			cEntidFim2	:=	cCCFim
		EndIf
	Case cAlias == 'CTX'
		If cHeader == 'CTD'
			cChave  	 := "ITEM+CLVL"
			cEntidIni1	:= 	cItemIni
			cEntidFim1	:= 	cItemFim
			cEntidIni2	:= 	cClVlIni
			cEntidFim2	:= 	cClVlFim
		ElseIf cHeader == 'CTH'
			cChave  	 := "CLVL+ITEM"
			cEntidIni1	:= 	cClVlIni
			cEntidFim1	:= 	cClVlFim
			cEntidIni2	:= 	cItemIni
			cEntidFim2	:= 	cItemFim
		EndIf
	Case cAlias	== 'CTY'
		cChave			:="ENTID1+ENTID2"
		If cHeader == 'CTT' .And. cFiltroEnt == 'CTD'
			cEntidIni1	:= cCCIni
			cEntidFim1	:= cCCFim
			cEntidIni2	:= cClVlIni
			cEntidFim2	:= cClvlFim
		ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
			cEntidIni1	:= cCCIni
			cEntidFim1	:= cCCFim
			cEntidIni2	:= cItemIni
			cEntidFim2	:= cItemFim
		ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
			cEntidIni1	:= cItemIni
			cEntidFim1	:= cItemFim
			cEntidIni2	:= cClVlIni
			cEntidFim2	:= cClVlFim
		ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
			cEntidIni1	:= cItemIni
			cEntidFim1	:= cItemFim
			cEntidIni2	:= cCCIni
			cEntidFim2	:= cCCFim
		ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
			cEntidIni1	:= cClVlIni
			cEntidFim1	:= cClVlFim
			cEntidIni2	:= cItemIni
			cEntidFim2	:= cItemFim
		ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
			cEntidIni1	:= cClVlIni
			cEntidFim1	:= cClVlFim
			cEntidIni2	:= cCCIni
			cEntidFim2	:= cCCFim
		EndIf
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	If cAlias $ "CT3/CT4/CTI"		//Se for Balancete Entidade/Entidade Gerencial
		Do Case
			Case cAlias == "CT3"
				cChave	:= "CUSTO+CONTA"
			Case cAlias == "CT4"
				cChave	:= "ITEM+CONTA"
			Case cAlias == "CTI"
				cChave	:= "CLVL+CONTA"
		EndCase
	ElseIf cAlias = 'CTU'
		Do Case
			Case cIdent = 'CTT'
				cChave	:= "CUSTO"
			Case cIdent = 'CTD'
				cChave	:= "ITEM"
			Case cIdent = 'CTH'
				cChave	:= "CLVL"
		EndCase
	Else
		cChave	:= "CONTA"
	EndIf
Endif

cArqTmp := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)

IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	cArqTmp1 := CriaTrab(, .F.)
	IndRegua("cArqTmp",cArqTmp1,"ORDEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
Endif

dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	dbSetIndex(cArqTmp1+OrdBagExt())
Endif

#IFDEF TOP
	If FunName() <> "CTBR195" .or. (FunName() == "CTBR195" .and. !lImpAntLP)
		//// SE FOR DEFINIÇÃO TOP
		If TcSrvType() != "AS/400" .and. lTemQuery .and. Select("TRBTMP") > 0 	/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)
			If !Empty(cSegmento)
				If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
					Help("CTN_CODIGO")
					Return(cArqTmp)
				Endif
				dbSelectArea("CTM")
				dbSetOrder(1)
				If MsSeek(xFilial()+cCodMasc)
					While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
						nPos += Val(CTM->CTM_DIGITO)
						If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
							nPos -= Val(CTM->CTM_DIGITO)
							nPos ++
							nDigitos := Val(CTM->CTM_DIGITO)
							Exit
						EndIf
						dbSkip()
					EndDo
				Else
					Help("CTM_CODIGO")
					Return(cArqTmp)
				EndIf
			EndIf
			
			If cAlias == "CT3" .And. cHeader == "CTT" .And. !Empty(cMascaraG)
				If !Empty(cSegmentoG)
					dbSelectArea("CTM")
					dbSetOrder(1)
					If MsSeek(xFilial()+cMascaraG)
						While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
							nPosG += Val(CTM->CTM_DIGITO)
							If CTM->CTM_SEGMEN == cSegmentoG
								nPosG -= Val(CTM->CTM_DIGITO)
								nPosG ++
								nDigitosG := Val(CTM->CTM_DIGITO)
								Exit
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
			EndIf
			
			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP
			
			nCampoLP	 := Ascan(aStruTMP,{|x| x[1]=="SLDLPANTDB"})
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"
				oMeter:SetTotal(TRBTMP->(RecCount()))
				oMeter:Set(0)
			EndIf
			
			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
				
				//Se nao considera apuracao de L/P sera verificado na propria query
				dbSelectArea("TRBTMP")
				If !lVlrZerado .And. lImpAntLP
					If TRBTMP->((SALDOANTDB - SLDLPANTDB) - (SALDOANTCR - SLDLPANTCR)) == 0 .And. ;
						TRBTMP->(SALDODEB-MOVLPDEB) == 0 .And. TRBTMP->(SALDOCRD-MOVLPCRD) == 0
						dbSkip()
						Loop
					EndIf
				ElseIf !lVlrZerado
					If TRBTMP->(SALDOANTDB - SALDOANTCR) == 0 .And. TRBTMP->SALDODEB == 0 .And. TRBTMP->SALDOCRD == 0
						dbSkip()
						Loop
					EndIf
				EndIf
				
				//Verificacao da  Data Final de Existencia da Entidade somente se imprime saldo zerado
				// e se realemten nao tiver saldo e movimento para a entidade. Caso tenha algum movimento
				//ou saldo devera imprimir.
				If lVlrZerado
					If lImpAntLP
						If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
							(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0)
							//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
							//relatorio for maior, nao ira imprimir a entidade.
							If  cAlias $ "CT7/CT3/CT4/CTI"
								If lCT1EXDTFIM .and. !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .and. !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTDEXDTFIM .and. !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If lCTHEXDTFIM .and. !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
						EndIf
					Else
						If (SALDOANTDB  == 0 .And. SALDOANTCR  == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0)
							If cAlias $ "CT7/CT3/CT4/CTI"
								If lCT1EXDTFIM .and. !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .and. !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTDEXDTFIM .and. !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
							
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If lCTHEXDTFIM .and. !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
				If cAlias == "CTU"
					Do Case
						Case cIdent	== "CTT"
							cCodigo	:= TRBTMP->CUSTO
						Case cIdent	== "CTD"
							cCodigo	:= TRBTMP->ITEM
						Case cIdent	== "CTH"
							cCodigo	:= TRBTMP->CLVL
					EndCase
				Else
					If lImpConta .Or. cAlias == "CT7"
						cCodigo	:= TRBTMP->CONTA
					Else
						If cAlias == "CT3"
							cCodigo	:= TRBTMP->CUSTO
						ElseIf cAlias == "CT4"
							cCodigo	:= TRBTMP->ITEM
						ElseIf cAlias == "CTI"
							cCodigo	:= TRBTMP->CLVL
						EndIf
					EndIf
					If cAlias == "CT3" .And. cHeader == "CTT"
						cCodGer	:= TRBTMP->CUSTO
					EndIf
				EndIf
				
				If !Empty(cSegmento)
					If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
						If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) )
							dbSkip()
							Loop
						EndIf
					Else
						If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
							Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
							dbSkip()
							Loop
						EndIf
					Endif
				EndIf
				
				//Caso faca filtragem por segmento gerencial,verifico se esta dentro
				//da solicitacao feita pelo usuario.
				If cAlias == "CT3" .And. cHeader == "CTT"
					If !Empty(cSegmentoG)
						If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
							If  !(Substr(cCodGer,nPosG,nDigitosG) $ (cFiltSegmG) )
								dbSkip()
								Loop
							EndIf
						Else
							If Substr(cCodGer,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
								Substr(cCodGer,nPosG,nDigitosG) > Alltrim(cSegFimG)
								dbSkip()
								Loop
							EndIf
						Endif
					EndIf
				EndIf
				
				If &("TRBTMP->("+cFILUSU+")")
					RecLock("cArqTMP",.T.)
					For nTRB := 1 to Len(aStruTMP)
						Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])
						If Subs(aStruTmp[nTRB][1],1,6) $ "SALDODEB/SALDOCRD/SALDOANTDB/SALDOANTCR/SLDLPANTCR/SLDLPANTDB/MOVLPDEB/MOVLPCRD" .And. nDivide > 0
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide
						EndIf
					Next
					
					If cAlias	== "CTU"
						Do Case
							Case cIdent	== "CTT"
								If Empty(TRBTMP->DESCCC)
									cArqTmp->DESCCC		:= TRBTMP->DESCCC01
								EndIf
							Case cIdent == "CTD"
								If Empty(TRBTMP->DESCITEM)
									cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							Case cIdent == "CTH"
								If Empty(TRBTMP->DESCCLVL)
									cArqTmp->DESCCLVL	:= TRBTMP->DESCCV01
								EndIf
						EndCase
					Else
						If lImpConta .or. cAlias == "CT7"
							If Empty(TRBTMP->DESCCTA)
								cArqTmp->DESCCTA	:= TRBTMP->DESCCTA01
							EndIf
						EndIf
						
						If cAlias == "CT4"
							If !lImp3Ent
								If cMoeda <> '01' .And. Empty(TRBTMP->DESCITEM)
									cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							EndIf
							
							If lImp3Ent	//Balancete CC / Conta / Item
								If Empty(TRBTMP->DESCCC)
									cArqTmp->DESCCC	:= TRBTMP->DESCCC01
								EndIf
								
								If TRBTMP->ALIAS == 'CT4'
									If Empty(TRBTMP->DESCITEM)
										cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
									EndIf
								EndIf
							EndIf
						EndIf
						
						If cAlias == "CTI" .And. lImp4Ent
							If !Empty(CLVL)
								If Empty(TRBTMP->DESCCLVL)
									cArqTmp->DESCCLVL	:= TRBTMP->DESCCV01
								EndIf
							EndiF
							
							If !Empty(ITEM)
								If Empty(TRBTMP->DESCITEM)
									cArqTmp->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							Endif
							
							If !Empty(CUSTO)
								If Empty(TRBTMP->DESCCC)
									cArqTmp->DESCCC		:= TRBTMP->DESCCC01
								EndIf
							EndIf
						EndIf
					EndIf
					
					//Se for Relatorio US Gaap
					If lUsGaap
						
						nSlAntGap	:= TRBTMP->(SALDOANTDB - SALDOANTCR)	// Saldo Anterior
						nSlAntGapD	:= TRBTMP->(SALDOANTDB)					// Saldo anterior debito
						nSlAntGapC	:= TRBTMP->(SALDOANTCR)					// Saldo anterior credito
						nSlAtuGap	:= TRBTMP->((SALDOANTDB+SALDODEB)- (SALDOANTCR+SALDOCRD))	// Saldo Atual
						nSlAtuGapD	:= TRBTMP->(SALDOANTDB+SALDODEB)					// Saldo Atual debito
						nSlAtuGapC	:= TRBTMP->(SALDOANTCR+SALDOCRD)					// Saldo Atual credito
						
						nSlDebGap	:= TRBTMP->((SALDOANTDB+SALDODEB) - SALDOANTDB)		// Saldo Debito
						nSlCrdGap	:= TRBTMP->((SALDOANTCR+SALDOCRD) - SALDOANTCR)		// Saldo Credito
						
						If cConsCrit == "5"	//Se for Criterio do Plano de Contas
							cCritPlCta	:= Ctr045Med(cMoedConv)
						EndIf
						
						If cConsCrit $ "123" .Or. (cConsCrit == "5" .And. cCritPlCta $ "123")
							If cConsCrit == "5"
								cArqTmp->SALDOANT	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGap)
								cArqTmp->SALDOANTDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapD)
								cArqTmp->SALDOANTCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)
								cArqTmp->SALDOATU	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGap)
								cArqTmp->SALDOATUDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGapD)
								cArqTmp->SALDOATUCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)
								cArqTmp->SALDODEB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlDebGap)
								cArqTmp->SALDOCRD	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlCrdGap)
							Else
								cArqTmp->SALDOANT	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGap)
								cArqTmp->SALDOANTDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapD)
								cArqTmp->SALDOANTCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)
								cArqTmp->SALDOATU	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGap)
								cArqTmp->SALDOATUDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGapD)
								cArqTmp->SALDOATUCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)
								cArqTmp->SALDODEB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlDebGap)
								cArqTmp->SALDOCRD	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlCrdGap)
							EndIf
						ElseIf cConsCrit == "4" .Or. (cConsCrit == "5" .And. cCritPlCta == "4")
							cArqTmp->SALDOANT	:= nSlAntGap/nTaxaConv
							cArqTmp->SALDOANTDB	:= nSlAntGapD/nTaxaConv
							cArqTmp->SALDOANTCR	:= nSlAntGapC/nTaxaConv
							cArqTmp->SALDOATU	:= nSlAtuGap/nTaxaConv
							cArqTmp->SALDOATUDB	:= nSlAtuGapD/nTaxaConv
							cArqTmp->SALDOATUCR	:= nSlAtuGapC/nTaxaConv
							cArqTmp->SALDODEB	:= nSlDebGap/nTaxaConv
							cArqTmp->SALDOCRD	:= nSlCrdGap/nTaxaConv
						EndIf
					EndIf
					
					
					If nCampoLP > 0
						cArqTmp->SALDOANTDB	:= SALDOANTDB - SLDLPANTDB
						cArqTmp->SALDOANTCR	:= SALDOANTCR - SLDLPANTCR
						cArqTmp->SALDODEB	:= SALDODEB - MOVLPDEB
						cArqTmp->SALDOCRD	:= SALDOCRD - MOVLPCRD
					EndIf
					cArqTmp->SALDOANT	:= SALDOANTCR-SALDOANTDB
					cArqTmp->SALDOATUDB	:= SALDOANTDB+SALDODEB
					cArqTmp->SALDOATUCR	:= SALDOANTCR+SALDOCRD
					cArqTmp->SALDOATU	:= SALDOATUCR-SALDOATUDB
					cArqTmp->MOVIMENTO	:= SALDOCRD-SALDODEB
					
					//Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.
					If ( lImpConta .Or. cAlias == "CT7") .And. lRecDesp0 .And. Subs(TRBTMP->CONTA,1,1) $ cRecDesp
						
						If cAlias == "CT7"
							aSldRecDes	:= SaldoCT7(TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.)
						ElseIf cAlias == "CT3" .And. cHeader == "CTT"
							aSldRecDes	:= SaldoCT3(TRBTMP->CONTA,TRBTMP->CUSTO,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.)
						ElseIf cAlias == "CT4" .And. cHeader == "CTD"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							aSldRecDes	:= SaldTotCT4(TRBTMP->ITEM,TRBTMP->ITEM,cCusIni,cCusFim,TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos)
						Elseif cAlias == "CTI" .And. cHeader == "CTH"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							
							cItIni  	:= ""
							cItFim   	:= Repl("z",aTamItem[1])
							
							aSldRecDes := SaldTotCTI(TRBTMP->CLVL,TRBTMP->CLVL,cItIni,cItFim,cCusIni,cCusFim,;
							TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos)
						EndIf
						
						If nDivide > 1
							For nCont := 1 To Len(aSldRecDes)
								aSldRecDes[nCont] := Round(NoRound((aSldRecDes[nCont]/nDivide),3),2)
							Next nCont
						EndIf
						
						nSldRDAtuD	:=	aSldRecDes[4]
						nSldRDAtuC	:=	aSldRecDes[5]
						nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD
						
						cArqTmp->SALDOANT 	-= nSldAtuRD
						cArqTmp->SALDOANTDB	-=	nSldRDAtuD
						cArqTmp->SALDOANTCR -=	nSldRDAtuC
						cArqTmp->SALDOATU   -= nSldAtuRD
						cArqTmp->SALDOATUDB -=	nSldRDAtuD
						cArqTmp->SALDOATUCR -=	nSldRdAtuC
					EndIf
					
					cArqTMP->(MsUnlock())
				EndIf
				TRBTMP->(dbSkip())
				If ValType(oMeter) == "O"
					nMeter++
					oMeter:Set(nMeter)
				EndIf
			Enddo
			
			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf
#ENDIF


dbSelectArea("cArqTmp")
dbSetOrder(1)

If cAlias $ 'CT3/CT4/CTI' //Se imprime CONTA+ ENTIDADE
	If !Empty(aSetOfBook[5])
		If !lImpConta	//Se for balancete de 1 entidade filtrada por conta
			If cAlias == "CT3"
				cIdent	:= "CTT"
			ElseIf cAlias == "CT4"
				cIdent	:= "CTD"
			ElseIf cAlias == "CTI"
				cIdent 	:= "CTH"
			EndIf
			// Monta Arquivo Lendo Plano Gerencial
			// Neste caso a filtragem de entidades contabeis é desprezada!
			U_XCtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,"CTU",;
			cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD)
			dbSetOrder(2)
		Else
			If lImpEntGer	//Se for balancete de Entidade (C.Custo/Item/Cl.Vlr por Entid. Gerencial)
				U_XCtPlEntGer(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,cHeader,;
				lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,cContaIni,cContaFim,;
				cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,lImpSint,;
				lRecDesp0,cRecDesp,dDtZeraRD,nDivide,lFiltraCC,lFiltraIt,lFiltraCV)
			Else
				MsgAlert(cMensagem)
				Return
			EndIf
		EndIf
	Else
		If cHeader == "CT1"	//Se for Balancete Conta/Entidade
			#IFNDEF TOP	//Se for top connect, atualiza sinteticas
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				U_XCtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
				cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
				cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
				nDivide,lVlrZerado,lNImpMov)
			#ELSE
				If TcSrvType() == "AS/400"
					// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
					CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
					cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
					cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
					nDivide,lVlrZerado,lNImpMov)
					
				EndIf
			#ENDIF
			//Atualizacao de sinteticas para codebase e topconnect
			If lImpSint	//Se atualiza sinteticas
				CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)
			EndIf
		Else
			If !lImp3Ent	.And. !lImp4Ent //Se não for Balancete CC / Conta / Item
				If lImpConta
					#IFNDEF TOP
						// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
						U_XCtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
						cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
						cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
						lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
						lRecDesp0,cRecDesp,dDtZeraRD)
					#ELSE
						If TcSrvType() == "AS/400"
							U_XCtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
							cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
							lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
							lRecDesp0,cRecDesp,dDtZeraRD)
						EndIf
					#ENDIF
					
					If lImpSint	//Se atualiza sinteticas
						u_xCtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)
					EndIf
					
				Else
					#IFNDEF TOP
						CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
						cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
						cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
						cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
						lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
						lRecDesp0,cRecDesp,dDtZeraRD)
					#ELSE
						If TcSrvType() == "AS/400"
							CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
							cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
							cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
							lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
							lRecDesp0,cRecDesp,dDtZeraRD)
						EndIf
					#ENDIF
					
					If lImpSint
						If cAlias == "CT3"
							cIdent := "CTT"
						ElseIf cAlias == "CT4"
							cIdent := "CTD"
						ElseIf cAlias == "CTI"
							cIdent := "CTH"
						EndIf
						CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
					EndIf
					
				EndIf
			Else	//Se for Balancete CC / Conta / Item
				If lImp3Ent
					#IFNDEF TOP
						CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
						cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
						cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
						lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado)
					#ELSE
						If TcSrvType() == "AS/400"
							CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
							cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
							lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado)
						EndIf
					#ENDIF
					If lImpSint
						Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)
					Endif
				ElseIf cAlias == "CTI" .And. lImp4Ent .And. cHeader == "CTT"
					#IFNDEF TOP
						CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
						cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
						cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
						lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
						nDivide,lVlrZerado)
					#ELSE
						If TcSrvType() == "AS/400" .or. lImpAntLP
							CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
							cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
							lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado)
						EndIf
					#ENDIF
					If lImpSint
						Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)
					Endif
				EndIf
			EndIf
		EndIf
	EndIf
Else
	If cAlias $ 'CTU/CT7' .Or. (!Empty(aSetOfBook[5]) .And. Empty(cAlias))		//So Imprime Entidade ou demonstrativos
		If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
			// Monta Arquivo Lendo Plano Gerencial
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,;
			cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,;
			lMovPeriodo)
			dbSetOrder(2)
		Else
			//Se nao for for Top Connect
			#IFNDEF TOP
				CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
				cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
				lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
				dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
				cRecDesp,dDtZeraRD,cMoedaDsc)
			#ELSE
				If TcSrvType() == "AS/400"
					CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
					dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
					cRecDesp,dDtZeraRD,cMoedaDsc)
				EndIf
			#ENDIF
			
			If lImpSint	//Se atualiza sinteticas
				Do Case
					Case cAlias =="CT7"
						//Atualizacao de sinteticas para codebase e topconnect
						CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cMoedaDsc)
					Case cAlias == "CTU"
						CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
				EndCase
			EndIf
			
			dbSelectArea("cArqTmp")
			
			If FieldPos("ORDEMPRN") > 0
				dbSelectArea("cArqTmp")
				IndRegua("cArqTmp",Left(cArqInd, 7) + "A","ORDEMPRN",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				If cAlias == "CT7"
					IndRegua("cArqTmp",Left(cArqInd, 7) + "B","SUPERIOR+CONTA",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				ElseIf cAlias == "CTU"
					If cIdent == "CTT"
						IndRegua("cArqTmp",Left(cArqInd, 7) + "B","CCSUP+CUSTO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
					ElseIf cIdent == "CTD"
						IndRegua("cArqTmp",Left(cArqInd, 7) + "B","ITSUP+ITEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
					ElseIf cIdent == "CTH"
						IndRegua("cArqTmp",Left(cArqInd, 7) + "B","CLSUP+CLVL",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
					EndIf
				EndIf
				DbClearIndex()
				dbSetIndex(cArqInd+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"A"+OrdBagExt())
				dbSetIndex(Left(cArqInd,7)+"B"+OrdBagExt())
				
				DbSetOrder(1)
				DbGoTop()
				While ! Eof()
					If cAlias == "CT7"
						If Empty(SUPERIOR)
							CtGerSup(CONTA, @nOrdem, cAlias)
						EndIf
					ElseIf cAlias == "CTU"
						If cIdent == "CTT"
							If Empty(CCSUP)
								CtGerSup(CUSTO, @nOrdem,"CTU","CTT")
							EndIf
						ElseIf cIdent == "CTD"
							If Empty(ITSUP)
								CtGerSup(ITEM, @nOrdem,"CTU","CTD")
							EndIf
						ElseIf cIdent == "CTH"
							If Empty(CLSUP)
								CtGerSup(CLVL, @nOrdem,"CTU","CTH")
							Endif
						EndIf
					EndIf
					DbSkip()
				Enddo
				DbSetOrder(2)
			Endif
		EndIf
	Else    	//Imprime Relatorios com 2 Entidades
		If !Empty(aSetOfBook[5])
			MsgAlert(cMensagem)
			Return
		Else
			If cAlias == 'CTY'		//Se for Relatorio de 2 Entidades filtrado pela 3a Entidade
				Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt)
			Else
				CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cFilUsu)
			EndIf
		EndIf
	Endif
EndIf

RestArea(aSaveArea)

Return cArqTmp


//////////////////////////////////////
USER Function xCT7BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cMoeda,cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,cMoedaDsc)

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT4_DEBITO")
Local cCampUSU		:= ""
Local aStrSTRU		:= {}
Local nStruLen		:= 0
Local nStr			:= 1

DEFAULT lImpAntLP := .F.
DEFAULT dDataLP	  := CTOD("  /  /  ")
DEFAULT cMoedaDsc	:= '01'

cQuery := " SELECT CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, "
cQuery += " 	CT1_CTASUP SUPERIOR, CT1_CLASSE TIPOCONTA, CT1_GRUPO GRUPO, "
If CtbExDtFim("CT1")
	cQuery += "     CT1_DTEXSF CT1DTEXSF, "
EndIf
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT1->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

If CtbUso("CT1_DESC"+cMoedaDsc)  .And. !Empty(cMoedaDsc)
	If cMoedaDsc = '01'
		cQuery += "		CT1_DESC01 DESCCTA, "
	Else
		cQuery += "		CT1_DESC"+cMoedaDsc+" DESCCTA, CT1_DESC01 DESCCTA01, "
	EndIf
Else
	If cMoeda == '01'
		cQuery += "		CT1_DESC01 DESCCTA, "
	Else
		cQuery += "		CT1_DESC"+cMoeda+" DESCCTA, CT1_DESC01 DESCCTA01,  "
	EndIf
EndIf

cQuery += " 		(SELECT SUM(CT7_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTDB, "
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT7_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "
EndIf
cQuery += " 	  	(SELECT SUM(CT7_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTCR, "
If lImpAntLP
	cQuery += " 	(SELECT SUM(CT7_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "
EndIf
cQuery += " 		(SELECT SUM(CT7_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDODEB, "
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT7_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf
cQuery += " 		(SELECT SUM(CT7_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
cQuery += "  SALDOCRD "
If lImpAntLP
	cQuery += ", 		(SELECT SUM(CT7_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL	= '"+xFilial("CT7")+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += "				AND CT7_LP = 'Z' AND ((CT7_DTLP <> ' ' AND CT7_DTLP >= '"+DTOS(dDataLP)+"') OR (CT7_DTLP = '' AND CT7_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif
cQuery += " 	AND ARQ.D_E_L_E_T_ = ' ' "


If !lVlrZerado .And. !lImpAntLP	//Se considerar posicao anterior LP sera verificado na gravacao do arquivo de trabalho
	cQuery += " 	AND	((SELECT ROUND(SUM(CT7_DEBITO),2)- ROUND(SUM(CT7_CREDIT),2) "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND CT7.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 			(SELECT SUM(CT7_DEBITO)  "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND CT7.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "
	cQuery += " 			(SELECT SUM(CT7_CREDIT)  "
	cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
	cQuery += " 			WHERE CT7_FILIAL = '"+xFilial("CT7")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT7_CONTA "
	cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT7_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT7_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND CT7.D_E_L_E_T_ = '')<> 0) "
Endif

cQuery := ChangeQuery(cQuery)

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])
If CtbExDtFim("CT1")
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)
EndIf

If lImpAntLP
	TcSetField("TRBTMP","SLDLPANTDB","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","SLDLPANTCR","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","MOVLPDEB","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","MOVLPCRD","N",aTamVlr[1],aTamVlr[2])
EndIf

RestArea(aAreaQry)

Return

///////////////////////////
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT3BlnQry ºAutor  ³Simone Mie Sato     º Data ³  26/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos Conta x    º±±
±±º          ³Centro de Custo                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XCT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,	cMoeda,;
cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUSU)

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT3_DEBITO")
Local cCampUSU		:= ""
Local aStrSTRU		:= {}
Local nStruLen		:= 0
Local nStr			:= 1

DEFAULT lImpAntLP	:= .F.
DEFAULT dDataLP		:= CTOD("  /  /  ")

cQuery := " SELECT CTT_CUSTO CUSTO,CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC01 DESCCTA,  	"
cQuery += " 	CT1_CTASUP SUPERIOR, CTT_RES CCRES, CT1_GRUPO GRUPO, CTT_DESC01 DESCCC, CT1_CLASSE TIPOCONTA,CTT_CLASSE TIPOCC,  	"
If CtbExDtFim("CT1")
	cQuery += "     CT1_DTEXSF CT1DTEXSF, "
EndIf
If CtbExDtFim("CTT")
	cQuery += "     CTT_DTEXSF CTTDTEXSF, "
EndIf
cQuery += " 	CTT_CCSUP CCSUP,  "
////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT1->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////
cQuery += " 	(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTDB, "
If lImpAntLP
	cQuery += " 	(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '')  SLDLPANTDB, "
EndIf
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTCR, "
If lImpAntLP
	cQuery += " 	(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "
EndIf
cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA      = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD     = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA  = CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDODEB, "

If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
	
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') MOVLPCRD, "
EndIf

cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOCRD "
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ, "+RetSqlName("CTT")+" ARQ2 "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND  ARQ2.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ2.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ2.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ2.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CENTRO DE CUSTO DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "
cQuery += " 	AND ARQ2.D_E_L_E_T_ = '' "

If !lVlrZerado .And. !lImpAntLP
	cQuery += " 	AND ((SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ2.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND ARQ.CT1_CONTA	= CT3_CONTA "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '')<>0) "
Endif

cQuery := ChangeQuery(cQuery)

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])

If CtbExDtFim("CT1")
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)
EndIf

If CtbExDtFim("CTT")
	TCSetField("TRBTMP","CTTDTEXSF","D",8,0)
EndIf

If lImpAntLP
	TcSetField("TRBTMP","SLDLPANTDB","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","SLDLPANTCR","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","MOVLPDEB","N",aTamVlr[1],aTamVlr[2])
	TcSetField("TRBTMP","MOVLPCRD","N",aTamVlr[1],aTamVlr[2])
EndIf

RestArea(aAreaQry)

Return


/////////////////////////////////////
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT3Bln1EntºAutor  ³Simone Mie Sato     º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos de  uma    º±±
±±º          ³Entidade filtrada pela conta.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Balancete de 1 entidade filtrada por conta.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function XCt3Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,;
cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
lRecDesp0,cRecDesp,dDtZeraRD)


Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT3_DEBITO")
Local cCampUSU		:= ""
Local aStrSTRU		:= {}
Local nStruLen		:= 0
Local nStr			:= 1
Local nTamRecDes	:= Len(Alltrim(cRecDesp))
Local nCont			:= 0

DEFAULT lImpAntLP	:= .F.
DEFAULT dDataLP		:= CTOD("  /  /  ")
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")

cQuery := " SELECT CTT_CUSTO CUSTO, CTT_RES CCRES,  CTT_DESC"+cMoeda+" DESCCC,  CTT_DESC01 DESCCC01, CTT_CLASSE TIPOCC,  	"
cQuery += " 	CTT_CCSUP CCSUP, "

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT1->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

cQuery += " 	(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
If !lImpAntLP .And. lRecDesp0
	For nCont	:= 1 to nTamRecDes
		If nCont == 1
			cQuery += "	 			AND ( (CT3_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		Else
			cQuery += "	 			AND  (CT3_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		EndIf
	Next
	cQuery += " OR "
	cQuery += " ( "
	For nCont	:= 1 to nTamRecDes
		cQuery += " (CT3_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%') AND "
	Next
	cQuery += " CT3_DATA > '" +DTOS(dDtZeraRD)+"') "
	cQuery += " ) "
EndIf
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTDB, "
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTDB, "
EndIf
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
If !lImpAntLP .And. lRecDesp0
	For nCont	:= 1 to nTamRecDes
		If nCont == 1
			cQuery += "	 			AND ( (CT3_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		Else
			cQuery += "	 			AND  (CT3_CONTA NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		EndIf
	Next
	cQuery += " OR "
	cQuery += " ( "
	For nCont	:= 1 to nTamRecDes
		cQuery += " (CT3_CONTA LIKE '"+Substr(cRecDesp,nCont,1)+"%') AND "
	Next
	cQuery += " CT3_DATA > '" +DTOS(dDtZeraRD)+"') "
	cQuery += " ) "
EndIf
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOANTCR, "
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  SLDLPANTCR, "
EndIf
cQuery += " 		(SELECT SUM(CT3_DEBITO) "
cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA      = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD     = '"+cSaldos+"' "
cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDODEB, "
If lImpAntLP
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPDEB, "
EndIf
cQuery += " 		(SELECT SUM(CT3_CREDIT) "
cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 			AND CT3.D_E_L_E_T_ = '') SALDOCRD "
If lImpAntLP
	cQuery += " 		, (SELECT SUM(CT3_CREDIT) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += "				AND CT3_LP = 'Z' AND ((CT3_DTLP <> ' ' AND CT3_DTLP >= '"+DTOS(dDataLP)+"') OR (CT3_DTLP = '' AND CT3_DATA >= '"+DTOS(dDataLP)+"'))"
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') "
	cQuery += "  MOVLPCRD "
EndIf
cQuery += " 	FROM "+RetSqlName("CTT")+" ARQ "
cQuery += " 	WHERE ARQ.CTT_FILIAL = '"+xFilial("CTT")+"' "
cQuery += " 	AND ARQ.CTT_CUSTO BETWEEN '"+cCCIni+"' AND '"+cCCFim+"' "
cQuery += " 	AND ARQ.CTT_CLASSE = '2' "

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ARQ.CTT_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CENTRO DE CUSTO DO MESMO SETOFBOOKS
Endif

cQuery += " 	AND ARQ.D_E_L_E_T_ = '' "

If !lVlrZerado .And. !lImpAntLP	//Se considerar posicao anterior LP sera verificado na gravacao do arquivo de trabalho
	cQuery += " 	AND ((SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA <  '"+DTOS(dDataIni)+"' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_DEBITO) "
	cQuery += "			 	FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL = '"+xFilial("CT3")+"'  "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "
	cQuery += " 		(SELECT SUM(CT3_CREDIT) "
	cQuery += " 			FROM "+RetSqlName("CT3")+" CT3 "
	cQuery += " 			WHERE CT3_FILIAL	= '"+xFilial("CT3")+"' "
	cQuery += " 			AND CT3_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "
	cQuery += " 			AND ARQ.CTT_CUSTO	= CT3_CUSTO "
	cQuery += " 			AND CT3_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CT3_TPSALD = '"+cSaldos+"' "
	cQuery += " 			AND CT3_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
	cQuery += " 			AND CT3.D_E_L_E_T_ = '') <> 0) "
Endif

cQuery := ChangeQuery(cQuery)

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])


RestArea(aAreaQry)

Return

///////////////////////////////
USER Function XCtbPlGeren(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntFil1,cEntFil2,aGeren,lImpSint,;
lRecDesp0,cRecDesp,dDtZeraRD,lMovPeriodo)

Local aSaveArea := GetArea()
Local aSaldoAnt
Local aSaldoAtu
Local aSaldoSEM
Local aSaldoPER

Local cConta
Local cCodNor
Local cNormal
Local cContaSup
Local cDesc
Local cPlanGer := aSetOfBook[5]
Local cZZZCT1	:= Repl("Z",Len(Criavar("CT1_CONTA")))
Local cZZZCTT	:= Repl("Z",Len(Criavar("CTT_CUSTO")))
Local cZZZCTD	:= Repl("Z",Len(Criavar("CTD_ITEM")))
Local cZZZCTH	:= Repl("Z",Len(Criavar("CTH_CLVL")))
Local cContaIni	:= Space(Len(Criavar("CT1_CONTA")))
Local cContaFim	:= cZZZCT1
Local cCustoIni	:= Space(Len(Criavar("CTT_CUSTO")))
Local cCustoFim	:= cZZZCTT
Local cItemIni	:= Space(Len(Criavar("CTD_ITEM")))
Local cItemFim	:= cZZZCTD
Local cClvlIni	:= Space(Len(Criavar("CTH_CLVL")))
Local cClVlFim	:= cZZZCTH

Local cCtaFil1
Local cCtaFil2
Local cCCFil1
Local cCCFil2
Local cItemFil1
Local cItemFil2
Local cCLVLFil1
Local cCLVLFil2
Local lConta 	:= .F.
Local lCusto	:= .F.
Local lItem		:= .F.
Local lClasse	:= .F.

Local nReg
Local nFator	 := 1
Local nPos		:= 0
Local nSaldoAnt := 0
Local nSaldoDeb := 0
Local nSaldoCrd := 0

Local nSaldoAtu := 0		// Saldo ate a data final
Local nSaldoSEM := 0		// Saldo ate a variavel dSemestre
Local nSaldoPER := 0		// Saldo ate a variavel dPeriodo0
Local nMOVIMPER	:= 0
Local nMovPerAnt	:= 0	//	Movimento do periodo anterior

Local nSaldoAntD:= 0
Local nSaldoAntC:= 0
Local nSaldoAtuD:= 0
Local nSaldoAtuC:= 0
Local lSemestre := FieldPos("SALDOSEM") > 0		// Saldo por semestre
Local lPeriodo0 := FieldPos("SALDOPER") > 0		// Saldo dois periodos anteriores

Local lComNivel := FieldPos("NIVEL") > 0		// Nivel hierarquico
Local lColuna	:= FieldPos("COLUNA") > 0
Local nNivel	:= 0
Local nContador	:= 0
Local cFilCTS	:= xFilial("CTS")
Local lMovCusto := CtbMovSaldo("CTT")
Local lMovItem	:= CtbMovSaldo("CTD")
Local lMovClass := CtbMovSaldo("CTH")
Local nA:=1
Local aFator:={}
Local nFatorS:=1
Local aAreaCTS:={}
DEFAULT lImpSint	:= .T.
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lMovPeriodo := .F.

lTRegCts	:= Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
cAlias		:= Iif(cAlias == Nil,"",cAlias)
cIdent		:= Iif(cIdent == Nil,"",cIdent)
lVlrZerado	:= Iif(lVlrZerado == Nil,.T.,lVlrZerado)

If aGeren != Nil
	cCtaFil1  :=	If(MsAscii(aGeren[1])== 13,"",aGeren[1])
	cCtaFil2  :=	If(MsAscii(aGeren[2])== 13,"",aGeren[2])
	cCCFil1   :=	If(MsAscii(aGeren[3])== 13,"",aGeren[3])
	cCCFil2   :=	If(MsAscii(aGeren[4])== 13,"",aGeren[4])
	cItemFil1 :=	If(MsAscii(aGeren[5])== 13,"",aGeren[5])
	cItemFil2 :=	If(MsAscii(aGeren[6])== 13,"",aGeren[6])
	cCLVLFil1 :=	If(MsAscii(aGeren[7])== 13,"",aGeren[7])
	cCLVLFil2 :=	If(MsAscii(aGeren[8])== 13,"",aGeren[8])
EndIf
lCT1Fil := .F.
lCTTFil := .F.
lCTDFil	:= .F.
lCTHFil	:= .F.

// Filtragem da entidade compositora do Plano Gerencial (Centro de Custo da Getdados)
If !Empty(cCtaFil1) .Or. !Empty(cCtaFil2)
	lCT1Fil := .T.
	If cCtaFil1 > cContaIni
		cContaIni := cCtaFil1
	EndIf
	If cCtaFil2 < cContaFim
		cContaFim := cCtaFil2
	EndIf
EndIf

// Filtragem da entidade compositora do Plano Gerencial (Centro de Custo da Getdados)
If lMovCusto
	If !Empty(cCCFil1) .Or. !Empty(cCCFil2)
		lCTTFil := .T.
		If cCCFil1 > cCustoIni
			cCustoIni := cCCFil1
		EndIf
		If cCCFil2 < cCustoFim
			cCustoFim := cCcFil2
		EndIf
	EndIf
EndIf
/* Observacoes:
C.Custo do Plano Gerencial
001	002	003

C.Custo Informado no Filtro
000	001	002	003	004

O relatorio so podera imprimir: 001 002 003	*/

// Filtragem da entidade compositora do Plano Gerencial (Item Contabil da Getdados)
If lMovItem
	If !Empty(cItemFil1) .Or. !Empty(cItemFil2)
		lCTDFil := .T.
		If cItemFil1 > cItemIni
			cItemIni := cItemFil1
		EndIf
		If cItemFil2 < cItemFim
			cItemFim := cItemFil2
		EndIf
	EndIf
EndIf

// Filtragem da entidade compositora do Plano Gerencial (Classe de Valor da Getdados)
If lMovClass
	If !Empty(cCLVLFil1) .Or. !Empty(cCLVLFil2)
		lCTHFil := .T.
		If cCLVLFil1 > cClVlIni
			cClVlIni := cClVlFil1
		EndIf
		If cCLVLFil2 < cClVlFim
			cClVlFim := cClVlFil2
		EndIf
	EndIf
EndIf

dbSelectArea("CTS")
If ValType(oMeter) == "O"
	oMeter:nTotal := CTS->(RecCount())
EndIf
dbSetOrder(1)

MsSeek(cFilCTS+cPlanGer,.T.)

While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And.;
	CTS->CTS_CODPLA == cPlanGer
	
	If CTS->CTS_CLASSE == "1"// .And. (! CTS->CTS_IDENT $ "3456")
		dbSkip()
		Loop
	EndIf
	
	//Efetua o filtro dos parametros considerando o plano gerencial.
	If !Empty(cEntFil1) .Or. !Empty(cEntFil2)
		If CTS->CTS_CONTAG < cEntFil1 .Or. CTS->CTS_CONTAG > cEntFil2
			dbSkip()
			Loop
		EndIf
	EndIf
	// Recarrega variáveis
	lConta 	:= .F.
	lCusto	:= .F.
	lItem	:= .F.
	lClasse	:= .F.
	
	// Grava conta analitica
	cConta 	:= CTS->CTS_CONTAG
	cDesc	:= CTS->CTS_DESCCG
	cOrdem	:= CTS->CTS_ORDEM
	
	nSaldoAnt 	:= 0	// Zero as variaveis para acumular
	nSaldoDeb 	:= 0
	nSaldoCrd 	:= 0
	
	nSaldoAtu 	:= 0
	nSaldoSEM 	:= 0
	nSaldoPer	:= 0
	
	nSaldoAntD	:= 0
	nSaldoAntC	:= 0
	nSaldoAtuD	:= 0
	nSaldoAtuC	:= 0
	nMOVIMPER	:= 0
	nMovPerAnt	:= 0
	dbSelectArea("CTS")
	dbSetOrder(1)
	
	While !Eof() .And. CTS->CTS_FILIAL == cFilCTS .And.;
		CTS->CTS_CODPLA == cPlanGer  .And. CTS->CTS_ORDEM	== cOrdem
		aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoSEM	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoPER	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		
		lClasse := .F.
		lItem	:= .F.
		lCusto	:= .F.
		lConta	:= .F.
		
		If !lCTHFil
			If !Empty(CTS->CTS_CTHINI) .Or. !Empty(CTS->CTS_CTHFIM)		// Saldo a partir da classe
				cClVlIni	:= CTS->CTS_CTHINI
				cClVlFim	:= CTS->CTS_CTHFIM
				lClasse := .T.
			Else
				cCLVLIni	:= ""
				cCLVLFim	:= cZZZCTH
			EndIf
		Else
			lClasse := .T.
		Endif
		
		If !lCTDFil
			If !Empty(CTS->CTS_CTDINI) .Or. !Empty(CTS->CTS_CTDFIM)	// Saldo a partir do Item
				cItemIni	:= CTS->CTS_CTDINI
				cItemFim	:= CTS->CTS_CTDFIM
				lItem := .T.
			Else
				cItemIni	:= ""
				cItemFim	:= cZZZCTD
			EndIf
		Else
			lItem	:= .T.
		Endif
		
		If !lCTTFil
			If !Empty(CTS->CTS_CTTINI) .Or. !Empty(CTS->CTS_CTTFIM)	// Saldo a partir do C.Custo
				cCustoIni	:= CTS->CTS_CTTINI
				cCustoFim	:= CTS->CTS_CTTFIM
				lCusto := .T.
			Else
				cCustoIni	:= ""
				cCustoFim	:= cZZZCTT
			EndIf
		Else
			lCusto	:= .T.
		Endif
		
		If !lCT1Fil
			If !Empty(CTS->CTS_CT1INI) .Or. !Empty(CTS->CTS_CT1FIM)	// Saldo a partir da Conta
				cContaIni	:= CTS->CTS_CT1INI
				cContaFim	:= CTS->CTS_CT1FIM
				lConta := .T.
			Else
				cContaIni	:= ""
				cContaFim	:= cZZZCT1
			EndIf
		Else
			lConta	:= .T.
		EndIf
		If lClasse .and. lMovClass
			aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
			cItemFim,cCustoIni,cCustoFim,cContaIni,;
			cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			
			aSaldoAtu := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
			cItemFim,cCustoIni,cCustoFim,cContaIni,;
			cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			If lSemestre
				aSaldoSem := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
				cItemFim,cCustoIni,cCustoFim,cContaIni,;
				cContaFim,dSemestre,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
				cItemFim,cCustoIni,cCustoFim,cContaIni,;
				cContaFim,dPeriodo0,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
		ElseIf lItem .and. lMovItem
			aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
			cCustoFim,cContaIni,cContaFim,;
			dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			
			aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
			cCustoFim,cContaIni,cContaFim,;
			dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			If lSemestre
				aSaldoSem := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
				cCustoFim,cContaIni,cContaFim,;
				dSemestre,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
			If lPeriodo0
				aSaldoPEr := SaldTotCT4(cItemIni,cItemFim,cCustoIni,;
				cCustoFim,cContaIni,cContaFim,;
				dPeriodo0,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
		ElseIf lCusto .and. lMovCusto
			aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
			cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			aSaldoAtu := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
			cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			
			If lSemestre
				aSaldoSem := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
				cContaFim,dSemestre,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCT3(cCustoIni,cCustoFim,cContaIni,;
				cContaFim,dPeriodo0,cMoeda,CTS->CTS_TPSALD,,,,,lImpAntLP,dDataLP)
			Endif
		ElseIf lConta
			aSaldoAnt := SaldTotCT7(cContaIni,cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,,lRecDesp0,cRecDesp,dDtZeraRD)
			aSaldoAtu := SaldTotCT7(cContaIni,cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,,lRecDesp0,cRecDesp,dDtZeraRD)
			If lSemestre
				aSaldoSem := SaldTotCT7(cContaIni,cContaFim,dSemestre,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP)
			Endif
			If lPeriodo0
				aSaldoPer := SaldTotCT7(cContaIni,cContaFim,dPeriodo0,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP)
			Endif
		EndIf
		
		If aSetOfBook[9] > 1	// Divisao por fator
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] := Round(NoRound((aSaldoAnt[nPos]/aSetOfBook[9]),3),2)
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] := Round(NoRound((aSaldoAtu[nPos]/aSetOfBook[9]),3),2)
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] := Round(NoRound((aSaldoSem[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] := Round(NoRound((aSaldoPer[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
		Endif
		
		If Left(CTS->CTS_FORMUL, 7) == "ROTINA="
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			nFator := &(Subs(CTS->CTS_FORMUL, 8))
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] *= nFator
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] *= nFator
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] *= nFator
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] *= nFator
				Next
			Endif
		Elseif Left(CTS->CTS_FORMUL,6 ) == "SALDO="
			nLSldAnt := Len(aSaldoAnt)
			nLSldAtu := Len(aSaldoAtu)
			nLSldSem := Len(aSaldoSem)
			nLSldPer := Len(aSaldoPer)
			nFator := &(Subs(CTS->CTS_FORMUL, 7))
			For nPos := 1 To nLSldAnt
				aSaldoAnt[nPos] := nFator
			Next
			For nPos := 1 To nLSldAtu
				aSaldoAtu[nPos] := nFator
			Next
			If lSemestre
				For nPos := 1 To nLSldSem
					aSaldoSem[nPos] := nFator
				Next
			Endif
			If lPeriodo0
				For nPos := 1 To nLSldPer
					aSaldoPer[nPos] := nFator
				Next
			Endif
		Endif
		
		// Calculos com os Fatores
		If CTS->CTS_IDENT = "1"				// Somo os saldos
			nSaldoAnt 	+= aSaldoAnt[6]		// Saldo Anterior
			nSaldoAtu 	+= aSaldoAtu[1]		// Saldo Atual
			If lSemestre
				nSaldoSem += aSaldoSEM[1]	// Saldo Semestre
			Endif
			If lPeriodo0
				nSaldoPer += aSaldoPER[1]	// Saldo variavel dPeriodo0
			Endif
			// Calculando o Movimento do periodo anterior
			If lMovPeriodo
				nMovPerAnt += ( (aSaldoAnt[8] - aSaldoAnt[7]) - (aSaldoPer[8] - aSaldoPer[7]) )
			EndIf
			
			nSaldoAntD 	+= aSaldoAnt[7]
			nSaldoAntC 	+= aSaldoAnt[8]
			
			nSaldoAtuD 	+= aSaldoAtu[4]
			nSaldoAtuC 	+= aSaldoAtu[5]
			
			nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
			nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
			
		ElseIf CTS->CTS_IDENT = "2"			// Subtraio os saldos
			nSaldoAnt 	-= aSaldoAnt[6]		// Saldo Anterior
			nSaldoAtu 	-= aSaldoAtu[1]		// Saldo Atual
			If lSemestre
				nSaldoSem -= aSaldoSEM[1]	// Saldo Semestre
			Endif
			If lPeriodo0
				nSaldoPer -= aSaldoPER[1]	// Saldo Periodo determinado
			Endif
			// Calculando o Movimento do periodo anterior
			If lMovPeriodo
				nMovPerAnt -= ( (aSaldoAnt[8] - aSaldoAnt[7]) - (aSaldoPer[8] - aSaldoPer[7]) )
			EndIf
			
			nSaldoAntD 	-= aSaldoAnt[7]
			nSaldoAntC 	-= aSaldoAnt[8]
			
			nSaldoAtuD 	-= aSaldoAtu[4]
			nSaldoAtuC 	-= aSaldoAtu[5]
			
			nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
			nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
			
		EndIf
		
		nMOVIMPER += (aSaldoAnt[5] - aSaldoPer[8]) - (aSaldoAnt[4] - aSaldoPer[7])
		
		dbSelectArea("CTS")
		dbSetOrder(1)
		nReg := Recno()
		dbSkip()
		
		If lTRegCts .And. CTS_COLUNA > 0	// A coluna 0 nao respeita desmembramento
			Exit
		Endif
	EnddO
	
	dbSelectArea("CTS")
	dbSetOrder(2)
	dbGoTo(nReg)
	cCodNor := CTS->CTS_NORMAL
	
	If !lVlrZerado .And. (nSaldoCrd-nSaldoDeb = 0 .And. nSaldoAnt == 0 .And. nSaldoAtu == 0) .And. ;
		(nSaldoDeb = 0 .And. nSaldoCRD = 0)
		///DbDelete()			/// RETIRADO DELETE
		
		dbSelectArea("CTS")
		dbSetOrder(1)
		dbGoTo(nReg)
		dbSkip()
		Loop					/// SÓ INCLUI NO TMP SE O SALDO NÃO ESTIVER ZERADO (NAO PRECISA ATUALIZAR SUPERIORES)
	EndIf
	
	dbSelectArea("cArqTmp")
	dbSetOrder(1)
	If !MsSeek(cConta)
		dbAppend()
		If cAlias = 'CTU'
			Do Case
				Case cIdent	= 'CTT'
					Replace CUSTO 	With  cConta
					Replace DESCCC	With cDesc
					Replace TIPOCC 	With CTS->CTS_CLASSE
				Case cIdent = 'CTD'
					Replace ITEM 		With cConta
					Replace DESCITEM    With cDesc
					Replace TIPOITEM	With CTS->CTS_CLASSE
				Case cIdent = 'CTH'
					Replace CLVL		With cConta
					Replace DESCCLVL	With cDesc
					Replace TIPOCLVL	With CTS->CTS_CLASSE
			EndCase
		Else
			Replace CONTA 		With cConta
			Replace DESCCTA    	With cDesc
		EndIf
		Replace SUPERIOR  	With CTS->CTS_CTASUP
		Replace TIPOCONTA 	With CTS->CTS_CLASSE
		Replace NORMAL    	With CTS->CTS_NORMAL
		Replace ORDEM		With CTS->CTS_ORDEM
		Replace IDENTIFI	With CTS->CTS_IDENT
		If lColuna
			Replace COLUNA  With CTS->CTS_COLUNA
		Endif
		
		If lTRegCts
			CT1->(DbSeek(xFilial("CT1") + CTS->CTS_CT1INI))
			Replace DESCORIG 	With &("CT1->CT1_DESC" + cMoeda),;
			TIPOCONTA 	With CT1->CT1_CLASSE,;
			NORMAL    	With CT1->CT1_NORMAL
		Endif
	EndIf
	
	If Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
		Replace ("cArqTmp")->DESCCTA With 	AllTrim(("cArqTmp")->DESCCTA) + Space(1) +;
		&(Subs(CTS->CTS_FORMUL, 7))
	Endif
	
	dbSelectArea("cArqTmp")
	Replace	SALDOANT With nSaldoAnt			// Saldo Anterior
	Replace SALDOATU With nSaldoAtu			// Saldo Atual
	
	Replace SALDOATUDB With nSaldoAtuD		//Saldo Atual Devedor
	Replace SALDOATUCR With nSaldoAtuC		//Saldo Atual Credor
	
	If lSemestre
		Replace SALDOSEM With nSaldoSEM		// Saldo Semestre
	Endif
	
	If lPeriodo0	// Saldo periodo determinado
		Replace SALDOPER 	With nSaldoPER
		Replace MOVIMPER  	With nMOVIMPER
	Endif
	
	If nSaldoDeb < 0 //.And. cCodNor == "1"
		Replace SALDOCRD	With nSaldoDeb
	ElseIf nSaldoDeb >= 0 //.And. cCodNor == "1"
		Replace SALDODEB	With nSaldoDeb
	EndIf
	If nSaldoCrd < 0// .And. cCodNor == "2"
		Replace SALDODEB	With nSaldoCrd
	ElseIf nSaldoCrd >= 0 //.And. cCodNor == "2"
		Replace SALDOCRD	With nSaldoCrd
	EndIf
	
	Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
	
	If lMovPeriodo
		Replace MOVPERANT With nMovPerAnt
	EndIf
	If lComNivel
		aNivel := {}
		Aadd(aNivel, Recno())
	Endif
	
	If lImpSint
		dbSelectArea("CTS")
		dbSetOrder(2)
		// Grava contas sinteticas
		If !Empty(CTS->CTS_CTASUP)
			While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And. ;
				CTS->CTS_CODPLAN == cPlanGer
				
				cContaSup 	:= CTS->CTS_CTASUP
				
				dbSelectArea("CTS")
				dbSetOrder(2)
				If MsSeek(cFilCTS+cPlanGer+cContaSup)
					cDesc 	:= CTS->CTS_DESCCG
					cNormal := CTS->CTS_NORMAL
				Else
					cNormal	:= cCodNor
				EndIf
				
				dbSelectArea("cArqTmp")
				dbSetOrder(1)
				If !MsSeek(cContaSup)
					dbAppend()
					If cAlias = 'CTU'
						Do Case
							Case cIdent = 'CTT'
								Replace CUSTO 		With cContaSup
								Replace DESCCC		With cDesc
								Replace TIPOCC		With CTS->CTS_CLASSE
							Case cIdent	= 'CTD'
								Replace ITEM 		With cContaSup
								Replace DESCITEM	With cDesc
								Replace TIPOITEM	With CTS->CTS_CLASSE
							Case cIdent = 'CTH'
								Replace CLVL 		With cContaSup
								Replace DESCCLVL	With cDesc
								Replace TIPOCLVL	With CTS->CTS_CLASSE
						EndCase
					Else
						Replace CONTA	With cContaSup
						Replace DESCCTA With cDesc
					EndIf
					Replace SUPERIOR  	With CTS->CTS_CTASUP
					Replace TIPOCONTA	With CTS->CTS_CLASSE
					Replace NORMAL   	With CTS->CTS_NORMAL
					Replace ORDEM		With CTS->CTS_ORDEM
					Replace IDENTIFI	With CTS->CTS_IDENT
					If lColuna
						Replace COLUNA  With CTS->CTS_COLUNA
					Endif
					If lTRegCts
						CT1->(DbSeek(xFilial("CT1") + CTS->CTS_CT1INI))
						Replace DESCORIG 	With &("CT1->CT1_DESC" + cMoeda),;
						TIPOCONTA 	With CT1->CT1_CLASSE,;
						NORMAL    	With CT1->CT1_NORMAL
					Endif
					aAreaCTS:=CTS->(GetArea())
					While CTS->(!EOF()) .AND. cFilCTS+cPlanGer+cContaSup ==  xFilial("CTS")+CTS->CTS_CODPLAN +CTS->CTS_CONTAG
						
						If Left(CTS->CTS_FORMUL, 7) == "ROTINA="
							nFatorS := &(Subs(CTS->CTS_FORMUL, 8))
							Aadd(aFator,{Recno(),nFatorS," ",.F.,0})
						ElseIf Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
							Aadd(aFator,{Recno(),1,Alltrim(&(Subs(CTS->CTS_FORMUL, 7))),.F.,0 })
						ElseIf Left(CTS->CTS_FORMUL,6 ) == "SALDO="
							nFatorS := &(Subs(CTS->CTS_FORMUL, 7))
							Aadd(aFator,{Recno(),1," ",.T.,nFatorS})
							
						EndIf
						
						CTS->(Dbskip())
					EndDo
					CTS->(RestArea(aAreaCTS))
				EndIf
				
				Replace	SALDOANT With SALDOANT + nSaldoAnt			// Saldo Anterior
				Replace SALDOATU With SALDOATU + nSaldoAtu			// Saldo Atual
				
				Replace SALDOATUDB With SALDOATUDB + nSaldoAtuD		//Saldo Atual Devedor
				Replace SALDOATUCR With SALDOATUCR + nSaldoAtuC		//Saldo Atual Credor
				
				If nSaldoDeb < 0 //.And. cNormal == "1"
					Replace SALDOCRD	With SALDOCRD + nSaldoDeb
				ElseIf nSaldoDeb >= 0 //.And. cNormal == "1"
					Replace SALDODEB	With SALDODEB + nSaldoDeb
				EndIf
				If nSaldoCrd < 0 //.And. cNormal == "2"
					Replace SALDODEB	With SALDODEB + nSaldoCrd
				ElseIf nSaldoCrd >= 0 //.And. cNormal == "2"
					Replace SALDOCRD	With SALDOCRD + nSaldoCrd
				EndIf
				
				//				Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
				Replace MOVIMENTO With SALDOCRD-SALDODEB
				
				If lSemestre		// Saldo por semestre
					Replace SALDOSEM With SALDOSEM + nSaldoSEM
				Endif
				If lPeriodo0		// Saldo periodo determinado
					Replace SALDOPER With SALDOPER + nSaldoPER
				Endif
				
				If lMovPeriodo		// Movimento periodo anterior
					Replace MOVPERANT With MOVPERANT + nMovPerAnt
				EndIf
				If lComNivel
					Aadd(aNivel, Recno())
				Endif
				
				dbSelectArea("CTS")
				If !Eof() .And. Empty(CTS->CTS_CTASUP)
					dbSelectArea("cArqTmp")
					Replace NIVEL1 With .T.
					dbSelectArea("CTS")
					Exit
				EndIf
			EndDo
			
			If lComNivel
				dbSelectArea("cArqTmp")
				nContador 	:= 1
				For nNivel 	:= Len(aNivel) To 1 Step -1
					DbGoto(aNivel[nNivel])
					Replace NIVEL With nContador ++
				Next
			Endif
			
		EndIf
	Endif
	
	dbSelectArea("CTS")
	dbSetOrder(1)
	dbGoTo(nReg)
	dbSkip()
	
EndDo
dbSelectArea("cArqTmp")
If Len(aFator) >0
	For nA:=1 To Len(aFator)
		Dbgoto(aFator[Na][1])
		RecLock( "cArqTmp", .f. )
		Replace	SALDOANT 	With SALDOANT * aFator[Na][2]
		Replace SALDOATU 	With SALDOATU * aFator[Na][2]
		Replace SALDOATUDB 	With SALDOATUDB * aFator[Na][2]
		Replace SALDOATUCR 	With SALDOATUCR * aFator[Na][2]
		Replace SALDOCRD	With SALDOCRD * aFator[Na][2]
		Replace SALDODEB	With SALDODEB * aFator[Na][2]
		Replace SALDOCRD	With SALDOCRD * aFator[Na][2]
		Replace MOVIMENTO 	With MOVIMENTO * aFator[Na][2]
		If lSemestre
			Replace SALDOSEM 	With SALDOSEM * aFator[Na][2]
		EndIf
		If lPeriodo0
			Replace SALDOPER 	With SALDOPER * aFator[Na][2]
			Replace MOVPERANT 	With MOVPERANT * aFator[Na][2]
		EndIf
		If aFator[Na][4]
			Replace	SALDOANT 	With aFator[Na][5]
			Replace SALDOATU 	With aFator[Na][5]
			Replace SALDOATUDB 	With aFator[Na][5]
			Replace SALDOATUCR 	With aFator[Na][5]
			Replace SALDOCRD	With aFator[Na][5]
			Replace SALDODEB	With aFator[Na][5]
			Replace SALDOCRD	With aFator[Na][5]
			Replace MOVIMENTO 	With aFator[Na][5]
			If lSemestre
				Replace SALDOSEM 	With aFator[Na][5]
			EndIf
			If lPeriodo0
				Replace SALDOPER 	With aFator[Na][5]
				Replace MOVPERANT 	With aFator[Na][5]
			EndIf
		EndIf
		
		Replace DESCCTA With 	Alltrim(DESCCTA)+" "+Alltrim(aFator[Na][3])
		MsUnlock()
		
	Next
EndIf

RestArea(aSaveArea)

Return


////////////////////////
USER Function XCtPlEntGer(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
cAlias,cHeader,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,;
cEntGerIni,cEntGerFim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,;
lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,nDivide,lFiltraCC,lFiltraIt,lFiltraCv)

Local aSaveArea := GetArea()
Local aSaldoAnt	:= {}
Local aSaldoAtu	:= {}

Local cFilCTS	:= xFilial("CTS")
Local cPlanGer	:= aSetOfBook[5]
Local cDescEnt	:= ""

Local cCodNor	:= ""
Local cChave	:= ""
Local cConta 	:= ""
Local cDesc		:= ""
Local cDescS 	:= ""
Local cOrdem	:= ""
Local cCpoCod	:= ""
Local cCodRes	:= ""
Local cContaIni	:= ""
Local cContaFim	:= ""
Local cCCOfiIni	:= cCCIni
Local cCCOfiFim	:= cCCFim
Local cItOfiIni	:= cItemIni
Local cItOfiFim	:= cItemFim
Local cCVOfiIni	:= cClVlIni
Local cCVOfiFim	:= cClVlFim

Local nPos			:= 0
Local nNivel		:= 0
Local nReg			:= 0
Local nRegCTS		:= 0
Local nSaldoAnt 	:= 0
Local nSaldoDeb 	:= 0
Local nSaldoCrd 	:= 0
Local nSaldoAtu 	:= 0
Local nSaldoAntD	:= 0
Local nSaldoAntC	:= 0
Local nSaldoAtuD	:= 0
Local nSaldoAtuC	:= 0
Local nLSldAnt		:= 0
Local nLSldAtu		:= 0

Local lComNivel 	:= FieldPos("NIVEL") > 0		// Nivel hierarquico
Local aRet			:= {.T.,"","","","","",""}
Local lFiltraEnt	:= IIf(ExistBlock("FILTRAENT"),.T.,.F.)

If cHeader	== "CTT"
	cCpoCod	:= "CUSTO"
ElseIf cHeader == "CTD"
	cCpoCod	:= "ITEM"
ElseIf cHeader == "CTH"
	cCpoCod	:= "CLVL"
EndIf

dbSelectArea("CTS")
If ValType(oMeter) == "O"
	oMeter:nTotal := CTS->(RecCount())
EndIf
dbSetOrder(1)

MsSeek(cFilCTS+cPlanGer,.T.)

While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And.;
	CTS->CTS_CODPLA == cPlanGer
	
	If CTS->CTS_CLASSE == "1"
		dbSkip()
		Loop
	EndIf
	
	//Efetua o filtro dos parametros considerando o plano gerencial.
	If !Empty(cEntGerIni) .Or. !Empty(cEntGerFim)
		If CTS->CTS_CONTAG < cEntGerIni .Or. CTS->CTS_CONTAG > cEntGerFim
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If lFiltraEnt
		
		cCCIni		:= cCCOfiIni
		cCCFim		:= cCCOfiFim
		cItemIni	:= cItOfiIni
		cItemFim	:= cItOfiFim
		cClVlIni	:= cCVOfiIni
		cClVlFim	:= cCVOfiFim
		
		aRet	:= ExecBlock("FILTRAENT",.F.,.F.,{cHeader,lFiltraCC,lFiltraIt,lFiltraCV,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim})
		
		If !aRet[1]
			dbSkip()
			Loop
		Else
			cCCIni		:= aRet[2]
			cCCFim		:= aRet[3]
			cItemIni	:= aRet[4]
			cItemFim	:= aRet[5]
			cClVlIni	:= aRet[6]
			cClVlFim	:= aRet[7]
		EndIf
	EndIf
	
	// Grava conta analitica
	cConta 	:= CTS->CTS_CONTAG
	cDesc	:= CTS->CTS_DESCCG
	cOrdem	:= CTS->CTS_ORDEM
	
	nSaldoAnt 	:= 0	// Zero as variaveis para acumular
	nSaldoDeb 	:= 0
	nSaldoCrd 	:= 0
	
	nSaldoAtu 	:= 0
	nSaldoAntD	:= 0
	nSaldoAntC	:= 0
	nSaldoAtuD	:= 0
	nSaldoAtuC	:= 0
	
	dbSelectArea(cHeader)
	dbSetOrder(1)
	MsSeek(xFilial()+cEntidIni,.T.)
	
	
	While !Eof() .And. (cHeader)->&((cHeader)+"_FILIAL") == xFilial(cHeader) .And. ;
		(cHeader)->&((cHeader)+"_"+cCpoCod) <= cEntidFim
		
		If (cHeader)->&((cHeader)+"_CLASSE") == "1"
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("CTS")
		dbSetOrder(1)
		MsSeek(xFilial()+cPlanGer+cOrdem)
		
		While !Eof() .And. CTS->CTS_FILIAL == cFilCTS .And.;
			CTS->CTS_CODPLA == cPlanGer  .And. CTS->CTS_ORDEM	== cOrdem
			
			aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
			aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
			
			
			If cHeader == "CTH"
				cClVlIni	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				cClVlFim	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				If !lFiltraIt		//Se nao considera o filtro das perguntas
					cItemIni	:= CTS->CTS_CTDINI
					cItemFim	:= CTS->CTS_CTDFIM
				EndIf
				If !lFiltraCC		//Se nao considera o filtro das perguntas
					cCCIni	:= CTS->CTS_CTTINI
					cCCFim	:= CTS->CTS_CTTFIM
				EndIf
				cContaIni	:= CTS->CTS_CT1INI
				cContaFim	:= CTS->CTS_CT1FIM
				cCodRes		:= CTH->CTH_RES
				cDescEnt	:= &("CTH->CTH_DESC"+cMoeda)
				If Empty(cDescEnt)
					cDescEnt	:= CTH->CTH_DESC01
				EndIf
			ElseIf cHeader == "CTD"
				If !lFiltraCV		//Se nao considera o filtro das perguntas
					cClVlIni	:= CTS->CTS_CTHINI
					cClVlFim	:= CTS->CTS_CTHFIM
				EndIf
				cItemIni	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				cItemFim	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				If !lFiltraCC		//Se nao considera o filtro das perguntas
					cCCIni  := CTS->CTS_CTTINI
					cCCFim  := CTS->CTS_CTTFIM
				EndIf
				cContaIni	:= CTS->CTS_CT1INI
				cContaFim	:= CTS->CTS_CT1FIM
				cCodRes		:= CTD->CTD_RES
				cDescEnt	:= &("CTD->CTD_DESC"+cMoeda)
				If Empty(cDescEnt)
					cDescEnt	:= CTD->CTD_DESC01
				EndIf
			ElseIf cHeader == "CTT"
				If !lFiltraCV		//Se nao considera o filtro das perguntas
					cClVlIni	:= CTS->CTS_CTHINI
					cClVlFim	:= CTS->CTS_CTHFIM
				EndIf
				If !lFiltraIt		//Se nao considera o filtro das perguntas
					cItemIni	:= CTS->CTS_CTDINI
					cItemFim	:= CTS->CTS_CTDFIM
				EndIf
				cCCIni  	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				cCCFim   	:= (cHeader)->&((cHeader)+"_"+cCpoCod)
				cContaIni	:= CTS->CTS_CT1INI
				cContaFim	:= CTS->CTS_CT1FIM
				cCodRes		:= CTT->CTT_RES
				cDescEnt	:= &("CTT->CTT_DESC"+cMoeda)
				If Empty(cDescEnt)
					cDescEnt	:= CTT->CTT_DESC01
				EndIf
			EndIf
			
			
			If !Empty(cClVlIni) .Or. !Empty(cClVlFim)
				aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
				cItemFim,cCCIni,cCCFim,cContaIni,;
				cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
				
				aSaldoAtu := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,;
				cItemFim,cCCIni,cCCFim,cContaIni,;
				cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			ElseIf !Empty(cItemIni) .Or. !Empty(cItemFim)
				aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCCIni,;
				cCCFim,cContaIni,cContaFim,;
				dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
				
				aSaldoAtu := SaldTotCT4(cItemIni,cItemFim,cCCIni,;
				cCCFim,cContaIni,cContaFim,;
				dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			ElseIf !Empty(cCCIni) .Or. !Empty(cCCFim)
				aSaldoAnt := SaldTotCT3(cCCIni,cCCFim,cContaIni,;
				cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
				aSaldoAtu := SaldTotCT3(cCCIni,cCCFim,cContaIni,;
				cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,,lRecDesp0,cRecDesp,dDtZeraRD,lImpAntLP,dDataLP)
			ElseIf !Empty(cContaIni) .Or. !Empty(cContaFim)
				aSaldoAnt := SaldTotCT7(cContaIni,cContaFim,dDataIni,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,,lRecDesp0,cRecDesp,dDtZeraRD)
				aSaldoAtu := SaldTotCT7(cContaIni,cContaFim,dDataFim,cMoeda,CTS->CTS_TPSALD,lImpAntLP,dDataLP,,lRecDesp0,cRecDesp,dDtZeraRD)
			EndIf
			
			If aSetOfBook[9] > 1	// Divisao por fator
				nLSldAnt := Len(aSaldoAnt)
				nLSldAtu := Len(aSaldoAtu)
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := Round(NoRound((aSaldoAnt[nPos]/aSetOfBook[9]),3),2)
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := Round(NoRound((aSaldoAtu[nPos]/aSetOfBook[9]),3),2)
				Next
			Endif
			
			If Left(CTS->CTS_FORMUL, 7) == "ROTINA="
				nLSldAnt := Len(aSaldoAnt)
				nLSldAtu := Len(aSaldoAtu)
				nFator := &(Subs(CTS->CTS_FORMUL, 8))
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] *= nFator
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] *= nFator
				Next
			Elseif Left(CTS->CTS_FORMUL,6 ) == "SALDO="
				nLSldAnt := Len(aSaldoAnt)
				nLSldAtu := Len(aSaldoAtu)
				nFator := &(Subs(CTS->CTS_FORMUL, 7))
				For nPos := 1 To nLSldAnt
					aSaldoAnt[nPos] := nFator
				Next
				For nPos := 1 To nLSldAtu
					aSaldoAtu[nPos] := nFator
				Next
			Endif
			
			// Calculos com os Fatores
			If CTS->CTS_IDENT = "1"				// Somo os saldos
				nSaldoAnt 	+= aSaldoAnt[6]		// Saldo Anterior
				nSaldoAtu 	+= aSaldoAtu[1]		// Saldo Atual
				
				nSaldoAntD 	+= aSaldoAnt[7]
				nSaldoAntC 	+= aSaldoAnt[8]
				
				nSaldoAtuD 	+= aSaldoAtu[4]
				nSaldoAtuC 	+= aSaldoAtu[5]
				
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				
			ElseIf CTS->CTS_IDENT = "2"			// Subtraio os saldos
				nSaldoAnt 	-= aSaldoAnt[6]		// Saldo Anterior
				nSaldoAtu 	-= aSaldoAtu[1]		// Saldo Atual
				
				nSaldoAntD 	-= aSaldoAnt[7]
				nSaldoAntC 	-= aSaldoAnt[8]
				
				nSaldoAtuD 	-= aSaldoAtu[4]
				nSaldoAtuC 	-= aSaldoAtu[5]
				
				nSaldoDeb  	:= (nSaldoAtuD - nSaldoAntD)
				nSaldoCrd  	:= (nSaldoAtuC - nSaldoAntC)
				
			EndIf
			
			dbSelectArea("CTS")
			dbSetOrder(1)
			nReg := Recno()
			dbSkip()
		Enddo
		
		nRegCTS	:= CTS->(Recno())
		
		dbSelectArea("CTS")
		dbSetOrder(2)
		dbGoTo(nReg)
		cCodNor := CTS->CTS_NORMAL
		
		If !lVlrZerado .And. (nSaldoCrd-nSaldoDeb = 0 .And. nSaldoAnt == 0 .And. nSaldoAtu == 0) .And. ;
			(nSaldoDeb = 0 .And. nSaldoCRD = 0)
			dbSelectArea(cHeader)
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("cArqTmp")
		dbSetOrder(1)
		If cHeader == "CTT"
			cChave	:= cCCIni+cConta
		ElseIf cHeader == "CTD"
			cChave	:= cItemIni+cConta
		ElseIf cHeader == "CTH"
			cChave	:= cClVlIni+cConta
		EndIf
		
		If !MsSeek(cChave)
			dbAppend()
			Do Case
				Case cHeader == 'CTT'
					Replace CUSTO 	With cCCIni
					Replace DESCCC	With cDescEnt
					Replace TIPOCC 	With CTS->CTS_CLASSE
					Replace CCRES	With cCodRes
				Case cHeader == 'CTD'
					Replace ITEM 		With cItemIni
					Replace DESCITEM    With cDescEnt
					Replace TIPOITEM	With CTS->CTS_CLASSE
					Replace ITEMRES		With cCodRes
				Case cHeader == 'CTH'
					Replace CLVL		With cClVlIni
					Replace DESCCLVL	With cDescEnt
					Replace TIPOCLVL	With CTS->CTS_CLASSE
					Replace CLVLRES		With cCodRes
			EndCase
			Replace CONTA 		With cConta
			Replace DESCCTA    	With cDesc
			Replace SUPERIOR  	With CTS->CTS_CTASUP
			Replace TIPOCONTA 	With CTS->CTS_CLASSE
			Replace NORMAL    	With CTS->CTS_NORMAL
			Replace ORDEM		With CTS->CTS_ORDEM
			Replace IDENTIFI	With CTS->CTS_IDENT
		EndIf
		
		If Left(CTS->CTS_FORMUL, 6) = "TEXTO="		// Adiciona texto a descricao
			Replace ("cArqTmp")->DESCCTA With 	AllTrim(("cArqTmp")->DESCCTA) + Space(1) +;
			&(Subs(CTS->CTS_FORMUL, 7))
		Endif
		
		If nDivide > 1
			nSaldoAnt	:= Round(NoRound((nSaldoAnt/nDivide),3),2)
			nSaldoAtu	:= Round(NoRound((nSaldoAtu/nDivide),3),2)
			nSaldoAtuD	:= Round(NoRound((nSaldoAtuD/nDivide),3),2)
			nSaldoAtuC	:= Round(NoRound((nSaldoAtuC/nDivide),3),2)
			nSaldoDeb	:= Round(NoRound((nSaldoDeb/nDivide),3),2)
			nSaldoCrd	:= Round(NoRound((nSaldoCrd/nDivide),3),2)
		EndIf
		
		dbSelectArea("cArqTmp")
		Replace	SALDOANT With nSaldoAnt			// Saldo Anterior
		Replace SALDOATU With nSaldoAtu			// Saldo Atual
		
		Replace SALDOATUDB With nSaldoAtuD		//Saldo Atual Devedor
		Replace SALDOATUCR With nSaldoAtuC		//Saldo Atual Credor
		
		If nSaldoDeb < 0
			Replace SALDOCRD	With nSaldoDeb
		ElseIf nSaldoDeb >= 0
			Replace SALDODEB	With nSaldoDeb
		EndIf
		If nSaldoCrd < 0
			Replace SALDODEB	With nSaldoCrd
		ElseIf nSaldoCrd >= 0
			Replace SALDOCRD	With nSaldoCrd
		EndIf
		
		Replace MOVIMENTO With nSaldoCrd-nSaldoDeb
		
		
		If lComNivel
			aNivel := {}
			Aadd(aNivel, Recno())
		Endif
		
		If lImpSint
			dbSelectArea("CTS")
			dbSetOrder(2)
			// Grava contas sinteticas
			If !Empty(CTS->CTS_CTASUP)
				While !Eof() .And. 	CTS->CTS_FILIAL == cFilCTS .And. ;
					CTS->CTS_CODPLAN == cPlanGer
					
					cContaSup 	:= CTS->CTS_CTASUP
					
					dbSelectArea("CTS")
					dbSetOrder(2)
					If MsSeek(cFilCTS+cPlanGer+cContaSup)
						cDescS	:= CTS->CTS_DESCCG
						cNormal := CTS->CTS_NORMAL
					Else
						cNormal	:= cCodNor
					EndIf
					
					dbSelectArea("cArqTmp")
					dbSetOrder(1)
					If cHeader == "CTT"
						cChave	:= cCCIni+cContaSup
					ElseIf cHeader == "CTD"
						cChave	:= cItemIni+cContaSup
					ElseIf cHeader == "CTH"
						cChave	:= cClVlIni+cContaSup
					EndIf
					
					If !MsSeek(cChave)
						dbAppend()
						Do Case
							Case cHeader = 'CTT'
								Replace CUSTO 		With cCCIni
								Replace DESCCC		With cDescEnt
								Replace TIPOCC		With CTS->CTS_CLASSE
								Replace CCRES		With cCodRes
							Case cHeader = 'CTD'
								Replace ITEM 		With cItemIni
								Replace DESCITEM	With cDescEnt
								Replace TIPOITEM	With CTS->CTS_CLASSE
								Replace ITEMRES		With cCodRes
							Case cHeader = 'CTH'
								Replace CLVL 		With cClVlIni
								Replace DESCCLVL	With cDescEnt
								Replace TIPOCLVL	With CTS->CTS_CLASSE
								Replace CLVLRES		With cCodRes
						EndCase
						Replace CONTA	With cContaSup
						Replace DESCCTA With cDescS
						Replace SUPERIOR  	With CTS->CTS_CTASUP
						Replace TIPOCONTA	With CTS->CTS_CLASSE
						Replace NORMAL   	With CTS->CTS_NORMAL
						Replace ORDEM		With CTS->CTS_ORDEM
						Replace IDENTIFI	With CTS->CTS_IDENT
					EndIf
					
					Replace	SALDOANT With SALDOANT + nSaldoAnt			// Saldo Anterior
					Replace SALDOATU With SALDOATU + nSaldoAtu			// Saldo Atual
					
					Replace SALDOATUDB With SALDOATUDB + nSaldoAtuD		//Saldo Atual Devedor
					Replace SALDOATUCR With SALDOATUCR + nSaldoAtuC		//Saldo Atual Credor
					
					If nSaldoDeb < 0
						Replace SALDOCRD	With SALDOCRD + nSaldoDeb
					ElseIf nSaldoDeb >= 0
						Replace SALDODEB	With SALDODEB + nSaldoDeb
					EndIf
					If nSaldoCrd < 0
						Replace SALDODEB	With SALDODEB + nSaldoCrd
					ElseIf nSaldoCrd >= 0
						Replace SALDOCRD	With SALDOCRD + nSaldoCrd
					EndIf
					
					Replace MOVIMENTO With SALDOCRD-SALDODEB
					
					If lComNivel
						Aadd(aNivel, Recno())
					Endif
					
					dbSelectArea("CTS")
					If !Eof() .And. Empty(CTS->CTS_CTASUP)
						dbSelectArea("cArqTmp")
						Replace NIVEL1 With .T.
						dbSelectArea("CTS")
						Exit
					EndIf
				EndDo
				
				If lComNivel
					dbSelectArea("cArqTmp")
					nContador 	:= 1
					For nNivel 	:= Len(aNivel) To 1 Step -1
						DbGoto(aNivel[nNivel])
						Replace NIVEL With nContador ++
					Next
				Endif
			EndIf
		Endif
		aSaldoAnt	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		aSaldoAtu	:= { 0, 0, 0, 0, 0, 0, 0, 0 }
		nSaldoCrd	:= 0
		nSaldoDeb 	:= 0
		nSaldoAnt 	:= 0
		nSaldoAtu 	:= 0
		nSaldoAtuD	:= 0
		nSaldoAtuC	:= 0
		nSaldoAntD	:= 0
		nSaldoAntC	:= 0
		nLSldAnt	:= 0
		nLSldAtu	:= 0
		
		dbSelectArea(cHeader)
		dbSkip()
		
	EnddO
	
	dbSelectArea("CTS")
	dbSetOrder(1)
	dbGoTo(nRegCTS)
	//	dbSkip()
EndDo

RestArea(aSaveArea)

Return

/////////////////////////////////

User Function XCtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,nComp)

Local aSaveArea	:= GetArea()

Local cCadastro	:= ""
Local cSuperior	:= ""
Local cCpoSup	:= ""
Local cIndice	:= ""
Local cEntid 	:= ""
Local cEntidG	:= ""
Local cCodRes	:= ""
Local cTipoEnt  := ""
Local cContaSup	:= ""
Local cDesc		:= ""
Local cDescEnt  := ""

Local nIndex	:= 0
Local nSaldoAnt := 0
Local nSaldoAtu := 0
Local nSaldoDeb := 0
Local nSaldoCrd := 0
Local nMovimento:= 0
Local nRegTmp 	:= 0
Local nReg		:= 0
Local nCol		:= 1
Local lEstour	:= .F.

DEFAULT nComp	:= 0			///SE FOR COMPARATIVO MES A MES INDICAR A QUANTIDADE DE COLUNAS

Do Case
	Case cAlias == 'CT3'
		cCadastro 	:= "CTT"
		cSuperior	:= 'CTT_FILIAL + CTT_CCSUP'
		cCpoSup		:= 'CTT_CCSUP'
	Case cAlias == 'CT4'
		cCadastro 	:= "CTD"
		cSuperior	:= 'CTD_FILIAL + CTD_ITSUP'
		cCpoSup		:= 'CTD_ITSUP'
	Case cAlias == 'CTI'
		cCadastro 	:= "CTH"
		cSuperior	:= 'CTH_FILIAL + CTH_CLSUP'
		cCpoSup		:= 'CTH_CLSUP'
EndCase

dbSelectArea("CT1")
lEstour := CT1->(FieldPos("CT1_ESTOUR")) <> 0
DbSelectArea(cCadastro)

If !Empty(cSuperior) .And. Empty(IndexKey(5))
	IndRegua(cCadastro, cIndice := (CriaTrab(, .F. )), cSuperior,,, "Selecionando registros...")
	nIndex:=RetIndex(cCadastro)+1
	dbSelectArea(cCadastro)
	#IfNDef TOP
		dbSetIndex(cIndice+OrdBagExt())
	#Endif
Else
	nIndex := 5
Endif

dbSelectArea("cArqTmp")
If lEstour .and. cArqTmp->(FieldPos("ESTOUR")) <> 0
	lEstour := .T.
Else
	lEstour := .F.
EndIf
dbGoTop()
If ValType(oMeter) == "O"
	nMeter	:= 0
	oMeter:SetTotal(cArqTmp->(RecCount()))
	oMeter:Set(0)
EndIf

While cArqTmp->(!Eof())
	
	nRegTmp := Recno()
	If cAlias == 'CT3'
		cEntid 	 := cArqTmp->CUSTO
		cCodRes	 := cArqTmp->CCRES
		cTipoEnt := cArqTmp->TIPOCC
		cDescEnt := cArqTmp->DESCCC
	ElseIf cAlias == 'CT4'
		cEntid 	 := cArqTmp->ITEM
		cCodRes	 := cArqTmp->ITEMRES
		cTipoEnt := cArqTmp->TIPOITEM
		cDescEnt := cArqTmp->DESCITEM
	ElseIf cAlias == 'CTI'
		cEntid 	 := cArqTmp->CLVL
		cCodRes	 := cArqTmp->CLVLRES
		cTipoEnt := cArqTmp->TIPOCLVL
		cDescEnt := cArqTmp->DESCCLVL
	EndIf
	
	If cTipoEnt == "1"
		dbSkip()
		Loop
	EndIf
	
	If nComp < 2
		nSaldoAnt:= SALDOANT
		nSaldoAtu:= SALDOATU
		nSaldoDeb:= SALDODEB
		nSaldoCrd:= SALDOCRD
		nMovimento:= MOVIMENTO
	Else
		For nCol := 1 to nComp
			&("nMov"+ALLTRIM(STR(INT(nCol)))) := &("cArqTmp->MOVIMENTO"+ALLTRIM(STR(INT(nCol))))
		Next
	EndIf
	
	DbSelectArea(cCadastro)
	cEntidG := cEntid
	
	dbSetOrder(1)
	
	MsSeek(xFilial(cCadastro)+cEntidG)
	
	While !Eof() .And. &(cCadastro + "->" + cCadastro + "_FILIAL") == xFilial(cCadastro)
		
		nReg := cArqTmp->(Recno())
		dbSelectArea("CT1")
		dbSetOrder(1)
		cContaSup := cArqTmp->CONTA
		MsSeek(xFilial("CT1")+ cContaSup)
		
		If cEntid = cEntidG
			cContaSup := CT1->CT1_CTASUP
			MsSeek(xFilial("CT1")+ cContaSup)
		Endif
		
		While !Eof() .And. CT1->CT1_FILIAL == xFilial("CT1")
			
			cDesc := &("CT1->CT1_DESC"+cMoeda)
			If Empty(cDesc)		// Caso nao preencher descricao da moeda selecionada
				cDesc := CT1->CT1_DESC01
			Endif
			
			cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC"+cMoeda)
			If Empty(cDescEnt)		// Caso nao preencher descricao da moeda selecionada
				cDescEnt := &(cCadastro + "->" + cCadastro + "_DESC01")
			Endif
			cCodRes  := &(cCadastro + "->" + cCadastro + "_RES")
			cTipoEnt := &(cCadastro + "->" + cCadastro + "_CLASSE")
			
			dbSelectArea("cArqTmp")
			dbSetOrder(1)
			If !MsSeek(cEntidG+cContaSup)
				dbAppend()
				Replace CONTA		With cContaSup
				Replace DESCCTA 	With cDesc
				Replace NORMAL   	With CT1->CT1_NORMAL
				Replace TIPOCONTA	With CT1->CT1_CLASSE
				Replace GRUPO		With CT1->CT1_GRUPO
				Replace CTARES		With CT1->CT1_RES
				Replace SUPERIOR	With CT1->CT1_CTASUP
				If lEstour
					Replace ESTOUR With CT1->CT1_ESTOUR
				EndIf
				If cAlias == 'CT3'
					Replace CUSTO With cEntidG
					Replace CCRES With cCodRes
					Replace TIPOCC With cTipoEnt
					Replace DESCCC With cDescEnt
				ElseIf cAlias == 'CT4'
					Replace ITEM With cEntidG
					Replace ITEMRES With cCodRes
					Replace TIPOITEM With cTipoEnt
					Replace DESCITEM With cDescEnt
				ElseIf cAlias == 'CTI'
					Replace CLVL With cEntidG
					Replace CLVLRES With cCodRes
					Replace TIPOCLVL With cTipoEnt
					Replace DESCCLVL WITH cDescEnt
				EndIf
			EndIf
			
			If nComp < 2
				Replace	 SALDOANT With SALDOANT + nSaldoAnt
				Replace  SALDOATU With SALDOATU + nSaldoAtu
				Replace  SALDODEB With SALDODEB + nSaldoDeb
				Replace  SALDOCRD With SALDOCRD + nSaldoCrd
				If !lNImpMov
					Replace MOVIMENTO With MOVIMENTO + nMovimento
				Endif
			Else
				For nCol := 1 to nComp
					&("cArqTmp->MOVIMENTO"+ALLTRIM(STR(INT(nCol)))) += &("nMov"+ALLTRIM(STR(INT(nCol))))
				Next
			EndIf
			
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(CT1->CT1_CTASUP) //.And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
				Exit
			EndIf
			
			dbSelectArea("cArqTmp")
			dbGoto(nRegTmp)
			dbSelectArea("CT1")
			cContaSup := CT1->CT1_CTASUP
			If Empty(cContaSup) .And. Empty(&(cCadastro + "->" + cCpoSup))
				dbSelectArea("cArqTmp")
				Replace NIVEL1 With .T.
				dbSelectArea("CT1")
			EndIf
			MsSeek(xFilial("CT1")+ cContaSup)
		EndDo
		dbSelectArea("cArqTmp")
		dbGoto(nReg)
		DbSelectArea(cCadastro)
		cEntidG := &cCpoSup
		If Empty(cEntidG)		// Ultimo Nivel gerencial
			Exit
		EndIf
		MsSeek(xFilial(cCadastro)+cEntidG)
	EndDo
	dbSelectArea("cArqTmp")
	dbGoto(nRegTmp)
	dbSkip()
	If ValType(oMeter) == "O"
		nMeter++
		oMeter:Set(nMeter)
	EndIf
EndDo

If ! Empty(cIndice)
	dbSelectArea(cCadastro)
	dbClearFil()
	RetIndex(cCadastro)
	dbSetOrder(1)
	Ferase(cIndice + OrdBagExt())
Endif


Restarea(aSaveArea)

Return

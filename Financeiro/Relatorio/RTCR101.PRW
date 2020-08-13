#include "topconn.ch"
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTCR101  ³ Alterado:Edmilson D. Santos   ³ Data ³ 27.02.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³10/07/07  ³ Alteração Cristiano - Acrescentado o campo emissao e colo- ³±±
±±³          ³ cado na proxima linha a natureza e o histórico.            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RTCR101()

Local Tamanho		:=	"G"
Local cString		:=	"SE5"
Local wnrel			:=	"RTCR101"
Local aOrd			:=	{ "Data Pagamento" , "Data Conciliacao" }
Local cDesc1 		:= "Este programa ir  emitir a rela‡„o dos titulos baixados."
Local cDesc2 		:= "Poder  ser emitido por data, banco, natureza ou alfab‚tica"
Local cDesc3 		:= "de cliente ou fornecedor e data da digita‡„o."

Private cabec1
Private cabec2
Private cNomeArq
Private aLinha  	:= {}
Private nLastKey 	:= 0
Private cPerg   	:=	"RTC101    "
Private NomeProg	:=	"RTCR101"
Private Titulo		:=	"Relacao de Baixas"
Private aReturn 	:= { "Zebrado" , 01 , "Administracao" , 01, 02, 01, "", 01 }

AjustaSx1()

ValidPerg()

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // da data da baixa                  ³
//³ mv_par02            // at‚ a data da baixa               ³
//³ mv_par03            // do banco                          ³
//³ mv_par04            // at‚ o banco                       ³
//³ mv_par05            // da natureza                       ³
//³ mv_par06            // at‚ a natureza                    ³
//³ mv_par07            // do c¢digo                         ³
//³ mv_par08            // at‚ o c¢digo                      ³
//³ mv_par09            // da data de digita‡„o              ³
//³ mv_par10            // ate a data de digita‡„o           ³
//³ mv_par11            // Tipo de Carteira (R/P)            ³
//³ mv_par12            // Moeda                             ³
//³ mv_par13            // Hist¢rico: Baixa ou Emiss„o       ³
//³ mv_par14            // Imprime Baixas Normais / Todas    ³
//³ mv_par15            // Situacao                          ³
//³ mv_par16            // Cons Mov Fin                      ³
//³ mv_par17            // Cons filiais abaixo               ³
//³ mv_par18            // da filial                         ³
//³ mv_par19            // ate a filial                      ³
//³ mv_par20            // Do Lote                           ³
//³ mv_par21            // Ate o Lote                        ³
//³ mv_par22            // da loja                           ³
//³ mv_par23            // Ate a loja                        ³
//³ mv_par24            // NCC Compensados                   ³
//³ mv_par25            // Outras Moedas                     ³
//³ mv_par26            // do prefixo                        ³
//³ mv_par27            // at‚ o prefixo                     ³
//³ mv_par28            // Imprimir os Tipos                 ³
//³ mv_par29            // Nao Imprimir Tipos			     ³
//³ mv_par30            // Imprime nome (Normal ou reduzido) ³
//³ mv_par31            // da data da vencto. do tit         ³
//³ mv_par32            // at‚ a data de vencto do tit.      ³
//³ mv_par33            // da filial origem                  ³
//³ mv_par34            // ate filial origem                 ³
//³ mv_par38            // da data de Conciliacao            ³
//³ mv_par39            // ate a data de Conciliacao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,,Tamanho,,.t.)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]

RptStatus( { |lEnd| Fa190Imp(@lEnd,wnRel,cString) } , Titulo )

Return(Nil)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FA190Imp(lEnd,wnRel,cString)

Local nI
Local nVlr
Local cLinha
Local cChave
Local bFirst
Local cLoja
Local CbTxt
Local CbCont
Local dDigit
Local cBanco
Local cFilTrb
Local cCliFor
Local cRecPag
Local cTipodoc
Local cFilOrig
Local cNatureza
Local cAnterior
Local cCarteira
Local dDtMovFin
Local cHistorico

Local nCM				:=	0
Local nCT				:=	0
Local nAbat 			:= 0
Local nDesc				:=	0
Local nJuros			:=	0
Local nValor			:=	0
Local nMulta			:=	0
Local nTotCm			:=	0
Local nGerCm			:=	0
Local nFilCM			:=	0
Local nRecSe5 			:= 0
Local nTotAbat 		:= 0
Local nGerAbat 		:= 0
Local nFilDesc			:=	0
Local nFilAbat			:=	0
Local nFilComp			:=	0
Local nFilOrig			:=	0
Local nGerOrig			:=	0
Local nGerDesc			:=	0
Local nGerComp			:=	0
Local nTotDesc			:=	0
Local nTotOrig			:=	0
Local nTotComp			:=	0
Local nMoedaBco		:= 1
Local nGerValor		:=	0
Local nGerJuros		:=	0
Local nGerMulta		:=	0
Local nVlMovFin		:=	0
Local nTotValor		:=	0
Local nTotJuros		:=	0
Local nTotMulta		:=	0
Local nFilJuros		:=	0
Local nFilMulta		:=	0
Local nFilValor		:=	0
Local nFilMovFin		:=	0
Local nGerMovFin		:=	0
Local nTotMovFin		:=	0
Local nFilBaixado		:=	0
Local nTotBaixado		:=	0
Local nGerBaixado		:=	0

Local cQuery			:=	""
Local cNomArq1			:=	""
Local cCliFor190 		:=	""
Local Tamanho			:=	"G"
Local cFilSe5 			:=	".t."

Local lBxTit			:=	.f.
Local lAsTop 			:= .f.
Local lAchou 			:=	.f.
Local lManual 			:= .f.
Local lContinua		:=	.t.
Local lOriginal		:=	.t.

Local aColu 			:= {}
Local aCampos 			:= {}

Local cFilNome 		:= Space(15)
Local nRecEmp 			:= SM0->(Recno())
Local cMotBaixa 		:= Criavar("E5_MOTBX")
Local aStru 			:= SE5->(DbStruct())
Local lCancPos			:=	MsgYesNo("Imprime Títulos Com Cancelamento Posterior ?")
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),"")))
Local aTam 				:= iif(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))

cbcont   := 0
m_pag    := 1
li       := 80
cCond3	:=	".t."
cbtxt   	:=	Space(10)
nOrdem 	:= aReturn[8]
cSuf		:=	ltrim( Str(mv_par12) )
cMoeda	:= GetMv( "MV_MOEDA" + cSuf )

If mv_par11 == 1
	Titulo := "Relacao dos Titulos Recebidos em " + cMoeda
	cabec1 := iif( aTam[1] > 6 , "Clien-Nome Cliente    " , "Numero  Prc  TP   Nome do Cliente                                      Emissao   Vencto   Dt Baixa  Valor Original    Tx Permanen      Multa      Correcao    Descontos   Abatimentos    Total Pago Bco Dt Concil Mot. Baixa" )
	cabec2 := iif( aTam[1] > 6 , "                       Prf Numero       P TP                           Emissao   Vencto   Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa" , "" )
Else
	Titulo := "Relacao dos Titulos Pagos em " + cMoeda
	cabec1 := iif(aTam[1] > 6 , "Fornc-Nome Fornecedor " , "Numero  Prc  TP   Nome do Fornecedor                                    Emissao  Vencto   Dt Baixa  Valor Original    Tx Permanen      Multa      Correcao    Descontos   Abatimentos    Total Pago Bco Dt Concil Mot. Baixa" )
	cabec2 := iif(aTam[1] > 6 , "                       Prf Numero       P TP                            Emissao  Vencto   Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa" , "" )
EndIf

/*        10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Receber
Numero  Prc  TP   Nome do Cliente                                       Emissao  Vencto   Dt Baixa  Valor Original    Tx Permanen      Multa      Correcao    Descontos   Abatimentos    Total Pago Bco Dt Consil Mot. Baixa
Prf Numero       P TP                            Emissao  Vencto   Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa
Natureza: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  Historico: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Pagar
Numero  Prc  TP   Nome do Fornecedor                                    Emissao  Vencto   Dt Baixa  Valor Original    Tx Permanen      Multa      Correcao    Descontos   Abatimentos    Total Pago Bco Dt Consil Mot. Baixa
Prf Numero       P TP                            Emissao  Vencto   Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa
999999  XXX  XXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99/99/99 99/99/99 99/99/99
Natureza: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  Historico: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*/

cFilDe := iif( mv_par17 == 2 , cFilAnt , mv_par18 )
cFilAte:= iif( mv_par17 == 2 , cFilAnt , mv_par19 )

DbSelectArea("SE5")

Do Case
	Case nOrdem == 1
		cCondicao	:= "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
		cCond2 		:= "E5_DATA"
		cChave 		:= "E5_FILIAL,E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,SE5.R_E_C_N_O_ "
		Titulo 		+= " por data de pagamento"
		bFirst 		:=	{ || MsSeek( xFilial("SE5") + DtoS(mv_par01) , .t. ) }
	Case nOrdem == 2
		cCondicao 	:= "E5_DTDISPO >= mv_par38 .and. E5_DTDISPO <= mv_par39"
		cCond2 		:= "E5_DTDISPO"
		cChave 		:= "E5_FILIAL,E5_DTDISPO,E5_PREFIXO,E5_NUMERO,E5_PARCELA"
		Titulo 		+= " Por Data de Conciliacao"
		bFirst 		:=	{ || MsSeek( xFilial("SE5") , .t. )}
EndCase

If !Empty(mv_par28) .and. !( ";" $ mv_par28 ) .and. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert("Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif

If !Empty(mv_par29) .and. !( ";" $ mv_par29 ) .and. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert("Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif

lAsTop 		:= .t.
cCondicao 	:=	".t."

DbSelectArea("SE5")

aEval( DbStruct() , { |e| cQuery += "," + AllTrim(e[1]) } )

AjustaDispo()

cQuery 	:=	"SELECT " + SubStr(cQuery,2) + " , SE5.R_E_C_N_O_ SE5RECNO "
cQuery 	+= "FROM " + RetSqlName("SE5")+" SE5 "
cQuery 	+= "WHERE E5_RECPAG = '" 	+ iif( mv_par11 == 1, "R","P") + "' AND "
cQuery 	+= 	"	 E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
cQuery 	+= 	"   E5_SITUACA NOT IN ('C','E','X') AND "
cQuery 	+= 	"   ( ( E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA ) OR E5_TIPODOC <> 'CD' ) AND "
cQuery 	+= 	"   E5_NATUREZ between '" 	+ mv_par05       	+ "' AND '" + mv_par06       	+ 	"' AND "
cQuery 	+= 	"   E5_LOTE    between '" 	+ mv_par20       	+ "' AND '" + mv_par21       	+ 	"' AND "
cQuery 	+= 	"   E5_CLIFOR  between '" 	+ mv_par07       	+ "' AND '" + mv_par08       	+ 	"' AND "
cQuery 	+= 	"   E5_LOJA    between '" 	+ mv_par22       	+ "' AND '" + mv_par23 	    	+	"' AND "
cQuery 	+= 	"   E5_PREFIXO between '" 	+ mv_par26       	+ "' AND '"	+ mv_par27 	    	+ 	"' AND "
cQuery 	+= 	"   E5_DTDIGIT between '" 	+ DtoS(mv_par09) 	+ "' AND '" + DtoS(mv_par10) 	+ 	"' AND "
cQuery 	+= 	"   E5_DTDISPO between '" 	+ DtoS(mv_par38) 	+ "' AND '" + DtoS(mv_par39) 	+ 	"' AND "
cQuery 	+= 	"   E5_BANCO   between '" 	+ mv_par03       	+ "' AND '" + mv_par04       	+ 	"' AND "
cQuery 	+= 	"   E5_DATA    between '" 	+ DtoS(mv_par01) 	+ "' AND '"	+ DtoS(mv_par02) 	+ 	"' AND "
cQuery 	+= 	"   E5_DATA    <= '" 		+ DtoS(dDataBase)	+ "' AND "
cQuery 	+= 	"   D_E_L_E_T_ = ' '  "

If mv_par11 == 2
	cQuery += " AND E5_TIPODOC <> 'E2' "
EndIf

If !Empty(mv_par28)
	cQuery += " AND E5_TIPO IN "		+	FormatIn(mv_par28,";")
ElseIf !Empty(Mv_par29)
	cQuery += " AND E5_TIPO NOT IN "	+	FormatIn(mv_par29,";")
EndIf

If mv_par16 == 2
	cQuery += " AND E5_TIPODOC <> '" + Space(Len(E5_TIPODOC)) 	+ "'"
	cQuery += " AND E5_NUMERO  <> '" + Space(Len(E5_NUMERO)) 	+ "'"
	cQuery += " AND E5_TIPODOC <> 'CH' "
Endif

If mv_par17 == 2
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "'"
Else
	cQuery += " AND E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
Endif
cQuery	+=	" Order By R_E_C_N_O_ "   //Rafael - Coloca para ordenar os registros na ordem que foram baixados
//cQuery 	+=	" ORDER BY " + cChave
cQuery 	:=	ChangeQuery(cQuery)

dbUseArea(.t., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .f., .t.)

For nI := 1 To Len(aStru)
	If aStru[nI,2] != "C"
		TcSetField( "NEWSE5"  , aStru[nI,1], aStru[nI,2], aStru[nI,3], aStru[nI,4] )
	EndIf
Next nI

DbGoTop()

aAdd(aCampos , { "LINHA" , "C" , 80 , 00 } )

cNomArq1 := CriaTrab(aCampos)
dbUseArea( .t. , , cNomArq1 , "Trb" , Nil , .f. )
IndRegua( "TRB" , cNomArq1 , "LINHA" ,,, "Selecionando Registros..." )

if aTam[1] > 6
	aColu	:= { 023 , 027 , TamParcela("E1_PARCELA",40,39,38) , 042 , 000 , 022 }
else
	aColu := { 000 , 004 , TamParcela("E1_PARCELA",17,16,15) , 019 , 023 , 030 }
endif

DbSelectArea("SM0")
DbSeek( cEmpAnt + cFilDe , .t. )

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
	
	cFilAnt := SM0->M0_CODFIL
	cFilNome:= SM0->M0_FILIAL
	
	DbSelectArea("NEWSE5")
	
	SetRegua(RecCount())
	
	While NEWSE5->(!Eof()) .and. NEWSE5->E5_FILIAL == xFilial("SE5") .and. &cCondicao .and. lContinua
		
		If lEnd
			@ prow() + 1 , 001 psay "CANCELADO PELO OPERADOR"
			lContinua:=.f.
			Exit
		EndIf
		
		IncRegua()
		DbSelectArea("NEWSE5")
		
		If	!Fr190TstCond(cFilSe5,.f.)
			NEWSE5->(dbSkip())
			Loop
		Endif
		
		if	!lCancPos
			if	TemCancPos()
				NEWSE5->(dbSkip())
				Loop
			Endif
		endif
		
		if (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
			(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 			//Adiantamento
			cCarteira := "R"
		Else
			cCarteira := "P"
		Endif
		
		dbSelectArea("NEWSE5")
		
		nCT			:= 0
		nTotCM		:= 0
		nTotDesc		:= 0
		nTotOrig		:= 0
		nTotAbat  	:= 0
		nTotComp		:= 0
		nTotJuros	:= 0
		nTotMulta	:= 0
		nTotValor	:= 0
		nTotMovFin	:= 0
		nTotBaixado	:= 0
		
		cAnterior 	:= &cCond2
		
		While NEWSE5->(!Eof()) .and. &cCond2 = cAnterior .and. NEWSE5->E5_FILIAL == xFilial("SE5") .and. lContinua
			
			lManual := .f.
			
			dbSelectArea("NEWSE5")
			
			If ( Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 1 ) .or. ( Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 1 )
				lManual := .t.
			EndIf
			
			If !Fr190TstCond(cFilSe5,.t.)
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())
				Loop
			Endif
			
			if	!lCancPos
				if	TemCancPos()
					NEWSE5->(dbSkip())
					Loop
				Endif
			endif
			
			cNumero    	:= NEWSE5->E5_NUMERO
			cPrefixo   	:= NEWSE5->E5_PREFIXO
			cParcela   	:= NEWSE5->E5_PARCELA
			dBaixa     	:= NEWSE5->E5_DATA
			cBanco     	:= NEWSE5->E5_BANCO
			cNatureza  	:= NEWSE5->E5_NATUREZ
			cCliFor    	:= NEWSE5->E5_BENEF
			cLoja      	:= NEWSE5->E5_LOJA
			cSeq       	:= NEWSE5->E5_SEQ
			cNumCheq   	:= NEWSE5->E5_NUMCHEQ
			cRecPag 		:= NEWSE5->E5_RECPAG
			cTipodoc   	:= NEWSE5->E5_TIPODOC
			cMotBaixa	:= NEWSE5->E5_MOTBX
			cCheque    	:= NEWSE5->E5_NUMCHEQ
			cTipo      	:= NEWSE5->E5_TIPO
			cFornece   	:= NEWSE5->E5_CLIFOR
			cLoja      	:= NEWSE5->E5_LOJA
			dDigit     	:= NEWSE5->E5_DTDISPO
			lBxTit	  	:= .f.
			cFilorig    := NEWSE5->E5_FILORIG
			
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 			//Adiantamento
				
				dbSelectArea("SE1")
				dbSetOrder(1)
				
				lBxTit := MsSeek( cFilial + cPrefixo + cNumero + cParcela + cTipo )
				
				If !lBxTit
					lBxTit := dbSeek( NEWSE5->E5_FILORIG + cPrefixo + cNumero + cParcela + cTipo )
				Endif
				
				cCarteira 	:=	"R"
				dDtMovFin	:= iif( lManual , CtoD("") , DataValida(SE1->E1_VENCTO,.t.) )
				
				While SE1->(!Eof()) .and. SE1->(E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO) == cPrefixo + cNumero + cParcela + cTipo
					If SE1->E1_CLIENTE == cFornece .and. SE1->E1_LOJA == cLoja
						Exit
					Endif
					SE1->( dbSkip() )
				EndDo
				
				If !SE1->(Eof()) .and. mv_par11 == 1 .and. !lManual .and.  ;
					(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
					If !(SE1->E1_SITUACA $ mv_par15)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif
				Endif
				
				cCond3 := "E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
				nDesc  := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
			Else
				
				dbSelectArea("SE2")
				DbSetOrder(1)
				
				cCarteira := "P"
				lBxTit := MsSeek(cFilial+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				
				If !lBxTit
					lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
				Endif
				
				dDtMovFin 	:= IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.t.))
				cCond3		:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
				nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
				
				cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				
				//Implementação para cheques aglutinados. Por Cristiano em 30/07/07
				If Empty(cCheque) //Se o cheque for vazio
					dbSelectArea("SEF")
					dbSetOrder(8) //Indice especifico: EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE+EF_LOJA
					If dbSeek(xFilial("SEF")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
						If EF_IMPRESS <> "C" //Não imprime cheques cancelados
							cCheque := SEF->EF_NUM
						EndIF
					EndIf
				EndIf
			Endif
			
			dbSelectArea("NEWSE5")
			
			IncRegua()
			
			cHistorico := Space(40)
		
			While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .and. NEWSE5->E5_FILIAL==xFilial("SE5")
				
				IncRegua()
				dbSelectArea("NEWSE5")
				cTipodoc   := NEWSE5->E5_TIPODOC
						
				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")
					lContinua:=.f.
					Exit
				EndIF
				
				// Testa condicoes de filtro
				If !Fr190TstCond(cFilSe5,.t.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif
				
				if	!lCancPos
					if	TemCancPos()
						NEWSE5->(dbSkip())
						Loop
					Endif
				endif
				
				If NEWSE5->E5_SITUACA $ "C/E/X"
					dbSelectArea("NEWSE5")
					NEWSE5->( dbSkip() )
					Loop
				EndIF
				
				If NEWSE5->E5_LOJA != cLoja
					Exit
				Endif
				
				If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
					dbSelectArea("NEWSE5")
					NEWSE5->( dbSkip() )
					Loop
				Endif
				
				cFilTrb := If(mv_par11==1,"SE1","SE2")
				
				If (cFilTrb)->(!Eof()) .and.;
					((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .or. (!Empty(mv_par32) .and. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())
					Loop
				Endif
				
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag		:= NEWSE5->E5_RECPAG
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cTipo190		:= NEWSE5->E5_TIPO
				cFilorig    := NEWSE5->E5_FILORIG
				
				If cPaisLoc	# "BRA".and.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
					SA6->(DbSetOrder(1))
					SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
					nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
				Else
					nMoedaBco	:=	1
				Endif
				
				If !Empty(NEWSE5->E5_NUMERO)
					If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
						(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .or.;
						(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPODOC $ "DB#OD")
						dbSelectArea("SA1")
						dbSetOrder(1)
						lAchou := .f.
						If Empty(xFilial("SA1"))  //SA1 Compartilhado
							If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .t.
							Endif
						Else
							cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
							If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
									lAchou := .t.
								Else
									cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .t.
										Endif
									Endif
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .t.
									Endif
								Endif
							Endif
						EndIF
						If lAchou
							cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
						Endif
					Else
						dbSelectArea("SA2")
						dbSetOrder(1)
						lAchou := .f.
						If Empty(xFilial("SA2"))  //SA2 Compartilhado
							If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								lAchou := .t.
							Endif
						Else
							cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
							If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
								If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
									lAchou := .t.
								Else
									cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .t.
										Endif
									Endif
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .t.
									Endif
								Endif
							Endif
						EndIF
						If lAchou
							cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
						Endif
					EndIf
				EndIf
				
				dbSelectArea("SM2")
				dbSetOrder(1)
				dbSeek(NEWSE5->E5_DATA)
				dbSelectArea("NEWSE5")
				
				nRecSe5	:=	Iif(lAsTop,NEWSE5->SE5RECNO,Recno())
				nDesc		+=	Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nJuros	+=	Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nMulta	+=	Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				nCM		+=	Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				
				If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
					cHistorico := NEWSE5->E5_HISTOR
					nValor+=Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				Else
					nVlMovFin+=Iif(mv_par12==1.and.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
					cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
					cNatureza  	:= NEWSE5->E5_NATUREZ
				Endif
				
				dbSkip()
				
				If lManual
					Exit
				Endif
			EndDO
			
			If ( nDesc + nValor + nJuros + nCM + nMulta + nVlMovFin ) > 0
				
				If cCarteira == "R" .and. !lManual
					dbSelectArea("SE1")
					nRecno := Recno()
					nAbat := SomaAbat(cPrefixo,cNumero,cParcela,"R",mv_par12,,cFornece,cLoja)
					dbSelectArea("SE1")
					dbGoTo(nRecno)
				Elseif !lManual
					dbSelectArea("SE2")
					nRecno := Recno()
					nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
					dbSelectArea("SE2")
					dbGoTo(nRecno)
				EndIF
				
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				EndIF
				
				IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
					If lBxTit
						@li, aColu[05] PSAY SE1->E1_CLIENTE
					Endif
					@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					li++
				Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
					If lBxTit
						@li, aColu[05] PSAY SE2->E2_FORNECE
					Endif
					@li, aColu[06] PSAY SubStr(cCliFor,1,18)
					li++
				Endif
				
				@li, aColu[02]-4 PSAY cNumero
				@li, aColu[03]-7 PSAY cParcela
				@li, aColu[04]-6 PSAY cTipo
				
				If !lManual
					dbSelectArea("TRB")
					lOriginal := .t.
					If cCarteira == "R"
						cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
						nVlr:= SE1->E1_VLCRUZ
						If mv_par12 > 1
							nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDesc+1)
						EndIF
					Else
						cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
						nVlr:= SE2->E2_VLCRUZ
						If mv_par12 > 1
							nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
						Endif
					Endif
					cFilTrb := If(cCarteira=="R","SE1","SE2")
					IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
						nVlr:=0
						nAbat:=0
						lOriginal := .f.
					Else
						nVlr:=NoRound(nVlr)
						RecLock("TRB",.t.)
						Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
						MsUnlock()
					EndIF
				Else
					If lAsTop
						dbSelectArea("SE5")
					Else
						dbSelectArea("NEWSE5")
					Endif
					dbgoto(nRecSe5)
					
					nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
					nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,dDataBase,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)					
					nAbat:= 0
					lOriginal := .t.
					If lAsTop
						nRecSe5:=NEWSE5->SE5RECNO
					Else
						nRecSe5:=Recno()
						NEWSE5->( dbSkip() )
					Endif
					dbSelectArea("TRB")
				Endif
				
				IF cCarteira == "R"
					If ( !lManual )
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
						Else
							cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
						Endif
					EndIf
					
					If aTam[1] <= 6 .and. !lManual
						@li, aColu[06]-12 PSAY SubStr(cCliFor,1,18)
					Endif
					
					If Empty( dDtMovFin ) .or. dDtMovFin == Nil
						dDtMovFin := CtoD("  /  /  ")
					Endif
					
					@li, 72 PSAY SE1->E1_EMISSAO
					@li, 81 PSAY IIf(lManual,dDtMovFin,iif(mv_par40 == 2,DataValida(SE1->E1_VENCTO,.t.),SE1->E1_VENCTO))
					@li, 90 PSAY dBaixa
					
					IF nVlr > 0
						@li,101 PSAY nVlr  Picture tm(nVlr,14,nDecs)
					Endif
				Else
					If mv_par13 == 1
						cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
					Else
						cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
					Endif
					
					If aTam[1] <= 6 .and. !lManual
						@li, aColu[06]-12 PSAY SubStr(cCliFor,1,18)
					Endif
					
					If Empty( dDtMovFin ) .or. dDtMovFin == Nil
						dDtMovFin := CtoD("  /  /  ")
					Endif
					
					@li, 72 PSAY SE2->E2_EMISSAO
					@li, 81 PSAY IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.t.))
					@li, 90 PSAY dBaixa
					
					IF nVlr > 0
						@li,101 PSAY nVlr Picture tm(nVlr,14,nDecs)
					Endif
				Endif
				nCT ++
				
				@li,116 PSAY nJuros     PicTure tm(nJuros,12,nDecs)
				@li,129 PSAY nMulta     PicTure tm(nMulta,12,nDecs)
				@li,142 PSAY nCM        PicTure tm(nCM ,12,nDecs)
				@li,155 PSAY nDesc      PicTure tm(nDesc,12,nDecs)
				@li,168 PSAY nAbat  	Picture tm(nAbat,12,nDecs)
				
				If nVlMovFin > 0
					@li,181 PSAY nVlMovFin     PicTure tm(nVlMovFin,14,nDecs)
				Else
					@li,181 PSAY nValor			PicTure tm(nValor,14,nDecs)
				Endif
				
				@li,196 PSAY cBanco
				@li,202 PSAY dDigit
				
				If empty(cMotBaixa)
					cMotBaixa := "NOR"
				Endif
				
				@li,211 PSAY Substr(cMotBaixa,1,3)
				@li,215 PSAY cFilorig
				
				li++
				
				@li,00 PSAY "Natureza: "+POSICIONE("SED",1,xFilial("SED")+cNatureza,"ED_DESCRIC")
				
				IF cCarteira == "R"
					@li,041 PSAY "Historico: "+cHistorico
				Else
					If !Empty(cCheque)
						@li, 41 PSAY "Historico: "+ALLTRIM(cCheque)+"/"+Trim(cHistorico)
					Else
						@li, 41 PSAY "Historico: "+ALLTRIM(cHistorico)
					EndIf
				EndIf
				
				nTotOrig   += Iif(lOriginal,nVlr,0)
				nTotBaixado+= Iif(cTipodoc == "CP",0,nValor)		// n„o soma, j  somou no principal
				nTotDesc   += nDesc
				nTotJuros  += nJuros
				nTotMulta  += nMulta
				nTotCM     += nCM
				nTotAbat   += nAbat
				nTotValor  += IIF( nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),nValor,0))
				nTotMovFin += nVlMovFin
				nTotComp   += Iif(cTipodoc == "CP",nValor,0)
				nDesc := nJuros := nValor := nMulta := nCM := nAbat := nVlMovFin := 0
				li++
			Endif
			dbSelectArea("NEWSE5")
		Enddo
		
		If (nTotValor+nDesc+nJuros+nCM+nTotMulta+nTotOrig+nTotMovFin+nTotComp)>0
			
			li++
			
			IF li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			Endif
			
			If nCT > 0
				IF nOrdem == 1 .or. nOrdem == 2
					@li, 0 PSAY "Sub Total : " + DTOC(cAnterior)
				Endif
				
				If nOrdem != 5
					@li,101 PSAY nTotOrig     PicTure tm(nTotOrig,14,nDecs)
					@li,116 PSAY nTotJuros    PicTure tm(nTotJuros,12,nDecs)
					@li,129 PSAY nTotMulta    PicTure tm(nTotMulta,12,nDecs)
					@li,142 PSAY nTotCM       PicTure tm(nTotCM ,12,nDecs)
					@li,155 PSAY nTotDesc     PicTure tm(nTotDesc,12,nDecs)
					@li,168 PSAY nTotAbat     Picture tm(nTotAbat,12,nDecs)
					@li,181 PSAY nTotValor    PicTure tm(nTotValor,14,nDecs)
					If nTotBaixado > 0
						@li,197 PSAY OemToAnsi("Baixados")
						@li,206 PSAY nTotBaixado  PicTure tm(nTotBaixado,14,nDecs)
					Endif
					If nTotMovFin > 0
						li++
						@li,197 PSAY OemToAnsi("Mov Fin.")
						@li,206 PSAY nTotMovFin   PicTure tm(nTotMovFin,14,nDecs)
					Endif
					If nTotComp > 0
						li++
						@li,197 PSAY "Compens."
						@li,206 PSAY nTotComp     PicTure tm(nTotComp,14,nDecs)
					Endif
					li+=2
				Endif
				dbSelectArea("NEWSE5")
			Endif
		Endif
		
		nGerOrig	+= nTotOrig
		nGerValor	+= nTotValor
		nGerDesc	+= nTotDesc
		nGerJuros	+= nTotJuros
		nGerCM		+= nTotCM
		nGerMulta	+= nTotMulta
		nGerAbat	+= nTotAbat
		nGerBaixado += nTotBaixado
		nGerMovFin	+= nTotMovFin
		nGerComp	+= nTotComp
		
		nFilOrig	+= nTotOrig
		nFilValor	+= nTotValor
		nFilDesc	+= nTotDesc
		nFilJuros	+= nTotJuros
		nFilCM		+= nTotCM
		nFilMulta	+= nTotMulta
		nFilAbat	+= nTotAbat
		nFilBaixado += nTotBaixado
		nFilMovFin	+= nTotMovFin
		nFilComp	+= nTotComp
	Enddo
	
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .and. li != 80
		@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
		@li,101 PSAY nFilOrig       PicTure tm(nFilOrig,14,nDecs)
		@li,116 PSAY nFilJuros      PicTure tm(nFilJuros,12,nDecs)
		@li,129 PSAY nFilMulta      PicTure tm(nFilMulta,12,nDecs)
		@li,142 PSAY nFilCM         PicTure tm(nFilCM ,12,nDecs)
		@li,155 PSAY nFilDesc       PicTure tm(nFilDesc,12,nDecs)
		@li,168 PSAY nFilAbat       PicTure tm(nFilAbat,12,nDecs)
		@li,181 PSAY nFilValor      PicTure tm(nFilValor,14,nDecs)
		If nFilBaixado > 0
			@li,197 PSAY OemToAnsi("Baixados")
			@li,206 PSAY nFilBaixado    PicTure tm(nFilBaixado,14,nDecs)
		Endif
		If nFilMovFin > 0
			li++
			@li,197 PSAY OemToAnsi("Mov Fin.")
			@li,206 PSAY nFilMovFin   PicTure tm(nFilMovFin,14,nDecs)
		Endif
		If nFilComp > 0
			li++
			@li,197 PSAY "Compens."
			@li,206 PSAY nFilComp     PicTure tm(nFilComp,14,nDecs)
		Endif
		li+=2
		If Empty(xFilial("SE5"))
			Exit
		Endif
		
		nFilOrig:=nFilJuros:=nFilMulta:=nFilCM:=nFilDesc:=nFilAbat:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=0
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo

If li != 80
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2
	@li,  0 PSAY OemToAnsi("Total Geral : ")
	@li,101 PSAY nGerOrig       PicTure tm(nGerOrig,14,nDecs)
	@li,116 PSAY nGerJuros      PicTure tm(nGerJuros,12,nDecs)
	@li,129 PSAY nGerMulta      PicTure tm(nGerMulta,12,nDecs)
	@li,142 PSAY nGerCM         PicTure tm(nGerCM ,12,nDecs)
	@li,155 PSAY nGerDesc       PicTure tm(nGerDesc,12,nDecs)
	@li,168 PSAY nGerAbat       PicTure tm(nGerAbat,12,nDecs)
	@li,181 PSAY nGerValor      PicTure tm(nGerValor,14,nDecs)
	If nGerBaixado > 0
		@li,197 PSAY OemToAnsi("Baixados")
		@li,206 PSAY nGerBaixado    PicTure tm(nGerBaixado,14,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,197 PSAY OemToAnsi("Mov Fin.")
		@li,206 PSAY nGerMovFin   PicTure tm(nGerMovFin,14,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,197 PSAY "Compens."
		@li,206 PSAY nGerComp     PicTure tm(nGerComp,14,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
cFilAnt := SM0->M0_CODFIL
dbSelectArea("TRB")
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fr190TstCo³ Autor ³ Claudio D. de Souza   ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Testa as condicoes do registro do SE5 para permitir a impr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Fr190TstCon(cFilSe5)													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilSe5 - Filtro em CodBase										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fr190TstCond(cFilSe5,lInterno)

Local lRet := .t.
Local nMoedaBco
Local lManual := .f.

If (Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 1) .or.;
	(Empty(NEWSE5->E5_NUMERO)  .and. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
	Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
		lRet := .f.
	Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2"
		lRet := .f.
	Case NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or.;
		(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
		lRet := .f.
	Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
		lRet := .f.
	Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
		lRet := .f.
	Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
		lRet := .f.
	Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH"
		lRet := .f.
	Case NEWSE5->E5_TIPODOC == "TR"
		lRet := .f.
	Case mv_par11 = 1 .and. E5_TIPODOC $ "E2#CB"
		lRet := .f.
	Case NEWSE5->E5_BANCO < mv_par03 .or. NEWSE5->E5_BANCO > MV_PAR04
		lRet := .f.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
		//³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
		//³manuais, se consideradas.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual
		lRet := .f.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case !Empty(cFilterUser).and.!(&cFilterUser)
		lRet := .f.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe estorno para esta baixa, somente no nivel de quebra ³
		//³ mais interno, para melhorar a performance 										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case lInterno .and.;
		TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
		lRet := .f.
EndCase

If lRet .and. mv_par25 == 2
	If cPaisLoc	# "BRA".and.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
		SA6->(DbSetOrder(1))
		SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
		nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	Else
		nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .f.
	EndIf
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Claudio D. de Souza   ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1()

Local aArea 	:=	GetArea()
Local cPerg		:= "RTC101    "

//Altera o tamanho da pergunta e ativa os novos tipos de cobrança (FGH)

dbSelectArea("SX1")
dbSetOrder(1)

If MsSeek( cPerg + "15" )
	RecLock("SX1")
	Replace X1_TAMANHO	With 11
	Replace X1_CNT01		With "01234567FGH"
	MsUnlock()
Endif

RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaDispo³ Autor ³ Claudio Ferreira     ³ Data ³24/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no Campo E5_DISPO da baixa do titulo a dt Conc.Cheque³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function AjustaDispo()

cQuery :=" SELECT * "
cQuery +=" FROM "+RetSqlName("SE5")
cQuery +=" WHERE ("
cQuery += "      E5_DATA    between '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'  OR "
cQuery += "      E5_DATA    between '" + DtoS(mv_par38) + "' AND '" + DtoS(mv_par39) + "') AND "
cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "
cQuery += "      E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06       + "' AND "
cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
cQuery += "      D_E_L_E_T_ = ' '  AND "
cQuery += "      E5_TIPODOC = 'CH' " 
cQuery += " Order By R_E_C_N_O_ " //Rafael - Coloca para ordenar os registros na ordem que foram baixados
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "QSE5"
dbSelectArea("QSE5")
dbGoTop()

WHILE !EOF()
	If QSE5->E5_RECONC == 'x'
		pCheque := QSE5->E5_DATA+QSE5->E5_BANCO+QSE5->E5_AGENCIA+QSE5->E5_CONTA+QSE5->E5_NUMCHEQ
		DbSelectArea("SE5")
		DbSetOrder(1)
		DBSEEK(xFilial("SE5")+QSE5->E5_DATA+QSE5->E5_BANCO+QSE5->E5_AGENCIA+QSE5->E5_CONTA+QSE5->E5_NUMCHEQ)
		WHILE !EOF().and.DtoS(SE5->E5_DATA)+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ ==;
			QSE5->E5_DATA+QSE5->E5_BANCO+QSE5->E5_AGENCIA+QSE5->E5_CONTA+QSE5->E5_NUMCHEQ
			IF SE5->E5_TIPODOC == 'BA'
				RecLock("SE5",.f.)
				REPLACE SE5->E5_DTDISPO WITH stod(QSE5->E5_DTDISPO)
				SE5->(MsUnLock())
			Endif
			DbSelectArea("SE5")
			DbSkip()
		EndDO
	Endif
	dbSelectArea("QSE5")
	DbSkip()
ENDDO
dbSelectArea("QSE5")
QSE5->(dbCloseArea())
dbSelectArea("SE5")

Return

/***********************************************************************************/

Static Function ValidPerg()

_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
aRegs	:=	{}

aAdd(aRegs,{cPerg,"40","Imprime Data         ?",Space(20),Space(20),"mv_chz","C",1,0,0,"C","","mv_par40","Vencimento","","","","","Vencimento Real","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.t.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return

/***********************************************************************************/

Static Function TemCancPos()

Local cQuery
Local lRet	:=	.f.    
Local aArea := GetArea()

cQuery	:=	" Select * "
cQuery	+=	" From " + RetSQLName("SE5")
cQuery	+=	" Where E5_TIPODOC IN ('VL','BA','ES') AND "
cQuery	+=		"    E5_FILIAL  = '" + NEWSE5->E5_FILIAL						+	"' and "
cQuery	+=		"    E5_PREFIXO = '" + NEWSE5->E5_PREFIXO						+	"' and "
cQuery	+=		"    E5_NUMERO  = '" + NEWSE5->E5_NUMERO 						+	"' and "
cQuery	+=		"    E5_PARCELA = '" + NEWSE5->E5_PARCELA						+	"' and "
cQuery	+=		"    E5_TIPO    = '" + NEWSE5->E5_TIPO   						+	"' and "
cQuery	+=		"    E5_CLIFOR  = '" + NEWSE5->E5_CLIFOR 						+	"' and "
cQuery	+=		"    E5_LOJA    = '" + NEWSE5->E5_LOJA   						+	"' and "
cQuery	+=		"    R_E_C_N_O_ > " 	+ AllTrim(Str(NEWSE5->SE5RECNO))		+	"  and "
cQuery	+=		"    D_E_L_E_T_ = ' ' "
cQuery	+=	" Order By R_E_C_N_O_ "   //Rafael - Coloca para ordenar os registros na ordem que foram baixados
cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "TTTQRY"

if	TTTQRY->(!Bof()) .and. TTTQRY->(!Eof()) .and. TTTQRY->E5_TIPODOC == "ES"
	lRet := .t.
endif

TTTQRY->(dbclosearea())

RestArea(aArea)

Return ( lRet )

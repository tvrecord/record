#Include "Protheus.ch"
#Include "TopConn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTCR102    ³ Autor ³ Edmilson D. Santos    ³ Data ³ 01.03.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Comunicado de Transferˆncias                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ATFR100                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
USER Function RTCR102()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL cString  :="SN4"
LOCAL cDesc1	:=OemToAnsi("Este relatorio ir   imprimir a movimenta‡„o de transferencia")
LOCAL cDesc2	:=OemToAnsi("dos bens em um periodo.")
LOCAL cDesc3	:=""
LOCAL wnrel
Local aPergs     := {}

PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE aLinha   := { }
PRIVATE cPerg    :="RTC102    "
PRIVATE NomeProg :="RTCR102"
PRIVATE nLastKey := 0
PRIVATE tamanho:="P"

PRIVATE titulo:=OemToAnsi("TRANSFERENCIAS DE BENS")
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPergs,{"Da Conta	   ?","","","mv_ch1","C",20,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Conta    ?","","","mv_ch2","C",20,0,0,"G","","MV_PAR02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do C.Custo   ?","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate C.Custo  ?","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Aquisicao ?","","","mv_ch5","D",8,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Aquisicao?","","","mv_ch6","D",8,0,0,"G","","MV_PAR06","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bem       ?","","","mv_ch7","C",10,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bem      ?","","","mv_ch8","C",10,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)
Pergunte(cPerg,.F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros           ³
//³ mv_par01         // Do Bem                     ³
//³ mv_par02         // Ate o Bem                  ³
//³ mv_par03         // Do C.Custo                 ³
//³ mv_par04         // Ate C. Custo               ³
//³ mv_par05         // Da Conta                   ³
//³ mv_par06         // Ate Conta                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RTCR102"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If  nLastKey == 27
	Return
End

SetDefault( aReturn,cString )

If  nLastKey == 27
	Return
End

RptStatus({|lEnd| FR100Imp(@lEnd,wnRel,cString)},Titulo)

Return


Static Function FR100Imp(lEnd,WnRel,cString)

Local nDecimal 	:= 0
Local cPicture	:= "@E 999,999,999"
Local nMoeda	:= mv_par03
//Local cMoeda	:= Alltrim(Str(mv_par03))
//Local cTitMoeda	:= Alltrim(GETMV("MV_MOEDAP"+cMoeda))
Local nResidual:=0,nValAtual:=0,nRec
Local nTotValor:=0,nTotDepr:=0,nTotResid:=0,nTotBaixa:=0
Local nGerValor:=0,nGerDepr:=0,nGerResid:=0,nGerBaixa:=0
Local cBase,cItem,cTipo
Local dData    := dDataBase
Local CbTxt
Local cbCont
Local limite:=132
Local x
LOCAL nTransfTot := 0  // Valor total transferido
Local	cAliasQry
Local	cAliasSn3
Local	cAliasSn1
Local cQuery
Local cTipoSn3
Local cDescric
Local dAquisic
Local cIndTmp, nIndex
Local cOrder
Local nA
Local cFilterUser:=aReturn[7]
Local aGeren := {}
Local cLocAnt
LOCAL oPrint

LOCAL oFont8
LOCAL oFont10
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i        := 0
#IFDEF TOP
	Local  aStru
#ENDIF
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

cMoedaAtf:=GetMv("MV_ATFMOEDA")
oPrint  := TMSPrinter():New("Autorização de Movimento de Ativo")
lImpBol := oPrint:Setup()		// Se retorna .T. imprime direto na impressora
IF !(lImpBol)
	RETURN
ENDIF
oPrint:SetPortrait()				// ou SetLandscape()
oPrint:SetPaperSize(9)			// Seta para papel A4
oPrint:StartPage()				// Inicia uma nova pagina


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := SPACE( 10 )
cbcont := 0
cMoeda1:=GetMV("MV_MOEDA1")
cMoeda2:=GetMV("MV_MOEDA"+cMoedaAtf)
nLen   :=Len(PesqPict("SN4","N4_VLROC1",14) ) - Len(AllTrim(cMoeda1))
cMoeda1:=IIf(nLen>0, Space(nLen)+cMoeda1,cMoeda1)
nLen   :=Len(PesqPict("SN4","N4_VLROC1",14) ) - Len(AllTrim(cMoeda2))
cMoeda2:=IIf(nLen>0, Space(nLen)+cMoeda2,cMoeda2)

cString:="SN4"
li     :=0
m_pag  :=1

///////////////////////////////////////
// Acrescenta a qtde de casas decimais,
// respeitando o configurado em MV_CENT
// Alteracao conforme BOPS 66.785
// Cristiano Denardi
//nDecimal := MSdecimais(nMoeda)
//For nA := 1 to nDecimal
//	If ( nA = 1 )
//		cPicture += "."
//	Endif
//	cPicture += "9"
//Next nA

titulo := Alltrim(titulo)
//titulo += OemToAnsi(STR0006)+DtoC(mv_par01) + OemToAnsi(STR0013) + DtoC(mv_par02) + OemToAnsi(STR0014) + If(!Empty(cTitMoeda),cTitMoeda,OemToAnsi(STR0015)) // #" entre " #" a " #" e Valores em " #"<INEXISTENTE>"
DbSelectArea("SN1")

cQuery := " SELECT N1_CBASE, N1_ITEM, N3_CCONTAB, N3_CUSTBEM,N3_CBASE,N3_ITEM,"
cQuery += "			N3_CCDEPR,N3_CDESP, N3_CCUSTO, N3_TIPO, N1_LOCAL, N1_DESCRIC, "
cQuery += "			N1_AQUISIC"
cQuery += " FROM "+RetSqlName("SN1")+" SN1,"
cQuery +=          RetSqlName("SN3")+" SN3 "
cQuery += " WHERE "
cQuery += "N1_CBASE   >= '"+MV_PAR07+"' AND "
cQuery += "N1_CBASE   <= '"+MV_PAR08+"' AND "
CQUERY += "N3_CCONTAB >= '"+MV_PAR01+"' AND "
CQUERY += "N3_CCONTAB <= '"+MV_PAR02+"' AND "
CQUERY += "N3_CUSTBEM >= '"+MV_PAR03+"' AND "
CQUERY += "N3_CUSTBEM <= '"+MV_PAR04+"' AND "
CQUERY += "N1_AQUISIC >= '"+DTOS(MV_PAR05)+"' AND "
CQUERY += "N1_AQUISIC <= '"+DTOS(MV_PAR06)+"' AND "
cQuery += "N1_FILIAL='"+xFilial("SN1")+"' AND "
cQuery += "N1_FILIAL= N3_FILIAL AND "
cQuery += "N1_CBASE = N3_CBASE AND "
cQuery += "N1_ITEM  = N3_ITEM  AND "
cQuery += "N3_FILIAL='"+xFilial("SN3")+"' AND "
cQuery += "SN1.D_E_L_E_T_=' '  AND "
cQuery += "SN3.D_E_L_E_T_=' ' 	   "
cQuery += " ORDER BY N1_FILIAL,N1_CBASE,N1_ITEM,N3_TIPO"

TCQUERY cQuery NEW ALIAS "TRB"

SetRegua((RecCount()))

While TRB->(!Eof())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta a regua       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()
	
	dbSelectArea("SN1")
	MsSeek(xFilial("SN1")+TRB->N3_CBASE+TRB->N3_ITEM)
	
	pItem :=TRB->N3_CBASE+TRB->N3_ITEM

	While TRB->(!Eof()) .AND. TRB->N3_CBASE+TRB->N3_ITEM == pItem

  		li+=200
 		oPrint:Say (li+0084,0300,"AUTORIZAÇÃO  DE  MOVIMENTAÇAO DE ATIVO",oFont20)					// [2] Nome do Banco
 		li+=100
 		oPrint:Say (li+0300,0100,"Plaqueta Patrimonio:",oFont14)					// [2] Nome do Banco
  		oPrint:Say (li+0300,0700,POSICIONE("SN1",1,xFilial("SN1")+TRB->N1_CBASE+TRB->N1_ITEM,"N1_CHAPA"),oFont15n)					// [2] Nome do Banco
  		li+=300
 		oPrint:Say (li+0100,0100,"Descricao do Bem:",oFont14)
		oPrint:Say (li+0100,0700,TRB->N1_DESCRIC,oFont15n)
	
		li+= 100
	
 		oPrint:Say (li+0100,0100,"Centro Custo Origem:",oFont14)
  		cCOrigem := POSICIONE("CTT",1,xFilial("CTT")+TRB->N3_CCUSTO,"CTT_DESC01")
 		oPrint:Say (li+0100,0700,cCOrigem,oFont15n)

		li+= 100
	
  		oPrint:Say (li+0100,0100,"Centro Custo Destino:",oFont14)
  		cCDestin := REPLICATE("_",40)
 		oPrint:Say (li+0100,0700," ",oFont15n)
 		li+=200
  		oPrint:Say (li+0100,0200,"Na qualidade de responsavel pelo Centro: "+cCorigem+", informo a",oFont15n)
  		li+=100
  		oPrint:Say (li+0100,0100,"Gerencia Administrativa e ao Depto de Contabilidade que o bem acima descrito esta sendo",oFont15n)
  		li+=100
  		oPrint:Say (li+0100,0100,"transferido/retirado para o Departamento: "+cCDestin,oFont15n)
	
  		li+= 300
  		oPrint:Say (li+0100,0200,SM0->M0_CIDCOB+" - "+SM0->M0_ESTCOB+", "+TRANSFORM(DAY(DDATABASE),"99")+" de "+MesExtenso(Month(Ddatabase))+" de "+STRZERO(YEAR(DDATABASE),4),oFont14)
	   
  		dbSelectArea("TRB")
  		DBSKIP()
	Enddo
	li+= 300
	oPrint:Say (li+0100,0300,"Assinatura:_____________________________________ "+ALLTRIM(cCorigem),oFont15n)
	li+= 100                         
	DBSELECTAREA("SND")
	DBSETORDER(2)
	DBSEEK(xFilial("SN3")+pItem,.T.)
	oPrint:Say (li+0100,0300,"Nome  :     "+POSICIONE("RD0",1,xFilial("RD0")+SND->ND_CODRESP,"RD0_NOME"),oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Função:",oFont15n)
	
	li+= 200
	oPrint:Say (li+0100,0300,"Assinatura:_____________________________________ C.Custo Destino ",oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Nome:",oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Função:",oFont15n)
	
	//li+= 200
	//oPrint:Say (li+0100,0300,"Assinatura:_____________________________________ Ativo",oFont15n)
	//li+= 100
	//oPrint:Say (li+0100,0300,"Nome:",oFont15n)
	//li+= 100
	//oPrint:Say (li+0100,0300,"Função:",oFont15n)
	
	li+= 200
	oPrint:Say (li+0100,0300,"Movimento Autorizado por:______________________________",oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Gerencia Administrativa :______________________________",oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Contabilidade:_________________________________________",oFont15n)
	li+= 100
	oPrint:Say (li+0100,0300,"Data:____/_____/_____",oFont15n)
	
	oPrint:EndPage()	// Finaliza a Pagina.
	oPrint:Preview()	// Visualiza antes de Imprimir.

ENDDO

// Fecha a query
dbSelectArea("TRB")
DbCloseArea()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ AjustaX1º Autor ³ Cristiano Denardi  º Data ³  27.10.03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Criacao de Perguntas no SX1                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ATFR100                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return()

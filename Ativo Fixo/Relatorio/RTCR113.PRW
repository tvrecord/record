#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTCR113   º Autor ³ Edmilson D. Santos º Data ³  25/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório Apolices de Seguro x Bens.					        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cliente Record                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function RTCR113(cApolIni,cApolFim,cSegIni,cSegFim)

Local cDesc1        := "Este programa emite o relatório Apólice de Seguro x Bens."
Local cDesc2        := ""
Local cDesc3        := ""
Local titulo     	  :="Apólices de Seguro x Bens"
Local nLin          := 80
Local Cabec11		  := "Apolice          Descricao                   Codigo Nome Red. Suguradora            Vigencia                  Valor Seguro"
Local Cabec22		  := ""
//                     "Apolice          Descricao                   Codigo Nome Red. Suguradora            Vigencia                  Valor Seguro
//                      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
//                      0         1         2         3         4         5         6         7         8         9        10        20

//                      032002168        SEGURO EQUIPAMENTOS         000001  BRADESCO AUTO/RE COMPANHIA  23/10/06-23/10/07              2.616,87

//                      Cod.do Bem   Item   Descricicao Sint.                Plaqueta    Aquisicao   Vlr.Aquisc.   Centro Custo
//                      001438       0000   TRIPE EM DURALUMINIO C/CABECA    001438      25/08/07     999,999.99   COMERCIALXXXXXXXXXXXXX
//                      001439       0000   TRIPE EM DURALUMINIO C/CABECA    001439      25/08/07     999,999.99   COMERCIALXXXXXXXXXXXXX

Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RTCR113" // Nome para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}	///"Zebrado"#"Administracao"
Private nLastKey    := 0
Private cPerg       := "RTC113    "
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 1
Private wnrel       := "RTCR113" // Nome do arquivo usado para impressao em disco
Private aOrd	     := {}			//// ARRAY COM O TEXTO DAS ORDENS DE IMPRESSAO
PRIVATE pCustAnt
Private cString := "SNB"
/*
dbSelectArea("SIX")
dbSetOrder(1)
If MsSeek("SNB",.F.)
While !SIX->(Eof()) .and. SIX->INDICE == "SNB" .and. SIX->ORDEM <= "2"
#IFDEF SPANISH
aAdd(aOrd,SIX->DESCSPA)
#ELSE
#IFDEF ENGLISH
aAdd(aOrd,SIX->DESCENG)
#ELSE
aAdd(aOrd,SIX->DESCRICAO)
#ENDIF
#ENDIF
SIX->(dbSkip())
EndDo
Else
aOrd 	:= {"Número da Apólice + Cod. Cia. Seguro","Cod. Cia. Seguro + Número da Apólice"}	///"Número da Apólice + Cod. Cia. Seguro"#"Cod. Cia. Seguro + Número da Apólice"
Endif
*/
aOrd 	:= {"Número da Apólice + Cod. Cia. Seguro","Cod. Cia. Seguro + Número da Apólice","Centro de Custo + Número da Apólice "}	///"Número da Apólice + Cod. Cia. Seguro"#"Cod. Cia. Seguro + Número da Apólice"

Pergunte(cPerg,.F.)

If !Empty(cApolIni) .or. !Empty(cApolFim)
	mv_par01 := cApolIni
	mv_par02 := cApolFim
Endif

If !Empty(cSegIni) .or. !Empty(cSegFim)
	mv_par03 := cSegIni
	mv_par04 := cSegFim
Endif

mv_par09 := space(9)
mv_par10 := "ZZZZZZZZZ"

If !Pergunte(cPerg,.T.)
	Return
Endif

If mv_par08 == 2															/// SE O FILTRO DE USUARIO FOR PARA O CADASTRO DE BENS
	cString := "SN1"														/// USA O cString NO CADASTRO DE BENS
Endif																		/// CASO CONTRARIO O SNB (Apolices) E O DEFAULT.

dbSelectArea("SNB")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)	/// SO FILTRO DE USUARIO E ORDENS DE IMPRESSAO

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| AFR310Run(Cabec11,Cabec22,Titulo,nLin) },Titulo)

Return


Static Function AFR310Run(Cabec11,Cabec22,Titulo,nLin)

Local cNBAPOLICE	:= RetTitle("NB_APOLICE")
Local cNBDESCRIC	:= RetTitle("NB_DESCRIC")
Local cNBCODSEG	:= RetTitle("NB_CODSEG")
Local cNBCSEGURO	:= RetTitle("NB_CSEGURO")
Local cVIGENCIA	:= "Vigencia"
Local cNBMOEDA		:= ""
Local cNBVLRSEG	:= RetTitle("NB_VLRSEG")
Local cN1CBASE		:= RetTitle("N1_CBASE")
Local cN1ITEM		:= RetTitle("N1_ITEM")
Local cN1DESCRIC	:= RetTitle("N1_DESCRIC")
Local cN1CHAPA		:= RetTitle("Plaqueta")
Local cN1LOCAL		:= RetTitle("N1_LOCAL")
Local cN1AQUISIC	:= RetTitle("N1_AQUISIC")
Local cN1BAIXA		:= RetTitle("N1_BAIXA")

Local nLenCol1		:= Len(CriaVar("NB_APOLICE"))
Local nLenCol2		:= Len(CriaVar("NB_DESCRIC"))
Local nLenCol3		:= Len(CriaVar("NB_CODSEG"))
Local nLenCol4		:= Len(CriaVar("NB_CSEGURO"))
Local nLenCol5		:= 17
Local nLenCol6 	:= 3
Local nLenCol7		:= 17
Local nLN1CBASE	:= Len(CriaVar("N1_CBASE"))
Local nLN1ITEM		:= Len(CriaVar("N1_ITEM"))
Local nLN1DESCRIC	:= Len(CriaVar("N1_DESCRIC"))
Local nLN1CHAPA	:= Len(CriaVar("N1_CHAPA"))
Local nLN1LOCAL	:= Len(CriaVar("N1_LOCAL"))
Local nLN1AQUISIC	:= 8					/// CAMPO DATA FIXO 8
Local nLN1BAIXA	:= 8					/// CAMPO DATA FIXO 8

Local nCol1 		:= 0					/// COLUNA PARA IMPRESSAO DO NUMERO DA APOLICE
Local nCol2 		:= 17					/// COLUNA PARA IMPRESSAO DA DESCRICAO DA APOLICE
Local nCol3 		:= 60					/// COLUNA PARA IMPRESSAO DO CODIGO DA SEGURADORA
Local nCol4 		:= 70					/// COLUNA PARA IMPRESSAO DO NOME DA SEGURADORA
Local nCol5 		:= 95					/// COLUNA PARA IMPRESSAO DA VIGENCIA (DATA INICIAL E FINAL)
Local nCol6			:= 113				/// COLUNA PARA IMPRESSAO DO SIMBOLO DE MOEDA
Local nCol7			:= 116				/// COLUNA PARA IMPRESSAO DO VALOR DO SEGURO
Local nColCBASE	:= 0
Local nColITEM		:= nColCBASE+nLN1CBASE+1
Local nColDESCRIC	:= nColITEM+nLN1ITEM+1
Local nColCHAPA	:= nColDESCRIC+nLN1DESCRIC+1
Local nColLOCAL	:= nColCHAPA+nLN1CHAPA+1
Local nColAQUISIC	:= nColLOCAL+nLN1LOCAL+1
Local nColBAIXA	:= nColAQUISIC+nLN1AQUISIC+1

Local cLstMoeda 	:= "1"
Local cSmbMoeda 	:= GetMv("MV_SIMB"+ALLTRIM(cLstMoeda))
Local n1St9			:= 4

dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek("NB_VLRSEG",.F.)
	cPicVLRSEG	:= ALLTRIM(SX3->X3_PICTURE)
	n1St9		:= At("9",cPicVLRSEG)
	If n1St9 <= 0
		n1St9 := 4
	Endif
	nLenCol7	:= Len(ALLTRIM(SUBSTR(cPicVLRSEG,n1St9,Len(cPicVLRSEG))))
Else
	nLenCol7	:= Len("99,999,999,999.99")
Endif

dbSelectArea("SNB")

If mv_par08 == 2											//// SE O FILTRO ESTIVER INDICADO PARA O CADASTRO DE BENS
	dbSelectArea("SN1")									//// ABRE O ALIAS
	If !Empty(aReturn[7])
		SET FILTER TO &(aReturn[7])					//// EFETUA O FILTRO
	Endif
	dbSelectArea("SNB")
Else															//// CASO CONTRARIO TRATA O FILTRO DEFAULT SOBRE O CADASTRO DE APOLICES
	If !Empty(aReturn[7])
		SET FILTER TO &(aReturn[7])
	Endif
Endif

SetRegua(RecCount())

dbSetOrder(aReturn[8])

If aReturn[8] == 1
	MsSeek(xFilial("SNB")+mv_par01,.T.)
ElseIF aReturn[8] == 2   //MODIFICADO ISTO
	MsSeek(xFilial("SNB")+mv_par03+mv_par01,.T.)
ELSE
	DBSELECTAREA("SN1")  //MODIFICADO
	MsSeek(xFilial("SN1")+mv_par09,.T.)
Endif

IF aReturn[8] <> 3
	
	While SNB->(!EOF()) .and. SNB->NB_APOLICE <= mv_par02 .and. SNB->NB_CODSEG <= mv_par04
		
		If lAbortPrint
			@nLin,00 PSAY "Cancelado pelo Usuario"
			Exit
		Endif
		
		IncRegua("Apolice de Seguro "+SNB->NB_APOLICE)
		
		If aReturn[8] == 1
			If SNB->NB_CODSEG < mv_par03 .or. SNB->NB_CODSEG > mv_par04
				SNB->(dbSkip())
				Loop
			Endif
		Else
			If SNB->NB_APOLICE < mv_par01 .or. SNB->NB_APOLICE > mv_par02
				SNB->(dbSkip())
				Loop
			Endif
		Endif
		
		If nLin > 70
			Cabec(Titulo,Cabec11,Cabec22,NomeProg,Tamanho,nTipo)						//// SEMPRE DEVE QUEBRAR O CABECALHO PARA CADA APOLICE
			nLin := 8
		Endif
		
		cKeySN1 := xFilial("SN1")+SNB->(NB_APOLICE+NB_CODSEG)
		
		dbSelectArea("SN1")
		dbSetOrder(5)
		If !MsSeek(cKeySN1)					//// SE NAO ENCONTRAR BEM ASSOCIADO A ESTA APOLICE
			If mv_par05 == 1				//// EMITE APOLICE SEM BENS ? = SIM
				@nLin,000 PSAY __PrtThinLine()
				nLin++         
				@nLin,0000 PSAY SNB->NB_APOLICE
				@nLin,0017 PSAY Left(SNB->NB_DESCRIC,27)
				@nLin,0046 PSAY SNB->NB_CODSEG
				@nLin,0053 PSAY SNB->NB_CSEGURO
				@nLin,0081 PSAY DTOC(SNB->NB_DTINI)+"-"+DTOC(SNB->NB_DTVENC)
				If cLstMoeda <> SNB->NB_MOEDA
					cLstMoeda := SNB->NB_MOEDA
					cSmbMoeda := GetMv("MV_SIMB"+ALLTRIM(cLstMoeda))
				Endif
				
				@nLin,0104 PSAY PADR(cSmbMoeda,3)
				@nLin,0109 PSAY SNB->NB_VLRSEG PICTURE  "@E 999,999,999.99"
				nLin++
				@nLin,0087 PSAY "Vlr Assegurado"
				@nLin,0104 PSAY cSmbMoeda
				@nLin,0109 PSAY SNB->NB_VLSEGUR PICTURE "@E 999,999,999.99"
				
			Endif
			SNB->(dbSkip())
			Loop							//// PASSA PARA A PROXIMA APOLICE
		Endif
		
		@nLin,000 PSAY __PrtThinLine()
		nLin++
		
		@nLin,0000 PSAY SNB->NB_APOLICE
		@nLin,0017 PSAY LEFT(SNB->NB_DESCRIC,27)
		@nLin,0046 PSAY SNB->NB_CODSEG
		@nLin,0053 PSAY SNB->NB_CSEGURO
		@nLin,0081 PSAY DTOC(SNB->NB_DTINI)+"-"+DTOC(SNB->NB_DTVENC)
		
		If cLstMoeda <> SNB->NB_MOEDA
			cLstMoeda := SNB->NB_MOEDA
			cSmbMoeda := GetMv("MV_SIMB"+ALLTRIM(cLstMoeda))
		Endif
		
		@nLin,0104 PSAY PADR(cSmbMoeda,3)
		@nLin,0109 PSAY SNB->NB_VLRSEG PICTURE "@E 999,999,999.99"
		nLin+=2
		
		@nLin,0087 PSAY "Vlr Assegurado"
		@nLin,0104 PSAY cSmbMoeda
		@nLin,0109 PSAY SNB->NB_VLSEGUR PICTURE "@E 999,999,999.99"
		If mv_par06 == 1	// SE O PARAMETRO 6 ESTIVER PARA IMPRIMIR OS BENS
			
			nLin+=2
			//// CABECALHO DOS BENS ASSOCIADOS A ESTA APOLICE
			@nLin,0000		PSAY "Cod.do Bem"
			@nLin,0013		PSAY "Item"
			@nLin,0020		PSAY "Descricao Sintetica"
			@nLin,0053		PSAY "Aquisicao"
			@nLin,0065		PSAY "Dt.Baixa"
			@nLin,0077		PSAY "Vlr.Aquisc."
			@nLin,0091		PSAY "Descricao C. Custo"
			@nLin,0112		PSAY "Forma Aquisicao"
			nLin++
			xValor := 0
			I		 := 0
			While SN1->(!Eof()) .and. cKeySN1 == SN1->(N1_FILIAL+N1_APOLICE+N1_CODSEG)
				
				If lAbortPrint
					@nLin,00 PSAY "Cancelado pelo Usuario"
					Exit
				Endif
				
				If mv_par07 == 2	// SE O PARAMETRO IMPR. BAIXADOS == "NAO"
					If !Empty(SN1->N1_BAIXA)
						SN1->(dbSkip())
						Loop
					Endif
				Endif
				
				DBSELECTAREA("SN3")
				DBSETORDER(1)
				SN3->(DBSEEK(xFilial("SN1")+SN1->N1_CBASE+SN1->N1_ITEM))
				
				IF SN3->N3_CCUSTO < MV_PAR09 .OR. SN3->N3_CCUSTO > MV_PAR10
					SN1->(DBSKIP())
					LOOP
				ENDIF
				
				If nLin > 55
					Cabec(Titulo,Cabec11,Cabec22,NomeProg,Tamanho,nTipo)						//// SEMPRE DEVE QUEBRAR O CABECALHO PARA CADA APOLICE
					nLin := 8
				Endif
				
				@nLin,0000	PSAY SN1->N1_CBASE
				@nLin,0013	PSAY SN1->N1_ITEM
				@nLin,0020	PSAY LEFT(SN1->N1_DESCRIC,27)
				@nLin,0054	PSAY DTOC(SN1->N1_AQUISIC)
				If !Empty(SN1->N1_BAIXA)
					@nLin,0065	PSAY DTOC(SN1->N1_BAIXA)
				Endif
				@nLin,0077	PSAY SN3->N3_VORIG1 PICTURE "@E 9,999,999.99"
				@nLin,0092  PSAY LEFT(POSICIONE("CTT",1,xFilial("CTT")+SN3->N3_CCUSTO,"CTT_DESC01"),20)
				IF SN1->N1_FORAQUI == "1"
					cDescAq := "Aquisicao"
				ELSEIF SN1->N1_FORAQUI == "2"
					cDescAq := "Leasing"
				ELSEIF SN1->N1_FORAQUI == "3"
					cDescAq := "Doacao"
				ELSEIF SN1->N1_FORAQUI == "4"
					cDescAq := "Financiamento"
				ELSEIF SN1->N1_FORAQUI == "5"
					cDescAq := "Comodato"
				ELSE
					cDescAq := "Outros"
				ENDIF
				@nLin,0112  PSAY cDescAq
				nLin++
				xValor += SN3->N3_VORIG1
				SN1->(dbSkip())
				I++
			EndDo
			IF I > 1
				@nLin,0010  PSAY "T o t a l ->"
				@nLin,0075	PSAY xValor PICTURE "@E 999,999,999.99"
				nLin++
			ENDIF
		Endif
		
		SNB->(dbSkip())
		
	EndDo
	
	IF nLin<> 80
		roda(cbcont,cbtxt,"M")
	ENDIF
	
	If mv_par08 == 2											//// SE O FILTRO ESTIVER INDICADO PARA O CADASTRO DE BENS
		dbSelectArea("SN1")										//// ABRE O ALIAS
		If !Empty(aReturn[7])
			SET FILTER TO
		Endif
		dbSelectArea("SNB")
	Else														//// CASO CONTRARIO TRATA O FILTRO DEFAULT SOBRE O CADASTRO DE APOLICES
		dbSelectArea("SNB")
		If !Empty(aReturn[7])
			SET FILTER TO
		Endif
		
	Endif
	
ELSE     

	Cabec1		  := "C.Custo      Descricao                         Codigo  Nome Red. Suguradora           Vigencia                Valor Seguro"
	Cabec2		  := "Apolice"
 
   cQry := "SELECT N1_CBASE,N1_ITEM,N1_AQUISIC,N1_BAIXA,N1_APOLICE,N1_FORAQUI,N1_CODSEG,N1_FILIAL,"
   cQry += "       NB_DTINI,NB_DTVENC,NB_VLSEGUR,NB_VLRSEG,NB_CSEGURO,NB_DESCRIC,NB_MOEDA,NB_APOLICE,NB_CODSEG,"
	cQry += "       N3_CBASE,N3_ITEM,N3_CUSTBEM,N3_AQUISIC,N3_VORIG1,N3_DTBAIXA,N3_HISTOR "
	cQry += "FROM "+RetSqlName("SN1")+" N1, "+RetSqlName("SNB")+" NB, "+RetSqlName("SN3")+" N3 "
	cQry += "WHERE N1.N1_FILIAL = NB.NB_FILIAL  AND "
	cQry += "      N1.N1_APOLICE= NB.NB_APOLICE AND "
	cQry += "      N1.N1_FILIAL = N3.N3_FILIAL  AND "
	cQry += "      N1.N1_CBASE  = N3.N3_CBASE   AND "
	cQry += "      N1.N1_ITEM   = N3.N3_ITEM    AND "
	cQry += "		N1.N1_APOLICE!= SPACE(LENgth(N1_APOLICE)) AND "
	cQry += "      NB.NB_APOLICE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQry += "      NB.NB_CSEGURO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += "      N3.N3_CUSTBEM BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND "
	cQry += "      N1.D_E_L_E_T_ != '*' AND "
	cQry += "      NB.D_E_L_E_T_ != '*' "
	cQry += "ORDER BY N1.N1_FILIAL,N3.N3_CUSTBEM,NB.NB_APOLICE,N3.N3_CBASE,N3.N3_ITEM"
	TCQUERY cQry NEW ALIAS "TRB"

	DBSELECTAREA("TRB")
	SetRegua(RecCount())
	
	pTotGer := 0
	
	While TRB->(!EOF()) 
	
	   pCcusto 	:= TRB->N3_CUSTBEM
	   ImpCcusto:= .T. 
		pTotCC   := 0
				
		While TRB->(!EOF()) .AND. TRB->N3_CUSTBEM == pCcusto
		                              
		   pApolice		 := TRB->NB_APOLICE
		   ImpApolice 	 := .T.
			pTotApo 		 := 0

			While TRB->(!EOF()) .AND. TRB->N3_CUSTBEM == pCcusto .AND. TRB->N1_APOLICE == pApolice
										
				If lAbortPrint
					@nLin,00 PSAY "Cancelado pelo Usuario"
					Exit
				Endif
		
				IncRegua("Centro de Custo "+TRB->N3_CUSTBEM)
		
				If nLin > 70
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)						//// SEMPRE DEVE QUEBRAR O CABECALHO PARA CADA APOLICE
					nLin := 9 
				Endif
		  
				IF ImpCcusto
					@nLin,000 PSAY "C.custo : "+TRB->N3_CUSTBEM 
					@nLin,022 PSAY POSICIONE("CTT",1,xFilial("CTT")+TRB->N3_CUSTBEM,"CTT_DESC01") 
					ImpCcusto := .F.
				ENDIF
            
            IF ImpApolice 
					nLin++
					@nLin,0000 PSAY TRB->NB_APOLICE
					@nLin,0012 PSAY LEFT(TRB->NB_DESCRIC,33)
					@nLin,0048 PSAY TRB->NB_CODSEG
					@nLin,0056 PSAY TRB->NB_CSEGURO
					@nLin,0084 PSAY STOD(TRB->NB_DTINI)            
					@nLin,0093 PSAY "-"
					@nLin,0094 psay STOD(TRB->NB_DTVENC)            
   				If cLstMoeda <> TRB->NB_MOEDA
						cLstMoeda := TRB->NB_MOEDA
						cSmbMoeda := GetMv("MV_SIMB"+ALLTRIM(cLstMoeda))
					Endif
					@nLin,0104 PSAY PADR(cSmbMoeda,3)
					@nLin,0109 PSAY TRB->NB_VLRSEG PICTURE "@E 999,999,999.99"
					nLin+=2
					@nLin,0087 PSAY "Vlr Assegurado"
					@nLin,0103 PSAY cSmbMoeda
					@nLin,0108 PSAY TRB->NB_VLSEGUR PICTURE "@E 999,999,999.99"				
					ImpApolice := .F.
					//////
					nLin+=2
					//// CABECALHO DOS BENS ASSOCIADOS A ESTA APOLICE
					@nLin,0000		PSAY "Cod.do Bem"
					@nLin,0013		PSAY "Item"
					@nLin,0020		PSAY "Descricao Sintetica"
					@nLin,0053		PSAY "Aquisicao"
					@nLin,0065		PSAY "Dt.Baixa"
					@nLin,0077		PSAY "Vlr.Aquisc."
					@nLin,0091		PSAY "Descricao C. Custo"
					@nLin,0112		PSAY "Forma Aquisicao"
					nLin++
					///////
            Endif

				If mv_par06 == 1	//.and. ImpApolice // SE O PARAMETRO 6 ESTIVER PARA IMPRIMIR OS BENS
			      /*
         		nLin+=2
					//// CABECALHO DOS BENS ASSOCIADOS A ESTA APOLICE
					@nLin,0000		PSAY "Cod.do Bem"
					@nLin,0013		PSAY "Item"
					@nLin,0020		PSAY "Descricao Sintetica"
					@nLin,0053		PSAY "Aquisicao"
					@nLin,0065		PSAY "Dt.Baixa"
					@nLin,0077		PSAY "Vlr.Aquisc."
					@nLin,0091		PSAY "Descricao C. Custo"
					@nLin,0112		PSAY "Forma Aquisicao"
					nLin++
					*/
					
					If mv_par07 == 2	// SE O PARAMETRO IMPR. BAIXADOS == "NAO"
						If !Empty(TRB->N1_BAIXA)
							TRB->(dbSkip())
							Loop
						Endif
					Endif
							
					If nLin > 70
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)						//// SEMPRE DEVE QUEBRAR O CABECALHO PARA CADA APOLICE
						nLin := 8
					Endif
				
					@nLin,0000	PSAY TRB->N1_CBASE
					@nLin,0013	PSAY TRB->N1_ITEM
					@nLin,0020	PSAY LEFT(TRB->N3_HISTOR,33)
					@nLin,0054	PSAY STOD(TRB->N1_AQUISIC)
					If !Empty(TRB->N1_BAIXA)
						@nLin,0065	PSAY STOD(TRB->N1_BAIXA)
					Endif
					@nLin,0077	PSAY TRB->N3_VORIG1 PICTURE "@E 9,999,999.99"
					@nLin,0092  PSAY LEFT(POSICIONE("CTT",1,xFilial("CTT")+TRB->N3_CUSTBEM,"CTT_DESC01"),20)
					IF TRB->N1_FORAQUI == "1"
						cDescAq := "Aquisicao"
					ELSEIF TRB->N1_FORAQUI == "2"
						cDescAq := "Leasing"
					ELSEIF TRB->N1_FORAQUI == "3"
						cDescAq := "Doacao"
					ELSEIF TRB->N1_FORAQUI == "4"
						cDescAq := "Financiamento"
					ELSEIF TRB->N1_FORAQUI == "5"
						cDescAq := "Comodato"
					ELSE
						cDescAq := "Outros"
					ENDIF
					@nLin,0112  PSAY cDescAq
					nLin++
					pTotApo   += TRB->N3_VORIG1
				
				EndIF
			
				TRB->(dbSkip())

			   IF TRB->N3_CUSTBEM <> pCcusto 
					@nLin,000 PSAY __PrtThinLine()
					nLin++
				ENDIF	
		
			EndDO
		   
		   //@ nLin,050 PSAY "Total Apolice: "
		   //@ nLin,077 PSAY pTotApo PICTURE "@E 9,999,999.99"
		   //nLin++
			//@nLin,000 PSAY __PrtThinLine()
			//nLin++
        
         pTotCC += pTotApo
		
		EndDo
	
		@ nLin,050 PSAY "Total C.Custo: "
		@ nLin,077 PSAY pTotCC  PICTURE "@E 9,999,999.99"
		nLin++ 
		@nLin,000 PSAY __PrtThinLine()
		nLin++

		pTotGer += pTotCC
			   
	ENDDO
   
   @ nLin,050 PSAY "Total Geral..: "
   @ nLin,077 PSAY pTotGer PICTURE "@E 9,999,999.99"
   nLin++
	
	IF nLin<> 80
		roda(cbcont,cbtxt,"M")
	ENDIF
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()

ENDIF

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

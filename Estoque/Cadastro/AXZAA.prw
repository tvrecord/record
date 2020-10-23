#INCLUDE "protheus.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXZA7     ºAutor  ³Rafael		        º Data ³  02/09/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de EPI                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AXZAA

	LOCAL aCores  		:= {;
		{"EMPTY(ZAA->ZAA_DTDEVO)","BR_VERDE"		},;
		{"!EMPTY(ZAA->ZAA_DTDEVO) .AND. ZAA->ZAA_QTDEVO < ZAA->ZAA_QTDENT .AND. ZAA->ZAA_QTDEVO > 0","BR_AMARELO"		},;
		{"!EMPTY(ZAA->ZAA_DTDEVO) .AND. (ZAA->ZAA_QTDEVO == ZAA->ZAA_QTDENT .OR. ZAA->ZAA_QTDEVO == 0)","BR_VERMELHO"	}}

	Private cCadastro 	:= "Controle de EPI"
	Private nOpca 		:= 0
	Private aParam 		:= {}
	Private lOk1 		:= .T.
	Private nOpca 		:= 0
	Private aButtons 	:= {}
	Private ExpA1 := {}
	Private ExpN2 := 3
	Private lOK2   := .T.
	Private cTipo := "1"


	aAdd( aParam,  {|| U_ZAABefore() } )  //antes da abertura
	aAdd( aParam,  {|| U_ZAATudoOK() } )  //ao clicar no botao ok
	aAdd( aParam,  {|| U_ZAATransaction() } )  //durante a transacao
	aAdd( aParam,  {|| U_ZAAFim() } )       //termino da transacao

	Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","U_AxIncZAA",0,3},;
		{"Alterar","AxAltera",0,4},;
		{"Excluir","AxDeleta",0,5},;
		{"Devolução","U_TelaZAA",0,4},;
		{"Legenda","U_LegZAA",0,6}}

	Private cString := "ZAA"

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function LegZAA

	BrwLegenda("Legenda","Controle de EPI",{;
		{ "BR_VERDE"    ,"Item com Funcionario"}	,;
		{ "BR_AMARELO"  ,"Item Parcialmente Devolvido"}	,;
		{ "BR_VERMELHO"	,"Item Devolvido"}	})

Return

User Function AxIncZAA()

	lOk2 := .T.
	nOpca := 0

	//AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
	nOpca := AxInclui("ZAA",ZAA->(Recno()), 3,, "U_ZAABefore",, "U_ZAATudoOk()", .F., "U_ZAATransaction", aButtons, aParam,,,.T.,,,,,)

Return nOpca

User function ZAABefore()

	lOk2 := .T.

Return .T.

User function ZAATudoOK()

	IF lOK2

		nSaldo := Posicione("SB2",1,xFilial("SB2") + M->ZAA_CODEPI + M->ZAA_LOCAL,"B2_QATU")

		IF M->ZAA_QTDENT > nSaldo
			MSGALERT("Saldo insuficiente em estoque. Saldo atual: " + STRZERO(nSaldo,3) ,"Saldo insuficiente!")
		ELSE
			lOk1 := .T.
		ENDIF

		IF lOk1

			ExpA1 := {}
			aCab  := {}
			aItem := {}
			aItem1 := {}
			lMsHelpAuto := .F.
			lMsErroAuto := .F.

			aadd(aCab,{"D3_FILIAL","01",NIL})
			aadd(aCab,{"D3_TM","998",NIL})
			//aadd(aCab,{"D3_DOC",_cNUMDOC,NIL})
			aadd(aCab,{"D3_EMISSAO",M->ZAA_DTENTR,NIL})
			aadd(aCab,{"D3_CC",Posicione("SRA",1,xFilial("SRA")+M->ZAA_MAT,"RA_CC"),NIL})
			aadd(aItem,{"D3_TM","998",NIL})
			//aadd(aItem,{"D3_DOC",M->ZAA_COD,NIL})
			aadd(aItem,{"D3_EMISSAO",M->ZAA_DTENTR,NIL})
			aadd(aItem,{"D3_CC",Posicione("SRA",1,xFilial("SRA")+M->ZAA_MAT,"RA_CC"),NIL})
			aadd(aItem,{"D3_COD",M->ZAA_CODEPI,NIL})
			aadd(aItem,{"D3_UM",Posicione("SB1",1,xFilial("SB1")+M->ZAA_CODEPI,"B1_UM"),NIL})
			aadd(aItem,{"D3_LOCAL",M->ZAA_LOCAL,NIL})
			aadd(aItem,{"D3_LOCALIZ",M->ZAA_END,NIL})
			aadd(aItem,{"D3_QUANT",M->ZAA_QTDENT,NIL})
			aadd(aItem,{"D3_CF","RE0",NIL})
			aadd(aItem,{"D3_GRUPO",Posicione("SB1",1,xFilial("SB1")+M->ZAA_CODEPI,"B1_GRUPO"),NIL})
			aadd(aItem,{"D3_CONTA",Posicione("SB1",1,xFilial("SB1")+M->ZAA_CODEPI,"B1_CONTA"),NIL})
			//aadd(aItem,{"D3_CUSTO1",M->ZAA_CUSTO,NIL})
			aadd(aItem,{"D3_TIPO",Posicione("SB1",1,xFilial("SB1")+M->ZAA_CODEPI,"B1_TIPO"),NIL})
			aadd(aItem,{"D3_OBS","TERMO DE ENTREGA " + M->ZAA_COD + " MATRICULA " + M->ZAA_MAT,NIL})

			aadd(aItem1,aItem)

			Begin Transaction
				MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem1,3)
				If lMsErroAuto
					DisarmTransaction()
					break
				EndIf
			End Transaction
			If lMsErroAuto
				//Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia.
				Mostraerro()
				Return .F.
			EndIf

			//MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)
			//If !lMsErroAuto
			//	MSGALERT("Erro na inclusao!","Erro")
			//EndIf
			//MSGALERT("Fim: "+Time(),"Tempo")

			dbSelectArea("TNF")
			dbSetOrder(1)

			RecLock("TNF",.T.)
			TNF->TNF_FILIAL 	:= xFilial("TNF")
			TNF->TNF_NUMCAP		:= "999999999999"
			TNF->TNF_MAT		:= M->ZAA_MAT
			TNF->TNF_CODEPI		:= M->ZAA_CODEPI
			TNF->TNF_FORNEC		:= M->ZAA_FORNEC
			TNF->TNF_LOJA		:= M->ZAA_LOJA
			TNF->TNF_DTENTR		:= M->ZAA_DTENTR
			TNF->TNF_HRENTR		:= M->ZAA_HRENTR
			TNF->TNF_QTDENT     := M->ZAA_QTDENT
			TNF->TNF_DTRECI     := M->ZAA_TDRECI
			TNF->TNF_CODFUN		:= M->ZAA_CODFUN
			TNF->TNF_INDDEV		:= M->ZAA_INDDEV
			TNF->TNF_DTDEVO		:= M->ZAA_DTDEVO
			TNF->TNF_MOTIVO		:= M->ZAA_MOTIVO
			TNF->TNF_LOCAL		:= M->ZAA_LOCAL
			TNF->TNF_ENDLOC		:= M->ZAA_END
			TNF->TNF_TIPODV		:= M->ZAA_TIPODV
			TNF->TNF_NUMSEQ		:= M->ZAA_NUMSEQ
			TNF->TNF_CUSTO		:= M->ZAA_CUSTO
			TNF->TNF_NSERIE		:= M->ZAA_NSERIE
			TNF->TNF_MATFUN		:= M->ZAA_MATFUN
			TNF->TNF_FUNNAM		:= M->ZAA_FUNNAM
			TNF->TNF_QTDEVO		:= M->ZAA_QTDEVO
			TNF->TNF_DIGIT1		:= M->ZAA_DIGIT1
			TNF->TNF_DIGIT2		:= M->ZAA_DIGIT2
			TNF->TNF_OBS		:= M->ZAA_OBS
			MsUnLock()

			dbSelectArea("TNF")
			dbCloseArea("TNF")

		ENDIF

		lOk2 := .F.

	ENDIF

Return lOk1

User function ZAATransaction()

	lOk2 := .T.

Return .T.

User function ZAAFim()

	lOk2 := .T.

Return .T.

User Function TelaZAA

	Private cCodigo 	:= ZAA->ZAA_COD
	Private cMat 		:= ZAA->ZAA_MAT
	Private cNome 		:= Posicione("SRA",1,xFilial("SRA")+ZAA->ZAA_MAT,"RA_NOME")
	Private nQTD 		:= ZAA->ZAA_QTDENT
	Private dEntrega	:= ZAA_DTENTR
	Private nCusto 		:= ZAA_CUSTO
	Private cEPI 		:= ZAA->ZAA_CODEPI
	Private cDescri 	:= ZAA->ZAA_DESC
	Private cLocal		:= ZAA->ZAA_LOCAL
	Private dDevol		:= CTOD("  /  /  ")
	Private nQTDDev		:= 000
	Private cObs		:= SPACE(50)

	Private aItems:= {'Sim','Nao'}
	Private oArquivo
	Private cArquivo

	IF !EMPTY(ZAA->ZAA_DTDEVO) .AND. (ZAA->ZAA_QTDEVO == ZAA->ZAA_QTDENT .OR. ZAA->ZAA_QTDEVO == 0)

		MsgInfo("EPI já foi devolvido pelo funcionário!","Atenção")
		Return

	ENDIF

	DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

	@ 000,000 TO 395,500 DIALOG oDlg TITLE "Devolução de EPIs"
	@ 015,005 SAY UPPER("Codigo  :  " + alltrim(cCodigo))
	@ 030,005 SAY UPPER("Data Entrega :  " + DTOC(dEntrega))
	@ 030,100 SAY UPPER("Funcionário :  " + alltrim(cMat) + " - " + SUBSTR(cNome,1,40))
	@ 045,005 SAY UPPER("EPI :  " + ALLTRIM(cEPI) + " - " + substr(cDescri,1,40))
	@ 060,005 SAY UPPER("Quantidade :  " + cValToChar(nQTD))
	@ 060,100 SAY UPPER("Valor :  ")
	@ 060,155 SAY nCusto PICTURE "@E 999,999.99"
	@ 075,005 SAY UPPER("Data Devolução :  ")
	@ 075,100 GET dDevol SIZE 050,020
	@ 090,005 SAY UPPER("Quantidade Devolvida :  ")
	@ 090,100 GET nQTDDev
	@ 105,005 SAY UPPER("Repor ao Estoque :  ")
	@ 105,100 COMBOBOX oArquivo ITEMS aItems SIZE 050,020 OF oDlg PIXEL FONT oFont
	@ 120,005 SAY "OBSERVAÇÃO :"
	@ 120,100 GET cObs
	@ 135,100 BUTTON "Devolver" SIZE 35,10 ACTION DevolveZAA(dDevol,nQtdDev,cObs)
	@ 135,150 BUTTON "Fechar" 	SIZE 35,10 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return

Static Function DevolveZAA(dDevol,nQtdDev,cObs)

	If Empty(dDevol) .OR. nQTDDev == 0
		MsgInfo("Informe a Data e a Quantidade da Devolução","VAZIO")
		Return
	Endif

	IF oArquivo == 'Sim'
		cTipo := "1"
	ElseIf oArquivo == 'Nao'
		cTipo := "2"
	endif

	IF cTipo == "1"

		dbSelectArea("ZAA")
		dbSetOrder(1)
		dbSeek(xFilial("ZAA") + cCodigo)

		ExpA1 := {}
		aCab  := {}
		aItem := {}
		aItem1 := {}
		lMsHelpAuto := .F.
		lMsErroAuto := .F.

		aadd(aCab,{"D3_FILIAL","01",NIL})
		aadd(aCab,{"D3_TM","498",NIL})
		//aadd(aCab,{"D3_DOC",_cNUMDOC,NIL})
		aadd(aCab,{"D3_EMISSAO",dDevol,NIL})
		aadd(aCab,{"D3_CC",Posicione("SRA",1,xFilial("SRA")+ZAA->ZAA_MAT,"RA_CC"),NIL})
		aadd(aItem,{"D3_TM","498",NIL})
		//aadd(aItem,{"D3_DOC",M->ZAA_COD,NIL})
		aadd(aItem,{"D3_EMISSAO",dDevol,NIL})
		aadd(aItem,{"D3_CC",Posicione("SRA",1,xFilial("SRA")+ZAA->ZAA_MAT,"RA_CC"),NIL})
		aadd(aItem,{"D3_COD",ZAA->ZAA_CODEPI,NIL})
		aadd(aItem,{"D3_UM",Posicione("SB1",1,xFilial("SB1")+ZAA->ZAA_CODEPI,"B1_UM"),NIL})
		aadd(aItem,{"D3_LOCAL",ZAA->ZAA_LOCAL,NIL})
		aadd(aItem,{"D3_LOCALIZ",ZAA->ZAA_END,NIL})
		aadd(aItem,{"D3_QUANT",nQTDDev,NIL})
		//aadd(aItem,{"D3_CF","RE0",NIL})
		aadd(aItem,{"D3_GRUPO",Posicione("SB1",1,xFilial("SB1")+ZAA->ZAA_CODEPI,"B1_GRUPO"),NIL})
		aadd(aItem,{"D3_CONTA",Posicione("SB1",1,xFilial("SB1")+ZAA->ZAA_CODEPI,"B1_CONTA"),NIL})
		//aadd(aItem,{"D3_CUSTO1",M->ZAA_CUSTO,NIL})
		aadd(aItem,{"D3_TIPO",Posicione("SB1",1,xFilial("SB1")+ZAA->ZAA_CODEPI,"B1_TIPO"),NIL})
		aadd(aItem,{"D3_OBS","TERMO DE DEVOLUCAO " + ZAA->ZAA_COD + " MATRICULA " + ZAA->ZAA_MAT,NIL})

		aadd(aItem1,aItem)

		Begin Transaction
			MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem1,3)
			If lMsErroAuto
				DisarmTransaction()
				break
			EndIf
		End Transaction
		If lMsErroAuto
			//Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia.
			Mostraerro()
			Return .F.
		EndIf

	Endif

	dbSelectArea("ZAA")
	dbSetOrder(1)
	dbSeek(xFilial("ZAA") + cCodigo)

	nQtdDev += ZAA->ZAA_QTDEVO

	RecLock("ZAA",.F.)
	ZAA->ZAA_DTDEVO := dDevol
	ZAA->ZAA_QTDEVO := nQtdDev
	ZAA->ZAA_DIGIT2 := cOBS
	ZAA->ZAA_TIPODV := cTipo
	ZAA->ZAA_INDDEV := "1"
	MsUnLock()

	dbSelectArea("TNF")
	dbSetOrder(1)
	dbSeek(xFilial("TNF")+ZAA->ZAA_FORNEC+ZAA->ZAA_LOJA+ZAA->ZAA_CODEPI+"999999999999"+ZAA->ZAA_MAT+DTOS(ZAA->ZAA_DTENTR)+ZAA->ZAA_HRENTR)

	nQtdDev += TNF->TNF_QTDEVO

	RecLock("TNF",.F.)
	TNF->TNF_INDDEV		:= "1"
	TNF->TNF_DTDEVO		:= dDevol
	TNF->TNF_TIPODV		:= cTipo
	TNF->TNF_QTDEVO		:= nQtdDev
	TNF->TNF_OBS		:= cOBS
	MsUnLock()

	dbSelectArea("TNF")
	dbCloseArea("TNF")

	Close(oDlg)

Return
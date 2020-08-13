#INCLUDE "protheus.ch"
#INCLUDE "Topconn.ch"
//+--------------------------------------------------------------------+
//| Rotina | MBRWMOD3| Autor | ARNALDO RAYMUNDO JR. |Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. |Cadastro de Compras x Investidores |
//+--------------------------------------------------------------------+
//| Uso | CURSO DE ADVPL |
//+--------------------------------------------------------------------+

User Function AXZA1()


Private cCadastro := "Cadastro de Transferencia"
Private aRotina := {}
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cAlias := "ZA1"
Private aCores := {}

AADD(aRotina,{ "Pesquisar","AxPesqui" ,0,1})
AADD(aRotina,{ "Visualizar" ,"U_Mod3All" ,0,2})
AADD(aRotina,{ "Incluir" ,"U_Mod3All" ,0,3})
AADD(aRotina,{ "Alterar" ,"U_Mod3All" ,0,4})
AADD(aRotina,{ "Excluir" ,"U_Mod3All" ,0,5})
AADD(aRotina,{"Legenda","u_LegendZA1()",0,4})
AADD(aRotina,{"Aprovar","u_Aprova()",0,2})
AADD(aRotina,{"Transferencia","u_MyATFA060()",0,2})
AADD(aRotina,{"Relatorio","u_RelTransf()",0,2})
AADD(aRotina,{"Ficha Trans.","u_RelAutTran()",0,2})

aCores := {{'!EMPTY(ZA1_PROCES)','BR_VERMELHO'},;
{'(AllTrim(cUserName) $ "Josiel Ferreira%" .AND. !EMPTY(ZA1_EXEC)) .OR. (!EMPTY(ZA1_ADM) .AND. AllTrim(cUserName) $ "Elenn%") .OR. (!EMPTY(ZA1_ADM) .AND. !EMPTY(ZA1_EXEC))','BR_VERDE'},;
{'EMPTY(ZA1_ADM) .OR. EMPTY(ZA1_EXEC)','BR_AZUL'}}

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse( 6,1,22,75,cAlias,,,,,,aCores)

Return

User Function Mod3All(cAlias,nReg,nOpcx)

Local cTitulo := "Cadastro de Transferencia"
Local cAliasE := "ZA1"
Local cAliasG := "ZA2"
Local cLinOk :=  "u_Validador"
Local cTudOk :=  "AllwaysTrue()"
Local cFieldOk:= "AllwaysTrue()"
Local aCposE := {}
Local nUsado, nX := 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case nOpcx==3; nOpcE:=3 ; nOpcG:=3 // 3 - "INCLUIR"
	Case nOpcx==4; nOpcE:=4 ; nOpcG:=4 // 4 - "ALTERAR"
	Case nOpcx==2; nOpcE:=2 ; nOpcG:=2 // 2 - "VISUALIZAR"
	Case nOpcx==5; nOpcE:=5 ; nOpcG:=5 // 5 - "EXCLUIR"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//RegToMemory("ZA1",(nOpcx==3 .or. nOpcx==4 )) // Se for inclusao ou alteracaopermite alterar o conteudo das variaveis de memoria
RegToMemory("ZA1",(nOpcx==3)) // Master Advpl - 04-09-12

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nUsado:=0
dbSelectArea("SX3")
dbSeek("ZA2")

aHeader:={}

While !Eof().And.(x3_arquivo=="ZA2")
	
	If Alltrim(x3_campo)== "ZA2_CODIGO"
		dbSkip()
		Loop
	Endif
	
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	
	dbSkip()
End

If nOpcx==4 // Alterar
	If !EMPTY(ZA1->ZA1_PROCES)
		Alert("Não é possivel alterar uma Pre Transferencia já executada!!")
		Return
	EndIf
	
EndIf

If nOpcx==5 // Excluir
	If !EMPTY(ZA1->ZA1_PROCES)
		Alert("Não é possivel excluir uma Pre Transferencia já executada!!")
		Return
	EndIf
EndIf


If nOpcx==3 // Incluir
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For nX:=1 to nUsado
		aCols[1,nX]:=CriaVar(aHeader[nX,2])
	Next
Else
	
	aCols:={}
	dbSelectArea("ZA2")
	dbSetOrder(1)
	dbSeek(xFilial()+M->ZA1_CODIGO)
	While !eof().and.ZA2_CODIGO==M->ZA1_CODIGO
		AADD(aCols,Array(nUsado+1))
		For nX:=1 to nUsado
			aCols[Len(aCols),nX]:=FieldGet(FieldPos(aHeader[nX,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif

If Len(aCols)>0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//aCposE := {"ZA1_CODIGO"}
	
	
	lRetMod3 := Modelo3(cTitulo, cAliasE, cAliasG, , cLinOk, cTudOk,nOpcE, nOpcG,cFieldOk)
	//			lRetMod3 := Modelo3(cTitulo, cAliasE, cAliasG, aCposE, cLinOk, cTudOk,nOpcE, nOpcG,cFieldOk)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetMod3
		
		If nOpcx == 3 // Inclusão
			
			DBSelectARea("ZA1")
			DBSetOrder(1)
			If DBSeek(xFilial("ZA1") + M->ZA1_CODIGO)
				Alert("Codigo duplicado, favor entrar em contato com o Administrador do Sistema...")
			else
				Reclock("ZA1",.T.)
				ZA1->ZA1_FILIAL     := xFilial("ZA1")
				ZA1->ZA1_CODIGO     := M->ZA1_CODIGO
				ZA1->ZA1_EMISSA     := M->ZA1_EMISSA
				ZA1->ZA1_USUARI     := M->ZA1_USUARI
				ZA1->ZA1_PROCES     := M->ZA1_PROCES
				ZA1->ZA1_MOTIVO     := M->ZA1_MOTIVO
				ZA1->ZA1_ADM     	:= M->ZA1_ADM
				ZA1->ZA1_EXEC     	:= M->ZA1_EXEC
				ZA1->ZA1_CCSOLI    	:= M->ZA1_CCSOLI
				ZA1->ZA1_CCDESC    	:= M->ZA1_CCDESC
				ZA1->ZA1_SOLICI    	:= M->ZA1_SOLICI
				ZA1->ZA1_CCD    	:= M->ZA1_CCD
				ZA1->ZA1_CCDEST    	:= M->ZA1_CCDEST
				MsUnlock()
				
				
				DBSelectArea("ZA1")
				
				i := 0
				
				For n := 1 to len(aCols)
					
					If aCols[n][len(aCols[n])] == .F.
						
						i++
						
						Reclock("ZA2",.T.)
						ZA2->ZA2_FILIAL	  	:= xFilial("ZA2")
						ZA2->ZA2_SEQ      	:= strzero(i,3)
						ZA2->ZA2_CODIGO    	:= M->ZA1_CODIGO
						ZA2->ZA2_CBASE		:= aCols[n][2]
						ZA2->ZA2_ITEM		:= aCols[n][3]
						ZA2->ZA2_TIPO		:= aCols[n][4]
						ZA2->ZA2_DESCRI     := aCols[n][5]
						ZA2->ZA2_GRUPO     	:= aCols[n][6]
						ZA2->ZA2_CC     	:= aCols[n][7]
						ZA2->ZA2_DESC     	:= aCols[n][8]
						ZA2->ZA2_CONTA      := aCols[n][09]
						ZA2->ZA2_CONTAD     := aCols[n][10]
						ZA2->ZA2_CTDEP      := aCols[n][11]
						ZA2->ZA2_CTDEPD     := aCols[n][12]
						ZA2->ZA2_CTACU      := aCols[n][13]
						ZA2->ZA2_CTACUD     := aCols[n][14]
						MsUnlock()
					EndIf
				Next
				
			eNDIF
			
		elseif nOpcx == 4 // 4 - "ALTERAR"
			
			dbSelectArea("ZA1")
			dbSelectArea("ZA2")
			ZA1->(dbSetOrder(1))
			ZA2->(dbSetOrder(1))
			ZA1->(DbGoto(nReg))
			
			
			Reclock("ZA1",.F.)
			ZA1->ZA1_FILIAL     := xFilial("ZA1")
			ZA1->ZA1_CODIGO     := M->ZA1_CODIGO
			ZA1->ZA1_EMISSA     := M->ZA1_EMISSA
			ZA1->ZA1_USUARI     := M->ZA1_USUARI
			ZA1->ZA1_PROCES     := M->ZA1_PROCES
			ZA1->ZA1_MOTIVO     := M->ZA1_MOTIVO
			ZA1->ZA1_ADM     	:= CTOD("//")
			ZA1->ZA1_EXEC     	:= CTOD("//")
			ZA1->ZA1_CCSOLI    	:= M->ZA1_CCSOLI
			ZA1->ZA1_CCDESC    	:= M->ZA1_CCDESC
			ZA1->ZA1_SOLICI    	:= M->ZA1_SOLICI
			ZA1->ZA1_CCD    	:= M->ZA1_CCD
			ZA1->ZA1_CCDEST    	:= M->ZA1_CCDEST
			MsUnlock()
			
			DBSelectArea("ZA2")
			DbGotop()
			
			n := 1
			For i:= 1 to len(aCols)
				If aCols[i,nUsado+1]
					If ZA2->(DBSEEK(xFilial("ZA2") + M->ZA1_CODIGO + aCols[i][2] + aCols[i,1]))
						RECLOCK("ZA2",.F.)
						ZA2->(DBDELETE())
						ZA2->(MSUNLOCK())
					else
						RECLOCK("ZA2",.T.)
						ZA2->ZA2_FILIAL	  	:= xFilial("ZA2")
						ZA2->ZA2_SEQ      	:= strzero(i,3)
						ZA2->ZA2_CODIGO    	:= M->ZA1_CODIGO
						ZA2->ZA2_CBASE		:= aCols[n][2]
						ZA2->ZA2_ITEM		:= aCols[n][3]
						ZA2->ZA2_TIPO		:= aCols[n][4]
						ZA2->ZA2_DESCRI     := aCols[n][5]
						ZA2->ZA2_GRUPO     	:= aCols[n][6]
						ZA2->ZA2_CC     	:= aCols[n][7]
						ZA2->ZA2_DESC     	:= aCols[n][8]
						ZA2->ZA2_CONTA      := aCols[n][09]
						ZA2->ZA2_CONTAD     := aCols[n][10]
						ZA2->ZA2_CTDEP      := aCols[n][11]
						ZA2->ZA2_CTDEPD     := aCols[n][12]
						ZA2->ZA2_CTACU      := aCols[n][13]
						ZA2->ZA2_CTACUD     := aCols[n][14]
						ZA2->(MSUNLOCK())
					endif
				Else
					If ZA2->(DBSEEK(xFilial("ZA2") + M->ZA1_CODIGO + aCols[i][2] + aCols[i,1]))
						RECLOCK("ZA2",.F.)
						ZA2->ZA2_FILIAL	  	:= xFilial("ZA2")
						ZA2->ZA2_SEQ      	:= strzero(i,3)
						ZA2->ZA2_CODIGO    	:= M->ZA1_CODIGO
						ZA2->ZA2_CBASE		:= aCols[n][2]
						ZA2->ZA2_ITEM		:= aCols[n][3]
						ZA2->ZA2_TIPO		:= aCols[n][4]
						ZA2->ZA2_DESCRI     := aCols[n][5]
						ZA2->ZA2_GRUPO     	:= aCols[n][6]
						ZA2->ZA2_CC     	:= aCols[n][7]
						ZA2->ZA2_DESC     	:= aCols[n][8]
						ZA2->ZA2_CONTA      := aCols[n][09]
						ZA2->ZA2_CONTAD     := aCols[n][10]
						ZA2->ZA2_CTDEP      := aCols[n][11]
						ZA2->ZA2_CTDEPD     := aCols[n][12]
						ZA2->ZA2_CTACU      := aCols[n][13]
						ZA2->ZA2_CTACUD     := aCols[n][14]
						ZA2->(MSUNLOCK())
					else
						RECLOCK("ZA2",.T.)
						ZA2->ZA2_FILIAL	  	:= xFilial("ZA2")
						ZA2->ZA2_SEQ      	:= strzero(i,3)
						ZA2->ZA2_CODIGO    	:= M->ZA1_CODIGO
						ZA2->ZA2_CBASE		:= aCols[n][2]
						ZA2->ZA2_ITEM		:= aCols[n][3]
						ZA2->ZA2_TIPO		:= aCols[n][4]
						ZA2->ZA2_DESCRI     := aCols[n][5]
						ZA2->ZA2_GRUPO     	:= aCols[n][6]
						ZA2->ZA2_CC     	:= aCols[n][7]
						ZA2->ZA2_DESC     	:= aCols[n][8]
						ZA2->ZA2_CONTA      := aCols[n][09]
						ZA2->ZA2_CONTAD     := aCols[n][10]
						ZA2->ZA2_CTDEP      := aCols[n][11]
						ZA2->ZA2_CTDEPD     := aCols[n][12]
						ZA2->ZA2_CTACU      := aCols[n][13]
						ZA2->ZA2_CTACUD     := aCols[n][14]
						ZA2->(MSUNLOCK())
					endif
				Endif
				n++
			Next
			
			
		elseif nOpcx == 5 // 5 - "EXCLUIR"
			
			dbSelectArea("ZA1")
			dbSelectArea("ZA2")
			ZA1->(dbSetOrder(1))
			ZA2->(dbSetOrder(1))
			
			ZA1->(DbGoto(nReg))
			Reclock("ZA1",.F.)
			ZA1->(DBDELETE())
			ZA1->(MSUNLOCK())
			
			For i:= 1 to len(aCols)
				ZA2->(DBSEEK(xFilial("ZA2") + M->ZA1_CODIGO + aCols[i][2] + aCols[i,1]))
				Reclock("ZA2",.F.)
				ZA2->(DBDELETE())
				ZA2->(MSUNLOCK())
			Next
			
			dbSelectArea("ZA1")
			dbSelectArea("ZA2")
			ZA1->(dbSetOrder(1))
			ZA2->(dbSetOrder(1))
			
			
			
		Endif
	Endif
Endif


Return

User Function Validador()

Local lRetorno := .T.

If aCols[n][len(aCols[n])] == .F. // Os deletados não passam pela validação
	
	If !EMPTY(POSICIONE("SN1",1,xFilial("SN1") + aCols[n][2] + aCols[n][3],"N1_BAIXA"))
		Alert("Não pode transferir um imobilizado que já foi baixado, favor verificar")
		lRetorno := .F.
	ENDIF
	
EndIf

Return(lRetorno)

User Function LEGENDZA1()

Local aLegenda := {{"BR_VERDE","Liberado"},{"BR_VERMELHO","Transferido"},{"BR_AZUL","Bloqueado"}}

BrwLegenda("Cadastro de Transferencia","Legenda",aLegenda)

Return(.t.)

User Function Aprova()


DBSelectARea("ZA1")
DBSetOrder(1)
If !DBSeek(xFilial("ZA1") + ZA1->ZA1_CODIGO)
	Alert("Transferencia não localizada!")
else
	
	If MsgYesNo("Tem certeza que deseja aprovar a Transferencia Nº: " + (ZA1->ZA1_CODIGO) + " ?")
		
		If AllTrim(Substring(cUsuario,7,15)) $ "Eleni Caldeira (Elenn)%Josiel Ferreira%Wagner Lima%Artur Fernandes Dias Junior"
			
			If AllTrim(Substring(cUsuario,7,15)) $ "Eleni Caldeira (Elenn)%"
				
				If EMPTY(ZA1->ZA1_ADM)
					Reclock("ZA1",.F.)
					ZA1->ZA1_ADM     	:= DDATABASE
					MsUnlock()
					MsgInfo("Nivel Liberado com sucesso!","Aprovação")
				Else
					MsgInfo("Nivel já Liberado!","Aprovação")
				EndIf
				
			EndIf
			
			If AllTrim(Substring(cUsuario,7,15)) $ "Wagner Lima%Artur Fernandes Dias Junior%"
				If EMPTY(ZA1->ZA1_EXEC)
					Reclock("ZA1",.F.)
					ZA1->ZA1_EXEC     	:= DDATABASE
					MsUnlock()
					MsgInfo("Nivel Liberado com sucesso!","Aprovação")
				Else
					MsgInfo("Nivel já Liberado!","Aprovação")
				EndIf
			EndIf
			
		else
			
			MsgInfo("Usuário não autorizado!","Aprovação")
			
		EndIf
		
		
		
	EndIf
	
EndIf

Return

//Fazer a transferencia de todos os ativos automaticamente

User Function  MyATFA060()


Private aDadosAuto := {}		// Array com os dados á serem enviados pela MsExecAuto() para gravação automática.
Private aParam := {}  // Parametro do execauto
Private lMsHelpAuto := .f.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log.
Private lMsErroAuto := .f.	// Determina se houve alguma inconsistência na execução da rotina em relação aos
Private cQuery := ""
Private nRec  := 0
Private lRet := .T.

dData := DDATABASE

IF dData <= GetMv("MV_ULTDEPR") .Or. dData > LastDay(GetMv("MV_ULTDEPR")+1)
	//Tipo Depreciacao diferente 02-Mes Subsequente
	MsgInfo("A transferência só pode ocorrer no mês imediatamente posterior ao último cálculo mensal de correção e depreciação")
	lRet := .F.
ElseIF dData < (FirstDay(GetMv("MV_ULTDEPR")))
	MsgInfo("A transferência só pode ocorrer no mês imediatamente posterior ao último cálculo mensal de correção e depreciação")
	lRet := .F.
Endif

If lRet == .T.
	If EMPTY(ZA1->ZA1_PROCES)
		
		If !EMPTY(ZA1->ZA1_ADM) //.AND. !EMPTY(ZA1->ZA1_EXEC)Retirado o acesso do Sr. Adauto no dia 16/05/2014
			If MsgYesNo("Tem certeza que deseja executar a Transferencia Nº: " + (ZA1->ZA1_CODIGO) + " ?")
				Processa({|| ProPreTran() },"Transferindo...")
			EndIf
		else
			MsgInfo("Transferencia não aprovada!","Aprovação")
		EndIf
		
	Else
		
		MsgInfo("Transferencia já executada!","Aprovação")
		
	Endif
EndIf




Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O exemplo abaixo foi considerado passando somente dados de conta contabil e centro de custo, caso ³
//³ necessário passar os campos referentes a itens contábeis e classes de valores.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function ProPreTran()

cQuery := "SELECT * FROM ZA2010 WHERE "
cQuery += "ZA2_CODIGO = '" + (ZA1->ZA1_CODIGO) + "' AND "
cQuery += "D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ZA2_SEQ "

TcQuery cQuery New Alias "TMP1"

COUNT TO nRec

DBSelectArea("TMP1")
DbGotop()

procregua(nRec)

While !EOF()
	
	IncProc("Transferindo Ativo Fixo:   " + TMP1->ZA2_CODIGO)
	
	aDadosAuto:= {	{	'N3_FILIAL'  , TMP1->ZA2_FILIAL			, Nil},;  //Código base do ativo
	{'N3_TIPO'    , TMP1->ZA2_TIPO	, Nil},;	// Item sequencial do código bas do ativo
	{'N3_CBASE'   , TMP1->ZA2_CBASE	, Nil},;	// Item sequencial do código bas do ativo
	{'N3_ITEM'    , TMP1->ZA2_ITEM	, Nil},;	// Item sequencial do código bas do ativo
	{'N4_DATA' 	  , dData, Nil},;	// Data de aquisição do ativo
	{'N3_CCUSTO'  , POSICIONE("ZA1",1,xFilial("ZA1") + TMP1->ZA2_CODIGO,"ZA1_CCD")	 , Nil},;	// Centro de Cuso de Despesa
	{'N3_CCONTAB' , IIF(EMPTY(TMP1->ZA2_CONTAD),TMP1->ZA2_CONTA,TMP1->ZA2_CONTAD) , Nil},;	// Conta Contabil
	{'N3_CCORREC' , "", Nil},;	// Conta de Correcao do Bem
	{'N3_CDEPREC' , IIF(EMPTY(TMP1->ZA2_CTDEPD),TMP1->ZA2_CTDEP,TMP1->ZA2_CTDEPD), Nil},;	// Conta Despesa Depreciação
	{'N3_CCDEPR'  , IIF(EMPTY(TMP1->ZA2_CTACUD),TMP1->ZA2_CTACU,TMP1->ZA2_CTACUD), Nil},;	// Conta Depreciação Acumulada
	{'N3_CDESP'   , "", Nil},;	// Conta Correção Depreciação
	{'N3_CUSTBEM' , POSICIONE("ZA1",1,xFilial("ZA1") + TMP1->ZA2_CODIGO,"ZA1_CCD"), Nil},;	// Centro de Custo da Conta do Bem
	{'N3_CCCORR'  , "", Nil},;	// Centro Custo Correção Monetária
	{'N3_CCDESP'  , POSICIONE("ZA1",1,xFilial("ZA1") + TMP1->ZA2_CODIGO,"ZA1_CCD"), Nil},;	// Centro Custo Despesa Depreciação
	{'N3_CCCDEP'  , "", Nil},;	// Centro Custo Despesa Acumulada
	{'N3_CCCDES'  , "", Nil},;	// Centro Custo Correção Depreciacão
	{'N1_GRUPO'   , TMP1->ZA2_GRUPO	, Nil}}	// Código do Grupo do Bem
	
	
	If !EMPTY(TMP1->ZA2_CONTAD) .OR. !EMPTY(TMP1->ZA2_CTDEPD) .OR. !EMPTY(TMP1->ZA2_CTACUD)
		
		aParam:= {	{	'MV_PAR01'  , 1			, Nil},;  // Contabiliza
		{'MV_PAR02'    , 1	, Nil},;	// Mostra lançamento
		{'MV_PAR03'   , 2   , Nil}}	// Aglutina lançamento
		
	Else
		
		aParam:= {	{	'MV_PAR01'  , 2			, Nil},;  // Contabiliza
		{'MV_PAR02'    , 2	, Nil},;	// Mostra lançamento
		{'MV_PAR03'   , 2   , Nil}}	// Aglutina lançamento
		
	EndIf
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso deseje passar valores para os campos, Grupo, Local, NF/Serie Taxa padrao, considerar ³
	//³ como no exemplo acima utilizando os campos correspondentes da tabela SN1.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	MSExecAuto({|x, y, z| AtfA060(x, y, z)},aDadosAuto,4,aParam)
	
	
	// Transfere os dois tipo, 01 e o 10
	// Evita a necessidade de incluir dois imobilizados iguais com tipos diferentes
	DBSElectAREa("SN3")
	DBSEtOrder(1)
	iF(DBSeek(aDadosAuto[1][2]+aDadosAuto[3][2]+aDadosAuto[4][2]+IIF(aDadosAuto[2][2]=="01","10","01")))
		aDadosAuto[2][2] := IIF(aDadosAuto[2][2]=="01","10","01")
		MSExecAuto({|x, y, z| AtfA060(x, y, z)},aDadosAuto,4,aParam)
	EndIf
	
	DbSelectArea("ZA1")
	DBSetOrder(1)
	If DBSEEK(xFilial("ZA1") + TMP1->ZA2_CODIGO)
		
		Reclock("ZA1",.F.)
		ZA1->ZA1_PROCES := DDATABASE
		MsUnlock()
		
	EndIf
	
	
	If lMsErroAuto
		lRetorno := .F.
		MostraErro()
	Else
		lRetorno:=.T.
	EndIf
	
	DBSelectArea("TMP1")
	dbsKIP()
	
EndDo

DBCLOSEAREA("TMP1")

Return

#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT20FOPOS ºAutor  ³Bruno Alves         º Data ³  02/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cadastrar e inserir a conta contabil no fornecedor       º±±
±±º          ³  no ato da inclusao automaticamente                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT20FOPOS


Local nOpcA :=PARAMIXB[1]         //-- Rotina de customização do usuário
Local nX,nY
Local _lOk := .T.
Local aRecSX7 := {}
Local aItens := {}
Local aCab := {}

PRIVATE lMsErroAuto := .F.

//MsgAlert('Passei aqui!')

// If incluir um novo fornecedor, cadastre automaticamente a conta contabil e inseri a nova conta contabil no cadastro do fornecedor gravado na memoria
If nOpcA == 3
	
	
	
	//Exemplo de rotina automática para inclusão de contas contábeis no ambiente Contabilidade Gerencial (SigaCTB).
	/// ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB
	
	aCab := { {'CT1_CONTA' ,"211" + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4) ,NIL},;
	{'CT1_DESC01' ,SUBSTR(M->A2_NOME,1,40) ,NIL},;
	{'CT1_CLASSE' ,'2' ,NIL},;
	{'CT1_NORMAL' , '2' ,NIL},;
	{'CT1_NTSPED' , '02' ,NIL},;
	{'CT1_INDNAT' , '2' ,NIL} }
	
	
	//as linhas da getdados do plano referencial sempre devem ser do mesmo plano
	aAdd(aItens,{  {'CVD_FILIAL'  	,CVD->(xFilial('CVD'))   , NIL},;
	{'CVD_CONTA'  	,PadR("211" + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4),Len(CVD->CVD_CONTA))   , NIL},;
	{'CVD_ENTREF' 	,'10'   , NIL},; // Entidade
	{'CVD_CTAREF'  	,PadR('2.01.01.01.00', Len(CVD->CVD_CTAREF)) , NIL},;
	{'CVD_TPUTIL'  	,'A' , NIL},;
	{'CVD_CODPLA'  	,PadR('003',Len(CVD->CVD_CODPLA)) , NIL},;     // Plano Referencial
	{'CVD_CUSTO'  	,PadR('',Len(CVD->CVD_CUSTO)) , NIL} } )
	
	
	//necessario jogar para variavel de memoria os campos do acols
	
	For nX := 1 TO Len(aItens)
		For nY := 1 TO Len(aItens[nX])
			_SetOwnerPrvt( aItens[nX,nY,1], aItens[nX,nY,2] )
		Next
	Next
	//necessario retirar os gatilhos da tabela "CVD" para nao influir na inclusao dos itens da grade
	
	dbSelectArea("SX7")
	dbSetOrder(1)
	dbSeek("CVD_")
	While ! Eof() .And. Left(x7_campo,4) == "CVD_"
		aAdd(aRecSX7, Recno())
		
		//salva os recnos para recuperar depois da msexecauto
		
		Reclock("SX7", .F.)
		dbDelete()
		MsUnlock()
		dbSkip()
		
	EndDo
	
	MSExecAuto( {|X,Y,Z| CTBA020(X,Y,Z)} ,aCab , 3, aItens)
	
	If lMsErroAuto <> Nil
		If !lMsErroAuto
			_lOk := .T.
			If !IsBlind()
				MsgInfo('Conta Contabil Incluida com sucesso!')
			EndIf
		Else
			_lOk := .F.
			If !IsBlind()
				MostraErro()
				MsgAlert('Erro na inclusao da Conta Contabil!')
			Endif
		EndIf
	EndIf
	
	//volta os gatilhos para inclusao manual das amarracoes a conta referencial
	
	dbSelectArea("SX7")
	For nX := 1 TO Len(aRecSX7)
		dbGoto(aRecSX7[nX])
		Reclock("SX7", .F.)
		dbRecall()
		MsUnlock()
	Next
	
	
	DbSelectArea("SA2")
	DBSetOrder(1)
	If DBSeek(xFilial("SA2") + M->A2_COD)
		
		Reclock("SA2", .F.)
		SA2->A2_CONTA := "211" + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4)
		MsUnlock()
		
	Else
		
		Alert("ERRO na inserção do código da conta contabil no cadastro do Fornecedor, FAVOR VERIFICAR!!!")
		
	EndIf	
	
U_AVISOFOR()
	
	
	
	
EndIf





Return

User Function AVISOFOR()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AVISOFOR  ºAutor  ³Bruno Alves         º Data ³  20/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Enviar e-mail toda vez que cadastrar um novo fornecedor   º±±
±±º          ³  													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""



	
	cEmail := "contabilidade@recordtvdf.com.br"//;Controladoria@recordtvdf.com.br;Almoxarifado@recordtvdf.com.br;COMPRAS@recordtvdf.com.br;jdosilva@recordtvdf.com.br"
	cTitulo	:= 	"Um novo Fornecedor foi incluído! " //+ SZP->ZP_COD + ""
	
		
		
	cBody   += "Codigo: " + M->A2_COD + "" + Chr(13) + Chr(10)
	cBody 	+= "Descrição: " + M->A2_NOME + "" + Chr(13) + Chr(10)  
	cBody 	+= "Grupo: " + M->A2_GRUPC + "" + ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZU" + M->A2_GRUPC,"X5_DESCRI")) + "" + Chr(13) + Chr(10) 	+ Chr(13) + Chr(10)  + Chr(13) + Chr(10)  + Chr(13) + Chr(10)  + Chr(13) + Chr(10)  

	
	


	
	
	
	// Conecta com o Servidor SMTP
	CONNECT SMTP SERVER "smtp.recordtvdf.com.br" ;
	ACCOUNT "microsiga" PASSWORD "record@10" ;
	RESULT lOk
	If lOk
		//   MsgStop( "Conexão OK" )
		SEND MAIL FROM "microsiga@recordtvdf.com.br" ;
		TO cEmail ;
		SUBJECT cTitulo ;
		BODY cBody ;
		RESULT lOk
		If lOk
			MsgInfo( "E-mail enviado com sucesso" )
		Else
			GET MAIL ERROR cSmtpError
			MsgSTop( "Erro de envio : " + cSmtpError)
		Endif
		// Desconecta do Servidor
		DISCONNECT SMTP SERVER
	Else
		GET MAIL ERROR cSmtpError
		MsgStop( "Erro de conexão : " + cSmtpError)
	Endif

Return




#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC ºAutor  ³Edmilson D. Santos   º Data ³  10/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validacao da inclusao do contas a Pagar±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Clientes Microsiga                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050INC()

PRIVATE lRetorna := .T.
// Grava a Posicao atual
aSvAlias :={Alias(),IndexOrd(),Recno()}

dbSelectArea("SE2")
nRegistro:=Recno()
dbSetOrder(1)

lRetorna := .T.

IF ALLTRIM(FUNNAME()) $ "FINA050/FINA750"
	
	IF M->E2_RATEIO == "S"
		//M->E2_CCD   := Vazio()
		lRetorna    := .T.
	ELSE
		//M->E2_CCD   := NaoVazio()
		IF EMPTY(M->E2_CCD).AND. TRIM(M->E2_TIPO) <> "PA" .AND. M->E2_PREFIXO <> "GPE" .AND. !SE2->E2_FORNECE $ "001105,000175"
			Help(" ",1,"E2_CCD")
			lRetorna    := .F.
		ENDIF
	ENDIF
	
	U_RTCTBA04()
	
	// Retorna a Posicao atual Gravada
ENDIF


IF 	lRetorna == .T.  .AND. ALLTRIM(FUNNAME()) $ "FINA050/FINA750" .AND. XFILIAL()== "01" .AND. EMPTY(M->E2_AUTORIZ)
	
	IF EMPTY(M->E2_AUTORIZ) .AND. Posicione("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_AUTNF")  == "2" .OR. ;  //25/07/14 Sra Elenn, Naturezas que não precisam de autorização
		EMPTY(M->E2_AUTORIZ) .AND. Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE,"A2_AUTNF")  == "2"  //25/07/14 Sra Elenn, Fornecedores que não precisam de autorização
		
	ELSE
		lRetorna := .F.                                                                                                                                              
		Aviso("Informe a autorização de pagamento","Caro Usuário, você só poderá incluir títulos para essa natureza que tenham autorização de pagamento liberada com mesmo fornecedor. Favor informar a autorização correta!",{"Ok"}, 2)
	endif
	
ELSEIF lRetorna == .T.  .AND. ALLTRIM(FUNNAME()) $ "FINA050/FINA750" .AND. XFILIAL() == "01" .AND. !EMPTY(M->E2_AUTORIZ) //Verifica se autorização esta liberada e pertence ao mesmo fornecedor
	
	IF Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_LIBERAD") <> "L" 
		lRetorna := .F.
		Aviso("Autorização de pagamento não foi liberada","Caro Usuário, você só poderá incluir títulos para essa natureza que tenham autorização de pagamento liberada com mesmo fornecedor. Favor informar a autorização correta!",{"Ok"}, 2)
	ELSEIF Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_LIBERAD") == "L" .AND.  ALLTRIM(Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_FORNECE")) <> ALLTRIM(M->E2_FORNECE)
		lRetorna := .F.
		Aviso("Autorização de pagamento incorreta","Caro Usuário, você só poderá incluir títulos para essa natureza que tenham autorização de pagamento liberada com mesmo fornecedor. Favor informar a autorização correta!",{"Ok"}, 2)
	ENDIF  
	
	
Endif


dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return lRetorna

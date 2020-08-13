#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXSZP     º Autor ³ RAFAEL FRANCA      º Data ³  12/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CADASTRO DE ORDENS DE SERVICO.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORD DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AXSZP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cCadastro := "Ordens de Servico"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","U_inclui()",0,3,} ,;
{"Alterar","U_AxAlteSZP()",0,4} ,;  //Chamados liberados nao poderao ser alterados
{"Excluir","AxDeleta",0,5} ,;
{"E-Mail","u_tstSMTP()",0,2},;
{"Imprime","u_Pendencia()",0,2},;
{"Libera/Cancela","u_LibAprov()",0,2},; //Programa de Liberacao do chamado
{"Legenda","u_LegenSZP()",0,4}}
Private aCores := {{'ZP_STATUS == "2"','BR_AMARELO'},{'!EMPTY(ZP_CANCEL)','BR_VERMELHO'},{'EMPTY(ZP_CONCLUS)','BR_AZUL'},{'!EMPTY(ZP_CONCLUS)','BR_VERDE'}}
// aCores: Verde = Liberado, Azul = Pendente e Vermelho = Liberado e concluido
//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZP"


dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function Inclui()
Local nOpca := 0
Local aParam := {}
Private  aButtons := {}
Private cCadastro := "Ordem de Serviço" // título da tela
Private lOk1 := .T.


//adiciona botoes na Enchoice
//aAdd( aButtons, { "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botão Teste" } )

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam,  {|| U_Before() } )  //antes da abertura
aAdd( aParam,  {|| U_TudoOK1() } )  //ao clicar no botao ok
aAdd( aParam,  {|| U_Transaction() } )  //durante a transacao
aAdd( aParam,  {|| U_Fim() } )       //termino da transacao

dbSelectArea("SZP")
//AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
nOpca := AxInclui("SZP",SZP->(Recno()), 3,, "U_Before",, "U_TudoOk1()", .F., "U_Transaction", aButtons, aParam,,,.T.,,,,,)
Return nOpca


User function Before()
Return .T.

User function TudoOK1()

lOk1 := .T.

If !EMPTY(M->ZP_PRAZO) .OR. !EMPTY(M->ZP_CONCLUS)
	If AllTrim(cUserName) $ "LUIZ%Eleni%Josiel Ferreira%Administrador%Wagner Lima%"
		lOk1 := .T.
	else
		lOk1 := .F.
		Alert("Sem permissão no preenchimento da Data do Prazo e Data de Conclusão!!")
	EndIf
EndIf

Return lOk1

User function Transaction()
Return .T.

User function Fim()
U_tstSMTP()
Return .T.




User Function LegenSZP

Local aLegenda := {{"ENABLE","Concluido"},{"DISABLE","Não Liberado"},{"BR_AZUL","Pendente"},{"BR_AMARELO","Andamento"}}

BrwLegenda("Ordem de Servico","Legenda",aLegenda)

Return(.t.)

User Function LibAprov

If AllTrim(cUserName) $ "LUIZ%Eleni%Josiel Ferreira%Administrador%Wagner Lima%"
	
	//	IF EMPTY(SZP->ZP_CANCEL) .AND. EMPTY(SZP->ZP_CONCLUS)
	IF EMPTY(SZP->ZP_CONCLUS) .AND. EMPTY(SZP->ZP_CANCEL)
		IF MsgYesNo("Deseja cancelar o chamado "+ SZP->ZP_COD +" ?")
			
			RecLock("SZP",.F.)
			SZP->ZP_CANCEL := date()
			SZP->ZP_NOME := Posicione("SAK",2,xFilial("SAK")+ __cUserID,"AK_NOME")
			SZP->ZP_APROV := Posicione("SAK",2,xFilial("SAK")+ __cUserID,"AK_COD")
			SZP->(MsUnLock())
		ENDIF
	ELSEIF !EMPTY(SZP->ZP_CANCEL) .AND. EMPTY(SZP->ZP_CONCLUS)
		IF	MsgYesNo("Deseja liberar o chamado "+ SZP->ZP_COD +" ?")
			RecLock("SZP",.F.)
			SZP->ZP_CANCEL := CTOD('  /  /  ')
			SZP->ZP_NOME := ""
			SZP->ZP_APROV := ""
			SZP->(MsUnLock())
		ENDIF
		
	ELSEIF !EMPTY(SZP->ZP_CONCLUS)
		MsgAlert("Chamados concluidos não podem ser cancelados ou liberado!","Atenção")
		//	Return
		
	ENDIF
	
Else
	MsgAlert("Usuario sem permissao para liberar o chamado!","Atenção")
	Return
Endif

Return()

User Function AxAlteSZP

Local lUser := .T.

IF AllTrim(cUserName) $ "LUIZ%Eleni%Josiel Ferreira%Administrador%Wagner Lima%"
	//	lUser := .F.
	dbSelectArea("SZP")
	AxAltera("SZP",SZP->(Recno()),4,,,,,".T.",,,,,,,.F.)
	IF SZP->ZP_STATUS == "3"
		IF MsgYesNo("Deseja enviar e-mail finalizando o chamado?")
			U_tstSMTP()
		ENDIF
	ENDIF
else
	Alert("Sem permissão a alteração")
	Return
ENDIF

/*
IF lUser
IF EMPTY(ZP_CANCEL) .AND. EMPTY(ZP_CONCLUS)

dbSelectArea("SZP")
AxAltera("SZP",SZP->(Recno()),4,,,,,".T.",,,,,,,.F.)

ELSE
MsgInfo("Chamados cancelados/concluidos não podem ser alterados!","Atenção!")
Return
lUser := .T.
ENDIF

ENDIF
*/

Return

User Function tstSMTP()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= "" 
Local cTitulo	:= ""

// Rafael França - 22/02/12 - Coloca o email do usuario que abriu a ordem de serviço no grupo de envio.

cEmail := "rfranca@recordtvdf.com.br;wsbezerra@recordtvdf.com.br"
IF !EMPTY(SZP->ZP_EMAIL) .AND. !(AllTrim(SZP->ZP_EMAIL) $ "RFRANCA%ECALDEIRA%FJSILVA%BAOLIVEIRA") //Valida se esta cadastrado o e-mail ou se ele ja esta recebendo.
	cEmail += ";" + ALLTRIM(SZP->ZP_EMAIL)
ENDIF

cBody 	:=  "Solicitante: " + UPPER(SZP->ZP_SOLICIT) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
cBody 	+=	"Modulo: " + UPPER(Posicione("SX5",1,xFilial("SX5")+"IA" + SZP->ZP_MODULO,"X5_DESCRI")) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
cBody 	+=	"Resumo: " + UPPER(SZP->ZP_DESCRI) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
IF SZP->ZP_STATUS == "3"  
	cTitulo	:=  "Solução Ordem de Serviço Nº " + SZP->ZP_COD + ""
	cBody 	+=	"Detalhes: " + UPPER(SZP->ZP_DETALHE) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
	cBody   +=  "Conclusão: " + DTOC(SZP->ZP_CONCLUS) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
	cBody   +=  "Solução: " + UPPER(SZP->ZP_SOLUCAO) + Chr(13) + Chr(10) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
ELSE
	cTitulo	:= 	"Ordem de Serviço Nº " + SZP->ZP_COD + ""
	cBody 	+=	"Detalhes: " + UPPER(SZP->ZP_DETALHE) + Chr(13) + Chr(10) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
ENDIF

// Conecta com o Servidor SMTP
CONNECT SMTP SERVER "Outlook.office365.com" ;//"smtp.recordtvdf.com.br" ;
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

DBcloseARea("SZP")
Return()

User Function AchaEmail

//Rafael França - 22/02/12 - Verifica o email do usuario para envio.

Local cUserMail := ""
Local _aRetUser := {}

// Defino a ordem
PswOrder(1) // Ordem de nome

// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
If PswSeek(__cUserID,.T.)
	
	// Obtenho o resultado conforme vetor
	_aRetUser := PswRet(1)
	
	cUserMail   := upper(alltrim(_aRetUser[1,14]))
	
EndIf

/*
PswOrder(nOrder) = Seta a ordem de pesquisa:

nOrder

Ordem     Chave
1         ID
2         Nome
3         Senha
4         E-Mail ( ainda não implementado )

PswSeek(cSeek,lUser) = Faz a pesquisa retornando .T. ou .F.

cSeek = String a ser procurada

lUser
Conteúdo     Descrição
.T.          Pesquisa usuário ( padrão )
.F.          Pesquisa grupos

PswRet(nReg) = Retorna vetor com informações do usuário / grupo

nReg

Conteúdo     Descrição
NIL          Todos os registros
1            1º Registro
2            2º Registro
3            3º Registro

Vetor com configurações do administrador

Registro     Elemento                              Tipo    Tamanho
1            Senha mestra                            C     6
2            Número de erros                         N     1
3            Número de senhas a guardar              N     2
4            Uso do nome para verificação da senha   L     1
5            Tamanho da senha                        N     1
6            Bloqueio                                L     1


Vetor com configurações dos grupos

Registro     Elemento                        Tipo     Tamanho

1          ID                           C     6
2          Nome                         C     20
3          Vetor com horários de acesso A
4          Data de validade             D     8
5          Quantas vezes para expirar   N     4
6          Autorizado a alterar a senha L     1
7          Idioma                       N     1
8          Diretório                    C     100
9          Impressora                   C
10         Acessos                      C     512
11         Vetor com empresas           A
12         Data da última alteração     D     8
13         Tipo de impressão            N     1
14         Formato                      N     1
15         Ambiente                     N     1
16         Opção de Impressão           C     2


Vetor com configurações dos usuários

Registro   Elemento                          Tipo     Tamanho
1     ID                                C     6
2     Nome                              C     15
3     Senha                             C     6
4     Nome completo                     C     30
5     Vetor com "n" últimas senhas      A
6     Data de validade                  D     8
7     Quantas vezes para expirar        N     4
8     Autorizado a alterar a senha      L     1
9     Alterar senha no próximo logon    L     1
10    Vetor com os grupos               A
11    ID do superior                    C     6
12    Departamento                      C     30
13    Cargo                             C     30
14    E-mail                            C     30
15    Número de acessos simultâneos     N     4
16    Data da última alteração          D     8
17    Usuário bloqueado                 L     1
18    Número de digitos para o ano      N     1

*/

Return(cUserMail)
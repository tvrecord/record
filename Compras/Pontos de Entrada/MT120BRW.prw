#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#include "Protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TelaOBS  ºAutor  ³Bruno Alves          º Data ³  31/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Nova botao na rotina de Liberação Eletronica/ Programa de    º±±
±±º          ³inserção da observacao do detalhe pedido.	                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TelaOBS()

//Tela de alteracao do campo observacao da cotacao.

Local cPedido 	:= Space(6)
Local cCotacao	:= Space(6)
Local cSolicit	:= Space(6)
Local cCtaSig	:= Space(6)
Local cSigDesc	:= Space(60)
Local cOBS 		:= Space(40)
Local cOBS1		:= Space(40)
Local aItens	:= {'Boleto','Transferencia'}
Local aItens1	:= {'Sim','Não'}
Private oArquivo
Private oArquivo1
Private cBanco 		:= space(3)
Private cAgencia 	:= space(6)
Private cDgAgencia	:= space(1)
Private cConta 		:= space(9)
Private cDgConta 	:= space(1)
Private cNome	 	:= space(60)

//cCotacao := ALLTRIM(POSICIONE("SC8",11,xFilial("SC8")+Alltrim(SCR->CR_NUM) + "0001","C8_NUM"))
cCotacao := SC7->C7_NUMCOT
cSolicit := SC7->C7_NUMSC
cPedido  := SC7->C7_NUM
cCtaSig	 := Posicione("SED",1,xFilial("SED") + Posicione("SC1",6,xFilial("SCR") + ALLTRIM(SC7->C7_NUM),"C1_NATUREZ"),"ED_CONTSIG")
cSigDesc := PadL(Alltrim(cCtaSig) + " - " + Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(cCtaSig),6)+cValToChar(Year(SC7->C7_EMISSAO)),"ZY_DESCRI"),60)

dbSelectArea("SZL")
dbSetOrder(2)
IF DbSeek(xFilial("SZL") + cPedido + cCotacao )   //Verifica se ja existe o detalhe do pedido SZL
	cOBS 	 := ZL_OBS2
ELSE
	RecLock("SZL",.T.)
	SZL->ZL_COTACAO	:= cCotacao
	SZL->ZL_PEDIDO	:= cPedido
	SZL->ZL_SOLICIT	:= cSolicit
	MsUnlock("SZL")
Endif

DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

@ 000,000 TO 490,530 DIALOG oDlg TITLE "Registra Detalhes do Pedido"
@ 010,015 Say "Pedido:"
@ 010,050 Get cPedido  when .F. F3 "SC7" //IIF(Empty(cPedido),.F.,.T. )
@ 010,130 Say "Tp. Pagamento:"
@ 010,170 COMBOBOX oArquivo ITEMS aItens SIZE 70,020 OF oDlg PIXEL FONT oFont  VALID !EMPTY(oArquivo)
@ 030,015 Say "Cotação:"
@ 030,050 Get cCotacao  when .F. F3 "SC8" //IIF(Empty(cCotacao),.F.,.T. )
@ 030,130 Say "Orçado:"
@ 030,170 COMBOBOX oArquivo1 ITEMS aItens1 SIZE 70,020 OF oDlg PIXEL FONT oFont  VALID !EMPTY(oArquivo1)
@ 050,015 Say "Cta. SIG:"
@ 050,050 Get cSigDesc //IIF(Empty(cPedido),.F.,.T. )
@ 070,015 Say "Observação:"
@ 070,050 Get cOBS MEMO SIZE 200,040 VALID !EMPTY(cOBS)
@ 120,015 Say "Exclusivo:"
@ 120,050 Get cOBS1 MEMO SIZE 200,040 VALID !EMPTY(cOBS1)
@ 170,190 BMPBUTTON TYPE 01 ACTION AlteraOBS(cPedido,cCotacao,cOBS,cOBS1)
@ 170,220 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Return

Static Function AlteraOBS(cPedido,cCotacao,cOBS,cOBS1)

If Empty(cOBS)
	MsgInfo("Favor, inserir observação","Vazio")
	Return
Endif

If Empty(cCotacao)
	MsgAlert("Pedido não foi gerado por cotação","Atencao")
	Return
Endif

If  Empty(cPedido)
	MsgAlert("Entre em contato com o Administrador do Sistema","Atencao")
	Return
Endif

//If AllTrim(Substring(cUsuario,7,15)) $ "Carlos Alves/bruno alves"


//Gravacao ou altercao do registro na SZL

DBSELECTAREA("SZL")
DBSETORDER(1)
If DBSEEK(xFilial("SZL")+cCotacao)
	RecLock("SZL",.F.)
	SZL->ZL_OBS1		:= cObs
	SZL->ZL_TPPAG		:= IIF(oArquivo == "Boleto","1","2")
	SZL->ZL_PEDORC 		:= IIF(oArquivo1 == "Sim","1","2")
	SZL->ZL_EXCLUSI 	:= cObs1
	MsUnlock("SZL")
	//MsgInfo("Alteração realizada com sucesso","Fim")
EndIF

Close(oDlg)


iF SZL->ZL_TPPAG == "2" // Verifica se o tipo de pagamento é como transferencia

	DBSelectArea("SA2")
	DBSetorder(1)
	DBSeek(xFilial("SA2") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_FORNECE") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_LOJA"))


	iF !EMPTY(ALLTRIM(SA2->A2_BANCO))
		cBanco 		:= ALLTRIM(SA2->A2_BANCO)
	EndIf
	iF !EMPTY(ALLTRIM(SA2->A2_AGENCIA))
		cAgencia 	:= ALLTRIM(SA2->A2_AGENCIA)
	EndIf
	iF !EMPTY(SA2->A2_DGAGEN)
		cDgAgencia	:= SA2->A2_DGAGEN
	EndIf
	iF !EMPTY(ALLTRIM(SA2->A2_NUMCON))
		cConta 		:= ALLTRIM(SA2->A2_NUMCON)
	EndIf
	iF !EMPTY(SA2->A2_DGCONTA)
		cDgConta 	:= SA2->A2_DGCONTA
	EndIf
	iF !EMPTY(SA2->A2_NOME)
		cNome	 	:= SA2->A2_NOME
	EndIf

	DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

	@ 000,000 TO 230,350 DIALOG oDlg TITLE "Consulta/Altera Dados Bancarios do Fornecedor"
	@ 010,015 Say "Banco:"
	@ 010,050 Get cBanco  Valid  !EMPTY(ALLTRIM(cBanco))
	@ 030,015 Say "Agencia:"
	@ 030,050 Get cAgencia  Valid  !EMPTY(ALLTRIM(cAgencia))
	@ 030,100 Say "Dg. Agencia:"
	@ 030,135 Get cDgAgencia Valid  !EMPTY(ALLTRIM(cDgAgencia))
	@ 050,015 Say "Conta:"
	@ 050,050 Get cConta Valid  !EMPTY(ALLTRIM(cConta))
	@ 050,100 Say "Dg. Conta:"
	@ 050,135 Get cDgConta  Valid  !EMPTY(ALLTRIM(cDgConta))
	@ 070,015 Say "Fornecedor:"
	@ 070,050 Get cNome  when .F.
	@ 090,090 BMPBUTTON TYPE 01 ACTION AlteraSA2()
	@ 090,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

	DBSelectArea("SA2")
	DBSetorder(1)
	DBSeek(xFilial("SA2") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_FORNECE") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_LOJA"))

	If MsgYesNo("Deseja enviar e-mail com os dos dados bancarios do fornecedor " + SA2->A2_NOME + " com Banco: " + ALLTRIM(SA2->A2_BANCO) + "-" + "Ag: " + ALLTRIM(SA2->A2_AGENCIA) + "-" + (SA2->A2_DGAGEN) + " Conta: " + ALLTRIM(SA2->A2_NUMCON) + "-" + SA2->A2_DGCONTA + " ?" )

		U_AVISOCOMP() // Envia e-mail para os departamentos envolvidos cadastrarem a agencia e a conta no Bradesco para realizar o pagamento

	EndIf

EndIf

Return


Static Function AlteraSA2()

	If EMPTY(ALLTRIM(cBanco)) .OR. EMPTY(ALLTRIM(cAgencia)) .OR. EMPTY(ALLTRIM(cDgAgencia)) .OR. EMPTY(ALLTRIM(cConta)) .OR. EMPTY(ALLTRIM(cDgConta))
		Alert("Para concluir a transação é necessário preencher todos os Campos da Tela")
		Return
	EndIf

Close(oDlg)

DBSelectArea("SA2")
DBSetorder(1)
IF(DBSeek(xFilial("SA2") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_FORNECE") + POSICIONE("SC7",1,xFilial("SC7")+SZL->ZL_PEDIDO,"C7_LOJA"))	)

	RecLock("SA2",.F.)
	SA2->A2_BANCO := cBanco
	SA2->A2_AGENCIA := cAgencia
	SA2->A2_DGAGEN := cDgAgencia
	SA2->A2_NUMCON := cConta
	SA2->A2_DGCONTA := cDgConta
	SA2->(MsUnlock())

	MsgInfo("Cadastro Bancario do fornecedor alterado com sucesso!!")

EndIf

Return



User Function AVISOCOMP()

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

cEmail := "compras@recordtvdf.com.br;financeiro@recordtvdf.com.br"//;Controladoria@recordtvdf.com.br;Almoxarifado@recordtvdf.com.br;COMPRAS@recordtvdf.com.br;jdosilva@recordtvdf.com.br"
cTitulo	:= 	"Verificar o cadastramento do banco do Fornecedor - " + ALLTRIM(SA2->A2_NOME) + ""

cBody   += "DADOS BANCÁRIOS: " + Chr(13) + Chr(10) + Chr(13) + Chr(10)

cBody   += "Banco: " + SA2->A2_BANCO + "" + Chr(13) + Chr(10)
cBody 	+= "Nome: " + SA2->A2_DESCBAN + "" + Chr(13) + Chr(10)
cBody   += "Agência: " + SA2->A2_AGENCIA + "-" + SA2->A2_DGAGEN + "" + Chr(13) + Chr(10)
cBody 	+= "Conta: " + SA2->A2_NUMCON + "-" + SA2->A2_DGCONTA + "" + Chr(13) + Chr(10)
cBody   += "CNPJ: " + Transform(SA2->A2_CNPJ,"@R 99.999.999/9999-99") + "" + Chr(13) + Chr(10) + Chr(13) + Chr(10)

cBody   += "DADOS DO PEDIDO DE COMPRA: " + Chr(13) + Chr(10) + Chr(13) + Chr(10)

cBody   += "Pedido de Compra: " + SZL->ZL_PEDIDO + "" + Chr(13) + Chr(10)
cBody   += "Cod. Fornecedor: " + SA2->A2_COD + "" + Chr(13) + Chr(10)
cBody 	+= "Razão Social: " + SA2->A2_NOME + "" + Chr(13) + Chr(10)
cBody   += "Nome Fantasia: " + SA2->A2_NREDUZ + "" + Chr(13) + Chr(10) + Chr(13) + Chr(10)

// Conecta com o Servidor SMTP
CONNECT SMTP SERVER "Outlook.office365.com" ;  //"smtp.recordtvdf.com.br" ;
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
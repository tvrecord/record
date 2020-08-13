#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTTURNO  ºAutor  ³Bruno Alves        º Data ³  05/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia um e-mail quando desbloquear  ou bloquear algum turno SR6        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ALTTURNO()

Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""

cEmail := "gbarcelos@recordtvdf.com.br;rfranca@recordtvdf.com.br;jrcruz@recordtvdf.com.br;wsbezerra@recordtvdf.com.br;"
cTitulo	:= 	"VERIFICAR ALTERAÇÃO DO TURNO " //+ SZP->ZP_COD + ""

If M->R6_MSBLQL == "2"
	cBody   += "Desbloqueou o turno: " + M->R6_TURNO + " - " + M->R6_DESC + "" + Chr(13) + Chr(10)
	cBody   += "Horas Trabalhadas: " + cValToChar(R6_HRNORMA) + "" + Chr(13) + Chr(10)
	cBody   += "Horas de Descanso: " + cValtoChar(R6_HRDESC) + "" + Chr(13) + Chr(10)
	cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
ELSEIF M->R6_MSBLQL == "1"
	cBody   += "Bloqueou o turno: " + M->R6_TURNO + " - " + M->R6_DESC + "" + Chr(13) + Chr(10)
	cBody   += "Horas Trabalhadas: " + cValToChar(R6_HRNORMA) + "" + Chr(13) + Chr(10)
	cBody   += "Horas de Descanso: " + cValtoChar(R6_HRDESC) + "" + Chr(13) + Chr(10)
	cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
EndIf

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
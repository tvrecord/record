#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#INCLUDE "TBICONN.CH"



User Function AVISOPREV()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""
Local cQuery  	:= ""
Local nCont		:= 0
Local n			:= 1


PREPARE ENVIRONMENT EMPRESA ("01") FILIAL ("01") MODULO "CFG" //usado para utlizar a rotina eschedule


cEmail := "ecaldeira@recordtvdf.com.br;rfranca@recordtvdf.com.br"
//cEmail := "baoliveira@recordtvdf.com.br"
cTitulo	:= 	"LEMBRETE - CONFER�NCIA DO RELAT�RIO DE PREVIS�O " //+ SZP->ZP_COD + ""



cBody   += "Emitir relat�rio PREVIS�O localizado no m�dulo Financeiro no caminho RELAT�RIOS/FLUXO DE CAIXA/PREVIS�O e validar se as datas dos vencimentos est�o corretas."  + Chr(13) + Chr(10) + Chr(13) + Chr(10)
cBody 	+=  "� necess�rio conferir somente as previs�es dos tipos:" + Chr(13) + Chr(10)
cBody 	+=  "- AENTREGASE; " + Chr(13) + Chr(10)
cBody 	+=  "- ANTCONTRAT; " + Chr(13) + Chr(10)
cBody 	+=  "- CONTRATO; " + Chr(13) + Chr(10)
cBody 	+=  "- PEDIDO. " + Chr(13) + Chr(10) + Chr(13) + Chr(10)


// Conecta com o Servidor SMTP
CONNECT SMTP SERVER "Outlook.office365.com" ;  //"smtp.recordtvdf.com.br" ;
ACCOUNT "microsiga" PASSWORD "record@10" ;
RESULT lOk
If lOk
	//   MsgStop( "Conex�o OK" )
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
	MsgStop( "Erro de conex�o : " + cSmtpError)
Endif


RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return




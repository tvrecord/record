#include "TOTVS.CH"

User Function COMMAIL001()

Local oServer := TMailManager():New()

Local oMessage := TMailMessage():New()
Local nErro := 0

oServer:SetUseTLS( .T. )
oServer:Init( "", "smtp.office365.com", "Microsiga", "record@micro", 0, 587)

If oServer:SetSmtpTimeOut( 60 ) != 0
Conout( "Falha ao setar o time out" )
Return .F.
EndIf

If oServer:SmtpConnect() != 0
Conout( "Falha ao conectar" )
Return .F.

EndIf

oMessage:Clear()

oMessage:cFrom := "SISTEMA"
oMessage:cTo := "rfranca@recordtvdf.com.br"
oMessage:cCc := "plpontes@recordtvdf.com.br"
oMessage:cSubject := "Teste Email"
oMessage:cBody := "Não responda"
//oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+"cArquivo")

//Envia o e-mail
If oMessage:Send( oServer ) != 0
Conout( "Erro ao enviar o e-mail" )
Return .F.
EndIf

//Desconecta do servidor
If oServer:SmtpDisconnect() != 0
Conout( "Erro ao disconectar do servidor SMTP" )
Return .F.
EndIf

Return(nErro)
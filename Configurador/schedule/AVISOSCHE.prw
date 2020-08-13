#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#INCLUDE "TBICONN.CH"



User Function AVISOSCHE()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""
Local cQuery  	:= ""
Local nCont		:= 0
Local n			:= 1


PREPARE ENVIRONMENT EMPRESA ("01") FILIAL ("01") MODULO "CFG" //usado para utlizar a rotina eschedule


cQuery := "SELECT C3_NUM,C3_FORNECE,C3_LOJA,A2_NOME,C3_DATPRF,C3_PRECO,C3_OBS,DAYS(DATE(SUBSTRING(C3_DATPRF,1,4) + '-' + SUBSTRING(C3_DATPRF,5,2) + '-' + SUBSTRING(C3_DATPRF,7,2))) - DAYS(CURRENT DATE) AS DIAS  "
cQuery += "FROM SC3010 "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "SC3010.C3_FORNECE = SA2010.A2_COD AND "
cQuery += "SC3010.C3_LOJA = SA2010.A2_LOJA "
cQuery += "WHERE "
cQuery += "SC3010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "DAYS(DATE(SUBSTRING(C3_DATPRF,1,4) + '-' + SUBSTRING(C3_DATPRF,5,2) + '-' + SUBSTRING(C3_DATPRF,7,2))) - DAYS(CURRENT DATE)  <= 45 AND "
//cQuery += "C3_ENCER <> 'E' AND " - Fabyana pediu para retirar  05/12/2012
cQuery += "C3_ENCER <> 'E' AND "// - Wallace pediu para inserir no dia 13/08/2013
cQuery += "C3_RENOVA = '' "
cQuery += "ORDER BY DIAS "

TcQuery cQuery New Alias "TMP"

DBSelectARea("TMP")

Count to nCont

DBGotop()

If nCont > 0
	
	cEmail := "rfranca@recordtvdf.com.br;Controladoria@recordtvdf.com.br"
	cTitulo	:= 	"VERIFICAR A RENOVAÇÃO DOS CONTRATOS " //+ SZP->ZP_COD + ""
	
	While !EOF()
		
		cBody   += "Item Nº: " + str(n) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Cod. Contrato: " + TMP->C3_NUM + "" + Chr(13) + Chr(10)
		cBody 	+=  "Contrato: " + TMP->C3_OBS + "" + Chr(13) + Chr(10)
		cBody 	+=  "Fornecedor: " + TMP->C3_FORNECE + "" + Chr(13) + Chr(10)
		cBody 	+=  "Loja: " + TMP->C3_LOJA + "" + Chr(13) + Chr(10)
		cBody 	+=  "Nome: " + TMP->A2_NOME + "" + Chr(13) + Chr(10)
		cBody 	+=  "Dt. Vencimento: " + DTOC(STOD(TMP->C3_DATPRF)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Dias para o Vencimento: " + STR(TMP->DIAS) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Valor: " + STR(TMP->C3_PRECO) + "" + Chr(13) + Chr(10)
		cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
		
		n++
		
		DBSKIP()
		
	Enddo
	
	
	
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
	
else // validar programa durante a execucao
	
	cEmail := "rfranca@recordtvdf.com.br"
	cTitulo	:= 	"TESTE CONTRATO" //+ SZP->ZP_COD + ""
	
	cBody   += "OK!!! "
	
	
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
	
EndIf

DBSELECTAREA("TMP")
DBCLOSEAREA("TMP")





RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return




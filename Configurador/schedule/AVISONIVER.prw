#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch" // Usado para o envio de e-mail
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVISONIVERบAutor  ณBruno Alves         บ Data ณ  10/23/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o e-mail dos aniversariantes do dia e do dia seguinte ฑฑ
ฑฑบ          ณduas vezes ao dia                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AVISONIVER()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""
Local cQuery  	:= ""
Local nCont		:= 0
Local nContPJ  := 0
Local cQueryPJ := ""
Local lSubTit   := .T.
Local lImprimi := .F.
Local lValida := .F.



PREPARE ENVIRONMENT EMPRESA ("01") FILIAL ("01") MODULO "CFG" //usado para utlizar a rotina eschedule

// Funcionแrio CLT

cQuery := "SELECT RA_MAT,RA_NOME,RA_ADMISSA,SUBSTRING(RA_NASC,5,4) AS ANIVERSARIO,RA_NASC,CTT_DESC01,RJ_DESC FROM SRA010 "
cQuery += "INNER JOIN CTT010 ON RA_FILIAL = CTT_FILIAL AND RA_CC = CTT_CUSTO "
cQuery += "INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "WHERE "
cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
cQuery += "SRA010.RA_DEMISSA = '' AND "
cQuery += "SRA010.RA_MAT < '7999999' AND "
cQuery += "SRA010.RA_FILIAL = '01' AND "
cQuery += "SUBSTRING(RA_NASC,5,4) IN ('" + (SUBSTR(DTOS(DATE()),5,4)) + "','" + (SUBSTR(DTOS(DATE() + 1),5,4)) + "') AND "
cQuery += "SRJ010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SUBSTRING(RA_NASC,5,4),RA_NOME "

TcQuery cQuery New Alias "TMP"

DBSelectARea("TMP")

Count to nCont

DBGotop()

If nCont > 0
	lValida := .T.
	lImprimiu := .T.
	cEmail := "ecaldeira@recordtvdf.com.br;rfranca@recordtvdf.com.br"
	cTitulo	:= 	"ANIVERSARIANTES DO DIA E DO DIA SEGUINTE" //+ SZP->ZP_COD + ""
	cBody   += "FUNCIONมRIOS CLT" + Chr(13) + Chr(10)
	
	While !EOF()
		
		If lSubTit == .T.
			
			If (SUBSTR(DTOS(DATE()),5,4)) == (SUBSTR(RA_NASC,5,4))
				cBody   += "ANIVERSARIANTE(S) DO DIA" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
			ELSE
				cBody   += "ANIVERSARIANTE(S) DO DIA SEGUINTE" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
			EndIf
			
			lSubTit := .F.
			
		EndIf
		
		cBody   +=  "Matricula: " + TMP->RA_MAT + "" + Chr(13) + Chr(10)
		cBody 	+=  "Nome: " + TMP->RA_NOME + "" + Chr(13) + Chr(10)
		cBody 	+=  "Admissใo: " + DTOC(STOD(TMP->RA_ADMISSA)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Dt. Nascimento: " + DTOC(STOD(TMP->RA_NASC)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "C. Custo: " + TMP->CTT_DESC01 + "" + Chr(13) + Chr(10)
		cBody 	+=  "Fun็ใo: " + TMP->RJ_DESC + "" + Chr(13) + Chr(10)
		cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
		
		cNiver := SUBSTR(RA_NASC,5,4)
		
		DBSKIP()
		
		If cNiver <> SUBSTR(RA_NASC,5,4)
			lSubTit := .T.
		EndIf
		
	Enddo
	
EndIf

DBSELECTAREA("TMP")
DBCLOSEAREA("TMP")

ด// Funcionarios PJ - SOMENTE OS VINCULADOS NOS CONTRATOS

cQueryPj := "SELECT C3_NUM,MAX(C3_ITEM) AS ITEM, C3_PRODUTO,RA_MAT,RA_NOME,RA_ADMISSA,SUBSTRING(RA_NASC,5,4) AS ANIVERSARIO,RA_NASC,CTT_DESC01,RJ_DESC FROM SC3010 "
cQueryPj += "INNER JOIN SRA010 ON "
cQueryPj += "RA_FILIAL = C3_FILIAL AND "
cQueryPj += "RA_MAT = C3_MAT "
cQueryPj += "INNER JOIN CTT010 ON "
cQueryPj += "RA_FILIAL = CTT_FILIAL AND "
cQueryPj += "RA_CC = CTT_CUSTO "
cQueryPj += "INNER JOIN SRJ010 ON "
cQueryPj += "RA_CODFUNC = RJ_FUNCAO "
cQueryPj += "WHERE "
cQueryPj += "C3_QUJE <> C3_QUANT AND "
cQueryPj += "C3_MAT <> '' AND "
cQueryPj += "SRA010.RA_FILIAL = '01' AND "
cQueryPj += "SUBSTRING(RA_NASC,5,4) IN ('" + (SUBSTR(DTOS(DATE()),5,4)) + "','" + (SUBSTR(DTOS(DATE() + 1),5,4)) + "') AND "
cQueryPj += "SRJ010.D_E_L_E_T_ <> '*' AND "
cQueryPj += "SRA010.D_E_L_E_T_ <> '*' AND "
cQueryPj += "CTT010.D_E_L_E_T_ <> '*' "
cQueryPj += "GROUP BY C3_NUM,C3_PRODUTO,RA_MAT,RA_NOME,RA_ADMISSA,RA_NASC,CTT_DESC01,RJ_DESC "
cQueryPj += "ORDER BY SUBSTRING(RA_NASC,5,4),RA_NOME "

TcQuery cQueryPj New Alias "TMP1"

DBSelectARea("TMP1")

Count to nContPJ

DBGotop()

If nContPJ > 0
	lValida := .T.
	
	If lImprimi == .F.
		cEmail := "ecaldeira@recordtvdf.com.br;rfranca@recordtvdf.com.br"
		cTitulo	:= 	"ANIVERSARIANTES DO DIA E DO DIA SEGUINTE" //+ SZP->ZP_COD + ""
	EndIf
	
	cBody   += "FUNCIONมRIOS PJ" + Chr(13) + Chr(10)
	
	
	While !EOF()
		
		If lSubTit == .T.
			
			If (SUBSTR(DTOS(DATE()),5,4)) == (SUBSTR(RA_NASC,5,4))
				cBody   += "ANIVERSARIANTE(S) DO DIA" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
			ELSE
				cBody   += "ANIVERSARIANTE(S) DO DIA SEGUINTE" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
			EndIf
			
			lSubTit := .F.
			
		EndIf
		
		cBody   +=  "Matricula: " + TMP1->RA_MAT + "" + Chr(13) + Chr(10)
		cBody 	+=  "Nome: " + TMP1->RA_NOME + "" + Chr(13) + Chr(10)
		cBody 	+=  "Admissใo: " + DTOC(STOD(TMP1->RA_ADMISSA)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Dt. Nascimento: " + DTOC(STOD(TMP1->RA_NASC)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "C. Custo: " + TMP1->CTT_DESC01 + "" + Chr(13) + Chr(10)
		cBody 	+=  "Fun็ใo: " + TMP1->RJ_DESC + "" + Chr(13) + Chr(10)
		cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
		
		cNiver := SUBSTR(RA_NASC,5,4)
		
		DBSelectArea("TMP1")
		DBSKIP()
		
		If cNiver <> SUBSTR(RA_NASC,5,4)
			lSubTit := .T.
		EndIf
		
	Enddo
	
EndIf




If lValida == .T. //Verifica se achou algum registro para imprimir, caso contrario envia o e-mail para o responsavel do programa verificar a integridade
	// Conecta com o Servidor SMTP
	CONNECT SMTP SERVER "Outlook.office365.com" ;  //"smtp.recordtvdf.com.br" ;
	ACCOUNT "microsiga" PASSWORD "record@10" ;
	RESULT lOk
	If lOk
		//   MsgStop( "Conexใo OK" )
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
		MsgStop( "Erro de conexใo : " + cSmtpError)
	Endif
	
else // validar programa durante a execucao
	
	cEmail := "rfranca@recordtvdf.com.br"
	cTitulo	:= 	"TESTE ANIVERSARIO" //+ SZP->ZP_COD + ""
	
	cBody   += "OK!!! "
	
	
	// Conecta com o Servidor SMTP
	CONNECT SMTP SERVER "Outlook.office365.com" ;  //"smtp.recordtvdf.com.br" ;
	ACCOUNT "microsiga" PASSWORD "record@10" ;
	RESULT lOk
	If lOk
		//   MsgStop( "Conexใo OK" )
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
		MsgStop( "Erro de conexใo : " + cSmtpError)
	Endif
	
EndIf


DBSELECTAREA("TMP1")
DBCLOSEAREA("TMP1")



RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return




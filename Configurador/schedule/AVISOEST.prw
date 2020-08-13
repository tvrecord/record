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
ฑฑบPrograma  ณAVISOEST  บAutor  ณBruno Alves         บ Data ณ  10/16/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Informar aos departamentos os produtos que nใo chegaram   บฑฑ
ฑฑบ          ณ  ao estoque apos as compras                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



User Function AVISOEST()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""
Local cQuery  	:= ""
Local cQueryCot  	:= ""
Local nCont		:= 0
Local cPedido	:= ""
Local lPedido   := .T.


PREPARE ENVIRONMENT EMPRESA ("01") FILIAL ("01") MODULO "CFG" //usado para utlizar a rotina eschedule


cQuery := "SELECT C7_FILIAL,C7_EMISSAO,C7_ITEM,C7_NUM,C7_PRODUTO,C7_DESCRI,C7_UM,AH_UMRES,C7_LOCAL,C7_DATPRF,C7_QUANT - C7_QUJE AS QUANTIDADE,C7_FORNECE,A2_LOJA,A2_NOME FROM SC7010 "
cQuery += "INNER JOIN SAH010 ON "
cQuery += "SAH010.AH_UNIMED = SC7010.C7_UM "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "SA2010.A2_COD = SC7010.C7_FORNECE AND "
cQuery += "SA2010.A2_LOJA = SC7010.C7_LOJA "
cQuery += "WHERE "
cQuery += "SC7010.D_E_L_E_T_ <> '*' AND "
cQuery += "SAH010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC7010.C7_CONAPRO = 'L' AND "
cQuery += "C7_QUANT - C7_QUJE <> 0 AND "
cQuery += "C7_DATPRF < '" + DTOS(DATE()) + "' AND " // Verifica se o prazo da data de entrega foi excedida
cQuery += "C7_FILIAL = '01' AND "
cQuery += "C7_RESIDUO <> 'S' AND "
cQuery += "C7_EMISSAO >= '20121001' " //Solicitado pela Sra. Elenn devido a grande pendencia de produtos que nใo foram entregues
cQuery += "ORDER BY C7_NUM,C7_ITEM "

TcQuery cQuery New Alias "TMP"

DBSelectARea("TMP")

Count to nCont

DBGotop()

If nCont > 0
	
	cEmail := "rfranca@recordtvdf.com.br;compras@recordtvdf.com.br;almoxarifado@recordtvdf.com.br;controladoria@recordtvdf.com.br"//;Controladoria@recordtvdf.com.br;Almoxarifado@recordtvdf.com.br;COMPRAS@recordtvdf.com.br;jdosilva@recordtvdf.com.br"
	cTitulo	:= 	"Fornecedores com prazo de entrega excedida " //+ SZP->ZP_COD + ""
	
	While !EOF()
		
		If lPedido == .T.
//PARA SOMAR O VALOR DO PEDIDO			
//			cQueryCot := "SELECT C8_NUM,C8_NUMPED,SUM(C8_VALIPI) AS VLIPI,SUM(C8_TOTAL) AS VLTOT,C8_TOTFRE AS VLFRETE,SUM(C8_DESPESA) AS VLDESPESA,SUM(C8_VLDESC) AS VLDESC FROM SC8010 WHERE " - Retirado no dia 14/08/2013 - JUDSON
			cQueryCot := "SELECT C7_NUM,SUM(C7_TOTAL + C7_VALFRE + C7_DESPESA - C7_VLDESC) AS VLTOT FROM SC7010 WHERE "
			cQueryCot += " C7_FILIAL = '" + (TMP->C7_FILIAL) + "' AND "
			cQueryCot += " C7_NUM = '" + (TMP->C7_NUM) + "' AND "			
			cQueryCot += " C7_RESIDUO <> 'S' AND "			
			cQueryCot += " D_E_L_E_T_ <> '*' "
			cQueryCot += " GROUP BY C7_NUM "
			
			TcQuery cQueryCot New Alias "COT"
			
			DBSelectARea("COT")
			
			
			cBody 	+=  "----------------------------------------------------------------------------" + Chr(13) + Chr(10)
			cBody 	+=  "Pedido: " + TMP->C7_NUM + "" + Chr(13) + Chr(10)
			cBody 	+=  "Emissใo: " + DTOC(STOD(TMP->C7_EMISSAO)) + "" + Chr(13) + Chr(10)
			cBody 	+=  "Fornecedor: " + TMP->A2_NOME + "" + Chr(13) + Chr(10)
//			cBody 	+=  "Vl. Total: " + cValToChar(COT->VLIPI + COT->VLTOT + COT->VLFRETE - COT->VLDESC + COT->VLDESPESA) + "" + Chr(13) + Chr(10) + Chr(13) + Chr(10) + Chr(13) + Chr(10) - - Retirado no dia 14/08/2013 - JUDSON
			cBody 	+=  "Vl. Total: " + cValToChar(COT->VLTOT) + "" + Chr(13) + Chr(10) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
			
		DBSelectARea("COT")
		DBCloseArea("COT")
					
		EndIf		
		
		cBody   += "Item Nบ: " + TMP->C7_ITEM + "" + Chr(13) + Chr(10)
		cBody 	+=  "Produto: " + TMP->C7_PRODUTO + "" + Chr(13) + Chr(10)
		cBody 	+=  "Descri็ใo: " + TMP->C7_DESCRI + "" + Chr(13) + Chr(10)
		cBody 	+=  "Quantidade: " + cValToChar(TMP->QUANTIDADE) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Unidade: " + ALLTRIM(TMP->AH_UMRES) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Local: " + TMP->C7_LOCAL + "" + Chr(13) + Chr(10)
		cBody 	+=  "Data de Entrega: " + DTOC(STOD(TMP->C7_DATPRF)) + "" + Chr(13) + Chr(10)
		cBody 	+=  "Qtd. Dias Vencidas: " + cValToChar(DATE() - STOD(TMP->C7_DATPRF)) + "" + Chr(13) + Chr(10) + Chr(13) + Chr(10)
		
		
		
		
		
		
		cPedido := TMP->C7_NUM
		
		DBSelectARea("TMP")
		DBSKIP()
		
		If cPedido != TMP->C7_NUM
			lPedido := .T.
			cBody 	+=  "----------------------------------------------------------------------------"
			cBody 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)
		else
			lPedido := .F.
		EndIf
		
	Enddo
	
	
	
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
	cTitulo	:= 	"TESTE ALMOXARIFADO" //+ SZP->ZP_COD + ""
	
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

DBSELECTAREA("TMP")
DBCLOSEAREA("TMP")





RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return

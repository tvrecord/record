#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Rafael F. - 04/02/2022 - Programa para envio de contratos que estão perto de vencer

User Function xMailContr()

Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""
Local nCont		:= 0
Local n			:= 1
Local cAlias 	:= GetNextAlias() //Declarei meu ALIAS

//PREPARE ENVIRONMENT EMPRESA ("01") FILIAL ("01") MODULO "CFG" //usado para utlizar a rotina eschedule

BeginSql Alias cAlias

SELECT C3_NUM,C3_FORNECE,C3_LOJA,A2_NOME,C3_DATPRF,C3_PRECO,C3_OBS,
DAY(SUBSTRING(C3_DATPRF,1,4) + '-' + SUBSTRING(C3_DATPRF,5,2) + '-' + SUBSTRING(C3_DATPRF,7,2)) - DAY(GETDATE()) AS DIAS
FROM %table:SC3%
INNER JOIN %table:SA2% ON
SC3010.C3_FORNECE = %table:SA2%.A2_COD AND
SC3010.C3_LOJA = %table:SA2%.A2_LOJA AND
%table:SA2%.D_E_L_E_T_ = ''
WHERE
%table:SC3%.D_E_L_E_T_ = ''
AND DAY(SUBSTRING(C3_DATPRF,1,4) + '-' + SUBSTRING(C3_DATPRF,5,2) + '-' + SUBSTRING(C3_DATPRF,7,2)) - DAY(GETDATE()) <= 45
AND C3_ENCER <> 'E'
//C3_ENCER <> 'E' AND " - //Rafael F. - Fabyana pediu para retirar  05/12/2012
// Rafael F. - Wallace pediu para inserir no dia 13/08/2013
AND C3_RENOVA = ''
ORDER BY DIAS

EndSql //FINALIZO A MINHA QUERY

DBSelectARea(cAlias)

Count to nCont

DBGotop()

If nCont > 0

	cPara 		:= "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br"
	cAssunto	:= 	"Verificar Renovação dos Contratos "

	While !EOF()

		cCorpo   += "Item Nº: " + str(n) + "<br>"
		cCorpo 	+=  "Cod. Contrato: " + (cAlias)->C3_NUM + "<br>"
		cCorpo 	+=  "Contrato: " + (cAlias)->C3_OBS + "<br>"
		cCorpo 	+=  "Fornecedor: " + (cAlias)->C3_FORNECE + "<br>"
		cCorpo 	+=  "Loja: " + (cAlias)->C3_LOJA + "<br>"
		cCorpo 	+=  "Nome: " + (cAlias)->A2_NOME + "<br>"
		cCorpo 	+=  "Dt. Vencimento: " + DTOC(STOD((cAlias)->C3_DATPRF)) + "<br>"
		cCorpo 	+=  "Dias para o Vencimento: " + STR((cAlias)->DIAS) + "<br>"
		cCorpo 	+=  "Valor: " + STR((cAlias)->C3_PRECO) + "<br>"
		cCorpo 	+=  "<br>"
		//cCorpo 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)

		n++

		DBSKIP()

	Enddo

	u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)

EndIf

DBSelectARea(cAlias)
DBCloseArea()

dbSelectArea(aArea)

//RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return




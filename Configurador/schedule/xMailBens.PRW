#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#INCLUDE "TBICONN.CH"

//Pedro L - Schedule para disparo de email automático de prazos dos Bens de Terceiros
//25/10/2022

User Function xMailBens()

//Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""
Local cAlias 	:= GetNextAlias() //Declarei meu ALIAS
Local lEmail	:= .F.

Private lLogin  := Type("cEmpAnt") != "U"

	If !lLogin
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf

BeginSql Alias cAlias

SELECT ZN_COD
, CASE ZN_SIT
WHEN '1' THEN 'Emprest. Concedidos'
WHEN '2' THEN 'Emprest. Recebidos'
WHEN '3' THEN 'Locacao'
WHEN '4' THEN 'Conserto'
WHEN '5' THEN 'Demonstracao'
WHEN '6' THEN 'Troca em Garantia'
ELSE 'Ativos p/ uso externo'
END AS SITUACAO
, ZN_DESCRI, ZN_NSERIE, ZN_VALOR, ZN_NOTA, ZN_DTRECEB
, ZN_FORNECE, ZN_EMPRESA, ZN_PRAZO, ZN_CC, ZN_CCDESC
FROM SZN010
WHERE ZN_TIPO = '2' //BENS DE TERCEIROS
AND ZN_DTDEVOL = '' //NÃO DEVOLVIDO

AND SZN010.D_E_L_E_T_ = ''

EndSql //FINALIZO A MINHA QUERY

DBSelectARea(cAlias)

	cPara 		:= "plpontes@recordtvdf.com.br;jabreu@recordtvdf.com.br;bnfreitas@recordtvdf.com.br;irlima@recordtvdf.com.br;patrimonio@rederecorddf.onmicrosoft.com"
	cAssunto	:= 	"Atenção ao Prazo do Bem de Terceiro"

	While !EOF()

	lEmail := .F.

		if (cAlias)->ZN_PRAZO - Date() == 15
		lEmail := .T.
		cCorpo   += "FALTAM 15 DIAS PARA O PRAZO DE DEVOLUÇÃO DO BEM ACABAR!"+ "<br>"
		ELSEIF (cAlias)->ZN_PRAZO - Date() == 10
		lEmail := .T.
		cCorpo   += "FALTAM 10 DIAS PARA O PRAZO DE DEVOLUÇÃO DO BEM ACABAR!"+ "<br>"
		ELSEIF (cAlias)->ZN_PRAZO - Date() == 5
		lEmail := .T.
		cCorpo   += "FALTAM 5 DIAS PARA O PRAZO DE DEVOLUÇÃO DO BEM ACABAR!"+ "<br>"
		ELSEIF (cAlias)->ZN_PRAZO - Date() == -1
		cCorpo   += "O PRAZO DO BEM VENCEU!"+ "<br>"
		Endif

		cCorpo   += "Cod: " + (cAlias)->ZN_COD + "<br>"
		cCorpo   += "Situação: " + (cAlias)->SITUACAO + "<br>"
		cCorpo   += "Bem: " + (cAlias)->ZN_DESCRI + "<br>"
		cCorpo   += "N° Serie: " + (cAlias)->ZN_NSERIE + "<br>"
		cCorpo   += "Valor: " + Transform((cAlias)->ZN_VALOR,"@e 99,999,999.99") + "<br>"
		cCorpo   += "NF Entrada: " + (cAlias)->ZN_NOTA + "<br>"
		cCorpo   += "DT. Entrada: " +SubStr((cAlias)->ZN_DTRECEB,7,2) +"/"+ SubStr((cAlias)->ZN_DTRECEB,5,2) +"/"+ SubStr((cAlias)->ZN_DTRECEB,1,4) + "<br>"
		cCorpo   += "Fornecedor: ("+(cAlias)->ZN_FORNECE+") "+ (cAlias)->ZN_EMPRESA + "<br>"
		cCorpo   += "C.Custo: ("+(cAlias)->ZN_CC+") "+ (cAlias)->ZN_CCDESC + "<br>"
		cCorpo   += "DATA PRAZO :" + SubStr((cAlias)->ZN_PRAZO,7,2) +"/"+ SubStr((cAlias)->ZN_PRAZO,5,2) +"/"+ SubStr((cAlias)->ZN_PRAZO,1,4) + "<br>"
		cCorpo 	+=  "<br>"
		//cCorpo 	+=  Chr(13) + Chr(10) + Chr(13) + Chr(10)

		IF lEmail
		u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)
		EndIf

		DBSKIP()

	Enddo

DBSelectARea(cAlias)
DBCloseArea()

//dbSelectArea(aArea)

//RESET ENVIRONMENT // usado para utilizar a rotina schedule

Return

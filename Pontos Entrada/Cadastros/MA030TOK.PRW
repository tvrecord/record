#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MA030TOK  º Autor ³ Fabricio           º Data ³  23/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica preenchomento dos cadastros basicos obrigatorios  º±±
±±º          ³ ao livro eletronico                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - disparado na inclusao                           º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MA030TOK()

Local _lRetorno := .T.

If M->A1_TIPO<>"X" .AND. EMPTY(M->A1_CGC)
	MsgBox("Quando cliente NAO for TIPO=X o CPF/CNPJ deve ser informado! ","Verifique!","INFO")
	_lRetorno := .F.
Endif

Do Case
  Case (M->A1_EST=="EX" .and. M->A1_TIPO <> "X") .or. (M->A1_EST<>"EX" .and. M->A1_TIPO == "X")
    MsgBox("Quando o cliente for estrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!")//Mensagem alterada por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.

  Case (M->A1_EST=="EX" .and. M->A1_TIPO == "X" .and. EMPTY(M->A1_BAIRRO)) .or. (M->A1_EST=="EX" .and. M->A1_TIPO == "X" .and. EMPTY(M->A1_CEP))
    MsgBox("Quando o cliente for estrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!") //Condicao inclusa por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.

  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_MUN)
    MsgBox("Quando cliente não for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio")
   	_lRetorno := .F.

  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_COD_MUN)
    MsgBox("Quando cliente não for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio")
   	_lRetorno := .F.

EndCase

//Pedro L - Envio de email após cadastro de clientes para a Contabilidade.

	IF _lRetorno

		//M->A1_CONTA := '211' + M->A1_GRUPC + SUBSTR(M->A1_COD,3,4)

		U_AvisaCli1()

	ENDIF

Return(_lRetorno)

User Function AvisaCli1()

Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""

	cPara 		:= "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br;Contabilidade@recordtvdf.com.br;jabreu@recordtvdf.com.br"
	cAssunto	:= "Cliente incluído: " + M->A1_COD + " - " + M->A1_NOME
	cCorpo 		:= "Codigo: " + M->A1_COD + "<br>"
	cCorpo 		+= "Descrição: "+ M->A1_NOME + "<br>"
	cCorpo 		+= "Conta Contábil: "+ M->A1_CONTA + "<br>"
	cCorpo 		+= "Natureza: "+ M->A1_NATUREZ + "<br>"
	cCorpo 		+= "CPF/CNPJ: "+ M->A1_CGC + "<br>"
	cCorpo 		+= "Município: "+ "(" + M->A1_COD_MUN + ") " + A1_MUN +"<br>"
	cCorpo 		+= "Estado: "+ M->A1_EST + "<br>"
	cCorpo 		+= "País Bacen: "+ M->A1_CODPAIS + "<br>"

	u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)

dbSelectArea(aArea)
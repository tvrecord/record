#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH"

//Pedro L. (10/02/2022) - Ponto de Entrada para inclusão de botões do usuário na barra de ferramentas do cadastro de Fornecedores

User Function MA030BUT()

Local aButtons := {} // botões a adicionar

AAdd(aButtons,{ 'NOTE'      ,{||  AvisoCli2() }, 'Email contabilidade','Email' } )
//AAdd(aButtons,{ 'PEDIDO'   ,{| |  U_MyProg2() }, 'Consulta Pedidos','Ped' } )

Return (aButtons)

Static Function AvisoCli2()

Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""

	cPara 		:= "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br;"//Contabilidade@recordtvdf.com.br"
	cAssunto	:= "Cliente incluído: " + SA1->A1_COD + " - " + SA1->A1_NOME
	cCorpo 		:= "Codigo: " + SA1->A1_COD + "<br>"
	cCorpo 		+= "Descrição: "+ SA1->A1_NOME + "<br>"
	cCorpo 		+= "Conta Contábil: "+ SA1->A1_CONTA + "<br>"
	cCorpo 		+= "Natureza: "+ SA1->A1_NATUREZ + " - " + Posicione("SED",1,xFilial("SED")+SA1->A1_NATUREZ,"ED_DESCRIC") + "<br>"
	cCorpo 		+= "CPF/CNPJ: "+ SA1->A1_CGC + "<br>"
	cCorpo 		+= "Município: "+ "(" + SA1->A1_COD_MUN + ") " + A1_MUN +"<br>"
	cCorpo 		+= "Estado: "+ SA1->A1_EST + "<br>"
	cCorpo 		+= "País Bacen: "+ SA1->A1_CODPAIS + "<br>"

	u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)

dbSelectArea(aArea)

Return()

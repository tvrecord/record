#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH"

//Pedro L. (10/02/2022) - Ponto de Entrada para inclusão de botões do usuário na barra de ferramentas do cadastro de Fornecedores

User Function MA020BUT()

Local aButtons := {} // botões a adicionar

AAdd(aButtons,{ 'NOTE'      ,{||  AvisoFor2() }, 'Email contabilidade','Email' } )
//AAdd(aButtons,{ 'PEDIDO'   ,{| |  U_MyProg2() }, 'Consulta Pedidos','Ped' } )

Return (aButtons)

Static Function AvisoFor2()

Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""

	cPara 		:= "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br"
	//cPara		:= "Contabilidade@recordtvdf.com.br"
	cAssunto	:= "Fornecedor incluído: " + SA2->A2_COD + " - " + SA2->A2_NOME
	cCorpo 		:= "Codigo: " + SA2->A2_COD + "<br>"
	cCorpo 		+= "Descrição: "+ SA2->A2_NOME + "<br>"
	cCorpo 		+= "Grupo: " + SA2->A2_GRUPC + " - " + ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZU" + SA2->A2_GRUPC,"X5_DESCRI")) + "<br>"

	u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)

dbSelectArea(aArea)

Return()

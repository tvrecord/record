/*//#########################################################################################
Projeto : POUPEX
Modulo  : SIGACOM
Fonte   : SF1100I
Objetivo: Chamar funções para complementar contas a pagar e gravar dados adicionais na SF1
*///#########################################################################################

#INCLUDE 'TOTVS.CH'
#INCLUDE "TopConn.ch"

//----------------------------------------------------------
/*/{Protheus.doc} SF1100I
Ponto de entrada para no final da nota fiscal de entrada
@author Bruno Alves
@version PROTHEUS 12
@since 02/10/2020

@obs 02/10/2020 - Construcao Inicial
/*/
//----------------------------------------------------------
User Function SF1100I()

	Local _cUpd  := ""
	Local nPosRP := Ascan(aXNumRep,{|x| Alltrim(x[1]) == Alltrim(SF1->F1_DOC) + Alltrim(SF1->F1_FORNECE)})


	//Se tiver numero do RP para ser preenchido, Gravo na SF1 e SE2
	If nPosRP > 0

		//Gravo o numero do RP no cabeçalho da NF
		Reclock("SF1",.F.)
		SF1->F1_XNUMRP	:= aXNumRep[nPosRP][2]
		MsUnlock()

		//Gravo numero do RP em todos os titulos do contas a pagar

		//Altera Pedido de Compra
		_cUpd := " UPDATE " + RetSqlName("SE2")
		_cUpd += " SET"
		_cUpd += " E2_XNUMRP = '" + aXNumRep[nPosRP][2] + "' , E2_FATINI = '" + DTOS(aXNumRep[nPosRP][3]) + "' , E2_FATFIM = '"+ DTOS(aXNumRep[nPosRP][4]) + "' "
		_cUpd += " WHERE D_E_L_E_T_ = ' '"
		_cUpd += " AND E2_PREFIXO = '"+ SF1->F1_SERIE +"'"
		_cUpd += " AND E2_NUM     = '"+ SF1->F1_DOC +"'"
		_cUpd += " AND E2_FORNECE = '"+ SF1->F1_FORNECE +"'"
		_cUpd += " AND E2_LOJA    = '"+ SF1->F1_LOJA +"'"


		If TcSqlExec(_cUpd) < 0
			MsgStop("Ocorreu um erro na atualização na tabela do contas a pagar!!!")
			Final()
		EndIf

	EndIF

Return()
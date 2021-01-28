#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} MT097LOK
//
Ponto de entrada utilizado para Substituir programa de liberação do controle de alçada
@author Bruno Alves
@since 19/01/2020
@version 1.0
@return ${return}, ${return_description}
*/

User Function MT094LOK()

	Local lRetorno := .T.

	//Verifico se o controle de alçada é o customizado
	If SCR->CR_TIPO == "A1"

		//Posiciono na tabela
		DbSelectArea("SZS");DbSetOrder(1)
		If Dbseek(xFilial("SZS") + Alltrim(SCR->CR_NUM))

			//Chama tela responsavel pela liberação
			u_TelaSZS()

			//Informo que a aprovação foi feita pela aprovação da propria rotina customizada
			lRetorno := .F.

		EndIf

	EndIf


Return(  lRetorno )
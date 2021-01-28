#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} MT097LOK
//
Ponto de entrada utilizado para Substituir programa de libera��o do controle de al�ada
@author Bruno Alves
@since 19/01/2020
@version 1.0
@return ${return}, ${return_description}
*/

User Function MT094LOK()

	Local lRetorno := .T.

	//Verifico se o controle de al�ada � o customizado
	If SCR->CR_TIPO == "A1"

		//Posiciono na tabela
		DbSelectArea("SZS");DbSetOrder(1)
		If Dbseek(xFilial("SZS") + Alltrim(SCR->CR_NUM))

			//Chama tela responsavel pela libera��o
			u_TelaSZS()

			//Informo que a aprova��o foi feita pela aprova��o da propria rotina customizada
			lRetorno := .F.

		EndIf

	EndIf


Return(  lRetorno )
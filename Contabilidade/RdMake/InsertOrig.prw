#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} InsertOrig
	Fun��o responsavel pelo preenchimento da origem quando ocorrer complemento de algum lan�amento contabil.
   @author  Bruno Alves
   @since   27/05/2021
/*/

User Function InsertOrig()

	Local cOrigem := CT2_ORIGEM //Busco a informa��o da memoria, ficou dessa forma por n�o aceitar M->CT2_ORIGEM

	If FunName() == "CTBA102" .AND. ALTERA

		cOrigem := CT2->CT2_ORIGEM //Caso seja altera��o, busca o origem da informa��o posicionada.

	Endif

Return(cOrigem)
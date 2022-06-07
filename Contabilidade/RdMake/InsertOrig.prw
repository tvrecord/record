#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} InsertOrig
	Função responsavel pelo preenchimento da origem quando ocorrer complemento de algum lançamento contabil.
   @author  Bruno Alves
   @since   27/05/2021
/*/

User Function InsertOrig()

	Local cOrigem := CT2_ORIGEM //Busco a informação da memoria, ficou dessa forma por não aceitar M->CT2_ORIGEM

	If FunName() == "CTBA102" .AND. ALTERA

		cOrigem := CT2->CT2_ORIGEM //Caso seja alteração, busca o origem da informação posicionada.

	Endif

Return(cOrigem)
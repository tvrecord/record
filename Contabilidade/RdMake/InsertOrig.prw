

#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} InsertOrig

	Função responsavel pelo preenchimento da origem quando ocorrer complemento de algum lançamento contabil.

   @author  Bruno Alves
   @since   27/05/2021
/*/

User Function InsertOrig()

	Local cOrigem := ""

	If FunName() == "CTBA102" .AND. ALTERA

		cOrigem := CT2->CT2_ORIGEM

	Endif

Return(cOrigem)
#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TopConn.ch"

//Bruno Alves de OLiveira 15/03/2020
//Rotina responsavel por deletar todas as tabelas filtradas que estão vazias

user function DropTable()


	Local cQuery := ""

	cQuery	:= "SELECT " 
	cQuery	+= "TABLE_NAME "
	cQuery	+= "FROM INFORMATION_SCHEMA.TABLES WHERE "
	cQuery	+= "TABLE_NAME LIKE 'FISA008%' ORDER BY TABLE_NAME"

	tcQuery cQuery New Alias "TMP"


	DBSelectArea("TMP")
	DBGotop()

	
	While TMP->(!Eof())  

		If QtdTable(TMP->TABLE_NAME) == 0

			
			//Dropa as tabelas
			cUpd := " DROP TABLE " + TMP->TABLE_NAME

			If TcSqlExec(cUpd) < 0
			MsgStop("Ocorreu um erro na exclusao da tabela " + TMP->TABLE_NAME)
			Final()
			EndIf

		EndIf

		dbSelectArea("TMP")
		dbskip()

	EndDo
	
	dbSelectArea("TMP")
	dbCloseArea("TMP")


return


//Função que verifica a quantidade de tabelas existentes na tabela
Static Function QtdTable(cTabela) 	


	Local cQtd := "SELECT count(*) as QTD FROM " + cTabela
	Local nQtd := 0


	tcQuery cQtd New Alias "TMP_QTD"


	nQtd := TMP_QTD->QTD


	dbSelectArea("TMP_QTD")
	dbCloseArea("TMP_QTD")


Return(nQtd)
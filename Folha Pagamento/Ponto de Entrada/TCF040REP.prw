#INCLUDE "TOTVS.CH"
#INCLUDE "TCFA040.CH"

// Ponto de Entrada ap�s reprova��o da solicita��o
User Function TCF040REP()
LOCAL cIdSolic := PARAMIXB[1][1] //ID da Solicita��o
LOCAL cTpSolic := PARAMIXB[1][2] //Tipo da Solicita��o
Local cMsg     := cObserva
Local cMsg1    := cOBS
Local nErro	   := 0

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	SRA->(dbSeek(RH3->(RH3_FILIAL+RH3_MAT)))


	MsgRun( "Aguarde. Enviando Email...","",;	//"Aguarde. Enviando Email..."
	{||nErro := RH_Email(Lower(Alltrim(SQG->QG_EMAIL)),'',STR0036,cMsgEmail,'','')})


		If nErro != 0
			RH_ErroMail(nErro)
		EndIf

Return(.t.)
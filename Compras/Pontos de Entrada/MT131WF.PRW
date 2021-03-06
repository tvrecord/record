#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT130WF   �Autor  �Bruno Alves		 � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada apos finalizado a gera��o da cotacao		  ���
���          �Objetivo: Chamar o programa de alteracao fornecedor apos	  ���
���          �gravacao na tabela SC8 									  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT131WF()

	Private cNat		:= Space(09)
	Private nPrazo		:= 0


	//Linha - Coluna
	@ 000,000 TO 100,250 DIALOG oDlg TITLE "Inserir Natureza e Prazo de Entrega"
	@ 005,015 Say "Natureza:"
	@ 006,055 Get cNat  F3 "SED" Valid  !EMPTY(cNat) .AND. ExistCPO("SED",cNat) 
	@ 018,015 Say "Dias p/ Entrega:"
	@ 019,055 Get nPrazo  PICTURE "@E 999"//Valid  !EMPTY(dEntrega) //Data da entrega - Grava em todos os fornecedores
	@ 035,045 BMPBUTTON TYPE 01 ACTION GravaSC8()
	@ 035,080 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaSC8  �Autor  �Bruno Alves		 � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa utilizado para alterar os fornecedores conforme	  ���
���          �gravado na tabela SC8 pela rotina MATA130 (Gerar Cotacao),  ���
���          �lembrando que as vezes ser� inclusos novos fornecedores 	  ���
���        	 �na tabela .												  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GravaSC8


	Local cQuery   	:= ""
	Local cQuery1  	:= ""
	Local cQuery5  	:= ""
	Local cContato 	:= ""
	Local cNumSC 	:= SC1->C1_NUM



	//A cQuery busca todas as informacoes criadas pela geracao da cotacao que ainda esta em aberta e ordena por filial e produto conforme inserido na solicitacao.

	cQuery := "SELECT * FROM " + RetSqlName("SC8") + " WHERE "
	cQuery += "C8_NUMSC = '" + (cNumSC) + "' AND D_E_L_E_T_ <> '*' AND C8_NUMPED = '' "
	cQuery += "ORDER BY C8_FILIAL,C8_PRODUTO,C8_IDENT"

	TcQuery cQuery New Alias "TMP"

	dbSelectArea("TMP")
	dbGotop()


	If !EOF()	

		cQuery1 := "UPDATE " + RetSqlName("SC8") + " SET "
		cQuery1 += "C8_PRAZO = " + ALLTRIM(STR(nPrazo)) + " WHERE "
		cQuery1 += "C8_NUMSC = '" + (cNumSC) + "' AND D_E_L_E_T_ <> '*' AND C8_NUMPED = '' "

		If TcSqlExec(cQuery1) < 0
			MsgStop("Ocorreu um erro na atualiza��o na tabela SC8!")
			Final()
		EndIf		



	Endif   

	cQuery5 := "UPDATE " + RetSqlName("SC1") + " SET "
	cQuery5 += "C1_NATUREZ = '" + (cNat) + "' WHERE "
	cQuery5 += "C1_NUM = '" + (cNumSC) + "' AND D_E_L_E_T_ <> '*'"

	If TcSqlExec(cQuery5) < 0
		MsgStop("Ocorreu um erro na atualiza��o na tabela SC8!")
		Final()
	EndIf

	dbSelectArea("TMP")
	dbCloseARea("TMP")




	MsgInfo("Natureza e Prazo de entrega inserido com sucesso!")
	Close(oDlg)

Return



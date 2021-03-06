#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC �Autor  �Edmilson D. Santos   � Data �  10/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validacao da inclusao do contas a Pagar��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Clientes Microsiga                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA050INC()

PRIVATE lRetorna := .T.
// Grava a Posicao atual
aSvAlias :={Alias(),IndexOrd(),Recno()}

dbSelectArea("SE2")
nRegistro:=Recno()
dbSetOrder(1)

lRetorna := .T.

IF ALLTRIM(FUNNAME()) $ "FINA050/FINA750"

	IF M->E2_RATEIO == "S"
		//M->E2_CCD   := Vazio()
		lRetorna    := .T.
	ELSE
		//M->E2_CCD   := NaoVazio()
		IF EMPTY(M->E2_CCD).AND. TRIM(M->E2_TIPO) <> "PA" .AND. M->E2_PREFIXO <> "GPE" .AND. !SE2->E2_FORNECE $ "001105,000175"
			Help(" ",1,"E2_CCD")
			lRetorna    := .F.
		ENDIF
	ENDIF

	U_RTCTBA04()

	// Retorna a Posicao atual Gravada
ENDIF

IF EMPTY(M->E2_AUTORIZ) .AND. Posicione("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_AUTNF")  == "2" .OR. ;  //25/07/14 Sra Elenn, Naturezas que n�o precisam de autoriza��o
		EMPTY(M->E2_AUTORIZ) .AND. Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE,"A2_AUTNF")  == "2"  //25/07/14 Sra Elenn, Fornecedores que n�o precisam de autoriza��o

ELSE // Se natureza e fornecedor n�o estiverem na lista de exce��o executa a valida��o abaixo

	IF 	lRetorna .AND. ALLTRIM(FUNNAME()) $ "FINA050/FINA750" .AND. XFILIAL()== "01" .AND. EMPTY(M->E2_AUTORIZ)

		lRetorna := .F.
		Aviso("Informe a autoriza��o de pagamento","Caro Usu�rio, voc� s� poder� incluir t�tulos para essa natureza que tenham autoriza��o de pagamento liberada com mesmo fornecedor. Favor informar a autoriza��o correta!",{"Ok"}, 2)


	ELSEIF lRetorna  .AND. ALLTRIM(FUNNAME()) $ "FINA050/FINA750" .AND. XFILIAL() == "01" .AND. !EMPTY(M->E2_AUTORIZ) //Verifica se autoriza��o esta liberada e pertence ao mesmo fornecedor

		IF Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_LIBERAD") <> "L"
			lRetorna := .F.
			Aviso("Autoriza��o de pagamento n�o foi liberada","Caro Usu�rio, voc� s� poder� incluir t�tulos para essa natureza que tenham autoriza��o de pagamento liberada com mesmo fornecedor. Favor informar a autoriza��o correta!",{"Ok"}, 2)
		ELSEIF Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_LIBERAD") == "L" .AND.  ALLTRIM(Posicione("SZS",1,"01" + M->E2_AUTORIZ,"ZS_FORNECE")) <> ALLTRIM(M->E2_FORNECE)
			lRetorna := .F.
			Aviso("Autoriza��o de pagamento incorreta","Caro Usu�rio, voc� s� poder� incluir t�tulos para essa natureza que tenham autoriza��o de pagamento liberada com mesmo fornecedor. Favor informar a autoriza��o correta!",{"Ok"}, 2)
		ENDIF

	Endif

Endif


dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return lRetorna

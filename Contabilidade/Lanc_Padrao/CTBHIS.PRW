#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBHIS    �Autor  �Microsiga           � Data �  12/28/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � ATRIBUI O HISTORICO BASEADO PARA A CONTABILIDADE ATRAV�S   ���
���          � DO LP - 660.                                               ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
*/

User Function CTBHIS()

Local pHisto	:= ""

//cNota := SF1->F1_DOC
//cSerie:= SF1->F1_SERIE
//cForne:= SF1->F1_FORNECE
//cLoja := SF1->F1_LOJA

//DbSelectArea("SD1")
//SD1->(dbsetorder(1))
//IF DBSEEK(xFilial("SD1")+cNota+cSerie+cForne+cLoja,.T.)
	//	IF SD1->D1_ITEM == "0001"  //REMESSA PRA CONSERTO
      IF (Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CODIGO") $ "192,196,198")
	      pHisto := "RETORNO REM. S/NF "+SD1->D1_DOC+" "+TRIM(SA2->A2_NREDUZ)+" "+SD1->D1_FORNECE
 	   ELSE
 	      pHisto := "AQUIS. NF "+SD1->D1_DOC+" F. "+SD1->D1_FORNECE+"-" + SUBSTRING(SA2->A2_NREDUZ,1,20) + " - "+ALLTRIM(POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC"))
 	   ENDIF
//  ENDIF
//ELSE
//	pHisto := ""
//ENDIF

Return(pHisto)

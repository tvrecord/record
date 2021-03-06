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
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTBHIS1()
Private pHisto	:= ""
pFilial  := SF1->F1_FILIAL
pFornece := SF1->F1_FORNECE
pLoja    := SF1->F1_LOJA
pDoc     := SF1->F1_DOC
pSerie   := SF1->F1_SERIE

DBSELECTAREA("SD1")
DBSETORDER(1)
IF DBSEEK(pFilial+pDoc+pSerie+pFornece+pLoja,.T.)

   IF (POSICIONE("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CODIGO") $ "192,196,198")
      pHisto := "RETORNO REM. S/NF "+pDoc+" "+TRIM(SA2->A2_NREDUZ)+" "+pFornece
   ELSE
 	   pHisto := "AQUIS. NF "+pDoc+" F. "+pFornece+"-" + SUBSTRING(SA2->A2_NREDUZ,1,20) + " - "+ALLTRIM(POSICIONE("SE2",1,pFilial+pSerie+pDoc,"E2_HIST"))
 	ENDIF

ENDIF
Return(pHisto)

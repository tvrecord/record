/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � FA080POS   � Autor � Leandro Camara       � Data � 16/11/2006 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de Entrada de alteracao do historico na baixa a pagar.  ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/

User Function FA080POS()

If !Empty(SE2->E2_HIST)
   cHist070 := SE2->E2_HIST   
EndIf
//sugestao do proximo numero de cheque
IF TRIM(cMotBx) $ "CHEQUE" .AND. !EMPTY(CBANCO)
   cCheque  := POSICIONE("SA6",1,xFilial("SA6")+CBANCO+CAGENCIA+CCONTA,"A6_XULTCHE")
ENDIF  

Return
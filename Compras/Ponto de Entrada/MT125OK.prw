#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �MT125OK    � Autor � Bruno Alves� Data �  28/01/2013  ���
�������������������������������������������������������������������������͹��
��� Valida se o campo C3_MAT foi preenchido apois inserir 1=SIM no campo   ��
��� CE_PJ																   ��
��� 								                                       ��
��                                                                        ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT125OK()
Local	_aArea	:= GetArea()
Local lOk := .T.

For I := 1 To Len(aCols)
	
	If aCols[I][aScan(aHeader,{|x| Trim(x[2])=="C3_PJ"})] == "1" .AND. EMPTY(aCols[I][aScan(aHeader,{|x| Trim(x[2])=="C3_MAT"})])
		Alert("Para concluir o cadastramento � necess�rio preencher o campo MATRICULA do       Item: " + StrZero(I,4) +  "" )
		lOk := .F.
	EndIf
	
Next I

For I := 1 To Len(aCols)
	
	If aCols[I][aScan(aHeader,{|x| Trim(x[2])=="C3_FLUXO"})] == "1" .AND. (EMPTY(aCols[I][aScan(aHeader,{|x| Trim(x[2])=="C3_VENC"})]) .OR. EMPTY(aCols[I][aScan(aHeader,{|x| Trim(x[2])=="C3_MESPAG"})]))
		Alert("Favor preencher o dia e o mes do Pagamento nos campos DIA PAGAMENTO e MES PAGAMENTO, pois esse contrato est� configurado para demonstrar no Fluxo de Caixa!" )
		lOk := .F.
	EndIf
	
Next I


RESTAREA(_aArea)

Return(lOk)



#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �CALCISS  � Autor � Edmilson � Data �  20/03/07 			  ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DO VALOR DE ISS DOS AUTONOMOS        ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CALCISS()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS

Local _nValGrat	:= 0
Local _DiasTrab    := 0

If SRA->RA_CATFUNC $ "A"
	
	IF SRA->RA_TIPOPGT $ "M"
		DbSelectArea("SRC")
		DbSetOrder(1)
		DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"220",.T.)
	ELSE
		DbSelectArea("SRC")
		DbSetOrder(1)
		SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"220"+SRA->RA_CC+cSemana))
	ENDIF
	
	_ValGrat    := SRC->RC_VALOR
	_nValor 	:= Round((_valgrat*(SRA->RA_ALIQISS/100)),2)
	
	FdelPd("301")
	fGeraVerba("301",_nValor,,,,,,,,,.T.)

EndIf

Return

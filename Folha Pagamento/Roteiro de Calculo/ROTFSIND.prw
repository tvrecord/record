#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROTFSIND	� Autor � Bruno Alves        � Data �  12/01/2011 ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO CONFORME SINCIDCATO.		  		  ���
�������������������������������������������������������������������������͹��
���				        												  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROTFSIND()

Local aArea			:= GetArea()
Local nValPg		:= 0
Local nPercS		:= 0.02


If(SRA->RA_MSIND = "S")
	
	
	nValPg := SRA->RA_SALARIO * nPercS
	
	//26/01/18 - Rafael Fran�a - Mudan�a para contribui��o para 2% limitada a R$ 60. Solicitante: Giselly, 26/01/18
	
	If SRA->RA_SINDICA = "01"
		if	nValPg > 60
			nValPg := 60
		endif
	Endif
	
	//20/12/17 - Rafael Fran�a - Mudan�a para contribui��o sindical fixa a R$ 60. E-mail: ALTERA��O MENSALIDADE SINDICAL JORNALISTAS, 11/12/17
	
	If SRA->RA_SINDICA = "02"
		nValPg := 60
		nPercS := 0
	Endif
	
	fDelPd("471")
	fGeraVerba("471",nValPg,nPercS,,,"V",,,,,.t.)
	
	
Endif

RestArea(aArea)

Return
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROT007    � Autor � Hermano Nobre      � Data �  25.11.06   ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DO BENEFICIO NA APOSENTADORIA        ���
�������������������������������������������������������������������������͹��
���	A empresa conceder� um beneficio ao empregado que tiver acima de 5 anos �
��� de empresa no momento da aposentadoria.                               ���
���                                                                       ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00365 -       ���
���          EXECBLOCK("ROT007",.F.,.F.) 							      ���
���                														  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROT007()

If cTipRes $ "38/39"  // se tipo de rescisao for aposentadoria
	If U_CalcAnos(SRA->RA_ADMISSA,dDataDem1) >= 5   // Funcionario tem mais de 5 anos de empresa ?
		fDelPd("119")
		fGeraVerba("119",SRA->RA_SALARIO,1,,,,,,,,.t.)
	EndIf
EndIf

Return

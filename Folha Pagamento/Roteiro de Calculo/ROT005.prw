#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROT005    � Autor � Hermano Nobre      � Data �  23.11.06   ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DE INDENIZACAO COMPENSAVEL.  		  ���
�������������������������������������������������������������������������͹��
���	A empresa conceder� ao funcionario maior de 45 anos de idade e        l)�
��� com mais de 5 anos de empresa uma indenizacao compensavel.            ���
���                                                                       ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00366 -       ���
���          EXECBLOCK("ROT005",.F.,.F.) 							      ���
���                														  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROT005()

Local aArea			:= GetArea()
Private dDataIni	:= CTOD('  /  /  ')
Private dDataFim	:= CTOD('  /  /  ')

If cTipRes $ "09/10/11/12/13/14/15/16"
	If U_CalcAnos(SRA->RA_NASC,dDataDem1) >= 45  // Funcionario tem mais de 45 anos de idade
		If U_CalcAnos(SRA->RA_ADMISSA,dDataDem1) >= 5  // Funcionario tem pelo menos 5 anos de empresa
			fDelPd("121")
			fGeraVerba("121",SRA->RA_SALARIO,1,,,,,,,,.t.)
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return

*******************************************************
* Funcao para calcular anos conf parametro inicio e fim
*******************************************************

User Function CalcAnos(dDataIni,dDataFim)

Local nRet	:= 0

nRet := Year(dDataFim) - Year(dDataIni)
If Month(dDataIni) > Month(dDataFim)
	nRet -= 1
ElseIf Month(dDataIni) == Month(dDataFim)
	If Day(dDataIni) > Day(dDataFim)
		nRet -= 1
	EndIf
EndIf

Return(nRet)

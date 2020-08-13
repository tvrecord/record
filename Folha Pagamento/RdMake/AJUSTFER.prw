#include 'protheus.ch'
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �AJUSTFER  � Autor � Bruno Alv      � Data �  03/06/19	     ���
�������������������������������������������������������������������������͹��
��� Desc.    � GRAVA O VALOR DO SAL�RIO BASE CONFORME PREVISTO NO FUN��O   ��
��  SALMES(SALARIO COMPOSTO) AP�S OS C�LCULOS DE F�RIAS.                   ��
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�]����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function AJUSTFER()

Local _aArea	:= GetArea()
Local nSalario := SRA->RA_SALARIO + SRA->RA_REMUNEN

	RecLock("SRH",.F.)
	SRH->RH_SALMES := nSalario        
	SRH->RH_SALHRS:= nSalario/SRA->RA_HRSMES
	SRH->RH_SALDIA   := nSalario/30 
	SRH->(MsUnLock())
RESTAREA(_aArea)
	
return
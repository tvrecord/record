#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �CALC    � Autor � Rorilson        � Data �  10/12/08		  ���
�������������������������������������������������������������������������͹��
��� Antes de efetivar a Gravacao da Rescisao. Ser� alterado o sal�rio base ��
��� para o sal�rio composto, de acordo com o fun��o Salmes como o conte�do ��
��� previsto no final do c�lculo.                                          ��
��                                                                        ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Gp010ValPE()
Local	_aArea	:= GetArea()
Local lOk := .T.

IF M->RA_ACFUNC == "S" .OR. M->RA_ACUMULA != 0 .OR. M->RA_CALCADI == "S"
	
	IF EMPTY(M->RA_DESCACU)
		Alert("Favor, preencher o campo Desc. Acumulo na pasta Beneficio")
		lOk := .F.
	ELSEIF EMPTY(M->RA_CCACUM) .OR. EMPTY(M->RA_ACUM) .OR. EMPTY(M->RA_INIACUM) 
	Alert("Favor, preencher todos esses campos na pasta Beneficio: C. Custo  Acum; Descri��o C. Custo; Ini CC Acum")
		lOk := .F.
	ENDIF 
	
EndIf

RESTAREA(_aArea)

Return(lOk)



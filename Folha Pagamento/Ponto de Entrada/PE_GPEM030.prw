#include 'protheus.ch'
#INCLUDE "RWMAKE.CH"
#include "parmtype.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �GPEM030  � Autor � Bruno Alv      � Data �  03/06/19	     ���
�������������������������������������������������������������������������͹��
��� Desc.    � ponto de entrada responsavel pela altera��o das informa��es��
��  salariais do cabe�alho de ferias no momento da confirma��o do calculo ��
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�]����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function GPEM030()

	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ""
	Local cIdPonto := ""
	Local cIdModel := ""
	Local lIsGrid := .F.
	Local nLinha := 0
	Local nQtdLinhas := 0
	Local cMsg := ""

	If aParam <> NIL
		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := (Len(aParam) > 3)

		//chamada ap�s a grava��o da tabela do formul�rio
		If cIdPonto == "FORMCOMMITTTSPOS"
			//Fun��o responsavel por editar o cabe�alho no momento da confirma��o das f�rias
			u_AjustFer()        
		EndIf



	EndIf



return(xRet)
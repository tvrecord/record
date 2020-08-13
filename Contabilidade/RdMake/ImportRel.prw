#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function ImportRel()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImportRel �Autor  �Bruno Alves          � Data �  21/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclus�o de vinculo contabil - usado na configura��o de todos.���
���          � os lan�amentos padr�es contabeis de despesa                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Local cArq    := "C:\TEMP\SZI010.CSV"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local cUpd	  := ""

Private aErro := {}

If !MsgYesNo("Processa arquivo: " + cArq + "?")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + cArq + " n�o foi encontrado. A importa��o ser� abortada!","ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

Begin Transaction
ProcRegua(Len(aDados))



For i:=1 to Len(aDados)
	
	IncProc("Cadastrando Vinculo de Contas Contabeis...")
	
	If Len(aDados[i,1]) == 9 //Somente contas Analiticas
		
		RecLock("SZI",.T.)
		
		L := 1
		
		SZI->ZI_CC1 		:= ALLTRIM(aDados[i,L])
		SZI->ZI_DESC01 		:= Posicione("CT1",1,xfilial("CT1")+ALLTRIM(aDados[i,L]),"CT1_DESC01")
		L++
		
		iF EMPTY(aDados[i,L])
			L++
		EndIf
		
		iF !EMPTY(aDados[i,L])
			SZI->ZI_CC2 		:= ALLTRIM(aDados[i,L])
			SZI->ZI_DESC02 		:= Posicione("CT1",1,xfilial("CT1")+ALLTRIM(aDados[i,L]),"CT1_DESC01")
		EndIf
		L++
		
		iF EMPTY(aDados[i,L])
			L++
		EndIf
		
		iF !EMPTY(aDados[i,L]) 
			SZI->ZI_CC3 		:= ALLTRIM(aDados[i,L])
			SZI->ZI_DESC03 		:= Posicione("CT1",1,xfilial("CT1")+ALLTRIM(aDados[i,L]),"CT1_DESC01")
		EndIF
		
		SZI->(MSUNLOCK())
		
	EndIf
	
	
Next i
End Transaction

FT_FUSE()

ApMsgInfo("A Inclusao da relacao contabil foi feito com Sucesso!","SUCESSO")

Return

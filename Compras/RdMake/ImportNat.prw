#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function ImportNat()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImportNat�Autor  �Bruno Alves          � Data �  23/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Alterar valores limites no cadastro de natureza             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Local cArq    := "C:\TEMP\PRACA.CSV"
Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local _cUpd	  := ""

Private aErro := {}

If !MsgYesNo("Processa arquivo: " + cArq + " SZY010?")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + cArq + " n�o foi encontrado no caminho C:\TEMP\NATUREZAF FLUXO.CSV. A importa��o ser� abortada!","ATENCAO")
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
	
	IncProc("Processando SZY")
	
	RECLOCK("ZAF",.T.)
	ZAF_FILIAL   := xFilial("ZAF") 
	ZAF_CODIGO	 := STRZERO(VAL(aDados[i,1]),3)
	ZAF_DESCRI	 := aDados[i,2]
	ZAF_CITY	 := aDados[i,3]
	ZAF_EST		 := aDados[i,4]
	ZAF_CGC		 := aDados[i,5]
	MSUNLOCK()
	
	

	


/*	
RECLOCK("ZA6",.T.)
ZA6->ZA6_FILIAL 	:= xFilial("ZA6")
ZA6->ZA6_CODIGO     := GETSXENUM("ZA6","ZA6_CODIGO")                                                                                                   
ZA6->ZA6_MES      	:= aDados[i,1]
ZA6->ZA6_ANO     	:= aDados[i,2]
ZA6->ZA6_NATURE     := aDados[i,5]
ZA6->ZA6_NMNAT     	:= Posicione("SED",1,xFilial("SED")+aDados[i,5],"ED_DESCRIC") 
ZA6->ZA6_FORNEC     := aDados[i,3]
ZA6->ZA6_LOJA     	:= "01"
ZA6->ZA6_NMFOR     	:= Posicione("SA2",1,xFilial("SA2")+aDados[i,3] + "01","A2_NOME") 
ZA6->ZA6_VENC     	:= CTOD(aDados[i,7])
ZA6->ZA6_VENCRE     := DATAVALIDA(CTOD(aDados[i,7]))
ZA6->ZA6_VALOR     	:= VAL(aDados[i,8])
ZA6->ZA6_HIST		:= aDados[i,9]
MSUNLOCK()
*/
	
	If TcSqlExec(_cUpd) < 0
		MsgStop("Ocorreu um erro na atualiza��o na tabela SZY no registro " + aDados[i,1] + "!!!")
		Final()		
	EndIf
	
	
	
	
	
	
Next i
End Transaction

FT_FUSE()

ApMsgInfo("Altera��o das Naturezas realizada com Sucesso!","SUCESSO")

Return

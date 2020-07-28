#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function IMPORTSIG()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IncTecnico�Autor  �Rafael Fran�a       � Data �  13/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Incluir dados de um txt no sistema para or�amento SIG.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Local cArq    := ""
Local cLinha  := ""
Local nNum	  := 0
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}

Private aErro := {}
Private cPerg := "IMPORTSIG1"

ValidPerg()
Pergunte(cPerg,.T.)

cArq := MV_PAR01

If !MsgYesNo("Processa arquivo: " + alltrim(cArq) + " e substitui dados anteriores?")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + alltrim(cArq) + " n�o foi encontrado. A importa��o ser� abortada!","ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo de or�amento...")
	
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
	
	dbSelectArea("SZY")
	dbSetOrder(1)
	dbGoTop()
	
	IF dbSeek(xFilial("SZY") + aDados[i,1]) 
	Reclock("SZY",.F.)
	//ZY_CODIGO	:= UPPER(aDados[i,1])
	//ZY_DESCRI	:= UPPER(aDados[i,2])
	ZY_MES01	:= VAL(StrTran(aDados[i,3],",",".",1,)) 
	ZY_MES02	:= VAL(StrTran(aDados[i,4],",",".",1,))
	ZY_MES03	:= VAL(StrTran(aDados[i,5],",",".",1,))
	ZY_MES04	:= VAL(StrTran(aDados[i,6],",",".",1,))
	ZY_MES05	:= VAL(StrTran(aDados[i,7],",",".",1,))
	ZY_MES06	:= VAL(StrTran(aDados[i,8],",",".",1,))
	ZY_MES07	:= VAL(StrTran(aDados[i,9],",",".",1,))
	ZY_MES08	:= VAL(StrTran(aDados[i,10],",",".",1,))
	ZY_MES09	:= VAL(StrTran(aDados[i,11],",",".",1,))
	ZY_MES10	:= VAL(StrTran(aDados[i,12],",",".",1,))
	ZY_MES11	:= VAL(StrTran(aDados[i,13],",",".",1,))
	ZY_MES12	:= VAL(StrTran(aDados[i,14],",",".",1,))					
		SZY->(MsUnlock())
		nNum + 1
	ELSE
	Reclock("ZA7",.T.)
	ZY_CODIGO	:= UPPER(aDados[i,1])
	ZY_DESCRI	:= UPPER(aDados[i,2])
	ZY_MES01	:= VAL(StrTran(aDados[i,3],",",".",1,)) 
	ZY_MES02	:= VAL(StrTran(aDados[i,4],",",".",1,))
	ZY_MES03	:= VAL(StrTran(aDados[i,5],",",".",1,))
	ZY_MES04	:= VAL(StrTran(aDados[i,6],",",".",1,))
	ZY_MES05	:= VAL(StrTran(aDados[i,7],",",".",1,))
	ZY_MES06	:= VAL(StrTran(aDados[i,8],",",".",1,))
	ZY_MES07	:= VAL(StrTran(aDados[i,9],",",".",1,))
	ZY_MES08	:= VAL(StrTran(aDados[i,10],",",".",1,))
	ZY_MES09	:= VAL(StrTran(aDados[i,11],",",".",1,))
	ZY_MES10	:= VAL(StrTran(aDados[i,12],",",".",1,))
	ZY_MES11	:= VAL(StrTran(aDados[i,13],",",".",1,))
	ZY_MES12	:= VAL(StrTran(aDados[i,14],",",".",1,))
	SZY->(MsUnlock())
		
	ENDIF
	
Next i

IF 	nNum == 0
	
	ApMsgInfo("Cadastro previsao realizado com Sucesso!","SUCESSO")
	
ELSE
	
	ApMsgInfo("Foram localizados "+STRZERO(nNum,3)+" duplicados!","ATEN��O")
	
ENDIF

End Transaction

FT_FUSE()

Return

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Arquivo:        ","","","mv_ch1","C",30,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return
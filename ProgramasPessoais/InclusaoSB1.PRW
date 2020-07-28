#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function Altaxa1()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncTecnicoºAutor  ³Rafael França       º Data ³  23/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Incluir dados de um txt no sistema.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local cArq    := "C:\TEMP\APOLICEATF.CSV"
Local cLinha  := ""
Local lPrim   := .T.                      
Local aCampos := {}
Local aDados  := {}
Local _cUpd	  := ""

Private aErro := {}

If !MsgYesNo("15/06/2015 - Processa arquivo: " + cArq + " SN1010 com a nova apolice??")
	Return()
EndIf

If !File(cArq)
	MsgStop("O arquivo " + cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
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
	
	IncProc("Processando SN1")
	
	/*
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	
	//dbSeek(aDados[i,1]+ aDados[i,2] + aDados[i,3] + "01")
	//If Found()
	Reclock("SB1",.T.)
	SB1_FILIAL	:= "05" // Alterar de acordo com a filial
	SB1_DATA	:= STOD("20111231")
	SB1_LOTE    := "999999"
	SB1_SBLOTE  := "002"
	SB1_DOC  	:= "000001"
	SB1_LINHA	:= aDados[i,1]
	SB1_MOEDLC	:= "01"
	SB1_DC		:= aDados[i,6]
	IF aDados[i,6] == "1"
	SB1_DEBITO  := aDados[i,2]
	SB1_VALOR	:= val(aDados[i,4])
	ELSEIF aDados[i,6] == "2"
	SB1_CREDIT	:= aDados[i,2]
	SB1_VALOR	:= val(aDados[i,5])
	ENDIF
	SB1_HIST 	:= "LANCAMENTO SALDO INICIAL NOVAS CONTAS"
	SB1_EMPORI	:= "01"
	SB1_FILORI	:= "05"// Alterar de acordo com a filial
	SB1_TPSALD	:= "3"
	SB1_MANUAL 	:= "1"
	SB1_ORIGEM  := aDados[i,2]
	SB1_ROTINA 	:= "CTBA102"
	SB1_AGLUT	:= "2"
	SB1_SEQHIS	:= "001"
	SB1_SEQLAN	:= "001"
	
	SB1->(MsUnlock())
	//EndIf
	
	*/
	/*
	
	_cUpd := "UPDATE CT1010 SET "
	//IF aDados[i,6] == "1"
	//	_cUpd += "SB1_VALOR	= " +aDados[i,4] +" "
	//ELSEIF aDados[i,6] == "2"
	_cUpd += "CT1_SIG	= '"+aDados[i,2]+"' "
	//ENDIF
	_cUpd += "WHERE "
	_cUpd += "D_E_L_E_T_ = '' "
	//_cUpd += "AND SB1_DATA = '20121231' "
	//_cUpd += "AND (SUBSTR(N1_SERIE1,2,1) = '' AND SUBSTR(N1_SERIE1,1,1) <> '' OR N1_SERIE1 = '')  "
	//_cUpd += "AND SB1_LOTE = '999999' "
	_cUpd += "AND CT1_CONTA = '"+ aDados[i,1] +"' "
	//IF aDados[i,6] == "1"
	//	_cUpd += "SB1_DEBITO = "+aDados[i,2]+" "
	//ELSEIF aDados[i,6] == "2"
	//	_cUpd += "SB1_CREDIT = aDados[i,2] "
	//ENDIF
	//_cUpd += "AND N3_TIPO = '"+ aDados[i,4] +"'"
	
	If TcSqlExec(_cUpd) < 0
		MsgStop("Ocorreu um erro na atualização na tabela CT1!!!")
		Final()
	EndIf
	
	*/
	
	//Query
	_cUpd := "UPDATE SN1010 SET N1_APOLICE = '1800034920', N1_DTVENC = '20160413', N1_CODSEG = '000003', N1_CSEGURO = 'EMPRESARIAL/PREDIAL' "
	_cUpd += "WHERE D_E_L_E_T_ = '' "
	//_cUpd += "AND N1_FILIAL = '01' "
	//_cUpd += "AND N3_BAIXA  '' " 
	//_cUpd += "AND (SUBSTR(N1_SERIE1,2,1) = '' AND SUBSTR(N1_SERIE1,1,1) <> '' OR N1_SERIE1 = '')  "
	//_cUpd += "AND N3_TIPO = '10' "
	_cUpd += "AND N1_FILIAL = '01' "
	_cUpd += "AND N1_CBASE = '"+ aDados[i,1] +"' "
	_cUpd += "AND N1_ITEM = '"+ aDados[i,2] +"' "
	//_cUpd += "AND N3_CDEPREC = '"+ aDados[i,3] +"'"  
	
	If TcSqlExec(_cUpd) < 0
		MsgStop("Ocorreu um erro na atualização na tabela SN1!!!")
		Final()
	EndIf
	
	/*
	
	//Reclock("SN3",.F.)
	dbSelectArea("SN3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(aDados[i,1]+ aDados[i,2] + aDados[i,3] + "01")
	If Found()
	Reclock("SN3",.F.)
	N3_TXDEPR1	:= ROUND(VAL(aDados[i,4]),2)
	N3_TXDEPR2	:= ROUND(VAL(aDados[i,4]),2)
	N3_TXDEPR3	:= ROUND(VAL(aDados[i,4]),2)
	N3_TXDEPR4	:= ROUND(VAL(aDados[i,4]),2)
	N3_TXDEPR5	:= ROUND(VAL(aDados[i,4]),2)
	SN3->(MsUnlock())
	EndIf
	*/
	
Next i
End Transaction

FT_FUSE()

ApMsgInfo("Alteração SN1 feito com Sucesso!","SUCESSO")

Return
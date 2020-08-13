#include "totvs.ch"
#include "protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function IMPRATEIO()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRATEIO ºAutor  ³Rafael França       º Data ³  18/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Incluir dados de um txt no sistema.                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Local cArq    	 := ""
Local cLinha  	 := ""
Local nNum	  	 := 1
Local lPrim   	 := .T.
Local aCampos 	 := {}
Local aDados  	 := {}
Local cQuery  	 := ""
Local cRat	  	 := ""
Local cDescri	 := ""
Local cConta  	 := ""
Local cHist		 := ""
Local cTempConta := ""
Local cGrupo	 := ""
Local nTotal 	 := 0

Private aErro := {}
Private cPerg := "IMPRAT1"

ValidPerg()
Pergunte(cPerg,.T.)

cArq := MV_PAR04

//If !MsgYesNo("Processa arquivo: " + alltrim(cArq) + " e substitui dados anteriores?")
//	Return()
//EndIf

If !File(cArq)
	MsgStop("O arquivo " + alltrim(cArq) + " não foi encontrado. A importação será abortada!","ATENCAO")
	Return
EndIf

cQuery  := "SELECT CTJ_FILIAL,CTJ_RATEIO,CTJ_DESC,CTJ_DEBITO,CTJ_HIST FROM CTJ010 "
cQuery  += "WHERE D_E_L_E_T_ = '' AND CTJ_RATEIO = '"+MV_PAR01+"' AND CTJ_FILIAL = '01' "
cQuery  += "GROUP BY CTJ_FILIAL,CTJ_RATEIO,CTJ_DESC,CTJ_DEBITO,CTJ_HIST "
cQuery  += "ORDER BY CTJ_DEBITO"

tcQuery cQuery New Alias "TMPRAT"

If Eof()
	MsgInfo("Não existe rateio informado!","Verifique")
	dbSelectArea("TMPRAT")
	dbCloseArea("TMPRAT")
	Return
Endif

DBSelectArea("TMPRAT")
DBGotop()

cRat	  	:= TMPRAT->CTJ_RATEIO
cDescri		:= TMPRAT->CTJ_DESC
IF MV_PAR02 == 1
	cConta      := MV_PAR03
	cTempConta	:= MV_PAR03
ELSE
	cConta  	:= TMPRAT->CTJ_DEBITO
	cTempConta	:= TMPRAT->CTJ_DEBITO
ENDIF
cHist		:= TMPRAT->CTJ_HIST

dbSelectArea("TMPRAT")
dbCloseArea("TMPRAT")

IF MsgYesNo("O sistema irá substituir o rateio " + ALLTRIM(cRat) + " - " + ALLTRIM(cDescri) + ". Deseja continuar?","Atenção")
	
	
	FT_FUSE(cArq)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
		
		IncProc("Lendo arquivo de rateio externo...")
		
		cLinha := FT_FREADLN()
		
		If lPrim //Tira a primeira linha
			
			lPrim := .F.
			
			AADD(aCampos,Separa(cLinha,";",.T.))
			
		Else
			
			AADD(aDados,Separa(cLinha,";",.T.))
			
		EndIF
		
		FT_FSKIP()
	EndDo
	
	For i:=1 to Len(aDados) //Verifica integridade das informações
		
		nNum += 1
		nTotal += VAL(StrTran(StrTran(StrTran(aDados[i,3],"%","",1,),".","",1,),",",".",1,))
		
		IF !EXISTCPO("CTT",aDados[i,1]) .AND. !EMPTY(aDados[i,1])
			ApMsgInfo("Centro de custo não existe! " + ALLTRIM(aDados[i,1]) + " linha: " + STRZERO(nNum,3) + ".","Verificar")
			Return
		ENDIF
		
	Next i
	
	//IF nTotal <> 100
	//ApMsgInfo("Soma da porcentagem não foi igual a 100%.","Verificar")
	//Return
	//ENDIF
	
	Processa({|| TcSqlExec("DELETE FROM CTJ010 WHERE CTJ_RATEIO = '" + MV_PAR01 + "'")},"Deletando registro antigo!")
	
	Begin Transaction
	ProcRegua(Len(aDados))
	nNum := 1
	For i:=1 to Len(aDados)
		
		IncProc("Processando CTJ...")
		
		IF !EMPTY(aDados[i,1])
			
			dbSelectArea("CTJ")
			dbSetOrder(1)
			dbGoTop()
			
			//Altera a conta de acordo com o Centro de Custo
			If  cTempConta >= '41' .AND. cTempConta <= '439999999'
				
				cGrupo 	:= Posicione("CTT",1,xFilial("CTT") + IIF(ALLTRIM(aDados[i,1])==" ", " ",ALLTRIM(aDados[i,1]))   ,"CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
				
				If SUBSTR(cTempConta,2,1) == cGrupo // Verifica se a conta contabil do cadastro está OK
					cConta := cTempConta
					//Se a Conta contabil não for o mesmo grupo do centro de custo, o programa pesquisa
					//uma conta compativel no cadastro da relação da conta contabil
				ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2"),2,1) == cGrupo
					cConta := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2")
				ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3"),2,1) == cGrupo
					cConta := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3")
				EndIf
			ENDIF
			
			Reclock("CTJ",.T.)
			CTJ_FILIAL	:= "01"
			CTJ_RATEIO	:= cRat
			CTJ_SEQUEN	:= STRZERO(nNum,3)
			CTJ_DESC	:= cDescri
			CTJ_MOEDLC	:= "01"
			CTJ_TPSALD	:= "1"
			CTJ_DEBITO	:= cConta
			CTJ_PERCEN	:= VAL(StrTran(StrTran(aDados[i,3],"%","",1,),",",".",1,))
			CTJ_HIST	:= cHist
			CTJ_CCD  	:= aDados[i,1]
			ZA7->(MsUnlock())
			
			nNum += 1
			
		ENDIF
		
	Next i
	
	ApMsgInfo("Cadastro realizado com Sucesso!","SUCESSO")
	
	End Transaction
	
	FT_FUSE()
	
EndIf

Return

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Codigo Rateio:		","","","mv_ch01","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTJ"})
aAdd(aRegs,{cPerg,"02","Altera C Contabil:	","","","mv_ch02","N",01,00,1,"C","","mv_par02","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","C. Contabil:    	","","","mv_ch03","C",20,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
aAdd(aRegs,{cPerg,"04","Arquivo:        	","","","mv_ch04","C",50,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
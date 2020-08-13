#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP_comp     ºAutor  ³Microsiga           º Data ³  12/28/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_comp()
Private cRet		:= ""
Private nSD1CONTA	:= ""
Private cGrupo		:= ""
Private cTempConta 	:= ""

DbSelectArea("SB1")

DbSelectArea("SF4")
SF4->(dbsetorder(1))

/*
IF SD1->D1_CC = ""

If (SF4->(DBSEEK(XFILIAL('SF4')+SD1->D1_TES)))
If SF4->F4_CTBDESP=="1"
cRet :=SF4->F4_CCONTA
endif
endif
If SF4->F4_CTBDESP=="2"
cRet :=Posicione("SB1",1,xfilial("SB1")+SD1->D1_COD,"B1_CONTA")
Endif

ELSE
*/

If (SF4->(DBSEEK(XFILIAL('SF4')+SD1->D1_TES)))
	If SF4->F4_CTBDESP=="1"
		
		cTempConta	:= SF4->F4_CCONTA
		
		If  cTempConta >= '41' .AND. cTempConta <= '439999999'
			
			cGrupo 		:= Posicione("CTT",1,xFilial("CTT") + SDE->DE_CC,"CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
			
			If SUBSTR(cTempConta,2,1) == cGrupo // Verifica se a conta contabil do cadastro está OK
				cRet := cTempConta
				//Se a Conta contabil não for o mesmo grupo do centro de custo, o programa pesquisa
				//uma conta compativel no cadastro da relação da conta contabil
			ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2"),2,1) == cGrupo
				cRet := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2")
			ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3"),2,1) == cGrupo
				cRet := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3")
			EndIf
			
		ELSE
			
			Ret :=SF4->F4_CCONTA
			
		ENDIF
		
	endif
endif

If SF4->F4_CTBDESP=="2"
	
	cTempConta	:= Posicione("SB1",1,xfilial("SB1") + SD1->D1_COD,"B1_CONTA")
	
	If  cTempConta >= '41' .AND. cTempConta <= '439999999'
		
		cGrupo 		:= Posicione("CTT",1,xFilial("CTT") + SDE->DE_CC,"CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
		
		If SUBSTR(cTempConta,2,1) == cGrupo // Verifica se a conta contabil do cadastro está OK
			cRet := cTempConta
			//Se a Conta contabil não for o mesmo grupo do centro de custo, o programa pesquisa
			//uma conta compativel no cadastro da relação da conta contabil
		ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2"),2,1) == cGrupo
			cRet := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2")
		ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3"),2,1) == cGrupo
			cRet := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3")
		EndIf
		
	ELSE
		
		cRet :=Posicione("SB1",1,xfilial("SB1")+SD1->D1_COD,"B1_CONTA")
		
	ENDIF
	
ENDIF

//ENDIF

Return(cRet)

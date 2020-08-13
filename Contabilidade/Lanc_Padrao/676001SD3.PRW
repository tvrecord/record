
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³650010ºAutor  ³Microsiga           º Data ³  01/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para o novo plano de contas                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
GRUPO:
- 1: Custo de Produção
- 2: Comercial
- 3: Administativo
*/



User Function 676001SD3()


Private cConta 		:= ""
Private cGrupo 		:= "" 
Private cTempConta	:= ""

_aArea := GetArea()

If SB1->B1_CONTA >= '41' .AND. SB1->B1_CONTA <= '439999999'
	
	cGrupo 		:= Posicione("CTT",1,xFilial("CTT") + SD3->D3_CC, "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	cTempConta	:= POSICIONE("SB1",1,xFilial("SD3") + SD3->D3_COD,"B1_CONTA")
	
	If SUBSTR(POSICIONE("SB1",1,xFilial("SD3") + SD3->D3_COD,"B1_CONTA"),2,1) == cGrupo // Verifica se a conta contabil do cadastro está OK
		cConta 	:= cTempConta
		//Se a Conta contabil não for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da relação da conta contabil   
	ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC2")
	ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cTempConta, "ZI_CC3")
	EndIf
	
	
	
ELSE
	
	cConta := POSICIONE("SB1",1,xFilial("SD3") + SD3->D3_COD,"B1_CONTA")
	
EndIf

_aArea	:= RestArea(_aArea)


Return(cConta)
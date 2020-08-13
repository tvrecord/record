
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A01003CREºAutor  ³Microsiga           º Data ³  01/03/13   º±±
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



User Function A01003CRE()


Private cConta := ""
Private cGrupo := ""
Private cSRVConta := IIF(SRZ->RZ_PD=="760".AND.SRZ->RZ_VAL<0,POSICIONE("SRV",1,XFILIAL("SRV")+SRZ->RZ_PD,"RV_CTACRED"),"")

_aArea := GetArea()    	

If cSRVConta >= '41' .AND. cSRVConta <= '439999999'
	
	cGrupo := Posicione("CTT",1,xFilial("CTT") + IIF(SUBSTR(POSICIONE("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"RV_CTACRED"),1,1)=="4",SRZ->RZ_CC,""), "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	
	If SUBSTR(cSRVConta,2,1) == cGrupo // Verifica se a conta contabil do cadastro está OK
		cConta := cSRVConta
		
		//Se a Conta contabil não for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da relação da conta contabil
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cSRVConta, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cSRVConta, "ZI_CC2")
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cSRVConta, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cSRVConta, "ZI_CC3")
	EndIf
	
	
	
ELSE
	
	cConta := cSRVConta
	
EndIf

_aArea	:= RestArea(_aArea)


Return(cConta)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A01001DEB�Autor  �Microsiga           � Data �  01/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra para o novo plano de contas                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
GRUPO:
- 1: Custo de Produ��o
- 2: Comercial
- 3: Administativo
*/



User Function A01001DEB()


Private cConta := ""
Private cGrupo := ""
Private cSRVConta := iif(SRZ->RZ_PD<>"760",POSICIONE("SRV",1,"  "+SRZ->RZ_PD,"RV_CONTA"),"")   

_aArea := GetArea()

If cSRVConta >= '41' .AND. cSRVConta <= '439999999'
	
	cGrupo := Posicione("CTT",1,xFilial("CTT") + IF(SUBSTR(POSICIONE("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"RV_CONTA"),1,1)=="4",SRZ->RZ_CC,""), "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	
	If SUBSTR(cSRVConta,2,1) == cGrupo // Verifica se a conta contabil do cadastro est� OK
		cConta := cSRVConta
		
		//Se a Conta contabil n�o for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da rela��o da conta contabil
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
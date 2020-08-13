
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �650010�Autor  �Microsiga           � Data �  01/03/13   ���
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



User Function 650010SF4()


Private cConta := ""
Private cGrupo := ""

_aArea := GetArea()

If SF4->F4_CCONTA >= '41' .AND. SF4->F4_CCONTA <= '439999999'
	
	cGrupo := Posicione("CTT",1,xFilial("CTT") + SD1->D1_CC, "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	
	If SUBSTR(SF4->F4_CCONTA,2,1) == cGrupo // Verifica se a conta contabil do cadastro est� OK
		cConta := SF4->F4_CCONTA
		
		//Se a Conta contabil n�o for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da rela��o da conta contabil
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + SF4->F4_CCONTA, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + SF4->F4_CCONTA, "ZI_CC2")
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + SF4->F4_CCONTA, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + SF4->F4_CCONTA, "ZI_CC3")
	EndIf
	
	
	
ELSE
	
	cConta := SF4->F4_CCONTA
	
EndIf

_aArea	:= RestArea(_aArea)


Return(cConta)
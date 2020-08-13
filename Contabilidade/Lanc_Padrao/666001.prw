
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �666001�Autor  �Microsiga           � Data �  01/03/13   ���
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



User Function 666001()


Private cConta := ""
Private cGrupo := ""
Private cSB1Conta := POSICIONE("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_CONTA")

_aArea := GetArea()

If cSB1Conta >= '41' .AND. cSB1Conta <= '439999999'
	
	cGrupo := Posicione("CTT",1,xFilial("CTT") + IF(EMPTY(SD3->D3_CC),"4002003",SD3->D3_CC), "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	
	If SUBSTR(cSB1Conta,2,1) == cGrupo // Verifica se a conta contabil do cadastro est� OK
		cConta := cSB1Conta
		
		//Se a Conta contabil n�o for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da rela��o da conta contabil
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cSB1Conta, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cSB1Conta, "ZI_CC2")
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cSB1Conta, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cSB1Conta, "ZI_CC3")
	EndIf
	
	
	
ELSE
	
	cConta := cSB1Conta
	
EndIf

_aArea	:= RestArea(_aArea)


Return(cConta)
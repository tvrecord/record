
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �516002�Autor  �Microsiga           � Data �  01/03/13   ���
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



User Function 516002()


Private cConta := ""
Private cGrupo := ""

_aArea := GetArea()

If SED->ED_CONTA >= '41' .AND. SED->ED_CONTA <= '439999999'
	
	cGrupo := Posicione("CTT",1,xFilial("CTT") + CUSTOD, "CTT_GRUPO")// Busca o grupo do plano de contas no cadastro do centro de custo
	
	If SUBSTR(SED->ED_CONTA,2,1) == cGrupo // Verifica se a conta contabil do cadastro est� OK
		cConta := SED->ED_CONTA
		
		//Se a Conta contabil n�o for o mesmo grupo do centro de custo, o programa pesquisa
		//uma conta compativel no cadastro da rela��o da conta contabil
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + SED->ED_CONTA, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + SED->ED_CONTA, "ZI_CC2")
	elseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + SED->ED_CONTA, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + SED->ED_CONTA, "ZI_CC3")
	EndIf
	
	
	
ELSE
	
	cConta := SED->ED_CONTA
	
EndIf

_aArea	:= RestArea(_aArea)


Return(cConta)

#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT130WF   �Autor  �Bruno Alves		 � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada apos finalizado a gera��o da cotacao		  ���
���          �Objetivo: Chamar o programa de alteracao fornecedor apos	  ���
���          �gravacao na tabela SC8 									  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TelVerba

Private cVerba := Space(03)

@ 000,000 TO 120,300 DIALOG oDlg TITLE "Excluir Lan�amento zerado"
@ 010,005 Say "Deseja utilizar a rotina para excluir lan�amentos zerados?"
@ 020,032 Say "Informe qual verba ser� excluida:"
@ 030,063 Get cVerba VALID !EMPTY(cVerba) .AND. ExistCpo("SRV",cVerba)//Quantidade de Fornecedores que serao alterados ou inclusos
@ 045,045 BMPBUTTON TYPE 01 ACTION ExcVerba()
@ 045,075 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TelaFor   �Autor  �Bruno Alves		 � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela que ir� buscar quais fornecedores serao inclusos ou	  ���
���          �alterados quando chamado o programa GravaSC8				  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function ExcVerba

Private cQuery := ""

cQuery := "DELETE FROM	" + RetSqlName("SRC") + " WHERE "
cQuery += "RC_VALOR = 0 AND RC_PD = '" + cVerba + "' AND D_E_L_E_T_ <> '*'" 

                    
If TcSqlExec(cQuery) < 0
	MsgStop("Ocorreu um erro na exclus�o da tabela SRC!")
	Final()
EndIf 

MsgInfo("Exclus�o realizada com sucesso!!")

Return



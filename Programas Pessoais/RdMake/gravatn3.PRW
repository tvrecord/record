#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"



User Function GRAVATN3


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaSC8  �Autor  �Bruno Alves		 � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa utilizado para alterar os fornecedores conforme	  ���
���          �gravado na tabela SC8 pela rotina MATA130 (Gerar Cotacao),  ���
���          �lembrando que as vezes ser� inclusos novos fornecedores 	  ���
���        	 �na tabela .												  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



Local cQuery   := ""


cQuery := "SELECT B1_COD FROM SB1010 WHERE "
cQuery += "B1_GRUPO IN ('095','100') AND "
cQuery += "D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY B1_COD "

TcQuery cQuery New Alias "TMP"



dbSelectArea("TMP")
dbGotop()

While !EOF()
	
	
	RECLOCK("SB2",.T.)
	B2_FILIAL := "01"
	B2_COD := TMP->B1_COD
	B2_LOCAL := "01"
	B2_QATU := 1
	MSUNLOCK()
	
	DBSelectArea("TMP")
	DBSKIP()
	
	
Enddo

dbSelectArea("TMP")
dbCloseARea("TMP")


MsgInfo(" Saldos inseridos com sucesso!")


Return

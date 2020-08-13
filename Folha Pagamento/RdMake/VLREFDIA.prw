#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLREFDIA     �Autor  �Bruno Alves         � Data �  03/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula o dia do vale refei��o/alimenta��o                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                       

User Function VLREFDIA

Private cQuery := ""
Private nValor := 0


cQuery := "SELECT "
/*
cQuery += "SUBSTR(RX_TXT,34,2) AS DIAS, "
cQuery += "SUBSTR(RX_TXT,28,5) AS VALOR "
*/

cQuery += "RFO_DIAFIX AS DIAS, "
cQuery += "RFO_VALOR AS VALOR "
	
cQuery += "FROM SRA010 "
/*
cQuery += "INNER JOIN SRX010 ON "
cQuery += "SRA010.RA_VALREF = SUBSTR(RX_COD,13,2) "
*/
cQuery += "INNER JOIN RFO010 ON "
cQuery += "SRA010.RA_VALREF = RFO010.RFO_CODIGO "

cQuery += "WHERE "
cQuery += "SRA010.RA_FILIAL = '" + (xFilial("SZO")) + "' AND "
cQuery += "SRA010.RA_MAT = '" + (M->ZO_MAT) + "' AND "
cQuery += "SRA010.RA_DESCMED <> '4' AND " //Refeicao ou Alimentacao
cQuery += "SRA010.RA_VALREF <> '' AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
/*
cQuery += "SRX010.RX_TIP = '26' AND "
cQuery += "SRX010.D_E_L_E_T_ <> '*'"
*/
cQuery += "RFO010.D_E_L_E_T_ <> '*'"


tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("C�digo do vale refei��o n�o vinculado no cadastro do Funcionario!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif              

nValor := ((M->ZO_DIAS * TMP->VALOR) * M->ZO_PERC) / 100                                               

	dbSelectArea("TMP")
	dbCloseArea("TMP")


Return(nValor)
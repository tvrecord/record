#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPM040CO  �Autor  �Bruno Alves         � Data �  11/16/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se existe algum IPI para ser entreguea            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function GPM040CO()


Local aArea 	:= GetArea()       
Local lRet 		:= .T.
Local cQuery 	:= ""

cQuery := "SELECT COUNT(TNF_MAT) AS QUANTIDADE FROM TNF010 WHERE "
cQuery += "TNF_MAT = '" + (SRA->RA_MAT) + "' AND "
cQuery += "TNF_INDDEV = '2' AND "
cQuery += "TNF_DTDEVO = '' AND "
cQuery += "D_E_L_E_T_ <> '*'"

TcQuery cQuery New Alias "TMP"

If TMP->QUANTIDADE > 0 .AND. (SRA->RA_AUTORIZ == "2" .OR. EMPTY(SRA->RA_AUTORIZ))
Alert("Funcion�rio n�o entregou todos os EPIS")	    
lRet := .F.
ElseIf TMP->QUANTIDADE > 0 .AND. SRA->RA_AUTORIZ == "1" 
Alert("Funcion�rio n�o entregou todos os EPIS, mas foi liberado pela Chefia")	    
EndIf




DBSelectARea("TMP")
DBCloseArea("TMP")

RestArea(aArea)

Return (lRet)

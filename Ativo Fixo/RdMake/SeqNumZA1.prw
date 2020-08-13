#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXSZ2     � Autor � Bruno alves        � Data �  07/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Sequencia do cadastro da Pre Transferencia                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SeqNumZA1

Local	aAreaX3 := GetArea("ZA1")
Local   cQuery := ""
Local   cProxNum := ""
Local   nProxNum := 0


cQuery := "SELECT MAX(ZA1_CODIGO) AS NUM FROM ZA1010 WHERE "
cQuery += "D_E_L_E_T_ <> '*' "

TcQuery cQuery New Alias "TMP"

DbSelectARea("TMP")   

If empty(TMP->NUM)
cProxNum := "000001"
else
nProxNum := VAL(TMP->NUM) + 1
cProxNum := Strzero(nProxNum,6)
EndIf

DbSelectARea("TMP")   
DBCloseArea("TMP")

RestArea(aAreaX3)

Return(cProxNum)               
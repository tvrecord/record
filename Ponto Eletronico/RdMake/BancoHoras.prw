#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BancoHoras�Autor  �Bruno Alves         � Data �  09/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajustar o saldo interior da competencia 072010              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GVObs()

cQuery := ""

cQuery := "SELECT * FROM SZL010 WHERE ZL_PEDIDO = '006802'" 
TcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

dbSelectArea("TMP")
dbGotop()

While !EOF()

DbSelectArea("SZL")
DbSetOrder(1)
DbSeek(xFilial("SZL") + TMP->ZL_COTACAO + TMP->ZL_PEDIDO)

MSMM(SZL->ZL_OBS1,TamSX3("ZL_OBS"),,"TESTE",1,,,"SZL","ZL_COTACAO")
//MSMM(,TamSX3("ZL_OBS"),,"teste unico",1,,,"SZL","ZL_COTACAO")
//cMemo := MSMM (cChave,nTam,nLin,cString,nOpc,nTabSize,lWrap,cAlias,cCpochave)


DbSelectArea("TMP")
DbSkip()

End

Alert("Operacao realizada com sucesso!!")

dbCloseArea("TMP")
dbCloseArea("SZL")

Return
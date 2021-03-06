#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460I   � Autor � AP6 IDE            � Data �  01/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada utilizado na geracao das NFs de Saida     ���
���          � onde eh calculado e gravado o Nosso Numero nos Titulos     ���
���          � do SE1 gerados, facilitando a geracao do CNAB.             ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record-DF - modulo Financeiro                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CONTAFAT()        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

// Grava a Posicao atual
Local lRet := ""

aSvAlias :={Alias(),IndexOrd(),Recno()}
//IF SD2->D2_ITEM == "01"
   cPedido 	:=  SD2->D2_PEDIDO             
	DBSELECTAREA("SC5")
	DBSETORDER(1)
	SC5->(DBSEEK(xFilial("SC5")+cPedido))

	IF FOUND()                                                             
   	lRet := POSICIONE("SED",1,xFilial("SED")+SC5->C5_NATUREZ,"ED_CONTA")
	ELSE      
		lRet := ""
	ENDIF   
   
//ENDIF
	// Retorna a Posicao atual Gravada
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

RETURN lRet

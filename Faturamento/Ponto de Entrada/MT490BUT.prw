#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT490	    � Autor �Rafael Franca       � Data �  23/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para preenchimento do campo E3_DATA na     ���
���          �rotina de manuten�ao de comissoes.                          ���
�������������������������������������������������������������������������͹��
���Uso       �Protheus 10                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT490BUT()
Local aButtons := {}

	AADD(aButtons,{'EDITABLE', {||aDataPag()},"Data do Pagamento", "Data Pag."})

Return(aButtons)

Static Function aDataPag		// Criar uma tela para altera�ao da data de Pagamento  
Local dData := CtoD("//")

@ 000,000 TO 100,300 DIALOG oDlg TITLE "Data de Pagamento"
@ 010,020 Say "Data do pagamento:"
@ 010,070 Get dData 
@ 035,080 BMPBUTTON TYPE 01 ACTION AlteraData(dData)
@ 035,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function AlteraData(dData)		//Grava a Nova data no Campo E3_DATA

If Empty(dData)
	MsgInfo("Informe a Data","VAZIO")
	Return
Endif

RecLock("SE3",.F.)
M->E3_DATA := dData
MsUnLock()

Close(oDlg)

Return 
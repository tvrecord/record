#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT241GRV  � Autor � Cristiano D. Alves � Data �  20/07/07   ���
                      Alterado  : Edmilson Dias Santos Data    09/05/10
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para chamada do relat�rio Rela��o de Re-  ���
���          � quisi��o ao almoxarifado.
��					Permitir que o usu�rio imprima a requisi��o digitando o nome
               do solicitante que ser� impresso na requisi��o.
�������������������������������������������������������������������������͹��
���Uso       � Movimentos Internos Mod. 2                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT241GRV(cDocumento,dA241Data)

Local aAreaPE := GetArea()
Local oDlg1
Local nRet		:=	0
Local cTitle	:=	"Solicitante"
Local _cDocumento	:= SD3->D3_DOC
Private _Solicita:=space(30)

If MsgYesNo("Deseja imprimir a rela��o de requisi��o?","Aten��o!!!")

	Define MsDialog oDlg1 Title cTitle From 000,000 To 100,230 Of oMainWnd Pixel
	@ 010,010 Get _Solicita	PICTURE "@S30" Size 090,050
	Define SButton From 030,075 Type 1 Enable Of oDlg1 Action oDlg1:End()
	Activate MsDialog oDlg1 Centered

cQuery := "UPDATE " + RetSqlName("SD3") + " SET "    // Rafael Fran�a - Grava o nome do solicitante na tabela
cQuery += "D3_OBS = '" + (_Solicita) + "' WHERE "
cQuery += "D3_DOC = '" + (_cDocumento) + "' AND D_E_L_E_T_ <> '*'"
                                                                                                              �
If TcSqlExec(cQuery) < 0
	MsgAlert("Ocorreu um erro na atualiza��o na tabela SD3!","Aten��o!")
EndIf

	U_RTCR123(_Solicita) //Chamada do relat�rio personalizado
	Pergunte("MTA240    ",.F.)
EndIf

RestArea(aAreaPE)

Return(.T.)

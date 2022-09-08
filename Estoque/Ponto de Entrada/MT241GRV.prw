#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT241GRV  º Autor ³ Cristiano D. Alves º Data ³  20/07/07   º±±
                      Alterado  : Edmilson Dias Santos Data    09/05/10
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para chamada do relatório Relação de Re-  º±±
±±º          ³ quisição ao almoxarifado.
±±					Permitir que o usuário imprima a requisição digitando o nome
               do solicitante que será impresso na requisição.
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Movimentos Internos Mod. 2                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT241GRV(cDocumento,dA241Data)

Local aAreaPE := GetArea()
Local oDlg1
Local nRet		:=	0
Local cTitle	:=	"Solicitante"
Local _cDocumento	:= SD3->D3_DOC
Private _Solicita:=space(30)

If MsgYesNo("Deseja imprimir a relação de requisição?","Atenção!!!")

	Define MsDialog oDlg1 Title cTitle From 000,000 To 100,230 Of oMainWnd Pixel
	@ 010,010 Get _Solicita	PICTURE "@S30" Size 090,050
	Define SButton From 030,075 Type 1 Enable Of oDlg1 Action oDlg1:End()
	Activate MsDialog oDlg1 Centered

cQuery := "UPDATE " + RetSqlName("SD3") + " SET "    // Rafael França - Grava o nome do solicitante na tabela
cQuery += "D3_OBS = '" + (_Solicita) + "' WHERE "
cQuery += "D3_DOC = '" + (_cDocumento) + "' AND D_E_L_E_T_ <> '*'"
                                                                                                              ú
If TcSqlExec(cQuery) < 0
	MsgAlert("Ocorreu um erro na atualização na tabela SD3!","Atenção!")
EndIf

	U_RTCR123(_Solicita) //Chamada do relatório personalizado
	Pergunte("MTA240    ",.F.)
EndIf

RestArea(aAreaPE)

Return(.T.)

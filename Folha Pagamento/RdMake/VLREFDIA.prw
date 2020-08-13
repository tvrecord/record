#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLREFDIA     ºAutor  ³Bruno Alves         º Data ³  03/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o dia do vale refeição/alimentação                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	MsgInfo("Código do vale refeição não vinculado no cadastro do Funcionario!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif              

nValor := ((M->ZO_DIAS * TMP->VALOR) * M->ZO_PERC) / 100                                               

	dbSelectArea("TMP")
	dbCloseArea("TMP")


Return(nValor)
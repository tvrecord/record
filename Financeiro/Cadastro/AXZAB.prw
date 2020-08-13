#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AxSZK     º Autor ³ Rafael Franca      º Data ³  13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de situacoes de ativos no sistema.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Record Centro-Oeste                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AXZAB

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro BV"
Private nOpca := 0
Private aParam := {}                       

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","AxInclui",0,3},;
{"Alterar","AxAltera",0,4},;
{"Excluir","AxDeleta",0,5},;
{"Importar","u_IMPORTSE2",0,5},;
{"Relatorio","u_COMISSBV()",0,2}}

Private cString := "ZAB"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return

User Function IMPORTSE2

Private dBaixa1 	:= CtoD("//")
Private dBaixa2 	:= CtoD("//")
Private dFat1		:= CtoD("//")
Private dFat2		:= CtoD("//")

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Importar Titulos de Comissoes"
@ 011,020 Say "Da Baixa:"
@ 010,060 Get dBaixa1  SIZE 40,020
@ 011,150 Say "Ate a Baixa:"
@ 010,190 Get dBaixa2 SIZE 40,020
@ 035,020 Say "Do Faturamento:"
@ 035,060 Get dFat1 SIZE 40,020
@ 035,150 Say "Ate o Faturamento:"
@ 035,190 Get dFat2 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION IMPORTBV(dBaixa1,dBaixa2,dFat1,dFat2)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function IMPORTBV(dBaixa1,dBaixa2,dFat1,dFat2)

Local cQuery := ""

cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,E2_BAIXA,(E2_ISS + E2_IRRF + E2_VALOR) AS E2_VALOR,E2_NATUREZ,E2_HIST "
cQuery += "FROM SE2010 "
cQuery += "INNER JOIN SED010 ON E2_NATUREZ = ED_CODIGO "
cQuery += "INNER JOIN SA2010 ON A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA "
cQuery += "WHERE SED010.D_E_L_E_T_ = '' AND SE2010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' "
cQuery += "AND ED_COMBV = '1' "
cQuery += "AND E2_BAIXA BETWEEN '" + DTOS(dBaixa1) + "' AND '" + DTOS(dBaixa2) + "' "
//cQuery += "AND E2_VENCREA BETWEEN '" + DTOS(dFat1) + "' AND '" + DTOS(dFat2) + "' "
cQuery += "ORDER BY E2_NATUREZ "

tcQuery cQuery New Alias "TMPBV"

If Eof()
	MsgInfo("Não existem dados no periodo informado!","Verifique")
	dbSelectArea("TMPBV" )
	dbCloseArea("TMPBV" )
	Return
Endif

Count To nRec

dbSelectArea("TMPBV")
dbGoTop()

ProcRegua(nRec)

While !EOF()
	
	IncProc()
	
	dbSelectArea("ZAB")
	dBSetOrder(1)
	If !dbSeek(xFilial("ZAB") + TMPBV->E2_PREFIXO + TMPBV->E2_NUM + TMPBV->E2_PARCELA + TMPBV->E2_TIPO + TMPBV->E2_FORNECE + TMPBV->E2_LOJA)
		Reclock("ZAB",.T.)
		ZAB->ZAB_FILIAL := xFilial("ZAB")    
		ZAB->ZAB_PREFIX := TMPBV->E2_PREFIXO   
		ZAB->ZAB_TITULO := TMPBV->E2_NUM   
		ZAB->ZAB_PARC   := TMPBV->E2_PARCELA 
		ZAB->ZAB_TIPO   := TMPBV->E2_TIPO 
		ZAB->ZAB_FORNEC := TMPBV->E2_FORNECE   
		ZAB->ZAB_LOJA 	:= TMPBV->E2_LOJA 
		ZAB->ZAB_NOME	:= TMPBV->E2_NOMFOR
		ZAB->ZAB_EMISSA := STOD(TMPBV->E2_EMISSAO)    
		ZAB->ZAB_VENCTO := STOD(TMPBV->E2_VENCREA)
		ZAB->ZAB_BAIXA 	:= STOD(TMPBV->E2_BAIXA)		
		ZAB->ZAB_NATURE := TMPBV->E2_NATUREZ
		ZAB->ZAB_OBS    := TMPBV->E2_HIST
		ZAB->ZAB_VLSE2	:= TMPBV->E2_VALOR
		MsUnlock()
	ELSE
		Reclock("ZAB",.F.)
		ZAB->ZAB_NOME	:= TMPBV->E2_NOMFOR
		ZAB->ZAB_EMISSA := STOD(TMPBV->E2_EMISSAO)    
		ZAB->ZAB_VENCTO := STOD(TMPBV->E2_VENCREA)
		ZAB->ZAB_BAIXA 	:= STOD(TMPBV->E2_BAIXA)		
		ZAB->ZAB_NATURE := TMPBV->E2_NATUREZ
		ZAB->ZAB_OBS    := TMPBV->E2_HIST
		ZAB->ZAB_VLSE2	:= TMPBV->E2_VALOR		
		MsUnlock()
	END
	
	dbSelectArea("TMPBV")
	dbSkip()
	
EndDo

dbSelectArea("TMPBV")
dbCloseArea("TMPBV")   

Close(oDlg)

RETURN
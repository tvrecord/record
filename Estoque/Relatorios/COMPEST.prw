#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMPEST º Autor ³ Bruno Alves       º Data ³    09/04/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Planilha para informar quais produtos deverão ser comprados ±
±±          ±± periodicamente											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMPEST()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Pedido de Compra - Consumo Medio"
Local nLin           := 100

Local Cabec1         := ""
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "COMPEST" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "COMPEST" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "COMPEST7"
Private cString      := "SD3"
Private cQuery       := ""
Private aCons1		 := {}
Private aCons2		 := {}
Private aCons3		 := {}
Private aCons4		 := {}
Private aEnt1		 := {}
Private aEnt2		 := {}
Private aEnt3		 := {}
Private aEnt4		 := {}
Private nRec1		 := 0
Private nRec2		 := 0
Private nRec3		 := 0
Private nRec4		 := 0
Private nRec5		 := 0
Private nRec6		 := 0
Private nRec7		 := 0
Private nRec8		 := 0
Private aSaldos		 := {}
Private _aIExcel 	 := {}


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| _GeraEnt1()},"Gerando 1º Entrada")
Processa({|| _GeraEnt2()},"Gerando 2º Entrada")
Processa({|| _GeraEnt3()},"Gerando 3º Entrada")
Processa({|| _GeraEnt4()},"Gerando 4º Entrada (Informativo)")

Processa({|| _GeraCons1()},"Gerando 1º Consumação")
Processa({|| _GeraCons2()},"Gerando 2º Consumação")
Processa({|| _GeraCons3()},"Gerando 3º Consumação")
Processa({|| _GeraCons4()},"Gerando 4º Entrada (Informativo)")


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

//1º Entrada

Static Function _GeraEnt1()

cQuery := "SELECT D1_COD,D1_DESCRI,SUM(D1_QUANT) AS QUANTIDADE,B1_LOCPAD FROM SD1010 "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "D1_TES = F4_CODIGO "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "D1_COD = B1_COD "
cQuery += "WHERE "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR05) + "' AND '"  + DTOS(MV_PAR06) + "' AND "
cQuery += "F4_ESTOQUE = 'S' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SF4010.D_E_L_E_T_ <> '*'  "
cQuery += "GROUP BY D1_COD,D1_DESCRI,B1_LOCPAD "
cQuery += "ORDER BY D1_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec1

DBSelectArea("TMP")
DBGotop()

procregua(nRec1)

While !EOF()
	
	IncProc("Gerando 1º Entrada:")
	
	aAdd(aEnt1,{	TMP->D1_COD,;     //01.Codigo do Produto
	TMP->D1_DESCRI,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->B1_LOCPAD})		//04.Mes da compra
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------

// 2º Entrada

Static Function _GeraEnt2

cQuery := "SELECT D1_COD,D1_DESCRI,SUM(D1_QUANT) AS QUANTIDADE,B1_LOCPAD FROM SD1010 "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "D1_TES = F4_CODIGO "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "D1_COD = B1_COD "
cQuery += "WHERE "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR03) + "' AND '"  + DTOS(MV_PAR04) + "' AND "
cQuery += "F4_ESTOQUE = 'S' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SF4010.D_E_L_E_T_ <> '*'  "
cQuery += "GROUP BY D1_COD,D1_DESCRI,B1_LOCPAD "
cQuery += "ORDER BY D1_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec2

DBSelectArea("TMP")
DBGotop()

procregua(nRec2)

While !EOF()
	
	IncProc("Gerando 2º Entrada:")
	
	aAdd(aEnt2,{	TMP->D1_COD,;     //01.Codigo do Produto
	TMP->D1_DESCRI,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->B1_LOCPAD})		//04.Mes da compra
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------

// 3º Entrada

Static Function _GeraEnt3

cQuery := "SELECT D1_COD,D1_DESCRI,SUM(D1_QUANT) AS QUANTIDADE,B1_LOCPAD FROM SD1010 "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "D1_TES = F4_CODIGO "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "D1_COD = B1_COD "
cQuery += "WHERE "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR01) + "' AND '"  + DTOS(MV_PAR02) + "' AND "
cQuery += "F4_ESTOQUE = 'S' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SF4010.D_E_L_E_T_ <> '*'  "
cQuery += "GROUP BY D1_COD,D1_DESCRI,B1_LOCPAD "
cQuery += "ORDER BY D1_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec3

DBSelectArea("TMP")
DBGotop()

procregua(nRec3)

While !EOF()
	
	IncProc("Gerando 3º Entrada:")
	
	aAdd(aEnt3,{	TMP->D1_COD,;     //01.Codigo do Produto
	TMP->D1_DESCRI,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->B1_LOCPAD})		//04.Mes da compra
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return


// 4º Entrada (INFORMATIVA) Rafael França colocado a pedido da Sra. Elenn (20/11/13)

Static Function _GeraEnt4

cQuery := "SELECT D1_COD,D1_DESCRI,SUM(D1_QUANT) AS QUANTIDADE,B1_LOCPAD FROM SD1010 "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "D1_TES = F4_CODIGO "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "D1_COD = B1_COD "
cQuery += "WHERE "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR07) + "' AND '"  + DTOS(MV_PAR08) + "' AND "
cQuery += "F4_ESTOQUE = 'S' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SF4010.D_E_L_E_T_ <> '*'  "
cQuery += "GROUP BY D1_COD,D1_DESCRI,B1_LOCPAD "
cQuery += "ORDER BY D1_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec7

DBSelectArea("TMP")
DBGotop()

procregua(nRec7)

While !EOF()
	
	IncProc("Gerando 4º Entrada:")
	
	aAdd(aEnt4,{	TMP->D1_COD,;     //01.Codigo do Produto
	TMP->D1_DESCRI,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->B1_LOCPAD})		//04.Mes da compra
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Quantidade de Produtos que foram consumidos no periodo informado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ
*/

// 1º Consumação

Static Function _GeraCons1

cQuery := "SELECT D3_COD,B1_DESC,BM_GRUPO,B1_LOCPAD,BM_DESC,SUM(D3_QUANT) AS QUANTIDADE FROM SD3010 "
cQuery += "INNER JOIN SF5010 ON "
cQuery += "F5_CODIGO = D3_TM "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = D3_COD "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = B1_GRUPO "
cQuery += "WHERE "
cQuery += "F5_TIPO = 'R' AND "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D3_EMISSAO BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "'  AND "
cQuery += "D3_ESTORNO = '' AND "
cQuery += "SF5010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SBM010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D3_COD,B1_DESC,B1_LOCPAD,BM_GRUPO,BM_DESC "
cQuery += "ORDER BY BM_GRUPO,D3_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec4

DBSelectArea("TMP")
DBGotop()

procregua(nRec4)

While !EOF()
	
	IncProc("Gerando 1º Consumação:")
	
	aAdd(aCons1,{	TMP->D3_COD,;     //01.Codigo do Produto
	TMP->B1_DESC,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->BM_GRUPO,;      //04
	TMP->BM_DESC,;        //05
	TMP->B1_LOCPAD})		//06
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
// 2º Consumação

Static Function _GeraCons2

cQuery := "SELECT D3_COD,B1_DESC,BM_GRUPO,BM_DESC,B1_LOCPAD,SUM(D3_QUANT) AS QUANTIDADE FROM SD3010 "
cQuery += "INNER JOIN SF5010 ON "
cQuery += "F5_CODIGO = D3_TM "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = D3_COD "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = B1_GRUPO "
cQuery += "WHERE "
cQuery += "F5_TIPO = 'R' AND "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "'  AND "
cQuery += "D3_ESTORNO = '' AND "
cQuery += "SF5010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SBM010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D3_COD,B1_DESC,B1_LOCPAD,BM_GRUPO,BM_DESC "
cQuery += "ORDER BY BM_GRUPO,D3_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec5

DBSelectArea("TMP")
DBGotop()

procregua(nRec5)

While !EOF()
	
	IncProc("Gerando 2º Consumação:")
	
	aAdd(aCons2,{	TMP->D3_COD,;     //01.Codigo do Produto
	TMP->B1_DESC,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->BM_GRUPO,;
	TMP->BM_DESC,;
	TMP->B1_LOCPAD})
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
// 3º Consumação

Static Function _GeraCons3

cQuery := "SELECT D3_COD,B1_DESC,BM_GRUPO,BM_DESC,B1_LOCPAD,SUM(D3_QUANT) AS QUANTIDADE FROM SD3010 "
cQuery += "INNER JOIN SF5010 ON "
cQuery += "F5_CODIGO = D3_TM "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = D3_COD "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = B1_GRUPO "
cQuery += "WHERE "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "F5_TIPO = 'R' AND "
cQuery += "D3_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'  AND "
cQuery += "D3_ESTORNO = '' AND "
cQuery += "SF5010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SBM010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D3_COD,B1_DESC,B1_LOCPAD,BM_GRUPO,BM_DESC "
cQuery += "ORDER BY BM_GRUPO,D3_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec6

DBSelectArea("TMP")
DBGotop()

procregua(nRec6)

While !EOF()
	
	IncProc("Gerando 3º Consumação:")
	
	aAdd(aCons3,{	TMP->D3_COD,;     //01.Codigo do Produto
	TMP->B1_DESC,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->BM_GRUPO,;   // 04 Grupo
	TMP->BM_DESC,;
	TMP->B1_LOCPAD})		//05.Descrição Grupo
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return


// 1º Consumação

Static Function _GeraCons4

cQuery := "SELECT D3_COD,B1_DESC,BM_GRUPO,B1_LOCPAD,BM_DESC,SUM(D3_QUANT) AS QUANTIDADE FROM SD3010 "
cQuery += "INNER JOIN SF5010 ON "
cQuery += "F5_CODIGO = D3_TM "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = D3_COD "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = B1_GRUPO "
cQuery += "WHERE "
cQuery += "F5_TIPO = 'R' AND "
cQuery += "B1_LOCPAD BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "'  AND "
cQuery += "B1_COD BETWEEN '" + (MV_PAR13) + "' AND '" + (MV_PAR14) + "'  AND "
cQuery += "D3_EMISSAO BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "'  AND "
cQuery += "D3_ESTORNO = '' AND "
cQuery += "SF5010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SBM010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D3_COD,B1_DESC,B1_LOCPAD,BM_GRUPO,BM_DESC "
cQuery += "ORDER BY BM_GRUPO,D3_COD "

tcQuery cQuery New Alias "TMP"

COUNT TO nRec8

DBSelectArea("TMP")
DBGotop()

procregua(nRec8)

While !EOF()
	
	IncProc("Gerando 4º Consumação:")
	
	aAdd(aCons4,{	TMP->D3_COD,;     //01.Codigo do Produto
	TMP->B1_DESC,;    	//02.Descrição do Produto
	TMP->QUANTIDADE,;  	//03.Quantidade comprada
	TMP->BM_GRUPO,;      //04
	TMP->BM_DESC,;        //05
	TMP->B1_LOCPAD})		//06
	
	DBSkip()
	
EndDo

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cGrupo := ""
Local N2 := 0
Local N3 := 0
Local N4 := 0
Local C1 := 0
Local C2 := 0
Local C3 := 0
Local C4 := 0


//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


// **************************** Cria Arquivo Temporario
_aCExcel:={}//SPCSQL->(DbStruct())
aadd( _aCExcel , {"LOCAL"		, "C" , 07 , 00 } ) //01
aadd( _aCExcel , {"CODIGO"     	, "C" , 10 , 00 } ) //02
aadd( _aCExcel , {"DESC" 		, "C" , 50 , 00 } ) //03
aadd( _aCExcel , {"SALDOINI"	, "C" , 15 , 00 } ) //04
aadd( _aCExcel , {"COMPRA1" 	, "C" , 18 , 00 } ) //05
aadd( _aCExcel , {"CONSUMO1"	, "C" , 25 , 00 } ) //06
aadd( _aCExcel , {"SALDO1"		, "C" , 15 , 00 } ) //07
aadd( _aCExcel , {"COMPRA2" 	, "C" , 18 , 00 } ) //08
aadd( _aCExcel , {"CONSUMO2"	, "C" , 25 , 00 } ) //09
aadd( _aCExcel , {"SALDO2"		, "C" , 15 , 00 } ) //10
aadd( _aCExcel , {"COMPRA3" 	, "C" , 18 , 00 } ) //11
aadd( _aCExcel , {"CONSUMO3" 	, "C" , 25 , 00 } ) //12
aadd( _aCExcel , {"SALDO3"		, "C" , 15 , 00 } ) //13
aadd( _aCExcel , {"COMPRA4" 	, "C" , 18 , 00 } ) //14
aadd( _aCExcel , {"CONSUMO4" 	, "C" , 25 , 00 } ) //15
aadd( _aCExcel , {"SALDO4"		, "C" , 15 , 00 } ) //16
aadd( _aCExcel , {"MEDCOMPRA"	, "C" , 18 , 00 } ) //17
aadd( _aCExcel , {"MEDCONSUMO"	, "C" , 18 , 00 } ) //18
aadd( _aCExcel , {"MARGEM"		, "C" , 18 , 00 } ) //19
aadd( _aCExcel , {"MEDMARGEM"	, "C" , 31 , 00 } ) //20
aadd( _aCExcel , {"APROVADO"	, "C" , 15 , 00 } ) //21

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

	_aItem := ARRAY(LEN(_aCExcel) + 1)
_aItem[01]		:= "LOCAL"
_aItem[02]		:= "PRODUTO"
_aItem[03]		:= "DESCRICAO"
_aItem[04]		:= DTOC(MV_PAR01)
_aItem[05]		:= MES(MV_PAR02) + " / " + cValToChar(YEAR(MV_PAR02))
_aItem[06]		:= DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)
_aItem[07]		:= DTOC(MV_PAR02)
_aItem[08]		:= MES(MV_PAR04) + " / " + cValToChar(YEAR(MV_PAR04))
_aItem[09] 		:= DTOC(MV_PAR03) + " a " + DTOC(MV_PAR04)
_aItem[10]		:= DTOC(MV_PAR04)
_aItem[11]		:= MES(MV_PAR06) + " / " + cValToChar(YEAR(MV_PAR06))
_aItem[12]		:= DTOC(MV_PAR05) + " a " + DTOC(MV_PAR06)
_aItem[13]		:= DTOC(MV_PAR06)
_aItem[14]		:= MES(MV_PAR08) + " / " + cValToChar(YEAR(MV_PAR08))
_aItem[15]		:= DTOC(MV_PAR07) + " a " + DTOC(MV_PAR08)
_aItem[16]		:= DTOC(MV_PAR08)
_aItem[17]		:= "COMPRA (MEDIA)"
_aItem[18]		:= "CONSUMO (MEDIA)"
_aItem[19]		:= "MARGEM(" + cValtoChar(MV_PAR12) + "%)"
_aItem[20]		:= "CONSUMO + MARGEM(" + cValtoChar(MV_PAR12) + "%) - ESTOQUE"

	AADD(_aIExcel,_aItem)
	_aItem := {}

If MV_PAR11 == 1
	
	For I := 1 to Len(aCons1)
		
		N4 := aScan(aCons4, { |x| x[01] == aCons1[I][1] } )
		N3 := aScan(aCons3, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
		N2 := aScan(aCons2, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
		
		
		If N2 != 0 .AND. N3 != 0 // Será impresso caso o produto já esteja consumido os tres periodos informados nos parametros, caso contrario precisará realizar controle manual até ser consumido os periodos informados
			
			IF (aCons1[I][4] != cGrupo)
				
				// Pular Linha
					_aItem := ARRAY(LEN(_aCExcel) + 1)
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
					_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[02] 		:= aCons1[I][4]
				_aItem[03] 		:= aCons1[I][5]
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
				//Pular Linha
					_aItem := ARRAY(LEN(_aCExcel) + 1)
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
			Endif
			
			C1 := aScan(aEnt1, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C2 := aScan(aEnt2, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C3 := aScan(aEnt3, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C4 := aScan(aEnt4, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			
			aSaldos:={CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR01),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR02 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR04 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR06 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR08 + 1)}
			
				_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= aCons1[I][6]
			_aItem[02]		:= aCons1[I][1]
			_aItem[03]		:= aCons1[I][2]
			_aItem[04]		:= cValToChar(aSaldos[1][1])
			_aItem[05] 		:= 	IIf(C3 == 0,cValToChar(0),cValtoChar(aEnt3[C3][3]))
			_aItem[06] 		:= cValtoChar(aCons3[N3][3])
			_aItem[07]		:= cValToChar(aSaldos[2][1])
			_aItem[08] 		:= 	IIf(C2 == 0,cValToChar(0),cValtoChar(aEnt2[C2][3]))
			_aItem[09] 		:= cValtoChar(aCons2[N2][3])
			_aItem[10]		:= cValToChar(aSaldos[3][1])
			_aItem[11]		:= 	IIf(C1 == 0,cValToChar(0),cValtoChar(aEnt1[C1][3]))
			_aItem[12]		:= cValtoChar(aCons1[I][3])
			_aItem[13]		:= cValToChar(aSaldos[4][1])
			_aItem[14]		:= 	IIf(C4 == 0,cValToChar(0),cValtoChar(aEnt4[C4][3]))
			_aItem[15]		:= cValtoChar(aCons4[I][3])
			//			TMP1->SALDO4	:= cValtoChar(Posicione("SB2",1,xFilial("SB2") + aCons1[I][1] + aCons1[I][6],"B2_QATU"))
			_aItem[16]		:= cValToChar(aSaldos[5][1])
			If 	   C2 != 0 .AND. C1 != 0  .AND. C3 == 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt2[C2][3] + aEnt1[C1][3]) / 2),0))
			ELSEIF C3 != 0 .AND. C1 != 0  .AND. C2 == 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt3[C3][3] + aEnt1[C1][3]) / 2),0))
			ELSEIF C2 != 0 .AND. C3 != 0  .AND. C1 == 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt3[C3][3] + aEnt2[C2][3]) / 2),0))
			ELSEIF C1 != 0 .AND. C2 != 0 .AND. C3 != 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt3[C3][3] + aEnt2[C2][3] + aEnt1[C1][3]) / 3),0))
			ELSEIF C2 != 0 .AND. C1 == 0  .AND. C3 == 0
				_aItem[17]		:= cValtoChar(aEnt2[C2][3])
			ELSEIF C3 != 0 .AND. C1 == 0  .AND. C2 == 0
				_aItem[17]		:= cValtoChar(aEnt3[C3][3])
			ELSEIF C1 != 0 .AND. C2 == 0 .AND. C3 == 0
				_aItem[17]		:= cValtoChar(aEnt1[C1][3])
			EndIf
			_aItem[18]		:= cValtoChar(ROUND(((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3),0))
			_aItem[19]   	:= cValtoChar(ROUND((((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) * (MV_PAR12/100)),0))
			_aItem[20]		:= cValtoChar(((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) + (((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) * (MV_PAR12/100)) - (aSaldos[5][1]))
			IF VAL(_aItem[20]) < 0
				_aItem[20]		:= "0"
			ELSEIF AT(".",_aItem[20]) > 0
				_aItem[02]		:= cValToChar(VAL(SUBSTR(_aItem[20],1,(AT(".",_aItem[20]) - 1))) + 1)
			Endif
			
				AADD(_aIExcel,_aItem)
	_aItem := {}
			
			
		EndIf
		
		cGrupo := aCons1[I][4]
		
		
	Next
	
ELSE
	
	For I := 1 to Len(aCons1)
		
		N4 := aScan(aCons4, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
		N3 := aScan(aCons3, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
		N2 := aScan(aCons2, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
		
		
		If N2 != 0 .OR. N3 != 0 // Será impresso caso o produto já esteja consumido os tres periodos informados nos parametros, caso contrario precisará realizar controle manual até ser consumido os periodos informados
			
			IF (aCons1[I][4] != cGrupo)
				
				// Pular Linha
					_aItem := ARRAY(LEN(_aCExcel) + 1)
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
					_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[02] 	:= aCons1[I][4]
				_aItem[03]	:= aCons1[I][5]
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
				//Pular Linha
					_aItem := ARRAY(LEN(_aCExcel) + 1)
					AADD(_aIExcel,_aItem)
	_aItem := {}
				
			Endif
			
			C1 := aScan(aEnt1, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C2 := aScan(aEnt2, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C3 := aScan(aEnt3, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			C4 := aScan(aEnt4, { |x| x[01] == aCons1[I][1] } )// Localiza o mesmo produto em outra consumação para impressao
			
			aSaldos:={CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR01),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR02 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR04 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR06 + 1),;
			CalcEst(PADL(aCons1[I][1],15),aCons1[I][6],MV_PAR08 + 1)}
			
				_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= aCons1[I][6]
			_aItem[02]		:= aCons1[I][1]
			_aItem[03]		:= aCons1[I][2]
			_aItem[04]		:= cValToChar(aSaldos[1][1])
			_aItem[05]		:= IIf(C3 == 0,cValToChar(0),cValtoChar(aEnt3[C3][3]))
			_aItem[06]		:= iiF(N3==0,cValToChar(0),cValtoChar(aCons3[N3][3]))
			_aItem[07]		:= cValToChar(aSaldos[2][1])
			_aItem[08]		:= IIf(C2 == 0,cValToChar(0),cValtoChar(aEnt2[C2][3]))
			_aItem[09]		:= IIF(N2==0,cValToChar(0),cValtoChar(aCons2[N2][3]))
			_aItem[10]		:= cValToChar(aSaldos[3][1])
			_aItem[11]		:= IIf(C1 == 0,cValToChar(0),cValtoChar(aEnt1[C1][3]))
			_aItem[12]		:= cValtoChar(aCons1[I][3])
			_aItem[13]		:= cValToChar(aSaldos[4][1])
			_aItem[14]		:= IIf(C4 == 0,cValToChar(0),cValtoChar(aEnt4[C4][3]))
			_aItem[15]		:= IIF(N4==0,cValToChar(0),cValtoChar(aCons4[N4][3]))
			_aItem[16]		:= cValToChar(aSaldos[5][1])
			If 	   C2 != 0 .AND. C1 != 0 .AND. C3 == 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt2[C2][3] + aEnt1[C1][3]) / 2),0))
			ELSEIF C3 != 0 .AND. C1 != 0 .AND. C2 == 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt3[C3][3] + aEnt1[C1][3]) / 2),0))
			ELSEIF C2 != 0 .AND. C3 != 0 .AND. C1 == 0
				_aItem[17]	:= cValtoChar(ROUND(((aEnt2[C2][3] + aEnt3[C3][3]) / 2),0))
			ELSEIF C1 != 0 .AND. C2 != 0 .AND. C3 != 0
				_aItem[17]		:= cValtoChar(ROUND(((aEnt3[C3][3] + aEnt2[C2][3] + aEnt1[C1][3]) / 3),0))
			ELSEIF C2 != 0 .AND. C1 == 0  .AND. C3 == 0
				_aItem[17]		:= cValtoChar(aEnt2[C2][3])
			ELSEIF C3 != 0 .AND. C1 == 0  .AND. C2 == 0
				_aItem[17]	:= cValtoChar(aEnt3[C3][3])
			ELSEIF C1 != 0 .AND. C2 == 0 .AND. C3 == 0
				_aItem[17]	:= cValtoChar(aEnt1[C1][3])
			EndIf
			If     N2 == 0
				_aItem[18]	:= cValtoChar(ROUND((iiF(N2==0,((aCons3[N3][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0))
				_aItem[19]	:= cValtoChar(ROUND((ROUND((iiF(N2==0,((aCons3[N3][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0)) * (MV_PAR12/100),0))
			ELSEif  N3== 0
				_aItem[18]	:= cValtoChar(ROUND((iiF(N3==0,((aCons2[N2][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0))
				_aItem[19]	:= cValtoChar(ROUND((ROUND((iiF(N3==0,((aCons2[N2][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0)) * (MV_PAR12/100),0))
			ELSEIF N2 != 0 .AND. N3 != 0
				_aItem[18]	:= cValtoChar(ROUND((iiF(N3==0,((aCons2[N2][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0))
				_aItem[19]	:= cValtoChar(ROUND((ROUND((iiF(N3==0,((aCons2[N2][3] + aCons1[I][3])/2),(aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3)),0)) * (MV_PAR12/100),0))
			EndIf
			
			If N3 == 0
				_aItem[20]		:= cValToChar(IIF(N3==0,((aCons1[I][3] + aCons2[N2][3]) / 2) + (((aCons1[I][3] + aCons2[N2][3]) / 2) * (MV_PAR12/100)) - (aSaldos[5][1]),((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3])/3) + (((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) * (MV_PAR12/100)) - (aSaldos[5][1])))
			ELSEIF N2 == 0
				_aItem[20]		:= cValToChar(IIF(N2==0,((aCons1[I][3] + aCons3[N3][3]) / 2) + (((aCons1[I][3] + aCons3[N3][3]) / 2) * (MV_PAR12/100)) - (aSaldos[5][1]),((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3])/3) + (((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) * (MV_PAR12/100)) - (aSaldos[5][1])))
			ELSEIF N2 != 0 .AND. N3 != 0
				_aItem[20]		:= cValToChar(IIF(N2==0,((aCons1[I][3] + aCons3[N3][3]) / 2) + (((aCons1[I][3] + aCons3[N3][3]) / 2) * (MV_PAR12/100)) - (aSaldos[5][1]),((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3])/3) + (((aCons3[N3][3] + aCons2[N2][3] + aCons1[I][3]) / 3) * (MV_PAR12/100)) - (aSaldos[5][1])))
			EndIf
			
			IF VAL(_aItem[20]) < 0
				_aItem[20]		:= "0"
			ELSEIF AT(".",_aItem[20]) > 0
				_aItem[20]		:= cValToChar(VAL(SUBSTR(_aItem[20],1,(AT(".",_aItem[20]) - 1))) + 1)
			Endif
				AADD(_aIExcel,_aItem)
	_aItem := {}			
		EndIf
		
		cGrupo := aCons1[I][4]
	
	Next
	
EndIf

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf    

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Planilha de compras - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","COMPEST")
	_lRet := .F.
ENDIF

//cArq     := _cTemp+".DBF"

//DBSelectArea("TMP1")
//DBCloseARea("TMP1")


//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)


Return




Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Da  Data 1:	 	  ","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Data 1:	  	  ","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Data 2:	  	  ","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data 2:	  	  ","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Data 3:	  	  ","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Data 3:	  	  ","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da  Data 4 (Info):","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Data 4 (Info):","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do  Armazem:	  ","","","mv_ch09","C",02,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate Armazem:	  ","","","mv_ch10","C",02,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Cons. 3 Periodo:  ","","","mv_ch11","N",01,0,2,"C","","MV_PAR11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Margem de Seg (%):","","","mv_ch12","N",05,2,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Do  Produto:	  ","","","mv_ch13","C",15,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"14","Ate Produto:	  ","","","mv_ch14","C",15,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
AADD(aRegs,{cPerg,"15","Dt. Referencia:	  ","","","mv_ch15","D",08,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
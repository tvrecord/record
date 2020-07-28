#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Permuta    º Autor ³ Bruno Alves        º Data ³  13/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Demostra todas as notas vinculadas aos contratos de        º±±
±±º          ³ Permuta                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Permuta


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := "  Emissao    Prf Doc         Pedido   Cod.   Lj   Fornecedor                                  Valor( + Despesa + Frete - Desconto)"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "PERMUTA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	:= "PERMUTA2"

Private cString := "SC3"

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo       := "Documento de Entrada x Contrato - Permuta  Período: " + DTOC(MV_PAR05) + " a " + DTOC(MV_PAR06) + ""

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

cQuery := "SELECT D1_SERIE,D1_DOC,D1_EMISSAO,D1_PEDIDO,D1_FORNECE,D1_LOJA,A2_NOME,(SUM(D1_TOTAL) + SUM(D1_VALFRE) + SUM(D1_DESPESA) - SUM(D1_VALDESC)) AS VALOR,D1_PERMUTA,D1_ITEMPER,C3_VL,C3_OBS,C3_TOTAL,
cQuery += "C3_FORNECE, C3_LOJA, (SELECT A2_NOME FROM SA2010 WHERE A2_COD = C3_FORNECE AND A2_LOJA = C3_LOJA AND D_E_L_E_T_ <> '*') AS FORNECEDOR FROM SD1010 "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "D1_FORNECE = A2_COD AND "
cQuery += "D1_LOJA = A2_LOJA "
cQuery += "INNER JOIN SC3010 ON "
cQuery += "D1_PERMUTA = C3_NUM AND "
cQuery += "D1_ITEMPER = C3_ITEM "
cQuery += "WHERE "
cQuery += "D1_PERMUTA <> '' AND "
cQuery += "D1_FILIAL = '01' AND "
cQuery += "D1_ITEMPER <> '' AND "
cQuery += "D1_SERIE BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "D1_DOC BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery += "D1_EMISSAO BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' AND "
cQuery += "D1_PERMUTA BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery += "D1_ITEMPER BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' AND "
cQuery += "D1_FORNECE BETWEEN '" + (MV_PAR11) + "' AND '" + (MV_PAR12) + "' AND "
cQuery += "SD1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SC3010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY D1_SERIE,D1_DOC,D1_EMISSAO,D1_PEDIDO,D1_FORNECE,D1_LOJA,D1_PERMUTA,D1_ITEMPER,A2_NOME,C3_VL,C3_OBS,C3_TOTAL,C3_FORNECE, C3_LOJA "
cQuery += "ORDER BY D1_PERMUTA,D1_ITEMPER,D1_EMISSAO "



tcQuery cQuery New Alias "TMP"


If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  29/05/12   º±±
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

Local nOrdem
Local cContrato := ""
Local cItem := ""
Local nTot := 0
Local nValCont := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()

DbSelectArea("TMP")

While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 57 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	If cContrato != TMP->D1_PERMUTA .AND. cItem != TMP->D1_ITEMPER // Imprime titulo de cada contrato
		@nLin,001 PSAY 	"Código: " + TMP->C3_FORNECE + "   Loja: " + TMP->C3_LOJA + " Fornecedor: " + TMP->FORNECEDOR + ""
		nLin++
		@nLin,001 PSAY 	"Periodo do Contrato: " + DTOC(Posicione("SC3",1,xFilial("SC3") + ALLTRIM(TMP->D1_PERMUTA) + ALLTRIM(TMP->D1_ITEMPER),"C3_DATPRI")) + " a " + DTOC(Posicione("SC3",1,xFilial("SC3") + ALLTRIM(TMP->D1_PERMUTA) + ALLTRIM(TMP->D1_ITEMPER),"C3_DATPRF")) + "    -    Valor Atual: " + Transform( TMP->C3_TOTAL , "@e 99,999,999.99" ) + "     Valor Original: " + Transform( TMP->C3_VL , "@e 99,999,999.99" ) + ""
		nLin++
		@nLin,001 PSAY 	"Contrato: " + TMP->D1_PERMUTA + " Item: " + TMP->D1_ITEMPER + " - " + TMP->C3_OBS + ""
		nLin+= 2
		
	EndIf
	
	
	@nLin,001 PSAY STOD(TMP->D1_EMISSAO)
	@nLin,013 PSAY TMP->D1_SERIE
	@nLin,017 PSAY TMP->D1_DOC
	@nLin,029 PSAY TMP->D1_PEDIDO
	@nLin,037 PSAY TMP->D1_FORNECE
	@nLin,045 PSAY TMP->D1_LOJA
	@nLin,049 PSAY TMP->A2_NOME
	@nLin,100 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
	
	
	
	cContrato := TMP->D1_PERMUTA
	cItem := TMP->D1_ITEMPER
	nTot += TMP->VALOR
	nValCont := TMP->C3_VL
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	nLin++
	
	
	If cContrato != TMP->D1_PERMUTA .AND. cItem != TMP->D1_ITEMPER // Imprime Totalizador de cada contrato após impressao de todas as notas vinculadas
		@nLin,089 PSAY "TOTAL: "
		@nLin,100 PSAY nTot PICTURE "@E 999,999,999.99"
		nLin++
		@nLin,089 PSAY "DIFERENÇA: "
		@nLin,100 PSAY nValCont - nTot PICTURE "@E 999,999,999.99"
		
		nLin += 2
		
		@nLin,01 PSAY "---------------------------------------------------------------------------------------------------------------------------------"
		
		nLin += 2
		
		nTot := 0
		
		
	EndIf
	
	
	
	
EndDo





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

DBSelectArea("TMP")
DBCloseArea("TMP")

MS_FLUSH()

Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Serie?","","","mv_ch01","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Serie?","","","mv_ch02","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do  Documento?","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SD1"})
AADD(aRegs,{cPerg,"04","Ate Documento?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SD1"})
AADD(aRegs,{cPerg,"05","Da  Emissao ?","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Emissao ?","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Do  Contrato?","","","mv_ch07","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SC3PER"})
AADD(aRegs,{cPerg,"08","Ate Contrato?","","","mv_ch08","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SC3PER"})
AADD(aRegs,{cPerg,"09","Do  Item?","","","mv_ch09","C",04,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ate Item?","","","mv_ch10","C",04,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Do  Fornecedor?","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"12","Ate Fornecedor?","","","mv_ch12","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})

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

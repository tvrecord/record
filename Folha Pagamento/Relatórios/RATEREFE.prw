#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RATEREF   º Autor ³ Bruno Alves        º Data ³ 06/04/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualiza o valor e a porcentagem pago de vale de refeicao º±±
±±          ±±  por centro de custo   									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RATEREFE

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Rateio por Centro de Custo de Vale Refeicao"
Local nLin           := 100
Local cTpVal		 := ""
Local Cabec1         := "C.Custo    Descrição                                     Valor           Rateio"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "RATEREFE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RATEREFE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RATEREFE26"
Private cString      := "SRC"
Private cQuery       := ""
Private nPerc		 := 0
Private	nPercTot 	 := 0
Private	nValTot 	 := 0
Private nTot		 := 0
Private lOk 		 := .T.
Private cPath		 := ""
Private nArq 		 := 0 
Private cCusto		 := ""
Private cDescri		 := ""

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR08 == 1
	titulo       	 := "Rateio por Centro de Custo de Vale Refeicao"
ELSEIF MV_PAR08 == 2
	titulo       	 := "Rateio por Centro de Custo de Vale Alimentação"
ELSEIF MV_PAR08 == 3
	titulo       	 := "Rateio por Centro de Custo de Cesta Alimentação"
ELSEIF MV_PAR08 == 4
	titulo       	 := "Rateio por Centro de Custo Alimentação"
EndIf

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

//Imprimir relatorio com dados Financeiros ou de Clientes

cQuery := "SELECT ZO_CC,ZO_NOMECC,SUM(ZO_VALOR) AS VALOR FROM SZO010 WHERE "
cQuery += "ZO_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "ZO_MES = '" + (MV_PAR02) + "' AND "
cQuery += "ZO_ANO = '" + (MV_PAR03) + "' AND "
cQuery += "ZO_MAT BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
cQuery += "ZO_CC BETWEEN '" + (MV_PAR06) + "' AND '" + (MV_PAR07) + "' AND "
If MV_PAR08 != 4
	cQuery += "ZO_TPREF = '" + ALLTRIM(cValToChar(MV_PAR08)) + "' AND "
EndIf
cQuery += "D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY ZO_CC,ZO_NOMECC "
cQuery += "ORDER BY ZO_CC "


tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
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

IF MV_PAR10 == 1
	
	DBSelectArea("TMP")
	DBGotop()
	
	While !EOF()
		nTot += TMP->VALOR
		dbSkip()
	Enddo
	
	DBSelectArea("TMP")
	DBGotop()
	
	
	While !EOF()
		
		SetRegua(RecCount())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		
		nPerc := (TMP->VALOR * 100)/nTot
		
		@nLin, 000 PSAY TMP->ZO_CC
		@nLin, 011 PSAY TMP->ZO_NOMECC
		@nLin, 051 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
		@nLin, 073 PSAY ROUND(nPerc,2) PICTURE "99.99%"
		
		nPercTot += nPerc
		nValTot += TMP->VALOR
		
		
		dbskip()
		
		nLin 			+= 1 // Avanca a linha de impressao
		
		
	ENDDO
	
	@nLin, 000 PSAY "----------------------------------------------------------------------------------"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 051 PSAY nValTot PICTURE "@E 999,999,999.99"
	@nLin, 073 PSAY ROUND(nPercTot,2) PICTURE "999.99%"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "----------------------------------------------------------------------------------"
	
	
	If !EMPTY(MV_PAR09)
		nLin += 3
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		nLin++
		@nLin, 000 PSAY "Observação: " + ALLTRIM(MV_PAR09)
		nLin++
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
	Endif
	
	
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
	
	MS_FLUSH()
	
	DBSelectArea("TMP")
	DBCloseArea("TMP")
	
	Return
	
ELSE  

Processa({|| RatRefImp() },"Exportando Rateio...")
	
ENDIF
 
Static Function RatRefImp  

If MV_PAR08 == 1
cPath := "C:\RATEIO\VALEREF"
ELSEIF MV_PAR08 == 2
cPath := "C:\RATEIO\VALEALI"
ELSEIF MV_PAR08 == 3
cPath := "C:\RATEIO\CESTAALI"
ELSEIF MV_PAR08 == 4
cPath := "C:\RATEIO\ALIMENTACAO"
EndIf

nArq  := FCreate(cPath + ".CSV")

If nArq == -1 
DBSelectARea("TMP")
DBCloseARea("TMP")
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf
 
	DBSelectArea("TMP")
	DBGotop()
	
	While !EOF()
		nTot += TMP->VALOR
		dbSkip()
	Enddo   
	
FWrite(nArq, "CCUSTO" + ";" + "DESCRICAO" + ";" + "PERCENTUAL" + Chr(13) + Chr(10))	
	
	DBSelectArea("TMP")
	DBGotop()	
	
	While !EOF()		
		                   
		cCusto 		:= TMP->ZO_CC
		cDescri 	:= TMP->ZO_NOMECC
		nPerc 		:= (TMP->VALOR * 100)/nTot
		
		FWrite(nArq, ALLTRIM(cCusto) + ";" + ALLTRIM(cDescri) + ";" + Transform(ROUND(nPerc,2),"@R 99.99") + Chr(13) + Chr(10))
		
		dbskip()		
		
	ENDDO 
	

FClose(nArq)   

DBSelectARea("TMP")
DBCloseARea("TMP")

oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath + ".CSV")
oExcel:SetVisible(.T.)
oExcel:Destroy()

FErase(cPath + ".CSV")	

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Filial 			","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Mes 			","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Ano 			","","","mv_ch03","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Matricula De 	","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"05","Matricula Ate	","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"06","C. Custo De 	","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","C. Custo Ate	","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"08","Tipo 			","","","mv_ch08","N",01,0,2,"C","","mv_par08","Refeicao","","","","","Alimentacao","","","","","Cst Alimentacao","","","","","Ambos","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Observação 		","","","mv_ch09","C",99,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Formato 		","","","mv_ch10","N",01,0,2,"C","","mv_par10","Relatorio","","","","","CSV","","","","","","","","","","","","","","","","","","","","","","",""})

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
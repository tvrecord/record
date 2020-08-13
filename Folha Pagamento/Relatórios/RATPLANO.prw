#include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATEREF   บ Autor ณ Rafael Fran็a     บ Data ณ 19/09/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o valor e a porcentagem pago de vale de refeicao บฑฑ
ฑฑ          ฑฑ  por centro de custo   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RATPLANO

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Rateio por Centro de Custo Planos"
Local nLin           := 100
Local cTpVal		 := ""
Local Cabec1         := "C.Custo    Descri็ใo                                     Valor           Rateio"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "RATPLANO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RATPLANO" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RATPLANO"
Private cString      := "SRA"
Private cQuery       := ""
Private nPerc		 := 0
Private	nPercTot 	 := 0
Private	nValTot 	 := 0
Private nTot		 := 0
Private lOk 		 := .T.
Private cPath		:= ""
Private nArq 		:= 0
Private cCusto		:= ""
Private cDescri		:= ""
Private aDados		:= {}
Private nValMed		:= 0
Private nValODo     := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If MV_PAR08 == 1
	titulo       	 := "Rateio por Centro de Custo Plano de Saude"
ELSEIF MV_PAR08 == 2
	titulo       	 := "Rateio por Centro de Custo Plano Odontologico"
EndIf

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

cQuery := "SELECT RA_FILIAL AS FILIAL, RA_CC AS CC "
cQuery += ",(SELECT CTT_DESC01 FROM CTT010 WHERE CTT010.D_E_L_E_T_ = '' AND CTT_CUSTO = RA_CC AND CTT_FILIAL = RA_FILIAL) AS CCUSTO "
cQuery += ",RA_MAT AS MATRICULA,RA_NOME AS NOME,RA_ADMISSA AS ADMISSAO "

If MV_PAR08 == 1
	cQuery += ",(SELECT SUBSTRING(RCC_CONTEU,35,12) FROM RHK010 INNER JOIN RCC010 ON RHK_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S008' WHERE RHK010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHK_PERFIM = '' AND RHK_TPFORN = '1' AND RHK_CODFOR = '002' AND RHK_MAT = RA_MAT) AS ASSMED "
	cQuery += ",(SELECT COUNT(RCC_FILIAL) + 1 FROM RHL010 INNER JOIN RCC010 ON RHL_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S008' WHERE RHL010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHL_PERFIM = '' AND RHL_TPFORN = '1' AND RHL_CODFOR = '002' AND RHL_MAT = RA_MAT AND RHL_FILIAL = RA_FILIAL GROUP BY RHL_FILIAL) AS QTDMED "
ELSEIF MV_PAR08 == 2
	cQuery += ",(SELECT SUBSTRING(RCC_CONTEU,35,12) FROM RHK010 INNER JOIN RCC010 ON RHK_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S013' WHERE RHK010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHK_PERFIM = '' AND RHK_TPFORN = '2' AND RHK_CODFOR = '003' AND RHK_MAT = RA_MAT) AS ASSODO "
	cQuery += ",(SELECT COUNT(RCC_FILIAL) + 1 FROM RHL010 INNER JOIN RCC010 ON RHL_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S013' WHERE RHL010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHL_PERFIM = '' AND RHL_TPFORN = '2' AND RHL_CODFOR = '003' AND RHL_MAT = RA_MAT AND RHL_FILIAL = RA_FILIAL GROUP BY RHL_FILIAL) AS QTDODO "
EndIf

cQuery += "FROM SRA010 "
cQuery += "WHERE SRA010.D_E_L_E_T_ = '' AND RA_FILIAL = '"+MV_PAR01+"' AND RA_MAT BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery += "AND RA_SITFOLH <> 'D' AND RA_CC BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
cQuery += "ORDER BY RA_FILIAL,RA_CC,RA_MAT "

tcQuery ChangeQuery(cQuery) New Alias "TMPRAT"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMPRAT")
	dbCloseArea("TMPRAT")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMPRAT")
	dbCloseArea("TMPRAT")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DBSelectArea("TMPRAT")
DbGoTop()

While TMPRAT->(!Eof())
	
	IF lOk
		cCusto := TMPRAT->CC
		lOk := .F.
	ENDIF
	
	IF ALLTRIM(TMPRAT->QTDMED) == ALLTRIM(cCusto)
		
		If MV_PAR08 == 1
			
			IF TMPRAT->QTDMED > 0
				nValMed += (VAL(TMPRAT->ASSMED)*TMPRAT->QTDMED)
			ELSE
				nValMed += VAL(TMPRAT->ASSMED)
			ENDIF
			
		ELSE
			
			IF TMPRAT->QTDODO > 0
				nValOdo += (VAL(TMPRAT->ASSODO)*TMPRAT->QTDODO)
			ELSE
				nValOdo += VAL(TMPRAT->ASSODO)
			ENDIF
			
		ENDIF
		
	ELSE
		
		aAdd(aDados,{cCusto,cDescri,(nValMed+nValOdo)})
		
		nTot += nValMed + nValOdo
		
		nValMed := 0
		nValOdo := 0
		
		cCusto := TMPRAT->CC
		cDescri := TMPRAT->CCUSTO
		
	ENDIF
	
	TMPRAT->(DbSkip())
	
Enddo

DBSelectArea("TMPRAT")
DBCloseArea("TMPRAT")

IF MV_PAR10 == 1
	
	
	
	For i:=1 to Len(aDados)
		
		SetRegua(RecCount())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		
		nPerc := (aDados[i][3] * 100)/nTot
		
		@nLin, 000 PSAY aDados[i][1]
		@nLin, 011 PSAY aDados[i][2]
		@nLin, 051 PSAY aDados[i][3]PICTURE "@E 999,999,999.99"
		@nLin, 073 PSAY ROUND(nPerc,2) PICTURE "99.99%"
		
		nPercTot += nPerc
		nValTot += aDados[i][3]
		
		nLin 			+= 1 // Avanca a linha de impressao
		
	Next
	
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
		@nLin, 000 PSAY "Observa็ใo: " + ALLTRIM(MV_PAR09)
		nLin++
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
	Endif
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
ELSE
	
	Processa({|| RatPlano() },"Exportando Rateio...")
	
ENDIF

Return



Static Function RatPlano

If MV_PAR08 == 1
	cPath := "C:\RATEIO\PLASAUDE"
ELSEIF MV_PAR08 == 2
	cPath := "C:\RATEIO\PLAODONTO"
EndIf

nArq  := FCreate(cPath + ".CSV")

If nArq == -1
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf

FWrite(nArq, "CCUSTO" + ";" + "DESCRICAO" + ";" + "PERCENTUAL" + Chr(13) + Chr(10))

For i:=1 to Len(aDados)
	
	cCusto 		:= aDados[i][1]
	cDescri 	:= aDados[i][2]
	nPerc 		:= (aDados[i][3] * 100)/nTot
	
	FWrite(nArq, ALLTRIM(cCusto) + ";" + ALLTRIM(cDescri) + ";" + Transform(ROUND(nPerc,2),"@R 99.99") + Chr(13) + Chr(10))
	
Next


FClose(nArq)

DBSelectARea("TMPRAT")
DBCloseARea("TMPRAT")

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
AADD(aRegs,{cPerg,"08","Tipo 			","","","mv_ch08","N",01,0,2,"C","","mv_par08","Saude","","","","","Odonto","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Observa็ใo 		","","","mv_ch09","C",99,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
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

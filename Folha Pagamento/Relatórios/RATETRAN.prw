#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATETRAN   บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o valor e a porcentagem pago de vale de refeicao บฑฑ
ฑฑ          ฑฑ  por centro de custo   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RATETRAN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Rateio por Centro de Custo"
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
Private nomeprog     := "RATETRAN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RATETRAN" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "TRANSRAT"
Private cString      := "SRC"
Private cQuery       := ""
Private nPerc		 := 0
Private	nPercTot 	 := 0
Private	nValTot 	 := 0
Private nTot		 := 0
Private aSubTot		 := {}
Private lObs 		 := .T.
Private cPath		 := ""
Private nArq 		 := 0 
Private cCusto		 := ""
Private cDescri		 := ""


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)


//Totalizador por Grupo
cQuery := "SELECT RN_GRUPO,RN_DESCGRU,SUM(R0_VALCAL) AS VALOR FROM SR0010 "
cQuery += "INNER JOIN CTT010 ON "
cQuery += "CTT010.CTT_FILIAL = SR0010.R0_FILIAL AND "
cQuery += "CTT010.CTT_CUSTO = SR0010.R0_CC "
cQuery += "INNER JOIN SRA010 ON "
cQuery += "SRA010.RA_FILIAL = SR0010.R0_FILIAL AND "
cQuery += "SRA010.RA_MAT = SR0010.R0_MAT "
cQuery += "INNER JOIN SRN010 ON "
cQuery += "SRN010.RN_COD = SR0010.R0_CODIGO "
cQuery += "WHERE  "
cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
cQuery += "SR0010.R0_FILIAL  =  '" + (MV_PAR01) + "'  AND "
cQuery += "SR0010.R0_MAT BETWEEN '"+ (MV_PAR02) + "' AND '"+ (MV_PAR03) + "' AND "
cQuery += "SR0010.R0_CC BETWEEN '"+ (MV_PAR04) + "' AND '"+ (MV_PAR05) + "' AND " 
IF !EMPTY(MV_PAR08)
cQuery += "SRN010.RN_GRUPO = '"+ (MV_PAR08) + "' AND "
ENDIF
cQuery += "SR0010.R0_VALCAL  <>  0  AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "SR0010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRN010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY RN_GRUPO,RN_DESCGRU "
cQuery += "ORDER BY RN_GRUPO"

tcQuery cQuery New Alias "CONF"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("CONF")
	dbCloseArea("CONF")
	Return
	
else
	
	// Adiciona no vetor os subtotais de todos os grupos
	
	DBSelectArea("CONF")
	DBGotop()
	
	While !EOF()
		
		aAdd(aSubTot,{CONF->RN_GRUPO,;  		// 1 - Grupo
		CONF->RN_DESCGRU,; // 2 - Descricao do Grupo
		CONF->VALOR}) // 3 - Valor Total do Grupo
		
		dbSkip()
		
	Enddo
	
	// Apos soma, fecho a tabela, pois nao vou mais utiliza-la
	dbSelectArea("CONF")
	dbCloseArea("CONF")
	
Endif



//Imprimir relatorio com dados Financeiros ou de Clientes
cQuery := "SELECT RN_GRUPO,RN_DESCGRU,R0_CC,CTT_DESC01,SUM(R0_VALCAL) AS VALOR FROM SR0010 "
cQuery += "INNER JOIN CTT010 ON "
cQuery += "CTT010.CTT_FILIAL = SR0010.R0_FILIAL AND "
cQuery += "CTT010.CTT_CUSTO = SR0010.R0_CC "
cQuery += "INNER JOIN SRA010 ON "
cQuery += "SRA010.RA_FILIAL = SR0010.R0_FILIAL AND "
cQuery += "SRA010.RA_MAT = SR0010.R0_MAT "
cQuery += "INNER JOIN SRN010 ON "
cQuery += "SRN010.RN_COD = SR0010.R0_CODIGO "
cQuery += "WHERE  "
cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
cQuery += "SR0010.R0_FILIAL  =  '" + (MV_PAR01) + "'  AND "
cQuery += "SR0010.R0_MAT BETWEEN '"+ (MV_PAR02) + "' AND '"+ (MV_PAR03) + "' AND "
cQuery += "SR0010.R0_CC BETWEEN '"+ (MV_PAR04) + "' AND '"+ (MV_PAR05) + "' AND "
IF !EMPTY(MV_PAR08)
cQuery += "SRN010.RN_GRUPO = '"+ (MV_PAR08) + "' AND "
ENDIF
cQuery += "SR0010.R0_VALCAL  <>  0  AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "SR0010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRN010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY RN_GRUPO,RN_DESCGRU,R0_CC,CTT_DESC01 "
cQuery += "ORDER BY RN_GRUPO,R0_CC "

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
Local lOk := .T.
Local nPos := 0
Local cGrupo := "" 

IF MV_PAR07 == 1


DBSelectArea("TMP")
DBGotop()


While !EOF()
	
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
	
	
	If lOk == .T.     // Valor total do grupo + impressao do cabecalho por grupo
		
		nPos := Ascan(aSubTot, { |X| X[1] == TMP->RN_GRUPO })
		nTot := aSubTot[nPos][3]
		
		@nLin, 000 PSAY aSubTot[nPos][2]
		nLin++
		@nLin, 000 PSAY "__________________________________________________________________________________"
		
		nLin += 2
		
		lOk := .F.
		
	EndIf
	
	cGrupo := TMP->RN_GRUPO
	
	
	
	nPerc := (TMP->VALOR * 100)/nTot
	
	@nLin, 000 PSAY TMP->R0_CC
	@nLin, 011 PSAY TMP->CTT_DESC01
	@nLin, 051 PSAY TMP->VALOR PICTURE "@E 999,999,999.99"
	@nLin, 073 PSAY nPerc PICTURE "999.99%"
	
	nPercTot += nPerc
	nValTot += TMP->VALOR
	
	
	dbskip()
	
	nLin 			+= 1 // Avanca a linha de impressao
	
	If cGrupo != TMP->RN_GRUPO
		
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 051 PSAY nValTot PICTURE "@E 999,999,999.99"
		@nLin, 073 PSAY nPercTot PICTURE "999.99%"
		nLin 			+= 1 // Avanca a linha de impressao
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		
		If !EMPTY(MV_PAR06)
		nLin := 67		
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		nLin++
		@nLin, 000 PSAY "Observa็ใo: " + ALLTRIM(MV_PAR06)                                      
		nLin++
		@nLin, 000 PSAY "----------------------------------------------------------------------------------"
		Endif
		
		lOk := .T.
		nValTot := 0
		nPercTot := 0
		nLin := 71 // Para pular de pแgina
		
	EndIf	
	
ENDDO

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

DBSelectArea("TMP")
DBCloseArea("TMP") 

Return

ELSE
 
Processa({|| RatTraImp() },"Exportando Rateio...")

ENDIF

Static Function RatTraImp  

cPath := "C:\RATEIO\VALETRANS" + ALLTRIM(MV_PAR08)

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
		nValTot += TMP->VALOR
		dbSkip()
	Enddo   
	
FWrite(nArq, "CCUSTO" + ";" + "DESCRICAO" + ";" + "PERCENTUAL" + Chr(13) + Chr(10))	
	
	DBSelectArea("TMP")
	DBGotop()	
	
	While !EOF()		
		                   
		cCusto 		:= TMP->R0_CC
		cDescri 	:= TMP->CTT_DESC01
		nPerc 		:= (TMP->VALOR * 100)/nValTot
		
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
AADD(aRegs,{cPerg,"01","Filial ?		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Matricula De ?	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Matricula Ate ?	","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","C. Custo De ?	","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"05","C. Custo Ate ?	","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Observa็ใo 		","","","mv_ch06","C",99,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})  
AADD(aRegs,{cPerg,"07","Formato 		","","","mv_ch07","N",01,0,2,"C","","mv_par07","Relatorio","","","","","CSV","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Empresa    		","","","mv_ch08","C",03,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","ZN"})

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


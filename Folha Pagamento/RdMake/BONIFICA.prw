#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELVALE  บ Autor ณ Bruno Alves        บ Data ณ  27/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio que gerara um arquivo para poder enviar a empresaบฑฑ
ฑฑบ          ณ resposanvel do deposito do vale transporte aos funcionariosบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BONIFICA


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Bonifica็ใo "
Local nLin           := 100

Local Cabec1         := "Fl  Mat       Nome                                     Admissao   Anos        Valor"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "BONIFICA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SRA"
Private cPerg	     := "BONIFICA1"
Private cQuery       := ""
Private aPag		 := {}
Private cPeriodo 	 := ""


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

IF (MV_PAR08) == 2
	u_GPER009()
	Return
ENDIF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	titulo := "           Relatorio de Pagamento (Bonifica็ใo)  - Referente: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) "

wnrel := SetPrint("",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Utilizado para imprimir o relatorio
IF MV_PAR07 <= "2018"
cQuery := "SELECT RA_CC,RA_FILIAL,RA_MAT,RA_NOME,RA_CODFUNC,RA_DEPTO,RA_ADMISSA,RA_NASC,CTT_DESC01,RJ_DESC,(SELECT SUBSTRING(RX_TXT,7,8) FROM SRX010 WHERE RX_TIP = '11' AND SUBSTRING(RX_COD,9,4) = '" + (MV_PAR07) +"' AND SUBSTRING(RX_COD,13,2) = '" + (MV_PAR06) +"' AND D_E_L_E_T_ <> '*' AND SUBSTRING(RX_COD,1,2) = '" + (MV_PAR01) + "') AS SALMINIMO FROM SRA010 "
ELSE
cQuery := "SELECT RA_CC,RA_FILIAL,RA_MAT,RA_NOME,RA_CODFUNC,RA_DEPTO,RA_ADMISSA,RA_NASC,CTT_DESC01,RJ_DESC,(SELECT SUBSTRING(RCC_CONTEU,13,12)FROM RCC010 WHERE RCC_CODIGO = 'S004' AND SUBSTRING(RCC_CONTEU,1,4) = '" + (MV_PAR07) +"' AND '" + (MV_PAR06) +"' BETWEEN SUBSTRING(RCC_CONTEU,05,2) AND SUBSTRING(RCC_CONTEU,11,2)  AND D_E_L_E_T_ <> '*' AND SUBSTRING(RCC_FIL,1,2) = '" + (MV_PAR01) + "') AS SALMINIMO FROM SRA010 "
ENDIF
cQuery += "INNER JOIN CTT010 ON RA_FILIAL = CTT_FILIAL AND RA_CC = CTT_CUSTO "
cQuery += "INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO "
cQuery += "WHERE "
cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
cQuery += "SRA010.RA_DEMISSA = '' AND "
cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "SRA010.RA_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "SUBSTRING(RA_ADMISSA,5,2) IN ('" + (MV_PAR06) + "') AND "
cQuery += "SRA010.RA_CATFUNC <> 'E' AND "
cQuery += "SRJ010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY RA_NOME "

tcQuery cQuery New Alias "TMP"


If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If EMPTY(SALMINIMO)
	MsgInfo("Favor preencher o campo Salario Minimo no Parametro Nบ 11","Verifique")
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
Local nAno 	:= 0
Local nVal 	:= 0
LOCAL cVerba := ""
Local nValCC := 0
Local nValTot := 0

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !("TMP")->(Eof())

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


	nAno := VAL(MV_PAR07) - VAL(SUBSTR(TMP->RA_ADMISSA,1,4))  //Quantidade de anos trabalhados na empresa
	nVal := 0

	If MV_PAR07 == "2013" //Calculo para compensar os meses nใo recebidos, devido a data do surgimento da bonifica็ใo Ano 2013

		If nAno > 0 // alterar, valido somente em 5 e 5 anos
			If nAno < 5
				nVal := 0
			ElseIf nAno >= 5 .AND. nAno <= 9
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 1
			ElseIf nAno >= 10 .AND. nAno <= 14
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 2
			ElseIf nAno >= 15 .AND. nAno <= 19
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 3
			ElseIf nAno >= 20
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 4
			EndIf
		else
			nAno := 0
			nVal := 0
		EndIf

	Else

		If nAno > 0
			If nAno < 5
				nVal := 0
			ElseIf nAno/5 == 1
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 1
			ElseIf nAno/5 == 2
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 2
			ElseIf nAno/5 == 3
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 3
			ElseIf nAno/5 >= 4 .AND. Len(cValToChar(nAno/5)) == 1
				nVal := VAL(ALLTRIM(TMP->SALMINIMO))  * 4
			EndIf
		else
			nAno := 0
			nVal := 0
		EndIf
	EndIf

	If nVal == 0
		dbskip()
		loop
	EndIf

	If MV_PAR08 == 1

	cVerba := ""
	If nAno <= 5
	cVerba := "305"
	ElseIf nAno >= 6
	cVerba := "307"
    EndIf

    If MV_PAR07 == "2013" .AND. nAno >= 10
    nVal += VAL(ALLTRIM(TMP->SALMINIMO))
    EndIf


		aAdd(aPag,{TMP->RA_FILIAL,;  		// 1 - Filial
		TMP->RA_MAT,;	// 2 - Matricula
		TMP->RA_CC,;	// 3 - Centro de Custo
		nAno,;	// 4 - Qtd Ano
		nVal,;// 5 - Valor
		cVerba}) //6 - Verba

	Endif

	IF(MV_PAR08) ==2

	//Criando o objeto que irแ gerar o conte๚do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Dados Do Funcionแrio") //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Dados Do Funcionแrio",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"FILIAL",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"CCUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"CENTRO_CUSTO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"MATRอCULA",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"DT_ADMISS",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"QTD_ANOS",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionแrio",cNomeTabela,"VALOR",3,3)

ENDIF

	@nLin, 000 PSAY TMP->RA_FILIAL
	@nLin, 004 PSAY TMP->RA_MAT
	@nLin, 014 PSAY TMP->RA_NOME
	@nLin, 056 PSAY STOD(TMP->RA_ADMISSA)
	@nLin, 068 PSAY nAno
	@nLin, 072 PSAY nVal Picture "@E 999,999,999.99"
	oFWMsExcel:AddRow("Dados Do Funcionแrio",cNomeTabela,{TMP->RA_FILIAL, TMP->RA_CC, TMP->CTT_DESC01, TMP->RA_MAT, TMP->RA_NOME, TMP->RA_ADMISSA, nAno, nVal})

	nValCC += nVal // valor total por centr
	nValTot += nVal

	nLin++

	dbskip()


EndDo

nLin++
@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin, 045 PSAY "T O T A L ----------->"
@nLin, 072 PSAY nValTot Picture "@E 999,999,999.99"
nLin++
@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"

oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexใo com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	("TMP")->(dbClosearea()) 				//FECHO A TABELA APOS O USO

	RestArea(aArea)


Return

If MV_PAR08 == 1

cPeriodo := MV_PAR07 + MV_PAR06

	For _J := 1 To Len(aPag)

	DBSelectArea("RGB")
	DBSetOrder(5)
	If DBSeek(aPag[_J][1] + "00001" + cPeriodo + "01" + "FOL" +  aPag[_J][2] + "305")

	    Reclock("RGB",.F.)
		RGB->RGB_FILIAL		:= aPag[_J][1]
		RGB->RGB_MAT		:= aPag[_J][2]
		RGB->RGB_PD			:= "305"
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= aPag[_J][4]
		RGB->RGB_VALOR		:= aPag[_J][5]
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= aPag[_J][3]
		MsUnlock()

	ELSE

	    Reclock("RGB",.T.)
		RGB->RGB_FILIAL		:= aPag[_J][1]
		RGB->RGB_MAT		:= aPag[_J][2]
		RGB->RGB_PD			:= "305"
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= aPag[_J][4]
		RGB->RGB_VALOR		:= aPag[_J][5]
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= aPag[_J][3]
		RGB->RGB_TIPO2		:= "G"
		RGB_PROCES 			:= "00001"
		RGB_PERIOD 			:= cPeriodo
		RGB_SEMANA 			:= "01"
		RGB_ROTEIR 			:= "FOL"
		RGB_QTDSEM  		:= 0
		RGB_PARCEL 			:= 0
		RGB_CODFUN 			:= TMP->RA_CODFUNC
		RGB_DEPTO 			:= TMP->RA_DEPTO
		RGB_DUM     		:= 0
		RGB_DDOIS   		:= 0
		RGB_DTRES   		:= 0
		RGB_DQUATR  		:= 0
		RGB_DCINCO  		:= 0
		RGB_DSEIS   		:= 0
		RGB_DSETE   		:= 0
		MsUnlock()

	EndIf


	Next _J



EndIf


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

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Filial ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Matricula De ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Matricula Ate ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","C. Custo De ?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"05","C. Custo Ate ?","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Mes ?","","","mv_ch06","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ano ?","","","mv_ch07","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Atualiza Movimento ?","","","mv_ch08","N",01,0,2,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})



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

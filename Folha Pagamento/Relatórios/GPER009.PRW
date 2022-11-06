#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relatório para ADMISSÃO E DEMISSÃO dos funcionários
//SIGAGPE -> Relatorios -> Especificos Record -> Admissões e Demissões


User Function GPER009()

Local oFWMsExcel
Local oExcel
Local aArea        	:= GetArea()
Local cArquivo    	:= GetTempPath()+'GPER009.xml'
Local nAno 	:= 0
Local nVal 	:= 0
Private cNomeTabela	:= ""
Private cFiltro		:= ""

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cNomeTabela	:= UPPER("Admissões e Rescisões " )

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
	MsgInfo("Favor preencher o campo Salario Minimo no Parametro Nº 11","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif


If nLastKey == 27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


DBSelectArea("TMP")
DBGotop()

    nAno := VAL(MV_PAR07) - VAL(SUBSTR(TMP->RA_ADMISSA,1,4))  //Quantidade de anos trabalhados na empresa
	nVal := 0

	If MV_PAR07 == "2013" //Calculo para compensar os meses não recebidos, devido a data do surgimento da bonificação Ano 2013

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

	//Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Dados Do Funcionário") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Dados Do Funcionário",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"FILIAL",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"CCUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"CENTRO_CUSTO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"MATRÍCULA",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"DT_ADMISS",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"QTD_ANOS",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"VALOR",3,3)


//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()


	//Criando as Linhas
    oFWMsExcel:AddRow("Dados Do Funcionário",cNomeTabela,{TMP->RA_FILIAL, TMP->RA_CC, TMP->CTT_DESC01, TMP->RA_MAT, TMP->RA_NOME, TMP->RA_ADMISSA, nAno, nVal})


	("TMP")->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	("TMP")->(dbClosearea()) 				//FECHO A TABELA APOS O USO

	RestArea(aArea)


Return


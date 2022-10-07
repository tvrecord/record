#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relatório de marcação de férias (Mostra pendências e marcações)
//SIGAGPE -> Relatorios -> Especificos Record -> Marcação de férias


User Function GPER006()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER006.xml'

Private cPerg  		:= "GPER006"
Private cNomeTabela	:= ""
Private cFiltro		:= ""
Private cFimAqu		:= ""
Private cLimitFer	:= ""
Private cSoma		:= ""

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou
		MsgAlert("Operação Cancelada!")
		RestArea(aArea)
		Return
	EndIf

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cNomeTabela	:= UPPER("Marcação de Férias" )

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

	SELECT RF_FILIAL,RA_MAT,RF_DATABAS AS INICIO_PER_AQUIS, RF_DATAFIM, RF_DFEPRO2, RA_REMUNEN //TEM QUE tirar um dia NO ADVPL
	, DATEADD(yyyy,1,RF_DATABAS) as PER_INICIO_FÉRIAS
	, DATEADD(yyyy,1,RF_DATAFIM) as LIM_INICIO_FÉRIAS //TEM QUE tirar 45 diaS NO ADVPL
	,RA_NOME,RA_CATFUNC,RA_ADMISSA,RA_CC, CTT_DESC01, RA_SITFOLH
	,RF_DATAINI AS DATA_INICIO
	,DATEADD(d,RF_DFEPRO1,RF_DATAINI)as DATA_FIM
	,RF_DFEPRO1 AS DIAS
	, RF_PERC13S, RF_PAR13AT, RA_CODFUNC, RA_DEPTO, QB_DESCRIC, RJ_DESC, RA_SALARIO, RF_DABPRO1 AS DIAS_ABONO
	FROM SRF010
	INNER JOIN SRA010 ON
	SRF010.RF_FILIAL = SRA010.RA_FILIAL AND
	SRF010.RF_MAT = SRA010.RA_MAT
	INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
	INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO AND SRJ010.D_E_L_E_T_ <> '*'
	LEFT JOIN SQB010 ON QB_DEPTO = RA_DEPTO
	WHERE
	SRF010.D_E_L_E_T_ <> '*'
	AND SRA010.D_E_L_E_T_ <> '*'
	AND SRA010.RA_MAT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SRA010.RA_CC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SRF010.RF_DATABAS BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND SRF010.RF_DATAINI BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND SRF010.RF_STATUS = '1'   //Ferias que NÃO foram pagas
	AND RA_SITFOLH <> 'D'
	UNION
	SELECT RF_FILIAL,RA_MAT,RF_DATABAS AS INICIO_PER_AQUIS, RF_DATAFIM, RF_DFEPRO2, RA_REMUNEN //TEM QUE tirar um dia NO ADVPL
	, DATEADD(yyyy,1,RF_DATABAS) as PER_INICIO_FÉRIAS
	, DATEADD(yyyy,1,RF_DATAFIM) as LIM_INICIO_FÉRIAS //TEM QUE tirar 45 diaS NO ADVPL
	,RA_NOME,RA_CATFUNC,RA_ADMISSA,RA_CC, CTT_DESC01, RA_SITFOLH
	,RF_DATINI2 AS DATA_INICIO
	,DATEADD(d,RF_DFEPRO2,RF_DATINI2)as DATA_FIM
	,RF_DFEPRO2 AS DIAS
	, RF_PERC13S, RF_PAR13AT, RA_CODFUNC, RA_DEPTO, QB_DESCRIC, RJ_DESC, RA_SALARIO, RF_DABPRO2 AS DIAS_ABONO
	FROM SRF010
	INNER JOIN SRA010 ON
	SRF010.RF_FILIAL = SRA010.RA_FILIAL AND
	SRF010.RF_MAT = SRA010.RA_MAT
	INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
	INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO AND SRJ010.D_E_L_E_T_ <> '*'
	LEFT JOIN SQB010 ON QB_DEPTO = RA_DEPTO
	WHERE
	SRF010.D_E_L_E_T_ <> '*'
	AND SRA010.D_E_L_E_T_ <> '*'
	AND SRA010.RA_MAT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND SRA010.RA_CC BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND SRF010.RF_DATABAS BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND SRF010.RF_DATINI2 BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
	AND SRF010.RF_DFEPRO1 <> '30'
	AND SRF010.RF_STATUS = '1'   //Ferias que NÃO foram pagas
	AND RA_SITFOLH <> 'D'
	ORDER BY RA_CC, RA_MAT

	EndSql //FINALIZO A MINHA QUERY


    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Dados Do Funcionário") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Dados Do Funcionário",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"MATRICULA",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"CCUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"CENTRO_CUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"DEPARTAMENTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"CARGO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"REMUNERAÇÃO",3,3)
        oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"ADMISSÃO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"INICIO PER. AQUIS.",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"FIM PER. AQUIS",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"PER. INICIO FÉRIAS",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"LIMITE INICIO FÉRIAS",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"DATA INICIO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"DATA FIM",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"QTD_DIAS",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"DIAS ABONO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"PERC. 13º",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcionário",cNomeTabela,"1º PAR 13 SAL",1,1)


While !(cAlias)->(Eof())


	cLimitFer	:= DaySum(((cAlias)->LIM_INICIO_FÉRIAS) , -45)
	cSoma		:= (cAlias)->RA_SALARIO + (cAlias)->RA_REMUNEN

	//Criando as Linhas
    oFWMsExcel:AddRow("Dados Do Funcionário",cNomeTabela,{RA_MAT, RA_NOME, RA_CC, CTT_DESC01, QB_DESCRIC, RJ_DESC, cSoma, DTOC(STOD(RA_ADMISSA)), DTOC(STOD(INICIO_PER_AQUIS)), DTOC(STOD(RF_DATAFIM)), PER_INICIO_FÉRIAS, cLimitFer, DTOC(STOD(DATA_INICIO)), DATA_FIM, DIAS, DIAS_ABONO, RF_PERC13S, RF_PAR13AT})


	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO
	RestArea(aArea)

Return

//Programa usado para criar perguntas na tabela SX1 (Tabela de perguntas)
Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Da Matrícula:"				,"","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"02","Até a Matrícula:"			,"","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"03","Do Centro de Custo:"		,"","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"04","Até o Centro de Custo:"		,"","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"05","Da Data Base:"				,"","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Até a Data Base:"			,"","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Da Programação:"			,"","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Até a Programação:"			,"","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//AAdd(aRegs,{cPerg,"07","Pendência:"					,"","","mv_ch07","N",01,0,2,"C","","mv_par07","Pendentes","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next

	dbSelectArea(_sAlias)

Return

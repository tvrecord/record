#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relat�rio para ADMISS�O E DEMISS�O dos funcion�rios
//SIGAGPE -> Relatorios -> Especificos Record -> Admiss�es e Demiss�es


User Function GPER005()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER005.xml'

Private cPerg  		:= "GPER005"
Private cNomeTabela	:= ""
Private cFiltro		:= ""

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIA��O DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou
		MsgAlert("Opera��o Cancelada!")
		RestArea(aArea)
		Return
	EndIf

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cNomeTabela	:= UPPER("Admiss�es e Rescis�es " )
cFiltro		:= "% RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+ "' AND RA_ADMISSA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' %" //Filtro MATR�CULA e per�odo solicitado nos parametros

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT RA_MAT AS MATRICULA, RA_NOME AS NOME, RA_CC AS CCUSTO, CTT_DESC01 AS CENTRO_CUSTO, RA_SEXO AS SEXO
, RA_ADMISSA AS DT_ADMISS, RA_NASC AS DT_NASC, RA_DEMISSA AS DT_DEMISS, RA_SITFOLH AS SIT_FOL
, (SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = '28' AND X5_CHAVE = RA_CATFUNC) AS CAT_FUNC
,(SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = '26' AND X5_CHAVE = RA_GRINRAI) AS GRAU_ESCOLA
, (SELECT X5_DESCRI FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = '27' AND X5_CHAVE = RA_RESCRAI) AS TIPO_RECISAO
, CASE RA_TPCONTR
WHEN '1' THEN '1 - Indeterminado'
WHEN '2' THEN '2 - Determinado'
ELSE '3 - Intermitente'
END AS TP_CONTRATO
, RA_CODFUNC AS COD_FUNC, RJ_DESC AS FUNCAO, RA_SALARIO SALARIO, RA_REMUNEN AS REMUNERACAO
, RA_SALARIO + RA_REMUNEN AS SOMA
, RA_DEPTO AS COD_DEP, QB_DESCRIC AS DEPARTAMENTO

FROM SRA010
INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
INNER JOIN SRJ010 ON RA_CODFUNC = RJ_FUNCAO AND SRJ010.D_E_L_E_T_ <> '*'
LEFT JOIN SQB010 ON QB_DEPTO = RA_DEPTO
WHERE SRA010.D_E_L_E_T_ = '' AND
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Dados Do Funcion�rio") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Dados Do Funcion�rio",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"MATRICULA",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"CCUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"CENTRO_CUSTO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"SEXO",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"DT_ADMISS",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"DT_NASC",1,1)
        oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"DT_DEMISS",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"SIT_FOL",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"CAT_FUNC",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"GRAU_ESCOLA",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"TIPO_RECISAO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"TP_CONTRATO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"COD_FUNC",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"FUNCAO",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"SALARIO",3,3)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"REMUNERACAO",3,3)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"SOMA",3,3)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"COD_DEP",1,1)
		oFWMsExcel:AddColumn("Dados Do Funcion�rio",cNomeTabela,"DEPARTAMENTO",1,1)

While !(cAlias)->(Eof())

	//Criando as Linhas
    oFWMsExcel:AddRow("Dados Do Funcion�rio",cNomeTabela,{MATRICULA, NOME, CCUSTO, CENTRO_CUSTO, SEXO, DTOC(STOD(DT_ADMISS)), DTOC(STOD(DT_NASC)), DTOC(STOD(DT_DEMISS)), SIT_FOL, CAT_FUNC, GRAU_ESCOLA, TIPO_RECISAO, TP_CONTRATO, COD_FUNC, FUNCAO, SALARIO, REMUNERACAO, SOMA, COD_DEP, DEPARTAMENTO})


	(cAlias)->(dbSkip()) //PASSAR PARA O PR�XIMO REGISTRO DA MINHA QUERY

Enddo

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conex�o com Excel
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

	AADD(aRegs,{cPerg,"01","Da Matr�cula:"			,"","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"02","At� a Matr�cula:"		,"","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"03","Da Data de Admiss�o:"	,"","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","At� a Data de Admiss�o:","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relatório para extrair o cálculo de plano de saúde em excel
//SIGAGPE -> Relatorios -> Especificos Record -> Cal. Plano Saúde


User Function GPERX008()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPERX008.xml'

Private cPerg  		:= "GPERX008"
Private cNomeTabela	:= ""
Private cFiltro		:= ""

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
cNomeTabela	:= UPPER("CÁLCULO DE PLANO DE SAÚDE" )
cFiltro		:= "%  AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+ "' AND RA_EXAMEDI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' %" //Filtro MATRÍCULA e período solicitado nos parametros

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT RA_FILIAL AS FILIAL, RHR_COMPPG AS PERIODO,RA_CC AS CCUSTO, RA_MAT AS MATRÍCULA , RHR_ORIGEM AS ORIGEM
, RHR_CODIGO AS DEPENDENTE
,IIF(RHR_ORIGEM = '1', RA_NOME, RB_NOME) AS NOME, RHR_TPLAN AS LANCAMENTO, RHR_TPFORN AS TIPO
, RHR_CODFOR AS COD_FORN, RHR_TPPLAN AS TP_PLANO, RHR_PLANO AS COD_PLANO
, RHR_PD AS COD_VERBA, RV_DESC AS VERBA, RHR_VLRFUN AS VLR_FUNC, RHR_VLREMP AS VLR_EMPR, (RHR_VLRFUN + RHR_VLREMP) AS TOTAL
FROM RHR010
INNER JOIN SRA010 ON RA_FILIAL = RHR_FILIAL AND  RA_MAT = RHR_MATAND RA_MAT < '799999' AND RA_SITFOLH <> 'D' AND SRA010.D_E_L_E_T_ = ''	//Cadastro de Funcionários
LEFT JOIN SRB010 ON RB_FILIAL = RHR_FILIAL AND RB_MAT = RHR_MAT	AND RB_COD = RHR_CODIGO AND SRB010.D_E_L_E_T_ = ''		//Dependentes
INNER JOIN SRV010 ON RV_COD = RHR_PD AND SRV010.D_E_L_E_T_ = ''
WHERE RHR010.D_E_L_E_T_ = ''





EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Exames Periódicos") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Exames Periódicos",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Matrícula",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Nome",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"CPF",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"RG",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Data_Nascimento",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Data_Vencimento_Periódico",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Departamento",1,1)
        oFWMsExcel:AddColumn("Exames Periódicos",cNomeTabela,"Função",1,1)

While !(cAlias)->(Eof())



	//Criando as Linhas
    oFWMsExcel:AddRow("Exames Periódicos",cNomeTabela,{MATRICULA, NOME, CPF, RG, DTOC(STOD(NASCIMENTO)), DTOC(STOD(VENCIMENTO)), DEPARTAMENTO,FUNCAO})


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

	AADD(aRegs,{cPerg,"01","Da Matrícula:		","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Até a Matrícula:	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Do Vencimento:		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Até o Vencimento:	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

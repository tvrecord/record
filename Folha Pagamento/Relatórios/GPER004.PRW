#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relat�rio para extrair o c�lculo de plano de sa�de e odontologico em excel
//SIGAGPE > Relat�rios > Espec�ficos Record > Plano Saude e Odonto


User Function GPER004()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER004.xml'

Private cPerg  		:= "GPER004"
Private cNomeTabela	:= ""
Private cFiltro		:= ""
Private cOrdem		:= ""
Private cTipo		:= ""
Private cPlano 		:= ""

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


cNomeTabela	:= UPPER("CALCULO DE PLANO DE SAUDE/ODONTO" )

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
//FILTRO PARA EXTRAIR PLANOS DE SA�DE, ODONTOL�GICO OU AMBOS RESPECTIVAMENTE
If  MV_PAR05 == 1
cFiltro		:= "% AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'AND CTT_CUSTO BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' AND RHK_TPFORN = '1' %"
ElseIf MV_PAR05 == 2
cFiltro		:= "% AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'AND CTT_CUSTO BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' AND RHK_TPFORN = '2' %"
ElseIf MV_PAR05 == 3
cFiltro		:= "% AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'AND CTT_CUSTO BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' %"
EndIf

//ORDENO POR MATR�CULA OU POR NOME DO TITULAR
If  MV_PAR06 == 1
cOrdem		:= "% MATRICULA %"
Else
cOrdem		:= "% FILIAL, NOME_ORD, DEPENDENTE %"
EndIf

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA O PLANO DE SA�DE DO FUNCIONARIO E SEUS DEPENDENTES

SELECT  RA_FILIAL AS FILIAL,'1 - TITULAR' AS TIPO,RA_CC AS CCUSTO, CTT_DESC01 AS DESCRICAO,RA_MAT AS MATRICULA,'' AS DEPENDENTE, RA_NOME AS NOME
, RHK_TPFORN AS TP_FORNEC, RHK_CODFOR AS COD_FORN, RHK_TPPLAN AS TP_PLAN, RHK_PLANO AS COD_PLANO
, CASE RHK_TPFORN
WHEN '1' THEN SUBSTRING(RCC1.RCC_CONTEU,3,20)
WHEN '2' THEN SUBSTRING(RCC2.RCC_CONTEU,3,20)
END AS DESC_PLANO
, CASE RHK_TPFORN
WHEN '1' THEN SUBSTRING(RCC1.RCC_CONTEU,35,12)
WHEN '2' THEN SUBSTRING(RCC2.RCC_CONTEU,35,12)
END AS VALOR
,RHK_PD AS VERBA_FUNCIONARIO, RHK_PDDAGR AS VERBA_DEPEND, RA_NOME AS NOME_ORD,  '' AS PLANO
FROM SRA010
INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
INNER JOIN RHK010 ON RHK_FILIAL = RA_FILIAL AND RHK_MAT = RA_MAT AND RHK010.D_E_L_E_T_ = ''
LEFT JOIN RCC010 AS RCC1 ON RCC1.RCC_CODIGO = 'S008' AND  RHK_PLANO = SUBSTRING(RCC1.RCC_CONTEU,1,2) AND RCC1.D_E_L_E_T_ = ''
LEFT JOIN RCC010 AS RCC2 ON RCC2.RCC_CODIGO = 'S013' AND  RHK_PLANO = SUBSTRING(RCC2.RCC_CONTEU,1,2) AND RCC2.D_E_L_E_T_ = ''
WHERE SRA010.D_E_L_E_T_ = '' AND RA_SITFOLH <> 'D' AND RHK_TPFORN = '1'
UNION
SELECT  RB_FILIAL AS FILIAL,'2 - DEPENDENTE' AS TIPO,RA_CC AS CCUSTO, CTT_DESC01 AS DESCRICAO,RB_MAT AS MATRICULA, RB_COD AS DEPENDENTE, RB_NOME AS NOME
, RHK_TPFORN AS TP_FORNEC, RHK_CODFOR AS COD_FORN, RHK_TPPLAN AS TP_PLAN, RHK_PLANO AS COD_PLANO
, CASE RHK_TPFORN
WHEN '1' THEN SUBSTRING(RCC1.RCC_CONTEU,3,20)
WHEN '2' THEN SUBSTRING(RCC2.RCC_CONTEU,3,20)
END AS DESC_PLANO
, CASE RHK_TPFORN
WHEN '1' THEN SUBSTRING(RCC1.RCC_CONTEU,47,12)
WHEN '2' THEN SUBSTRING(RCC2.RCC_CONTEU,47,12)
END AS VALOR
,RHK_PD AS VERBA_FUNCIONARIO, RHK_PDDAGR AS VERBA_DEPEND, RA_NOME AS NOME_ORD, RB_PLSAUDE AS PLANO
FROM SRB010
INNER JOIN SRA010 ON RB_FILIAL = RA_FILIAL AND RB_MAT = RA_MAT AND SRA010.D_E_L_E_T_ = ''
INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
INNER JOIN RHK010 ON RHK_FILIAL = RB_FILIAL AND RHK_MAT = RB_MAT AND RHK010.D_E_L_E_T_ = ''
LEFT JOIN RCC010 AS RCC1 ON RCC1.RCC_CODIGO = 'S008' AND  RHK_PLANO = SUBSTRING(RCC1.RCC_CONTEU,1,2) AND RCC1.D_E_L_E_T_ = ''
LEFT JOIN RCC010 AS RCC2 ON RCC2.RCC_CODIGO = 'S013' AND  RHK_PLANO = SUBSTRING(RCC2.RCC_CONTEU,1,2) AND RCC2.D_E_L_E_T_ = ''
WHERE SRB010.D_E_L_E_T_ = '' AND RA_SITFOLH <> 'D' AND RHK_TPFORN = '1' AND RB_PLSAUDE <> '2'
%exp:cFiltro%
ORDER BY
%exp:cOrdem%

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("CALCULO DE PLANO DE SAUDE/ODONTO") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"FILIAL",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"CENTRO DE CUSTO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"DESCRICAO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"TIPO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"MATRICULA",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"DEPENDENTE",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"TP_FORNEC",1,1)
		oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"DESCRICAO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"COD_PLANO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"DESCRICAO",1,1)
        oFWMsExcel:AddColumn("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,"VALOR",3,3)

dbSelectArea(cAlias)
dbGoTop()
While !(cAlias)->(Eof())

	//INCLUS�O DE NOVA COLUNA INDICANDO SA�DE OU ODONTO
	If (cAlias)->TP_PLAN == '1'
	cPlano = 'Plano de Saude'
	else
	cPlano = 'Odontol�gico'
	EndIF

	//Criando as Linhas
    oFWMsExcel:AddRow("CALCULO DE PLANO DE SAUDE/ODONTO",cNomeTabela,{FILIAL, CCUSTO, DESCRICAO, TIPO, MATRICULA, DEPENDENTE, NOME, TP_FORNEC,cPlano, COD_PLANO, DESC_PLANO, VALOR })

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

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Da Matr�cula:			","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"02","At� a Matr�cula:		","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"03","Do Centro de custo:		","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"04","At� o Centro de custo:	","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"05","Tipo Plano:				","","","mv_ch05","N",01,0,1,"C","","mv_par05","Sa�de","","","","","Odontol�gico","","","","","Ambos","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Ordenar por:			","","","mv_ch06","N",01,0,1,"C","","mv_par06","Matr�cula","","","","","Nome do Titular","","","","","","","","","","","","","","","","","","","",""})


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

	RestArea(aArea)
Return

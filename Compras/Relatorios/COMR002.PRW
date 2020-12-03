#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Wesley da Silva - 03/12/2020 - Relatorio para saber os ativos adquirido no mês
//SIGACOM -> Relatorios -> Especificos Record -> Ativos por Aquisicao

User Function COMR002()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'COMR002.xml'

Private cPerg  		:= "COMR002"
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
cNomeTabela	:= UPPER("Ativos adquiridos no período - " + ALLTRIM(MesExtenso(Month(MV_PAR01))))
cFiltro		:= "%AND N1_AQUISIC BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' %"


//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT N3_CCONTAB AS CCONTABIL,CT1_DESC01 AS NOMECONTA,N1_CBASE as BASE, N1_ITEM as ITEM , N1_DESCRIC AS DESCRICAO,
(SELECT E4_DESCRI FROM %table:SF1%
INNER JOIN %table:SE4% ON F1_COND = E4_CODIGO
WHERE SF1010.D_E_L_E_T_ = '' AND SE4010.D_E_L_E_T_ = ''
AND N1_FILIAL = F1_FILIAL AND N1_NFISCAL = F1_DOC
AND N1_NSERIE = F1_SERIE AND  F1_FORNECE = N1_FORNEC
AND N1_LOJA = F1_LOJA) AS CONDPAG, N3_VORIG1 AS VALOR,N1_NFISCAL as NFISCAL,N1_NSERIE as Serie,
N1_AQUISIC AS AQUISICAO
FROM SN1010
INNER JOIN SN3010 ON N1_FILIAL = N3_FILIAL AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N3_TIPO = '01'
INNER JOIN CT1010 ON N3_CCONTAB = CT1_CONTA
WHERE SN1010.D_E_L_E_T_ = '' AND SN3010.D_E_L_E_T_ = '' AND CT1010.D_E_L_E_T_ = ''
%exp:cFiltro%
ORDER BY N1_FILIAL,N3_CCONTAB,N1_CBASE,N1_ITEM



EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Aquisicao Ativos") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Aquisicao Ativos",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"CCONTABIL",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"NOMECONTA",1,1)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"DESCRICAO",1,1)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"CONDPAG",1,1)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"VALOR",3,3)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"NFISCAL",1,1)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"SERIE",1,1)
        oFWMsExcel:AddColumn("Aquisicao Ativos",cNomeTabela,"AQUISICAO",1,1)

While !(cAlias)->(Eof())



	//Criando as Linhas
    oFWMsExcel:AddRow("Aquisicao Ativos",cNomeTabela,{CCONTABIL,NOMECONTA, DESCRICAO, CONDPAG, VALOR, NFISCAL, SERIE, DTOC(STOD(AQUISICAO))})


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

	AADD(aRegs,{cPerg,"01","Data Inicial: ","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data Final:	  ","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

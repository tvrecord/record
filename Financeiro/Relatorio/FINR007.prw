#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relatório para extrair comissões de agência por emissão
//SIGAFIN -> Relatorios -> Especificos Record -> Comis. Agen. por Emissão


User Function FINR007()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'FINR007.xml'

Private cPerg  		:= "FINR007"
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
cNomeTabela	:= UPPER("Comissão de agência por emissão (" ) +DTOC(MV_PAR01) + " A " + DTOC(MV_PAR02) + ")"
cFiltro		:= "% AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' %" // // Filtro por Emissao ---> para pegar tudo o que tem aberto(td o que nao tem baixa) independente da emissao

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT SUBSTRING(E1_EMISSAO,1,4) + '/' + SUBSTRING(E1_EMISSAO,5,2) AS MES,A3_COD AS AGENCIA,A3_NOME AS NOME
,E1_NUM AS NOTA,E1_CLIENTE AS CLIENTE,E1_NOMCLI AS NOME
,E1_EMISSAO AS EMISSAO
,E1_VENCREA AS VENCIMENTO
,E1_VALOR AS VALOR,(E1_VALOR * E1_COMIS1 / 100) AS COMISSAO
,E1_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRICAO
//,SUBSTRING(E1_EMIS1,7,2) + '/' +  SUBSTRING(E1_EMIS1,5,2) + '/' + SUBSTRING(E1_EMIS1,1,4) AS ENTRADA
,E1_BAIXA AS BAIXA
FROM SE1010
INNER JOIN SA3010 ON E1_VEND1 = A3_COD
INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO
WHERE SE1010.D_E_L_E_T_ = '' AND SA3010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = ''
AND E1_COMIS1 <> 0
%exp:cFiltro%

//AND E1_BAIXA = '' --todos os que estao em aberto, quando for apenas por mês, comente o filtro e1_baixa
ORDER BY SUBSTRING(E1_EMISSAO,1,6),A3_COD,A3_NOME

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Comissão de Agências") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Comissão de Agências",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Mês",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Agência",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Nome",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Nota",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Cliente",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Nome",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Emissão",1,1)
        oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Vencimento",1,1)
		oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Valor",3,3)
		oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Comissão",3,3)
		oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Natureza",1,1)
		oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Descrição",1,1)
		oFWMsExcel:AddColumn("Comissão de Agências",cNomeTabela,"Baixa",1,1)

While !(cAlias)->(Eof())



	//Criando as Linhas
    oFWMsExcel:AddRow("Comissão de Agências",cNomeTabela,{MES, AGENCIA, NOME, NOTA, CLIENTE, NOME, DTOC(STOD(EMISSAO)), DTOC(STOD(VENCIMENTO)), VALOR, COMISSAO, NATUREZA, DESCRICAO, DTOC(STOD(BAIXA)) })


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

	Local _sAlias := Alias()
	Local aRegs	:={}
	Local i, j

	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)


	AADD(aRegs,{cPerg,"01","Da data de emissão: ","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Até data de emissão:	  ","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Rafael Fran�a - 18/05/2021 - Relatorio para saber o periodo que os itens ficam em estoque sem uso
//Pedro Leonardo - 12/04/2022 - Altera��es(Inclus�o de unidade requisitante, corre��es nos par�metros)
//SIGACOM -> Relatorios -> Especificos Record -> Estoque por Periodo

User Function COMR004()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'COMR004.xml'
Local cNomeTabela	:= UPPER("Itens em Estoque por Periodo")
Local cNomePlan		:= "Saldos SB2"
Local cFiltro		:= ""
Local cDescricao	:= ""
Local nSaldo		:= 0
Local cProduto		:= ""
Local cArmazem		:= ""
Local cCodigo 		:= ""
Local cDescri 		:= ""
Local nDias			:= 0
Local nEst        	:= 0
Local nVlEst		:= 0

Private cPerg  		:= "COMR004"

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
cFiltro		:= "% AND B2_COD BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND Y3_COD BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' %"

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY
SELECT B2_COD AS CODIGO, D1_DESCRI AS DESC_PROD, B2_LOCAL AS LOCAL
, D1_DOC AS NOTA_FISCAL, D1_SERIE AS SERIE, D1_DTDIGIT AS DT_ENTRADA, D1_FORNECE AS FORNECEDOR, D1_QUANT AS QTD_NF
, B2_QATU AS ESTOQUE, B2_VATU1 AS VL_ESTOQUE, Y3_COD AS UNI_REQ, Y3_DESC AS DESC_UNID, D1_PEDIDO AS PEDIDO
FROM %table:SB2%
INNER JOIN %table:SD1% ON B2_COD = D1_COD AND %table:SD1%.D_E_L_E_T_ = '' AND B2_LOCAL = D1_LOCAL
LEFT JOIN %table:SC1%  ON D1_PEDIDO = C1_PEDIDO AND %table:SC1%.D_E_L_E_T_ = ''
LEFT JOIN %table:SY3%  ON C1_UNIDREQ = Y3_COD AND %table:SY3%.D_E_L_E_T_ = ''
WHERE %table:SB2%.D_E_L_E_T_ = '' AND B2_QATU > 0
%exp:cFiltro%
ORDER BY B2_COD, B2_LOCAL, D1_DTDIGIT DESC

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet(cNomePlan) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable(cNomePlan,cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"COD_SOLICITANTE",1,1)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"DESC_SOLICITANTE",1,1)
	    oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"PRODUTO",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"DESC_PRODUTO",1,1)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"ARMAZEM",1,1)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"NFISCAL",1,1)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"SERIE",1,1)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"FORNECEDOR",1,1)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"DT_ENTRADA",1,1)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"QTD_ENTRADA",2,2)
        oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"ESTOQUE_ATUAL",2,2)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"VALOR_ATUAL",3,3)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"DIAS_ESTOQUE",1,1)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"PEDIDO",1,1)
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"HISTORICO",1,1)

While !(cAlias)->(Eof())

nDias := dDatabase - STOD((cAlias)->DT_ENTRADA)

If !Empty(PEDIDO)
	IF !EMPTY(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"))
		cDescricao	:= MemoLine(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"),100,1)
		IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"),101,100)))
			cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"),100,2)
			IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"),201,100)))
				cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + (cAlias)->PEDIDO,"ZL_OBS1"),100,3)
			ENDIF
		ENDIF
	ENDIF
EndIf

If cProduto <> CODIGO .OR. cArmazem <> (cAlias)->LOCAL
nSaldo 	:= 0
nEst 	:= (cAlias)->ESTOQUE
nVlEst	:= (cAlias)->VL_ESTOQUE
EndIf

If nSaldo < (cAlias)->ESTOQUE

/*
If QTD_NF >= ESTOQUE
nEst 	:= ESTOQUE
nVlEst	:= VL_ESTOQUE
ElseIf (ESTOQUE - nSaldo) >= QTD_NF
nEst 	:= QTD_NF
nVlEst	:= QTD_NF * (VL_ESTOQUE/ESTOQUE)
ElseIf (ESTOQUE - nSaldo) < QTD_NF
nEst 	:= (ESTOQUE - nSaldo)
nVlEst	:= (ESTOQUE - nSaldo) * (VL_ESTOQUE/ESTOQUE)
EndIf
*/

//If cCodigo <> CODIGO
cCodigo := (cAlias)->CODIGO
cDescri := (cAlias)->DESC_PROD
//Else
//cCodigo := ""
//cDescri := ""
//EndIf

    oFWMsExcel:AddRow(cNomePlan,cNomeTabela,{(cAlias)->UNI_REQ,(cAlias)->DESC_UNID,cCodigo,cDescri,(cAlias)->LOCAL,(cAlias)->NOTA_FISCAL,(cAlias)->SERIE,;
	(cAlias)->FORNECEDOR,DTOC(STOD((cAlias)->DT_ENTRADA)),(cAlias)->QTD_NF,nEst,nVlEst,cValToChar(nDias),(cAlias)->PEDIDO,ALLTRIM(UPPER(cDescricao))})

EndIf

nEst 		:= 0
nVlEst		:= 0
nSaldo 		+= (cAlias)->QTD_NF
cProduto	:= (cAlias)->CODIGO
cArmazem 	:= (cAlias)->LOCAL
cDescricao	:= ""

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

	Local _sAlias := Alias()
	Local aRegs	:={}
	Local i, j

	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Do Produto:			","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"02","At� o Produto:		","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"03","Da Entrada:			","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","At� a Entrada:		","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Do Departamento:	","","","mv_ch05","C",05,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SY3"})
	AADD(aRegs,{cPerg,"06","At� o Departamento:	","","","mv_ch06","C",05,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SY3"})

	For i:=1 to Len(aRegs)
		If !dbSeek(PADR(cPerg,10)+aRegs[i,2])
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

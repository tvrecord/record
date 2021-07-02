#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Rafael Fran�a - 18/05/2021 - Relatorio para saber o periodo que os itens ficam em estoque sem uso
//SIGACOM -> Relatorios -> Especificos Record -> Estoque por Periodo

User Function COMR004()

Private cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Private aArea        	:= GetArea()
Private oFWMsExcel
Private oExcel
Private cArquivo    	:= GetTempPath()+'COMR004.xml'
Private cPerg  		:= "COMR004"
Private cNomeTabela	:= UPPER("Itens em Estoque por Periodo")
Private cNomePlan	:= "Saldos SB2"
Private cFiltro		:= ""
Private cDescricao	:= ""
Private nSaldo		:= 0
Private cProduto	:= ""
Private cLocal		:= ""
Private cCodigo 	:= ""
Private cDescri 	:= ""
Private nDias		:= 0
Private nEst        := 0
Private nVlEst		:= 0

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
cFiltro		:= "% AND B2_COD BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' %"

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY
SELECT B2_COD AS CODIGO, D1_DESCRI AS DESC_PROD, B2_LOCAL AS LOCAL
, D1_DOC AS NOTA_FISCAL, D1_SERIE AS SERIE, D1_DTDIGIT AS DT_ENTRADA, D1_FORNECE AS FORNECEDOR, D1_QUANT AS QTD_NF
, B2_QATU AS ESTOQUE, B2_VATU1 AS VL_ESTOQUE, D1_CC AS CCUSTO, CTT_DESC01 AS DESC_CCUSTO, D1_PEDIDO AS PEDIDO
FROM %table:SB2%
INNER JOIN %table:SD1% ON B2_COD = D1_COD AND %table:SD1%.D_E_L_E_T_ = '' AND B2_LOCAL = D1_LOCAL
LEFT JOIN %table:CTT%  ON D1_CC = CTT_CUSTO AND %table:CTT%.D_E_L_E_T_ = ''
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
		oFWMsExcel:AddColumn(cNomePlan,cNomeTabela,"DEP_SOLICITANTE",1,1)

While !(cAlias)->(Eof())

nDias := dDatabase - STOD(DT_ENTRADA)

If !Empty(PEDIDO)
	IF !EMPTY(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"))
		cDescricao	:= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,1)
		IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),101,100)))
			cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,2)
			IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),201,100)))
				cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,3)
			ENDIF
		ENDIF
	ENDIF
EndIf

If cProduto <> CODIGO .OR. cLocal <> LOCAL
nSaldo 	:= 0
nEst 	:= ESTOQUE
nVlEst	:= VL_ESTOQUE
EndIf

If nSaldo < ESTOQUE

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

If cCodigo <> CODIGO
cCodigo := CODIGO
cDescri := DESC_PROD
Else
cCodigo := ""
cDescri := ""
EndIf

    oFWMsExcel:AddRow(cNomePlan,cNomeTabela,{cCodigo,cDescri,LOCAL,NOTA_FISCAL,SERIE,FORNECEDOR,DTOC(STOD(DT_ENTRADA)),QTD_NF,nEst,nVlEst,cValToChar(nDias),PEDIDO,UPPER(cDescricao),""})

EndIf

nEst 		:= 0
nVlEst		:= 0
nSaldo 		+= QTD_NF
cProduto	:= CODIGO
cLocal 		:= LOCAL
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

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Do Produto:		","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"02","At� o Produto:	","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
	AADD(aRegs,{cPerg,"03","Da Data:		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","At� a Data:		","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
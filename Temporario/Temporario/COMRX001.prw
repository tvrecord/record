#Include "RwMake.ch"
#Include "topconn.ch"

// COMRX001 - Rafael França - 29/06/2020 - Programa criado com objetivo de facilitar a importação das informações do sistema para o BI.

User Function COMRX001


Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    		:= GetTempPath()+'COMRX001.xml'

Private cPerg  			:= "COMRX001"
Private cFiltro			:= ""
Private cNomeTabela		:= ""


	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou
		MsgAlert("Operação Cancelada!","Alerta!")
		RestArea(aArea)
		Return
	EndIf

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

IF MV_PAR05 == 1 .OR. MV_PAR05 == 4 //Entradas ou todos

//Filtro das Entradas
cFiltro := "%AND D1_FILIAL BETWEEN '" + ALLTRIM(MV_PAR01) + "' AND '" + ALLTRIM(MV_PAR02) + "' AND D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' %"

BeginSql Alias cAlias

//Query com o tratamento das informações da tabela SD1 de entrada
SELECT 'ENTRADA' AS TIPO, '' AS EMPRESA,D1_FILIAL AS FILIAL,D1_TIPO AS TIPONF
, D1_DOC AS NFISCAL, D1_SERIE AS SERIE, D1_ITEM AS ITEM, D1_COD AS PRODUTO
, AH_UMRES AS MEDIDA, B1_DESC AS DESCRICAOP, D1_QUANT AS QUANTIDADE,D1_VUNIT AS VLUNIT, D1_TOTAL AS VLTOTAL, D1_LOCAL AS ARMAZEM,NNR_DESCRI AS DESCRICAOA
, D1_LOTECTL AS LOTE, D1_DTVALID AS VALIDADE, D1_DTDIGIT AS ENTRADA, D1_EMISSAO AS EMISSAO
, D1_TES AS TES, F4_TEXTO AS FINALIDADE, F4_ESTOQUE AS ESTOQUE, F4_DUPLIC AS FINANCEIRO, D1_CF AS CFOP
, D1_FORNECE AS CLIFOR, D1_LOJA AS LOJA
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_NOME FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_NOME FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS NOME
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_EST FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_EST FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS ESTADO
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_TIPO FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_PESSOA FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS PESSOA
, D1_PEDIDO AS PEDIDO, D1_ITEMPC AS ITEMPD
, CASE D1_TIPO WHEN 'D' THEN 'DEVOLUCAO' WHEN 'N' THEN 'NORMAL' WHEN 'C' THEN 'COMPLEMENTO VALOR' WHEN 'B' THEN 'BENEFICIAMENTO' WHEN 'P' THEN 'COMPLEMENTO IPI' WHEN 'I' THEN 'COMPLEMENTO ICMS' END AS TIPONF1
//Rafael França - 07/07/20 - Inclusão das informações: Codigo de municipio, Municipio, Canal e Descrição (Cliente)
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_COD_MUN FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_COD_MUN FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_MUN
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_MUN FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_MUN FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS MUNICIPIO
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN (SELECT A2_PAIS FROM %table:SA2% WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_PAIS FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_PAIS
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN '' //GF
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_ZZCANAL FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_CANAL //GF
, CASE WHEN D1_TIPO NOT IN ('D','B') THEN '' //GF
WHEN D1_TIPO IN ('D','B') THEN (SELECT A1_ZZDSCAN FROM %table:SA1% WHERE D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS CANAL //GF
, F1_CHVNFE AS CHAVENFE
FROM %table:SD1%
INNER JOIN %table:SF1% ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_SERIE = F1_SERIE AND D1_EMISSAO = F1_EMISSAO AND %table:SF1%.D_E_L_E_T_ = ''
INNER JOIN %table:SB1% ON D1_COD = B1_COD AND %table:SB1%.D_E_L_E_T_ = ''
INNER JOIN %table:SF4% ON D1_TES = F4_CODIGO AND %table:SF4%.D_E_L_E_T_ = ''
INNER JOIN %table:NNR% ON D1_FILIAL = NNR_FILIAL AND D1_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = '' //GF NNR Exclusiva
//INNER JOIN %table:NNR% ON D1_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = '' //Rec NNR Compartilhada
INNER JOIN %table:SAH% ON D1_UM = AH_UNIMED AND %table:SAH%.D_E_L_E_T_ = ''
WHERE %table:SD1%.D_E_L_E_T_ = ''
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

cNomeTabela := "SD1 Entradas - " + DTOC(MV_PAR03) + " a " + DTOC(MV_PAR04)

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Entradas") //Não utilizar número junto com sinal de menos. Ex.: 1-

		//Criando a Tabela
        oFWMsExcel:AddTable("Entradas",cNomeTabela)

//Criando Colunas
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"TIPO"   		,1,1) //01 //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"EMPRESA"		,1,1) //02
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"FILIAL"	   	,1,1) //03
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"TIPONF"	    ,1,1) //04
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"NFISCAL"  		,1,1) //05
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"SERIE"   	  	,1,1) //06
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"ITEM"   	  	,1,1) //07
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"PRODUTO"   	,1,1) //08
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"DESCRICAOP"	,1,1) //09
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"QUANTIDADE"	,2,2) //10
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"MEDIDA"	    ,1,1) //11
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"VLUNIT"	    ,2,2) //12
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"VLTOTAL"  		,2,2) //13
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"ARMAZEM"   	,1,1) //14
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"DESCRICAOA"  	,1,1) //15
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"LOTE" 	 		,1,1) //16
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"VALIDADE"   	,1,1) //17
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"DTENTRADA"   	,1,1) //18
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"EMISSAO"   	,1,1) //19
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"TES"			,1,1) //20
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"FINALIDADE"	,1,1) //21
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"ESTOQUE"   	,1,1) //22
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"FINANCEIRO"	,1,1) //23
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"CFOP"	   		,1,1) //24
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"CLIFOR"	    ,1,1) //25
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"NOME"  		,1,1) //26
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"ESTADO"   	  	,1,1) //27
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"PESSOA"   	  	,1,1) //28
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"PEDIDO"   	  	,1,1) //29
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"ITEMPD"   	  	,1,1) //30
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"COD_MUN"   	,1,1) //31
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"MUNICIPIO"  	,1,1) //32
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"COD_PAIS"      ,1,1) //33
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"PAIS"      	,1,1) //34
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"COD_CANAL"     ,1,1) //35 - GF
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"CANAL"   	  	,1,1) //36 - GF
oFWMsExcel:AddColumn("Entradas",cNomeTabela,"CHAVENFE" 	  	,1,1) //37

While !(cAlias)->(Eof())

	//Criando as Linhas
    oFWMsExcel:AddRow("Entradas",cNomeTabela,{TIPO,EMPRESA,FILIAL,TIPONF1,NFISCAL,SERIE,ITEM,PRODUTO,DESCRICAOP,QUANTIDADE,MEDIDA,VLUNIT,VLTOTAL,ARMAZEM,DESCRICAOA,LOTE,DTOC(STOD(VALIDADE)),DTOC(STOD(ENTRADA)),DTOC(STOD(EMISSAO)),TES,FINALIDADE,ESTOQUE,FINANCEIRO,CFOP,CLIFOR,NOME,ESTADO,PESSOA,PEDIDO,ITEMPD,COD_MUN,MUNICIPIO,COD_PAIS,Posicione('SYA',1,xFilial('SYA')+COD_PAIS,'YA_DESCR'),COD_CANAL,CANAL,CHAVENFE}) //GF
	//oFWMsExcel:AddRow("Entradas",cNomeTabela,{TIPO,EMPRESA,FILIAL,TIPONF1,NFISCAL,SERIE,ITEM,PRODUTO,DESCRICAOP,QUANTIDADE,MEDIDA,VLUNIT,VLTOTAL,ARMAZEM,DESCRICAOA,LOTE,DTOC(STOD(VALIDADE)),DTOC(STOD(ENTRADA)),DTOC(STOD(EMISSAO)),TES,FINALIDADE,ESTOQUE,FINANCEIRO,CFOP,CLIFOR,NOME,ESTADO,PESSOA,PEDIDO,ITEMPD,COD_MUN,MUNICIPIO,COD_PAIS,Posicione('SYA',1,xFilial('SYA')+COD_PAIS,'YA_DESCR'),CHAVENFE}) //Rec

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

(cAlias)->(dbClosearea()) //FECHO A TABELA APOS O USO

ENDIF

IF MV_PAR05 == 2 .OR. MV_PAR05 == 4 //Saídas ou todos

//Filtro das saídas
cFiltro := "%AND D2_FILIAL BETWEEN '" + ALLTRIM(MV_PAR01) + "' AND '" + ALLTRIM(MV_PAR02) + "' AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' %"

BeginSql Alias cAlias

//Query com o tratamento das informações da tabela SD2 de saída
SELECT 'SAIDA' AS TIPO, '10 - GLOBALFRUIT' AS EMPRESA,D2_FILIAL AS FILIAL,D2_TIPO AS TIPONF, D2_DOC AS NFISCAL, D2_SERIE AS SERIE, D2_ITEM AS ITEM, D2_COD AS PRODUTO
, AH_UMRES AS MEDIDA, B1_DESC AS DESCRICAOP, D2_QUANT AS QUANTIDADE,D2_PRCVEN AS VLUNIT, D2_TOTAL AS VLTOTAL, D2_LOCAL AS ARMAZEM,NNR_DESCRI AS DESCRICAOA
, D2_LOTECTL AS LOTE, D2_DTVALID AS VALIDADE, D2_EMISSAO AS ENTRADA, D2_EMISSAO AS EMISSAO
, D2_TES AS TES, F4_TEXTO AS FINALIDADE, F4_ESTOQUE AS ESTOQUE, F4_DUPLIC AS FINANCEIRO, D2_CF AS CFOP
, D2_CLIENTE AS CLIFOR, D2_LOJA AS LOJA, CASE
WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_NOME FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_NOME FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS NOME
, CASE WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_EST FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_EST FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS ESTADO
, CASE WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_TIPO FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_PESSOA FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS PESSOA
, D2_PEDIDO AS PEDIDO, D2_ITEMPV AS ITEMPD
, CASE D2_TIPO WHEN 'D' THEN 'DEVOLUCAO' WHEN 'N' THEN 'NORMAL' WHEN 'C' THEN 'COMPLEMENTO VALOR' WHEN 'B' THEN 'BENEFICIAMENTO' WHEN 'P' THEN 'COMPLEMENTO IPI' WHEN 'I' THEN 'COMPLEMENTO ICMS' END AS TIPONF1
//Rafael França - 07/07/20 - Inclusão das informações: Codigo de municipio, Municipio, Canal e Descrição (Cliente)
, CASE WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_COD_MUN FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_COD_MUN FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_MUN
, CASE WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_MUN FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_MUN FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS MUNICIPIO
, CASE WHEN D2_TIPO IN ('D','B') THEN (SELECT A2_PAIS FROM %table:SA2% WHERE D2_CLIENTE = A2_COD AND D2_LOJA = A2_LOJA AND %table:SA2%.D_E_L_E_T_ = '' )
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_PAIS FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_PAIS
, CASE WHEN D2_TIPO IN ('D','B') THEN '' //GF
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_ZZCANAL FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS COD_CANAL //GF
, CASE WHEN D2_TIPO IN ('D','B') THEN '' //GF
WHEN D2_TIPO NOT IN ('D','B') THEN (SELECT A1_ZZDSCAN FROM %table:SA1% WHERE D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND %table:SA1%.D_E_L_E_T_ = '' ) END AS CANAL //GF
, F2_CHVNFE AS CHAVENFE
FROM %table:SD2%
INNER JOIN %table:SF2% ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND %table:SF2%.D_E_L_E_T_ = ''
INNER JOIN %table:SB1% ON D2_COD = B1_COD AND %table:SB1%.D_E_L_E_T_ = ''
INNER JOIN %table:SF4% ON D2_TES = F4_CODIGO AND %table:SF4%.D_E_L_E_T_ = ''
INNER JOIN %table:NNR% ON D2_FILIAL = NNR_FILIAL AND D2_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = '' //GF NNR Exclusiva
//INNER JOIN %table:NNR% ON D2_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = '' //Rec NNR Compartilhada
INNER JOIN %table:SAH% ON D2_UM = AH_UNIMED AND %table:SAH%.D_E_L_E_T_ = ''
WHERE %table:SD2%.D_E_L_E_T_ = ''
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

cNomeTabela := "SD2 Saidas - " + DTOC(MV_PAR03) + " a " + DTOC(MV_PAR04)

	IF MV_PAR05 == 2 //Crio o objeto se ele não foi criado
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
	ENDIF

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Saidas") //Não utilizar número junto com sinal de menos. Ex.: 1-

		//Criando a Tabela
        oFWMsExcel:AddTable("Saidas",cNomeTabela)

//Criando Colunas
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"TIPO"   		,1,1) //01 //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"EMPRESA"		,1,1) //02
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"FILIAL"	   	,1,1) //03
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"TIPONF"	    ,1,1) //04
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"NFISCAL"  	,1,1) //05
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"SERIE"   	,1,1) //06
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"ITEM"   	  	,1,1) //07
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"PRODUTO"   	,1,1) //08
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"DESCRICAOP"	,1,1) //09
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"QUANTIDADE"	,2,2) //10
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"MEDIDA"	    ,1,1) //11
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"VLUNIT"	    ,2,2) //12
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"VLTOTAL"  	,2,2) //13
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"ARMAZEM"   	,1,1) //14
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"DESCRICAOA"  ,1,1) //15
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"LOTE" 	 	,1,1) //16
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"VALIDADE"   	,1,1) //17
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"DTSAIDA"   	,1,1) //18
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"EMISSAO"   	,1,1) //19
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"TES"			,1,1) //20
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"FINALIDADE"	,1,1) //21
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"ESTOQUE"   	,1,1) //22
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"FINANCEIRO"	,1,1) //23
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"CFOP"	   	,1,1) //24
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"CLIFOR"	    ,1,1) //25
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"NOME"  		,1,1) //26
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"ESTADO"   	,1,1) //27
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"PESSOA"   	,1,1) //28
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"PEDIDO"   	,1,1) //29
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"ITEMPD"   	,1,1) //30
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"COD_MUN"   	,1,1) //31
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"MUNICIPIO"  	,1,1) //32
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"COD_PAIS"   	,1,1) //33
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"PAIS"   	    ,1,1) //34
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"COD_CANAL"   ,1,1) //35 - GF
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"CANAL"   	,1,1) //36 - GF
oFWMsExcel:AddColumn("Saidas",cNomeTabela,"CHAVENFE"   	,1,1) //37

While !(cAlias)->(Eof())

	//Criando as Linhas
    oFWMsExcel:AddRow("Saidas",cNomeTabela,{TIPO,EMPRESA,FILIAL,TIPONF1,NFISCAL,SERIE,ITEM,PRODUTO,DESCRICAOP,QUANTIDADE,MEDIDA,VLUNIT,VLTOTAL,ARMAZEM,DESCRICAOA,LOTE,DTOC(STOD(VALIDADE)),DTOC(STOD(ENTRADA)),DTOC(STOD(EMISSAO)),TES,FINALIDADE,ESTOQUE,FINANCEIRO,CFOP,CLIFOR,NOME,ESTADO,PESSOA,PEDIDO,ITEMPD,COD_MUN,MUNICIPIO,COD_PAIS,Posicione('SYA',1,xFilial('SYA')+COD_PAIS,'YA_DESCR'),COD_CANAL,CANAL,CHAVENFE}) //GF
	//oFWMsExcel:AddRow("Saidas",cNomeTabela,{TIPO,EMPRESA,FILIAL,TIPONF1,NFISCAL,SERIE,ITEM,PRODUTO,DESCRICAOP,QUANTIDADE,MEDIDA,VLUNIT,VLTOTAL,ARMAZEM,DESCRICAOA,LOTE,DTOC(STOD(VALIDADE)),DTOC(STOD(ENTRADA)),DTOC(STOD(EMISSAO)),TES,FINALIDADE,ESTOQUE,FINANCEIRO,CFOP,CLIFOR,NOME,ESTADO,PESSOA,PEDIDO,ITEMPD,COD_MUN,MUNICIPIO,COD_PAIS,Posicione('SYA',1,xFilial('SYA')+COD_PAIS,'YA_DESCR'),CHAVENFE}) //Rec

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

ENDIF

IF MV_PAR05 == 3 .OR. MV_PAR05 == 4 // Estoque ou todos

//Filtro das saídas
cFiltro := "%AND D3_FILIAL BETWEEN '" + ALLTRIM(MV_PAR01) + "' AND '" + ALLTRIM(MV_PAR02) + "' AND D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' %"

BeginSql Alias cAlias

SELECT 'INTERNAS' AS TIPO, '' AS EMPRESA, D3_FILIAL AS FILIAL, D3_CF AS TIPO1, D3_DOC AS DOCUMENTO, D3_SEQCALC AS SEQUENCIA, D3_COD AS PRODUTO, B1_DESC AS DESCRICAOP, D3_QUANT AS QUANTIDADE
, D3_CUSTO1 AS CUSTO, AH_UMRES AS MEDIDA, D3_LOCAL AS ARMAZEM, NNR_DESCRI AS DESCRICAOA, D3_TM AS TPMOV, F5_TEXTO AS FINALIDADE,  D3_EMISSAO AS EMISSAO, D3_LOTECTL AS LOTE, D3_DTVALID AS VALIDADE
FROM %table:SD3%
INNER JOIN %table:SB1% ON B1_COD = D3_COD AND %table:SB1%.D_E_L_E_T_ = ''
INNER JOIN %table:NNR% ON D3_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = ''
INNER JOIN %table:SAH% ON D3_UM = AH_UNIMED AND %table:SAH%.D_E_L_E_T_ = ''
INNER JOIN %table:SF5% ON D3_TM = F5_CODIGO AND %table:SF5%.D_E_L_E_T_ = ''
WHERE %table:SD3%.D_E_L_E_T_ = ''
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

cNomeTabela := "SD3 Internas - " + DTOC(MV_PAR03) + " a " + DTOC(MV_PAR04)

	IF MV_PAR05 == 3 //Crio o objeto se ele não foi criado
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
	ENDIF

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Internas") //Não utilizar número junto com sinal de menos. Ex.: 1-

		//Criando a Tabela
        oFWMsExcel:AddTable("Internas",cNomeTabela)

//Criando Colunas
oFWMsExcel:AddColumn("Internas",cNomeTabela,"TIPO"   		,1,1) //01 //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
oFWMsExcel:AddColumn("Internas",cNomeTabela,"EMPRESA"		,1,1) //02
oFWMsExcel:AddColumn("Internas",cNomeTabela,"FILIAL"	   	,1,1) //03
oFWMsExcel:AddColumn("Internas",cNomeTabela,"TIPO1"		    ,1,1) //04
oFWMsExcel:AddColumn("Internas",cNomeTabela,"DOCUMENTO"  	,1,1) //05
oFWMsExcel:AddColumn("Internas",cNomeTabela,"SEQUENCIA"		,1,1) //06
oFWMsExcel:AddColumn("Internas",cNomeTabela,"PRODUTO"   	,1,1) //07
oFWMsExcel:AddColumn("Internas",cNomeTabela,"DESCRICAOP"	,1,1) //08
oFWMsExcel:AddColumn("Internas",cNomeTabela,"QUANTIDADE"	,2,2) //09
oFWMsExcel:AddColumn("Internas",cNomeTabela,"MEDIDA"	    ,1,1) //10
oFWMsExcel:AddColumn("Internas",cNomeTabela,"CUSTO"  		,2,2) //11
oFWMsExcel:AddColumn("Internas",cNomeTabela,"EMISSAO"	    ,1,1) //12
oFWMsExcel:AddColumn("Internas",cNomeTabela,"TIPOMOV"	    ,1,1) //13
oFWMsExcel:AddColumn("Internas",cNomeTabela,"FINALIDADE"    ,1,1) //14
oFWMsExcel:AddColumn("Internas",cNomeTabela,"ARMAZEM"   	,1,1) //15
oFWMsExcel:AddColumn("Internas",cNomeTabela,"DESCRICAOA"  	,1,1) //16
oFWMsExcel:AddColumn("Internas",cNomeTabela,"LOTE" 	 		,1,1) //17
oFWMsExcel:AddColumn("Internas",cNomeTabela,"VALIDADE"   	,1,1) //18

While !(cAlias)->(Eof())

	//Criando as Linhas
	oFWMsExcel:AddRow("Internas",cNomeTabela,{TIPO,EMPRESA,FILIAL,TIPO1,DOCUMENTO,SEQUENCIA,PRODUTO,DESCRICAOP,QUANTIDADE,MEDIDA,CUSTO,DTOC(STOD(EMISSAO)),TPMOV,FINALIDADE,ARMAZEM,DESCRICAOA,LOTE,DTOC(STOD(VALIDADE))})

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

//Crio a tabela de saldos iniciais

cFiltro := "%AND B9_FILIAL BETWEEN '" + ALLTRIM(MV_PAR01) + "' AND '" + ALLTRIM(MV_PAR02) + "' %"

BeginSql Alias cAlias

SELECT 'SLD_INICIAL' AS TIPO, '' AS EMPRESA, B9_FILIAL AS FILIAL, B9_COD AS PRODUTO, B1_DESC AS DESCRICAOP, B9_QINI AS QTDINICIAL
, B9_VINI1 AS VLRINICIAL, B9_LOCAL AS ARMAZEM, NNR_DESCRI AS DESCRICAOA, B9_DATA AS DATA
FROM %table:SB9%
INNER JOIN %table:SB1% ON B1_COD = B9_COD AND %table:SB1%.D_E_L_E_T_ = ''
INNER JOIN %table:NNR% ON B9_FILIAL = NNR_FILIAL AND B9_LOCAL = NNR_CODIGO AND %table:NNR%.D_E_L_E_T_ = ''
WHERE %table:SB9%.D_E_L_E_T_ = '' AND (B9_VINI1 <> 0 OR B9_QINI <> 0)
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

cNomeTabela := "SB9 Saldos Iniciais"

	IF MV_PAR05 == 3 //Crio o objeto se ele não foi criado
    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
	ENDIF

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Saldo_Inicial") //Não utilizar número junto com sinal de menos. Ex.: 1-

		//Criando a Tabela
        oFWMsExcel:AddTable("Saldo_Inicial",cNomeTabela)

//Criando Colunas
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"TIPO"   		,1,1) //01 //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"EMPRESA"		,1,1) //02
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"FILIAL"	   	,1,1) //03
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"PRODUTO"   	,1,1) //07
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"DESCRICAOP"	,1,1) //08
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"QTDINICIAL"	,2,2) //09
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"VLRINICIAL"   ,2,2) //10
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"DATA"		    ,1,1) //12
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"ARMAZEM"   	,1,1) //15
oFWMsExcel:AddColumn("Saldo_Inicial",cNomeTabela,"DESCRICAOA"  	,1,1) //16


While !(cAlias)->(Eof())

	//Criando as Linhas
	oFWMsExcel:AddRow("Saldo_Inicial",cNomeTabela,{TIPO,EMPRESA,FILIAL,PRODUTO,DESCRICAOP,QTDINICIAL,VLRINICIAL,DTOC(STOD(DATA)),ARMAZEM,DESCRICAOA})

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

(cAlias)->(dbClosearea()) //FECHO A TABELA APOS O USO

ENDIF

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	RestArea(aArea)

Return

//Validação cPerg

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

AADD(aRegs,{cPerg,"01","Da Filial:		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Até a Filial: 	","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Da Data:  		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Até a Data: 	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","TP Relatorio: 	","","","mv_ch05","N",01,0,0,"C","","mv_par05","Entradas","","","","","Saidas","","","","","Estoque","","","","","Todos","","","","","","","","",""})

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
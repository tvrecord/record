#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Rafael França - 21/01/2021 - Relatorio de pedidos de compras, autorizações de entrega e autoizações de pagamento aguardando aprovação
//SIGACOM -> Relatorios -> Especificos -> Pendentes para liberação

User Function COMR003()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    		:= GetTempPath()+'COMR003.xml'

Private cPerg  			:= "COMR003"
Private cFiltro			:= ""
Private cFiltro1		:= ""
Private cNomeTabela		:= ""
Private cDescricao		:= ""
Private cOrcado			:= ""
Private nPrevisao		:= 0
Private nSaldo			:= 0
Private cAprov01		:= ""
Private cLib01			:= ""
Private cAprov02        := ""
Private cLib02			:= ""
Private nPedido			:= ""
Private cCampo1			:= ""
Private cCampo2			:= ""
Private aRegistros		:= {}
Private nLin			:= 0
Private cSolicitante    := ""

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

cNomeTabela		:= "PENDENTES PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)
cFiltro			:= "% AND C7_CONAPRO <> 'L' AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "'  AND '" + DTOS(MV_PAR02) + "'  %" //Seleciona periodo pedidos de compras SC7
cFiltro1		:= "% AND ZS_LIBERAD = 'P' AND ZS_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "'  AND '" + DTOS(MV_PAR02) + "'  %" //Seleciona periodo nas autorizações de pagamento SZS
cCampo1			:= "ZY_MES" + SUBSTR(DTOS(MV_PAR01),5,2)
cCampo2			:= "ZY_USO" + SUBSTR(DTOS(MV_PAR01),5,2)

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//Query para selecionar os pedidos aprovados pela Sra. Elenn com natureza, nome do fornecedor, condição de pagamento e centro de custo
SELECT CR_TIPO AS TIPO, C7_NUM AS CODIGO, C7_EMISSAO AS EMISSAO, ED_DESCRIC AS NATUREZA, A2_NOME AS FORNECEDOR, ZL_PEDORC AS ORCADO, SUM(C7_TOTAL) AS VALOR, E4_DESCRI AS CONDPAG
, (SELECT CTT_DESC01 FROM %table:CTT% WHERE C7_CC = CTT_CUSTO AND %table:CTT%.D_E_L_E_T_ = '') AS CCUSTO
, CR_USER AS APROVADOR, CR_NIVEL AS NIVEL, ED_CONTSIG AS SIG, CR_TOTAL AS VLAPROV, CR_DATALIB AS DTLIB, C7_OBS AS HISTORICO, C7_USER AS SOLICITANTE
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND %table:SC1%.D_E_L_E_T_ = ''
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND %table:SA2%.D_E_L_E_T_ = ''
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ = ''
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND AND %table:SE4%.D_E_L_E_T_ = ''
INNER JOIN %table:SCR% ON (CR_NUM = C7_NUM  AND CR_TIPO = 'PC' AND C7_TIPO = '1' OR CR_NUM = C7_NUM  AND CR_TIPO = 'AE' AND C7_TIPO = '2') AND %table:SCR%.D_E_L_E_T_ = ''
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM
WHERE %table:SC7%.D_E_L_E_T_ = ''
%exp:cFiltro%
GROUP BY CR_TIPO, C7_NUM, C7_EMISSAO, ED_DESCRIC, A2_NOME, ZL_PEDORC, E4_DESCRI, C7_CC, CR_USER, CR_NIVEL, ED_CONTSIG, CR_TOTAL,CR_DATALIB, C7_OBS, C7_USER
UNION
SELECT 'A1' AS TIPO, ZS_CODIGO AS PEDIDO, ZS_EMISSAO AS EMISSAO, ZS_NMNAT AS NATUREZA, ZS_NOME AS FORNECEDOR, '' AS ORCADO, ZS_VALOR AS VALOR, 'A VISTA' AS CONDPAG
,ZS_NMDEP AS CCUSTO, CR_USER AS APROVADOR, CR_NIVEL AS NIVEL, ED_CONTSIG AS SIG, CR_TOTAL AS VLAPROV, CR_DATALIB AS DTLIB, '' AS HISTORICO, ZS_SOLICIT AS SOLICITANTE
FROM %table:SZS%
INNER JOIN %table:SED% ON ZS_NATUREZ = ED_CODIGO  AND %table:SED%.D_E_L_E_T_ = ''
INNER JOIN %table:SCR% ON CR_NUM = ZS_CODIGO AND CR_TIPO = 'A1' AND %table:SCR%.D_E_L_E_T_ = ''
WHERE %table:SZS%.D_E_L_E_T_ = ''
%exp:cFiltro1%
ORDER BY EMISSAO, CODIGO, NIVEL

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Registros") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Registros",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"EMISSAO",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
		oFWMsExcel:AddColumn("Registros",cNomeTabela,"TIPO",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"NUMERO",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"NATUREZA",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"FORNECEDOR",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"DESCRIÇÃO",1,1)
		oFWMsExcel:AddColumn("Registros",cNomeTabela,"ORÇADO",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"VALOR PEDIDO",3,3)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"PREVISÃO ORÇAMENTARIA",3,3)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"SALDO APÓS APROVAÇÃO",3,3)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"CONDIÇÃO DE PAGAMENTO",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"SOLICITANTE",1,1)
		oFWMsExcel:AddColumn("Registros",cNomeTabela,"DEP. SOLICITANTE",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"APROVADOR01",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"LIBERACAO01",1,1)
		oFWMsExcel:AddColumn("Registros",cNomeTabela,"APROVADOR02",1,1)
        oFWMsExcel:AddColumn("Registros",cNomeTabela,"LIBERACAO02",1,1)



While !(cAlias)->(Eof())

//Verifico o historico do pedido na tabela SZL, faço o tratamento do campo memo
						IF !EMPTY(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1")) .AND. TIPO == "PC"
							cDescricao	:= MemoLine(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1"),100,1)
							IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1"),101,100)))
								cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1"),100,2)
								IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1"),201,100)))
									cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + CODIGO,"ZL_OBS1"),100,3)
								ENDIF
							ENDIF
						ENDIF

						IF !EMPTY(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI")) .AND. TIPO == "A1"
							cDescricao	:= MemoLine(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI"),100,1)
							IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI"),101,100)))
								cDescricao	+= MemoLine(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI"),100,2)
								IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI"),201,100)))
									cDescricao	+= MemoLine(Posicione("SZS",1,xFilial("SZS") + CODIGO,"ZS_HISTORI"),100,3)
								ENDIF
							ENDIF
						ENDIF

							IF PswSeek( SOLICITANTE, .T. ) .AND. TIPO <> "A1"
							aUsuario := PswRet() // Retorna vetor com informações do usuário
							cSolicitante 	:= UPPER(Alltrim(aUsuario[1][4]))
								ELSE
								cSolicitante := SOLICITANTE

								ENDIF




						IF TIPO == "AE"
						cDescricao	:= HISTORICO
						ENDIF

						IF ORCADO == "1"
						cOrcado := "SIM"
						Else
						cOrcado := "NÃO"
						ENDIF


	nPrevisão := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(EMISSAO,1,4),@cCampo1)
	nSaldo	  := (Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(emissao,1,4),@cCampo1) - Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(EMISSAO,1,4),@cCampo2) - VLAPROV)


				IF PswSeek( APROVADOR, .T. ) .AND. NIVEL == "01"
				aUsuario := PswRet() // Retorna vetor com informações do usuário
				cAprov01 	:= UPPER(Alltrim(aUsuario[1][4]))
			    cLib01	    := DTOC(STOD(DTLIB))

				ELSEIF PswSeek( APROVADOR, .T. ) .AND. NIVEL == "03"
				aUsuario := PswRet() // Retorna vetor com informações do usuário
				cAprov02 := UPPER(Alltrim(aUsuario[1][4]))
				cLib02	 := DTOC(STOD(DTLIB))

		    	ENDIF

	IF NIVEL == "01"  //nPedido	<> ALLTRIM(TIPO + CODIGO)
	//Criando as Linhas - Utilizando array no logar de criar as linhas diretamente no excel
	aAdd(aRegistros,{DTOC(STOD(EMISSAO)),TIPO,CODIGO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VLAPROV,nPrevisão,nSaldo,CONDPAG,cSolicitante,CCUSTO,cAprov01,cLib01,"",""})
    //oFWMsExcel:AddRow("Registros",cNomeTabela,{DTOC(STOD(EMISSAO)),TIPO,CODIGO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VLAPROV,nPrevisão,nSaldo,CONDPAG,CCUSTO,cAprov01,cLib01,cAprov02,cLib02})
	nLin += 1

	ELSE

	aRegistros[nLin][16] := cAprov02
	aRegistros[nLin][17] := cLib02

	ENDIF

	nPedido			:= ALLTRIM(TIPO + CODIGO)

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

	//Zerar as variaveis
cDescricao		:= ""
cOrcado			:= ""
nPrevisao		:= 0
nSaldo			:= 0
cAprov01		:= ""
cLib01			:= ""
cAprov02        := ""
cLib02			:= ""
nPedido			:= ""

Enddo

	(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

	For i:=1 to Len(aRegistros)

	 oFWMsExcel:AddRow("Registros",cNomeTabela,aRegistros[i])

	Next

	oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	RestArea(aArea)

Return

//Programa usado para criar perguntas na tabela SX1 (Tabela de perguntas)
Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Data Inicial:  	","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data Final:  	","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})


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
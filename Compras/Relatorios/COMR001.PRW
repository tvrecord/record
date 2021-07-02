#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Rafael França - 28/10/2020 - Relatorio de mapas para liberação de acordo com modelo estabelecido pelo compras
//SIGACOM -> Relatorios -> Especificos -> Mapas para Liberação

User Function COMR001()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    		:= GetTempPath()+'COMR001.xml'

Private cPerg  			:= "COMR001"
Private cFiltro			:= ""
Private cNomeTabela		:= ""
Private cNomeTabela1	:= ""
Private cDescricao		:= ""
Private cOrcado			:= ""
Private cPDiaSem  		:= ""
Private cUDiaSem		:= ""
Private cCampo1			:= ""
Private cCampo2			:= ""
Private nPrevisao		:= 0
Private nSaldo			:= 0
Private cSubTot			:= ""
Private nSubTot			:= 0
Private nTotal			:= 0
Private n

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

/*
IF MV_PAR02 == 1
//VERIFICO O PRIMEIRO E O ULTIMO DIA DA SEMANA PARA USAR NO FILTRO
For n := 0 To 7
   If Dow(MV_PAR01 - n) == 1
     cPDiaSem := DTOS(MV_PAR01 - n)
     cUDiaSem := DTOS(MV_PAR01 - n + 7)
   EndIf
Next
ELSEIF MV_PAR02 == 2
//FILTRO PEDIDOS EM ABERTO PARA O DIRETOR NOS ULTIMOS 45 DIAS
     cPDiaSem := DTOS(MV_PAR01 - 60)
     cUDiaSem := DTOS(MV_PAR01 + 5)
ENDIF
*/
//Rafael França - 30/03/21 - Alterado a disposição dos parametros, agora será controle lado por periodo defindo por usuario.
     cPDiaSem := DTOS(MV_PAR01)
     cUDiaSem := DTOS(MV_PAR02)


//TRATO AS PERGUNTAS PARA USO NOS FILTROS
IF MV_PAR03 == 1
cNomeTabela		:= "MAPAS PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(STOD(cPDiaSem)) + " - " + DTOC(STOD(cUDiaSem))
cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND C7_TIPO = '1' AND CR_APROV = '000001' AND CR_TOTAL BETWEEN 1000 AND 10000 %" //Aprovados pela Sra. Elenn durante a semana --ALTERADO O CR_APROV PARA O 000032 DA LUCILENE e diminuido o valor para 4 mil
ELSEIF MV_PAR03 == 2
cNomeTabela		:= "MAPAS PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(MV_PAR01)
cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND CR_APROV = '000028' AND CR_DATALIB = '' %" //Apenas pedidos enviados para aprovação do diretor
ELSEIF MV_PAR03 == 3
cNomeTabela		:= "MAPAS PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(STOD(cPDiaSem)) + " - " + DTOC(STOD(cUDiaSem))
cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND C7_TIPO = '1' AND CR_APROV = '000001' %"
ENDIF

cCampo1			:= "ZY_MES" + SUBSTR(DTOS(MV_PAR01),5,2)
cCampo2			:= "ZY_USO" + SUBSTR(DTOS(MV_PAR01),5,2)

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//Query para selecionar os pedidos aprovados pela Sra. Elenn com natureza, nome do fornecedor, condição de pagamento e centro de custo
SELECT C7_NUM AS PEDIDO, ED_DESCRIC AS NATUREZA, A2_NOME AS FORNECEDOR, ZL_PEDORC AS ORCADO, SUM(C7_TOTAL) AS VALOR, E4_DESCRI AS CONDPAG
, (SELECT CTT_DESC01 FROM CTT010 WHERE C7_CC = CTT_CUSTO AND CTT010.D_E_L_E_T_ = '') AS CCUSTO
, CR_APROV AS APROVADOR, ED_CONTSIG AS SIG, CR_TOTAL AS VLAPROV
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1010.D_E_L_E_T_ = ''
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2010.D_E_L_E_T_ = ''
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO AND SED010.D_E_L_E_T_ = ''
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND AND SE4010.D_E_L_E_T_ = ''
INNER JOIN %table:SCR% ON (CR_NUM = C7_NUM  AND CR_TIPO = 'PC' AND C7_TIPO = '1' OR CR_NUM = C7_NUM  AND CR_TIPO = 'AE' AND C7_TIPO = '2') AND SCR010.D_E_L_E_T_ = ''
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM
WHERE SC7010.D_E_L_E_T_ = ''
%exp:cFiltro%
GROUP BY C7_NUM, ED_DESCRIC, A2_NOME, ZL_PEDORC, E4_DESCRI, C7_CC, CR_APROV, ED_CONTSIG, CR_TOTAL
ORDER BY PEDIDO

EndSql //FINALIZO A MINHA QUERY

IF MV_PAR04 == 1

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Mapas
    oFWMsExcel:AddworkSheet("Mapas") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Mapas",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"PEDIDO",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"NATUREZA",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"FORNECEDOR",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"DESCRIÇÃO",1,1)
		oFWMsExcel:AddColumn("Mapas",cNomeTabela,"ORÇADO",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"VALOR PEDIDO",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"PREVISÃO ORÇAMENTARIA",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"SALDO APÓS APROVAÇÃO",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"CONDIÇÃO DE PAGAMENTO",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"SOLICITANTE",1,1)

While !(cAlias)->(Eof())

//Verifico o historico do pedido na tabela SZL, faço o tratamento do campo memo
						IF !EMPTY(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"))
							cDescricao	:= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,1)
							IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),101,100)))
								cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,2)
								IF !EMPTY(ALLTRIM(SUBSTR(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),201,100)))
									cDescricao	+= MemoLine(Posicione("SZL",2,xFilial("SZL") + PEDIDO,"ZL_OBS1"),100,3)
								ENDIF
							ENDIF
						ENDIF

						IF ORCADO == "1"
						cOrcado := "SIM"
						Else
						cOrcado := "NÃO"
						ENDIF

	nPrevisão := Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(cUDiaSem,1,4),@cCampo1)
	nSaldo	  := (Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(cUDiaSem,1,4),@cCampo1) - Posicione("SZY",1,xFilial("SZY")+PADR(Alltrim(SIG),6)+SUBSTR(cUDiaSem,1,4),@cCampo2) - VLAPROV)

	//Criando as Linhas
    oFWMsExcel:AddRow("Mapas",cNomeTabela,{PEDIDO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VLAPROV,nPrevisão,nSaldo,CONDPAG,CCUSTO})

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

	(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

BeginSql Alias cAlias

//Query para selecionar os totais dos pedidos aprovados pela Sra. Elenn por centro de custo
SELECT (SELECT CTT_DESC01 FROM CTT010 WHERE C7_CC = CTT_CUSTO AND CTT010.D_E_L_E_T_ = '') AS CCUSTO, C7_NUM AS PEDIDO, SUM(C7_TOTAL) AS VALOR
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND
INNER JOIN %table:SCR% ON CR_NUM = C7_NUM
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM
WHERE SC7010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND SE4010.D_E_L_E_T_ = '' AND SCR010.D_E_L_E_T_ = ''
%exp:cFiltro%
GROUP BY C7_CC, C7_NUM
ORDER BY CCUSTO

EndSql //FINALIZO A MINHA QUERY

		oFWMsExcel:AddworkSheet("Totais")
        //Criando a Tabela
        oFWMsExcel:AddTable("Totais",cNomeTabela)
        //Criando Colunas
		oFWMsExcel:AddColumn("Totais",cNomeTabela,"DEPARTAMENTO SOLICITANTE",1,1)
        oFWMsExcel:AddColumn("Totais",cNomeTabela,"TOTAL",3,3)

While !(cAlias)->(Eof())

	If cSubTot <> CCUSTO .AND. cSubTot <> ""

	//Criando as Linhas
    oFWMsExcel:AddRow("Totais",cNomeTabela,{cSubTot,nSubTot})
	nSubTot			:= 0

	EndIf

	cSubTot			:= CCUSTO
	nSubTot			+= VALOR
	nTotal			+= VALOR

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

	//Adiciona a ultima linha com subtotal
	oFWMsExcel:AddRow("Totais",cNomeTabela,{cSubTot,nSubTot})
	//Adiciona os totais
  	oFWMsExcel:AddRow("Totais",cNomeTabela,{"TOTAL",nTotal})

	(cAlias)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	RestArea(aArea)

	ELSEIF MV_PAR04 == 2

	ENDIF

Return

//Programa usado para criar perguntas na tabela SX1 (Tabela de perguntas)
Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Data Inicial:  		","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Data Final: 	 	","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Tipo:            	","","","mv_ch03","N",01,0,1,"C","","mv_par03","Lib. Gerência","","","","","Pend. Diretor","","","","","Todos","","","","","","","","","","","","","","" })
	AADD(aRegs,{cPerg,"04","Formato:           	","","","mv_ch04","N",01,0,1,"C","","mv_par04","Planilha","","","","","PDF","","","","","","","","","","","","","","","","","","","" })

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
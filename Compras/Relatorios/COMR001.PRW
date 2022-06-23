#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

//Rafael França - 28/10/2020 - Relatorio de mapas para liberação de acordo com modelo estabelecido pelo compras
//SIGACOM -> Relatorios -> Especificos -> Mapas para Liberação

#DEFINE REL_VERT_STD 12
#DEFINE REL_START 65
#DEFINE REL_END 500
#DEFINE REL_RIGHT 820
#DEFINE REL_LEFT 10

User Function COMR001()

// Abaixo variaveis usadas para criação de relatorio em formato xml
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'COMR001.xml'
Private cAlias1 	:= GetNextAlias() //Declarei meu ALIAS
Private cAlias2		:= GetNextAlias() //Declarei meu ALIAS da segunda consulta SQL

//Abaixo variaveis criadas para uso especifico do relatorio
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
Private oPrint
Private cSubTitle	:= ""
Private nPag 		:= 0
Private nLin 		:= 0
Private nLinF 		:= 0
Private nLinD 		:= 0
Private oFonte 		:= u_xFonte(06,,,,"Arial")
Private oFonteN 	:= u_xFonte(06,.T.,,,"Arial")
Private oFonte10 	:= u_xFonte(10,,,,"Arial")
Private oFonte10N 	:= u_xFonte(10,.T.,,,"Arial")

//Variaveis para impressão em PDF / MV_PAR04 == 2

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou, em caso de cancelamento fecha o programa e retorna
		MsgAlert("Operação Cancelada!")
		RestArea(aArea)
		Return //Retorna a tela anterior e fecha o relatorio
	EndIf

//Rafael França - 30/03/21 - Alterado a disposição dos parametros, agora será controlado por periodo defindo por usuario.
     cPDiaSem := DTOS(MV_PAR01)
     cUDiaSem := DTOS(MV_PAR02)


//TRATO AS PERGUNTAS PARA USO NOS FILTROS
IF MV_PAR03 == 3
	cNomeTabela		:= "MAPAS PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)
	cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND C7_TIPO = '1' AND CR_APROV = '000001' %"
ELSE
	cNomeTabela		:= "MAPAS LIBERADOS PELA GERÊNCIA DE " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)
	IF MV_PAR08 == 1
		cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND C7_TIPO = '1' %" //Aprovados pela Sra. Elenn durante a semana --ALTERADO O CR_APROV PARA O 000032 DA LUCILENE e diminuido o valor para 4 mil
	ELSE
		cFiltro			:= "%AND CR_DATALIB BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND C7_TIPO = '1' %" //Aprovados pela Sra. Elenn durante a semana --ALTERADO O CR_APROV PARA O 000032 DA LUCILENE e diminuido o valor para 4 mil
	ENDIF
ENDIF
/*   Pedro L - (23/06/2022) - Todos os pedidos de compras passam a serem liberados exclusivamente pela Dona Elenn. E enviado para conhecimento do diretor
ELSEIF MV_PAR03 == 2
cNomeTabela		:= "MAPAS PARA LIBERAÇÃO NO MICROSIGA - " + DTOC(MV_PAR01) + " - " + DTOC(MV_PAR02)
cFiltro			:= "%AND C7_EMISSAO BETWEEN '"+cPDiaSem+"' AND '"+cUDiaSem+"' AND CR_APROV = '000028' AND CR_DATALIB = '' %" //Apenas pedidos enviados para aprovação do diretor
*/



cCampo1			:= "ZY_MES" + SUBSTR(DTOS(MV_PAR01),5,2)
cCampo2			:= "ZY_USO" + SUBSTR(DTOS(MV_PAR01),5,2)

//Começo minha consulta no SQL e coloco o nome da tabela com cAlias1
BeginSql Alias cAlias1

//Query para selecionar os pedidos aprovados pela Sra. Elenn com natureza, nome do fornecedor, condição de pagamento e unidade requisitante
SELECT C7_NUM AS PEDIDO, ED_DESCRIC AS NATUREZA, A2_NOME AS FORNECEDOR, ZL_PEDORC AS ORCADO, SUM(C7_TOTAL) AS VALOR, E4_DESCRI AS CONDPAG
, (SELECT Y3_DESC FROM SY3010 WHERE C1_UNIDREQ = Y3_COD AND SY3010.D_E_L_E_T_ = '') AS UNIREQ
, CR_APROV AS APROVADOR, ED_CONTSIG AS SIG, CR_TOTAL AS VLAPROV
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND %table:SC1%.D_E_L_E_T_ = ''
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND %table:SA2%.D_E_L_E_T_ = ''
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ = ''
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND AND %table:SE4%.D_E_L_E_T_ = ''
INNER JOIN %table:SCR% ON (CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND C7_TIPO = '1' OR CR_NUM = C7_NUM  AND CR_TIPO = 'AE' AND C7_TIPO = '2') AND %table:SCR%.D_E_L_E_T_ = ''
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM AND %table:SZL%.D_E_L_E_T_ = ''
WHERE %table:SC7%.D_E_L_E_T_ = ''
%exp:cFiltro%
GROUP BY C7_NUM, ED_DESCRIC, A2_NOME, ZL_PEDORC, E4_DESCRI, C1_UNIDREQ, CR_APROV, ED_CONTSIG, CR_TOTAL
ORDER BY PEDIDO

EndSql //FINALIZO A MINHA QUERY

BeginSql Alias cAlias2

//Query para selecionar os totais dos pedidos aprovados pela Sra. Elenn por centro de custo
SELECT (SELECT Y3_DESC FROM SY3010 WHERE C1_UNIDREQ = Y3_COD AND SY3010.D_E_L_E_T_ = '') AS UNIREQ, SUM(C7_TOTAL) AS VALOR
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND %table:SC1%.D_E_L_E_T_ = ''
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND %table:SA2%.D_E_L_E_T_ = ''
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO AND %table:SED%.D_E_L_E_T_ = ''
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND AND %table:SE4%.D_E_L_E_T_ = ''
INNER JOIN %table:SCR% ON (CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND C7_TIPO = '1' OR CR_NUM = C7_NUM  AND CR_TIPO = 'AE' AND C7_TIPO = '2') AND %table:SCR%.D_E_L_E_T_ = ''
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM AND %table:SZL%.D_E_L_E_T_ = ''
WHERE %table:SC7%.D_E_L_E_T_ = ''
%exp:cFiltro%
GROUP BY C1_UNIDREQ
ORDER BY UNIREQ

EndSql //FINALIZO A MINHA QUERY

IF MV_PAR04 == 1 //Se o relatorio for no formato planilha excel

If !ApOleClient("MsExcel") //Verifica se o Excel esta instalado no computador
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return //Retorna a tela anterior e fecha o relatorio
EndIf

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //oFWMsExcel:AddworkSheet - Cria uma aba na planilha "Mapas"
    oFWMsExcel:AddworkSheet("Mapas") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //oFWMsExcel:AddTable - Criando a Tabela com o nome da variavel cNomeTabela
        oFWMsExcel:AddTable("Mapas",cNomeTabela)
        //oFWMsExcel:AddColumn - Criando Colunas dentro da Aba "Mapas" e da tabela cNomeTabela
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

DBSelectArea(cAlias1)
DbGotop()
While !(cAlias1)->(Eof())

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

	//oFWMsExcel:AddRow - Criando as Linhas na aba "Mapas" tabela cNomeTabela e na ordem estabelecida das colunas
    oFWMsExcel:AddRow("Mapas",cNomeTabela,{PEDIDO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VLAPROV,nPrevisão,nSaldo,CONDPAG,UNIREQ})

	(cAlias1)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

	(cAlias1)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

//Crio uma nova aba para gravação dos totais  (Alias2)

		oFWMsExcel:AddworkSheet("Totais")
        //Criando a Tabela
        oFWMsExcel:AddTable("Totais",cNomeTabela)
        //Criando Colunas
		oFWMsExcel:AddColumn("Totais",cNomeTabela,"DEPARTAMENTO SOLICITANTE",1,1)
        oFWMsExcel:AddColumn("Totais",cNomeTabela,"TOTAL",3,3)

DBSelectArea(cAlias2)
DbGotop()
While !(cAlias2)->(Eof())

	//If cSubTot <> UNIREQ .AND. cSubTot <> ""

	//Criando as Linhas
    oFWMsExcel:AddRow("Totais",cNomeTabela,{UNIREQ,VALOR})
	//nSubTot			:= 0

	//EndIf

	//cSubTot			:= UNIREQ
	//nSubTot			+= VALOR
	nTotal			+= VALOR

	(cAlias2)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

(cAlias2)->(dbClosearea()) 				//FECHO A TABELA APOS O USO

	//Adiciona a ultima linha com subtotal
	oFWMsExcel:AddRow("Totais",cNomeTabela,{cSubTot,nSubTot})
	//Adiciona os totais
  	oFWMsExcel:AddRow("Totais",cNomeTabela,{"TOTAL",nTotal})

    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)

    //Abrindo o excel e abrindo o arquivo xml
    oExcel:= MsExcel():New()            	//Abre uma nova conexão com Excel
    oExcel:WorkBooks:Open(cArquivo)     	//Abre uma planilha
    oExcel:SetVisible(.T.)              	//Visualiza a planilha
    oExcel:Destroy()                    	//Encerra o processo do gerenciador de tarefas

	RestArea(aArea)

	Return

	ELSEIF MV_PAR04 == 2

fProcPdf()

ENDIF

Static Function fProcPdf()

	Local nTotal    := 0
	Local nRegAtu	:= 0
	Local nTotReg	:= 0
	Local cDir 		:= Alltrim(MV_PAR07) + "\"
	Local cAssin1 	:= ""
	Local cAssin2 	:= ""
	Local cCargo1 	:= ""
	Local cCargo2 	:= ""
	Local i

	//Private cPeriodo 	:= SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)
	//Private cPerTitulo	:= SUBSTRING(DTOS(MV_PAR01),5,2) + "/" + SUBSTRING(DTOS(MV_PAR01),1,4)

	// Carrega regua de processamento
	DBSelectArea(cAlias1)
	DbGotop()
	Count To nTotReg
	ProcRegua(nTotReg)

	If nTotReg == 0
		MsgInfo("Não existem registros a serem impressos, favor verificar os parametros","COMR001")
		(cAlias1)->(DbCloseArea())
		Return
	EndIf

	(cAlias1)->(DbGoTop())

	cFileName 	:= "COMR001_MAPAS" + "_" +DTOS(Date())+ "_" + StrTran(Time(),":","_")
	oPrint 		:= FWMSPrinter():New(cFileName, IMP_PDF, .F., cDir, .T.)
	//oPrint:SetPortrait()//Retrato
	oPrint:SetLandScape()//Paisagem
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:cPathPDF := cDir

	ImpProxPag()//Monta cabeçario da primeira e proxima pagina

	While (cAlias1)->(!Eof())

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

	//oFWMsExcel:AddRow - Criando as Linhas na aba "Mapas" tabela cNomeTabela e na ordem estabelecida das colunas
    //oFWMsExcel:AddRow("Mapas",cNomeTabela,{PEDIDO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VLAPROV,nPrevisão,nSaldo,CONDPAG,UNIREQ})

		nRegAtu++
		// Atualiza regua de processamento
		IncProc( "Imprimindo Registro " + cValToChar( nRegAtu ) + " De " + cValToChar( nTotReg ) + " [" + StrZero( Round( ( nRegAtu / nTotReg ) * 100 , 0 ) , 3 ) +"%]" )

		nLinF := nLin
		nLinD := nLin

		oPrint:Say(nLin,020, (cAlias1)->PEDIDO		  				  			  			,oFonte)
		If Empty(SUBSTR((cAlias1)->NATUREZA,25,1))
		oPrint:Say(nLin,050, SUBSTR((cAlias1)->NATUREZA,1,25)					  			,oFonte)
		Else
		oPrint:Say(nLin,050, SUBSTR((cAlias1)->NATUREZA,1,24) + "."				  			,oFonte)
		EndIf

		//Função para quebrar linha sem cortar a palavra.
		For i := 1 To MLCount(ALLTRIM((cAlias1)->FORNECEDOR),35)
     		If !Empty(MLCount(ALLTRIM((cAlias1)->FORNECEDOR),35))
          		If !Empty(MemoLine(ALLTRIM((cAlias1)->FORNECEDOR),35,i))
               	oPrint:Say(nLinF,145,OemToAnsi(MemoLine(ALLTRIM((cAlias1)->FORNECEDOR),35,i)),oFonte)
				nLinF += REL_VERT_STD
          		EndIf
     		EndIf
		Next i

		For i := 1 To MLCount(ALLTRIM(cDescricao),75)
     		If !Empty(MLCount(ALLTRIM(cDescricao),75))
          		If !Empty(MemoLine(ALLTRIM(cDescricao),75,i))
               	oPrint:Say(nLinD,270,OemToAnsi(MemoLine(ALLTRIM(cDescricao),75,i)),oFonte)
				nLinD += REL_VERT_STD
          		EndIf
     		EndIf
		Next i
		//oPrint:Say( nLin,285, ALLTRIM(cDescricao)					  			  			,oFonte)
		oPrint:Say(nLin,530, cOrcado								  			  			,oFonte)
		oPrint:Say(nLin,560, PADR(Transform((cAlias1)->VLAPROV, "@E 9,999,999.99"),12) 		,oFonte)
		oPrint:Say(nLin,615, PADR(Transform(nPrevisão, "@E 9,999,999.99"),12) 				,oFonte)
		oPrint:Say(nLin,670, PADR(Transform(nSaldo, "@E 9,999,999.99"),12) 					,oFonte)
		oPrint:Say(nLin,710, (cAlias1)->CONDPAG					  			  				,oFonte)
		If Empty(SUBSTR((cAlias1)->UNIREQ,20,1))
		oPrint:Say(nLin,750, SUBSTR((cAlias1)->UNIREQ,1,20)			  			  			,oFonte)
		Else
		oPrint:Say(nLin,750, SUBSTR((cAlias1)->UNIREQ,1,19) + "."				  			,oFonte)
		EndIf

		If nLin < nLinD //Verifica se houve necessidade de pular linha para escrever a descrição
		nLin := nLinD + 2
		ElseIf nLinD < nLinF //Verifica se houve a necessidade de pular de linha para imprimir fornecedor, e se ficou maior que a descrição
		nLin := nLinF + 2
		else
		nLin += REL_VERT_STD + 2
		EndIf

		If nLin < nLinF //Verifica se houve a necessidade de pular de linha para imprimir fornecedor, e se ficou maior que a descrição
		nLin := nLinF + 2
		EndIf

		oPrint:Line(nLin-REL_VERT_STD+2,020,nLin-REL_VERT_STD+2,REL_RIGHT)

		If nLin > REL_END
			u_PXRODAPE(@oPrint,"COMR001.PRW","")
			oPrint:EndPage()
			ImpProxPag()//Monta cabeçario da proxima pagina
		EndIf

		nTotal += (cAlias1)->VLAPROV

		(cAlias1)->(DbSkip())

	EndDo

	(cAlias1)->(dbClosearea())

	//Impressão do total de todas as praças
	oPrint:Say( nLin,560, PADR(Transform( nTotal, "@E 9,999,999.99"),12),oFonteN)
	nLin += (REL_VERT_STD * 4)

		//Imprime linha das assinaturas
	If !Empty(MV_PAR05) //.and. FWSFALLUSERS(MV_PAR05,.T.)
		oPrint:Say(nLin,024, "_________________________" ,oFonte10N)
		aUsuario := FWSFALLUSERS({MV_PAR05}) // Retorna vetor com informações do usuário
		cAssin1 := Alltrim(aUsuario[1][4])
		cCargo1 := Alltrim(aUsuario[1][7])
		nLin += REL_VERT_STD
		oPrint:Say(nLin,024, PADC(cAssin1,40) ,oFonte10)
		nLin += REL_VERT_STD
		oPrint:Say(nLin,024, PADC(cCargo1,33) ,oFonte10N)
	EndIf

	If !Empty(MV_PAR06) .and. !Empty(MV_PAR05) //.and. FWSFALLUSERS(MV_PAR06,.T.)
		nLin -= (REL_VERT_STD*2)
		oPrint:Say(nLin,175, "_________________________" ,oFonte10N)
		aUsuario := FWSFALLUSERS({MV_PAR06})// Retorna vetor com informações do usuário
		cAssin2 := Alltrim(aUsuario[1][4])
		cCargo2 := Alltrim(aUsuario[1][7])
		nLin += REL_VERT_STD
		oPrint:Say(nLin,175, PADC(cAssin2,40) ,oFonte10)
		nLin += REL_VERT_STD
		oPrint:Say(nLin,175, PADC(cCargo2,33) ,oFonte10N)
	EndIf

	nLin += REL_VERT_STD

//Imprime os totais do relatorio
	DBSelectArea(cAlias2)
	DbGotop()
	Count To nTotReg

	nLin 	:= nLin - (REL_VERT_STD * 3)
	nLinF	:= nLin + (REL_VERT_STD * (nTotReg+2))

	oPrint:Box(nLin,600,nLinF+6,REL_RIGHT) //Quadrado dos totais
	oPrint:Box(nLin+REL_VERT_STD+4,600,nLinF+4-REL_VERT_STD,REL_RIGHT) //Linhas de Cabeçalho e total
	oPrint:Line(nLin,730,nLinF+6,730) //Linha divisoria central Departamento/Total

	nLin += REL_VERT_STD

	oPrint:Say(nLin,610,"DEPARTAMENTO"	  		,oFonteN)
	oPrint:Say(nLin,795,PADR("TOTAL",10)		,oFonteN)

	nLin += REL_VERT_STD

	DBSelectArea(cAlias2)
	DbGotop()
	While !(cAlias2)->(Eof())

	oPrint:Say(nLin,610,(cAlias2)->UNIREQ		  								,oFonte)
	oPrint:Say(nLin,790,PADR(Transform((cAlias2)->VALOR, "@E 9,999,999.99"),12)	,oFonte)

	nLin += REL_VERT_STD

	(cAlias2)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

	Enddo

	oPrint:Say(nLin,610,"TOTAL"	  									,oFonteN)
	oPrint:Say(nLin,790,PADR(Transform(nTotal, "@E 9,999,999.99"),12)	,oFonteN)

	(cAlias2)->(dbClosearea())

	u_PXRODAPE(@oPrint,"COMR001.PRW","")
	oPrint:EndPage()
	oPrint:Preview()

Return

Static Function ImpProxPag()

	nPag++
	oPrint:StartPage()
	cSubTitle := "DEPARTAMENTO: COMPRAS"
	nLin := u_PXCABECA(@oPrint,cNomeTabela,cSubTitle,nPag)

	oPrint:Say( nLin,020, "PEDIDO"				,oFonteN)
	oPrint:Say( nLin,050, "NATUREZA"			,oFonteN)
	oPrint:Say( nLin,145, "FORNECEDOR"			,oFonteN)
	oPrint:Say( nLin,270, "DESCRIÇÃO"			,oFonteN)
	oPrint:Say( nLin,515, "ORÇADO"				,oFonteN)
	oPrint:Say( nLin,560, PADR("VL PEDIDO",12)	,oFonteN)
	oPrint:Say( nLin,615, PADR("PREV ORC.",12)	,oFonteN)
	oPrint:Say( nLin,670, PADR("SALDO",12)		,oFonteN)
	oPrint:Say( nLin,710, "COND PAG."			,oFonteN)
	oPrint:Say( nLin,750, "SOLICITANTE"			,oFonteN)

	oPrint:line(nLin+5,REL_LEFT,nLin+5,REL_RIGHT )

	nLinI 	:= nLin
	nLin 	+= REL_VERT_STD

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
	AADD(aRegs,{cPerg,"05","Assinatura 1:		","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	AADD(aRegs,{cPerg,"06","Assinatura 2:		","","","mv_ch06","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","USR"})
	AADD(aRegs,{cPerg,"07","Destino Arquivo:	","","","mv_ch07","C",60,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Filtra Por:			","","","mv_ch08","N",01,0,1,"C","","mv_par08","Emissão","","","","","Liberação","","","","","","","","","","","","","","","","","","",""})

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
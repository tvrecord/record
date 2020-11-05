#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Rafael Fran�a - 28/10/2020 - Relatorio de mapas para libera��o
//SIGACOM -> Relatorios -> Especificos -> Mapas para Libera��o

User Function COMR001()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'COMR001.xml'

Private cPerg  		:= "COMR001"
Private cNomeTabela	:= ""
Private cDescricao	:= ""
Private cOrcado		:= ""

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIA��O DAS PERGUNTAS

	Pergunte(cPerg,.T.) //FAZ A PERGUNTA PARA USUARIO

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cNomeTabela	:= UPPER("MAPAS PARA LIBERA��O NO MICROSIGA - " + DTOC(MV_PAR01))

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//Query para selecionar os pedidos aprovados pela Sra. Elenn com natureza, nome do fornecedor, condi��o de pagamento e centro de custo
SELECT C7_NUM AS PEDIDO, ED_DESCRIC AS NATUREZA, A2_NOME AS FORNECEDOR, ZL_PEDORC AS ORCADO, SUM(C7_TOTAL) AS VALOR, E4_DESCRI AS CONDPAG
, (SELECT CTT_DESC01 FROM CTT010 WHERE C7_CC = CTT_CUSTO AND CTT010.D_E_L_E_T_ = '') AS CCUSTO
, CR_APROV AS APROVADOR
FROM %table:SC7%
INNER JOIN %table:SC1% ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC
INNER JOIN %table:SA2% ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA
INNER JOIN %table:SED% ON C1_NATUREZ = ED_CODIGO
INNER JOIN %table:SE4% ON E4_CODIGO = C7_COND
INNER JOIN %table:SCR% ON CR_NUM = C7_NUM
FULL OUTER JOIN %table:SZL% ON ZL_PEDIDO = C7_NUM
WHERE SC7010.D_E_L_E_T_ = '' AND SC1010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND SE4010.D_E_L_E_T_ = '' AND SCR010.D_E_L_E_T_ = ''
AND C7_EMISSAO BETWEEN '20201102' AND '20201106' AND C7_TIPO = '1'
//AND CR_APROV = '000028' AND CR_DATALIB = '' //Apenas pedidos enviados para aprova��o do diretor
GROUP BY C7_NUM, ED_DESCRIC, A2_NOME, ZL_PEDORC, E4_DESCRI, C7_CC, CR_APROV
//HAVING SUM(C7_TOTAL) BETWEEN 1000 AND 10000 //Pedidos entre R$ 1.000,00 e R$ 10.000,00
ORDER BY PEDIDO

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Mapas") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Mapas",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"PEDIDO",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"NATUREZA",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"FORNECEDOR",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"DESCRI��O",1,1)
		oFWMsExcel:AddColumn("Mapas",cNomeTabela,"OR�ADO",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"VALOR PEDIDO",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"PREVIS�O OR�AMENTARIA",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"SALDO AP�S ARPOVA��O",3,3)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"CONDI��O DE PAGAMENTO",1,1)
        oFWMsExcel:AddColumn("Mapas",cNomeTabela,"SOLICITANTE",1,1)

While !(cAlias)->(Eof())

//Verifico o historico do pedido na tabela SZL, fa�o o tratamento do campo memo
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
						cOrcado := "N�O"
						ENDIF

	IF MV_PAR02 == 1 .AND. VALOR > 1000 .AND. VALOR <= 10000 .AND. APROVADOR == "000001" //Pedidos entre R$ 1.000,00 e R$ 10.000,00 aprovados pela Sra. Elenn

	//Criando as Linhas
    oFWMsExcel:AddRow("Mapas",cNomeTabela,{PEDIDO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VALOR,0,0,CONDPAG,CCUSTO})

	ElseIf MV_PAR02 == 2 .AND. APROVADOR == "000028" //Apenas pedidos enviados para aprova��o do diretor

//Criando as Linhas
	oFWMsExcel:AddRow("Mapas",cNomeTabela,{PEDIDO,NATUREZA,FORNECEDOR,UPPER(cDescricao),cOrcado,VALOR,0,0,CONDPAG,CCUSTO})

	EndIf

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

	AADD(aRegs,{cPerg,"01","Data Refer�ncia:  	","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Tipo            	","","","mv_ch02","N",01,0,1,"C","","mv_par02","Liberados Elenn","","","","","Libera��o Diretor","","","","","","","","","","","","","","","","","","","" })

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
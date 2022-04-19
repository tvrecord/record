#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relatório para extrair o vencimento dos exames periódicos dos funcionários
//SIGAGPE -> Relatorios -> Especificos Record -> Venc. Exame Periódico


User Function GPER003()

Local cAlias1 		:= GetNextAlias()
Local cAlias2 		:= GetNextAlias()
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER003.xml'

Private cPerg  		:= "GPER003"
Private cNomeTabela	:= ""
Private cFiltro		:= ""
Private nColTot		:= 0
Private nTamanho	:= 1
Private nColuna		:= 0
Private nTipo		:= 1
Private aCampos		:= {}
Private aCells		:= {}

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou
		MsgAlert("Operação Cancelada!")
		RestArea(aArea)
		Return
	EndIf

	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel não instalado.")  //"Microsoft Excel nao instalado."
		RestArea(aArea)
		Return
	EndIf

	//TRATO AS PERGUNTAS PARA USO NOS FILTROS
	cNomeTabela	:= UPPER("Tabela RCB")
	//cFiltro		:= "%  AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+ "' AND RA_EXAMEDI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' %" //Filtro MATRÍCULA e período solicitado nos parametros

	//COMEÇO A MINHA CONSULTA SQL
	BeginSql Alias cAlias1

		//Query que busca a estrutura da tabela RCB
		SELECT RCB_CODIGO, RCB_DESC, RCB_ORDEM, RCB_CAMPOS, RCB_DESCPO, RCB_TIPO, RCB_TAMAN, RCB_DECIMA
		FROM RCB010
		WHERE RCB010.D_E_L_E_T_ = ''
		AND RCB_CODIGO = %exp:MV_PAR01%

	EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()
    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet(MV_PAR01) //Não utilizar número junto com sinal de menos. Ex.: 1-
    //Criando a Tabela
    oFWMsExcel:AddTable(MV_PAR01,cNomeTabela)
    //Criando Colunas
	//oFWMsExcel:AddColumn(MV_PAR01,cNomeTabela,"Sequencia",nTipo,nTipo) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$

	While !(cAlias1)->(Eof())

		IF (cAlias1)->RCB_TIPO == "N"
			nTipo := 2
		ELSE
			nTipo := 1
		ENDIF

		aAdd(aCampos,{(cAlias1)->RCB_ORDEM,;	//01 - Ordem
		ALLTRIM((cAlias1)->RCB_CAMPOS),;		//02 - Campo
		(cAlias1)->RCB_TIPO,;					//03 - Tipo
		nTamanho,;								//04 - Coluna Inicial
		(cAlias1)->RCB_TAMAN})					//05 - Coluna Final

		nTamanho += (cAlias1)->RCB_TAMAN
		nColTot	 += 1

        oFWMsExcel:AddColumn(MV_PAR01,cNomeTabela,ALLTRIM((cAlias1)->RCB_CAMPOS),nTipo,nTipo) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$

		(cAlias1)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

	Enddo

	(cAlias1)->(DbCloseArea())

	BeginSql Alias cAlias2

		//Query que busca a estrutura da tabela RCB
		SELECT RCC_CODIGO, RCC_SEQUEN, RCC_CONTEU
		FROM RCC010
		WHERE RCC010.D_E_L_E_T_ = ''
		AND RCC_CODIGO = %exp:MV_PAR01%

	EndSql //FINALIZO A MINHA QUERY

	While !(cAlias2)->(Eof())

	aCells := Array(nColTot)

		For nColuna := 1 To nColTot
			aCells[nColuna] := SUBSTRING((cAlias2)->RCC_CONTEU,aCampos[nColuna][4],aCampos[nColuna][5])
		Next nColuna

		//Criando Linas
		oFWMsExcel:AddRow(MV_PAR01,cNomeTabela,aClone(aCells))

		(cAlias2)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

	Enddo

	(cAlias2)->(DbCloseArea())

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

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Tabela:		","","","mv_ch01","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","RCB"})

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

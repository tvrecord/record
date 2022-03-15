#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

//Rafael França - 28/10/2020 - Relatorio de controle de banco de horas por periodo
//SIGAPON -> Relatorios -> Especificos Record -> saldo Banco de Horas

User Function PONR001()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'PONR001.xml'

Private cPerg  		:= "PONR001"
Private cMesAnt		:= ""
Private cMesAtu		:= ""
Private nExtraMes	:= 0
Private nFaltaMes	:= 0
Private cMat 		:= ""
Private cNome   	:= ""
Private nSaldoAnt	:= 0
Private nSaldoAtu	:= 0
Private cNomeTabela	:= ""

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
cMesAnt		:= SUBSTRING(DTOS(MonthSub(MV_PAR01, 1)),1,6)
cMesAtu		:= SUBSTRING(DTOS(MV_PAR01),1,6)
cNomeTabela	:= UPPER("Banco de Horas - " + ALLTRIM(MesExtenso(Month(MV_PAR01))))

//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//Query que traz todos coloboradores que tem saldo na SZF, independente da SPI do mês
SELECT ZF_MAT AS MATRICULA, RA_NOME AS NOME, ZF_SALDATU AS SLDANT, PI_PD AS EVENTO, PI_QUANT AS HORAS,
(SELECT P9_TIPOCOD FROM %table:SP9% WHERE PI_PD = P9_CODIGO AND SP9010.D_E_L_E_T_ = '') AS TIPO
FROM %table:SZF%
INNER JOIN %table:SRA% ON ZF_MAT = RA_MAT AND SRA010.D_E_L_E_T_ = ''
FULL OUTER JOIN %table:SPI% ON ZF_MAT = PI_MAT AND SUBSTRING(PI_DATA,1,6) = %exp:cMesAtu% AND SPI010.D_E_L_E_T_ = ''
WHERE SZF010.D_E_L_E_T_ = ''
AND ZF_COMPET = %exp:cMesAnt%  AND ZF_SALDATU <> 0
ORDER BY MATRICULA, TIPO

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Banco de Horas") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Banco de Horas",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"MATRICULA",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"NOME",1,1)
        oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"SLD ATUAL",1,1)
        oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"HORAS EXTRAS",1,1)
		oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"HORAS NEGATIVAS",1,1)
        oFWMsExcel:AddColumn("Banco de Horas",cNomeTabela,"SLD TOTAL",1,1)

While !(cAlias)->(Eof())

PosSP9(EVENTO,xFilial("SP9"),"P9_TIPOCOD")

	 		If SP9->P9_TIPOCOD == "1" //Verifica o tipo de hora 1 = positivo e 2 = negativo
				nExtraMes 	:= SomaHoras(nExtraMes,(cAlias)->HORAS)
			Else //TIPO == "2"
				nFaltaMes   := SomaHoras(nFaltaMes,(cAlias)->HORAS)
			Endif

	IF cMat <> (cAlias)->MATRICULA .AND. cMat <> ""

	nSaldoAtu	:= nSaldoAnt
	nSaldoAtu	:= SomaHoras(nSaldoAtu,nExtraMes)
	nSaldoAtu	:= SubHoras(nSaldoAtu,nFaltaMes)

	//Criando as Linhas
    oFWMsExcel:AddRow("Banco de Horas",cNomeTabela,{cMat,cNome,nSaldoAnt,nExtraMes,nFaltaMes,nSaldoAtu})

	nSaldoAtu	:= 0
	nExtraMes 	:= 0
	nFaltaMes   := 0

	Endif

 	cMat 		:= (cAlias)->MATRICULA
 	cNome   	:= (cAlias)->NOME
	nSaldoAnt	:= (cAlias)->SLDANT

	(cAlias)->(dbSkip()) //PASSAR PARA O PRÓXIMO REGISTRO DA MINHA QUERY

Enddo

	//Calcula e imprime o ultimo registro da tabela
	nSaldoAtu	:= nSaldoAnt
	nSaldoAtu	:= SomaHoras(nSaldoAtu,nExtraMes)
	nSaldoAtu	:= SubHoras(nSaldoAtu,nFaltaMes)

    oFWMsExcel:AddRow("Banco de Horas",cNomeTabela,{cMat,cNome,nSaldoAnt,nExtraMes,nFaltaMes,nSaldoAtu})

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

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Data Referência:  ","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

/*
Static Function ValHora(nValor)

	Local cHora 	:= ""
    Local cMinutos 	:= ""

	cMinutos 	:= STRZERO((nValor - Int(nValor))*100,2)

	If nValor < 0
		If nValor <= -100
			cHora 		:= "-" + cValToChar(Int(nValor)) + ":" + cMinutos
		Else
			cHora 		:= "-" + cValToChar(Int(nValor)) + ":" + cMinutos
		Endif
	Else
		If nValor >= 100
			cHora 		:= cValToChar(Int(nValor)) + ":" + cMinutos
		Else
			cHora 		:= cValToChar(Int(nValor)) + ":" + cMinutos
		Endif
	EndIf

Return cHora
*/
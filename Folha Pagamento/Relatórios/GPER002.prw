#INCLUDE "TOPCONN.CH"
#INCLUDE "protheus.CH"

/*/{Protheus.doc} PXCOMA20
	Relatorio responsavel por imprimir as solicitações inseridas no Portal RH
	@type  Function
	@author Bruno Alves de Oliveira
	@since 04/04/2022
	@version 1.0
/*/


User Function GPER002()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER002.xml'

Private cPerg  		:= "GPER002X"
Private cNomeTabela	:= ""
Private cFiltro		:= ""

	ValidPerg(cPerg) //INICIA A STATIC FUNCTION PARA CRIAÇÃO DAS PERGUNTAS

	If !Pergunte(cPerg) //Verifica se usuario respondeu as perguntas ou cancelou
		MsgAlert("Operação Cancelada!")
		RestArea(aArea)
		Return
	EndIf

/*
If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	RestArea(aArea)
	Return
EndIf
*/

//TRATO AS PERGUNTAS PARA USO NOS FILTROS
cNomeTabela	:= UPPER("Solicitacoes ao RH " )

cFiltro := "% "
cFiltro += "RH3_FILIAL BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND "
cFiltro += "RH3_CODIGO BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' AND "
cFiltro += "RH3_MAT  BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' AND "
cFiltro += "RH3_TIPO  BETWEEN '"+(MV_PAR07)+"' AND '"+(MV_PAR08)+"' AND "
If MV_PAR09 == 2
cFiltro += "RH3_STATUS = '"+Alltrim(STR(MV_PAR10))+"' AND "
EndIf
cFiltro += "RH3_DTSOLI  BETWEEN '"+DTOS(MV_PAR11)+"' AND '"+DTOS(MV_PAR12)+"' AND "
cFiltro += "RH3_DTATEN  BETWEEN '"+DTOS(MV_PAR13)+"' AND '"+DTOS(MV_PAR14)+"' "
cFiltro += "%"
//COMEÇO A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO


SELECT RH3_FILIAL,RH3_CODIGO,RH3_MAT,RA_NOME,X5_DESCRI,RH4_CAMPO,RH4_VALANT,RH4_VALNOV,
CASE
WHEN RH3_STATUS = '1' THEN 'Em processo de aprovação'
WHEN RH3_STATUS = '2' THEN 'Atendida'
WHEN RH3_STATUS = '3' THEN 'Reprovada'
WHEN RH3_STATUS = '4' THEN 'Aguardando Efetivação do RH'
WHEN RH3_STATUS = '5' THEN 'Aguardando Aprovação do RH'
ELSE
''
END AS RH3_STATUS,
RH3_DTSOLI,RH3_DTATEN FROM %table:RH3% RH3
INNER JOIN %table:SRA% SRA ON
RA_FILIAL = RH3_FILIAL AND
RA_MAT = RH3_MAT
INNER JOIN %table:SX5% SX5 ON
X5_TABELA = 'JQ' AND
X5_CHAVE = RH3_TIPO
INNER JOIN %table:RH4% RH4 ON
RH4_FILIAL = RH3_FILIAL AND
RH4_CODIGO = RH3_CODIGO
WHERE
RH4_CAMPO NOT LIKE '%FILIAL%' AND
RH4_CAMPO NOT LIKE '%MAT%' AND
RH4_CAMPO NOT LIKE '%NOME%' AND
RH3.D_E_L_E_T_ = '' AND
SRA.D_E_L_E_T_ = '' AND
SX5.D_E_L_E_T_ = '' AND
RH3.D_E_L_E_T_ = '' AND
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que irá gerar o conteúdo do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("SolRH") //Não utilizar número junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("SolRH",cNomeTabela)
        //Criando Colunas
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Filial",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Codigo",1,1)
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Matricula",1,1)
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Nome",1,1)
		oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Tipo",1,1)

        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Campo",1,1)
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Valor Novo",1,1)
        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Status",1,1)

        oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Data Solicitacao",1,1)
		oFWMsExcel:AddColumn("SolRH",cNomeTabela,"Data Atendida",1,1)


While !(cAlias)->(Eof())



	//Criando as Linhas
    oFWMsExcel:AddRow("SolRH",cNomeTabela,{RH3_FILIAL, RH3_CODIGO, RH3_MAT, Alltrim(RA_NOME), Alltrim(X5_DESCRI), Alltrim(RH4_CAMPO), Alltrim(RH4_VALNOV), RH3_STATUS, DTOC(STOD(RH3_DTSOLI)), DTOC(STOD(RH3_DTATEN))  })



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

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Da Filial:		 ","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"02","Até Filial: 	 ","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"03","Do Codigo:		 ","","","mv_ch03","C",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Até Codigo:	 	 ","","","mv_ch04","C",05,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

	AADD(aRegs,{cPerg,"05","Da Matrícula:	 ","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"06","Até a Matrícula: ","","","mv_ch06","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"07","Do Tipo:		 ","","","mv_ch07","C",01,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","JQ"})
	AADD(aRegs,{cPerg,"08","Até Tipo:		 ","","","mv_ch08","C",01,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","JQ"})

	AADD(aRegs,{cPerg,"09","Todos Status?","","","mv_ch09","N",01,0,0,"C","","mv_par09",;
	"Sim","","","","",;
	"Não","","","","",;
	"","","","","","","","","","","","","","",""})

	AADD(aRegs,{cPerg,"10","Status?","","","mv_ch10","N",01,0,0,"C","","mv_par10",;
	"Processo Aprovação","","","","",;
	"Atendida","","","","",;
	"Reprovada","","","","",;
	"Aguardando Efetivação do RH","","","","",;
	"Aguardando Aprovação do RH","","","","",;
	"","","","","","","","","","","","","","",""})

	AADD(aRegs,{cPerg,"11","Da Dt. Solicit:	 ","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Ate Dt. Solicit: ","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Da Dt. Atendida: ","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","Ate Dt. Atendida:","","","mv_ch14","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

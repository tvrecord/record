#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo -> Relat�rio para extrair o vencimento dos exames peri�dicos dos funcion�rios
//SIGAGPE -> Relatorios -> Especificos Record -> Venc. Exame Peri�dico


User Function GPER001()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'GPER001.xml'

Private cPerg  		:= "GPER001"
Private cNomeTabela	:= ""
Private cFiltro		:= ""

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
cNomeTabela	:= UPPER("Vencimento de Exames Peri�dicos " )
cFiltro		:= "%  AND RA_MAT BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+ "' AND RA_EXAMEDI BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' %" //Filtro MATR�CULA e per�odo solicitado nos parametros

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT RA_MAT AS MATRICULA, RA_NOME AS NOME, RA_CIC AS CPF, RA_RG AS RG
,RA_NASC AS NASCIMENTO
, RA_EXAMEDI AS VENCIMENTO
, CTT_DESC01 AS DEPARTAMENTO, RA_CODFUNC + ' - ' + RJ_DESC AS FUNCAO
FROM  %table:SRA%
INNER JOIN %table:CTT% ON RA_FILIAL = CTT_FILIAL AND RA_CC = CTT_CUSTO AND CTT010.D_E_L_E_T_ <> '*'
INNER JOIN %table:SRJ% ON RA_CODFUNC = RJ_FUNCAO AND SRJ010.D_E_L_E_T_ <> '*'
WHERE SRA010.D_E_L_E_T_ = ''
AND RA_SITFOLH <> 'D'
%exp:cFiltro%

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Exames Peri�dicos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Exames Peri�dicos",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Matr�cula",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Nome",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"CPF",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"RG",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Data_Nascimento",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Data_Vencimento_Peri�dico",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Departamento",1,1)
        oFWMsExcel:AddColumn("Exames Peri�dicos",cNomeTabela,"Fun��o",1,1)

While !(cAlias)->(Eof())



	//Criando as Linhas
    oFWMsExcel:AddRow("Exames Peri�dicos",cNomeTabela,{MATRICULA, NOME, CPF, RG, DTOC(STOD(NASCIMENTO)), DTOC(STOD(VENCIMENTO)), DEPARTAMENTO,FUNCAO})


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

	AADD(aRegs,{cPerg,"01","Da Matr�cula:		","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","At� a Matr�cula:	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Do Vencimento:		","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","At� o Vencimento:	","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

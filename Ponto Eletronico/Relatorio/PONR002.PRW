#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//Pedro Leonardo (25/02/2022) -> Relat�rio para extrair batidas pendentes ou batidas erradas pelo portal meu rh
//SIGAPON -> Relatorios -> Especificos Record -> Marca��es Pendentes


User Function PONR002()

Local cAlias 		:= GetNextAlias() //Declarei meu ALIAS
Local aArea        	:= GetArea()
Local oFWMsExcel
Local oExcel
Local cArquivo    	:= GetTempPath()+'PONR002.xml'

Private cPerg  		:= "PONR002"
Private cNomeTabela	:= ""
Private cFiltro		:= ""
Private cQtd 		:= ""
Private cBatida 	:= ""

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
cNomeTabela	:= UPPER("Marca��es pendentes" )
cFiltro		:= "% AND PC_FILIAL BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"' AND RA_MAT BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+ "' AND CTT_CUSTO BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' AND PC_DATA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' %" //Filtro MATR�CULA e per�odo solicitado nos parametros

//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias

//QUERY QUE BUSCA OS ATIVOS POR DATA DE AQUISICAO

SELECT PC_FILIAL AS FILIAL, PC_CC AS CCUSTO, CTT_DESC01 AS DESCRICAO, PC_MAT AS MATRICULA, RA_NOME AS NOME, R6_TURNO AS TURNO, R6_DESC AS DESCRITURNO
, PC_DATA AS DIA_FALTA
, PC_PD AS COD_OCOR, P9_DESC AS OCORRENCIA, PC_QUANTC AS QTD
, CASE P8_FLAG
WHEN 'G' THEN 'G - GERADO POR ROTINA'
WHEN 'A' THEN 'A - MARCA��O AUTOM�TICA'
WHEN 'I' THEN 'I - ROTINA DE INTEGRADOS OU MARCA��ES'
WHEN 'E' THEN 'E - GERADO POR PONTO ELETR�NICO'
WHEN 'M' THEN 'M - MARCA��O MODIFICADA'
WHEN 'P' THEN 'P - APP MEU RH'
ELSE 'SEM MARCA��O'
END AS TIPO_MARCACAO
, P8_HORA AS BATIDA
,CASE  P8_TPMARCA
WHEN '1E' THEN '1 ENTRADA REGISTRADA'
WHEN '2E' THEN '2 ENTRADA REGISTRADA'
WHEN '3E' THEN '3 ENTRADA REGISTRADA'
WHEN '1S' THEN '1 SA�DA REGISTRADA'
WHEN '2S' THEN '2 SA�DA REGISTRADA'
WHEN '3S' THEN '3 SA�DA REGISTRADA'
ELSE 'N�O REGISTROU ENTRADA E NEM SA�DA'
END AS REGISTRO
,CASE  P8_TPMARCA
WHEN '1E' THEN 'BATIDA DE SA�DA PENDENTE'
WHEN '2E' THEN 'BATIDA DE SA�DA PENDENTE'
WHEN '3E' THEN 'BATIDA DE SA�DA PENDENTE'
WHEN '1S' THEN 'BATIDA DE ENTRADA PENDENTE'
WHEN '2S' THEN 'BATIDA DE ENTRADA PENDENTE'
WHEN '3S' THEN 'BATIDA DE ENTRADA PENDENTE'
ELSE 'REGISTRAR ENTRADA E SA�DA'
END AS PENDENCIA
, P8_MOTIVRG AS MOTIVO
FROM SPC010
INNER JOIN SRA010 ON RA_FILIAL = PC_FILIAL AND RA_MAT = PC_MAT AND SRA010.D_E_L_E_T_ = '' AND RA_SITFOLH <> 'D'
INNER JOIN CTT010 ON CTT_CUSTO = RA_CC AND CTT010.D_E_L_E_T_ = ''
INNER JOIN SP9010 ON P9_CODIGO = PC_PD AND SP9010.D_E_L_E_T_ = ''
INNER JOIN SR6010 ON R6_TURNO = RA_TNOTRAB AND SR6010.D_E_L_E_T_ = ''
LEFT JOIN SP8010 ON P8_MAT = PC_MAT AND P8_DATA = PC_DATA AND P8_FILIAL = PC_FILIAL AND SP8010.D_E_L_E_T_ = '' AND P8_TPMCREP <> 'D'
WHERE
PC_PD IN ('409')
AND SPC010.D_E_L_E_T_ = ''
AND PC_ABONO = ''
%exp:cFiltro%
ORDER BY PC_FILIAL, PC_MAT, PC_PD, PC_DATA, P8_HORA

EndSql //FINALIZO A MINHA QUERY

    //Criando o objeto que ir� gerar o conte�do do Excel
    oFWMsExcel := FWMSExcel():New()

    //Aba 01 - Nome Guia
    oFWMsExcel:AddworkSheet("Marca��es Pendentes") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Marca��es Pendentes",cNomeTabela)
        //Criando Colunas
          oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"FILIAL",1,1) //1,1 = Modo Texto  // 2,2 = Valor sem R$  //  3,3 = Valor com R$
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"CCUSTO",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"DESCRI��O",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"MATR�CULA",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"NOME",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"TURNO",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"DESCRICAO",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"DATA",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"COD_OCOR",1,1)
        oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"OCORR�NCIA",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"QTD",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"TIPO MARCA��O",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"BATIDA",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"REGISTRO",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"PENDENCIA",1,1)
		oFWMsExcel:AddColumn("Marca��es Pendentes",cNomeTabela,"MOTIVO",1,1)


While !(cAlias)->(Eof())

	cQtd 	:= u_zHoraAbnt(QTD, ":")
	cBatida := u_zHoraAbnt(BATIDA, ":")

	//Criando as Linhas
    oFWMsExcel:AddRow("Marca��es Pendentes",cNomeTabela,{FILIAL, CCUSTO, DESCRICAO, MATRICULA, NOME, TURNO, DESCRITURNO,DTOC(STOD(DIA_FALTA)), COD_OCOR, OCORRENCIA, cQtd, TIPO_MARCACAO, cBatida, REGISTRO, PENDENCIA,MOTIVO})


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

	Local aArea	:= GetArea()
	Local aRegs	:= {}
	Local i,j

	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Da Filial:					","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"02","At� a Filial:				","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
	AADD(aRegs,{cPerg,"03","Da Matr�cula:				","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"04","At� a Matr�cula:			","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"05","Do Centro de Custo:			","","","mv_ch05","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"06","At� o Centro de Custo:		","","","mv_ch06","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
	AADD(aRegs,{cPerg,"07","Da Data:					","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","At� a Data:					","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

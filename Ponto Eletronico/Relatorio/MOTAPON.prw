#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMOTAPON บ Autor ณ Bruno Alves       บ Data ณ    19/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Informa a quantidade de horas em abonos feitas pelo        บฑฑ
ฑฑ          ฑฑ funcinario												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MOTAPON()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relacao de Abono"
Local nLin           := 100

Local Cabec1         := "Mat.    Funcionario                                   Data       Dia       Horas       Motivo Abono"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "MOTAPON" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "MOTAPON4"
Private cString      := "SPC"
Private cQuery       := ""
Private nCont	    := 0
Private _aIExcel 	 := {}


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Imprimir relatorio com dados Financeiros ou de Clientes

If MV_PAR10 == 1
	
	cQuery := "SELECT PH_FILIAL AS FILIAL,PH_MAT AS MAT,RA_NOME AS NOME,RA_SITFOLH AS SITFOLH,RA_DEMISSA AS DEMISSA,PH_DATA AS DATA,PH_ABONO AS ABONO,P6_DESC AS DESC,PH_QTABONO AS QTABONO,PH_CC AS CC,CTT_DESC01 AS DESC01 FROM SPH010 "
	cQuery += "INNER JOIN SRA010 ON "
	cQuery += "SPH010.PH_FILIAL = SRA010.RA_FILIAL AND "
	cQuery += "SPH010.PH_MAT = SRA010.RA_MAT "
	cQuery += "INNER JOIN CTT010 ON "
	cQuery += "SPH010.PH_FILIAL = CTT010.CTT_FILIAL AND "
	cQuery += "SPH010.PH_CC = CTT010.CTT_CUSTO "
	cQuery += "INNER JOIN SP6010 ON "
	cQuery += "SPH010.PH_ABONO = SP6010.P6_CODIGO "
	cQuery += "WHERE "
	cQuery += "SPH010.PH_ABONO   <> ''  AND "
	if MV_PAR11 == 1
		cQuery += "SRA010.RA_SITFOLH = 'D' AND "
		cQuery += "SRA010.RA_DEMISSA <> '' AND "
	else
		cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
		cQuery += "SRA010.RA_DEMISSA = '' AND "
	endif
	cQuery += "CTT010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPH010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SP6010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPH010.PH_MAT BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
	cQuery += "SPH010.PH_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
	If !EMPTY(MV_PAR05)
		cQuery += "SPH010.PH_ABONO IN " + FormatIn(MV_PAR05,";") + " AND "
	Else
		cQuery += "SPH010.PH_ABONO BETWEEN '" + (MV_PAR06) + "' AND '" + (MV_PAR07) + "' AND "
	EndIf
	cQuery += "SPH010.PH_CC BETWEEN '" + (MV_PAR08) + "' AND '" + (MV_PAR09) + "' "
	cQuery += "ORDER BY SPH010.PH_CC,SPH010.PH_MAT,SPH010.PH_DATA "
	
ELSE
	
	cQuery := "SELECT PC_FILIAL AS FILIAL,PC_MAT AS MAT,RA_NOME AS NOME,RA_SITFOLH AS SITFOLH,RA_DEMISSA AS DEMISSA,PC_DATA AS DATA,PC_ABONO AS ABONO,P6_DESC AS DESC,PC_QTABONO AS QTABONO,PC_CC AS CC,CTT_DESC01 AS DESC01 FROM SPC010 "
	cQuery += "INNER JOIN SRA010 ON "
	cQuery += "SPC010.PC_FILIAL = SRA010.RA_FILIAL AND "
	cQuery += "SPC010.PC_MAT = SRA010.RA_MAT "
	cQuery += "INNER JOIN CTT010 ON "
	cQuery += "SPC010.PC_FILIAL = CTT010.CTT_FILIAL AND "
	cQuery += "SPC010.PC_CC = CTT010.CTT_CUSTO "
	cQuery += "INNER JOIN SP6010 ON "
	cQuery += "SPC010.PC_ABONO = SP6010.P6_CODIGO "
	cQuery += "WHERE "
	cQuery += "SPC010.PC_ABONO   <> ''  AND "
	cQuery += "CTT010.D_E_L_E_T_ <> '*' AND "
	if MV_PAR11 == 1
		cQuery += "SRA010.RA_SITFOLH = 'D' AND "
		cQuery += "SRA010.RA_DEMISSA <> '' AND "
	else
		cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
		cQuery += "SRA010.RA_DEMISSA = '' AND "
	endif
	cQuery += "SPC010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SP6010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SPC010.PC_MAT BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
	cQuery += "SPC010.PC_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND "
	If !EMPTY(MV_PAR05)
		cQuery += "SPC010.PC_ABONO IN " + FormatIn(MV_PAR05,";") + " AND "
	Else
		cQuery += "SPC010.PC_ABONO BETWEEN '" + (MV_PAR06) + "' AND '" + (MV_PAR07) + "' AND "
	EndIf
	cQuery += "SPC010.PC_CC BETWEEN '" + (MV_PAR08) + "' AND '" + (MV_PAR09) + "' "
	cQuery += "ORDER BY SPC010.PC_CC,SPC010.PC_MAT,SPC010.PC_DATA "
	
EndIf

tcQuery cQuery New Alias "TMP"


If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif




If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

dbSelectArea("TMP")
dbCloseArea("TMP")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nTotHoras := 0
Local nHoras 	 := 0
Local nHorasFunc  := 0
Local nHorasCC		:= 0
Local cCodCusto := ""
Local cCusto 	 := ""
Local cNome 	 := ""
Local cCodMat    := ""

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

If MV_PAR12 == 1
	
	While !EOF()
		
		SetRegua(RecCount())
		
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		
		If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		
		
		cNome := TMP->NOME
		nHoras := TMP->QTABONO
		cCodMat := TMP->MAT
		
		
		IF (TMP->CC != cCodCusto)
			@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY TMP->CC
			@nLin, 010 PSAY TMP->DESC01
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
		Endif
		
		
		@nLin, 000 PSAY TMP->MAT
		@nLin, 008 PSAY cNome
		@nLin, 050 PSAY STOD(TMP->DATA)
		@nLin, 062 PSAY DiaExtenso(STOD(TMP->DATA))
		@nLin, 074 PSAY nHoras
		@nLin, 084 PSAY TMP->DESC
		
		nTotHoras := SomaHoras(nTotHoras,nHoras)
		nHorasFunc := SomaHoras(nHorasFunc,nHoras)
		nHorasCC := SomaHoras(nHorasCC,nHoras)
		
		
		
		cCodCusto := TMP->CC
		
		dbskip()
		
		
		
		IF (TMP->MAT != cCodMat)
			nLin += 1
			@nLin, 000 PSAY "Total de Horas do Funcionario "
			@nLin, 030 PSAY cCodMat  + " : "
			@nLin, 040 PSAY nHorasFunc
			nHorasFunc := 0
			nLin += 1
		ENDIF
		
		IF (TMP->CC != cCodCusto)
			nLin += 1
			@nLin, 000 PSAY "Total de Horas do Centro de Custo "
			@nLin, 034 PSAY cCodCusto  + " : "
			@nLin, 047 PSAY nHorasCC
			nHorasCC := 0
			nLin += 1
			@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		ENDIF
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		
		
	ENDDO
	
	
	nLin += 1
	@nLin, 00 PSAY "Total de Horas: "
	@nLin, 23 PSAY nTotHoras
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
ELSE
	
	
	
	// **************************** Cria Arquivo Temporario
	_aCExcel:={}//SPCSQL->(DbStruct()) 
	aadd( _aCExcel , {"MATRICULA"    	, "C" , 10 , 00 } ) //01
	aadd( _aCExcel , {"NOME"			, "C" , 50 , 00 } ) //02
	aadd( _aCExcel , {"DATADIA"  		, "C" , 10 , 00 } ) //03
	aadd( _aCExcel , {"EXTENSO"	   		, "C" , 30 , 00 } ) //04
	aadd( _aCExcel , {"HORAS"     		, "C" , 04,  00 } ) //05
	aadd( _aCExcel , {"EVENTO"		  	, "C" , 20 , 00 } ) //06
	
	
   	//_cTemp := CriaTrab(_aCExcel, .T.)
	//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	DbSelectArea("TMP")
	Do While TMP->(!Eof())
		
		
		cNome := TMP->NOME
		nHoras := TMP->QTABONO
		cCodMat := TMP->MAT
		
		IF (TMP->CC != cCodCusto)
		
		// Pular Linha
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
	_aItem := {}
	
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[1] 		:= TMP->CC
			_aItem[2] 		    := TMP->DESC01
   			AADD(_aIExcel,_aItem)
   			_aItem := {}
			
		//Pular Linha					
	_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
	_aItem := {}			
		
		Endif
		
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[1]  		:= TMP->MAT
		_aItem[2]		:= cNome
		_aItem[3]		:= DTOC(STOD(TMP->DATA))
		_aItem[4] 	   	:= DiaExtenso(STOD(TMP->DATA))
		_aItem[5] 	 	:= cValToChar(nHoras)
		_aItem[6]     	:= TMP->DESC
	AADD(_aIExcel,_aItem)
	_aItem := {}
		
		nTotHoras := SomaHoras(nTotHoras,nHoras)
		nHorasFunc := SomaHoras(nHorasFunc,nHoras)
		nHorasCC := SomaHoras(nHorasCC,nHoras)
		
		
		
		cCodCusto := TMP->CC
		
		TMP->(DbSkip())
		
		
		
		IF (TMP->MAT != cCodMat)
	_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[4] 	:= "TOTAL FUNCIONARIO"
			_aItem[5] 	    := cValToChar(nHorasFunc)
	AADD(_aIExcel,_aItem)
	_aItem := {}
			nHorasFunc := 0
		ENDIF
		
		IF (TMP->CC != cCodCusto)
	_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[4] 	:= "TOTAL CENTRO DE CUSTO"
			_aItem[5]	    := cValToChar(nHorasCC)
	AADD(_aIExcel,_aItem)
	_aItem := {}
			nHorasCC := 0
		ENDIF
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		
	Enddo
			//Pula Linha
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	AADD(_aIExcel,_aItem)
	_aItem := {} 
			
	_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[4] 	:= "TOTAL DE HORAS"
			_aItem[5]	    := cValToChar(nTotHoras)
	AADD(_aIExcel,_aItem)
	_aItem := {}

	
	If !ApOleClient("MsExcel")
		MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
		Return
	EndIf
	
	//cArq     := _cTemp+".DBF"
	
	//DBSelectArea("TMP1")
	//DBCloseARea("TMP1")
	
	
	//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")
	
	//oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
	//oExcelApp:SetVisible(.T.) 
	
	IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Relacao de abono - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","MOTAPON")
	_lRet := .F.
ENDIF
	
EndIf

Return




Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Matricula ?","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Matricula ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Da  Data ?","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data ?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Abonos  ?","","","mv_ch05","C",30,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","De  Abono ?","","","mv_ch06","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SP6"})
AADD(aRegs,{cPerg,"07","Ate Abono ?","","","mv_ch07","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SP6"})
AADD(aRegs,{cPerg,"08","De  C. Custo ?","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"09","Ate C. Custo ?","","","mv_ch09","C",09,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"10","Acumulado ?","","","mv_ch10","N",01,0,2,"C","","mv_par10","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Demitido ?","","","mv_ch11","N",01,0,2,"C","","mv_par11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"12","Gerar         ?","","","mv_ch12","N",01,0,0,"C","","mv_par12","Relatorio","Relatorio","Relatorio","","","Plan. Excel","Plan. Excel","Plan. Excel","","","","","","","","","","","","","","","","","","","",""} )

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return



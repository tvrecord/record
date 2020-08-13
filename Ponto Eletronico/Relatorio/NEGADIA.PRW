#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 NEGADIA  : Autor 3 Bruno Alves        : Data 3  07/12/2012 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Relatorio de horas negativas diarios       :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Verificação do Ponto Eletronico                                 :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function NEGADIA

Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "Horas Negativas"
Private cPict        := ""
Private titulo       := "Horas Negativas"
Private Cabec1       := "Mat.    Nome                                                Data      Evento  Nome                 Horario    C. Custo  Descrição"
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd         := {}
Private nLin         := 80
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "NEGADIA"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "NEGADIA8"
Private cString    := "SPC"
Private nHoras 	   := 0
Private nCCHoras   := 0
Private nFHoras	   := 0
Private	cCC  	   := ""
Private	cMat       := ""
Private	cPd       := ""
Private aDias 		:= {} // Contem os dias negativos POR funcionario
Private	cPeriodo := SUBSTR(GETMV("MV_PAPONTA"),1,6)

ValidPerg(cPerg)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//EndIf
Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Funo    3RUNREPORT : Autor 3 AP6 IDE            : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descrio 3 Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS :11
11:          3 monta a janela com a regua de processamento.               :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local _cQrySPC:=""
SetRegua(5000)
Pergunte(cPerg,.f.)

_cQrySPC+="	SELECT PI_FILIAL AS FILIAL,PI_MAT AS MAT,RA_NOME AS NOME,PI_DATA AS DATAPER,PI_PD AS PD,P9_DESC AS DESC,PI_QUANT AS QUANTC,PI_CC AS CC,CTT_DESC01 AS DESC01, PI_DTBAIX AS BAIXA FROM SPI010
_cQrySPC+="	INNER JOIN CTT010 ON
_cQrySPC+="	CTT010.CTT_FILIAL = SPI010.PI_FILIAL AND
_cQrySPC+="	CTT010.CTT_CUSTO = SPI010.PI_CC
_cQrySPC+="	INNER JOIN SP9010 ON
_cQrySPC+="	SP9010.P9_CODIGO = SPI010.PI_PD
_cQrySPC+="	INNER JOIN SRA010 ON
_cQrySPC+="	SRA010.RA_FILIAL = SPI010.PI_FILIAL AND
_cQrySPC+="	SRA010.RA_MAT = SPI010.PI_MAT
_cQrySPC+="	WHERE
_cQrySPC+="	SPI010.PI_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
_cQrySPC+="	SPI010.PI_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
_cQrySPC+="	SPI010.PI_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' AND "
_cQrySPC+="	SPI010.PI_CC BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
_cQrySPC+="	SPI010.PI_PD IN " + FormatIn(MV_PAR11,";") + " AND "
_cQrySPC+="	SRA010.RA_DEMISSA = '' AND "
_cQrySPC+="	SPI010.D_E_L_E_T_ <> '*' AND
_cQrySPC+="	CTT010.D_E_L_E_T_ <> '*' AND
_cQrySPC+="	SP9010.D_E_L_E_T_ <> '*' AND
_cQrySPC+="	SRA010.D_E_L_E_T_ <> '*'
If MV_PAR10 == 2
	_cQrySPC+="    ORDER BY PI_FILIAL,PI_CC,PI_MAT,PI_DATA
ELSE
	_cQrySPC+="	ORDER BY PI_FILIAL,PI_CC,PI_MAT,PI_PD
ENDIF

If Select("SPCSQL") > 0
	SPCSQL->(DbCloseArea())
Endif

TCQUERY _cQrySPC NEW ALIAS "SPCSQL"

SPCSQL->(DbGoTop())

If mv_par09 == 1
	
	While SPCSQL->(!Eof())
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		If cPeriodo == SUBSTR(SPCSQL->DATAPER,1,6)
			If Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PC_ABONO") == "014" .OR. Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "498","PC_ABONO") == "014"// Se for folga abonada
				DBSkip()
				If MV_PAR10 == 2
					AltMat01() //Verifica se deve imprimir
				ElseIf MV_PAR10 == 1
					AltMat02()
				EndIf
				Loop
			EndIf
		else
			If Posicione("SPH",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PH_ABONO") == "014" .OR. Posicione("SPH",2,SPCSQL->FILIAL + ALLTRIM(SPCSQL->MAT) + SPCSQL->DATAPER + "498","PH_ABONO") == "014" // Se for folga abonada
				DBSkip()
				If MV_PAR10 == 2 //Analitico
					AltMat01() //Verifica se deve imprimir
				ElseIf MV_PAR10 == 1 //Sintetico
					AltMat02()
				EndIf
				Loop
			EndIf
		EndIf
		
		
		IF MV_PAR10 == 2
			
			
			nFHoras := SomaHoras(nFHoras,SPCSQL->QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->QUANTC) //Soma as horas por Centro de Custo
			
			cCC  := SPCSQL->CC
			cMat := SPCSQL->MAT
			
			
			//Altera formato para 00:00
			nHoras  := StrZero(SPCSQL->QUANTC,5,2)
			nHoras := StrTran(nHoras,".",":")
			
			
			aAdd(aDias,{	SPCSQL->MAT	,;	// 01
			SPCSQL->NOME ,; // 02
			STOD(SPCSQL->DATAPER) ,; // 03
			SPCSQL->PD ,; // 04
			SPCSQL->DESC ,; // 05
			nHoras ,; // 06
			SPCSQL->CC ,; // 07
			SPCSQL->DESC01})	// 08
			
			DBSKIP()
			
			AltMat01() //Verifica se deve imprimir
			
			
		ELSE
			
			nFHoras := SomaHoras(nFHoras,SPCSQL->QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->QUANTC) //Soma as horas por Centro de Custo
			
			cMat  	:= SPCSQL->MAT
			cNome 	:= SPCSQL->NOME
			cPd	  	:= SPCSQL->PD
			cDescri := SPCSQL->DESC
			cCC  	:= SPCSQL->CC
			cCCDesc := SPCSQL->DESC01
			
			
			
			DBSKIP()
			
			AltMat02()//Verifica se deve Imprimir
			
			
			
		EndIf
		
		
	Enddo
	
	
	
	SET DEVICE TO SCREEN
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
	
Else
	
	IF MV_PAR10 == 2
		
		// **************************** Cria Arquivo Temporario
		_aStru:={}//SPCSQL->(DbStruct())
		aadd( _aStru , {"MATRICULA"      	, "C" , 06 , 00 } )
		aadd( _aStru , {"NOME"   			, "C" , 50 , 00 } )
		aadd( _aStru , {"DATADIA"  			, "D" , 10 , 00 } )
		aadd( _aStru , {"EVENTO"  			, "C" , 05 , 00 } )
		aadd( _aStru , {"DESCEVENT"			, "C" , 20 , 00 } )
		aadd( _aStru , {"QUANTIDADE"		, "C" , 08,  00 } )
		aadd( _aStru , {"CCUSTO"			, "C" , 09 , 00 } )
		aadd( _aStru , {"DESCCC"			, "C" , 40 , 00 } )
		_cTemp := CriaTrab(_aStru, .T.)
		DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
		
		DbSelectArea("SPCSQL")
		Do While SPCSQL->(!Eof())
			
			If cPeriodo == SUBSTR(SPCSQL->DATAPER,1,6)
				If Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PC_ABONO") == "014" .OR. Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "498","PC_ABONO") == "014"// Se for folga abonada
					SPCSQL->(DBSkip())
					AltMat03()
					Loop
				EndIf
			else
				If Posicione("SPH",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PH_ABONO") == "014" .OR. Posicione("SPH",2,SPCSQL->FILIAL + ALLTRIM(SPCSQL->MAT) + SPCSQL->DATAPER + "498","PH_ABONO") == "014" // Se for folga abonada
					SPCSQL->(DBSkip())
					AltMat03()
					Loop
				EndIf
			EndIf
			
			
			nFHoras := SomaHoras(nFHoras,SPCSQL->QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->QUANTC) //Soma as horas por Centro de Custo
			
			cCC  := SPCSQL->CC
			cMat := SPCSQL->MAT
			
			nHoras  := StrZero(SPCSQL->QUANTC,5,2)
			nHoras := StrTran(nHoras,".",":")
			
			aAdd(aDias,{	SPCSQL->MAT	,;	// 01
			SPCSQL->NOME ,; // 02
			STOD(SPCSQL->DATAPER) ,; // 03
			SPCSQL->PD ,; // 04
			SPCSQL->DESC ,; // 05
			CVALTOCHAR(nHoras) ,; // 06
			SPCSQL->CC ,; // 07
			SPCSQL->DESC01})	// 08
			
			
			SPCSQL->(DbSkip())
			
			
			AltMat03()
			
		Enddo
		
		If !ApOleClient("MsExcel")
			MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
			Return
		EndIf
		
		cArq     := _cTemp+".DBF"
		
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
		
		__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")
		
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
		oExcelApp:SetVisible(.T.)
		
	ELSE // SINTETICO
		
		// **************************** Cria Arquivo Temporario
		_aStru:={}//SPCSQL->(DbStruct())
		aadd( _aStru , {"MATRICULA"      	, "C" , 06 , 00 } )
		aadd( _aStru , {"NOME"   			, "C" , 50 , 00 } )
		aadd( _aStru , {"EVENTO"  			, "C" , 05 , 00 } )
		aadd( _aStru , {"DESCEVENT"			, "C" , 20 , 00 } )
		aadd( _aStru , {"QUANTIDADE"		, "C" , 08,  00 } )
		aadd( _aStru , {"CCUSTO"			, "C" , 09 , 00 } )
		aadd( _aStru , {"DESCCC"			, "C" , 40 , 00 } )
		_cTemp := CriaTrab(_aStru, .T.)
		DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
		
		DbSelectArea("SPCSQL")
		Do While SPCSQL->(!Eof())
			
			If cPeriodo == SUBSTR(SPCSQL->DATAPER,1,6)
				If Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PC_ABONO") == "014" .OR. Posicione("SPC",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "498","PC_ABONO") == "014"// Se for folga abonada
					SPCSQL->(DBSkip())
					Loop
				EndIf
			else
				If Posicione("SPH",2,SPCSQL->FILIAL + SPCSQL->MAT + SPCSQL->DATAPER + "409","PH_ABONO") == "014" .OR. Posicione("SPH",2,SPCSQL->FILIAL + ALLTRIM(SPCSQL->MAT) + SPCSQL->DATAPER + "498","PH_ABONO") == "014" // Se for folga abonada
					SPCSQL->(DBSkip())
					Loop
				EndIf
			EndIf
			
			
			nFHoras := SomaHoras(nFHoras,SPCSQL->QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->QUANTC) //Soma as horas por Centro de Custo
			
			cMat  	:= SPCSQL->MAT
			cNome 	:= SPCSQL->NOME
			cPd	  	:= SPCSQL->PD
			cDescri := SPCSQL->DESC
			cCC  	:= SPCSQL->CC
			cCCDesc := SPCSQL->DESC01
			
			
			SPCSQL->(DbSkip())
			
			AltMat04()
			
		Enddo
		
		If !ApOleClient("MsExcel")
			MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
			Return
		EndIf
		
		cArq     := _cTemp+".DBF"
		
		DbSelectArea("TMP")
		TMP->(DbCloseArea())
		
		__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")
		
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
		oExcelApp:SetVisible(.T.)
		
	EndIf
	
Endif
Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3ValidPerg : Autor 3                    : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Cria/Valida Parametros do sistema                          :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Da Filial	  		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Ate Filial  		","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Da Matricula	  		","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Ate Matricula  		","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
Aadd(aRegs,{cPerg,"05","Data de    ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data ate   ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Centro de Custo	  		","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"08","Ate Centro de Custo	","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
Aadd(aRegs,{cPerg,"09","Gerar         ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Relatorio","Relatorio","Relatorio","","","Plan. Excel","Plan. Excel","Plan. Excel","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"10","Impressao ?","","","mv_ch10","N",01,0,0,"C","","mv_par10","Sintetico","Sintetico","Sintetico","","","Analitico","Analitico","Analitico","","","","","","","","","","","","","","","","","","","",""} )
AADD(aRegs,{cPerg,"11","Eventos?	","","","mv_ch11","C",30,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Acima de Qts Horas ?","","","mv_ch12","N",5,2,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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




Static Function AltMat01()


If cMat != SPCSQL->MAT
	If nFHoras > (MV_PAR12) //Se estiver dentro do limite de horas para impressão, imprima os valores no vetor
		For I := 1 to Len(aDias)
			
			@ nLin,000 PSAY aDias[I][01]
			@ nLin,008 PSAY aDias[I][02]
			@ nLin,060 PSAY aDias[I][03]
			@ nLin,072 PSAY aDias[I][04]
			@ nLin,077 PSAY aDias[I][05]
			@ nLin,100 PSAY aDias[I][06]
			@ nLin,110 PSAY aDias[I][07]
			@ nLin,120 PSAY aDias[I][08]
			
			nLin++
			
						If nLin > 70
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			
		Next
		
		aDias := {}
		
		
		If nFHoras < 100
			nFHoras  := StrZero(nFhoras,5,2)
		Else
			nFHoras  := StrZero(nFhoras,6,2)
		EndIf
		nLin--
		nFHoras := StrTran(nFHoras,".",":")
		@ nLin,101 PSAY "_____"
		nLIn++
		@ nLin,100 PSAY nFHoras
		nLin += 2
		nFHoras := 0
		
		
	Else
		
		aDias := {}
		nCCHoras -= nFHoras
		nFHoras := 0
		
		
	EndIf
	
	
EndIf


If nCCHoras > 0
	If cCC != SPCSQL->CC
		If nCCHoras < 100
			nCCHoras  := StrZero(nCChoras,5,2)
		ElseIf nCCHoras > 100 .AND. nCCHoras < 1000
			nCCHoras  := StrZero(nCChoras,6,2)
		ElseIf nCCHoras > 1000
			nCCHoras  := StrZero(nCChoras,7,2)
		EndIf
		nLin--
		nCCHoras := StrTran(nCCHoras,".",":")
		@ nLin,0 PSAY REPLICATE("_",160)
		nLIn++
		@ nLin,100 PSAY nCCHoras
		nLin+= 2
		nCCHoras := 0
	EndIf
	
						If nLin > 70
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
	
EndIf

Return

Static Function AltMat02()

If cMat != SPCSQL->MAT //.OR. cPd != SPCSQL->PD
	If nFHoras > MV_PAR12
		
		If nFHoras < 100
			nFHoras  := StrZero(nFhoras,5,2)
		Else
			nFHoras  := StrZero(nFhoras,6,2)
		EndIf
		nFHoras := StrTran(nFHoras,".",":")
		
		
		@ nLin,000 PSAY cMat
		@ nLin,008 PSAY cNome
		@ nLin,072 PSAY cPd
		@ nLin,077 PSAY cDescri
		@ nLin,100 PSAY nFHoras
		@ nLin,110 PSAY cCC
		@ nLin,120 PSAY cCCDEsc
		nFHoras := 0
		nLin++
		
		
	EndIf	
	
	
EndIf


If nCCHoras > 0
	
	If cCC != SPCSQL->CC
		nLin--
		If nCCHoras < 100
			nCCHoras  := StrZero(nCChoras,5,2)
		ElseIf nCCHoras > 100 .AND. nCCHoras < 1000
			nCCHoras  := StrZero(nCChoras,6,2)
		ElseIf nCCHoras > 1000
			nCCHoras  := StrZero(nCChoras,7,2)
		EndIf
		nCCHoras := StrTran(nCCHoras,".",":")
		@ nLin,0 PSAY REPLICATE("_",160)
		nLIn++
		@ nLin,100 PSAY nCCHoras
		@ nLin,0 PSAY REPLICATE("_",160)
		nLin++
		nLin++
		nCCHoras := 0
	EndIf
	
			
EndIf

		If nLin > 70
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

Return

Static Function AltMat03()



If cMat != SPCSQL->MAT
	
	If nFHoras > MV_PAR12
		
		For I := 1 to Len(aDias)
			
			Reclock("TMP",.T.)
			TMP->MATRICULA 	:= aDias[I][01]
			TMP->NOME 		:= aDias[I][02]
			TMP->DATADIA 	:= aDias[I][03]
			TMP->EVENTO 	:= aDias[I][04]
			TMP->DESCEVENT 	:= aDias[I][05]
			TMP->QUANTIDADE := aDias[I][06]
			TMP->CCUSTO 	:= aDias[I][07]
			TMP->DESCCC 	:= aDias[I][08]
			MsUnlock()
			
		Next
		
		If nFHoras < 100
			nFHoras  := StrZero(nFhoras,5,2)
		Else
			nFHoras  := StrZero(nFhoras,6,2)
		EndIf
		nFHoras := StrTran(nFHoras,".",":")
		Reclock("TMP",.T.)
		TMP->MATRICULA 	:= ""
		TMP->NOME 		:= "TOTAL FUNCIONARIO"
		TMP->DATADIA 	:= CtoD("//")
		TMP->QUANTIDADE := nFHoras
		TMP->CCUSTO 	:= ""
		TMP->DESCCC 	:= ""
		MsUnlock()
		nFHoras := 0
		aDias := {}
		
	Else
		
		nFHoras := 0
		aDias := {}
		
	EndIf
	
EndIf

Return

Static Function AltMat04()

If nFHoras > MV_PAR12
	
	If cMat != SPCSQL->MAT //.OR. cPd != SPCSQL->PD
		If nFHoras > MV_PAR12
			If nFHoras < 100
				nFHoras  := StrZero(nFhoras,5,2)
			Else
				nFHoras  := StrZero(nFhoras,6,2)
			EndIf
			nFHoras := StrTran(nFHoras,".",":")
			Reclock("TMP",.T.)
			TMP->MATRICULA 	:= cMat
			TMP->NOME 		:= cNome
			TMP->QUANTIDADE := nFHoras
			TMP->EVENTO     := cPd
			TMP->DESCEVENT := cDescri
			TMP->CCUSTO 	:= cCC
			TMP->DESCCC 	:= cCCDEsc
			MsUnlock()
			nFHoras := 0
		EndIf
		
		
	EndIf
EndIf

Return

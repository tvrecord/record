#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 ICTBR02  : Autor 3 Bruno Alves        : Data 3  24/11/2011 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Relatorio de horas extras diarios       :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Especifico Indiana Seguros                                 :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function EXTRADIA

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Horas Extras"
Local cPict        := ""
Local titulo       := "Horas Extras"
Local nLin         := 80
Local Cabec1       := "Mat.    Nome                                                Data      Evento  Nome                 Horario    C. Custo  Descrição"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "EXTRADIA"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "EXTRADIA2"
Private cString    := "SPH"
Private nHoras 	   := 0
Private nCCHoras   := 0
Private nFHoras	   := 0
Private	cCC  	   := ""
Private	cMat       := ""
Private	cPd       := ""
Private _aCExcel := {}
Private _aIExcel := {}
Private _lRet := .T.

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

If MV_PAR11 == 1

	_cQrySPC:="SELECT PH_FILIAL AS PC_FILIAL,PH_MAT AS PC_MAT,RA_NOME,PH_DATA AS PC_DATA,PH_PD AS PC_PD,P9_DESC,PH_QUANTC AS PC_QUANTC,PH_CC AS PC_CC,CTT_DESC01 FROM SPH010 "
	_cQrySPC+="INNER JOIN CTT010 ON "
	_cQrySPC+="CTT010.CTT_FILIAL = SPH010.PH_FILIAL AND "
	_cQrySPC+="CTT010.CTT_CUSTO = SPH010.PH_CC "
	_cQrySPC+="INNER JOIN SP9010 ON "
	_cQrySPC+="SP9010.P9_CODIGO = SPH010.PH_PD "
	_cQrySPC+="INNER JOIN SRA010 ON "
	_cQrySPC+="SRA010.RA_FILIAL = SPH010.PH_FILIAL AND "
	_cQrySPC+="SRA010.RA_MAT = SPH010.PH_MAT "
	_cQrySPC+="WHERE "
	_cQrySPC+="SPH010.PH_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
	_cQrySPC+="SPH010.PH_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
	_cQrySPC+="SPH010.PH_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' AND "
	_cQrySPC+="SPH010.PH_CC BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
	_cQrySPC+="SP9010.P9_CLASEV = '01' AND "
	_cQrySPC+="SPH010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="CTT010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="SP9010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="SRA010.D_E_L_E_T_ <> '*' "
	If MV_PAR10 == 2
		_cQrySPC+="ORDER BY PH_FILIAL,PH_CC,PH_MAT,PH_DATA "
	ELSE
		_cQrySPC+="ORDER BY PH_FILIAL,PH_CC,PH_MAT,PH_PD "
	ENDIF

Else

	_cQrySPC:="SELECT PC_FILIAL,PC_MAT,RA_NOME,PC_DATA,PC_PD,P9_DESC,PC_QUANTC,PC_CC,CTT_DESC01 FROM SPC010 "
	_cQrySPC+="INNER JOIN CTT010 ON "
	_cQrySPC+="CTT010.CTT_FILIAL = SPC010.PC_FILIAL AND "
	_cQrySPC+="CTT010.CTT_CUSTO = SPC010.PC_CC "
	_cQrySPC+="INNER JOIN SP9010 ON "
	_cQrySPC+="SP9010.P9_CODIGO = SPC010.PC_PD "
	_cQrySPC+="INNER JOIN SRA010 ON "
	_cQrySPC+="SRA010.RA_FILIAL = SPC010.PC_FILIAL AND "
	_cQrySPC+="SRA010.RA_MAT = SPC010.PC_MAT "
	_cQrySPC+="WHERE "
	_cQrySPC+="SPC010.PC_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
	_cQrySPC+="SPC010.PC_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
	_cQrySPC+="SPC010.PC_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' AND "
	_cQrySPC+="SPC010.PC_CC BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
	_cQrySPC+="SP9010.P9_CLASEV = '01' AND "
	_cQrySPC+="SPC010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="CTT010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="SP9010.D_E_L_E_T_ <> '*' AND "
	_cQrySPC+="SRA010.D_E_L_E_T_ <> '*' "
	If MV_PAR10 == 2
		_cQrySPC+="ORDER BY PC_FILIAL,PC_CC,PC_MAT,PC_DATA "
	ELSE
		_cQrySPC+="ORDER BY PC_FILIAL,PC_CC,PC_MAT,PC_PD "
	ENDIF

EndIf





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

		If nLin > 56
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF MV_PAR10 == 2


			nFHoras := SomaHoras(nFHoras,SPCSQL->PC_QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->PC_QUANTC) //Soma as horas por Centro de Custo

			cCC  := SPCSQL->PC_CC
			cMat := SPCSQL->PC_MAT


			//Altera formato para 00:00
			nHoras  := StrZero(SPCSQL->PC_QUANTC,5,2)
			nHoras := StrTran(nHoras,".",":")

			@ nLin,000 PSAY SPCSQL->PC_MAT
			@ nLin,008 PSAY SPCSQL->RA_NOME
			@ nLin,060 PSAY STOD(SPCSQL->PC_DATA)
			@ nLin,072 PSAY SPCSQL->PC_PD
			@ nLin,077 PSAY SPCSQL->P9_DESC
			@ nLin,100 PSAY nHoras
			@ nLin,110 PSAY SPCSQL->PC_CC
			@ nLin,120 PSAY SPCSQL->CTT_DESC01

			DBSKIP()

			If cMat != SPCSQL->PC_MAT
				If nFHoras < 100
					nFHoras  := StrZero(nFhoras,5,2)
				Else
					nFHoras  := StrZero(nFhoras,6,2)
				EndIf
				nFHoras := StrTran(nFHoras,".",":")
				@ nLin,101 PSAY "_____"
				nLIn++
				@ nLin,100 PSAY nFHoras
				nLin++
				nFHoras := 0
			EndIf



			If cCC != SPCSQL->PC_CC
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
				nLin++
				nCCHoras := 0
			EndIf



			nLin++

		ELSE

			nFHoras := SomaHoras(nFHoras,SPCSQL->PC_QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->PC_QUANTC) //Soma as horas por Centro de Custo

			cMat  	:= SPCSQL->PC_MAT
			cNome 	:= SPCSQL->RA_NOME
			cPd	  	:= SPCSQL->PC_PD
			cDescri := SPCSQL->P9_DESC
			cCC  	:= SPCSQL->PC_CC
			cCCDesc := SPCSQL->CTT_DESC01



			DBSKIP()

			If cMat != SPCSQL->PC_MAT .OR. cPd != SPCSQL->PC_PD
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



			If cCC != SPCSQL->PC_CC
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
		_aCExcel:={}//SPCSQL->(DbStruct())
		aadd( _aCExcel , {"MATRICULA"      	, "C" , 06 , 00 } )
		aadd( _aCExcel , {"NOME"   			, "C" , 120 , 00 } )
		aadd( _aCExcel , {"DATADIA"  			, "D" , 10 , 00 } )
		aadd( _aCExcel , {"EVENTO"  			, "C" , 05 , 00 } )
		aadd( _aCExcel , {"DESCEVENT"			, "C" , 20 , 00 } )
		aadd( _aCExcel , {"QUANTIDADE"		, "C" , 08,  00 } )
		aadd( _aCExcel , {"CCUSTO"			, "C" , 09 , 00 } )
		aadd( _aCExcel , {"DESCCC"			, "C" , 40 , 00 } )

		DbSelectArea("SPCSQL")
		Do While SPCSQL->(!Eof())

			nFHoras := SomaHoras(nFHoras,SPCSQL->PC_QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->PC_QUANTC) //Soma as horas por Centro de Custo

			cCC  := SPCSQL->PC_CC
			cMat := SPCSQL->PC_MAT

			nHoras  := StrZero(SPCSQL->PC_QUANTC,5,2)
			nHoras := StrTran(nHoras,".",":")


			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01] 	:= SPCSQL->PC_MAT
			_aItem[02] 	:= SPCSQL->RA_NOME
			_aItem[03] 	:= STOD(SPCSQL->PC_DATA)
			_aItem[04] 	:= SPCSQL->PC_PD
			_aItem[05] 	:= SPCSQL->P9_DESC
			_aItem[06]  := CVALTOCHAR(nHoras)
			_aItem[07] 	:= SPCSQL->PC_CC
			_aItem[08] 	:= SPCSQL->CTT_DESC01
			AADD(_aIExcel,_aItem)
			_aItem := {}



			SPCSQL->(DbSkip())

			If cMat != SPCSQL->PC_MAT
				If nFHoras < 100
					nFHoras  := StrZero(nFhoras,5,2)
				Else
					nFHoras  := StrZero(nFhoras,6,2)
				EndIf
				nFHoras := StrTran(nFHoras,".",":")

				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[02] 	:= "TOTAL FUNCIONARIO"
				_aItem[06] 	:= nFHoras
				AADD(_aIExcel,_aItem)
				_aItem := {}

				nFHoras := 0
			EndIf


		Enddo


	ELSE // SINTETICO

		// **************************** Cria Arquivo Temporario
		_aCExcel:={}//SPCSQL->(DbStruct())
		aadd( _aCExcel , {"MATRICULA"      	, "C" , 06 , 00 } )  //01
		aadd( _aCExcel , {"NOME"   			, "C" , 50 , 00 } )  //02
		aadd( _aCExcel , {"EVENTO"  			, "C" , 05 , 00 } )  //03
		aadd( _aCExcel , {"DESCEVENT"			, "C" , 20 , 00 } )  //04
		aadd( _aCExcel , {"QUANTIDADE"		, "C" , 08,  00 } )      //05
		aadd( _aCExcel , {"CCUSTO"			, "C" , 09 , 00 } )      //06
		aadd( _aCExcel , {"DESCCC"			, "C" , 40 , 00 } )      //07


		DbSelectArea("SPCSQL")
		Do While SPCSQL->(!Eof())

			nFHoras := SomaHoras(nFHoras,SPCSQL->PC_QUANTC) //Soma as horas por Funcionario
			nCCHoras := SomaHoras(nCCHoras,SPCSQL->PC_QUANTC) //Soma as horas por Centro de Custo

			cMat  	:= SPCSQL->PC_MAT
			cNome 	:= SPCSQL->RA_NOME
			cPd	  	:= SPCSQL->PC_PD
			cDescri := SPCSQL->P9_DESC
			cCC  	:= SPCSQL->PC_CC
			cCCDesc := SPCSQL->CTT_DESC01


			SPCSQL->(DbSkip())

			If cMat != SPCSQL->PC_MAT .OR. cPd != SPCSQL->PC_PD
				If nFHoras < 100
					nFHoras  := StrZero(nFhoras,5,2)
				Else
					nFHoras  := StrZero(nFhoras,6,2)
				EndIf
				nFHoras := StrTran(nFHoras,".",":")

				_aItem := ARRAY(LEN(_aCExcel) + 1)
				_aItem[01] 	:= cMat
				_aItem[02] 	:= cNome
				_aItem[03]  := cPd
				_aItem[04]  := cDescri
				_aItem[05]  := nFHoras
				_aItem[06] 	:= cCC
				_aItem[07] 	:= cCCDEsc
				AADD(_aIExcel,_aItem)
				_aItem := {}

				nFHoras := 0

			EndIf


		Enddo


	EndIf


	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Hora Extra - Record", _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","EXTRADIA")
		_lRet := .F.
	ENDIF

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


AADD(aRegs,{cPerg,"01","Da Filial	  		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Filial  		","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Matricula	  		","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Ate Matricula  		","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
Aadd(aRegs,{cPerg,"05","Data de    ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Data ate   ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Centro de Custo	  		","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"08","Ate Centro de Custo	","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
Aadd(aRegs,{cPerg,"09","Gerar         ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Relatorio","Relatorio","Relatorio","","","Plan. Excel","Plan. Excel","Plan. Excel","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"10","Impressao ?","","","mv_ch10","N",01,0,0,"C","","mv_par10","Sintetico","Sintetico","Sintetico","","","Analitico","Analitico","Analitico","","","","","","","","","","","","","","","","","","","",""} )
Aadd(aRegs,{cPerg,"11","Acumulado ?","","","mv_ch11","N",01,0,0,"C","","mv_par11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","",""} )

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

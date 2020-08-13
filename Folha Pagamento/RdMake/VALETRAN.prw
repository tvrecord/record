#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALETRAN  บ Autor ณ Bruno Alves        บ Data ณ  27/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio que gerara um arquivo para poder enviar a empresaบฑฑ
ฑฑบ          ณ resposanvel do deposito do vale transporte aos funcionariosบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VALETRAN


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := ""
	Local cPict          := ""
	Local titulo       	 := "Relatorio de pedido de vale transporte"
	Local nLin           := 100

	Local Cabec1         := ""
	Local Cabec2         := ""
	Local Cabec3         := ""
	Local imprime        := .T.
	Local aOrd := {}

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 180
	Private tamanho      := "M"
	Private nomeprog     := "VALETRAN1" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString      := "SRA"
	Private cPerg	     := "VALETRAN1"
	Private cQuery       := ""  
	Private cQuery1       := ""  
	Private cMat	     := ""
	Private aCont 		 := {}
	Private nPos		 := 0


	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAวรO CANCELADA")
		return
	ENDIF

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	wnrel := SetPrint("",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



	//Imprimir relatorio com dados Financeiros ou de Clientes
	//Adicionado o parametro para imprimir diferen็a do vale transporte ou vale transporte - 15/01/2020 - Bruno Alves de Oliveira
	If MV_PAR04 == 1
		cQuery := "SELECT R0_FILIAL,R0_MAT,RA_NOME,RA_CIC,RA_CC,RN_CODITEM,R0_DIASPRO,R0_QDIAINF,R0_QDIACAL AS DIASVAL FROM SR0010 "
	Else
		cQuery := "SELECT R0_FILIAL,R0_MAT,RA_NOME,RA_CIC,RA_CC,RN_CODITEM,R0_DIASPRO,R0_QDIAINF,R0_QDIADIF AS DIASVAL FROM SR0010 "
	Endif
	cQuery += "INNER JOIN SRA010 ON "
	cQuery += "SRA010.RA_FILIAL = SR0010.R0_FILIAL AND "
	cQuery += "SRA010.RA_MAT = SR0010.R0_MAT "
	cQuery += "INNER JOIN SRN010 ON "
	cQuery += "SR0010.R0_CODIGO = SRN010.RN_COD "
	cQuery += "WHERE "
	cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
	cQuery += "SR0010.R0_FILIAL  =  '" + (MV_PAR01) + "'  AND "
	cQuery += "SR0010.R0_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND " 
	cQuery += "SR0010.R0_VALCAL  <>  0  AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SR0010.D_E_L_E_T_ <> '*' AND "
	cQuery += "SRN010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY RA_CIC"

	tcQuery cQuery New Alias "TMP"


	cQuery1 := "SELECT RA_CIC,COUNT(RA_CIC) AS QUANT FROM SR0010 "
	cQuery1 += "INNER JOIN SRA010 ON "
	cQuery1 += "SRA010.RA_FILIAL = SR0010.R0_FILIAL AND "
	cQuery1 += "SRA010.RA_MAT = SR0010.R0_MAT "
	cQuery1 += "WHERE "
	cQuery1 += "SRA010.RA_SITFOLH <> 'D' AND "
	cQuery1 += "SR0010.R0_FILIAL  =  '" + (MV_PAR01) + "'  AND "
	cQuery1 += "SR0010.R0_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND " 
	cQuery1 += "SR0010.R0_VALCAL  <>  0  AND "
	cQuery1 += "SR0010.D_E_L_E_T_ <> '*' AND "
	cQuery1 += "SRA010.D_E_L_E_T_ <> '*' "
	cQuery1 += "GROUP BY RA_CIC "
	cQuery1 += "ORDER BY RA_CIC "

	tcQuery cQuery1 New Alias "CONT"


	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return
	Endif

	If nLastKey == 27
		dbSelectArea("TMP")
		dbCloseArea("TMP")
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

//Imprime na tela ou Excel?
	If MV_PAR05 == 1
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		RunExcel()
	EndIf

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

//Bruno Alves de Oliveira - 12/02/2020
//Implementado a impressใo em excel
Static Function RunExcel()


	//Excel
	Private _aCExcel := {}
	Private _aIExcel := {}
	Private _lRet := .T.




	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(_aCExcel, {"CPF"				,"N", 20, 0}) //01
	AADD(_aCExcel, {"NOME"				,"C", 60, 0}) //02
	AADD(_aCExcel, {"COD_SETOR" 		,"C", 30, 0}) //03
	AADD(_aCExcel, {"MATRICULA" 		,"C", 20, 0}) //04
	AADD(_aCExcel, {"COD_TARIFA1"		,"C", 15, 0}) //05
	AADD(_aCExcel, {"QTD_VALES1"		,"N", 10, 0}) //06
	AADD(_aCExcel, {"COD_TARIFA2"		,"C", 15, 0}) //07
	AADD(_aCExcel, {"QTD_VALES2"		,"N", 10, 0}) //08
	AADD(_aCExcel, {"COD_TARIFA3"		,"C", 15, 0}) //09
	AADD(_aCExcel, {"QTD_VALES3"		,"N", 10, 0}) //10
	AADD(_aCExcel, {"COD_TARIFA4"		,"C", 15, 0}) //11
	AADD(_aCExcel, {"QTD_VALES4"		,"N", 10, 0}) //12
	AADD(_aCExcel, {"COD_TARIFA5"		,"C", 15, 0}) //13
	AADD(_aCExcel, {"QTD_VALES5"		,"N", 10, 0}) //14



	DBSelectArea("CONT")
	DBGotop()        

	DBSelectArea("TMP")
	DBGotop()

	//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

	While !EOF()


		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01] := VAL(TMP->RA_CIC)
		_aItem[02] := TMP->RA_NOME
		_aItem[03] := TMP->RA_CC
		_aItem[04] := TMP->R0_MAT
		_aItem[05] := ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
		_aItem[06] := TMP->DIASVAL

		If CONT->QUANT == 2 
			dbskip()	
			_aItem[07] := ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			_aItem[08] := TMP->DIASVAL
		EndIf


		If CONT->QUANT == 3 	
			dbskip()	
			_aItem[07] := ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			_aItem[08] := TMP->DIASVAL
			dbskip()
			_aItem[09] := ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			_aItem[10] := TMP->DIASVAL
		EndIf



		AADD(_aIExcel,_aItem)
		_aItem := {}			



		DBSELECTAREA("CONT")	
		dbskip()

		DBSELECTAREA("TMP")	
		dbskip()	


	ENDDO


	//-----------------------------------------------------------------------
	//ณ Finaliza a execucao do relatorio...
	//-----------------------------------------------------------------------	

	cCab := "Pedido de Vale Transporte "

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", cCab, _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","GPEREL001")
		_lRet := .F.
	ENDIF	


Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


	DBSelectArea("CONT")
	DBGotop()        

	DBSelectArea("TMP")
	DBGotop()

	//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

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


		@nLin, 000 PSAY TMP->RA_CIC
		@nLin, 013 PSAY TMP->RA_NOME
		@nLin, 063 PSAY TMP->RA_CC
		@nLin, 074 PSAY TMP->R0_MAT
		@nLin, 082 PSAY ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
		@nLin, 089 PSAY TMP->DIASVAL

		If CONT->QUANT == 2 
			dbskip()	
			@nLin, 096 PSAY ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			@nLin, 103 PSAY TMP->DIASVAL
		EndIf

		If CONT->QUANT == 3 	
			dbskip()	
			@nLin, 096 PSAY ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			@nLin, 103 PSAY TMP->DIASVAL
			dbskip()
			@nLin, 110 PSAY ALLTRIM(SUBSTR(TMP->RN_CODITEM,1,5))
			@nLin, 117 PSAY TMP->DIASVAL
		EndIf


		DBSELECTAREA("CONT")	
		dbskip()

		DBSELECTAREA("TMP")	
		dbskip()



		nLin 			+= 1 // Avanca a linha de impressao


	ENDDO





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

	DBSelectArea("TMP")
	DBCloseArea("TMP")
	DBSelectArea("CONT")
	DBCloseArea("CONT")

Return


Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Filial ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Matricula De ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"03","Matricula Ate ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	aAdd(aRegs,{cPerg,"04","Exporta?   	","","","mv_ch04","N",01,00,1,"C","","mv_par04","Vale Transporte","","","","","Dif. V Transporte","","","","","","","","","","","","","","","","","","","" })
	aAdd(aRegs,{cPerg,"05","Tp Impressao?   	","","","mv_ch05","N",01,00,1,"C","","mv_par05","Tela","","","","","Excel","","","","","","","","","","","","","","","","","","","" })




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
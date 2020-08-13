#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELVALE  º Autor ³ Bruno Alves        º Data ³  27/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio que gerara um arquivo para poder enviar a empresaº±±
±±º          ³ resposanvel do deposito do vale transporte aos funcionariosº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELVALE


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relatorio de Pagamento Vale Refeição / Alimentação referente "
Local nLin           := 100

Local Cabec1         := "Mat.    Nome                                     Admissao Fim Contrat  Ini Ferias   Fim Ferias          Total   Desconto   Tipo"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "RELVALE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SRA"
Private cPerg	     := "RELVALE3"
Private cQuery       := ""
Private cQuery1      := ""
Private cMat	     := ""
Private cCCusto	     := ""
Private aCont 		 := {}
Private nPos		 := 0
Private nTotVal 	 := 0
Private nTotRefEst 	 := 0
Private nTotAliEst 	 := 0
Private nTotRef 	 := 0
Private nTotAlim 	 := 0
Private nTotDesc 	 := 0
Private	nTotCC 		 := 0
Private	nDescCC 	 := 0
Private nCont 		 := 0
Private nContEst	 := 0
Private lOk1		 := .F.
Private lCc			 := .T.
Private nRecTMP		 := 0
Private nRecTMP1	 := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF MV_PAR12 == 1 // Vale Refeição e Alimentacao
	
	If MV_PAR09 == 1
		titulo := "Relatorio de Pagamento Vale Refeição / Alimentação  - Referente: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + " Pagamento: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + ""
	Else
		titulo := "Relatorio de Pagamento Vale Refeição / Alimentação  - Referente: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + " Pagamento: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "01") - 1 )),4,8) + ""
	EndIf
	
ELSE
	
	If MV_PAR09 == 1
		titulo := "Relatorio de Pagamento Cesta Alimentação  - Referente: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + " Pagamento: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + ""
	Else
		titulo := "Relatorio de Pagamento Cesta Alimentação  - Referente: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "28") )),4,8) + " Pagamento: " + SUBSTR(DTOC((STOD(MV_PAR07 + MV_PAR06 + "01") - 1 )),4,8) + ""
	EndIf
	
ENDIF

wnrel := SetPrint("",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Utilizado para imprimir o relatorio
IF MV_PAR12 == 1
	cQuery := "SELECT ZO_FILIAL,ZO_MAT,ZO_NOME,ZO_CC,ZO_NOMECC,ZO_VALOR,(ZO_VALOR * 20)/100 AS DESCONTO,ZO_TPREF FROM SZO010 "
ELSE
	cQuery := "SELECT ZO_FILIAL,ZO_MAT,ZO_NOME,ZO_CC,ZO_NOMECC,ZO_VALOR,(ZO_VALOR * 1)/100 AS DESCONTO,ZO_TPREF FROM SZO010 "
ENDIF

cQuery += "WHERE "
cQuery += "D_E_L_E_T_ <> '*' AND "
cQuery += "ZO_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "ZO_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "ZO_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
cQuery += "ZO_MES = '" + (MV_PAR06) + "' AND "
cQuery += "ZO_ANO = '" + (MV_PAR07)  + "' AND "

If MV_PAR12 == 1
	cQuery += "ZO_TPREF <> '3' "
Else
	cQuery += "ZO_TPREF = '3' "
EndIf

If MV_PAR10 == 1
	cQuery += "ORDER BY ZO_CC,ZO_MAT "
Else
	cQuery += "ORDER BY ZO_CC,ZO_NOME "
EndIf

tcQuery cQuery New Alias "TMP"

COUNT TO nRecTMP

//Utilizado para gerar desconto na folha de pagamento
If MV_PAR12 == 1
	cQuery1 := "SELECT ZO_FILIAL,ZO_MAT,ZO_NOME,ZO_CC,ZO_NOMECC,SUM(ZO_VALOR) AS VALOR,(SUM(ZO_VALOR) * 20)/100 AS DESCONTO,ZO_DIAS,ZO_TPREF,RA_DEPTO,RA_CODFUNC FROM SZO010 "
ELSE
	cQuery1 := "SELECT ZO_FILIAL,ZO_MAT,ZO_NOME,ZO_CC,ZO_NOMECC,SUM(ZO_VALOR) AS VALOR,(SUM(ZO_VALOR) * 1)/100 AS DESCONTO,ZO_DIAS,ZO_TPREF,RA_DEPTO,RA_CODFUNC FROM SZO010 "
EndIf
cQuery1 += "INNER JOIN SRA010 ON "
cQuery1 += "ZO_FILIAL = RA_FILIAL AND "
cQuery1 += "ZO_MAT = RA_MAT "
cQuery1 += "WHERE "
cQuery1 += "SZO010.D_E_L_E_T_ <> '*' AND "
cQuery1 += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery1 += "ZO_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery1 += "ZO_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery1 += "ZO_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
cQuery1 += "ZO_MES = '" + (MV_PAR06) + "' AND "
cQuery1 += "ZO_VALOR > 0 AND "
cQuery1 += "ZO_ANO = '" + (MV_PAR07)  + "' AND "
If MV_PAR12 == 1
	cQuery1 += "ZO_TPREF <> '3' "
Else
	cQuery1 += "ZO_TPREF = '3' "
EndIf
cQuery1 += "GROUP BY ZO_FILIAL,ZO_MAT,ZO_NOME,ZO_CC,ZO_NOMECC,ZO_DIAS,ZO_TPREF,RA_DEPTO,RA_CODFUNC "
cQuery1 += "ORDER BY ZO_MAT "

tcQuery cQuery1 New Alias "TMP1"

COUNT TO nRecTMP1

DBSelectArea("TMP")
DBGotop()

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPeriodo := MV_PAR07 + MV_PAR06

If MV_PAR08 == 1
	Processa({|| GravaFol()},"Gravando Informações na Folha de Pagamento")
EndIf

If MV_PAR11 == 1
	Processa({|| Excel()},"Gerando Relatório")
Else
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Endif



Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  28/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DBSelectArea("TMP")
DBGotop()

While !EOF()
	
	SetRegua(RecCount())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	
	
	DBSelectARea("SR8")
	DBSetOrder(1)
	iF (DBSeek(TMP->ZO_FILIAL + TMP->ZO_MAT))
		
		
		// Localiza o periodo das férias no pagamento do vale transporte
		
		While !EOF() .AND. TMP->ZO_MAT == SR8->R8_MAT
			
			
			
			If cPeriodo == SUBSTR(DTOS(SR8->R8_DATAINI),1,6) .OR. cPeriodo == SUBSTR(DTOS(SR8->R8_DATAFIM),1,6)
				
				lOk1 := .T.
				
				dDtaIni := SR8->R8_DATAINI
				dDtaFim := SR8->R8_DATAFIM
				
			EndIf
			
			Dbskip()
			
		EndDo
		
	EndIf
	
	
	cMat := TMP->ZO_MAT
	cCCusto  := TMP->ZO_CC
	
	
	DBSelectArea("SRA")
	DBSetOrder(1)
	DBSeek(TMP->ZO_FILIAL + TMP->ZO_MAT)
	
	If lCc == .T.
		@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin += 1
		@nLin, 000 PSAY TMP->ZO_CC
		@nLin, 012 PSAY TMP->ZO_NOMECC
		nLin += 1
		@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
		nLin += 1
		
	EndIf
	
	@nLin, 000 PSAY Alltrim(TMP->ZO_MAT)
	@nLin, 008 PSAY SUBSTR(Alltrim(TMP->ZO_NOME),1,40)
	/*
	@nLin, 050 PSAY TMP->ZO_CC
	@nLin, 061 PSAY TMP->ZO_NOMECC
	*/
	@nLin, 050 PSAY SRA->RA_ADMISSA
	
	If SRA->RA_CATFUNC != "E"
		
		If cPeriodo == SUBSTR(DTOS(SRA->RA_VCTOTEM),1,6)
			@nLin, 062 PSAY SRA->RA_VCTOTEM
		else
			@nLin, 062 PSAY " / / "
		EndIf
		
	else
		
		If cPeriodo == SUBSTR(DTOS(SRA->RA_VCTOEST),1,6)
			@nLin, 062 PSAY SRA->RA_VCTOEST
		else
			@nLin, 062 PSAY " / / "
		EndIf
		
	Endif
	
	If lOk1 == .T.
		@nLin, 074 PSAY dDtaIni
		@nLin, 086 PSAY dDtaFim
	else
		@nLin, 074 PSAY " / / "
		@nLin, 086 PSAY " / / "
	EndIf
	
	@nLin, 101 PSAY TMP->ZO_VALOR PICTURE "@E 999,999.99"
	
	//Imprimi valor do desconto de estagiario
	If !(SRA->RA_CATFUNC == "E")
		@nLin, 113 PSAY ROUND(TMP->DESCONTO,2) PICTURE  "@E 999.99"
	else
		@nLin, 113 PSAY "0" PICTURE  "@E 999.99"
	EndIf
	
	IF TMP->ZO_TPREF == "1"
		@nLin, 121 PSAY "Refeicao"
	ELSEIF TMP->ZO_TPREF == "2"
		@nLin, 121 PSAY "Alimentação"
	ELSEIF TMP->ZO_TPREF == "3"
		@nLin, 121 PSAY "Cesta Alimentação"
	EndIf
	
	nTotVal += TMP->ZO_VALOR // Valor Total pago aos funcionarios
	
	If TMP->ZO_TPREF == "1"
		If !(SRA->RA_CATFUNC == "E")
			nTotRef += TMP->ZO_VALOR // Valor pago somente para vale Refeicao
		else
			nTotRefEst += TMP->ZO_VALOR
		EndIf
		
	ELSEIF TMP->ZO_TPREF == "2"
		
		If !(SRA->RA_CATFUNC == "E")
			nTotAlim += TMP->ZO_VALOR // Valor pago somente para vale Alimentacao
		else
			nTotAliEst += TMP->ZO_VALOR
		EndIf
		
	EndIf
	
	//Soma do valor total de desconto
	If !(SRA->RA_CATFUNC == "E")
		nTotDesc += ROUND(TMP->DESCONTO,2) // Valor total descontado dos funcionarios
	EndIf
	
	//Soma Valor Total e Desconto por Centro de Custo
	nTotCC += TMP->ZO_VALOR // Valor Total pago do Centro de Custo
	
	//----------Retira Estagiarios------------
	If !(SRA->RA_CATFUNC == "E")
		nDescCC += ROUND(TMP->DESCONTO,2) // Valor total descontado dos funcionarios por CENTRO DE CUSTO
	EndIf
	
	DBSelectArea("TMP")
	dbskip()
	
	// Contador de Funcionarios
	If cMat != TMP->ZO_MAT
		nCont += 1
		
		// Contador de Estagiarios
		If SRA->RA_CATFUNC  == "E"
			nContEst += 1
		EndIf
		
	EndIf
	
	
	
	//Logica para imprimir o centro de custo
	lCc := .F.
	If cCcusto != TMP->ZO_CC
		
		//Imprimi valor total por Centro de Custo
		@nLin, 100 PSAY "__________________________________"
		nLin += 1
		@nLin, 100 PSAY nTotCC PICTURE "@E 99,999.99"
		@nLin, 112 PSAY nDescCC PICTURE "@E 99,999.99"
		
		//Zero as variaveis para iniciar a soma por outro Centro de Custo
		nTotCC 	:= 0
		nDescCC := 0
		
		lCc := .T.
	EndIf
	
	
	
	
	
	nLin 			+= 1 // Avanca a linha de impressao
	lOk1 := .F.
	
ENDDO

If MV_PAR12 == 1
	
	@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "Qtd. Funcionários: "
	@nLin, 019 PSAY nCont
	@nLin, 112 PSAY nTotDesc PICTURE "@E 999,999.99"
	@nLin, 073 PSAY "Funcionário - Refeição:"
	@nLin, 100 PSAY nTotRef PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 072 PSAY "Funcionário - Alimentação:"
	@nLin, 100 PSAY nTotAlim PICTURE "@E 999,999.99"
	@nLin, 000 PSAY "Qtd. Estagiários: "
	@nLin, 019 PSAY nContEst
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 072 PSAY "Estagiário - Refeição:"
	@nLin, 100 PSAY nTotRefEst PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 072 PSAY "Estagiário - Alimentação:"
	@nLin, 100 PSAY nTotAliEst PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 100 PSAY nTotVal PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
	
ELSE // Cesta Basica
	
	@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "Qtd. Funcionários: "
	@nLin, 019 PSAY nCont
	@nLin, 112 PSAY nTotDesc PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 100 PSAY nTotVal PICTURE "@E 999,999.99"
	nLin 			+= 1 // Avanca a linha de impressao
	@nLin, 000 PSAY "-------------------------------------------------------------------------------------------------------------------------------------"
	
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

DBSelectArea("TMP")
DBCloseArea("TMP")
DBSelectArea("TMP1")
DBCloseArea("TMP1")

Return


Static Function Excel()

Local cTipo := ""
Private _cDtExp  := ""
Private _aCExcel := {}
Private _aIExcel := {}
Private _lRet := .T.

// **************************** Cria Arquivo Temporario
_aCExcel:={}//SPCSQL->(DbStruct())
aadd( _aCExcel , {"MAT"		    , "C" , 15 , 00 } )   	//01
aadd( _aCExcel , {"NOME	"		, "C" , 60 , 00 } )     //02
aadd( _aCExcel , {"ADMISSA"		, "C" , 10 , 00 } )     //03
aadd( _aCExcel , {"CONTRAT"		, "C" , 10 , 00 } )     //04
aadd( _aCExcel , {"INFER"		, "C" , 15 , 00 } )     //05
aadd( _aCExcel , {"FIMFER"		, "C" , 15 , 00 } )     //06
aadd( _aCExcel , {"TOTAL"		, "N" , 15 , 02 } )     //07
aadd( _aCExcel , {"DESCONTO"		, "N" , 15 , 02 } ) //08
aadd( _aCExcel , {"TIPO"			, "C" , 20 , 00 } ) //09

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP3",.F.,.F.)




DBSelectArea("TMP")
DBGotop()

procregua(nRecTMP)

While !TMP->(EOF())
	
	IncProc("Gerando Relatório em Excel......")
	
	DBSelectARea("SR8")
	DBSetOrder(1)
	iF (DBSeek(TMP->ZO_FILIAL + TMP->ZO_MAT))
		
		
		// Localiza o periodo das férias no pagamento do vale transporte
		
		While !EOF() .AND. TMP->ZO_MAT == SR8->R8_MAT
			
			
			
			If cPeriodo == SUBSTR(DTOS(SR8->R8_DATAINI),1,6) .OR. cPeriodo == SUBSTR(DTOS(SR8->R8_DATAFIM),1,6)
				
				lOk1 := .T.
				
				dDtaIni := SR8->R8_DATAINI
				dDtaFim := SR8->R8_DATAFIM
				
			EndIf
			
			Dbskip()
			
		EndDo
		
	EndIf
	
	
	cMat := TMP->ZO_MAT
	cCCusto  := TMP->ZO_CC
	
	
	DBSelectArea("SRA")
	DBSetOrder(1)
	DBSeek(TMP->ZO_FILIAL + TMP->ZO_MAT)
	
	
	If lCc == .T.
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01] := TMP->ZO_CC
		_aItem[02] := TMP->ZO_NOMECC
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		
		
		/*
		Reclock("TMP3",.T.)
		TMP3->MAT  := TMP->ZO_CC
		TMP3->NOME := TMP->ZO_NOMECC
		MsUnlock()
		
		RecLock("TMP3",.T.)
		MsUnlock()
		*/
		
	EndIf
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[01] := TMP->ZO_MAT
	_aItem[02] := TMP->ZO_NOME
	_aItem[03] := DTOC(SRA->RA_ADMISSA)
	
	
	/*
	Reclock("TMP3",.T.)
	TMP3->MAT	  := TMP->ZO_MAT
	TMP3->NOME 	  :=TMP->ZO_NOME
	TMP3->ADMISSA := DTOC(SRA->RA_ADMISSA)
	*/
	
	If SRA->RA_CATFUNC != "E"
		
		If cPeriodo == SUBSTR(DTOS(SRA->RA_VCTOTEM),1,6)
			
			_aItem[04] := DTOC(SRA->RA_VCTOTEM)
			
			/*
			TMP3->CONTRAT := DTOC(SRA->RA_VCTOTEM)
			*/
			
		EndIf
		
	else
		
		If cPeriodo == SUBSTR(DTOS(SRA->RA_VCTOEST),1,6)
			
			_aItem[04] := DTOC(SRA->RA_VCTOEST)
			
			/*
			TMP3->CONTRAT := DTOC(SRA->RA_VCTOEST)
			*/
		EndIf
		
	Endif
	
	If lOk1 == .T.
		
		_aItem[05] := DTOC(dDtaIni)
		_aItem[06] := DTOC(dDtaFim)
		
		/*
		TMP3->INFER := DTOC(dDtaIni)
		TMP3->FIMFER := DTOC(dDtaFim)
		*/
		
	EndIf
	
	_aItem[07] := TMP->ZO_VALOR
	
	/*
	TMP3->TOTAL := TMP->ZO_VALOR
	*/
	
	//Imprimi valor do desconto de estagiario
	If !(SRA->RA_CATFUNC == "E")
		
		_aItem[08] := ROUND(TMP->DESCONTO,2)
		
		/*
		TMP3->DESCONTO := ROUND(TMP->DESCONTO,2)
		*/
	EndIf
	
	IF TMP->ZO_TPREF == "1"
		cTipo :=  "Refeicao"
	ELSEIF TMP->ZO_TPREF == "2"
		cTipo :=  "Alimentação"
	ELSEIF TMP->ZO_TPREF == "3"
		cTipo :=  "Cesta Alimentação"
	EndIf
	
	_aItem[09] := cTipo
	
	//Adiciona os dados do excel
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	//	MSUNLOCK()
	
	nTotVal += TMP->ZO_VALOR // Valor Total pago aos funcionarios
	
	If TMP->ZO_TPREF == "1"
		If !(SRA->RA_CATFUNC == "E")
			nTotRef += TMP->ZO_VALOR // Valor pago somente para vale Refeicao
		else
			nTotRefEst += TMP->ZO_VALOR
		EndIf
		
	ELSEIF TMP->ZO_TPREF == "2"
		
		If !(SRA->RA_CATFUNC == "E")
			nTotAlim += TMP->ZO_VALOR // Valor pago somente para vale Alimentacao
		else
			nTotAliEst += TMP->ZO_VALOR
		EndIf
	EndIf
	
	//Soma do valor total de desconto
	If !(SRA->RA_CATFUNC == "E")
		nTotDesc += ROUND(TMP->DESCONTO,2) // Valor total descontado dos funcionarios
	EndIf
	
	//Soma Valor Total e Desconto por Centro de Custo
	nTotCC += TMP->ZO_VALOR // Valor Total pago do Centro de Custo
	
	//----------Retira Estagiarios------------
	If !(SRA->RA_CATFUNC == "E")
		nDescCC += ROUND(TMP->DESCONTO,2) // Valor total descontado dos funcionarios por CENTRO DE CUSTO
	EndIf
	
	DBSelectArea("TMP")
	dbskip()
	
	// Contador de Funcionarios
	If cMat != TMP->ZO_MAT
		nCont += 1
		
		// Contador de Estagiarios
		If SRA->RA_CATFUNC  == "E"
			nContEst += 1
		EndIf
		
	EndIf
	
	
	
	//Logica para imprimir o centro de custo
	lCc := .F.
	If cCcusto != TMP->ZO_CC
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[07] := nTotCC
		_aItem[08] := nDescCC
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		
		/*
		RecLock("TMP3",.T.)
		TMP3->TOTAL := nTotCC
		TMP3->DESCONTO := nDescCC
		MsUnlock()
		
		
		RecLock("TMP3",.T.)
		MsUnlock()
		
		*/
		
		//Zero as variaveis para iniciar a soma por outro Centro de Custo
		nTotCC 	:= 0
		nDescCC := 0
		
		lCc := .T.
	EndIf
	
	
	
	
	
	lOk1 := .F.
	
ENDDO


IF MV_PAR12 == 1
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[02] := "Qtd. Funcionarios: "
	_aItem[03] := cValToChar(nCont)
	_aItem[05] := "Funcionario"
	_aItem[06] := "Refeicao:"
	_aItem[07] := nTotRef
	_aItem[08] := nTotDesc
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	
	/*
	RecLock("TMP3",.T.)
	TMP3->NOME := "Qtd. Funcionarios: "
	TMP3->ADMISSA := cValToChar(nCont)
	TMP3->INFER := "Funcionario"
	TMP3->FIMFER := "Refeicao:"
	TMP3->TOTAL := nTotRef
	TMP3->DESCONTO := nTotDesc
	MsUnlock()
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[02] := "Qtd. Estagiarios: "
	_aItem[03] := cValToChar(nContEst)
	_aItem[05] := "Funcionario"
	_aItem[06] := "Alimentacao:"
	_aItem[07] := nTotAlim
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->NOME := "Qtd. Estagiarios: "
	TMP3->ADMISSA := cValToChar(nContEst)
	TMP3->INFER := "Funcionario"
	TMP3->FIMFER := "Alimentacao:"
	TMP3->TOTAL := nTotAlim
	MsUnlock()
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[05] := "Estagiario"
	_aItem[06] := "Refeicao:"
	_aItem[07] := nTotRefEst
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->INFER := "Estagiario"
	TMP3->FIMFER :="Refeicao:"
	TMP3->TOTAL := nTotRefEst
	MsUnlock()
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[05] := "Estagiario"
	_aItem[06] := "Refeicao:"
	_aItem[07] := nTotAliEst
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->INFER := "Estagiario"
	TMP3->FIMFER := "Alimentacao:"
	TMP3->TOTAL := nTotAliEst
	MsUnlock()
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[07] := nTotVal
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->TOTAL := nTotVal
	MsUnlock()
	*/
	
ELSE // CESTA BASICA
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[02] := "Qtd. Funcionarios: "
	_aItem[03] := cValToChar(nCont)
	_aItem[05] := "Funcionario"
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->NOME := "Qtd. Funcionarios: "
	TMP3->ADMISSA := cValToChar(nCont)
	TMP3->INFER := "Funcionario"
	MsUnlock()
	*/
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[07] := nTotVal
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	/*
	RecLock("TMP3",.T.)
	TMP3->TOTAL := nTotVal
	MsUnlock()
	*/
	
endif

DBSelectArea("TMP")
DBCloseArea("TMP")
DBSelectArea("TMP1")
DBCloseArea("TMP1")
//DBSelectArea("TMP3")
//DBCloseArea("TMP3")



IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Vale Refeicao - Record", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","RELVALE")
	_lRet := .F.
ENDIF

/*
If !ApOleClient("MsExcel")
MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
Return
EndIf

cArq     := _cTemp+".DTC"

__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
oExcelApp:SetVisible(.T.)
*/

Return




Static Function GravaFol()


DBSelectArea("TMP1")
DBGotop()

procregua(nRecTMP1)


While !EOF()
	
	IncProc("Gravando Folha......")
	
	DBSelectARea("SRA")
	DBSetOrder(1)
	DBSeek(TMP1->ZO_FILIAL + TMP1->ZO_MAT)
	If (SRA->RA_CATFUNC == "E")
		DBSelectArea("TMP1")
		dbskip()
		loop
	EndIf

//22/05/18 - Rafael - Substituição do comando GETMV("MV_FOLMES") por cPeriodo	
	
	DBSelectArea("RGB")
	DBSetOrder(5)
	If DBSeek(TMP1->ZO_FILIAL + "00001" + cPeriodo + "01" + "FOL" +  TMP1->ZO_MAT + "424") .AND. TMP1->ZO_TPREF == "1"
		
		
		Reclock("RGB",.F.)
		RGB->RGB_FILIAL		:= TMP1->ZO_FILIAL
		RGB->RGB_MAT		:= TMP1->ZO_MAT
		RGB->RGB_PD			:= "424"
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= TMP1->ZO_DIAS
		RGB->RGB_VALOR		:= ROUND(TMP1->DESCONTO,2)
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= TMP1->ZO_CC
		RGB->RGB_TIPO2		:= "I"
		MsUnlock()
		
	ELSEIF DBSeek(TMP1->ZO_FILIAL + "00001" + cPeriodo + "01" + "FOL" +  TMP1->ZO_MAT + "304") .AND. TMP1->ZO_TPREF == "2"
		
		Reclock("RGB",.F.)
		RGB->RGB_FILIAL		:= TMP1->ZO_FILIAL
		RGB->RGB_MAT			:= TMP1->ZO_MAT
		RGB->RGB_PD			:= "304"  // Alimentação
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= TMP1->ZO_DIAS
		RGB->RGB_VALOR		:= ROUND(TMP1->DESCONTO,2)
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= TMP1->ZO_CC
		RGB->RGB_TIPO2		:= "I"
		MsUnlock()
		
	ELSEIF DBSeek(TMP1->ZO_FILIAL + "00001" + cPeriodo + "01" + "FOL" +  TMP1->ZO_MAT + "322") .AND. TMP1->ZO_TPREF == "3"
		
		Reclock("RGB",.F.)
		RGB->RGB_FILIAL		:= TMP1->ZO_FILIAL
		RGB->RGB_MAT			:= TMP1->ZO_MAT
		RGB->RGB_PD			:= "322"  // Cesta Basica
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= TMP1->ZO_DIAS
		RGB->RGB_VALOR		:= ROUND(TMP1->DESCONTO,2)
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= TMP1->ZO_CC
		RGB->RGB_TIPO2		:= "I"
		MsUnlock()
		
		
		
	ELSE
		
		Reclock("RGB",.T.)
		RGB->RGB_FILIAL		:= TMP1->ZO_FILIAL
		RGB->RGB_MAT			:= TMP1->ZO_MAT
		If TMP1->ZO_TPREF == "1" // Refeição
			RGB->RGB_PD			:= "424"
		ELSEIF TMP1->ZO_TPREF == "2" // Alimentação
			RGB->RGB_PD			:= "304"  // Alimentação
		ELSEIF TMP1->ZO_TPREF == "3" // Cesta Basica
			RGB->RGB_PD			:= "322"  // Cesta Basica
		EndIf
		RGB->RGB_TIPO1		:= "V"
		RGB->RGB_HORAS		:= TMP1->ZO_DIAS
		RGB->RGB_VALOR		:= ROUND(TMP1->DESCONTO,2)
		RGB->RGB_DTREF		:= STOD(cPeriodo + "01")
		RGB->RGB_CC			:= TMP1->ZO_CC
		RGB->RGB_TIPO2		:= "I"
		RGB_PROCES 			:= "00001"
		RGB_PERIOD 			:= cPeriodo
		RGB_SEMANA 			:= "01"
		RGB_ROTEIR 			:= "FOL"
		RGB_QTDSEM  		:= 0
		RGB_PARCEL 			:= 0
		RGB_CODFUN 			:= TMP1->RA_CODFUNC
		RGB_DEPTO 			:= TMP1->RA_DEPTO
		RGB_DUM     		:= 0
		RGB_DDOIS   		:= 0
		RGB_DTRES   		:= 0
		RGB_DQUATR  		:= 0
		RGB_DCINCO  		:= 0
		RGB_DSEIS   		:= 0
		RGB_DSETE   		:= 0
		MsUnlock()
		
	EndIf
	
	DBSelectARea("TMP1")
	DBSkip()
	
Enddo

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
AADD(aRegs,{cPerg,"04","C. Custo De ?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"05","C. Custo Ate ?","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Mes ?","","","mv_ch06","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ano ?","","","mv_ch07","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Atualiza Movimento ?","","","mv_ch08","N",01,0,2,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Complementar ?","","","mv_ch09","N",01,0,2,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Ordenar Por ?","","","mv_ch10","N",01,0,2,"C","","mv_par10","Matricula","","","","","Nome","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Excel ?","","","mv_ch11","N",01,0,2,"C","","mv_par11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Tipo Refeicao ?","","","mv_ch12","N",01,0,2,"C","","mv_par12","Refeicao/Alimentacao","","","","","Cesta Alimentacao","","","","","","","","","","","","","","","","","","",""})




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

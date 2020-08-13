#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFTRANSPº Autor ³ Bruno Alves        º Data ³  11/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ º±±
±±º          ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONFTRANSP


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relatorio de Pagamento Vale Transporte"
Local nLin           := 100

Local Cabec1         := "Mat.    Nome                                     Admissao Fim Contrat  Ini Ferias   Fim Ferias       Total       Desconto"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "CONFTRANSP" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SRA"
Private cPerg	     := "CONFTRANS"
Private cQuery       := ""
Private lOk1		 := .F.
Private nTot		 := 0
Private nCont		 := 0
Private cCustos		 := ""   
Private nTotCC		 := 0
Private nContCC		 := 0
Private	nDescTotcc   := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If MV_PAR05 == 1
	titulo := "Relatorio de Pagamento Vale Transporte - Referente: " + SUBSTR(DTOC(MV_PAR04),4,8) + " - Pagamento: " + SUBSTR(DTOC(MV_PAR04),4,8) + ""
Else
	titulo := "Relatorio de Pagamento Vale Transporte - Referente: " + SUBSTR(DTOC(MV_PAR04),4,8) + " - Pagamento: " + SUBSTR(DTOC(MonthSub(MV_PAR04, 1)),4,8) + ""
EndIf

wnrel := SetPrint("",NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Utilizado para imprimir o relatorio   

//Rafael Franca - 27/09/11 - Inclusao do campo RA_CC para subtotais por Centro de Custo.
cQuery := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_VCTOTEM, SUM(R0_VALCAL) as TOTAL,RA_SALARIO,RA_CATFUNC,RA_CC FROM SRA010 "
cQuery += "INNER JOIN SR0010 ON "
cQuery += "SR0010.R0_FILIAL = SRA010.RA_FILIAL AND "
cQuery += "SR0010.R0_MAT = SRA010.RA_MAT "
cQuery += "WHERE "
cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "SRA010.RA_DEMISSA = '' AND "
cQuery += "SRA010.RA_SITFOLH <> 'D' AND "
cQuery += "SR0010.R0_VALCAL <> 0 AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "SR0010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_VCTOTEM,RA_SALARIO,RA_CATFUNC,RA_CC "
If MV_PAR06 == 1
	cQuery += "ORDER BY RA_CC,RA_MAT "
Else                                                    
	cQuery += "ORDER BY RA_CC,RA_NOME "
EndIf

tcQuery cQuery New Alias "TMP"



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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

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
nDesc 	 	:= 0
nDescTot 	:= 0
//Rafael Franca - 27/09/11 - Ususados para gravar valores por Centro de Custos
cCustos		:= ""   
nTotCC		:= 0
nContCC		:= 0
nDescTotcc  := 0


DBSelectArea("TMP")
DBGotop()       

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

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
	
	//Rafael Franca - 27/09/11 - Separacao por Centro de Custos
		
	IF (TMP->RA_CC != cCustos)
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY TMP->RA_CC
		@nLin, 015 PSAY Posicione("CTT",1,xFilial("CTT")+TMP->RA_CC,"CTT_DESC01")
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nTotCC		 := 0
		nContCC		 := 0
		nDescTotcc   := 0

	Endif
	
	DBSelectARea("SR8")
	DBSetOrder(1)
	iF (DBSeek(TMP->RA_FILIAL + TMP->RA_MAT))
		
		
		// Localiza o periodo das férias no pagamento do vale transporte
		
		While !EOF() .AND. TMP->RA_MAT == SR8->R8_MAT
			
			If SUBSTR(DTOS(MV_PAR04),1,6) == SUBSTR(DTOS(SR8->R8_DATAINI),1,6) .OR. SUBSTR(DTOS(MV_PAR04),1,6) == SUBSTR(DTOS(SR8->R8_DATAFIM),1,6)
				
				lOk1 := .T.
				
				dDtaIni := SR8->R8_DATAINI
				dDtaFim := SR8->R8_DATAFIM
				
			EndIf
			
			Dbskip()
			
		EndDo
		
	EndIf
	
	// Calculo do Desconto
	
	
	
	If TMP->RA_CATFUNC != "E"
		
		nDesc := TMP->RA_SALARIO * 0.06
		
		If nDesc > TMP->TOTAL
			nDesc := TMP->TOTAL
		EndIf
		
	Else
		
		nDesc := 0
		
	EndIf
	
	
	
	@nLin, 000 PSAY alltrim(TMP->RA_MAT)
	@nLin, 008 PSAY alltrim(TMP->RA_NOME)
	@nLin, 050 PSAY STOD(TMP->RA_ADMISSA)
	If SUBSTR(DTOS(MV_PAR04),1,6) == SUBSTR(TMP->RA_VCTOTEM,1,6)
		@nLin, 062 PSAY STOD(TMP->RA_VCTOTEM)
	else
		@nLin, 062 PSAY " / / "
	EndIf
	If lOk1 == .T.
		@nLin, 074 PSAY dDtaIni
		@nLin, 086 PSAY dDtaFim
	else
		@nLin, 074 PSAY " / / "
		@nLin, 086 PSAY " / / "
	EndIf
	@nLin, 098 PSAY TMP->TOTAL PICTURE "@E 999,999.99"
	@nLin, 110 PSAY nDesc PICTURE "@E 999,999.99"
	
	
	
	DBSelectARea("SR0")
	DBSetOrder(1)
	DBSeek(TMP->RA_FILIAL + TMP->RA_MAT)
	
	While !EOF() .AND. SR0->R0_MAT == TMP->RA_MAT
		
		nLin += 1
		
		DBSelectARea("SRN")
		DBSetOrder(1)
		DBSeek(xFilial("SRN") + SR0->R0_CODIGO)
		
		@nLin, 000 PSAY SR0->R0_CODIGO
		@nLin, 004 PSAY SRN->RN_DESC
		@nLin, 020 PSAY SRN->RN_VUNIATU PICTURE "@E 999.99"
		@nLin, 028 PSAY SR0->R0_QDIACAL
		@nLin, 033 PSAY SR0->R0_VALCAL PICTURE "@E 999.99"
		
		DBSelectArea("SR0")
		dbSkip()
		
	EndDo
	
	nLin += 1
	
	nTot     	+= TMP->TOTAL
	nDescTot 	+= nDesc	 
	nTotCC		 += TMP->TOTAL
	cCustos  	:= TMP->RA_CC
	nContCC		 += 1
	nDescTotcc   += nDesc
	
	DBSelectArea("TMP")
	DBSKIP() 	
	 
		//Rafael Franca - 27/09/11 - Separacao por Centro de Custos
	
	IF (TMP->RA_CC != cCustos)
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY "Total C. Custo:"
		@nLin, 025 PSAY SUBSTR(Posicione("CTT",1,xFilial("CTT")+ cCustos,"CTT_DESC01"),1,30) 
		@nLin, 060 PSAY nContCC
		@nLin, 098 PSAY nTotCC PICTURE "@E 999,999.99"
		@nLin, 111 PSAY nDescTotCC PICTURE "@E 999,999.99"
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 3 // Avanca a linha de impressao
	Endif

	nCont   += 1
	nLin 	+= 1
	lOk1 	:= .F. 
	
ENDDO

@nLin, 000 PSAY "-----------------------------------------------------------------------------------------------------------------------------"
nLin += 1
@nLin, 000 PSAY "Qtd. Funcionarios: "
@nLin, 019 PSAY nCont
@nLin, 094 PSAY nTot PICTURE "@E 999,999,999.99"
@nLin, 106 PSAY nDescTot PICTURE "@E 999,999,999.99"
nLin += 1
@nLin, 000 PSAY "-----------------------------------------------------------------------------------------------------------------------------"




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
DBSelectArea("SR8")
DBCloseArea("SR8")
DBSelectArea("SR0")
DBCloseArea("SR0")




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
AADD(aRegs,{cPerg,"04","Periodo ?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Complementar ?","","","mv_ch05","N",01,0,2,"C","","mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ordenar Por ?","","","mv_ch06","N",01,0,2,"C","","mv_par06","Matricula","","","","","Nome","","","","","","","","","","","","","","","","","","",""})





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

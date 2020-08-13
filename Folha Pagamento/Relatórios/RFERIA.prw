#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFERIA   º Autor ³ Rafael Franca      º Data ³ 24/09/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programacao de ferias especifica da Record                 º±±
±±          ±±     														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDEs                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFERIA()                                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := UPPER("Programacao de Ferias por Centro de Custos ")
Local nLin           := 110

Local Cabec1         := UPPER("Matr.   Funcionario                          Admissao    Periodo Aquisitivo        Per. Máximo Férias         Observação:                   Inicio Férias        Qtd. Dias          Assinatura do Colaborador")
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFERIA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFERIA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RFERIA4"
Private cString      := "SRF"
Private cQuery       := ""
Private nCont	    := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF                 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Imprimir relatorio com dados Financeiros ou de Clientes

Titulo := Titulo + " - "+(MV_PAR08)+""

cQuery := "SELECT RF_FILIAL,RF_MAT,RF_DATABAS,RA_NOME,RA_CATFUNC,RA_ADMISSA,RA_CC,RA_SITFOLH,RF_DATAINI,RF_DFEPRO1,RF_DATINI2,RF_DFEPRO2,RF_DATINI3,RF_DFEPRO3 FROM SRF010 "
cQuery += "INNER JOIN SRA010 ON "
cQuery += "SRF010.RF_FILIAL = SRA010.RA_FILIAL AND "
cQuery += "SRF010.RF_MAT = SRA010.RA_MAT "
cQuery += "WHERE "
cQuery += "SRF010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA010.RA_CC BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
IF !Empty (MV_PAR09)
	cQuery += "SRA010.RA_SITFOLH NOT IN " + FormatIn(MV_PAR09,";") + " AND "
Endif    
IF !Empty (MV_PAR10)
	cQuery += "SRA010.RA_CATFUNC NOT IN " + FormatIn(MV_PAR10,";") + " AND "
Endif
cQuery += "SRF010.RF_MAT BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "SRF010.RF_DATABAS BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND " 
cQuery += "SRF010.RF_STATUS <> '3' "  //Ferias que ja foram pagas
//cQuery += "SRF010.RF_DATAINI BETWEEN '" + DTOS(MV_PAR13) + "' AND '" + DTOS(MV_PAR14) + "' "
IF MV_PAR11 == 1
cQuery += "ORDER BY SRA010.RA_CC,SRF010.RF_MAT,SRF010.RF_DATABAS "  
ELSEIF MV_PAR11 == 2
cQuery += "ORDER BY SRA010.RA_CC,SRA010.RA_NOME,SRF010.RF_DATABAS "
ENDIF  

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

dbSelectArea("TMP")
dbCloseArea("TMP")

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

Local dBaseFer   	:= CtoD ("//")
Local dPerAqui1  	:= CtoD ("//")
Local dPerAqui2  	:= CtoD ("//")
Local dLimite 	 	:= CtoD ("//")
Local cCodCusto  	:= TMP->RA_CC
Local cCusto 	 	:= ""
Local cNome 	 	:= ""
Local cCodMat    	:= ""
Local nFuncio	 	:= 0
Local nFuncioCC	 	:= 0
Local lOk        	:= .T.
Local cOBS1  	 	:= "* AVISO IMPORTANTE:"
Local cOBS2      	:= " A PROGRAMACAO DE FERIAS DEVERA SER MARCADA SOMENTE APOS O VENCIMENTO DO PERIODO AQUISITIVO DE FERIAS." 	                       

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
	
	If nLin > 55  // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF MV_PAR07 == 1 .and. TMP->RA_CC != cCodCusto .and. nLin != 8
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIF
	
	
	IF (TMP->RA_CC != cCodCusto .or. lOk == .T.)
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 000 PSAY TMP->RA_CC
		@nLin, 010 PSAY Posicione("CTT",1,xFilial("CTT")+TMP->RA_CC,"CTT_DESC01")
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 000 PSAY Replicate("-",Limite)
		nLin += 2 // Avanca a linha de impressao 
	Endif
	
	   

	//If EMPTY(TMP->RF_DATAINI)    // Bruno Alves, verificar se a pessoal entrou de férias no ano
	                                    
	dBaseFer  	:= STOD(TMP->RF_DATABAS) 
	dPerAqui1   := STOD(TMP->RF_DATABAS)
	dPerAqui2   := (YEARSUM(dBaseFer,1) -1)
	dLimite 	:= (YEARSUM(dPerAqui2,1) -45)	

	//else
		
	//dBaseFer  	:= YEARSUM(STOD(TMP->RF_DATABAS),1)   
	//dPerAqui1   := YEARSUM(STOD(TMP->RF_DATABAS),1)
	//dPerAqui2   := (YEARSUM(dBaseFer,1)-1)
	//dLimite 	:= (YEARSUM(dPerAqui2,1) -45)	
	
	//Endif

	
	nLin += 1
	@nLin, 000 PSAY TMP->RF_MAT
	@nLin, 008 PSAY SUBSTR(TMP->RA_NOME,1,35)
	@nLin, 045 PSAY STOD(TMP->RA_ADMISSA)
	@nLin, 057 PSAY dPerAqui1
	@nLin, 068 PSAY "A"
	@nLin, 070 PSAY dPerAqui2
	@nLin, 083 PSAY (dPerAqui2 + 1)
	@nLin, 094 PSAY "A"
	@nLin, 096 PSAY dLimite
	@nLin, 110 PSAY Replicate ("_",26)
	//RF_DFEPRO1,RF_DATINI2,RF_DFEPRO2
	If STOD(TMP->RF_DATAINI) >= MV_PAR13 .AND. STOD(TMP->RF_DATAINI) <= MV_PAR14
	@nLin, 143 PSAY STOD(TMP->RF_DATAINI)
	@nLin, 160 PSAY PadC(STRZERO(ROUND(TMP->RF_DFEPRO1,0),2),12)	 
	ELSE 
	@nLin, 139 PSAY "_____/_____/_____" 
	@nLin, 160 PSAY Replicate ("_",12)	
	ENDIF
	//@nLin, 168 PSAY "Sim (  ) Nao (  )"
	@nLin, 180 PSAY Replicate ("_",33)
	nLin += 2 
  
  	@nLin, 110 PSAY Replicate ("_",26) 	
	If STOD(TMP->RF_DATINI2) >= MV_PAR13 .AND. STOD(TMP->RF_DATINI2) <= MV_PAR14
	@nLin, 143 PSAY STOD(TMP->RF_DATINI2)
	@nLin, 160 PSAY PadC(STRZERO(ROUND(TMP->RF_DFEPRO2,0),2),12)
	ELSE 
	@nLin, 139 PSAY "_____/_____/_____" 
	@nLin, 160 PSAY Replicate ("_",12)	
	ENDIF		
	@nLin, 180 PSAY Replicate ("_",33)	 	

IF EMPTY(TMP->RF_DATINI3)

nLin -= 1

ELSE

	nLin += 2

	@nLin, 110 PSAY Replicate ("_",26) 	
	If STOD(TMP->RF_DATINI3) >= MV_PAR13 .AND. STOD(TMP->RF_DATINI3) <= MV_PAR14
	@nLin, 143 PSAY STOD(TMP->RF_DATINI3)
	@nLin, 160 PSAY PadC(STRZERO(ROUND(TMP->RF_DFEPRO3,0),2),12)
	ELSE 
	@nLin, 139 PSAY "_____/_____/_____" 
	@nLin, 160 PSAY Replicate ("_",12)	
	ENDIF		
	@nLin, 180 PSAY Replicate ("_",33)	 	
	nLin -= 1
	
	ENDIF
	
	nFuncio   += 1
	nFuncioCC += 1
	cCodCusto := TMP->RA_CC
	
	dbskip()
	
	/*
	
	IF (TMP->RF_MAT != cCodMat)
	nLin += 1
	@nLin, 000 PSAY "Total de Horas do Funcionario "
	@nLin, 030 PSAY cCodMat  + " : "
	@nLin, 040 PSAY nHorasFunc
	nHorasFunc := 0
	nLin += 1
	ENDIF
	
	*/
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...  
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF (TMP->RA_CC != cCodCusto)
		nLin += 2
		@nLin, 000 PSAY "Total de Funcionarios do Centro de Custo "
		@nLin, 045 PSAY cCodCusto  + " : "
		@nLin, 060 PSAY nFuncioCC
		nLin += 3
		IF MV_PAR12 == 1   
		nLin += 2
		@nLin, 000 PSAY PADC(UPPER("_______________________________                             _______________________________"),220)
		nLin += 1 // Avanca a linha de impressao       
		@nLin, 000 PSAY PADC(UPPER("          Supervisor                                                Gerente / Diretor      "),220)
	    nLin += 1 // Avanca a linha de impressao    
	    EndIF
		nFuncioCC := 0
	ENDIF
	
	nLin := nLin + 2 // Avanca a linha de impressao
	
	lOk := .F.
	
ENDDO



nLin += 1
@nLin, 00 PSAY "Total de Funcionarios: "
@nLin, 30 PSAY nFuncio
@ 060, 000 PSAY cOBS1
@ 061, 000 PSAY cOBS2

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

Return

DBSelectArea("TMP")
DBCloseArea("TMP")


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Matricula ","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Matricula ","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Da  Data ","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Data ","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Do C. Custos","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Ate o C. Custos ","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","Salta pag. por CC?","","","mv_ch07","N",01,0,2,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ano ","","","mv_ch08","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Nao Imprimir Tipos","","","mv_ch09","C",10,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Nao Imp. Categorias","","","mv_ch10","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"11","Ordem","","","mv_ch11","N",01,0,2,"C","","mv_par11","Matricula","","","","","Nome","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Imprime Ass. Supervisor","","","mv_ch12","N",01,0,2,"C","","mv_par12","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Da  Programação ","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ate Programação ","","","mv_ch14","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
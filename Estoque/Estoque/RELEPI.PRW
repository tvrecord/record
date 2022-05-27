#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELEPI    º Autor ³ Rafael Franca      º Data ³ 06/07/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³RELATORIO DE EPI PARA FUNCIONARIOS DE OUTRAS FILIAIS        º±±
±±|          |     														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RELEPI                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELEPI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local titulo       	 := "Itens Vinculados ao Funcionário"
Local nLin           := 100
Local Cabec1         := " Produto   Descricao                                           QTD        Entrega     Situacao         Qtd. Devolvida  "
Local Cabec2         := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RELEPI"// Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELEPI"// Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RELEPI9"
Private cString      := "ZAA"
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

Local cCustos	:= ""
Local cMat	 	:= ""
Local cMatFun 	:= ""
Local nItens	:= 0
Local nItensTot := 0
Local nItensFun := 0
Local nItensCC	:= 0
Local nDev  	:= 0
Local nDevTot   := 0
Local nDevFun   := 0
Local nDevCC	:= 0

cQuery	:= "SELECT ZAA_FILIAL,ZAA_CODEPI,ZAA_MAT,ZAA_DTENTR,ZAA_QTDENT,ZAA_INDDEV,ZAA_QTDEVO,ZAA_DTDEVO,ZAA_MATFUN,ZAA_FUNNAM,B1_DESC,RA_CC,ZAA_OBS "
cQuery	+= "FROM ZAA010 "
cQuery	+= "INNER JOIN SB1010 ON ZAA010.ZAA_CODEPI = SB1010.B1_COD "
cQuery	+= "INNER JOIN SRA010 ON ZAA_FILIAL = RA_FILIAL AND ZAA_MAT = RA_MAT "
cQuery	+= "WHERE ZAA010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND SRA010.D_E_L_E_T_ <> '*'"
IF 		MV_PAR10 == 2
	cQuery	+= "AND ZAA_QTDEVO = ZAA_QTDENT "
ELSEIF 	MV_PAR10 == 3
	cQuery	+= "AND ZAA_QTDEVO < ZAA_QTDENT "
ENDIF

IF 	   !EMPTY(MV_PAR17)
	cQuery	+= "AND SB1010.B1_DESC LIKE '%"+ALLTRIM(MV_PAR17)+"%' "
ENDIF
cQuery	+= "AND ZAA010.ZAA_CODEPI BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery	+= "AND ZAA010.ZAA_MAT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
//cQuery	+= "AND ZAA010.ZAA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
cQuery	+= "AND ZAA010.ZAA_DTENTR BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
IF MV_PAR10 == 2
cQuery	+= "AND ZAA010.ZAA_DTDEVO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' "
ENDIF
cQuery	+= "AND SB1010.B1_LOCPAD BETWEEN '" + MV_PAR14 + "' AND '" + MV_PAR15 + "' "
IF 		MV_PAR09 == 1
	cQuery	+= "ORDER BY SRA010.RA_CC,ZAA010.ZAA_MAT,ZAA010.ZAA_MATFUN,ZAA010.ZAA_CODEPI"
ELSEIF 	MV_PAR09 == 2
	cQuery	+= "ORDER BY SRA010.RA_CC,ZAA010.ZAA_MAT,ZAA010.ZAA_MATFUN,SB1010.B1_DESC"
ELSEIF 	MV_PAR09 == 3
	cQuery	+= "ORDER BY SRA010.RA_CC,ZAA010.ZAA_MAT,ZAA010.ZAA_MATFUN,ZAA010.ZAA_DTENTR"
ENDIF

tcQuery cQuery New Alias "TMP"


If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea()
	Return
Endif


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
		dbSelectArea("TMP")
		dbCloseArea()
		Exit


	Endif

	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif


	IF (TMP->RA_CC != cCustos) .AND. MV_PAR13 == 1
		nLin := nLin + 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY TMP->RA_CC
		@nLin, 015 PSAY Posicione("CTT",1,xFilial("CTT")+RA_CC,"CTT_DESC01")
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nITens	 	:= 0
		nDev		:= 0
	Endif

	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	IF (TMP->ZAA_MAT != cMat)
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin, 001 PSAY UPPER("Matricula:")
		@nLin, 015 PSAY TMP->ZAA_MAT
		@nLin, 026 PSAY SUBSTR(Posicione("SRA",1,xFilial("SRA")+TMP->ZAA_MAT,"RA_NOME"),1,35)
		@nLin, 065 PSAY "FUNÇAO:"
		@nLin, 073 PSAY Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
		IF MV_PAR13 == 2
		@nLin, 098 PSAY "C. CUSTO:"
		@nLin, 107 PSAY Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
		ENDIF
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nITens	 	:= 0
		nDev		:= 0
	Endif

	If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	@nLin, 001 PSAY Alltrim(TMP->ZAA_CODEPI)
	@nLin, 012 PSAY SUBSTR(TMP->B1_DESC,1,40)
	@nLin, 061 PSAY TMP->ZAA_QTDENT PICTURE "@E 999"
	@nLin, 074 PSAY STOD(TMP->ZAA_DTENTR)
	IF TMP->ZAA_QTDENT == ZAA_QTDEVO
	@nLin, 086 PSAY "Devolvido"
	ELSEIF TMP->ZAA_QTDEVO > 0 .AND.TMP->ZAA_QTDEVO < TMP->ZAA_QTDENT
	@nLin, 086 PSAY "Dev. Parc."
	ELSE
	@nLin, 086 PSAY "Com Funcionario"
	ENDIF
	@nLin, 107 PSAY TMP->ZAA_QTDEVO PICTURE "@E 999"

	IF !EMPTY(TMP->ZAA_OBS)
	nLin += 1
	@nLin, 001 PSAY "OBS: "
	@nLin, 006 PSAY ALLTRIM(TMP->ZAA_OBS)
	ENDIF

	nItens   	+= TMP->ZAA_QTDENT
	nItensTot 	+= TMP->ZAA_QTDENT
	nItensFun 	+= TMP->ZAA_QTDENT
	nItensCC	+= TMP->ZAA_QTDENT
	nDev	   	+= TMP->ZAA_QTDEVO
	nDevTot 	+= TMP->ZAA_QTDEVO
	nDevFun 	+= TMP->ZAA_QTDEVO
	nDevCC		+= TMP->ZAA_QTDEVO
	cCustos		:= TMP->RA_CC
	cMat 		:= TMP->ZAA_MAT
	cMatFun		:= TMP->ZAA_MATFUN
	cFunName    := TMP->ZAA_FUNNAM


	dbSelectArea ("TMP")
	dbskip()


	IF (TMP->ZAA_MATFUN != cMatFun) .AND. !EMPTY(cMatFun)
	nLin += 2
	@nLin, 000 PSAY UPPER("Funcionario -->")
	@nLin, 018 PSAY Alltrim(cMatFun)
	@nLin, 028 PSAY Alltrim(cFunName)
	@nLin, 062 PSAY nItensFun PICTURE "@E 999"
	@nLin, 107 PSAY nDevFun PICTURE "@E 999"
	//@nLin, 099 PSAY "ASS: ______________________"
	nItensFun := 0
	nDevFun  := 0
	nLin += 1
	ENDIF


	IF (TMP->ZAA_MAT != cMat)
		nLin += 2
		@nLin, 001 PSAY "Total do Matricula -->"
		@nLin, 026 PSAY Posicione("SRA",1,xFilial("SRA")+ cMat ,"RA_NOME")
		@nLin, 062 PSAY nItens	  PICTURE "@E 999"
		@nLin, 107 PSAY nDev	  PICTURE "@E 999"
		//@nLin, 100 PSAY "ASS: ______________________"
		nLin += 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	ENDIF

		If nLin > 70 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

		IF (TMP->RA_CC != cCustos) .AND. MV_PAR13 == 1
		nLin += 2
		@nLin, 001 PSAY "Total Centro de Custo -->"
		@nLin, 027 PSAY SUBSTR(Posicione("CTT",1,xFilial("CTT")+ cCustos,"CTT_DESC01"),1,32)
		@nLin, 062 PSAY nItensCC	  PICTURE "@E 999"
		@nLin, 107 PSAY nDevCC	      PICTURE "@E 999"
		//@nLin, 100 PSAY "ASS: ______________________"
		nLin += 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	ENDIF

	nLin 		+= 1 // Avanca a linha de impressao

ENDDO

@nLin, 001 PSAY UPPER("Total de Itens ")
@nLin, 061 PSAY nItensTot PICTURE "@E 999"
@nLin, 107 PSAY nDevTot   PICTURE "@E 999"


IF MV_PAR16 == 1

nLin 		+= 3

@nLin, 001 PSAY "    Ocorrendo desligamento por parte do colaborador ou pela empresa, todos os documentos, Rádio Nextel, Telefone Celular, uniforme,"
nLin 		+= 1
@nLin, 001 PSAY "crachá, equipamentos, ferramentas e os EPIs que pertence a emissora e estiver sob sua responsabilidade, deverá ser devolvido até"
nLin 		+= 1
@nLin, 001 PSAY "a data prevista abaixo com ciencia na assinatura de seu desligamento, caso isso não ocorra os valores correspondentes serão "
nLin 		+= 1
@nLin, 001 PSAY "descontados na rescisão."
nLin 		+= 2
@nLin, 001 PSAY "Data prevista para devolução: _____/_____/________"
nLin 		+= 2
@nLin, 001 PSAY "Ciente:  _____/_____/________"

ENDIF

dbSelectArea("TMP")
dbCloseArea()


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

Static Function ValidPerg(cPerg)

Local aArea	:= GetArea()
Local aRegs	:= {}
Local i,j

cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do  Funcionario	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Funcionario	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Do  Supervisor	","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""}) // Campo Retirado
AADD(aRegs,{cPerg,"04","Ate Supervisor	","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Emissao 	","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Emissao 	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da  EPI		    ","","","mv_ch07","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","TN3"})
AADD(aRegs,{cPerg,"08","Ate EPI			","","","mv_ch08","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","TN3"})
AADD(aRegs,{cPerg,"09","Ordem			","","","mv_ch09","N",01,0,2,"C","","mv_par09","Produto","","","","","Descricao","","","","","Dt Entrega","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Imprime:		","","","mv_ch10","N",01,0,2,"C","","mv_par10","Ambos","","","","","Devolvidos","","","","","Com Funcionario","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Da  Devolucao 	","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Devolucao 	","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Totais por CC?  ","","","mv_ch13","N",01,0,2,"C","","mv_par13","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Do  Armazem	    ","","","mv_ch14","C",02,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Ate Armazem	    ","","","mv_ch15","C",02,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Termo Desligamento?","","","mv_ch16","N",01,0,2,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Filtro Descrição:","","","mv_ch17","C",50,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

RestArea(aArea)

Return
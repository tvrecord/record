#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCR129  บ Autor ณ Edmilson D. Santos  บ Data ณ  14/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Dirf Mensal                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV Record                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCR129()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio de Dirf Mensal"
Local cPict        := ""
Local titulo       := "Relatorio de Dirf Mensal"
Local nLin         := 80

Local imprime      := .T.
Local Cabec1       := "Fi C.Custo   Matr. Nome                                    Folha / Lucro   Adiantamento         Ferias    13. Salario   T O T A I S"
Local Cabec2       := "                                                               Base / IR      Base / IR      Base / IR      Base / IR     Base / IR"

Private aOrd       := {""}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "RTCR129" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTCR129" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 	 := "SRA"
cPerg 		:= "RTR129"

ValidPerg()
pergunte(cPerg,.t.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

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
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/09/04   บฑฑ
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

Local cQry, I
Local aArqTemp   := {}
Local cArqTemp   := ""
Private cMat

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os periodos onde devem ser lidos os identificadores deณ
//ณ verbas de folha de pagamento e adiantamento de salario.      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MesAno(MV_PAR07) <> MesAno(MV_PAR08)
	Aviso("Aviso","As datas inicial e final devem estar dentro do mesmo m๊s e ano. Verifique.", {"OK"})
	Return nil
Endif

IF STRZERO(YEAR(MV_PAR07),4)+STRZERO(MONTH(MV_PAR07),2) < GETMV("MV_FOLMES")
	cQry := "SELECT RA_FILIAL AS FILIAL,RA_MAT AS MAT,RA_CC AS CC,RA_NOME AS NOME,RD_FILIAL AS FILIAL2,RD_MAT AS MAT2,RD_CC AS CC2,RD_PD AS VERBA,"
	cQry += "       RD_DATPGT AS PAGTO,RD_VALOR AS VALOR "
	cQry += "FROM   "+RetSqlName("SRA")+" RA,"+RetSqlName("SRD")+" RD "
	cQry += "WHERE  RA.RA_FILIAL = RD.RD_FILIAL AND"
	cQry += "       RA.RA_MAT    = RD.RD_MAT AND    "
	cQry += "       SUBSTRING(RD.RD_DATPGT,1,6) = '"+STRZERO(YEAR(mv_par07),4)+STRZERO(MONTH(mv_par07),2)+"'  AND"
	cQry += "       RA.RA_MAT    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry += "       RD.RD_CC     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += "       RD.RD_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQry += "       RD.RD_PD IN('711','741','405','705','708','710','707','495','717','726','403') AND
	cQry += "       RA.D_E_L_E_T_ = ' ' AND "
	cQry += "       RD.D_E_L_E_T_ = ' '     "
	cQry += " ORDER BY RA.RA_FILIAL, RA.RA_MAT "
ELSEIF GETMV("MV_FOLMES") == STRZERO(YEAR(MV_PAR07),4)+STRZERO(MONTH(MV_PAR07),2)
	cQry := "SELECT RA_FILIAL AS FILIAL,RA_MAT AS MAT,RA_CC AS CC,RA_NOME AS NOME,RC_FILIAL AS FILIAL2,RC_MAT AS MAT2,RC_CC AS CC2,RC_PD AS VERBA,"
	cQry += "       RC_DATA AS PAGTO,RC_VALOR AS VALOR "
	cQry += "FROM   "+RetSqlName("SRA")+" RA,"+RetSqlName("SRC")+" RC "
	cQry += "WHERE  RA.RA_FILIAL = RC.RC_FILIAL AND"
	cQry += "       RA.RA_MAT    = RC.RC_MAT AND    "
	cQry += "       SUBSTR(RC.RC_DATA,1,6) = '"+STRZERO(YEAR(mv_par07),4)+STRZERO(MONTH(mv_par07),2)+"'  AND"
	cQry += "       RA.RA_MAT    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQry += "       RC.RC_CC     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
	cQry += "       RC.RC_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQry += "       RC.RC_PD IN('711','741','405','705','708','710','707','495','717','726','403') AND
	cQry += "       RA.D_E_L_E_T_ = ' ' AND "
	cQry += "       RC.D_E_L_E_T_ = ' '     "
	cQry += " ORDER BY RA.RA_FILIAL, RA.RA_MAT "
ELSE
	MsgBox("Perํodo fora das especifica็๕es dos arquivos de Acumulados ou Mensal (SRD-SRC).","Atencao","STOP")
	Return
ENDIF
IF SELECT("TRB") > 0
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
ENDIF

TCQUERY cQry NEW ALIAS "TRB"
AADD(aArqTemp,{"FILIAL"	  ,"C",02,0})
AADD(aArqTemp,{"MATRICULA","C",06,0})
AADD(aArqTemp,{"NOME"     ,"C",30,0})
AADD(aArqTemp,{"PAGAMENTO","D",08,0})
AADD(aArqTemp,{"VERBA"    ,"C",03,0})
AADD(aArqTemp,{"CCUSTO"   ,"C",08,0})
AADD(aArqTemp,{"BASEFOLHA","N",12,2})
AADD(aArqTemp,{"BASEADIAN","N",12,2})
AADD(aArqTemp,{"BASEFERIA","N",12,2})
AADD(aArqTemp,{"BASE13SAL","N",12,2})
AADD(aArqTemp,{"IRFOLHA"  ,"N",12,2})
AADD(aArqTemp,{"DTIRFOLHA","D",08,0})
AADD(aArqTemp,{"IRADIAN"  ,"N",12,2})
AADD(aArqTemp,{"DTIRADIAN","D",08,0})
AADD(aArqTemp,{"IRFERIA"  ,"N",12,2})
AADD(aArqTemp,{"DTIRFERIA","D",08,0})
AADD(aArqTemp,{"IR13SAL"  ,"N",12,2})
AADD(aArqTemp,{"DTIR13SAL","D",08,0})
cArqTemp := CriaTrab(aArqTemp)
dbUseArea(.T.,__LocalDriver,cArqTemp,"MAP")
IndRegua("MAP",cArqTemp,"FILIAL+MATRICULA")

DBSELECTAREA("TRB")
SetRegua(RecCount())

While !EOF()
	
	DBSELECTAREA("MAP")
	DBSEEK(TRB->FILIAL+TRB->MAT)
	IF FOUND()
		RECLOCK("MAP",.F.)
	ELSE
		RECLOCK("MAP",.T.)
		MAP->FILIAL    := TRB->FILIAL
		MAP->MATRICULA := TRB->MAT
		MAP->NOME      := TRB->NOME
		MAP->CCUSTO    := TRB->CC
	ENDIF
	
	pMat 				:= TRB->FILIAL+TRB->MAT
	
	IF TRB->VERBA $ "711/741"    //BASE DE FOLHA
		MAP->BASEFOLHA += TRB->VALOR
	ELSEIF TRB->VERBA $ "405/705"  //IR DE FOLHA
		MAP->IRFOLHA   += TRB->VALOR
		MAP->DTIRFOLHA := STOD(TRB->PAGTO)
	ELSEIF TRB->VERBA == "708"  //BASE ADIANTAMENTO
		MAP->BASEADIAN += TRB->VALOR
	ELSEIF TRB->VERBA == "710"  //IR ADIANTAMENTO
		MAP->IRADIAN   += TRB->VALOR
		MAP->DTIRADIAN := STOD(TRB->PAGTO)
	ELSEIF TRB->VERBA $ "707/717"  //BASE DE FERIAS
		MAP->BASEFERIA += TRB->VALOR
	ELSEIF TRB->VERBA == "495"  //IR DE FERIAS
		MAP->IRFERIA   += TRB->VALOR
		MAP->DTIRFERIA := STOD(TRB->PAGTO)
	ELSEIF TRB->VERBA == "726"  //BASE DE 13 SALARIO
		MAP->BASE13SAL += TRB->VALOR
	ELSEIF TRB->VERBA == "403"  //IR DE 13 SALARIO
		MAP->IR13SAL   += TRB->VALOR
		MAP->DTIR13SAL := STOD(TRB->PAGTO)
	ENDIF
	
	DadosSRH() //Procuro Dados de Cabe็alho nas Ferias.
	MAP->(MSUNLOCK())

	dbselectarea("TRB")
	TRB->(DBSKIP())
	
ENDDO

pBASEFOLHA := 0
pBASEADIAN := 0
pBASEFERIA := 0
pBASE13SAL := 0

pIRFOLHA  := 0
pIRADIAN  := 0
pIRFERIA  := 0
pIR13SAL  := 0

DBSELECTAREA("MAP")
DBGOTOP()
IndRegua("MAP",cArqTemp,"FILIAL+NOME")

WHILE !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	IF nLin > 55
		//nLin++
		nLin:=Cabec(titulo+SPACE(5)+"Periodo: "+dtoc(mv_par07)+" a "+dtoc(mv_par08),cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		nLin++
	ENDIF
	
	IF MAP->IRFOLHA+MAP->IRADIAN+MAP->IRFERIA+MAP->IR13SAL > 0
		
		@ nLin,000  PSAY MAP->FILIAL
		@ nLin,003  PSAY LEFT(MAP->CCUSTO,7)
		@ nLin,012  PSAY MAP->MATRICULA
		@ nLin,021  PSAY LEFT(MAP->NOME,28)
		@ nLin,060  PSAY IF(MAP->IRFOLHA > 0,MAP->BASEFOLHA,0) PICTURE "@EZ 9,999,999.99"
		@ nLin,075  PSAY IF(MAP->IRADIAN > 0,MAP->BASEADIAN,0) PICTURE "@EZ 9,999,999.99"
		@ nLin,090  PSAY IF(MAP->IRFERIA > 0,MAP->BASEFERIA,0) PICTURE "@EZ 9,999,999.99"
		@ nLin,105  PSAY IF(MAP->IR13SAL > 0,MAP->BASE13SAL,0) PICTURE "@EZ 9,999,999.99"
		@ nLin,118  PSAY IF(MAP->IRFOLHA > 0,MAP->BASEFOLHA,0)+IF(MAP->IRADIAN > 0,MAP->BASEADIAN,0)+IF(MAP->IRFERIA > 0,MAP->BASEFERIA,0)+;
		IF(MAP->IR13SAL > 0,MAP->BASE13SAL,0) PICTURE "@EZ 99,999,999.99"
		//MAP->BASEFOLHA+MAP->BASEADIAN+MAP->BASEFERIA+MAP->BASE13SAL PICTURE "@E 99,999,999.99"
		nLin++
		@ nLin,060  PSAY MAP->IRFOLHA PICTURE "@EZ 9,999,999.99"
		@ nLin,075  PSAY MAP->IRADIAN PICTURE "@EZ 9,999,999.99"
		@ nLin,090  PSAY MAP->IRFERIA PICTURE "@EZ 9,999,999.99"
		@ nLin,105  PSAY MAP->IR13SAL PICTURE "@EZ 9,999,999.99"
		@ nLin,118  PSAY MAP->IRFOLHA+MAP->IRADIAN+MAP->IRFERIA+MAP->IR13SAL PICTURE "@EZ 99,999,999.99"
		nLin++
		IF !EMPTY(MAP->DTIRFOLHA)
			@ nLin,064  PSAY MAP->DTIRFOLHA
		ENDIF
		IF !EMPTY(MAP->DTIRADIAN)
			@ nLin,079  PSAY MAP->DTIRADIAN
		ENDIF
		IF !EMPTY(MAP->DTIRFERIA)
			@ nLin,094  PSAY MAP->DTIRFERIA
		ENDIF
		IF !EMPTY(MAP->DTIR13SAL)
			@ nLin,109  PSAY MAP->DTIR13SAL
		ENDIF
		nLin++
	ENDIF
		
	pBASEFOLHA += IF(MAP->IRFOLHA > 0,MAP->BASEFOLHA,0) //MAP->BASEFOLHA
	pBASEADIAN += IF(MAP->IRADIAN > 0,MAP->BASEADIAN,0) //MAP->BASEADIAN
	pBASEFERIA += IF(MAP->IRFERIA > 0,MAP->BASEFERIA,0) //MAP->BASEFERIA
	pBASE13SAL += IF(MAP->IR13SAL > 0,MAP->BASE13SAL,0) //MAP->BASE13SAL
	pIRFOLHA   += MAP->IRFOLHA
	pIRADIAN   += MAP->IRADIAN
	pIRFERIA   += MAP->IRFERIA
	pIR13SAL   += MAP->IR13SAL
		
	dbselectarea("MAP")
	dbSkip()
		
END
	
IF pBASEFOLHA+pBASEADIAN+pBASEFERIA+pBASE13SAL > 0 .OR. pIRFOLHA+pIRADIAN+pIRFERIA+pIR13SAL > 0
	@nLin,000 PSAY __PrtThinLine()
	nLin++
	@nLin,000 PSAY "TOTAL FILIAL: "+SM0->M0_CODFIL+"  "+ALLTRIM(SM0->M0_FILIAL)
	@nLin,060 PSAY pBASEFOLHA PICTURE "@EZ 9,999,999.99"
	@nLin,075 PSAY pBASEADIAN PICTURE "@EZ 9,999,999.99"
	@nLin,090 PSAY pBASEFERIA PICTURE "@EZ 9,999,999.99"
	@nLin,105 PSAY pBASE13SAL PICTURE "@EZ 9,999,999.99"
	@nLin,118 PSAY pBASEFOLHA+pBASEADIAN+pBASEFERIA+pBASE13SAL PICTURE "@EZ 99,999,999.99"
	nLin++
	@nLin,060 PSAY pIRFOLHA PICTURE "@EZ 9,999,999.99"
	@nLin,075 PSAY pIRADIAN PICTURE "@EZ 9,999,999.99"
	@nLin,090 PSAY pIRFERIA PICTURE "@EZ 9,999,999.99"
	@nLin,105 PSAY pIR13SAL PICTURE "@EZ 9,999,999.99"
	@nLin,118 PSAY pIRFOLHA+pIRADIAN+pIRFERIA+pIR13SAL PICTURE "@EZ 99,999,999.99"
	nLin++
	@nLin,000 PSAY __PrtThinLine()
ENDIF
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
dbSelectArea( "MAP" )
dbCloseArea()
fErase(cArqTemp+GetDBExtension())
fErase(cArqTemp+OrdBagExt())
fErase(cArqTemp+OrdBagExt())

Return

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
aRegs	:=	{}

AADD(aRegs,{cPerg,"01","Filial De     ?",Space(20),Space(20),"mv_ch1","C",02,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SX0","","","","",""})
AADD(aRegs,{cPerg,"02","Filial Ate    ?",Space(20),Space(20),"mv_ch2","C",02,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SX0","","","","",""})
Aadd(aRegs,{cPerg,"03","C.Custo De    ?",Space(07),Space(07),"mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SI3","","","","",""})
Aadd(aRegs,{cPerg,"04","C.Custo Ate   ?",Space(07),Space(07),"mv_ch4","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SI3","","","","",""})
AADD(aRegs,{cPerg,"05","Matricula De  ?",Space(20),Space(20),"mv_ch5","C",06,0,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
AADD(aRegs,{cPerg,"06","Matricula Ate ?",Space(20),Space(20),"mv_ch6","C",06,0,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
AADD(aRegs,{cPerg,"07","Data Pagto De ?",Space(20),Space(20),"mv_ch7","D",08,0,0,"C","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Data Pagto Ate?",Space(20),Space(20),"mv_ch8","D",08,0,0,"C","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return

STATIC FUNCTION DADOSSRH()

Local aRecnoSRG := {}
Local aRecnoSRGD:= {}
Local cFolmes	 := SuperGetMv("MV_FOLMES",,"")
Local xMAT      := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura no SRG Funcionarios Demitidos                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRG" )
If dbSeek(pMat) //STRZERO(YEAR(MV_PAR07),4)+STRZERO(MONTH(MV_PAR07),2)            
	While !Eof() .And. pMat == SRG->RG_FILIAL + SRG->RG_MAT
		If SRG->RG_EFETIVA = "S" .And. (SRG->RG_DATAHOM >= MV_PAR07 .And. SRG->RG_DATAHOM <= MV_PAR08 )
			aAdd(aRecnoSRG,{SRG->RG_FILIAL+SRG->RG_MAT,SRG->RG_DTGERAR,SRG->RG_DATAHOM,SRG->RG_DATADEM,SRG->(RECNO())})
			dbSelectArea( "SRR" )
			DBSETORDER(1)
			If dbSeek( pMat + "R" + DtoS(SRG->RG_DTGERAR))
				While !Eof() .And. pMat + "R" + DtoC(SRG->RG_DTGERAR) == ;
					SRR->RR_FILIAL + SRR->RR_MAT + "R" + DtoC(SRR->RR_DATA)

					IF SRR->RR_PD $ "711/741"    //BASE DE FOLHA
						MAP->BASEFOLHA = SRR->RR_VALOR
					ELSEIF SRR->RR_PD $ "405/705"  //IR DE FOLHA
						MAP->IRFOLHA   := SRR->RR_VALOR
						MAP->DTIRFOLHA := SRR->RR_DATA
					ELSEIF SRR->RR_PD == "708"  //BASE ADIANTAMENTO
						MAP->BASEADIAN := SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "710"  //IR ADIANTAMENTO
						MAP->IRADIAN   := SRR->RR_VALOR
						MAP->DTIRADIAN := SRR->RR_DATA
					ELSEIF SRR->RR_PD $ "707/717"  //BASE DE FERIAS
						MAP->BASEFERIA = SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "495"  //IR DE FERIAS
						MAP->IRFERIA   := SRR->RR_VALOR
						MAP->DTIRFERIA := SRR->RR_DATA
					ELSEIF SRR->RR_PD == "726"  //BASE DE 13 SALARIO
						MAP->BASE13SAL := SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "403"  //IR DE 13 SALARIO
						MAP->IR13SAL   := SRR->RR_VALOR
						MAP->DTIR13SAL := SRR->RR_DATA
					ENDIF
					SRR->(dbSkip())
				Enddo
			Endif
		Endif
		dbSelectArea("SRG")
		dbSkip()
	Enddo
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as rescisoes que devem ter o Ir abatido.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nx := 1 to Len(aRecnoSRG)
	dbSelectArea("SRG")
	dbgoto(aRecnoSRG[nx,5])
	SRG->(dbskip(-1))
	If	SRG->RG_FILIAL+SRG->RG_MAT == aRecnoSRG[nx,1] .And. ;
		MesAno(SRG->RG_DTGERAR) == MesAno(aRecnoSRG[nx,2]) .And. ;
		MesAno(SRG->RG_DTGERAR) == MesAno(SRG->RG_DATADEM) .And. ;
		!SRG->(BOF())
		aAdd(aRecnoSRGD,{SRG->RG_FILIAL+SRG->RG_MAT,SRG->RG_DTGERAR,SRG->RG_DATAHOM,SRG->RG_DATADEM,SRG->(RECNO())})
	Endif
Next nx
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ajusta os valores de ir de rescisoes complementares dentro do mesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea( "SRR" )
For nx := 1 to Len(aRecnoSRGD)

	IF SRR->RR_PD $ "711/741"    //BASE DE FOLHA
		MAP->BASEFOLHA := SRR->RR_VALOR
	ELSEIF SRR->RR_PD $ "405/705"  //IR DE FOLHA
		MAP->IRFOLHA   := SRR->RR_VALOR
		MAP->DTIRFOLHA := SRR->RR_DATA
	ELSEIF SRR->RR_PD == "708"  //BASE ADIANTAMENTO
		MAP->BASEADIAN := SRR->RR_VALOR
	ELSEIF SRR->RR_PD == "710"  //IR ADIANTAMENTO
		MAP->IRADIAN   := SRR->RR_VALOR
		MAP->DTIRADIAN := SRR->RR_DATA
	ELSEIF SRR->RR_PD $ "707/717"  //BASE DE FERIAS
		MAP->BASEFERIA := SRR->RR_VALOR
	ELSEIF SRR->RR_PD == "495"  //IR DE FERIAS
		MAP->IRFERIA   := SRR->RR_VALOR
		MAP->DTIRFERIA := SRR->RR_DATA
	ELSEIF SRR->RR_PD == "726"  //BASE DE 13 SALARIO
		MAP->BASE13SAL := SRR->RR_VALOR
	ELSEIF SRR->RR_PD == "403"  //IR DE 13 SALARIO
		MAP->IR13SAL   := SRR->RR_VALOR
		MAP->DTIR13SAL := SRR->RR_DATA
	ENDIF
	
Next nx

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procura no SRH Funcionarios em Ferias                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//dbSelectArea( "SRH" )  

I:= ASCAN(xMAT,pMat) 

IF I == 0
	
	AADD(xMAT ,pMat) //adiciono a matricula	

	dbSelectArea( "SRH" )  
	If dbSeek(pMat )
		While !Eof() .And. pMat == SRH->RH_FILIAL + SRH->RH_MAT
			dDtBusFer := fDtBusFer() // Busca RH_DTRECIB ou RH_DTITENS
			If (SRH->RH_DTRECIB >= MV_PAR07 .And. SRH->RH_DTRECIB <= MV_PAR08 )
	  			dbSelectArea( "SRR" )
				DBSETORDER(1)
     			dbSeek( pMat + "F" + DtoS(dDtBusFer),.T. )
		   	WHILE !Eof() .And. SRH->RH_FILIAL + SRH->RH_MAT == SRR->RR_FILIAL + SRR->RR_MAT
		
					IF SRR->RR_PD $ "711/741"    //BASE DE FOLHA
						MAP->BASEFOLHA := SRR->RR_VALOR
					ELSEIF SRR->RR_PD $ "405/705"  //IR DE FOLHA
						MAP->IRFOLHA   := SRR->RR_VALOR
						MAP->DTIRFOLHA := SRR->RR_DATA
					ELSEIF SRR->RR_PD == "708"  //BASE ADIANTAMENTO
						MAP->BASEADIAN := SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "710"  //IR ADIANTAMENTO
						MAP->IRADIAN   := SRR->RR_VALOR
						MAP->DTIRADIAN := SRR->RR_DATA
					ELSEIF SRR->RR_PD $ "707/717"  //BASE DE FERIAS
						MAP->BASEFERIA := SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "495"  //IR DE FERIAS
						MAP->IRFERIA   := SRR->RR_VALOR
						MAP->DTIRFERIA := SRR->RR_DATA
					ELSEIF SRR->RR_PD == "726"  //BASE DE 13 SALARIO
						MAP->BASE13SAL := SRR->RR_VALOR
					ELSEIF SRR->RR_PD == "403"  //IR DE 13 SALARIO
						MAP->IR13SAL   := SRR->RR_VALOR
						MAP->DTIR13SAL := SRR->RR_DATA
					ENDIF          
			
			  		SRR->(DBSKIP())
		   
	         ENDDO
	         
      	ENDIF   
   
   		SRH->(dbSkip())
      	
		Enddo
		
	EndIF

Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ 13ง Salario -
// podera ser pago em  qq mes do ano              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dDataAux	:= mv_par07
If StrZero(YEAR(dDataAux),4) == SUBSTR(cFolmes,1,4)
	cAlias		:= "SRI"
	cCpo		:= "RI"
	cDatarq		:= MesAno(dDataAux)
	cCpoData	:= "_DATA"
	cChave		:= pMat
Else 
	cAlias		:= "SRD"
	cCpo		:= "RD"
	cDatarq		:= str(Year(dDataAux),4)+"13"
	cCpoData	:= "_DATPGT"
  //	cChave		:= pMat + cDatarq
Endif

Return                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDtBusFer บAutor  ณEmerson Rosa        บ Data ณ  25/05/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Testa se o campo existe e busca data de pagto das ferias.  บฑฑ
ฑฑบ          ณ Este campo sera utilizado para calculo de 2 recibos.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
STATIC Function fDtBusFer()
Local cAlias := ALIAS()
Static cEmpAtu
Static lExistCpo

dbSelectArea( "SRH" )
If lExistCpo == Nil .Or. cEmpAtu == Nil .Or. cEmpAtu # cEmpAnt
	cEmpAtu   := cEmpAnt
	lExistCpo := ( SRH->(FieldPos( "RH_DTITENS" )) # 0 )
EndIf

dDtRetorno := SRH->RH_DTRECIB
If lExistCpo .And. !Empty(SRH->RH_DTITENS)
	dDtRetorno := SRH->RH_DTITENS
EndIf
dbSelectArea( cAlias )

Return dDtRetorno
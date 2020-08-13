#INCLUDE "rwmake.ch"   
#INCLUDE "TopConn.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCR119   บ Autor ณ Cristiano D. Alves บ Data ณ  06/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio para impressใo da contribuicao sindical dos fun- บฑฑ
ฑฑบ          ณ cionแrios.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Record - DF                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCR119()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Contribuicao Sindical"
Local cPict          := ""
Local titulo       	:= ""
Local nLin         	:= 80
Local Cabec1       	:= "                                                                          CTPS"
Local Cabec2       	:= "MATRIC NOME                           FUNCAO               ADMISSAO NUMERO   SERIE UF  VLR. CONTRIB.   BASE CALCULO"
Local Cabec3       	:= ""
Local imprime      	:= .T.
Local aOrd 				:= {"Matricula","Nome"}
Private lEnd         := .F.
Private lAbortPrint 	:= .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RTCR119" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RTCR119" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg			:= "RTC119"
Private cString 		:= "SRA"

ValidPerg()
pergunte(cPerg,.T.)

titulo := OEMToANSI("Mensalidade Sindical    " + "Periodo: " + Transform(MV_PAR03,"@R 99/9999"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/07/07   บฑฑ
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

Local nOrdem      := aReturn[8]
Local _lSRC			:= .F.
Local cArqMov     := ""
Local cAliasMov   := "SRC"
Local aOrdBag		:= {}
Local _cCpo			:= ""
Local _cAno			:= Substr(MV_PAR03,3,6)
Local _cMes			:= Substr(MV_PAR03,1,2)
Local _cChave		:= ""
Local _nTotCt		:= 0
Local _nTotBs     := 0
Local _nTotFunc	:= 0
Local _nVlrCt		:= 0
Local _nVlrBs		:= 0
//Local "SRC"		:= ""
Local _cMat			:= ""
Local _cNSind		:= ""
Local _cCSind		:= ""
Local _cQuery		:= ""
Local _dDtBase		:= CTOD("31/"+Substr(MV_PAR03,1,2)+"/"+Substr(MV_PAR03,3,4))
Local _lRet			:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If !OpenSrc(MV_PAR03, @cAliasMov, @aOrdBag, @cArqMov,_dDtBase)
If SUBSTR(MV_PAR03,3,4)+SUBSTR(MV_PAR03,1,2) == SUBSTR(DTOS(dDataBase),1,6) //GETMV("MV_FOLMES")
	DBSELECTAREA("SRC")
	cAlias := "SRC"
ELSEIF SUBSTR(MV_PAR03,3,4)+SUBSTR(MV_PAR03,1,2) < SUBSTR(DTOS(dDataBase),1,6) //GETMV("MV_FOLMES")
	DBSELECTAREA("SRD")
	cAlias := "SRD"
ELSE
	MsgBox("Perํodo fora das especifica็๕es dos arquivos de Acumulados ou Mensal (SRD-SRC).","Atencao","STOP")
	Return
ENDIF
//Busca descri็ใo do sindicato
dbSelectArea("RCE")

dbSetOrder(1)
If dbSeek(xFilial("RCE")+MV_PAR06)
	_cCSind	:= RCE->RCE_CODIGO
	_cNSind	:= RCE->RCE_DESCRI
Else
	_cSind	:= "Sindicato nao encontrado!!!"
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("SRA")
If nOrdem == 1
	dbSetOrder(1)
ElseIf nOrdem == 2
	dbSetOrder(3)
EndIf
dbGoTop()
//dbSeek(xFilial("SRA")+MV_PAR01,.T.)
While !SRA->(EOF()) //.and. SRA->RA_MAT <= MV_PAR02
	
	If SRA->RA_MAT < MV_PAR01 .or. SRA->RA_MAT > MV_PAR02
		SRA->(dbSkip())
		Loop
	EndIf
	
	IncProc("Matricula: "+SRA->RA_MAT)
	//Verifica a categoria do funcionแrio
	If SRA->RA_CATFUNC <> MV_PAR04       
		
		SRA->(dbSkip())
		Loop
	EndIf
	//Verifica o sindicato do funcionแrio
	If SRA->RA_SINDICA <> MV_PAR06
		SRA->(dbSkip())
		Loop
	EndIf

	_cMat	:= SRA->RA_MAT //Matricula do funcionแrio
	
	dbSelectArea(cAlias) 				//Seleciono tabela conforme checagem acima
	dbSetOrder(1)							//Indice: RC_FILIAL+RC_MAT+RC_PD
	IF cAlias == "SRC"
		If SRC->(dbSeek(xFilial("SRC")+_cMat+MV_PAR05)) 	//movimenta็ใo acumulada
			_nVlrCt		:= SRC->RC_VALOR //Valor da Contribui็ใo
		ENDIF
	ELSE
		If SRD->(dbSeek(xFilial("SRD")+_cMat+SUBSTR(MV_PAR03,3,4)+SUBSTR(MV_PAR03,1,2)+MV_PAR05),.T.) 	//movimenta็ใo acumulada
			_nVlrCt		:= SRD->RD_VALOR //Valor da Contribui็ใo
		ENDIF
	ENDIF
	_nVlrBs		:= SRA->RA_SALARIO //Valor base. Salแrio base naquele periodo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		@nLin,000 PSAY "Sindicato: "+_cCSind+" - "+;
		_cNSind + " Tipo de contribuicao: " + Alltrim(Posicione("SX5",1,xFilial("SX5")+"28"+MV_PAR04,"X5_DESCRI"))
		nLin := 11
	Endif
	
	IF _nVlrCt > 0
		
		
		@nLin,000 PSAY _cMat                                                     			//Matricula
		@nLin,007 PSAY Alltrim(SUBSTR(SRA->RA_NOME,1,29))                                       		//Nome
		@nLin,038 PSAY Alltrim(SUBSTR(Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC"),1,19)) 		//Funcao
		@nLin,059 PSAY DTOC(SRA->RA_ADMISSA)                                    			//Admissao
		@nLin,068 PSAY SRA->RA_NUMCP																		//Numero da CTPS
		@nLin,077 PSAY SRA->RA_SERCP																		//Serie CTPS
		@nLin,083 PSAY SRA->RA_UFCP																		//UF CTPS
		@nLin,087 PSAY _nVlrCt 					Picture "@E 99,999,999.99"							//Valor Movimento
		@nLin,102 PSAY _nVlrBs 					Picture "@E 99,999,999.99" //Base de cแlculo
		
		_nTotCt	+= _nVlrCt
		_nTotBs	+= _nVlrBs
		_nTotFunc++
		
		_nVlrCt := 0
		_nVlrBs := 0
		
		nLin := nLin + 1 // Avanca a linha de impressao
	EndIf
	
	SRA->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

If _nTotFunc > 0
	nLin ++
	@nLin, 000 Psay "TOTAL FUNCIONARIOS --->"
	@nLin, 024 Psay _nTotFunc
	@nLin, 041 Psay "TOTAL GERAL ------------------------------->"
	@nLin, 087 Psay _nTotCt	Picture "@E 99,999,999.99"
	@nLin, 102 Psay _nTotBs	Picture "@E 99,999,999.99"
EndIf
//Else
//	Return
//EndIf
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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณCristiano D. Alves  บ Data ณ  06/07/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas no SX1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Record - DF                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Da Matricula       ?","","","mv_ch1","C",06,00,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"02","Ate a Matricula    ?","","","mv_ch2","C",06,00,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"03","Mes/Ano Referencia ?","","","mv_ch3","C",06,00,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"04","Categoria          ?","","","mv_ch4","C",01,00,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","28",""})
aAdd(aRegs,{cPerg,"05","Verba Valor Contrib?","","","mv_ch5","C",03,00,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRV",""})
aAdd(aRegs,{cPerg,"06","Qual Sindicato     ?","","","mv_ch6","C",02,00,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","RCE",""})

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

/*
0         10        20        30        40        50        60        70        80        90        100       110       120       130
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
CTPS
MATRIC NOME                           FUNCAO               ADMISSAO NUMERO   SERIE UF  VLR. CONTRIB.   BASE CALCULO
999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99/99/99 XXXXXXXX XXXXX XX  99,999,999.99  99,999,999.99
TOTAL FUNCIONARIOS ---> 99999            TOTAL GERAL ------------------------------->
*/
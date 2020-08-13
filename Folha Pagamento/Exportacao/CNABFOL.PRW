#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  08/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CNABFOL



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private oGeraTxt
Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,460 DIALOG oGeraTxt TITLE OemToAnsi("Gerao de Arquivo Texto")
//@ 02,10 TO 08,200
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SRA                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte("CNABFO    ")

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  08/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



IF !Empty(MV_PAR01)
	
	Private cArqTxt := ALLTRIM(MV_PAR03) + ".TXT" //"C:\RECORD" + SUBSTR(DTOS(MV_PAR01),5,2)+SUBSTR(DTOS(MV_PAR01),1,4) + ".TXT"
	Private nHdl    := fCreate(cArqTxt)
	
	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa a regua de processamento                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Processa({|| RunCont() },"Processando...")
	Return
	
Else
	
	MsgAlert("Favor preencher os parametros!!!","Atencao!")
	
Endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  08/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea(cString)
dbsetorder(8)
dbGoTop()



ProcRegua(RecCount()) // Numero de registros a processar

Mes := substr(DTOS(MV_PAR01),5,2)

DO CASE
	CASE Mes = "01"
		Nomemes := "JANEIRO"
	CASE Mes = "02"
		Nomemes := "FEVEREIRO"
	CASE Mes = "03"
		Nomemes := "MARวO"
	CASE Mes = "04"
		Nomemes := "ABRIL"
	CASE Mes = "05"
		Nomemes := "MAIO"
	CASE Mes = "06"
		Nomemes := "JUNHO"
	CASE Mes = "07"
		Nomemes := "JULHO"
	CASE Mes = "08"
		Nomemes := "AGOSTO"
	CASE Mes = "09"
		Nomemes := "SETEMBRO"
	CASE Mes = "10"
		Nomemes := "OUTUBRO"
	CASE Mes = "11"
		Nomemes := "NOVEMBRO"
	CASE Mes = "12"
		Nomemes := "DEZEMBRO"
ENDCASE

Mensag1    := mv_par04										 	//Mensagem 1
Mensag2    := mv_par05											//Mensagem 2
Mensag3    := mv_par06

Ok := .T.
Branco := Space(200)
While !EOF()
	
	IF SRA->RA_SITFOLH $ ("D,T")
		SRA->(dbSkip())
		Loop
	Endif
	
	//Implementado para nใo imprimir o recibo de pagamento dos PJS - Bruno Alves
	
	If SRA->RA_MAT > "910000" //.OR. !SRA->RA_MAT  $ ("000103/000948/000595/000360/000855/000139/000511/000315/000260/000730/001114/000456/000291/000938/000369")
		SRA->(dbSkip())
		Loop
	EndIf
	

	
	IF SRA->RA_CATFUNC = "A"
		SRA->(dbSkip())
		Loop
	Endif
	
	_TotDesc := 0
	_TotProv := 0
	_VlrLiq  := 0
	_BaseInss := 0
	_Fgtsmes  := 0
	_BaseIrrf := 0
	_BaseFgts := 0
	_IrAdian  := 0
	
	aSvAlias :={Alias(),IndexOrd(),Recno()}
	
	IncProc()
	
	If Ok
		nTamLin := 210
		cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
		
		cCpo := PADR("1",01)
		cLin := Stuff(cLin,01,01,cCpo)
		cCpo := PADR(SM0->M0_NOMECOM,60)
		cLin := Stuff(cLin,02,60,cCpo)
		cCpo := PADR(SM0->M0_CGC,14)
		cLin := Stuff(cLin,62,14,cCpo)
		cCpo := PADR(Nomemes,09)
		cLin := Stuff(cLin,76,09,cCpo)
		cCpo := PADR(YEAR(MV_PAR02),4)
		cLin := Stuff(cLin,85,4,cCpo)
		cCpo := PADR(SUBSTR(DTOS(MV_PAR02),7,2)+SUBSTR(DTOS(MV_PAR02),5,2)+SUBSTR(DTOS(MV_PAR02),1,4),8)
		cLin := Stuff(cLin,89,8,cCpo)
		cCpo := PADR(SUBSTR(BRANCO,1,113),113)
		cLin := Stuff(cLin,97,113,cCpo)
		
		
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Exit
			Endif
		Endif
		
		Ok := .F.
		
	Endif
	
	IF Select("TMP") > 0
		TMP->(dbCloseArea())
	ENDIF
	
	IF Select("TCC") > 0
		TCC->(dbCloseArea())
	ENDIF
	
	cQuery 	:= " SELECT  RJ_DESC "
	cQuery 	+= " FROM " + RetSqlName("SRJ")
	cQuery 	+= " WHERE RJ_FUNCAO = '" + SRA->RA_CODFUNC + "' AND"
	cQuery 	+= "	   D_E_L_E_T_  = ' ' "
	
	cQuery	:=	ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TMP"
	
	cQuery1 	:= " SELECT  CTT_DESC01 "
	cQuery1 	+= " FROM " + RetSqlName("CTT")
	cQuery1 	+= " WHERE CTT_CUSTO= '" + SRA->RA_CC + "' AND"
	cQuery1 	+= "	   D_E_L_E_T_  = ' ' "
	
	cQuery1	:=	ChangeQuery(cQuery1)
	
	TcQuery cQuery1 New Alias "TCC"
	
	
	nTamLin := 210
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	
	cCpo := PADR("2",01)
	cLin := Stuff(cLin,01,01,cCpo)
	cCpo := PADR(SRA->RA_MAT,08)
	cLin := Stuff(cLin,02,08,cCpo)
	cCpo := PADR(SRA->RA_NOME,50)
	cLin := Stuff(cLin,10,50,cCpo)
	cCpo := PADR(TMP->RJ_DESC,35)
	cLin := Stuff(cLin,60,35,cCpo)
	cCpo := PADR(SUBSTR(DTOS(SRA->RA_ADMISSA),7,2)+SUBSTR(DTOS(SRA->RA_ADMISSA),5,2)+SUBSTR(DTOS(SRA->RA_ADMISSA),1,4),8)
	cLin := Stuff(cLin,95,8,cCpo)
	cCpo := PADR(TCC->CTT_DESC01,50)
	cLin := Stuff(cLin,104,50,cCpo)
	cCpo := PADR(SUBSTR(SRA->RA_BCDEPSA,1,3),03)
	cLin := Stuff(cLin,154,03,cCpo)
	cCpo := PADR(SUBSTR(SRA->RA_BCDEPSA,4,6),06)
	cLin := Stuff(cLin,157,06,cCpo)
	cCpo := PADR(SRA->RA_CTDEPSA,11)
	cLin := Stuff(cLin,163,11,cCpo)
	cCpo := PADR(STRZERO(SRA->RA_SALARIO*100,11),11)
	cLin := Stuff(cLin,174,11,cCpo)
	
	cCpo := PADR(SRA->RA_CIC,11)
	cLin := Stuff(cLin,185,11,cCpo)
	
	cCpo := PADR(SRA->RA_NUMCP,08)
	cLin := Stuff(cLin,196,08,cCpo)
	
	cCpo := PADR(SUBSTR(BRANCO,1,06),06)
	cLin := Stuff(cLin,204,06,cCpo)
	
	TMP->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
	//ณ linha montada.                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	
	// REGISTRO TIPO 3
	
	
	IF Select("TPD") > 0
		TPD->(dbCloseArea())
	ENDIF
	
	_Mes  := GETMV("MV_FOLMES")
	_Mes1 := ANOMES(MV_PAR01)
	
	
	IF MV_PAR07 = 1  // Folha
		
		
		IF Alltrim(GETMV("MV_FOLMES")) == ALLTRIM(ANOMES(MV_PAR01)) // recibo ref a folha do mes
			
			cQuery2 	:= " SELECT  RC.RC_PD, RC.RC_HORAS, RC.RC_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
			cQuery2 	+= " FROM " + RetSqlName("SRC") + " RC" + ", " + RetSqlName("SRV") + " RV"
			cQuery2 	+= " WHERE RC.RC_PD = RV.RV_COD AND "
			cQuery2 	+= "       RC.RC_MAT     = '" + SRA->RA_MAT + "' AND "
			cquery2     += "       RV.RV_TIPOCOD <> '3' AND "
			cQuery2 	+= "	   RC.D_E_L_E_T_  = ' ' AND "
			cQuery2 	+= "	   RV.D_E_L_E_T_  = ' ' "
			cQuery2 	+= " ORDER BY RC.RC_PD, RV.RV_TIPOCOD "
			cQuery2	:=	ChangeQuery(cQuery2)
			
			TcQuery cQuery2 New Alias "TPD"
			
			While !TPD->(EOF())
				
				cCpo := PADR("3",01)
				cLin := Stuff(cLin,01,01,cCpo)
				cCpo := PADR(TPD->RC_PD,04)
				cLin := Stuff(cLin,02,04,cCpo)
				cCpo := PADR(TPD->RV_DESC,45)
				cLin := Stuff(cLin,06,45,cCpo)
				cCpo := PADR(STRZERO(TPD->RC_HORAS*100,6),06)
				cLin := Stuff(cLin,51,06,cCpo)
				cCpo := PADR(IF(TPD->RV_TIPOCOD="1","P","D"),01)
				cLin := Stuff(cLin,57,01,cCpo)
				cCpo := PADR(STRZERO(TPD->RC_VALOR*100,11),11)
				cLin := Stuff(cLin,58,11,cCpo)
				
				cCpo := PADR(SUBSTR(BRANCO,1,131),131)
				cLin := Stuff(cLin,69,131,cCpo)
				
				
				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					Endif
				Endif
				
				IF TPD->RV_TIPOCOD = "1"
					_TotProv := _TotProv + TPD->RC_VALOR
				Endif
				
				IF TPD->RV_TIPOCOD = "2"
					_TotDesc := _TotDesc + TPD->RC_VALOR
				Endif
				
				
				
				TPD->(dbSkip())
				
				
			Enddo
			
			// registro tipo 4
			
			IF Select("TBB") > 0
				TBB->(dbCloseArea())
			ENDIF
			
			cQuery3 	:= " SELECT  RC.RC_PD, RC.RC_HORAS, RC.RC_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
			cQuery3 	+= " FROM " + RetSqlName("SRC") + " RC" + ", " + RetSqlName("SRV") + " RV"
			cQuery3 	+= " WHERE RC.RC_PD = RV.RV_COD AND "
			cQuery3 	+= "       RC.RC_MAT     = '" + SRA->RA_MAT + "' AND "
			cquery3     += "       RC.RC_PD IN ('799','721','722','732','711','731','710')  AND "
			cQuery3 	+= "	   RC.D_E_L_E_T_  = ' ' AND "
			cQuery3 	+= "	   RV.D_E_L_E_T_  = ' ' "
			cQuery3 	+= " ORDER BY RC.RC_PD, RV.RV_TIPOCOD "
			cQuery3	:=	ChangeQuery(cQuery3)
			
			TcQuery cQuery3 New Alias "TBB"
			
			While !TBB->(EOF())
				
				IF TBB->RC_PD = "799"  //Lํquido a Receber//
					_VlrLiq := TBB->RC_VALOR
				Endif
				
				IF TBB->RC_PD = "721"  //Base de Inss at้ o teto mแximo//
					_BaseInss += TBB->RC_VALOR
				Endif
				
				IF TBB->RC_PD = "710"  //Base de Imposto de Renda sobre o Adiantamento//
					_IrAdian += TBB->RC_VALOR
				Endif
				
				IF TBB->RC_PD = "732"     // Valor do Recolhimento do FGTS do M๊s//
					_Fgtsmes := TBB->RC_VALOR
				Endif
				
				IF TBB->RC_PD = "711"    //Base de Imposto de Renda//
					_BaseIrrf := TBB->RC_VALOR
				Endif
				
				IF TBB->RC_PD = "731"    //Base de FGTS do M๊s//
					_BaseFgts := TBB->RC_VALOR
				Endif
				
				TBB->(dbSkip())
				
			Enddo
			
			
			cCpo := PADR("4",01)
			cLin := Stuff(cLin,01,01,cCpo)
			
			cCpo := PADR(STRZERO(_TotProv*100,11),11)
			cLin := Stuff(cLin,02,11,cCpo)
			
			cCpo := PADR(STRZERO(_TotDesc*100,11),11)
			cLin := Stuff(cLin,13,11,cCpo)
			
			cCpo := PADR(STRZERO(_VlrLiq*100,11),11)
			cLin := Stuff(cLin,24,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseFgts*100,11),11)
			cLin := Stuff(cLin,35,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseInss*100,11),11)
			cLin := Stuff(cLin,46,11,cCpo)
			
			cCpo := PADR(STRZERO(_FgtsMes*100,11),11)
			cLin := Stuff(cLin,57,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseIrrf*100,11),11)
			cLin := Stuff(cLin,68,11,cCpo)
			
			cCpo := PADR(STRZERO(_IrAdian*100,11),11)
			cLin := Stuff(cLin,79,11,cCpo)
			
			
			cCpo := PADR(SUBSTR(BRANCO,1,120),131)
			cLin := Stuff(cLin,90,120,cCpo)
			
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		Else
			cQuery2 	:= " SELECT  RD.RD_PD, RD.RD_HORAS, RD.RD_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
			cQuery2 	+= " FROM " + RetSqlName("SRD") + " RD" + ", " + RetSqlName("SRV") + " RV"
			cQuery2 	+= " WHERE RD.RD_PD = RV.RV_COD AND "
			cQuery2 	+= "       RD.RD_MAT     = '" + SRA->RA_MAT + "' AND "
			cQuery2 	+= "       RD.RD_DATARQ  = '" + ANOMES(MV_PAR01) + "' AND "
			cquery2     += "       RV.RV_TIPOCOD <> '3' AND "
			cQuery2 	+= "	   RD.D_E_L_E_T_  = ' ' AND "
			cQuery2 	+= "	   RV.D_E_L_E_T_  = ' ' "
			cQuery2 	+= " ORDER BY RD.RD_PD, RV.RV_TIPOCOD "
			cQuery2	:=	ChangeQuery(cQuery2)
			
			TcQuery cQuery2 New Alias "TPD"
			
			While !TPD->(EOF())
				
				If TPD->RD_PD = "405"
					x := TPD->RD_HORAS
				Endif
				cCpo := PADR("3",01)
				cLin := Stuff(cLin,01,01,cCpo)
				cCpo := PADR(TPD->RD_PD,04)
				cLin := Stuff(cLin,02,04,cCpo)
				cCpo := PADR(TPD->RV_DESC,45)
				cLin := Stuff(cLin,06,45,cCpo)
				cCpo := PADR(STRZERO(TPD->RD_HORAS*100,6),06)
				cLin := Stuff(cLin,51,06,cCpo)
				cCpo := PADR(IF(TPD->RV_TIPOCOD="1","P","D"),01)
				cLin := Stuff(cLin,57,01,cCpo)
				cCpo := PADR(STRZERO(TPD->RD_VALOR*100,11),11)
				cLin := Stuff(cLin,58,11,cCpo)
				
				cCpo := PADR(SUBSTR(BRANCO,1,141),141)
				cLin := Stuff(cLin,69,141,cCpo)
				
				
				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
					Endif
				Endif
				
				IF TPD->RV_TIPOCOD = "1"
					_TotProv := _TotProv + TPD->RD_VALOR
				Endif
				
				IF TPD->RV_TIPOCOD = "2"
					_TotDesc := _TotDesc + TPD->RD_VALOR
				Endif
				
				
				
				TPD->(dbSkip())
				
				
			Enddo
			
			// registro tipo 4
			
			IF Select("TBB") > 0
				TBB->(dbCloseArea())
			ENDIF
			
			cQuery3 	:= " SELECT  RD.RD_PD, RD.RD_HORAS, RD.RD_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
			cQuery3 	+= " FROM " + RetSqlName("SRD") + " RD" + ", " + RetSqlName("SRV") + " RV"
			cQuery3 	+= " WHERE RD.RD_PD = RV.RV_COD AND "
			cQuery3 	+= "       RD.RD_MAT     = '" + SRA->RA_MAT + "' AND "
			cQuery3 	+= "       RD.RD_DATARQ  = '" + ANOMES(MV_PAR01) + "' AND "
			cquery3     += "       RD.RD_PD IN ('799','721','722','732','711','731','710')  AND "
			cQuery3 	+= "	   RD.D_E_L_E_T_  = ' ' AND "
			cQuery3 	+= "	   RV.D_E_L_E_T_  = ' ' "
			cQuery3 	+= " ORDER BY RD.RD_PD, RV.RV_TIPOCOD "
			cQuery3	:=	ChangeQuery(cQuery3)
			
			TcQuery cQuery3 New Alias "TBB"
			
			While !TBB->(EOF())
				
				IF TBB->RD_PD = "799"
					_VlrLiq := TBB->RD_VALOR
				Endif
				
				IF TBB->RD_PD = "721"
					_BaseInss += TBB->RD_VALOR
				Endif
				
				IF TBB->RD_PD = "710"
					_IrAdian += TBB->RD_VALOR
				Endif
				
				IF TBB->RD_PD = "732"
					_Fgtsmes := TBB->RD_VALOR
				Endif
				
				IF TBB->RD_PD = "711"
					_BaseIrrf := TBB->RD_VALOR
				Endif
				
				IF TBB->RD_PD = "731"
					_BaseFgts := TBB->RD_VALOR
				Endif
				
				TBB->(dbSkip())
				
			Enddo
			
			
			cCpo := PADR("4",01)
			cLin := Stuff(cLin,01,01,cCpo)
			
			cCpo := PADR(STRZERO(_TotProv*100,11),11)
			cLin := Stuff(cLin,02,11,cCpo)
			
			cCpo := PADR(STRZERO(_TotDesc*100,11),11)
			cLin := Stuff(cLin,13,11,cCpo)
			
			cCpo := PADR(STRZERO(_VlrLiq*100,11),11)
			cLin := Stuff(cLin,24,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseFgts*100,11),11)
			cLin := Stuff(cLin,35,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseInss*100,11),11)
			cLin := Stuff(cLin,46,11,cCpo)
			
			cCpo := PADR(STRZERO(_FgtsMes*100,11),11)
			cLin := Stuff(cLin,57,11,cCpo)
			
			cCpo := PADR(STRZERO(_BaseIrrf*100,11),11)
			cLin := Stuff(cLin,68,11,cCpo)
			
			
			cCpo := PADR(STRZERO(_IrAdian*100,11),11)
			cLin := Stuff(cLin,79,11,cCpo)
			
			
			cCpo := PADR(SUBSTR(BRANCO,1,120),120)
			cLin := Stuff(cLin,90,120,cCpo)
			
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
			
		Endif
	Else // 13 salario
		
		cQuery2 	:= " SELECT  RI.RI_PD, RI.RI_HORAS, RI.RI_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
		cQuery2 	+= " FROM " + RetSqlName("SRI") + " RI" + ", " + RetSqlName("SRV") + " RV"
		cQuery2 	+= " WHERE RI.RI_PD = RV.RV_COD AND "
		cQuery2 	+= "       RI.RI_MAT     = '" + SRA->RA_MAT + "' AND "
		cquery2  += "       RV.RV_TIPOCOD <> '3' AND "
		cQuery2 	+= "	   RI.D_E_L_E_T_  = ' ' AND "
		cQuery2 	+= "	   RV.D_E_L_E_T_  = ' ' "
		cQuery2 	+= " ORDER BY RI.RI_PD, RV.RV_TIPOCOD "
		cQuery2	:=	ChangeQuery(cQuery2)
		
		TcQuery cQuery2 New Alias "TPD"
		
		While !TPD->(EOF())
			
			cCpo := PADR("3",01)
			cLin := Stuff(cLin,01,01,cCpo)
			cCpo := PADR(TPD->RI_PD,04)
			cLin := Stuff(cLin,02,04,cCpo)
			cCpo := PADR(TPD->RV_DESC,45)
			cLin := Stuff(cLin,06,45,cCpo)
			cCpo := PADR(STRZERO(TPD->RI_HORAS*100,6),06)
			cLin := Stuff(cLin,51,06,cCpo)
			cCpo := PADR(IF(TPD->RV_TIPOCOD="1","P","D"),01)
			cLin := Stuff(cLin,57,01,cCpo)
			cCpo := PADR(STRZERO(TPD->RI_VALOR*100,11),11)
			cLin := Stuff(cLin,58,11,cCpo)
			cCpo := PADR(SUBSTR(BRANCO,1,131),131)
			cLin := Stuff(cLin,69,131,cCpo)
			
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
			IF TPD->RV_TIPOCOD = "1"
				_TotProv := _TotProv + TPD->RI_VALOR
			Endif
			
			IF TPD->RV_TIPOCOD = "2"
				_TotDesc := _TotDesc + TPD->RI_VALOR
			Endif
			
			
			
			TPD->(dbSkip())
			
			
		Enddo
		
		// registro tipo 4
		
		IF Select("TBB") > 0
			TBB->(dbCloseArea())
		ENDIF
		
		cQuery3 	:= " SELECT  RI.RI_PD, RI.RI_HORAS, RI.RI_VALOR, RV.RV_DESC, RV.RV_TIPOCOD "
		cQuery3 	+= " FROM " + RetSqlName("SRI") + " RI" + ", " + RetSqlName("SRV") + " RV"
		cQuery3 	+= " WHERE RI.RI_PD = RV.RV_COD AND "
		cQuery3 	+= "       RI.RI_MAT     = '" + SRA->RA_MAT + "' AND "
		cquery3     += "       RI.RI_PD IN ('709','723','740','726','739')  AND "
		cQuery3 	+= "	   RI.D_E_L_E_T_  = ' ' AND "
		cQuery3 	+= "	   RV.D_E_L_E_T_  = ' ' "
		cQuery3 	+= " ORDER BY RI.RI_PD, RV.RV_TIPOCOD "
		cQuery3	:=	ChangeQuery(cQuery3)
		
		TcQuery cQuery3 New Alias "TBB"
		
		While !TBB->(EOF())
			
			IF TBB->RI_PD = "709"
				_VlrLiq := TBB->RI_VALOR
			Endif
			
			IF TBB->RI_PD = "723"
				_BaseInss += TBB->RI_VALOR
			Endif
			
			//	      IF TBB->RC_PD = "722"
			//	        _BaseInss += TBB->RC_VALOR
			//	      Endif
			
			IF TBB->RI_PD = "740"
				_Fgtsmes := TBB->RI_VALOR
			Endif
			
			IF TBB->RI_PD = "726"
				_BaseIrrf := TBB->RI_VALOR
			Endif
			
			IF TBB->RI_PD = "739"
				_BaseFgts := TBB->RI_VALOR
			Endif
			
			TBB->(dbSkip())
			
		Enddo
		
		cCpo := PADR("4",01)
		cLin := Stuff(cLin,01,01,cCpo)
		
		cCpo := PADR(STRZERO(_TotProv*100,11),11)
		cLin := Stuff(cLin,02,11,cCpo)
		
		cCpo := PADR(STRZERO(_TotDesc*100,11),11)
		cLin := Stuff(cLin,13,11,cCpo)
		
		cCpo := PADR(STRZERO(_VlrLiq*100,11),11)
		cLin := Stuff(cLin,24,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseFgts*100,11),11)
		cLin := Stuff(cLin,35,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseInss*100,11),11)
		cLin := Stuff(cLin,46,11,cCpo)
		
		cCpo := PADR(STRZERO(_FgtsMes*100,11),11)
		cLin := Stuff(cLin,57,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseIrrf*100,11),11)
		cLin := Stuff(cLin,68,11,cCpo)
		
		cCpo := PADR(STRZERO(_IrAdian*100,11),11)
		cLin := Stuff(cLin,79,11,cCpo)
		
		
		cCpo := PADR(SUBSTR(BRANCO,1,120),131)
		cLin := Stuff(cLin,90,120,cCpo)
		/*--------------
		cCpo := PADR("4",01)
		cLin := Stuff(cLin,01,01,cCpo)
		
		cCpo := PADR(STRZERO(_TotProv*100,11),11)
		cLin := Stuff(cLin,02,11,cCpo)
		
		cCpo := PADR(STRZERO(_TotDesc*100,11),11)
		cLin := Stuff(cLin,13,11,cCpo)
		
		cCpo := PADR(STRZERO(_VlrLiq*100,11),11)
		cLin := Stuff(cLin,24,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseFgts*100,11),11)
		cLin := Stuff(cLin,35,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseInss*100,11),11)
		cLin := Stuff(cLin,46,11,cCpo)
		
		cCpo := PADR(STRZERO(_FgtsMes*100,11),11)
		cLin := Stuff(cLin,57,11,cCpo)
		
		cCpo := PADR(STRZERO(_BaseIrrf*100,11),11)
		cLin := Stuff(cLin,68,11,cCpo)
		
		
		
		cCpo := PADR(SUBSTR(BRANCO,1,131),131)
		cLin := Stuff(cLin,79,131,cCpo)
		*/
		
		
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Exit
			Endif
		Endif
		
		
	Endif
	
	// registro tipo 5
	
	IF (MONTH(SRA->RA_NASC) == MONTH(MV_PAR01)) .OR. !EMPTY(MENSAG1)
		
		If MENSAG1 # SPACE(100)
			/*
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
			DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
			DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
			
			*/
			IF(MONTH(SRA->RA_NASC) = MONTH(MV_PAR01))
				DESC_MSG1 := "A TV CAPITAL, por meio de seu RH, deseja um FELIZ ANIVERSมRIO!"
			ELSE
				DESC_MSG1 := MENSAG1
			ENDIF
			
			cCpo := PADR("5",01)
			cLin := Stuff(cLin,01,01,cCpo)
			cCpo := PADR(DESC_MSG1,100)
			cLin := Stuff(cLin,02,100,cCpo)
			                               
			/*
			cCpo := PADR(SUBSTR(BRANCO,1,148),148)
			cLin := Stuff(cLin,52,148,cCpo)
			*/
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		Endif
		
	EndIf
	
	IF (MONTH(SRA->RA_NASC) != MONTH(MV_PAR01)) .AND. !EMPTY(MENSAG2)
		
		If MENSAG2 # SPACE(100)
			
			/*
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
			DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
			DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
			
			*/
			
			DESC_MSG2 := MENSAG2
			
			cCpo := PADR("5",01)
			cLin := Stuff(cLin,01,01,cCpo)
			cCpo := PADR(DESC_MSG2,100)
			cLin := Stuff(cLin,02,100,cCpo)
			
			/*
			cCpo := PADR(SUBSTR(BRANCO,1,148),148)
			cLin := Stuff(cLin,52,148,cCpo)
			*/
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		Endif
		
	EndIf
	
	IF(MONTH(SRA->RA_NASC) != MONTH(MV_PAR01)) .AND. !EMPTY(MENSAG3)
		
		If MENSAG3 # SPACE(100)
			/*
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
			DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
			DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
			*/
			
			DESC_MSG3 := MENSAG3
			
			cCpo := PADR("5",01)
			cLin := Stuff(cLin,01,01,cCpo)
			cCpo := PADR(DESC_MSG3,100)
			cLin := Stuff(cLin,02,100,cCpo)
			
			/*
			cCpo := PADR(SUBSTR(BRANCO,1,148),148)
			cLin := Stuff(cLin,52,148,cCpo)
			*/
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		Endif
		
	EndIf
	
	
	dbSelectArea(aSvAlias[1])
	dbSetOrder(aSvAlias[2])
	dbGoto(aSvAlias[3])
	
	SRA->(dbSkip())
	
	
	
	
EndDo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

fClose(nHdl)
Close(oGeraTxt)

Return

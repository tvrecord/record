#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rubsrc   º Autor ³ Pedro Alves        º Data ³  09/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de Importação Movimento Mensal -                  º±±
±±º          ³ Relatorio de Ficha Financeira tabela do rubi               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga.				 				                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rubsrc()

Local   cInd
Local   lOk	    :=.f.
Local   oDlg2

Private cString0	:= "TRC"
Private cString1	:= "TRB"
Private cAlias 		:= "SRC"
Private aStru0  	:= {}
Private aStru1		:= {}

// ------------ Monta a Tela de Confirmacao do Processamento ----------

@ 094,001 to 273,293 Dialog oDlg2 Title "Confirmação..."
@ 020,009 say " Importa dados do Mov.Mensal/Historico Fin."
@ 030,009 say "   Confirma o Início do Processamento ? "
@ 075,085 BmpButton type 01 Action eval({|| lOk:=.t.,Close(oDlg2)})
@ 075,115 BmpButton type 02 Action eval({|| lOk:=.f.,Close(oDlg2)})

Activate Dialog oDlg2 Centered
if !lOk
	return
endif

// -------------------------- Fim da Tela -----------------------------
aAdd( aStru0,	{"CAMPO_AP","C",003,00} ) // Codigo Microsiga
aAdd( aStru0,	{"CAMPO_RU","C",003,00} ) // Codigo Rubi
//aAdd( aStru0, {"CAMPO_TP","C",001,00} ) // Tipo da verba

aAdd( aStru1,	{"CAMPO_01","C",002,00} ) // Filial
aAdd( aStru1,	{"CAMPO_02","C",006,00} ) // Codigo Funcionario
aAdd( aStru1,	{"CAMPO_03","C",003,00} ) // Codigo da Verba
aAdd( aStru1,	{"CAMPO_04","N",008,02} ) // Referencia Verbas
aAdd( aStru1,	{"CAMPO_05","N",009,02} ) // Valor do Evento
aAdd( aStru1,	{"CAMPO_06","D",008,00} ) // Data
aAdd( aStru1,	{"CAMPO_07","C",001,00} ) // Codigo Rubi "O"
aAdd( aStru1, 	{"CAMPO_08","C",001,00} ) // Tipo da Verba

cArq0 	:= CriaTrab(aStru0,.T.)
dbUseArea( .T.,, cArq0, cString0, if(.F. .OR. .F., !.F., NIL), .F. )

cArq1 	:= CriaTrab(aStru1,.T.)
dbUseArea(.T.,,cArq1,cString1,.T.)

//--------------------Criando o Index Temporario-------------------------

cIndice:= "CAMPO_RU"
IndRegua("TRC",cArq0,cIndice,,,"Selecionando Registros...")

LeTxtProd()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function LeTxtProd()

Private cArqTxt0 	:= "c:\arqimp\p_dpara.txt"
Private cArqTxt1	:= "c:\arqimp\p_src.txt"
Private nHdl0    	:= 0
Private nHdl1    	:= 0
Private cEOL    	:= "CHR(13)+CHR(10)"
Private nSeq1	   	:= 0
nHdl0  						:= fOpen(cArqTxt0,68)
nHdl1   					:= fOpen(cArqTxt1,68)

If Empty(cEOL)
	cEOL 				:= CHR(13)+CHR(10)
Else
	cEOL 				:= Trim(cEOL)
	cEOL 				:= &cEOL
Endif

If nHdl0 == -1
	MsgAlert("O arquivo de nome "+cArqTxt0+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	TRB->(dbclosearea())
	Return
Endif

If nHdl1 == -1
	MsgAlert("O arquivo de nome "+cArqTxt1+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	TRC->(dbclosearea())
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsAguarde({|| ArqTmp() },"Aguarde... Lendo arquivo Texto","Processando...",.T.)

MsgAlert("Processo Finalizado!")
Return

//----------------------------------------------------------------------------------------

Static Function ArqTmp()

Local nTamFile, nTamLin, cBuffer, nBtLidos

nTamFile := fSeek(nHdl0,0,2)
fSeek(nHdl0,0,0)
nTamLin  := 10 + Len(cEOL)
cBuffer  := Space(nTamLin)

nBtLidos := fRead(nHdl0,@cBuffer,nTamLin)

While nBtLidos >= nTamLin
	
	//IncProc()
	dbSelectArea(cString0)
	RecLock(cString0,.T.)
	
	TRC->CAMPO_AP 	:= substr(cBuffer,01,03)
	TRC->CAMPO_RU 	:= substr(cBuffer,08,03)
	//TRC->CAMPO_TP 	:= Posicione("SRV",1,xFilial("SRV")+substr(cBuffer,01,03),"RV_TIPO")//substr(cBuffer,05,01)
	if TRC->CAMPO_AP < "000" .or. TRC->CAMPO_AP > "999"
		Alert("Erro na leitura do arquivo de de/para!","Sistema Abortado...")
		fClose(nHdl0)
		TRB->( dbclosearea() )
		TRC->( dbclosearea() )
		Return
	endif
	MsProcTxt(" Lendo arquivo de/para:" + TRC->CAMPO_AP )
	MSUnLock()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Leitura da proxima linha do arquivo texto.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nBtLidos := fRead(nHdl0,@cBuffer,nTamLin)
	
	dbSkip()
EndDo

fClose(nHdl0)
MsAguarde({|| RunCont() },"Aguarde... Lendo arquivo Texto","Processando...",.T.)
Return


//-----------------------------------------------------------------------------------------------

Static Function RunCont()

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local aUltimodia := {"31","28","31","30","31","30","31","31","30","31","30","31"}
nTamFile := fSeek(nHdl1,0,2)
fSeek(nHdl1,0,0)
nTamLin  := 77 + Len(cEOL)
cBuffer  := Space(nTamLin)
nBtLidos := fRead(nHdl1,@cBuffer,nTamLin)

While nBtLidos >= nTamLin
	
	IncProc()
	dbSelectArea(cString1)
	RecLock(cString1,.T.)
	
	TRB->CAMPO_01 := substr(cBuffer,01,02) //SRC->RC_FILIAL
	if TRB->CAMPO_01 <>"01"
		msAlert("Erro na leitura do arquivo de movimento RUBI!","Sistema Abortado...")
		fClose(nHdl1)
		TRB->( dbclosearea() )
		TRC->( dbclosearea() )
		Return
	endif
	TRB->CAMPO_02 := substr(cBuffer,04,06) //SRC->RC_MAT
	TRB->CAMPO_03 := substr(cBuffer,11,03) //SRC->RC_PD TMP-RUBI
	if TRC->(dbseek( TRB->CAMPO_03, .f. )) 
		TRB->CAMPO_03	:= TRC->CAMPO_AP	//SRC->RC_PD
		TRB->CAMPO_07	:= "1"				//SRC->RC_SEQ 1=TRU
	else
		TRB->CAMPO_07	:= "0"				//SRC->RC_SEQ 0=FALSE
	endif
	TRB->CAMPO_08 := Posicione("SRV",1,xFilial("SRV")+TRC->CAMPO_AP,"RV_TIPO") 	//SRC->RC_TIPO1
	TRB->CAMPO_04 := val( substr(cBuffer,19,06) + "." + substr(cBuffer,26,02) ) 	//SRC->RC_HORAS
	TRB->CAMPO_05 := val( substr(cBuffer,34,07) + "." + substr(cBuffer,42,02) )   //SRC->RC_VALOR
	TRB->CAMPO_06 := ctod( aUltimodia[val(substr(cBuffer,45,02))]+;
					 "/"+substr(cBuffer,45,02)+"/"+substr(cBuffer,47,04)) //SRC->RC_DATA
	nSeq1 ++
	MsProcTxt(" Lendo Matricula "  + TRB->CAMPO_02 + "  " + TRB->CAMPO_03 + " " + str(nSeq1) )
	MSUnLock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Leitura da proxima linha do arquivo texto.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nBtLidos := fRead(nHdl1,@cBuffer,nTamLin)
	
	dbSkip()
EndDo

fClose(nHdl1)
MsAguarde({|| Gera() },"Aguarde... Gerando carga na base","Processando...",.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Gera()

local nSeq	:= 0

TRB->(dbgotop())
SRC->(dbsetorder(3))

do while !TRB->(eof())
	
	nSeq ++
	MsProcTxt( "Importando " + str(nSeq) + " de " + str(nSeq1) )

/*	
	cQuery	:= 	"SELECT * FROM  " + retsqlname("SRV") 				+;
							" WHERE 	" 	+ retsqlname("SRV") 	+ ".D_E_L_E_T_ != '*'  	AND " 	+;
							" RV_COD = '" 	+ TRB->CAMPO_03  		+ "'"
	
	TCQUERY cQuery New Alias "TMP"
	nTam	:=	TMP->(lastrec())
	TMP->(dbgotop())
*/	
	cQuery1	:= 	"SELECT RA_CC FROM  " + retsqlname("SRA") 				+;
							" WHERE " 	+ retsqlname("SRA") 	+ ".D_E_L_E_T_ != '*'  	AND " 	+;
							" RA_FILIAL ='" + TRB->CAMPO_01 + "' AND RA_MAT = '" + TRB->CAMPO_02 	+ "'"
	
	TCQUERY cQuery1 New Alias "TMP1"
	cArq	:= CriaTrab(NIL,.F.)
	Copy To &cArq
	TMP1->(dbclosearea())
	dbUseArea( .t. , , cArq , "TMP1" , .f. )
	nTam	:=	TMP1->(lastrec())
	TMP1->(dbgotop())
	
	iif (SRC->( dbseek( TRB->CAMPO_01 + TRB->CAMPO_03 + TRB->CAMPO_02 + TRB->CAMPO_07 , .f. )),	reclock("SRC",.f.),reclock("SRC",.t.))
	iif (!TMP1->(Eof()),SRC->RC_CC			:= TMP1->RA_CC,)
	SRC->RC_FILIAL			:= TRB->CAMPO_01
	SRC->RC_MAT					:= TRB->CAMPO_02
	SRC->RC_PD					:= TRB->CAMPO_03
	SRC->RC_TIPO1				:= TRB->CAMPO_08 //iif(TRB->CAMPO_08 == "1","V","H")
	SRC->RC_TIPO2				:= "I"
	SRC->RC_HORAS				:= TRB->CAMPO_04
	SRC->RC_VALOR				:= TRB->CAMPO_05
	SRC->RC_DATA				:= TRB->CAMPO_06
	SRC->RC_SEQ					:= TRB->CAMPO_07 //"0"
	msunlock("SRC")
	
	//TMP->( dbclosearea() )
	TMP1->( dbclosearea() )
	TRB->( dbskip(1) )
enddo

TRB->( dbclosearea() )
TRC->( dbclosearea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclusao da Tabela Temporaria.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ferase( cArq0  + ordbagext() )
ferase( cArq1  + ordbagext() )

Return

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AXSZN     º Autor ³ RAFAEL FRANCA      º Data ³  29/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³CADASTRO DE BENS SOB EMPRESTIMO.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORD DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AXSZN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Bens Sob Emprestimo"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,; 
{"Devolução","u_contrdev",0,4} ,;
{"Relatorio","u_contrter",0,4} ,;
{"Legenda","u_LegenSZN()",0,4}}
Private aCores := {{'EMPTY(ZN_DTRECEB) .AND. ZN_TIPO == "1" .AND. ((ZN_PRAZO - 7) > DDATABASE .OR. EMPTY(ZN_PRAZO))','BR_VERDE'},;
{'!EMPTY(ZN_DTDEVOL) .AND. ZN_TIPO == "2" .OR. !EMPTY(ZN_DTRECEB) .AND. ZN_TIPO == "1"','BR_VERMELHO'},;
{'EMPTY(ZN_DTDEVOL) .AND. ZN_TIPO == "2" .AND. ((ZN_PRAZO - 7) > DDATABASE .OR. EMPTY(ZN_PRAZO))','BR_AZUL'},;
{'(EMPTY(ZN_DTDEVOL) .AND. ZN_TIPO == "2" .OR. EMPTY(ZN_DTRECEB) .AND. ZN_TIPO == "1") .AND. (ZN_PRAZO - 7) <= DDATABASE .AND. ZN_PRAZO >= DDATABASE','BR_AMARELO'},;
{'(EMPTY(ZN_DTDEVOL) .AND. ZN_TIPO == "2" .OR. EMPTY(ZN_DTRECEB) .AND. ZN_TIPO == "1") .AND. ZN_PRAZO <= DDATABASE .AND. !EMPTY(ZN_PRAZO)','BR_PRETO'}}
//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZN"
Private cCodigo	:= ""

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores) 

//cCodigo	:= M->ZN_COD

Return

User Function LegenSZN

Local aLegenda := {{"ENABLE","Bens em terceiros"},{"BR_AZUL","Bens de terceiros"},{"BR_AMARELO","A uma semana do prazo"},{"BR_PRETO","Prazo vencido"},{"DISABLE","Devolvido"}}

BrwLegenda("Cadastro de controle de terceiros","Legenda",aLegenda)

Return(.T.)  

User Function contrdev()

Private dDataDev := StoD("        ") 
Private	cNota	 := SPACE(10)  

//dbSelectArea(cString)
//dbSetOrder(1)
//dbSeek(xFilial("SZN") + cCodigo)

IF ZN_TIPO == "1"

dDataDev :=	SZN->ZN_DTRECEB  
cNota	 := SZN->ZN_NOTA	  	
                                        
ELSEIF ZN_TIPO == "2"

dDataDev := SZN->ZN_DTDEVOL 
cNota 	 := SZN->ZN_NFSAIDA

ENDIF                     

@ 000,000 TO 150,300 DIALOG oDlg TITLE "Tela de Devolução"
@ 010,020 Say "Data da Devolução:"
@ 010,070 Get dDataDev SIZE 030,010 VALID !EMPTY(dDataDev)   
@ 030,020 Say "Nota Fiscal:"                             
@ 030,070 Get cNota SIZE 040,010 VALID !EMPTY(cNota)            
@ 055,085 BMPBUTTON TYPE 01 ACTION DataDev(dDataDev,cNota)
@ 055,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function DataDev(dDataDev,cNota)

//dbSelectArea(cString)
//dbSetOrder(1)
//dbSeek(xFilial("SZN") + cCodigo)	

IF ZN_TIPO == "1"

RecLock("SZN",.F.)
ZN_DTRECEB 	:= dDataDev
ZN_NOTA	  	:= cNota	
MsUnLock() 

ELSEIF ZN_TIPO == "2"

RecLock("SZN",.F.)
ZN_DTDEVOL 	 := dDataDev 
ZN_NFSAIDA    := cNota	
MsUnLock() 

ENDIF

Close(oDlg)

Return()

Return()
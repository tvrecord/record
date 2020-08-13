#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXSZR     บ Autor ณ RAFAEL FRANCA      บ Data ณ  07/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRegistros de importa็ใo do SIG                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRECORD DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                                                                            

User Function AXSZR  // Rafael -> AxCadastro da rotina

Private cCadastro := "Arquivo SIG"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3,} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5},;
{"Calc Receita","u_TelaRECE()",0,2},;
{"Calc Despesa","u_TelaDESP()",0,2},;
{"Calc Ativo","u_TelaATF()",0,2},;   
{"Compensa็ใo Desp.","u_TelaComp()",0,2},;
{"Compensa็ใo Desp. Ativo","u_TelCompAt()",0,2},;
{"Relatorio","u_ImpSIG()",0,2},;
{"Legenda","u_LegenSZR()",0,4}} 

Private aCores := {{'ZR_TIPO == "D"','BR_VERMELHO'},{'ZR_TIPO == "C"','BR_VERDE'},{'ZR_TIPO == "E"','BR_AMARELO'},{'ZR_TIPO == "F"','BR_PRETO'}}
Private cString := "SZR"
                                                                    

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function LegenSZR

Local aLegenda := {{"ENABLE","Receita"},{"DISABLE","Despesa"},{"BR_AMARELO","Estorno Receita"},{"BR_PRETO","Estorno Despesa"}}

BrwLegenda("Legenda SIG","Legenda",aLegenda)

Return(.T.)

User Function TelaRECE // Tela de atualiza็ใo do dados de Receita

Private dData3 	:= CtoD("//")
Private dData4 	:= CtoD("//")
Private cCusto3	:= Space(9)
Private cCusto4	:= "ZZZZZZZZZ"//Space(9)

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Registros de Receitas"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData3 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData4 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION VerificaRECE(dData3,dData4,cCusto3,cCusto4)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

User Function TelaDESP
Private dData1 	:= CtoD("//")
Private dData2 	:= CtoD("//")
Private cCusto1	:= Space(9)
Private cCusto2	:= "ZZZZZZZZZ"

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Registros de Despesas"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData1 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData2 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION VerificaDESP(dData1,dData2,cCusto1,cCusto2)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

User Function TelaATF  //Altera็ใo - Trata os ativos de maneira s๚eparada

Private dData5	:= CtoD("//")
Private dData6 	:= CtoD("//")
Private cCusto5	:= Space(9)
Private cCusto6	:= "ZZZZZZZZZ"//Space(9)

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Registros dos Ativos"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData5 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData6 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION VerificaATF(dData5,dData6,cCusto5,cCusto6)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

User Function TelaVLJ  //Altera็ใo - Trata os ativos de maneira s๚eparada

Private dData7	:= CtoD("//")
Private dData8 	:= CtoD("//")

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Registros dos Valor Justo"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData7 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData8 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION _GeraVLJ(dData7,dData8)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

User Function TelaComp // Tela de Compensacao de Despesa

Private dData10 	:= CtoD("//")
Private dData11 	:= CtoD("//")
Private cCusto10	:= Space(9)
Private cCusto11	:= "ZZZZZZZZZ"//Space(9)

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Compensa็ใo de Despesa"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData10 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData11 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION CompDesp(dData10,dData11)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

User Function TelCompAt // Tela de Compensacao de Despesa

Private dData10 	:= CtoD("//")
Private dData11 	:= CtoD("//")
Private cCusto10	:= Space(9)
Private cCusto11	:= "ZZZZZZZZZ"//Space(9)

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Compensa็ใo de Despesa Ativo Fixo"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData10 SIZE 40,020
@ 011,150 Say "Data Final:"
@ 010,190 Get dData11 SIZE 40,020
@ 060,170 BMPBUTTON TYPE 01 ACTION CompAtivo(dData10,dData11)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAciona a rotina RECEITA para gera็ใo do SIGณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

Static Function VerificaRECE(dData3,dData4,cCusto3,cCusto4)

IF MsgYesNo("O sistema irแ apagar os lan็amentos de credito do periodo antes de executar o programa. Deseja continuar?","Aten็ใo")
Processa({|| TcSqlExec("DELETE FROM " + RetSqlName("SZR") + " WHERE ZR_EMISSAO  BETWEEN '" + DTOS(dData3) + "' AND '" + DTOS(dData4) + "' AND ZR_ROTINA = '1' ")},"Deletando registros anteriores")
	Processa({|| _GeraRECE(dData3,dData4,cCusto3,cCusto4)},"Atualizando registros do SIG")
EndIf

Return

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAciona a rotina DESPESA para gera็ใo do SIGณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

Static Function VerificaDESP(dData1,dData2,cCusto1,cCusto2)

IF MsgYesNo("O sistema irแ apagar os lan็amentos de debito do periodo antes de executar o programa. Deseja continuar?","Aten็ใo")
	
	Processa({|| TcSqlExec("DELETE FROM " + RetSqlName("SZR") + " WHERE ZR_EMISSAO  BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND ZR_TIPO = 'D' AND ZR_ROTINA = '2'")},"Deletando registros anteriores")
	Processa({|| TcSqlExec("DELETE FROM " + RetSqlName("SZR") + " WHERE ZR_EMISSAO  BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND ZR_TIPO = 'X' AND ZR_ROTINA = '2'")},"Deletando registros CD")
	Processa({|| _GeraDESP(dData1,dData2,cCusto1,cCusto2)},"Atualizando registros do SIG")
	//EndIF
EndIf

Return

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAciona a rotina DESPESA ATIVO FIXO para gera็ใo do SIGณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

Static Function VerificaATF(dData5,dData6,cCusto5,cCusto6)

IF MsgYesNo("O sistema irแ apagar os lan็amentos do Ativo do periodo antes de executar o programa. Deseja continuar?","Aten็ใo")
	Processa({|| TcSqlExec("DELETE FROM " + RetSqlName("SZR") + " WHERE ZR_EMISSAO  BETWEEN '" + DTOS(dData5) + "' AND '" + DTOS(dData6) + "' AND ZR_ROTINA IN ('3','4')")},"Deletando registros do ativo")
	Processa({|| _GeraATF(dData5,dData6,cCusto5,cCusto6)},"Atualizando registros do Ativo no SIG")
EndIf

Return



/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAciona a rotina de Compensa็ใo para descontar todos os credtitos do debito, respeitando tambem a tabela SZT caso esteja alguma informa็ใo cadastrada referente ao mes ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

Static Function CompDesp(dData10,dData11)
IF MsgYesNo("O sistema irแ apagar os lan็amentos do Ativo do periodo antes de executar o programa. Deseja continuar?","Aten็ใo")
	Processa({|| _RateioDesp(dData10,dData11)},"Executando Compensacao")
EndIf	
Return

Static Function CompAtivo(dData10,dData11)

IF MsgYesNo("O sistema irแ apagar os lan็amentos do Ativo do periodo antes de executar o programa. Deseja continuar?","Aten็ใo")
	Processa({|| _RateioATIVO(dData10,dData11)},"Executando Compensacao de Despesa Ativo Fixo")
EndIf	

Return

//Seleciona e grava registros de receita tipo C

Static Function _GeraRECE(dData3,dData4,cCusto3,cCusto4)

Local cQueryRECE	:= ""
Local cQueryRECEE	:= ""                                              
Local nRec2			:= 0
Local nCod2			:= 1
Local cCusto		:= ""

cQueryRECE := "SELECT CT2_CREDIT,CT2_CCC,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryRECE += "INNER JOIN CT1010 ON CT2_CREDIT = CT1_CONTA "
cQueryRECE += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryRECE += "(CT2_ROTINA NOT LIKE ('%ATF%') OR CT2_CREDIT = '321100007') AND "
//cQueryRECE += "CT2_DEBITO BETWEEN '" + (cConta1) + "' AND '" + (cConta2) + "' AND "
cQueryRECE += "CT2_CREDIT IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG <> '' AND SUBSTRING(CT1_SIG,1,2) <> '15' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '' AND CT1_NORMAL = '2' AND SUBSTRING(CT1_CONTA,1,1) = '3') AND "
cQueryRECE += "CT2_CCC BETWEEN '" + (cCusto3) + "' AND '" + (cCusto4) + "' AND "
cQueryRECE += "CT2_DATA BETWEEN '" + DTOS(dData3) + "' AND '" + DTOS(dData4) + "' AND CT2_TPSALD = '1' AND "
cQueryRECE += "CT2_FILIAL = '01' "
//cQueryRECE += "AND CT2_ROTINA LIKE ('%GPE%') "
//cQueryRECE += "GROUP BY CT2_CREDIT,CT2_CCC,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG"

tcQuery cQueryRECE New Alias "TMPRECE"

If Eof()
	MsgInfo("Nao existem dados no periodo/conta/c. custo informado!","Verifique")
	dbSelectArea("TMPRECE" )
	dbCloseArea("TMPRECE" )
	Return
Endif

Count To nRec2

dbSelectArea("TMPRECE")
dbGoTop()

ProcRegua(nRec2)

While !EOF()
	
	IncProc()
	
	dbSelectArea("SZR")
	dBSetOrder(2)
	If !EMPTY(TMPRECE->CT2_CCC)
		If !dbSeek(xFilial("SZR") + SUBSTR(TMPRECE->CT2_CREDIT,1,10) + TMPRECE->CT2_CCC + " " + TMPRECE->CT2_DATA + SUBSTR(TMPRECE->CT2_ORIGEM,1,40) + TMPRECE->CT2_HIST)
			Reclock("SZR",.T.)
			SZR->ZR_CODIGO	:= SUBSTR(TMPRECE->CT2_DATA,1,6)
			SZR->ZR_CODEMP	:= "12"
			SZR->ZR_UNDNEG	:= "1"
			IF SUBSTR(TMPRECE->CT2_ORIGEM,09,3) <> SPACE(3) .OR. SUBSTR(TMPRECE->CT2_ORIGEM,13,6) <> SPACE(6)
				SZR->ZR_PREFIXO	:= SUBSTR(TMPRECE->CT2_ORIGEM,09,3)
				SZR->ZR_DOC		:= SUBSTR(TMPRECE->CT2_ORIGEM,13,6)
			ELSE
				SZR->ZR_PREFIXO	:= STRZERO(0,03)
				SZR->ZR_DOC		:= SUBSTR(TMPRECE->CT2_DATA,1,6) + STRZERO(nCod2,04)
				nCod2 ++
			ENDIF
			IF SUBSTR(TMPRECE->CT2_ORIGEM,20,6) <> SPACE(6) .AND. SUBSTR(TMPRECE->CT2_ORIGEM,27,2) <> SPACE(2)
				SZR->ZR_CLIENTE	:= SUBSTR(TMPRECE->CT2_ORIGEM,20,6)
				SZR->ZR_LOJA	:= SUBSTR(TMPRECE->CT2_ORIGEM,27,2)
			ELSE
				SZR->ZR_CLIENTE	:= "002459"
				SZR->ZR_LOJA	:= "01"
			ENDIF
			SZR->ZR_EMISSAO	:= STOD(TMPRECE->CT2_DATA)
			SZR->ZR_CTASIG  := TMPRECE->CT1_SIG
			SZR->ZR_CONTA  	:= TMPRECE->CT2_CREDIT
			SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+TMPRECE->CT2_CREDIT,"CT1_DESC01")
			IF !EMPTY(TMPRECE->CT2_CCC)
				SZR->ZR_CC     	:= TMPRECE->CT2_CCC
				SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+TMPRECE->CT2_CCC,"CTT_DESC01")
			ELSE
				SZR->ZR_CC     	:= "1005001"
				SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+"1005001","CTT_DESC01")
			ENDIF
			SZR->ZR_VALOR	:= TMPRECE->VALOR
			SZR->ZR_MODULO	:= TMPRECE->CT2_ROTINA
			SZR->ZR_HIST	:= TMPRECE->CT2_HIST
			SZR->ZR_ORIGEM	:= TMPRECE->CT2_ORIGEM
			SZR->ZR_TIPO	:= "C"
			SZR->ZR_ROTINA  := "1" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo
			MsUnlock()
		END
	ELSE
//		If !dbSeek(xFilial("SZR") + SUBSTR(TMPRECE->CT2_CREDIT,1,10) + "1005001   " + TMPRECE->CT2_DATA + SUBSTR(TMPRECE->CT2_ORIGEM,1,40) + TMPRECE->CT2_HIST)
			Reclock("SZR",.T.)
			SZR->ZR_CODIGO	:= SUBSTR(TMPRECE->CT2_DATA,1,6)
			SZR->ZR_CODEMP	:= "12"
			SZR->ZR_UNDNEG	:= "1"
			IF SUBSTR(TMPRECE->CT2_ORIGEM,09,3) <> SPACE(3) .OR. SUBSTR(TMPRECE->CT2_ORIGEM,13,6) <> SPACE(6)
				SZR->ZR_PREFIXO	:= SUBSTR(TMPRECE->CT2_ORIGEM,09,3)
				SZR->ZR_DOC		:= SUBSTR(TMPRECE->CT2_ORIGEM,13,6)
			ELSE
				SZR->ZR_PREFIXO	:= STRZERO(0,03)
				SZR->ZR_DOC		:= SUBSTR(TMPRECE->CT2_DATA,1,6) + STRZERO(nCod2,04)
				nCod2 ++
			ENDIF
			IF SUBSTR(TMPRECE->CT2_ORIGEM,20,6) <> SPACE(6) .AND. SUBSTR(TMPRECE->CT2_ORIGEM,27,2) <> SPACE(2)
				SZR->ZR_CLIENTE	:= SUBSTR(TMPRECE->CT2_ORIGEM,20,6)
				SZR->ZR_LOJA	:= SUBSTR(TMPRECE->CT2_ORIGEM,27,2)
			ELSE
				SZR->ZR_CLIENTE	:= "002459"
				SZR->ZR_LOJA	:= "01"
			ENDIF
			SZR->ZR_EMISSAO	:= STOD(TMPRECE->CT2_DATA)
			SZR->ZR_CTASIG  := TMPRECE->CT1_SIG
			SZR->ZR_CONTA  	:= TMPRECE->CT2_CREDIT
			SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+TMPRECE->CT2_CREDIT,"CT1_DESC01")
			IF !EMPTY(TMPRECE->CT2_CCC)
				SZR->ZR_CC     	:= TMPRECE->CT2_CCC
				SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+TMPRECE->CT2_CCC,"CTT_DESC01")
			ELSE
				SZR->ZR_CC     	:= "1005001"
				SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+"1005001","CTT_DESC01")
			ENDIF
			SZR->ZR_VALOR	:= TMPRECE->VALOR
			SZR->ZR_MODULO	:= TMPRECE->CT2_ROTINA
			SZR->ZR_HIST	:= TMPRECE->CT2_HIST
			SZR->ZR_ORIGEM	:= TMPRECE->CT2_ORIGEM
			SZR->ZR_TIPO	:= "C"  
			SZR->ZR_SEQUEN	:= TMPRECE->CT2_SEQUEN 
			SZR->ZR_SEQLAN	:= TMPRECE->CT2_SEQLAN 			
			SZR->ZR_ROTINA  := "1" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo			
			MsUnlock()
  //		END
	END
	
	dbSelectArea("TMPRECE")
	dbSkip()
	
EndDo

dbSelectArea("TMPRECE")
dbCloseArea("TMPRECE")

Close(oDlg)

Return

//Seleciona e grava registeos de despesas tipo D

Static Function _GeraDESP(dData1,dData2,cCusto1,cCusto2)

Local cQueryDESPE	:= ""
Local cQueryDESP	:= ""
Local nGPE          := 0
Local nRec1			:= 0
Local nCod1			:= 1 
Local nCod2			:= 1
Local nCD 			:= 1

cQueryDESP := "SELECT 'DES' AS PREFIXO,CT2_DEBITO,CT2_CCD,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryDESP += "INNER JOIN CT1010 ON CT2_DEBITO = CT1_CONTA "
cQueryDESP += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryDESP += "CT2_ROTINA NOT LIKE ('%ATF%') AND SUBSTRING(CT2_DEBITO,1,5) <> '41160' AND "  // Separa registros dos ativos
cQueryDESP += "CT2_DEBITO IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG <> '' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '' AND CT1_NORMAL = '1' AND (SUBSTRING(CT1_CONTA,1,1) = '4' OR SUBSTRING(CT2_DEBITO,1,3) = '126' OR SUBSTRING(CT2_DEBITO,1,3) = '127' OR SUBSTRING(CT2_DEBITO,1,3) = '129')) AND "
cQueryDESP += "CT2_CCD BETWEEN '" + (cCusto1) + "' AND '" + (cCusto2) + "' AND "
cQueryDESP += "CT2_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND CT2_TPSALD = '1' AND "
cQueryDESP += "CT2_FILIAL = '01' "
cQueryDESP += "UNION "
cQueryDESP += "SELECT 'FIS' AS PREFIXO,CT2_CREDIT AS CT2_DEBITO,CT2_CCC AS CT2_CCD,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryDESP += "INNER JOIN CT1010 ON CT2_CREDIT = CT1_CONTA "
cQueryDESP += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryDESP += "CT2_ROTINA NOT LIKE ('%ATF%') AND SUBSTRING(CT2_DEBITO,1,5) <> '41160' AND "  // Separa registros dos ativos
cQueryDESP += "CT2_CREDIT IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG BETWEEN '15000' AND '15999' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '') AND "
cQueryDESP += "CT2_CCC BETWEEN '' AND 'ZZZZZZZ' AND "
cQueryDESP += "CT2_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND CT2_TPSALD = '1' AND "
cQueryDESP += "CT2_FILIAL = '01' "
cQueryDESP += "UNION " // IMP - REGRA PARA CALCULO DE IMPOSTOS
cQueryDESP += "SELECT 'IMP' AS PREFIXO,CT2_DEBITO,CT2_CCD,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryDESP += "INNER JOIN CT1010 ON CT2_DEBITO = CT1_CONTA "
cQueryDESP += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryDESP += "CT2_ROTINA NOT LIKE ('%ATF%') AND SUBSTRING(CT2_DEBITO,1,5) <> '41160' AND "  // Separa registros dos ativos
cQueryDESP += "CT2_DEBITO IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG BETWEEN '14001' AND '14999' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '') AND "  
cQueryDESP += "CT2_CCD BETWEEN '' AND 'ZZZZZZZ' AND "
cQueryDESP += "CT2_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND CT2_TPSALD = '1' AND "
cQueryDESP += "CT2_FILIAL = '01' "  
cQueryDESP += "UNION " // TRI - REGRA PARA CALCULOS DE TRIBUTOS
cQueryDESP += "SELECT 'TRI' AS PREFIXO,CT2_DEBITO,CT2_CCD,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryDESP += "INNER JOIN CT1010 ON CT2_DEBITO = CT1_CONTA "
cQueryDESP += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryDESP += "CT2_ROTINA NOT LIKE ('%ATF%') AND SUBSTRING(CT2_DEBITO,1,1) <> '4' AND "  // Separa registros dos ativos
cQueryDESP += "CT2_DEBITO IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG BETWEEN '07000' AND '07999' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '') AND "
cQueryDESP += "CT2_CCD BETWEEN '' AND 'ZZZZZZZ' AND "
cQueryDESP += "CT2_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND CT2_TPSALD = '1' AND "
cQueryDESP += "CT2_FILIAL = '01' "

tcQuery cQueryDESP New Alias "TMPDESP"

If TMPDESP->(Eof())
	MsgInfo("Nao existem dados no periodo/conta/c. custo informado!","Verifique")
	dbSelectArea("TMPDESP" )
	dbCloseArea("TMPDESP" )
	Return
Endif

Count To nRec1

dbSelectArea("TMPDESP")
dbGoTop()
ProcRegua(nRec1)
While !EOF()
	IncProc("Gerando registros de despesa.......  " + SUBSTR(TMPDESP->CT2_ROTINA,1,7))
	dbSelectArea("SZR")
	dBSetOrder(2)
	If !dbSeek(xFilial("SZR")+ SUBSTR(TMPDESP->CT2_DEBITO,1,10) + TMPDESP->CT2_CCD + " " + TMPDESP->CT2_DATA + SUBSTR(TMPDESP->CT2_ORIGEM,1,40) + TMPDESP->CT2_HIST)
		Reclock("SZR",.T.)
		SZR->ZR_CODIGO	:= SUBSTR(TMPDESP->CT2_DATA,1,6)
		SZR->ZR_CODEMP	:= "12"
		SZR->ZR_UNDNEG	:= "1"
		IF SUBSTR(TMPDESP->CT2_ROTINA,1,3) == "GPE" .AND. TMPDESP->PREFIXO == "DES"
			SZR->ZR_PREFIXO	:= "GPE"
			SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_DATA,1,6) + STRZERO(nGPE,4)
			SZR->ZR_FORNECE	:= "000131"
			SZR->ZR_LOJA	:= "01"
			nGPE ++
		ELSEIF SUBSTR(TMPDESP->CT2_ROTINA,1,5) == "MTA33" .AND. TMPDESP->PREFIXO == "DES"
			IF TMPDESP->CT2_DATA < "20120411"
				SZR->ZR_PREFIXO	:= SUBSTR(TMPDESP->CT2_ORIGEM,09,3)
				SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_HIST,14,9)
			ELSE
				SZR->ZR_PREFIXO	:= SUBSTR(TMPDESP->CT2_ORIGEM,09,3)
				SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_ORIGEM,13,9)
			ENDIF
			SZR->ZR_FORNECE	:= "000131"
			SZR->ZR_LOJA	:= "01"
		ELSEIF SUBSTR(TMPDESP->CT2_ROTINA,1,5) <> "MTA33" .AND. SUBSTR(TMPDESP->CT2_ROTINA,1,3) <> "GPE" .AND. TMPDESP->PREFIXO == "DES"
			IF SUBSTR(TMPDESP->CT2_ORIGEM,09,3) <> SPACE(3) .OR. SUBSTR(TMPDESP->CT2_ORIGEM,13,6) <> SPACE(6)
				SZR->ZR_PREFIXO	:= SUBSTR(TMPDESP->CT2_ORIGEM,09,3)
				SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_ORIGEM,13,6)
			ELSE
				SZR->ZR_PREFIXO	:= STRZERO(0,03)
				SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_DATA,1,6) + STRZERO(nCod1,04)
				nCod1 ++
			ENDIF
			IF SUBSTR(TMPDESP->CT2_ORIGEM,20,6) <> SPACE(6) .AND. SUBSTR(TMPDESP->CT2_ORIGEM,27,2) <> SPACE(2)
				SZR->ZR_FORNECE	:= SUBSTR(TMPDESP->CT2_ORIGEM,20,6)
				SZR->ZR_LOJA	:= SUBSTR(TMPDESP->CT2_ORIGEM,27,2)
			ELSE
				SZR->ZR_FORNECE	:= "000131"
				SZR->ZR_LOJA	:= "01"
			ENDIF 
		ELSEIF TMPDESP->PREFIXO == "IMP"
			SZR->ZR_PREFIXO	:= TMPDESP->PREFIXO
			SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_DATA,3,6) + SUBSTR(TMPDESP->CT1_SIG,2,4)
			SZR->ZR_FORNECE	:= "000131"
			SZR->ZR_LOJA	:= "01"		
		ELSEIF TMPDESP->PREFIXO == "FIS"			
			SZR->ZR_PREFIXO	:= TMPDESP->PREFIXO
			SZR->ZR_DOC		:= SUBSTR(TMPDESP->CT2_DATA,3,6) + STRZERO(nCod2,04)
			SZR->ZR_FORNECE	:= "000131"
			SZR->ZR_LOJA	:= "01"	  
			nCod2 ++			
		ENDIF
		SZR->ZR_EMISSAO	:= STOD(TMPDESP->CT2_DATA)
		IF (TMPDESP->CT2_ORIGEM == "A01-001 305                             " .OR. TMPDESP->CT2_ORIGEM == "A01-001 307                             " .OR. TMPDESP->CT2_ORIGEM == "A01-001 389                             ") .AND. TMPDESP->CT1_SIG == "04011" 
		SZR->ZR_CTASIG  := "05008"
		ELSE
		SZR->ZR_CTASIG  := TMPDESP->CT1_SIG 
		ENDIF
		SZR->ZR_CONTA  	:= TMPDESP->CT2_DEBITO
		SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+TMPDESP->CT2_DEBITO,"CT1_DESC01")  
		IF TMPDESP->PREFIXO <> "DES" .AND. EMPTY(TMPDESP->CT2_CCD)
		SZR->ZR_CC     	:= "4001001"   
		SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+"4001001","CTT_DESC01")		
		ELSE
		SZR->ZR_CC     	:= TMPDESP->CT2_CCD  
		SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+TMPDESP->CT2_CCD,"CTT_DESC01")		
		END
		SZR->ZR_VALOR	:= TMPDESP->VALOR
		SZR->ZR_MODULO	:= TMPDESP->CT2_ROTINA
		SZR->ZR_HIST	:= TMPDESP->CT2_HIST
		SZR->ZR_ORIGEM	:= TMPDESP->CT2_ORIGEM
		SZR->ZR_TIPO	:= "D"  
		SZR->ZR_SEQUEN	:= TMPDESP->CT2_SEQUEN 
		SZR->ZR_SEQLAN	:= TMPDESP->CT2_SEQLAN
		SZR->ZR_ROTINA  := "2" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo		
		MsUnlock()
	End
	
	
	dbSelectArea("TMPDESP")
	dbSkip()
	
EndDo

dbSelectArea("TMPDESP")
dbCloseArea("TMPDESP")

cQueryDESPE := "SELECT CT2_CREDIT,CT2_CCC,CT2_HIST,CT2_ORIGEM,CT2_DATA,CT2_ROTINA,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,CT2_VALOR AS VALOR FROM CT2010 "
cQueryDESPE += "INNER JOIN CT1010 ON CT2_CREDIT = CT1_CONTA "
cQueryDESPE += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
cQueryDESPE += "CT2_ROTINA NOT LIKE ('%ATF%') AND SUBSTRING(CT2_CREDIT,1,5) <> '41160' AND "  // Separa registros dos ativos
cQueryDESPE += "CT2_CREDIT IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG <> '' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '' AND (SUBSTRING(CT1_CONTA,1,1) = '4' OR SUBSTRING(CT1_CONTA,1,3) = '126')) AND "
cQueryDESPE += "CT2_CCC BETWEEN '" + (cCusto1) + "' AND '" + (cCusto2) + "' AND "
cQueryDESPE += "CT2_DATA BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND CT2_TPSALD = '1' AND "
cQueryDESPE += "CT2_FILIAL = '01' "

tcQuery cQueryDESPE New Alias "ESTDESP"

dbSelectArea("ESTDESP")
dbGoTop()
While !EOF()
	
	dbSelectArea("SZR")
	dbSetOrder(3)
	If dbSeek(xFilial("SZR") + PADR(ESTDESP->CT2_CREDIT,20) + PADR(ESTDESP->CT2_CCC,10) + ESTDESP->CT2_DATA + "D" + PADL(ALLTRIM(STR(ESTDESP->VALOR)),12) + SUBSTR(ESTDESP->CT2_ROTINA,1,7))
		Reclock("SZR",.F.)
		SZR->ZR_MODULO	:= ESTDESP->CT2_ROTINA
		SZR->ZR_HIST	:= ESTDESP->CT2_HIST
		SZR->ZR_TIPO	:= "F"
		MsUnlock()
	Else
		Reclock("SZR",.T.)
		SZR->ZR_CODIGO	:= SUBSTR(ESTDESP->CT2_DATA,1,6)
		SZR->ZR_CODEMP	:= "12"
		SZR->ZR_UNDNEG	:= "1"
		SZR->ZR_PREFIXO	:= "CD"
		SZR->ZR_DOC		:= SUBSTR(ESTDESP->CT2_DATA,1,6) + STRZERO(nCD,4)
		SZR->ZR_FORNECE	:= "000131"
		SZR->ZR_LOJA	:= "01"
		SZR->ZR_EMISSAO	:= STOD(ESTDESP->CT2_DATA)
		SZR->ZR_CTASIG  := ESTDESP->CT1_SIG
		SZR->ZR_CONTA  	:= ESTDESP->CT2_CREDITO
		SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+ESTDESP->CT2_CREDITO,"CT1_DESC01")
		SZR->ZR_CC     	:= ESTDESP->CT2_CCC
		SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+ESTDESP->CT2_CCC,"CTT_DESC01")
		SZR->ZR_VALOR	:= ESTDESP->VALOR
		SZR->ZR_MODULO	:= ESTDESP->CT2_ROTINA
		SZR->ZR_HIST	:= ESTDESP->CT2_HIST
		SZR->ZR_ORIGEM	:= ESTDESP->CT2_ORIGEM
		SZR->ZR_TIPO	:= "X" 
		SZR->ZR_SEQUEN	:= ESTDESP->CT2_SEQUEN
		SZR->ZR_SEQLAN	:= ESTDESP->CT2_SEQLAN
		SZR->ZR_ROTINA  := "2" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo		
		MsUnlock()
		nCD ++
	End
	
	dbSelectArea("ESTDESP")
	dbSkip()
	
EndDo

dbSelectArea("ESTDESP")
dbCloseArea("ESTDESP")

Close(oDlg)

Return

//Seleciona e grava registros do ativo fixo tipo D

Static Function _GeraATF(dData5,dData6,cCusto5,cCusto6)

Local cQueryATF	:= ""
Local nATF      := 0
Local nRec3		:= 0

cQueryATF := "SELECT CT2_DEBITO,CT2_CCD,CT2_DATA,CT2_ROTINA,CT2_ORIGEM,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,SUM(CT2_VALOR) AS VALOR FROM CT2010 "
cQueryATF += "INNER JOIN CT1010 ON CT2_DEBITO = CT1_CONTA "
cQueryATF += "WHERE CT2010.D_E_L_E_T_ <> '*' AND CT1010.D_E_L_E_T_ <> '*' AND "
//cQueryATF += "(CT2_ROTINA LIKE ('%ATF%') OR SUBSTRING(CT2_DEBITO,1,3) = '126' OR SUBSTRING(CT2_DEBITO,1,3) = '127' OR SUBSTRING(CT2_DEBITO,1,3) = '129') AND "
cQueryATF += "(CT2_ROTINA LIKE ('%ATF%') AND " //Rafael Fran็a retiro as imobiliza็๕es para evitar duplicidades com o _GeraDESP
cQueryATF += "(SUBSTRING(CT2_DEBITO,1,5) = '41250' OR SUBSTRING(CT2_DEBITO,1,5) = '42250' OR SUBSTRING(CT2_DEBITO,1,5) = '43260' OR SUBSTRING(CT2_DEBITO,1,5) = '41255' OR SUBSTRING(CT2_DEBITO,1,5) = '42260' OR SUBSTRING(CT2_DEBITO,1,5) = '43265' OR SUBSTRING(CT2_DEBITO,1,5) = '46110' OR SUBSTRING(CT2_DEBITO,1,3) = '126' OR SUBSTRING(CT2_DEBITO,1,3) = '127' OR SUBSTRING(CT2_DEBITO,1,3) = '129') AND "  // Separa registros dos ativos
//cQueryATF += "CT2_DEBITO BETWEEN '" + (cConta1) + "' AND '" + (cConta2) + "' AND "
cQueryATF += "CT2_DEBITO IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_SIG <> '' AND CT1_BLOQ <> '1' AND D_E_L_E_T_ = '' AND CT1_NORMAL = '1') AND "
cQueryATF += "CT2_CCD BETWEEN '" + (cCusto5) + "' AND '" + (cCusto6) + "' AND "
cQueryATF += "CT2_DATA BETWEEN '" + DTOS(dData5) + "' AND '" + DTOS(dData6) + "' AND CT2_TPSALD = '1' AND "
cQueryATF += "CT2_FILIAL = '01' )"
//cQueryATF += "AND CT2_ROTINA LIKE ('%GPE%') "
cQueryATF += "GROUP BY CT2_DEBITO,CT2_CCD,CT2_DATA,CT2_ROTINA,CT2_ORIGEM,CT1_SIG,CT2_SEQUEN,CT2_SEQLAN"

tcQuery cQueryATF New Alias "TMPATF"

If Eof()
	MsgInfo("Nao existem dados no periodo/conta/c. custo informado!","Verifique")
	dbSelectArea("TMPATF")
	dbCloseArea("TMPATF")
	Return
Endif

Count To nRec3

dbSelectArea("TMPATF")
dbGoTop()

ProcRegua(nRec3)

While !EOF()
	
	IncProc()
	
	dbSelectArea("SZR")
	dBSetOrder(2)
	If !dbSeek(xFilial("SZR")+ SUBSTR(TMPATF->CT2_DEBITO,1,10) + TMPATF->CT2_CCD + " " + TMPATF->CT2_DATA + SUBSTR(TMPATF->CT2_ORIGEM,1,40))
		Reclock("SZR",.T.)
		SZR->ZR_CODIGO	:= SUBSTR(TMPATF->CT2_DATA,1,6)
		SZR->ZR_CODEMP	:= "12"
		SZR->ZR_UNDNEG	:= "1"
		SZR->ZR_PREFIXO	:= "ATF"
		SZR->ZR_DOC		:= SUBSTR(TMPATF->CT2_DATA,1,6) + STRZERO(nATF,4)
		SZR->ZR_FORNECE	:= "000131"
		SZR->ZR_LOJA	:= "01"
		//SZR->ZR_NOME	:= "RADIO TELEVISAO CAPITAL"
		SZR->ZR_EMISSAO	:= STOD(TMPATF->CT2_DATA)
		SZR->ZR_CTASIG  := TMPATF->CT1_SIG
		SZR->ZR_CONTA  	:= TMPATF->CT2_DEBITO
		SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+TMPATF->CT2_DEBITO,"CT1_DESC01")
		SZR->ZR_CC     	:= TMPATF->CT2_CCD
		SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+TMPATF->CT2_CCD,"CTT_DESC01")
		SZR->ZR_VALOR	:= TMPATF->VALOR
		SZR->ZR_MODULO	:= TMPATF->CT2_ROTINA
		SZR->ZR_HIST	:= "DEPRECIACAO MES " + MesExtenso(STOD(TMPATF->CT2_DATA)) + "C. CUSTO: " + TMPATF->CT2_CCD
		SZR->ZR_ORIGEM	:= TMPATF->CT2_ORIGEM      
		IF SUBSTR(TMPATF->CT2_ORIGEM,09,3) == 'ZZZ'     //SUBSTR(TMPDESP->CT2_ORIGEM,09,3)   
	   	SZR->ZR_TIPO	:= "Y"
		ELSE
		SZR->ZR_TIPO	:= "D"      
		ENDIF   
		SZR->ZR_SEQUEN	:= TMPATF->CT2_SEQUEN
		SZR->ZR_SEQLAN	:= TMPATF->CT2_SEQLAN		
		SZR->ZR_ROTINA  := "3" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo		
		MsUnlock()
	End
	
	nATF ++
	
	dbSelectArea("TMPATF")
	dbSkip()
	
EndDo

dbSelectArea("TMPATF")
dbCloseArea("TMPATF") 

_GeraVLJ(dData5,dData6)

Close(oDlg)

Return

//Seleciona registros de valor justo do ativo fixo tipo D

Static Function _GeraVLJ(dData5,dData6)                                    

Local cQueryVLJ	:= ""
Local nVLJ      := 0
Local nRec4		:= 0

cQueryVLJ := "SELECT CT2_DEBITO,CT2_CCD,CT2_DATA,CT2_ROTINA,CT2_ORIGEM,'14001' AS CT1_SIG,CT2_SEQUEN,CT2_SEQLAN,SUM(CT2_VALOR) AS VALOR "
cQueryVLJ += "FROM CT2010 WHERE CT2010.D_E_L_E_T_ = '' AND "
cQueryVLJ += "CT2_DATA BETWEEN '" + DTOS(dData5) + "' AND '" + DTOS(dData6) + "' AND CT2_TPSALD = '1' AND "
cQueryVLJ += "CT2_DEBITO IN (SELECT CT1_CONTA FROM CT1010 WHERE CT1_DESC01 LIKE '%VALOR JUSTO%' AND CT1_CONTA >= '3' AND CT1010.D_E_L_E_T_ = '') "
cQueryVLJ += "GROUP BY CT2_DEBITO,CT2_CCD,CT2_DATA,CT2_ROTINA,CT2_ORIGEM,CT2_SEQUEN,CT2_SEQLAN "

tcQuery cQueryVLJ New Alias "TMPVLJ"

If Eof()
	MsgInfo("Nao existem dados no periodo/conta/c. custo informado!","Verifique")
	dbSelectArea("TMPVLJ")
	dbCloseArea("TMPVLJ")
	Return
Endif

Count To nRec4

dbSelectArea("TMPVLJ")
dbGoTop()

ProcRegua(nRec4)

While !EOF()
	
	IncProc()
	
	dbSelectArea("SZR")
	dBSetOrder(2)
	If !dbSeek(xFilial("SZR")+ SUBSTR(TMPVLJ->CT2_DEBITO,1,10) + TMPVLJ->CT2_CCD + " " + TMPVLJ->CT2_DATA + SUBSTR(TMPVLJ->CT2_ORIGEM,1,40))
		Reclock("SZR",.T.)
		SZR->ZR_CODIGO	:= SUBSTR(TMPVLJ->CT2_DATA,1,6)
		SZR->ZR_CODEMP	:= "12"
		SZR->ZR_UNDNEG	:= "1"
		SZR->ZR_PREFIXO	:= "VLJ"
		SZR->ZR_DOC		:= SUBSTR(TMPVLJ->CT2_DATA,1,6) + STRZERO(nVLJ,4)
		SZR->ZR_FORNECE	:= "000131"
		SZR->ZR_LOJA	:= "01"
		//SZR->ZR_NOME	:= "RADIO TELEVISAO CAPITAL"
		SZR->ZR_EMISSAO	:= STOD(TMPVLJ->CT2_DATA)
		SZR->ZR_CTASIG  := TMPVLJ->CT1_SIG
		SZR->ZR_CONTA  	:= TMPVLJ->CT2_DEBITO
		SZR->ZR_CTADESC := Posicione("CT1",1,xfilial("CT1")+TMPVLJ->CT2_DEBITO,"CT1_DESC01")
		SZR->ZR_CC     	:= TMPVLJ->CT2_CCD
		SZR->ZR_NOMECC 	:= Posicione("CTT",1,xFilial("CTT")+TMPVLJ->CT2_CCD,"CTT_DESC01")
		SZR->ZR_VALOR	:= TMPVLJ->VALOR
		SZR->ZR_MODULO	:= TMPVLJ->CT2_ROTINA
		SZR->ZR_HIST	:= "DEPRECIACAO SOCIETARIA MES " + MesExtenso(STOD(TMPVLJ->CT2_DATA)) + "C. CUSTO: " + TMPVLJ->CT2_CCD
		SZR->ZR_ORIGEM	:= TMPVLJ->CT2_ORIGEM      
		IF SUBSTR(TMPVLJ->CT2_ORIGEM,09,3) == 'ZZZ'     //SUBSTR(TMPDESP->CT2_ORIGEM,09,3)   
	   	SZR->ZR_TIPO	:= "Y"
		ELSE
		SZR->ZR_TIPO	:= "D"      
		ENDIF   
		SZR->ZR_SEQUEN	:= TMPVLJ->CT2_SEQUEN
		SZR->ZR_SEQLAN	:= TMPVLJ->CT2_SEQLAN		
		SZR->ZR_ROTINA  := "4" // 1 = Receita; 2 = Despesa; 3 = Despesa Ativo Fixo; 4 = Valor Justo		
		MsUnlock()
	End
	
	nVLJ ++
	
	dbSelectArea("TMPVLJ")
	dbSkip()
	
EndDo

dbSelectArea("TMPVLJ")
dbCloseArea("TMPVLJ")

Close(oDlg)

Return

//Faz a compensa็ใo do credito nas despesas 

Static Function _RateioDESP(dData10,dData11)

Local cQueryDeb:= ""
Local cQueryTot  := ""
Local cQueryCon  := ""
Local cQueryCt  := ""
Local aInfo    := {}
Local aConta   := {}
Local cContas  := ""
Local nValDesc := 0
Local lOk := .F.
Local nRec2 := 0

//Localiza quais contas contabeis serใo descontadas sem utilizar filtro do centro de custo

cQueryCt := "SELECT * FROM SZT010 WHERE "
cQueryCt += "ZT_PERIODO = '" + SUBSTR(DTOS(dData11),1,6) + "' AND "
cQueryCt += "ZT_TIPO = 'D' AND "
cQueryCt += "D_E_L_E_T_ <> '*'"

tcQuery cQueryCt New Alias "TMPCT"

dBSelectArea("TMPCT")
While !EOF() 
	
	//aAdd(aConta,{Posicione("CT1",1,xfilial("CT1")+TMPCT->ZT_CONTA,"CT1_SIG")})
	aAdd(aConta,{ALLTRIM(TMPCT->ZT_CTASIG)})	
	
	Dbskip()
	
EndDo

dBSelectArea("TMPCT")
dbCloseArea("TMPCT")

If Len(aConta) > 0
	
	For i := 1 To Len(aConta)
		
		If i != Len(aConta)
			cContas += aConta[i][1] + ";"
		else
			cContas += aConta[i][1]            
		Endif
		
	Next i
	
EndIf

cQueryTot := "SELECT ZR_CODIGO,ZR_CTASIG,ZR_CC,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryTot += "ZR_TIPO = 'D' AND ZR_CTASIG NOT IN " + FormatIn(cContas,";")
cQueryTot += " AND (SUBSTRING(ZR_CONTA,1,3) <> '126' OR SUBSTRING(ZR_CONTA,1,3) <> '127' OR SUBSTRING(ZR_CONTA,1,3) <> '129') AND "
cQueryTot += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
cQueryTot += "GROUP BY ZR_CODIGO,ZR_CTASIG,ZR_CC "
cQueryTot += "ORDER BY ZR_CTASIG "

tcQuery cQueryTot New Alias "TMPTOT"

dBSelectArea("TMPTOT")

While !EOF()
	
	aAdd(aInfo,{TMPTOT->ZR_CODIGO,;
	TMPTOT->ZR_CC,;
	TMPTOT->ZR_CTASIG,;
	TMPTOT->VALOR})
	
	dBSelectArea("TMPTOT")
	dbSkip()
	                                          
Enddo

dBSelectArea("TMPTOT")
dbCloseArea("TMPTOT")

cQueryDeb := "SELECT ZR_CODIGO,ZR_CTASIG,ZR_CC,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryDeb += "ZR_TIPO = 'X' AND "
cQueryDeb += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
cQueryDeb += "GROUP BY ZR_CODIGO,ZR_CTASIG,ZR_CC "
cQueryDeb += "ORDER BY ZR_CTASIG "

tcQuery cQueryDeb New Alias "TMPDEB"

dBSelectArea("TMPDEB")


While !EOF()


	
	For i := 1 To Len(aInfo)
		
		IF (aInfo[i][2] == TMPDEB->ZR_CC .AND. aInfo[i][3] == TMPDEB->ZR_CTASIG)
			nPos := i
			lOk := .T.
			Exit
		EndIf
		
	Next i
	
	If lOk == .T.		
		
		cQueryCon := "SELECT * FROM SZR010 WHERE "
		cQueryCon += "ZR_TIPO = 'D' AND "
		cQueryCon += "ZR_CTASIG = '"+ TMPDEB->ZR_CTASIG +"' AND "
		cQueryCon += "ZR_CC = '"+ TMPDEB->ZR_CC +"' AND "
		cQueryCon += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
		cQueryCon += "ORDER BY ZR_CTASIG "
		
		tcQuery cQueryCon New Alias "TMPCON"
		
		DBSelectArea("TMPCON")
		While !EOF() //.AND. dData1 <= SZR->ZR_EMISSAO .AND. dData2 >= SZR->ZR_EMISSAO .AND. TMPDEB->ZR_CC == SZR->ZR_CC .AND. TMPDEB->ZR_CONTA == SZR->ZR_CONTA
			
			
			DBSelectArea("SZR")
			dbSetOrder(9)
			If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CTASIG,10) + PADR(TMPCON->ZR_CC,10) + TMPCON->ZR_EMISSAO + "D" + PADL(TMPCON->ZR_VALOR,14) + "2")
				
				nValDesc := TMPCON->ZR_VALOR - ((TMPCON->ZR_VALOR /aInfo[nPos][4]) * (TMPDEB->VALOR))
				Reclock("SZR",.F.)
				SZR->ZR_VALOR	:= nValDesc
				ZR_USERLGA := "COMPDESP"
				MsUnlock()
				
			EndIf
			
			nValDesc :=  0
			
			DBSelectArea("TMPCON")
			DBSkip()
			
		EndDo
		
		dBSelectArea("TMPCON")
		dbCloseArea("TMPCON")
		
	EndIf
	
	lOk := .F.
	
	
	
	dBSelectArea("TMPDEB")
	DBSkip()
	
Enddo

dBSelectArea("TMPDEB")
dbCloseArea("TMPDEB")


cQueryDeb	:= ""
cQueryTot  	:= ""
cQueryCon  	:= ""
nValDesc 	:= 0
lOk 		:= .F.

cQueryTot := "SELECT ZR_CODIGO,ZR_CONTA,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryTot += "ZR_TIPO = 'D' AND ZR_CONTA IN "+FormatIn(cContas,";")
cQueryTot += " AND ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
cQueryTot += "GROUP BY ZR_CODIGO,ZR_CONTA "
cQueryTot += "ORDER BY ZR_CONTA "

tcQuery cQueryTot New Alias "TMPTOT"

dBSelectArea("TMPTOT")
dbgotop()

ProcRegua(1000)

While !EOF()
	
	cQueryDeb := "SELECT ZR_CODIGO,ZR_CONTA,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
	cQueryDeb += "ZR_TIPO = 'X' AND ZR_CONTA = '" + TMPTOT->ZR_CONTA + "' AND "
	cQueryDeb += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
	cQueryDeb += "GROUP BY ZR_CODIGO,ZR_CONTA "
	cQueryDeb += "ORDER BY ZR_CONTA "
	
	tcQuery cQueryDeb New Alias "TMPDEB"
	
	dBSelectArea("TMPDEB")
	While !EOF()
		
		cQueryCon := "SELECT * FROM SZR010 WHERE "
		cQueryCon += "ZR_TIPO = 'D' AND "
		cQueryCon += "ZR_CONTA = '"+ TMPDEB->ZR_CONTA + "' AND "
		cQueryCon += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '2' "
		cQueryCon += "ORDER BY ZR_CONTA "
		
		tcQuery cQueryCon New Alias "TMPCON"
		
		DBSelectArea("TMPCON")
		While !EOF() //.AND. dData1 <= SZR->ZR_EMISSAO .AND. dData2 >= SZR->ZR_EMISSAO .AND. TMPDEB->ZR_CC == SZR->ZR_CC .AND. TMPDEB->ZR_CONTA == SZR->ZR_CONTA
			   IncProc()
			
			DBSelectArea("SZR")
			dbSetOrder(3)
			//If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CONTA,20) + "D" + PADL(TMPCON->ZR_VALOR,12))
			If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CONTA,20) + PADR(TMPCON->ZR_CC,10) + TMPCON->ZR_EMISSAO + "D" + PADL(TMPCON->ZR_VALOR,14) + "2")
				
				
				nValDesc := TMPCON->ZR_VALOR - ((TMPCON->ZR_VALOR /TMPTOT->VALOR) * (TMPDEB->VALOR))
				Reclock("SZR",.F.)
				SZR->ZR_VALOR	:= nValDesc
				ZR_USERLGA := ""
				MsUnlock()
				
			EndIf
			
			nValDesc :=  0
			
			DBSelectArea("TMPCON")
			DBSkip()
			
		EndDo
		
		dBSelectArea("TMPCON")
		dbCloseArea("TMPCON")
		
		dBSelectArea("TMPDEB")
		DBSkip()
		
	Enddo
	
	dBSelectArea("TMPDEB")
	dbCloseArea("TMPDEB")
	
	dBSelectArea("TMPTOT")
	DBSkip()
	
ENDDO

dBSelectArea("TMPTOT")
dbCloseArea("TMPTOT")

Close(oDlg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXSZR     บAutor  ณBruno               บ Data ณ  03/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que gera a Compensacao das despesas caso exista
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _RateioATIVO(dData10,dData11)

Local cQueryDeb:= ""
Local cQueryTot  := ""
Local cQueryCon  := ""
Local cQueryCt  := ""
Local aInfo    := {}
Local aConta   := {}
Local cContas  := ""
Local nValDesc := 0
Local lOk := .F.

//Localiza quais contas contabeis serใo descontadas sem utilizar filtro do centro de custo

cQueryCt := "SELECT * FROM SZT010 WHERE "
cQueryCt += "ZT_PERIODO = '" + SUBSTR(DTOS(dData11),1,6) + "' AND "
cQueryCt += "ZT_TIPO = 'D' AND "
cQueryCt += "D_E_L_E_T_ <> '*'"

tcQuery cQueryCt New Alias "TMPCT"

dBSelectArea("TMPCT")
While !EOF()
	
	aAdd(aConta,{TMPCT->ZT_CONTA})
	
	Dbskip()
	
EndDo

dBSelectArea("TMPCT")
dbCloseArea("TMPCT")

If Len(aConta) > 0
	
	For i := 1 To Len(aConta)
		
		If i != Len(aConta)
			cContas += aConta[i][1] + ";"
		else
			cContas += aConta[i][1]
		Endif
		
	Next i
	
EndIf

cQueryTot := "SELECT ZR_CODIGO,ZR_CONTA,ZR_CC,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryTot += "ZR_TIPO = 'D' AND ZR_CONTA NOT IN " + FormatIn(cContas,";")
cQueryTot += " AND SUBSTRING(ZR_CONTA,1,3) <> '126' OR SUBSTRING(ZR_CONTA,1,3) <> '127' OR SUBSTRING(ZR_CONTA,1,3) <> '129' AND "
cQueryTot += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
cQueryTot += "GROUP BY ZR_CODIGO,ZR_CONTA,ZR_CC "
cQueryTot += "ORDER BY ZR_CONTA "

tcQuery cQueryTot New Alias "TMPTOT"

dBSelectArea("TMPTOT")
While !EOF()
	
	aAdd(aInfo,{TMPTOT->ZR_CODIGO,;
	TMPTOT->ZR_CC,;
	TMPTOT->ZR_CONTA,;
	TMPTOT->VALOR})
	
	dBSelectArea("TMPTOT")
	dbSkip()
	
Enddo

dBSelectArea("TMPTOT")
dbCloseArea("TMPTOT")


cQueryDeb := "SELECT ZR_CODIGO,ZR_CONTA,ZR_CC,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryDeb += "ZR_TIPO = 'X' AND "
cQueryDeb += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
cQueryDeb += "GROUP BY ZR_CODIGO,ZR_CONTA,ZR_CC "
cQueryDeb += "ORDER BY ZR_CONTA "

tcQuery cQueryDeb New Alias "TMPDEB"

dBSelectArea("TMPDEB")
While !EOF()
	
	For i := 1 To Len(aInfo)
		
		IF (aInfo[i][2] == TMPDEB->ZR_CC .AND. aInfo[i][3] == TMPDEB->ZR_CONTA)
			nPos := i
			lOk := .T.
			Exit
		EndIf
		
	Next i
	
	If lOk == .T.
		
		cQueryCon := "SELECT * FROM SZR010 WHERE "
		cQueryCon += "ZR_TIPO = 'D' AND "
		cQueryCon += "ZR_CONTA = '"+ TMPDEB->ZR_CONTA +"' AND "
		cQueryCon += "ZR_CC = '"+ TMPDEB->ZR_CC +"' AND "
		cQueryCon += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
		cQueryCon += "ORDER BY ZR_CONTA "
		
		tcQuery cQueryCon New Alias "TMPCON"
		
		DBSelectArea("TMPCON")
		While !EOF() //.AND. dData1 <= SZR->ZR_EMISSAO .AND. dData2 >= SZR->ZR_EMISSAO .AND. TMPDEB->ZR_CC == SZR->ZR_CC .AND. TMPDEB->ZR_CONTA == SZR->ZR_CONTA
			
			
			DBSelectArea("SZR")
			dbSetOrder(3)
			If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CONTA,20) + PADR(TMPCON->ZR_CC,10) + TMPCON->ZR_EMISSAO + "D" + PADL(TMPCON->ZR_VALOR,14) + "3")
				
				nValDesc := TMPCON->ZR_VALOR - ((TMPCON->ZR_VALOR /aInfo[nPos][4]) * (TMPDEB->VALOR))
				Reclock("SZR",.F.)
				SZR->ZR_VALOR	:= nValDesc
				ZR_USERLGA := ""
				MsUnlock()
				
			EndIf
			
			nValDesc :=  0
			
			DBSelectArea("TMPCON")
			DBSkip()
			
		EndDo
		
		dBSelectArea("TMPCON")
		dbCloseArea("TMPCON")
		
	EndIf
	
	lOk := .F.
	
	dBSelectArea("TMPDEB")
	DBSkip()
	
Enddo

dBSelectArea("TMPDEB")
dbCloseArea("TMPDEB")


cQueryDeb	:= ""
cQueryTot  	:= ""
cQueryCon  	:= ""
nValDesc 	:= 0
lOk 		:= .F.

cQueryTot := "SELECT ZR_CODIGO,ZR_CONTA,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
cQueryTot += "ZR_TIPO = 'D' AND ZR_CONTA IN "+FormatIn(cContas,";")
cQueryTot += " AND ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
cQueryTot += "GROUP BY ZR_CODIGO,ZR_CONTA "
cQueryTot += "ORDER BY ZR_CONTA "

tcQuery cQueryTot New Alias "TMPTOT"

dBSelectArea("TMPTOT")
While !EOF()
	
	cQueryDeb := "SELECT ZR_CODIGO,ZR_CONTA,SUM(ZR_VALOR) AS VALOR FROM SZR010 WHERE "
	cQueryDeb += "ZR_TIPO = 'X' AND ZR_CONTA = '" + TMPTOT->ZR_CONTA + "' AND "
	cQueryDeb += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
	cQueryDeb += "GROUP BY ZR_CODIGO,ZR_CONTA "
	cQueryDeb += "ORDER BY ZR_CONTA "
	
	tcQuery cQueryDeb New Alias "TMPDEB"
	
	dBSelectArea("TMPDEB")
	While !EOF()
		
		cQueryCon := "SELECT * FROM SZR010 WHERE "
		cQueryCon += "ZR_TIPO = 'D' AND "
		cQueryCon += "ZR_CONTA = '"+ TMPDEB->ZR_CONTA + "' AND "
		cQueryCon += "ZR_EMISSAO BETWEEN '" + DTOS(dData10) + "'  AND '" + DTOS(dData11) + "' AND ZR_ROTINA = '3' "
		cQueryCon += "ORDER BY ZR_CONTA "
		
		tcQuery cQueryCon New Alias "TMPCON"
		
		DBSelectArea("TMPCON")
		While !EOF() //.AND. dData1 <= SZR->ZR_EMISSAO .AND. dData2 >= SZR->ZR_EMISSAO .AND. TMPDEB->ZR_CC == SZR->ZR_CC .AND. TMPDEB->ZR_CONTA == SZR->ZR_CONTA		
			
			DBSelectArea("SZR")
			dbSetOrder(3)
			//If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CONTA,20) + "D" + PADL(TMPCON->ZR_VALOR,12))
			If dbSeek(xFilial("SZR") + PADR(TMPCON->ZR_CONTA,20) + PADR(TMPCON->ZR_CC,10) + TMPCON->ZR_EMISSAO + "D" + PADL(TMPCON->ZR_VALOR,14) + "3")
						
				nValDesc := TMPCON->ZR_VALOR - ((TMPCON->ZR_VALOR /TMPTOT->VALOR) * (TMPDEB->VALOR))
				Reclock("SZR",.F.)
				SZR->ZR_VALOR	:= nValDesc
				ZR_USERLGA := ""
				MsUnlock()
				
			EndIf
			
			nValDesc :=  0
			
			DBSelectArea("TMPCON")
			DBSkip()
			
		EndDo
		
		dBSelectArea("TMPCON")
		dbCloseArea("TMPCON")
		
		dBSelectArea("TMPDEB")
		DBSkip()
		
	Enddo
	
	dBSelectArea("TMPDEB")
	dbCloseArea("TMPDEB")
	
	dBSelectArea("TMPTOT")
	DBSkip()
	
ENDDO

dBSelectArea("TMPTOT")
dbCloseArea("TMPTOT")

Close(oDlg)

Return
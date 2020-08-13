#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTEDISSº Autor ³ Bruno Alves        º Data ³  25/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajuste dissidio devido otimização de acumulo no roteiro    º±±
±±º           de calculo da folha de pagamento                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                              

//13/03/17 Alterado para novas verbas - Rafael

User Function AJUSTEDISS

Private cPerg	:= "AJUSTE2"

ValidPerg()
If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF


IF MV_PAR10 == 1

Processa({|| GravaDiss() },"Alterando Verbas 100/117/127/169/118/122/060... Alteração 20/08/18")

ELSEIF MV_PAR10 == 2                                                                                      

ImpDiss()

EndIf

Static Function GravaDiss  

Local nPerc := (MV_PAR11 / 100)

cQuery	:= "SELECT RHH_FILIAL,RHH_MAT,RHH_CC,RHH_VB,RHH_VL,RHH_CALC,  RHH_VL + (RHH_VL * "+ cValToChar(nPerc) + ") AS VLCALC,  RHH_VALOR, ((RHH_VL + (RHH_VL * "+ cValToChar(nPerc) + ")) - RHH_VL) AS DIFERENCA,RHH_DATA,RHH_MESANO FROM RHH010 WHERE "
cQuery	+= "RHH_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery	+= "RHH_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery	+= "RHH_CC BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery	+= "RHH_DATA BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery	+= "RHH_MESANO = '" + (MV_PAR09) + "' AND "
cQuery	+= "RHH_VB IN ('100','117','127','169','118','122','060') AND "
cQuery	+= "D_E_L_E_T_ <> '*' "
cQuery	+= "ORDER BY RHH_DATA"

TcQuery cQuery New Alias "TMP"

COUNT TO nRec

DbSelectArea("TMP")
dbGoTop()

procregua(nRec)


While !TMP->(Eof())
	
	IncProc("Gravando ajustes das Verbas 100/117/127/169/118/122/060")
	
	DbSelectArea("RHH")
	dbSetOrder(2)
	DbSeek(TMP->RHH_FILIAL+TMP->RHH_MAT+TMP->RHH_DATA+TMP->RHH_MESANO+TMP->RHH_VB) 
	If Found()
	
		RecLock("RHH",.F.)
		RHH_CALC := ROUND(TMP->VLCALC,2)
		RHH_VALOR := ROUND(TMP->DIFERENCA,2)
		RHH->(MSUNLOCK())                              
		
		
	EndIf
	
	
	
	
	TMP->(dbSkip())
	
	
End

MsgInfo("Alterações realizadas com sucesso nas verbas: 100/117/127/169/118/122/060!!!")

DBSelectARea("TMP")
DBCloseARea("TMP")


Return

Static Function IMPDISS


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Valor Ajustado de " + cValToChar(MV_PAR11 / 100)
Local nLin         := 80
Local nPerc 	   := (MV_PAR11 / 100)
Local Cabec1       := "Mes/Ano  Verba   Val. Original   Calculado Sist.  Calculado Ajust.  Dif. Sist.   Dif. Ajust."
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 120
Private tamanho          := "M"
Private nomeprog         := "IMPDISS" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "IMPDISS" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "RHH"
Private cQuery := ""




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)




cQuery	:= "SELECT RHH_FILIAL,RHH_MAT,RA_NOME,RHH_CC,CTT_DESC01,RHH_VB,RHH_VL,RHH_CALC,  RHH_VL + (RHH_VL * "+ cValToChar(nPerc) + ") AS VLCALC,  RHH_VALOR, ((RHH_VL + (RHH_VL * "+ cValToChar(nPerc) + ")) - RHH_VL) AS DIFERENCA,RHH_DATA,RHH_MESANO FROM RHH010 "
cQuery += "INNER JOIN CTT010 ON "
cQuery += "RHH_FILIAL = CTT_FILIAL AND "
cQuery += "RHH_CC = CTT_CUSTO "  
cQuery += "INNER JOIN SRA010 ON "
cQuery += "RHH_FILIAL = RA_FILIAL AND "
cQuery += "RHH_MAT = RA_MAT "
cQuery	+= "WHERE "
cQuery	+= "RHH_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery	+= "RHH_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery	+= "RHH_CC BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery	+= "RHH_DATA BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
cQuery	+= "RHH_MESANO = '" + (MV_PAR09) + "' AND "
cQuery	+= "RHH_VB IN ('100','117','127','169','118','122','060') AND "
cQuery	+= "RHH010.D_E_L_E_T_ <> '*' AND "
cQuery	+= "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery	+= "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY CTT_DESC01,RA_NOME,RHH_DATA,RHH_VB "


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
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
15267±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
cCC := ""
cMat := ""
lOk := .T.
lOkMat := .T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

dbSelectARea("TMP")
dbGoTop()

While !EOF()
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	cCC := TMP->RHH_CC
	cMat := TMP->RHH_MAT	
	
	If lOk == .T.
		@nLin, 000 PSAY TMP->CTT_DESC01
		nLin += 3
	EndIf
	
		If lOkMat == .T.
	@nLin, 000 PSAY TMP->RHH_MAT
	@nLin, 008 PSAY TMP->RA_NOME
		nLin += 2
	EndIf
	
	@nLin, 000 PSAY SUBSTR(TMP->RHH_DATA,5,2) + "/" + SUBSTR(TMP->RHH_DATA,1,4)
	@nLin, 010 PSAY TMP->RHH_VB 
	@nLin, 017 PSAY TMP->RHH_VL PICTURE "@E 999,999.99"
	@nLin, 033 PSAY TMP->RHH_CALC  PICTURE "@E 999,999.99" //CALCULO SISTEMA
	@nLin, 051 PSAY TMP->VLCALC  PICTURE "@E 999,999.99" //CALCULO MANUAL
	@nLin, 066 PSAY TMP->RHH_VALOR PICTURE "@E 999,999.99" //CALCULO SISTEMA
	@nLin, 078 PSAY TMP->DIFERENCA PICTURE "@E 999,999.99" //CALCULO MANUAL	
	
	nLin += 1

	
	
	
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	If cCC != TMP->RHH_CC
		nLin := 61 // Pula Página
		lOk := .T.
	Else
		lOk := .F.
	EndIf
	
		If cMat != TMP->RHH_MAT
		lOkMat := .T.
	Else
		lOkMat := .F.
	EndIf
	
EndDo

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

DBSelectAREa("TMP")
DBCloseARea("TMP")

Return


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Da Filial        ?","","","mv_ch1","C",02,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{cPerg,"02","Ate Filial     ?","","","mv_ch2","C",02,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
aAdd(aRegs,{cPerg,"03","Da Matricula         ?","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"04","Ate Matricula      ?","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"05","De C. Custo        ?","","","mv_ch5","C",09,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"06","Ate C. Custo     ?","","","mv_ch6","C",09,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"07","De Data (AAAAMM)        ?","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate Data (AAAAMM)      ?","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ano/Mes do Calculo (AAAAMM)      ?","","","mv_ch9","C",06,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Processo      ?","","","mv_ch10","N",01,00,0,"C","","mv_par10","Gravar","","","","","Relatório","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Porcentagem      ?","","","mv_ch11","N",05,2,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})



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

#INCLUDE "rwmake.ch"
#DEFINE nMult 118.11023

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณETQCHQ    บ Autor ณ HERMANO NOBRE      บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressใo de etiquetas para impressใo no verso dos cheques บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Record                                                     บฑฑ
ฑฑบAltera็๕esณ Cristiano 11/07/07 - Ajustar o salto de pแgina.            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ETQCHQ()

	Private cPerg       := "ETQCHQ    "

If !Pergunte( cPerg, .T. )
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 390,380 DIALOG oDlg TITLE OemToAnsi("Impressao de Etiquetas de produtos")
@ 02,10 TO 070,180
@ 10,015 Say "Este programa ira imprimir as etiquetas de produtos, conforme "
@ 18,015 Say "os Parametros definidos pelo usuario, com os dados da nota    "
@ 26,015 Say "fiscal de entrada.                                            "
@ 80,100 BMPBUTTON TYPE 01 ACTION Prossegue()
@ 80,130 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 80,160 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oDlg Centered

Return

Static Function Prossegue()
                                            

Local nOrdem
Local cNome		:= ""
Local cNReduz	:= ""
Local aCheques	:= {}
Local cQuery	:= ""
Local npElem	:= 0
Local dVenc		:= CTOD('  /  /  ')
Local nSalt		:= 0
Local nEtiq		:= 0                    	
Local nLin		:= 1.8
Local nCol		:= 0.80
Local nPos		:= 0.80
Local nTmLin := 0.30
Local nTmCol	:= 10

oFont7  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont	:= TFont():New( "Arial",,09,,.F.,,,,,.F. )
oPrn	:= TMSPrinter():New()
oPrn	:Setup()
oPrn	:startPage()

Close(oDlg) // Fecha a Caixa de Dialogo	

cQuery  := " SELECT * FROM "+RetSqlName("SEF")
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND EF_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND EF_BANCO = '" + MV_PAR03 + "' "
cQuery += " AND EF_AGENCIA = '" + MV_PAR04 + "' "
cQuery += " AND EF_CONTA = '" + MV_PAR05 + "' "
cQuery += " AND EF_DATA BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' "
cQuery += " AND EF_IMPRESS <> 'C' "
cQuery += " ORDER BY EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, EF_SEQUENC"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QSEF',.T.,.T.)

dbSelectArea("QSEF")
dbGoTop()

While !Eof()
	If !Empty(QSEF->EF_FORNECE)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+QSEF->EF_FORNECE+QSEF->EF_LOJA)
		cNome		:= SA2->A2_NOME
		cNReduz	:= SA2->A2_NREDUZ
		dbSelectArea("SE5")
		dbSetOrder(11)
		If dbSeek(xFilial("SE5")+QSEF->EF_BANCO+QSEF->EF_AGENCIA+QSEF->EF_CONTA+QSEF->EF_NUM+QSEF->EF_DATA)
			dVenc	:= SE5->E5_DTDISPO     
		EndIf
	Else
		cNome		:= QSEF->EF_BENEF
		cNReduz	:= QSEF->EF_BENEF
		dVenc		:= STOD(QSEF->EF_DATA)
	EndIf

	npElem	:= Ascan(aCheques,{|x|x[1]==QSEF->EF_NUM})
	If npElem == 0
		AADD(aCheques,{QSEF->EF_NUM,;				//[1] Numero do cheque
		STOD(QSEF->EF_DATA),;						//[2] Data de emissao
		dVenc,;						 					//[3] Vencimento
		QSEF->EF_PREFIXO+"-"+QSEF->EF_TITULO,;	//[4] Parcela
		cNome,;											//[5] Razao social
		cNreduz,;										//[6] Nome Fantasia
		QSEF->EF_HIST})								//[7] Historico
	ElseIf !Empty(QSEF->EF_TITULO)
		aCheques[npElem][4]	:= aCheques[npElem][4] + "/" + ;
		QSEF->EF_PREFIXO+"-"+QSEF->EF_TITULO
	EndIf
	dbSelectArea("QSEF")
	dbSkip()
	Loop
End

QSEF->(dbCloseArea())

For I:= 1 To Len(aCheques)
	//nEtiq++ Cristiano 11/07/07
	If nEtiq == 7  //Cristiano 11/07/07. Alterado de 8 para 7
		oPrn:endPage()
		oPrn:startPage()
		nLin	:= 1.8
		nEtiq	:= 0
	EndIf
	nSalt	:= 0
	nLinOld	:= nLin
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][6],1,50),oFont)
	nCol += nTmCol
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][6],1,50),oFont)
	nCol -= nTmCol                        
 	nLin += 0.30
            
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][5],1,50),oFont)
	nCol += nTmCol
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][5],1,50),oFont)
	nCol -= nTmCol                        
	nLin += 0.30
	
	oPrn:Say(nLin*nMult, nCol*nMult,"CHEQUE: "+Substr(aCheques[I][1],1,50),oFont)
	nCol += nTmCol
	oPrn:Say(nLin*nMult, nCol*nMult,"CHEQUE: "+Substr(aCheques[I][1],1,50),oFont)
	nCol -= nTmCol                        
	nLin += 0.30

	oPrn:Say(nLin*nMult, nCol*nMult,"EMISSAO: "+DtoC(aCheques[I][2]),oFont)
	nCol += 4
	oPrn:Say(nLin*nMult, nCol*nMult,"VENC.: "+Dtoc(aCheques[I][3]),oFont)
	nCol += nTmCol - 4
	
	oPrn:Say(nLin*nMult, nCol*nMult,"EMISSAO: "+Dtoc(aCheques[I][2]),oFont)
	nCol += 4
	oPrn:Say(nLin*nMult, nCol*nMult,"VENC.: "+Dtoc(aCheques[I][3]),oFont)
	nCol -= nTmCol + 4
	nLin += 0.30
	                                                                             
	oPrn:Say(nLin*nMult, nCol*nMult,Substr("TIT: " + aCheques[I][4],1,50),oFont)
	nCol += nTmCol
	oPrn:Say(nLin*nMult, nCol*nMult,Substr("TIT: " + aCheques[I][4],1,50),oFont)
	nCol -= nTmCol                        
	nLin += 0.30
	
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][7],1,50),oFont)
	nCol += nTmCol
	oPrn:Say(nLin*nMult, nCol*nMult,Substr(aCheques[I][7],1,50),oFont)
	nCol -= nTmCol                        
	nLin += 0.30
	

/*	If Len(aCheques[I][4]) > 37
	nLin++
		@ nLin, 001 PSAY Substr(aCheques[I][4],1,37)
		@ nLin, 041 PSAY Substr(aCheques[I][4],1,37)
		nSalt := 1
	EndIf*/
	nLin := nLinOld + 3.8
	nEtiq++ //Cristiano 11/07/07. Inserido.
Next         

oPrn:EndPage()
oPrn:Preview()
oPrn:End()

Return

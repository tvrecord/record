#include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExpSig    บAutor  ณBruno Alves         บ Data ณ  03/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExporta็ใo do arquivo do SIG                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TelaSig

Private dData1 	:= CtoD("//")
Private dData2 	:= CtoD("//")

Private cDoc := ""
Private cFornece := ""
Private cCliente := ""
Private cLoja := ""
Private cCCSig := ""             
Private cDocAtu := ""
Private nSeq  := 100
Private aItems:= {'Receita','Despesa'}   
Private oArquivo
Private cArquivo

DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD


@ 000,000 TO 150,300 DIALOG oDlg TITLE "Exporta็ใo de Arquivo"
@ 011,020 Say "Data Inicial:"
@ 010,060 Get dData1 SIZE 40,020
@ 025,020 Say "Data Final:"
@ 024,060 Get dData2 SIZE 40,020
@ 035,020 Say "Arquivo:"
@ 034,060 COMBOBOX oArquivo ITEMS aItems  SIZE 70,020 OF oDlg PIXEL FONT oFont
@ 061,090 BMPBUTTON TYPE 01 ACTION ExpSig()
@ 060,120 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return


//----------------------------------------------------------------------------------------------------------------//
// Exportacao de dados para o Excel.
//----------------------------------------------------------------------------------------------------------------//
Static Function ExpSig()


Close(oDlg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If oArquivo == "Receita"

Processa({|| ArqCliente() },"Exportando Arquivo Cliente...")

Processa({|| ArqReceita() },"Exportando Arquivo Receita...")

ElseIf oArquivo == "Despesa"

Processa({|| ArqFornece() },"Exportando Arquivo Fornecedor...")

Processa({|| ArqDesp() },"Exportando Arquivo Despesa...")

EndIf



Return


Static Function ArqCliente
Local oExcel
Local cArq  := ""
Local nArq  := 0
Local cPath := ""
Local cQuery := ""
Local nReq := 0
Local aStru:={}
Local cPessoa  	:= ""
Local cCgc		:= ""
Local cNome		:= ""
Local cNReduz	:= ""
Local cCliente1  := ""
Local cLoja1		:= ""

/*
cQuery	:= "SELECT ZR_CODEMP,ZR_CLIENTE,ZR_LOJA,A1_PESSOA,A1_CGC,A1_NOME,A1_NREDUZ,ZR_ORIGEM FROM SZR010 "
cQuery	+= "LEFT JOIN SA1010 ON "
cQuery	+= "SA1010.A1_COD = SZR010.ZR_CLIENTE AND "
cQuery	+= "SA1010.A1_LOJA = SZR010.ZR_LOJA "
cQuery	+= "WHERE "
cQuery	+= "SA1010.D_E_L_E_T_ <> '*' AND "
cQuery	+= "SZR010.D_E_L_E_T_ <> '*' AND "
cQuery	+= "SZR010.ZR_TIPO = 'C' AND "
cQuery	+= "SZR010.ZR_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' "
cQuery	+= "GROUP BY ZR_CODEMP,ZR_CLIENTE,ZR_LOJA,A1_PESSOA,A1_CGC,A1_NOME,A1_NREDUZ,ZR_ORIGEM "
cQuery	+= "ORDER BY ZR_CLIENTE"
*/

cQuery	:= "SELECT ZR_CODEMP,ZR_CLIENTE,ZR_LOJA FROM SZR010 "
cQuery	+= "WHERE "
cQuery	+= "D_E_L_E_T_ <> '*' AND "
cQuery	+= "ZR_TIPO = 'C' AND "
cQuery	+= "ZR_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' "
cQuery	+= "GROUP BY ZR_CODEMP,ZR_CLIENTE,ZR_LOJA "
cQuery	+= "ORDER BY ZR_CLIENTE"

TcQuery cQuery New Alias "TMP"

COUNT TO nRec

/*
If !ApOleClient("MSExcel")
MsgAlert("Microsoft Excel nใo instalado!")
Return
EndIf
*/





cPath := "C:\SIG\CLIENTES12"
nArq  := FCreate(cPath + ".TXT")


If nArq == -1
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf

//FWrite(nArq, "Codigo;Nome;Endereco" + Chr(13) + Chr(10))


dbSelectArea("TMP")
dbGoTop()

procregua(nRec)


While !TMP->(Eof())
	
	IncProc("Gerando Arquivo Cliente:   " + TMP->ZR_CLIENTE)
/*	
	If TMP->ZR_CLIENTE != cCliente1 .OR. TMP->ZR_LOJA != cLoja1
		
		IF 	SUBSTR(TMP->ZR_ORIGEM,1,3) == "510" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "008" .OR. SUBSTR(TMP->ZR_ORIGEM,1,3) == "512" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "002" .OR. ;
			SUBSTR(TMP->ZR_ORIGEM,1,3) == "515" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "001" .OR. SUBSTR(TMP->ZR_ORIGEM,1,3) == "530" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "002" .OR. ;
			SUBSTR(TMP->ZR_ORIGEM,1,3) == "530" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "003" .OR. SUBSTR(TMP->ZR_ORIGEM,1,3) == "531" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "001" .OR. ;
			SUBSTR(TMP->ZR_ORIGEM,1,3) == "531" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "005" .OR. SUBSTR(TMP->ZR_ORIGEM,1,3) == "531" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "006" .OR. ;
			SUBSTR(TMP->ZR_ORIGEM,1,3) == "590" .AND. SUBSTR(TMP->ZR_ORIGEM,5,3) == "005"
			cPessoa 	:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_TIPO")
			cCgc 		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_CGC")
			cNome		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_NOME")
			cNReduz		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_NREDUZ")
		else
		*/
		
		If EMPTY(Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A1_CGC"))
		
			cPessoa 	:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_TIPO")
			cCgc 		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_CGC")
			cNome		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_NOME")
			cNReduz		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A2_NREDUZ")
			
			ELSE
		
			cPessoa 	:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A1_PESSOA")
			cCgc 		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A1_CGC")
			cNome		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A1_NOME")
			cNReduz		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP->ZR_CLIENTE) + ALLTRIM(TMP->ZR_LOJA),"A1_NREDUZ")
		EndIf
		
		If cPessoa == "X"
			cPessoa := "J"
			cCgc 	:= "00000000000000"
		EndIf
		
		//ZR_CODEMP,ZR_CLIENTE,ZR_LOJA,A1_PESSOA,A1_CGC,A1_NOME,A1_NREDUZ "
		FWrite(nArq, ALLTRIM(TMP->ZR_CLIENTE) + TMP->ZR_LOJA + ";" + ALLTRIM(TMP->ZR_CODEMP) + ";" + cPessoa + ";" + IIF(Alltrim(cPessoa) == "F",Transform(cCgc,"@R 999.999.999-99"),Transform(cCgc,"@R 99.999.999/9999-99")) + ";" + ALLTRIM(cNome) + ";" + ALLTRIM(cNReduz) + Chr(13) + Chr(10))
		
   //	EndIf
	
	cCliente1 := TMP->ZR_CLIENTE
	cLoja1 	 := TMP->ZR_LOJA
	
	TMP->(dbSkip())
	
	
End

FClose(nArq)
DBSelectARea("TMP")
DBCloseARea("TMP")
DBSelectARea("SA2")
DBCloseARea("SA2")


oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath + ".TXT")
oExcel:SetVisible(.T.)
oExcel:Destroy()




FErase(cPath + ".TXT")

Return


Static Function ArqReceita
Local oExcel
Local cArq  := ""
Local nArq  := 0
Local cPath := ""
Local cQuery := ""
Local nReq := 0
Local aStru:={}
Local cHistorico := ""

cQuery	:= "SELECT ZR_DOC,ZR_CODEMP,ZR_CLIENTE,ZR_LOJA,ZR_UNDNEG,CTT_CCSIG,ZR_CTASIG,SUM(ZR_VALOR) AS VALOR, ZR_EMISSAO,ZR_HIST,ZR_SEQUEN,ZR_SEQLAN FROM SZR010 "
cQuery	+= "INNER JOIN CTT010 ON "
cQuery	+= "CTT010.CTT_CUSTO = SZR010.ZR_CC "
cQuery	+= "WHERE "
cQuery	+= "CTT010.CTT_FILIAL = '01' AND "
cQuery	+= "SZR010.ZR_TIPO = 'C' AND "
cQuery	+= "ZR_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND "
cQuery	+= "SZR010.D_E_L_E_T_ <> '*' AND CTT010.D_E_L_E_T_ <> '*' "
cQuery	+= "GROUP BY SZR010.ZR_DOC,SZR010.ZR_CODEMP,SZR010.ZR_CLIENTE,SZR010.ZR_LOJA,SZR010.ZR_UNDNEG,CTT010.CTT_CCSIG,SZR010.ZR_CTASIG,SZR010.ZR_EMISSAO,SZR010.ZR_HIST,ZR_SEQUEN,ZR_SEQLAN "
cQuery	+= "ORDER BY ZR_DOC,ZR_CLIENTE,ZR_LOJA,ZR_CTASIG"

TcQuery cQuery New Alias "TMP1"

COUNT TO nRec


If !ApOleClient("MSExcel")
MsgAlert("Microsoft Excel nใo instalado!")
Return
EndIf

cPath := "C:\SIG\RECEITAS12"
nArq  := FCreate(cPath + ".TXT")


If nArq == -1
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf

//FWrite(nArq, "Codigo;Nome;Endereco" + Chr(13) + Chr(10))


dbSelectArea("TMP1")
dbGoTop()

procregua(nRec)


While !TMP1->(Eof())
	
	IncProc("Gerando Arquivo de Receita:   " + TMP1->ZR_DOC + " - " + TMP1->ZR_CLIENTE + " - " + TMP1->ZR_LOJA)
	
	
	If TMP1->ZR_DOC == cDoc .AND. TMP1->ZR_CLIENTE == cCliente .AND. TMP1->ZR_LOJA == cLoja //.AND.  TMP1->CTT_CCSIG == cCCSig 
		cDocAtu := ALLTRIM(TMP1->ZR_DOC) + cValtoChar(nSeq)
		nSeq++
	Else
		nSeq := 100
		cDocAtu := ALLTRIM(TMP1->ZR_DOC)
	EndIf
	
	cDoc		:= TMP1->ZR_DOC
	cCliente	:= TMP1->ZR_CLIENTE
	cLoja 		:= TMP1->ZR_LOJA
	cCCSig 		:= TMP1->CTT_CCSIG
	cHistorico  := TMP1->ZR_HIST
	nValor		:= TMP1->VALOR

	
	If	!EMPTY(TMP1->ZR_SEQUEN) .AND. !EMPTY(TMP1->ZR_SEQLAN)
		
		cQuery := "SELECT CT2_HIST,CT2_SEQHIS FROM CT2010 WHERE "
		cQuery += "CT2_DATA = '" + (TMP1->ZR_EMISSAO) + "' AND "
		cQuery += "CT2_SEQUEN = '" + (TMP1->ZR_SEQUEN) + "' AND "
		cQuery += "CT2_SEQLAN = '" + (TMP1->ZR_SEQLAN) + "' AND "
		cQuery += "CT2_FILIAL = '01' AND "
		cQuery += "CT2_SEQHIS > '001' AND "
		cQuery += "D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY CT2_LINHA "
		
		TcQuery cQuery New Alias "HIS"
		
		DBSelectArea("HIS")
		
		While !EOF()
			cHistorico += HIS->CT2_HIST
			HIS->(dbsKIP())
		EndDo
		
		DBSelectArea("HIS")
		DBCloseARea("HIS")
		
	EndIf	
	
	
	
	//ZR_DOC,ZR_CODEMP,ZR_CLIENTE,ZR_LOJA,ZR_UNDNEG,ZR_CC,ZR_CTASIG,ZR_EMISSAO,ZR_VALOR,ZR_HIST
	
	FWrite(nArq, ("12" + cDocAtu) + ";" + ALLTRIM(TMP1->ZR_CODEMP) + ";" + ALLTRIM(TMP1->ZR_CLIENTE) + TMP1->ZR_LOJA + ";" + "1"  + ";" + ALLTRIM(IIF(SUBSTR(TMP1->CTT_CCSIG,1,1) == "0",SUBSTR(TMP1->CTT_CCSIG,2,1) ,SUBSTR(TMP1->CTT_CCSIG,1,2))) + ";" + ALLTRIM(iif(SUBSTR(TMP1->ZR_CTASIG,1,1) == "0",SUBSTR(TMP1->ZR_CTASIG,2,4),TMP1->ZR_CTASIG)) + ";" + Transform(TMP1->ZR_EMISSAO,"@R 9999/99/99") + ";" + cValToChar(TMP1->VALOR) + ";" + cHistorico + Chr(13) + Chr(10))
	
	
	TMP1->(dbSkip())
	
	
End

FClose(nArq)
DBSelectARea("TMP1")
DBCloseARea("TMP1")


oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath + ".TXT")
oExcel:SetVisible(.T.)
oExcel:Destroy()




FErase(cPath + ".TXT")

Return

Static Function ArqFornece
Local oExcel
Local cArq  := ""
Local nArq  := 0
Local cPath := ""
Local cQuery := ""
Local nReq := 0
Local aStru:={}
Local cPessoa  	:= ""
Local cCgc		:= ""
Local cNome		:= ""
Local cNReduz	:= ""
Local cFornece1  := ""
Local cLoja1 	:= ""

cQuery	:= "SELECT ZR_CODEMP,ZR_FORNECE,ZR_LOJA FROM SZR010 " // ZR_ORIGEM RETIRADO PELO BRUNO 13/03/2013
cQuery	+= "WHERE "
cQuery	+= "D_E_L_E_T_ <> '*' AND "
cQuery	+= "ZR_TIPO = 'D' AND "
cQuery	+= "ZR_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' "
cQuery	+= "GROUP BY ZR_CODEMP,ZR_FORNECE,ZR_LOJA "// ZR_ORIGEM RETIRADO PELO BRUNO 13/03/2013
cQuery	+= "ORDER BY ZR_FORNECE"

TcQuery cQuery New Alias "TMP2"

COUNT TO nRec


If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel nใo instalado!")
	Return
EndIf



cPath := "C:\SIG\FORNECEDORES12"
nArq  := FCreate(cPath + ".TXT")


If nArq == -1
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf

//FWrite(nArq, "Codigo;Nome;Endereco" + Chr(13) + Chr(10))


dbSelectArea("TMP2")
dbGoTop()

procregua(nRec)


While !TMP2->(Eof())
	
	IncProc("Gerando Arquivo de Fornecedores:   " + TMP2->ZR_FORNECE)
	
/*	If TMP2->ZR_FORNECE != cFornece1 .OR.  TMP2->ZR_LOJA != cLoja1
		
  		IF SUBSTR(TMP2->ZR_ORIGEM,1,3) == "520" .AND. SUBSTR(TMP2->ZR_ORIGEM,5,3) == "001" .OR. SUBSTR(TMP2->ZR_ORIGEM,1,3) == "520" .AND. SUBSTR(TMP2->ZR_ORIGEM,5,3) == "003"
			cPessoa 	:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A1_PESSOA")
			cCgc 		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A1_CGC")
			cNome		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A1_NOME")
			cNReduz		:= Posicione("SA1",1,xFilial("SA1")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A1_NREDUZ")
	
		else*/
			cPessoa 	:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A2_TIPO")
			cCgc 		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A2_CGC")
			cNome		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A2_NOME")
			cNReduz		:= Posicione("SA2",1,xFilial("SA2")+ALLTRIM(TMP2->ZR_FORNECE) + ALLTRIM(TMP2->ZR_LOJA),"A2_NREDUZ")
///		EndIf

		
		If cPessoa == "X"
			cPessoa := "J"
			cCgc 	:= "00000000" + ALLTRIM(TMP2->ZR_FORNECE)
		EndIf
		
		//ZR_CODEMP,ZR_FORNECE,ZR_LOJA,A2_TIPO,A2_CGC,A2_NOME,A2_NREDUZ
		FWrite(nArq, ALLTRIM(TMP2->ZR_FORNECE) + TMP2->ZR_LOJA + ";" + ALLTRIM(TMP2->ZR_CODEMP) + ";" + cPessoa + ";" + IIF(Alltrim(cPessoa) == "F",Transform(cCgc,"@R 999.999.999-99"),Transform(cCgc,"@R 99.999.999/9999-99")) + ";" + ALLTRIM(cNome) + ";" + ALLTRIM(cNReduz) + Chr(13) + Chr(10))
		
//	EndIf
	
	cFornece1 := TMP2->ZR_FORNECE
	cLoja1    := TMP2->ZR_LOJA
	
	TMP2->(dbSkip())
	
	
End

FClose(nArq)
DBSelectARea("TMP2")
DBCloseARea("TMP2")



oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath + ".TXT")
oExcel:SetVisible(.T.)
oExcel:Destroy()




FErase(cPath + ".TXT")

Return

Static Function ArqDesp
Local oExcel
Local cArq  := ""
Local nArq  := 0
Local cPath := ""
Local cQuery := ""
Local nReq := 0
Local aStru:={}
Local cHistorico := ""


cQuery	:= "SELECT ZR_DOC,ZR_CODEMP,ZR_FORNECE,ZR_LOJA,ZR_UNDNEG,CTT_CCSIG,ZR_CTASIG,SUM(ZR_VALOR) AS VALOR, ZR_EMISSAO,ZR_HIST,ZR_SEQUEN,ZR_SEQLAN FROM SZR010 "
cQuery	+= "INNER JOIN CTT010 ON "
cQuery	+= "CTT010.CTT_CUSTO = SZR010.ZR_CC "
cQuery	+= "WHERE "
cQuery	+= "CTT010.CTT_FILIAL = '01' AND "
cQuery	+= "SZR010.ZR_TIPO = 'D' AND "
cQuery	+= "ZR_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' AND "
cQuery	+= "SZR010.D_E_L_E_T_ <> '*' AND CTT010.D_E_L_E_T_ <> '*' "
cQuery	+= "GROUP BY SZR010.ZR_DOC,SZR010.ZR_CODEMP,SZR010.ZR_FORNECE,SZR010.ZR_LOJA,SZR010.ZR_UNDNEG,CTT010.CTT_CCSIG,SZR010.ZR_CTASIG,SZR010.ZR_EMISSAO,SZR010.ZR_HIST,ZR_SEQUEN,ZR_SEQLAN "
cQuery  += "ORDER BY ZR_DOC,ZR_FORNECE,ZR_LOJA,ZR_CTASIG "

TcQuery cQuery New Alias "TMP3"

COUNT TO nRec

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel nใo instalado!")
	Return
EndIf


cPath := "C:\SIG\DESPESAS12"
nArq  := FCreate(cPath + ".TXT")


If nArq == -1
	MsgAlert("Nao conseguiu criar o arquivo!")
	Return
EndIf

//FWrite(nArq, "Codigo;Nome;Endereco" + Chr(13) + Chr(10))

dbSelectArea("TMP3")
dbGoTop()

procregua(nRec)

While !TMP3->(Eof())
	
	IncProc("Gerando Arquivo de Despesa:   " + TMP3->ZR_DOC + " - " + TMP3->ZR_FORNECE + " - " + TMP3->ZR_LOJA)
	
	
	If TMP3->ZR_DOC == cDoc .AND. TMP3->ZR_FORNECE == cFornece .AND. TMP3->ZR_LOJA == cLoja //.AND. TMP3->CTT_CCSIG == cCCSig   
		cDocAtu := ALLTRIM(TMP3->ZR_DOC) + cValtoChar(nSeq)
		nSeq++
	Else
		nSeq := 100
		cDocAtu := ALLTRIM(TMP3->ZR_DOC)
	EndIf
	
	cDoc		:= TMP3->ZR_DOC
	cFornece	:= TMP3->ZR_FORNECE
	cLoja 		:= TMP3->ZR_LOJA
	cCCSig 		:= TMP3->CTT_CCSIG
	cHistorico  := TMP3->ZR_HIST    
	nValor		:= TMP3->VALOR
	
	If	!EMPTY(TMP3->ZR_SEQUEN) .AND. !EMPTY(TMP3->ZR_SEQLAN)
		
		cQuery := "SELECT CT2_HIST,CT2_SEQHIS FROM CT2010 WHERE "
		cQuery += "CT2_DATA = '" + (TMP3->ZR_EMISSAO) + "' AND "
		cQuery += "CT2_SEQUEN = '" + (TMP3->ZR_SEQUEN) + "' AND "
		cQuery += "CT2_SEQLAN = '" + (TMP3->ZR_SEQLAN) + "' AND "
		cQuery += "CT2_FILIAL = '01' AND "
		cQuery += "CT2_SEQHIS > '001' AND "
		cQuery += "D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY CT2_LINHA "
		
		TcQuery cQuery New Alias "HIS"
		
		DBSelectArea("HIS")
		
		While !EOF()
			cHistorico += HIS->CT2_HIST
			HIS->(dbsKIP())
		EndDo
		
		DBSelectArea("HIS")
		DBCloseARea("HIS")
		
	EndIf
	
	
	FWrite(nArq, ("12" + cDocAtu) + ";" + ALLTRIM(TMP3->ZR_CODEMP) + ";" +  ALLTRIM(TMP3->ZR_FORNECE) + TMP3->ZR_LOJA + ";" + "1" + ";" + ALLTRIM(IIF(SUBSTR(TMP3->CTT_CCSIG,1,1) == "0",SUBSTR(TMP3->CTT_CCSIG,2,1) ,SUBSTR(TMP3->CTT_CCSIG,1,2))) + ";" + ALLTRIM(iif(SUBSTR(TMP3->ZR_CTASIG,1,1) == "0",SUBSTR(TMP3->ZR_CTASIG,2,4),TMP3->ZR_CTASIG)) + ";" + Transform(TMP3->ZR_EMISSAO,"@R 9999/99/99") + ";" + cValToChar(TMP3->VALOR) + ";" + cHistorico + Chr(13) + Chr(10))
	
	DBSelectArea("TMP3")
	
	TMP3->(dbSkip())
	
	
End

FClose(nArq)
DBSelectARea("TMP3")
DBCloseARea("TMP3")


oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath + ".TXT")
oExcel:SetVisible(.T.)
oExcel:Destroy()




FErase(cPath + ".TXT")

Return

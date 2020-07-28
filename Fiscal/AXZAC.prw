#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXZAC  บ Autor ณ Rafael Fran็a         บ Data ณ  12/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Declara็ใo de ISS Fornecedor                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RECORD-DF                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AXZAC

Private cCadastro := "Declaracao ISS"
Private nOpca := 0
Private aParam := {}
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Importa็ใo","u_TelaZAC()",0,2},;
{"Impressao","u_WordISS()",0,4}}

Private cString := "ZAC"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return

User Function TelaZAC

Private dData1 	:= CtoD("//")
Private dData2 	:= CtoD("//")
Private cFor1	:= Space(6)
Private cFor2	:= "ZZZZZZ"//Space(6)

@ 000,000 TO 160,500 DIALOG oDlg TITLE "Importa็ใo Mes"
@ 011,020 Say "Emissao Inicial:"
@ 010,060 Get dData1 SIZE 40,020
@ 011,150 Say "Emissao Final:"
@ 010,190 Get dData2 SIZE 40,020
@ 035,020 Say "Do Fornecedor:"
@ 035,060 Get cFor1	F3 "SA2"
@ 035,150 Say "Ate o Fornecedor:"
@ 035,190 Get cFor2	F3 "SA2"
@ 060,170 BMPBUTTON TYPE 01 ACTION ImportZAC(dData1,dData2,cFor1,cFor2)
@ 060,200 BMPBUTTON TYPE 02 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Return()

Static Function ImportZAC(dData1,dData2,cFor1,cFor2)

Local cQuery 	:= ""
Local cRec	 	:= 0
Local cFornece 	:= ""
Local cPeriodo 	:= ""
Local cFornece 	:= ""
Local cLoja		:= ""
Local cNome		:= ""
Local cEnd		:= ""
Local cBairro	:= ""
Local cMun      := ""
Local cEst		:= ""
Local cCEP		:= ""
Local cInscri	:= ""
Local cCGC		:= ""
Local nValor	:= 0
Local nAliq     := 0
Local nVlISS	:= 0
Local cNotas	:= ""

IF MsgYesNo("O sistema irแ atualizar os registros jแ gravados no periodo informado. Deseja continuar?","Aten็ใo")
	
	cQuery	:= "SELECT SUBSTRING(D1_EMISSAO,1,6) AS PERIODO, D1_FORNECE,D1_LOJA,A2_NOME,A2_END,A2_BAIRRO,A2_MUN,A2_EST,A2_CEP,A2_INSCR,A2_CGC,D1_DOC "
	cQuery	+= ",SUM(D1_TOTAL) AS VALOR,MAX(D1_ALIQISS) AS ALIQ,SUM(D1_VALISS) AS VLISS "
	cQuery	+= "FROM SD1010 "
	cQuery	+= "INNER JOIN SA2010 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA "
	cQuery	+= "WHERE SD1010.D_E_L_E_T_ = '' AND SA2010.D_E_L_E_T_ = '' "
	cQuery	+= "AND D1_EMISSAO BETWEEN '" + DTOS(dData1) + "' AND '" + DTOS(dData2) + "' "
	cQuery	+= "AND D1_FORNECE BETWEEN '"+cFor1+"' AND '"+cFor2+"' "
	cQuery	+= "AND D1_VALISS <> 0 "
	cQuery	+= "GROUP BY SUBSTRING(D1_EMISSAO,1,6), D1_FORNECE,D1_LOJA,A2_NOME,A2_END,A2_BAIRRO,A2_MUN,A2_EST,A2_CEP,A2_INSCR,A2_CGC,D1_DOC "
	cQuery	+= "ORDER BY PERIODO,D1_FORNECE,D1_LOJA,D1_DOC "
	
	tcQuery cQuery New Alias "TMPZAC"
	
	If Eof()
		MsgInfo("Nao existem dados no periodo informado!","Verifique")
		dbSelectArea("TMPZAC")
		dbCloseArea("TMPZAC")
		Return
	Endif
	
	Count To nRec
	
	dbSelectArea("TMPZAC")
	dbGoTop()
	
	ProcRegua(nRec)
	
	While !EOF()
		
		IncProc()
		
		cPeriodo 	:= TMPZAC->PERIODO
		cFornece 	:= ALLTRIM(TMPZAC->D1_FORNECE)
		cLoja		:= TMPZAC->D1_LOJA
		cNome		:= TMPZAC->A2_NOME
		cEnd		:= TMPZAC->A2_END
		cBairro		:= TMPZAC->A2_BAIRRO
		cMun       	:= TMPZAC->A2_MUN
		cEst		:= TMPZAC->A2_EST
		cCEP		:= TMPZAC->A2_CEP
		cInscri		:= TMPZAC->A2_INSCR
		cCGC		:= TMPZAC->A2_CGC
		nValor		+= TMPZAC->VALOR
		nAliq       := TMPZAC->ALIQ
		nVlISS		+= TMPZAC->VLISS
		If EMPTY(cNotas)
			cNotas		:= ALLTRIM(TMPZAC->D1_DOC)
		Else
			cNotas		:= ALLTRIM(cNotas) + ";" + ALLTRIM(TMPZAC->D1_DOC)
		Endif
		
		dbSelectArea("TMPZAC")
		DbSkip()
		
		IF cFornece != ALLTRIM(TMPZAC->D1_FORNECE)
			
			dbSelectArea("ZAC")
			dBSetOrder(1)
			If !dbSeek(xFilial("ZAC") + cPeriodo + cFornece + cLoja)
				Reclock("ZAC",.T.)
				ZAC->ZAC_PERIOD := cPeriodo
				ZAC->ZAC_FORNEC := cFornece
				ZAC->ZAC_LOJA   := cLoja
				ZAC->ZAC_NOME   := cNome
				ZAC->ZAC_END    := cEnd
				ZAC->ZAC_BAIRRO := cBairro
				ZAC->ZAC_MUN    := cMun
				ZAC->ZAC_EST    := cEst
				ZAC->ZAC_CEP    := cCEP
				ZAC->ZAC_INSCRI := cInscri
				ZAC->ZAC_CGC    := cCGC
				ZAC->ZAC_NF     := cNotas
				ZAC->ZAC_VLTOT  := nValor
				ZAC->ZAC_ALIQ   := nAliq
				ZAC->ZAC_VLISS  := nVlISS
				MsUnlock()
			Else    
				Reclock("ZAC",.F.)
				ZAC->ZAC_NOME   := cNome
				ZAC->ZAC_END    := cEnd
				ZAC->ZAC_BAIRRO := cBairro
				ZAC->ZAC_MUN    := cMun
				ZAC->ZAC_EST    := cEst
				ZAC->ZAC_CEP    := cCEP
				ZAC->ZAC_INSCRI := cInscri
				ZAC->ZAC_CGC    := cCGC
				ZAC->ZAC_NF     := cNotas
				ZAC->ZAC_VLTOT  := nValor
				ZAC->ZAC_ALIQ   := nAliq
				ZAC->ZAC_VLISS  := nVlISS
				MsUnlock()
			Endif
			
			nValor		:= 0
			nAliq       := 0
			nVlISS		:= 0
			cNotas		:= ""
			
		EndIf
		
	EndDo
	
EndIF

dbSelectArea("TMPZAC")
dbCloseArea("TMPZAC")

Close(oDlg)

Return()

User Function WordISS()

Local wcPeriodo 	:= ""
Local wcFornece := ""
Local wcLoja	:= ""
Local wcNome	:= ""
Local wcEnd		:= ""
Local wcBairro	:= ""
Local wcCEP		:= ""
Local wcInscri	:= ""
Local wcCGC		:= ""
Local wcValor	:= ""
Local wcAliq    := ""
Local wcVlISS	:= ""
Local wcNotas	:= ""
Local wcData	:= ""
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local nAuxTot	:= 0
Local nK
Local cPathDot	:= ""
Private	hWord

//Close(oDlg)

dbSelectArea("ZAC")
dbSetOrder(1)
dbSeek(xFilial("ZAC") + ZAC->ZAC_PERIOD + ZAC->ZAC_FORNEC + ZAC->ZAC_LOJA)

If !found()
	Alert(" Codigo nใo cadastrado!!")
	Return()
EndIf

wcVlISS			:= Alltrim(Str(ZAC->ZAC_VLISS))+ " (" + Extenso(ZAC->ZAC_VLISS)  +  ")"
wcFornecedor	:= Alltrim(ZAC->ZAC_NOME) + " "
wcEnd			:= Alltrim(ZAC->ZAC_END)
wcBairro		:= Alltrim(ZAC->ZAC_BAIRRO) + " - " + Alltrim(ZAC->ZAC_MUN) + "/" + Alltrim(ZAC->ZAC_EST)   
wcCEP			:= Alltrim(ZAC->ZAC_CEP)
wcInscri		:= ZAC->ZAC_INSCRI 
wcCGC			:= ZAC->ZAC_CGC
wcNotas			:= ZAC->ZAC_NF
wcValor			:= Alltrim(Str(ZAC->ZAC_VLTOT)) + " (" + Extenso(ZAC->ZAC_VLTOT)  +  ")"  
wcAliq    		:= Alltrim(Str(ZAC->ZAC_ALIQ)) 
wcPeriodo 		:= Mes(STOD(ZAC->ZAC_PERIOD + "01"))  + " de " + Alltrim(Str(Ano(STOD(ZAC->ZAC_PERIOD + "01"))))  
IF !EMPTY(ZAC->ZAC_DATA)
wcData			:= ALLTRIM(str(Day(ZAC->ZAC_DATA))) + " de " + Mes(ZAC->ZAC_DATA)  + " de " + Alltrim(Str(Ano(ZAC->ZAC_DATA)))   
ENDIF

cPathDot := "X:\DeclaracaoISS.docx"

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cPathDot)

cPathDot := ""

//Montagem das variaveis do cabecalho    
OLE_SetDocumentVar(hWord, 'VLISS'     ,wcVlISS)
OLE_SetDocumentVar(hWord, 'Fornecedor',wcFornecedor)
OLE_SetDocumentVar(hWord, 'End'       ,wcEnd)
OLE_SetDocumentVar(hWord, 'Bairro'    ,wcBairro) 
OLE_SetDocumentVar(hWord, 'CEP'	      ,Transform(wcCEP,"@R 99999-999"))  
OLE_SetDocumentVar(hWord, 'Inscricao' ,wcInscri) 
OLE_SetDocumentVar(hWord, 'CNPJ'      ,Transform(wcCGC,"@R 99.999.999/9999-99"))  
OLE_SetDocumentVar(hWord, 'Periodo'   ,wcPeriodo) 
OLE_SetDocumentVar(hWord, 'Notas'     ,wcNotas) 
OLE_SetDocumentVar(hWord, 'Valor'     ,wcValor)                                  
OLE_SetDocumentVar(hWord, 'Aliq'      ,wcAliq)
OLE_SetDocumentVar(hWord, 'Data'      ,wcData)  

//Reclock("ZAC",.F.)
//ZAC->ZAC_DATA	:= Date()
//MsUnlock()

dBCloseArea("ZAC")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualizando as variaveis do documento do Word                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

OLE_UpdateFields(hWord)

//If MsgYesNo("Imprime o Documento ?")
//	Ole_PrintFile(hWord,"ALL",,,1)
//EndIf

If MsgYesNo("Fecha o Word e Corta o Link ?")
	OLE_CloseFile(hWord)
	OLE_CloseLink(hWord)
Endif

Return()
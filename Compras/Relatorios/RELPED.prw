#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RELPED	   บ Autor ณ RAFAEL FRANวA      บ Data ณ 29/12/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CONTROLE DE PEDIDOS								          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RECORD                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELPED

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "PEDIDOS POR PERIODO"
Local nLin         	:= 80
Local Cabec1       	:= " Pedido   Tp  Emissao     Fornece Lj  Nome                                 Descri็ใo                                                                                               Situa็ใo    Dt Libera็ใo            Valor"
Local Cabec2       	:= "                                                                           Continua็ใo"
Local imprime      	:= .T.
Local aOrd 			:= {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RELPED"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RELPED1"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELPED"
Private cString 	:= "SC7"

dbSelectArea("SC7")
dbSetOrder(1)

ValidPerg()

Pergunte(cPerg,.T.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aPedidos	:= {}
Local nVlr		:= 0
Local cQuery	:= ""
Local cData		:= ""
Local nData		:= 0
Local nTotal	:= 0
Local lOk		:= .F.
Local cMemo		:= ""
Local nAprov    := 0
Local nBApro	:= 0
Local cAprov	:= ""
Local nDiretor	:= 0

cQuery := " SELECT ED_CONTSIG AS SIG1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
cQuery += " ,'PC' AS TIPO,'PRODUTO' AS PRODUTO,'DESCRICAO' AS DESCRI,0 AS QTD,C7_CONAPRO AS LIBERADO "
cQuery += " ,(SELECT MAX(CR_DATALIB) FROM SCR010 WHERE CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '') AS LIBERACAO "
cQuery += " ,(SELECT MAX(CR_TOTAL) FROM SCR010 WHERE CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '') AS VALLIB "
cQuery += " ,(SELECT MAX(CR_USERLIB) FROM SCR010 WHERE CR_NUM = C7_NUM AND CR_TIPO = 'PC' AND D_E_L_E_T_ = '') AS USERLIB "
cQuery += " ,SUM(C7_TOTAL + C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI) AS VALOR " //AGRUPADO POR PEDIDO
cQuery += " FROM SC7010 "
cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL "
cQuery += " INNER JOIN SED010 ON C1_NATUREZ = ED_CODIGO "
cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 "
cQuery += " AND C7_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += " AND C7_RESIDUO <> 'S' "
cQuery += " AND C7_ENCER = '' "
cQuery += " AND SA2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
cQuery += " GROUP BY ED_CONTSIG,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'PC','','',0,C7_CONAPRO " //AGRUPADO POR PEDIDO
cQuery += " ORDER BY SIG1,TIPO,EMISSAO "

TcQuery cQuery New Alias "TMP1"

dbSelectArea("TMP1")

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
Endif

SetRegua(RecCount())

dbGoTop()
While !EOF()
	
	IF MV_PAR07 == 1
		
		IF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "B"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,"",TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ELSEIF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "L"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ENDIF
		
	ELSEIF MV_PAR07 == 2
		
		IF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "B" .AND. TMP1->USERLIB <> "000192"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,"",TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ELSEIF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "L" .AND. TMP1->USERLIB <> "000192"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ENDIF
		
	ELSEIF MV_PAR07 == 3
		
		IF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "B" .AND. TMP1->USERLIB == "000192"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,"",TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ELSEIF TMP1->TIPO == "PC" .AND. TMP1->LIBERADO == "L" .AND. TMP1->USERLIB == "000192"
			aAdd(aPedidos,{TMP1->SIG1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR,TMP1->NUM,TMP1->VALLIB,TMP1->USERLIB})
		ENDIF
		
	ENDIF
	
	dbSkip()
	
EndDo

dbSelectArea("TMP1")
dbCloseArea("TMP1")

ASORT(aPedidos,,,{|x,y|x[4]+x[1]+x[2] < y[4]+y[1]+y[2]})

For _I := 1 To Len(aPedidos)
	
	IF  	!EMPTY(aPedidos[_I,12])
		cAprov	:= "LIBERADO"
	ELSEIF  EMPTY(aPedidos[_I,12])
		cAprov	:= "BLOQUEADO"
	ENDIF
	
	If cData != aPedidos[_I,4] .AND. lOk
		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
		@nLin,001 PSAY "BLOQUEADO --->"
		@nLin,179 PSAY "BLOQUEADO:"
		@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		@nLin,001 PSAY "APROVADO  --->"
		@nLin,050 PSAY "COM DIRETOR:"
		@nLin,070 PSAY nDiretor PICTURE "@E 999,999,999.99"
		@nLin,110 PSAY "SEM DIRETOR:"
		@nLin,130 PSAY (nAprov - nDiretor) PICTURE "@E 999,999,999.99"
		@nLin,179 PSAY "APROVADO:"
		@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		@nLin,179 PSAY "TOTAL:"
		@nLin,206 PSAY nData PICTURE "@E 999,999,999.99"
		nLin 	+= 2
		nAprov  := 0
		nBApro	:= 0
		nData	:= 0
	Endif
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 65 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If cData	!= aPedidos[_I,4]
		nLin 	+= 1
		@nLin,001 PSAY STOD(aPedidos[_I,4])
		nLin 	+= 1
		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
	Endif
	
	@nLin,001 PSAY ALLTRIM(aPedidos[_I,2])		//PEDIDO
	@nLin,010 PSAY aPedidos[_I,3]				//TIPO
	
	@nLin,014 PSAY STOD(aPedidos[_I,4])			//EMISSAO
	@nLin,026 PSAY aPedidos[_I,5] 				//COD FORNECE
	@nLin,034 PSAY aPedidos[_I,6]  				//LOJA
	@nLin,038 PSAY SUBSTR(aPedidos[_I,7],1,34)  //NOME
	@nLin,179 PSAY cAprov						//LIBERADO
	@nLin,191 PSAY STOD(aPedidos[_I,12]) 		//DT LIBERAวรO
	@nLin,206 PSAY aPedidos[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
	
	dbSelectArea ("SZL")
	dbSetOrder(2)
	IF DbSeek(xFilial("SZL") + aPedidos[_I,2])
		cMemo := MemoLine(ZL_OBS1,100,1)
		@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
		IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,101,100)))
			cMemo := MemoLine(ZL_OBS1,100,2)
			nLin 	+= 1
			@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
			IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,201,100)))
				cMemo := MemoLine(ZL_OBS1,100,3)
				nLin 	+= 1
				@nLin,076 PSAY ALLTRIM(UPPER(cMemo))
			ENDIF
		ENDIF
	ENDIF
	
	lOk 	:= .T.
	cData	:= aPedidos[_I,4]
	
	IF  	!EMPTY(aPedidos[_I,12])
		nAprov  += aPedidos[_I,13] 
			IF aPedidos[_I,16] == "000192"
		nDiretor += aPedidos[_I,13]
	ENDIF
	ELSEIF  EMPTY(aPedidos[_I,12])
		nBApro	+= aPedidos[_I,13]
	ENDIF
	
	nData	+= aPedidos[_I,13]
	nTotal	+= aPedidos[_I,13]
	
	nLin 	+= 1 // Avanca a linha de impressao
	
Next _I

@nLin,001 PSAY REPLICATE("-",LIMITE)
nLin 	+= 1
@nLin,001 PSAY "BLOQUEADO --->"
@nLin,179 PSAY "BLOQUEADO:"
@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
nLin 	+= 1
@nLin,001 PSAY "APROVADO  --->"
@nLin,050 PSAY "COM DIRETOR:"
@nLin,070 PSAY nDiretor PICTURE "@E 999,999,999.99"
@nLin,110 PSAY "SEM DIRETOR:"
@nLin,130 PSAY (nAprov - nDiretor) PICTURE "@E 999,999,999.99"
@nLin,179 PSAY "APROVADO:"
@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
nLin 	+= 1
@nLin,179 PSAY "TOTAL:"
@nLin,206 PSAY nData PICTURE "@E 999,999,999.99"
nLin 	+= 2
nAprov  := 0
nBApro	:= 0
nData	:= 0
nLin 	+= 2
@nLin,001 PSAY "TOTAL GERAL ------>"
@nLin,206 PSAY nTotal PICTURE "@E 999,999,999.99"

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Do Pedido      		","","","mv_ch01","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"02","Ate o Pedido		","","","mv_ch02","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"03","Da Emissใo   		","","","mv_ch03","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Emissใo		","","","mv_ch04","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Fornecedor      	","","","mv_ch05","C",06,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"06","Ate o Fornecedor	","","","mv_ch06","C",06,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"07","Imprime			   	","","","mv_ch07","N",01,00,1,"C","","mv_par07","Todos","","","","","Sem Diretor","","","","","Com Diretor","","","","","","","","","","","","","","" })

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
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELNAT   º Autor ³ RAFAEL FRANÇA      º Data ³  25/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ CONTROLE DE PEDIDOS/AUTORIZAÇOES POR NATUREZA              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELNAT

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "PEDIDOS POR NATUREZA"
Local nLin         	:= 80
Local Cabec1       	:= " Pedido  Tp  Emissao     Fornece Lj  Nome                                 Descrição                                                                                               Situação    Dt Liberação             Valor"
Local Cabec2       	:= "                                                                          Continuação"
Local imprime      	:= .T.
Local aOrd 			:= {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RELNAT"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RELNAT1"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELNAT"
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
Local cNat		:= ""
Local nNat		:= 0
Local nTotal	:= 0
Local lOk		:= .F.
Local cCampo	:= "ED_MES" + MV_PAR03
Local cMemo		:= ""
Local nAprov    := 0
Local nBApro	:= 0
Local cAprov	:= ""
//Local lDiret	:= .F.

If AllTrim(Substring(cUsuario,7,15)) $ "Luciano Ribeiro%Eleni Caldeira (Elenn)%Claudinei Girotti%Bruno$Josiel Ferreira%Wagner Lima%Artur Fernandes Dias Junior%"
	
	MV_PAR04 := SUBSTR(DTOS(dDatabase),1,4)
	MV_PAR03 := SUBSTR(DTOS(dDatabase),5,2)
	MV_PAR01 := ""
	MV_PAR02 := "ZZZZZZZZZZZ"
	MV_PAR07 := ""
	MV_PAR08 := "ZZZZZZZZZZZ"	
	                           
	//lDiret	 := .T.
	cCampo   := "ED_MES" + MV_PAR03
	

	DBSelectArea("SC7")
	DBSetOrder(1)
	If DBSeek(ALLTRIM(xFilial("SCR")) + ALLTRIM(SCR->CR_NUM))
		iF SC7->C7_TIPO == 1
			MV_PAR05 := Posicione("SC1",6,xFilial("SCR") + ALLTRIM(SCR->CR_NUM),"C1_NATUREZ")
			MV_PAR06 := Posicione("SC1",6,xFilial("SCR") + ALLTRIM(SCR->CR_NUM),"C1_NATUREZ")
		Else
			MV_PAR05 := Posicione("SC3",1,xFilial("SCR") + C7_NUMSC + C7_ITEMSC,"C3_NATUREZ")
			MV_PAR06 := Posicione("SC3",1,xFilial("SCR") + C7_NUMSC + C7_ITEMSC,"C3_NATUREZ")
		Endif
		
	EndIf
Endif

IF MV_PAR09 == 5 //MODIFICADO PARA ANULAR O PARAMETRO
	
	cQuery := " SELECT C1_NATUREZ AS NAT1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
	cQuery += " ,''  AS NAT2,''  AS NAT3,''  AS NAT4 "
	cQuery += " ,'PC' AS TIPO,SUM(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR "
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL "
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 " 
	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) >= '201308' "	
//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND C7_NUM NOT IN (SELECT ZL_PEDIDO FROM SZL010 WHERE SZL010.D_E_L_E_T_ = '') "
	cQuery += " AND C1_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY C1_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'','','','PC' "
	cQuery += " UNION "
	cQuery += " SELECT C1_NATUREZ AS NAT1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
	cQuery += " ,ZL_NATUREZ AS NAT2,ZL_NATURE1 AS NAT3,ZL_NATURE2 AS NAT4 "
	cQuery += " ,'PC' AS TIPO,SUM(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR "
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SZL010 ON C7_NUM = ZL_PEDIDO "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL "
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 "
	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) >= '201308' "	
//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND (C1_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' .OR. ZL_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' .OR. ZL_NATURE1 BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' .OR. ZL_NATURE2 BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "') "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY C1_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,ZL_NATUREZ,ZL_NATURE1,ZL_NATURE2,'PC' "
	cQuery += " UNION "
	cQuery += " SELECT ZS_NATUREZ AS NAT1,ZS_CODIGO AS NUM,ZS_EMISSAO AS EMISSAO,ZS_FORNECE AS FORNECE,ZS_LOJA AS LOJA,ZS_NOME AS NOMEFOR "
	cQuery += " ,'' AS NAT2,'' AS NAT3,'' AS NAT4,'AP' AS TIPO,ZS_VALOR AS VALOR "
	cQuery += " FROM SZS010 WHERE SZS010.D_E_L_E_T_ = '' "
	cQuery += " AND SUBSTRING(ZS_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND ZS_TIPO <> '21' "
	cQuery += " AND ZS_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND ZS_CODIGO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND ZS_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " ORDER BY TIPO,EMISSAO "
	
	TcQuery cQuery New Alias "TMP1"
	
	dbSelectArea("TMP1")
	
	SetRegua(RecCount())
	
	dbGoTop()
	While !EOF()
		
		IF EMPTY(TMP1->NAT2)
			
			nVlr	:= TMP1->VALOR
			
			aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			
			dbSkip()
			
		ELSEIF !EMPTY(TMP1->NAT2) .AND. EMPTY(TMP1->NAT3)
			
			nVlr	:= TMP1->VALOR / 2
			
			aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT2,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			
			dbSkip()
			
		ELSEIF !EMPTY(TMP1->NAT2) .AND. !EMPTY(TMP1->NAT3) .AND. EMPTY(TMP1->NAT4)
			
			nVlr	:= TMP1->VALOR / 3
			
			aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT2,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT3,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			
			dbSkip()
			
		ELSEIF !EMPTY(TMP1->NAT2) .AND. !EMPTY(TMP1->NAT3) .AND. !EMPTY(TMP1->NAT4)
			
			nVlr	:= TMP1->VALOR / 4
			
			aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT2,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT3,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			aAdd(aPedidos,{TMP1->NAT4,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,nVlr})
			
			dbSkip()
			
		ENDIF
		
	EndDo
	
ELSE
	
	cQuery := " SELECT C1_NATUREZ AS NAT1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
//	cQuery += " ,'PC' AS TIPO,C7_PRODUTO AS PRODUTO,C7_DESCRI AS DESCRI,C7_QUANT AS QTD,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR "
	cQuery += " ,'PC' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,C7_CONAPRO AS LIBERADO "  
	cQuery += " ,CR_DATALIB AS LIBERACAO "	
	cQuery += " ,SUM(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_VALIPI + C7_ICMSRET) AS VALOR " //AGRUPADO POR PEDIDO
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC1010 ON C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM AND C7_FILIAL = C1_FILIAL " 
	cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER IN ('000192','000157') AND CR_TIPO = 'PC' "	
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 1 "
	cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES		
//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND C1_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND C7_RESIDUO <> 'S' "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' "  
	cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "	
	cQuery += " GROUP BY C1_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'PC','','',0,C7_CONAPRO,CR_DATALIB " //AGRUPADO POR PEDIDO
	cQuery += " UNION "
	cQuery += " SELECT C3_NATUREZ AS NAT1,C7_NUM AS NUM,C7_EMISSAO AS EMISSAO,C7_FORNECE AS FORNECE "
	cQuery += " ,C7_LOJA AS LOJA, SUBSTRING(A2_NOME,1,30) AS NOMEFOR "
	cQuery += " ,'AE' AS TIPO,C7_PRODUTO AS PRODUTO,C3_OBS AS DESCRI,C7_QUANT AS QTD,C7_CONAPRO AS LIBERADO "
	cQuery += " ,CR_DATALIB AS LIBERACAO "	
	cQuery += " ,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE + C7_VALIPI + C7_ICMSRET) AS VALOR "
//	cQuery += " ,'AE' AS TIPO,(C7_TOTAL - C7_DESPESA - C7_VLDESC + C7_VALFRE) AS VALOR " //AGRUPADO POR AP
	cQuery += " FROM SC7010 "
	cQuery += " INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA "
	cQuery += " INNER JOIN SC3010 ON C7_NUMSC = C3_NUM AND C7_ITEMSC = C3_ITEM AND C7_FILIAL = C3_FILIAL " 
	cQuery += " INNER JOIN SCR010 ON C7_NUM = CR_NUM AND CR_USER IN ('000192','000157') AND CR_TIPO = 'AE'  "	
	cQuery += " WHERE SC7010.D_E_L_E_T_ = '' AND C7_TIPO = 2 "
	cQuery += " AND C7_EMISSAO >= '20130726' " // COMEÇARAM AS LIBERAÇÃO PELO SR CARLOS ALVES	
//	cQuery += " AND SUBSTRING(C7_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND C3_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND C7_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND C7_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " AND C7_RESIDUO <> 'S' "
	cQuery += " AND SA2010.D_E_L_E_T_ = '' "
	cQuery += " AND SC3010.D_E_L_E_T_ = '' "  
	cQuery += " AND SCR010.D_E_L_E_T_ = '' AND (CR_DATALIB = '' OR SUBSTRING(CR_DATALIB,1,6) >= '" + MV_PAR04 + MV_PAR03 + "') "		
//	cQuery += " GROUP BY C3_NATUREZ,C7_NUM,C7_EMISSAO,C7_FORNECE,C7_LOJA,A2_NOME,'AE' "//AGRUPADO POR PEDIDO
	cQuery += " UNION "
	cQuery += " SELECT ZS_NATUREZ AS NAT1,ZS_CODIGO AS NUM,ZS_EMISSAO AS EMISSAO,ZS_FORNECE AS FORNECE,ZS_LOJA AS LOJA,ZS_NOME AS NOMEFOR "
//	cQuery += " ,'AP' AS TIPO,'AUTORIZACAO DE PAGAMENTO' AS PRODUTO,'' AS DESCRI,0 AS QTD,ZS_VALOR AS VALOR "
	cQuery += " ,'AP' AS TIPO,'' AS PRODUTO,'' AS DESCRI,0 AS QTD,'L' AS LIBERADO,ZS_DTLIB AS LIBERACAO,ZS_VALOR AS VALOR "	//AGRUPADO POR PEDIDO
	cQuery += " FROM SZS010 WHERE SZS010.D_E_L_E_T_ = '' "
	cQuery += " AND SUBSTRING(ZS_EMISSAO,1,6) = '" + MV_PAR04 + MV_PAR03 + "' "
	cQuery += " AND ZS_TIPO <> '21' " 
	cQuery += " AND ZS_LIBERAD <> 'B' "
	cQuery += " AND ZS_CONTRAT <> '1' "	
	cQuery += " AND ZS_NATUREZ BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " AND ZS_CODIGO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND ZS_FORNECE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery += " ORDER BY NAT1,TIPO,EMISSAO "
	
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
	
	
		
		aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->PRODUTO,TMP1->DESCRI,TMP1->QTD,TMP1->LIBERADO,TMP1->LIBERACAO,TMP1->VALOR})
		//aAdd(aPedidos,{TMP1->NAT1,TMP1->NUM,TMP1->TIPO,TMP1->EMISSAO,TMP1->FORNECE,TMP1->LOJA,TMP1->NOMEFOR,TMP1->VALOR})
		
		dbSkip()
		
	EndDo
	
ENDIF

dbSelectArea("TMP1")
dbCloseArea("TMP1")

ASORT(aPedidos,,,{|x,y|x[1]+x[2] < y[1]+y[2]})

For _I := 1 To Len(aPedidos)
	
	IF  	!EMPTY(aPedidos[_I,12])
		cAprov	:= "LIBERADO"
	ELSEIF  EMPTY(aPedidos[_I,12])
		cAprov	:= "BLOQUEADO"
	ENDIF
	
	If cNat	!= aPedidos[_I,1] .AND. lOk
		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
		@nLin,001 PSAY "BLOQUEADO --->"
		@nLin,178 PSAY "BLOQUEADO:"
		@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		@nLin,001 PSAY "APROVADO  --->"
		@nLin,095 PSAY "SALDO ATUAL:"
		@nLin,125 PSAY (Posicione("SED",1,xFilial("SED")+cNat,@cCampo) - nAprov) PICTURE "@E 999,999,999.99"
		@nLin,178 PSAY "APROVADO:"
		@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		//		@nLin,001 PSAY "TOTAL"
		@nLin,001 PSAY Posicione("SED",1,xFilial("SED")+cNat,"ED_DESCRIC")
		@nLin,050 PSAY "VL. ORÇADO:"
		@nLin,065 PSAY Posicione("SED",1,xFilial("SED")+cNat,@cCampo) PICTURE "@E 999,999,999.99"
		@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
		@nLin,125 PSAY (Posicione("SED",1,xFilial("SED")+cNat,@cCampo) - nNat) PICTURE "@E 999,999,999.99"
		@nLin,178 PSAY "TOTAL:"
		@nLin,206 PSAY nNat PICTURE "@E 999,999,999.99"
		nLin 	+= 2
		nAprov  := 0
		nBApro	:= 0
		nNat	:= 0
	Endif
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 65 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If cNat	!= aPedidos[_I,1]  .AND. !EMPTY(aPedidos[_I,1])
		nLin 	+= 1
		@nLin,001 PSAY aPedidos[_I,1]
		@nLin,011 PSAY Posicione("SED",1,xFilial("SED")+aPedidos[_I,1],"ED_DESCRIC")
		nLin 	+= 1
		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
	ELSEIF EMPTY(aPedidos[_I,1]) .AND. cNat == ""
		nLin 	+= 1
		@nLin,001 PSAY "0000000"
		@nLin,011 PSAY "SEM NATUREZA"
		nLin 	+= 1
		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
	Endif
	
	@nLin,001 PSAY ALLTRIM(aPedidos[_I,2]) 		//PEDIDO
	@nLin,009 PSAY ALLTRIM(aPedidos[_I,3]) 		//TIPO
	@nLin,013 PSAY STOD(aPedidos[_I,4])    		//EMISSAO
	@nLin,025 PSAY ALLTRIM(aPedidos[_I,5]) 		//COD FORNECE
	@nLin,033 PSAY ALLTRIM(aPedidos[_I,6])  	//LOJA
	@nLin,037 PSAY SUBSTR(aPedidos[_I,7],1,34)  //NOME
	@nLin,178 PSAY cAprov						//LIBERADO 
	@nLin,190 PSAY STOD(aPedidos[_I,12]) 		//DT LIBERAÇÃO	
	@nLin,206 PSAY aPedidos[_I,13] PICTURE "@E 999,999,999.99"	//VALOR
	IF aPedidos[_I,3] == "AE"
		//@nLin,075 PSAY ALLTRIM(aPedidos[_I,8])    	//PRODUTO
		@nLin,075 PSAY SUBSTR(aPedidos[_I,9],1,80)  //DESCRI PRODUTO
		//@nLin,137 PSAY aPedidos[_I,10] PICTURE "@E 999"			//QUANTIDADE
	ELSEIF aPedidos[_I,3] == "PC"
		dbSelectArea ("SZL")
		dbSetOrder(2)
		IF DbSeek(xFilial("SZL") + aPedidos[_I,2])
			cMemo := MemoLine(ZL_OBS1,100,1)
			@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
			IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,101,100)))
				cMemo := MemoLine(ZL_OBS1,100,2)
				nLin 	+= 1
				@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
				IF !EMPTY(ALLTRIM(SUBSTR(ZL_OBS1,201,100)))
					cMemo := MemoLine(ZL_OBS1,100,3)
					nLin 	+= 1
					@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
				ENDIF
			ENDIF
		ENDIF
	ELSEIF aPedidos[_I,3] == "AP"
		dbSelectArea ("SZS")
		dbSetOrder(1)
		IF DbSeek(xFilial("SZS") + aPedidos[_I,2])
			cMemo := MemoLine(ZS_HISTORI,100,1)
			@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
			IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,101,100)))
				nLin 	+= 1
				cMemo 	:= MemoLine(ZS_HISTORI,100,2)
				@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
				IF !EMPTY(ALLTRIM(SUBSTR(ZS_HISTORI,201,100)))
					nLin 	+= 1
					cMemo 	:= MemoLine(ZS_HISTORI,100,3)
					@nLin,075 PSAY ALLTRIM(UPPER(cMemo))
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	lOk 	:= .T.
	cNat	:= aPedidos[_I,1]
	IF  	!EMPTY(aPedidos[_I,12])
		nAprov  += aPedidos[_I,13]
	ELSEIF  EMPTY(aPedidos[_I,12])
		nBApro	+= aPedidos[_I,13]
	ENDIF
	nNat	+= aPedidos[_I,13]
	nTotal	+= aPedidos[_I,13]
	
	nLin 	+= 1 // Avanca a linha de impressao
	
Next _I

		@nLin,001 PSAY REPLICATE("-",LIMITE)
		nLin 	+= 1
		@nLin,001 PSAY "BLOQUEADO --->"
		@nLin,178 PSAY "BLOQUEADO:"
		@nLin,206 PSAY nBApro PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		@nLin,001 PSAY "APROVADO  --->"
		@nLin,095 PSAY "SALDO ATUAL:"
		@nLin,125 PSAY (Posicione("SED",1,xFilial("SED")+cNat,@cCampo) - nAprov) PICTURE "@E 999,999,999.99"
		@nLin,178 PSAY "APROVADO:"
		@nLin,206 PSAY nAprov PICTURE "@E 999,999,999.99"
		nLin 	+= 1
		//		@nLin,001 PSAY "TOTAL"
		@nLin,001 PSAY Posicione("SED",1,xFilial("SED")+cNat,"ED_DESCRIC")
		@nLin,050 PSAY "VL. ORÇADO:"
		@nLin,065 PSAY Posicione("SED",1,xFilial("SED")+cNat,@cCampo) PICTURE "@E 999,999,999.99"
		@nLin,095 PSAY "SALDO APÓS APROVAÇÃO:"
		@nLin,125 PSAY (Posicione("SED",1,xFilial("SED")+cNat,@cCampo) - nNat) PICTURE "@E 999,999,999.99"
		@nLin,178 PSAY "TOTAL:"
		@nLin,206 PSAY nNat PICTURE "@E 999,999,999.99"
		nLin 	+= 2
		nAprov  := 0
		nBApro	:= 0
		nNat	:= 0
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

aAdd(aRegs,{cPerg,"01","Do Pedido       	","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"02","Ate o Pedido		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7",""})
aAdd(aRegs,{cPerg,"03","Mes			   		","","","mv_ch3","C",02,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ano					","","","mv_ch4","C",04,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Natureza       	","","","mv_ch5","C",09,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
aAdd(aRegs,{cPerg,"06","Ate a Natureza		","","","mv_ch6","C",09,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
aAdd(aRegs,{cPerg,"07","Do Fornecedor      	","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"08","Ate o Fornecedor	","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"09","Considera Rateios? 	","","","mv_ch9","N",01,00,1,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","" })

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

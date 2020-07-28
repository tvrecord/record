/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GQREENTR   ¦ Autor ¦ Leandro Camara       ¦ Data ¦ 16/11/2006 ¦¦¦
¦¦¦                                  Edmilson Dias Santos   Altera: 24/04/2007
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de gravacao da nota fiscal de entrada        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
	Permite 
	a delecao dos registros inclidos pelo sistema da forma
	original e adiciona 1 unico registro contendo o valor total  da
	N.Fiscal de Entrada para itens com a TES 153 (Imobilizado) para
	Adintamento, para no futuro este transforma-se em um bem defini-
	tivo.
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
*-------------------------------------------------------------------------------------------------------------------------------------------------------------

#include "rwmake.ch"
#include "topconn.ch"

*-------------------------------------------------------------------------------------------------------------------------------------------------------------
User Function GQREENTR()      

	Local aArea		:=	GetArea()
	Local aAreaSE2	:=	GetArea("SE2")
	Local aAreaSD1	:=	GetArea("SD1")
	Local aAreaSN1	:=	GetArea("SN1")
	Local aAreaSN3	:=	GetArea("SN3")

	
	Local _dDatDig, _cCCusto, _cItem, _cClVl, _cTes
	
	PRIVATE aCbase
	Private cHist := Space(100)
	
	AcTitulos()
	
	RestArea(aAreaSE2)
	RestArea(aArea)
	
	@ 200,1 TO 380,380 DIALOG oGrav TITLE OemToAnsi("Gravacao do Histórico")
	@ 02,10 TO 080,190
	@ 10,018 Say "Digite o Histórico a ser registrado no Contas a Pagar. "
	@ 20,018 Get cHist  Valid !Empty(cHist)  Picture "@!"  SIZE 100,75
	@ 70,128 BMPBUTTON TYPE 01 ACTION OkGrav()
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGrav)
	
	Activate Dialog oGrav Centered
	
	RestArea(aAreaSD1)
	RestArea(aAreaSN1)
	RestArea(aAreaSN3)
	RestArea(aAreaSE2)
	RestArea(aArea)

Return
*-------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Manipulacao da Tabela */
Static Function OkGrav

	Local   _nCntFor 	:= 0
	Local   _nQuant  	:= 0
	Local   _nVlrIcm 	:= 0
	lOCAL   _nVlIcmC 	:= 0
	Local   _nVlOrig 	:= 0
	Local   _nUsado  	:= 0
	Local   _nMoeda  	:= IIf(cPaisLoc == "BRA",1,SF1->F1_MOEDA)
	Private _aBase		:= {}     //adicionado isto p/ edmilson
	
	dbSelectArea("SE2")
	dbSetOrder(6)
	
	If dbSeek(XFILIAL("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC))
	
		While !EOF() .and. SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXOE+E2_NUM) = SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
			RecLock("SE2",.F.)
			SE2->E2_HIST   := Alltrim(cHist)
			MsUnLock()
			dbSkip()
		enddo  

	//Rafael França - 06/09/18 - Controladoria / Anderson -Altera o historico de acordo com o imposto
	Processa({|| TcSqlExec("UPDATE SE2010 SET E2_HIST = 'IRRF DO FORNECEDOR "+ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"),1,30))+", REF. NF: "+SF1->F1_DOC+"' WHERE D_E_L_E_T_ = '' AND E2_NUM = '"+SF1->F1_DOC+"' AND E2_PREFIXO = '"+SF1->F1_SERIE+"' AND E2_FILIAL = '"+XFILIAL("SE2")+"' AND E2_TIPO = 'TX'  AND E2_EMIS1 = '"+DTOS(dDataBase)+"' AND E2_FORNECE = '000054' AND E2_NATUREZ = '1203010'")},"Atualizando historico IRRF")			
	Processa({|| TcSqlExec("UPDATE SE2010 SET E2_HIST = 'ISS  DO FORNECEDOR "+ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"),1,30))+", REF. NF: "+SF1->F1_DOC+"' WHERE D_E_L_E_T_ = '' AND E2_NUM = '"+SF1->F1_DOC+"' AND E2_PREFIXO = '"+SF1->F1_SERIE+"' AND E2_FILIAL = '"+XFILIAL("SE2")+"' AND E2_TIPO = 'ISS' AND E2_EMIS1 = '"+DTOS(dDataBase)+"' AND E2_FORNECE = '000053' AND E2_NATUREZ = '1203018'")},"Atualizando historico ISS ")
	Processa({|| TcSqlExec("UPDATE SE2010 SET E2_HIST = 'INSS DO FORNECEDOR "+ALLTRIM(SUBSTR(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"),1,30))+", REF. NF: "+SF1->F1_DOC+"' WHERE D_E_L_E_T_ = '' AND E2_NUM = '"+SF1->F1_DOC+"' AND E2_PREFIXO = '"+SF1->F1_SERIE+"' AND E2_FILIAL = '"+XFILIAL("SE2")+"' AND E2_TIPO = 'INS' AND E2_EMIS1 = '"+DTOS(dDataBase)+"' AND E2_FORNECE = '000055' AND E2_NATUREZ = '1203021'")},"Atualizando historico INSS")		
	
	Endif
	
	DBSELECTAREA("SD1")
	DBSETORDER(1)
	SD1->(DBSEEK(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
	
	WHILE !EOF() .AND. SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		
		IF ! ( SD1->D1_TES $ "153" )
			DBSKIP()
			LOOP
		ENDIF
		
		IF ASCAN(_aBase, SD1->D1_CBASEAF) == 0
			AADD(_aBase, SD1->D1_CBASEAF)
		ENDIF
		 
		_nQuant 	+= SD1->D1_QUANT
		_nVlrIcm	+= SD1->D1_VALICM
		_nVlOrig	+= SD1->D1_TOTAL  
		_nVlIcmC	+= SD1->D1_ICMSCOM
		
		_dDatDig	:= SD1->D1_DTDIGIT
		_cCCusto	:= SD1->D1_CC
		_cItem  	:= SD1->D1_ITEMCTA
		_cClVl  	:= SD1->D1_CLVL
		_cTes   	:=	SD1->D1_TES
		
		SD1->(DBSKIP())
		
	ENDDO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenchimento das Variaveis referentes ao SN1 e SN3                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IF LEN( _aBase ) > 0
		
		sDeleta()   //APAGA PRIMEIRO OS REGISTROS SN1 E SN3
		
		DBSELECTAREA("SN1")
		RECLOCK("SN1",.T.)
			N1_FILIAL   := SF1->F1_FILIAL
			N1_CBASE		:= "NFE"+SF1->F1_DOC
			N1_ITEM		:= "0001" //cItem
			N1_AQUISIC	:= _dDatDig
			N1_DESCRIC	:= "IMOB. EM ANDAMENTO S/NF "+SF1->F1_DOC+" - "+SF1->F1_SERIE
			N1_QUANTD	:= 1 //_nQuant
			N1_FORNEC	:= SF1->F1_FORNECE
			N1_LOJA		:= SF1->F1_LOJA
			N1_NSERIE	:= SF1->F1_SERIE
			N1_INCLUSA  := "1"
			N1_NFISCAL	:= SF1->F1_DOC
			N1_CHASSIS	:= " "//SF1->F1_CHASSI
			N1_PLACA		:= " "//SD1->D1_PLACA
			N1_PATRIM	:= "N"
			N1_CODCIAP	:= " " //cCodCiap
			N1_ICMSAPR	:= _nVlrIcm
		SN1->(MsUnLock())
		
		DBSELECTAREA("SN3")
		RECLOCK("SN3",.T.)
			N3_FILIAL  := SF1->F1_FILIAL
			N3_CBASE   := "NFE"+SF1->F1_DOC
			N3_ITEM    := "0001"
			N3_TIPO    := "03"   //Inclue logo como tipo == "03" - Adiantamento
			N3_BAIXA   := "0"
			N3_CCONTAB := ""
			N3_CCUSTO  := ""
			N3_SUBCCON := ""
			N3_CLVLCON := ""               
			
			N3_AQUISIC := SN1->N1_AQUISIC  // Data de aquisicao
			N3_VORIG1  := xMoeda( _nVlOrig,_nMoeda,1,SF1->F1_EMISSAO)
			N3_VORIG2  := xMoeda( _nVlOrig,_nMoeda,2,SF1->F1_EMISSAO)
			N3_VORIG3  := xMoeda( _nVlOrig,_nMoeda,3,SF1->F1_EMISSAO)
			N3_VORIG4  := xMoeda( _nVlOrig,_nMoeda,4,SF1->F1_EMISSAO)
			N3_VORIG5  := xMoeda( _nVlOrig,_nMoeda,5,SF1->F1_EMISSAO)	
		SN3->(MsUnLock())	
		
	ENDIF
	
	RecLock("SF1",.F.)
		SF1->F1_ICMSCOM   := _nVlIcmC
	MsUnLock()
	
	Close(oGrav)

RETURN NIL
*-------------------------------------------------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION sDeleta()

	Local cQuery
	Local cQuery1
	Local Ky, Kx
	
	For kX := 1 to Len(_aBase)	
	
		DBSELECTAREA("SN1")
		DBSETORDER(1)
		SN1->(DBSEEK(xFilial("SN1")+_aBase[kx],.T.))
		RecLock("SN1",.f.,.t.)
			SN1->(dbdelete())
		MsUnlock("SN1")	
		
	Next Kx
	
	For ky := 1 to Len(_aBase)	
	
		DBSELECTAREA("SN3")
		DBSETORDER(1)
		SN3->(DBSEEK(xFilial("SN3")+_aBase[ky],.T.))
		RecLock("SN3",.f.,.t.)
			SN3->(dbdelete())
		MsUnlock("SN3")
		
	Next ky

Return
*-------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AcTitulos()

	Local cQuery
	
	cQuery 	:= " SELECT R_E_C_N_O_ RECNOSE2 "
	cQuery	+=	" FROM " + RetSqlName("SE2") 
	cQuery	+=	" WHERE E2_NATUREZ LIKE '" + '"%' + "' AND D_E_L_E_T_ = ' ' "
	
	TcQuery cQuery New Alias "QRY"
	
	Do While QRY->(!Eof())
	
		SE2->(dbgoto(QRY->RECNOSE2))
		if	'"' $ SE2->E2_NATUREZ
			RecLock("SE2",.f.)
				SE2->E2_NATUREZ	:=	StrTran(SE2->E2_NATUREZ,'"',"")
			MsUnlock("SE2")
		endif
		QRY->(dbskip())
		
	EndDo
	
	QRY->(dbclosearea())
	
	cQuery 	:= " SELECT R_E_C_N_O_ RECNOSE5 "
	cQuery	+=	" FROM " + RetSqlName("SE5") 
	cQuery	+=	" WHERE E5_NATUREZ LIKE '" + '"%' + "' AND D_E_L_E_T_ = ' ' "
	
	TcQuery cQuery New Alias "QRY"
	
	Do While QRY->(!Eof())
	
		SE5->(dbgoto(QRY->RECNOSE5))
		if	'"' $ SE5->E5_NATUREZ
			RecLock("SE5",.f.)
				SE5->E5_NATUREZ	:=	StrTran(SE5->E5_NATUREZ,'"',"")
			MsUnlock("SE5")
		endif
		QRY->(dbskip())
		
	EndDo
	
	QRY->(dbclosearea())

Return
*-------------------------------------------------------------------------------------------------------------------------------------------------------------
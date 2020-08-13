#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    14/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FLUXO REALIZADO 						                        ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function REALIZADO()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := ""
Private cPict          := ""
Private nLin           := 100

Private Cabec1         := ""
Private Cabec2         := ""
Private Cabec3         := ""
Private imprime        := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "REALIZADO" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "REALIZADO" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "REALIZADO2"
Private cString      := "SE5"
Private cQuery       := ""
Private cfiltro      := ""
Private titulo       := "Fluxo Realizado"
Private aTitulos 	 := {}
Private _aIExcel 	 := {}
Private cNatGer 	 := ""
Private nSubTotal  	 := 0
Private nTotal 		 := 0
Private nTotalDesp	 := 0
Private cHist		 := ""
Private lOk          := .T.

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando Relatório")

Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Relatorio()

cQuery := "SELECT E5_FILIAL,E5_DATA,E5_NATUREZ,ED_DESCRIC,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_FILIAL, "
cQuery += "E5_PREFIXO,E5_NUMERO,E5_TIPO,E5_PARCELA,E5_RECPAG,E5_CLIFOR,E5_LOJA,E5_HISTOR,ED_NATGER, "
cQuery += "E5_VALOR,E5_SEQ "
cQuery += "FROM SE5010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
cQuery += "AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E5_FILIAL = '01' "
cQuery += "AND E5_DATA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "

IF MV_PAR02 == 1  //PAGAR
	cQuery += "AND E5_RECPAG = 'P' "
ELSEIF MV_PAR02 == 2 //RECEBER
	cQuery += "AND E5_RECPAG = 'R' "
ENDIF

cQuery += "AND E5_NATUREZ <> '1503001' "

IF !EMPTY(MV_PAR13) //Filtra Bancos
	cQuery += "AND E5_BANCO IN " + FormatIn(MV_PAR13,";") + " "
ENDIF

IF !EMPTY(MV_PAR14) //Filtra Agencia
	cQuery += "AND E5_AGENCIA IN " + FormatIn(MV_PAR14,";") + " "
ENDIF

IF !EMPTY(MV_PAR15) //Filtra Conta
	cQuery += "AND E5_CONTA IN " + FormatIn(MV_PAR15,";") + " "
ENDIF
cQuery += "AND E5_TIPODOC <> 'CH' "
cQuery += "AND E5_SITUACA <> 'C' AND E5_TIPO <> 'DC' " 
cQuery += "AND E5_RECONC = 'x' "
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR16+"' AND '"+MV_PAR17+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "ORDER BY ED_NATGER,E5_DATA,E5_NATUREZ "

tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

IF MV_PAR02 == 1
	
	cQuery := "SELECT E5_DATA,E5_NUMCHEQ,E5_NATUREZ,ED_DESCRIC,ED_NATGER,E5_BANCO,E5_AGENCIA,E5_CONTA,SUM(E5_VALOR) AS VALOR "
	cQuery += "FROM SE5010 "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "E5_NATUREZ = ED_CODIGO "
	cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
	cQuery += "AND SED010.D_E_L_E_T_ = ''  "
	cQuery += "AND E5_TIPODOC = 'BA' "
	cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR16+"' AND '"+MV_PAR17+"' "
	cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "AND E5_DATA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
	cQuery += "AND E5_NUMCHEQ <> '' "  
	cQuery += "AND E5_FILIAL = '01' "	
	cQuery += "GROUP BY E5_DATA,E5_NUMCHEQ,E5_NATUREZ,ED_DESCRIC,ED_NATGER,E5_BANCO,E5_AGENCIA,E5_CONTA "
	cQuery += "ORDER BY ED_NATGER,E5_DATA,E5_NATUREZ "
	
	tcQuery cQuery New Alias "TMP2"
	
	If Eof()
		//MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP2")
		dbCloseArea("TMP2") 
		lOk  := .F.
		//Return
	Endif
	
ENDIF

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// **************************** Cria Arquivo Temporario
_aCExcel:={}//SPCSQL->(DbStruct())
aadd( _aCExcel , {"EMISSAO"      	, "D" , 010 , 00 } ) //01
aadd( _aCExcel , {"DOC	"			, "C" , 010 , 00 } ) //02
aadd( _aCExcel , {"VENCTO"		    , "D" , 010 , 00 } ) //03
aadd( _aCExcel , {"VENCREAL"		, "D" , 010 , 00 } ) //04
aadd( _aCExcel , {"DTBAIXA"			, "D" , 010 , 00 } ) //05
aadd( _aCExcel , {"FORNECEDOR"		, "C" , 050 , 00 } ) //06
aadd( _aCExcel , {"HISTORICO"		, "C" , 100 , 00 } ) //07
aadd( _aCExcel , {"VALOR"			, "N" , 014 , 02 } ) //08
aadd( _aCExcel , {"NATUREZA"		, "C" , 010 , 00 } ) //09
aadd( _aCExcel , {"DESCRINAT"		, "C" , 010 , 00 } ) //10
aadd( _aCExcel , {"NATGER"	   		, "C" , 010 , 00 } ) //11

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"CTREECDX",_cTemp,"TMP1",.F.,.F.)

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())
	
	IF MV_PAR02 == 1  //PAGAR
		                                       
		cHist := Posicione("SE2",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E2_HIST")
				
		If TemBxCanc(TMP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .AND. ALLTRIM(TMP->E5_NATUREZ) <> "1205005"
			TMP->(dbSkip())
			Loop
		EndIf		
		
		IF ALLTRIM(TMP->E5_NATUREZ) == "1205005"
			aAdd(aTitulos,{STOD(TMP->E5_DATA),;
			TMP->E5_NUMERO,; 
			STOD(TMP->E5_DATA),;			
			STOD(TMP->E5_DATA),;
			STOD(TMP->E5_DATA),;
			Posicione("SA6",1,xFilial("SA6")+TMP->E5_BANCO+TMP->E5_AGENCIA+TMP->E5_CONTA,"A6_NOME"),;
			IIF(EMPTY(TMP->E5_HISTOR),TMP->ED_DESCRIC,FwNoAccent(UPPER(TMP->E5_HISTOR))),;
			TMP->E5_VALOR,;
			TMP->E5_NATUREZ,;
			TMP->ED_DESCRIC,;
			TMP->ED_NATGER})
		ELSE
			aAdd(aTitulos,{Posicione("SE2",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E2_EMISSAO"),;
			TMP->E5_NUMERO,; 
			Posicione("SE2",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E2_VENCTO"),;			
			Posicione("SE2",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E2_VENCREA"),;
			STOD(TMP->E5_DATA),;
			Posicione("SA2",1,xFilial("SA2")+TMP->E5_CLIFOR+TMP->E5_LOJA,"A2_NOME"),;
			IIF(EMPTY(cHist),TMP->ED_DESCRIC,FwNoAccent(UPPER(cHist))),;
			TMP->E5_VALOR,;
			TMP->E5_NATUREZ,;
			TMP->ED_DESCRIC,;
			TMP->ED_NATGER})
		ENDIF
		
	ELSEIF MV_PAR02 == 2  //RECEBER
		
		aAdd(aTitulos,{Posicione("SE1",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E1_EMISSAO"),;
		TMP->E5_NUMERO,; 
		Posicione("SE1",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E1_VENCTO"),;
		Posicione("SE1",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E1_VENCREA"),;
		STOD(TMP->E5_DATA),;
		Posicione("SA1",1,xFilial("SA1")+TMP->E5_CLIFOR+TMP->E5_LOJA,"A1_NOME"),;
		Posicione("SE1",1,TMP->E5_FILIAL+TMP->E5_PREFIXO+TMP->E5_NUMERO+TMP->E5_PARCELA+TMP->E5_TIPO+TMP->E5_CLIFOR+TMP->E5_LOJA,"E1_HIST"),;
		TMP->E5_VALOR,;
		TMP->E5_NATUREZ,;
		TMP->ED_DESCRIC,;
		TMP->ED_NATGER})
		
	ENDIF
	
	DBSelectArea("TMP")
	DBSkip()
	
Enddo

IF MV_PAR02 == 1 .AND. lOk //PAGAR
	
	//Grava cheques no vetor
	
	DBSelectArea("TMP2")
	DBGotop()
	
	While !TMP2->(EOF())
		
		aAdd(aTitulos,{STOD(TMP2->E5_DATA),;
		TMP2->E5_NUMCHEQ,; 
		STOD(TMP2->E5_DATA),;		
		STOD(TMP2->E5_DATA),;
		STOD(TMP2->E5_DATA),;
		Posicione("SEF",1,xFilial("SEF")+TMP2->E5_BANCO+TMP2->E5_AGENCIA+TMP2->E5_CONTA+TMP2->E5_NUMCHEQ,"EF_BENEF"),;
		Posicione("SEF",1,xFilial("SEF")+TMP2->E5_BANCO+TMP2->E5_AGENCIA+TMP2->E5_CONTA+TMP2->E5_NUMCHEQ,"EF_HIST"),;
		TMP2->VALOR,;
		TMP2->E5_NATUREZ,;
		TMP2->ED_DESCRIC,;
		TMP2->ED_NATGER})
		
		DBSelectArea("TMP2")
		DBSkip()
		
	Enddo
	
ENDIF

//Ordena todas as informações por Natureza GErencial + Data de Vencimento
ASORT(aTitulos,,,{|x,y|x[11]+DTOS(x[5]) < y[11]+DTOS(y[5])})

For i:=1 to Len(aTitulos)
	
	If i == 1
		cNatGer := aTitulos[i][11]
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[06]	:= Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][11],"X5_DESCRI")
		AADD(_aIExcel,_aItem)
		_aItem := {}
	EndIf
	
	If cNatGer != aTitulos[i][11]
		
		//SubTotal
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[08] 		:= nSubTotal
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		// Pula Linha
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		//Cabeçalho
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[06]	:= Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][11],"X5_DESCRI")
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		nSubTotal := 0
		
	EndIf
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[01]		:= aTitulos[i][1]
	_aItem[02]		:= aTitulos[i][2]
	_aItem[03]		:= aTitulos[i][3]
	_aItem[04]		:= aTitulos[i][4]
	_aItem[05]		:= aTitulos[i][5]
	_aItem[06]		:= aTitulos[i][6]
	_aItem[07]		:= aTitulos[i][7]
	_aItem[08] 		:= aTitulos[i][8]
	_aItem[09]		:= aTitulos[i][9]
	_aItem[10]		:= aTitulos[i][10]
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	IF aTitulos[i][11] <> "0009"
		nTotalDesp 		+= aTitulos[i][8]
	ENDIF
	
	nSubTotal 	+= aTitulos[i][8]
	nTotal 		+= aTitulos[i][8]
	cNatGer 	:= aTitulos[i][11]
	
Next

// Subtotal do ultimo registro que não será impresso no FOR
_aItem := ARRAY(LEN(_aCExcel) + 1)
_aItem[08] 		:= nSubTotal
AADD(_aIExcel,_aItem)
_aItem := {}

// Pula Linha
_aItem := ARRAY(LEN(_aCExcel) + 1)
AADD(_aIExcel,_aItem)
_aItem := {}

// Total
IF MV_PAR02 == 1 //PAGAR
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[06]		:= UPPER("Total Despesas:")
	_aItem[08] 		:= nTotalDesp
	AADD(_aIExcel,_aItem)
	_aItem := {}
ELSEIF MV_PAR02 == 2 //RECEBER
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[06]		:= UPPER("Total Receitas:")
	_aItem[08] 		:= nTotalDesp
	AADD(_aIExcel,_aItem)
	_aItem := {}
ENDIF

// Total
//_aItem := ARRAY(LEN(_aCExcel) + 1)
//_aItem[06]		:= UPPER("Total com Transferencias:")
//_aItem[08] 		:= nTotal
//AADD(_aIExcel,_aItem)
//_aItem := {}

//If !ApOleClient("MsExcel")
//MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
//DBSelectArea("TMP")
//DBCloseARea("TMP")
//Return
//EndIf

//cArq     := _cTemp+".DTC"


	DBSelectArea("TMP")
	DBCloseARea("TMP")

IF MV_PAR02 == 1 .AND. lOk //PAGAR
	DBSelectArea("TMP2")
	DBCloseARea("TMP2")
ENDIF

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)


IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Realizado Pagar - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","REALIZADO")
	_lRet := .F.
ENDIF

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Modelo      	 	","","","mv_ch01","N",01,0,2,"C","","mv_par01","Napoli","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Carteira     		","","","mv_ch02","N",01,0,2,"C","","mv_par02","Pagar","","","","","Receber","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Natureza  	  	","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"04","Ate Natureza      	","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"05","Do Vencimento 	  	","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Vencimento 	  	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da Data     	  	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Data       	  	","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Cli/For 	  		","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"10","Ate Cli/For    		","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"11","Do Titulo  	  		","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Titulo      	","","","mv_ch12","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Filtra Bancos		","","","mv_ch13","C",20,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Filtra Agencia		","","","mv_ch14","C",20,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Filtra Contas		","","","mv_ch15","C",20,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Do Bloco   		  	","","","mv_ch16","C",04,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
AADD(aRegs,{cPerg,"17","Ate Bloco	      	","","","mv_ch17","C",04,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})

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
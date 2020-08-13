#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    23/04/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ SIG EXCEL 						                           ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SIGEXCEL()

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
Private nomeprog     := "SIGEXCEL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "SIGEXCEL" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "SIGEXCEL2"
Private cString      := "SZR"
Private cQuery       := ""
Private cFilQry   	 := ""
Private titulo       := "SIG EXCEL"
Private aRegistro 	 := {}
Private nPos		 := 0
Private nCol		 := 0
Private cSigGer 	 := ""
Private nSubTot		 := 0
Private nSubJan		:= 0
Private nSubFev		:= 0
Private nSubMar		:= 0
Private nSubAbr		:= 0
Private nSubMai		:= 0
Private nSubJun		:= 0
Private nSubJul		:= 0
Private nSubAgo		:= 0
Private nSubSet		:= 0
Private nSubOut		:= 0
Private nSubNov		:= 0
Private nSubDez		:= 0
Private nTotal 		 := 0
Private nSubTotal	 := 0
Private nNum		 := 0
Private _aIExcel 	 := {}

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


Static Function Relatorio()

//Grava o filtro para repetir na query

cFilQry  := "FROM SZR010 " 
cFilQry  += "INNER JOIN CTT010 ON ZR_CC = CTT_CUSTO AND CTT010.D_E_L_E_T_ = '' "
cFilQry  += "WHERE SZR010.D_E_L_E_T_ = '' "
cFilQry  += "AND ZR_CTASIG BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"' "
cFilQry  += "AND ZR_CC BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"' "
cFilQry  += "AND ZR_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cFilQry  += "AND ZR_TIPO IN ('C','D') "
IF 	   MV_PAR01 == 1
	cFilQry  += "AND ZR_TIPO = 'D' "
ELSEIF MV_PAR01 == 2                                  
	cFilQry  += "AND ZR_TIPO = 'C' "
ENDIF     

IF MV_PAR10 == 1
	cFilQry  += "AND CTT_GRPGER = '1' "
ELSEIF MV_PAR10 == 2
	cFilQry  += "AND CTT_GRPGER = '2' "
ELSEIF MV_PAR10 == 3
	cFilQry  += "AND CTT_GRPGER = '3' "
ELSEIF MV_PAR10 == 4
	cFilQry  += "AND CTT_GRPGER = '4' "  
ELSEIF MV_PAR11 == 1 .AND. MV_PAR10 == 5 
	cFilQry  += "AND CTT_GRPGER = '5' "	
ELSEIF MV_PAR11 == 2 .AND. MV_PAR10 == 5 
	cFilQry  += "AND CTT_GRPGER = '6' "	
END

IF MV_PAR02 == 1
	
	//TMP2 ->VERIFICA OS VALORES DE CADA CONTA
	
	cQuery := "SELECT ZR_CTASIG,ZR_CODIGO,SUM(ZR_VALOR) AS VALOR "
	cQuery += cFilQry
	cQuery += "GROUP BY ZR_CTASIG,ZR_CODIGO "
	cQuery += "ORDER BY ZR_CTASIG,ZR_CODIGO "
	
	tcQuery cQuery New Alias "TMP2"
	
	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP2")
		dbCloseArea("TMP2")
		Return
	Endif
	
	//TMP3 ->VERIFICA AS CONTAS SIG
	
	cQuery := "SELECT ZR_CTASIG, "
	cQuery += "(SELECT X5_DESCRI FROM SX5010 WHERE SX5010.D_E_L_E_T_ = '' AND X5_CHAVE = ZR_CTASIG AND X5_TABELA = 'Z8') AS DESCRICAO "
	cQuery += cFilQry
	cQuery += "GROUP BY ZR_CTASIG "
	cQuery += "ORDER BY ZR_CTASIG "
	
	tcQuery cQuery New Alias "TMP3"
	
ELSE
	
	
	//TMP2 ->VERIFICA OS VALORES DE CADA CONTA
	
	cQuery := "SELECT ZR_CC,ZR_CTASIG,ZR_CODIGO,SUM(ZR_VALOR) AS VALOR "
	cQuery += cFilQry
	cQuery += "GROUP BY ZR_CC,ZR_CTASIG,ZR_CODIGO "
	cQuery += "ORDER BY ZR_CC,ZR_CTASIG,ZR_CODIGO "
	
	tcQuery cQuery New Alias "TMP2"
	
	If Eof()
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP2")
		dbCloseArea("TMP2")
		Return
	Endif
	
	//TMP3 ->VERIFICA AS CONTAS SIG
	
	cQuery := "SELECT ZR_CC,ZR_CTASIG, "
	cQuery += "(SELECT X5_DESCRI FROM SX5010 WHERE SX5010.D_E_L_E_T_ = '' AND X5_CHAVE = ZR_CTASIG AND X5_TABELA = 'Z8') AS DESCRICAO "
	cQuery += cFilQry
	cQuery += "GROUP BY ZR_CC,ZR_CTASIG "
	cQuery += "ORDER BY ZR_CC,ZR_CTASIG "
	
	tcQuery cQuery New Alias "TMP3"
	
ENDIF

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_aCExcel:={}
aadd( _aCExcel , {"CONTASIG"      	, "C" , 010 , 00 } ) //01
aadd( _aCExcel , {"DESCRICAO"		, "C" , 030 , 00 } ) //02
aadd( _aCExcel , {"JANEIRO"		    , "N" , 014 , 02 } ) //03
aadd( _aCExcel , {"FEVEREIRO"	    , "N" , 014 , 02 } ) //04
aadd( _aCExcel , {"MARCO"		    , "N" , 014 , 02 } ) //05
aadd( _aCExcel , {"ABRIL"		    , "N" , 014 , 02 } ) //06
aadd( _aCExcel , {"MAIO" 		    , "N" , 014 , 02 } ) //07
aadd( _aCExcel , {"JUNHO"		    , "N" , 014 , 02 } ) //08
aadd( _aCExcel , {"JULHO"		    , "N" , 014 , 02 } ) //09
aadd( _aCExcel , {"AGOSTO"		    , "N" , 014 , 02 } ) //10
aadd( _aCExcel , {"SETEMBRO"	    , "N" , 014 , 02 } ) //11
aadd( _aCExcel , {"OUTUBRO"		    , "N" , 014 , 02 } ) //12
aadd( _aCExcel , {"NOVEMBRO"	    , "N" , 014 , 02 } ) //13
aadd( _aCExcel , {"DEZEMBRO"	    , "N" , 014 , 02 } ) //14
aadd( _aCExcel , {"TOTAL"		    , "N" , 016 , 02 } ) //15

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DBSelectArea("TMP3")
DBGotop()

While !TMP3->(EOF())
	
	aAdd(aRegistro,{TMP3->ZR_CTASIG,TMP3->DESCRICAO,0,0,0,0,0,0,0,0,0,0,0,0,0})
	
	nNum += 1
	
	DBSelectArea("TMP3")
	DBSkip()
	
Enddo

aAdd(aRegistro,{"TOTAL","---------->",0,0,0,0,0,0,0,0,0,0,0,0,0})
nNum += 1

dbSelectArea("TMP3")
dbCloseArea("TMP3")

DBSelectArea("TMP2")  //Grava os valores de cada mes
DBGotop()

While !TMP2->(EOF())
	
	nPos := aScan(aRegistro, { |x| x[1] == TMP2->ZR_CTASIG })
	nCol := (VAL(SUBSTR(TMP2->ZR_CODIGO,5,2)) + 2)
	
	IF SUBSTR(TMP2->ZR_CTASIG,1,2) == "15" // CONTAS FISCAIS DIMINUEM AS DESPESAS
	aRegistro[nPos][nCol] 	:= TMP2->VALOR
	aRegistro[nPos][15]   	-= TMP2->VALOR 	
	ELSE
	aRegistro[nPos][nCol] 	:= TMP2->VALOR
	aRegistro[nPos][15]   	+= TMP2->VALOR    
	ENDIF
	
	IF ALLTRIM(TMP2->ZR_CTASIG) <> "01078" .AND. ALLTRIM(TMP2->ZR_CTASIG) <> "01079"  
	IF SUBSTR(TMP2->ZR_CTASIG,1,2) == "15" // CONTAS FISCAIS DIMINUEM AS DESPESAS
		aRegistro[nNum][nCol] 	-= TMP2->VALOR
		aRegistro[nNum][15] 	-= TMP2->VALOR
		nTotal	     			-= TMP2->VALOR 	
	ELSE
		aRegistro[nNum][nCol] 	+= TMP2->VALOR
		aRegistro[nNum][15] 	+= TMP2->VALOR
		nTotal	     			+= TMP2->VALOR 
	ENDIF
		
	ENDIF
	
	DBSelectArea("TMP2")
	DBSkip()
	
Enddo

dbSelectArea("TMP2")
dbCloseArea("TMP2")


//Ordena todas as informações por Natureza GErencial + Data de Vencimento
ASORT(aRegistro,,,{|x,y|x[01] < y[01]})

For i:=1 to Len(aRegistro)
	
	If i == 1
		cSigGer := SUBSTR(aRegistro[i][01],1,2)
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= SUBSTR(aRegistro[i][01],1,2)
		_aItem[02]		:= Posicione("SX5",1,xFilial("SX5") + "ZA" + SUBSTR(aRegistro[i][01],1,2),"X5_DESCRI")
		AADD(_aIExcel,_aItem)
		_aItem := {}
	EndIf
	
	If cSigGer != SUBSTR(aRegistro[i][01],1,2)
		
		//SubTotal
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01]		:= "SUBTOTAL"
		_aItem[02]		:= Posicione("SX5",1,xFilial("SX5") + "ZA" + cSigGer,"X5_DESCRI")
		_aItem[03]		:= nSubJan
		_aItem[04]		:= nSubFev
		_aItem[05]		:= nSubMar
		_aItem[06]		:= nSubAbr
		_aItem[07]		:= nSubMai
		_aItem[08]		:= nSubJun
		_aItem[09]		:= nSubJul
		_aItem[10]		:= nSubAgo
		_aItem[11]		:= nSubSet
		_aItem[12]		:= nSubOut
		_aItem[13] 		:= nSubNov
		_aItem[14]		:= nSubDez
		_aItem[15]		:= nSubTotal
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		// Pula Linha
		_aItem := ARRAY(LEN(_aCExcel) + 1)
		AADD(_aIExcel,_aItem)
		_aItem := {}
		
		//Cabeçalho
		IF SUBSTR(aRegistro[i][01],1,2) <> "TO"
			
			_aItem := ARRAY(LEN(_aCExcel) + 1)
			_aItem[01]		:= SUBSTR(aRegistro[i][01],1,2)
			_aItem[02]		:= Posicione("SX5",1,xFilial("SX5") + "ZA" + SUBSTR(aRegistro[i][01],1,2),"X5_DESCRI")
			AADD(_aIExcel,_aItem)
		_aItem := {}
			
		ENDIF
		
		nSubJan		:= 0
		nSubFev		:= 0
		nSubMar		:= 0
		nSubAbr		:= 0
		nSubMai		:= 0
		nSubJun		:= 0
		nSubJul		:= 0
		nSubAgo		:= 0
		nSubSet		:= 0
		nSubOut		:= 0
		nSubNov		:= 0
		nSubDez		:= 0
		nSubTotal 	:= 0
		
	EndIf
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[01]		:= aRegistro[i][1]
	_aItem[02]		:= aRegistro[i][2]
	_aItem[03]		:= aRegistro[i][3]
	_aItem[04]		:= aRegistro[i][4]
	_aItem[05]		:= aRegistro[i][5]
	_aItem[06]		:= aRegistro[i][6]
	_aItem[07]		:= aRegistro[i][7]
	_aItem[08]		:= aRegistro[i][8]
	_aItem[09]		:= aRegistro[i][9]
	_aItem[10]		:= aRegistro[i][10]
	_aItem[11]		:= aRegistro[i][11]
	_aItem[12]		:= aRegistro[i][12]
	_aItem[13] 		:= aRegistro[i][13]
	_aItem[14]		:= aRegistro[i][14]
	_aItem[15]		:= aRegistro[i][15]
	AADD(_aIExcel,_aItem)
		_aItem := {}  
	
IF aRegistro[i][1] <> "01078" .AND. aRegistro[i][1] <> "01079"	
	nSubJan		+= aRegistro[i][3]
	nSubFev		+= aRegistro[i][4]
	nSubMar		+= aRegistro[i][5]
	nSubAbr		+= aRegistro[i][6]
	nSubMai		+= aRegistro[i][7]
	nSubJun		+= aRegistro[i][8]
	nSubJul		+= aRegistro[i][9]
	nSubAgo		+= aRegistro[i][10]
	nSubSet		+= aRegistro[i][11]
	nSubOut		+= aRegistro[i][12]
	nSubNov		+= aRegistro[i][13]
	nSubDez		+= aRegistro[i][14]
	nSubTotal 	+= aRegistro[i][15] 
ENDIF	
	
	IF  aRegistro[i][01] <> "TOTAL"
		
		cSigGer := SUBSTR(aRegistro[i][01],1,2)
		
	ENDIF
	
Next

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf    

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "SIG Excel - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","SIGEXCEL")
	_lRet := .F.
ENDIF

//cArq     := _cTemp+".DBF"

//DBSelectArea("TMP1")
//DBCloseARea("TMP1")

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Tipo Relatorio:	 	","","","mv_ch01","N",01,0,2,"C","","mv_par01","Despesa","","","","","Receita","","","","","Ambos","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ordena por:    		","","","mv_ch02","N",01,0,2,"C","","mv_par02","Cta. SIG","","","","","C. Custo","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Cta. SIG  	  	","","","mv_ch03","C",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZY"})
AADD(aRegs,{cPerg,"04","Ate Cta. SIG      	","","","mv_ch04","C",05,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SZY"})
AADD(aRegs,{cPerg,"05","Do C. Custo 	  	","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Ate C. Custo	  	","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"07","Da Data     	  	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Data       	  	","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"09","Imp. Previsão	 	","","","mv_ch09","N",01,0,2,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Filtra Grupo:	 	","","","mv_ch10","N",01,0,2,"C","","mv_par10","Tecnico","","","","","Comercial","","","","","Aministrativo","","","","","Jornalismo","","","","","Todos","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Filtra Grupo Cont.:	","","","mv_ch11","N",01,0,2,"C","","mv_par11","Marketing","","","","","Operacoes","","","","","Todos","","","","","","","","","","","","","","","","","",""})

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
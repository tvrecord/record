#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    29/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FLUXO A VENCER						                        ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AVENCER()    

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
Private nomeprog     := "AVENCER" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "AVENCER" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "AVENCER2"
Private cString      := "SE2"
Private cQuery       := ""
Private titulo       := "Fluxo por vencimento"
Private aTitulos 	 := {} 
Private cNatGer 	 := ""
Private nSubTotal  	 := 0
Private nTotal 		 := 0   
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

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Relatorio()

cQuery := "SELECT E2_FILIAL AS FILIAL,E2_VENCREA AS VENCIMENTO, "
cQuery += "E2_PREFIXO AS PREFIXO,E2_NUM AS TITULO, "
cQuery += "E2_PARCELA AS PARCELA,E2_TIPO AS TIPO, "
cQuery += "E2_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRI, "
cQuery += "ED_NATGER AS NATGER,E2_FORNECE AS CODFOR, "
cQuery += "E2_LOJA AS LOJA,E2_NOMFOR AS NOME, "
cQuery += "E2_HIST AS HISTORICO,E2_SALDO AS VALOR, "  
cQuery += "E2_BAIXA AS BAIXA, 'SE2' AS TABELA,'' AS SEQUENCIA "
cQuery += "FROM SE2010 INNER JOIN SED010 ON E2_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE2010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND E2_FILIAL = '01' "
cQuery += "AND E2_VENCREA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' " 
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "AND E2_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND E2_SALDO <> 0 "
cQuery += "UNION "
cQuery += "SELECT E5_FILIAL AS FILIAL,E5_DATA AS VENCIMENTO, "
cQuery += "E5_PREFIXO AS PREFIXO,E5_NUMERO AS TITULO, "
cQuery += "E5_PARCELA AS PARCELA,E5_TIPO AS TIPO, "
cQuery += "E5_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRI, "
cQuery += "ED_NATGER AS NATGER,E5_CLIFOR AS CODFOR, "
cQuery += "E5_LOJA AS LOJA,E5_BENEF AS NOME, "
cQuery += "E5_HISTOR AS HISTORICO,E5_VALOR AS VALOR, " 
cQuery += "E5_DATA AS BAIXA, 'SE5' AS TABELA,E5_SEQ AS SEQUENCIA "
cQuery += "FROM SE5010 INNER JOIN SED010 ON E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND E5_SITUACA <> 'C' AND E5_FILIAL = '01' "
cQuery += "AND E5_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' " 
cQuery += "AND ED_NATGER BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND E5_FILIAL = '01' "
IF MV_PAR02 == 1
cQuery += "AND E5_RECPAG = 'P' " 
ELSEIF MV_PAR02 == 2
cQuery += "AND E5_RECPAG = 'R' " 
ENDIF  
cQuery += "ORDER BY VENCIMENTO,NOME "

tcQuery cQuery New Alias "TMP"  

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// **************************** Cria Arquivo Temporario
_aCExcel:={}//SPCSQL->(DbStruct())
aadd( _aCExcel , {"FORNECEDOR"     	, "C" , 030 , 00 } )
aadd( _aCExcel , {"HISTORICO"		, "C" , 100 , 00 } )
aadd( _aCExcel , {"NF"		    	, "C" , 010 , 00 } )
aadd( _aCExcel , {"FIXA"		   	, "N" , 010 , 02 } )
aadd( _aCExcel , {"VARIAVEL"		, "N" , 010 , 02 } )
aadd( _aCExcel , {"INVEST"	    	, "N" , 010 , 02 } )
aadd( _aCExcel , {"VENCTO"			, "D" , 010 , 00 } )
aadd( _aCExcel , {"PAGAMENTO"		, "D" , 010 , 00 } )
aadd( _aCExcel , {"BANCO"			, "C" , 010 , 00 } )
aadd( _aCExcel , {"NATUREZA"		, "C" , 030 , 00 } )  
                                                 
//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())	

		If TemBxCanc(TMP->(PREFIXO+TITULO+PARCELA+TIPO+CODFOR+LOJA+SEQUENCIA))
		TMP->(dbSkip())
			Loop
		EndIf	
			 
			aAdd(aTitulos,{Posicione("SA2",1,xFilial("SA2") + TMP->CODFOR + TMP->LOJA,"A2_NOME"),;
			TMP->HISTORICO,;
			TMP->TITULO,;
			0,;
			TMP->VALOR,; 
			0,;
			STOD(TMP->VENCIMENTO),;
			STOD(TMP->BAIXA),;
			"BRADESCO",;
			TMP->NATGER})
			
						
	DBSelectArea("TMP")
	DBSkip()
	
Enddo

//Ordena todas as informações por Natureza GErencial + Data de Vencimento
ASORT(aTitulos,,,{|x,y|DTOS(x[7])+x[1] < DTOS(y[7])+y[1]})

For i:=1 to Len(aTitulos)        

/*  	
		If i == 1
		cNatGer := aTitulos[i][10]
		Reclock("TMP1",.T.)
		TMP1->FORNECEDOR	:= Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][10],"X5_DESCRI")
		MsUnlock()
	EndIf
	
	If cNatGer != aTitulos[i][10]
		                   	
		//SubTotal
		Reclock("TMP1",.T.)
		TMP1->VALOR 		:= nSubTotal
		MsUnlock()
		
		// Pula Linha
		Reclock("TMP1",.T.)
		MsUnlock()
		
		//Cabeçalho
		Reclock("TMP1",.T.)
		TMP1->FORNECEDOR	:= Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][10],"X5_DESCRI")
		MsUnlock()
		
		nSubTotal := 0
		
	EndIf   
	
	*/
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[1]		:= aTitulos[i][1]
	_aItem[2]		:= aTitulos[i][2]
	_aItem[3] 		:= aTitulos[i][3]
	_aItem[4]	 	:= aTitulos[i][4]
	_aItem[5]		:= aTitulos[i][5]
	_aItem[6]		:= aTitulos[i][6]
	_aItem[7]		:= aTitulos[i][7]
	_aItem[8]		:= aTitulos[i][8]
	_aItem[9]		:= aTitulos[i][9]           
	_aItem[10]		:= Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][10],"X5_DESCRI")
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	nSubTotal 	+= aTitulos[i][5]
	nTotal 		+= aTitulos[i][5]
   //	cNatGer 	:= aTitulos[i][10]
	
Next
       
/*

// Subtotal do ultimo registro que não será impresso no FOR
Reclock("TMP1",.T.)
TMP1->VALOR 		:= nSubTotal
MsUnlock()

// Total
Reclock("TMP1",.T.)
TMP1->VALOR 		:= nTotal
MsUnlock()

*/


If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado." 
	DBSelectArea("TMP")
	DBCloseARea("TMP")
	Return
EndIf

//cArq     := _cTemp+".DBF"

//DBSelectArea("TMP1")
//DBCloseARea("TMP1")
DBSelectArea("TMP")
DBCloseARea("TMP")


//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")
                                            	
//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.) 

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Titulos a Vencer - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","AVENCER")
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
AADD(aRegs,{cPerg,"07","Do Bloco   		  	","","","mv_ch07","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})
AADD(aRegs,{cPerg,"08","Ate Bloco	      	","","","mv_ch08","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","ZV"})

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
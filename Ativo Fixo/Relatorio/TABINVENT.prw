#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 TABATIVO : Autor 3 Rafael França      : Data 3  07/04/2015 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Tabela do Ativo Fixo em Excel    :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Auditoria                                                  :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function TABINVENT

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Tabela de Inventario do Ativo Fixo"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "TABINVENT"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "TABINVENT"
Private cString    := "SN1"
Private N		   := 00001
Private cQuery   := ""
Private _aStruSRA := {}
Private _aIExcel 	 := {}

ValidPerg(cPerg)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//EndIf
Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Funo    3RUNREPORT : Autor 3 AP6 IDE            : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descrio 3 Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS :11
11:          3 monta a janela com a regua de processamento.               :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQuery	:= ""  
Local cCodBase 	:= ""
SetRegua(5000)
Pergunte(cPerg,.f.)


cQuery:= "SELECT N3_CBASE AS CBASE "        
cQuery+= ",(SELECT N1_DESCRIC FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS DESCRICAO "
cQuery+= ",N3_CUSTBEM "
cQuery+= ",(SELECT N1_SERIE1 FROM SN1010 WHERE SN1010.D_E_L_E_T_ = '' AND N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL) AS NSERIE "
cQuery+= "FROM SN3010 "
cQuery+= "WHERE SN3010.D_E_L_E_T_ = '' "  //AND N3_TIPO <> '12' //AND N3_CCONTAB = '126510001' AND SUBSTRING(N3_CUSTBEM,1,1) <> '2' 
cQuery+= "AND N3_CBASE BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' "
cQuery+= "AND N3_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' "  
cQuery+= "AND N3_DTBAIXA = '' "   
cQuery+= "AND N3_TIPO = '01' "
cQuery+= "AND N3_CBASE NOT LIKE '%.%' "
cQuery+= "AND N3_CBASE NOT LIKE 'NFE%' "
cQuery+= "ORDER BY N3_CBASE "


If Select("TMP") > 0
	TMP->(DbCloseArea())                
Endif

TCQUERY cQuery NEW ALIAS "TMP"

TMP->(DbGoTop())

// **************************** Cria Arquivo Temporario
_aCExcel:={}//TMP->(DbStruct()) //_aCExcel
aadd( _aCExcel , {"CBASE"   			, "C" , 10 , 00 } )//01
aadd( _aCExcel , {"DESCRICAO"			, "C" , 50,  00 } )//02
aadd( _aCExcel , {"CCUSTO"	   			, "C" , 10 , 00 } )//03  
aadd( _aCExcel , {"BRANCO1"	       		, "C" , 10 , 00 } )//04
aadd( _aCExcel , {"BRANCO2"  			, "C" , 10 , 00 } )//05
aadd( _aCExcel , {"NSERIE"   	  		, "C" , 10 , 00 } )//06
aadd( _aCExcel , {"STATUS1"   	  		, "C" , 01 , 00 } )//07


DbSelectArea("TMP")
Do While TMP->(!Eof())
	
IF TMP->CBASE <> cCodBase	
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)                                                                       
	_aItem[1]			:=	TMP->CBASE       	     
	_aItem[2]			:=	TMP->DESCRICAO                                  
	_aItem[3]			:=	TMP->N3_CUSTBEM
	_aItem[4]			:=	"" 
	_aItem[5]			:=	""	
	_aItem[6]			:= 	TMP->NSERIE  
	_aItem[7]			:=  "1"
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	N++    
	cCodBase := 	TMP->CBASE
	
ENDIF
		
	TMP->(DbSkip())
			
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

DbSelectArea("TMP")
TMP->(DbCloseArea())

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Tabela de inventario do Ativo Fixo - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","TABINVENT")
	_lRet := .F.
ENDIF

Return

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3ValidPerg : Autor 3                    : Data 3  18/09/06   :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Cria/Valida Parametros do sistema                          :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Da Filial	   ","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Ate Filial     ","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Do Ativo Fixo  ","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
AADD(aRegs,{cPerg,"04","Ate Ativo Fixo ","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})



For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)
Return

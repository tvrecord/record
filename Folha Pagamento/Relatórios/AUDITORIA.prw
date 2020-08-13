#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 AUDITRH  : Autor 3 Bruno Alves        : Data 3  27/11/2012 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 Registros Profissionais - Relatório    :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Auditoria                                                  :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function AUDITRH

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Registro Profissional"
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
Private nomeprog   := "AUDITRH"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "AUDITRH1"
Private cString    := "SRA"
Private N		   := 00001
Private _cQrySRA   := ""
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
Local _cQrySRA:=""
SetRegua(5000)
Pergunte(cPerg,.f.)


_cQrySRA:="SELECT "
_cQrySRA+="RA_DEMISSA,RA_FILIAL, "
_cQrySRA+="RA_SITFOLH, "
_cQrySRA+="RA_MAT, "
_cQrySRA+="RA_NOME, "
_cQrySRA+="RA_ADMISSA, "
_cQrySRA+="RA_CC,CTT_DESC01, "
_cQrySRA+="RA_CODFUNC,RJ_DESC,RA_DESCACU,RA_CCACUM,RA_ACUM,RA_INIACUM,RA_NUMCP,RA_SERCP,RA_UFCP,RA_NUMREQ, "
_cQrySRA+="RA_EMISSAO,RA_NUMRG,RA_ORGAO,RA_UFREG,RA_ADMACU,RA_RGACUM,RA_REG02,RA_UFACUM "
_cQrySRA+="FROM SRA010 "
_cQrySRA+="INNER JOIN CTT010 ON "
_cQrySRA+="RA_FILIAL = CTT_FILIAL AND "
_cQrySRA+="RA_CC = CTT_CUSTO "
_cQrySRA+="INNER JOIN SRJ010 ON "
_cQrySRA+="RA_CODFUNC = RJ_FUNCAO "
_cQrySRA+="WHERE "
_cQrySRA+="SRJ010.D_E_L_E_T_ <> '*' AND "
_cQrySRA+="SRA010.D_E_L_E_T_ <> '*' AND "
_cQrySRA+="CTT010.D_E_L_E_T_ <> '*' AND "
_cQrySRA+="RA_CATFUNC <> 'E' AND "
If MV_PAR11 == 2
_cQrySRA+="RA_DEMISSA = '' AND "
EndIf
_cQrySRA+="RA_FILIAL BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
_cQrySRA+="RA_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
_cQrySRA+="RA_ADMISSA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' AND "
_cQrySRA+="RA_CC BETWEEN '" + (MV_PAR07) + "' AND '" + (MV_PAR08) + "' AND "
_cQrySRA+="RA_CODFUNC BETWEEN '" + (MV_PAR09) + "' AND '" + (MV_PAR10) + "' "
_cQrySRA+="ORDER BY RA_NOME "





If Select("SRASQL") > 0
	SRASQL->(DbCloseArea())
Endif

TCQUERY _cQrySRA NEW ALIAS "SRASQL"

SRASQL->(DbGoTop())




// **************************** Cria Arquivo Temporario
_aCExcel:={}//SRASQL->(DbStruct())
aadd(_aCExcel , {"SEQUENCIAL"      		, "C" , 10 , 00 } ) //01
aadd(_aCExcel , {"SITUACAO"   			, "C" , 03 , 00 } ) //02
aadd(_aCExcel , {"NOME"  				, "C" , 50 , 00 } ) //03
aadd(_aCExcel , {"ADMISSAO"				, "C" , 10 , 00 } ) //04
aadd(_aCExcel , {"CCSINT"				, "C" , 50,  00 } ) //05
aadd(_aCExcel , {"FUNCAO"	   			, "C" , 40 , 00 } ) //06
aadd(_aCExcel , {"DTCARGO"	   			, "C" , 10 , 00 } ) //07
aadd(_aCExcel , {"CCUSTO"  	  			, "C" , 40 , 00 } ) //08
aadd(_aCExcel , {"FUNCACUM"    			, "C" , 40 , 00 } ) //09
aadd(_aCExcel , {"CCACUM " 				, "C" , 40 , 00 } ) //10
aadd(_aCExcel , {"DTAINIACUM"  			, "C" , 12 , 00 } ) //11
aadd(_aCExcel , {"CTPS"	   				, "C" , 25,  00 } ) //12
aadd(_aCExcel , {"NUMREQ"  	 			, "C" , 10 , 00 } ) //13
aadd(_aCExcel , {"CARGO01"	 			, "C" , 40 , 00 } ) //14
aadd(_aCExcel , {"EMISSAO"     			, "C" , 10 , 00 } ) //15
aadd(_aCExcel , {"REGISTRO01"  		 	, "C" , 25 , 00 } ) //16
aadd(_aCExcel , {"FUNCAOACUM"  			, "C" , 40 , 00 } ) //17
aadd(_aCExcel , {"EMISSAOACU"  			, "C" , 12 , 00 } ) //18
aadd(_aCExcel , {"REGISTRO02"  			, "C" , 25,  00 } ) //19
aadd(_aCExcel , {"DEMISSA"	 			, "C" , 15 , 00 } ) //20

//_cTemp := CriaTrab(_aStruSRA, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)

//SUBTITULO - INCLUIDO PARA FACILITAR A VISUALIZAÇÃO DO USUÁRIO

	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[1]	 		:=	"Num"
	_aItem[2]			:=	"A/D"
	_aItem[3]			:= 	"Nome do Empregado"
	_aItem[4]	 		:=	"Admissao"
	_aItem[5]			:=	"Centro de Custo"
	_aItem[6]			:=	"Cargo Principal"
	_aItem[7]			:=	"Data Cargo"
	_aItem[8]			:=	"Setor Radialista do Cargo Principal"
	_aItem[9]			:=	"Cargo Acumulado"
	_aItem[10]			:=	"Setor Radialista do Cargo Acumulado"
	_aItem[11]			:=	"DT Acumu."
	_aItem[12]			:=	"N CTPS"
	_aItem[13]			:=	"Requisicao"
	_aItem[14]  		:=	"Cargo 1 Registro Profissional"
	_aItem[15]   		:=	"Emissao"
	_aItem[16]	 		:=	"N 1 Reg."
	_aItem[17]	 		:=	"Cargo 2 Registro Profissional"
	_aItem[18]			:=	"Emissao"
	_aItem[19]	   		:=	"N. 2 Reg."
	_aItem[20]		:=	"Desligamento"
	AADD(_aIExcel,_aItem)
	_aItem := {}

DbSelectArea("SRASQL")
Do While SRASQL->(!Eof())
	
	
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[1]	  		:=	STRZERO(N,6)
	_aItem[2]	   		:=	IIF(EMPTY(SRASQL->RA_DEMISSA),"A","D")
	_aItem[3]			:= 	SRASQL->RA_NOME	
	_aItem[4]	 		:=	DTOC(STOD(SRASQL->RA_ADMISSA))
	_aItem[5]			:=	Posicione("CTT",1,SRASQL->RA_FILIAL + SUBSTR(SRASQL->RA_CC,1,4),"CTT_DESC01")
	_aItem[6]			:=	SRASQL->RJ_DESC
	_aItem[7]	 		:=	DTOC(Posicione("SR7",3,SRASQL->RA_FILIAL + SRASQL->RA_MAT + SRASQL->RA_CODFUNC ,"R7_DATA"))
	_aItem[8]			:=	SRASQL->CTT_DESC01
	_aItem[9]	   		:=	SRASQL->RA_DESCACU
	_aItem[10]			:=	SRASQL->RA_ACUM
	_aItem[11]	   		:=	DTOC(STOD(SRASQL->RA_INIACUM))
	_aItem[12]			:=	IIF(!EMPTY(SRASQL->RA_NUMCP),(SRASQL->RA_NUMCP) + " / " + (SRASQL->RA_SERCP) + " - " + (SRASQL->RA_UFCP),"")
	_aItem[13]			:=	SRASQL->RA_NUMREQ
	_aItem[14]  		:=	SRASQL->RJ_DESC
	_aItem[15]   		:=	DTOC(STOD(SRASQL->RA_EMISSAO))
	_aItem[16]			:=	IIF(!EMPTY(SRASQL->RA_NUMRG),(SRASQL->RA_NUMRG) + " - " + (SRASQL->RA_ORGAO) + " / " + (SRASQL->RA_UFREG),"")
	_aItem[17]			:=	SRASQL->RA_DESCACU
	_aItem[18]			:=	DTOC(STOD(SRASQL->RA_ADMACU))
	_aItem[19]			:=	IIF(!EMPTY(SRASQL->RA_RGACUM),(SRASQL->RA_RGACUM) + " - " + (SRASQL->RA_REG02) + " / " + (SRASQL->RA_UFACUM),"")
	_aItem[20]		:=	DTOC(STOD(SRASQL->RA_DEMISSA))
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	
	SRASQL->(DbSkip())
	
	N++
	
	
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

//DbSelectArea("TMP")
//TMP->(DbCloseArea())

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.) 

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Registro profissional - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","AUDITORIA")
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


AADD(aRegs,{cPerg,"01","Da Filial	  		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Ate Filial  		","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"03","Da Matricula	  		","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Ate Matricula  		","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
Aadd(aRegs,{cPerg,"05","Da Admissão    ?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Ate Admissão   ?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","De Centro de Custo	  		","","","mv_ch07","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"08","Ate Centro de Custo	","","","mv_ch08","C",09,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"09","De Função	  		","","","mv_ch09","C",05,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRJ"})
AADD(aRegs,{cPerg,"10","Ate Função	","","","mv_ch10","C",05,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRJ"})
AADD(aRegs,{cPerg,"11","Imp. Demitido?","","","mv_ch11","N",01,0,2,"C","","mv_par11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})


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

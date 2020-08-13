#Include "RwMake.ch"
#Include "topconn.ch"

/*/
Rafael França,11/09/17,RELNAPOLI,Solicitantes: Giselly, Relatorio com o objetivo de mostrar o cadastro de funcionarios no modelo solicitado pela Napoli
/*/

User Function RELNAPOLI

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "Controle de encargos - Napoli "
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
Private nomeprog   := "RELNAPOLI"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "RELNAPOLI"
Private cString    := "SRA"
Private cQuery     := ""
Private _aStruSRA  := {}
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

Local cQuery		:= ""
Local nValMed       := 0
Local nValOdo       := 0
Local nValor		:= 0

Pergunte(cPerg,.F.)

cQuery := "SELECT RA_FILIAL AS FILIAL "
cQuery += ",(SELECT CTT_DESC01 FROM CTT010 WHERE CTT010.D_E_L_E_T_ = '' AND CTT_CUSTO = RA_CC AND CTT_FILIAL = RA_FILIAL) AS CCUSTO "
cQuery += ",RA_MAT AS MATRICULA,RA_NOME AS NOME,RA_ADMISSA AS ADMISSAO "
cQuery += ",(SELECT RJ_DESC FROM SRJ010 WHERE SRJ010.D_E_L_E_T_ = '' AND RA_CODFUNC = RJ_FUNCAO) AS FUNCAO "
cQuery += ",RA_HRSMES AS HORAMES "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND (RD_PD IN "+FormatIn(mv_par05,";")+" OR RD_PD IN "+FormatIn(mv_par16,";")+") AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS SALARIO "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par06,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS ACUMULO "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par07,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS ATS "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par08,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS PERICUL "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par09,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS VALI " //20% FUNCIONARIO 80% EMPRESA
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par10,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS VREF " //20% FUNCIONARIO 80% EMPRESA
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par12,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS VCESTA" //01% FUNCIONARIO 99% EMPRESA
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par11,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS VTRANS "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par15,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS DESCSAL "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par13,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS INSS "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par14,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS FGTS "
cQuery += ",(SELECT SUM(ZO_VALOR) FROM SZO010 WHERE SZO010.D_E_L_E_T_ = '' AND ZO_MES = '"+SUBSTR(MV_PAR02,5,2)+"' AND ZO_ANO = '"+SUBSTR(MV_PAR02,1,4)+"' AND ZO_MAT = RA_MAT AND ZO_FILIAL= RA_FILIAL AND ZO_TPREF= '2' GROUP BY ZO_MAT) AS ALIMENTA "
cQuery += ",(SELECT SUM(ZO_VALOR) FROM SZO010 WHERE SZO010.D_E_L_E_T_ = '' AND ZO_MES = '"+SUBSTR(MV_PAR02,5,2)+"' AND ZO_ANO = '"+SUBSTR(MV_PAR02,1,4)+"' AND ZO_MAT = RA_MAT AND ZO_FILIAL= RA_FILIAL AND ZO_TPREF= '1' GROUP BY ZO_MAT) AS REFEICAO "
cQuery += ",(SELECT SUM(ZO_VALOR) FROM SZO010 WHERE SZO010.D_E_L_E_T_ = '' AND ZO_MES = '"+SUBSTR(MV_PAR02,5,2)+"' AND ZO_ANO = '"+SUBSTR(MV_PAR02,1,4)+"' AND ZO_MAT = RA_MAT AND ZO_FILIAL= RA_FILIAL AND ZO_TPREF= '3' GROUP BY ZO_MAT) AS CESTA "
cQuery += ",(SELECT SUBSTRING(RCC_CONTEU,35,12) FROM RHK010 INNER JOIN RCC010 ON RHK_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S008' WHERE RHK010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHK_PERFIM = '' AND RHK_TPFORN = '1' AND RHK_CODFOR = '002' AND RHK_MAT = RA_MAT) AS ASSMED "
cQuery += ",(SELECT SUBSTRING(RCC_CONTEU,35,12) FROM RHK010 INNER JOIN RCC010 ON RHK_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S013' WHERE RHK010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHK_PERFIM = '' AND RHK_TPFORN = '2' AND RHK_CODFOR = '003' AND RHK_MAT = RA_MAT) AS ASSODO "
cQuery += ",(SELECT COUNT(RCC_FILIAL) + 1 FROM RHL010 INNER JOIN RCC010 ON RHL_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S008' WHERE RHL010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHL_PERFIM = '' AND RHL_TPFORN = '1' AND RHL_CODFOR = '002' AND RHL_MAT = RA_MAT AND RHL_FILIAL = RA_FILIAL GROUP BY RHL_FILIAL) AS QTDMED "
cQuery += ",(SELECT COUNT(RCC_FILIAL) + 1 FROM RHL010 INNER JOIN RCC010 ON RHL_PLANO = SUBSTRING(RCC_CONTEU,1,2) AND RCC_CODIGO = 'S013' WHERE RHL010.D_E_L_E_T_ = '' AND RCC010.D_E_L_E_T_ = '' AND RHL_PERFIM = '' AND RHL_TPFORN = '2' AND RHL_CODFOR = '003' AND RHL_MAT = RA_MAT AND RHL_FILIAL = RA_FILIAL GROUP BY RHL_FILIAL) AS QTDODO "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par17,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS DSR "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par18,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS NOTURNO "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par19,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS GRATIFICA "
cQuery += ",(SELECT SUM(RD_VALOR) FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL AND RD_PD IN "+FormatIn(mv_par20,";")+" AND RD_MAT = RA_MAT GROUP BY RD_MAT) AS HEXTRA "
cQuery += "FROM SRA010 "
cQuery += "WHERE SRA010.D_E_L_E_T_ = '' AND RA_FILIAL = '"+MV_PAR01+"' AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND RA_MAT IN (SELECT RD_MAT FROM SRD010 WHERE SRD010.D_E_L_E_T_ = '' AND RD_DATARQ = '"+MV_PAR02+"' AND RD_FILIAL = RA_FILIAL GROUP BY RD_MAT) "
cQuery += "ORDER BY FILIAL,CCUSTO,MATRICULA,NOME "

If Select("TMPSRA") > 0
	TMPSRA->(DbCloseArea())
Endif

TCQUERY cQuery NEW ALIAS "TMPSRA"

TMPSRA->(DbGoTop())

// **************************** Cria Arquivo Temporario
_aCExcel:={}//TMP->(DbStruct()) 
aadd( _aCExcel , {"DEPART"	   			, "C" , 20 , 00 } ) //01
aadd( _aCExcel , {"MATRICULA"	   		, "C" , 12 , 00 } ) //02
aadd( _aCExcel , {"NOME"	     		, "C" , 35 , 00 } ) //03
aadd( _aCExcel , {"ADMISSAO"   	   		, "C" , 10 , 00 } ) //04
aadd( _aCExcel , {"FUNCAO"   	  		, "C" , 20 , 00 } ) //05
aadd( _aCExcel , {"CHORAS"  			, "N" , 03 , 00 } ) //06
aadd( _aCExcel , {"SALARIO"		 	  	, "N" , 12 , 02 } ) //07
aadd( _aCExcel , {"DSR"			   		, "N" , 12 , 02 } ) //08
aadd( _aCExcel , {"NOTURNO"		   		, "N" , 12 , 02 } ) //09
aadd( _aCExcel , {"GRATIFICA"		   	, "N" , 12 , 02 } ) //10
aadd( _aCExcel , {"HEXTRA"			   	, "N" , 12 , 02 } ) //11
aadd( _aCExcel , {"ACUMULO"		   		, "N" , 12 , 02 } ) //12
aadd( _aCExcel , {"ATS"		   	  		, "N" , 12 , 02 } ) //13
aadd( _aCExcel , {"PERICUL"	   			, "N" , 12 , 02 } ) //14
aadd( _aCExcel , {"SEGVIDA"		   		, "N" , 12 , 02 } ) //15
aadd( _aCExcel , {"ASSMEDICA"		   	, "N" , 12 , 02 } ) //16
aadd( _aCExcel , {"VALI"		   		, "N" , 12 , 02 } ) //17
aadd( _aCExcel , {"VREF"		   		, "N" , 12 , 02 } ) //18
aadd( _aCExcel , {"CESTA"		   		, "N" , 12 , 02 } ) //19
aadd( _aCExcel , {"VTRANS"		   		, "N" , 12 , 02 } ) //20
aadd( _aCExcel , {"INSS"		   		, "N" , 12 , 02 } ) //21
aadd( _aCExcel , {"FGTS"		   		, "N" , 12 , 02 } ) //22

//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DbSelectArea("TMPSRA")
Do While TMPSRA->(!Eof()) 

IF TMPSRA->QTDMED > 0
nValMed := (VAL(TMPSRA->ASSMED)*TMPSRA->QTDMED) 
ELSE
nValMed := VAL(TMPSRA->ASSMED) 
ENDIF 

IF TMPSRA->QTDODO > 0
nValOdo := (VAL(TMPSRA->ASSODO)*TMPSRA->QTDODO) 
ELSE
nValOdo := VAL(TMPSRA->ASSODO)
ENDIF    

nValor := nValMed + nValOdo
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	_aItem[1]			:= TMPSRA->CCUSTO	
	_aItem[2] 			:= TMPSRA->MATRICULA
	_aItem[3]			:= TMPSRA->NOME  
	_aItem[4]			:= DTOC(STOD(TMPSRA->ADMISSAO))
	_aItem[5]			:= TMPSRA->FUNCAO
	_aItem[6]			:= TMPSRA->HORAMES
	_aItem[7]			:= (TMPSRA->SALARIO - TMPSRA->DESCSAL)
	_aItem[8]			:= TMPSRA->DSR       
	_aItem[9]			:= TMPSRA->NOTURNO	
	_aItem[10]			:= TMPSRA->GRATIFICA 
	_aItem[11]			:= TMPSRA->HEXTRA	
	_aItem[12]			:= TMPSRA->ACUMULO 
	_aItem[13]			:= TMPSRA->ATS
	_aItem[14]			:= TMPSRA->PERICUL
	_aItem[15]			:= 0
	_aItem[16]			:= nValor
	_aItem[17]			:= (TMPSRA->ALIMENTA - TMPSRA->VALI)
  	_aItem[18]			:= (TMPSRA->REFEICAO - TMPSRA->VREF) 
	_aItem[19]			:= (TMPSRA->CESTA - TMPSRA->VCESTA)
	_aItem[20]			:= TMPSRA->VTRANS 
	_aItem[21]			:= TMPSRA->INSS 
	_aItem[22]		    := TMPSRA->FGTS	
									
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	TMPSRA->(DbSkip())	
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	Return
EndIf

//cArq     := _cTemp+".DBF"

DbSelectArea("TMPSRA")
TMPSRA->(DbCloseArea())
//DbSelectArea("TMP1")
//TMP1->(DbCloseArea())

//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Controle de encargos - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","RELNAPOLI")
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

AADD(aRegs,{cPerg,"01","Filial: 		","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"02","Periodo(AAAAMM):","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da  Matricula:	","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Ate Matricula:	","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"05","Verbas Salario 	;","","","mv_ch05","C",60,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Verbas Acumulo 	;","","","mv_ch06","C",60,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Verbas ATS     	;","","","mv_ch07","C",60,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"08","Periculosidade 	;","","","mv_ch08","C",60,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","V Alimentacao  	;","","","mv_ch09","C",60,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","V Refeicao     	;","","","mv_ch10","C",60,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","V Transporte   	;","","","mv_ch11","C",60,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","V Cesta        	;","","","mv_ch12","C",60,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","INSS Empresa   	;","","","mv_ch13","C",60,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","FGTS Empresa    ;","","","mv_ch14","C",60,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Desc Salario (-);","","","mv_ch15","C",60,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"16","Compl. Salario 	;","","","mv_ch16","C",60,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","DSR			   	;","","","mv_ch17","C",60,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"18","Ad. Noturno   	;","","","mv_ch18","C",60,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"19","Gratificação	;","","","mv_ch19","C",60,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"20","Horas extras 	;","","","mv_ch20","C",60,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
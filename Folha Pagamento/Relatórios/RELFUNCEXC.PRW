#Include "RwMake.ch"
#Include "topconn.ch"

/*/
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 RELFUNCEXC : Autor 3 Bruno Alves        : Data 3  26/08/2013 :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Descricao 3 RELAÇAO DE FUNCIONARIOS LIMITE DE COMPRAS                  :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 Gestao Pessoal                                        :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
/*/

User Function RELFUNCEXC

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Controle de Registros Profissionais"
Local cPict        := ""
Local titulo       := "RELACAO DE FUNCIONARIOS - LIMITE DE COMPRAS - "
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
Private nomeprog   := "RELFUNCEXC"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := ""
Private cPerg      := "RELFUNC2"
Private cString    := "SRA"
Private N		   := 00001
Private _cQrySRA   := ""
Private _aStruSRA := {}
Private dData	    := ("//")
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
Local cQuery := ""
SetRegua(5000)
Pergunte(cPerg,.f.)

dData := (STOD(SUBSTR(DTOS(MV_PAR03),1,6) + "28") + 10)


cQuery	:= "SELECT RA_FILIAL,RA_SITFOLH,RA_TPCONTR,RA_MAT,RA_CC,RA_SEXO,RA_NOME,RA_CIC,RA_RG,RA_CODFUNC, RA_ENDEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP, "
cQuery	+= "SUBSTRING(RA_NASC,7,2) + '/' + SUBSTRING(RA_NASC,5,2) + '/'+  SUBSTRING(RA_NASC,1,4) AS NASCIMENTO, "
cQuery	+= "SUBSTRING(RA_ADMISSA,7,2) + '/' + SUBSTRING(RA_ADMISSA,5,2) + '/'+  SUBSTRING(RA_ADMISSA,1,4) AS ADMISSAO "
IF MV_PAR07 == 1
	cQuery	+= ",SUM(RD_VALOR) * 0.3 AS VALOR "
ENDIF
cQuery	+= "FROM SRA010 "
IF MV_PAR07 == 1
	cQuery	+= "INNER JOIN SRD010 ON RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT "
ENDIF
cQuery	+= "WHERE SRA010.D_E_L_E_T_ <> '*' AND SRA010.RA_MAT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
IF !EMPTY(MV_PAR12) .AND. !EMPTY(MV_PAR13) // Rafael França - parametro ira funcionar apenas quando forem preenchidas as duas datas de demissao.
	cQuery	+= "AND (RA_SITFOLH NOT IN ('D') OR RA_SITFOLH = 'D' AND RA_DEMISSA BETWEEN '" + DTOS(MV_PAR12) + "' AND '" + DTOS(MV_PAR13) + "') "
ELSE
	cQuery	+= "AND RA_SITFOLH NOT IN ('D') "
ENDIF
cQuery	+= "AND RA_CATFUNC <> 'E' "
cQuery	+= "AND RA_ADMISSA BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' "
IF MV_PAR07 == 1
	cQuery	+= "AND SRD010.D_E_L_E_T_ <> '*' AND SRD010.RD_PD = '799' AND SRD010.RD_DATARQ = '" + SUBSTR(DTOS(MV_PAR03),1,6) + "' "
	cQuery	+= "AND RA_TPCONTR <> '2' "
ENDIF
cQuery	+= "AND SRA010.RA_FILIAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
cQuery	+= "GROUP BY RA_FILIAL,RA_SITFOLH,RA_CODFUNC,RA_TPCONTR,RA_MAT,RA_CC,RA_SEXO,RA_NOME,RA_CIC,RA_RG,RA_ENDEREC,RA_COMPLEM,RA_BAIRRO, "
cQuery	+= "RA_MUNICIP,RA_ESTADO,RA_CEP,RA_NASC,RA_ADMISSA "
IF 		MV_PAR06 == 1
	cQuery	+= "ORDER BY RA_MAT "
ELSEIF 	MV_PAR06 == 2
	cQuery	+= "ORDER BY RA_NOME "
ENDIF

tcQuery cQuery New Alias "SRASQL"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("SRASQL")
	dbCloseArea("SRASQL")
	Return
Endif




SRASQL->(DbGoTop())




// **************************** Cria Arquivo Temporario
_aCExcel:={}//SRASQL->(DbStruct()) 

IF MV_PAR07 == 1
	
	aadd( _aCExcel , {"MATRICULA"      	   		, "C" , 10 , 00 } ) //01
	aadd( _aCExcel , {"NOME"   					, "C" , 57 , 00 } ) //02
	aadd( _aCExcel , {"CPF"  					, "C" , 20 , 00 } ) //03
	aadd( _aCExcel , {"RG"						, "C" , 15 , 00 } ) //04
	aadd( _aCExcel , {"ENDERECO"				, "C" , 40,  00 } ) //05
	aadd( _aCExcel , {"COMPLEMENT" 				, "C" , 40 , 00 } ) //06
	aadd( _aCExcel , {"BAIRRO"	   				, "C" , 20 , 00 } ) //07
	aadd( _aCExcel , {"MUNICIPIO"	  			, "C" , 20 , 00 } ) //08
	aadd( _aCExcel , {"UF"     					, "C" , 04 , 00 } ) //09
	aadd( _aCExcel , {"CEP"  					, "C" , 13 , 00 } ) //10
	aadd( _aCExcel , {"NASCIMENTO"	  			, "C" , 12 , 00 } ) //11
	aadd( _aCExcel , {"ADMISSAO"				, "C" , 12,  00 } ) //12
	aadd( _aCExcel , {"VALOR"   	 			, "C" , 20 , 00 } ) //13
	
ELSE
	
	//Giselly solicitou a alteração 26/08/2013
	aadd( _aCExcel , {"MATRICULA"      	 		, "C" , 10 , 00 } ) //01
	aadd( _aCExcel , {"NOME" 					, "C" , 50 , 00 } ) //02
	aadd( _aCExcel , {"NASCIMENTO" 	   			, "C" , 12 , 00 } )	//03
	aadd( _aCExcel , {"CAPITAL"		   			, "C" , 25 , 00 } ) //04
	aadd( _aCExcel , {"APOLICE" 				, "C" , 15 , 00 } ) //05
	aadd( _aCExcel , {"SUB" 					, "C" , 05 , 00 } ) //06
	aadd( _aCExcel , {"SEXO" 					, "C" , 15 , 00 } ) //07
	aadd( _aCExcel , {"VIGENCIA" 				, "C" , 12 , 00 } ) //08
	aadd( _aCExcel , {"MESFAT" 					, "C" , 10 , 00 } ) //09
	aadd( _aCExcel , {"CPF" 					, "C" , 20 , 00 } )	//10
	aadd( _aCExcel , {"ENDERECO"				, "C" , 50,  00 } )	//11
	aadd( _aCExcel , {"BAIRRO"	   				, "C" , 20 , 00 } ) //12
	aadd( _aCExcel , {"MUNICIPIO"	  			, "C" , 20 , 00 } ) //13
	aadd( _aCExcel , {"CEP"  					, "C" , 15 , 00 } )	//14
	aadd( _aCExcel , {"UF"     					, "C" , 04 , 00 } ) //15
	
	/*
	aadd( _aCExcel , {"MATRICULA"      		, "C" , 10 , 00 } )
	aadd( _aCExcel , {"CCUSTO" 				, "C" , 12 , 00 } )
	aadd( _aCExcel , {"NOME" 					, "C" , 50 , 00 } )
	aadd( _aCExcel , {"NASCIMENTO"				, "C" , 12 , 00 } )
	aadd( _aCExcel , {"PREMIO"					, "C" , 30,  00 } )
	aadd( _aCExcel , {"NUMERO"					, "C" , 15 , 00 } )
	aadd( _aCExcel , {"FILIAL"	   				, "C" , 06 , 00 } )
	aadd( _aCExcel , {"SEXO"	  				, "C" , 15 , 00 } )
	aadd( _aCExcel , {"ADMISSAO"     			, "C" , 12 , 00 } )
	aadd( _aCExcel , {"COMPET"			, "C" , 10 , 00 } )
	aadd( _aCExcel , {"CPF"	  				, "C" , 20 , 00 } )
	aadd( _aCExcel , {"CARGO"					, "C" , 25,  00 } )
	*/
	
ENDIF




//_cTemp := CriaTrab(_aCExcel, .T.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)

//SUBTITULO - INCLUIDO PARA FACILITAR A VISUALIZAÇÃO DO USUÁRIO




_aItem := ARRAY(LEN(_aCExcel) + 1)
If MV_PAR07 == 1
	_aItem[2]		:=	Titulo + UPPER(Mes(dData)) + "/" + SUBSTR(DTOS(dData),1,4)
ELSE
	_aItem[2]		:=	"COMPETENCIA - " + SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4) + " TV CAPITAL"
Endif
AADD(_aIExcel,_aItem)
_aItem := {}

DbSelectArea("SRASQL")
Do While SRASQL->(!Eof())
	
	
	
	
	_aItem := ARRAY(LEN(_aCExcel) + 1)
	IF MV_PAR07 == 1
		
		_aItem[1]		:= SRASQL->RA_MAT
		_aItem[2]			:= SRASQL->RA_NOME
		_aItem[3]			:= SRASQL->RA_CIC
		_aItem[4]				:= SRASQL->RA_RG
		_aItem[5]		:=SRASQL->RA_ENDEREC
		_aItem[6]   	:=SRASQL->RA_COMPLEM
		_aItem[7]			:=SRASQL->RA_BAIRRO
		_aItem[8]		:=SRASQL->RA_MUNICIP
		_aItem[9]				:=SRASQL->RA_ESTADO
		_aItem[10]			:= SRASQL->RA_CEP
		_aItem[11]		:=SRASQL->NASCIMENTO
		_aItem[12]		:= SRASQL->ADMISSAO
		_aItem[13]			:= CVALTOCHAR(ROUND(SRASQL->VALOR,2))
		
	ELSE
		
		
		_aItem[1]		:=SRASQL->RA_MAT
		_aItem[2]			:=SRASQL->RA_NOME
		_aItem[3]		:=SRASQL->NASCIMENTO
		_aItem[4]		:= MV_PAR08
		_aItem[5]		:= MV_PAR09
		_aItem[6]			:= SRASQL->RA_FILIAL
		IF SRASQL->RA_SEXO == "F"
			_aItem[7]			:= "FEMININO"
		ELSEIF SRASQL->RA_SEXO == "M"
			_aItem[7]			:= "MASCULINO"
		EndIf
		_aItem[8]		:= "01/" + SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4)
		_aItem[9]			:= SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4)
		_aItem[10]			:= SRASQL->RA_CIC
		_aItem[11]		:= SRASQL->RA_ENDEREC
		_aItem[12]			:= SRASQL->RA_BAIRRO
		_aItem[13]		:= SRASQL->RA_MUNICIP
		_aItem[14]			:= SRASQL->RA_CEP
		_aItem[15]				:= SRASQL->RA_ESTADO
		
		
		
		/*
		--------------------------------------------------
		Giselly solicitou a alteração 26/08/2013
		-------------------------------------------------
		
		_aItem[1]		:=SRASQL->RA_MAT
		TMP->CCUSTO			:=SRASQL->RA_CC
		_aItem[2]			:=SRASQL->RA_NOME
		_aItem[11]		:=SRASQL->NASCIMENTO
		TMP->PREMIO			:=MV_PAR08
		TMP->NUMERO			:=MV_PAR09
		TMP->FILIAL			:=SRASQL->RA_FILIAL
		
		IF SRASQL->RA_SEXO == "F"
		_aItem[20]			:= "FEMININO"
		ELSEIF SRASQL->RA_SEXO == "M"
		_aItem[20]			:= "MASCULINO"
		EndIf
		
		
		_aItem[12]		:= SRASQL->ADMISSAO
		TMP->COMPET	:=SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4)
		_aItem[3]			:=SRASQL->RA_CIC
		TMP->CARGO			:=Posicione("SRJ",1,xFilial("SRJ")+ SRASQL->RA_CODFUNC,"RJ_DESC")
		
		*/
		
	ENDIF
	
	AADD(_aIExcel,_aItem)
	_aItem := {}
	
	
	SRASQL->(DbSkip())
	
	N++
	
	
	
Enddo

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	
	//DbSelectArea("TMP")
	//TMP->(DbCloseArea())
	DbSelectArea("SRASQL")
	SRASQL->(DbCloseArea())
	
	Return
EndIf

//cArq     := _cTemp+".DBF"

//DbSelectArea("TMP")
//TMP->(DbCloseArea())
DbSelectArea("SRASQL")
SRASQL->(DbCloseArea())


//__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

//oExcelApp:= MsExcel():New()
//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
//oExcelApp:SetVisible(.T.)

IF (LEN(_aIExcel) > 0)
	MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
	{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", "Controle de Registros Profissionais - Record DF", _aCExcel, _aIExcel}} ), CURSORARROW() } )
ELSE
	MSGALERT("Nenhum Registro foi encontrado.","RELFUNCEXC")
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

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Matricula	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Matricula	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Mes				","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Da  Filial 		","","","mv_ch04","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"05","Ate Filial 		","","","mv_ch05","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"06","Ordem			","","","mv_ch06","N",01,0,2,"C","","mv_par06","Matricula","","","","","Nome","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Relatorio		","","","mv_ch07","N",01,0,2,"C","","mv_par07","Limite Compras","","","","","Competência","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Premio			","","","mv_ch08","C",14,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Numero			","","","mv_ch09","C",07,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Da  Admissao	","","","mv_ch10","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Ate Admissao	","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Da Dt Demissao	","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Ate Dt Demissao	","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

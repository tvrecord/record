#include "Topconn.ch"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MAPAFIN   ∫ Autor ≥ Edmilson D. Santos ∫ Data ≥  25/03/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ MAPAFIN - Relatorio dos Titulos por natureza               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Clientes Microsiga                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function MAPAFIN()

Local aOrd 			 	:=	{}
Local aRegs        	:= {}
Local aPergs       	:= {}
Local cPict        	:= ""
Local Imprime      	:= .t.
Local cDesc1       	:=	"Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Gerenciamento Financeiro por Natureza"

Private cbtxt      	:=	Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "MAPAFINA"
Private nLin      	:= 80
Private Titulo  	 	:= "MAPA GERENCIAL FINANCEIRO - MENSAL"
Private cabec1  	 	:= ""
Private cabec2  	 	:= ""
Private CbTxt      	:= ""
Private lEnd       	:= .f.
Private lAbortPrint	:= .f.
Private limite     	:= 220
Private tamanho    	:= "G"
Private nomeprog   	:=	"MAPAFIN"
Private nTipo      	:= 15
Private aReturn    	:= { "Zebrado", 01, "Administracao", 01, 02, 01, "", 01}
Private nLastKey   	:= 0
Private cString    	:= "SE2"
Private cPerg      	:= "MAPA12"+space(4)

Private cString , i , ColIni , aQtde , aChave , aTotSub , aNumped , ImprTotal

dbSelectArea("SE2")
dbSetOrder(1)

AjustaSx1(cPerg,@aPergs)

Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,"",,Tamanho,,.t.)

if nLastKey == 27
	Return
endif

SetDefault(aReturn,cString)

if nLastKey == 27
	Return
endif

nTipo := iif( aReturn[4] == 1 , 15 , 18 )

RptStatus( { || RunReport(Cabec1,Cabec2,Titulo) } , Titulo )

Return

/***************************************************************************/

Static Function AjustaSX1(cPerg, aPergs)

Local nCondicao
Local nJ				:= 0
Local nX 			:= 0
Local cKey			:= ""
Local lAltera		:= .f.
Local _sAlias		:= Alias()
Local aCposSX1		:=	{	"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,"X1_TIPO"	,;
"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"	,;
"X1_VAR01"		,"X1_DEF01"		,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,;
"X1_VAR02"		,"X1_DEF02"		,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,;
"X1_VAR03"		,"X1_DEF03"		,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,;
"X1_VAR04"		,"X1_DEF04"		,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,;
"X1_VAR05"		,"X1_DEF05"		,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,;
"X1_F3"			,"X1_GRPSXG"	, "X1_PYME"		,"X1_HELP" 		}

aAdd(aPergs,{"Filial De        	?","","","mv_ch1","C",02,0,1,"G","","mv_par01","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","XM0","",""})
aAdd(aPergs,{"Filial Ate       	?","","","mv_ch2","C",02,0,1,"G","","mv_par02","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","XM0","",""})
aAdd(aPergs,{"Natureza De      	?","","","mv_ch3","C",09,0,1,"G","","mv_par03","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SED","",""})
aAdd(aPergs,{"Natureza Ate     	?","","","mv_ch4","C",09,0,1,"G","","mv_par04","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SED","",""})
aAdd(aPergs,{"Carteira         	?","","","mv_ch5","N",01,0,1,"C","","mv_par05","Receber        ","","","","","Pagar          ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Emissao De       	?","","","mv_ch6","D",08,0,1,"G","","mv_par06","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Emissao Ate      	?","","","mv_ch7","D",08,0,1,"G","","mv_par07","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Vencimento De    	?","","","mv_ch8","D",08,0,1,"G","","mv_par08","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Vencimento Ate   	?","","","mv_ch9","D",08,0,1,"G","","mv_par09","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Imprimir Por     	?","","","mv_chb","N",01,0,1,"C","","mv_par10","Emissao        ","","","","","Vencimento     ","","","","","Entrada","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Imprimir Modo    	?","","","mv_chc","N",01,0,1,"C","","mv_par11","Sintetico      ","","","","","Analitico      ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Imprimir Situacao	?","","","mv_chd","N",01,0,1,"C","","mv_par12","Recebidos/Pagos","","","","","N„o Receb/Pagos","","","","","Ambos","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Totalizar        	?","","","mv_che","N",01,0,1,"C","","mv_par13","Vlr Original   ","","","","","Saldo          ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Excluir Mov.Caixa	?","","","mv_chf","N",01,0,1,"C","","mv_par14","Sim            ","","","","","Nao            ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Tit. Adiant. Compen?","","","mv_chg","N",01,0,1,"C","","mv_par15","Sim            ","","","","","Nao            ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Banco              ?","","","mv_chh","C",03,0,1,"G","","mv_par16","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SA6","",""})
aAdd(aPergs,{"Agencia            ?","","","mv_chi","C",05,0,1,"G","","mv_par17","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Conta              ?","","","mv_chj","C",10,0,1,"G","","mv_par18","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Impostos Terceiros ?","","","mv_chk","N",01,0,1,"C","","mv_par19","Sim            ","","","","","Nao            ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Prefixo De         ?","","","mv_chl","C",03,0,1,"G","","mv_par20","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Prefixo Ate        ?","","","mv_chm","C",03,0,1,"G","","mv_par21","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Entrada De         ?","","","mv_chn","D",08,0,1,"G","","mv_par22","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Entrada Ate        ?","","","mv_cho","D",08,0,1,"G","","mv_par23","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Fora Prefixo       ?","","","mv_chp","C",03,0,1,"G","","mv_par24","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","   ","",""})
aAdd(aPergs,{"Cliente De      	?","","","mv_chq","C",06,0,1,"G","","mv_par25","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SA1","",""})
aAdd(aPergs,{"Cliente Ate     	?","","","mv_chr","C",06,0,1,"G","","mv_par26","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SA1","",""})
aAdd(aPergs,{"Fornecedor De   	?","","","mv_chs","C",06,0,1,"G","","mv_par27","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SA2","",""})
aAdd(aPergs,{"Fornecedor Ate  	?","","","mv_cht","C",06,0,1,"G","","mv_par28","               ","","","","","               ","","","","","     ","","","","","","","","","","","","","","SA2","",""})
aAdd(aPergs,{"Resumido    	?","","","mv_chu","N",01,0,1,"C","","mv_par29","Sim      ","","","","","Nao      ","","","","","     ","","","","","","","","","","","","","","   ","",""})


dbSelectArea("SX1")
dbSetOrder(1)

For nX:=1 to Len(aPergs)
	lAltera := .f.
	if MsSeek(cPerg+Right(aPergs[nX][11], 2))
		if (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .and.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .t.
		endif
	endif
	
	if ! lAltera .and. Found() .and. X1_TIPO <> aPergs[nX][5]
		lAltera := .t.		// Garanto que o tipo da pergunta esteja correto
	endif
	
	if ! Found() .or. lAltera
		RecLock("SX1",If(lAltera, .f., .t.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			if 	Len(aPergs[nX]) >= nJ .and. aPergs[nX][nJ] <> Nil .and.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		if ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		else
			aHelpSpa := {}
		endif
		
		if ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		else
			aHelpEng := {}
		endif
		
		if ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		else
			aHelpPor := {}
		endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	endif
Next

Return (.t.)

/***************************************************************************/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local w
Local t
Local s
Local k
Local xI
Local nTot
Local nCol
Local cTxt
Local cNat
Local nPos
Local nPosP
Local nTemp
Local nPerc
Local nValor
Local nPosN1
Local nPosN2
Local nPosN3
Local dTemp
Local cQuery
Local dIniVen
Local dFimVen
Local dIniEmis
Local dFimEmis
Local nPeriodos

Local nCount		:=	0
Local cFilialI		:=	""
Local aTemp 		:=	{}
Local aTotG			:=	{}
Local aTotN1		:=	{}
Local aTotN2		:=	{}
Local aTotN3		:=	{}
Local aNivel1		:=	{}
Local aNivel2		:=	{}
Local aNivel3		:=	{}
Local aTitulos 	:=	{}
Local aPeriodos	:=	{}
Local lMultiNat	:=	.f.
Local nPis   		:= 0
Local nCofins		:= 0
Local nCsll  		:= 0
Local nIrrf 		:= 0

For t := 12 to 01 Step -1
	aAdd( aTemp , { Nil , Nil , Nil , Nil , StrZero(t,2) } )
Next t

dIniEmis	:=	mv_par06
dFimEmis	:=	mv_par07
dIniVen 	:=  mv_par08
dFimVen 	:=	mv_par09
dIniEnt     :=  mv_par22
dFimEnt     :=  mv_par23

if mv_par10 == 1           	// Por Emiss„o
	
	dTemp   	:=	iif( mv_par07 > dDataBase , dDataBase , mv_par07 )
	
	For t := 1 to Len(aTemp)
		aTemp[t,01]	:=	Year(dTemp)
		aTemp[t,02]	:=	Month(dTemp)
		aTemp[t,03]	:=	PriDia(dTemp)
		aTemp[t,04]	:=	UltDia(dTemp)
		
		if	aTemp[t,03]	<  dIniEmis
			aTemp[t,03]	:=	dIniEmis
		endif
		
		if	aTemp[t,04]	>  dFimEmis
			aTemp[t,04]	:=	dFimEmis
		endif
		
		dTemp	:=	( PriDia(dTemp) - 1 )
		
		if	dTemp < dIniEmis
			Exit
		endif
	Next t
	
elseif mv_par10 == 2      	// Por Vencimento
	
	dTemp   	:=	iif( mv_par09 > dDataBase , dDataBase , mv_par09 )
	
	For t := 1 to Len(aTemp)
		aTemp[t,01]	:=	Year(dTemp)
		aTemp[t,02]	:=	Month(dTemp)
		aTemp[t,03]	:=	PriDia(dTemp)
		aTemp[t,04]	:=	UltDia(dTemp)
		
		if	aTemp[t,03]	<  dIniVen
			aTemp[t,03]	:=	dIniVen
		endif
		
		if	aTemp[t,04]	>  dFimVen
			aTemp[t,04]	:=	dFimVen
		endif
		
		dTemp	:=	( PriDia(dTemp) - 1 )
		
		if	dTemp < dIniVen
			Exit
		endif
	Next t
	
elseif mv_par10 == 3      	// Por Entrada
	
	dTemp   	:=	iif( mv_par23 > dDataBase , dDataBase , mv_par23 )
	
	For t := 1 to Len(aTemp)
		aTemp[t,01]	:=	Year(dTemp)
		aTemp[t,02]	:=	Month(dTemp)
		aTemp[t,03]	:=	PriDia(dTemp)
		aTemp[t,04]	:=	UltDia(dTemp)
		
		if	aTemp[t,03]	<  dIniEnt
			aTemp[t,03]	:=	dIniEnt
		endif
		
		if	aTemp[t,04]	>  dFimEnt
			aTemp[t,04]	:=	dFimEnt
		endif
		
		dTemp	:=	( PriDia(dTemp) - 1 )
		
		if	dTemp < dIniEnt
			Exit
		endif
	Next t
	
endif

aTemp := aSort( aTemp ,,, { |x,y| x[05] < y[05] } )

For t := 1 to Len(aTemp)
	if	aTemp[t,01] <> Nil
		aAdd( aPeriodos , { aTemp[t,01] , aTemp[t,02] , aTemp[t,03] , aTemp[t,04] } )
	endif
Next t

nPeriodos   :=	Len(aPeriodos)

if	nPeriodos > 1
	cTxt	:=	Chr(13) + Chr(10)
	cTxt	+=	"O Relatorio Ir· Imprimir o PerÌodo de "
	cTxt 	+=	Substr(DtoS(aPeriodos[01,03]),05,02) + "/"
	cTxt	+=	Substr(DtoS(aPeriodos[01,03]),01,04) + " a "
	cTxt 	+=	Substr(DtoS(aPeriodos[Len(aPeriodos),04]),05,02) + "/"
	cTxt	+=	Substr(DtoS(aPeriodos[Len(aPeriodos),04]),01,04) + " por Emissao !!!"
	
	Aviso( "AtenÁ„o" , cTxt , {"Ok"} , 3 , "PerÌodo de Impress„o" )
endif

IF MV_PAR10 <> 3 // INCLUIDO POR JACKSON MACIEL
	Cabec1		:=	"PERIODO DOS TITULOS : Emissao de " + DtoC(mv_par06) + " a " + DtoC(mv_par07) + " - "
ELSE
	Cabec1		:=	"PERIODO DOS TITULOS : Entrada de " + DtoC(mv_par22) + " a " + DtoC(mv_par23) + " - " // JACKSON MACIEL
ENDIF

Cabec1		+=	"Vencimento de " + DtoC(mv_par08) + " a " + DtoC(mv_par09) + "   "
Cabec1		+=	"Situacao: "

if	mv_par12 == 1
	Cabec1	+=	iif( mv_par05 == 2 , "Pagos" 		, "Recebidos" 		)
elseif	mv_par12 == 2
	Cabec1	+=	iif( mv_par05 == 2 , "N„o Pagos"	, "N„o Recebidos" )
else
	Cabec1	+=	"Ambos"
endif

Cabec1		+=	Space(20) + " Carteira: " + iif( mv_par05 == 2 , "PAGAR  " , "RECEBER" ) + Space(03)

if	!Empty(mv_par16) .and. !Empty(mv_par17) .and. !Empty(mv_par18)
	Cabec1	+=	"Banco: " + mv_par16 + Space(05) + "Agencia: " + mv_par17 + Space(05) + "Conta :" + mv_par18
else
	Cabec1	+=	"Banco: Ambos    Agencia: Ambas    C/C : Ambas"
endif

if mv_par05 == 2
	
	dbSelectArea("SE2")
	
	cQuery	:=	" SELECT E2_FILIAL   AS FILIAL   , "
	cQuery	+=			"  E2_PREFIXO  AS PREFIXO  , "
	cQuery	+=			"  E2_NUM      AS NUMERO   , "
	cQuery	+=			"  E2_PARCELA  AS PARCELA  , "
	cQuery	+=			"  E2_TIPO     AS TIPO     , "
	cQuery	+=			"  E2_EMISSAO  AS EMISSAO  , "
	cQuery	+=			"  E2_VENCREA  AS VENCTO   , "
	cQuery	+=			"  E2_NATUREZ  AS NATUREZA , "
	cQuery	+=			"  E2_VALOR    AS VALOR    , "
	cQuery	+=			"  E2_VALLIQ   AS VALLIQ   , "	//
	cQuery	+=			"  E2_ISS      AS ISS      , "   //
	If MV_PAR10 = 3
		cQuery	+=			"  E2_EMIS1 AS ENTRADA , "   //
	Endif
	IF SE2->(FieldPos("E2_VRETIRF")) > 0
		cQuery	+= 	"  E2_VRETIRF  AS IRRF     , "   //
	ELSE
		cQuery	+=		"  E2_IRRF     AS IRRF     , "   //
	ENDIF
	
	cQuery	+=			"  E2_INSS     AS INSS     , "   //
	cQuery	+=			"  E2_SEST     AS SEST     , "   //
	cQuery	+=			"  E2_VRETPIS  AS PIS      , "   //
	cQuery	+=			"  E2_VRETCOF  AS COFINS   , "   //
	cQuery	+=			"  E2_VRETCSL  AS CSLL     , "   //
	cQuery	+=			"  E2_SALDO    AS SALDO    , "
	cQuery	+=			"  E2_MULTNAT  AS MULTNAT  , "
	cQuery	+=			"  'P'         AS RECPAG   , "
	cQuery	+=			"  E2_FORNECE  AS CLIFOR   , "
	cQuery	+=			"  E2_LOJA     AS LOJA     , "
	cQuery	+=			"  E2_ORIGEM   AS ORIGEM   , "
	cQuery	+=			"  R_E_C_N_O_  AS RECNOS     "
	cQuery 	+=	" FROM " + RetSqlName("SE2")
	cQuery 	+=	" WHERE E2_FILIAL  BETWEEN '" + mv_par01			+ "' AND '" + mv_par02			+ "' AND "
	cQuery 	+=			" E2_NATUREZ BETWEEN '" + mv_par03			+ "' AND '" + mv_par04			+ "' AND "
	cQuery 	+=			" E2_PREFIXO BETWEEN '" + mv_par20			+ "' AND '" + mv_par21			+ "' AND "
	cQuery 	+=			" E2_FORNECE BETWEEN '" + mv_par27			+ "' AND '" + mv_par28			+ "' AND " //Bruno Alves
	cQuery 	+=			" E2_PREFIXO <> '" + mv_par24 + "' AND "
	IF MV_PAR10 <>3
		cQuery 	+=			" E2_EMISSAO BETWEEN '" + DtoS(mv_par06)	+ "' AND '" + DtoS(mv_par07)	+ "' AND "
		cQuery 	+=			" E2_VENCREA BETWEEN '" + DtoS(mv_par08) 	+ "' AND '" + DtoS(mv_par09) 	+ "' AND "
	Endif
	If MV_PAR10=3
		cQuery 	+=			" E2_EMIS1 BETWEEN '" + DtoS(mv_par22) 	    + "' AND '" + DtoS(mv_par23) 	+ "' AND "   // INCLUIDO POR JACKSON
	Endif
	if mv_par14 == 1
		//	   cQuery 	+= " ( Substr(e2_bcopag,1,1) <> 'C'"	 				// Rotina Adicionada por Klaus em 13/07/2007 pelo motivo acima.
		cQuery 	+= " ( SUBSTRING(e2_bcopag,1,1) NOT IN ('C','R')"	 				// Rotina alterada por Marcio T. Suzaki em 19/11/08 devido ao
		cQuery 	+= "   or ( select count(1)"                            // caixinha da Radio Capital ter saido do padr„o de cadastramento
		cQuery 	+= "        from " + RetSqlName("SE5")
		cQuery 	+= "        where e5_filial  = e2_filial"
		cQuery 	+= "          and e5_prefixo = e2_prefixo"
		cQuery 	+= "          and e5_numero  = e2_num"
		cQuery 	+= "          and e5_parcela = e2_parcela"
		cQuery 	+= "          and e5_tipo    = e2_tipo"
		cQuery 	+= "          and e5_clifor = e2_fornece" //Incluido por Cristiano Alves em 08/03/08
		cQuery 	+= "          and e5_loja = e2_loja"
		cQuery 	+= "          and d_e_l_e_t_ = ' ') > 1 ) and " 	// Fim da inclusao por Klaus em 13/07/2007
	endif
	
	if	mv_par12 <> 3
		cQuery		+=	iif( mv_par12 == 1 , " E2_SALDO = 0 AND " , " E2_SALDO > 0 AND " )
	endif
	
	if !Empty(mv_par16) .and. !Empty(mv_par17) .and. !Empty(mv_par18)
		cQuery 	+= " E2_PORTADO = '" + mv_par16 + "' AND "
		cQuery 	+= " E2_AGEDEP  = '" + mv_par17 + "' AND "
		cQuery 	+= " E2_NUMCON  = '" + mv_par18 + "' AND "
	endif
	
	cQuery 	+= "       D_E_L_E_T_  = ' '"
	IF MV_PAR10 <> 3  // INCLUIDO POR JACKSON MACIEL
		cQuery 	+= " ORDER BY E2_FILIAL,E2_NATUREZ,E2_EMISSAO,E2_VENCREA "
	Else
		cQuery 	+= " ORDER BY E2_FILIAL,E2_NATUREZ,E2_EMIS1,E2_VENCREA " // JACKSON MACIL
	Endif
	//MemoWrite("c:\mapafin.sql",cQuery)
else
	
	dbSelectArea("SE1")
	
	cQuery 	:=	" SELECT E1_FILIAL   AS FILIAL   , "
	cQuery	+=			"  E1_PREFIXO  AS PREFIXO  , "
	cQuery	+=			"  E1_NUM      AS NUMERO   , "
	cQuery	+=			"  E1_PARCELA  AS PARCELA  , "
	cQuery	+=			"  E1_TIPO     AS TIPO     , "
	cQuery	+=			"  E1_EMISSAO  AS EMISSAO  , "
	cQuery	+=			"  E1_VENCREA  AS VENCTO   , "
	cQuery	+=			"  E1_NATUREZ  AS NATUREZA , "
	cQuery	+=		   "  E1_VALOR    AS VALOR    , "
	cQuery	+=			"  E1_VALLIQ   AS VALLIQ   , "	//
	cQuery	+=			"  E1_ISS      AS ISS      , "   //
	cQuery	+=			"  E1_IRRF     AS IRRF     , "   //
	cQuery	+=			"  E1_INSS     AS INSS     , "   //
//	cQuery	+=			"  E1_SEST     AS SEST     , "   //
	cQuery	+=			"  E1_PIS      AS PIS      , "   //
	cQuery	+=			"  E1_COFINS   AS COFINS   , "   //
	cQuery	+=			"  E1_CSLL     AS CSLL     , "   //
	cQuery	+=			"  E1_SALDO    AS SALDO    , "
	cQuery	+=			"  E1_MULTNAT  AS MULTNAT  , "
	cQuery	+=			"  'R'         AS RECPAG   , "
	cQuery	+= 		"  E1_CLIENTE  AS CLIFOR   , "
	cQuery	+=			"  E1_LOJA     AS LOJA     , "
	cQuery	+=			"  E1_ORIGEM   AS ORIGEM   , "
	cQuery	+=			"  R_E_C_N_O_  AS RECNOS     "
	cQuery 	+=	" FROM " + RetSqlName("SE1")
	cQuery 	+=	" WHERE E1_FILIAL  BETWEEN '" + mv_par01			+ "' AND '" + mv_par02			+ "' AND "
	cQuery 	+=			" E1_NATUREZ BETWEEN '" + mv_par03			+ "' AND '" + mv_par04			+ "' AND "
	cQuery 	+=			" E1_EMISSAO BETWEEN '" + DtoS(mv_par06) 	+ "' AND '" + DtoS(mv_par07) 	+ "' AND "
	cQuery 	+=			" E1_VENCREA BETWEEN '" + DtoS(mv_par08) 	+ "' AND '" + DtoS(mv_par09) 	+ "' AND "
	cQuery 	+=			" E1_CLIENTE BETWEEN '" + mv_par25 	+ "' AND '" + mv_par26 	+ "' AND "
	cQuery 	+=			" D_E_L_E_T_ = ' ' "
	if	mv_par12 <> 3
		cQuery	+=	iif( mv_par12 == 1 , "  AND E1_SALDO = 0 " , "  AND E1_SALDO > 0 " )		// Verificar
	endif
	cQuery 	+=	" ORDER BY E1_FILIAL,E1_NATUREZ,E1_EMISSAO,E1_VENCREA "
endif

cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "TMAP"

dbSelectArea("TMAP")

Count to nCount

dbSelectArea("TMAP")
dbGoTop()
SetRegua(nCount)

While !TMAP->(Eof())
	
	IncRegua()
	
	IF MV_PAR10 <> 3   // JACKSON
		dTemp	:=	iif( mv_par10 == 1 , StoD(TMAP->EMISSAO) , StoD(TMAP->VENCTO) )
		
	Else
		dTemp := Stod(TMAP->ENTRADA)
	Endif
	
	nPosP	:= aScan( aPeriodos , { |x| x[03] <= dTemp .and. x[04] >= dTemp } )
	
	if nPosP == 0 .or. ( mv_par15 == 2 .and. TMAP->TIPO == iif(mv_par05 == 1,"RA ","PA ") .and. TMAP->SALDO == 0 )
		TMAP->(dbSkip())
		Loop
	endif
	//Impostos de terceiros
	if	Substr(TMAP->NATUREZA,01,04) == '1203' .and. mv_par19 == 2
		//Carteira pagar e
		if mv_par05 == 2 .and. Upper(Alltrim(TMAP->ORIGEM)) <> 'FINA050'
			TMAP->(dbSkip())
			Loop
		endif
	endif
	
	lMultiNat := iif( TMAP->MULTNAT == "1" , .t. , .f. )
	
	if	lMultiNat
		//lMiltinat := .t.	//Alterado por Cristiano Alves em 08/03/08
		lMultiNat := .f.    //Alterado por Cristiano Alves em 08/03/08
		
		cQuery 	:= " Select * "
		cQuery 	+= " From " + RetSqlName("SEV")
		cQuery 	+= " Where EV_FILIAL  = '" + xFilial("SEV",TMAP->FILIAL)	+ "' and "
		cQuery 	+= 		"  EV_PREFIXO = '" + TMAP->PREFIXO						+ "' and "
		cQuery 	+= 		"  EV_NUM     = '" + TMAP->NUMERO 						+ "' and "
		cQuery 	+= 		"  EV_PARCELA = '" + TMAP->PARCELA						+ "' and "
		cQuery 	+= 		"  EV_TIPO    = '" + TMAP->TIPO   						+ "' and "
		cQuery 	+= 		"  EV_CLIFOR  = '" + TMAP->CLIFOR 						+ "' and "
		cQuery 	+= 		"  EV_LOJA    = '" + TMAP->LOJA   						+ "' and "
		cQuery 	+= 		"  EV_RECPAG  = '" + TMAP->RECPAG 						+ "' and "
		cQuery 	+= 		"  D_E_L_E_T_ = ' '"
		//MemoWrite("c:\multnat1.sql",cQuery)
		cQuery 	:= ChangeQuery(cQuery)
		
		TcQuery cQuery New Alias "MULT"
		
		Do While MULT->(!Eof()) .and. !lMultiNat
			//lMiltinat := .t.	//Alterado por Cristiano Alves em 08/03/08
			lMultinat := .t.	//Alterado por Cristiano Alves em 08/03/08
			MULT->(dbskip())
		EndDo
		
		MULT->(dbclosearea())
	endif
	
	// N„o Tem M˙ltiplas Naturezas
	
	if	!lMultiNat
		
		if	mv_par13 == 1
			nValor	:=	TMAP->VALOR// - TMAP->(PIS + COFINS + CSLL) //Rafael
		else
			nValor	:=	TMAP->SALDO
		endif
		
		// Verifico no Primeiro NÌvel
		
		nPosN1 := aScan( aNivel1 , { |x| x[01] == TMAP->FILIAL .and. x[02] == Substr(TMAP->NATUREZA,01,02) } )
		
		if	nPosN1 == 0
			aAdd( aNivel1 , Array( nPeriodos + 2 ) )
			nPosN1 := Len( aNivel1 )
			For w := 1 to ( nPeriodos + 2 )
				aNivel1[nPosN1,w]	:=	0.00
			Next w
			aNivel1[nPosN1,01]		:=	TMAP->FILIAL
			aNivel1[nPosN1,02]		:=	Substr(TMAP->NATUREZA,01,02)
		endif
		
		aNivel1[nPosN1,nPosP + 2]	+=	nValor
		
		// Verifico no Segundo NÌvel
		
		nPosN2 := aScan( aNivel2 , { |x| x[01] == TMAP->FILIAL 						.and. ;
		x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
		x[03] == Substr(TMAP->NATUREZA,01,04) 	} )
		
		if	nPosN2 == 0
			aAdd( aNivel2 , Array( nPeriodos + 3 ) )
			nPosN2 := Len( aNivel2 )
			For w := 1 to ( nPeriodos + 3 )
				aNivel2[nPosN2,w]	:=	0.00
			Next w
			aNivel2[nPosN2,01]	:=	TMAP->FILIAL
			aNivel2[nPosN2,02]	:=	Substr(TMAP->NATUREZA,01,02)
			aNivel2[nPosN2,03]	:=	Substr(TMAP->NATUREZA,01,04)
		endif
		
		aNivel2[nPosN2,nPosP + 3]	+=	nValor
		
		// Verifico no Terceiro NÌvel
		
		nPosN3 := aScan( aNivel3 , { |x| x[01] == TMAP->FILIAL 						.and. ;
		x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
		x[03] == Substr(TMAP->NATUREZA,01,04) 	.and. ;
		x[04] == TMAP->NATUREZA 					} )
		
		if	nPosN3 == 0
			aAdd( aNivel3 , Array( nPeriodos + 4 ) )
			nPosN3 := Len( aNivel3 )
			For w := 1 to ( nPeriodos + 4 )
				aNivel3[nPosN3,w]	:=	0.00
			Next w
			aNivel3[nPosN3,01]	:=	TMAP->FILIAL
			aNivel3[nPosN3,02]	:=	Substr(TMAP->NATUREZA,01,02)
			aNivel3[nPosN3,03]	:=	Substr(TMAP->NATUREZA,01,04)
			aNivel3[nPosN3,04]	:=	TMAP->NATUREZA
		endif
		
		aNivel3[nPosN3,nPosP + 4]	+=	nValor
		
		if	TMAP->(PIS + COFINS + CSLL) == 0
			aAdd( aTitulos ,	{	TMAP->FILIAL 			,	TMAP->NATUREZA			,	TMAP->PREFIXO			,;
			TMAP->NUMERO 			,	TMAP->PARCELA			,	TMAP->TIPO				,;
			TMAP->CLIFOR			, 	TMAP->LOJA				,	TMAP->EMISSAO			,;
			TMAP->VENCTO			,	TMAP->RECNOS			,	"N"						,;
			TMAP->VALOR 			,  TMAP->SALDO 			})
		else
			aAdd( aTitulos ,	{	TMAP->FILIAL 			,	TMAP->NATUREZA			,	TMAP->PREFIXO			,;
			TMAP->NUMERO 			,	TMAP->PARCELA			,	TMAP->TIPO				,;
			TMAP->CLIFOR			, 	TMAP->LOJA				,	TMAP->EMISSAO			,;
			TMAP->VENCTO			,	TMAP->RECNOS			,	"N"						,;
			TMAP->VALOR 			,  TMAP->SALDO 			})	//Rafael
			//TMAP->VALOR - TMAP->(PIS + COFINS + CSLL)		,  TMAP->SALDO 			})					
		endif
		
	else
		
		nPos		:=	0
		aTemp 	:=	{}
		nValor	:=	0//TMAP->(PIS + COFINS + CSLL) Rafael
		
		cQuery 	:= " Select * "
		cQuery 	+= " From " + RetSqlName("SEV")
		cQuery 	+= " Where EV_FILIAL  = '" + xFilial("SEV",TMAP->FILIAL)	+ "' and "
		cQuery 	+= 		"  EV_PREFIXO = '" + TMAP->PREFIXO						+ "' and "
		cQuery 	+= 		"  EV_NUM     = '" + TMAP->NUMERO 						+ "' and "
		cQuery 	+= 		"  EV_PARCELA = '" + TMAP->PARCELA						+ "' and "
		cQuery 	+= 		"  EV_TIPO    = '" + TMAP->TIPO   						+ "' and "
		cQuery 	+= 		"  EV_CLIFOR  = '" + TMAP->CLIFOR 						+ "' and "
		cQuery 	+= 		"  EV_LOJA    = '" + TMAP->LOJA   						+ "' and "
		cQuery 	+= 		"  EV_RECPAG  = '" + TMAP->RECPAG 						+ "' and "
		cQuery 	+= 		"  D_E_L_E_T_ = ' '"
		//MemoWrite("c:\mapafin2.sql",cQuery)
		cQuery 	:= ChangeQuery(cQuery)
		
		TcQuery cQuery New Alias "MULT"
		
		aEval( SEV->(dbstruct()) , { |x| iif( x[2] <> "C" , TcSetField("MULT",x[1],x[2],x[3],x[4]) , Nil ) } )
		
		do while MULT->(!Eof())
			
			nPos := aScan( aTemp , { |x| x[1] == MULT->EV_NATUREZ } )
			
			if	nPos == 0
				aAdd( aTemp , { MULT->EV_NATUREZ , MULT->EV_VALOR , iif( TMAP->SALDO == 0 , 0 , MULT->EV_VALOR ) })
				nPos := Len(aTemp)
			else
				aTemp[nPos,2] 	+=	MULT->EV_VALOR
				aTemp[nPos,3]	+=	iif( TMAP->SALDO <> 0 , MULT->EV_VALOR , 0 )
			endif
			
			if	nValor > 0
				nTemp	:=	Round( nValor * MULT->EV_PERC , 2 )
				nTemp	:=	iif( nTemp >= nValor , nValor , nTemp )
				
				aTemp[nPos,2]	-=	nTemp
				aTemp[nPos,3]	-=	iif( TMAP->SALDO <> 0 , nTemp , 0 )
				
				nValor -= nTemp
			endif
			
			MULT->(dbskip())
		enddo
		
		MULT->(dbclosearea())
		
		if	nValor <> 0 .and. nPos <> 0
			aTemp[nPos,2]	-=	nValor
			aTemp[nPos,3]	-=	iif( TMAP->SALDO <> 0 , nValor , 0 )
		endif
		
		// Verifico se imprime por saldo e se h· baixas parciais
		
		if	mv_par13 == 2 .and. TMAP->SALDO <> TMAP->VALOR .and. TMAP->SALDO <> 0
			
			nTemp	:= TMAP->SALDO
			nPerc := ( TMAP->SALDO / TMAP->VALOR )
			
			For xI := 1 to Len(aTemp)
				
				aTemp[xI,3] := aTemp[xI,2] * nPerc
				
				nTemp -= aTemp[xI,3]
				
				if	xI == Len(aTemp) .and. nTemp <> 0
					aTemp[xI,3] -= nTemp
				endif
			Next xI
		endif
		
		For t := 1 to Len(aTemp)
			
			if	aTemp[t,01] < mv_par03 .or. aTemp[t,01] > mv_par04
				Loop
			endif
			
			// Verifico no Primeiro NÌvel
			
			nPosN1 := aScan( aNivel1 , { |x| x[01] == TMAP->FILIAL .and. x[02] == Substr(aTemp[t,01],01,02) } )
			
			if	nPosN1 == 0
				aAdd( aNivel1 , Array( nPeriodos + 2 ) )
				nPosN1 := Len( aNivel1 )
				For w := 1 to ( nPeriodos + 2 )
					aNivel1[nPosN1,w]	:=	0.00
				Next w
				aNivel1[nPosN1,01]		:=	TMAP->FILIAL
				aNivel1[nPosN1,02]		:=	Substr(aTemp[t,01],01,02)
			endif
			
			aNivel1[nPosN1,nPosP + 2]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			
			// Verifico no Segundo NÌvel
			
			nPosN2 := aScan( aNivel2 , { |x| x[01] == TMAP->FILIAL 						.and. ;
			x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
			x[03] == Substr(aTemp[t,01],01,04) 		} )
			
			if	nPosN2 == 0
				aAdd( aNivel2 , Array( nPeriodos + 3 ) )
				nPosN2 := Len( aNivel2 )
				For w := 1 to ( nPeriodos + 3 )
					aNivel2[nPosN2,w]	:=	0.00
				Next w
				aNivel2[nPosN2,01]	:=	TMAP->FILIAL
				aNivel2[nPosN2,02]	:=	Substr(aTemp[t,01],01,02)
				aNivel2[nPosN2,03]	:=	Substr(aTemp[t,01],01,04)
			endif
			
			aNivel2[nPosN2,nPosP + 3]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			
			// Verifico no Terceiro NÌvel
			
			nPosN3 := aScan( aNivel3 , { |x| x[01] == TMAP->FILIAL 						.and. ;
			x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
			x[03] == Substr(aTemp[t,01],01,04) 		.and. ;
			x[04] == aTemp[t,01]							} )
			
			if	nPosN3 == 0
				aAdd( aNivel3 , Array( nPeriodos + 4 ) )
				nPosN3 := Len( aNivel3 )
				For w := 1 to ( nPeriodos + 4 )
					aNivel3[nPosN3,w]	:=	0.00
				Next w
				aNivel3[nPosN3,01]	:=	TMAP->FILIAL
				aNivel3[nPosN3,02]	:=	Substr(aTemp[t,01],01,02)
				aNivel3[nPosN3,03]	:=	Substr(aTemp[t,01],01,04)
				aNivel3[nPosN3,04]	:=	aTemp[t,01]
			endif
			
			aNivel3[nPosN3,nPosP + 4]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			
			aAdd( aTitulos ,	{	TMAP->FILIAL 			,	aTemp[t,01]				,	TMAP->PREFIXO			,;
			TMAP->NUMERO 			,	TMAP->PARCELA			,	TMAP->TIPO				,;
			TMAP->CLIFOR			, 	TMAP->LOJA				,	TMAP->EMISSAO			,;
			TMAP->VENCTO			,	TMAP->RECNOS			,	"S"						,;
			aTemp[t,02] 			,  aTemp[t,03]				})
			
		Next t
	endif
	
	TMAP->(dbskip())
enddo

TMAP->(dbclosearea())

aNivel1	:=	aSort( aNivel1 ,,, { |x,y| x[01] + x[02] < y[01] + y[02] } )
aNivel2	:=	aSort( aNivel2 ,,, { |x,y| x[01] + x[02] + x[03] < y[01] + y[02] + y[03] } )
aNivel3	:=	aSort( aNivel3 ,,, { |x,y| x[01] + x[02] + x[03] + x[04] < y[01] + y[02] + y[03] + y[04] } )


if mv_par10 == 1 		// Por Emiss„o
	aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[01] + x[09] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
	y[01] + y[09] + y[02] + y[03] + y[04] + y[05] + y[06] } )
else
	aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[01] + x[10] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
	y[01] + y[10] + y[02] + y[03] + y[04] + y[05] + y[06] } )
endif

if	Len(aNivel1) > 0
	
	cFilialI	:=	aNivel1[01,01]
	aTotN1 	:=	{ { "T O T A I S" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 } }
	nLin 		:=	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
	
	ImprSubCab(aPeriodos,nPeriodos,@nLin)
	
	For t := 1 to Len(aNivel1)
		
		if	cFilialI	<> aNivel1[t,01] .or. nLin > 55
			
			if	cFilialI	<> aNivel1[t,01]
				
				nLin ++
				
				nCol := 36
				
				@ ++ nLin , 006 psay "T O T A I S"
				
				For k := 2 to 13
					if	aTotN1[ 01 , k ] <> 0
						@ nLin , nCol psay Transform( aTotN1[ 01 , k ] , "@e 99,999,999.99" )
					endif
					
					nCol += 14
				Next k
				
				@ nLin , 204 psay Transform( aTotN1[ 01 , 14 ] , "@e 99,999,999.99" )
				
				cFilialI	:=	aNivel1[t,01]
				aTotN1 	:=	{ { "T O T A I S" , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 } }
			endif
			
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
			
			ImprSubCab(aPeriodos,nPeriodos,@nLin)
		endif
		
		aAdd( aTotN1 , { aNivel1[t,01] , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 } )
		
		cTxt 	:=	aNivel1[t,02] + " "
		cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel1[t,02] , "ED_DESCRIC" ) , 01 , 25 )
		
		@ nLin , 000 psay cTxt
		
		nCol := 36
		
		For k := 1 to nPeriodos
			
			if	aNivel1[ t , k + 2 ] <> 0
				@ nLin , nCol psay Transform( aNivel1[ t , k + 2 ] , "@e 99,999,999.99" )
			endif
			
			nCol += 14
			
			aTotN1[ 01 , k + 1 ]				+=	aNivel1[ t , k + 2 ]
			aTotN1[ 01 , 14    ]				+=	aNivel1[ t , k + 2 ]
			
			aTotN1[ Len(aTotN1) , k + 1 ]	+=	aNivel1[ t , k + 2 ]
			aTotN1[ Len(aTotN1) , 14    ]	+=	aNivel1[ t , k + 2 ]
			
		Next k
		
		@ nLin , 204 psay Transform( aTotN1[ Len(aTotN1) , 14 ] , "@e 99,999,999.99" )
		If MV_PAR29 == 2		// Bruno
			nLin ++
		EndIf
		
		if	nLin > 55
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
			
			ImprSubCab(aPeriodos,nPeriodos,@nLin)
		endif
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
		//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
		//  0000000 XXXXXXXXXXXXXXXXXXXXXXXXX 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99 99,999,999.99
		//  Codigo  Descricao da Natureza          Abr/2008      Mai/2008                                                                                                                                                     TOTAL
		
		For w := 1 to Len(aNivel2)
			
			if	aNivel1[t,01] == aNivel2[w,01] .and. aNivel1[t,02] == aNivel2[w,02]
				
				nTot 	:= 0
				nCol 	:= 36
				cTxt 	:=	aNivel2[w,03] + " "
				cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel2[w,03] , "ED_DESCRIC" ) , 01 , 25 )
				
				@ ++ nLin , 001 psay cTxt
				
				For k := 1 to nPeriodos
					
					if	aNivel2[ w , k + 3 ] <> 0
						@ nLin , nCol psay Transform( aNivel2[ w , k + 3 ] , "@e 99,999,999.99" )
					endif
					
					nCol += 14
					nTot += aNivel2[ w , k + 3 ]
				Next k
				
				@ nLin , 204 psay Transform( nTot , "@e 99,999,999.99" )
				
				if	nLin > 55
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
					
					ImprSubCab(aPeriodos,nPeriodos,@nLin)
				endif
				
				nLin ++
				
				if	nLin > 55
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
					
					ImprSubCab(aPeriodos,nPeriodos,@nLin)
				endif
				iF MV_PAR29 = 2 // Resumido, imprime somente os totalizadores dos 4 primeiros digitos da natureza responsavel - Bruno Alves 18/07/2013
					For s := 1 to Len(aNivel3)
						
						if	aNivel2[w,01] == aNivel3[s,01] .and. aNivel2[w,02] == aNivel3[s,02] .and. aNivel2[w,03] == aNivel3[s,03]
							
							nTot 	:= 0
							nCol 	:= 36
							cTxt 	:=	Alltrim(aNivel3[s,04]) + " "
							cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel3[s,04] , "ED_DESCRIC" ) , 01 , 25 )
							
							if	( nLin + 1 ) > 55
								nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
								
								ImprSubCab(aPeriodos,nPeriodos,@nLin)
							endif
							
							@ ++ nLin , 002 psay cTxt
							
							For k := 1 to nPeriodos
								
								if	aNivel3[ s , k + 4 ] <> 0
									@ nLin , nCol psay Transform( aNivel3[ s , k + 4 ] , "@e 99,999,999.99" )
								endif
								
								nCol += 14
								nTot += aNivel3[ s , k + 4 ]
							Next k
							
							@ nLin , 204 psay Transform( nTot , "@e 99,999,999.99" )
							
							if	nLin > 55
								nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
								
								ImprSubCab(aPeriodos,nPeriodos,@nLin)
							endif
							
							if	mv_par11 == 2  //Analitico
								
								nLin ++
								
								if	( nLin + 1 ) >= 55
									nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
									
									ImprSubCab(aPeriodos,nPeriodos,@nLin)
								endif
								
								@ ++ nLin , 002 psay "Prf Numero Par  Tip  Codigo        Nome                           Emiss„o   Vecto     Pagto     Entrada      Vlr Liquido            Saldo  Historico       "
								
								//  XXX-999999-AAA  XXX  999999/99  XXXXXXXXXXXXXXXXXXXX  99/99/9999  99/99/9999  99/99/9999  9999  9,999,999.99  9,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXX
								//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
								//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
								
								nLin ++
								
								For k := 1 to Len(aTitulos)
									
									if	aTitulos[k,01] == aNivel3[s,01] .and. aTitulos[k,02] == aNivel3[s,04]
										
										if	nLin > 55
											nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
											
											ImprSubCab(aPeriodos,nPeriodos,@nLin)
											
											cTxt 	:=	aNivel3[s,04] + " "
											cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel3[s,04] , "ED_DESCRIC" ) , 01 , 25 )
											
											@    nLin , 002 psay cTxt + " >> Em continuaÁ„o << "
											
											nLin ++
											
											@ ++ nLin , 002 psay "Prf Numero Par  Tip  Codigo        Nome                           Emiss„o   Vecto     Pagto     Entrada      Vlr Liquido            Saldo  Historico       "
											
											nLin ++
										endif
										
										if	mv_par05 == 2
											
											SE2->(dbgoto(aTitulos[k,11]))
											
											nLin ++
											
											if	aTitulos[k,12] == "S"
												@ nLin,001 psay "*"
											endif
											
											cTxt	:=	SE2->E2_PREFIXO + "-" + SE2->E2_NUM + "-" + SE2->E2_PARCELA
											cTxt	+=	"  " + SE2->E2_TIPO + "  " + SE2->E2_FORNECE + "/" + SE2->E2_LOJA
											cTxt	+=	"  " + SE2->E2_NOMFOR
											
											@ nLin,002 psay cTxt
											@ nLin,066 psay DtoC(SE2->E2_EMISSAO)
											@ nLin,076 psay DtoC(SE2->E2_VENCREA)
											@ nLin,086 psay DtoC(SE2->E2_BAIXA)
											@ nLin,096 psay DtoC(SE2->E2_EMIS1)
											
											/*
											if	Empty(SE2->E2_BAIXA) .and. SE2->E2_VENCREA < dDatabase
											@ nLin,092 psay Transform( SE2->E2_VENCREA - dDatabase , "@E 9999" )
											endif
											
											if	!Empty(SE2->E2_BAIXA)
											@ nLin,092 psay Transform( SE2->E2_VENCREA - SE2->E2_BAIXA , "@E 9999" )
											endif
											*/
											if	aTitulos[k,12] == "N"
												
												nPis   	:= SE2->E2_VRETPIS
												nCofins	:= SE2->E2_VRETCOF
												nCsll  	:= SE2->E2_VRETCSL
												If SE2->(FieldPos("E2_VRETIRF")) > 0
													nIrrf := SE2->E2_VRETIRF
												Endif
												
												//if	SE2->(E2_ISS + E2_IRRF + E2_INSS + E2_SEST + E2_PIS + E2_COFINS + E2_CSLL) == 0
												//	@ nLin,098 psay Transform(SE2->E2_VALOR	,"@e 9,999,999.99")
												//else
												//	@ nLin,098 psay Transform(SE2->E2_VALLIQ	,"@e 9,999,999.99")
												//endif
												
												/* Retirado dia 26/02/2020 conforme solicitado pela Eurilene - Bruno Alves de Oliveira
												
												if	SE2->(E2_ISS + nIrrf + E2_INSS + E2_SEST + nPis + nCofins + nCsll) == 0
													@ nLin,108 psay Transform(SE2->E2_VALOR	,"@e 9,999,999.99")
												else
													@ nLin,108 psay Transform(SE2->E2_VALLIQ ,"@e 9,999,999.99")
												endif
												*/
												
												@ nLin,108 psay Transform((SE2->E2_VALOR + SE2->E2_ISS + SE2->E2_IRRF),"@e 9,999,999.99")
												
												@ nLin,122 psay Transform(SE2->E2_SALDO,"@e 9,999,999.99")
												
											else
												//@ nLin,108 psay Transform(aTitulos[k,13],"@e 9,999,999.99") //Retirado dia 26/02/2020 conforme solicitado pela Eurilene - Bruno Alves de Oliveira
												@ nLin,108 psay Transform((SE2->E2_VALOR + SE2->E2_ISS + SE2->E2_IRRF),"@e 9,999,999.99")
												@ nLin,122 psay Transform(aTitulos[k,14],"@e 9,999,999.99")
											endif
											
											@ nLin,136 psay Substr(SE2->E2_HIST,01,90)
											
										else
											
											SE1->(dbgoto(aTitulos[k,11]))
											
											nLin ++
											
											if	aTitulos[k,12] == "S"
												@ nLin,001 psay "*"
											endif
											
											cTxt	:=	SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" + SE1->E1_PARCELA
											cTxt	+=	"  " + SE1->E1_TIPO + "  " + SE1->E1_CLIENTE + "/" + SE1->E1_LOJA
											cTxt	+=	"  " + SE1->E1_NOMCLI
											
											@ nLin,002 psay cTxt
											@ nLin,056 psay DtoC(SE1->E1_EMISSAO)
											@ nLin,068 psay DtoC(SE1->E1_VENCREA)
											@ nLin,080 psay DtoC(SE1->E1_BAIXA)
											
											if	Empty(SE1->E1_BAIXA) .and. SE1->E1_VENCREA < dDatabase
												@ nLin,092 psay Transform( SE1->E1_VENCREA - dDatabase , "@E 9999" )
											endif
											
											if	!Empty(SE1->E1_BAIXA)
												@ nLin,092 psay Transform( SE1->E1_VENCREA - SE1->E1_BAIXA , "@E 9999" )
											endif
											
											if	aTitulos[k,12] == "N"              
												//if	SE1->(E1_ISS + E1_IRRF + E1_INSS + E1_SEST + E1_PIS + E1_COFINS + E1_CSLL) == 0 //Campo n„o existente Bruno Alves
												if	SE1->(E1_ISS + E1_IRRF + E1_INSS + E1_SEST + E1_PIS + E1_COFINS + E1_CSLL) == 0
													@ nLin,098 psay Transform(SE1->E1_VALOR	,"@e 9,999,999.99")
												else
													@ nLin,098 psay Transform(SE1->E1_VALLIQ	,"@e 9,999,999.99")
												endif
											
											else
												  @ nLin,098 psay Transform(aTitulos[k,13],"@e 9,999,999.99") 
												  @ nLin,112 psay Transform(aTitulos[k,14],"@e 9,999,999.99")
											endif
											
											@ nLin,126 psay Substr(SE1->E1_HIST,01,90)
										endif
									endif
								Next k
								
								nLin ++
							endif
						endif
					Next s
					
				EndIf
				
				
				
				
				If MV_PAR29 = 1
					nLin --
				else
					nLin ++
				endif
				
				if	nLin > 55
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
					
					ImprSubCab(aPeriodos,nPeriodos,@nLin)
				endif
			endif
		Next w
		
		If MV_PAR29 = 1
			nLin += 2
		else
			nLin ++
		endif
		
	Next t
	
	if	nLin > 55
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
		
		ImprSubCab(aPeriodos,nPeriodos,@nLin)
	endif
	
	nCol := 36
	
	@ nLin , 006 psay "T O T A I S"
	
	For k := 2 to 13
		if	aTotN1[ 01 , k ] <> 0
			@ nLin , nCol psay Transform( aTotN1[ 01 , k ] , "@e 99,999,999.99" )
		endif
		
		nCol += 14
	Next k
	
	@ nLin , 204 psay Transform( aTotN1[ 01 , 14 ] , "@e 99,999,999.99" )
endif

Set Device To Screen

if aReturn[5] == 1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
endif

Ms_Flush()

Return

/************************************************************************************/

Static Function ImprSubCab(aPeriodos,nPeriodos,nLin)

Local k
Local nMes
Local nCol 		:=	41
Local aMeses	:=	{"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
If MV_PAR10 <> 3
	cTexto	:=	"RELACAO " + iif(mv_par11 == 1,"SINTETICA","ANALITICA") + " EM REAIS - POR " + iif(mv_par10 == 1,"EMISSAO","VENCIMENTO")
Else
	
	cTexto	:=	"RELACAO " + iif(mv_par11 == 1,"SINTETICA","ANALITICA") + " EM REAIS - POR ENTRADA"
Endif
@ ++ nLin , 000 psay PadC( cTexto , 220 )

nLin ++

@ ++ nLin , 002 psay "Codigo  Descricao da Natureza"

For k := 1 to nPeriodos
	nMes := aPeriodos[k,02]
	@ nLin , nCol psay aMeses[ nMes ] + "/" + AllTrim(Str(aPeriodos[k,01]))
	nCol += 14
Next k

@    nLin , 212 psay "TOTAL"

@ ++ nLin , 000 psay Replicate( "-" , 219 )

nLin ++

Return

/************************************************************************************/

Static Function PriDia(dDataRef)

Return ( StoD( Substr(DtoS(dDataRef),01,06) + "01" ) )

/************************************************************************************/

Static Function UltDia(dDataRef)

Local cRet := Substr(DtoS(dDataRef),01,06)

if	Substr(DtoS(dDataRef),05,02) == "02"
	cRet += iif( (Year(dDataRef) / 4) == Int(Year(dDataRef) / 4) , "29" , "28" )
else
	cRet += iif( Substr(DtoS(dDataRef),05,02) $ "04/06/09/11" , "30" , "31" )
endif

Return ( StoD(cRet) )





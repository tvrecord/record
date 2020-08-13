#include "Topconn.ch"

/*
------------------------------------------------------------------------------------------------------------------------------------------------
Programa: MAPAFINI  

Autor: Edmilson D. Santos

Data: 25/03/07

Descricao: Relatorio dos Titulos por natureza com impressão conjunta dos impostos            

Uso: RECORD - Financeiro
------------------------------------------------------------------------------------------------------------------------------------------------
ALTERAÇÕES DESDE A CRIAÇÃO
 - 23/01/2009 - Rafael Costa Leite - Construção do relatório MAPAFINI, a partir do MAPAFINI. Alterada forma de impressão dos títulos de impostos.

------------------------------------------------------------------------------------------------------------------------------------------------
OBSERVAÇÕES SOBRE O RELATÓRIO

O relatório MAPAFINI foi criado a partir do relatório MAPAFIN. O relatório MAPAFINI foi criado a partir da necessidade de alteração 
do tratamentos na impressão dos títulos de impostos. A criação do MAPAFINI não inutiliza o MAPAFIN, ambos estarão posicionados no menu do usuário.
------------------------------------------------------------------------------------------------------------------------------------------------
*/
User Function MAPAFINI

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
Private wnrel      	:= "MAPAFINI" 
Private nLin      	:= 80
Private Titulo  	 	:= "MAPA GERENCIAL FINANCEIRO - MENSAL - IMPOSTOS"
Private cabec1  	 	:= ""
Private cabec2  	 	:= ""
Private CbTxt      	:= ""
Private lEnd       	:= .f.
Private lAbortPrint	:= .f.
Private limite     	:= 220
Private tamanho    	:= "G"
Private nomeprog   	:=	"MAPAFINI" 
Private nTipo      	:= 15
Private aReturn    	:= { "Zebrado", 01, "Administracao", 01, 02, 01, "", 01}
Private nLastKey   	:= 0
Private cString    	:= "SE2"
Private cPerg      	:= "MPFINI"

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

_cPerg	:= "MPFINI"

PutSx1( _cPerg,'01',"Filial De        	?",'','','mv_ch1','C',02,0,0,'G','','XM0','','','mv_par01','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'02',"Filial Ate       	?",'','','mv_ch2','C',02,0,0,'G','','XM0','','','mv_par02','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'03',"Natureza De      	?",'','','mv_ch3','C',09,0,0,'G','','SED','','','mv_par03','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'04',"Natureza Ate     	?",'','','mv_ch4','C',09,0,0,'G','','SED','','','mv_par04','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'05',"Carteira         	?",'','','mv_ch5','C',01,0,0,'G','',''   ,'','','mv_par05','Receber          ','','','','Pagar          ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'06',"Emissao De       	?",'','','mv_ch6','C',08,0,0,'G','',''   ,'','','mv_par06','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'07',"Emissao Ate      	?",'','','mv_ch7','C',08,0,0,'G','',''   ,'','','mv_par07','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'08',"Vencimento De    	?",'','','mv_ch8','C',08,0,0,'G','',''   ,'','','mv_par08','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'09',"Vencimento Ate   	?",'','','mv_ch9','C',08,0,0,'G','',''   ,'','','mv_par09','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'10',"Imprimir Por     	?",'','','mv_cha','C',01,0,0,'C','',''   ,'','','mv_par10','Emissao          ','','','','Vencimento     ','','','Entrada','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'11',"Imprimir Modo    	?",'','','mv_chb','C',01,0,0,'C','',''   ,'','','mv_par11','Sintetico        ','','','','Analitico      ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'12',"Imprimir Situacao	?",'','','mv_chc','C',01,0,0,'C','',''   ,'','','mv_par12','Recebidos/Pagos  ','','','','Não Receb/Pados','','','Ambos','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'13',"Totalizar        	?",'','','mv_chd','C',01,0,0,'C','',''   ,'','','mv_par13','Vlr Original     ','','','','Saldo          ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'14',"Excluir Mov.Caixa	?",'','','mv_che','C',01,0,0,'C','',''   ,'','','mv_par14','Sim              ','','','','Nao            ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'15',"Tit. Adiant. Compen?",'','','mv_chf','C',01,0,0,'C','',''   ,'','','mv_par15','Sim              ','','','','Nao            ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'16',"Banco              ?",'','','mv_chg','C',03,0,0,'G','','SA6','','','mv_par16','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'17',"Agencia            ?",'','','mv_chh','C',05,0,0,'G','',''   ,'','','mv_par17','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'18',"Conta              ?",'','','mv_chi','C',10,0,0,'G','',''   ,'','','mv_par18','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'19',"Impostos Terceiros ?",'','','mv_chj','C',01,0,0,'C','',''   ,'','','mv_par19','Sim              ','','','','Nao            ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'20',"Prefixo De         ?",'','','mv_chk','C',03,0,0,'G','',''   ,'','','mv_par20','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'21',"Prefixo Ate        ?",'','','mv_chl','C',03,0,0,'G','',''   ,'','','mv_par21','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'22',"Entrada De         ?",'','','mv_chm','C',08,0,0,'G','',''   ,'','','mv_par22','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'23',"Entrada Ate        ?",'','','mv_chn','C',08,0,0,'G','',''   ,'','','mv_par23','                 ','','','','               ','','','','','','','','','','','', ,{},{} )
PutSx1( _cPerg,'24',"Fora Prefixo       ?",'','','mv_cho','C',03,0,0,'G','',''   ,'','','mv_par24','                 ','','','','               ','','','','','','','','','','','', ,{},{} )

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
	aAdd( aTemp , { Nil , Nil , Nil , Nil , StrZero(t,2), 0 } )
Next t

dIniEmis	:=	mv_par06
dFimEmis	:=	mv_par07
dIniVen 	:=  mv_par08
dFimVen 	:=	mv_par09
dIniEnt     :=  mv_par22
dFimEnt     :=  mv_par23

if mv_par10 == 1           	// Por Emissão

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
	cTxt	+=	"O Relatorio Irá Imprimir o Período de "
	cTxt 	+=	Substr(DtoS(aPeriodos[01,03]),05,02) + "/" 
	cTxt	+=	Substr(DtoS(aPeriodos[01,03]),01,04) + " a "
	cTxt 	+=	Substr(DtoS(aPeriodos[Len(aPeriodos),04]),05,02) + "/" 
	cTxt	+=	Substr(DtoS(aPeriodos[Len(aPeriodos),04]),01,04) + " por Emissao !!!"
	
	Aviso( "Atenção" , cTxt , {"Ok"} , 3 , "Período de Impressão" )
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
	Cabec1	+=	iif( mv_par05 == 2 , "Não Pagos"	, "Não Recebidos" )
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
	cQuery	+=			"  E2_EMIS1    AS EMIS1    , "
	cQuery	+=			"  E2_VENCREA  AS VENCTO   , "
	cQuery	+=			"  E2_NATUREZ  AS NATUREZA , "
	cQuery	+=			"  E2_VALOR    AS VALOR    , "
	cQuery	+=			"  E2_VALLIQ   AS VALLIQ   , "	//
	cQuery	+=			"  E2_ISS      AS ISS      , "   //
	If MV_PAR10 = 3
	  cQuery	+=			"  E2_EMIS1 AS ENTRADA , "   //
	Endif
	
	/*
	IF SE2->(FieldPos("E2_VRETIRF")) > 0
		cQuery	+= 	"  E2_VRETIRF  AS IRRF     , "   //
	ELSE
		cQuery	+=		"  E2_IRRF     AS IRRF     , "   //
	ENDIF
   */
	
	cQuery	+=		   "  E2_IRRF     AS IRRF     , "   //
	cQuery	+=			"  E2_INSS     AS INSS     , "   //
	cQuery	+=			"  E2_SEST     AS SEST     , "   //

//	cQuery	+=			"  E2_VRETPIS  AS PIS      , "   //
//	cQuery	+=			"  E2_VRETCOF  AS COFINS   , "   //
//	cQuery	+=			"  E2_VRETCSL  AS CSLL     , "   //
	cQuery	+=			"  E2_PIS      AS PIS      , "   //
	cQuery	+=			"  E2_COFINS   AS COFINS   , "   //
	cQuery	+=			"  E2_CSLL     AS CSLL     , "   //
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
	cQuery 	+=			" E2_PREFIXO <> '" + mv_par24 + "' AND "
	cQuery 	+=			" E2_TIPO <> 'TX ' AND " //Incluido com a criação do MAPAFINI
	cQuery 	+=			" E2_TIPO <> 'ISS' AND " //Incluido com a criação do MAPAFINI
	cQuery 	+=			" E2_TIPO <> 'INS' AND " //Incluido com a criação do MAPAFINI
	IF MV_PAR10 <>3
	  cQuery 	+=			" E2_EMISSAO BETWEEN '" + DtoS(mv_par06)	+ "' AND '" + DtoS(mv_par07)	+ "' AND "
	  cQuery 	+=			" E2_VENCREA BETWEEN '" + DtoS(mv_par08) 	+ "' AND '" + DtoS(mv_par09) 	+ "' AND "  
    Endif
    If MV_PAR10=3
      cQuery 	+=			" E2_EMIS1 BETWEEN '" + DtoS(mv_par22) 	    + "' AND '" + DtoS(mv_par23) 	+ "' AND "   // INCLUIDO POR JACKSON
    Endif
    if mv_par14 == 1
//	   cQuery 	+= " ( Substr(e2_bcopag,1,1) <> 'C' "	 					 		// Rotina Adicionada por Klaus em 13/07/2007 pelo motivo acima.
	   cQuery 	+= " ( SUBSTRING(e2_bcopag,1,1) NOT IN ('C','R')"	 				// Rotina alterada por Marcio T. Suzaki em 19/11/08 devido ao
	   cQuery 	+= "   or ( select count(1)"                            		// caixinha da Radio Capital ter saido do padrão de cadastramento
	   cQuery 	+= "        from " + RetSqlName("SE5")
	   cQuery 	+= "        where e5_filial  = e2_filial"
	   cQuery 	+= "          and e5_prefixo = e2_prefixo"
	   cQuery 	+= "          and e5_numero  = e2_num"
	   cQuery 	+= "          and e5_parcela = e2_parcela"
	   cQuery 	+= "          and e5_tipo    = e2_tipo"   
	   cQuery 	+= "          and e5_clifor =  e2_fornece" 			//Incluido por Cristiano Alves em 08/03/08
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
	
	//REALIZADO UNION PARA TRATAR INSS DA FOLHA
	cQuery 	+= " UNION                   "                                                     
	
	cQuery	+=	" SELECT E2_FILIAL   AS FILIAL   , "
	cQuery	+=			"  E2_PREFIXO  AS PREFIXO  , "
	cQuery	+=			"  E2_NUM      AS NUMERO   , "
	cQuery	+=			"  E2_PARCELA  AS PARCELA  , "
	cQuery	+=			"  E2_TIPO     AS TIPO     , "
	cQuery	+=			"  E2_EMISSAO  AS EMISSAO  , "
	cQuery	+=			"  E2_EMIS1    AS EMIS1    , "
	cQuery	+=			"  E2_VENCREA  AS VENCTO   , "
	cQuery	+=			"  E2_NATUREZ  AS NATUREZA , "
	cQuery	+=			"  E2_VALOR    AS VALOR    , "
	cQuery	+=			"  E2_VALLIQ   AS VALLIQ   , "	//
	cQuery	+=			"  E2_ISS      AS ISS      , "   //
	If MV_PAR10 = 3
	  cQuery	+=			"  E2_EMIS1 AS ENTRADA , "   //
	Endif
	
	/*
	IF SE2->(FieldPos("E2_VRETIRF")) > 0
		cQuery	+= 	"  E2_VRETIRF  AS IRRF     , "   //
	ELSE
		cQuery	+=		"  E2_IRRF     AS IRRF     , "   //
	ENDIF
   */
	
	cQuery	+=		   "  E2_IRRF     AS IRRF     , "   //
	cQuery	+=			"  E2_INSS     AS INSS     , "   //
	cQuery	+=			"  E2_SEST     AS SEST     , "   //

//	cQuery	+=			"  E2_VRETPIS  AS PIS      , "   //
//	cQuery	+=			"  E2_VRETCOF  AS COFINS   , "   //
//	cQuery	+=			"  E2_VRETCSL  AS CSLL     , "   //
	cQuery	+=			"  E2_PIS      AS PIS      , "   //
	cQuery	+=			"  E2_COFINS   AS COFINS   , "   //
	cQuery	+=			"  E2_CSLL     AS CSLL     , "   //
	cQuery	+=			"  E2_SALDO    AS SALDO    , "
	cQuery	+=			"  E2_MULTNAT  AS MULTNAT  , "
	cQuery	+=			"  'P'         AS RECPAG   , "    
	cQuery	+=			"  E2_FORNECE  AS CLIFOR   , "
	cQuery	+=			"  E2_LOJA     AS LOJA     , "
	cQuery	+=			"  E2_ORIGEM   AS ORIGEM   , "
	cQuery	+=			"  R_E_C_N_O_  AS RECNOS     "
	cQuery 	+=	" FROM " + RetSqlName("SE2")
	cQuery 	+=	" WHERE E2_FILIAL  BETWEEN '" + mv_par01			+ "' AND '" + mv_par02			+ "' AND "
	cQuery 	+=			" E2_NATUREZ = '1201022' AND "
	cQuery 	+=			" E2_PREFIXO BETWEEN '" + mv_par20			+ "' AND '" + mv_par21			+ "' AND " 
	cQuery 	+=			" E2_PREFIXO <> '" + mv_par24 + "' AND "
	cQuery 	+=			" E2_TIPO <> 'TX ' AND " //Incluido com a criação do MAPAFINI
	cQuery 	+=			" E2_TIPO <> 'ISS' AND " //Incluido com a criação do MAPAFINI
	IF MV_PAR10 <>3
	  cQuery 	+=			" E2_EMISSAO BETWEEN '" + DtoS(mv_par06)	+ "' AND '" + DtoS(mv_par07)	+ "' AND "
	  cQuery 	+=			" E2_VENCREA BETWEEN '" + DtoS(mv_par08) 	+ "' AND '" + DtoS(mv_par09) 	+ "'  "  
    Endif
    If MV_PAR10=3
      cQuery 	+=			" E2_EMIS1 BETWEEN '" + DtoS(mv_par22) 	    + "' AND '" + DtoS(mv_par23) 	+ "' "   // INCLUIDO POR JACKSON
    Endif
    if mv_par14 == 1
//	   cQuery 	+= " ( Substr(e2_bcopag,1,1) <> 'C' "	 					 		// Rotina Adicionada por Klaus em 13/07/2007 pelo motivo acima.
	   cQuery 	+= " AND ( SUBSTRING(e2_bcopag,1,1) NOT IN ('C','R')"	 				// Rotina alterada por Marcio T. Suzaki em 19/11/08 devido ao
	   cQuery 	+= "   or ( select count(1)"                            		// caixinha da Radio Capital ter saido do padrão de cadastramento
	   cQuery 	+= "        from " + RetSqlName("SE5")
	   cQuery 	+= "        where e5_filial  = e2_filial"
	   cQuery 	+= "          and e5_prefixo = e2_prefixo"
	   cQuery 	+= "          and e5_numero  = e2_num"
	   cQuery 	+= "          and e5_parcela = e2_parcela"
	   cQuery 	+= "          and e5_tipo    = e2_tipo"   
	   cQuery 	+= "          and e5_clifor =  e2_fornece" 			//Incluido por Cristiano Alves em 08/03/08
	   cQuery 	+= "          and e5_loja = e2_loja"
	   cQuery 	+= "          and d_e_l_e_t_ = ' ') > 1 )  " 	// Fim da inclusao por Klaus em 13/07/2007
	endif   

	if	mv_par12 <> 3 
		cQuery		+=	iif( mv_par12 == 1 , " AND E2_SALDO = 0 AND " , " E2_SALDO > 0  " )
	endif

   if !Empty(mv_par16) .and. !Empty(mv_par17) .and. !Empty(mv_par18)
		cQuery 	+= " AND E2_PORTADO = '" + mv_par16 + "' AND "
		cQuery 	+= " E2_AGEDEP  = '" + mv_par17 + "' AND "
		cQuery 	+= " E2_NUMCON  = '" + mv_par18 + "'  "
   endif

	cQuery 	+= "    AND   D_E_L_E_T_  = ' '"                                                      
	
	IF MV_PAR10 <> 3  // INCLUIDO POR JACKSON MACIEL
	  //cQuery 	+= " ORDER BY E2_FILIAL,E2_NATUREZ,E2_EMISSAO,E2_VENCREA "

	  //Ajustado apos a inclusao do UNIO
	  cQuery 	+= " ORDER BY FILIAL,NATUREZA,EMISSAO,VENCTO "
    Else
      //cQuery 	+= " ORDER BY E2_FILIAL,E2_NATUREZ,E2_EMIS1,E2_VENCREA " // JACKSON MACIL
      
      //Ajustado apos a inclusao do UNIO
	  cQuery 	+= " ORDER BY FILIAL,NATUREZA,EMIS1,VENCTO "

    Endif
   
    MemoWrite("c:\mapafini-1.sql",cQuery)
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
	cQuery	+=			"  E1_SEST     AS SEST     , "   //
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

	// Não Tem Múltiplas Naturezas 
	if	!lMultiNat
		
		if	mv_par13 == 1 
			nValor	:=	TMAP->VALOR 
		else
			nValor	:=	TMAP->SALDO
		endif	

		// Verifico no Primeiro Nível
		If MV_PAR25 == 1
			nPosN1 := aScan( aNivel1 , { |x| x[01] == TMAP->FILIAL .and. x[02] == Substr(TMAP->NATUREZA,01,02) } )
		Else	
			nPosN1 := aScan( aNivel1 , { |x| x[02] == Substr(TMAP->NATUREZA,01,02) } )
		EndIf

		if	nPosN1 == 0 
			aAdd( aNivel1 , Array( nPeriodos + 2 ) )
			nPosN1 := Len( aNivel1 )
			For w := 1 to ( nPeriodos + 2 )
				aNivel1[nPosN1,w]	:=	0.00
			Next w
			aNivel1[nPosN1,01]		:=	TMAP->FILIAL 	
			aNivel1[nPosN1,02]		:=	Substr(TMAP->NATUREZA,01,02)		
		endif

		//aNivel1[nPosN1,nPosP + 2]	+=	nValor
		aNivel1[nPosN1,nPosP + 2]	+=	nValor + TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS)

		// Verifico no Segundo Nível
		If MV_PAR25 == 1
			nPosN2 := aScan( aNivel2 , { |x| x[01] == TMAP->FILIAL 						.and. ;
														x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
														x[03] == Substr(TMAP->NATUREZA,01,04) 	} )
		Else 
			nPosN2 := aScan( aNivel2 , { |x| x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
														x[03] == Substr(TMAP->NATUREZA,01,04) 	} )	
		EndIf	

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

		//aNivel2[nPosN2,nPosP + 3]	+=	nValor 
		aNivel2[nPosN2,nPosP + 3]	+=	nValor + TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS)

		// Verifico no Terceiro Nível
		If MV_PAR25 == 1
			nPosN3 := aScan( aNivel3 , { |x| x[01] == TMAP->FILIAL 						.and. ;
														x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
														x[03] == Substr(TMAP->NATUREZA,01,04) 	.and. ;
														x[04] == TMAP->NATUREZA 					} )    
		Else
			nPosN3 := aScan( aNivel3 , { |x|	x[02] == Substr(TMAP->NATUREZA,01,02) 	.and. ;
														x[03] == Substr(TMAP->NATUREZA,01,04) 	.and. ;
														x[04] == TMAP->NATUREZA 					} )    
		EndIf
	
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

		//aNivel3[nPosN3,nPosP + 4]	+=	nValor 
		aNivel3[nPosN3,nPosP + 4]	+=	nValor + TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS)
      
//      If TMAP->NUMERO = '003625'
//      	conout('teste')
//      EndIf 
      
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
										TMAP->VALOR - TMAP->(PIS + COFINS + CSLL)		,  TMAP->SALDO 			}) 													
		endif

    else
   
		nPos		:=	0
		aTemp 	:=	{}
		nValor	:= TMAP->(PIS + COFINS + CSLL)
      
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
     			aAdd( aTemp , { MULT->EV_NATUREZ , MULT->EV_VALOR, iif( TMAP->SALDO == 0 , 0 , MULT->EV_VALOR ) })
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

		// Verifico se imprime por saldo e se há baixas parciais
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

			// Verifico no Primeiro Nível	
			If MV_PAR25 == 1
				nPosN1 := aScan( aNivel1 , { |x| x[01] == TMAP->FILIAL .and. x[02] == Substr(aTemp[t,01],01,02) } )
			Else
				nPosN1 := aScan( aNivel1 , { |x| x[02] == Substr(aTemp[t,01],01,02) } )
			EndIf
	
			if	nPosN1 == 0 
				aAdd( aNivel1 , Array( nPeriodos + 2 ) )
				nPosN1 := Len( aNivel1 )
				For w := 1 to ( nPeriodos + 2 )
					aNivel1[nPosN1,w]	:=	0.00
				Next w
				aNivel1[nPosN1,01]		:=	TMAP->FILIAL 	
				aNivel1[nPosN1,02]		:=	Substr(aTemp[t,01],01,02)		
			endif
	
			//aNivel1[nPosN1,nPosP + 2]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			_nImp := 	fSEVImp({TMAP->FILIAL     ;
										,TMAP->PREFIXO   ;
										,TMAP->NUMERO    ;
										,TMAP->PARCELA   ;
										,TMAP->TIPO      ;
										,TMAP->CLIFOR    ;
										,TMAP->LOJA      ;
										,TMAP->NATUREZA })
			
			_nImp := Round((TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS) * _nImp),2) 
							
			aNivel1[nPosN1,nPosP + 2]	+=	iif( mv_par13 == 1 , aTemp[t,02]+_nImp, aTemp[t,03] )
	
			// Verifico no Segundo Nível
			If MV_PAR25 == 1
				nPosN2 := aScan( aNivel2 , { |x| x[01] == TMAP->FILIAL 						.and. ;
															x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
															x[03] == Substr(aTemp[t,01],01,04) 		} )
			Else
				nPosN2 := aScan( aNivel2 , { |x|	x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
															x[03] == Substr(aTemp[t,01],01,04) 		} )
			EndIf			
	
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
	
			//aNivel2[nPosN2,nPosP + 3]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			_nImp := 	fSEVImp({TMAP->FILIAL     ;
										,TMAP->PREFIXO   ;
										,TMAP->NUMERO    ;
										,TMAP->PARCELA   ;
										,TMAP->TIPO      ;
										,TMAP->CLIFOR    ;
										,TMAP->LOJA      ;
										,TMAP->NATUREZA })
			
			_nImp := Round((TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS) * _nImp),2) 

			aNivel2[nPosN2,nPosP + 3]	+=	iif( mv_par13 == 1 , aTemp[t,02]+_nImp, aTemp[t,03] )
	
			// Verifico no Terceiro Nível	
			If MV_PAR25 == 1
				nPosN3 := aScan( aNivel3 , { |x| x[01] == TMAP->FILIAL 						.and. ;
															x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
															x[03] == Substr(aTemp[t,01],01,04) 		.and. ;
															x[04] == aTemp[t,01]							} )
			Else
				nPosN3 := aScan( aNivel3 , { |x| x[02] == Substr(aTemp[t,01],01,02) 		.and. ;
															x[03] == Substr(aTemp[t,01],01,04) 		.and. ;
															x[04] == aTemp[t,01]							} )
			EndIf
	
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
	
			//aNivel3[nPosN3,nPosP + 4]	+=	iif( mv_par13 == 1 , aTemp[t,02] , aTemp[t,03] )
			_nImp := 	fSEVImp({TMAP->FILIAL     ;
										,TMAP->PREFIXO   ;
										,TMAP->NUMERO    ;
										,TMAP->PARCELA   ;
										,TMAP->TIPO      ;
										,TMAP->CLIFOR    ;
										,TMAP->LOJA      ;
										,TMAP->NATUREZA })

			_nImp := Round((TMAP->(PIS + COFINS + CSLL + IRRF + ISS + INSS) * _nImp),2) 

			aNivel3[nPosN3,nPosP + 4]	+=	iif( mv_par13 == 1 , aTemp[t,02]+_nImp, aTemp[t,03] )

//	      If TMAP->NUMERO = '003625'
//	      	conout('teste')
//   	   EndIf 

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



If MV_PAR25 == 1
	// INICIO DO TRATAMENTO DE ORDEM POR FILIAL
	aNivel1	:=	aSort( aNivel1 ,,, { |x,y| x[01] + x[02] < y[01] + y[02] } )
	aNivel2	:=	aSort( aNivel2 ,,, { |x,y| x[01] + x[02] + x[03] < y[01] + y[02] + y[03] } )
	aNivel3	:=	aSort( aNivel3 ,,, { |x,y| x[01] + x[02] + x[03] + x[04] < y[01] + y[02] + y[03] + y[04] } )
	
	
	if mv_par10 == 1 		// Por Emissão
		aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[01] + x[09] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
															 y[01] + y[09] + y[02] + y[03] + y[04] + y[05] + y[06] } )
	else
		aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[01] + x[10] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
															 y[01] + y[10] + y[02] + y[03] + y[04] + y[05] + y[06] } )
	endif            
	// FIM FO TRATAMENTO DE ORDEM POR FILIAL
Else

	// INICIO DO TRATAMENTO DE ORDEM SEM FILIAL
	//Rafael - Junto com o tratamento de impostos, passou a ser necessária a impressão de todas as filiais juntas
	aNivel1	:=	aSort( aNivel1 ,,, { |x,y| x[02] < y[02] } )
	aNivel2	:=	aSort( aNivel2 ,,, { |x,y| x[02] + x[03] < y[02] + y[03] } )
	aNivel3	:=	aSort( aNivel3 ,,, { |x,y| x[02] + x[03] + x[04] < y[02] + y[03] + y[04] } )
	
	
	if mv_par10 == 1 		// Por Emissão
		aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[09] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
															 y[09] + y[02] + y[03] + y[04] + y[05] + y[06] } )
	else
		aTitulos	:=	aSort( aTitulos ,,, { |x,y| x[10] + x[02] + x[03] + x[04] + x[05] + x[06] < ;
															 y[10] + y[02] + y[03] + y[04] + y[05] + y[06] } )
	endif            
	// FIM DO TRATAMENTO DE ORDEM SEM FILIAL
EndIf


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

		nLin ++

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
	
							@ ++ nLin , 002 psay "Prf Numero Par  Tip  Codigo     Nome                  Emissão   Vecto     Pagto     Entrada      Vlr Liquido         Saldo  Historico       "

							                  //  XXX-999999-AAA  XXX  999999/99  XXXXXXXXXXXXXXXXXXXX  99/99/9999  99/99/9999  99/99/9999  9999  9,999,999.99  9,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXX
												   //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
               							   //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21

							nLin ++ 

                  	For k := 1 to Len(aTitulos)

								if	(aTitulos[k,01] == aNivel3[s,01] .and. aTitulos[k,02] == aNivel3[s,04] .and. MV_PAR25 == 1);
								.or. (aTitulos[k,02] == aNivel3[s,04] .and. MV_PAR25 == 2)

									if	nLin > 55					
										nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
							
										ImprSubCab(aPeriodos,nPeriodos,@nLin)

										cTxt 	:=	aNivel3[s,04] + " " 
										cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel3[s,04] , "ED_DESCRIC" ) , 01 , 25 )

										@    nLin , 002 psay cTxt + " >> Em continuação << "
				
										nLin ++

										@ ++ nLin , 002 psay "Prf Numero Par  Tip  Codigo     Nome                  Emissão   Vecto     Pagto     Entrada      Vlr Liquido         Saldo  Historico       "

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

										//@ nLin,001 psay "#"
										@ nLin,002 psay cTxt
										@ nLin,056 psay DtoC(SE2->E2_EMISSAO)
										@ nLin,066 psay DtoC(SE2->E2_VENCREA)
										@ nLin,076 psay DtoC(SE2->E2_BAIXA)
										@ nLin,086 psay DtoC(SE2->E2_EMIS1)
				
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

											if	SE2->(E2_ISS + nIrrf + E2_INSS + E2_SEST + nPis + nCofins + nCsll) == 0 
												@ nLin,098 psay Transform(SE2->E2_VALOR	,"@e 9,999,999.99")
      									else
												@ nLin,098 psay Transform(SE2->E2_VALLIQ	,"@e 9,999,999.99")
											endif
											
											@ nLin,112 psay Transform(SE2->E2_SALDO,"@e 9,999,999.99")
											
										else
											@ nLin,098 psay Transform(aTitulos[k,13],"@e 9,999,999.99")
											@ nLin,112 psay Transform(aTitulos[k,14],"@e 9,999,999.99")
										endif
										
										@ nLin,126 psay Substr(SE2->E2_HIST,01,90)
																				
										//Apenas títulos de primeira parcela
										If SE2->E2_PARCELA $ "   / 1 /1  /  1/ 01/01 /001/A  / A /  A" 
											//Impressão dos títulos de impostos
											// Monta arquivo temporário com os títulos de impostos do titulo original
											fTitImp(	{SE2->E2_FILIAL ;
														,SE2->E2_PREFIXO;
														,SE2->E2_NUM    ;
														,SE2->E2_PARCELA;
														,SE2->E2_TIPO   ;
														,SE2->E2_FORNECE;
														,SE2->E2_LOJA   ;
														,SE2->E2_IRRF   ;
														,SE2->E2_ISS    ;
														,SE2->E2_COFINS ;
														,SE2->E2_PIS    ;
														,SE2->E2_CSLL   ;
														,SE2->E2_INSS   })
											
											//Percorre todo arquivo temporario
											ARQ1->(DbGoTop())
											While !ARQ1->(EOF())
	                              	
	                              	//Detalhe de impressao
												_cTImp	:=	ARQ1->PREFIXO  + "-" + ARQ1->NUMERO + "-" + ARQ1->PARCELA
												_cTImp	+=	"  " + ARQ1->TIPO + "  " + ARQ1->FORNECEDOR + "/" + ARQ1->LOJA
												_cTImp	+=	"  " + Left(ARQ1->NOME,18)
												
	
												//Monta histórico para impressão
												If ARQ1->TIPO == "ISS"        
													_cHist := "Parcela do ISS"										
												ElseIf ARQ1->TIPO == "INS"        
													_cHist := "Parcela do INSS"										
												ElseIf ARQ1->PARCELA == SE2->E2_PARCIR
													_cHist := "Parcela do IRRF"
												ElseIf ARQ1->PARCELA == SE2->E2_PARCCOF
													_cHist := "Parcela do COFINS"
												ElseIf ARQ1->PARCELA == SE2->E2_PARCPIS
													_cHist := "Parcela do PIS"
												ElseIf ARQ1->PARCELA == SE2->E2_PARCSLL
													_cHist := "Parcela do CSLL"
												Else
													_cHist := "Parcela não identificada"
												EndIf
	
												++nLin
												//Verificar quantidade de linhas
												if	nLin > 55					
													nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
									
													ImprSubCab(aPeriodos,nPeriodos,@nLin)
			
													cTxt 	:=	aNivel3[s,04] + " " 
													cTxt 	+=	Substr( Posicione( "SED" , 1 , xFilial("SED") + aNivel3[s,04] , "ED_DESCRIC" ) , 01 , 25 )
			
													@    nLin , 002 psay cTxt + " >> Em continuação << "
							
													nLin ++
			
													@ ++ nLin , 002 psay "Prf Numero Par  Tip  Codigo     Nome                  Emissão   Vecto     Pagto     Entrada      Vlr Liquido         Saldo  Historico       "
			
													nLin ++ 
												endif						
			
												@ nLin,004 psay _cTImp  
												@ nLin,056 psay DtoC(StoD(ARQ1->EMISSAO))
												@ nLin,066 psay DtoC(StoD(ARQ1->VENCIMENTO))
												@ nLin,076 psay DtoC(StoD(ARQ1->BAIXA))
												@ nLin,086 psay DtoC(StoD(ARQ1->ENTRADA))
												@ nLin,098 psay Transform(ARQ1->VALOR,"@e 9,999,999.99")
												@ nLin,112 psay Transform(ARQ1->SALDO,"@e 9,999,999.99")																						
												@ nLin,126 psay _cHist
													                                 
												//Avanca registro
												ARQ1->(DbSkip())
											EndDo 
										EndIf

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
											if	SE1->(E1_ISS + E1_IRRF + E1_INSS + E1_SEST + E1_PIS + E1_COFINS + E1_CSLL) == 0
												@ nLin,098 psay Transform(SE1->E1_VALOR	,"@e 9,999,999.99")
											else
												@ nLin,098 psay Transform(SE1->E1_VALLIQ	,"@e 9,999,999.99")
											endif
											@ nLin,112 psay Transform(SE1->E1_SALDO,"@e 9,999,999.99")
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

				nLin ++

				if	nLin > 55					
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
		
					ImprSubCab(aPeriodos,nPeriodos,@nLin)
				endif	
			endif
		Next w

		nLin ++
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
                   
/*
--------------------------------------------------------------------------------------------------------------------------------------------
Função: fTitImp

Tipo: Função Estática

Descrição: Monta arquivo temporário com os dados dos títulos de impostos, relacionados com o título principal

Parâmetros:
 - aPar - Array contendo os dados do título principal
 - aPar[1] - Filial
 - aPar[2] - Prefixo
 - aPar[3] - Numero
 - aPar[4] - Parcela
 - aPar[5] - Tipo
 - aPar[6] - Fornecedor
 - aPar[7] - Loja
 - aPar[8] - Valor IRRF
 - aPar[9] - Valor ISS
 - aPar[10] - Valor COFINS
 - aPar[11] - Valor CSLL
 - aPar[12] - Valor INSS
 
 Retorno
--------------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function fTitImp(aPar)

Local cQry:= ""
Local EOL := Chr(13)+Chr(10)

//Parametros recebidos
Local cTitFil := aPar[1]
Local cTitPrf := aPar[2]
Local cTitNum := aPar[3]
Local cTitPar := aPar[4]
Local cTitTip := aPar[5]
Local cTitFor := aPar[6]
Local cTitLoj := aPar[7]
Local nTitIRF := aPar[8]
Local nTitISS := aPar[9]
Local nTitCOF := aPar[10]
Local nTitPIS := aPar[11]
Local nTitCSL := aPar[12]
Local nTitINS := aPar[13]
 
//Monta query
cQuery	:=EOL+   " select 
cQuery	+=EOL+	"  SE2.E2_FILIAL   AS FILIAL   
cQuery	+=EOL+	"  ,SE2.E2_PREFIXO  AS PREFIXO 
cQuery	+=EOL+	"  ,SE2.E2_NUM      AS NUMERO  
cQuery	+=EOL+	"  ,SE2.E2_PARCELA  AS PARCELA 
cQuery	+=EOL+	"  ,SE2.E2_TIPO     AS TIPO    
cQuery	+=EOL+	"  ,SE2.E2_EMISSAO  AS EMISSAO 
cQuery	+=EOL+	"  ,SE2.E2_VENCREA  AS VENCIMENTO  
cQuery	+=EOL+	"  ,SE2.E2_BAIXA    AS BAIXA       
cQuery	+=EOL+	"  ,SE2.E2_EMIS1    AS ENTRADA     
cQuery	+=EOL+	"  ,SE2.E2_NATUREZ  AS NATUREZA
cQuery	+=EOL+	"  ,SE2.E2_VALOR    AS VALOR   
cQuery	+=EOL+	"  ,SE2.E2_VALLIQ   AS VALLIQ  
cQuery	+=EOL+	"  ,SE2.E2_SALDO    AS SALDO    
cQuery	+=EOL+	"  ,SE2.E2_MULTNAT  AS MULTNAT  
cQuery	+=EOL+	"  ,SE2.E2_FORNECE  AS FORNECEDOR   
cQuery	+=EOL+	"  ,SE2.E2_NOMFOR   AS NOME
cQuery	+=EOL+	"  ,SE2.E2_LOJA     AS LOJA     
cQuery	+=EOL+	"  ,SE2.E2_ORIGEM   AS ORIGEM   
cQuery 	+=EOL+	" from " + RetSqlName("SE2") + " SE2 "
cQuery 	+=EOL+	" where "
cQuery 	+=EOL+	"      SE2.D_E_L_E_T_ =  '' "
cQuery 	+=EOL+	"  and SE2.E2_FILIAL  =  '" + cTitFil + "' "
cQuery 	+=EOL+	"  and SE2.E2_PREFIXO =  '" + cTitPrf + "' "
cQuery 	+=EOL+	"  and SE2.E2_NUM     =  '" + cTitNum + "' "
cQuery 	+=EOL+	"  and SE2.E2_TIPO    <> '" + cTitTip + "' "

//Como foram encontrados diferenças de R$0,01 entre o valor gravado no título original e o valor do título de imposto gerado,
// será verificada a necessidade verificar essa diferença
cQuery 	+=EOL+	"  and (SE2.E2_VALOR between " + StrTran(Transform((nTitIRF-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitIRF+0.01),"@E 999999999.99"),",",".") + " "
cQuery 	+=EOL+	"    or SE2.E2_VALOR between " + StrTran(Transform((nTitISS-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitISS+0.01),"@E 999999999.99"),",",".") + " "
cQuery 	+=EOL+	"    or SE2.E2_VALOR between " + StrTran(Transform((nTitCOF-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitCOF+0.01),"@E 999999999.99"),",",".") + " "
cQuery 	+=EOL+	"    or SE2.E2_VALOR between " + StrTran(Transform((nTitPIS-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitPIS+0.01),"@E 999999999.99"),",",".") + " "
cQuery 	+=EOL+	"    or SE2.E2_VALOR between " + StrTran(Transform((nTitCSL-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitCSL+0.01),"@E 999999999.99"),",",".") + " "
cQuery 	+=EOL+	"    or SE2.E2_VALOR between " + StrTran(Transform((nTitINS-0.01),"@E 999999999.99"),",",".") + " and " + StrTran(Transform((nTitINS+0.01),"@E 999999999.99"),",",".") + ")"

/*
If nTitIRF > 0.01
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform((nTitIRF),"@E 999999999.99"),",",".") + " "
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitIRF,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitIRF,2),"@E 999999999.99"),",",".") + " "
EndIf

If Round(nTitISS,2) == NoRound(nTitISS,2)
	cQuery 	+=EOL+	"    or SE2.E2_VALOR = " + StrTran(Transform((nTitISS),"@E 999999999.99"),",",".") + " "
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitISS,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitISS,2),"@E 999999999.99"),",",".") + " "
EndIf

If Round(nTitCOF,2) == NoRound(nTitCOF,2)
	cQuery 	+=EOL+	"    or SE2.E2_VALOR = " + StrTran(Transform((nTitCOF),"@E 999999999.99"),",",".") + " "
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitCOF,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitCOF,2),"@E 999999999.99"),",",".") + " "
EndIf

If Round(nTitPIS,2) == NoRound(nTitPIS,2)
	cQuery 	+=EOL+	"    or SE2.E2_VALOR = " + StrTran(Transform((nTitPIS),"@E 999999999.99"),",",".") + " "
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitPIS,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitPIS,2),"@E 999999999.99"),",",".") + " "
EndIf
	
If Round(nTitCSL,2) == NoRound(nTitCSL,2)
	cQuery 	+=EOL+	"    or SE2.E2_VALOR = " + StrTran(Transform((nTitCSL),"@E 999999999.99"),",",".") + " "
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitCSL,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitCSL,2),"@E 999999999.99"),",",".") + " "
EndIf

If Round(nTitINS,2) == NoRound(nTitINS,2)
	cQuery 	+=EOL+	"    or SE2.E2_VALOR = " + StrTran(Transform((nTitINS),"@E 999999999.99"),",",".") + ")"
Else
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(Round(nTitINS,2),"@E 999999999.99"),",",".") + " "
	cQuery 	+=EOL+	"  and (SE2.E2_VALOR = " + StrTran(Transform(NoRound(nTitINS,2),"@E 999999999.99"),",",".") + " "
EndIf
*/

MemoWrite("c:\mapa_fin_imp.sql",cQuery)

//Ajusta query
cQuery	:=	ChangeQuery(cQuery)

//Verifica se alias está em uso
If Select("ARQ1") > 0
	DbSelectArea("ARQ1")
	DbCloseArea()
EndIf

TcQuery cQuery New Alias "ARQ1"

Return

/*
--------------------------------------------------------------------------------------------------------------------------------------------
Função: fSEVImp

Tipo: Função Estática

Descrição: Retorna percentual a

Parâmetros:
 - aPar - Array contendo os dados do título principal
 - aPar[1] - Filial
 - aPar[2] - Prefixo
 - aPar[3] - Numero
 - aPar[4] - Parcela
 - aPar[5] - Tipo
 - aPar[6] - Fornecedor
 - aPar[7] - Loja
 - aPar[8] - natureza
 
 Retorno
--------------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function fSEVImp(aPar)

Local cQry := ''
Local nRet := 0

cQry 	:= " Select * "
cQry 	+= " From " + RetSqlName("SEV")
cQry 	+= " Where EV_FILIAL = '" + aPar[1]	+ "' and "
cQry 	+= "  EV_PREFIXO = '" + aPar[2]		+ "' and "
cQry 	+= "  EV_NUM     = '" + aPar[3] 		+ "' and "
cQry 	+= "  EV_PARCELA = '" + aPar[4]		+ "' and "
cQry 	+= "  EV_TIPO    = '" + aPar[5]   	+ "' and "
cQry 	+= "  EV_CLIFOR  = '" + aPar[6] 		+ "' and "
cQry 	+= "  EV_LOJA    = '" + aPar[7]   	+ "' and "
cQry 	+= "  EV_NATUREZ = '" + aPar[8]   	+ "' and "
cQry 	+= "  EV_RECPAG  = 'P'                   and "
cQry 	+= "  D_E_L_E_T_ = ' '"

//MemoWrite("c:\mapafin2.sql",cQuery)
cQry := ChangeQuery(cQry)      

//Verifica se area já existe
If Select("_IMP") > 0
	DbSelectArea("_IMP")
	DbCloseArea()
EndIF

TcQuery cQry New Alias "_IMP"

//Verifica percentual encontrado
nRet := 0
_IMP->(DbGoTop())
While ! _IMP->(EOF())
    
    nRet += _IMP->EV_PERC	
	_IMP->(DbSkip())
EndDo

DbSelectArea("_IMP")
DbCloseArea()

Return(nRet)
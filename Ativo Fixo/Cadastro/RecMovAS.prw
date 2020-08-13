#include 'topconn.ch'
#include 'protheus.ch'

#define APOLICE 		1
#define BENS			2	

#define VINCULAR		1
#define DESVINCULAR	2
#define TRANSFERIR 	3

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRecMovAS  บAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Realizar a Vincula็ใo das Ap๓lices de Seguro   บฑฑ
ฑฑบ          ณ aos Bens                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 8                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RecMovAS()  

Local oDlg
Local oRadio
Local nOpca 		:= 0
Local nRadio		:=	1

Define MsDialog oDlg From 094,001 To 255,293 Title "Tabela Inicial" Pixel
@ 05,07 Say "Escolha a Tabela Inicial" Size 150,007 Of oDlg Pixel
@ 17,07 To 058,140 Of oDlg Pixel
@ 25,10 Radio oRadio Var nRadio Items "Cadastro de Ap๓lices","Cadastro de Bens","Log das Movimenta็๕es" Size 110,010 Of oDlg Pixel
Define sButton From 063,080 Type 1 Enable Of oDlg Action ( nOpca := 1 , oDlg:End() )
Define sButton From 063,110 Type 2 Enable Of oDlg Action ( nOpca := 0 , oDlg:End() )
Activate MsDialog oDlg Centered 

If nOpca == 1

	Private bVinculo	:=	{ || Vinculo(nRadio) 	}
	Private bDesVinc	:=	{ || Desvinculo(nRadio) }
	Private bTransfe	:=	{ || Transfere(nRadio)	}

	Private cDelFunc 	:=	".t." 
	Private cString 	:=	iif( nRadio == 1 , "SNB" , iif( nRadio == 2 , "SN1" , "SZB" ))
	Private cCadastro	:=	iif( nRadio == 1 , "Cadastro de Ap๓lices" , iif( nRadio == 2 , "Cadastro de Bens" , "Log Movimenta็ใo das Ap๓lices" ))
	Private aRotina 	:= { {"Pesquisar"	,"AxPesqui"	,0,1}	,	{"Visualizar"	,"AxVisual"	,0,2} }

	if	nRadio <> 3
		aAdd( aRotina , {"Vincular"		,"Eval(bVinculo)"		,0,4} )
	 	aAdd( aRotina , {"Desvincular"	,"Eval(bDesVinc)"		,0,4} )
		aAdd( aRotina , {"Transferir"  	,"Eval(bTransfe)"		,0,4} )
	endif
	
	dbSelectArea(cString)
	dbSetOrder(1)

	mBrowse(06,01,22,75,cString)

EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVinculo   บAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para vincular os bens เ ap๓lice                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Vinculo(nRadio)

Local w
Local oDlg                     
Local oBem
Local cBem
Local oFont
Local oApol
Local oCabec 
Local oTexto1
Local oTexto2
Local oTexto3
Local cTexto1
Local cTexto2
Local cTexto3

Local nOpc			:=	2
Local nMark			:=	0
Local nMarked		:=	0
Local aBem			:=	{}
Local lTodos		:=	.f.
Local aArea			:=	GetArea()
Local aAreaSN1		:=	SN1->(GetArea())
Local aAreaSNB		:=	SNB->(GetArea())
Local bOk			:=	{ || oDlg:End() , nOpc := 1 } 
Local bCancel 		:=	{ || oDlg:End() , nOpc := 2 } 
Local oOk     		:=	LoadBitmap( GetResources(), "LBOK" 	)
Local oNo     		:=	LoadBitmap( GetResources(), "LBNO" 	)
Local oTik    		:=	LoadBitmap( GetResources(), "LBTIK" )
Local bPesquisa	:=	{ || Pesquisas( aBem , oBem , oDlg ) }
Local bVldAp		:=	{ || ValidApol( @cApol , @oApol , @oDlg , @oCabec , @cCabec , @nRecApol ) }
Local aButtons 	:=	{ { "S4WB011N" , bPesquisa , "Pesquisar" } }
Local nRecApol		:=	iif( nRadio == APOLICE , SNB->(Recno()) , 0 )
Local cCabec		:=	iif( nRadio == APOLICE , Capital(SNB->NB_DESCRIC) , "" )
Local bTexto2		:=	{ || RetTexto2( aBem[oBem:nAt,01] , @nMark , @cTexto2 , @oTexto2 , @oDlg ) }
Local cApol			:=	iif(nRadio == APOLICE,SNB->NB_APOLICE,iif(!Empty(SN1->N1_APOLICE),SN1->N1_APOLICE,CriaVar("NB_APOLICE",.f.)))

if	!Empty( cApol )
	if	nRadio == BENS
		SNB->(dbsetorder(1))
		if	!SNB->( dbseek( xFilial("SNB") + cApol , .f. ))
			Alert("Ap๓lice Nใo Encontrada. Verifique !!!")
			Return ( .t. )	   	
		else
			cCabec 	:= Capital(SNB->NB_DESCRIC)
			nRecApol :=	SNB->(Recno())
		endif
	endif            
	
	if	SNB->NB_DTVENC <= dDataBase
		Alert("Ap๓lice Jแ Vencida. Nใo Serแ Possํvel a Vincula็ใo de Bens.")	
		Return ( .t. )
	endif
endif

Define Font oFont  Name "Tahoma" Size 0,-11 Bold

MsgRun( "Carregando Dados ..." , "" , { || CursorWait() , CargaArray( 1 , @aBem , nRadio , @nMark , @nMarked ) , CursorArrow() } )

if	Len( aBem ) == 0
	Alert( "Nใo Foram Encontrados Bens a Vincular")
	Return ( .t. )
endif

cTexto1	:=	"Quantidade de Bens : " + StrZero(Len(aBem),6)
cTexto2	:=	"Selecionados : " + StrZero(nMark,6)
cTexto3	:=	"Vinculados : " + StrZero(nMarked,6)

Setapilha()
Define MsDialog oDlg Title "Vinculo de Bens" From 000,000 To 027,095 Of oMainWnd
@ 015,005 To 040,370 Label " Ap๓lice de Seguro " Of oDlg Pixel Color CLR_RED
@ 025,010 Say "C๓digo da Apolice" Font oFont Pixel       
@ 023,065 MsGet oApol  Var cApol  Size 080,09 Font oFont Color 8388608 F3 "SNB" Of oDlg Pixel Valid Eval(bVldAp) When Empty(Alltrim(cApol))
@ 023,150 MsGet oCabec Var cCabec Size 215,09 Font oFont Color 8388608 Of oDlg Pixel When .f.
@ 045,005 ListBox oBem Var cBem Fields Header "","Cod do Bem","Item","Descri็ใo","Quantidade" ColSizes 20,35,35,230,50 Size 365,140 Of oDlg Pixel
		oBem:SetArray(aBem)
		oBem:bLDblClick	:= { || iif( aBem[oBem:nAt,01] <> Nil , aBem[oBem:nAt,01] := !aBem[oBem:nAt,01] , Nil ) , Eval( bTexto2 ) } 
		oBem:bHeaderClick	:=	{ || CargaGeral( @oBem , @aBem , @oDlg , @oTexto2 , @cTexto2 , @nMark , @lTodos , oOk , oNo , oTik ) }
		oBem:bLine 			:= { || {	iif(aBem[oBem:nAt,01] == Nil,oTik,iif(aBem[oBem:nAt,01],oOk,oNo)),;
												aBem[oBem:nAt,02] ,;
												aBem[oBem:nAt,03] ,;
												aBem[oBem:nAt,04] ,;
												Transform(aBem[oBem:nAt,05],"@e 999,999,999.99") } }
@ 192,005 Say oTexto1 Var cTexto1 	Font oFont Color 8388608 Size 120,007 Of oDlg Pixel
@ 192,160 Say oTexto2 Var cTexto2 	Font oFont Color 128     Size 120,007 Of oDlg Pixel
@ 192,314 Say oTexto3 Var cTexto3 	Font oFont Color 128     Size 120,007 Of oDlg Pixel
Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtons) Centered
Setapilha()

if	nOpc == 1
	if	nRecApol == 0 
		Alert("Erro na Grava็ใo. Avise ao Cpd.")
	else
		if	MsgYesNo("Confirma Opera็ใo de Vincula็ใo ?")

			SNB->(dbgoto(nRecApol))
	
			For w := 1 to Len(aBem)
				if	aBem[w,1] <> Nil .and. aBem[w,1]	

					SN1->(dbgoto( aBem[w,6] ))
	            
					RecLock("SN1",.f.)
						SN1->N1_APOLICE	:=	SNB->NB_APOLICE
						SN1->N1_CODSEG		:=	SNB->NB_CODSEG
						SN1->N1_DTVENC		:=	SNB->NB_DTVENC
						SN1->N1_CSEGURO	:=	SNB->NB_CSEGURO
					MsUnlock("SN1")

					RecLock("SZB",.t.)
						SZB->ZB_FILIAL		:=	xFilial("SZB")
						SZB->ZB_DATA		:=	dDataBase
						SZB->ZB_APOORI		:=	cApol
						SZB->ZB_DSCAPOR	:= cCabec
						SZB->ZB_BEM			:= aBem[w,02]
						SZB->ZB_ITEM		:= aBem[w,03]
						SZB->ZB_DESCBEM	:= aBem[w,04]
						SZB->ZB_MOVIMEN	:=	"V"	
					MsUnlock("SZB")								
				endif
			Next w
		
			Alert("Opera็ใo de Vincula็ใo Finalizada com Sucesso")
		endif
	endif
endif

RestArea(aAreaSN1)
RestArea(aAreaSNB)
RestArea(aArea)

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidApol บAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunc็ใo para Validar a ap๓lice digitada                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidApol( cApol , oApol , oDlg , oCabec , cCabec , nRecApol )

Local lRet		:=	.t.
Local aArea		:=	SNB->(GetArea())

SNB->(dbsetorder( 1 ))

if	SNB->( dbseek( xFilial("SNB") + cApol , .f. ))
	cCabec 	:=	Capital(SNB->NB_DESCRIC)
	nRecApol :=	SNB->(Recno())

	oCabec:SetText(cCabec)
	oCabec:Refresh()
	oApol:Disable()
	oApol:Refresh()
	oDlg:Refresh()
else
	lRet := .f.
endif	

RestArea(aArea)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCargaArrayบAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o Array com os Bens                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CargaArray( nTipo , aBem , nRadio , nMark , nMarked )

Local cQuery

cQuery	:=	" Select N1_CBASE , N1_ITEM , N1_DESCRIC , N1_QUANTD , N1_APOLICE , R_E_C_N_O_ RECNOSN1"
cQuery	+=	" From " + RetSqlName("SN1")
cQuery	+=	" Where N1_FILIAL   = '" + xFilial("SN1") 				+ "'   and "

if	nTipo == VINCULAR
	cQuery	+=		"  ( N1_APOLICE  = '" + CriaVar("N1_APOLICE",.f.)	+ "'   or  "
	if	nRadio == APOLICE 
		cQuery	+=	"    N1_APOLICE  = '" +	SNB->NB_APOLICE          	+ "' ) and "
	else
		cQuery	+=	"    N1_APOLICE  = '" +	SN1->N1_APOLICE          	+ "' ) and "
	endif
elseif nTipo == DESVINCULAR .or. nTipo == TRANSFERIR
	if	nRadio == APOLICE 
		cQuery	+=	"    N1_APOLICE  = '" +	SNB->NB_APOLICE          	+ "'   and "
	else
		cQuery	+=	"    N1_APOLICE  = '" +	SN1->N1_APOLICE          	+ "'   and "
	endif
endif

cQuery	+=	"    D_E_L_E_T_  = ' ' "
cQuery	+=	" Order By N1_CBASE , N1_ITEM "
cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "TQRY"

TcSetField("TQRY","N1_QUANTD","N",09,03)

Do while TQRY->(!Eof())
	if	nTipo == VINCULAR
		if	!Empty(TQRY->N1_APOLICE)
			aAdd( aBem , { Nil , TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )
			nMarked ++
		else
			if	nRadio == BENS .and. TQRY->N1_CBASE == SN1->N1_CBASE
				aAdd( aBem , { .t. , TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )
				nMark ++ 
	   	else
				aAdd( aBem , { .f. , TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )
			endif
		endif
	elseif nTipo == DESVINCULAR
		if	nRadio == BENS .and. TQRY->N1_CBASE == SN1->N1_CBASE
			aAdd( aBem , { .t. , TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )
			nMark ++ 
   	else
			aAdd( aBem , { .f. , TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )
		endif
		nMarked ++ 
	elseif nTipo == TRANSFERIR
		aAdd( aBem , { TQRY->N1_CBASE , TQRY->N1_ITEM , TQRY->N1_DESCRIC , TQRY->N1_QUANTD , TQRY->RECNOSN1 } )	
	endif
	TQRY->(dbskip())
enddo

TQRY->(dbclosearea())            

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTexto2 บAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para Retornar o Texto Correto da Se็ใo 2             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RetTexto2( lEscolha , nMark , cTexto2 , oTexto2 , oDlg )

if	lEscolha <> Nil
	if	lEscolha
		nMark ++
	else	
		nMark --
	endif
	
	cTexto2	:=	"Selecionados : " + StrZero(nMark,6)
	
	oTexto2:SetText(cTexto2)
	oTexto2:Refresh()
	oDlg:Refresh()
endif

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesquisas บAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para Pesquisar no Array dos Bens                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Pesquisas( aBem , oBem , oDlg )

Local oGet
Local oDlg1
Local nPos		:=	0
Local cGet		:=	CriaVar("N1_CBASE",.f.)

Define MsDialog oDlg1 Title "Digite o Bem" From 000,000 To 100,217 Of oMainWnd Pixel
@ 010,010 MsGet oGet Var cGet Size 090,009 F3 "SN1" Of oDlg1 Pixel
Define SButton From 030,075 Type 1 Enable Of oDlg1 Action oDlg1:End()
Activate MsDialog oDlg1 Centered

if	!Empty(Alltrim(cGet))
	nPos := aScan( aBem , { |x| x[2] == cGet } )
	
	if	nPos > 0
		oBem:nAt	:= nPos
		oBem:SetFocus()
		oBem:Refresh()
		oDlg:Refresh()
	else
		Alert("Bem Nใo Encontrado")
	endif
endif

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCargaGeralบAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para Marcar/Desmarcar os Todos os Bens               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function CargaGeral( oBem , aBem , oDlg , oTexto2 , cTexto2 , nMark , lTodos , oOk , oNo , oTik )

Local t

if	MsgYesNo( iif( lTodos , "Desmarcar " , "Marcar " ) + "Todos ?" )

	nMark := 0
	
	For t := 1 to Len(aBem)
		if	aBem[t,1] <> Nil
			aBem[t,1] := iif( lTodos , .f. , .t. )
			nMark		 += iif( aBem[t,1] , 1 , 0 )
		endif
	Next t
	
	lTodos 	:=	!lTodos
	cTexto2	:=	"Selecionados : " + StrZero(nMark,6)
	
	oTexto2:SetText(cTexto2)
	oTexto2:Refresh()
	
	oBem:SetArray(aBem)

	if	oTik <> Nil
		oBem:bLine 			:= { || {	iif(aBem[oBem:nAt,01] == Nil,oTik,iif(aBem[oBem:nAt,01],oOk,oNo)),;
												aBem[oBem:nAt,02] ,;
												aBem[oBem:nAt,03] ,;
												aBem[oBem:nAt,04] ,;
												Transform(aBem[oBem:nAt,05],"@e 999,999,999.99") } }
	else	
			oBem:bLine 		:= { || {	iif(aBem[oBem:nAt,01],oOk,oNo),;
												aBem[oBem:nAt,02] ,;
												aBem[oBem:nAt,03] ,;
												aBem[oBem:nAt,04] ,;
												Transform(aBem[oBem:nAt,05],"@e 999,999,999.99") } }
	endif
	
	oBem:Refresh()
	oDlg:Refresh()
endif
	
Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDesvinculoบAutor  ณAlexandre Zapponi   บ Data ณ  10/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para vincular os bens เ ap๓lice                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Desvinculo(nRadio)

Local w
Local oDlg                     
Local oBem
Local cBem
Local oFont
Local oApol
Local oCabec 
Local oTexto1
Local oTexto2
Local oTexto3
Local cTexto1
Local cTexto2
Local cTexto3

Local nOpc			:=	2
Local nMark			:=	0
Local nMarked		:=	0
Local aBem			:=	{}
Local lTodos		:=	.f.
Local aArea			:=	GetArea()
Local aAreaSN1		:=	SN1->(GetArea())
Local aAreaSNB		:=	SNB->(GetArea())
Local bOk			:=	{ || oDlg:End() , nOpc := 1 } 
Local bCancel 		:=	{ || oDlg:End() , nOpc := 2 } 
Local oOk     		:=	LoadBitmap( GetResources(), "LBOK" 	)
Local oNo     		:=	LoadBitmap( GetResources(), "LBNO" 	)
Local bPesquisa	:=	{ || Pesquisas( aBem , oBem , oDlg ) }
Local aButtons 	:=	{ { "S4WB011N" , bPesquisa , "Pesquisar" } }
Local nRecApol		:=	iif( nRadio == APOLICE , SNB->(Recno()) , 0 )
Local cCabec		:=	iif( nRadio == APOLICE , Capital(SNB->NB_DESCRIC) , "" )
Local bTexto2		:=	{ || RetTexto2( aBem[oBem:nAt,01] , @nMark , @cTexto2 , @oTexto2 , @oDlg ) }
Local cApol			:=	iif(nRadio == APOLICE,SNB->NB_APOLICE,iif(!Empty(SN1->N1_APOLICE),SN1->N1_APOLICE,CriaVar("NB_APOLICE",.f.)))

if	!Empty( cApol )
	if	nRadio == BENS
		SNB->(dbsetorder(1))
		if	!SNB->( dbseek( xFilial("SNB") + cApol , .f. ))
			Alert("Ap๓lice Nใo Encontrada. Verifique !!!")
			Return ( .t. )	   	
		else
			cCabec 	:= Capital(SNB->NB_DESCRIC)
			nRecApol :=	SNB->(Recno())
		endif
	endif            
else
	if	nRadio == BENS	
   	Alert("Nใo Existe Ap๓lice Vinculada ao Bem")
		Return ( .t. )	   	
	endif
endif

Define Font oFont  Name "Tahoma" Size 0,-11 Bold

MsgRun( "Carregando Dados ..." , "" , { || CursorWait() , CargaArray( 2 , @aBem , nRadio , @nMark , @nMarked ) , CursorArrow() } )

if	Len( aBem ) == 0
	Alert( "Nใo Foram Encontrados Bens a Desvincular")
	Return ( .t. )
endif

cTexto1	:=	"Quantidade de Bens : " + StrZero(Len(aBem),6)
cTexto2	:=	"Selecionados : " + StrZero(nMark,6)
cTexto3	:=	"Vinculados : " + StrZero(nMarked,6)

Setapilha()
Define MsDialog oDlg Title "Vinculo de Bens" From 000,000 To 027,095 Of oMainWnd
@ 015,005 To 040,370 Label " Ap๓lice de Seguro " Of oDlg Pixel Color CLR_RED
@ 025,010 Say "C๓digo da Apolice" Font oFont Pixel       
@ 023,065 MsGet oApol  Var cApol  Size 080,09 Font oFont Color 8388608 F3 "SNB" Of oDlg Pixel When .f.
@ 023,150 MsGet oCabec Var cCabec Size 215,09 Font oFont Color 8388608 Of oDlg Pixel When .f.
@ 045,005 ListBox oBem Var cBem Fields Header "","Cod do Bem","Item","Descri็ใo","Quantidade" ColSizes 20,35,35,230,50 Size 365,140 Of oDlg Pixel
		oBem:SetArray(aBem)
		oBem:bLDblClick	:= { || aBem[oBem:nAt,01] := !aBem[oBem:nAt,01] , Eval( bTexto2 ) } 
		oBem:bHeaderClick	:=	{ || CargaGeral( @oBem , @aBem , @oDlg , @oTexto2 , @cTexto2 , @nMark , @lTodos , oOk , oNo ) }
		oBem:bLine 			:= { || {	iif(aBem[oBem:nAt,01],oOk,oNo),;
												aBem[oBem:nAt,02] ,;
												aBem[oBem:nAt,03] ,;
												aBem[oBem:nAt,04] ,;
												Transform(aBem[oBem:nAt,05],"@e 999,999,999.99") } }
@ 192,005 Say oTexto1 Var cTexto1 	Font oFont Color 8388608 Size 120,007 Of oDlg Pixel
@ 192,160 Say oTexto2 Var cTexto2 	Font oFont Color 128     Size 120,007 Of oDlg Pixel
@ 192,314 Say oTexto3 Var cTexto3 	Font oFont Color 128     Size 120,007 Of oDlg Pixel
Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtons) Centered
Setapilha()

if	nOpc == 1
	if	nRecApol == 0 
		Alert("Erro na Grava็ใo. Avise ao Cpd.")
	else
		if	MsgYesNo("Confirma Opera็ใo de Desvincula็ใo ?")
			SNB->(dbgoto(nRecApol))
	
			For w := 1 to Len(aBem)
				if	aBem[w,1]
	
					SN1->(dbgoto( aBem[w,6] ))
	            
					RecLock("SN1",.f.)
						SN1->N1_APOLICE	:=	""
						SN1->N1_CODSEG		:=	""
						SN1->N1_DTVENC		:=	CtoD("")
						SN1->N1_CSEGURO	:=	""
					MsUnlock("SN1")

					RecLock("SZB",.t.)
						SZB->ZB_FILIAL		:=	xFilial("SZB")
						SZB->ZB_DATA		:=	dDataBase
						SZB->ZB_APOORI		:=	cApol
						SZB->ZB_DSCAPOR	:= cCabec
						SZB->ZB_BEM			:= aBem[w,02]
						SZB->ZB_ITEM		:= aBem[w,03]
						SZB->ZB_DESCBEM	:= aBem[w,04]
						SZB->ZB_MOVIMEN	:=	"D"	
					MsUnlock("SZB")
				endif
			Next w

			Alert("Opera็ใo de Desvincula็ใo Finalizada com Sucesso")
		endif
	endif
endif

RestArea(aAreaSN1)
RestArea(aAreaSNB)
RestArea(aArea)

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransfere บAutor  ณAlexandre Zapponi   บ Data ณ  14/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para vincular os bens เ ap๓lice                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Transfere(nRadio)

Local w
Local oDlg                     
Local oBem
Local cBem
Local oFont
Local oApol1
Local oApol2
Local oCabec1
Local oCabec2
Local oTexto1

Local nOpc			:=	2
Local nRecApol1	:=	0
Local nRecApol2	:=	0
Local aArea			:=	GetArea()
Local aAreaSN1		:=	SN1->(GetArea())
Local aAreaSNB		:=	SNB->(GetArea())
Local aBem			:=	{{"","","",0.00}}
Local cApol1		:=	CriaVar("NB_APOLICE",.f.)
Local cApol2		:=	CriaVar("NB_APOLICE",.f.)
Local cCabec1		:=	CriaVar("NB_DESCRIC",.f.)
Local cCabec2		:=	CriaVar("NB_DESCRIC",.f.)
Local bOk			:=	{ || oDlg:End() , nOpc := 1 } 
Local bCancel 		:=	{ || oDlg:End() , nOpc := 2 } 
Local cTexto1		:=	"Quantidade de Bens : 000000" 
Local bVldAp1		:=	{ || ValidApol( @cApol1 , @oApol1 , @oDlg , @oCabec1 , @cCabec1 , @nRecApol1 ) }
Local bVldAp2		:=	{ || ValidApol( @cApol2 , @oApol2 , @oDlg , @oCabec2 , @cCabec2 , @nRecApol2 ) }               
Local bRetVal		:=	{ || Ajusta( @oDlg , @oBem , @aBem , @oTexto1 , @cTexto1 , nRecApol1 ) }
Local bCarga		:=	{ || iif( Eval(bVldAp1) , Eval(bRetVal) , .f. ) }

Define Font oFont  Name "Tahoma" Size 0,-11 Bold

Setapilha()
Define MsDialog oDlg Title "Transfer๊ncia de Bens" From 000,000 To 031,095 Of oMainWnd
@ 015,005 To 040,370 Label " Ap๓lice de Seguro Anterior " Of oDlg Pixel Color CLR_RED
@ 025,010 Say "C๓digo da Apolice" Font oFont Pixel       
@ 023,065 MsGet oApol1	Var cApol1  Size 080,09 Font oFont Color 8388608 F3 "SNB" Of oDlg Pixel Valid Eval(bCarga)
@ 023,150 MsGet oCabec1 Var cCabec1 Size 215,09 Font oFont Color 8388608 Of oDlg Pixel When .f.
@ 045,005 To 070,370 Label " Ap๓lice de Seguro Atual " Of oDlg Pixel Color CLR_RED
@ 055,010 Say "C๓digo da Apolice" Font oFont Pixel       
@ 053,065 MsGet oApol2  Var cApol2  Size 080,09 Font oFont Color 8388608 F3 "SNB" Of oDlg Pixel Valid Eval(bVldAp2) 
@ 053,150 MsGet oCabec2 Var cCabec2 Size 215,09 Font oFont Color 8388608 Of oDlg Pixel When .f.
@ 075,005 ListBox oBem Var cBem Fields Header "Cod do Bem","Item","Descri็ใo","Quantidade" ColSizes 40,40,240,50 Size 365,140 Of oDlg Pixel
		oBem:SetArray(aBem)
		oBem:bLine := { || {aBem[oBem:nAt,01],aBem[oBem:nAt,02],aBem[oBem:nAt,03],Transform(aBem[oBem:nAt,04],"@e 999,999,999.99")}}
@ 222,005 Say oTexto1 Var cTexto1 	Font oFont Color 8388608 Size 120,007 Of oDlg Pixel
Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered
Setapilha()

if	nOpc == 1
	if	nRecApol1 == 0 .and. nRecApol2 == 0
		Alert("Erro na Grava็ใo. Avise ao Cpd.")
	else
		if	MsgYesNo("Confirma Opera็ใo de Transfer๊ncia ?")	

			SNB->(dbgoto(nRecApol2))
	
			For w := 1 to Len(aBem)
	
				SN1->(dbgoto( aBem[w,5] ))
            
				RecLock("SN1",.f.)
					SN1->N1_APOLICE	:=	SNB->NB_APOLICE
					SN1->N1_CODSEG		:=	SNB->NB_CODSEG
					SN1->N1_DTVENC		:=	SNB->NB_DTVENC
					SN1->N1_CSEGURO	:=	SNB->NB_CSEGURO
				MsUnlock("SN1")

				RecLock("SZB",.t.)
					SZB->ZB_FILIAL		:=	xFilial("SZB")
					SZB->ZB_DATA		:=	dDataBase
					SZB->ZB_APOORI		:=	cApol1
					SZB->ZB_DSCAPOR	:= cCabec1
					SZB->ZB_APODEST	:=	cApol2
					SZB->ZB_DSCAPDE	:=	cCabec2
					SZB->ZB_BEM			:= aBem[w,01]
					SZB->ZB_ITEM		:= aBem[w,02]
					SZB->ZB_DESCBEM	:= aBem[w,03]
					SZB->ZB_MOVIMEN	:=	"T"	
				MsUnlock("SZB")
			Next w

			Alert("Opera็ใo de Transfer๊ncia Finalizada com Sucesso")
		endif
	endif
endif

RestArea(aAreaSN1)
RestArea(aAreaSNB)
RestArea(aArea)

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta    บAutor  ณAlexandre Zapponi   บ Data ณ  14/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para carregar o array dos bens na transfer๊ncia      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Ajusta( oDlg , oBem , aBem , oTexto1 , cTexto1 , nRecApol1 )

Local aTmp		:=	{}
Local aArea		:=	SNB->(GetArea())

SNB->(dbgoto(nRecApol1))

MsgRun( "Carregando Dados ..." , "" , { || CursorWait() , CargaArray( 3 , @aTmp , APOLICE ) , CursorArrow() } )

if	Len(aTmp) == 0
	Alert("Nใo Foram Encontrados os Bens Pertencentes a Ap๓lice de Origem. Verifique !!!")
else
	aBem 		:=	aClone(aTmp)
	cTexto1 	:= "Quantidade de Bens : " + StrZero(Len(aBem),6)

	oBem:SetArray(aBem)
	oBem:bLine := { || {aBem[oBem:nAt,01],aBem[oBem:nAt,02],aBem[oBem:nAt,03],Transform(aBem[oBem:nAt,04],"@e 999,999,999.99")}}

	oTexto1:SetText(cTexto1)
	oTexto1:Refresh()
	oBem:Refresh()
	oDlg:Refresh()
endif

Return ( Len(aTmp) <> 0 )
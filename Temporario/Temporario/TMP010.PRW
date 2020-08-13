#include "protheus.ch"
#include "topconn.ch"                             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTCR120  ³ Autor ³ EDMILSON D. SANTOS    ³ Data ³ 09.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ POSICAO DOS BENS ATIVOS E DEPRECIADOS                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//User Function RTCR120()
User Function TMP010()

Local cString 		:=	"SN3"
Local cDesc1  		:= "Este relatorio ira' imprimir a rela‡„o bens ativos e"
Local cDesc2  		:= "depreciados entre um periodo. Podera' ser impresso por"
Local cDesc3  		:= ""
Local wnrel			:= "RTCR120"
Local aPergs  		:=	{}
Local aOrd			:=	{"Conta Contabil","Centro de Custo"}
Local nTamCC   	:=	Len(CriaVar("N3_CCUSTO",.f.))
Local nTamConta	:=	Len(CriaVar("N3_CCONTAB",.f.))

Private Cabec1
Private Cabec2
Private aReturn  	:= {OemToAnsi("Zebrado"),01,OemToAnsi("Administracao"),02,02,01,"",01}
Private aLinha   	:= {}
Private cPerg    	:= "RTC120    "
Private NomeProg 	:= "RTCR120"
Private nLastKey 	:= 0
Private Tamanho  	:= "G"
Private Titulo   	:= OemToAnsi("RELACAO DOS BENS ATIVOS E DEPRECIADOS")

AjustaSx1("RTC120",aPergs)

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da Conta                              ³
//³ mv_par02            // Ate a Conta                           ³
//³ mv_par03            // Do Centro Custo                       ³
//³ mv_par04            // Ate o Centro Custo                    ³
//³ mv_par05            // A partir da data                      ³
//³ mv_par06            // Ate a Data                            ³
//³ mv_par07            // Da Filial                             ³
//³ mv_par08            // Ate a Filial                          ³
//³ mv_par09            // Do Bem                                ³
//³ mv_par10            // Ate o Bem                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd)

ContaDe   	:= Substr( mv_par01 , 01 , nTamConta )
ContaAte  	:=	Substr( mv_par02 , 01 , nTamConta )
CcDe      	:= Substr( mv_par03 , 01 , nTamCC )
CcAte     	:= Substr( mv_par04 , 01 , nTamCC )
DatDe     	:= mv_par05
DatAte    	:= mv_par06
FilialDe  	:= mv_par07
FilialAte 	:= mv_par08
BemDe     	:= mv_par09
BemAte   	:= mv_par10

ContaDe   	+= Space( nTamConta - Len( ContaDe ) )
ContaAte  	+=	Space( nTamConta - Len( ContaAte ) )
CcDe      	+= Space( nTamCC - Len( CcDe ) )
CcAte     	+= Space( nTamCC - Len( CcAte ) )

If nLastKey == 27
	Return
End

SetDefault( aReturn,cString )

If nLastKey == 27
	Return
End

RptStatus( { |lEnd| FR120Imp(@lEnd,wnRel,cString) } , Titulo )

iif( Select("TRX") > 0 , TRX->(dbCloseArea()) , Nil )
iif( Select("TRB") > 0 , TRB->(dbCloseArea()) , Nil )

Return

/**************************************************************/

Static Function FR120Imp(lEnd,WnRel,cString)

Local cQry
Local nPos  		:= 0
Local nPos2  		:= 0
Local nResidual 	:= 0
Local nValAtual 	:= 0
Local cPos  		:= ""
Local cPesq 		:= ""
Local aPrint    	:=	{} 
Local aItens    	:=	{} 
Local aAreaTmp  	:=	{} 
Local aTotLin   	:=	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
Local aTotGer   	:=	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
Local lCont			:=	.f.
Local lFound 		:=	.f.
Local lFound2 		:=	.f.
Local lPriVez		:=	.f.
Local dData			:=	Ctod("")     
Local dPriDia		:=	CalcDia(mv_par06,1)
Local dUltDia		:=	CalcDia(mv_par06,2)     

nOrdem 	:= aReturn[8]

dbSelectArea("SN3")
SN3->(dbsetorder(iif(nOrdem == 1,2,3)))
SN3->(dbgotop())
SN3->(dbseek( xFilial("SN3") + iif( nOrdem == 1 , ContaDe + BemDe , CcDe + BemDe ) , .t. ))

li       := 80
m_pag    := 01
cbcont   := 00
nMoeda 	:= 01
cString  := "SN3"
cbtxt    := Space(10)
cMoeda 	:= Str(nMoeda,1)
Titulo 	:=	"BENS ATIVOS E DEPRECIADOS POR " + iif( nOrdem == 1 , "CONTA" , "C.CUSTO" )
TItulo 	+=	" - ENTRE: " + DtoC(mv_par05) + " a " + DtoC(mv_par06)
cabec1   := "Codigo        Corr.Periodo  Descricao do Bem                              ST                                                                Aquisic.          Vlr.Corrigido           Dep.Acum. R$              Vlr Residual" 
cabec2   := "Dep.Per. UFIR   Dep.Per.R$                                                                                                                 Vl.Aquis.            Qtde UFIR             Dep. Ac.UFIR                % Deprec  "  
cInicio  := "SN3->N3_FILIAL + " + iif(nOrdem == 1,"SN3->(N3_CCONTAB + N3_CBASE)","SN3->(N3_CCUSTO + N3_CBASE)")
cFim     := xFilial("SN3") + iif( nOrdem == 1 , ContaAte + BemAte , CcAte + BemAte )

SetRegua(SN3->(RecCount()))

While !Eof() .and. &cInicio <= cFim
	
	IncRegua()

	If SN3->N3_CCONTAB < mv_par01 .or. SN3->N3_CCONTAB > mv_par02 .or. ;
		SN3->N3_CCUSTO  < mv_par03 .or. SN3->N3_CCUSTO  > mv_par04 .or. ;
		SN3->N3_AQUISIC < mv_par05 .or. SN3->N3_AQUISIC > mv_par06 .or. ;
		SN3->N3_CBASE   < mv_par09 .or. SN3->N3_CBASE   > mv_par10 
		dbSkip()
		Loop
	Endif
		
	lFound 	:=	.t.
	lFound2 	:=	.t.
	dData		:=	CtoD("")	
	lRet 		:=	iif( Empty(SN3->N3_DTBAIXA) , .t. , .f. )

	if	!Empty(SN3->N3_DTBAIXA)
		lRet	:=	iif( Year(SN3->N3_DTBAIXA) < 2007 , .f. , .t. )
		if	Substr(DtoS(SN3->N3_DTBAIXA),1,6) == Substr(DtoS(mv_par06),1,6)  // Baixa Dentro do Mes
			dData	:=	SN3->N3_DTBAIXA

			if	SN3->N3_DTBAIXA < mv_par06
				aAreaTmp := SN3->(GetArea())
				
				cPesq	:=	SN3->( N3_FILIAL + N3_CBASE + N3_ITEM + N3_TIPO ) + "0"

				SN3->(dbsetorder(1))
				SN3->(dbgotop())
				if	!SN3->(dbseek( cPesq , .f. ))
					lFound	:=	.f.
				else
					lFound	:=	Nil
				endif
			
				RestArea(aAreaTmp)	
		   endif
	   elseif	Substr(DtoS(SN3->N3_DTBAIXA),1,6) < Substr(DtoS(mv_par06),1,6)  // Baixa no Mes Anterior
  			lRet := .f.
	   elseif	Substr(DtoS(SN3->N3_DTBAIXA),1,6) > Substr(DtoS(mv_par06),1,6)  // Baixa no Mes Posterior
			aAreaTmp := SN3->(GetArea())

			cPesq	:=	SN3->( N3_FILIAL + N3_CBASE + N3_ITEM + N3_TIPO ) + "0"

			SN3->(dbsetorder(1))
			SN3->(dbgotop())
			if	!SN3->(dbseek( cPesq , .f. ))
				lFound2 := .f.
			endif

			RestArea(aAreaTmp)	
	   endif
   endif
   
	if	lRet
		cPos	:=	iif( nOrdem == 1 , SN3->N3_CCONTAB , SN3->N3_CCUSTO )	
		nPos	:=	aScan( aPrint , { |x| x[1] == cPos 				.and. x[2] == SN3->N3_CBASE  .and. ;
												 x[3] == SN3->N3_ITEM   .and. x[4] == SN3->N3_TIPO   .and. ;
												 x[5] == dData } )	 		
												 
		if	nPos == 0
			aAdd( aPrint , Array(28) )
			nPos := Len(aPrint)
			For t := 1 to Len(aPrint[nPos])
				aPrint[nPos,t]	:=	0.00
			Next t
			aPrint[nPos,01] := cPos
			aPrint[nPos,02] := SN3->N3_CBASE
			aPrint[nPos,03] := SN3->N3_ITEM 
			aPrint[nPos,04] := SN3->N3_TIPO 
			aPrint[nPos,05] := dData
			aPrint[nPos,07] := Left(Posicione("SN1",1,xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM,"N1_DESCRIC"),43)
			aPrint[nPos,08] := Posicione("SN1",1,xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM,"N1_AQUISIC")
			aPrint[nPos,27] := lFound
			aPrint[nPos,28] := lFound2
		endif
	endif

	dbSelectArea("SN3")
	SN3->(dbSkip())	
EndDo

dbSelectArea("SN3")
SN3->(dbsetorder(iif(nOrdem == 1,2,3)))
SN3->(dbgotop())
SN3->(dbseek( xFilial("SN3") + iif( nOrdem == 1 , ContaDe + BemDe , CcDe + BemDe ) , .t. ))

SetRegua(SN3->(RecCount()))

While !Eof() .and. &cInicio <= cFim
	
	IncRegua()

	If SN3->N3_CCONTAB < mv_par01 .or. SN3->N3_CCONTAB > mv_par02 .or. ;
		SN3->N3_CCUSTO  < mv_par03 .or. SN3->N3_CCUSTO  > mv_par04 .or. ;
		SN3->N3_AQUISIC < mv_par05 .or. SN3->N3_AQUISIC > mv_par06 .or. ;
		SN3->N3_CBASE   < mv_par09 .or. SN3->N3_CBASE   > mv_par10 
		dbSkip()
		Loop
	Endif

	dData	:=	CtoD("")
	lRet 	:=	iif(  Empty(SN3->N3_DTBAIXA) , .t. , iif( Year(SN3->N3_DTBAIXA) < 2007 , .f. , .t. ) )

	if	!Empty(SN3->N3_DTBAIXA)
		if	Year(SN3->N3_DTBAIXA) == Year(mv_par06) .and. Month(SN3->N3_DTBAIXA) == Month(mv_par06)
			dData	:=	SN3->N3_DTBAIXA
	   endif
	endif

	if	!lRet
		SN3->(dbskip())
		Loop
	endif

	cPos	:=	iif( nOrdem == 1 , SN3->N3_CCONTAB , SN3->N3_CCUSTO )	
	nPos	:=	aScan( aPrint , { |x| x[1] == cPos 				.and. x[2] == SN3->N3_CBASE  .and. ;
											 x[3] == SN3->N3_ITEM   .and. x[4] == SN3->N3_TIPO   .and. ;
											 x[5] == dData } )	 		

	if	nPos == 0
		SN3->(dbskip())
		Loop
	endif

	nValAtual 			:=	SN3->(N3_VORIG1 + N3_AMPLIA1 + N3_VRCACM1)                                 
	nResidual 			:= SN3->(N3_VORIG1 + N3_VRCACM1 + N3_AMPLIA1) 
	nResidual 			+= ( SN3->(N3_VRDACM1 + N3_VRCDA1) * iif( SN3->N3_TIPO == "05" , 1 , -1 ) )	

	if	!aPrint[nPos,28]  // Baixa Total no Mes Posterior
   	aPrint[nPos,06]	+=	SN3->N3_VRCMES1
		aPrint[nPos,09] 	+= SN3->(N3_VORIG1 + N3_AMPLIA1 + N3_VRCACM1)	
		aPrint[nPos,10] 	+= SN3->N3_VRDACM1 					
		aPrint[nPos,11] 	+= nValAtual - SN3->N3_VRDACM1 	
		aPrint[nPos,14] 	+=	SN3->N3_VORIG1 
		aPrint[nPos,15] 	+=	SN3->N3_VORIG3 
		aPrint[nPos,16] 	+=	SN3->N3_VRDACM3
		aPrint[nPos,17] 	+=	SN3->N3_VRDACM1
		aPrint[nPos,19] 	+=	SN3->N3_VORIG1 	  	
	else
		if aPrint[nPos,27] <> Nil .and. aPrint[nPos,27]  // Baixa Total no Mes Atual
			if	Empty(SN3->N3_DTBAIXA) .or. ( !Empty(SN3->N3_DTBAIXA) .and. SN3->N3_DTBAIXA > mv_par06 ) 
				aPrint[nPos,06]	+=	SN3->N3_VRCMES1
				aPrint[nPos,09] 	+= SN3->(N3_VORIG1 + N3_AMPLIA1 + N3_VRCACM1)	
				aPrint[nPos,10] 	+= SN3->N3_VRDACM1 					
				aPrint[nPos,11] 	+= nValAtual - SN3->N3_VRDACM1 	
				aPrint[nPos,14] 	+=	SN3->N3_VORIG1 
				aPrint[nPos,15] 	+=	SN3->N3_VORIG3 
				aPrint[nPos,16] 	+=	SN3->N3_VRDACM3
				aPrint[nPos,17] 	+=	SN3->N3_VRDACM1
				aPrint[nPos,19] 	+=	SN3->N3_VORIG1 	  	
			elseif !Empty(SN3->N3_DTBAIXA) .and. Substr(DtoS(SN3->N3_DTBAIXA),1,6) == Substr(DtoS(dUltDia),1,6)
				aPrint[nPos,06]	+=	SN3->N3_VRCMES1
				aPrint[nPos,09] 	+= SN3->(N3_VORIG1 + N3_AMPLIA1 + N3_VRCACM1)	
				aPrint[nPos,10] 	+= SN3->N3_VRDACM1 					
				aPrint[nPos,11] 	+= nValAtual - SN3->N3_VRDACM1 	
				aPrint[nPos,14] 	+=	SN3->N3_VORIG1 
				aPrint[nPos,15] 	+=	SN3->N3_VORIG3 
				aPrint[nPos,16] 	+=	SN3->N3_VRDACM3
				aPrint[nPos,17] 	+=	SN3->N3_VRDACM1
				aPrint[nPos,19] 	+=	SN3->N3_VORIG1 	  	
			else
				SN3->(dbskip())
				Loop
		   endif
		endif
	endif
		
	cQry 	:= " select * "
	cQry 	+= " from " + RetSqlName("SN4")
	cQry	+= " where n4_filial  = '" + xFilial("SN4")	+ "' and "
	cQry 	+= 		" n4_cbase   = '" + sn3->n3_cbase	+ "' and "
	cQry 	+= 		" n4_item    = '" + sn3->n3_item 	+ "' and "
	cQry 	+= 		" n4_tipo    = '" + sn3->n3_tipo 	+ "' and "
	cQry 	+= 		" n4_data   >= '" + DtoS(dPriDia)	+ "' and "
	cQry 	+= 		" n4_data   <= '" + DtoS(dUltDia)	+ "' and "
	cQry 	+= 		" n4_ocorr   = '06' and "
	cQry 	+= 		" n4_tipocnt = '4'  and "
	cQry 	+= 		" d_e_l_e_t_ = ' ' "
	cQry	:=	ChangeQuery(cQry)		

	TcQuery cQry New Alias "TRX"
	
	aEval(SN4->(dbstruct()),{ |x| iif(x[2]<>"C",TcSetField("TRX",x[1],x[2],x[3],x[4]),Nil)})

	do while TRX->(!Eof())
		if	aPrint[nPos,27] == Nil .or. ( aPrint[nPos,27] .and. aPrint[nPos,28] )
			if	Empty(SN3->N3_DTBAIXA)
				lCont := .t.
				if	!Empty(TRX->N4_MOTIVO)				
					nPos2	:=	aScan( aPrint , { |x| x[1] == cPos 				.and. x[2] == SN3->N3_CBASE  .and. ;
															 x[3] == SN3->N3_ITEM   .and. x[4] == SN3->N3_TIPO   .and. ;
															 x[5] == TRX->N4_DATA 	} )	 		
					if	nPos2 > 0			
						lCont := .f.		
					endif	
		      endif
	
				if	lCont
					aPrint[nPos,12] 	+= TRX->N4_VLROC3
					aPrint[nPos,13] 	+= TRX->N4_VLROC1
		      endif
			else
				if	!Empty(TRX->N4_MOTIVO) .and. SN3->N3_DTBAIXA == TRX->N4_DATA
					nPos2	:=	aScan( aPrint , { |x| x[1] == cPos 				.and. x[2] == SN3->N3_CBASE  .and. ;
															 x[3] == SN3->N3_ITEM   .and. x[4] == SN3->N3_TIPO   .and. ;
															 x[5] == TRX->N4_DATA 	} )	 		
					if	nPos2 > 0			
						aPrint[nPos2,12] 	+= TRX->N4_VLROC3
						aPrint[nPos2,13] 	+= TRX->N4_VLROC1
					endif	
				endif
	      endif
		else
			aPrint[nPos,12] 	+= TRX->N4_VLROC3
			aPrint[nPos,13] 	+= TRX->N4_VLROC1
      endif
		TRX->(dbskip())
	enddo

   TRX->(dbclosearea())

	if	Empty(SN3->N3_DTBAIXA)		

		cQry 	:=	" select * "
		cQry 	+= " from "+RetSqlName("SN4")
		cQry 	+= " where n4_filial  = '" + xFilial("SN4")	+ "' and "
		cQry 	+= 		" n4_cbase   = '" + sn3->n3_cbase	+ "' and "
		cQry 	+= 		" n4_item    = '" + sn3->n3_item 	+ "' and "
		cQry 	+= 		" n4_tipo    = '" + sn3->n3_tipo 	+ "' and "
		cQry 	+= 		" n4_data    > '" + dtos(mv_par06)	+ "' and "
		cQry 	+= 		" n4_ocorr   = '06' and "
		cQry 	+= 		" n4_tipocnt = '4'  and "
		cQry 	+= 		" d_e_l_e_t_ = ' ' "
		cQry	:=	ChangeQuery(cQry)	
		
		TcQuery cQry New Alias "TRB"
	
		aEval(SN4->(dbstruct()),{ |x| iif(x[2]<>"C",TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})
	
		do while TRB->(!Eof())
			if	aPrint[nPos,27] <> Nil .and. aPrint[nPos,27]
				aPrint[nPos,10] -= TRB->N4_VLROC1
			endif
			aPrint[nPos,11] += TRB->N4_VLROC1 
			aPrint[nPos,18] += TRB->N4_VLROC1 
			TRB->(dbskip())
		enddo
	
	   TRB->(dbclosearea())
	endif			
	
	dbSelectArea("SN3")
	SN3->(dbSkip())	
EndDo

aPrint 		:=	aSort( aPrint ,,, { |x,y| x[1] + x[2] + x[3] + x[4] + DtoS(x[5]) < y[1] + y[2] + y[3] + y[4] + DtoS(y[5]) } )
ImpConta 	:= .f.
ImpCusto 	:= .f.
cPos			:=	iif( Len(aPrint) > 0 , aPrint[1,1] , "" )

SetRegua(Len(aPrint))

For t := 1 to Len(aPrint)
	
	IncRegua()	
    
    if	cPos <> aPrint[t,1]

		if li > 58 .or. ( li + 3 ) > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
			ImpConta := .t.
			ImpCusto := .t.
		endif

		if nOrdem == 1	.and. ImpConta
			@    li, 00 psay "CONTA: " + cPos + " - " + Posicione("CT1",1,xFilial("CT1") + cPos,"CT1_DESC01")
			@ ++ li, 00 psay Replicate("-",220)
			li ++
			ImpConta := .f.
		elseif nOrdem == 2 .and. ImpCusto
			@    li, 00 psay "C.CUSTO: " + cPos + " - " + Posicione("CTT",1,xFilial("CTT") + cPos,"CTT_DESC01")
			@ ++ li, 00 psay Replicate("-",220)
			li ++
			ImpCusto := .f.
		endif
		@ ++ li,000 psay Replicate("-",220)
		@ ++ li,000 psay iif( nOrdem == 1,"TOTAL GERAL CONTA: ","TOTAL GERAL C.CUSTO: ")
		@    li,022 psay aTotLin[06] Picture "@E 999,999,999.9999"    	//CORRECAO DO MES
		@    li,156 psay aTotLin[09] Picture "@E 999,999,999.99"    	//VALOR ATUAL
		@    li,180 psay aTotLin[10] Picture "@E 999,999,999.99" 	  	//DEPRECIACAO ACUMULADA
		@    li,204 psay aTotLin[11] Picture "@E 999,999,999.99"   		//RESIDUAL
		@ ++ li,000 psay aTotLin[12] Picture "@E 999,999,999.9999"
		@    li,022 psay aTotLin[13] Picture "@E 999,999,999.99"
		@    li,132 psay aTotLin[14] Picture "@E 999,999,999.99"
		@    li,152 psay aTotLin[15] Picture "@E 999,999,999,999.9999"
		@    li,180 psay aTotLin[16] Picture "@E 999,999,999.9999"
		@ ++ li,000 psay Replicate("-",220)

		li += 2

		ImpConta := .t.
		ImpCusto := .t.
		cPos 		:=	aPrint[t,1]
		aTotLin 	:=	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
	endif

	if li > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		ImpConta := .t.
		ImpCusto := .t.
	endif
	
	if nOrdem == 1	.and. ImpConta
		if li > 58 .or. ( li + 3 ) > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		endif	
		@    li, 00 psay "CONTA: " + cPos + " - " + Posicione("CT1",1,xFilial("CT1") + cPos,"CT1_DESC01")
		@ ++ li, 00 psay Replicate("-",220)
		li ++
		ImpConta := .f.
	elseif nOrdem == 2 .and. ImpCusto
		if li > 58 .or. ( li + 3 ) > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		endif	
		@    li, 00 psay "C.CUSTO: " + cPos + " - " + Posicione("CTT",1,xFilial("CTT") + cPos,"CTT_DESC01")
		@ ++ li, 00 psay Replicate("-",220)
		li ++
		ImpCusto := .f.
	endif

	@    li,000 psay aPrint[t,02]
	@    li,014 psay aPrint[t,06]	Picture "@E 9,999,999.9999"
	@    li,029 psay aPrint[t,07]
	@    li,140 psay aPrint[t,08]									//Aquisição
	@    li,156 psay aPrint[t,09]	Picture "@E 999,999,999.99"  	//Valor corrigido
	@    li,180 psay aPrint[t,10] 	Picture "@E 999,999,999.99"  	//Dep. Acum. R$
	@    li,204 psay aPrint[t,11] 	Picture "@E 999,999,999.99"  	//Vlr residual
	
	@ ++ li,000 psay aPrint[t,12] 	Picture "@E 9999,999.9999"

	@    li,014 psay aPrint[t,13] 	Picture "@E 9,999,999.99"
	@    li,132 psay aPrint[t,14]	Picture "@E 999,999,999.99"
	@    li,156 psay aPrint[t,15]	Picture "@E 999,999,999.9999"
	@    li,180 psay aPrint[t,16] 	Picture "@E 999,999,999.9999"
	@    li,212 psay ((( aPrint[t,17] - aPrint[t,18] ) / aPrint[t,19] ) * 100 ) Picture "@E 999.99"

	li ++
		
	For k := 1 to ( Len(aPrint[t]) - 2 )
		aTotLin[k]	+=	iif( ValType(aPrint[t,k]) == "N" , aPrint[t,k] , 0 )
		aTotGer[k]	+=	iif( ValType(aPrint[t,k]) == "N" , aPrint[t,k] , 0 )
	Next k
Next t

if li <> 80       

	if li > 58 .or. ( li + 3 ) > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		ImpConta := .t.
		ImpCusto := .t.
	endif
	
	if nOrdem == 1	.and. ImpConta
		if li > 58 .or. ( li + 3 ) > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		endif	
		@    li, 00 psay "CONTA: " + cPos + " - " + Posicione("CT1",1,xFilial("CT1") + cPos,"CT1_DESC01")
		@ ++ li, 00 psay Replicate("-",220)
		li ++
		ImpConta := .f.
	elseif nOrdem == 2 .and. ImpCusto
		if li > 58 .or. ( li + 3 ) > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
		endif	
		@    li, 00 psay "C.CUSTO: " + cPos + " - " + Posicione("CTT",1,xFilial("CTT") + cPos,"CTT_DESC01")
		@ ++ li, 00 psay Replicate("-",220)
		li ++
		ImpCusto := .f.
	endif

	@    li,000 psay Replicate("-",220)
	@ ++ li,000 psay iif( nOrdem == 1,"TOTAL GERAL CONTA: ","TOTAL GERAL C.CUSTO: ")
	@    li,022 psay aTotLin[06] Picture "@E 999,999,999.9900"    	//CORRECAO DO MES
	@    li,156 psay aTotLin[09] Picture "@E 999,999,999.99"    	//VALOR ATUAL
	@    li,180 psay aTotLin[10] Picture "@E 999,999,999.99" 	  	//DEPRECIACAO ACUMULADA
	@    li,204 psay aTotLin[11] Picture "@E 999,999,999.99"   		//RESIDUAL
	@ ++ li,000 psay aTotLin[12] Picture "@E 999,999,999.9999"   	
	@    li,022 psay aTotLin[13] Picture "@E 999,999,999.99"
	@    li,132 psay aTotLin[14] Picture "@E 999,999,999.99"
	@    li,152 psay aTotLin[15] Picture "@E 999,999,999,999.9999"
	@    li,180 psay aTotLin[16] Picture "@E 999,999,999.9999"
	@ ++ li,000 psay Replicate("-",220)


	if li > 58 .or. ( li + 3 ) > 58
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,iif(aReturn[4]==1,15,18))
	endif
                                    
	@ ++ li,000 psay "TOTAL GERAL:"
	@    li,022 psay aTotGer[06] Picture "@E 999,999,999.9999"    	//CORRECAO DO MES
	@    li,156 psay aTotGer[09] Picture "@E 999,999,999.99"    	//VALOR ATUAL
	@    li,180 psay aTotGer[10] Picture "@E 999,999,999.99" 	  	//DEPRECIACAO ACUMULADA
	@    li,204 psay aTotGer[11] Picture "@E 999,999,999.99"   		//RESIDUAL
	@ ++ li,000 psay aTotGer[12] Picture "@E 999,999,999.9999"   	
	@    li,022 psay aTotGer[13] Picture "@E 999,999,999.999"
	@    li,132 psay aTotGer[14] Picture "@E 999,999,999.999"
	@    li,152 psay aTotGer[15] Picture "@E 999,999,999,999.9999"
	@    li,180 psay aTotGer[16] Picture "@E 999,999,999.9999"
	@ ++ li,000 psay Replicate("-",220)
	
	Roda(cbcont,cbtxt)
endif

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

Return

/****************************************************************/

Static Function AjustaSX1(cPerg, aPergs)

Local nCondicao
Local _sAlias		:= Alias()
Local aCposSX1		:= {}
Local nX 			:= 0
Local lAltera		:= .f.
Local cKey			:= ""
Local nJ				:=	0      

Aadd(aPergs,{"Da Conta	  ?","","","mv_ch1","C",20,0,0,"G","","mv_par01","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Conta   ?","","","mv_ch2","C",20,0,0,"G","","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do C.Custo  ?","","","mv_ch3","C",9,0,0,"G","","mv_par03","","","","      " ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate C.Custo ?","","","mv_ch4","C",9,0,0,"G","","mv_par04","","","","ZZZZZZ" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Emissao  ?","","","mv_ch5","D",8,0,0,"G","","mv_par05","","","","      " ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao ?","","","mv_ch6","D",8,0,0,"G","","mv_par06","","","","ZZZZZZ" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Filial   ?","","","mv_ch7","C",2,0,0,"G","","mv_par07","","","","      " ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Filial  ?","","","mv_ch8","C",2,0,0,"G","","mv_par08","","","","ZZZZZZ" ,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bem      ?","","","mv_ch9","C",10,0,0,"G","","mv_par09","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bem     ?","","","mv_ch0","C",10,0,0,"G","","mv_par10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
				"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
				"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
				"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
				"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
				"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
				"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
				"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }
				
dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .f.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .and. Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .t.
		Endif
	Endif
	
	If ! lAltera .and. Found() .and. X1_TIPO <> aPergs[nX][5]
		lAltera := .t.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .or. lAltera
		RecLock("SX1",iif(lAltera, .f.,.t.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If Len(aPergs[nX]) >= nJ .and. aPergs[nX][nJ] <> Nil .and. FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()

		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return

/*********************************************************/

Static Function CalcDia(dData,nTipo)

Local dRet 	:=	CtoD("")
Local cRet 	:=	Substr(DtoS(dData),01,06)

if	nTipo == 2
	if	Month(dData) == 2
		dRet := StoD(cRet + iif( Year(dData) / 4 == Int(Year(dData) / 4),"29","28"))
	else 
		dRet := StoD(cRet + iif( StrZero(Month(dData),02) $ "04/06/09/11","30","31"))		
   endif
endif

Return ( iif( nTipo == 1 , StoD( cRet + "01" ) , dRet ) )

/*       

Codigo        Corr.Periodo  Descricao do Bem                              ST                                                                Aquisic.          Vlr.Corrigido           Dep.Acum. R$              Vlr Residual" 
Dep.Per. UFIR   Dep.Per.R$                                                                                                                 Vl.Aquis.            Qtde UFIR             Dep. Ac.UFIR                % Deprec  "  
																																		    99/99/99        999,999,999.9999		999,999,999.9999    	999,999,999.9999
																																	999,999,999.9999        999,999,999.9999        999,999,999.9999                   99,99
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
0         1         2         3         4         5         6         7         8        9         0         1         2         3         4         5         6         7         8         9         0         1         2

cabec1   := "Codigo        Corr.Periodo  Descricao do Bem                              ST   Aquisic. Vlr.Corrigido  Dep.Acum. R$  Vlr Residual" //Conta                C.C       Base       Item TP  Descricao                       Aquisic.   Dt.Baixa   Nota Fisc.  Motivo"
//*                    XXXXXXXXXXXXXXXXXXXX XXXXXXXXX XXXXXXXXXX XXXX XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/9999 99/99/9999 999999-999  xx-xxxxxxxxxxxx
//*                    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123456789012345678901
//*                    0         1         2         3         4         5         6         7         8        9         0         1         2         3
cabec2   := "Dep.Per. UFIR   Dep.Per.R$                                                    Vl.Aquis.    Qtde UFIR   Dep. Ac.UFIR      % Deprec" // "Qtd.Baixad       Valor Atual Deprec. Acumulada Corr. Depr Acumul    Valor Residual       Valor Baixa    Lucro/Prejuizo Vl Ampliacao"
//*                    9999,999.9999 9,999,999.99  ESTBALIZADOR ELETRONICO DE TENSAO TRIFASICO        20/09/06  9,999,999.99 99,999,999.99  99,99,999.99
//                                   9,999,999.99  ESTBALIZADOR ELETRONICO DE TENSAO TRIFASICO    9,999,999.99 9,999,99.9999 9999,999.9999        999.99
*/

/*
Local cBase
Local cItem
Local cTipo
Local CbTxt
Local CbCont
Local nDepMes

Local nLaco 		:= 0
Local nZero 		:= 0
Local nMoeda 		:= 0
Local nOrdem 		:= 1
Local cProdAnt		:=	""
Local aMotBaixa 	:=	{} 
Local lRet 			:= .t.

Local nResidual := 0,nValAtual := 0,nRec      := 0,nLucro    := 0,nTotLucro  := 0,nGerLucro := 0
Local nTotValor := 0,nTotDepr  := 0,nTotResid := 0,nTotBaixa := 0,nTotDeprAc := 0,nTotAmpli := 0
Local nGerValor := 0,nGerDepr  := 0,nGerResid := 0,nGerBaixa := 0,nGerDeprAc := 0,nGerAmpli := 0

//,nRec      := 0,nLucro    := 0,nTotLucro  := 0,nGerLucro := 0

//Local nTotValor := 0,nTotDepr  := 0,nTotResid := 0,nTotBaixa := 0,nTotDeprAc := 0,nTotAmpli := 0
//Local nGerValor := 0,nGerDepr  := 0,nGerResid := 0,nGerBaixa := 0,nGerDeprAc := 0,nGerAmpli := 0


*/

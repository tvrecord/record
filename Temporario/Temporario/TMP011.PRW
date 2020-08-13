#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PORX010  ³ Autor ³ Edmilson D. Santos    ³ Data ³ 03.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho do Ponto - customizado Record                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ajustado: ³ Augusto - Totvs - Espírito Santo em 24/03/2008 12:10       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//User Function TMP006
User Function TMP011

Local aArea		  	:= GetArea()
Local cDesc1     	:= 'Espelho do Ponto'
Local cDesc2     	:= 'Ser  impresso de acordo com os parametros solicitados pelo'
Local cDesc3     	:= 'usuario.'
Local cString    	:= 'SRA' 
Local aOrd       	:= {'Matricula','Centro de Custo','Nome','Turno','C.Custo + Nome'} 
Local wnRel		  	:= "PONR010"
Local cHtml		  	:= ""

Private cMes     
Private aReturn  	:= {'Zebrado',01,'Administração',02,02,01,'',01} 
Private nomeprog 	:= 'PONR010'
Private aLinha   	:= {}
Private nLastKey 	:= 0
Private cPerg    	:= 'PNR010    '
Private aImp        := {}
Private aSaldos	    := {}
Private aTotais     := {}
Private aAbonados   := {}
Private nImpHrs     := 0
Private Titulo   	:= 'Espelho do Ponto'
Private cCabec   	:= ''
Private AT_PRG   	:= 'PONR010'
Private wCabec0  	:= 1
Private wCabec1  	:= ''
Private CONTFL   	:= 1
Private Li       	:= 0
Private nTamanho 	:= 'P'
Private MaxLine 	:= 67
Private dPerIni  	:= Ctod("")
Private dPerFim  	:= Ctod("")
Private cMenPad1 	:= Space(30)
Private cMenPad2 	:= Space(19)
Private cIndCond 	:= ''
Private cFilSPA  	:= iif(Empty(xFilial("SPA")),Space(02),SRA->RA_FILIAL)
Private cFor     	:= ''
Private nOrdem   	:= 0
Private cAponFer 	:= ''	
Private aInfo    	:= {}
Private aTurnos  	:= {}
Private aPrtTurn 	:= {}
Private cTiposVb	:=	""
Private aTiposVb	:=	{}
Private nTiposVb	:=	Len(CriaVar("RV_COD",.f.))
Private _nTipoCab	:=	3
Private nColunas 	:=	SuperGetMv("MV_COLMARC")
Private _dIniBcoH, _dFimBcoH
Private bQtdHorSpi	:= {|| StrTran( StrZero( iif( nHoras==1, SPI->PI_QUANT, SPI->PI_QUANTV ), 5, 2 ), ".", "" ) }
Private bQtdHorSpc	:= {|| StrTran( StrZero( (SPC->PC_QUANTC - SPC->PC_QTABONO), 5, 2 ), ".", "" ) }
Private lBancoHora  := .F.		//Controla de o Funcionario tem informacoes no SPI, para aquela data

if nColunas == Nil 
	Help("", 1,"MVCOLNCAD")
	Return( .f. )
Else
	Pergunte(cPerg,.f.)
	
	nTamanho		:= iif( nColunas < 5 , "M" , "G" )
	aReturn[4]	    := 01     
	nColunas		*=	02
	wnrel 		    :=	SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .f., aOrd, ,nTamanho)
	nOrdem 		    :=	aReturn[8]      
	FilialDe		:= mv_par01										//Filial  De
	FilialAte	    := mv_par02										//Filial  Ate
	CcDe			:= mv_par03										//Centro de Custo De
	CcAte			:= mv_par04										//Centro de Custo Ate
	TurDe			:= mv_par05										//Turno De
	TurAte		    := mv_par06										//Turno Ate
	MatDe			:= mv_par07										//Matricula De
	MatAte		    := mv_par08										//Matricula Ate
	NomDe			:= mv_par09										//Nome De
	NomAte		    := mv_par10										//Nome Ate
	cSit			:= mv_par11										//Situacao
	cCat			:= mv_par12										//Categoria
	nImpHrs		    := mv_par13										//Imprimir horas Calculadas/Inform/Ambas/NA
	nImpAut		    := mv_par14										//Demonstrar horas Autoriz/Nao Autorizadas
	nCopias		    := iif( mv_par15 > 0 , mv_par15 , 1 )	//N£mero de C¢pias
	lSemMarc		:= mv_par16 == 1 								//Imprime para Funcion rios sem Marca‡oes
	cMenPad1		:= mv_par17										//Mensagem padr„o anterior a Assinatura
	cMenPad2		:= mv_par18	        							//Mens. padr„o anterior a Assinatura(Cont.)
	dPerIni         := mv_par19  	    							//Data Contendo o Inicio do Periodo de Apontamento
	dPerFim     	:= mv_par20  	    							//Data Contendo o Fim  do Periodo de Apontamento
	lSexagenal		:= mv_par21 == 1								//Horas em  (Sexagenal/Centesimal)
	lImpRes			:= mv_par22 == 1								//Imprime eventos a partir do resultado ?
	lImpTroca   	:= mv_par23 == 1								//Imprime Descricao Troca de Turnos ou o Atual 
	lImpExcecao 	:= mv_par24 == 1								//Imprime Descricao da Excecao no Lugar da do Afastamento 
	nHoras    		:= mv_par25  									//Horas Normais/Valorizadas
	nSalBH	   		:= mv_par26  									//Imprimir com Saldo(Result/Credor/Devedor)
	nDataBaixa  	:= mv_par27  									//Data do Fechamento referente a 90 dias anterior.
	nTpEvento 		:=	mv_par14  									//Imprimir Eventos(Autoriz/N.Autoriz/Ambos)
	cFormImp  		:=	mv_par29  									//Código da formula a ser impressa
	dDtIni      	:= dPerIni
	dDtFim			:= dPerFim 
	cMenpad1 		:= iif(Empty( cMenPad1 ) , Space( 30 ) , cMenPad1 )
	cMenpad2 		:=	iif(Empty( cMenPad2 ) , Space( 19 ) , cMenPad2 )
	cTiposVb		:=	Alltrim(mv_par28)
    lCompensa		:= MV_PAR30 == 2

	nDataBaixa := IIF(EMPTY(nDataBaixa),dDtFim+20,nDataBaixa)
	_dIniBcoH  := CtoD("21/"+Right(DtoC(dDtFim-95),5)) //Data início do periodo de 90 dias do banco de horas
	_dFimBcoH  := nDataBaixa //Data fim do periodo de 90 dias do banco de horas

	For t := 1 to Len(cTiposVb) Step nTiposVb	
		aAdd( aTiposVb , Substr( cTiposVb , t , nTiposVb ) )
	Next t	
	
	Begin Sequence
		IF nLastKey <> 27 	
			SetDefault( aReturn , cString )		
			if	Empty(dPerIni) .or. Empty(dPerFim)
				Help(" ",1,"PONFORAPER",,'Periodo de Apontamento Invalido.',05,00)	
				Break
			Else	
			    RptStatus( { |lEnd| Pnr010Imp(@lEnd, wNRel, cString  ) } , Titulo )	
			EndIF	
		EndIf	
	End Sequence
EndIf                  

Return ( cHtml )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ POR010Imp³ Autor ³ EQUIPE DE RH          ³ Data ³ 07.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Espelho do Ponto                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Pnr010Imp( lEnd , WnRel ,cString  )

Local aComplPer		:= {}
Local aAbonosPer		:= {}
Local cFil				:= ""
Local cMat				:= ""
Local cTno				:= ""
Local cLastFil			:= "__cLastFil__"
Local cAcessaSRA		:= &("{ || " + ChkRH("PONR010","SRA","2") + "}")
Local cSeq				:= ""
Local cTurno			:= ""
Local cHtml				:= ""
Local lSPJExclu		:= !Empty( xFilial("SPJ") )
Local lSP9Exclu		:= !Empty( xFilial("SP9") )
Local nCount			:= 0.00
Local nX					:= 0.00
Local lMvAbosEve		:= .f.
Local lMvSubAbAp		:=	.f.

//OBS: A baixa ocorre sempre no mes seguinte ao período de apontamento conforme pagamente da folha.
Private dBxBcHProx	:= DataValida( dDtFim + 20 ) //Baixa do banco de horas no mes seguinte
Private dBxBcHAnte	:= DataValida( StoD( Left( DtoS( dDtIni ), 6 ) + "01" ) )	   //Baixa do banco de horas no mês anterior
Private aFuncFunc  	:= {" "," "," "," "," "," "}		
Private aMarcacoes 	:= {}
Private aTabPadrao 	:= {}
Private aTabCalend 	:= {}
Private aPeriodos  	:= {}
Private aId		   	:= {}
Private aBoxSPC	   := LoadX3Box("PC_TPMARCA") 
Private aBoxSPH	   := LoadX3Box("PH_TPMARCA")
Private cHeader    	:= ""
Private dIniCale   	:= Ctod("")		//-- Data Inicial a considerar para o Calendario
Private dFimCale   	:= Ctod("")		//-- Data Final a considerar para o calendario
Private dMarcIni   	:= Ctod("")		//-- Data Inicial a Considerar para Recuperar as Marcacoes
Private dMarcFim   	:= Ctod("")		//-- Data Final a Considerar para Recuperar as Marcacoes
Private dIniPonMes 	:= Ctod("")		//-- Data Inicial do Periodo em Aberto 
Private dFimPonMes 	:= Ctod("")		//-- Data Final do Periodo em Aberto 
Private lImpAcum   	:= .f.
Private nFalNoMes

dIniCale   := dPerIni   				//-- Data Inicial a considerar para o Calendario
dFimCale   := dPerFim   				//-- Data Final a considerar para o calendario

CarExtAut()
RstGetTabExtra()

dbSelectArea('SRA')

SRA->( dbSetOrder( nOrdem ) )

IF ( nOrdem == 1 )
	cInicio  := 'RA_FILIAL + RA_MAT'
	SRA->( MsSeek( FilialDe + MatDe , .t. ) )
	cFim := FilialAte + MatAte
ElseIF ( nOrdem == 2 )
	SRA->( MsSeek( FilialDe + CcDe + MatDe , .t. ) )
	cInicio  := 'RA_FILIAL + RA_CC + RA_MAT'
	cFim     := FilialAte + CcAte + MatAte
ElseIF ( nOrdem == 3 )
	SRA->( MsSeek( FilialDe + NomDe + MatDe , .t. ) )
	cInicio  := 'RA_FILIAL + RA_NOME + RA_MAT'
	cFim     := FilialAte + NomAte + MatAte
ElseIF ( nOrdem == 4 )
   SRA->( MsSeek( FilialDe + TurDe , .t. ) )
   cInicio  := 'RA_FILIAL + RA_TNOTRAB'
   cFim     := FilialAte + TurAte
ElseIF ( nOrdem == 5 )
	SRA->( dbSetOrder(8) )
	SRA->( MsSeek( FilialDe + CcDe + NomDe , .t. ) )
	cInicio  := 'RA_FILIAL + RA_CC + RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
EndIF

SetRegua( SRA->( RecCount() ) )

While SRA->( !Eof() .and. &(cInicio) <= cFim )

	IncRegua()

	IF lEnd
		Impr( cCancela , 'C' )
		Exit
	EndIF

	IF SRA->( !( RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA ) )
		SRA->( dbSkip() )
		Loop
	EndIF

	IF SRA->((  RA_TNOTRAB	< Turde ) .or. ( 	RA_TNOTRAB	> TurAte ) .or. ;
				(  RA_NOME 		< NomDe ) .or. ( 	RA_NOME 	   > NomAte ) .or. ;
				(  RA_MAT 		< MatDe ) .or. ( 	RA_MAT 		> MatAte ) .or. ;
				(  RA_CC 		< CCDe  ) .or. ( 	RA_CC 		> CCAte	) .or. ;
				(!(RA_SITFOLH	$ cSit )) .or. (!(RA_CATFUNC	$ cCat	)) )
		SRA->( dbSkip() )
		Loop
	EndIF

	IF !Empty(SRA->RA_DEMISSA) .and. SRA->RA_DEMISSA < dIniCale
		SRA->( dbSkip() )
		Loop
	EndIF

	IF	SRA->RA_FILIAL != cLastFil

		lMvAbosEve	:= Upper(AllTrim(SuperGetMv("MV_ABOSEVE",NIL,"N",cLastFil))) == "S" 		//--Verifica se Deduz as horas abonadas das horas do evento Sem a necessidade de informa o Codigo do Evento no motivo de abono que abona horas
		lMvSubAbAp	:= Upper(AllTrim(SuperGetMv("MV_SUBABAP",NIL,"N",cLastFil))) == "S" 		//--Verifica se Quando Abono nao Abonar Horas e Possuir codigo de Evento, se devera Gera-lo em outro evento e abater suas horas das Horas Calculadas
		cLastFil 	:= SRA->RA_FILIAL
		
		IF !CheckPonMes(@dPerIni,@dPerFim,.f.,.t.,.f.,cLastFil)
			Exit
		EndIF

		GetPonMesDat(@dIniPonMes,@dFimPonMes,cLastFil)
		
		aInfo := {}

		fInfo( @aInfo , cLastFil )
	
		if lSPJExclu .or. Empty(aTabPadrao)
			aTabPadrao := {}
			fTabTurno(@aTabPadrao,iif(lSPJExclu,cLastFil,Nil))
		EndIf

		If Empty( aId ) .or. ( lSP9Exclu )
			aId := {}
			CarId(fFilFunc("SP9"),@aId,"*")
		EndIf
	EndIf
	
	lBancoHora := f_ChkSPI() 
	///////////////////////////////////////////////////
    // Carrega totais referentes aos bancos de horas //
	///////////////////////////////////////////////////
		
	//Caso funcionario utilize banco de horas
	If lBancoHora

		nSaldo   	:= 0
		nSaldoAnt	:= 0
		aDet     	:= {}
	
		DbSelectArea( "SPI" )   
		SPI->(dbSetOrder(2))          
		SPI->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		
		cQry := " SELECT * " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''           " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	   = !PI_FILIAL!  " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		 	   = !PI_MAT!     " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA  	 	  >= !PI_DATA1!   " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA	      < !PI_DATA2!   " + CHR(13) + CHR(10)
//		cQry += "    AND (PI_DTBAIX	   = !PI_DTBAIX1! " + CHR(13) + CHR(10)
//		cQry += "     OR PI_DTBAIX	   > !PI_DTBAIX2!)" + CHR(13) + CHR(10)
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI") )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI") ) )
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql( SRA->RA_MAT ) )
		cQry := StrTran(cQry, "!PI_PD!" 		, ValToSql( "400" ) )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( _dIniBcoH ) )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dDtIni ) )
//		cQry := StrTran(cQry, "!PI_DTBAIX1!", ValToSql( Ctod("") ) )
//		cQry := StrTran(cQry, "!PI_DTBAIX2!", ValToSql( dDtFim) )
	
		MemoWrit("SPI_ANT.APQ",cQry)
		
		IF Select("SPI_ANT") > 0
			SPI_ANT->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPI_ANT",.F.,.F.)
		dbSelectArea("SPI_ANT")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPI_ANT",x[1],x[2],x[3],x[4]),)})
		
		// Totaliza Saldo Anterior                    
		While !SPI_ANT->(Eof())
		
			IF PosSP9( SPI_ANT->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD") = "1" 
	
				If nHoras == 1	// Horas Normais
					nSaldoAnt := SomaHoras(nSaldoAnt,SPI_ANT->PI_QUANT)
				Else                                                              				
					nSaldoAnt := SomaHoras(nSaldoAnt,SPI_ANT->PI_QUANTV)
				Endif
	
			Else
	
				If nHoras == 1
					nSaldoAnt := SubHoras(nSaldoAnt,SPI_ANT->PI_QUANT)
				Else
					nSaldoAnt := SubHoras(nSaldoAnt,SPI_ANT->PI_QUANTV)
				Endif
	
			Endif
				
			nSaldo := nSaldoAnt
	
			SPI_ANT->( dbSkip() )
	
		EndDo
	
	    cQry := " SELECT * " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''           " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	   = !PI_FILIAL!  " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		 	   = !PI_MAT!     " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA   BETWEEN !PI_DATA1! AND !PI_DATA2!  " + CHR(13) + CHR(10)
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI") )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI") ) )
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql( SRA->RA_MAT ) )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( dDtIni ) )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dDtFim ) )
	
		MemoWrit("SPI_DET.APQ",cQry)
		
		IF Select("SPI_DET") > 0
			SPI_DET->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPI_DET",.F.,.F.)
		dbSelectArea("SPI_DET")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPI_DET",x[1],x[2],x[3],x[4]),)})
	
		nFalNoMes	:= 0
		_nBaixaC 	:= 0
		nHorExtMes 	:= 0
		_nBaixaD 	:= 0
	
		While !SPI_DET->(EOF())
		
			If nTpEvento <> 3
				If !fBscEven(SPI_DET->PI_PD,2,nTpEvento)
					SPI_DET->(dbSkip())
					Loop
				EndIf
			Else
				PosSP9( SPI_DET->PI_PD ,SRA->RA_FILIAL )
			Endif
	
			If SP9->P9_TIPOCOD == "1"
				nHorExtMes 	:= SomaHoras ( nHorExtMes, iif( nHoras==1, SPI_DET->PI_QUANT, SPI_DET->PI_QUANTV ) )
			Else
				nFalNoMes   := SomaHoras ( nFalNoMes, iif( nHoras==1, SPI_DET->PI_QUANT, SPI_DET->PI_QUANTV ) )
			Endif
	
			aAdd(aDet,{padr(DTOC(SPI_DET->PI_DATA),10),;
						  SPI_DET->PI_PD,;
						  Left(DescPdPon(SPI_DET->PI_PD,SPI_DET->PI_FILIAL),20),;
						  Transform(If(SP9->P9_TIPOCOD == "1",0,If(nHoras==1,SPI_DET->PI_QUANT,SPI_DET->PI_QUANTV)),"9999999.99"),;
						  Transform(If(SP9->P9_TIPOCOD == "1",If(nHoras==1,SPI_DET->PI_QUANT,SPI_DET->PI_QUANTV),0),"9999999.99"),;
						  Transform(nSaldo,"99999999.99"),;
						  IF(SPI_DET->PI_STATUS=="B","Baixado","Pendente"),;
						  SPI_DET->PI_MAT })
	
			SPI_DET->( dbSkip() )
		EndDo
	
	//Caso funcionario nao utilize banco de horas
	Else

		nSaldo   	:= 0
		nSaldoAnt	:= 0
		aDet     	:= {}
	
		DbSelectArea( "SPC" )   
		SPC->(dbSetOrder(2))          
		SPC->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		
		cQry := " SELECT * " 						   + CHR(13) + CHR(10)
		cQry += "   FROM !SPC! SPC " 				   + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	 =  ''           " + CHR(13) + CHR(10)
		cQry += "    AND PC_FILIAL 	 =  !PC_FILIAL!  " + CHR(13) + CHR(10)
		cQry += "    AND PC_MAT		 =  !PC_MAT!     " + CHR(13) + CHR(10)
		cQry += "    AND PC_DATA  	 >= !PC_DATA1!   " + CHR(13) + CHR(10)
		cQry += "    AND PC_DATA	 <  !PC_DATA2!   " + CHR(13) + CHR(10)
		
		cQry := StrTran(cQry, "!SPC!"       , RetSqlName("SPC")        )
		cQry := StrTran(cQry, "!PC_FILIAL!" , ValToSql( xFilial("SPC")))
		cQry := StrTran(cQry, "!PC_MAT!"    , ValToSql( SRA->RA_MAT )  )
		cQry := StrTran(cQry, "!PC_PD!"     , ValToSql( "400" )        )
		cQry := StrTran(cQry, "!PC_DATA1!"  , ValToSql( _dIniBcoH )    )
		cQry := StrTran(cQry, "!PC_DATA2!"  , ValToSql( dDtIni )       )
	
		MemoWrit("SPC_ANT.APQ",cQry)
		
		IF Select("SPC_ANT") > 0
			SPC_ANT->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPC_ANT",.F.,.F.)
		dbSelectArea("SPC_ANT")
		aEval(SPC->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPC_ANT",x[1],x[2],x[3],x[4]),)})
		
		// Totaliza Saldo Anterior                    
		While !SPC_ANT->(Eof())
		
			IF PosSP9( SPC_ANT->PC_PD , SRA->RA_FILIAL, "P9_TIPOCOD") = "1" 
	
				nSaldoAnt := SomaHoras(nSaldoAnt,(SPC_ANT->PC_QUANTC - SPC_ANT->PC_QTABONO))	//Utiliza sempre as horas calculadas
			Else
	
				nSaldoAnt := SubHoras(nSaldoAnt,(SPC_ANT->PC_QUANTC - SPC_ANT->PC_QTABONO))    //Utiliza sempre as horas calculadas
			Endif
				
			nSaldo := nSaldoAnt
	
			SPC_ANT->( dbSkip() )
		EndDo
	
		cQry := " SELECT * "                                          + CHR(13) + CHR(10)
		cQry += "   FROM !SPC! SPC "                                  + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''           "               + CHR(13) + CHR(10)
		cQry += "    AND PC_FILIAL 	   = !PC_FILIAL!  "               + CHR(13) + CHR(10)
		cQry += "    AND PC_MAT		   = !PC_MAT!     "               + CHR(13) + CHR(10)
//		cQry += "    AND PC_PD IN ('004','106','107','498','409','010') "   + CHR(13) + CHR(10)
		cQry += "    AND PC_DATA BETWEEN !PC_DATA1! AND !PC_DATA2!  " + CHR(13) + CHR(10)

		cQry := StrTran(cQry, "!SPC!"      , RetSqlName("SPC")       )
		cQry := StrTran(cQry, "!PC_FILIAL!", ValToSql(xFilial("SPC"))) 
		cQry := StrTran(cQry, "!PC_MAT!"   , ValToSql( SRA->RA_MAT ) )
		cQry := StrTran(cQry, "!PC_DATA1!" , ValToSql(dDtIni)        )
		cQry := StrTran(cQry, "!PC_DATA2!" , ValToSql( dDtFim )      )
	
		MemoWrit("SPC_DET.APQ",cQry)
		
		IF Select("SPC_DET") > 0
			SPC_DET->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPC_DET",.F.,.F.)
		dbSelectArea("SPC_DET")
		aEval(SPC->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPC_DET",x[1],x[2],x[3],x[4]),)})
	
		nFalNoMes	:= 0
		_nBaixaC 	:= 0
		nHorExtMes 	:= 0
		_nBaixaD 	:= 0
	
		While !SPC_DET->(EOF())
		
			If nTpEvento <> 3
				If !fBscEven(SPC_DET->PI_PD,2,nTpEvento)
					SPC_DET->(dbSkip())
					Loop
				EndIf
			
			Elseif (!SPC_DET->PC_PD $ Alltrim(GetMv("MV_RTC_01"))) .and.(!SPC_DET->PC_PD $ Alltrim(GetMv("MV_RTC_02")))
   				SPC_DET->(dbSkip())
				Loop
			Else
				PosSP9( SPC_DET->PC_PD ,SRA->RA_FILIAL )
			Endif
	        
			//Funcionario sem banco de horas, nao tem hora extra nem falta
			
			If SP9->P9_TIPOCOD == "1"
				nHorExtMes := SomaHoras ( nHorExtMes,(SPC_DET->PC_QUANTC - SPC_DET->PC_QTABONO))
			Else
				nFalNoMes  := SomaHoras ( nFalNoMes,(SPC_DET->PC_QUANTC - SPC_DET->PC_QTABONO) )
			Endif
	  
	        
			aAdd(aDet,{padr(DTOC(SPC_DET->PC_DATA),10)                                         ;
			          ,SPC_DET->PC_PD															;
			          ,Left(DescPdPon(SPC_DET->PC_PD,SPC_DET->PC_FILIAL),20)					;
			          ,Transform(If(SP9->P9_TIPOCOD == "1",0,(SPC_DET->PC_QUANTC - SPC_DET->PC_QTABONO)),"9999999.99");
			          ,Transform(If(SP9->P9_TIPOCOD == "1",(SPC_DET->PC_QUANTC - SPC_DET->PC_QTABONO),0),"9999999.99");
			          ,Transform(nSaldo,"99999999.99")										    ;
			          ,"Sem status"                                                             ;
			          ,SPC_DET->PC_MAT })
	
			SPC_DET->( dbSkip() )
		EndDo
	Endif
	
	aPeriodos	:= Monta_per( dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )
	naPeriodos 	:=	Len( aPeriodos )

	For nX := 1 To naPeriodos

		dPerIni		:= aPeriodos[ nX , 1 ]
  		dPerFim		:= aPeriodos[ nX , 2 ] 
		dMarcIni	:= aPeriodos[ nX , 3 ]
		dMarcFim	:= aPeriodos[ nX , 4 ]
		lImpAcum 	:= dPerFim < dIniPonMes
		   
		IF lImpAcum
			IF SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni))) .and. !Empty(SPF->PF_SEQUEPA)
				cTurno	:= SPF->PF_TURNOPA
				cSeq	:= SPF->PF_SEQUEPA
			Else
				IF !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty(cSeq)
					cSeq := fQualSeq( NIL , aTabPadrao , dPerIni , @cTurno)
				EndIF
			EndIF
			fBuscaCC(dMarcFim, @aFuncFunc[1], @aFuncFunc[2], Nil, .f. , .t.) 
			aFuncFunc[2]:= Substr(aFuncFunc[2], 1, 25)
			fBuscaFunc(dMarcFim, @aFuncFunc[3], @aFuncFunc[4],20, @aFuncFunc[5], @aFuncFunc[6],25, .f. )
		Else
			cTurno			:= SRA->RA_TNOTRAB
			cSeq			:= SRA->RA_SEQTURN  
			aFuncFunc[1]	:= SRA->RA_CC
			aFuncFunc[2]	:= DescCc(aFuncFunc[1], SRA->RA_FILIAL, 25)
			aFuncFunc[3]	:= SRA->RA_CODFUNC 
			aFuncFunc[4]	:= DescFun(SRA->RA_CODFUNC , SRA->RA_FILIAL)
			aFuncFunc[6]	:= DescCateg(SRA->RA_CATFUNC , 25)
		EndIF
	
		aMarcacoes 	:= {}
		aTabCalend 	:= {} 
		aTurnos 	:= {}    
		IF !GetMarcacoes(@aMarcacoes			  ;	//Marcacoes dos Funcionarios
		                ,@aTabCalend			  ;	//Calendario de Marcacoes
		                ,@aTabPadrao			  ;	//Tabela Padrao
		                ,@aTurnos				  ;	//Turnos de Trabalho
		                ,dPerIni 				  ;	//Periodo Inicial
		                ,dPerFim				  ;	//Periodo Final
		                ,SRA->RA_FILIAL			  ;	//Filial
		                ,SRA->RA_MAT			  ;	//Matricula
		                ,cTurno					  ;	//Turno
		                ,cSeq					  ;	//Sequencia de Turno
		                ,SRA->RA_CC				  ;	//Centro de Custo
		                ,IF(lImpAcum,"SPG","SP8");	//Alias para Carga das Marcacoes
		                ,NIL					  ;	//Se carrega Recno em aMarcacoes
		                ,.t.					  ;	//Se considera Apenas Ordenadas
		                ,.t.    				  ;	//Se Verifica as Folgas Automaticas
		                ,.f.    			 	  )	//Se Grava Evento de Folga Automatica Periodo Anterior
			Loop
		EndIF					 
	   
	 	aPrtTurn := {}
	  	aEval(aTurnos, { |x| iif( x[2] >= dPerIni .and. x[2]<= dPerFim,aAdd(aPrtTurn,x),Nil)}) 	    
		aTotais  := {} 
		aAbonados:= {} 
		fAbonosPer(@aAbonosPer,dPerIni,dPerFim,cLastFil,SRA->RA_MAT)
		CarAboTot(@aTotais,@aAbonados,aAbonosPer,lMvAbosEve,lMvSubAbAp)
	
		IF !fMontaAimp(aTabCalend,aMarcacoes,@aImp,dMarcIni,dMarcFim) .and. !lSemMarc 
			Loop
		EndIF

		For nCount := 1 To nCopias
			fImpFun( aImp , nColunas )
		Next nCount
	
		aImp      := {}
		aSaldos   := {}
		aTotais   := {}
		aAbonados := {}
		
	Next nX
	SRA->( dbSkip() )
EndDo

dbSelectArea('SRA')
dbSetOrder(1)

Set Device To Screen

IF aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(wnrel)
EndIF

Ms_Flush()

Return( cHtml )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FImpFun   ³ Autor ³ J.Ricardo             ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o espelho do ponto do funcionario                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fImpFun( aImp , nColunas  )

	Local cDet      		:= ""
	Local cHtml				:= ""    
	Local cOcorr			:= ""   
	Local cAbHora			:= ""
	Local lZebrado			:= .f.
	Local nX        		:= 0.00
	Local nY        		:= 0.00
	Local nFor      		:= 0.00
	Local nCol      		:= 0.00
	Local nColMarc  		:= 0.00
	Local nMin				:= 0.00
	Local nLenImp			:= 0.00
	Local nLenImpnX		    := 0.00
	Local nTamAuxlin		:= 0.00   
	Local nAbHora			:= 0
	Local _cTipCod
	Local bNomCpo
	Local cAliaBx
	Local cTotHe	:= ""
	Local cTotFal	:= ""
	Local cAcSem	:= ""
	Local _nSA		:= 0
	Local _nSFM 	:= 0
	Local _nSHM 	:= 0
	

	Private nTamLin   	:= 0.00
	
	aEval(aImp, { |x| nColMarc := iif( Len(x) - 3 > nColMarc, Len(x) - 3 , nColMarc ) } )
	
	nColMarc 	+= iif( nColMarc % 2 == 0, 0, 1)
	nTamanho	:=	iif( nColunas < 10 , "M" , "G" )
	aReturn[4]	:= 1    
	nColunas 	:= Max(nColunas, nColMarc)
	nTamAuxLin	:=	19 + ( nColunas * 6 ) + 50
	nTamLin    	:= iif( nTamAuxLin <= 80 , 80 , iif( nTamAuxLin <= 132 , 132 , 220 ) )
	Li 			:= 01
	
	Imp_Cabec( nTamLin , nColunas ,  nTamanho, , 1 )
	
	nLenImp := Len(aImp)
	
	For nX := 1 To nLenImp
	
		cDet := PADR(DtoC(aImp[nX,1]),10) + Space(1) + DiaSemana(aImp[nX,1],8)
		nMin := Min(nColunas+4,Len(aImp[nX]))
		
		If Len(aImp[nX]) >= 4
		
			For nY := 4 To nMin                              
			
			    //-- Imprime Marcacoes. Ao imprimir, verificar se as marcacoes passam de 9E/9S
			    //-- a partir dai acrescenta 2 espacoes apos imprimir a marcacao para disponibiliza-la
			    //-- corretamente abaixo do cabecalho correspondente. 
				cDet +=  If( Empty( aImp[nX,nY]), Replicate(".", nColunas*6 -2), aImp[nX,nY] ) + Space(If(nY<21,1,2))
				
			Next nY 
			
		Else
		
			cDet += If( Empty( aImp[nX,2]), Replicate(".", nColunas*6 -2), aImp[nX,2] )
			
		Endif                                                                   
	
		//-- Qdo for "1a E. 2a S."  acrescenta mais 12 Brancos para que na eventual existencia de
		//-- ocorrencias como Excecoes e DSr e Compensado, as descricoes das mesmas saem integras,
		//-- sem cortes.                                    
	 	//-- If(nColunas<3, SPACE(12),''), VEJA ABAIXO
		//-- Imprime o motivo de Abono....
	
		cDet := Left(cDet+Space(19+(nColunas*6))+If(nColunas<3, SPACE(12),'') , 19+(nColunas*6)+ If(nColunas<3, 12,0) ) + IIF( LEN(aImp[nX]) >= 3, aImp[nX,3], "" )
		cDet := Left(Alltrim(cDet)+Space(nTamLin),nTamLin)

		//Acrescenta na variável de impressão o saldo de HE ou atrasos/faltas
		nTamDet := Len(cDet)-20
		cDet 	  := Left(cDet,nTamDet)+PadR( aSaldos[nX][1], 8 ) + Space(2) + PadR( aSaldos[nX][2], 10 )
		
		cTotHe	:= Exec4Oper( cTotHe,  aSaldos[nX][1], "+")
		cTotFal	:= Exec4Oper( cTotFal, aSaldos[nX][2], "+")
        
        cAcSem  := U_fHoraNeg(cTotHe,cTotFal)
		
		//IF (! "Ausente" $ aImp[nX][2] .AND.  AllTrim( DiaSemana( aImp[nX,1], 8 ) ) == "Sabado") .OR. nX == Len(aImp)
		IF (AllTrim( DiaSemana( aImp[nX,1], 8 ) ) == "Sabado") .OR. nX == Len(aImp)
	
			/* TESTE
			//Caso seja funcionario com banco de horas e tenha valores maiores que zero 
		   	IF  SRA->RA_ACUMBH == 'S' .and. Val(cTotHe)>0 .OR. Val(cTotFal)>0

				cDet 		:= SubStr( cDet, 1, nTamDet-11 ) + " Tot.Sem.: "
				cDet		+= PadR( IIF(Val(cTotHe)>0,Transform(cTotHe,"@R 99:99")," ") , 8 ) + Space( 2 ) 
				cDet		+= PadR( IIF(Val(cTotFal)>0,Transform(cTotFal,"@R 99:99")," "), 10 )
				cTotHe	:= " "
				cTotFal	:= " "
				ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , 0 )
			  	ImprEsp(__PrtThinLine(), 'C',, nTamLin, nColunas, nTamanho, 1 )
		  	Elseif SRA->RA_ACUMBH <> 'S' 
		  		cDet 		:= SubStr( cDet, 1, nTamDet-11 ) + " Tot.Sem.: "
				cDet		+= PadR( IIF(Val(cTotHe)>0,Transform(cTotHe,"@R 99:99")," ") , 8 ) + Space( 2 ) 
				cDet		+= PadR( IIF(Val(cTotFal)>0,Transform(cTotFal,"@R 99:99")," "), 10 )
				cTotHe	:= " "
				cTotFal	:= " "
				ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , 0 )
			  	ImprEsp(__PrtThinLine(), 'C',, nTamLin, nColunas, nTamanho, 1 )
		  	ENDIF
		  	>>>*/
	  		ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , 1 )
	  		cDet 		:= Space(nTamDet - 40 ) + Padr("Acumulado Semana: " + Transform(cAcSem,"@R X99:99"),40)
	  		cDet 		:= SubStr( cDet, 1, nTamDet-11 ) + " Tot.Sem.: "
			cDet		+= PadR( Transform(cTotHe,"@R 99:99") , 08 ) + Space( 2 ) 
			cDet		+= PadR( Transform(cTotFal,"@R 99:99"), 10 )
			cTotHe	:= " "
			cTotFal	:= " "
			ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , 0 )
		  	ImprEsp(__PrtThinLine(), 'C',, nTamLin, nColunas, nTamanho, 1 )
		ELSE
			
			ImprEsp(cDet, 'C',,nTamLin , nColunas ,  nTamanho , 1 )

		ENDIF
			
	Next nX
		
	//-- Se existirem totais, e se for selecionada sua impress„o, ser„o impressos.
	
	If Len(aTotais) > 0 .and. nImpHrs # 4
	
		cDet := 'T O T A I S'+SPACE(90)+"COMPETENCIA: "+MesExtenso(Month(dDtFim))
		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho, 1  )
			
		If Len(aTotais) % 2 # 0
		
			aAdd (aTotais, Space(Len(aTotais[1])))
			
		Endif
		
		If nImpHrs == 1 .or. nImpHrs == 3
		
			cDet := 'Cod Descricao             Calc. Infor.  Cod Descricao             Calc. Infor.  Cod Descricao             Calc. Infor.'
				
		ElseIf nImpHrs == 2
		
			cDet := 'Cod Descricao                   Infor.  Cod Descricao                    Infor.  Cod Descricao                   Infor.'
				
		Endif
		
	
		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho  ,2)
		ImprEsp(Replicate('=',38)+Space(2)+Replicate('=',38)+Space(2)+Replicate('=',38),'C',,nTamLin , nColunas ,  nTamanho, 2 )
	
		For nX := 1 To Len(aTotais) STEP 3
		
			cDet := aTotais[nX]+Space(2)
			cDet += IIF(Len(aTotais)>=nX+1,aTotais[nX+1]+Space(2),"")
			cDet += IIF(Len(aTotais)>=nX+2,aTotais[nX+2],"")
			
			ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho ,2 )
				
		Next nX
		
	Endif
	
	nn 		:=	0
	xResumo	:=	{}
	kResumo	:=	{}
	xEresumo:= {}


	IF DtoS(dDtIni)+"/"+DtoS(dDtFim) == GetMv("MV_PONMES")
		bNomCpo  := { | cCpo | "PB_" + cCpo }
		cAliaBx  := "SPB"
	ELSE
		bNomCpo  := { | cCpo | "PL_" + cCpo }
		cAliaBx  := "SPL"
	ENDIF

	dbSelectArea( cAliaBx )   

	cQry := " SELECT %PD% PB_PD, %MAT% PB_MAT, %HORAS% PB_HORAS, %DATA% PB_DATA " + CHR(13) + CHR(10)
	cQry += "   FROM !cAliaBx! "                                                  + CHR(13) + CHR(10)
	cQry += "  WHERE D_E_L_E_T_	   = ''           "                               + CHR(13) + CHR(10)
	cQry += "    AND %FILIAL% 	   	= !FILIAL!  "                                 + CHR(13) + CHR(10)
	cQry += "    AND %MAT%		    	= !MAT!     "                             + CHR(13) + CHR(10)
	cQry += "    AND %DATA%    BETWEEN !DATA1!  AND  !DATA2! "                    + CHR(13) + CHR(10)

	cQry := StrTran(cQry, "!cAliaBx!"	, RetSqlName(cAliaBx))
	cQry := StrTran(cQry, "!FILIAL!" 	, ValToSql( xFilial(cAliaBx) ))
	cQry := StrTran(cQry, "!MAT!"		, ValToSql( SRA->RA_MAT ))
	cQry := StrTran(cQry, "!DATA1!"  	, ValToSql( dDtIni ))
	cQry := StrTran(cQry, "!DATA2!"  	, ValToSql( dDtFim ))
	cQry := StrTran(cQry, "%FILIAL%"  	, Eval(bNomCpo,"FILIAL"))
	cQry := StrTran(cQry, "%MAT%"		, Eval(bNomCpo,"MAT"   ))
	cQry := StrTran(cQry, "%PD%"       	, Eval(bNomCpo,"PD"    ))
	cQry := StrTran(cQry, "%DATA%"    	, Eval(bNomCpo,"DATA"  ))
	cQry := StrTran(cQry, "%HORAS%"    	, Eval(bNomCpo,"HORAS"  ))

	MemoWrit("SPB_BX.APQ",cQry)
	
	IF Select("SPB_BX") > 0
		SPB_BX->(dbCloseArea())
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPB_BX",.F.,.F.)
	dbSelectArea("SPB_BX")
	If Select("SPI_ANT") > 0
		aEval(SPB->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPI_ANT",x[1],x[2],x[3],x[4]),)})
	ElseIf Select("SPC_ANT") > 0
		aEval(SPB->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPC_ANT",x[1],x[2],x[3],x[4]),)})
	EndIf

	dbselectarea("SPB_BX")
	
	IF	Len(aDet) > 0
	
		For nn := 1 to Len(aDet) 
		
			do while !Eof()
			
				if	aScan( kResumo , PB_PD + PB_MAT ) == 0
				
			  		aAdd(xResumo, { PB_PD, Posicione( "SRV", 1, xFilial("SRV") + PB_PD, "RV_DESC" ), PB_HORAS, aDet[nn,8] } )
	  				aAdd(kResumo, PB_PD + PB_MAT)
	  				
				endif

				dbskip()
				
			enddo	
		
		Next nn
		
	else
	
		do while !Eof()
		
			if	aScan( kResumo , PB_PD + PB_MAT ) == 0
		
		  		aAdd(xResumo, { PB_PD, Posicione( "SRV", 1, xFilial("SRV") + PB_PD, "RV_DESC" ), PB_HORAS, SRA->RA_MAT })
		  		aAdd(kResumo, PB_PD + PB_MAT)
		
			endif
		
			dbskip()
		
		enddo	
		
	endif
	   
	aSort(xResumo,,,{|x,y| x[1] < y[1] })  
	  
	nj        	:= 0
	J				:=	0                
	lResumo  	:= {}
	//xxResumo 	:= {}
	
	For nj := 1 to Len(aDet) 
	
		j:= aScan(lResumo,aDet[nj,8]+aDet[nj,2])
		
		IF j == 0 //MATRICULA + VERBA

			aAdd( lResumo, aDet[nj,8] + aDet[nj,2] ) 
			aAdd( xResumo, { aDet[nj,2], aDet[nj,3], VAL(aDet[nj,4]), VAL(aDet[nj,5]), VAL(aDet[nj,6]), aDet[nj,8] } )								 //CREDITO
			
		ELSE

			xResumo[J,4]:= SomaHoras( xResumo[J,4], IIF(PosSP9( aDet[nj,2] , SRA->RA_FILIAL, "P9_TIPOCOD" ) == "1", VAL(aDet[nj,5]), 0 ) )   //CREDITO

		ENDIF
		
	Next nj
	
	//Banco de horas
	//Caso funcionario utilize banco de horas
	If lBancoHora

		dbSelectArea( "SPI" )
		SPI->(dbSetOrder(2))          
		SPI->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		
		cQry := " SELECT * " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''          " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	   = !PI_FILIAL! " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		 	   = !PI_MAT!    " + CHR(13) + CHR(10)
		cQry += "    AND PI_STATUS	 	   = !PI_STATUS! " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA   BETWEEN !PI_DATA1!   AND !PI_DATA2!  " + CHR(13) + CHR(10)
		cQry += "    AND PI_DTBAIX	BETWEEN !PI_DTBAIX1! AND !PI_DTBAIX2!" + CHR(13) + CHR(10)
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI"))
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql(xFilial("SPI")))
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql(SRA->RA_MAT))
		cQry := StrTran(cQry, "!PI_STATUS!" , ValToSql("B"))
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql(_dIniBcoH))
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql(dDtFim))
		cQry := StrTran(cQry, "!PI_DTBAIX1!", ValToSql(dDtFim))
		cQry := StrTran(cQry, "!PI_DTBAIX2!", ValToSql(dBxBcHProx))
	
		MemoWrit("SPI_BX.APQ",cQry)
		
		IF Select("SPI_BX") > 0
			SPI_BX->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPI_BX",.F.,.F.)
		dbSelectArea("SPI_BX")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPI_BX",x[1],x[2],x[3],x[4]),)})
		
		While !SPI_BX->(Eof()) .And. SPI_BX->PI_FILIAL+SPI_BX->PI_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		
	 		IF (_cTipCod := PosSP9( SPI_BX->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD" )) == "2" //VERBA DE DESCONTO
	 			_nBaixaD := SomaHoras( _nBaixaD, If( nHoras==1, SPI_BX->PI_QUANT, SPI_BX->PI_QUANTV ) )
	 		ElseIf _cTipCod == "1" //VERBA PROVENTO
	 			_nBaixaC := SomaHoras( _nBaixaC, If(nHoras == 1, SPI_BX->PI_QUANT, SPI_BX->PI_QUANTV ) )
	 		Endif
	 		
			SPI_BX->(Dbskip())
			
		EndDo

	//Caso funcionario nao utilize banco de horas
	Else
	
		dbSelectArea( "SPC" )
		SPC->(dbSetOrder(2))          
		SPC->(dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ))
		
		cQry := " SELECT * "                                               + CHR(13) + CHR(10)
		cQry += "   FROM !SPC! SPC "                                       + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	 = '' "                                + CHR(13) + CHR(10)
		cQry += "    AND PC_FILIAL 	 = !PC_FILIAL! "                       + CHR(13) + CHR(10)
		cQry += "    AND PC_MAT		 = !PC_MAT!    "                       + CHR(13) + CHR(10)
		cQry += "    AND PC_DATA   BETWEEN !PC_DATA1!   AND !PC_DATA2!  "  + CHR(13) + CHR(10)

		cQry := StrTran(cQry, "!SPC!"       , RetSqlName("SPC")       )
		cQry := StrTran(cQry, "!PC_FILIAL!" , ValToSql(xFilial("SPC")))
		cQry := StrTran(cQry, "!PC_MAT!"    , ValToSql(SRA->RA_MAT)   )
		cQry := StrTran(cQry, "!PC_DATA1!"  , ValToSql(_dIniBcoH)     )
		cQry := StrTran(cQry, "!PC_DATA2!"  , ValToSql(dDtFim)        )
	
		MemoWrit("SPC_BX.APQ",cQry)
		
		IF Select("SPC_BX") > 0
			SPC_BX->(dbCloseArea())
		ENDIF
		
		dbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"SPC_BX",.F.,.F.)
		dbSelectArea("SPC_BX")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("SPC_BX",x[1],x[2],x[3],x[4]),)})
		
		/*While !SPC_BX->(Eof()) .And. SPC_BX->PC_FILIAL+SPC_BX->PC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		
	 		IF (_cTipCod := PosSP9( SPC_BX->PC_PD,SRA->RA_FILIAL,"P9_TIPOCOD")) == "2" 					//VERBA DE DESCONTO
	 			_nBaixaD := SomaHoras( _nBaixaD, SPC_BX->PC_QUANTC)
	 		ElseIf _cTipCod == "1" 																			//VERBA PROVENTO
	 			_nBaixaC := SomaHoras( _nBaixaC,SPC_BX->PC_QUANTC)
	 		Endif
	 		
			SPC_BX->(Dbskip())
			
		EndDo
		*/
	Endif
		   
	//If	nSaldoAnt + nHorExtMes <> 0 .or. nSaldoAnt + nHorExtMes == 0
	
		If Len(xResumo) > 0 .and. nImpHrs # 4
			
			cDet := "DADOS DO BANCO DE HORAS:"
			Li+=1
			ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho, 1 )
	
			_nSA	:= nSaldoAnt
			_nSFM := SubHoras( nFalNoMes,  _nBaixaD )
			_nSHM := SubHoras( nHorExtMes, _nBaixaC )

			cDet := "    SALDO ANTERIOR :" + TRANSFORM( If(lBancoHora,nSaldoAnt,0), "@E 9999.99") + space(4)
			cDet += "H.E. NO MES:"		   + TRANSFORM( If(lBancoHora,nHorExtMes,0), "@E 9999.99") + space(4)
			cDet += "HS BAIXADAS DEB: "	   + TRANSFORM( If(lBancoHora,(_nBaixaD * -1),0),"@E 9999.99") + space(4)
			cDet += "HS BAIXADAS CRED: "   + TRANSFORM( If(lBancoHora,_nBaixaC,0       ), "@E 9999.99") + space(4)
			cDet += "SALDO ATUAL : "	   + TRANSFORM( If(lBancoHora,SomaHoras( SubHoras( _nSA, _nSFM ), _nSHM ),0),"@E 9999.99")

			ImprEsp( cDet			  , 'C',, nTamLin, nColunas, nTamanho, 1 )
				
			IF	nImpHrs <> 4
		
				cDet := "BAIXA HORAS EXTRAS CONFORME CONVENCAO COLETIVA"
				Li+=1
		  		ImprEsp( cDet, 'C',, nTamLin, nColunas, nTamanho, 1 )
				Col := 0
				
				For nX := 1 To Len(xResumo)			  
				
				   IF ( LI > MaxLine )
					   Imp_Cabec( nTamLin, nColunas, nTamanho, _nTipoCab, , 1 )
					  	ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho,2 )
				   EndIf
				   
				   If Col == 120
				      Col := 0
	     				Li++
				   Endif 
				   
	   			If xResumo[nX,3] > 0 .AND. Posicione( "SRV" , 1 , xFilial("SRV") + xResumo[nX,1] , "RV_TIPOCOD" ) == "1" .or. aScan( aTiposVb , xResumo[nX,1] ) > 0
	  	   			@ Li, col PSAY xResumo[nX,1] + " " + Left(xResumo[nX,2],20) + Space(5) + Transform(xResumo[nX,3],"@E 999.99")
		         EndIf
		         
				   Col += 40 
				   
				Next nX
				
		   EndIf
		   
		Else
	        
			If	nImpHrs <> 4	
	
				cDet := "BAIXA HORAS EXTRAS CONFORME CONVENCAO COLETIVA"
				Li+=1
		  		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho,1  )
				Col := 0			
	
				For nX := 1 To Len(xResumo)			  
	
				   if ( LI > MaxLine )
					   Imp_Cabec( nTamLin , nColunas , nTamanho , _nTipoCab, ,1 )
						Li++
					  	ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho, 1 )
				   EndIf
	
				   If Col == 120
				      Col := 0
	     				Li++
				   Endif 
	
	   			If xResumo[nX,3] .AND. Posicione( "SRV" , 1 , xFilial("SRV") + xResumo[nX,1] , "RV_TIPOCOD" ) == "1" .or. aScan( aTiposVb , xResumo[nX,1] ) > 0
	  	   			@ Li, col PSAY xResumo[nX,1] + " " + Left(xResumo[nX,2],20) + Space(5) + Transform(xResumo[nX,3],"@E 999.99")
		         EndIf
	
				   Col += 40 
	
				Next nX
	
		   EndIf
	 	EndIf
	//ELSE
	/*
		If	nImpHrs <> 4	
	
			cDet := "BAIXA HORAS EXTRAS CONFORME CONVENCAO COLETIVA"
			Li+=1
	  		ImprEsp(cDet,'C',,nTamLin , nColunas ,  nTamanho, 1 )
			Col := 0			
	
			For nX := 1 To Len(xResumo)			  
	
			   IF ( LI > MaxLine )
				   Imp_Cabec( nTamLin , nColunas , nTamanho , _nTipoCab, ,1 )
				   Li++
				  	ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho, 1 )
			   EndIf
	
			   If Col == 120
			      Col := 0
	     			Li++
			   Endif 
	
				If Posicione( "SRV" , 1 , xFilial("SRV") + xResumo[nX,1] , "RV_TIPOCOD" ) == "1" .or. aScan( aTiposVb , xResumo[nX,1] ) > 0
	  	   		@ Li, col PSAY xResumo[nX,1] + " " + Left(xResumo[nX,2],20) + Space(5) + Transform(xResumo[nX,3],"@E 999.99")
	         EndIf
	
			   Col += 40 
	
			Next nX
	
	   EndIf
	*/
	//Endif	 
	
	//Assinatura
	IF .NOT. Empty(cFormImp)
		ImprEsp( Formula(cFormImp), 'C',,nTamLin , nColunas ,  nTamanho,1  )
		Li++
	ENDIF
	
	ImprEsp(cMenPad1 + cMenPad2 +Space(30) + Replicate('_',31), 'C',,nTamLin , nColunas ,  nTamanho,1  )
	ImprEsp(Space(52) +Space(30) + 'Assinatura do Funcionario' , 'C',,nTamLin , nColunas ,  nTamanho,1  ) // 'Assinatura do Funcionario'

Return( cHtml )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FMontaaIMP³ aUTOR ³ EQUIPE DE RH          ³ dATA ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o Vetor aImp , utilizado na impressao do espelho     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FMontaAimp(aTabCalend, aMarcacoes, aImp,dInicio,dFim)

	Local aDescAbono := {}
	Local cTipAfas   := ""
	Local cDescAfas  := ""
	Local cOcorr     := ""
	Local cOrdem     := ""
	Local cTipDia    := ""
	Local dData      := Ctod("//")
	Local dDtBase    := dFim
	Local lRet       := .t.
	Local lFeriado   := .t.
	Local lTrabaFer  := .f.
	Local lAfasta    := .t.   
	Local nX         := 0
	Local nDia       := 0
	Local nMarc      := 0
	Local nLenMarc	 := Len( aMarcacoes )
	Local nLenDescAb := Len( aDescAbono )
	Local nTab       := 0
	Local nContMarc  := 0
	Local nDias		 := 0 
	
	aImp 		     := {}
	aSaldos	         := {}
	
	nDias := ( dDtBase - dInicio )
	
	For nDia := 0 To nDias
	
		dData      := dInicio + nDia
		aDescAbono := {}
		cOcorr     := ""
		cTipAfas   := ""
		cDescAfas  := ""
		cOcorr	   := ""
	
		IF	( nTab := aScan(aTabCalend, {|x| x[1] == dData .and. x[4] == '1E' }) ) == 0.00
			Loop
		EndIF
	
		nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })
	
		IF ( ( lAfasta := aTabCalend[ nTab , 24 ] ) .or. SRA->( RA_SITFOLH $ 'DúT' .and. dData > RA_DEMISSA ) )
			lAfasta		:= .t.
			cTipAfas		:= Iif(!Empty(aTabCalend[ nTab , 25 ]),aTabCalend[ nTab , 25 ],fDemissao(SRA->RA_SITFOLH, SRA->RA_RESCRAI) )
			cDescAfas	:= fDescAfast( cTipAfas )
		EndIF
	
		//Verifica Regra de Apontamento ( Trabalha Feriado ? )
		lTrabaFer := ( PosSPA( aTabCalend[ nTab , 23 ] , cFilSPA , "PA_FERIADO" , 01 ) == "S" )
	
		//-- Consiste Feriados.
		IF ( lFeriado := aTabCalend[ nTab , 19 ] )  .AND. !lTrabaFer
			cOcorr := aTabCalend[ nTab , 22 ]
		EndIF
	
		//-- Carrega Array aDescAbono com os Abonos ocorridos no Dia
		nLenDescAb := Len(aAbonados)
		For nX := 1 To nLenDescAb
		
			If aAbonados[nX,1] == dData
				aAdd(aDescAbono, aAbonados[nX,2] + Space(1) + aAbonados[nX,3]+ Space(2) + aAbonados[nX,4])
			EndIf
			
		Next nX
	
		//-- Ordem e Tipo do dia em quest„o.
		cOrdem  := aTabCalend[nTab,2]
		cTipDia := aTabCalend[nTab,6]
	
	    //-- Se a Data da marcacao for Posterior a Admissao
		IF dData >= SRA->RA_ADMISSA
		
			//-- Se Afastado
			If ( lAfasta  .AND. aTabCalend[nTab,10] <> 'E' ) .OR. ( lAfasta  .AND. aTabCalend[nTab,10] == 'E' .AND. !lImpExcecao )
				cOcorr := cDescAfas 
			//-- Se nao for Afastado
			Else         
	
			    //-- Se tiver EXCECAO para o Dia  ------------------------------------------------
				If aTabCalend[nTab,10] == 'E'			
			       //-- Se excecao trabalhada
			       If cTipDia == 'S'  
			          //-- Se nao fez Marcacao
			          If Empty(nMarc)
						 cOcorr := '** Ausente **'	
					  //-- Se fez marcacao	 
			          Else
		          	  //-- Motivo da Marcacao
		          		 If !Empty(aTabCalend[nTab,11])
							 	cOcorr := AllTrim(aTabCalend[nTab,11])
							 Else
							 	cOcorr := '** Excecao nao Trabalhada **'
							 EndIf
			          Endif	 
			       //-- Se excecao outros dias (DSR/Compensado/Nao Trabalhado)
			       Else
	 					//-- Motivo da Marcacao
						If !Empty(aTabCalend[nTab,11])
							cOcorr := AllTrim(aTabCalend[nTab,11])
						Else
							cOcorr := '** Excecao nao Trabalhada **'  
						EndIf
				   Endif	
	
			    //-- Se nao Tiver Excecao  no Dia ---------------------------------------------------
			    Else    

		        //-- Se feriado 
		       	If lFeriado 
						//-- Se nao trabalha no Feriado
						If !lTrabaFer 

							cOcorr := If(!Empty(cOcorr),cOcorr,'** Feriado **' ) // '** Feriado **' 

						//-- Se trabalha no Feriado
						Else                  

						    //-- Se Dia Trabalhado e Nao fez Marcacao
					    	If cTipDia == 'S' .and. Empty(nMarc)
								cOcorr := '** Ausente **'
					    	ElseIf cTipDia == 'D'
								cOcorr := '** D.S.R. **'  
							ElseIf cTipDia == 'C'
								cOcorr := '** Compensado **'
							ElseIf cTipDia == 'N'
								cOcorr := '** Nao Trabalhado **'
							EndIf

						Endif
			    	Else

			    	    //-- Se Dia Trabalhado e Nao fez Marcacao
				    	If cTipDia == 'S' .and. Empty(nMarc)
							cOcorr := '** Ausente **'
				    	ElseIf cTipDia == 'D'
							cOcorr := '** D.S.R. **'
						ElseIf cTipDia == 'C'
							cOcorr := '** Compensado **'
						ElseIf cTipDia == 'N'
							cOcorr := '** Nao Trabalhado **'
						EndIf
					
					Endif	
			    Endif
			Endif
		Endif	    
		
		nLenDescAb := Len(aDescAbono) 
			
		//-- Adiciona Nova Data a ser impressa.
		aAdd(aImp,{})
		aAdd( aSaldos, { "    ", "    " } )
		aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])
		lDuplo := .F.
	
		//-- Abono na Data.
		If ( nLenDescAb  > 0 )
		
	    	If cOcorr == '** Ausente **'
			  	aAdd( aImp[Len(aImp)], cOcorr ) // '** Ausente **'
			Else
				If !empty(cOcorr)
					aAdd( aImp[Len(aImp)],	Space(01)) 
				  	aAdd( aImp[Len(aImp)], cOcorr )
					aAdd( aImp,{})
					aAdd( aSaldos, { "    ", "    " } )
					aAdd( aImp[Len(aImp)], aTabCalend[nTab,1])
					aAdd( aImp[Len(aImp)],	Space(01) )
					lDuplo := .T.
				Else                                   
					aAdd( aImp[Len(aImp)],	Space(01)) 
				Endif	
			Endif
			
			For nX := 1 To nLenDescAb
			
				If nX == 1
					aAdd( aImp[Len(aImp)], aDescAbono[nX])
				Else
					aAdd(aImp, {})
					aAdd( aSaldos, { "    ", "    " } )
					aAdd(aImp[Len(aImp)], aTabCalend[nTab,1]		)
					aAdd(aImp[Len(aImp)], Space(01)			 	)
					aAdd(aImp[Len(aImp)], aDescAbono[nX]			)
					lDuplo := .T.
				Endif
				
			Next nX
			
		Else
		
			If cOcorr == '** Ausente **'
			
				aAdd( aImp[Len(aImp)], cOcorr) 
				aAdd( aImp[Len(aImp)], Space(01)) 
				
			Else
			
				aAdd( aImp[Len(aImp)], Space(01)) 
			  	aAdd( aImp[Len(aImp)], cOcorr )
			  	
			Endif	
			
		Endif
	
		//-- Marca‡oes ocorridas na data.
		If nMarc > 0
		
			While nMarc <= nLenMarc .and. cOrdem == aMarcacoes[nMarc,3]
			
				nContMarc ++
				aAdd( aImp[Len(aImp)], StrTran( StrZero( aMarcacoes[ nMarc, 2 ], 5, 2 ), '.', ':' ) )
				nMarc ++
				
			EndDo

		EndIf

		aHorDia := _fCalcHeSA(aImp[Len(aImp)][1])
		IF Len(aImp) <> Len(aSaldos)
			aAdd( aSaldos, { Transform( Right( aHorDia[1], 4 ), IIF(!Empty(aHorDia[1]),"@R 99:99","9999" ) ), Transform( Right( aHorDia[2], 4 ), IIF(!Empty(aHorDia[2]),"@R 99:99","9999" ) ) } )
		ELSE
			aSaldos[Len(aImp)] := { Transform( Right( aHorDia[1], 4 ), IIF(!Empty(aHorDia[1]),"@R 99:99","9999" ) ), Transform( Right( aHorDia[2], 4 ), IIF(!Empty(aHorDia[2]),"@R 99:99","9999" ) ) }
		ENDIF
		

	Next nDia
	
	lRet := If(nContMarc>=1,.t.,.f.)

Return( lRet )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Calcula as Horas Extras, atrasos e saídas antecipadas.
Static Function _fCalcHeSA(dMarcacao)

	Local aGetArea := GetArea()
	Local aAreaSpi := GetArea("SPI")
	Local aAreaSpc := GetArea("SPC")
	Local _cHE  := ""
	Local _cFalt:= ""

	//Caso funcionario utilize banco de horas
	If lBancoHora

		SPI->(dbSetOrder(2))
		SPI->( dbSeek( xFilial("SPI")+SRA->RA_MAT+DtoS(dMarcacao) ) )
	
		WHILE SRA->RA_MAT+DtoS(dMarcacao) == SPI->(PI_MAT+DtoS(PI_DATA) ) .AND. ! SPI->(EOF()) 
			IF SPI->PI_PD < "400"
				_cHE  := Exec4Oper( _cHE,   Eval(bQtdHorSpi), "+")
			ELSE
				_cFalt:= Exec4Oper( _cFalt, Eval(bQtdHorSpi), "+")
			ENDIF
			SPI->(dbSkip())
		ENDDO
	
	//Caso funcionario nao utilize banco de horas
	//Nao calcula horas extras
	Else
				
		SPC->(dbSetOrder(2))
		SPC->( dbSeek( xFilial("SPC")+SRA->RA_MAT+DtoS(dMarcacao)))
	
		WHILE SRA->RA_MAT+DtoS(dMarcacao) == SPC->(PC_MAT+DtoS(PC_DATA) ) ;
	          .AND. ! SPC->(EOF()) 
			
			//IF SPC->PC_PD $ "004/106/107"
			IF SPC->PC_PD $ Alltrim(GetMv("MV_RTC_01"))
				_cHE  := Exec4Oper( _cHE,   Eval(bQtdHorSpc), "+")
			//ELSEIF SPC->PC_PD $ "498/409/010"  
			ELSEIF SPC->PC_PD $ Alltrim(GetMv("MV_RTC_02")) 
				_cFalt:= Exec4Oper( _cFalt, Eval(bQtdHorSpc), "+")
			ENDIF
			SPC->(dbSkip())
		ENDDO	
	Endif	
	
	RestArea(aAreaSpc)
	RestArea(aAreaSpi)
	RestArea(aGetArea)

Return( { _cHE, _cFalt } )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function _fCalHoras(dEntrada,dSaida,cHorIni,cHorFim)

	IF dEntrada <> dSaida

		cHCalc := Exec4Oper( Exec4Oper(   "2400", cHorIni, "-" ), Exec4Oper(  cHorFim,  "0000", "-" ), "+" )
		
	ELSE

		cHCalc := Exec4Oper( cHorFim, cHorIni, "-" )

	ENDIF
	
Return( IIF(VAL(cHCalc)>0,cHCalc,"    ") )	
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Imp_Cabec ³ Autor ³ EQUIPE DE RH          ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do espelho do ponto                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function Imp_Cabec(nTamLin ,nColunas, nTamanho ,_nTipoCab )

	Local cDet			:= ""
	Local cHtml			:= ""              
	Local lImpTurnos	:=.f.
	Local nVezes		:= ( nColunas / 2 )
	Local nQtdeTurno	:= 0.00
	Local nX				:= 0.00    
	Local nTamTno		:= ( Min(TamSx3("R6_DESC")[1], nTamLin:=132) ) 
	                        
	//DEFAULT lTerminal := .f.
	DEFAULT _nTipoCab := 3 // 1 - Cab para as Marcacoes / 2 - Totais / 3 - Sem Cab Auxiliar
	
	lImpTurnos := If(Li==1,.t.,.f.) //-- Somente imprime as trocas de turnos na 1 pagina de cada funcionario

		//-- Inicializa a impress„o
	
	    @ 0,0 PSAY AvalImp(nTamLin )
		
		//-- Inicializa Li com 1 para n„o imprimir cabecalho padrao
		Li := 01
	
		//-- Linha 01
		//-- Emp...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Matr..: 99-999999  Chapa : 9999999999
		cDet := 'Emp...: '  + PADR( If(Len(aInfo)>0,aInfo[03],SM0->M0_NomeCom) , 50)  // 'Emp...: '
		cDet += SPACE(2)+ ' Matr..: '  + SRA->RA_Filial + '-' + SRA->RA_Mat  // ' Matr..: '
		cDet += '  Chapa : '  + SRA->RA_Chapa // '  Chapa : '
		cDet += '     C.C.: '  + PADR(AllTrim(aFuncFunc[1]) + '-' + aFuncFunc[2] , 30) // 'C.C...: '

		Impr(cDet,'C')
		
		//-- Linha 02
		//-- End...: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Nome..: XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		cDet := 'End...: '  + PADR( If(Len(aInfo)>0,aInfo[04],SM0->M0_EndCob) , 50) // 'End...: '
		cDet += SPACE(2) + ' Nome..: '  + SRA->RA_Nome  // ' Nome..: '

		Impr(cDet,'C')
		
		//-- Linha 03
		//-- CGC...: 99.999.999/9999-99                Categ.: XXXXXXXXXXXXXXX 
		cDet := 'CGC...: '  + PADR(Transform( If(Len(aInfo)>0,aInfo[08],SM0->M0_CGC),'@R ##.###.###/####-##'),50)   // 'CGC...: '
		cDet += SPACE(2) + ' Categ.: '  + aFuncFunc[6] // ' Categ.: '
		cDet += SPACE(2) + 'Funcao: '  + aFuncFunc[3] + '-' + aFuncFunc[4]  // 'Funcao: '
		Impr(cDet,'C')
		
		//-- Linha 04
		//-- Turno.: 999-XXXXXXXXXXXXXXXXXXXXX
		//-- Imprime Trocas de turnos
		nQtdeTurno:=Len(aPrtTurn)
		
		If !lImpTroca .OR. nQtdeTurno<2   //-- Imprime Somente a descricao do turno atual
		   If !lImpTroca .OR. nQtdeTurno == 0 //-- Periodo Atual ou Superior
		   	  cDet := 'Turno.: '  + AllTrim(SRA->RA_TnoTrab) + ' ' + fDescTno(SRA->RA_Filial,SRA->RA_TnoTrab, nTamTno) // 'Turno.: '
		   Else	 //Periodo Anterior 
			  cDet := 'Turno.: '  + AllTrim(Alltrim(aPrtTurn[1,1])) + ' ' + fDescTno(SRA->RA_Filial,aPrtTurn[1,1], nTamTno) // 'Turno.: '
		   Endif
		   Impr(cDet,'C')
		Else
	        If lImpTurnos // Se for o mesmo funcionario nao imprime trocas de turnos a partir da 2 pagina
	        	//-- Imprime Trocas de Turnos no Periodo
				For nX := 1 To nQtdeTurno
					cDet:= If(nX==1,"EU",SPACE(Len("EU")))
			    	cDet:= cDet+DTOC(aPrtTurn[nX,2])+" "+"EU"+Alltrim(aPrtTurn[nX,1])+": "+Alltrim(fDescTno( SRA->RA_FILIAL, aPrtTurn[nX,1], nTamTno))
					Impr(cDet,'C')
				Next nX 
			
			Endif	
		Endif
	
		_nTipoCab := 1
		If _nTipoCab==1
			//-- Monta e Imprime Cabecalho das Marcacoes
			cHeader := '   DATA    DIA     '
			
			//								99/99/9999 Segunda
			For nX := 1 To nVezes
				cHeader += StrZero(nX,If(nX<10,1,2)) + 'a E. ' + StrZero(nX,If(nX<10,1,2)) + 'a S. '  // 'a E. '###'a S. '
			Next nX
			//-- Qdo for "1a E. 2a S."  acrescenta mais 20 Brancos para que na eventual existencia de
			//-- ocorrencias como Excecoes e DSr e Compensado, as descricoes das mesmas saem integras,
			//-- sem cortes. 
			cHeader+=If(nVezes==1,SPACE(12),'') 
			cHeader += 'Motivo de Abono           Horas'+Space(11)+'Saldo HE  S.Ant./Atr'
			//Impr(Replicate('-',nTamLin), 'C')
			Impr(cHeader, 'C')
			Impr(Replicate('-',nTamLin), 'C')
		   //cMes := Month(
		Elseif _nTipoCab==2                   
			Impr(Replicate('-',nTamLin), 'C')
			Impr(' ' ,'C')
			If Len(aTotais) % 2 # 0
				aAdd (aTotais, Space(Len(aTotais[1])))
			Endif
			
			If Len(xResumo) % 2 # 0
				aAdd (xResumo, Space(Len(xResumo[1])))
			Endif
			
			If nImpHrs == 1 .or. nImpHrs == 3
				cDet := 'Cod Descricao             Calc. Infor.    Cod Descricao             Calc. Infor.'
			ElseIf nImpHrs == 2
				cDet := 'Cod Descricao                   Infor.    Cod Descricao                   Infor.'
			Endif
		
			Impr(cDet,'C')
			Impr(Replicate('=',38)+Space(4)+Replicate('=',38),'C')
		Endif
	//Else
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Monta o Cabecalho das Marcacoes							   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	 /*   cHtml +=									'<tr>' + CRLF
	    cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
	    cHtml +=									'</tr>' + CRLF
		cHtml +=									'<tr>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	    cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0042 + CRLF	//'Data'
	    cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	    cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0043 + CRLF	//'Dia'
	    cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		For nX := 1 To nVezes
			cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	   		cHtml +=											'<div align="center">' + CRLF
	    	cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0044 + CRLF	// '&#170;E.'
	   		cHtml +=											'</div>' + CRLF
	    	cHtml +=										'</td>' + CRLF
			cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	   		cHtml +=											'<div align="center">' + CRLF
	    	cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0045 + CRLF	//'&#170;S.'
	   		cHtml +=											'</div>' + CRLF
	    	cHtml +=										'</td>' + CRLF
		Next nX
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	    cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0046 + CRLF //'Observa&ccedil;&otilde;s
	    cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	    cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0041 + CRLF	//'Motivo de Abono           Horas  Tipo da Marca&ccedil;&atilde;o'
	    cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
	    cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0047 + CRLF	//'Horas  Tipo da Marca&ccedil;&atilde;o'
	    cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
	    cHtml +=									'</tr>' + CRLF
	    cHtml +=									'<tr>' + CRLF
	    cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
	    cHtml +=									'</tr>' + CRLF
	EndIF
	*/	
Return( cHtml )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CarAboTot ³ Autor ³ EQUIPE DE RH          ³ Data ³ 08/08/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega os totais do SPC e os abonos                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarAboTot( aTotais , aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp ) 

	Local aTotSpc		:= {} //-- 1-SPC->PC_PD/2-SPC->PC_QUANTC/3-SPC->PC_QUANTI/4-SPC->PC_QTABONO
	Local aCodAbono		:= {}
	Local aJustifica	:= {} //-- Retorno fAbonos() c/Cod abono e horas abonadas.
	Local cString   	:= ""
	Local cFilSP9   	:= xFilial( "SP9" , SRA->RA_FILIAL )
	Local cFilSRV		:= xFilial( "SRV" , SRA->RA_FILIAL )
	Local cFilSPC   	:= xFilial( "SPC" , SRA->RA_FILIAL )
	Local cFilSPH   	:= xFilial( "SPH" , SRA->RA_FILIAL )
	Local cImpHoras 	:= If(nImpHrs==1,"C",If(nImpHrs==2,"I","*")) //-- Calc/Info/Ambas
	Local cAutoriza 	:= If(nImpAut==1,"A",If(nImpAut==2,"N","*")) //-- Aut./N.Aut./Ambas
	Local cAliasRes		:= IF( lImpAcum , "SPL" , "SPB" )
	Local cAliasApo		:= IF( lImpAcum , "SPH" , "SPC" )
	Local bAcessaSPC 	:= &("{ || " + ChkRH("PONR010","SPC","2") + "}")
	Local bAcessaSPH 	:= &("{ || " + ChkRH("PONR010","SPH","2") + "}")
	Local bAcessaSPB 	:= &("{ || " + ChkRH("PONR010","SPB","2") + "}")
	Local bAcessaSPL 	:= &("{ || " + ChkRH("PONR010","SPL","2") + "}")
	Local bAcessRes		:= IF( lImpAcum , bAcessaSPH , bAcessaSPC )
	Local bAcessApo		:= IF( lImpAcum , bAcessaSPL , bAcessaSPB )
	Local lCalcula	 	:= .f.
	Local lExtra	 	:= .f.
	Local nColSpc   	:= 0.00
	Local nCtSpc    	:= 0.00
	Local nQuaSpc		:= 0.00
	Local nPass     	:= 0.00
	Local nHorasCal 	:= 0.00
	Local nHorasInf 	:= 0.00
	Local nX        	:= 0.00
	Local cCodPd
	
	If ( lImpRes )
	
		//Totaliza Codigos a partir do Resultado	
		fTotalSPB( @aTotSpc, SRA->RA_Filial, SRA->RA_Mat, dMarcIni, dMarcFim, bAcessRes, cAliasRes, cAutoriza )
		
		//-- Converte as horas para sexagenal quando impressao for a partir do resultado
		If ( lSexagenal )	// Sexagenal
			For nCtSpc := 1 To Len(aTotSpc)
				For nColSpc := 2 To 4
					aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'H')
				Next nColSpc
			Next nCtSpc
		Endif
		
	Endif
	
	//Totaliza Codigos a partir do Movimento
	fTotaliza( @aTotSpc, SRA->RA_FILIAL, SRA->RA_MAT, bAcessApo, cAliasApo, cAutoriza, @aCodAbono, aAbonosPer, lMvAbosEve, lMvSubAbAp )
	
	//-- Converte as horas para Centesimal quando impressao for a partir do apontamento
	If !( lImpRes ) .and. !( lSexagenal ) // Centesimal
		For nCtSpc :=1 To Len(aTotSpc)
			For nColSpc :=2 To 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'D')
			Next nColSpc
		Next nCtSpc
	Endif
	
	cCodPd := ""
	
	//-- Monta Array com Totais de Horas
	If nImpHrs # 4  //-- Se solicitado para Listar Totais de Horas
		For nPass := 1 To Len(aTotSpc)
			IF ( lImpRes ) //Impressao dos Resultados
				//-- Se encontrar o Codigo da Verba ou For um codigo de hora extra valido de acordo com o solicitado  
				If PosSrv( aTotSpc[nPass,1] , cFilSRV , NIL , 01 )
					nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
					nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
					If nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
					   cString := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 999.99'),Space(6)) + Space(1)
					   cString += If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 999.99'),Space(6))
					   aAdd( aTotais, aTotSpc[nPass,1] + Space(1) + Left(SRV->RV_DESC,20) + Space(1) + cString )
					   cCodPd += aTotSpc[nPass,1]+";"
					EndIf	
				Endif
			ElseIf PosSP9( aTotSpc[nPass,1] , cFilSP9 , NIL , 01 )
				//-- Impressao a Partir do Movimento
				nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
				nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
				If nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
					cString := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 999.99'),Space(6)) + Space(1)
					cString += If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 999.99'),Space(6))
					aAdd( aTotais, aTotSpc[nPass,1] + Space(1) + Left(DescPDPon(aTotSpc[nPass,1], cFilSP9 ), 20 ) + Space(1) + cString )
					cCodPd += aTotSpc[nPass,1]+";"
				EndIf  
			EndIF
		Next nPass
		
		//-- Acrescenta as informacoes referentes aos eventos associados aos motivos de abono
		//-- Condicoes: Se nao For Impressao de Resultados 
		//-- 			e Se For para Imprimir Horas Calculadas ou Ambas
		If !( lImpRes ) .and. (nImpHrs == 1 .or. nImpHrs == 3) 
			For nX := 1 To Len(aCodAbono) 
				// Converte as horas para Centesimal
				If !( lSexagenal ) // Centesimal
					aCodAbono[nX,2]:=fConvHr(aCodAbono[nX,2],'D')
				Endif
				aAdd( aTotais, aCodAbono[nX,1] + Space(1) + DescPDPon(aCodAbono[nX,1], cFilSP9) + '      0,00 '  + Transform(aCodAbono[nX,2],'@E 99,999.99') )
				cCodPd += aTotSpc[nX,1]+";"
			Next nX
		Endif
		
		IF .NOT. "101"	$ cCodPd
			aAdd(aTotais, "101" + Space(1) + Left(DescPDPon("101", cFilSP9),20) + '   0,00 '  + Transform(0,'@E 999.99') )
		ENDIF

		IF .NOT. "102"	$ cCodPd
			aAdd(aTotais, "102" + Space(1) + Left(DescPDPon("102", cFilSP9),20) + '   0,00 '  + Transform(0,'@E 999.99') )
		ENDIF

		IF .NOT. "107"	$ cCodPd
			aAdd(aTotais, "107" + Space(1) + Left(DescPDPon("107", cFilSP9),20) + '   0,00 '  + Transform(0,'@E 999.99') )
		ENDIF

		IF .NOT. "409"	$ cCodPd
			aAdd(aTotais, "409" + Space(1) + Left(DescPDPon("409", cFilSP9),20) + '   0,00 '  + Transform(0,'@E 999.99') )
		ENDIF
		
	EndIf

Return( NIL )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fTotaliza ³ Autor ³ Mauricio MR           ³ Data ³ 27/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizar as Verbas do SPC (Apontamentos) /SPH (Acumulado) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fTotaliza(	aTotais	,cFil		,cMat		,bAcessa 	,cAlias		,cAutoriza	,aCodAbono	,aAbonosPer	,lMvAbosEve	,lMvSubAbAp )

	Local aJustifica	:= {}
	Local cCodigo		:= ""
	Local cPrefix		:= SubStr(cAlias,-2)
	Local cTno			:= ""
	Local cCodExtras	:= ""
	Local cEvento		:= ""
	Local cPD			:= ""
	Local cPDI			:= ""
	Local cCC			:= ""
	Local cTPMARCA		:= ""
	Local dPD			:= Ctod("//")
	Local lExtra		:= .t.
	Local lAbHoras		:= .t.
	Local nQuaSpc		:= 0.00
	Local nX			:= 0.00 
	Local nEfetAbono	:= 0.00
	Local nQUANTC		:= 0.00
	Local nQuanti		:= 0.00
	Local nQTABONO		:= 0.00
	
	If ( cAlias )->(dbSeek( cFil + cMat ) )

		While (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )
        
			dData		:= (cAlias)->(&(cPrefix+"_DATA"))  	//-- Data do Apontamento
			cPD		:= (cAlias)->(&(cPrefix+"_PD"))    	//-- Codigo do Evento
			cPDI		:= (cAlias)->(&(cPrefix+"_PDI"))     	//-- Codigo do Evento Informado
			nQUANTC	:= (cAlias)->(&(cPrefix+"_QUANTC"))  	//-- Quantidade Calculada pelo Apontamento
			nQuanti	:= (cAlias)->(&(cPrefix+"_QUANTI"))  	//-- Quantidade Informada
			nQTABONO	:= (cAlias)->(&(cPrefix+"_QTABONO")) 	//-- Quantidade Abonada
			cTPMARCA	:= (cAlias)->(&(cPrefix+"_TPMARCA")) 	//-- Tipo da Marcacao
			cCC		:= (cAlias)->(&(cPrefix+"_CC")) 		//-- Centro de Custos

			/*
			
			ESSE BLOCO FOI CRIADO E COMENTADO, POIS A LORRAYNNE INFORMOU UMA QUANTIDADE DE FALTAS E ACHAVA QUE ERA OUTRA. ELA SUSTENTOU
			A SISTUÇÃO ATÉ QUE EU CONSEGUI PROVAR QUE ELA HAVIA LANÇADO ERRADO. QUANDO CONSEGUI PROVAR ESSE BLOCO PERDEU A FINALIDADE.
			
			IF cPD > "400" .AND. cAlias == "SPC"
				cAbono	:= (cAlias)->(&(cPrefix+"_ABONO"))  //Codigo do abono aplicado as horas de faltas/atrasos/saídas antecipadas
				IF SP6->(dbSeek(xFilial("SP6")+cAbono))
					IF SP6->P6_ABHORAS == "S"
						nQUANTC  -= nQTABONO
					ENDIF
				ENDIF
			ENDIF
			
			*/
			
			If (cAlias)->( !Eval(bAcessa) )
				(cAlias)->( dbSkip() )
				Loop
			EndIf
			
			If dData < dMarcIni .or. dDATA > dMarcFim 
				(cAlias)->( dbSkip() )
				Loop
			Endif
	        
			 /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Obtem TODOS os ABONOS do Evento							   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			//-- Trata a Qtde de Abonos
			aJustifica 	:= {} //-- Reinicializa aJustifica
			nEfetAbono	:=	0.00
			If nQuanti == 0 .and. fAbonos( dData , cPD , NIL , @aJustifica , cTPMARCA , cCC , aAbonosPer ) > 0
            
            //-- Corre Todos os Abonos
				For nX := 1 To Len(aJustifica)
			    
				   /*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³ Cria Array Analitico de Abonos com horas Convertidas.		   ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					//-- Obtem a Quantidade de Horas Abonadas
					nQuaSpc := aJustifica[nX,2] //_QtAbono
					
					//-- Converte as horas Abonadas para Centesimal
					If !( lSexagenal ) // Centesimal
						nQuaSpc:= fConvHr(nQuaSpc,'D')
					Endif
	                
	                //-- Cria Novo Elemento no array ANALITICO de Abonos 
					aAdd( aAbonados, {} )
					aAdd( aAbonados[Len(aAbonados)], dData )
					aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C') )
					
					aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':') )
					aAdd( aAbonados[Len(aAbonados)], DescTpMarca(aBoxSPC,cTPMARCA))
				
					If !( lImpres )
						/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Trata das Informacoes sobre o Evento Associado ao Motivo corrente ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
						//-- Obtem Evento Associado
						cEvento := PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_EVENTO" , 01 )
						If ( lAbHoras := ( PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_ABHORAS" , 01 ) $ " S" ) )
						    //-- Se o motivo abona Horas
							If ( lAbHoras )
								If !Empty( cEvento )
									If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
										aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
									Else
										aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
									EndIf
								Else 
									/*
									ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									³ A T E N C A O: Neste Ponto deveriamos tratar o paramentro MV_ABOSEVE  ³
									³                no entanto, como ja havia a deducao abaixo e caso al-  ³
									³                guem migra-se da versao 609 com o cadastro de motivo   ³
									³                de abonos abonando horas mas sem o codigo, deixariamos ³
									³                de tratar como antes e o cliente argumentaria alteracao³
									³                de conceito.											³
									ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
								    //-- Se o motivo  nao possui abono associado
								    //-- Calcula o total de horas a abonar efetivamente
								    nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
									EndIf
							Endif
						Else	
							/*
							ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							³Se Motivo de Abono Nao Abona Horas e o Codigo do Evento Relaci³
							³onado ao Abono nao Estiver Vazio, Eh como se fosse uma  altera³
							³racao do Codigo de Evento. Ou seja, Vai para os Totais      as³
							³Horas do Abono que serao subtraidas das Horas Calculadas (  Po³
							³deriamos Chamar esta operacao de "Informados via Abono" ).	   ³
							³Para que esse processo seja feito o Parametro MV_SUBABAP  deve³
							³ra ter o Conteudo igual a "S"								   ³
							ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
							IF ( ( lMvSubAbAp ) .and. !Empty( cEvento ) )
							   //-- Se o motivo  nao possui abono associado
							   //-- Calcula o total de horas a abonar efetivamente 
							   If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
									aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
							   Else
									aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
							   EndIf
							   //-- O total de horas acumulado em nEfetAbono sera deduzido do 
							   //-- total de horas apontadas.
						   	nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
							Endif
						EndIf
					Endif	
				Next nX 
			Endif
        
        If !( lImpres )

				//-- Obtem o Codigo do Evento  (Informado ou Calculado)
				cCodigo:= If(!Empty(cPDI), cPDI, cPD )
	         
				//-- Obtem a posicao no Calendario para a Data
				If ( nPos 	:= aScan(aTabCalend, {|x| x[1] ==dDATA .and. x[4] == '1E' }) ) > 0
					
				    //-- Obtem o Turno vigente na Data
				    cTno	:=	aTabCalend[nPos,14]  
				    //-- Carrega ou recupera os codigos correspondentes a horas extras na Data
				    cCodExtras	:= ''
				    CarExtAut( @cCodExtras , cTno , cAutoriza )
				    lExtra:=.f.
				    
				    If cCodigo$cCodExtras 
				       lExtra:=.t.
				    Endif   
				    
				Endif      
	                 
				//-- Se o Evento for Alguma HE Solicitada (Autorizada ou Nao Autorizada) 
				//-- Ou  Valido Qquer Evento (Autorizado e Nao Autorizado)
				//-- OU  Evento possui um identificador correspondente a Evento Autorizado ou Nao Autorizado.
				If lExtra .or. cAutoriza == '*' .or. (aScan(aId,{|aEvento| aEvento[1] == cCodigo .and. Right(aEvento[2],1) == cAutoriza }) > 0.00)		
				      
				   //-- Procura em aTotais pelo acumulado do Evento Lido
					If ( nPos := aScan(aTotais,{|x| x[1] = cCodigo  }) ) > 0    
					   
					   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
					   aTotais[nPos,2] := __TimeSum(aTotais[nPos,2],If(nQuanti>0, 0, __TimeSub(nQUANTC,nEfetAbono)))
					   aTotais[nPos,3] := __TimeSum(aTotais[nPos,3],nQuanti)
					   aTotais[nPos,4] := __TimeSum(aTotais[nPos,4],nQTABONO)
					  
					Else 
					   
					   //-- Adiciona Evento em Acumulados
					   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
					   aAdd(aTotais,{cCodigo,If(nQuanti > 0, 0, __TimeSub(nQUANTC,nEfetAbono)), nQuanti,nQTABONO,lExtra })
					   
				   Endif
				Endif
	      Endif
			(cAlias)->( dbSkip() )
		EndDo
	Endif

Return( NIL )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fTotalSPB ³ Autor ³ EQUIPE DE RH		    ³ Data ³ 05/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totaliza eventos a partir do SPB.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fTotalSPB(aTotais,cFil,cMat,dDataIni,dDataFim,bAcessa,cAlias)

	Local cPrefix := ""
	
	cPrefix		:= SubStr(cAlias,-2)
	
	If ( cAlias )->( dbSeek( cFil + cMat ) )
		While (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )
	
			If (cAlias)->( &(cPrefix+"_DATA") < dDataIni .or. &(cPrefix+"_DATA") > dDataFim )
				(cAlias)->( dbSkip() )
				Loop
			Endif
	
			If (cAlias)->( !Eval(bAcessa) )
				(cAlias)->( dbSkip() )
				Loop
			EndIf
	
			If ( nPos := aScan(aTotais,{|x| x[1] == (cAlias)->( &(cPrefix+"_PD") ) }) ) > 0
				aTotais[nPos,2] := aTotais[nPos,2] + (cAlias)->( &(cPrefix+"_HORAS") ) 
			Else
				aAdd(aTotais,{(cAlias)->( &(cPrefix+"_PD") ),(cAlias)->( &(cPrefix+"_HORAS") ),0,0 })
			Endif
			(cAlias)->( dbSkip() )
		End While
	Endif

Return( NIL )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LoadX3Box ³ Autor ³ Mauricio MR           ³ Data ³ 10.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna array da ComboBox                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCampo - Nome do Campo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function LoadX3Box(cCampo)

	Local aRet:={},nCont,nIgual
	Local cCbox,cString
	Local aSvArea := SX3->(GetArea())
	
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(cCampo))
	
	cCbox := SX3->(X3Cbox())
	//-- Opcao 1   |Opcao 2 |Opcao 3|Opcao 4
	//-- 01=Amarelo;02=Preto;03=Azul;04=Vermelho  
	//   | À->nIgual        À->nCont
	//   À->cString: 01=Amarelo
	//aRet:={{01,Amarelo},{02.Preto},...}
	
	While !Empty(cCbox) 
	   nCont:=AT(";",cCbox) 
	   nIgual:=AT("=",cCbox)
	   cString:=AllTrim(SubStr(cCbox,1,nCont-1)) //Opcao
	   IF nCont == 0
	       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
	      Exit
	   Else
	       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
	   Endif 
	   cCbox:=SubStr(cCbox,nCont+1)
	Enddo
	   
	RestArea(aSvArea)

Return( aRet )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³DescTPMarc³ Autor ³ Mauricio MR           ³ Data ³ 10.12.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Descricao do Tipo da Marcacao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aBox     - Array Contendo as Opcoes do Combox Ja Carregadas³±±
±±³          ³ cTpMarca - Tipo da Marcacao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ponr010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function DescTpMarca(aBox,cTpMarca)

	Local aTpMarca:={},cRet:='',nTpMarca:=0
	//-- SE Existirem Opcoes Realiza a Busca da Marcacao
	If Len(aBox)>0
	   nTpmarca:=aScan(aBox,{|xtp| xTp[1] == cTpMarca})
	   cRet:=If(nTpMarca>0,aBox[nTpmarca,2],"")
	Endif

Return( cRet )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImprEsp   ³ Autor ³ Mauricio MR           ³ Data ³ 22/01/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se Deve Imprimir Cabec Especifico                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ImprEsp(Detalhe,FimFolha,Pos_cabec,nTamLin,nColunas,        ³±±
±±³          ³        nTamanho,lTerminal)                                 ³±±
±±³          ³A) Parametros de Acordo com a Impr:                         ³±±
±±³          ³  Detalhe   => Linha detalhe a ser Impressa                 ³±±
±±³          ³  FimFolha  => "C"(impressao continua)ou "P"(Pula Pagina)   ³±±
±±³          ³  Pos_cabec => Posicionamento do Cabecalho                  ³±±
±±³          ³B) Parametros de Acordo com a Imp_Cabec                     ³±±
±±³          ³  nTamLin   => Tamanho da Linha                             ³±±
±±³          ³  nColunas  => Qtde de Colunas a Imprimir                   ³±±
±±³          ³  nTamanho  => Tamanho do Relatorio                         ³±±
±±³          ³  lTerminal => Indica se Impressao de Destina a Web         ³±±
±±³          ³  _nTipoCab  => Tipo de Cabec Auxiliar                       ³±± 
±±³          ³               01 - Para Marcacoes : Data Dia 1aE 1aS 2aE...³±± 
±±³          ³               02 - Para Totais    : Cod. Descricao ....    ³±± 
±±³          ³               03 - Somente : Empresa,Funcionario ....      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP  e ImpEsp                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function ImprEsp( Detalhe, FimFolha, Pos_cabec, nTamLin, nColunas, nTamanho, _nTipoCab )

	nTamLin := 132
	nColunas:= 8
	nTamanho:= "M"
	_nTipoCab:= 2
	IF ( LI > MaxLine )
	   Imp_Cabec( nTamLin , nColunas , nTamanho , _nTipoCab )
	  	//ImprEsp(Replicate('-',nTamLin),'C',,nTamLin , nColunas ,  nTamanho )
	EndIF
	
	@ LI,00 PSAY DETALHE
	LI = LI+1

Return( NIL )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Monta_Per³ Autor ³Equipe Advanced RH     ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function Monta_Per( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )

	Local aPeriodos := {}
	Local cFilSPO	:= xFilial( "SPO" , cFil )
	Local dAdmissa	:= SRA->RA_ADMISSA
	Local dPerIni   := Ctod("//")
	Local dPerFim   := Ctod("//")
	
	SPO->( dbSetOrder( 1 ) )
	SPO->( dbSeek( cFilSPO , .f. ) )
	While SPO->( !Eof() .and. PO_FILIAL == cFilSPO )
	                       
	    dPerIni := SPO->PO_DATAINI
	    dPerFim := SPO->PO_DATAFIM  
	
	    //-- Filtra Periodos de Apontamento a Serem considerados em funcao do Periodo Solicitado
	    IF dPerFim < dDataIni .OR. dPerIni > dDataFim                                                      
			SPO->( dbSkip() )  
			Loop  
	    Endif
	
	    //-- Somente Considera Periodos de Apontamentos com Data Final Superior a Data de Admissao
	    IF ( dPerFim >= dAdmissa )
	       aAdd( aPeriodos , { dPerIni , dPerFim , Max( dPerIni , dDataIni ) , Min( dPerFim , dDataFim ) } )
		Else
			Exit
		EndIF
	
		SPO->( dbSkip() )
	
	End While
	
	IF ( aScan( aPeriodos , { |x| x[1] == dIniAtu .and. x[2] == dFimAtu } ) == 0.00 )
		dPerIni := dIniAtu
		dPerFim	:= dFimAtu 
		IF !(dPerFim < dDataIni .OR. dPerIni > dDataFim)
			IF ( dPerFim >= dAdmissa )
				aAdd(aPeriodos, { dPerIni, dPerFim, Max(dPerIni,dDataIni), Min(dPerFim,dDataFim) } )
			EndIF
	    Endif
	EndIF

Return( aPeriodos )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CarExtAut³ Autor ³ Mauricio MR           ³ Data ³ 24/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna Relacao de Horas Extras por Filial/Turno           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCodExtras --> String que Contem ou Contera os Codigos     ³±±
±±³          ³ cTnoCad    --> Turno conforme o Dia                        ³±±
±±³          ³ cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas       ³±± 
±±³          ³                "A" Horas Autorizadas                       ³±± 
±±³          ³                "N" Horas Nao Autorizadas                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONM010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CarExtAut( cCodExtras , cTnoCad , cAutoriza )

	Local aTabExtra		:= {}
	Local cFilSP4		:= fFilFunc("SP4")
	Local cTno			:= ""
	Local lFound		:= .f.
	Local lRet			:= .t.
	Local nX			:= 0
	Local naTabExtra	:= 0    
	Local ncTurno	    := 0.00
	
	Static aExtrasTno
	
	If ( PCount() == 0.00 )
	
		aExtrasTno	:= NIL              
	
	Else
	
		DEFAULT aExtrasTno	:= {} 
			
		//-- Procura Tabela (Filial + Turno corrente)
		If ( lFound	:= ( SP4->( dbSeek( cFilSP4 + cTnoCad , .f. ) ) ) )
		   cTno		:=	cTnoCad
		   lFound	:=	.t.
		Else      
		    //-- Procura Tabela (Filial)    
		    cTno	:= Space(Len(SP4->P4_TURNO))
			lFound	:= SP4->( dbSeek(  cFilSP4 + cTno , .f.) )
		Endif    
		
		//-- Se Existe Tabela de HE
		If ( lFound )
		   //-- Verifica se a Tabela de HE para o Turno ainda nao foi carregada
		   If (ncTurno:=aScan(aExtrasTno,{|aTurno| aTurno[1]  == cFilSP4 .and. aTurno[2] == cTno} )) == 0.00
		      //-- Se nao Encontrou Carrega Tabela para Filial e Turno especificos
		      GetTabExtra( @aTabExtra , cFilSP4 , cTno , .f. , .f. )     
		      //-- Posiciona no inicio da Tabela de HE da Filial Solicitada
			  If !Empty(aTabExtra)
				  naTabExtra:=	Len(aTabExtra)
				  //-- Corre C¢digos de Hora Extra da Filial
				  For nX:=1 To naTabExtra
						//-- Se Ambos os Tipos de Eventos ou Autorizados
						If cAutoriza == '*' .or. (cAutoriza == 'A' .and. !Empty(aTabExtra[nX,4]))
							cCodExtras += aTabExtra[nX,4]+'A' //-- Cod Autorizado                
						Endif
						//-- Se Ambos os Tipos de Eventos ou Nao Autorizados					
						If cAutoriza == '*' .or. (cAutoriza == 'N' .and. !Empty(aTabExtra[nX,5]))
							cCodExtras += aTabExtra[nX,5]+'N' //-- Cod Nao Autorizado                
						EndIf
				  Next nX
			  Endif	  
			  //-- Cria Nova Relacao de Codigos Extras para o Turno Lido
			  aAdd(aExtrasTno,{cFilSP4,cTno,cCodExtras})
		    Else
		        //-- Recupera Tabela Anteriormente Lida
		        cCodExtras:=aExtrasTno[ncTurno,3] 
		    Endif                    
		    
		Endif	
	
	Endif

Return( lRet )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CarId    ³ Autor ³ Mauricio MR           ³ Data ³ 24/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna Relacao de Eventos da Filial						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFil       --> Codigo da Filial desejada					  ³±±
±±³          ³ aId    	  --> Array com a Relacao	                      ³±±
±±³          ³ cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas       ³±± 
±±³          ³                "A" Horas Autorizadas                       ³±± 
±±³          ³                "N" Horas Nao Autorizadas                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONM010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/	
Static Function CarId( cFil , aId , cAutoriza )

	Local nPos	:= 0.00
	
	//-- Preenche o Array aCodAut com os Eventos (Menos DSR Mes Ant.)
	SP9->( dbSeek( cFil , .t. ) )
	While SP9->( !Eof() .and. cFil == P9_FILIAL )
		IF ( ( Right(SP9->P9_IDPON,1) == cAutoriza ) .or. ( cAutoriza == "*" ) )
			aAdd( aId , Array( 04 ) )
			nPos := Len( aId )
			aId[ nPos , 01 ] := SP9->P9_CODIGO	//-- Codigo do Evento 
			aId[ nPos , 02 ] := SP9->P9_IDPON 	//-- Identificador do Ponto 
			aId[ nPos , 03 ] := SP9->P9_CODFOL	//-- Codigo do da Verba Folha
			aId[ nPos , 04 ] := SP9->P9_BHORAS	//-- Evento para B.Horas
		EndIF
		SP9->( dbSkip() )
	EndDo

Return( NIL )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Static Function AjustaX1()

	Local cGrupo	:= "PNR010"
	Local cNumero	:= "3"
	Local cOrdem	:= "0"+cNumero
	Local cTipo		:= "N"
	Local nTamanho	:= 1
	Local nDecimal	:= 0
	Local nPresel	:= 0
	Local cGSC		:= "C" // G=get C=combo
	Local cPergPor	:= "Qual Moeda ?"
	Local cPergSpa	:= "¨Cual Moneda ?"
	Local cPergEng	:= "Which Currency ?"
	Local aHelpPor	:= {"Indica em qual moeda os valores ","serao impressos."}
	Local aHelpSpa	:= {"Indica en cual moneda los valores ","seran impresos."}
	Local aHelpEng	:= {"Indicate which currency the values ","will be printed"}
	Local cDescPor	:= "Moeda "
	Local cDescSpa	:= "Moneda "
	Local cDescEng	:= "Currency "
	Local aPergs := {}
	
	
	PutSx1(cGrupo,cOrdem,cPergPor,cPergSpa,cPergEng,"mv_ch"+cNumero,cTipo,nTamanho,nDecimal,nPresel,cGSC,"","","","","mv_par"+cOrdem,cDescPor+"1",cDescSpa+"1",cDescEng+"1","",;
	cDescPor+"2",cDescSpa+"2",cDescEng+"2",;
	cDescPor+"3",cDescSpa+"3",cDescEng+"3",;
	cDescPor+"4",cDescSpa+"4",cDescEng+"4",;
	cDescPor+"5",cDescSpa+"5",cDescEng+"5",;
	aHelpPor, aHelpEng, aHelpSpa )
	
	
	aAdd(aPergs,{"Mostra C.Custo ?"		,"Muestra C.Costo ?"		,"Show C.Center ?"	,"mv_ch4","N",1 ,0,1,"C","","mv_par04","Nao","No","No","","","Sim","Si","Yes","","","","","","","","","","","","","","","","","","",""})
	aAdd(aPergs,{"Mostra Item Ctb. ?"	,"Muestra It.Assiento ?"	,"Show Acc.It. ?"	,"mv_ch5","N",1 ,0,1,"C","","mv_par05","Nao","No","No","","","Sim","Si","Yes","","","","","","","","","","","","","","","","","","",""})
	aAdd(aPergs,{"Mostra Cl.Valor ?"	,"Muestra Cl.Valor ?"		,"Show Val.Class ?"	,"mv_ch6","N",1 ,0,1,"C","","mv_par06","Nao","No","No","","","Sim","Si","Yes","","","","","","","","","","","","","","","","","","",""})
	AjustaSx1(cGrupo, aPergs)
Return(Nil)
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//CONVERTE HORAS PARA MINUTOS
//cHora --> no formato 9999 onde 99 - Horas e 99 - Minutos
//RETORNA A HORA CONVERTIDA PARA MINUTOS E TIPO NUMÉRICO
User Function THor2Mi2(xHora) 
	
	Local nTamHor, nMinRet:=0

	IF ValType( xHora ) == "N"
		nMinRet := ( Int(xHora) * 60 ) +  ( xHora - Int(xHora) )
	ELSEIF ValType( xHora ) == "C"
		IF ( nTamHor:= At(":",xHora) ) > 0
		ELSEIF ( nTamHor:= At(".",xHora) ) > 0
		ELSEIF ( nTamHor:= At(",",xHora) ) > 0
		ELSE
			nTamHor:= Len(xHora)-2
		ENDIF
		nMinRet := ( Val( LEFT( xHora, nTamHor ) ) * 60 ) + Val( Right( xHora, 2 ) )
	ENDIF

Return( nMinRet )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//CONVERTE MINUTOS PARA HORAS
//cHora --> no formato 9999 onde 99 - Horas e 99 - Minutos
//RETORNA OS MINUTOS CONVERTIDOS PARA HORA NO FORMATO 9999 E TIPO CARACTER
User Function TMin2Ho2(nMin)

	Local cRetHor := AllTrim( Str( Int( nMin / 60 ), , 0 ) )
	Local cRetMin := StrZero( Mod( nMin, 60 ), 2, 0 ) 
	
	IF Len(cRetHor) == 1
		cRetHor := "0" +cRetHor
	EndIf
	
Return( cRetHor + cRetMin )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
//REALIZA OPERAÇÕES ENVOLVENDO HORAS
//cHora1,cHora2 --> no formato 9999 onde 99 - Horas e 99 - Minutos
//cOper --> Operação a ser realizada M(Multiplica),D(Divite),+(Soma),-(Subtrai)
//RETORNA O RESULTADOS CONVERTIDO PARA HORA E MINUTOS NO FORMATO 9999 E TIPO CARACTER
Static Function Exec4Oper(cHora1,cHora2,cOper) 

	Local bHorRet
	Local nResult
	
	Default cOper := '-'

	IF cOper == "D" //Divisor de Horas
		bHorRet := {|| u_TMin2Hor( u_THor2Min( cHora1 ) / u_THor2Min( cHora2 ) ) }
	ElseIf cOper == "M" //Multiplicador de Horas
		bHorRet := {|| u_TMin2Hor( u_THor2Min( cHora1 ) * u_THor2Min( cHora2 ) ) }
	ElseIf cOper == "+" //Somatória de Horas
		bHorRet := {|| u_TMin2Hor( u_THor2Min( cHora1 ) + u_THor2Min( cHora2 ) ) }
	Else	//Subtração de Horas
		bHorRet := {|| (nResult:=u_THor2Min( cHora1 ) - u_THor2Min( cHora2 )), u_TMin2Hor( IIF( nResult > 0, nResult, 0 ) ) }
	EndIf
	
Return( Eval(bHorRet) )
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function f_ChkSPI

Local cQuery := ""
Local lRet   := .F.

cQuery  := " SELECT DISTINCT 'S' RESULTADO            " + CHR(13) + CHR(10)
cQuery  += " FROM !SPI! SPI                           "	+ CHR(13) + CHR(10)
cQuery  += " WHERE SPI.D_E_L_E_T_	   =  ''          " + CHR(13) + CHR(10)
cQuery  += "  AND SPI.PI_FILIAL 	   =  !PI_FILIAL! " + CHR(13) + CHR(10)
cQuery  += "  AND SPI.PI_MAT		   =  !PI_MAT!    " + CHR(13) + CHR(10)
cQuery  += "  AND SPI.PI_DATA  	       >= !PI_DATA1!  " + CHR(13) + CHR(10)
cQuery  += "  AND SPI.PI_DATA	       <  !PI_DATA2!  " + CHR(13) + CHR(10)

cQuery  := StrTran(cQuery, "!SPI!"	      , RetSqlName("SPI")        )
cQuery  := StrTran(cQuery, "!PI_FILIAL!" , ValToSql( xFilial("SPI")))
cQuery  := StrTran(cQuery, "!PI_MAT!"    , ValToSql( SRA->RA_MAT )  )
cQuery  := StrTran(cQuery, "!PI_DATA1!"  , ValToSql( dDtIni )      )
cQuery  := StrTran(cQuery, "!PI_DATA2!"  , ValToSql( dDtFim )      )

MemoWrite("\ARQ1.TXT",cQuery)

IF Select("ARQ1") > 0
	ARQ1->(dbCloseArea())
ENDIF

//Ajusta a consulta
cQuery := ChangeQuery(cQuery)

//Cria Alias temporario para a consulta
TcQuery cQuery New Alias "ARQ1"

If ARQ1->RESULTADO == 'S'
	lRet := .T.
Endif

Return lRet

//Subtrai Horas, retornando valor negativo
User Function fHoraNe2(cPer1,cPer2)

Local nMin1 := nMin2 := nSub := 0
Local cRet  := ''

nMin1 := U_THor2Min(cPer1)	
nMin2 := U_THor2Min(cPer2)	

nSub := (nMin1 - nMin2)

If nSub > 0 
	cRet := "+" + U_TMin2Hor(nSub)
Else
	nSub := (nSub * -1)
	cRet := "-" + U_TMin2Hor(nSub)	
Endif

Return cRet
#include 'fivewin.ch'
#include "poncalen.ch"
#include "topconn.ch"
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PONR060  ³ Autor ³ R.H. - J. Ricardo     ³ Data ³ 12.08.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Autorizacao do Pagamento de Horas Extras                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PONR060(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marinaldo   ³06/04/01³Melhor³Retirada da Funcao fDescTno() que era esta³±±
±±³            ³--------³------³tica no Programa para utilizacao da  fDesc³±±
±±³            ³--------³------³tno() Existente no PonxFun().             ³±± 
±±³Mauricio MR ³27/02/02³Melhor³A)Inclusao da GetMarcacoes em substituicao³±± 
±±³            ³        ³      ³do algoritimo anterior para tratar a lei -³±±  
±±³            ³        ³      ³tura do SP8(marcacoes).                   ³±±  
±±³            ³        ³      ³B)Inclusao do PonCalen.ch e substituicao  ³±±  
±±³            ³        ³      ³dos indices dos arrays pelas Constantes   ³±±  
±±³            ³        ³      ³correspondentes.                          ³±±  
±±³Marinaldo   ³28/02/02³Melhor³Inclusao da Funcao fChkSX1() que ira inici³±±
±±³            ³        ³      ³alizar as Datas de Acordo com o Periodo de³±±  
±±³            ³        ³      ³Apontamento que sera montado a partir   da³±±  
±±³            ³        ³      ³Data Base do Sistema					  ³±±  
±±³ Priscila R.³04/06/02³------³Ajuste no relatorio para que seja impresso³±± 
±±³            ³--------³------³corretamente o C.C no tamanho 20.         ³±± 
±±³Mauricio MR ³04/12/02³------³Retirada a restricao de existencia de cra-³±± 
±±³            ³--------³------³cha para a emissao do relatorio.	      ³±± 
±±³Mauricio MR ³20/10/03³Melhor³Considera horas extras interjornadas e    ³±± 
±±³            ³        ³      ³de nona hora.						      ³±± 
±±³Edmilson BSB³10/05/07³Melhor³Acrescentar Total Geral ao Final		  ³±± 
±±³Rafael      ³17/04/08³Melhor³Inclusao de tratamento para verificar se  ³±±
±±³            ³        ³      ³tratase de periodo fechado (parametros    ³±±
±±³            ³        ³      ³"Data Inicial" e "Data Final".  		  ³±± 
±±³            ³        ³      ³Caso positivo relatorio ira buscar informa³±±
±±³            ³        ³      ³coes na tabela de Apontamentos Acumulados ³±±
±±³            ³        ³      ³"SPH", para efetuar a impressao dos dados ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TMP001()

Local wnRel				:=	'RTCR060' 
Local cDesc1  			:= 'Relatorio para Autorizacao do Pagamento de Horas Extras'
Local cDesc2  			:= 'Ser  impresso de acordo com os parametros solicitados pelo'
Local cDesc3  			:= 'usuario.'
Local cString 			:= 'SRA' 
Local aOrd    			:= {'Matricula','Centro de Custo','Nome','Turno','C.Custo+Nome'} 

Private xTotHor
Private aReturn    	:= {'Zebrado',01,'Administracao',01,02,01,'',01} 
Private nomeprog   	:= 'RTCR060'
Private aLinha     	:= {}
Private aTabPadrao 	:= {}
Private nLastKey   	:= 0
Private cPerg      	:= 'PNR060    '
Private Titulo   		:= OemToAnsi('Autorizacao do Pagamento de Horas Extras' ) 
Private cCabec   		:= ''
Private AT_PRG   		:= 'RTCR060'
Private wCabec0  		:= 1
PRIVATE wCabec1  		:= "Chapa Matr.  Funcionario                         Data   Cod Descricao            Horas      Visto"
Private ContFl   		:= 1
Private Li       		:= 0 
Private nTamanho 		:=	'N'
Private nOrdem   		:= 0
Private aInfo    		:=	{}

Begin Sequence

	//-- Parƒmetro MV_PAPONTA    
	
	Private dPerIni := CtoD('')
	Private dPerFim := CtoD('')
    
	//-----> Ajuste Acumulados de Apontamentos I
	//Comentado para nao considerar o periodo de apontamento atual
	//If !PerAponta(@dPerIni,@dPerFim)
	//	Break
	//Endif
	//-----> Ajuste Acumulados de Apontamentos F
    
	//-----> Ajuste Acumulados de Apontamentos I
	//Comentado para nao considerar o periodo de apontamento atual
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza as Datas no SX1                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//fChkSX1( dPerIni , dPerFim , cPerg )
	//-----> Ajuste Acumulados de Apontamentos F
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( cPerg , .f. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        //  Filial  De                               ³
	//³ mv_par02        //  Filial  Ate                              ³
	//³ mv_par03        //  Centro de Custo De                       ³
	//³ mv_par04        //  Centro de Custo Ate                      ³
	//³ mv_par05        //  Turno De                                 ³
	//³ mv_par06        //  Turno Ate                                ³
	//³ mv_par07        //  Matricula De                             ³
	//³ mv_par08        //  Matricula Ate                            ³
	//³ mv_par09        //  Nome De                                  ³
	//³ mv_par10        //  Nome Ate                                 ³
	//³ mv_par11        //  Situacao                                 ³
	//³ mv_par12        //  Categoria                                ³
	//³ mv_par13        //  Imprime C.C em outra Pagina              ³
	//³ mv_par14        //  Dia Inicial                              ³
	//³ mv_par15        //  Dia Final                                ³
	//³ mv_par16        //  Autorizadas/Nao Autorizadas/Ambas        ³
	//³ mv_par17        //  Relatorio Sintetico/Analitico            ³
	//³ mv_par18        //  Quebra Func.Pag. Sim/Nao                 ³
	//³ mv_par19        //  Imprimir Marca‡äes                       ³
	//³ mv_par20        //  Regra De                                 ³
	//³ mv_par21        //  Regra Ate                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnRel := SetPrint(cString, wnRel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .f., aOrd,,nTamanho)
	
	nOrdem    	:= aReturn[8]
	FilialDe  	:= mv_par01
	FilialAte 	:= mv_par02
	CcDe      	:= mv_par03
	CcAte     	:= mv_par04
	TurDe     	:= mv_par05
	TurAte    	:= mv_par06
	MatDe     	:= mv_par07
	MatAte    	:= mv_par08
	NomDe     	:= mv_par09
	NomAte    	:= mv_par10
	cSit      	:= mv_par11
	cCat      	:= mv_par12
	lCC       	:=	iif(	mv_par13 == 1, .t., .f.)
	nTipHoras 	:= mv_par16
	nSinAna   	:= mv_par17
	lImpFol	  	:=	iif( 	mv_par18 == 1, .t., .f.)
	lImpMar   	:=	iif( 	mv_par19 == 1, .t., .f.)
	RegDe     	:= mv_par20
	RegAte    	:= mv_par21	

	If mv_par14 > mv_par15
		Help(' ', 1, 'PNR050DATA')
		Break
	Endif

	If	nLastKey == 27
		Break
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Break
	Endif

	//-----> Ajuste Acumulados de Apontamentos I
	//Ajustado para que a data do periodo seja a data parametrizada
	dPerIni := dInicio := mv_par14
	dPerFim := dFim    := mv_par15
	//-----> Ajuste Acumulados de Apontamentos F
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega todas as tabelas de hor rio                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !fTabTurno(aTabPadrao)
		Break
	EndIf

	cCabec := 'Relatorio para Autorizacao do Pagamento de Horas Extras'

	Titulo := OemToAnsi(cCabec)

    RptStatus({|lEnd| PO060Imp(@lEnd,wnRel,cString)},Titulo)

End Sequence	

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PO060Imp ³ Autor ³ R.H. - J. Ricardo     ³ Data ³ 10.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Autorizacao de Horas Extras                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ PO060Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PO060Imp(lEnd,WnRel,cString)

Local nPosT
Local xQuant
Local xDescri
Local nPos         	:= 0
Local nFor		   	:= 0
Local nMar		   	:= 0
Local cOrdem	   	:= ''
Local cCod029A	   	:= ''
Local cCod025A	   	:= ''
Local aImpressao		:=	{}
Local aAutorizado  	:=	{}
Local cPD          	:= Space(03)
Local cAcessaSRA   	:= &("{ || " + ChkRH("PONR060","SRA","2") + "}")
Local cAcessaSPC   	:= &("{ || " + ChkRH("PONR060","SPC","2") + "}")

Private nPosMarc   	:=	0 
Private nLenMarc   	:=	0
Private aDet       	:=	{}
Private aMarcFun   	:=	{}
Private aTabPadrao 	:=	{}
Private aTabCalend 	:=	{}
Private lCabec     	:=	.f.
Private lCabecCC   	:=	.f.
Private lCabecTT   	:=	.f.
Private lPrimeira  	:=	.t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega todas as tabelas de hor rio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !fTabTurno(aTabPadrao)
	Return Nil
EndIf

dbSelectArea( "SRA" )
dbGoTop()
DbSetOrder(nOrdem)

If nOrdem == 1
	dbSeek(FilialDe + MatDe,.t.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSeek(FilialDe + CcDe + MatDe,.t.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := FilialAte + CcAte + MatAte
	lCabecCC := iif(!lImpFol,.t.,.f.)
ElseIf nOrdem == 3
	dbSeek(FilialDe + NomDe + MatDe,.t.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := FilialAte + NomAte + MatAte
ElseIf nOrdem == 4
	dbSeek(FilialDe + TurDe,.t.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_TNOTRAB"
	cFim     := FilialAte + TurAte
	lCabecTT := iif(!lImpFol,.t.,.f.)
ElseIf nOrdem == 5
	dbSetOrder(8)
	dbSeek(FilialDe + CcDe + NomDe,.t.)
	cInicio  := 'SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
Endif

SetRegua(SRA->(RecCount()))

cTnoAnt      := 'úúú'
cSeqAnt      := 'úú'
aTabOPadrao  := {}
aTabOrigin   := {}
aTabCalend   := {}
cTurnoant    := "@@@"
cFilAnterior := "@@"
cCcAnt       := Replicate('@',Len(SRA->RA_CC))

dbSelectArea( "SRA" )    

Do While !EOF() .and. &cInicio <= cFim
	
	IncRegua()

	If lEnd
		Impr(cCancela,"C")
		Exit
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SRA->( !(RA_FILIAL $ fValidFil()) .or. !Eval(cAcessaSRA) )
		SRA->(dbSkip())
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If (SRA->RA_Nome    < NomDe) .or. (SRA->RA_Nome > NomAte) 		.or. ;
		(SRA->RA_Mat     < MatDe) .or. (SRA->RA_Mat > MatAte)  		.or. ;
		(SRA->RA_CC      < CcDe)  .or. (SRA->RA_CC > CCAte) 			.or. ;
		(SRA->RA_TNOTRAB < TurDe) .or. (SRA->RA_TNOTRAB > TurAte)	.or. ;
		(SRA->RA_REGRA   < RegDe) .or. (SRA->RA_REGRA > RegAte)
		SRA->(dbSkip())
		Loop
	Endif

	If (SRA->RA_DEMISSA < dInicio .and. ! Empty(SRA->RA_DEMISSA))
		SRA->(DbSkip())
		Loop
	Endif

	If !(SRA->Ra_SitFolh $ cSit) .or. !(SRA->Ra_CatFunc $ cCat)
		DbSkip()
		Loop           // Testa Categoria e Situacao
	Endif

	If SRA->RA_FILIAL # cFilAnterior // quebra filial
		lCabec 			:=	.t.
		cFilAnterior 	:= SRA->RA_Filial
		cTurnoAnt 		:= "@@@"
		cCcAnt       	:= Replicate('@',Len(SRA->RA_CC))
	Endif

	If nOrdem == 4 .and. cTurnoAnt # SRA->RA_TNOTRAB 
		If !lImpFol
			lCabecTT := .t.
		Endif
		cCcAnt    := Replicate('@',Len(SRA->RA_CC))
		cTurnoAnt := SRA->RA_TNOTRAB
	Endif

	If ( nOrdem == 2 .or. nOrdem == 5 ) .and. SRA->RA_CC # cCcAnt
		If lCc
			lCabec := .t.
		Endif
		lCabecCC := .t.
	Endif                
	
	cCcAnt 		:= SRA->RA_CC
	cTurnoAnt 	:= SRA->RA_TNOTRAB
	dDtMarc		:=	CtoD("")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Calendario de Marca‡oes do Periodo                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If cTnoAnt + cSeqAnt # SRA->RA_TNOTRAB + SRA->RA_SEQTURN
		cTnoAnt	:= SRA->RA_TNOTRAB
		cSeqAnt 	:= SRA->RA_SEQTURN	
	Endif
    
	//-- Cria Calendario com o periodo completo com Trocas de Turno
	
	aTabCalend := {} ; aTurnos   := {} ; aMarcacoes := {}
    
	//-- Carrega as Marcacoes do Periodo
	IF !GetMarcacoes(	@aMarcacoes			,;	//Marcacoes dos Funcionarios
					  		@aTabCalend			,;	//Calendario de Marcacoes
					  		@aTabPadrao			,;	//Tabela Padrao
					  		@aTurnos				,;	//Turnos de Trabalho
					  		dPerIni 				,;	//Periodo Inicial
					  		dPerFim				,;	//Periodo Final
					  		SRA->RA_FILIAL		,;	//Filial
					  		SRA->RA_MAT			,;	//Matricula
					  		SRA->RA_TNOTRAB	,;	//Turno
					  		SRA->RA_SEQTURN	,;	//Sequencia de Turno
					  		SRA->RA_CC			,;	//Centro de Custo
					  		"SP8"					,;	//Alias para Carga das Marcacoes
					  		.f.    				,;	//Se carrega Recno em aMarcacoes
					  		.t.      			,;	//Se considera Apenas Ordenadas
					  		.t.      			,;	//Se Verifica as Folgas Automaticas
					  		.f.      			 )	//Se Grava Evento de Folga Automatica Periodo Anterior
        
		Set Device to Screen
		Help(' ',1,'PONSCALEND')
		Set Device to Printer
		cTnoAnt := 'úúú'
		cSeqAnt := 'úú'
		SRA->(dbSkip())
		Loop
    EndIF
	
	//-- Obtem Qtde de Marcacoes
	
	nLenMarc:=Len(aMarcacoes)

	aDet := {}

	// 1 - Data
	// 2 - Codigo do Evento
	// 3 - Descricao do Evento
	// 4 - Quantidade de horas Abonadas
	// 5 - Marcacoes

	dRef := CtoD("")

   xTotHor := 0

	dbSelectArea( "SPC" )

	If DbSeek( SRA->RA_Filial + SRA->RA_MAT )

		Do While !Eof() .and. SPC->PC_FILIAL + SPC->PC_MAT == SRA->RA_FILIAL + SRA->RA_MAT

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste controle de acessos e filiais validas               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
			
			If SPC->( !Eval(cAcessaSPC) )
				SPC->(dbSkip())
				Loop
			EndIf

			//-- Verifica o Periodo Solicitado
			
			If Empty(SPC->PC_DATA) .or. SPC->PC_DATA < dInicio .or. SPC->PC_DATA > dFim
				DbSkip()
				Loop
			Endif

			If dRef # SPC->PC_DATA
				dRef       	:= SPC->PC_DATA
				aAutorizado :=	{}				
	
				If aScan(aTabCalend,{ |x| DtoS(x[1]) == DtoS(dRef) }) > 0
					If SP4->( dbSeek( ( cFilSP4 := iif(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := SRA->RA_TnoTrab ) ) ) .or. ;
						SP4->( dbSeek( ( cFilSP4 := iif(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := Space(3)        ) ) )
						Do While !SP4->(Eof()) .and. cFilSP4 + cTno == SP4->P4_FILIAL + SP4->P4_TURNO	 
							If nTipHoras == 1
								aAdd(aAutorizado,{SP4->P4_CODAUT,iif(SP9->(dbSeek(fFilFunc('SP9')+SP4->P4_CODAUT)),SP9->P9_DESC,Space(20))})
							ElseIf nTipHoras == 2
								aAdd(aAutorizado,{SP4->P4_CODNAUT,iif(SP9->(DbSeek(fFilFunc('SP9')+SP4->P4_CODNAUT)),SP9->P9_DESC,Space(20))})
							ElseIf nTipHoras == 3	 
								aAdd(aAutorizado,{SP4->P4_CODAUT,iif(SP9->(dbSeek(fFilFunc('SP9')+SP4->P4_CODAUT)),SP9->P9_DESC,Space(20))})
								aAdd(aAutorizado,{SP4->P4_CODNAUT,iif(SP9->(DbSeek(fFilFunc('SP9')+SP4->P4_CODNAUT)),SP9->P9_DESC,Space(20))})
							Endif	 
							SP4->(dbSkip())
						Enddo
					Endif    
					If nTipHoras <> 2
   						cCod029A := PosSP9("029A",SRA->RA_FILIAL,"P9_IDPON",2)
   						If !Empty(cCod029A)
							aAdd(aAutorizado,{SP9->P9_CODIGO,SP9->P9_DESC})
						Endif
						cCod025A := PosSP9("025A",SRA->RA_FILIAL,"P9_IDPON",2)
   						If !Empty(cCod025A)
							aAdd(aAutorizado,{SP9->P9_CODIGO,SP9->P9_DESC})
						Endif	
					Endif 
				Endif
			Endif

			//-- Quando houver codigo informado, este sera utilizado
			//-- em substituicao ao codigo apontado
			cPD := iif(Empty(SPC->PC_PDI),SPC->PC_PD, SPC->PC_PDI)
			
			//-- Verifica se eh um codigo contido na relacao de codigos 
			//-- definidas segundo avariavel cCodigos
			nPos := aScan(aAutorizado,{ |x| x[1] = cPD })
			
   		//-- Se o Codigo do Evento apontado  eh Valido
			If nPos > 0
			
				//-- Obtem a quantidade do evento apontando
				xQuant := iif(SPC->PC_QUANTI>0,SPC->PC_QUANTI,SPC->PC_QUANTC)
            
            //-- Posiciona na TabCalend para a Data Lida
            nTab := aScan(aTabCalend, {|x| x[CALEND_POS_DATA] == SPC->PC_DATA .and. x[CALEND_POS_TIPO_MARC] == '1E' })
			   
				//-- Se existir calendario para o apontamento
				//-- Obs.: Se um apontamento for digitado pode ocorrer de nao ter
				//--       uma data correspondente na TabCalend ???
				If nTab>0
			  	
			  	   //-- Obtem a Ordem para a Data Lida
			  	   cOrdem    := aTabCalend[nTab,CALEND_POS_ORDEM] //-- Ordem
				
				   aMarcFun:={}
				
				   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				   //³Obtem as Marcacoes Realizadas para a Ordem Lida³
				   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			       If lImpMar
						//-- o Arquivo ‚ setado para a 1a Marca‡„o do dia em quest„o.
						//-- de acordo com a ordem da tabela
						nPosMarc:=aScan(aMarcacoes,{|x| x[3]==cOrdem})
						//-- Se Existir Marcacao para o Dia
						If !Empty(nPosMarc)
							//--  Corre Todas as marcacoes enquanto a mesma ordem
							While cOrdem == aMarcacoes[nPosMarc,3]
								  //-- Monta o array com as Marcacoes do funcionario para a ordem.
								  aAdd(aMarcFun,StrTran(StrZero(aMarcacoes[nPosMarc,2],5,2),'.',':'))
								  nPosMarc++
						 		  //-- Se o contador ultrapassar o total de Marcacoes abandona loop
						 		  If nPosMarc>nLenMarc
						 			 Exit
						 		  Endif   
							EndDo
					    Endif
				   Endif		   
				Endif 
						
				If nSinAna == 1	// Sintetica
					If ( nPosDet := aScan( aDet , { |x| x[2] =  cPD } ) ) > 0
						aDet[nPosDet,4] := SomaHoras(aDet[nPosDet,4],xQuant)
					Else
						aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant, aMarcFun })	
					Endif			
				Else
					aAdd(aDet,{ SPC->PC_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] , xQuant, aMarcFun })	
				Endif
			Endif
			
			DbSkip()
		EndDo
        
		//-----> Ajuste Acumulados de Apontamentos I
		//Verifica se nao foi encontrada informacao para o array de detalhes
		If Len(aDet) == 0                      
			
			//Guarda areas atuais
			aTMPArea := GetArea()
			
			DbSelectArea("SPH")
			DbSetOrder(1) 
			
			If DbSeek( SRA->RA_Filial + SRA->RA_MAT )

				Do While !Eof() .and. SPH->PH_FILIAL + SPH->PH_MAT == SRA->RA_FILIAL + SRA->RA_MAT
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Consiste controle de acessos e filiais validas               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
					
					If SPH->( !Eval(cAcessaSPC) )
						SPH->(dbSkip())
						Loop
					EndIf
		
					//-- Verifica o Periodo Solicitado
					
					If Empty(SPH->PH_DATA) .or. SPH->PH_DATA < dInicio .or. SPH->PH_DATA > dFim
						DbSkip()
						Loop
					Endif   
		
					If dRef # SPH->PH_DATA
						dRef       	:= SPH->PH_DATA
						aAutorizado :=	{}				
			
						If aScan(aTabCalend,{ |x| DtoS(x[1]) == DtoS(dRef) }) > 0
							If SP4->( dbSeek( ( cFilSP4 := iif(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := SRA->RA_TnoTrab ) ) ) .or. ;
								SP4->( dbSeek( ( cFilSP4 := iif(Empty(xFilial('SP4')), xFilial('SP4'), SRA->RA_Filial) ) + ( cTno := Space(3)        ) ) )
								Do While !SP4->(Eof()) .and. cFilSP4 + cTno == SP4->P4_FILIAL + SP4->P4_TURNO	 
									If nTipHoras == 1
										aAdd(aAutorizado,{SP4->P4_CODAUT,iif(SP9->(dbSeek(fFilFunc('SP9')+SP4->P4_CODAUT)),SP9->P9_DESC,Space(20))})
									ElseIf nTipHoras == 2
										aAdd(aAutorizado,{SP4->P4_CODNAUT,iif(SP9->(DbSeek(fFilFunc('SP9')+SP4->P4_CODNAUT)),SP9->P9_DESC,Space(20))})
									ElseIf nTipHoras == 3	 
										aAdd(aAutorizado,{SP4->P4_CODAUT,iif(SP9->(dbSeek(fFilFunc('SP9')+SP4->P4_CODAUT)),SP9->P9_DESC,Space(20))})
										aAdd(aAutorizado,{SP4->P4_CODNAUT,iif(SP9->(DbSeek(fFilFunc('SP9')+SP4->P4_CODNAUT)),SP9->P9_DESC,Space(20))})
									Endif	 
									SP4->(dbSkip())
								Enddo
							Endif    
							If nTipHoras <> 2
		   						cCod029A := PosSP9("029A",SRA->RA_FILIAL,"P9_IDPON",2)
		   						If !Empty(cCod029A)
									aAdd(aAutorizado,{SP9->P9_CODIGO,SP9->P9_DESC})
								Endif
								cCod025A := PosSP9("025A",SRA->RA_FILIAL,"P9_IDPON",2)
		   						If !Empty(cCod025A)
									aAdd(aAutorizado,{SP9->P9_CODIGO,SP9->P9_DESC})
								Endif	
							Endif 
						Endif
					Endif
		
					//-- Quando houver codigo informado, este sera utilizado
					//-- em substituicao ao codigo apontado
					cPD := iif(Empty(SPH->PH_PDI),SPH->PH_PD, SPH->PH_PDI)
					
					//-- Verifica se eh um codigo contido na relacao de codigos 
					//-- definidas segundo avariavel cCodigos
					nPos := aScan(aAutorizado,{ |x| x[1] = cPD })
					
		   		//-- Se o Codigo do Evento apontado  eh Valido
					If nPos > 0
					
						//-- Obtem a quantidade do evento apontando
						xQuant := iif(SPH->PH_QUANTI>0,SPH->PH_QUANTI,SPH->PH_QUANTC)
		            
		            //-- Posiciona na TabCalend para a Data Lida
		            nTab := aScan(aTabCalend, {|x| x[CALEND_POS_DATA] == SPH->PH_DATA .and. x[CALEND_POS_TIPO_MARC] == '1E' })
					   
						//-- Se existir calendario para o apontamento
						//-- Obs.: Se um apontamento for digitado pode ocorrer de nao ter
						//--       uma data correspondente na TabCalend ???
						If nTab>0
					  	
					  	   //-- Obtem a Ordem para a Data Lida
					  	   cOrdem    := aTabCalend[nTab,CALEND_POS_ORDEM] //-- Ordem
						
						   aMarcFun:={}
						
						   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						   //³Obtem as Marcacoes Realizadas para a Ordem Lida³
						   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					       If lImpMar
								//-- o Arquivo ‚ setado para a 1a Marca‡„o do dia em quest„o.
								//-- de acordo com a ordem da tabela
								nPosMarc:=aScan(aMarcacoes,{|x| x[3]==cOrdem})
								//-- Se Existir Marcacao para o Dia
								If !Empty(nPosMarc)
									//--  Corre Todas as marcacoes enquanto a mesma ordem
									While cOrdem == aMarcacoes[nPosMarc,3]
										  //-- Monta o array com as Marcacoes do funcionario para a ordem.
										  aAdd(aMarcFun,StrTran(StrZero(aMarcacoes[nPosMarc,2],5,2),'.',':'))
										  nPosMarc++
								 		  //-- Se o contador ultrapassar o total de Marcacoes abandona loop
								 		  If nPosMarc>nLenMarc
								 			 Exit
								 		  Endif   
									EndDo
							    Endif
						   Endif		   
						Endif 
								
						If nSinAna == 1	// Sintetica
							If ( nPosDet := aScan( aDet , { |x| x[2] =  cPD } ) ) > 0
								aDet[nPosDet,4] := SomaHoras(aDet[nPosDet,4],xQuant)
							Else
								aAdd(aDet,{ SPH->PH_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] ,	xQuant, aMarcFun })	
							Endif			
						Else
							aAdd(aDet,{ SPH->PH_DATA, aAutorizado[nPos,1], aAutorizado[nPos,2] , xQuant, aMarcFun })	
						Endif
					Endif
					
					DbSkip()
				EndDo
			Endif
	        RestArea(aTMPArea)
        Endif
		//-----> Ajuste Acumulados de Apontamentos F
	    
		If Len(aDet) > 0			
						
			aSort( aDet ,,, { |x,y| x[1] < y[1] })
			
			aImpressao := {}

			For nFor := 1 To Len(aDet)
			
				cDet 	:=	""
				cDet2	:=	""	// Impressao da Continuacao das Marcacoes

				If lImpMar .and. nSinAna == 2 .and. dDtMarc <> aDet[nFor,1]
					aMarc   := aDet[nFor,5]
					dDtMarc := aDet[nFor,1]
					For nMar:=1 to Len(aMarc)
						If nMar > 8
							cDet2 += aMarc[nMar]+" "
						Else
							cDet  += aMarc[nMar]+" "
						Endif					
					Next
				Endif     
				
				cDet 	:=	Padr(cDet,49)
				cDet2	:=	Padr(cDet2,49)
				
				//xTotHor += aDet[nFor,4]
				xTotHor=SomaHoras(xTotHor,aDet[nFor,4])				
				xQuant := StrZero(aDet[nFor,4],6,2)
				xQuant := StrTran(xQuant,".",":")

				if	nSinAna == 1 
					cDet 	+=	Space(5)	 
				else
					cDet	+=	SubStr(Dtos(aDet[nFor,1]),7,2) + '/' + SubStr(Dtos(aDet[nFor,1]),5,2)
   			endif

				cDet 	+=	"  " + aDet[nFor,2] + " " + aDet[nFor,3] + " " + xQuant + " "
				cDet	+=	Space(5)	+ Repl("_",20)

				If Li <> 60 .and. nFor > 1
					Impr(" ","C")
				Endif                  
				
				F060ImprL( cDet , Nil , nFor )

				If !Empty(cDet2)
					F060ImprL( cDet2 , .f. , nFor )
				Endif      

				// Só vai gravar o historico se o relatório for analítico

				if	nSinAna == 2					
	    			aAdd( aImpressao , { aDet[nFor,1] , cDet } )
	               
					If !Empty(cDet2)
		    			aAdd( aImpressao , { aDet[nFor,1] , cDet2 } )
					Endif      
				Endif      				
										
				xDescri :=aDet[nFor,3] 
			Next nFor

			If Li <> 60
				Impr(Replicate("-",132),"C")
			Endif
			
			xTotHor := StrZero(xTotHor,6,2) 
			xTotHor := StrTran(xTotHor,".",":")

		   @ li , 000 psay "TOTAL DE HORA(S)EXTRA(S)"
		   @ li , 081 psay xTotHor   

		   li ++

			Impr(Repl("-",132),"C")
			
			If lImpFol
				Impr("","P")
				lCabec:=.t.
			Endif  
			
			if	Len(aImpressao) > 0
			
				//*********************************************************
				// Apagar os movimentos gravados anteriormente caso existam		
				//*********************************************************
            


				/*		Criar Tabela
				For w := 1 to Len(aImpressao)
					SZ0->Z0_FILIAL		:=	xFilial("SZ0")
					SZ0->Z0_MAT			:=	SRA->RA_MAT
					SZ0->Z0_DATA		:=	aImpressao[w,01]
					SZ0->Z0_DESC		:=	aImpressao[w,02]
				Next w
				*/
			Endif
		Endif
	Endif
	DbSelectArea("SRA")
	DbSkip()
Enddo

dbSelectArea( "SP8" )
dbSetOrder(1)

dbSelectArea("SRA")
dbSetOrder(1)
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

Ms_Flush()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Imp_Cabec ³ Autor ³ J.Ricardo             ³ Data ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do Relatorio de Presentes/Ausentes     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR030IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

====================================================================================================
Chapa Matr.  Funcionario                    Data   Cod Descricao            Horas              Visto"
====================================================================================================
Filial: 01-123456789012345  Turno: 001-12345678901234567890    C.C: 123456789-1234567890123456789012
====================================================================================================

12345 123456 123456789012345678901234567890
99:99 99:99 99:99 99:99 99:99 99:99 99:99   99/99  999 1234567890123456789 999.99 12345678901234567890123456789 12345678901234567890
/*/

Static Function Imp_Cabec()

Local  cDet

cDet := "Filial: " + SRA->RA_FILIAL + "-" + Left(SM0->M0_Nome+Space(15),15) //"Filial: "

Li   := 0

If lImpFol
	cDet+= " Turno: "+SRA->RA_TNOTRAB // " Turno: "
	cDet+= "    C.C: "+SUBS(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "    C.C: "
	Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
Endif

Impr(cDet,"C")
Impr(Repl("=",132),"")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³f060ImprL ³ Autor ³ Aldo Marini Junior    ³ Data ³ 30/09/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime detalhe verificando a necessidade de pulo de pagina³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³f060ImprL(cString)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PONR010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function f060ImprL(cString,lImpNome, nFor)

Local cNome:=SRA->RA_CHAPA + " " + SRA->RA_MAT + " " + Left(SRA->RA_NOME,30) + " "
Local lCab := .f.

lImpNome := iif( lImpNome == Nil , .t. , lImpNome ) //-- Define se deve ou nao observar a necessidade de impressao do nome

// Caso seja primeira linha do Detalhe , imprime o Nome do Func.

If nFor == 1 .or. Li == 60 .or. Li == 8
	If Li == 60
		lCabec:=.t.

		If !lImpFol
			If nOrdem == 2 .or. nOrdem == 5
				lCabecCC:=.t.
			Endif

			If nOrdem = 4
				lCabecTT := .t.
			Endif
		Endif
	Endif

	If lImpMar .and. nSinAna == 2
		lCab:=.t.
	Else
		//--@@ 45 / 49
		cString := SubStr(cString,50,Len(cString)-49)
		cString := cNome+Space(05)+cString
	Endif
Endif

If lCabec
	Imp_Cabec()
	lCabec := .f.
Endif

If lCabecCC
	cDet1 := "C.C: " + SUBS(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "C.C: "
	Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
	Impr(cDet1,"C")
	If Li <> 60
		Impr(REPLICATE("-",132),"C")
	Endif
	lCabecCC := .f.
Endif

If lCabecTT
	cDet1 := " Turno: "+SRA->RA_TNOTRAB +"-"+ fDescTno(SRA->RA_FILIAL,SRA->RA_TNOTRAB) // " Turno: "
	Impr(cDet1,"C")
	If Li <> 60
		Impr(REPLICATE("-",132),"C")
	Endif
	lCabecTT := .f.
Endif

If Li < 60
	If lCab .and. lImpNome
		Impr(cNome,"C")
		lCab:=.f.
	Endif
Endif

If Li == 60
	Imp_Cabec()
	If (nOrdem == 2 .or. nOrdem == 5).and. !lImpFol
		cDet1 := "C.C: " + SUBS(SRA->RA_CC+SPACE(20),1,20) + "-" +; // "C.C: "
		Left(DescCc(SRA->RA_CC,SRA->RA_FILIAL,30)+Space(30),30)
		Impr(cDet1,"C")
		Impr(REPLICATE("-",132),"C")
	Endif

	If nOrdem == 4 .and. !lImpFol
		cDet1 := " Turno: "+SRA->RA_TNOTRAB +"-"+ fDescTno(SRA->RA_FILIAL,SRA->RA_TNOTRAB) // " Turno: "
		Impr(cDet1,"C")
		If Li <> 60
			Impr(REPLICATE("-",132),"C")
		Endif
	Endif

	If lImpMar .and. nSinAna == 2
		Impr(cNome,"C")
	Else
		cString := SubStr(cString,50,Len(cString)-49)
		cString := cNome+Space(05)+cString
	Endif	
Endif

Impr(cString,"C")

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fChkSX1  ³ Autor ³ Marinaldo de Jesus    ³ Data ³13/02/2002³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³ Verifica se os Parametros de Periodo estao corretos        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ PONM040                                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fChkSX1( dPerIni , dPerFim , cPerg )

Local aAreaSX1	:= SX1->( GetArea() )
Local dVar      := CtoD("//")

SX1->(dbSetOrder(1))

IF SX1->(dbSeek(cPerg+"14",.f.))
	dVar := CtoD(SX1->X1_CNT01,'ddmmyy')
	IF dVar < dPerIni .or. dVar > dPerFim
		RecLock("SX1")
		SX1->X1_CNT01 := Dtoc(dPerIni)
		SX1->( MsUnlock() )
	EndIF
	SX1->( dbSkip() )
	IF SX1->( X1_GRUPO + X1_ORDEM ) == cPerg+"15"
		dVar := CtoD(SX1->X1_CNT01,'ddmmyy')
		IF dVar < dPerIni .or. dVar > dPerFim
			RecLock("SX1")
			SX1->X1_CNT01 := Dtoc(dPerFim)
			SX1->( MsUnlock() )
		EndIF
	EndIF
EndIF

RestArea( aAreaSX1 )

Return( NIL )
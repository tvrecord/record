#include "Protheus.ch"
#include "GPER080.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	   ³ GPER080  ³ Autor ³ Equipe RH		        ³ Data ³ 12/04/95  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao   ³ Demonstrativo de Medias								       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	   ³ GPER080()	     										       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	  ³ FNC          ³  Motivo da Alteracao				   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Raquel Hager³27/12/2013³M12RH01 RQ0911³Unificacao das Folhas de Pagamento.  ³±±
±±³Mariana M.  ³09/04/2015³TRETC7		 ³Replica chamado TRCNRI			   ³±±
±±³Esther V.   ³01/06/2016³TVFY37		 ³Incluido impressao da filial do func.³±±
±±³Gabriel A.  ³10/06/2016³TVH082        ³Ajuste para considerar os valores    ³±±
±±³            ³          ³              ³corretos no cálculo de médias.       ³±±
±±³Marcia Moura³06/07/16³TVMEN0          ³Criacao do controle para RA_HOJORVA, ³±±
±±³            ³        ³                ³controle de med. horas como sal base ³±±
±±|Claudinei S.|22/07/16|TVQQXK          |Ajuste em Gr080Imp() na chamada da,  |±±
±±|            |        |                |GPEXMED estava passando o lJorvar no |±±
±±|            |        |                |13º parâmetro e na verdade é o 14º.  |±±
±±|Isabel N.   |04/01/2017|MRH-3746      |Ajuste nos nomes dos campos conforme |±±
±±|            |          |              |cadastrados no ATUSX (RA_DEMISSAO p/ |±±
±±|            |          |              |RA_DEMISSA, RA_ADMISSAO p/ RA_ADMISSA|±±
±±|            |          |              |e RF_DATABASE para RF_DATABAS).      |±±
±±|Raquel Hager|19/01/2017|MRH-4655	     |Implementado Totalizador das verbas  |±±
±±|            |          |              |do Grupo 0 - Horista com Jornada     |±±
±±|            |          |              |Variável.  						   |±±
±±³Renan Borges³31/01/2017³MRH-5615	 	 ³Ajuste para no calculo da provisão   ³±±
±±³            ³          ³              ³quando houver férias e periculosidade³±±
±±³            ³          ³              ³paga nas ferias e na folha, seja gera³±±
±±³            ³          ³              ³do a baixa de adicionais corretamente³±±
±±³Raquel Hager³13/02/2017³MRH-4655	    ³Removido impressão de rodapé.         ³±±
±±³Gabriel A.  ³16/03/2017³MRH-8284      ³Ajuste para carregar o aPd de forma  ³±±
±±³            ³          ³              ³correta antes de chamar o GPEXMED.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GPER080X()
	  
Local cDesc1 := STR0001		//"Demonstrativo de M‚dias"
Local cDesc2 := STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0003		//"usu rio."
Local cString:="SRA"					    // alias do arquivo principal (Base)
Local aOrd	 := {STR0004,STR0005,STR0006}	//"Matricula"###"Centro de Custo"###"Nome"
Local aRegs		:= {}
Local aHelp		:= {} 
	 
// Define Variaveis Private(Basicas)									 
Private aReturn := {STR0007, 1,STR0008, 2, 2, 1, "",1 }		// "Zebrado"###"Administra‡„o"
Private nomeprog:="gper080"
Private aLinha	:= { },nLastKey := 0
Private cPerg	:="GPR080"	
Private lTemJorVar	:= ( SRA->( Type("RA_HOJORVA") ) != "U" )
Private lJorVar		:= .F.

// Define Variaveis Private(Programa)							 		
Private nOrdem
Private aInfo	 := {}
Private aFolBas[4] , aAdiBas[4] , aFerBas[4] , a13Bas[4]
Private aFolIR[4]  , aAdiIR[4]	, aFerIR[4]  , a13IR[4]
Private cAnoMes := ""	
// Variaveis Utilizadas na funcao IMPR 						
Private titulo
Private AT_PRG	:= "GPER080"
Private wCabec0 := 1
Private wCabec1 := STR0009		//"DATA BASE: "
Private CONTFL	:= 1
Private LI		:= 0
Private nTamanho:= "M"    
Private cQuerySRH := ""
Private dDataRec  := CTOD("//")  
Private nSalRec   := 0
	
	// Carregar os Mnemonicos 	                                   
	SetMnemonicos(Nil,Nil,.T.)

	// Verifica as perguntas selecionadas						 
	Pergunte("GPR080",.F.)
	

	// Variaveis utilizadas para parametros					    
	// mv_par01		//	Data Base (referencia)					
	// mv_par02		//	Filial	De								
	// mv_par03		//	Filial	Ate 							
	// mv_par04		//	Centro de Custo De						
	// mv_par05		//	Centro de Custo Ate 					
	// mv_par06		//	Matricula De							
	// mv_par07		//	Matricula Ate							
	// mv_par08		//	Nome De 								
	// mv_par09		//	Nome Ate								
	// mv_par10		//	Ferias, 13§ Salario, Aviso Previo, Todos
	// mv_par11		//	Situacao do Funcionario 				
	// mv_par12		//	Categoria do Funcionario				
	// mv_par13		//	Considera Mes Atual do Acumulado   		
	// mv_par14		//	Imprime media de pagamento?        		
	Titulo := STR0010		//"DEMONSTRATIVO DE MEDIAS"	
	wnrel:="GPER080"            //Nome Default do relatorio em Disco
	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)
	
	nOrdem	   := aReturn[8]
	dDtBase    := mv_par01
	cFilDe	   := mv_par02
	cFilAte    := mv_par03
	cCcDe	   := mv_par04
	cCcAte	   := mv_par05
	cMatDe	   := mv_par06
	cMatAte    := mv_par07
	cNomDe	   := mv_par08
	cNomAte    := mv_par09
	nTipoMed   := mv_par10
	cSituacao  := mv_par11
	cCategoria := mv_par12
	lMesAtu    := If(mv_par13 == 3, .F., .T.)  // 1 - Mensal  2 - Acumulado  3 - Nao
	lMovMensal := If(mv_par13 == 1, .T., .F.)
	wCabec1    += DTOC(dDtBase)
	lImpPgto   := If(mv_par14 == 2, .F., .T.)
	cAnoMes    := strzero(year(dDtBase),4)+strzero(month(dDtBase),2)
	
	If nLastKey = 27
		Return
	EndIf
	
	SetDefault(aReturn,cString)
	
	If nLastKey = 27
		Return
	EndIf
	
	RptStatus({|lEnd| GR080Imp(@lEnd,wnRel,cString)},Titulo)
	
	RstXMED() //Reinicializa statics do GPEXMED
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ GR080Imp ³ Autor ³ R.H. - Jose Ricardo	³ Data ³ 12/04/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Demonstrativo de Medias.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso	 	 ³ GPER080   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gr080Imp(lEnd,WnRel,cString)
Local CbTxt 
Local CbCont
Local Val_SalMin := 0
Local dDt1,dDt3,dDt4,dDt6
Local cFilAnterior 	:= Replicate("!", FWGETTAMFILIAL)
Local nSalario	:= nSalMes := nSalDia := nSalHora := 0
Local cArqDbf,cArqNtx
Local cInicio, cFim:= ""
Local cChaveSRF := ""  
Local aHelpPor		:= {}
Local aPerAtual   := {}
Local nRazaoDia   := 0
Local nRazaoHr    := 0
	
// Variaveis de Acesso do Usuario                               
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER080" , "SRA" , "2" ) + " } " )

// Define Variaveis Privates (Programa)					
c__Roteiro			:= "   "
Private aPdv		:= {} // Matriz Incidencia de Verbas Usado na Fvaloriza()
Private aCodFol		:= {}
Private aRoteiro	:= {} 
Private APERIODO	:= {}
Private cComp13 	:= 'N'  

Private aSalFer     := {}
Private aSal13      := {}
Private aSalAP      := {}
Private aSalFol     := {}

	//------------ Variaveis usadas em GPEXMED ---------------
	Private cProcesso
	Private aPerFerias
	Private nVal1Parc13	:= 0
	Private cTipoRot	:= fGetTipoRot( GetRotExec() )                                                                              
		
	If Type("P_FERPAC") == "U"
		Private P_FERPAC:= "N"		
        dbSelectArea("RCA")
        RCA->( dbSetOrder(1) )
		If RCA->( dbSeek( xFilial( "RCA" ) + "P_FERPAC" ) )
			P_FERPAC := AllTrim( RCA->RCA_CONTEU )
		EndIf
	EndIf	     	
	//-------------------------------------------------------
	
	// Criar Arquivo de Medias Temporario
	Cria_TRP(@cArqDbf,@cArqNtx)
	
	dbSelectArea ("SRA")
	DbGoTop()
	If nOrdem == 1
		dbSetOrder(1)
		dbSeek( cFilDe + cMatDe,.T. )
		cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
		cFim	 := cFilAte + cMatAte
	ElseIf nOrdem == 2
		dbSetOrder(2)
		dbSeek( cFilDe + cCcDe + cMatDe,.T. )
		cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
		cFim	 := cFilAte + cCcAte + cMatAte
	ElseIf nOrdem == 3
		dbSetOrder(3)
		dbSeek( cFilDe + cNomDe + cMatDe,.T. )
		cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
		cFim	 := cFilAte + cNomAte + cMatAte
	EndIf
	
	dbSelectArea("SRA")
	SetRegua(SRA->(RecCount()))
	
	While !Eof() .And. &cInicio <= cFim

		IncRegua()
	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif
		
		// Consiste Parametrizacao do Intervalo de Impressao			
		If (SRA->RA_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) .Or. ;
		   (SRA->RA_MAT < cMatDe)  .Or. (SRA->RA_MAT > cMatAte)  .Or. ;
			(SRA->RA_CC < cCcDe)	.Or. (SRA->RA_CC > cCcAte)
			SRA->(dbSkip(1))
			Loop
		EndIf
	
		// Consiste Filiais e Acessos                                             
		If !( SRA->RA_FILIAL $ fValidFil() ) .Or. !Eval( cAcessaSRA )
			SRA->(DbSkip())
			Loop
		EndIf

		// Despreza conforme Situacao e Categoria dos funcionarios     
		If	!( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
	
		// Quebra de Filial											
		If cFilAnterior # SRA->RA_FILIAL
			cFilAnterior := SRA->RA_FILIAL
			If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
				Return
			EndIf
		EndIf
		
		cProcesso	:= SRA->RA_PROCES
		aPerFerias	:= {}
		dDt1 := ""
		
		If	nTipoMed == 1 .Or. nTipoMed == 5
			dbSelectArea( "SRF" )              
			SRF->( dbSetOrder(2) )
			cChaveSRF := SRA->RA_FILIAL + SRA->RA_MAT + FGETCODFOL("0072")
			If SRF->( dbSeek( cChaveSRF ) )
				While !SRF->( Eof() ) .And. ( SRF->RF_FILIAL + SRF->RF_MAT + SRF->RF_PD == cChaveSRF )
					If ( SRF->RF_STATUS == "1" )
						dDt1 := SRF->RF_DATABAS
						Exit
					EndIf
					SRF->( DbSkip() )
				Enddo
			Else
				dDt1 := SRA->RA_ADMISSA
			EndIf
			SRF->( dbSetOrder(1) )
			DbSelectArea("SRA")	
		EndIf
		
	 	dDt3 := If(nTipoMed == 2 .Or. nTipoMed == 5,dDtBase,"")
    	dDt4 := If(nTipoMed == 3 .Or. nTipoMed == 5,dDtBase,"")
	    dDt6 := If(nTipoMed >= 4 ,If(SRA->RA_SEXO == "M", "", dDtBase),"")     
	    
		nSalario := 0
		nSalMes  := 0
		nSalDia  := 0
		nSalHora := 0
		
		fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.,,,,mv_par01)
	
		// Busca os valores de Rescisao e os carrega em aPd			 
		If lMovMensal .And. !Empty(SRA->RA_DEMISSA)
			aPd := {}		// Limpar aPd em caso de rescisao para nao duplicar os valores lancados no SRC que foram levados para rescisao
			fApdResc(dDtBase)
		EndIf
		//Verifica se e' funcionario horista com jornada variavel
		If lTemJorVar
			lJorVar := ( SRA->RA_CATFUNC == "H" .And. SRA->RA_HOJORVA == "1" )
		EndIf
	
		// Monta Media 												 
		dbSelectArea("TRP")
		Zap    
		
		nRazaoDia := Round(nSalMes / nSalDia, 0)
		nRazaoHr  := Round(nSalMes / nSalHora, 0)
		
		fSalIncMed(@aSalFer,@aSal13,@aSalAP,@aSalFol,dDtBase,nSalMes,nRazaoDia,nRazaoHr)
		
		If GPEXMED(dDt1,,dDt3,dDt4,dDtBase,nSalHora,Val_SalMin,aCodfol,lMesAtu,lMovMensal,,dDt6,,lJorVar)
			fImpr_Med(nSalMes,nSalDia,nSalHora,,lImpPgto)
		EndIf
	    
		dbSelectArea( "SRA" )
		dbSkip()
	Enddo

	// Termino do relatorio										
	dbSelectArea( "SRA" )
	Set Filter to 
	dbSetOrder(1)
	
	Set Device To Screen
	
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	EndIf
	
	MS_FLUSH()
	TRP->(dbCloseArea())
	fErase(cArqNtx + OrdBagExt())
	fErase(cArqDbf + GetDBExtension())

Return( Nil )
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ fImpr_Med ³ Autor ³ Equipe RH        	³ Data ³ --/--/-- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao das Medias.    								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	 	 ³ GPER080   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpr_Med(nSalMes,nSalDia,nSalHora,cTipoMov,lImpPgto)
Local aTipoRel := {STR0011,STR0012,STR0013,STR0014, STR0043 }		//"F‚rias Vencidas"###"F‚rias a Vencer"###"13o Sal rio"###"Aviso Pr‚vio"###"Lic.Maternidade"
Local nTipo    := 0
Local cTipo      := "0", cPd := "000"
Local cTitulo    := "",aTipMed,cCnt,cTipoRel
Local cImpressas := ""
Local cPropVerba := ""
Local lAtuDatBse := .F.
Local dDtBasVen  := CToD("")
Local nCnt
Local nIndMes	 := 1
Local dDataAux   := CToD("")

Private A1COLUNA 	:= {}
Private A2COLUNA 	:= {}
Private	LI    		:= 0
Private nMes        := nDia := nHor := 0 
Private nValAtual   := 0
Default cTipoMov	:= " "
Default lImpPgto	 := .T.

	If FunName()== "GPEM030"
		If Type("wCabec1") <> "U"
			dDataAux := DToC(RH_DATAINI)
			wCabec1  := STR0009 + dDataAux
		EndIf
		dDtBasVen := RH_DATABAS
	Else
		dDtBasVen := SRF->RF_DATABAS
	EndIf
	
	nMes := nSalMes
	nDia := nSalDia
	nHor := nSalhora
	
	// Ponto para alterar variaveis do de salario do cabecalho
	If ExistBlock("GP080ALT") //08/06/18 - Rafael França - Ajustar o valor do salario de acordo com o recebido nas ferias. MV_PAR10 == 1 salario recebe RHH_SALMES
		Execblock("GP080ALT",.F.,.F.)
	EndIf    
				
	cColuna := "A1COLUNA"
	dbSelectArea( "TRP" )

	// Tipos de Medias a Imprimir:                                 
	// 1-Ferias Vencidas 1o Periodo                                
	// 2-Ferias a Vencer                                           
	// 3-13o Salario                                               
	// 4-Aviso Previo                                              
	// 5 a 9-Ferias Vencidas Periodos 2o,3o,4o...                  
	// A-Licenca Maternidade                                       
	aTipMed    := { "1","5","6","7","8","9","2","3","4","A" }
	For nCnt := 1 To Len(aTipMed)
		If !dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aTipMed[nCnt] )
			Loop
		ElseIf !(aTipMed[nCnt] $ "3*4*A") // 13o.Salario e Aviso Previo
			cImpressas += aTipMed[nCnt] + "*"
		EndIf
	          
		// Identificacao de existencia de periodo de ferias vencido
		If cTipoRot == "4"
			// 350 = 365 - 15 dias, pois precisa so de 15 dias do ultimo 'mes' p/ ser ferias vencidas
			lTemVenc := dDataDem - SRF->RF_DATABAS > 349
		ElseIf cTipoRot == "3"
			lTemVenc := M->RH_DFERVEN > 0
		Else
			// 350 = 365 - 15 dias, pois precisa so de 15 dias do ultimo 'mes' p/ ser ferias vencidas
			lTemVenc := Stod( MesAno(dDtBase) + Alltrim( Str( f_UltDia(dDtBase) ) ) ) - SRF->RF_DATABAS > 349
		EndIf
		
		// Se for impressao a partir das ferias e nao tiver 1a.parcela  
		// nao imprime o demonstrativo de medias de 13o.salario.        
		If cTipoMov == "F"
			If M->RH_PERC13S == 0 .And. aTipMed[nCnt] == "3"
				Loop
			EndIf
		EndIf
	
		// Se houver mais de um periodo de vencida atualiza a data base
		lAtuDatBse := .F.
		Aeval( aTipMed, { |x| If( x $ cImpressas .And. ( ( x # aTipMed[nCnt] .Or. aTipMed[nCnt] == "2" ) .And. 	lTemVenc ), lAtuDatBse := .T., "" ) } )
		If aTipMed[nCnt] $ "2*5*6*7*8*9" .And. lAtuDatBse .And. (FunName() <> "GPEM030")
			dDtBasVen := fCalcFimAq(dDtBasVen)+1 // Inicio do proximo periodo
		EndIf
	
		If Len(A1COLUNA) # 0
			DESCARREGA()
			cColuna := "A1COLUNA" 
			IMPR(" ","C")
		EndIf 
		
		cTipo := TRP->RP_TIPO
		LI    := 0
		
		While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT+cTipo = TRP->RP_FILIAL+TRP->RP_MAT+TRP->RP_TIPO
	
			//Exibe a media de acordo com a configuracao da verba - Peru
			If cPaisLoc == "PER"
				cPropVerba := PosSRV( TRP->RP_PD, SRA->RA_FILIAL, "RV_REMCOMP" )
		    	If cPropVerba $ "1|2|3"
					nIndMes	:= 2
	 			Else
					nIndMes	:= 1				
	    		EndIf
			EndIf		  
			
			// Inicio da Impressao Das Linhas Detalhes 					
			If LI = 0
		  		nTipo    := If( cTipo=="A",5,If( cTipo>"4",1,Val(cTipo)))
				cTipoRel := aTipoRel[nTipo]+If( nTipo==1, "("+Str(nCnt,1)+")", "" )
				TITULO := STR0015+cTipoRel+ " ***"		//"*** DEMONSTRATIVO DE MEDIA DE HORAS EXTRAS E ADICIONAIS PARA "
				IMPR(" "+REPL("_",130),"C")
				DET := "| " + OemToAnsi(STR0045) + " " + SRA->RA_FILIAL + " - " + FWFilialName(, SRA->RA_FILIAL,1)
				DET := AllTrim(DET)+SPACE(131-Len(AllTrim(DET)))+"|"
				IMPR(DET,"C")
				DET := PADR(STR0016, 19)+Left(SRA->RA_NOME,30)+SPACE(8)+STR0017+SRA->RA_NUMCP+" - "+SRA->RA_SERCP+SPACE(6)+PADR(STR0018, 10) //"| Funcionario....: "###"Cart.Trab.:"###"Registro: "				
				DET += SRA->RA_MAT+SPACE(3)+STR0019				//"Admissao:"
				DET += PADR(DTOC(SRA->RA_ADMISSA),10)
				DET := AllTrim(DET)+SPACE(131-Len(AllTrim(DET)))+"|"
				IMPR(DET,"C")
				DET := "| " + STR0020+Subs(SRA->RA_CC+Space(20),1,20)+" - "+DescCC(SRA->RA_CC,SRA->RA_FILIAL,40)+Space(1)		//"| Centro de Custo: "
				DET += STR0021+SRA->RA_CODFUNC + " - " + DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL,30) //"Funcao....: "
				DET := AllTrim(DET)+SPACE(131-Len(AllTrim(DET)))+"|"				
				IMPR(DET,"C")
				DET := "| "+IF(nTipo<3,STR0022+If(nCnt==1 .and. !Empty(SRF->RF_IVENPEN), ;
				                              PADR(DTOC(SRF->RF_IVENPEN),10),  ;
				                              PADR(DTOC(dDtBasVen),10) )  ,SPACE(20))+SPACE(09)										//"Base Fer:"
				If !(AllTrim(cTipo) $ "A/4/3") .And. Type("aSalFer") <> "U" .And. Len(aSalFer) > 0
					DET += PADR(STR0044, 21) + TRANSFORM(aSalFer[1][1],"@E 999,999,999.99") + STR0024 + SPACE(2) + TRANSFORM(aSalFer[1][2],"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
					DET += SPACE(5) + TRANSFORM(aSalFer[1][3],"@E 999,999,999.99")/*+STR0026+SPACE(5)+"|"*/	//" por hora"
				ElseIf (AllTrim(cTipo) $ "4") .And. Type("aSalAP") <> "U" .And. Len(aSalAP) > 0
					DET += PADR(STR0044, 21)+TRANSFORM(aSalAP[1][1],"@E 999,999,999.99")+STR0024+SPACE(2)+TRANSFORM(aSalAP[1][2],"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
					DET += SPACE(5)+TRANSFORM(aSalAP[1][3],"@E 999,999,999.99")/*+STR0026+SPACE(5)+"|"*/	//" por hora"
				ElseIf (AllTrim(cTipo) $ "3").And. Type("aSal13") <> "U" .And. Len(aSal13) > 0
					DET += PADR(STR0044, 21)+TRANSFORM(aSal13[1][1],"@E 999,999,999.99")+STR0024+SPACE(2)+TRANSFORM(aSal13[1][2],"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
					DET += SPACE(5)+TRANSFORM(aSal13[1][3],"@E 999,999,999.99")/*+STR0026+SPACE(5)+"|"*/	//" por hora"
				ElseIf Type("aSalFol") <> "U" .And. Len(aSalFol) > 0
					DET += PADR(STR0044, 21)+TRANSFORM(aSalFol[1][1],"@E 999,999,999.99")+STR0024+SPACE(2)+TRANSFORM(aSalFol[1][2],"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
					DET += SPACE(5)+TRANSFORM(aSalFol[1][3],"@E 999,999,999.99")/*+STR0026+SPACE(5)+"|"*/	//" por hora"
				Else
					DET += PADR(STR0044, 21)+TRANSFORM(nMes,"@E 999,999,999.99")+STR0024+SPACE(2)+TRANSFORM(nDia,"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
					DET += SPACE(5)+TRANSFORM(nHor,"@E 999,999,999.99")/*+STR0026+SPACE(5)+"|"*/	//" por hora"
				EndIf
				
				DET := AllTrim(DET)+SPACE(131-Len(AllTrim(DET)))+"|"
				IMPR(DET,"C")
				IMPR("|"+REPL("_",130)+"|","C")
			Endif
		
			If TRP->RP_PD # cPd
				If cPd = "998" .Or. cPd = "997" 
					FTrocaColuna()
				EndIf          
				
				nTipo    := If( cTipo=="A",5,If( cTipo>"4",1,Val(cTipo)))
				cTipoRel := aTipoRel[nTipo]+If( nTipo==1, "("+Str(nCnt,1)+")", "" )
				cTitulo  := If(TRP->RP_PD="999",STR0027+cTipoRel,If(TRP->RP_PD="998",STR0028+cTipoRel,;					//"TOTAIS - "###"TOTAL FALTAS - "
						        If(TRP->RP_PD="997",STR0029+cTipoRel,If(TRP->RP_PD="995", STR0046+cTipoRel, TRP->RP_PD+" - "+DescPd(TRP->RP_PD,SRA->RA_FILIAL,20)))))	//"TOTAL ADTO. -  " ### //"TOTAL GRUPO 0. -  "
				DET := SPACE(12)+"*** "+ cTitulo + " ***" + SPACE(42-Len(cTitulo))
				AADD(&(cColuna),DET)
				If TRP->RP_PD = "998"
					DET := SPACE(21)+STR0030+SPACE(37)		//"DIAS"
				ElseIf TRP->RP_PD = "997"
					DET := SPACE(57)+STR0031					//"VALOR"
				Else
					DET := STR0032		//"REF.    DATA PGT     HORAS      VALOR ORIG.        VALOR ATUAL"
				EndIf
				AADD(&(cColuna),DET)
				DET := REPL("_",62)
				AADD(&(cColuna),DET)
				cPd := TRP->RP_PD
			
			EndIf
		
			// | REF.    DATA PGT     HORAS      VALOR ORIG.        VALOR ATUAL |
			// | 99/9999 99/99/9999 9999.99   999.999.999.99   9.999.999.999.99 |
			// | ** TOTAL           9999,99           500,00             500,00 |
			// | ** MEDIA     (12)  9999,99            41,67              41,67 |
			// | ** MEDIA PGTO(12)  9999,99            41,67              41,67 |
			// | * TOT OUTROS       9999,99         2.480,90           2.480,90 |
			// | * MED OUTROS       9999,99           206,75             206,75 |
			// | * OUTROS PGTO      9999,99           206,75             206,75 |
			// | * TOT H.EXT        9999,99             0,00               0,00 |
			// | * MED H.EXT        9999,99             0,00               0,00 |
			// | * H.EXT PGTO       9999,99             0,00               0,00 |
			// | ** TOTAL           9999,99         2.480,90           2.480,90 |
			// | ** MEDIA           9999,99           206,75             206,75 |
			// | ** MEDIA PGTO      9999,99           206,75             206,75 |
			// | NO PERIODO         9999,99                                    
		
			// Rafael - Ajuste de medias no relatorio, substituido o campo TRP->RP_VALATU por nValAtual  

			nValAtual := ROUND((TRP->RP_VALATU / SRA->RA_SALARIO) * nMes,2)	
						
			If TRP->RP_DATARQ = "9798  "
				DET := STR0033
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;		//"* TOT OUTROS"
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9799  "
				DET := STR0034
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD=="999","","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* MED OUTROS  "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "97MD  "
				DET := STR0035
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD == "999","","("+StrZero(TRP->RP_MESMEDIA/nIndMes,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* OUTROS PGTO "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9898  "
				DET := STR0036
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* TOT H.EXT "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9899  "
				DET := STR0037
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD == "999","","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* MED H.EXT   "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "98MD  "
				DET := STR0038
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD == "999","","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* H.EXT PGTO  "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9598  "
				DET := STR0047
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;		//"* TOT GRUPO 0"
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9599  "
				DET := STR0048
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD=="995","","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* MED GRUPO 0  "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "95MD  "
				DET := STR0049
				DET += SPACE(19-Len(DET))+If(TRP->RP_PD == "995","","("+StrZero(TRP->RP_MESMEDIA/nIndMes,2)+") ")+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* GRUPO 0 PGTO "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
				FTrocaColuna()
			ElseIf TRP->RP_DATARQ = "9998  "
				DET := STR0039
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"** TOTAL      "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "9999  "
				DET := STR0040+If(TRP->RP_PD == "999","","("+StrZero(TRP->RP_MESMEDIA,2)+") ")
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"** MEDIA     "
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_DATARQ = "99MD  " 
				DET := STR0041+If(TRP->RP_PD == "999","","("+StrZero(TRP->RP_MESMEDIA/nIndMes,2)+") ")
				DET += SPACE(19-Len(DET))+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(Round(TRP->RP_VALOR,2),"@E 999,999,999.99")+;	//"** MEDIA PGTO"
					SPACE(3)+TRANSFORM(Round(nValAtual,2),"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
				FTrocaColuna()
			ElseIf TRP->RP_PD = "998"
				If TRP->RP_TIPO="3"
					DET := RIGHT(TRP->RP_DATARQ,2)+"/"
					DET += PADR(IF(nTData==8,SubStr(TRP->RP_DATARQ,3,2),Left(TRP->RP_DATARQ,4)),5)
				Else
					DET := STR0042		//"NO PERIODO"
				Endif
				DET += SPACE(10)+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(35) 
				AADD(&(cColuna),DET)
			ElseIf TRP->RP_PD = "997"
				DET := SPACE(46)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			Else
				DET := PADR(RIGHT(TRP->RP_DATARQ,2)+"/"+IF(nTData==8,SubStr(TRP->RP_DATARQ,3,2),Left(TRP->RP_DATARQ,4)),8)
				DET += PADR(DTOC(TRP->RP_DATPGT),10)+SPACE(1)+;
					TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;
					SPACE(3)+TRANSFORM(nValAtual,"@E 9,999,999,999.99")
				AADD(&(cColuna),DET)
			Endif
			dbSelectArea( "TRP" )
			dbSkip()
		EndDo
	Next nCnt

	If Len(A1COLUNA) # 0
		DESCARREGA()
		Li := 0		
	EndIf  
	
Return( Nil )  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ DESCARREGA³ Autor ³ Equipe RH        	³ Data ³ --/--/-- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao dos vetores contendo detalhes da impressao.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso	 	 ³ GPER080   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DESCARREGA
Local x  

	If Len(A1COLUNA) > Len(A2COLUNA)
		cColuna = "A1COLUNA"
		ASIZE(A2COLUNA,Len(A1COLUNA))
	Else
		cColuna = "A2COLUNA"
		ASIZE(A1COLUNA,Len(A2COLUNA))
	EndIf
	
	For x = 1 TO Len(&(cColuna))
		DET = "| "+IF(A1COLUNA[x]=NIL,SPACE(62),A1COLUNA[x])+" || "+IF(A2COLUNA[x]=NIL,SPACE(62),A2COLUNA[x])+" |"
		IMPR(DET,"C")
	Next x

	IMPR("|"+REPL("_",130)+"|","C")
	ASIZE(A1COLUNA,0)
	ASIZE(A2COLUNA,0)

Return(.T.) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ FTrocaColuna ³ Autor ³ Equipe RH        	³ Data ³ --/--/-- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Troca de Coluna.										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso	 	 ³ GPER080   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FTrocaColuna()

	If cColuna = "A2COLUNA"
		DESCARREGA()
		cColuna = "A1COLUNA"
	Else
		cColuna = "A2COLUNA"
	EndIf

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fApdResc | Autor ³ Equipe RH             ³ Data ³ 27/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica se deve incluir as medias do mes atual no         ³±±
±±³          ³ demonstrativo de medias.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GPER080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fApdResc(dDtBase)
Local aArea := GetArea()
	
	dbSelectArea( "SRG" )
	dbSeek( SRA->RA_FILIAL+SRA->RA_MAT )
	While !Eof() .And. SRG->RG_FILIAL+SRG->RG_MAT == SRA->RA_FILIAL+SRA->RA_MAT
		If MesAno(SRG->RG_DTGERAR) == MesAno(dDtBase) .And. SRG->RG_MEDATU == "S"
			dbSelectArea("SRR")
			dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "R" )
			While !Eof() .And. RR_FILIAL + RR_MAT == SRA->RA_FILIAL + SRA->RA_MAT
				If SRR->RR_TIPO3 == "R"
					nPos := Ascan(aPd,{ |X| X[1] = SRR->RR_PD } )
					If nPos = 0
						fMatriz(SRR->RR_PD,SRR->RR_VALOR,SRR->RR_HORAS,"","",SRR->RR_TIPO1,SRR->RR_TIPO2,0,,SRR->RR_DATA)
					Else
						aPd[nPos,5] += SRR->RR_VALOR
					Endif
				EndIf
				dbSkip()
			Enddo
			Exit
		EndIf
		dbSelectArea( "SRG" )
		dbSkip()
	EndDo
	RestArea(aArea)

Return( Nil )

/*/{Protheus.doc}fSalIncMed
Carrega arrays com os salários incorporados para as médias
@author Gabriel de Souza Almeida
@since 08/06/2016
@version P12
/*/
Static Function fSalIncMed(aFER, a13, aAP, aFOL, dDataRef, nSalMes, nRazD, nRazH)
	Local cQuery    := ""
	Local cAliasQry := ""
	Local nSalDia   := 0
	Local nSalHr    := 0
	Local nAux      := 0
	Local aArea     := GetArea()
	Local nAuxMes   := nSalMes
	
	aFER := {}
	a13  := {}
	aAP  := {}
	aFOL := {}
	
	//Férias
	cAliasQry := GetNextAlias()
	cQuery := "SELECT "
	cQuery += "SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_PD, SRR.RR_VALOR, SRR.RR_PERIODO, SRR.RR_ROTEIR, SRR.RR_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRR") + " SRR "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRR.RR_PD "
	cQuery += "WHERE "
	cQuery += "SRR.RR_FILIAL='" + xFilial("SRR", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRR.RR_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRR.RR_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "SRR.RR_ROTEIR = 'FER' AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_REFFER <> 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRR.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	While !((cAliasQry)->(Eof()))
		nAux    := (cAliasQry)->RR_VALOR / Round(SRA->RA_HRSDIA * f_UltDia(dDtBase),2)
		nSalHr  := nSalMes / nRazH
		nSalMes += (cAliasQry)->RR_VALOR
		nSalDia := nSalMes / nRazD
		nSalHr  += nAux
		aAdd( aFER, {nSalMes, nSalDia, nSalHr})
		(cAliasQry)->(DbSkip())
	EndDo
	
	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbCloseArea())
	
	nSalMes := nAuxMes
	
	//Av. Prévio
	cAliasQry := GetNextAlias()
	cQuery := "SELECT "
	cQuery += "SRR.RR_FILIAL, SRR.RR_MAT, SRR.RR_PD, SRR.RR_VALOR, SRR.RR_PERIODO, SRR.RR_ROTEIR, SRR.RR_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRR") + " SRR "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRR.RR_PD "
	cQuery += "WHERE "
	cQuery += "SRR.RR_FILIAL='" + xFilial("SRR", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRR.RR_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRR.RR_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "SRR.RR_ROTEIR = 'RES' AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRR.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	While !((cAliasQry)->(Eof()))
		nAux    := (cAliasQry)->RR_VALOR / Round(SRA->RA_HRSDIA * f_UltDia(dDtBase),2)
		nSalHr  := nSalMes / nRazH
		nSalMes += (cAliasQry)->RR_VALOR
		nSalDia := nSalMes / nRazD
		nSalHr  += nAux
		aAdd( aAP, {nSalMes, nSalDia, nSalHr})
		(cAliasQry)->(DbSkip())
	EndDo
	
	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbCloseArea())
	
	nSalMes := nAuxMes
	
	//13º
	cAliasQry := GetNextAlias()
	
	cQuery := "SELECT "
	cQuery += "SRC.RC_FILIAL, SRC.RC_MAT, SRC.RC_PD, SRC.RC_VALOR, SRC.RC_PERIODO, SRC.RC_ROTEIR, SRC.RC_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRC") + " SRC "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRC.RC_PD "
	cQuery += "WHERE "
	cQuery += "SRC.RC_FILIAL='" + xFilial("SRC", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRC.RC_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRC.RC_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "(SRC.RC_ROTEIR = '131' OR SRC.RC_ROTEIR = '132') AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRC.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	
	cQuery += "UNION "
	
	cQuery := "SELECT "
	cQuery += "SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_VALOR, SRD.RD_PERIODO, SRD.RD_ROTEIR, SRD.RD_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRD") + " SRD "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRD.RD_PD "
	cQuery += "WHERE "
	cQuery += "SRD.RD_FILIAL='" + xFilial("SRD", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRD.RD_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRD.RD_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "(SRD.RD_ROTEIR = '131' OR SRD.RD_ROTEIR = '132') AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRD.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	While !((cAliasQry)->(Eof()))
		nAux    := (cAliasQry)->RD_VALOR / Round(SRA->RA_HRSDIA * f_UltDia(dDtBase),2)
		nSalHr  := nSalMes / nRazH
		nSalMes += (cAliasQry)->RD_VALOR
		nSalDia := nSalMes / nRazD
		nSalHr  += nAux
		aAdd( a13, {nSalMes, nSalDia, nSalHr})
		(cAliasQry)->(DbSkip())
	EndDo
	
	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbCloseArea())
	
	nSalMes := nAuxMes
	
	//Licença Matern.
	cAliasQry := GetNextAlias()
	
	cQuery := "SELECT "
	cQuery += "SRC.RC_FILIAL, SRC.RC_MAT, SRC.RC_PD, SRC.RC_VALOR, SRC.RC_PERIODO, SRC.RC_ROTEIR, SRC.RC_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRC") + " SRC "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRC.RC_PD "
	cQuery += "WHERE "
	cQuery += "SRC.RC_FILIAL='" + xFilial("SRC", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRC.RC_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRC.RC_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "SRC.RC_ROTEIR = 'FOL' AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_REFFER <> 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRC.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	
	cQuery += "UNION "
	
	cQuery := "SELECT "
	cQuery += "SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_PD, SRD.RD_VALOR, SRD.RD_PERIODO, SRD.RD_ROTEIR, SRD.RD_VALORBA "
	cQuery += "FROM "
	cQuery += RetSqlName("SRD") + " SRD "
	cQuery += "INNER JOIN " + RetSqlName("SRV") + " SRV ON SRV.RV_COD = SRD.RD_PD "
	cQuery += "WHERE "
	cQuery += "SRD.RD_FILIAL='" + xFilial("SRD", SRA->RA_FILIAL) + "' AND "
	cQuery += "SRD.RD_MAT='" + AllTrim(SRA->RA_MAT) + "' AND "
	cQuery += "SRD.RD_PERIODO='" + AnoMes(dDataRef) + "' AND "
	cQuery += "SRD.RD_ROTEIR = 'FOL' AND "
	cQuery += "SRV.RV_INCORP = 'S' AND SRV.RV_REFFER <> 'S' AND SRV.RV_CODFOL = '' AND "
	cQuery += "SRD.D_E_L_E_T_=' ' AND "
	cQuery += "SRV.D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	While !((cAliasQry)->(Eof()))
		nAux    := (cAliasQry)->RD_VALOR / Round(SRA->RA_HRSDIA * f_UltDia(dDtBase),2)
		nSalHr  := nSalMes / nRazH
		nSalMes += (cAliasQry)->RD_VALOR
		nSalDia := nSalMes / nRazD
		nSalHr  += nAux
		aAdd( aFOL, {nSalMes, nSalDia, nSalHr})
		(cAliasQry)->(DbSkip())
	EndDo
	
	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbCloseArea())
	
	RestArea(aArea)
Return Nil
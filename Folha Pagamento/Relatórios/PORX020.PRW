#INCLUDE "RWMAKE.CH"
#INCLUDE "EXTRABH.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PORX020  ³ Autor ³ Ana Claudia           ³ Data ³ 16.11.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apuração Mensal de Banco de Horas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PORX020                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PORX020()

Local aOrd		:= { 'Centro de Custo' , 'C.Custo + Nome'}
Local cDesc1    := 'Apuração Mensal de Banco de Horas'
Local cDesc2    := 'Ser  impresso de acordo com os parametros solicitados pelo'
Local cDesc3    := 'usuario.'
Local cString	:= 'SRA' 	//-- Alias do arquivo principal (Base)
Local lEnd		:= .F.

Private aReturn  := { STR0001 , 1, STR0002 , 2, 2, 1, '',1 } //'Zebrado'###'Administra‡„o'
Private nomeprog := 'PORX020'
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := 'PRX020'
Private Titulo   := OemToAnsi( 'Apuração Mensal de Banco de Horas')
Private cCabec	 := "MATRICULA NOME                                     PERIODO A COMPENSAR               TOTAL SALDO  HORAS COMPENSADAS"
Private AT_PRG   := 'PRX020'
Private CONTFL   := 1
Private nLin     := 80
Private nTamanho := 'M'
Private aInfo    := {}
Private wnrel
Private nOrdem
Private Limite	 := 132
Private m_pag := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( cPerg , .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := 'PORX020' //-- Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a Ordem do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem    := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private FilialDe  := mv_par01	//Filial  De
Private FilialAte := mv_par02	//Filial  Ate
Private CcDe      := mv_par03	//Centro de Custo De
Private CcAte     := mv_par04	//Centro de Custo Ate
Private TurDe     := mv_par05	//Turno De
Private TurAte    := mv_par06	//Turno Ate
Private MatDe     := mv_par07	//Matricula De
Private MatAte    := mv_par08	//Matricula Ate
Private NomDe     := mv_par09	//Nome De
Private NomAte    := mv_par10	//Nome Ate
Private cData     := Substr(mv_par11,1,2)+"/"+Substr(mv_par11,3,4)	//Mes de Competencia - MM/AAAA
Private nMesAnt   := mv_par12	//Numero de meses anteriores (default 3)
Private cSit      := mv_par13	//Situacao
Private cCat      := mv_par14	//Categoria
//Private nCopias   := mv_par15	//Numero de Copias

IF !( nLastKey == 27 )
	
	SetDefault( aReturn , cString )
	
	IF !( nLastKey == 27 )
		
		RptStatus( { |lEnd| ImpExtraBh( @lEnd , wNRel , cString ) } , Titulo )
		
	EndIF
	
EndIF

Return()

Static Function ImpExtraBh( lEnd, wNRel, cString )

Local cAcessaSRA	:= &("{ || " + ChkRH("PORX020","SRA","2") + "}")
Local cFil       	:= ''
Local cMat       	:= ''
Local cTno       	:= ''
Local cFilTmp    	:= 'úú'
Local cTnoAnt    	:= 'úúú'
Local lLoop      	:= .F.
Local nCount		:= 0
Local nSaldo		:= 0
Local nSaldoAnt		:= 0
Local aDet			:= {}
Local aDatas		:= {}
Local nI			:= 0

lEnd:=.F.

dbSelectArea('SRA')
dbSetOrder(nOrdem)
If nOrdem == 1
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := 'RA_FILIAL + RA_CC + RA_MAT'
	cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 2
	dbSetOrder(8)
	dbSeek(FilialDe + CcDe + NomDe,.T.)
	cInicio  := 'RA_FILIAL + RA_CC + RA_NOME'
	cFim     := FilialAte + CcAte + NomAte
Endif

//Cabecalho
//MATRICULA NOME                                     PERIODO A COMPENSAR               TOTAL SALDO HORAS COMPENSADAS
//999999    1234567890123456789012345678901234567890 HORAS A COMPENSAR ATE DD/MM/AAAA  99999999.99 _________________
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         1         2         3         4         5         6         7         8         9        11

//-- Inicializa R‚gua de Impress„o
SetRegua(RecCount())

cCC    := ""

dbSelectArea("SRA")
While SRA->( !Eof() .and. &(cInicio) <= cFim )
	
	//-- Incrementa a R‚gua de Impress„o
	IncRegua()
		
	//-- Cancela a Impress„o case se pressione Ctrl + A
	If lEnd
		IMPR(cCancela,'C')
		Exit
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->RA_TNOTRAB < Turde) .Or. (SRA->RA_TNOTRAB > TurAte) .Or. ;
		(SRA->Ra_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
		(SRA->Ra_MAT < MatDe) .Or. (SRA->RA_MAT > MatAte)  .Or. ;
		(SRA->Ra_CC < CCDe) .Or. (SRA->RA_CC > CCAte)
		dbSkip()
		Loop
	Endif
	
	//-- Consiste Situacao e Categoria
	If !(Sra->Ra_SitFolh $ cSit) .Or. ;
		!(Sra->Ra_CatFunc $ cCat)
		DbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		SRA->(dbSkip())
		Loop
	EndIf
		
	If SRA->RA_FILIAL #cFilTmp
		cFilTmp    := SRA->RA_Filial
		cTnoAnt    := 'úúú'
		//-- Atualiza o Array de Informa‡”es sobre a Empresa.
		aInfo := {}
		fInfo(@aInfo, SRA->RA_Filial)
	Endif
	
	Set Device to Printer
	
	//-- Carrega os Totais de Horas e Abonos.
	aDet     :={}
	aDatas   :={}
	
	// Crio as datas equivalentes aos meses anteriores que devem ser listados
	// aDatas[x,1] -> Data Inicial
	// aDatas[x,2] -> Data Final
	// aDatas[x,3] -> Data Competencia para pagamento
	
	dData := cTod("30/"+cData)
	nMeses := 31 * nMesAnt
	For nI := 1 to nMesAnt
		AAdd(aDatas,{cTod("01/"+StrZero(Month(dData-nMeses),2)+"/"+Str(Year(dData-nMeses),4)),;
     				 LastDay(dData-nMeses),;
     				 cTod("30/"+StrZero(Month(dData),2)+"/"+Str(Year(dData),4))})
  		// Retorno data para dia 30, para que proxima subtracao caia novamente no
  		// mes anterior
     	dData := cTod("30/"+StrZero(Month(dData),2)+"/"+Str(Year(dData),4))
     	dData += 30 // subtraio 30 dias para carregar mês anterior
	Next nI
	
	For nI := 1 to Len(aDatas)
		dDtIni := aDatas[nI][1]
		dDtFim := aDatas[nI][2]
		dCompet:= aDatas[nI][3]
		nSaldo   :=0
						
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica lancamentos no Banco de Horas                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SPI" )
		dbSetOrder(2)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SPI->PI_FILIAL+SPI->PI_MAT == SRA->RA_FILIAL+SRA->RA_MAT
			
				//-- Consiste Preenchimento de Cracha e data de Demiss„o
				If !Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEMISSA < dDtIni
					SPI->(DbSkip())
					Loop
				Endif
			
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica os Lancamentos a imprimir                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim .Or. SPI->PI_STATUS == "B"
					SPI->(dbSkip())
					Loop
				Endif
				
				PosSP9( SPI->PI_PD ,SRA->RA_FILIAL )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Acumula os lancamentos de Proventos/Desconto em Array        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If SP9->P9_TIPOCOD $ "1*3"
					nSaldo:=SomaHoras(nSaldo,SPI->PI_QUANT)
				Else
					nSaldo:=SubHoras (nSaldo,SPI->PI_QUANT)
				Endif
				
				SPI->( dbSkip() )
			Enddo
			AAdd(aDet,{dCompet,nSaldo})
		EndIf
	Next nI
	If Len(aDet) > 0
	
		If nLin > 57
			nLin := Cabec(Titulo+" Compentência: "+cData,cCabec,"",NomeProg,nTamanho,1)
		Endif
	
		If cCC != SRA->RA_CC
			If ! Empty(cCC)
				nLin := 60
				@ nLin,075 pSay Replicate("_",39)
				@ nLin,075 pSay "       Assinatura do Responsavel"
				nLin := Cabec(Titulo+" Compentência: "+cData,cCabec,"",NomeProg,nTamanho,1)
			EndIf	
			@ ++nLin,000 pSay Trim(SRA->RA_CC) + " - " +;
				Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
			nLin+=2
			cCC := SRA->RA_CC
		EndIf

		@ nLin,000 PSay SRA->RA_MAT
		@ nLin,010 pSay Substr(SRA->RA_NOME,1,40)
		For nI := 1 To Len(aDet)
			@ nLin,051 pSay "HORAS A COMPENSAR ATÉ "+dToC(aDet[nI][1])
			@ nLin,085 pSay aDet[nI][2] Picture "99999999.99"
			@ nLin,098 pSay Replicate("_",17)
			nLin +=2
		Next nI
		nLin ++
		
	EndIf	
	
	dbSelectArea("SRA")
	dbSkip()
Enddo

@ ++nLin,045 pSay "_______________________________________"
@ ++nLin,045 pSay "       Assinatura do Responsavel"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SPI')
dbSetOrder(1)

dbSelectArea('SRA')
dbSetOrder(1)
Set Filter To
Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return( )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imprime   ºAutor  ³Ana Claudia         º Data ³  17/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao de dados referentes aos funcionários que estiveremº±±
±±º          ³dentro dos parâmetros informados                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PORX020                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Imprime(aDet)

Return( )
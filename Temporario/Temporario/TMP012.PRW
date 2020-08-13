#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

#DEFINE STR0001 'TMP012'
#DEFINE STR0002 'Esse relatorio encontra-se em validacao. A criacao deste relatorio visa o detalhamento dos valores impressos no relatorio espelho de ponto.'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  10/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TMP012


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Detalhamento Horas de Debito e Credito"
Local cPict          := ""
Local titulo         := "Detalhamento Horas de Debito e Credito"
Local nLin           := 80

Local Cabec1         := " Data    Dt Baixa   Evento                                     Debito          Saldo                            Credito          Saldo"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "TMP012    "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SPI"

dbSelectArea("SPI")
dbSetOrder(1)

MsgInfo(STR0002,STR0001)

If !Pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem 

Local cMatricula := MV_PAR01  //Matricula parametrizada
Local dInicio    := MV_PAR02  //Data Inicial parametrizada
Local dFim		 := MV_PAR03  //Data Final parametrizada
Local nHoras     := MV_PAR04  //1-Normais /2-Valorizadas
Local nEvento    := MV_PAR05  //Autoriz/N.Autoriz/Ambos
Local nLayOut	 := MV_PAR06

Local dIniBanco  := CtoD("21/"+Right(DtoC(dFim-95),5))  //Data início do periodo de 90 dias do banco de horas
Local dBxBcHProx := DataValida(dFim+20)                 //Baixa do banco de horas no mes seguinte
Local cTipoMov   := ''
Local n1         := 0
Local n2         := 0
Local n3         := 0
Local n4         := 0
Local n5         := 0
Local n6         := 0
Local n7         := 0
Local n8         := 0
Local n9         := 0
Local n10        := 0
Local n11        := 0
Local n12        := 0
Local n13        := 0
Local n14        := 0
Local n15        := 0
Local n16        := 0
Local n17        := 0
Local n18        := 0
Local n1T        := 0
Local n2T        := 0    
Local n3T        := 0
Local n4T        := 0    
Local n5T        := 0
Local n6T        := 0    
Local n7T        := 0    
Local n8T        := 0    
Local lARQ1      := .T.
Local lARQ2      := .T.
Local lARQ3      := .T.
Local lARQ4      := .T.
Local lFunc		 := .T.

//////////////////////////////////////////////
//  Monta arquivo temporario para impressao //
//////////////////////////////////////////////
Do Case

	//Layout Antigo
	Case nLayout == 1
		
		/////////////////////
		// ARQ1 - SPI_ANT  //
		/////////////////////
		
		//Cria consulta a ser executada 
		cQry := " SELECT *                                    " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI                            " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''                   " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	   = !PI_FILIAL!          " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		   = !PI_MAT!             " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA  	   >= !PI_DATA1!          " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA	   < !PI_DATA2!           " + CHR(13) + CHR(10)
		cQry += "    AND (PI_DTBAIX	   = !PI_DTBAIX1!         " + CHR(13) + CHR(10)
		cQry += "    OR PI_DTBAIX	   > !PI_DTBAIX2!)        " + CHR(13) + CHR(10)
		cQry += " ORDER BY PI_DATA
		
		//Inclui informacoes variaveis
		cQry := StrTran(cQry, "!SPI!"	     , RetSqlName("SPI")        )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI")))
		cQry := StrTran(cQry, "!PI_MAT!" 	 , ValToSql( cMatricula )   )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( dIniBanco )    )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dInicio   )    )
		cQry := StrTran(cQry, "!PI_DTBAIX1!", ValToSql( Ctod(""))      )
		cQry := StrTran(cQry, "!PI_DTBAIX2!", ValToSql( dFim)          )
		
		//Gera Log
		MemoWrit("ARQ1.APQ",cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ1") > 0
			ARQ1->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ1",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ1")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ1",x[1],x[2],x[3],x[4]),)})
		
		////////////////////////////
		// ARQ2 - HORA EXTRA MES  //
		////////////////////////////
		
		//Cria consulta a ser executada 
		cQry := " SELECT *                                                  " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI                                          " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_ = ''                                    " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	= !PI_FILIAL!                           " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		= !PI_MAT!                              " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA    BETWEEN !PI_DATA1! AND !PI_DATA2!       " + CHR(13) + CHR(10)
		
		//Inclui informacoes variaveis
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI") )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI") ) )
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql( cMatricula ) )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( dInicio ) )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dFim ) )
		
		//Gera Log
		MemoWrit("ARQ2.APQ",cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ2") > 0
			ARQ2->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ2",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ2")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ2",x[1],x[2],x[3],x[4]),)})
		
		////////////////////
		// ARQ3 - SPI_BX  //
		////////////////////
		
		//Cria consulta a ser executada 
		cQry := " SELECT *                                                      " + CHR(13) + CHR(10)
		cQry += " FROM !SPI! SPI                                                " + CHR(13) + CHR(10)
		cQry += " WHERE  D_E_L_E_T_ = ''                                        " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	= !PI_FILIAL!                               " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT     = !PI_MAT!                                  " + CHR(13) + CHR(10)
		cQry += "    AND PI_STATUS  = !PI_STATUS!                               " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA    BETWEEN !PI_DATA1!   AND !PI_DATA2!         " + CHR(13) + CHR(10)
		cQry += "    AND PI_DTBAIX	BETWEEN !PI_DTBAIX1! AND !PI_DTBAIX2!       " + CHR(13) + CHR(10)
		cQry += " ORDER BY SPI.PI_DATA                                          " + CHR(13) + CHR(10)
		
		//Inclui informacoes variaveis
		cQry := StrTran(cQry, "!SPI!"		 , RetSqlName("SPI")       )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql(xFilial("SPI")))
		cQry := StrTran(cQry, "!PI_MAT!" 	 , ValToSql(cMatricula)    )
		cQry := StrTran(cQry, "!PI_STATUS!" , ValToSql("B")           )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql(dIniBanco)     )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql(dFim)          )
		cQry := StrTran(cQry, "!PI_DTBAIX1!", ValToSql(dFim)          )
		cQry := StrTran(cQry, "!PI_DTBAIX2!", ValToSql(dBxBcHProx)    )
		
		//Gera Log
		MemoWrit("TMP012.TXT",cQry)
		
		//Ajusta Query
		//cQry := ChangeQuery(cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ3") > 0
			ARQ3->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ3",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ3")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ3",x[1],x[2],x[3],x[4]),)})
		
		////////////////////////////////////////////////////////////
		//  Controla a quantidade de registros a serem impressos  //
		////////////////////////////////////////////////////////////
		DbSelectArea("ARQ1")
		SetRegua(RecCount())
		

		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho
		Cabec1         := " Data    Dt Baixa   Evento                                Positivas       Saldo                            Negativas        Saldo"
		Cabec2         := ""
		
		ARQ1->(DbGoTop())
		While !ARQ1->(EOF())
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
			Endif
		    
			//Dados do funcionario
			If lFunc
				@nLin,000 PSAY "MATRICULA: " + ARQ1->PI_MAT + "          NOME: " + Posicione("SRA",1,xFilial("SRA")+ARQ1->PI_MAT,"RA_NOME") 
			    nLin  := nLin + 1 // Avanca a linha de impressao			

				@nLin,000 PSAY "DATA INICIAL: " + DTOC(dInicio) + "     DATA FINAL: " + DTOC(dFim)
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			

				lFunc := .F.
			Endif
			//Linha de observacao inicial
			If lARQ1
			    @nLin,000 PSAY "Detalhamento das Horas que compoes o saldo anterior"
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    
			    //Controle de execucao
			    lARQ1 := .F.
			Endif
		
			// @nLin,00 PSAY 'EXEMPLO'
		
			//Carrega tipo de evento
		    cTipoMov := PosSP9( ARQ1->PI_PD,xFilial("SPI"),"P9_TIPOCOD" )
			n1  := 0
			n2  := 0
			
			//Verifica tipo de movimento
			If cTipoMov == "1"
			
				n1 := If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV )
				
			ElseIf cTipoMov == "2"
				
				n2 := If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV )
			Endif
			
			//Controla saldo do relatorio
			n1T := SomaHoras( n1T,n1 )  //Positivas
			n2T := SomaHoras( n2T,n2 )  //Negativas
		    
		    @nLin,000 PSAY DTOC(ARQ1->PI_DATA)	
		    @nLin,010 PSAY DTOC(ARQ1->PI_DTBAIX)	
		    @nLin,022 PSAY ARQ1->PI_PD + " - " + Posicione("SP9",1,xFilial("SP9")+ARQ1->PI_PD,"P9_DESC")
		    @nLin,050 PSAY If(n1>0,Padl(Transform(n1 ,"@E 999,999,999.99"),14),Space(14))
		    @nLin,065 PSAY Padl(Transform(n1T ,"@E 999,999,999.99"),14)
		    @nLin,100 PSAY If(n2>0,Padl(Transform(n2,"@E 999,999,999.99"),14),Space(14))
		    @nLin,115 PSAY Padl(Transform(n2T ,"@E 999,999,999.99"),14)
			nLin := nLin + 1 // Avanca a linha de impressao
		
			ARQ1->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo
		
		nLin := nLin + 1 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		
		//Impressao dos saldos finais
		@nLin,065 PSAY Padl(Transform(n1T,"@E 999,999,999.99"),14)
		@nLin,115 PSAY Padl(Transform(n2T,"@E 999,999,999.99"),14)
		
		nLin := nLin + 2 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		
		//Saldo Anterior
		n7 := SubHoras(n1T,n2T)
				
		nLin := nLin + 1 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		
		@nLin,005 PSAY "Saldo anterior:" + Padl(Transform(n7,"@E 999,999,999.99"),14)

		///////////////////////////////////////////////////////////////////////
		//  Imprime detalhamento das Horas que compoes a coluna H.E. no MES  //
		///////////////////////////////////////////////////////////////////////
		
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho
		Cabec1         := " Data    Dt Baixa   Evento                                Hr Extra        Saldo                            Faltas           Saldo"
		Cabec2         := ""
		
		ARQ2->(DbGoTop())
		While !ARQ2->(EOF())
		    
			// Avalia tipo de horas
			If nEvento <> 3
				If !fBscEven(ARQ2->PI_PD,2,nEvento)
					ARQ2->(dbSkip())
					Loop
				EndIf
			Endif
			
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
			Endif
		    
			//Linha de observacao inicial
			If lARQ2
			    @nLin,000 PSAY "Detalhamento das Horas que compoes a coluna H.E. no MES"
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    
			    //Controle de execucao
			    lARQ2 := .F.
			Endif
		
			// @nLin,00 PSAY 'EXEMPLO'
		
			//Carrega tipo de evento
		    cTipoMov := PosSP9( ARQ2->PI_PD,xFilial("SPI"),"P9_TIPOCOD" )
			n5       := 0
			n6       := 0
			
			//Verifica tipo de movimento
			If cTipoMov == "1"
			
				n5 := If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV )
				
			ElseIf cTipoMov == "2"
				
				n6 := If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV )
			Endif
			
			//Controla saldo do relatorio
			n5T := SomaHoras( n5T,n5 )  //Positivas
			n6T := SomaHoras( n6T,n6 )  //Negativas
		    
		    @nLin,000 PSAY DTOC(ARQ2->PI_DATA)	
		    @nLin,010 PSAY DTOC(ARQ2->PI_DTBAIX)	
		    @nLin,022 PSAY ARQ2->PI_PD + " - " + Posicione("SP9",1,xFilial("SP9")+ARQ2->PI_PD,"P9_DESC")
		    @nLin,050 PSAY If(n5>0,Padl(Transform(n5 ,"@E 999,999,999.99"),14),Space(14))
		    @nLin,065 PSAY Padl(Transform(n5T ,"@E 999,999,999.99"),14)
		    @nLin,100 PSAY If(n6>0,Padl(Transform(n6,"@E 999,999,999.99"),14),Space(14))
		    @nLin,115 PSAY Padl(Transform(n6T ,"@E 999,999,999.99"),14)
			nLin := nLin + 1 // Avanca a linha de impressao
		
			ARQ2->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo
		
		nLin := nLin + 1 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		
		//Impressao dos saldos finais
		@nLin,045 PSAY "H.E. EXTRAS NO MES"
		@nLin,065 PSAY Padl(Transform(n5T,"@E 999,999,999.99"),14)
		@nLin,095 PSAY "FALTAS NO MES"
		@nLin,115 PSAY Padl(Transform(n6T,"@E 999,999,999.99"),14)
		
		////////////////////////////////////////////////////////////////////////////////////////
		//  Imprime detalhamento das Horas que compoes as colunas Hs Baixadas Credito/Debito  //
		////////////////////////////////////////////////////////////////////////////////////////
		
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho
		Cabec1         := " Data    Dt Baixa   Evento                                Debito          Saldo                            Credito          Saldo"
		Cabec2         := ""
		
		ARQ3->(DbGoTop())
		While !ARQ3->(EOF())
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
			Endif
		
			//Linha de observacao inicial
			If lARQ3
			    @nLin,000 PSAY "Detalhamento das Horas que compoes as colunas Hs Baixadas Credito/Debito"
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    
			    //Controle de execucao
			    lARQ3 := .F.
			Endif
		
			// @nLin,00 PSAY 'EXEMPLO'
		
			//Carrega tipo de evento
		    cTipoMov := PosSP9( ARQ3->PI_PD,xFilial("SPI"),"P9_TIPOCOD" )
			n3 := 0  //DEBITO
			n4 := 0  //CREDITO
			
			//Verifica tipo de movimento
			If cTipoMov == "1"
			
				n4 := If( nHoras==1, ARQ3->PI_QUANT, ARQ3->PI_QUANTV ) //CREDITO
				
			ElseIf cTipoMov == "2"
				
				n3 := If( nHoras==1, ARQ3->PI_QUANT, ARQ3->PI_QUANTV ) //DEBITO
			Endif
			
			//Controla saldo do relatorio
			n3T := SomaHoras( n3T,n3 )
			n4T := SomaHoras( n4T,n4 )
		    
		    @nLin,000 PSAY DTOC(ARQ3->PI_DATA)	
		    @nLin,010 PSAY DTOC(ARQ3->PI_DTBAIX)	
		    @nLin,022 PSAY ARQ3->PI_PD + " - " + Posicione("SP9",1,xFilial("SP9")+ARQ3->PI_PD,"P9_DESC")
		    @nLin,050 PSAY If(n3>0,Padl(Transform(n3 ,"@E 999,999,999.99"),14),Space(14))
		    @nLin,065 PSAY Padl(Transform(n3T ,"@E 999,999,999.99"),14)
		    @nLin,100 PSAY If(n4>0,Padl(Transform(n4,"@E 999,999,999.99"),14),Space(14))
		    @nLin,115 PSAY Padl(Transform(n4T ,"@E 999,999,999.99"),14)
			nLin := nLin + 1 // Avanca a linha de impressao
		
			ARQ3->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		//Impressao dos saldos finais
		@nLin,045 PSAY "HS BAIXADAS DEB"
		@nLin,065 PSAY Padl(Transform(n3T ,"@E 999,999,999.99"),14)
		@nLin,095 PSAY "HS BAIXADAS CRED"
		@nLin,115 PSAY Padl(Transform(n4T ,"@E 999,999,999.99"),14)
		
		///////////////////////////////////
		//  Imprime resumo do relatorio  //
		///////////////////////////////////
		
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho
		Cabec1         := ""
		Cabec2         := ""
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
		
		/*
		     Descricao             |              Valor
		    -----------------------|-------------------- 
		     Saldo anterior        |
		     H.E. extras no mes    |
		     Faltas no mes         |
		     Hs baixadas deb.      |
		     Hs baixadas cred.     |  
		     
		((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred)) "
		
		
		(Faltas no mes - Hs baixadas deb.)
		n8 := SubHoras(n6T,n3T)
		
		((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))
		n9 := SubHoras(n7,n8)
		
		(H.E. no mes - Hs Baixadas cred)
		n10 := SubHoras(n5T,n4T) 
		
		((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred))
		n11 := SomaHoras(n9,n10)      
		*/
		
		//Calcula valores
		//(Faltas no mes - Hs baixadas deb.)
		n8 := SubHoras(n6T,n3T)
		
		//((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))
		n9 := SubHoras(n7,n8)
		
		//(H.E. no mes - Hs Baixadas cred)
		n10 := SubHoras(n5T,n4T) 
		
		//((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred))
		n11 := SomaHoras(n9,n10)      
		
		@nLin,000 PSAY "Resumo de horas"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "_________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		//Impressao
		@nLin,000 PSAY "     Descricao             |         Valor"
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    -----------------------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Saldo anterior        |" + Padl(Transform(n7,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     H.E. extras no mes    |" + Padl(Transform(n5T,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Faltas no mes         |" + Padl(Transform(n6T,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Hs baixadas deb.      |" + Padl(Transform(n3T ,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "     Hs baixadas cred.     |" + Padl(Transform(n4T ,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Saldo Atual           |" + Padl(Transform(n11 ,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Detalhamento do calculo de saldo atual"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "________________________________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     ((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred)) "
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Etapa 1 -> (Faltas no mes - Hs baixadas deb.)"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Etapa 2 -> (Saldo Anterior - (Faltas no mes - Hs baixadas deb.)"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Etapa 3 -> (H.E. no mes - Hs Baixadas cred)"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Etapa 4 -> ((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred))"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Saldo atual = Etapa 1 - Etapa 2 + Etapa 3"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Calculo de saldo atual"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "________________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "     Etapa 1"
		@nLin,060 PSAY "     Etapa 2"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "     (Faltas no mes - Hs baixadas deb.)"
		@nLin,060 PSAY "     ((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Descricao             | Opercao|         Valor "      
		@nLin,060 PSAY "     Descricao             | Opercao|         Valor "
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    -----------------------|--------|--------------- "
		@nLin,060 PSAY "    -----------------------|--------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Faltas no mes         |" + Padl("  |",9) + Padl(Transform(n6T,"@E 999,999,999.99"),14)  
		@nLin,060 PSAY "     Saldo Anterior        |" + Padl("  |",9) + Padl(Transform(n7 ,"@E 999,999,999.99"),14)   
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Hs baixadas deb.      |" + Padl("- |",9) + Padl(Transform(n3T ,"@E 999,999,999.99"),14)
		@nLin,060 PSAY "     (Faltas - Hs bx deb.) |" + Padl("- |",9) + Padl(Transform(n8  ,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "                           |" + Padl("= |",9) + Padl(Transform(n8 ,"@E 999,999,999.99"),14)
		@nLin,060 PSAY "                           |" + Padl("= |",9) + Padl(Transform(n9 ,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		//(H.E. no mes - Hs Baixadas cred)
		// ((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred)) 
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "     Etapa 3"
		@nLin,060 PSAY "     Etapa 4"
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "     (H.E. no mes - Hs Baixadas cred)"
		@nLin,060 PSAY "     ((Saldo Anterior - (Faltas no mes - Hs baixadas deb.))+(H.E. no mes - Hs Baixadas cred))"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Descricao             | Opercao|         Valor "
		@nLin,060 PSAY "     Descricao             | Opercao|         Valor "
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    -----------------------|--------|--------------- "
		@nLin,060 PSAY "    -----------------------|--------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     H.E. no mes           |" + Padl("  |",9) + Padl(Transform(n5T,"@E 999,999,999.99"),14)   
		@nLin,060 PSAY "     (S Ant-(Fal-Hs bx d)) |" + Padl("  |",9) + Padl(Transform(n9 ,"@E 999,999,999.99"),14)   
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Hs Baixadas cred      |" + Padl("- |",9) + Padl(Transform(n4T,"@E 999,999,999.99"),14)
		@nLin,060 PSAY "     (HE mes - Hs Bx cred) |" + Padl("+ |",9) + Padl(Transform(n10,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "                           |" + Padl("= |",9) + Padl(Transform(n10,"@E 999,999,999.99"),14)
		@nLin,060 PSAY "               SALDO ATUAL |" + Padl("= |",9) + Padl(Transform(n11,"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao 
	    
	//Layout novo
	Case nLayout == 2  
				
		//Data de baixa do mes atual
		//Cria consulta a ser executada 
		cQry := " SELECT DISTINCT PI_DTBAIX                                 " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI                                          " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_ = ''                                    " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	= !PI_FILIAL!                           " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		= !PI_MAT!                              " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA    BETWEEN !PI_DATA1! AND !PI_DATA2!       " + CHR(13) + CHR(10)
		cQry += "    AND PI_STATUS  = 'B'                                   " + CHR(13) + CHR(10)
		
		//Inclui informacoes variaveis
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI") )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI") ) )
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql( cMatricula ) )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( dInicio ) )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dFim ) )
		
		//Gera Log
		MemoWrit("ARQ5.APQ",cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ5") > 0
			ARQ5->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ5",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ5")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ5",x[1],x[2],x[3],x[4]),)})
		
		cQry := " SELECT * 														" + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI 												" + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_	   = ''          					  	 	" + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	   = !PI_FILIAL!  							" + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		   = !PI_MAT!     							" + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA	   < !PI_DATA2!						   	    " + CHR(13) + CHR(10) 

		cQry := StrTran(cQry, "!SPI!"	     , RetSqlName("SPI")        )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI")))
		cQry := StrTran(cQry, "!PI_MAT!" 	 , ValToSql( cMatricula )   )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dInicio-1 )    )

		//Gera Log
		MemoWrit("ARQ1.APQ",cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ1") > 0
			ARQ1->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ1",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ1")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ1",x[1],x[2],x[3],x[4]),)})
		
		////////////////////////////
		// ARQ2 - HORA EXTRA MES  //
		////////////////////////////
		
		//Cria consulta a ser executada 
		cQry := " SELECT *                                                  " + CHR(13) + CHR(10)
		cQry += "   FROM !SPI! SPI                                          " + CHR(13) + CHR(10)
		cQry += "  WHERE D_E_L_E_T_ = ''                                    " + CHR(13) + CHR(10)
		cQry += "    AND PI_FILIAL 	= !PI_FILIAL!                           " + CHR(13) + CHR(10)
		cQry += "    AND PI_MAT		= !PI_MAT!                              " + CHR(13) + CHR(10)
		cQry += "    AND PI_DATA    BETWEEN !PI_DATA1! AND !PI_DATA2!       " + CHR(13) + CHR(10)
		
		//Inclui informacoes variaveis
		cQry := StrTran(cQry, "!SPI!"			, RetSqlName("SPI") )
		cQry := StrTran(cQry, "!PI_FILIAL!" , ValToSql( xFilial("SPI") ) )
		cQry := StrTran(cQry, "!PI_MAT!" 	, ValToSql( cMatricula ) )
		cQry := StrTran(cQry, "!PI_DATA1!"  , ValToSql( dInicio ) )
		cQry := StrTran(cQry, "!PI_DATA2!"  , ValToSql( dFim ) )
		
		//Gera Log
		MemoWrit("ARQ2.APQ",cQry)
		
		//Verifica se arquivo de trabalho ja existe
		IF Select("ARQ2") > 0
			ARQ2->(dbCloseArea())
		ENDIF
		
		//Monta arquivo temporario
		DbUseArea(.T.,"TOPCONN",tcgenqry(,,ChangeQuery(cQry)),"ARQ2",.F.,.F.)
		
		//Ajusta campo do arquivo temporario
		DbSelectArea("ARQ2")
		aEval(SPI->(dbstruct()),{|x|Iif(x[2]<> "C",tcsetfield("ARQ2",x[1],x[2],x[3],x[4]),)})
					
		////////////////////////////////////////////////////////////
		//  Controla a quantidade de registros a serem impressos  //
		////////////////////////////////////////////////////////////
		DbSelectArea("ARQ1")
		SetRegua(RecCount())
	
	
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho                                                                                                                                     
		Cabec1         := " Data    Dt Baixa   Evento                                Positivas       Saldo           Negativas        Saldo           Positivas       Saldo           Negativas        Saldo"
		Cabec2         := "                                                                                                                           Baixadas                        Baixadas              "
		
		ARQ1->(DbGoTop())
		While !ARQ1->(EOF())
		   
			//Registro do saldo anterior que não estão totalmente zerados
		    If !ARQ1->PI_STATUS == '' .AND. !ARQ1->PI_DTBAIX == STOD('') .AND. !ARQ1->PI_DTBAIX == ARQ5->PI_DTBAIX
		    	ARQ1->(DbSkip())
		    	Loop
		    Endif 
		    
   		    //Horas com erro de data (data em branco mesmo com status de baixada)
		    If ARQ1->PI_STATUS == 'B'.AND. ARQ1->PI_DTBAIX == STOD('')  		   
		    	ARQ1->(DbSkip())
		    	Loop
		    Endif  

	
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
			Endif
		    
		    //Dados do funcionario
			If lFunc
				@nLin,000 PSAY "MATRICULA: " + ARQ1->PI_MAT + "          NOME: " + Posicione("SRA",1,xFilial("SRA")+ARQ1->PI_MAT,"RA_NOME") 
			    nLin  := nLin + 1 // Avanca a linha de impressao			

				@nLin,000 PSAY "DATA INICIAL: " + DTOC(dInicio) + "     DATA FINAL: " + DTOC(dFim)
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			

				lFunc := .F.
			Endif
			
			//Linha de observacao inicial
			If lARQ1
			    @nLin,000 PSAY "Detalhamento das Horas que compoes o saldo anterior"
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    
			    //Controle de execucao
			    lARQ1 := .F.
			Endif
		
			// @nLin,00 PSAY 'EXEMPLO'
		
			//Carrega tipo de evento
		    cTipoMov := PosSP9( ARQ1->PI_PD,xFilial("SPI"),"P9_TIPOCOD" )
			n1  := 0
			n2  := 0
			n3  := 0
			n4  := 0

			//Verifica tipo de movimento
			If cTipoMov == "1"
			
				n1 := If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV )
				
			ElseIf cTipoMov == "2"
				
				n2 := If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV )
			Endif
			
			If ARQ1->PI_STATUS == "B"

				//Verifica tipo de movimento
				If cTipoMov == "1"
				
					n3 := SomaHoras(n3,If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV ))
					
				ElseIf cTipoMov == "2"
					
					n4 := SubHoras(n4,If( nHoras==1, ARQ1->PI_QUANT, ARQ1->PI_QUANTV ))
				Endif

			Endif 

			//Controla saldo do relatorio
			n1T := SomaHoras( n1T,n1 )  //Positivas
			n2T := SomaHoras( n2T,n2 )  //Negativas
			n3T := SomaHoras( n3T,n3 )  //Positivas baixadas
			n4T := SomaHoras( n4T,n4 )  //Negativas baixadas
		    
		    @nLin,000 PSAY DTOC(ARQ1->PI_DATA)	
		    @nLin,010 PSAY DTOC(ARQ1->PI_DTBAIX)	
		    @nLin,022 PSAY ARQ1->PI_PD + " - " + Posicione("SP9",1,xFilial("SP9")+ARQ1->PI_PD,"P9_DESC")
		    @nLin,050 PSAY If(n1>0,Padl(Transform(n1 ,"@E 999,999,999.99"),14),Space(14))
		    @nLin,065 PSAY Padl(Transform(n1T ,"@E 999,999,999.99"),14)
		    @nLin,085 PSAY If(n2>0,Padl(Transform(n2,"@E 999,999,999.99"),14),Space(14))
		    @nLin,100 PSAY Padl(Transform(n2T ,"@E 999,999,999.99"),14)
		    If ARQ1->PI_STATUS == "B"
		    	@nLin,120 PSAY If(n3>0,Padl(Transform(n3 ,"@E 999,999,999.99"),14),Space(14))
   			    @nLin,135 PSAY Padl(Transform(n3T ,"@E 999,999,999.99"),14)
   			    @nLin,150 PSAY If(n4>0,Padl(Transform(n4,"@E 999,999,999.99"),14),Space(14))
   			    @nLin,165 PSAY Padl(Transform(n4T ,"@E 999,999,999.99"),14)
   			Endif
		    
			nLin := nLin + 1 // Avanca a linha de impressao
		
			ARQ1->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo
		
		nLin := nLin + 2 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 10
		Endif
		
		//Impressao dos saldos finais
		@nLin,065 PSAY Padl(Transform(n1T,"@E 999,999,999.99"),14)
		@nLin,100 PSAY Padl(Transform(n2T,"@E 999,999,999.99"),14)
		@nLin,135 PSAY Padl(Transform(n3T,"@E 999,999,999.99"),14)
		@nLin,165 PSAY Padl(Transform(n4T,"@E 999,999,999.99"),14)

		//Saldo Anterior
		n1S := SubHoras(n1T,n2T)
		n2S := SubHoras(n3T,n4T)
				
		///////////////////////////////////////////////////////////////////////
		//  Imprime detalhamento das Horas que compoes a coluna H.E. no MES  //
		///////////////////////////////////////////////////////////////////////
		
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho                                                                   
		Cabec1         := " Data    Dt Baixa   Evento                             Horas Extras       Saldo       Folgas/Faltas        Saldo        Horas Extras       Saldo       Folgas/Faltas        Saldo"
		Cabec2         := "                                                                                                                           Baixadas                        Baixadas              "
		
		ARQ2->(DbGoTop())
		While !ARQ2->(EOF())
		    
			// Avalia tipo de horas
			If nEvento <> 3
				If !fBscEven(ARQ2->PI_PD,2,nEvento)
					ARQ2->(dbSkip())
					Loop
				EndIf
			Endif
			
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Verifica o cancelamento pelo usuario...                             ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		   If lAbortPrint
		      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		      Exit
		   Endif
		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Impressao do cabecalho do relatorio. . .                            ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
			Endif
		    
			//Linha de observacao inicial
			If lARQ2
			    @nLin,000 PSAY "Detalhamento das Horas que compoes a coluna H.E. no MES"
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    nLin  := nLin + 1 // Avanca a linha de impressao			
			    
			    //Controle de execucao
			    lARQ2 := .F.
			Endif
		
			// @nLin,00 PSAY 'EXEMPLO'
		
			//Carrega tipo de evento
		    cTipoMov := PosSP9( ARQ2->PI_PD,xFilial("SPI"),"P9_TIPOCOD" )
			n5       := 0
			n6       := 0
			n7       := 0
			n8       := 0
			
			//Verifica tipo de movimento
			If cTipoMov == "1"
			
				n5 := If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV )
				
			ElseIf cTipoMov == "2"
				
				n6 := If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV )
			Endif
			
			If ARQ2->PI_STATUS == "B"

				//Verifica tipo de movimento
				If cTipoMov == "1"
				
					n7 := SomaHoras(n7,If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV ))
					
				ElseIf cTipoMov == "2"
					
					n8 := SomaHoras(n8,If( nHoras==1, ARQ2->PI_QUANT, ARQ2->PI_QUANTV ))
				Endif

			Endif 

			
			//Controla saldo do relatorio
			n5T := SomaHoras( n5T,n5 )  //Positivas
			n6T := SomaHoras( n6T,n6 )  //Negativas
			n7T := SomaHoras( n7T,n7 )  //Positivas baixadas
			n8T := SomaHoras( n8T,n8 )  //Negativas baixadas
				    
		    @nLin,000 PSAY DTOC(ARQ2->PI_DATA)	
		    @nLin,010 PSAY DTOC(ARQ2->PI_DTBAIX)	
		    @nLin,022 PSAY ARQ2->PI_PD + " - " + Posicione("SP9",1,xFilial("SP9")+ARQ2->PI_PD,"P9_DESC")
		    @nLin,050 PSAY If(n5>0,Padl(Transform(n5 ,"@E 999,999,999.99"),14),Space(14))
		    @nLin,065 PSAY Padl(Transform(n5T ,"@E 999,999,999.99"),14)
		    @nLin,085 PSAY If(n6>0,Padl(Transform(n6,"@E 999,999,999.99"),14),Space(14))
		    @nLin,100 PSAY Padl(Transform(n6T ,"@E 999,999,999.99"),14)
			If ARQ2->PI_STATUS == "B"
		    	@nLin,120 PSAY If(n7>0,Padl(Transform(n7 ,"@E 999,999,999.99"),14),Space(14))
   			    @nLin,135 PSAY Padl(Transform(n7T ,"@E 999,999,999.99"),14)
   			    @nLin,150 PSAY If(n8>0,Padl(Transform(n8,"@E 999,999,999.99"),14),Space(14))
   			    @nLin,165 PSAY Padl(Transform(n8T ,"@E 999,999,999.99"),14)
   			Endif
			
			nLin := nLin + 1 // Avanca a linha de impressao
		
			ARQ2->(DbSkip()) // Avanca o ponteiro do registro no arquivo
		EndDo
		
		nLin := nLin + 1 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		 	nLin := 8
		Endif
		
		//Impressao dos saldos finais
		@nLin,065 PSAY Padl(Transform(n5T,"@E 999,999,999.99"),14)
		@nLin,100 PSAY Padl(Transform(n6T,"@E 999,999,999.99"),14)
		@nLin,135 PSAY Padl(Transform(n7T,"@E 999,999,999.99"),14)
		@nLin,165 PSAY Padl(Transform(n8T,"@E 999,999,999.99"),14)
		
		///////////////////////////////////
		//  Imprime resumo do relatorio  //
		///////////////////////////////////
		
		//Forca impressao de nova pagina
		nLin           := 80
		
		//Ajusta cabecalho
		Cabec1         := ""
		Cabec2         := ""
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
		
		n1R := SubHoras(n1S,n2S)  //Saldo anterior em aberto
		n2R := SubHoras(n5T,n7T) //HE em aberto
		n3R := SubHoras(n6T,n8T) //Faltas em aberto
        n4R := SomaHoras(n1R,SubHoras(n2R,n3R))
		
		@nLin,000 PSAY "Formula do calculo das Horas"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "_________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressaO
		
		//Impressao
		@nLin,000 PSAY "     Saldo Anterior em aberto = (Saldo Anterior - Saldo Anterior Baixado no processamento do BH)"
		nLin := nLin + 1 // Avanca a linha de impressao          
	 	nLin := nLin + 1 // Avanca a linha de impressao          
	
		@nLin,000 PSAY "     HE Extras em aberto      = (Horas Extras do mes - Horas Extras no mes Baixadas no processamento do BH)"
		nLin := nLin + 1 // Avanca a linha de impressao          
		nLin := nLin + 1 // Avanca a linha de impressao          

		@nLin,000 PSAY "     Folgas/Faltas em aberto  = (Folgas/Faltas do mes - Folgas/Faltas no mes Baixadas no processamento do BH)"
		nLin := nLin + 1 // Avanca a linha de impressao          
		nLin := nLin + 1 // Avanca a linha de impressao          

		@nLin,000 PSAY "     Saldo Atual              = (Saldo Anterior em aberto) - (Folgas/Faltas em aberto) + (HE em aberto)"
		nLin := nLin + 1 // Avanca a linha de impressao          

		nLin := nLin + 1 // Avanca a linha de impressao          
		nLin := nLin + 1 // Avanca a linha de impressao          
		@nLin,000 PSAY "Detalhamento das Horas de Saldo"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "_________________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressaO

		//Impressao
		@nLin,000 PSAY "     Descricao                |         Valor"
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    --------------------------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Saldo anterior           |" + Padl(Transform(n1S,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao  d
		
		//@nLin,000 PSAY "     Saldo anterior - contido no periodo do banco de horas             |" + Padl(Transform(n7,"@E 999,999,999.99"),14)
		@nLin,000 PSAY "     Saldo baixado            |" + Padl(Transform(n2S,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao

		//@nLin,000 PSAY "                                           ----------------------------|--------------- "
		@nLin,000 PSAY "     Saldo Anterior em aberto |" + Padl(Transform(n1R,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao
	
		//@nLin,000 PSAY "                                                Saldo anterior - final |" + Padl(Transform(Somahoras(n7,n14),"@E 999,999,999.99"),14)
		nLin := nLin + 1 // Avanca a linha de impressao

		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Detalhamento das Horas Extras" 
		@nLin,120 PSAY "Detalhamento das Folgas/Faltas"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "_________________________________"
		@nLin,120 PSAY "_________________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressaO
		
		@nLin,000 PSAY "     Descricao                |         Valor"
		@nLin,120 PSAY "     Descricao                |         Valor"
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    --------------------------|--------------- "
		@nLin,120 PSAY "    --------------------------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Horas Extras no mes      |" + Padl(Transform(n5T,"@E 999,999,999.99"),14) 
		@nLin,120 PSAY "     Folga/Faltas no mes      |" + Padl(Transform(n6T,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "     Horas Extras Baixadas    |" + Padl(Transform(n7T,"@E 999,999,999.99"),14) 
		@nLin,120 PSAY "     Folga/Faltas Baixadas    |" + Padl(Transform(n8T,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Horas Extras em aberto   |" + Padl(Transform(n2R,"@E 999,999,999.99"),14) 
		@nLin,120 PSAY "     Folga/Faltas em aberto   |" + Padl(Transform(n3R,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,000 PSAY "Detalhamento do Saldo Final"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "_________________________________"
		nLin := nLin + 1 // Avanca a linha de impressao
		nLin := nLin + 1 // Avanca a linha de impressaO
		
		@nLin,000 PSAY "     Descricao                |         Valor"
		nLin := nLin + 1 // Avanca a linha de impressao          
		
		@nLin,000 PSAY "    --------------------------|--------------- "
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Saldo Anterior em aberto |" + Padl(Transform(n1R,"@E 999,999,999.99"),14) 
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "     Folga/Faltas em aberto   |" + Padl(Transform(n3R,"@E 999,999,999.99"),14) + " (-)"
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,000 PSAY "     Horas Extras em aberto   |" + Padl(Transform(n2R,"@E 999,999,999.99"),14) + " (+)"
		nLin := nLin + 1 // Avanca a linha de impressao 
		
		@nLin,000 PSAY "     Saldo Final em aberto    |" + Padl(Transform(n4R,"@E 999,999,999.99"),14) + " (=)"
		nLin := nLin + 1 // Avanca a linha de impressao		
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

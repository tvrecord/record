#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

#Define STR0001 "PED COMPRA"
#Define STR0002 "- PEDIDOS DE COMPRA"
#Define STR0003 "PED VENDA"
#Define STR0004 "- PEDIDOS VENDA"
#Define STR0005 "PEDIDOS PENDENTES" 
#Define STR0006 "Diario Sintetico Por Natureza"
#Define STR0007 "Houve falha na criacao do arquido temporario _SED."
#Define STR0008 "Houve falha na criacao do arquido temporario ARQTMP."
#Define STR0009 "Houve falha impressao dos registros de Pedido de Compra."

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³x_FINR200 ³ Autor ³ Claudio Ferreira      ³ Data ³ 22.05.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Di rio Sint‚tico em Aberto por Natureza                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR200(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico TV Record                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rafael      ³17/04/08³Melhor³Alterada regra para integracao com pedidos³±±
±±³            ³        ³      ³de Venda e Compra.                        ³±±
±±³            ³        ³      ³Incluidos parametros para filtro das      ³±±
±±³            ³        ³      ³contas bancarias.                         ³±±
±±³            ³        ³      ³Criado arquivo temporario da tabela SED   ³±±
±±³            ³        ³      ³denominando o novo alias como _SED, para  ³±±
±±³            ³        ³      ³parmitir manipulacao do cadastro durante  ³±±
±±³            ³        ³      ³a impressao.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TMP004()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1	:= "Emissao do Relatorio Diario Sintetico por Natureza. Ser  usado "  //
LOCAL cDesc2	:= "a data-base do sistema como ponto de partida."  //
LOCAL cDesc3	:=""
LOCAL cString	:=""
Local nMoeda, cTexto


PRIVATE Titulo	:= ""
PRIVATE cabec1  := ""
PRIVATE cebec2  := ""
PRIVATE tamanho := "G"
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //###
PRIVATE nomeprog:= "X_FINR200"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "XFI200    "
PRIVATE nColun  := 0  // Controle de colunas (substitui pCol())
PRIVATE cArqTmp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSx1()
AjustaSx1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³ mv_par01               Da Natureza                          ³
//³ mv_par02               At‚ a Natureza                       ³
//³ mv_par03               N£mero de dias                       ³
//³ mv_par04               Moeda                                ³
//³ mv_par05               Cons.Ped.Compra 1=Sim,2=nao FMQ201   ³
//³ mv_par06               Cons.Ped.Vda. 1=Sim,2=Nao   FMQ201   ³
//³ mv_par07               N¡veis de quebra                     ³
//³ mv_par08               Considera Data Base                  ³
//³ mv_par09               Considera Abatimentos                ³
//³ mv_par10               Considera Filiais                    ³
//³ mv_par11               Filial De                            ³
//³ mv_par12               Filial Ate                           ³
//³ mv_par13               Situacoes a imprimir                 ³
//³ mv_par14               Do Banco                             ³
//³ mv_par15               Da Agencia                           ³
//³ mv_par16               Da Conta                             ³ 
//³ mv_par17               Ate Banco                            ³
//³ mv_par18               Ate Agencia                          ³
//³ mv_par19               Ate Conta                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := OemToAnsi(STR0006)  //
cabec1 := OemToAnsi(STR0006)  //
cabec2 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "X_FINR200"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nMoeda	:= mv_par04
cTexto	:= " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))
Titulo	+= cTexto

RptStatus({|lEnd| Fa200Imp(@lEnd,wnRel,cString)},Titulo)

//Verifica se o alias temporario estah em uso
If chkfile("_SED")
	dbselectArea("_SED")
	dbCloseArea()
EndIf

//Verifica se o alias temporario estah em uso
If chkfile("_SC6")
	dbselectArea("_SC6")
	dbCloseArea()
EndIf                

//Verifica se o alias temporario estah em uso
If chkfile("_SC7")
	dbselectArea("_SC7")
	dbCloseArea()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA200IMP ³ Autor ³ Vin¡cius Barreira     ³ Data ³ 19.10.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Di rio Sint‚tico em Aberto por Natureza                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA200Imp(lEnd,wnRel,cString)

LOCAL cbCont	:=0
LOCAL CbTxt		:=Space(10)
LOCAL aNiveis  	:= {}
LOCAL aQuebras 	:= {}
LOCAL nLaco 	:= 0
LOCAL nByte 	:= 0
LOCAL cMapa 	:= ""
LOCAL nLimBreak := 0
LOCAL nBancos 	:= 0
LOCAL nCaixas 	:= 0
LOCAL nAplicacao	:= 0
Local nEmprestimo	:= 0
LOCAL lPrimeiraPagina := .T.
LOCAL aVenc,nValor,dDataIni
LOCAL lHaMovto	:= .F.
LOCAL lMovNat	:= .F.
LOCAL nOutroLaco:= 0
LOCAL aSemana	:= {OemToAnsi("Domingo"),;
					OemToAnsi("Segunda"),;
					OemToAnsi("Terca  "),;
					OemToAnsi("Quarta "),;     //#########
					OemToAnsi("Quinta "),;
					OemToAnsi("Sexta  "),;
					OemToAnsi("Sabado ") }              //######
LOCAL aCalc   	:= {}
Local aDtCabec	:= {}		// array das datas do cabecalho de dias
Local nBlocOld 	:= 0		// controla bloco anterior p/imprimir cabecalho de dias
Local dDataCabec:= dDataBase
Local dDtMovim 	:= dDataBase
Local cBancoCx
LOCAL lSaldoDia	:= .F.
LOCAL lResulDia	:= .F.
Local aAreaSM0 	:= SM0->(GetArea())
Local cSavFil  	:= cFilAnt
Local dUltData 	:= dDataBase
Local dDataTrab	:= dDataBase
Local nX       	:= 0
Local nY     	:= 0
Local nZ		:= 0
Local nDays
Local cFilDe 
Local cFilAte
Local cNatAnt
Local bNatureza := { || IF( mv_par10 == 1, .T., _SED->ED_FILIAL == xFilial("SED") .AND.;
					_SED->ED_CODIGO <= mv_par02 ) }
Local nDias
Local nBlocos
Local lFirst	:= .T.

Local cDoBanco	:= mv_par14
Local cDoAgenc	:= mv_par15
Local cDoConta	:= mv_par16
Local cAtBanco	:= mv_par17
Local cAtAgenc	:= mv_par18
Local cAtConta	:= mv_par19


cBancoCx := GetMV("MV_CARTEIR")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ a formata‡„o do c¢digo das naturezas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMascNat := GetMV("MV_MASCNAT")
cMapa    := "123456789"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida limite de quebra.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 >= Len( cMascNat )
	mv_par07 := Len( cMascNat ) - 1
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula a ultima data do relatorio, baseado no parametro que informa a  ³
//³qtde. de dias (MV_PAR03), pois o relatorio precisa processar datas em   ³
//³multiplos de oito dias.                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 0 To MV_PAR03 STEP 8
	nZ := IIF(mv_par03-nX >= 8,8,MOD(mv_par03,8))
	For nY := 1 TO nZ
		If nX == 0 .AND. nY == 7
			Exit
		EndIf
		dUltData++
		While Dow(dUltData) == 1 .or. Dow(dUltData) == 7
			dUltData++
		Enddo
	Next nY
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par10 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par11	// Todas as filiais
	cFilAte:= mv_par12
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho Temporario para o Cadastro de Naturezas "_SED"|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !f_SEDTMP()
	MsgAlert(STR0007) //"Houve falha na criacao do arquido temporario _SED."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho Temporario para o controle das impressoes     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !f_ARQTMP()
	MsgAlert(STR0008) //"Houve falha na criacao do arquido temporario ARQTMP."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a Disponibilidade Financeira                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmpAnt+cFilDe,.T.)
While SM0->(!Eof()) .And. SM0->M0_CODIGO == cEmpAnt .And. SM0->M0_CODFIL <= cFilAte
	cFilAnt := SM0->M0_CODFIL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe Operacao Financeira a ser resgatada no dia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEH")
	
	If !Empty(xFilial("SEH")) .Or. (Empty(xFilial("SEH")) .And. lFirst)
		dbSetOrder(2)
		dbSeek(xFilial("SEH")+"A",.T.)
		While ( !Eof() .And. SEH->EH_FILIAL == xFilial("SEH") .And. SEH->EH_STATUS == "A" )
			aCalc := Fa171Calc(dDataBase+MV_PAR03)
			If ( SEH->EH_APLEMP == "EMP" )
				nEmprestimo += xMoeda(aCalc[2,1],1,MV_PAR04)
			Else
				nAplicacao += xMoeda(aCalc[1],1,MV_PAR04)
			EndIf
			dbSelectArea("SEH")
			dbSkip()
		EndDo
		dbSelectArea("SEH")
		dbSetOrder(1)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica disponibilidade banc ria                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(xFilial("SA6")) .Or. (Empty(xFilial("SA6")) .And. lFirst)
		DbSelectArea("SA6")
		DbSeek(xFilial("SA6"))
		While ! Eof() .and. SA6->A6_FILIAL == xFilial("SA6")
			
			//Verifica bancos parametrizados
			If SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON < cDoBanco+cDoAgenc+cDoConta ;
			   .or. SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON > cAtBanco+cAtAgenc+cAtConta
			
				SA6->(DbSkip())
				Loop
			Endif

			
			//Verifica se banco compoe o fluxo de caixa
			If SA6->A6_FLUXCAI <> "N"
				If SubStr(SA6->A6_COD,1,2) = "CX" .or. SA6->A6_COD $ cBancoCx
					nCaixas += RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
				Else
					nBancos += RecSalBco(SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON,dDataBase)
				EndIf
			EndIf
			dbSelectArea("SA6")
			dbSkip()
		Enddo
	Endif
	
	lFirst  := .F.                                                  
	nBancos := xMoeda(nBancos,1,MV_PAR04)
	nCaixas := xMoeda(nCaixas,1,MV_PAR04)
	
	//Considera Pedidos de Compra
	If mv_par05 == 1
		
		//Montar Alias temporario para os Pedidos de Compra
		If f_SC7TMP()
			
			SF4->(DbSetOrder(1)) 
			
			//Percorre todo _SC7
			While !_SC7->(Eof())
			
				// Se TES nao gera duplicata, despreza o registro
				If SF4->(DBSEEK(xFilial("SF4")+_SC7->C7_TES)) ;
					.AND. SF4->F4_DUPLIC == "N"
					
					_SC7->(DbSkip())
					Loop
				Endif
								
				//Calcula valor do item
				nValor := _SC7->(C7_PRECO *(C7_QUANT-C7_QUJE) * (1+C7_IPI/100))
				
				If nValor > 0
					
					//Verifica se o Pedido tem Solicitacao de Compras
					If	!Empty(_SC7->C7_NUMSC)
		
						//Pesquisa a Solicitacao de Compras do Pedido de Compras
						SC1->(DbSetOrder(1))	//C1_FILIAL+C1_NUM+C1_ITEM                                                                                                                                        
						If SC1->(DbSeek(xFilial("SC1")+_SC7->(C7_NUMSC+C7_ITEMSC)))
								
							//Verifica se a Solicitacao tem Natureza
							If !Empty(SC1->C1_NATUREZ)							
								
								//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
								f_CalNat({SC1->C1_NATUREZ,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dUltData}) 
							
							//Pedido sem Natureza vinculada, sera vinculado ao item "Ped Compra" (STR0001)
							Else
							
								//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
								f_CalNat({STR0001,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dUltData})                 
									
							Endif
						Endif
		
					//Pedido sem Natureza vinculada, sera vinculado ao item "Ped Compra" (STR0001)
					Else
							
						//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
						f_CalNat({STR0001,nValor,_SC7->C7_COND,_SC7->C7_DATPRF,"S",dUltData})                				
					Endif
				Endif
					
				//Proximo registro
				_SC7->(DbSkip())
			Enddo	
		Else
			MsgAlert(STR0009) //"Houve falha impressao dos registros de Pedido de Compra"
		Endif	
	Endif
	
	//Verifica Pedidos de Venda
	If mv_par06 == 1
		
		//Montar Alias temporario para os Pedidos de Compra
		If f_SC6TMP()
		
			While !_SC6->(EOF())
				
				// Se for residuo ou se o TES nao gera duplicata, despreza o registro
				If SF4->(DBSEEK(xFilial("SF4")+_SC6->C6_TES)) ;
				   .AND. SF4->F4_DUPLIC == "N"
					
					_SC6->(DbSkip())
					Loop
				Endif
				
				//Calcula valor do registro
				nValor := _SC6->(C6_PRCVEN * (C6_QTDVEN-C6_QTDENT))
				
				//Avalia o cabecalho do Pedido de Venda
				SC5->(DbSetOrder(1))
				If SC5->(dbSeek(xFilial("SC5")+_SC6->C6_NUM))
				
					//Verifica o valor do item e o tipo do Pedido	
					IF nValor > 0  ;
					   .and. SC5->C5_TIPO == "N"   
					    
					    //Verifica os dados do produto do item 
						SB1->(DbSetOrder(1))
						SB1->(dbSeek(xFilial("SB1") + _SC6->C6_PRODUTO))
						
						//Ajusta valor do produto
						nValor *= (1+SB1->B1_IPI/100)
											
						//Verifica se o Pedido de Venda tem Natureza
						If !Empty(SC5->C5_NATUREZ)							
								
							//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
							f_CalNat({SC5->C5_NATUREZ,nValor,SC5->C5_CONDPAG,_SC6->C6_ENTREG,"E",dUltData}) 
								//Pedido sem Natureza vinculada, sera vinculado ao item "Ped Compra" (STR0001)
						Else
						
							//Inclui valor do movimento no arquivo de trabalho de controle do relatorio							
							f_CalNat({STR0003,nValor,SC5->C5_CONDPAG,_SC6->C6_ENTREG,"E",dUltData})                 								
						Endif	
			        EndIf
		       	EndIf
		       	
		       	//Proximo registro
		       	_SC6->(Dbskip())
			Enddo	
		Else
			MsgAlert("Houve falha impressao dos registros de Pedido de Compra")
		Endif			
	Endif
	
	DbSelectArea("SM0")
	DbSkip()
EndDo

cFilAnt := cSavFil
SM0->(RestArea(aAreaSM0))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os titulos a receber                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTmp("SE1",3,dUltData,cFilDe,cFilAte)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os titulos a pagar                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR10 == 1
	cFilDe := MV_PAR11	// Todas as filiais
	cFilAte:= MV_PAR12
Else
	cFilDe  := xFilial("SE2")
	cFilAte := xFilial("SE2")
EndIf
GeraTmp("SE2",2,dUltData,cFilDe,cFilAte)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta matriz informa em que posi‡”es ser„o feitas as quebras.   ³
//³ 1-Byte inicial da quebra, 2-Quantidade de caracteres.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aNiveis  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Esta matriz ANIVEIS estrutura os ponteiros usados na      ³
//³ verifica‡Æo de quebras de naturezas.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLaco := 1 to len( cMascNat )
	nByte := Val( Substr( cMascNat,nLaco,1 ) )
	If nByte > 0
		AAdd( aNiveis  , { Val(Left(cMapa,1)) , nByte} )
		cMapa := Subst(cMapa,nByte+1,Len(cMapa)-nByte)
	Endif
Next
nLimBreak := IIf(Len(aNiveis) > 1, Len(aNiveis)-1, 1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nLimite armazena o n¡vel de quebra m ximo. Caso o Usu rio   ³
//³ parametrize um limite menor, ‚ respeitado o parƒmetro do    ³
//³ usu rio.                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 > 0 .and. mv_par07 < nLimBreak
	nLimBreak := mv_par07
Endif

If mv_par07 == 0
	nLimBreak := 1
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Cria a principal matriz para verificar      ³
//³  quebras e imprimir valores.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMultpl8 :=  IIf(mv_par03 > 8, Int ( mv_par03 / 8 ) + 1, 1)
nMultpl8 *= 8
nMultpl8 += 2
aQuebras := Array( Len(aNiveis), nMultpl8 )
For nLaco := 1 to Len( aQuebras )
	aQuebras[nLaco,1] := ""
	For nDias := 2 to nMultpl8
		aQuebras[nLaco,nDias] := 0
	Next
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relat¢rio a partir do arquivo tempor rio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nBlocos   := 0
nHeader   := 0
nDias     := 0
nDays		 := 2  // dias para controle da coluna de atraso e database
dDataTrab := dDataBase
nValor    := 0
aTotDia   := { 0,0,0,0,0,0,0 }
cLinha    := "|" + Replicate("-",47) + "|" + Replicate("-----------------|",9)
nTotLinha := 0
nSaldoDoDia := 0
xTotRec:=0
xTotDes:=0

IF mv_Par10 == 1
	cIndex := CriaTrab(nil,.f.)
	dbSelectArea("_SED")
	IndRegua("_SED",cIndex,"ED_CODIGO",,,OemToAnsi("Selecionando Registros..."))  //
	nIndex := RetIndex("_SED")
	dbSelectArea("_SED")
	#IFNDEF TOP
		_SED->(dbSetIndex(cIndex+OrdBagExt()))
	#ENDIF
	_SED->(dbSetOrder(nIndex+1))
	_SED->(dbGoTop())
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o relat¢rio a partir do arquivo tempor rio  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lPrimeiraPagina := .T.
dbSelectArea("cArqTmp")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Avan‡a blocos de 8 em 8 dias. Caso o n£mero de dias for menor      ³
//³ que sete ou nÆo for m£ltiplo de 8, nÆo h  problema, pois o         ³
//³ arquivo tempor rio nÆo armazenar  datas fora do n£mero de dias     ³
//³ selecionados.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nBlocos := 1 to mv_par03 Step 8
	
	If li > 10
		cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
		If lPrimeiraPagina
			lPrimeiraPagina := .F.
			Li++
			//@LI++,00 PSAY OemToAnsi("SALDO EM CAIXA      : ")  //
			//@Prow(),23 PSAY nCaixas    Picture tm(nCaixas,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi("SALDO EM BANCOS     : ")  //
			@Prow(),23 PSAY nBancos    Picture tm(nBancos,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi("SALDO EM APLICACOES : ")  //
			@Prow(),23 PSAY nAplicacao Picture tm( nAplicacao,14) //"@E 999,999,999.99"
			@LI++,00 PSAY OemToAnsi("SALDO EM EMPRESTIMOS: ")  //
			@Prow(),23 PSAY nEmprestimo Picture tm(nEmprestimo,14) //"@E 999,999,999.99"
			
			nSaldoDoDia += nBancos
			nSaldoDoDia += nCaixas
			nSaldoDoDia += nAplicacao
			nSaldoDoDia -= nEmprestimo
			
			@LI++,00 PSAY OemToAnsi("TOTAL DO DISPONIVEL : ")  //
			@Prow(),23 PSAY nSaldoDoDia Picture tm(nSaldoDoDia,14) //"@E 999,999,999.99"
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Desenha sempre os cabe‡alhos de data pois o la‡o s¢ passar       ³
	//³  por aqui quando quebrar a data.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nBlocos > 1
		++li
	Endif
	Fin200Cabec(nBlocos,nHeader,aSemana,@aDtCabec,@nBlocOld,@dDataCabec)
	
	aTotDia := { 0,0,0,0,0,0,0,0 }                  
	aTotGer := { 0,0,0,0,0,0,0,0 } //Acumulador das naturezas genéricas
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura as naturezas nos dias abrangidos     ³
	//³ Por nBlocos (Acima) e nDias (Abaixo)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DBSELECTAREA("_SED")
	If mv_par10 == 1
		_SED->(dbSetOrder(nIndex+1))
		If !Empty(mv_par01)
			_SED->(dbSeek( mv_par01 ))
		Else
			_SED->(dbGoTop())
		Endif
	Else
		_SED->(dbSetOrder(1))
		If !Empty(mv_par01)
			_SED->(dbSeek( xFilial("SED")+mv_par01 ))
		Else
			_SED->(Dbseek( xFilial("SED") ))
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o aspecto VERTICAL do relat¢rio, sempre em blocos de 8 dias   ³
	//³ definidos pelo la‡o nBlocos acima definido.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While _SED->(!Eof()) .AND. EVAL( bNatureza )
		
		//Pega Codigo da Natureza atual
		cNatAnt := _SED->ED_CODIGO
		
		//Verifca quebra de pagina
		If li > 58
			If !lSaldoDia .or. !lResulDia
				@++li,00 PSAY cLinha
			Endif
			Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")) )
			Fin200Cabec(nBlocos,nHeader,aSemana,@aDtCabec,@nBlocOld,@dDataCabec)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se houve movimentaca d'aquela natureza para imprimir ou    ³
		//³ nao existe linha contendo aquela natureza.                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("cArqTmp")
		lHaMovto := .F.
		dDtMovim := dDataBase - 1
		For nOutroLaco := 0 to mv_par03

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a data que se busca movimentacao nao ‚ a data  ³
			//³ referente aos atrasos ou DataBase. Caso seja, nao verifica ³
			//³ se a mesma ‚ Sabado ou Domingo pois ser  impresso na coluna³
			//³ de atrasos ou database.												³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dDtMovim > dDataBase
				While Dow(dDtMovim) == 1 .or. Dow(dDtMovim) == 7
					dDtMovim++
				Enddo
			Endif                                                                      

			If DbSeek(dTos(dDtMovim)+_SED->ED_CODIGO )
				If cArqTmp->ENTR !=0 .or. cArqTmp->SAID !=0
					lHaMovto := .T.
					lMovNat	:= .T.
					Exit
				Endif
			Endif
			dDtMovim++
		Next
		
		If !lHaMovto
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Inicia a matriz acumuladora de quebras  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLaco := 1 to Len( aQuebras )
				aQuebras[nLaco,1] := Subst( _SED->ED_CODIGO,aNiveis[nLaco,1],aNiveis[nLaco,2] )
			Next
			
			DbSelectArea("_SED")
			DO WHILE _SED->ED_CODIGO == cNatAnt
				dbSkip()
			ENDDO
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Verifica se houve quebra em algum n¡vel ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			f200totnat(nLimBreak,aQuebras,aNiveis,@lMovNat,nBlocos)
			Loop
		Endif
		
		// Se for nivel 0 o relat¢rio ser  sintetico.
		If mv_par07 > 0
			lSaldoDia := .F.
			lResulDia := .F.
			If _SED->ED_GENERIC<>'2'
				@++li,00 PSAY  "|" + Trim(f_Mascara(_SED->ED_CODIGO) + ' ' + Left(_SED->ED_DESCRIC,30) )
				@li,48   PSAY  "|"
			Endif
		Endif
		
		DbSelectArea("cArqTmp")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o aspecto HORIZONTAL do Relat¢rio.               ³
		//³ Caso nao encontre a data, imprime espa‡os em branco    ³
		//³ para manter o alinhamento.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTotLinha := 0
		nDays := 2
		For nDias := 1 to 8

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso seja primeiro bloco, procura pelos atrasos e valo-³
			//³ res referentes a data base.                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nBlocos == 1 .and. nDias < 2
				If dbSeek( dTos(dDaTaBase+1-nDays) + _SED->ED_CODIGO )
					nValor := cArqTmp->Entr - cArqTmp->Said
					aTotDia[ nDias ] += cArqTmp->Entr - cArqTmp->Said
					//So se quizer somar o atrasado
					//xTotRec+=cArqTmp->Entr
					//xTotDes+=cArqTmp->Said
					nTotLinha += nValor
					For nLaco := 1 to Len(aQuebras)
						aQuebras[nLaco,( nBlocos+nDias ) ] += nValor
					Next
					
					// Se for nivel 0 o relat¢rio sera  sintetico.
					If mv_par07 > 0 .and. nValor != 0
						If _SED->ED_GENERIC<>'2'
							@Prow(),33+(nDias*18) PSAY nValor Picture tm(nValor,13)//"@E 99,999,999.99"
						else
							aTotGer[ nDias ] += nValor
						endif
					Endif
				Endif
				nDays --
			Else
				If dbSeek( dTos(aDtCabec[nDias]) + _SED->ED_CODIGO )
					nValor := cArqTmp->Entr - cArqTmp->Said
					aTotDia[ nDias ] += cArqTmp->Entr - cArqTmp->Said
					xTotRec+=cArqTmp->Entr
					xTotDes+=cArqTmp->Said
					nTotLinha += nValor
					For nLaco := 1 to Len(aQuebras)
						aQuebras[nLaco,( nBlocos+nDias ) ] += nValor
					Next
					// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
					If mv_par07 > 0 .and. nValor != 0
						If _SED->ED_GENERIC<>'2'
							@Prow(),33+(nDias*18) PSAY nValor Picture tm(nValor,13) // "@E 99,999,999.99"
						else
							aTotGer[ nDias ] += nValor
						endif
					Endif
				Endif
			Endif

			// Se for n¡vel 0 o relat¢rio ser  sint‚tico.
			If mv_par07 > 0 .and. _SED->ED_GENERIC<>'2'
				@Prow(),48 + ((nDias*18))   PSAY "|"
			Endif
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Imprime o total daquela linha daquela p gina     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07 > 0 .and. _SED->ED_GENERIC<>'2'
			@Prow(),194  PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
			@Prow(),210	 PSAY "|"
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Inicia a matriz acumuladora de quebras  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLaco := 1 to Len( aQuebras )
			aQuebras[nLaco,1] := Subst( _SED->ED_CODIGO,aNiveis[nLaco,1],aNiveis[nLaco,2] )
		Next
		DbSelectArea("_SED")
		
		DO WHILE _SED->ED_CODIGO == cNatAnt
			dbSkip()
		ENDDO
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³  Verifica se houve quebra em algum n¡vel ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		f200totnat(nLimBreak,aQuebras,aNiveis,@lMovNat,nBlocos)
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  ImpressÆo dos TOTAIS quando houver quebras por dia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY OemToAnsi("| RESULTADO DO DIA")   //
	@li,48   PSAY "|"
	lResulDia := .T.
	nTotLinha := 0
	For nDias := 1 to 8
		dDataTrab := dDataBase + nBlocos + nDias - 3
		nTotLinha += aTotDia[ nDias ]
		@Prow(),32 + ((nDias*18)) PSAY aTotDia[ nDias ] Picture tm(aTotDia[ nDias ],14) // "@E 99,999,999.99"
		@Prow(),48 + ((nDias*18)) PSAY "|"
	Next
	@Prow(),194      PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
	@Prow(),210      PSAY "|"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  ImpressÆo dos SALDOS quando houver quebras por dia ³
	//³  Observe que o array aTotDia somente ‚ limpo neste  ³
	//³  ponto do programa                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY cLinha
	@++li,00 PSAY OemToAnsi("| SALDO DO DIA")  //
	@li,48   PSAY "|"
	lSaldoDia := .T.
	nTotLinha := 0
	For nDias := 1 to 8
		nSaldoDoDia += aTotDia[nDias]
		@Prow(),33 + ((nDias*18)) PSAY nSaldoDoDia Picture tm(nSaldoDoDia,14) //"@E 99,999,999.99"
		@Prow(),48 + ((nDias*18)) PSAY "|"
		nTotLinha := nSaldoDoDia
		aTotDia[ nDias ] := 0
	Next
	@Prow(),194      PSAY nTotLinha Picture tm(nTotLinha,15) //"@E 9999,999,999.99"
	@Prow(),210      PSAY "|"
	@++li,00         PSAY  cLinha
Next
// Imprime resumo final
li+=2
@++li,00 PSAY " (+)SALDO EM BANCOS "+Dtoc(ddatabase)
@Prow(),48 PSAY nBancos    Picture tm(nBancos,14)
@++li,00 PSAY " (+)RECEITAS DE "+Dtoc(ddatabase)+" a "+Dtoc(dUltData)
@Prow(),48 PSAY xTotRec    Picture tm(nBancos,14)
@++li,00 PSAY " (-)DESPESAS DE "+Dtoc(ddatabase)+" a "+Dtoc(dUltData)
@Prow(),48 PSAY xTotDes    Picture tm(nBancos,14)
@++li,00 PSAY " (=)SALDO FINAL DO PERIODO"
@Prow(),48 PSAY nBancos+xTotRec-xTotDes    Picture tm(nBancos,14)
//
roda(cbcont,cbtxt,"G")

Set Device To Screen
Set Filter To

If mv_Par10 == 1
	dbSelectArea("_SED")
	dbClearFil()
	RetIndex("_SED")
	FErase(cIndex+OrdBagExt())
	DbSetOrder(1)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea("cArqTmp")
cArqTmp->( dbCloseArea() )
FErase(cArqTmp+OrdBagExt())
FErase(cArqTmp+GetDBExtension())

dbSelectArea("SE1")
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fin200Cabec³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 10/09/98³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Printa o cabe‡alho dos dias da semana                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fin200Cabec(nBlocos,nHeader,aSemana,aDtCabec,nBlocOld,	   ³±±
±±³          ³             dDataCabec)									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nBlocos  - N£mero de dias em m£ltiplos de 8 (uma semana).   ³±±
±±³          ³ nHeader  - Dia do mes/da semana do bloco em questao.        ³±±
±±³          ³ aSemana  - Array com os dias da semana por extenso.         ³±±
±±³          ³ aDtCabec - Array com as datas do bloco.                     ³±±
±±³          ³ nBlocOld - Guarda o bloco anterior p/recalcular datas ou nao³±±
±±³          ³ dDataCabec - Ultima data calculada no cabecalho.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - FINR200.PRX                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fin200Cabec(nBlocos,nHeader,aSemana,aDtCabec,nBlocOld,dDataCabec)

LOCAL aMeses := {OemToAnsi("Janeiro") ;
				,OemToAnsi("Fevereiro");
				,OemToAnsi("Marco");
				,OemToAnsi("Abril");
				,OemToAnsi("Maio");
				,OemToAnsi("Junho");
				,OemToAnsi("Julho");
				,OemToAnsi("Agosto");
				,OemToAnsi("Setembro");
				,OemToAnsi("Outubro");
				,OemToAnsi("Novembro");
				,OemToAnsi("Dezembro")}

Local nCount := 8

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica, pelo numero de linhas se podera imprimir o cabecalho	³
//³ nesta pagina, evitando que imprima cabecalho sem linha de dados  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li < 55
	@++li,00 PSAY cLinha
	@++li,00 PSAY OemToAnsi("| HISTORICO/DIAS")  //
	@li,48   PSAY "|"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica mudanca de bloco para atualizar o array de datas. Caso³
	//³o Array esteja vazio, alimenta o Array.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nBlocOld <> nBlocos
		aDtCabec := {}
		nBlocOld := nBlocos

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for 1§ bloco, imprime coluna de Atrasos e da DataBase      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nBlocos == 1
			AADD (aDtCabec,dDataBase-1)
			dDataCabec:= dDataBase
			AADD (aDtCabec,dDataCabec)
			nCount := 6
		Endif

		For nHeader := 1 to nCount
			dDataCabec++
			While Dow(dDataCabec) == 1 .or. Dow(dDataCabec) == 7
				dDataCabec++
			Enddo
			AADD (aDtCabec,dDataCabec)
		Next
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime datas.                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColun := 48
	For nHeader :=1 to 8
		If nHeader ==1 .and. nBlocos == 1
			nColun += 18
			@Prow(),54       PSAY OemToAnsi("Atrasos ")  //
			@Prow(),nColun   PSAY "|"
		Else
			nColun+=4
			@Prow(),nColun       PSAY aDtCabec[nHeader]
			nColun+=14
			@Prow(),nColun PSAY "|"
		Endif
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime Coluna de Subtotal no cabecalho.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@Prow(),195 PSAY OemToAnsi("SUBTOTAL DA")  //
	@Prow(),210 PSAY "|"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime dias da semana ref as datas do bloco.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@++li,00 PSAY "| " + aMeses[Month( dDataCabec )]
	@li,48   PSAY "|"
	nColun := 48
	For nHeader := 1 to 8
		If nHeader ==1 .and. nBlocos == 1
			nColun += 18
			@Prow(),nColun PSAY "|"
		Else
			nColun+=5
			@Prow(),nColun PSAY aSemana[ Dow(aDtCabec[nHeader]) ]
			nColun += 13
			@Prow(),nColun PSAY "|"
		Endif
		
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime coluna de complemento do Subtotal no cabecalho.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nColun += 6
	@Prow(),nColun PSAY OemToAnsi("NATUREZA")  //
	@Prow(),210 PSAY "|"
	@++li,00 PSAY  cLinha
Else
	li := 80
Endif
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ F200TotNatc³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 09/12/98³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime total da natureza, na quebra de natureza	         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ f200totnat(nLimBreak,aQuebras,aNiveis,lMovNat)  	         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - FINR200.PRX                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION f200totnat(nLimBreak,aQuebras,aNiveis,lMovNat,nBlocos)
Local nSavRec
Local nSavRec2
Local cSeek_SED
Local cCod_SED
Local nCtrl
Local nToCtrl
LOCAL nSetOrder := _SED->(INDEXORD())
LOCAL nLaco, nQuebras, nDias, nTotLinha

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Verifica se houve quebra em algum n¡vel ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_SED->( DBSETORDER(1) )
For nLaco := 1 to nLimBreak
	If aQuebras[nLaco,1] # Subst( _SED->ED_CODIGO, aNiveis[nLaco,1], aNiveis[nLaco,2] )
		For nQuebras := nLimBreak to nLaco Step -1
			nSavRec := _SED->( Recno() )
			dbSeek( xFilial("SED") + aQuebras[nQuebras,1] )
			//Verifica se somou natureza generica
			nTotGer := 0
			For nDias := 1 to 8
				If aTotGer[nDias] # 0
					nTotGer += aTotGer[nDias]
				Endif
			Next
			
			nTotLinha := 0
			For nDias := 1 to 8
				If aQuebras[nQuebras, nBlocos+nDias ] # 0
					nTotLinha += aQuebras[nQuebras, nBlocos+nDias ]
				Endif
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime totais de natureza GENERICAS que tenham Movimento  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotGer != 0
				li++
				@li,00 PSAY "|"
				@li,01 PSAY "          OUTRAS DESPESAS GENERICAS"
				@li,48 PSAY "|"
				
				For nDias := 1 to 8
					If aTotGer[nDias] # 0
						@Prow(),32 + ((nDias*18)) PSAY aTotGer[nDias] Picture Tm(aTotGer[nDias], 14 ) //"@E 99,999,999.99"
						aTotGer[nDias] := 0
					Endif
					@Prow(),48 + ((nDias*18))   PSAY "|"
				Next
				@Prow(),194 PSAY nTotGer Picture Tm( nTotGer, 15 ) // "@E 9999,999,999.99"
				@Prow(),210 PSAY "|"
				@++li,00 PSAY cLinha
			Endif
			//Fim impressao linha generica
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime totais de natureza que tenham Movimento  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotLinha != 0 .or. lMovNat
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a Descricao da Natureza Totalizada ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSavRec2 := _SED->( Recno() )
				cCod_SED  := aQuebras[nQuebras,1]
				cSeek_SED := ""
				If lMovNat
					nToCtrl  := IIF(mv_par07 > 0, mv_par07, 1)
					For nCtrl := 1 to nToCtrl
						cSeek_SED += aQuebras[nCtrl,1]
					Next
					DbSeek( xFilial("SED") + cSeek_SED )
					cCod_SED := f_Mascara(_SED->ED_CODIGO)
				EndIf
				li++
				@li,00 PSAY "|"
				
				//Verifica o codigo para ajustar descricao dos totalizadores de pedido
				If	Padr(cCod_SED,Len(_SED->ED_CODIGO)) <> Padr(STR0001,Len(_SED->ED_CODIGO)) ;
					.and. Padr(cCod_SED,Len(_SED->ED_CODIGO)) <> Padr(STR0003,Len(_SED->ED_CODIGO))
					
					@li,07 PSAY OemToAnsi("TOTAL - ") + cCod_SED + " " + Left( _SED->ED_DESCRIC , 20 )  //
				Else
					@li,07 PSAY OemToAnsi("TOTAL - ") + Left( STR0005 , 20 )  //
				Endif
				
				@li,48 PSAY "|"				
				_SED->( dbGoTo( nSavRec2 ) )
				
				lMovNat := .F.
				
				For nDias := 1 to 8
					If aQuebras[nQuebras, nBlocos+nDias ] # 0
						@Prow(),32 + ((nDias*18)) PSAY aQuebras[nQuebras, nBlocos+nDias ] Picture Tm(aQuebras[nQuebras, nBlocos+nDias ], 14 ) //"@E 99,999,999.99"
					Endif
					aQuebras[nQuebras, nBlocos+nDias ] := 0
					@Prow(),48 + ((nDias*18))   PSAY "|"
				Next
				@Prow(),194 PSAY nTotLinha Picture Tm( nTotLinha, 15 ) // "@E 9999,999,999.99"
				@Prow(),210 PSAY "|"
				@++li,00 PSAY cLinha
			Endif
			_SED->( dbGoTo( nSavRec ) )
		Next
	Endif
Next
_SED->(DBSETORDER(nSetOrder))
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GeraTmp   ºAutor  ³Claudio D. de Souza º Data ³  29/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera dados no arquivo temporario, a partir do arquivo de    º±±
±±º          ³titulos a receber ou do arquivo de titulos a pagar          º±±
±±º          ³Parametros:                                                 º±±
±±º          ³cAlias   -> Alias do arquivo de titulos (SE1 ou SE2)        º±±
±±º          ³nOrdem   -> Ordem por natureza do arquivo cAlias            º±±
±±º          ³dUltData -> Ultima data do periodo do relatorio             º±±
±±º          ³cFilDe   -> Filial inicial                                  º±±
±±º          ³cFilAte  -> Filial final                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR200                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION GeraTmp(cAlias,nOrdem,dUltData,cFilDe,cFilAte)

LOCAL cAliasTmp
LOCAL dDataTrab
LOCAL nX
LOCAL aSaldo    
Local cTipo    := If(Upper(cAlias)=="SE1", MVRECANT+"/"+MV_CRNEG, MVPAGANT+"/"+MV_CPNEG)
Local cCampo   := Right(cAlias,2)
Local cCampTmp := If(Upper(cAlias)=="SE1", "Entr", "Said")
Local lMvMultNat := &("MV_MULNAT"+If(cAlias=="SE1","R","P"))

#IFDEF TOP
	Local aStru
	Local cQuery
#ELSE
	Local nIndex
	Local cIndTmp
	
#ENDIF

#IFDEF TOP
	aStru  := (cAlias)->(dbStruct())
	cAliasTmp := "FINR200"
	cQuery := ""
	aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
	cQuery := "SELECT "+SubStr(cQuery,2)
	cQuery +=         ",R_E_C_N_O_ RECNO "
	cQuery += "FROM "+RetSqlName(cAlias)+ " "+ cAlias + " "
	cQuery += "WHERE "
	If mv_par10 == 1
		cQuery += cAlias + "." + cCampo + "_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' AND "
	Else
		cQuery += cAlias + "." + cCampo + "_FILIAL = '"+ xFilial(cAlias)+"' AND "
	Endif
	cQuery += "("+cAlias + "." + cCampo + "_MULTNAT = '1' OR ("
	cQuery += cAlias + "." + cCampo + "_NATUREZ BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQuery += cAlias + "." + cCampo + "_NATUREZ <> '"+Space(Len((cAlias)->&(cCampo+"_NATUREZ")))+"')) AND "
	cQuery += cAlias + "." + cCampo + "_EMISSAO <= '"+Dtos(dDataBase)+"' AND "
	cQuery += cAlias + "." + cCampo + "_VENCREA <= '"+Dtos(dUltData)+"' AND "
	If cAlias=="SE1"
		cQuery += cAlias + "." + cCampo + "_SITUACA IN "+FormatIn(mv_par13,,1)+" AND "
	Endif
	If ( MV_PAR08 == 2 )
		cQuery += cAlias + "." + cCampo + "_SALDO > 0 AND "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nao considerar titulos gerados a partir de uma FATURA para ³
	//³nao duplicar a demonstração.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery += "NOT (" + cAlias + "." + cCampo + "_FATURA <> ' ' AND " + cAlias + "." + cCampo + "_FATURA <> 'NOTFAT' AND " + cAlias + "." + cCampo  + "_DTFATUR <= '" + DTOS(dDataBase) + "') AND "
	cQuery += cAlias + "." + cCampo + "_FLUXO<>'N' AND "
	cQuery += cAlias + ".D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.)
	For nX :=  1 To Len(aStru)
		If aStru[nX][2] <> "C"
			TcSetField(cAliasTmp,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
#ELSE
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	cIndTmp := CriaTrab(,.F.)
	
	IndRegua(cAlias,cIndTmp,IndexKey(),,Fr200Fil(cCampo,cFilDe,cFilAte,dUltData))
	nIndex := RetIndex(cAlias)
	dbSetIndex(cIndTmp+OrdBagExt())
	dbSetOrder(nIndex+1)
	dbGotop()
	cAliasTmp := cAlias
#ENDIF


DbSelectArea(cAliasTmp)
While ( !Eof() ) //IndRegua

	// Se estiver utilizando multiplas naturezas, verifica o arquivo de multiplas
	// naturezas (SEV)
	If lMvMultnat .And. (cAliasTmp)->&(cCampo+"_MULTNAT") == "1"
		If !PesqNatSev(cAliasTmp,cCampo, mv_par01, mv_par02)
			DbSkip()
			Loop
		Endif
	Else
		If &(cCampo+"_NATUREZ") > mv_par02 .OR. &(cCampo+"_NATUREZ") < mv_par01
			DbSkip()
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se considera ou nÆo adiantamentos		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR09 == 2 .and. (cAliasTmp)->&(cCampo +"_TIPO") $ cTipo
		dbSkip()
		Loop
	EndIf

	If (cAliasTmp)->&(cCampo +"_VENCREA") < dDataBase
		dDataTrab := dDataBase - 1
	Else
		dDataTrab := DataValida((cAliasTmp)->&(cCampo+"_VENCREA"),.T.)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a data de vencto. ultrapassar a ultima data do relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If dDataTrab > dUltData
		dbSkip()
		Loop
	EndIf

	#IFDEF TOP
		// Posiciona SE2 ou SE1 para pegar o saldo do titulo correto
		(cAlias)->(DbGoto((cAliasTmp)->RECNO))
	#ENDIF

	aSaldo := SdoTitNat((cAliasTmp)->&(cCampo+"_PREFIXO"),;
	(cAliasTmp)->&(cCampo+"_NUM")    ,;
	(cAliasTmp)->&(cCampo+"_PARCELA"),;
	(cAliasTmp)->&(cCampo+"_TIPO")   ,;
	(cAliasTmp)->&(cCampo+If(Upper(cAlias)=="SE1","_CLIENTE","_FORNECE")),;
	(cAliasTmp)->&(cCampo+"_LOJA"),  ,;
	If(cAlias=="SE1","R","P")        ,;
		cAliasTmp                        ,;
		MV_PAR04                         ,;
		MV_PAR08 == 1)
		For nX := 1 To Len(aSaldo)
			If Abs(aSaldo[nX][2]) > 0.0001 .And.;
				aSaldo[nX][1] >= MV_PAR01   .And.;
				aSaldo[nX][1] <= MV_PAR02
				
				dbSelectArea( "cArqTmp" )
				If !(dbSeek(dTos(dDataTrab)+aSaldo[nX][1]))
					RecLock("cArqTmp",.T.)
					cArqTmp->NATUR := aSaldo[nX][1]
					cArqTmp->DATAX := dDataTrab
				Else
					RecLock("cArqTmp")
				EndIf
				If (cAliasTmp)->&(cCampo+"_TIPO") $ MVABATIM + "/" + cTipo
					cArqTmp->&(cCampTmp) -= aSaldo[nX][2]
				Else
					cArqTmp->&(cCampTmp) += aSaldo[nX][2]
				EndIf
			EndIf
		Next
		dbSelectArea(cAliasTmp)
		dbSkip()
Enddo
	#IFDEF TOP
		dbSelectArea(cAliasTmp)
		dbCloseArea()
		dbSelectArea(cAlias)
	#ELSE
		dbSelectArea(cAlias)
		DbClearFil()
		RetIndex(cAlias)
		FErase(cIndTmp+OrdBagExt())
	#ENDIF
	
RETURN NIL
*/

/*  
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fr200Fil    ³ Autor ³ Claudio Donizete Souza³ Data ³ 31/05/01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Expressao de filtro para base CDX, tratando mult.Naturezas   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fr200Fil(cCampo, cFilDe,cFilAte,dUltData)                   ³±±
±±³          ³ cCampo     - Campo do arquivo de titulo "E1" ou "E2"        ³±±
±±³          ³ cFilDe     - Filial inicial                                 ³±±
±±³          ³ cFilAte    - Filial final                                   ³±±
±±³          ³ dUltData   - Ultima data para o filtro a ser considerada    ³±±
±±³          ³              no VENCREA                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - FINR200.PRX                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION Fr200Fil( cCampo, cFilDe, cFilAte, dUltData)
Local cFiltro             ,;
cAlias  := Alias()
Local	cArq		:= "S"+cCampo

If mv_par10 = 1
	cFiltro := cCampo + "_FILIAL>='"+cFilDe+"'.And."
	cFiltro += cCampo + "_FILIAL<='"+cFilAte+"'.And."
Else
	cFiltro := cCampo + "_FILIAL=='"+xFilial(cArq)+"'.And."
Endif
cFiltro += "("+cCampo + "_MULTNAT='1'.Or."
cFiltro += "("+cCampo + "_NATUREZ>='"+MV_PAR01+"'.And."
cFiltro += cCampo + "_NATUREZ<='"+MV_PAR02+"'.And."
cFiltro += cCampo + "_NATUREZ<>'"+Space(Len((cAlias)->&(cCampo + "_NATUREZ")))+"')).And."
cFiltro += "Dtos(" + cCampo + "_VENCREA)<='"+Dtos(dUltData)+"'.And."
cFiltro += "Dtos(" + cCampo + "_EMISSAO)<='"+Dtos(dDataBase)+"'.And."
If cAlias=="SE1"
	cFiltro += cCampo + "_SITUACA$'"+mv_par13+"'.And."
Endif
If MV_PAR08==2
	cFiltro += cCampo + "_SALDO>0.And."
EndIf
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nao considerar titulos gerados a partir de uma FATURA para ³
//³nao duplicar a demonstração.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cFiltro += "!(!Empty(" + cCampo + "_FATURA).And.SUBSTR(" + cCampo + "_FATURA,1,6)!='NOTFAT'.And.DTOS(" + cCampo  + "_DTFATUR)<='" + DTOS(dDataBase) + "').And."
cFiltro += cCampo + "_FLUXO<>'N'"

Return cFiltro

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PesqNatSev  ³ Autor ³ Claudio Donizete Souza³ Data ³ 01/06/01³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pesquisa a natureza no SEV, de acordo com o titulo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PesqNatSev(cAlias,cCampo,cNatIni,cNatFim)                   ³±±
±±³          ³ cAlias     - Alias do arquivo de titulos                    ³±±
±±³          ³ cCampo     - Campo do arquivo de titulo "E1" ou "E2"        ³±±
±±³          ³ cNatIni    - Natureza Inicial        							   ³±±
±±³          ³ cNatFim    - Natureza Final 								         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - FINR200.PRX                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PesqNatSev( cAlias, cCampo, cNatIni, cNatFim )
LOCAL aArea := GetArea(),;
cChaveSev		   ,;
aAreaSev := SEV->(GetArea()),;
lAchouSev := .F.

DbSelectArea("SEV")
cChaveSev := RetChaveSev(cAlias,cCampo)
If MsSeek(cChaveSev)
	// Pesquisa as naturezas para o titulo
	While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
		EV_LOJA) == cChaveSev .And. !Eof()
		// Verifica se a natureza esta dentro dos parametros estabelecidos
		If SEV->EV_NATUREZ>= cNatIni .And.;
			SEV->EV_NATUREZ<= cNatFim .And.;
			!Empty(SEV->EV_NATUREZ)
			lAchouSev := .T.
			Exit
		Endif
		DbSkip()
	EndDo
Endif

RestArea( aAreaSev )
RestArea( aArea )

Return lAchouSev

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 07/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aArea := GetArea()
Local cPerg		:= "XFI200    "

//Altera o tamanho da pergunta e ativa os novos tipos de cobrança (FGH)
dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek(cPerg+"13")
	RecLock("SX1")
	Replace X1_TAMANHO	With 11
	Replace X1_CNT01		With "01234567FGH"
	MsUnlock()
Endif

RestArea(aArea)
Return
	
/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_CalNat  | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Soma valores as Naturezas do arquivo de trabalho que controla |
|          |a impressao do relatorio.                                     |
+----------+--------------------------------------------------------------+
|Retorno   |lRet: T - execucao correta / F - erro na execucao             |
+----------+--------------------------------------------------------------+
|Parâmetros|Array                                                         |
|          |[1] - Codigo da natureza a ser avaliada                       |
|          |[2] - Valor a ser incluido no relatorio                       |
|          |[3] - Condicao de pagamento                                   |
|          |[4] - Data de referencia                                      |
|          |[5] - Tipo de Movimento E - Entrada / S - Saida   			  |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_CalNat(aParm)

Local cNatCalc	:= aParm[1]	  		//Natureza a ser considerada		     	
Local nNatVal	:= aParm[2]	 		//Valor a ser incluido na Natureza    	
Local cCondNat	:= aParm[3] 		//Condicao a ser considerada    	
Local dDatRef	:= STOD(aParm[4]) 	//Data de referencia (data de entrega do pedido de compra)
Local cTipoMov	:= aParm[5] 		//Tipo de Movimento E - Entrada / S - Saida               
Local dDatUlt	:= aParm[6] 		//Data de referencia (data de entrega do pedido de compra)
Local aParcela	:= {}	   			//Array que recebera as parcelas simuladas
Local lRetCalc	:= .F.	   			//Retorno esperado

//Pesquisa Codigo da Natureza	
//_SED->(DbSetOrder(1))	//ED_FILIAL+ED_CODIGO                                                                                                                                             
//If _SED->(DbSeek(xFilial("_SED")+cNatCalc)))

//Verifica valor do movimento
If nNatVal > 0
	
	//Avalia a data a ser considerada
	dDatRef	:= IIf(dDatRef < dDataBase,dDataBase,dDatRef)
	
	//Gera simulacao para entrada do Pedido de Compra no Fluxo de Caixa
	aParcela := Condicao ( nNatVal,cCondNat,0,dDatRef)
	
	//Inclui simulacao no arquivo de trabalho que controla a impressao do relatorio
	For nX := 1 to Len(aParcela)
		
		//Verifica se a data da parcela eh valida
		If DataValida(aParcela[nX][1],.T.) <= dDatUlt
			
			//Verifica se jah existe Registro no arquivo temporario para a Data+Natureza do movimento
			DbSelectArea("cArqTmp")
			IF DbSeek(DToS(DataValida(aParcela[nX][1],.T.))+cNatCalc)
				RecLock("cArqTmp",.F.)
			
			//Caso nao encontre registro temporario, cria novo registro para a Data+Natureza do movimento 
			Else
				RecLock("cArqTmp",.T.)
				cArqTmp->NATUR	:= cNatCalc
				cArqTmp->DATAX	:= DataValida(aParcela[nX][1],.T.)
			Endif
				
				//Verifica se eh movimento de entrada ou saida
				If cTipoMov == "S" 
					//Soma o valor do movimento no registro temporario
					cArqTmp->SAID += xMoeda(aParcela[nX][2],1,mv_par04)
					
					//Controle da rotina
					lRetCalc := .T. 
				
				ElseIf cTipoMov == "E" 
	
					//Soma o valor do movimento no registro temporario
					cArqTmp->ENTR += xMoeda(aParcela[nX][2],1,mv_par04)
					
					//Controle da rotina
					lRetCalc := .T.				
				Endif
				
				MsUnlock()
		Endif
	Next
EndIf
//Endif   

Return lRetCalc           

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_SC7TMP  | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Cria alias temporario para os Pedidos de Compra em aberto     |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Retorno   |lRet: T - execucao correta / F - erro na execucao             |
+----------+--------------------------------------------------------------+
|Parâmetros|#                                                             |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_SC7TMP

Local lRetTmp	:= .F.									//Retorno da funcao 	
Local cQRY 		:= ""                                   //Variavel de controle da consulta
Local cSC7 		:= " " + RetSqlName("SC7") + " SC7 "    //Controle do arquivo a ser utilizado na consulta

//Verifica se o alias temporario estah em uso
If chkfile("_SC7")
	dbselectArea("_SC7")
	dbCloseArea()
End If

//Monta consulta
cQRY := " SELECT * FROM "
cQRY += cSC7
cQRY += " WHERE SC7.D_E_L_E_T_ =  '' "
cQRY += "   AND SC7.C7_FILIAL  =  '" + xFilial("SC7") + "' "
cQRY += "   AND SC7.C7_RESIDUO =  '' "
cQRY += "   AND SC7.C7_FLUXO   <> 'N' "
cQRY += "   AND SC7.C7_QUANT - SC7.C7_QUJE > 0 "
cQRY += "ORDER BY SC7.C7_NUM "

//Ajusta a consulta
cQRY := ChangeQuery(cQRY)

//Cria Alias temporario para a consulta
TcQuery cQry New Alias "_SC7"

DbSelectArea("_SC7")

//Verifica se foram encontrados resultados
If Select("_SC7") > 0
	lRetTmp := .T.
Endif

Return lRetTMP                 

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_SC6TMP  | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Cria alias temporario para os Pedidos de Venda nao Faturados  |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Retorno   |lRet: T - execucao correta / F - erro na execucao             |
+----------+--------------------------------------------------------------+
|Parâmetros|#                                                             |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_SC6TMP

Local lRetTmp	:= .F.									//Retorno da funcao 	
Local cQRY 		:= ""                                   //Variavel de controle da consulta
Local cSC6 		:= " " + RetSqlName("SC6") + " SC6 "    //Controle do arquivo a ser utilizado na consulta

//Verifica se o alias temporario estah em uso
If chkfile("_SC6")
	dbselectArea("_SC6")
	dbCloseArea()
End If

//Monta consulta
cQRY := " SELECT * FROM "
cQRY += cSC6
cQRY += " WHERE SC6.D_E_L_E_T_ =  '' "
cQRY += "   AND SC6.C6_FILIAL  =  '" + xFilial("SC6") + "' "
cQRY += "   AND SC6.C6_BLQ     <> 'R' "
cQRY += "   AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 "
cQRY += "ORDER BY SC6.C6_NUM "

//Ajusta a consulta
cQRY := ChangeQuery(cQRY)

//Cria Alias temporario para a consulta
TcQuery cQry New Alias "_SC6"

DbSelectArea("_SC6")

//Verifica se foram encontrados resultados
If Select("_SC6") > 0
	lRetTmp := .T.
Endif

Return lRetTMP                

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_SEDTMP  | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Cria alias temporario para o Cadastro de Naturezas.           |
|          |A criacao desse arquivo de trabalho eh realizada para que o   |
|          |Cadastro de Naturezas seja ajustado sem alterar a base de     |
|          |dados do Cliente.                                             |
|          |                                                              |
|          |Exemplo: existe a necessiade de incluir a natureza            |
|          |"PED COMPRAS" para que o relatorio considere Pedidos de       |
|          |Compra, sem natureza relacionada. Para isso sera criada uma   |
|          |natureza temporaria.                                          |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Retorno   |lRet: T - execucao correta / F - erro na execucao             |
+----------+--------------------------------------------------------------+
|Parâmetros|#                                                             |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_SEDTMP

Local lRetTmp	:= .F.									//Retorno da funcao 	
Local cCMPTMP	:= ""									//Conteudo temporario do campo
Local aCMPSED	:= {}                                  	//Campos do arquivo de trabalho
Local aSEDREG	:= {}                                  	//Registro a ser criado no arquivo de trabalho
Local aSX3Area	:= SX3->(GetArea())				    //Controle do arquivo a ser utilizado na consulta
Local aSIXArea	:= SIX->(GetArea())				    //Controle do arquivo a ser utilizado na consulta

//Verifica se o alias temporario estah em uso
If chkfile("_SED")
	dbselectArea("_SED")
	dbCloseArea()
EndIf

SX3->(DbSetOrder(1))
SX3->(DbSeek("SED"))

//Ajusta campos de Data ou Numericos
While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SED"
	
	//Inclui campos no array para criacao do arquivo de trabalho
	AADD(aCMPSED,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	
	//Proximo campo
	SX3->(DbSkip())
Enddo

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCMPSED,.T.)
DbUseArea(.T.,__LocalDriver,cArqTmp,"_SED",.T.)

//Cria Indice para o arquivo de trabalho
IndRegua ( "_SED",cArqTmp,"ED_FILIAL+ED_CODIGO",,,OemToAnsi("Criando Indice para arquivo temporario..."))  //

//Preenche arquivo de trabalho temporario
SED->(DbSetOrder(1))
SED->(DbGoTop())
While SED->(!EOF())
	
	//Zera array com dados do registro
	aSEDREG := {}
	
	//Preenche array com os dados do novo registro  
	For e:=1 To Len(aCMPSED)
		
		cCMPTMP := "SED->"+Alltrim(aCMPSED[e][1])
		
		AADD(aSEDREG,{aCMPSED[e][1],&(cCMPTMP)})   
	
	Next e
	
	If RecLock("_SED",.T.)
		AEval(aSEDREG, {|x| FieldPut(FieldPos(x[1]), x[2])})
		DbCommit()
		MsUnLock()
	Else
		lRetTmp := .F.
		Return lRetTmp
	EndIf

	//Proximo registro
	SED->(DbSkip())

EndDo

//Cria Naturezas temporarias   
//Essas naturezas serao utilizadas para relacionar pedidos de venda ou de compra que nao estejam com Natureza relacionada

//Natureza para Pedido de Compras
RecLock("_SED",.T.)
	
	_SED->ED_FILIAL  := xFilial("SED") 
	_SED->ED_CODIGO  := STR0001
	_SED->ED_DESCRIC := STR0002 
	_SED->ED_GENERIC := "1" 	
	
DbCommit()
MsUnLock()

//Natureza para Pedido de venda
RecLock("_SED",.T.)
	
	_SED->ED_FILIAL  := xFilial("SED") 
	_SED->ED_CODIGO  := STR0003
	_SED->ED_DESCRIC := STR0004 
	_SED->ED_GENERIC := "1" 	
	
DbCommit()
MsUnLock()

If chkfile("_SED")
	lRetTmp := .T.
Endif

//Restaura as areas alteradas	 
RestArea(aSX3Area)
RestArea(aSIXArea)

Return lRetTmp

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_ARQTMP  | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Cria alias temporario para controle do relatorio              |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Retorno   |lRet: T - execucao correta / F - erro na execucao             |
+----------+--------------------------------------------------------------+
|Parâmetros|#                                                             |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_ARQTMP

Local lRetTmp 	:= .F.
Local aCampos	:= {{"NATUR", "C" , Len(_SED->ED_CODIGO),0},;
					{"DATAX", "D" , 08                   ,0},;
					{"ENTR" , "N" , 17                   ,2},;
					{"SAID" , "N" , 17                    ,2}}

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCampos,.T.)
dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)

//Cria indice para arquivo temporario
IndRegua ( "cArqTmp",cArqTmp,"DTOS(DATAX)+NATUR",,,OemToAnsi("Selecionando Registros..."))  //

If chkfile("cArqTmp")
	lRetTmp := .T.
Endif

Return lRetTmp                             

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_Mascara | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Efetua tratamento de Mascara da natureza                      |
|          |Rotina verifica a necessidade de utilizar a funcao MascNat()  |
+----------+--------------------------------------------------------------+
|Retorno   |cNatAlt : Natureza com a mascara parametrizada                |
+----------+--------------------------------------------------------------+
|Parâmetros|cCodAlt: Codigo da natureza a ser processado                  |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function f_Mascara(cCodAlt)

Local nCod := Len(_SED->ED_CODIGO) //Carrega o tamanho do codigo da Natureza

//Verifica se a natureza nao eh "virtual"  STR0001 / STR0003 (criadas apenas no arquivo temporario _SED)
If	Padr(cCodAlt,nCod) <> Padr(STR0001,nCod) ;
	.and. Padr(cCodAlt,nCod) <> Padr(STR0003,nCod)
	
	cCodAlt := Mascnat(_SED->ED_CODIGO)
Endif
	
Return cCodAlt

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |f_CriaSx1 | Autor |RAFAEL COSTA LEITE     | Data | 15.04.2008 |
+----------+----------+-------+-----------------------+------+------------+
|Descrição |Cria grupo de perguntas personalizado para o relatorio        |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Retorno   |                                                              |
+----------+--------------------------------------------------------------+
|Parâmetros|                                                              |
|          |                                                              |
+----------+--------------------------------------------------------------+
|Uso       |Record - Financeiro                                           |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descrição                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

Static Function CriaSx1(cPerg,aPergs)

Local _sAlias	:= Alias()

/*
PutSx1(cGrupo  ,cOrdem  ,cPergunt,cPerSpa ,cPerEng ,cVar    ,cTipo   ,nTamanho,nDecimal,nPresel ,cGSC    ,cValid  ,cF3     ,cGrpSxg ;
      ,cPyme   ,cVar01  ,cDef01  ,cDefSpa1,cDefEng1,cCnt01  ,cDef02  ,cDefSpa2,cDefEng2,cDef03  ,cDefSpa3,cDefEng3,cDef04  ,cDefSpa4;
      ,cDefEng4,cDef05  ,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
*/

PutSx1('XFI200'			; //cGrupo   - Grupo de perguntas
      ,'01'    			; //cOrdem   - Ordem da pergunta
      ,'Da Natureza?'	; //cPergunt - Pergunta em Portugues
      ,'Da Natureza?'	; //cPerSpa  - Pergunta em Espanhol
      ,'Da Natureza?'	; //cPerEng  - Pergunta em Ingles
      ,'mv_ch1'		    ; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,10				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,'SED'		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par01'	   	; //cVar01   - Variavel 1
      ,''				; //cDef01   - Definicao 1
      ,''				; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''				; //cDef02
	  ,''   			; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''	 			; //cDef03
	  ,''				; //cDefSpa3
	  ,''               ; //cDefEng3
	  ,''               ; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''		  		; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp
	  
PutSx1('XFI200'			; //cGrupo   - Grupo de perguntas
      ,'02'    			; //cOrdem   - Ordem da pergunta
      ,'Ate Natureza?'	; //cPergunt - Pergunta em Portugues
      ,'Ate Natureza?'	; //cPerSpa  - Pergunta em Espanhol
      ,'Ate Natureza?'	; //cPerEng  - Pergunta em Ingles
      ,'mv_ch2'		    ; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,10				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,'SED'		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par02'	   	; //cVar01   - Variavel 1
      ,''				; //cDef01   - Definicao 1
      ,''				; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,'ZZZZZZZZZZ'		; //cCnt01
	  ,''				; //cDef02
	  ,''   			; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''	 			; //cDef03
	  ,''				; //cDefSpa3
	  ,''               ; //cDefEng3
	  ,''               ; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''		  		; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp 
	  
PutSx1('XFI200'			; //cGrupo   - Grupo de perguntas
      ,'03'    			; //cOrdem   - Ordem da pergunta
      ,'Numero de dias?'; //cPergunt - Pergunta em Portugues
      ,'Numero de dias?'; //cPerSpa  - Pergunta em Espanhol
      ,'Numero de dias?'; //cPerEng  - Pergunta em Ingles
      ,'mv_ch3'		    ; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,3				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par03'	   	; //cVar01   - Variavel 1
      ,''				; //cDef01   - Definicao 1
      ,''				; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,'  1'			; //cCnt01
	  ,''				; //cDef02
	  ,''   			; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''	 			; //cDef03
	  ,''				; //cDefSpa3
	  ,''               ; //cDefEng3
	  ,''               ; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''		  		; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	
	  
PutSx1('XFI200'			; //cGrupo   - Grupo de perguntas
      ,'04'    			; //cOrdem   - Ordem da pergunta
      ,'Qual moeda?'    ; //cPergunt - Pergunta em Portugues
      ,'Qual moeda?'    ; //cPerSpa  - Pergunta em Espanhol
      ,'Qual moeda?'    ; //cPerEng  - Pergunta em Ingles
      ,'mv_ch4'		    ; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par04'	   	; //cVar01   - Variavel 1
      ,'Moeda 1'		; //cDef01   - Definicao 1
      ,'Moneda 1       '; //cDefSpa1 - Definicao 1 Espanhol
      ,'Currency 1     '; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,'Moeda 2'		; //cDef02
	  ,'Moneda 2       '; //cDefSpa2
	  ,'Currency 2     '; //cDefEng2
	  ,'Moeda 3'		; //cDef03
	  ,'Moneda 3       '; //cDefSpa3
	  ,'Currency 3     '; //cDefEng3
	  ,'Moeda 4'		; //cDef04
	  ,'Moneda 4       '; //cDefSpa4
	  ,'Currency 4     '; //cDefEng4
	  ,'Moeda 5'		; //cDef05
	  ,'Moneda 5       '; //cDefSpa5
	  ,'Currency 5     '; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp

PutSx1('XFI200'		 	     ; //cGrupo   - Grupo de perguntas
      ,'05'    			     ; //cOrdem   - Ordem da pergunta
      ,'Consid.Ped.Compras ?'; //cPergunt - Pergunta em Portugues
      ,'Consid.Ped.Compras ?'; //cPerSpa  - Pergunta em Espanhol
      ,'Consid.Ped.Compras ?'; //cPerEng  - Pergunta em Ingles
      ,'mv_ch5'			     ; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,1				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par05'	   	; //cVar01   - Variavel 1
      ,'Sim'     		; //cDef01   - Definicao 1
      ,'Si 			   '; //cDefSpa1 - Definicao 1 Espanhol
      ,'Yes            '; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,'Nao'		   	; //cDef02
	  ,'No'				; //cDefSpa2
	  ,'No'				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp

PutSx1('XFI200'		 	     ; //cGrupo   - Grupo de perguntas
      ,'06'    			     ; //cOrdem   - Ordem da pergunta
      ,'Consid.Ped. Venda ? '; //cPergunt - Pergunta em Portugues
      ,'Consid.Ped. Venda ? '; //cPerSpa  - Pergunta em Espanhol
      ,'Consid.Ped. Venda ? '; //cPerEng  - Pergunta em Ingles
      ,'mv_ch6'			     ; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,1				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par06'	   	; //cVar01   - Variavel 1
      ,'Sim'     		; //cDef01   - Definicao 1
      ,'Si 			   '; //cDefSpa1 - Definicao 1 Espanhol
      ,'Yes            '; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,'Nao'		   	; //cDef02
	  ,'No'				; //cDefSpa2
	  ,'No'				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	  	 
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'07'    		    ; //cOrdem   - Ordem da pergunta
      ,'Nivel de quebra ?'; //cPergunt - Pergunta em Portugues
      ,'Nivel de quebra ?'; //cPerSpa  - Pergunta em Espanhol
      ,'Nivel de quebra ?'; //cPerEng  - Pergunta em Ingles
      ,'mv_ch7'			; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par07'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''               ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,'2'				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''  				; //cDefSpa2
	  ,''  				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	  		   

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'08'    		    ; //cOrdem   - Ordem da pergunta
      ,'Compoe Saldo Retroativo ?'; //cPergunt - Pergunta em Portugues
      ,'Compoe Saldo Retroativo ?'; //cPerSpa  - Pergunta em Espanhol
      ,'Compoe Saldo Retroativo ?'; //cPerEng  - Pergunta em Ingles
      ,'mv_ch8'			; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,2				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par08'	   	; //cVar01   - Variavel 1
      ,'Sim'       		; //cDef01   - Definicao 1
      ,'Sim'            ; //cDefSpa1 - Definicao 1 Espanhol
      ,'Sim'			; //cDefEng1 - Definicao 1 Ingles
      ,'2'				; //cCnt01
	  ,'Nao'   		   	; //cDef02
	  ,'Nao'			; //cDefSpa2
	  ,'Nao'			; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'09'    		    ; //cOrdem   - Ordem da pergunta
      ,'Considera Adiantam. ?'; //cPergunt - Pergunta em Portugues
      ,'Considera Adiantam. ?'; //cPerSpa  - Pergunta em Espanhol
      ,'Considera Adiantam. ?'; //cPerEng  - Pergunta em Ingles
      ,'mv_ch9'			; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,2				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par09'	   	; //cVar01   - Variavel 1
      ,'Sim'       		; //cDef01   - Definicao 1
      ,'Sim'            ; //cDefSpa1 - Definicao 1 Espanhol
      ,'Sim'			; //cDefEng1 - Definicao 1 Ingles
      ,'2'				; //cCnt01
	  ,'Nao'   		   	; //cDef02
	  ,'Nao'			; //cDefSpa2
	  ,'Nao'			; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	    		   

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'10'    		    ; //cOrdem   - Ordem da pergunta
      ,'Considera Filial ?            '; //cPergunt - Pergunta em Portugues
      ,'Considera Filial ?            '; //cPerSpa  - Pergunta em Espanhol
      ,'Considera Filial ?            '; //cPerEng  - Pergunta em Ingles
      ,'mv_cha'			; //cVar     - Variavel da pergunta
      ,'N'				; //cTipo    - Tipo da pergunta
      ,1				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,2				; //nPresel  - Pre selecao
      ,'C'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par10'	   	; //cVar01   - Variavel 1
      ,'Sim'       		; //cDef01   - Definicao 1
      ,'Sim'            ; //cDefSpa1 - Definicao 1 Espanhol
      ,'Sim'			; //cDefEng1 - Definicao 1 Ingles
      ,'2'				; //cCnt01
	  ,'Nao'   		   	; //cDef02
	  ,'Nao'			; //cDefSpa2
	  ,'Nao'			; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	    		  	  	   
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'11'    		    ; //cOrdem   - Ordem da pergunta
      ,'Da Filial ?                   '; //cPergunt - Pergunta em Portugues
      ,'Da Filial ?                   '; //cPerSpa  - Pergunta em Espanhol
      ,'Da Filial ?                   '; //cPerEng  - Pergunta em Ingles
      ,'mv_chb'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,2				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par11'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	    		  	  	  	   

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'12'    		    ; //cOrdem   - Ordem da pergunta
      ,'Ate Filial ?                   '; //cPergunt - Pergunta em Portugues
      ,'Ate Filial ?                   '; //cPerSpa  - Pergunta em Espanhol
      ,'Ate Filial ?                   '; //cPerEng  - Pergunta em Ingles
      ,'mv_chc'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,2				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par12'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	    		  	  	  	  	   
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'13'    		    ; //cOrdem   - Ordem da pergunta
      ,'Situacoes ?                   '; //cPergunt - Pergunta em Portugues
      ,'Situacoes ?                   '; //cPerSpa  - Pergunta em Espanhol
      ,'Situacoes ?                   '; //cPerEng  - Pergunta em Ingles
      ,'mv_chd'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,11				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par13'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,'01234567FGH'	; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	    		  	  	  	  	  	  

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'14'    		    ; //cOrdem   - Ordem da pergunta
      ,'Do Banco ?'		; //cPergunt - Pergunta em Portugues
      ,'Do Banco ?'		; //cPerSpa  - Pergunta em Espanhol
      ,'Do Banco ?'		; //cPerEng  - Pergunta em Ingles
      ,'mv_che'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,3				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,'SA6'			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par14'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'15'    		    ; //cOrdem   - Ordem da pergunta
      ,'Da Agencia ?'	; //cPergunt - Pergunta em Portugues
      ,'Da Agencia ?'	; //cPerSpa  - Pergunta em Espanhol
      ,'Da Agencia ?'	; //cPerEng  - Pergunta em Ingles
      ,'mv_chf'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,5				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''   		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par15'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	      		  	  	  	  	  	  
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'16'    		    ; //cOrdem   - Ordem da pergunta
      ,'Da Conta ?'		; //cPergunt - Pergunta em Portugues
      ,'Da Conta ?'		; //cPerSpa  - Pergunta em Espanhol
      ,'Da Conta ?'		; //cPerEng  - Pergunta em Ingles
      ,'mv_chg'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,10				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''   		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par16'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	      		  	  	  	  	  	  

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'17'    		    ; //cOrdem   - Ordem da pergunta
      ,'Ate Banco ?'		; //cPergunt - Pergunta em Portugues
      ,'Ate Banco ?'		; //cPerSpa  - Pergunta em Espanhol
      ,'Ate Banco ?'		; //cPerEng  - Pergunta em Ingles
      ,'mv_chh'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,3				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,'SA6'			    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par17'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	

PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'18'    		    ; //cOrdem   - Ordem da pergunta
      ,'Ate Agencia ?'	; //cPergunt - Pergunta em Portugues
      ,'Ate Agencia ?'	; //cPerSpa  - Pergunta em Espanhol
      ,'Ate Agencia ?'	; //cPerEng  - Pergunta em Ingles
      ,'mv_chi'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,5				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''   		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par18'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	      		  	  	  	  	  	  
	  
PutSx1('XFI200'		    ; //cGrupo   - Grupo de perguntas
      ,'19'    		    ; //cOrdem   - Ordem da pergunta
      ,'Ate Conta ?'		; //cPergunt - Pergunta em Portugues
      ,'Ate Conta ?'		; //cPerSpa  - Pergunta em Espanhol
      ,'Ate Conta ?'		; //cPerEng  - Pergunta em Ingles
      ,'mv_chj'			; //cVar     - Variavel da pergunta
      ,'C'				; //cTipo    - Tipo da pergunta
      ,10				; //nTamanho - Tamanho da pergunta
      ,0				; //nDecimal - Decimais da pergunta
      ,0				; //nPresel  - Pre selecao
      ,'G'			    ; //cGSC
      ,'' 				; //cValid   - Validacao da pergunta
      ,''   		    ; //cF3      - Consulta F3
      ,'' 				; //cGrpSxg
      ,'S'   			; //cPyme
      ,'mv_par19'	   	; //cVar01   - Variavel 1
      ,''       		; //cDef01   - Definicao 1
      ,''	            ; //cDefSpa1 - Definicao 1 Espanhol
      ,''				; //cDefEng1 - Definicao 1 Ingles
      ,''				; //cCnt01
	  ,''   		   	; //cDef02
	  ,''				; //cDefSpa2
	  ,''				; //cDefEng2
	  ,''  				; //cDef03
	  ,''				; //cDefSpa3
	  ,''				; //cDefEng3
	  ,''				; //cDef04
	  ,''				; //cDefSpa4
	  ,''				; //cDefEng4
	  ,''				; //cDef05
	  ,''				; //cDefSpa5
	  ,''				; //cDefEng5
	  ,{}				; //aHelpPor
	  ,{}				; //aHelpEng
	  ,{}				; //aHelpSpa
	  ,''				)	//cHelp	      		  	  	  	  	  	  
	  
Return
#include "Protheus.ch"
#include "rwmake.ch"  
#include "Topconn.ch"
#INCLUDE "ATFR110.CH"

Static lFWCodFil := FindFunction("FWCodFil")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ATFR110  ³ Autor ³ Wagner Xavier         ³ Data ³ 03.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao das aquisicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe 	 ³ ATFR110                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function ATFR110x

Local oReport
Local lRetorno	:= .T.
Local aArea		:= SM0->( GetArea() )
Local cFlAnt	:= cFilAnt
Private aSelClass := {} //Filtro de classificações patrimoniais

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // a partir da data                  ³
//³ mv_par02            // ate a data                        ³
//³ mv_par03            // da conta                          ³
//³ mv_par04            // ate a conta                       ³
//³ mv_par05            // do centro de custo                ³
//³ mv_par06            // ate o centro de custo             ³
//³ mv_par07            // valores na moeda                  ³
//³ mv_par08            // Considera itens baixados			 ³
//³ mv_par09            // Considera filiais abaixo			 ³
//³ mv_par10            // filial de						 ³
//³ mv_par11            // filial ate						 ³
//³ mv_par12            // Considera itens (Norm, Ad, Ambos) ³
//³ mv_par13            // Selec Classif Patrimonial?        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CriaSX1("AFR110")

Pergunte( "AFR110" , .F. )


If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	
	// Verificacao de seguranca para executar versao R4
	If Valtype(oReport) == 'O'
		oReport:PrintDialog()
	Else
		lRetorno := .F.
	EndIf
	
	oReport := Nil
Else
	lRetorno := U_ATFR110R3x() // Executa versao R3
EndIf

RestArea( aArea	)
cFilAnt	:= cFlAnt
Return lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Claudio D. de Souza    ³ Data ³28/06/2006  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os   ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ 30/03/99 ³ Alice         ³Reposicionar o relat¢rio. Conta com tamanho 20³±±
±±³ 20/04/99 ³ Alice         ³Alteracao de macro.                           ³±±
±±³ 28/08/09 ³ William Pires ³Revisao e correcao das funcoes que auxiliam a ³±±
±±³			 |		         |construcao do relatorio.						³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(cRespINI,cRespFIM,cCBASEINI,cItemINI,cCBaseFIM,cItemFIM)

Local oReport, oSection1, oSection11
Local cReport 	:= "ATFR110"
Local cTitulo 	:= STR0003 // "Relacao dos bens adquiridos"
Local cDescri 	:= STR0001 + " " + STR0002 // "Este programa ira' emitir a rela‡„o das aquisi‡”es efetuadas dentro de um periodo."

// Definicao do Titulo do Relatorio no momento da impressao
Local bReport 	:= { |oReport|	cMoeda := Str(mv_par07,1),;
oReport:SetTitle(oReport:Title() + OemToAnsi(STR0009)+; // " por "
aOrd[oSection1:nOrder] + OemToAnsi(STR0010) +; //" em "
Getmv("MV_MOEDA" + cMoeda) + OemToAnsi(STR0011) +; //" entre "
DTOC(mv_par01) + OemToAnsi(STR0012) + DTOC(mv_par02)),; // " a "
ReportPrint( oReport ) }
Local cMoeda 	:= ""
Local aOrd 		:= {}
Local aArea		:= GetArea()
Local aAreaSX3 	:= SX3->(GetArea())
Local lQuery	:= .F. //variavel de controle para execucao de query



// Forca a abertura do SN1
DbSelectArea("SN1")

aOrd := {OemToAnsi(STR0004),; // "Conta"
OemToAnsi(STR0005),; // "C Custo"
OemToAnsi(STR0006)}  // "Data Aquisicao"

cMoeda := Str(mv_par07,1)

// Inicio da construcao do layout do relatorio
oReport  := TReport():New( cReport, cTitulo, "AFR110" , bReport, cDescri )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio Valores nas Moedas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport, STR0021, {"SN3" } , aOrd ) // "Dados do Bem"
TRCell():New( oSection1, "N3_CBASE"  	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_ITEM"   	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_DESCRIC"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_AQUISIC"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_QUANTD" 	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_NFISCAL"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_CHAPA"	  	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_GRUPO"	  	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CCUSTO" 	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_Local"	  	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_FORNEC" 	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N1_LOJA"   	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "A2_NREDUZ" 	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_DINDEPR"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_TXDEPR"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_VORIG"		, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_VRDACM"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_VRCACM"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_DTBAIXA"  	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CCONTAB"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CCORREC"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CDEPREC"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CCDEPR"	, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oSection1, "N3_CDESP"		, ,/*X3Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:SetLineBreak()
oSection1:SetTotalInLine(.T.)
oSection1:SetHeaderPage(.T.)

oReport:SetLandScape()

RestArea(aAreaSx3)
RestArea(aArea)

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Claudio D. de Souza º Data ³  23/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query de impressao do relatorio                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAATF                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )

Local oSection1 	:= oReport:Section(1)
Local cChave		:= ""
Local cChaveSQL		:= ""
Local cQuery 		:= ""
Local nOrder   		:= oSection1:nOrder
Local cMoeda		:= Str(mv_par07,1)
Local cWhere		:= ""
Local cBemAnt		:= ""
Local bTitle 		:= { |cCampo| SX3->(DbSetOrder(2)), SX3->(MsSeek(cCampo)), X3Titulo() }
Local cFilDe 		:= ""
Local cFilAte		:= ""
Local oBreak1
Local oBreak2
Local bVOrig
Local oTotOrdem
Local oTotFil
Local oTotGer
Local cFilRep		:= ""
Local cFilBrk		:= ""
Local cContaBrk		:= ""
Local cCustoBrk 	:= ""
Local dAquisBrk 	:= ""
Local cAliasSN3		:= "SN3"
Local cFiltro		:= ""
Local cFilterUser 	:= ""
Local lQuery		:= .F. //variavel de controle para execucao de query

// Verificação da classificação de Ativo se sofre depreciação
Local lAtClDepr 	:= .F.
Local cFilBkp
Local cChaveAux

If mv_par13 == 1 .And. FindFunction("AdmGetClass")
	aSelClass := AdmGetClass()
	If Len( aSelClass ) <= 0
		Return
	EndIf
EndIf

#IFDEF TOP
	lQuery := !(TcSrvType() == "AS/400" .Or. TcSrvType() == "iSeries") // somente ira executar a query se nao for AS400
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza registro inicial                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChave := GetChave( lQuery, nOrder )

// Retorna o o filtro escolhido pelo usuario
cUserFilter := oSection1:GetAdvplExp( "SN3" )

// Efetua o filtro para o relatorio
Atf110Tmp( @cAliasSN3, @cChave, @cFiltro, cUserFilter )

// Montagem da quebra do relatorio
IF nOrder == 1
	SN3->(dbSetOrder(2))
	oBreak1 := TRBreak():New( oSection1, {|| (cAliasSN3)->(N3_FILIAL+N3_CCONTAB)}, STR0022 + " : " + (cAliasSN3)->N3_CCONTAB) // "Total da Conta"
	
ElseIf nOrder == 2
	SN3->(dbSetOrder(3))
	oBreak1 := TRBreak():New( oSection1, {|| (cAliasSN3)->(N3_FILIAL+N3_CCUSTO)}, STR0023 + " : " + (cAliasSN3)->N3_CCUSTO) // "Total do Centro de Custo"
	
ElseIf nOrder == 3
	If !lQuery
		SN3->( dbSetOrder( Atfr110Idx( "SN3" , cChave, lQuery ) ) ) //seta indice por data em dbf
	EndIf
	oBreak1 := TRBreak():New( oSection1, {|| (cAliasSN3)->N3_FILIAL+DTOS((cAliasSN3)->N3_AQUISIC)}, STR0024 + " : " + DTOS((cAliasSN3)->N3_AQUISIC)) // "Total da Data de Aquisição"
	
End

oBreak2:= TRBreak():New(oSection1, {|| (cAliasSN3)->(N3_FILIAL) }, {|| STR0025+(cAliasSN3)->(N3_FILIAL) } ) //"TOTAL FILIAL:

oSection1:SetLineCondition({|| If(	(cAliasSN3)->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO) != cBemAnt,;
(cBemAnt := (cAliasSN3)->(N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO), .T.),.F.) } )

If lQuery //top
	TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+(cAliasSN3)->(N1_FORNEC+N1_LOJA)})
	// Verificação da classificação de Ativo se sofre depreciação
	lAtClDepr := Iif(FindFunction("AtClssVer"),AtClssVer((cAliasSN3)->N1_PATRIM),(cAliasSN3)->N1_PATRIM $ "NID")
	
	bVOrig := { || 	cFilBrk 	:= (cAliasSN3)->N3_FILIAL, cContaBrk 	:= (cAliasSN3)->N3_CCONTAB, cCustoBrk 	:= (cAliasSN3)->N3_CCUSTO,;
	dAquisBrk 	:= (cAliasSN3)->N3_AQUISIC,;
	nValor 		:= 	Af110VOrig((cAliasSN3)->N3_FILIAL,cMoeda,(cAliasSN3)->N3_CBASE,(cAliasSN3)->N3_ITEM,(cAliasSN3)->N3_TIPO),;
	Iif(lAtClDepr .OR. (cAliasSN3)->N1_PATRIM $ " P",nValor,nValor*(-1)) }
Else //dbf
	
	oSection1:SetFilter(cFiltro,cChave)
	
	TRPosition():New(oSection1,"SN1",1,{|| xFilial("SN1")+SN3->(N3_CBASE+N3_ITEM) })
	TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SN1->(N1_FORNEC+N1_LOJA)})
	
	// Verificação da classificação de Ativo se sofre depreciação
	lAtClDepr := Iif(FindFunction("AtClssVer"),AtClssVer(SN1->N1_PATRIM),SN1->N1_PATRIM $ "NID")
	bVOrig := { || 	cFilBrk 	:= (cAliasSN3)->N3_FILIAL, cContaBrk 	:= (cAliasSN3)->N3_CCONTAB, cCustoBrk 	:= (cAliasSN3)->N3_CCUSTO,;
	dAquisBrk 	:= (cAliasSN3)->N3_AQUISIC,;
	nValor 		:= 	Af110VOrig((cAliasSN3)->N3_FILIAL,cMoeda,(cAliasSN3)->N3_CBASE,(cAliasSN3)->N3_ITEM,(cAliasSN3)->N3_TIPO),;
	Iif(lAtClDepr .OR. SN1->N1_PATRIM $ " P",nValor,nValor*(-1)) }
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio Valores nas Moedas com os campos das tabelas A2 e N1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cAliasSN3 == 'SN3'
	oSection1:Cell("A2_NREDUZ" 	):SetBlock( {|| SA2->A2_NREDUZ  	})
	oSection1:Cell("N3_DTBAIXA"  	):SetBlock( {|| (cAliasSN3)->N3_DTBAIXA  		})
	oSection1:Cell("N1_DESCRIC"	):SetBlock( {|| SN1->N1_DESCRIC		})
	oSection1:Cell("N1_QUANTD" 	):SetBlock( {|| SN1->N1_QUANTD 		})
	oSection1:Cell("N1_NFISCAL"	):SetBlock( {|| SN1->N1_NFISCAL		})
	oSection1:Cell("N1_CHAPA"	):SetBlock( {|| SN1->N1_CHAPA		})
	oSection1:Cell("N1_GRUPO"	):SetBlock( {|| SN1->N1_GRUPO		})
	oSection1:Cell("N1_Local"	):SetBlock( {|| SN1->N1_Local		})
	oSection1:Cell("N1_FORNEC" 	):SetBlock( {|| SN1->N1_FORNEC 		})
	oSection1:Cell("N1_LOJA"   	):SetBlock( {|| SN1->N1_LOJA   		})
Else
	oSection1:Cell("A2_NREDUZ" 	):SetBlock( {|| SA2->A2_NREDUZ })
	oSection1:Cell("N3_DTBAIXA"  	):SetBlock( {|| (cAliasSN3)->N3_DTBAIXA })
	oSection1:Cell("N1_DESCRIC"	):SetBlock( {|| (cAliasSN3)->N1_DESCRIC})
	oSection1:Cell("N1_QUANTD" 	):SetBlock( {|| (cAliasSN3)->N1_QUANTD })
	oSection1:Cell("N1_NFISCAL"	):SetBlock( {|| (cAliasSN3)->N1_NFISCAL})
	oSection1:Cell("N1_CHAPA"	):SetBlock( {|| (cAliasSN3)->N1_CHAPA	})
	oSection1:Cell("N1_GRUPO"	):SetBlock( {|| (cAliasSN3)->N1_GRUPO	})
	oSection1:Cell("N1_Local"	):SetBlock( {|| (cAliasSN3)->N1_Local	})
	oSection1:Cell("N1_FORNEC" 	):SetBlock( {|| (cAliasSN3)->N1_FORNEC })
	oSection1:Cell("N1_LOJA"   	):SetBlock( {|| (cAliasSN3)->N1_LOJA   })
EndIf

oSection1:Cell("N3_CBASE"  	):SetBlock( {|| (cAliasSN3)->N3_CBASE  	})
oSection1:Cell("N3_ITEM"   	):SetBlock( {|| (cAliasSN3)->N3_ITEM   	})
oSection1:Cell("N3_AQUISIC"	):SetBlock( {|| (cAliasSN3)->N3_AQUISIC	})
oSection1:Cell("N3_CCUSTO" 	):SetBlock( {|| (cAliasSN3)->N3_CCUSTO 	})
oSection1:Cell("N3_DINDEPR"	):SetBlock( {|| (cAliasSN3)->N3_DINDEPR	})
oSection1:Cell("N3_TXDEPR"	):SetBlock( {|| &(cAliasSN3 + "->N3_TXDEPR" + cMoeda)})
oSection1:Cell("N3_VORIG"	):SetBlock( {|| &(cAliasSN3 + "->N3_VORIG"  + cMoeda)})
oSection1:Cell("N3_VRDACM"	):SetBlock( {|| &(cAliasSN3 + "->N3_VRDACM" + cMoeda)})
oSection1:Cell("N3_VRCACM"	):SetBlock( {|| (cAliasSN3)->N3_VRCACM1 })
oSection1:Cell("N3_CCONTAB"	):SetBlock( {|| (cAliasSN3)->N3_CCONTAB	})
oSection1:Cell("N3_CCORREC"	):SetBlock( {|| (cAliasSN3)->N3_CCORREC	})
oSection1:Cell("N3_CDEPREC"	):SetBlock( {|| (cAliasSN3)->N3_CDEPREC	})
oSection1:Cell("N3_CCDEPR"	):SetBlock( {|| (cAliasSN3)->N3_CCDEPR 	})
oSection1:Cell("N3_CDESP"	):SetBlock( {|| (cAliasSN3)->N3_CDESP		})

oSection1:SetLineBreak()

oBreak1:SetTotalText( { ||  Iif(nOrder == 1, STR0022+" : "+cContaBrk, Iif(nOrder == 2, STR0023+" : "+cCustoBrk, STR0024+" : "+DTOC(dAquisBrk)))} )
oBreak2:SetTotalText( { ||  STR0025+cFilBrk } )

//oTotOrdem	:= TRFunction():New(oSection1:Cell("N3_VORIG")	,, "SUM"	,oBreak1 	,,,(cAliasSN3 + "->N3_VORIG"  + cMoeda)		,.F.,.F.,.F.,oSection1)
//oTotFil		:= TRFunction():New(oSection1:Cell("N3_VORIG")	,, "SUM"	,oBreak2 	,,,(cAliasSN3 + "->N3_VORIG"  + cMoeda)		,.F.,.F.,.F.,oSection1)
oTotOrdem	:= TRFunction():New(oSection1:Cell("N3_VORIG")	,, "SUM"	,oBreak1 	,,,bVOrig		,.F.,.F.,.F.,oSection1)
oTotFil		:= TRFunction():New(oSection1:Cell("N3_VORIG")	,, "SUM"	,oBreak2 	,,,bVOrig		,.F.,.F.,.F.,oSection1)
oTotGer		:= TRFunction():New(oSection1:Cell("N3_VORIG")	,, "SUM"	,			,,,				,.F.,.T.)

oReport:SetMeter(RecCount())
oReport:SetTotalText(STR0017) //"TOTAL GERAL: "
oReport:SetTotalInLine(.F.)

If lQuery
	cFilBkp := cFilAnt
	If nOrder == 3
		cChaveAux := StrTran(cChave, ",", "+")
		cChaveAux := StrTran(cChaveAux, "N3_AQUISIC", "DTOS(N3_AQUISIC)")
	Else
		cChaveAux := StrTran(cChave, ",", "+")    //Necessario pois vai executar macro da expressao contida em cChave
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Init()
	While (cAliasSN3)->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		
		cFilRep := (cAliasSN3)->N3_FILIAL
		If !Empty( (cAliasSN3)->N3_FILIAL )
			cFilAnt := (cAliasSN3)->N3_FILIAL
		EndIf
		
		While (cAliasSN3)->(!Eof()) .And. (cAliasSN3)->N3_FILIAL == cFilRep
			cQuebra := (cAliasSN3)->(&cChaveAux)
			While (cAliasSN3)->(!Eof()) .And. (cAliasSN3)->(&cChaveAux) == cQuebra
				// Necessario para imprimir campos adicionados pelo usuario em tempo de execucao
				SN3->( DBGOTO( (cAliasSN3)->RECNOSN3 ) )
				
				oSection1:PrintLine()
				(cAliasSN3)->(DbSkip())
			EndDo
		EndDo
		
		oReport:SkipLine()
		oReport:IncMeter()
	EndDo
	oSection1:Finish()
	cFilAnt := cFilBkp
Else
	oSection1:Init()
	oSection1:Print()
	oSection1:Finish()
EndIf

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ATFR110R3 ³ Autor ³ Wagner Xavier         ³ Data ³ 03.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao das aquisicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ATFR110R3                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ATFR110R3x

Local cString:= "SN3"
Local cDesc1 := OemToAnsi(STR0001) // "Este programa ira' emitir a rela‡„o das aquisi‡”es"
Local cDesc2 := OemToAnsi(STR0002) // "efetuadas dentro de um periodo."
Local cDesc3 := ""
Local wnrel
Local lQuery := .F. //variavel de controle de query

Private aReturn  := { OemToAnsi(STR0018), 1,OemToAnsi(STR0019), 2, 2, 1, "",1 } // "Zebrado" ; "Administracao"
Private aLinha   := { }
Private cPerg    := "AFR110"
Private nomeprog := "ATFR110"
Private nLastKey := 0

Private tamanho  := "M"
Private titulo   := OemToAnsi(STR0003) // "Relacao dos bens adquiridos"
Private cabec1
Private cabec2
Private cabec3
Private nTamCC	 := Len(SN3->N3_CCUSTO)

#IFDEF TOP
	lQuery := !(TcSrvType() == "AS/400" .or. TcSrvType() == "iSeries") // somente ira executar a query se nao for AS400
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( "AFR110",.F.)



wnrel := "ATFR110"
aOrd  := { 	OemToAnsi(STR0004),; // "Conta"
OemToAnsi(STR0005),; // "C Custo"
OemToAnsi(STR0006)} // "Data Aquisicao"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

// Termina a execucao se o usuario clicar no botao Cancelar ou fechar a tela (ESC)
If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If lQuery //top
	RptStatus({|lEnd| u__xFR110ImpT(@lEnd,wnRel,cString)},Titulo)
Else //dbf
	RptStatus({|lEnd| u_xFR110Imp(@lEnd,wnRel,cString)},Titulo)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FR110IMP ³ Autor ³ Wagner Xavier         ³ Data ³ 03.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao das aquisicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FR110IMP(lEnd,WnRel,Titulo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES REALIZADAS DESDE A CONSTRU€AO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³C. Denardi  ³06/10/03³66.785³Localizacao de casas decimais na Picture  ³±±
±±³            ³        ³      ³em todos os relatorios do Ativo Fixo      ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xFR110Imp(lEnd,WnRel,cString)

Local nTotValor 	:= 0
Local nGerValor		:= 0
Local nOrdem		:= 0
Local nOrder		:= 0
Local nRec
Local cBase
Local cItem
Local cTipo
Local cBemAnt		:= " "
Local cIndice
Local CbTxt
Local cbCont
Local nMoeda		:= 0
Local nVOrig		:= 0
Local cFilDe 		:= ""
Local cFilAte		:= ""
Local nFilValor		:= 0
Local aAreaSM0		:= SM0->(GetArea())
Local cUserFilter	:= aReturn[7]
Local cAuxFilter 	:= cUserFilter
Local cFiltro		:= ""
Local lQuery		:= .F.
Local lSkip			:= .T.
Local nInc			:= 0
Local aSM0			:= {}
Local cAuxFil		:= cFilAnt
// Verificação da classificação de Ativo se sofre depreciação
Local lAtClDepr 	:= .F.

If mv_par13 == 1 .And. FindFunction("AdmGetClass")
	aSelClass := AdmGetClass()
EndIf

#IFDEF TOP
	lQuery := !(TcSrvType() == "AS/400" .or. TcSrvType() == "iSeries") // somente ira executar a query se nao for AS400
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := Space(10)
cbcont   := 0
cabec1   := OemToAnsi(STR0007) // "Base       Item Descricao                                Aquisic.   Quantidade   Nota Fisc. Chapa    Grupo    C. Custo  Localizacao"

//                                  XXXXXXXXXX XXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999 9.999.999,99 XXXXXX     XXXXXX   XXXX     XXXXXXXXX XX
//                                  01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^
//                                            1         2         3         4         5         6         7         8         9         0         1         2         3
//                                                                                                                                      1
cabec2   := OemToAnsi(STR0008) // "                In.Depr.  Tx.Depr.       Valor Original    Deprec. Acumulada   Correcao Acumulada"
li       := 80
m_pag    := 1

nOrdem   := aReturn[8]
nMoeda   := mv_par07
cMoeda   := Str(nMoeda,1)
titulo   := Trim( titulo ) + OemToAnsi(STR0009) + ; // " por "
aOrd[nOrdem]+OemToAnsi(STR0010) + ; // " em "
Getmv("MV_MOEDA" + cMoeda) + '-' + ;
DTOC(mv_par01) + OemToAnsi(STR0012) + DTOC(mv_par02) // " a "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par09 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
Else
	cFilDe := mv_par10	// Todas as filiais
	cFilAte:= mv_par11
EndIf

aSM0 := AdmAbreSM0()
For nInc := 1 To Len( aSM0 )
	If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] <= cFilAte
		cBemAnt	:= ""
		cFilAnt := aSM0[nInc][2]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza registro inicial                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF nOrdem == 1
			cChave := xFilial("SN3")
			
			If ! Empty( mv_par03 )
				cChave += mv_par03
			Endif
			
			SN3->( dbSetOrder(4) )
			SN3->( dbSeek(cChave , .T. ) )
			
			cCond1 := "SN3->N3_CCONTAB <= mv_par04"
			cCond2 := "cQuebra == SN3->N3_CCONTAB"
			
		ElseIF nOrdem == 2
			cChave := xFilial("SN3")
			
			If ! Empty( mv_par05 )
				cChave += mv_par05
			Endif
			
			SN3->( dbSetOrder(5) )
			SN3->( dbSeek(cChave , .T. ) )
			
			cCond1:="SN3->N3_CCUSTO <= mv_par06"
			cCond2:="cQuebra == SN3->N3_CCUSTO"
			
		ElseIF nOrdem == 3
			cIndice := CriaTrab(Nil,.f.)
			
			cChave  := "N3_FILIAL + DTOS(N3_AQUISIC) + N3_CBASE + N3_ITEM"
			
			Atf110Tmp( Nil ,@cChave, @cFiltro, cUserFilter )
			
			IndRegua("SN3",cIndice,cChave,,cFiltro,OemToAnsi(STR0020))
			
			nIndex  := RetIndex("SN3")
			dbSelectArea("SN3")
			
			If !lQuery // dbf
				dbSetIndex(cIndice+OrdBagExt())
			EndIf
			
			dbSetOrder(nIndex+1)
			DbGoTop()
			
			cCond1 := "!Eof()"
			cCond2 := "cQuebra == SN3->N3_AQUISIC"
		End
		
		SetRegua( SN3->(RecCount()) )
		
		While SN3->N3_FILIAL == xFilial("SN3") .And. &cCond1 .And. SN3->(!Eof())
			
			dbSelectArea("SN3")
			
			If  nOrdem == 1
				cQuebra := SN3->N3_CCONTAB
				
			ElseIf nOrdem == 2
				cQuebra := SN3->N3_CCUSTO
				
			ElseIf nOrdem == 3
				cQuebra := SN3->N3_AQUISIC
			EndIf
			
			IncRegua()
			
			If SN3->N3_TIPO != "01" // Empty(cQuebra) .or.  RETIRADO PARA IMPRIMIR AQUISICOES COM QUEBRA EM BRANCO
				SN3->(dbSkip())
				Loop
			EndIf
			
			cBemAnt := ""
			
			While SN3->N3_FILIAL  == xFilial("SN3") .And. &cCond1 .AND. &cCond2 .And. SN3->( !Eof() )
				
				IncRegua()
				
				If lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0013) // "CANCELADO PELO OPERADOR"
					Exit
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So' devera ser impresso uma vez o bem no relatorio ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SN3->N3_CBASE + SN3->N3_ITEM + SN3->N3_TIPO == cBemAnt
					SN3->(dbSkip())
					Loop
				EndIf
				
				cBemAnt := SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se data de aquisicao satisfaz a condicao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SN3->N3_AQUISIC < mv_par01 .or. SN3->N3_AQUISIC > mv_par02
					SN3->(dbSkip())
					Loop
				EndIf
				
				If SN3->N3_CCONTAB < mv_par03 .or. SN3->N3_CCONTAB > mv_par04
					SN3->(dbSkip())
					Loop
				EndIf
				
				If SN3->N3_CCUSTO < mv_par05 .or. SN3->N3_CCUSTO > mv_par06
					SN3->(dbSkip())
					Loop
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se considera itens baixados ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF mv_par08 == 2 .And. Val( SN3->N3_BAIXA ) # 0
					SN3->( dbSkip() )
					Loop
				EndIf
				
				// Filtro especifico para COLOMBIA quanto aos tipos de aquisicao
				If cPaisLoc == "COL"
					If SN3->N3_TIPO $ ("10/12/50/51/52/53/54")
						lSkip := .F.
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o tipo do registro para impressao         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par12 == 1 .AND. SN3->N3_TIPO != "01" .AND. lSkip // Somente Itens normais
					dbSkip()
					Loop
					
				ElseIf mv_par12 == 2 .AND. SN3->N3_TIPO != "03" // Somente Itens Adiantamentos
					dbSkip()
					Loop
					
				ElseIf mv_par12 == 3 .AND. ( SN3->N3_TIPO != "01" .And. lSkip ) .AND. SN3->N3_TIPO != "03" // Ambos os itens
					dbSkip()
					Loop
				EndIf
				
				
				
				cBase := SN3->N3_CBASE
				cItem := SN3->N3_ITEM
				cTipo := SN3->N3_TIPO
				nVOrig:= Af110VOrig(SN3->N3_FILIAL,cMoeda,SN3->N3_CBASE,SN3->N3_ITEM,SN3->N3_TIPO)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se houve baixas parciais do item, pois se ³
				//³ existe, o item j   ser   impresso.                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF Val( SN3->N3_BAIXA ) # 0
					nRec  := SN3->( Recno () )
					nOrder := SN3->( IndexOrd() )
					
					SN3->( dbSetOrder ( 1 ) )
					SN3->( dbSeek(cFilial+cBase+cItem+cTipo+'0') )
					
					IF SN3->( Found() )
						SN3->( dbGoto ( nRec ) )
						SN3->( dbSetOrder ( nOrder ) )
						SN3->( dbSkip() )
						Loop
					EndIf
					
					SN3->( dbGoto ( nRec ) )
					SN3->( dbSetOrder ( nOrder ) )
				End
				
				IF li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				End
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Localiza item no SN1                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SN1->( dbSeek(cFilial + cBASE + cITEM) )
				
				//Verifica se filtra as classificações patrimoniais
				If Len(aSelClass) > 0  .And.  FindFunction("FormatClas")
					If !(SN1->N1_PATRIM $ FormatClass(aSelClass,.F.))
						SN3->(dbSkip())
						Loop
					EndIf
				EndIf
				
				dbSelectArea("SN3")
				
				@ li,  0    PSAY    SN3->N3_CBASE
				@ li, 11    PSAY    SN3->N3_ITEM
				@ li, 16    PSAY    SubS(SN1->N1_DESCRIC,1,40)
				@ li, 57    PSAY    SN3->N3_AQUISIC
				@ li, 68    PSAY    SN1->N1_QUANTD  PICTURE PesqPict("SN1","N1_QUANTD",12)
				@ li, 81    PSAY    SN1->N1_NFISCAL
				@ li,103    PSAY    SN1->N1_CHAPA
				@ li,112    PSAY    SN1->N1_GRUPO
				
				If nTamCC < 10
					@ li,121 PSAY    SN3->N3_CCUSTO
				Endif
				
				@ li,131 PSAY SN1->N1_Local
				li ++
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se Houver fornecedor, imprime o nome  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ! Empty( SN1->N1_FORNEC )
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SA2") + SN1->N1_FORNEC + SN1->N1_LOJA )
						@ li,00             PSAY OemToAnsi(STR0014) // "FORNECEDOR "
						@Prow(),Pcol()      PSAY SN1->N1_FORNEC + "-" + SN1->N1_LOJA
						@Prow(),Pcol()+2    PSAY SA2->A2_NREDUZ
						li ++
					Endif
					
					dbSelectArea("SN3")
				Endif
				
				@ li, 16    PSAY    SN3->N3_DINDEPR
				@ li, 26    PSAY    &('SN3->N3_TXDEPR'+cMoeda)   PICTURE PesqPict("SN3","N3_TXDEPR"+cMoeda,  8,nMoeda)
				@ li, 36    PSAY    nVOrig    PICTURE PesqPict("SN3","N3_VORIG" +cMoeda, 19,nMoeda)
				@ li, 57    PSAY    &('SN3->N3_VRDACM'+cMoeda)   PICTURE PesqPict("SN3","N3_VRDACM"+cMoeda, 19,nMoeda)
				
				IF MV_PAR07 == 1
					@ li, 78    PSAY    SN3->N3_VRCACM1 PICTURE PesqPict("SN3","N3_VRCACM1", 19)
				End
				
				@ li, 99 PSAY SN3->N3_DTBAIXA
				
				If nTamCC > 9
					@ li,110 PSAY SN3->N3_CCUSTO
				Endif
				
				li++
				@ li, 16    PSAY    OemToAnsi(STR0015) // "Conta do Bem         Conta Correcao       Cta.Desp.Depr.       Cta.Depr.Acum.       Cta.Corr.Depr. "
				//                                                XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX
				//                                                678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^6789
				//                                                    2         3         4         5         6         7         8         9         0         1
				//                                                                                                                                    1
				li++
				@ li, 16    PSAY     SN3->N3_CCONTAB
				@ li, 37    PSAY     SN3->N3_CCORREC
				@ li, 58    PSAY     SN3->N3_CDEPREC
				@ li, 79    PSAY     SN3->N3_CCDEPR
				@ li, 100   PSAY     SN3->N3_CDESP
				
				dbSelectArea("SN3")
				
				// Verificação da classificação de Ativo se sofre depreciação
				lAtClDepr := Iif(FindFunction("AtClssVer"),AtClssVer(SN1->N1_PATRIM),SN1->N1_PATRIM $ "NID")
				
				If lAtClDepr .OR. SN1->N1_PATRIM $ " P"
					nTotValor += nVOrig
				Else
					nTotValor -= nVOrig
				Endif
				
				li+=2
				SN3->(dbSkip())
			End
			
			IF (nTotValor) <> 0
				IF li > 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				Endif
				@  li,  0 PSAY OemToAnsi(STR0016) // "TOTAL : "
				@  li,  8 PSAY cQuebra
				@  li, 34 PSAY nTotValor    PICTURE PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
				li++
				@  li, 0 PSAY Replicate("-",137)
				li++
				nGerValor+=nTotValor
				nFilValor+=nTotValor
				nTotValor:=0
			End
		End
		If mv_par09 == 1 .and. SM0->(Reccount()) > 1
			If li+3 >= 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			Endif
			@li,000 PSAY "T O T A L   F I L I A L ----> "+" "+Iif(mv_par09==1,cFilAnt+" - " + AllTrim( aSM0[nInc][7] ),"")
			@  li, pCol() + 2 PSAY nFilValor    PICTURE PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
			li++
			@  li, 0 PSAY Replicate("-",137)
			li++
			nFilValor:=0
		Endif
		If Empty(xFilial("SN3"))
			Exit
		Endif
	EndIf
Next

// Restaura a Filial Atual
cFilAnt := cAuxFil
IF li<> 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	Endif
	@  li, 0    PSAY OemToAnsi(STR0017) // "TOTAL GERAL: "
	@  li, 36   PSAY nGerValor      PICTURE  PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
	roda(cbcont,cbtxt)
End

IF nOrdem == 3
	nIndex     := RetIndex("SN3")
	Ferase(cIndice+IndexExt())
End


dbClearFilter()

RetIndex("SN3")

If aReturn[5] = 1
	Set Printer To 
	dbCommitAll()
	Ourspool(wnrel)
End

MS_FLUSH()

Return



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AFR110Filt ³ Autor ³ Cesar C S Prado       ³ Data ³ 03.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Filtra indice alternativo no periodo solicitado              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void AFR110Filtro()                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AFR110Filtro()
Local cFiltro

cFiltro := 'N3_FILIAL == "'  + xFilial("SN3")  + '" .And. '
cFiltro += 'DTOS(N3_AQUISIC) >= "' + DtoS( mv_par01) + '" .And. '
cFiltro += 'DTOS(N3_AQUISIC) <= "' + DtoS( mv_par02) + '" .AND. '
If mv_par12 == 1 // Itens normais
	cFiltro += 'N3_TIPO $ "01*10"'
Endif
If mv_par12 == 2 // Itens Adiantamentos
	cFiltro += 'N3_TIPO == "03"'
Endif
If mv_par12 == 3 // Itens normais e adiantamentos
	cFiltro += '(N3_TIPO $ "01*10" .Or. N3_TIPO == "03")'
Endif

If mv_par13 == 1 // Filtra classificação patrimonial
	If Len(aSelClass) > 0  .And.  FindFunction("FormatClas")
		cFiltro += ' .And. (N1_PATRIM $ ' +  FormatClass(aSelClass,.F.) +  ')'
	EndIf
Endif

Return cFiltro


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Af110VOrig³ Autor ³ Claudio D. de Souza   ³ Data ³ 23/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o valor original do bem                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ATFR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Af110VOrig(cFilSN3,cMoeda,cBase,cItem,cTipo)
Local aAreaSn3 := SN3->(GetArea())
Local nVOrig := 0

SN3->(DbSetOrder(1))
SN3->(MsSeek(cFilSN3+cBase+cItem+cTipo))

While SN3->(!Eof()) .And. SN3->(N3_FILIAL+N3_CBASE+N3_ITEM+SN3->N3_TIPO) == cFilSN3+cBase+cItem+cTipo
	nVOrig += SN3->&("N3_VORIG"+cMoeda)
	SN3->(DbSkip())
End
SN3->(RestArea(aAreaSn3))

Return nVOrig


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FR110IMPT³ Autor ³ Wagner Xavier         ³ Data ³ 03.08.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao das aquisicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FR110IMPT(lEnd,WnRel,Titulo)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES REALIZADAS DESDE A CONSTRU€AO INICIAL.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³C. Denardi  ³06/10/03³66.785³Localizacao de casas decimais na Picture  ³±±
±±³            ³        ³      ³em todos os relatorios do Ativo Fixo      ³±±
±±³W. Pires    ³28/08/09³      ³Adicionada a funcao Atf110Tmp, que retorna³±±
±±³            ³        ³      ³o filtro da query do relatorio			  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _xFR110ImpT(lEnd,WnRel,cString)

Local nTotValor := 0
Local nGerValor := 0
Local nOrdem    := 0
Local nOrder    := 0
Local nRec
Local cBase
Local cItem
Local cTipo
Local cBemAnt   := " "
Local cIndice
Local CbTxt
Local cbCont
Local nMoeda   	:= 0
Local nVOrig	:= 0
Local cFilDe
Local cFilAte
Local nFilValor := 0
Local aAreaSM0 	:= SM0->(GetArea())
Local cUserFilter := aReturn[7]
Local cAuxFilter := cUserFilter
Local cQuery := ""
Local aR110Campos := {}
Local i := 0
Local cValCampo := ""
Local cChave	:= ""
Local cFiltro	:= ""
Local TRB		:= ""
Local lQuery	:= .T. // Esta function trabalha Query
Local cAuxFil	:= cFilAnt

// Verificação da classificação de Ativo se sofre depreciação
Local lAtClDepr := .F.

If mv_par13 == 1 .And. FindFunction("AdmGetClass")
	aSelClass := AdmGetClass()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt	:= Space(10)
cbcont	:= 0
cabec1	:= OemToAnsi(STR0007) // "Base       Item Descricao                                Aquisic.   Quantidade   Nota Fisc. Chapa    Grupo    C. Custo  Localizacao"

*                                  XXXXXXXXXX XXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999 9.999.999,99 XXXXXX     XXXXXX   XXXX     XXXXXXXXX XX
*                                  01234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^
*                                            1         2         3         4         5         6         7         8         9         0         1         2         3
*                                                                                                                                      1
cabec2	:= OemToAnsi(STR0008) // "                In.Depr.  Tx.Depr.       Valor Original    Deprec. Acumulada   Correcao Acumulada"
li		:= 80
m_pag	:= 1

nOrdem	:= aReturn[8]
cChave	:= GetChave( lQuery, aReturn[8] /*nOrder*/ )
nMoeda	:= mv_par07
cMoeda	:= Str(nMoeda,1)

titulo	:=	Trim(titulo) + ;
OemToAnsi(STR0009) + ; // " por "
aOrd[nOrdem] + OemToAnsi(STR0010) +; //" em "
Getmv("MV_MOEDA" + cMoeda) + '-' + ;
DTOC(mv_par01) + OemToAnsi(STR0012) + DTOC(mv_par02) // " a "

// Filtro do Relatorio
Atf110Tmp( @TRB , @cChave , @cFiltro )

SetRegua((TRB)->(RecCount()))

While (TRB)->(!Eof())
	
	cBemAnt	:= ""
	cFilAnt := (TRB)->N3_FILIAL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza registro inicial                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nOrdem == 1
		cCond1 := TRB + "->N3_CCONTAB <= mv_par04"
		cCond2 := "cQuebra == " + TRB + "->N3_CCONTAB"
		
	ElseIF nOrdem == 2
		cCond1 := TRB + "->N3_CCUSTO <= mv_par06"
		cCond2 := "cQuebra == " + TRB + "->N3_CCUSTO"
		
	ElseIF nOrdem == 3
		cCond1 := "!Eof()"
		cCond2 := "cQuebra == " + TRB + "->N3_AQUISIC"
	EndIf
	
	
	While (TRB)->(!Eof()) .And. (TRB)->N3_FILIAL == cFilAnt .AND. &cCond1
		
		IF nOrdem == 1
			cQuebra := (TRB)->N3_CCONTAB
		ElseIF nOrdem == 2
			cQuebra := (TRB)->N3_CCUSTO
		ElseIF nOrdem == 3
			cQuebra := (TRB)->N3_AQUISIC
		EndIf
		
		IncRegua()
		
		While 	(TRB)->(!Eof()) .And. (TRB)->N3_FILIAL == cFilAnt .And. &cCond1 .AND. &cCond2
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SN3->(msGoto((TRB)->RecnoSN3)) //posiciona no Alias original, para avaliar o filtro de usuario
			// (pois o usuario pode escolher um campo que nao tem na query)
			
			If !Empty( cUserFilter ) .And. !( SN3->&(cUserFilter) )
				(TRB)->(dbSkip())
				Loop
			Endif
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0013) // "CANCELADO PELO OPERADOR"
				Exit
			End
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ So' devera ser impresso uma vez o bem no relatorio ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF (TRB)->N3_CBASE+(TRB)->N3_ITEM+(TRB)->N3_TIPO == cBemAnt .AND. mv_par08 == 2 .And. Val( SN3->N3_BAIXA ) # 0
				(TRB)->(dbSkip())
				Loop
			EndIF
			
			cBemAnt := (TRB)->N3_CBASE+(TRB)->N3_ITEM+(TRB)->N3_TIPO
			
			cBase := (TRB)->N3_CBASE
			cItem := (TRB)->N3_ITEM
			cTipo := (TRB)->N3_TIPO
			
			nVOrig := Af110VOrig((TRB)->N3_FILIAL,cMoeda,(TRB)->N3_CBASE,(TRB)->N3_ITEM,(TRB)->N3_TIPO)
			
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			EndIf
			
			@ li,  0    PSAY    (TRB)->N3_CBASE
			@ li, 11    PSAY    (TRB)->N3_ITEM
			@ li, 16    PSAY    SubS((TRB)->N1_DESCRIC,1,40)
			@ li, 57    PSAY    (TRB)->N3_AQUISIC
			@ li, 68    PSAY    (TRB)->N1_QUANTD  PICTURE PesqPict("SN1","N1_QUANTD",12)
			@ li, 81    PSAY    (TRB)->N1_NFISCAL
			@ li,103   PSAY    (TRB)->N1_CHAPA
			@ li,112    PSAY    (TRB)->N1_GRUPO
			
			If nTamCC < 10
				@ li,121 PSAY    (TRB)->N3_CCUSTO
			Endif
			
			@ li,131 PSAY (TRB)->N1_Local
			li ++
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se Houver fornecedor, imprime o nome  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty((TRB)->N1_FORNEC )
				SA2->(dbSetOrder(1))
				If SA2->( dbSeek(xFilial("SA2") + (TRB)->N1_FORNEC + (TRB)->N1_LOJA ) )
					@ li,00            	PSAY OemToAnsi(STR0014) // "FORNECEDOR "
					@ Prow(),Pcol()    	PSAY (TRB)->N1_FORNEC + "-" + (TRB)->N1_LOJA
					@ Prow(),Pcol()+2  	PSAY SA2->A2_NREDUZ
					li ++
				Endif
			Endif
			
			@ li, 16    PSAY    (TRB)->N3_DINDEPR
			@ li, 26    PSAY    &((TRB) + "->N3_TXDEPR" + cMoeda)   PICTURE PesqPict("SN3","N3_TXDEPR"+cMoeda,  8,nMoeda)
			@ li, 36    PSAY    nVOrig    PICTURE PesqPict("SN3","N3_VORIG" +cMoeda, 19,nMoeda)
			@ li, 57    PSAY    &((TRB) + "->N3_VRDACM" + cMoeda)   PICTURE PesqPict("SN3","N3_VRDACM"+cMoeda, 19,nMoeda)
			
			IF MV_PAR07 == 1
				@ li, 78    PSAY    (TRB)->N3_VRCACM1 PICTURE PesqPict("SN3","N3_VRCACM1", 19)
			EndIf
			
			@ li, 99 PSAY (TRB)->N3_DTBAIXA
			
			If nTamCC > 9
				@ li,110 PSAY (TRB)->N3_CCUSTO
			Endif
			
			li++
			@ li, 16    PSAY    OemToAnsi(STR0015) // "Conta do Bem         Conta Correcao       Cta.Desp.Depr.       Cta.Depr.Acum.       Cta.Corr.Depr. "
			*                                                XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX
			*                                                678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^678901234^6789
			*                                                    2         3         4         5         6         7         8         9         0         1
			*                                                                                                                                    1
			li++
			@ li, 16    PSAY     (TRB)->N3_CCONTAB
			@ li, 37    PSAY     (TRB)->N3_CCORREC
			@ li, 58    PSAY     (TRB)->N3_CDEPREC
			@ li, 79    PSAY     (TRB)->N3_CCDEPR
			@ li, 100   PSAY     (TRB)->N3_CDESP
			
			
			// Verificação da classificação de Ativo se sofre depreciação
			lAtClDepr := Iif(FindFunction("AtClssVer"),AtClssVer((TRB)->N1_PATRIM),(TRB)->N1_PATRIM $ "NID")
			
			If lAtClDepr .OR. (TRB)->N1_PATRIM $ " P"
				nTotValor += (TRB)->&("N3_VORIG"+cMoeda)
			Else
				nTotValor -= (TRB)->&("N3_VORIG"+cMoeda)
			Endif
			
			li+=2
			(TRB)->(dbSkip())
		EndDo
		
		If ( nTotValor ) <> 0
			IF li > 58
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			Endif
			@  li,  0 PSAY OemToAnsi(STR0016) // "TOTAL : "
			If nOrdem == 3
				@  li,  8 PSAY cQuebra
			Else
				@  li,  8 PSAY cQuebra
			EndIf
			@  li, 34 PSAY nTotValor    PICTURE PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
			li++
			@  li, 0 PSAY Replicate("-",137)
			li++
			nGerValor+=nTotValor
			nFilValor+=nTotValor
			nTotValor:=0
		EndIf
		
		If (TRB)->N3_FILIAL != cFilAnt
			
			If mv_par09 == 1
				If li+3 >= 58
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				Endif
				//@li,000 PSAY "T O T A L   F I L I A L ----> "+" "+Iif(mv_par09==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")
				@li,000 PSAY "T O T A L   F I L I A L ----> "+" FILIAL "+Iif(mv_par09==1,cFilAnt,"")
				@  li, pCol() + 2 PSAY nFilValor    PICTURE PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
				li++
				@  li, 0 PSAY Replicate("-",137)
				li++
				nFilValor:=0
			Endif
			
			cFilAnt := (TRB)->N3_FILIAL
			
		EndIf
		
	EndDo
	
EndDo

// Restaura a Filial Atual
cFilAnt := cAuxFil
IF li<> 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	Endif
	@  li, 0    PSAY OemToAnsi(STR0017) // "TOTAL GERAL: "
	@  li, 36   PSAY nGerValor PICTURE  PesqPict("SN3","N3_VORIG"+cMoeda, 21,nMoeda)
	Roda(cbcont,cbtxt)
Endif


DbSelectArea(TRB)
DbCloseArea()

DbSelectArea("SN3")
DbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	Ourspool(wnrel)
End

MS_FLUSH()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CriaSX1      ³ Autor ³ Claudio D. de Souza	³ Data ³ 28/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Siga                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSX1(cPerg)

Local aHelpPor 	:= {}
Local aHelpEng 	:= {}
Local aHelpSpa	:= {}
Local aPergs	:= {}
Local nTamFilial:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 )
Local lExistSN0 := IIf(FindFunction("ATFEXSTPTR"),ATFEXSTPTR(),.F.)

Aadd(aPergs,{"Considera itens baixados?","¿Cons. Cancelados?","Cons. Posted ?","mv_ch8","N",1,0,1,"C","","mv_par08","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aadd(aHelpPor,"Selecione neste parâmetro a opção 'Sim'")
aadd(aHelpPor,"para que o sistema considere as filiais")
aadd(aHelpPor,"a serem informadas nos parâmetros")
aadd(aHelpPor,"seguintes, ou selecione 'Não' em caso")
aadd(aHelpPor,"contrário.")

aadd(aHelpEng,"Selecione neste parâmetro a opção 'Sim'")
aadd(aHelpEng,"para que o sistema considere as filiais")
aadd(aHelpEng,"a serem informadas nos parâmetros")
aadd(aHelpEng,"seguintes, ou selecione 'Não' em caso")
aadd(aHelpEng,"contrário.")

aadd(aHelpSpa,"Selecione neste parâmetro a opção 'Sim'")
aadd(aHelpSpa,"para que o sistema considere as filiais")
aadd(aHelpSpa,"a serem informadas nos parâmetros")
aadd(aHelpSpa,"seguintes, ou selecione 'Não' em caso")
aadd(aHelpSpa,"contrário.")
Aadd(aPergs,{"Cons Filiais Abaixo ?","¿Cons sig. Filial?","Cons.Branches Below ?","mv_ch9","N",1,0,2,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","","",aHelpPor,aHelpEng,aHelpSpa})

//Filial De
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

aadd(aHelpPor,"Informe o código inicial do intervalo de")
aadd(aHelpPor,"filiais da empresa a serem consideradas")
aadd(aHelpPor,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpPor,"'Considera Filiais Abaixo?' estiver 'Sim'")

aadd(aHelpEng,"Informe o código inicial do intervalo de")
aadd(aHelpEng,"filiais da empresa a serem consideradas")
aadd(aHelpEng,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpEng,"'Considera Filiais Abaixo?' estiver 'Sim'")

aadd(aHelpSpa,"Informe o código inicial do intervalo de")
aadd(aHelpSpa,"filiais da empresa a serem consideradas")
aadd(aHelpSpa,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpSpa,"'Considera Filiais Abaixo?' estiver 'Sim'")

Aadd(aPergs,{"Filial De ?","¿De Filial?","From Branch ?","mv_cha","C",nTamFilial,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SM0","S","","",aHelpPor,aHelpEng,aHelpSpa})

//Filial Ate
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}

aadd(aHelpPor,"Informe o código final do intervalo de")
aadd(aHelpPor,"filiais da empresa a serem consideradas")
aadd(aHelpPor,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpPor,"'Considera Filiais Abaixo?' estiver 'Sim'")

aadd(aHelpEng,"Informe o código final do intervalo de")
aadd(aHelpEng,"filiais da empresa a serem consideradas")
aadd(aHelpEng,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpEng,"'Considera Filiais Abaixo?' estiver 'Sim'")

aadd(aHelpSpa,"Informe o código final do intervalo de")
aadd(aHelpSpa,"filiais da empresa a serem consideradas")
aadd(aHelpSpa,"pelo sistema, quando o parâmetro anterior")
aadd(aHelpSpa,"'Considera Filiais Abaixo?' estiver 'Sim'")

Aadd(aPergs,{"Filial Ate ?","¿A filial?","To Branch ?","mv_chb","C",nTamFilial,0,0,"G","","mv_par11","","","","ZZ","","","","","","","","","","","","","","","","","","","","","SM0","S","","",aHelpPor,aHelpEng,aHelpSpa})

Aadd(aPergs,{"Considera itens ?","¿Cons. itens?","Cons. Itens?","mv_chc","N",1,0,1,"C","","mv_par12","Normais","Normais","Normais","","","Adiantamentos","Adiantamentos","Adiantamentos","","","Ambos","Ambos","Ambos","","","","","","","","","","","","","S","",""})

AjustaSX1(cPerg,aPergs)

//Verifica se existe a tabela auxiliar, e se existe a tabela de classificações cadastradas
If lExistSN0
	aHelpPor :=	{"Define se seleciona a classificação " ," patrimonial das fichas de imobilizado"}
	aHelpSpa :=	{"Define si selecciona la clasificacion", "patrimonial  de las fichas del fijo  "  }
	aHelpEng :=	{"Defines if it selects the asset "     , "classification from the fixed ", "asset form"}
	PutSx1( cPerg, 	"13","Selec Classif Patrimonial?  ","¿Selec Clasif Patrimonial ? ","Selects Equity Classif ?","MV_CHD","N",1,0,2,"C","","","","S",;
	"MV_PAR13","Sim","Si","Yes","","Não","No","No",;
	"","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,".AFR11013.")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Atf110Tmp ºAutor  ³Renato		         º Data ³  21/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de retorno do conteudo a ser impresso pelo relatorioº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ATFR110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Atf110Tmp( cAliasTMP, cChave, cFiltro, cUserFilter )
Local aArea		:= GetArea()
Local lQuery	:= .F.
Local cCampos	:= ""
Local cQuery	:= ""
Local cFilDe	:= ""
Local cFilAte	:= ""
Local cTipoN3	:= "'01','10','12'"
Local aStruSn1	:= {}
Local aStruSn3	:= {}
Local nI		:= 0
LOCAL cFilBkp

DEFAULT cChave		:= ""
DEFAULT cFiltro		:= ""

If cPaisLoc == "COL"
	cTipoN3	:= "'01','50','51','52','53','54'"
EndIf



#IFDEF TOP
	lQuery := !(TcSrvType() == "AS/400" .or. TcSrvType() == "iSeries") // somente ira executar a query se nao for AS400
#ENDIF

If lQuery //TOP
	cAliasTMP := "cAtfTmp"
	
	If Select( cAliasTMP ) > 0
		DbSelectArea( cAliasTMP )
		DbCloseArea()
	Endif
Else //DBF
	cAliasTMP := 'SN3'
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par09 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par10	// Todas as filiais
	cFilAte:= mv_par11
Endif

If lQuery //TOP
	// montagem da query para SN1
	aStruSn1 := SN1->( dbStruct() )
	For nI := 1 to Len( aStruSn1 )
		If !Empty( cCampos )
			cCampos += ", "
		Endif
		
		cCampos += aStruSn1[nI,1]
	Next ni
	
	// montagem da query para SN3
	aStruSn3 := SN3->( dbStruct() )
	For nI := 1 to Len( aStruSn3 )
		If !Empty( cCampos )
			cCampos += ", "
		Endif
		
		cCampos += aStruSn3[nI,1]
	Next ni
	
	cQuery := "SELECT "
	cQuery += cCampos + ", SN3.R_E_C_N_O_ RECNOSN3 "
	cQuery += " FROM " + RetSqlName( "SN3" ) + " SN3"
	
	cQuery += " 	LEFT JOIN " + RetSqlName( "SN1" ) + " SN1 ON "
	cQuery += " 		SN1.N1_FILIAL  = SN3.N3_FILIAL AND "
	CqUERY += "			SN1.N1_CBASE   = SN3.N3_CBASE AND "
	cQuery += " 		SN1.N1_ITEM    = SN3.N3_ITEM AND
	cQuery += "			SN1.D_E_L_E_T_ <> '*'"
	
	// clausulas do filtro
	cQuery += " WHERE "
	
	// faixa de filiais
	If !Empty( cFilDe )
		cFilBkp := cFilAnt
		cFilAnt := cFilDe
		cQuery += "SN3.N3_FILIAL >= '" + xFilial("SN3") + "' AND "
		cFilAnt := cFilBkp
	Endif
	If !Empty( cFilAte )
		cFilBkp := cFilAnt
		cFilAnt := cFilAte
		cQuery += "SN3.N3_FILIAL <= '" + xFilial("SN3")+ "' AND "
		cFilAnt := cFilBkp
	Endif
	
	// faixa de contas contabeis
	If !Empty( mv_par03 )
		cQuery += "SN3.N3_CCONTAB >= '" + mv_par03 + "' AND "
	Endif
	If !Empty( mv_par04 )
		cQuery += "SN3.N3_CCONTAB <= '" + mv_par04 + "' AND "
	Endif
	
	// faixa de centros de custo
	If !Empty( mv_par05 )
		cQuery += "SN3.N3_CCUSTO  >= '" + mv_par05 + "' AND "
	Endif
	If !Empty( mv_par06 )
		cQuery += "SN3.N3_CCUSTO  <= '" + mv_par06 + "' AND "
	Endif
	
	// faixa de aquisicoes
	If !Empty( mv_par01 )
		cQuery += "SN3.N3_AQUISIC >= '" + DTOS( mv_par01 ) + "' AND "
	Endif
	If !Empty( mv_par02 )
		cQuery += "SN3.N3_AQUISIC <= '" + DTOS( mv_par02 ) + "' AND "
	Endif
	
	// faixa de itens
	IF mv_par12 == 1 // Itens normais
		cQuery += "SN3.N3_TIPO in ( " + cTipoN3 + " ) AND "
	ElseIf mv_par12 == 2 // Itens Adiantamentos
		cQuery += "SN3.N3_TIPO = '03' AND "
	ElseIf mv_par12 == 3 // Itens normais e adiantamentos
		cQuery += "(SN3.N3_TIPO in ( " + cTipoN3 + " ) OR SN3.N3_TIPO = '03') AND "
	Endif
	
	//Filtra classificações patrimoniais
	IF mv_par13 == 1 // Itens normais
		If Len(aSelClass) > 0  .And.  FindFunction("FormatClas")
			cQuery +=  "SN1.N1_PATRIM in  " +  FormatClass(aSelClass,.T.) +  "  And "
		EndIf
	EndIf
	
	// Se nao considera itens baixados, filtra na query
	If mv_par08 == 2
		cQuery += "SN3.N3_BAIXA = '0' AND "
	Endif
	
	// filtro dos nao deletados
	cQuery += "SN3.D_E_L_E_T_ <> '*'"
	
	// efetua o filtro do usuario
	If !Empty( cUserFilter )
		cQuery += " AND " + ADMParSQL( cUserFilter ) // funcao de Parse na query
	Endif
	
	// ordem baseada na chave passada
	If !Empty( cChave )
		cQuery += " ORDER BY " + STRTRAN( cChave , "+" , "," )
	Endif
	
	//retira os espacos em branco da query e transforma no padrao ANSI
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTMP, .T., .T.)
	
	// reconstruo o tipo do campo, conforme estrutura da tabela
	For nI := 1 to Len( aStruSn1 )
		If aStruSn1[nI,2] != "C"
			TCSetField( cAliasTMP, aStruSn1[nI,1] /*Nome*/, aStruSn1[nI,2]/*tipo*/,aStruSn1[nI,3]/*tamanho*/,aStruSn1[nI,4] /*precisao*/ )
		Endif
	Next
	For nI := 1 to Len( aStruSn3 )
		If aStruSn3[nI,2] != "C"
			TCSetField( cAliasTMP, aStruSn3[nI,1] /*Nome*/, aStruSn3[nI,2]/*tipo*/,aStruSn3[nI,3]/*tamanho*/,aStruSn3[nI,4] /*precisao*/ )
		Endif
	Next
	
	If Select( cAliasTMP ) <= 0
		Conout( 'Erro na montagem da query'	+ CRLF + cQuery )
	Endif
Else
	cFiltro := 'N3_FILIAL == "'+xFilial("SN3")+'" .And. '
	cFiltro += 'N3_CCONTAB>= "'+mv_par03+'" .And. '
	cFiltro += 'N3_CCONTAB<= "'+mv_par04+'" .And. '
	cFiltro += 'N3_CCUSTO >= "'+mv_par05+'" .And. '
	cFiltro += 'N3_CCUSTO <= "'+mv_par06+'" .And. '
	cFiltro += 'DTOS(N3_AQUISIC) >= "'+DTOS(mv_par01)+'" .And. '
	cFiltro += 'DTOS(N3_AQUISIC) <= "'+DTOS(mv_par02)+'" '
	
	If mv_par12 == 1 // Itens normais
		cFiltro += '.And. N3_TIPO $ "' + cTipoN3 + '" '
	Endif
	
	If mv_par12 == 2 // Itens Adiantamentos
		cFiltro += '.And. N3_TIPO == "03" '
	Endif
	
	If mv_par12 == 3 // Itens normais e adiantamentos
		cFiltro += '.And. (N3_TIPO $ " ' + cTipoN3 + '" .Or. N3_TIPO = "03") '
	Endif
	
	// Se nao considera itens baixados, filtra na query
	If mv_par08 == 2
		cFiltro += '.And. N3_BAIXA == "0" '
	Endif
	
	//Filtra classificações patrimoniais
	IF mv_par13 == 1
		If Len(aSelClass) > 0  .And.  FindFunction("FormatClas")
			cFiltro +=  '.And. N1_PATRIM $  " ' +  FormatClass(aSelClass,.F.) + '"'
		EndIf
	EndIf
	
	// efetua o filtro do usuario
	If !Empty( cUserFilter )
		cFiltro += ' .AND. ' + cUserFilter
	Endif
Endif


RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Atfr110IdxºAutor  ³Renato F. Campos    º Data ³  21/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que gera um indice por data dos bens cadastrados    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ATFR110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Atfr110Idx( cAliasTMP, cChave, lQuery)
Local aArea := GetArea()
Local cArqInd
Local nIndex	:= 0

dbSelectArea(cAliasTMP)

cArqInd	:= CriaTrab(Nil, .F.)

IndRegua( cAliasTMP,cArqInd,STRTRAN( cChave , "," , "+" ),,,OemToAnsi(STR0020))  //"Selecionando Registros..."

dbSelectArea(cAliasTMP)

IF lQuery
	DbClearIndex()
Endif

dbSetIndex(cArqInd+OrdBagExt())

If lQuery
	nIndex  := RetIndex(cAliasTMP)
Endif

nIndex++

RestArea( aArea )

Return nIndex


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATFR110   ºAutor  ³Microsiga           º Data ³  10/20/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetChave( lQuery, nOrder )
/*Local Declarations*/
Local lResult	:= .T.
Local cChave	:= ""

/*Initialization*/
Default nOrder	:= 1
Default lQuery	:= .F.

/*Implementation*/
If lResult
	If lQuery //TOP
		IF		nOrder == 1
			cChave	:= "N3_FILIAL,N3_CCONTAB,N3_CBASE,N3_ITEM"
		ElseIF	nOrder == 2
			cChave	:= "N3_FILIAL,N3_CCUSTO,N3_CBASE,N3_ITEM"
		ElseIF	nOrder == 3
			cChave	:= "N3_FILIAL,N3_AQUISIC,N3_CBASE,N3_ITEM"
		EndIf
	Else //DBF
		IF		nOrder == 1
			cChave	:= "N3_FILIAL+N3_CCONTAB+N3_CBASE+N3_ITEM"
		ElseIF	nOrder == 2
			cChave	:= "N3_FILIAL+N3_CCUSTO+N3_CBASE+N3_ITEM"
		ElseIF	nOrder == 3
			cChave	:= "N3_FILIAL+DTOS(N3_AQUISIC)+N3_CBASE+N3_ITEM"
		EndIf
	Endif
Endif

Return ( cChave )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
		IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
		"",;
		"",;
		"",;
		SM0->M0_NOME,;
		SM0->M0_FILIAL }
		
		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )
Return aRetSM0
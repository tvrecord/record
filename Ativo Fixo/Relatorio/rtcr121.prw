#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ATFR210  ³ Autor ³ Alice Yaeko Yamamoto  ³ Data ³ 04.09.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Bens  a Inventariar                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTCR121A()

Local wnrel			:=	"ATFR210"
Local cString		:=	"SN3"
Local cDesc1 		:= "Este programa irá emitir a relatório dos bens a inventariar de"
Local cDesc2 		:= "acordo com os parâmetros escolhidos. O ajuste Contábil desses "
Local cDesc3 		:= "bens deve ser feito antes do próximo cálculo"

Private aReturn 	:= {"Zebrado",1,"Administracao",2,2,1,"",1}
Private aLinha   	:= {}
Private cPerg    	:= "ATR210    "
Private NomeProg 	:= "RTCR121"
Private nLastKey 	:= 0
Private nTamCC	 	:= Len(SN3->N3_CCUSTO)
Private Tamanho  	:=	iif(nTamCC > 9,"G","M")
Private Titulo   	:= "Relacao de bens inventariados"
Private Cabec1   	:= ""
Private Cabec2   	:= ""
Private Cabec3   	:=	""
Private aOrd  		:=	{ "Codigo" , "C. Custo" } 

Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,,Tamanho)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

RptStatus( { |lEnd| FR210Imp(@lEnd,wnRel,cString)} , Titulo )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FR210IMP ³ Autor ³ Alice Y. Yamamoto     ³ Data ³ 04.09.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de Inventario                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FR210Imp(lEnd,WnRel,cString)

Local nColunas
Local cbCont		:=	0
Local nA				:= 0
Local lLoop   		:=	.f.
Local CbTxt			:= Space(10)
Local nOrdem  		:= aReturn[8]
Local nDecimal		:= MsDecimais(1)
Local cPicture		:=	"@E 999,999,999"
Local aColunas		:= { 74, 79, 89, 104, 114, 127 }

Private cChave 	:= xFilial("SN3")

//                                                                                                                                     1         1         1         1
//           0         1         2         3         4         5         6         7         8         9         0         1         2         3
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
Cabec1   := "C Base     Item Ti Chapa  Descricao                      Local  CCusto    Grup Qtd Atual    Valor Resid Qtd.Inv   Valor Invent Visto"
//           XXXXXXXXXX XXXX XX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXX XXXX 99.999,99 999.999.999,99 --------- ------------ -----
Cabec2   := "C Base     Item Ti Chapa  Descricao                      Local  CCusto    Grup Qtd.Invent  Valor Invent   Visto "
//           XXXXXXXXXX XXXX XX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXX XXXX ----------  -------------- ------

Li       := 80
m_pag    := 01

// Acrescenta a qtde de casas decimais, respeitando o configurado em MV_CENT
// Alteracao conforme BOPS 66.785 por Cristiano Denardi

For nA := 1 to nDecimal
	cPicture += iif( nA == 1 , "." , "" ) + "9"
Next nA

If nTamCC > 9 .and. mv_par09 == 1
	Cabec1 := Stuff(Cabec1,074,000,Replicate(Space(1),nTamCC - 9))
	For nColunas := 1 To Len(aColunas)
		If aColunas[nColunas] <> Nil
			aColunas[nColunas] += nTamCC - 9
		Endif
	Next
ElseIf mv_par09 == 2
	aColunas := {074,,,079,091,106}
Endif

Titulo := Alltrim(Titulo) + " por " + aOrd[nOrdem] + " em " + DtoC(mv_par10)
cChave += iif(nOrdem == 1,iif(!Empty(mv_par01),mv_par01,""),iif(!Empty(mv_par05),mv_par05,""))
cCond1 := iif(nOrdem == 1,"SN3->N3_CBASE <= mv_par02","SN3->N3_CCUSTO <= mv_par06")

dbSelectArea("SN3")
SN3->(dbSetOrder(iif(nOrdem == 1,1,3)))
SN3->(dbSeek(cChave,.t.))

if nOrdem == 1
	Cabec1   := "C Base     Item Ti Chapa  Descricao                             CCusto    Grup Qtd Atual    Valor Resid Qtd.Inv   Valor Invent Visto"
	//           XXXXXXXXXX XXXX XX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXX XXXX 99.999,99 999.999.999,99 --------- ------------ -----
	Cabec2   := "C Base     Item Ti Chapa  Descricao                             CCusto    Grup Qtd.Invent  Valor Invent   Visto "
else
	Cabec5   := "C Base     Item Ti Chapa  Descricao                                       Grup Qtd Atual    Valor Resid Qtd.Inv   Valor Invent Visto"
	//           XXXXXXXXXX XXXX XX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXX XXXXXXXXX XXXX 99.999,99 999.999.999,99 --------- ------------ -----
	Cabec6   := "C Base     Item Ti Chapa  Descricao                                       Grup Qtd.Invent  Valor Invent   Visto "
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // Do codigo                         ³
//³ mv_par02            // ate o Codigo                      ³
//³ mv_par03            // Do Grupo                          ³
//³ mv_par04            // Ate o Grupo                       ³
//³ mv_par05            // Do Centro de Custo                ³
//³ mv_par06            // At‚ o Centro de Custo             ³
//³ mv_par07            // Do Local                          ³
//³ mv_par08            // Ate o Local                       ³
//³ mv_par09            // Mostra Qtde e Vl Atual            ³
//³ mv_par10            // Data do Inv                       ³
//³ mv_par11            // Quais tipo  tipo 01 ou todos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(SN3->(RecCount()))

Do While !SN3->(Eof()) .and. SN3->N3_FILIAL == xFilial("SN3") .and. &cCond1
	
	If	lEnd
		@ Prow() + 1 , 001 psay "Cancelado Pelo Operador"
		Exit
	EndIf
	
	IncRegua()
	
	dbSelectArea("SN1")
	dbSeek( xFilial("SN1") + SN3->(N3_CBASE + N3_ITEM) )
	
	dbSelectArea("SN3")

	lLoop := .f.
	lLoop	:=	iif(SN3->N3_CBASE  < mv_par01 .or. SN3->N3_CBASE  > mv_par02, .t. , lLoop )
	lLoop := iif(SN3->N3_CCUSTO < mv_par05 .or. SN3->N3_CCUSTO > mv_par06, .t. , lLoop )
	lLoop := iif(SN1->N1_GRUPO  < mv_par03 .or. SN1->N1_GRUPO  > mv_par04, .t. , lLoop )
	lLoop := iif(SN1->N1_LOCAL  < mv_par07 .or. SN1->N1_LOCAL  > mv_par08, .t. , lLoop )
	lLoop := iif(mv_par11 == 1 .and. SN3->N3_TIPO != "01" , .t. , lLoop)
	lLoop := iif(Val(SN3->N3_BAIXA) != 0 , .t. , lLoop )
		
	If	lLoop
		dbSkip()
		Loop
	EndIf
	
	If li > 58
	   If nOrdem == 1
			Cabec(Titulo,iif(mv_par09 == 1,Cabec1,Cabec2),Cabec3,NomeProg,Tamanho,GetMv("MV_NORM"))
		else
			Cabec(Titulo,iif(mv_par09 == 1,Cabec5,Cabec6),Cabec3,NomeProg,Tamanho,GetMv("MV_NORM"))
		endif
		i := 1
	EndIf
	
	pCusto := SN3->N3_CCUSTO
	ImpCC  := .t.
	
	if nOrdem == 2     

		Do While !Eof() .and. SN3->N3_CCUSTO == pCusto

			dbSelectArea("SN1")
			dbSetOrder(1)
			dbSeek( xFilial("SN1") + SN3->N3_CBASE + SN3->N3_ITEM )

			dbSelectArea("SN3")                            

			lLoop := .f.
			lLoop	:=	iif(SN3->N3_CBASE  < mv_par01 .or. SN3->N3_CBASE  > mv_par02, .t. , lLoop )
			lLoop := iif(SN3->N3_CCUSTO < mv_par05 .or. SN3->N3_CCUSTO > mv_par06, .t. , lLoop )
			lLoop := iif(SN1->N1_GRUPO  < mv_par03 .or. SN1->N1_GRUPO  > mv_par04, .t. , lLoop )
			lLoop := iif(SN1->N1_LOCAL  < mv_par07 .or. SN1->N1_LOCAL  > mv_par08, .t. , lLoop )
			lLoop := iif(mv_par11 == 1 .and. SN3->N3_TIPO != "01" , .t. , lLoop)
			lLoop := iif(Val(SN3->N3_BAIXA) != 0 , .t. , lLoop )
				
			If	lLoop
				dbSkip()
				Loop
			EndIf		

			IF Li > 58
				Cabec(Titulo,iif(mv_par09 == 1,Cabec5,Cabec6),Cabec3,NomeProg,Tamanho,GetMv("MV_NORM"))
				ImpCC  := .t.
				i := 1
			EndIf
			
			If ImpCC
				if i > 1                     
				   @ Li,000 psay __PrtThinLine()
				   Li ++
				endif
				@ Li, 00 psay "C. custo: " + SN3->N3_CCUSTO  + " " + Posicione("CTT",1,xFilial("CTT")+SN3->N3_CCUSTO,"CTT_DESC01")
				Li ++  
				ImpCC := .f.
			EndIf			

			If SN3->N3_TIPO = "05"
				nVlrResid := (SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1) + (SN3->N3_VRDACM1+SN3->N3_VRCDA1)
			Else
				nVlrResid := (SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1) - (SN3->N3_VRDACM1+SN3->N3_VRCDA1)
			Endif
			
			@ Li, 00  psay SN3->N3_CBASE
			@ Li, 11  psay SN3->N3_ITEM
			@ Li, 16  psay SN3->N3_TIPO
			@ Li, 19  psay SN1->N1_CHAPA
			@ Li, 30  psay SN1->N1_DESCRIC
			@ Li, aColunas[1]  psay SN1->N1_GRUPO
			If mv_par09 == 1
				@ Li, aColunas[2]  	psay SN1->N1_QUANTD PICTURE "@E 99,999.99"
				@ Li, aColunas[3]  	psay nVlrResid      PICTURE cPicture
				@ Li, aColunas[4]  	psay "---------"        //Qtde Invent
				@ Li, aColunas[5]  	psay "------------"     //Valor Inventariado
				@ Li, aColunas[6]  	psay "-----"            //Visto
			Else
				@ Li, aColunas[4]  	psay "----------"       //Qtde Invent
				@ Li, aColunas[5]  	psay "--------------"   //Valor Inventariado
				@ Li, aColunas[6] 	psay "------"           //Visto
			EndIf

			Li ++

			nVlrResid := 0

			i ++

			dbSelectArea("SN3")
			dbSkip()			
		EndDo		
	Else
		dbSelectArea("SN1")
		dbSetOrder(1)
		dbSeek(xFilial("SN1") + SN3->N3_CBASE + SN3->N3_ITEM )
		If SN3->N3_TIPO = "05"
			nVlrResid := (SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1) + (SN3->N3_VRDACM1+SN3->N3_VRCDA1)
		Else
			nVlrResid := (SN3->N3_VORIG1+SN3->N3_VRCACM1+SN3->N3_AMPLIA1) - (SN3->N3_VRDACM1+SN3->N3_VRCDA1)
		Endif
		
		@ Li, 00  psay SN3->N3_CBASE
		@ Li, 11  psay SN3->N3_ITEM
		@ Li, 16  psay SN3->N3_TIPO
		@ Li, 19  psay SN1->N1_CHAPA
		@ Li, 30  psay SubS(SN1->N1_DESCRIC,1,32)
		@ Li, 64  psay SN3->N3_CCUSTO
		@ Li, aColunas[1]  psay SN1->N1_GRUPO
		If mv_par09 == 1
			@ Li, aColunas[2]  	psay SN1->N1_QUANTD Picture "@E 99,999.99"
			@ Li, aColunas[3]  	psay nVlrResid      Picture cPicture
			@ Li, aColunas[4]  	psay "---------"        //Qtde Invent
			@ Li, aColunas[5]  	psay "------------"     //Valor Inventariado
			@ Li, aColunas[6]  	psay "-----"            //Visto
		Else
			@ Li, aColunas[4]  	psay "----------"       //Qtde Invent
			@ Li, aColunas[5]  	psay "--------------"   //Valor Inventariado
			@ Li, aColunas[6] 	psay "------"           //Visto
		EndIf
		Li ++
		nVlrResid := 0		
		dbSelectArea("SN3")
		dbSkip()
	EndIf
EndDo

If Li != 80
	Roda(cbcont,cbtxt,tamanho)
EndIf

dbClearFilter()

RetIndex("SN3")

if aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return
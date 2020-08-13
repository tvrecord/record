#include "rwmake.ch" 
#include "topconn.ch"

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ATFR180    ³ Autor ³ Mario Angelo          ³ Data ³ 30.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de Bens Totalmente Depreciados                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAATF                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

User Function ATF()
                                                             		
Local Wnrel	  		:=	"ATFR180"
Local cDesc1  		:=	"Este programa ir  emitir a rela‡Æo dos Bens que já"
Local cDesc2  		:=	"foram totalmente depreciados"
Local cDesc3  		:=	""
Local cString 		:= "SN3"
Local cPerg    	:=	"ATR180X"+space(3) 

Private aLinha   	:= {}
Private aReturn 	:= {"Zebrado",1,"Administracao",2,2,1,"",1}
Private NomeProg 	:= "ATFR180"
Private nTamanho	:=	0
Private nLastKey 	:= 0
Private Tamanho  	:= "M"
Private Titulo  	:= "Bens Depreciados 100%"
Private Cabec1  	:=	"Saldos Depreciados por Bens"
Private Cabec2  	:=	"Codigo  Descricao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01            Do Bem                 ³
//³ mv_par02            Ate o Bem              ³
//³ mv_par03            Moeda 1                ³
//³ mv_par04            Moeda 2                ³
//³ mv_par05            Moeda 3                ³
//³ mv_par06            Moeda 4                ³
//³ mv_par07            Moeda 5                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

ValidPerg(PadR(cPerg,10))        

Pergunte(cPerg,.t.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,,,Tamanho)

If	nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTamanho	:=	iif( aReturn[4] == 1 , 15 , 18 )

RptStatus( { |lEnd| FR180Imp(@lEnd,wnRel,cString) } , Titulo )

Return

/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FR180Imp  ³ Autor ³ Mario Angelo          ³ Data ³ 30/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime as Etiquetas dentro do padrao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FR180Imp(lEnd,wnRel,cString)

Local cQuery	
Local cbCont			:=	0  
Local nTotalCorrAc 	:=	0
Local nTotalDeprAc 	:= 0
Local nTotalCrDpAc 	:= 0
Local nTotalAmplia	:= 0
Local cConta			:=	""
Local cDescConta		:=	""
Local lPriVez			:=	.t.
Local CbTxt				:=	Space(10)
Local aSubTot			:=	ZeraArray()

Local nTotal1 := 0, nTotal2 := 0, nTotal3 := 0, nTotal4 := 0, nTotal5 := 0
Local cMoeda1 := 0, cMoeda2 := 0, cMoeda3 := 0, cMoeda4 := 0, cMoeda5 := 0

li      	:= 80
m_pag   	:= 01
cMoeda  	:=	"1" //GetMv("MV_ATFMOED")
cMoeda1 	:= Space(19 - Len(AllTrim(GetMV("MV_SIMB1")))) + AllTrim(GetMV("MV_SIMB1"))
cMoeda2 	:= Space(18 - Len(AllTrim(GetMV("MV_SIMB2")))) + AllTrim(GetMV("MV_SIMB2"))
cMoeda3 	:= Space(18 - Len(AllTrim(GetMV("MV_SIMB3")))) + AllTrim(GetMV("MV_SIMB3"))
cMoeda4 	:= Space(18 - Len(AllTrim(GetMV("MV_SIMB4")))) + AllTrim(GetMV("MV_SIMB4"))
cMoeda5 	:= Space(18 - Len(AllTrim(GetMV("MV_SIMB5")))) + AllTrim(GetMV("MV_SIMB5"))

Cabec1  	:=	"Codigo     Item Descricao                                "
Cabec1  	+=	iif(mv_par03 == 1,cMoeda1,"") + iif(mv_par04 == 1,cMoeda2,"")
Cabec1  	+=	iif(mv_par05 == 1,cMoeda3,"") + iif(mv_par06 == 1,cMoeda4,"")
Cabec1  	+=	iif(mv_par07 == 1,cMoeda5,"")
Cabec2  	:=	"                    Dt.Aquisição  Correcao Acumulada    Depr Acumulada  Corr Depr Acumul"
//                                xx/xx/xxxx
//            012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                      1         2         3         4         5         6
//            Codigo     Item Descricao                                "   + Space(08) 
//            xxxxxxxxxx xxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

dbSelectArea("CT1")
CT1->(dbsetorder(1))

cQuery	:=	"Select SN3.* ,SN1.N1_FILIAL ,SN1.N1_DESCRIC , SN1.N1_AQUISIC "
cQuery	+=	"From " + RetSQLName("SN1") + " SN1 , "
cQuery	+=	          RetSQLName("SN3") + " SN3   "
cQuery	+=	"Where SN1.N1_FILIAL   >= '" + mv_par09 + "' and " 
cQuery	+=	" SN1.N1_FILIAL   <= '" + mv_par10 + "' and "
cQuery	+= 	"   SN1.N1_CBASE    = SN3.N3_CBASE and " 
cQuery	+= 	"   SN1.N1_FILIAL    = SN3.N3_FILIAL and "
cQuery	+=		"   SN1.N1_ITEM     = SN3.N3_ITEM  and "
cQuery	+=		"   SN1.D_E_L_E_T_  = ' ' and "
cQuery	+=		" ( SN3.N3_CDEPREC <> '" + CriaVar("N3_CDEPREC",.f.)	+ "'   or  "
cQuery	+=		"   SN3.N3_CDESP   <> '" + CriaVar("N3_CDESP",.f.)  	+ "'   or  "
cQuery	+=		"   SN3.N3_CCDEPR  <> '" + CriaVar("N3_CCDEPR",.f.)	+ "' ) and "
cQuery	+=		"   SN3.N3_CBASE   >= '" + mv_par01							+ "'   and "
cQuery	+=		"   SN3.N3_CBASE   <= '" + mv_par02							+ "'   and "
cQuery	+=		"   SN3.N3_CCONTAB >= '" + mv_par13							+ "'   and "
cQuery	+=		"   SN3.N3_CCONTAB <= '" + mv_par14							+ "'   and "
//cQuery	+= 	"   SN3.N3_FILIAL   = '" + xFilial("SN3") 				+ "'   and " 
if !Empty(MV_par16)
cQuery	+=		"   SN3.N3_TIPO = '" + mv_par16	+ "'   and "
endif  
IF MV_par17 == 2 
cQuery  +=      "	SN3.N3_DTBAIXA = ''  and "
ENDIF
cQuery	+=		"   SN3.D_E_L_E_T_  = ' '  "
cQuery	+=	"Order By N3_FILIAL , N3_CCONTAB , N3_CBASE "
cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "QSN3"

aEval(SN3->(dbstruct()),{|x| iif(x[2]<>"C",TcSetField("QSN3",x[1],x[2],x[3],x[4]),Nil)})

SetRegua(SN3->(RecCount()))

dbSelectArea("QSN3")

Do While !Eof() 

	IncRegua()
	
	if	lEnd
		@ Prow() + 1 , 001 psay "Cancelado Pelo Operador"
		Exit
	EndIf
	
	// Verifica se ja foi Totalmente depreciado
	
	If	( QSN3->N3_VRDACM1 != QSN3->N3_VORIG1 .or. QSN3->N3_VRDACM1 > QSN3->N3_VORIG1 ) .and. QSN3->N3_VRDACM1 <> ( QSN3->N3_VORIG1 + QSN3->N3_VRCACM1 )
		dbSkip()
		Loop
	EndIf

	if	mv_par15 == 1 // Consid.Database = Sim 
	  	if	UltDtDepr( QSN3->N3_CBASE , QSN3->N3_ITEM , QSN3->N3_TIPO, QSN3->N1_FILIAL ) > dDatabase
		 	dbSkip()
		 	Loop	    
	  	endif
	Endif
		
	if	cConta <> QSN3->N3_CCONTAB	   	

		if	!lPriVez

			Li ++
			
			if	Li > 58 .or. ( Li + 1 ) > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTamanho)
			Endif
		
			@ Li , 00 psay "S U B - T O T A I S" + Space(15) 

			If mv_par03 == 1
				@Prow(),Pcol() psay aSubTot[1,1] Picture PesqPict("SN3","N3_VORIG1",18,1)
			Endif
			
			If mv_par04 == 1
				@Prow(),Pcol() psay aSubTot[1,2] Picture PesqPict("SN3","N3_VORIG2",18,2)
			Endif
			
			If mv_par05 == 1
				@Prow(),Pcol() psay aSubTot[1,3] Picture PesqPict("SN3","N3_VORIG3",18,3)
			Endif
			
			If mv_par06 == 1
				@Prow(),Pcol() psay aSubTot[1,4] Picture PesqPict("SN3","N3_VORIG4",18,4)
			Endif
			
			If mv_par07 == 1
				@Prow(),Pcol() psay aSubTot[1,5] Picture PesqPict("SN3","N3_VORIG5",18,5)
			Endif
			
			Li ++
			
			@Li,034 psay aSubTot[2,1] Picture PesqPict("SN3","N3_VRCACM1",18,1)
			@Li,052 psay aSubTot[2,2] Picture PesqPict("SN3","N3_VRDACM1",18,1)
			@Li,070 psay aSubTot[2,3] Picture PesqPict("SN3","N3_VRCDA1" ,18,1)
			@Li,088 psay aSubTot[2,4] Picture PesqPict("SN3","N3_AMPLIA1",18,1)
		
			Li ++

			aSubTot	:=	ZeraArray()

		endif

		lPriVez 		:=	.f.
		cConta 		:=	QSN3->N3_CCONTAB
		cDescConta	:=	iif(CT1->(dbseek(xFilial("CT1")+QSN3->N3_CCONTAB)),CT1->CT1_DESC01,"")			

		Li ++

		if	Li > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTamanho)
		Endif
		
		@ Li , 00 psay "***** " + Alltrim(cConta) + " - " + cDescConta

		Li += 2
   endif

	if	Li > 58 .or. ( Li + 1 ) > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTamanho)
	Endif

	@ Li,00 psay QSN3->N3_CBASE + " " + QSN3->N3_ITEM + " " + QSN3->N1_DESCRIC + " "

	If	mv_par03 == 1
		@Prow(),Pcol() psay QSN3->(N3_VORIG1+N3_AMPLIA1) Picture PesqPict("SN3","N3_VORIG1",18,1)
	Endif
	
	If mv_par04 == 1
		@Prow(),Pcol() psay QSN3->(N3_VORIG2+N3_AMPLIA2) Picture PesqPict("SN3","N3_VORIG2",18,2)
	Endif
	
	If mv_par05 == 1
		@Prow(),Pcol() psay QSN3->(N3_VORIG3+N3_AMPLIA3) Picture PesqPict("SN3","N3_VORIG3",18,3)
	Endif
	
	If mv_par06 == 1
		@Prow(),Pcol() psay QSN3->(N3_VORIG4+N3_AMPLIA4) Picture PesqPict("SN3","N3_VORIG4",18,4)
	Endif
	
	If mv_par07 == 1
		@Prow(),Pcol() psay QSN3->(N3_VORIG5+N3_AMPLIA5) Picture PesqPict("SN3","N3_VORIG5",18,5)
	Endif
	
	Li ++
	
	@Li,020 psay DtoC(StoD(QSN3->N1_AQUISIC))
	@Li,034 psay QSN3->N3_VRCACM1 Picture PesqPict("SN3","N3_VRCACM1",18,1)
	@Li,052 psay QSN3->N3_VRDACM1 Picture PesqPict("SN3","N3_VRDACM1",18,1)
	@Li,070 psay QSN3->N3_VRCDA1  Picture PesqPict("SN3","N3_VRCDA1" ,18,1)
	@Li,088 psay QSN3->N3_AMPLIA1 Picture PesqPict("SN3","N3_AMPLIA1",18,1)
	
	Li ++

	nTotal1			+= QSN3->N3_VORIG1 + QSN3->N3_AMPLIA1
	nTotal2 			+= QSN3->N3_VORIG2 + QSN3->N3_AMPLIA2
	nTotal3 			+= QSN3->N3_VORIG3 + QSN3->N3_AMPLIA3
	nTotal4 			+= QSN3->N3_VORIG4 + QSN3->N3_AMPLIA4
	nTotal5 			+=	QSN3->N3_VORIG5 + QSN3->N3_AMPLIA5

	aSubTot[1,1]	+= QSN3->N3_VORIG1 + QSN3->N3_AMPLIA1
	aSubTot[1,2]	+= QSN3->N3_VORIG2 + QSN3->N3_AMPLIA2
	aSubTot[1,3]	+= QSN3->N3_VORIG3 + QSN3->N3_AMPLIA3
	aSubTot[1,4]	+= QSN3->N3_VORIG4 + QSN3->N3_AMPLIA4
	aSubTot[1,5]	+= QSN3->N3_VORIG5 + QSN3->N3_AMPLIA5
	
	nTotalCorrAc	+= QSN3->N3_VRCACM1
	nTotalDeprAc 	+= QSN3->N3_VRDACM1
	nTotalCrDpAc 	+= QSN3->N3_VRCDA1
	nTotalAmplia 	+=	QSN3->N3_AMPLIA1

	aSubTot[2,1]	+= QSN3->N3_VRCACM1
	aSubTot[2,2] 	+= QSN3->N3_VRDACM1
	aSubTot[2,3] 	+= QSN3->N3_VRCDA1
	aSubTot[2,4] 	+=	QSN3->N3_AMPLIA1

	QSN3->(dbSkip())
EndDo

QSN3->(dbclosearea())

If Li != 80

	Li ++
	
	if	Li > 58 .or. ( Li + 1 ) > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTamanho)
	Endif

	@ Li , 00 psay "S U B - T O T A I S" + Space(15) 

	If mv_par03 == 1
		@Prow(),Pcol() psay aSubTot[1,1] Picture PesqPict("SN3","N3_VORIG1",18,1)
	Endif
	
	If mv_par04 == 1
		@Prow(),Pcol() psay aSubTot[1,2] Picture PesqPict("SN3","N3_VORIG2",18,2)
	Endif
	
	If mv_par05 == 1
		@Prow(),Pcol() psay aSubTot[1,3] Picture PesqPict("SN3","N3_VORIG3",18,3)
	Endif
	
	If mv_par06 == 1
		@Prow(),Pcol() psay aSubTot[1,4] Picture PesqPict("SN3","N3_VORIG4",18,4)
	Endif
	
	If mv_par07 == 1
		@Prow(),Pcol() psay aSubTot[1,5] Picture PesqPict("SN3","N3_VORIG5",18,5)
	Endif
	
	Li ++
	
	@Li,034 psay aSubTot[2,1] Picture PesqPict("SN3","N3_VRCACM1",18,1)
	@Li,052 psay aSubTot[2,2] Picture PesqPict("SN3","N3_VRDACM1",18,1)
	@Li,070 psay aSubTot[2,3] Picture PesqPict("SN3","N3_VRCDA1" ,18,1)
	@Li,088 psay aSubTot[2,4] Picture PesqPict("SN3","N3_AMPLIA1",18,1)

	Li += 2

	if	Li > 58 .or. ( Li + 1 ) > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTamanho)
	Endif

	@ Li , 00 psay "T O T A I S" + Space(23) 

	If mv_par03 == 1
		@Prow(),Pcol() psay nTotal1 Picture PesqPict("SN3","N3_VORIG1",18,1)
	Endif
	
	If mv_par04 == 1
		@Prow(),Pcol() psay nTotal2 Picture PesqPict("SN3","N3_VORIG2",18,2)
	Endif
	
	If mv_par05 == 1
		@Prow(),Pcol() psay nTotal3 Picture PesqPict("SN3","N3_VORIG3",18,3)
	Endif
	
	If mv_par06 == 1
		@Prow(),Pcol() psay nTotal4 Picture PesqPict("SN3","N3_VORIG4",18,4)
	Endif
	
	If mv_par07 == 1
		@Prow(),Pcol() psay nTotal5 Picture PesqPict("SN3","N3_VORIG5",18,5)
	Endif
	
	Li ++
	
	@Li,034 psay nTotalCorrAc Picture PesqPict("SN3","N3_VRCACM1",18,1)
	@Li,052 psay nTotalDeprAc Picture PesqPict("SN3","N3_VRDACM1",18,1)
	@Li,070 psay nTotalCrDpAc Picture PesqPict("SN3","N3_VRCDA1" ,18,1)
	@Li,088 psay nTotalAmplia Picture PesqPict("SN3","N3_AMPLIA1",18,1)

	Roda(cbcont,cbtxt,Tamanho)	
EndIf

If aReturn[5] = 1
	Set Printer to
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return  

/*****************************************************/

Static Function ValidPerg(cPerg)

Local aRegs		:=	{}
Local _sAlias	:=	Alias()

dbSelectArea("SX1")                                
dbSetOrder(1)

aAdd(aRegs,{cPerg,"13","Conta   De       ?",Space(20),Space(20),"mv_ch13","C",20,0,0,"C","","mv_par13","   ","","","","","   ","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
aAdd(aRegs,{cPerg,"14","Conta   Ate      ?",Space(20),Space(20),"mv_ch14","C",20,0,0,"C","","mv_par14","   ","","","","","   ","","","","","","","","","","","","","","","","","","","CT1","","","","",""})
aAdd(aRegs,{cPerg,"15","Consid. Database ?",Space(07),Space(07),"mv_ch15","N",01,0,1,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","   ","","","","",""})
aAdd(aRegs,{cPerg,"16","Filtra tipo      ?",Space(20),Space(20),"mv_ch16","C",02,0,0,"C","","mv_par16","   ","","","","","   ","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Imprime Baixados ?",Space(07),Space(07),"mv_ch17","N",01,0,1,"C","","mv_par17","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","   ","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek( cPerg + aRegs[i,2] )
		RecLock("SX1",.t.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next j
		MsUnlock()
		dbCommit()
	Endif
Next i

dbSelectArea(_sAlias)

Return  

/**********************************************************/

Static Function ZeraArray()

Local aRet := {}

For t := 1 to 2
	aAdd( aRet , Array(5) )
	For k := 1 to 5 
		aRet[t,k] := 0.00
   Next k
Next t 

Return ( aRet )

/**********************************************************/

Static Function UltDtDepr(cChapa,cItem,cTipo,_cFilial)

Local dData 
Local cQuery
Local _sAlias	:=	Alias()

cQuery	:=	"Select Max(N4_DATA) AS MAXDATA "
cQuery 	+= "From SN4010 "
cQuery 	+= "Where N4_FILIAL  = '" + _cFilial	+ "' and "
cQuery 	+= 	"   N4_CBASE   = '" + cChapa 				+ "' and " 
cQuery 	+= 	"   N4_ITEM    = '" + cItem 				+ "' and " 
cQuery 	+= 	"   N4_TIPO    = '" + cTipo 				+ "' and " 
IF ALLTRIM(cTipo) == "10"  
cQuery 	+= 	"   N4_OCORR   = '20' and N4_TIPOCNT = '3'  and " 
ELSE
cQuery 	+= 	"   N4_OCORR   = '06' and N4_TIPOCNT = '3'  and " 
ENDIF
cQuery	+=		"   N4_VLROC1  > 0    and D_E_L_E_T_ = ' ' "
cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "QSN4"  

dbSelectArea("QSN4")
dData := iif(Empty(QSN4->MAXDATA) .or. QSN4->MAXDATA == Nil,Ctod(""),StoD(QSN4->MAXDATA))
dbclosearea()
dbSelectArea(_sAlias)

Return ( dData )

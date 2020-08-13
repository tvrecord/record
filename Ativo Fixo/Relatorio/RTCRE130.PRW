#include "rwmake.ch"  	
#include "topconn.ch" 	
#include "vkey.ch"    	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRE130  บ Autor ณ EDMILSON D. STOS   บ Data ณ  29/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Movimento Conta                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RTCRE130()

Local aOrd 				:=	{}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Movimentacao nas contas"
Local cPict          := ""
Local Titulo         := "Movimento Conta"
Local nLin           := 80
Local Imprime        := .t.
Local aRegs        	:= {}
Local aPergs       	:=	{}
Local Cabec1         :=	"    Conta Contabil                        "
Local Cabec2         := "          Mes/Ano  Tp Movimento      Motivo Mov.            Real           Ufir"   

Private CbTxt        :=	""
Private lEnd         := .f.
Private lAbortPrint  := .f.
Private Limite       := 80
Private Tamanho      := "P"
Private NomeProg     := "RTCRE130" 
Private nTipo        := 18
Private aReturn      := {"Zebrado",01,"Administracao",02,02,01,"",01}
Private nLastKey     := 0
Private cPerg        := "RTE130    "
Private cbtxt        := Space(10)
Private cbcont       := 00
Private ContFl       := 01
Private m_pag        := 01
Private wnrel        := "RTCRE130" 
Private cMascara     := GetMv("MV_MASCARA")
Private cString 		:=	"SN4"

If Upper(Alltrim(__CRDD)) <> "TOPCONN"
	MsgStop("Este relatorio somente podera ser executado na versao SQL do SIGA Advanced.")
Else
	//AjustaSx1("RTE130",aPergs)
	
	Pergunte(cPerg,.t.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.t.,aOrd,.t.,Tamanho,,.t.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := iif(aReturn[4]==1,15,18)
	
	RptStatus( { || RunReport(Cabec1,Cabec2,Titulo,nLin) } , Titulo )
EndIf
	
Return

/***************************************************************************/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local pTotGeral
Local cQry
Local aVend	  := {}
Local aMotivo := {}
Local aResumo := {}
Local aTipoOco:= {}

DbSelectArea("SN4")            

cQry	:= " SELECT N4_FILIAL,N4_MOTIVO,SUBSTRING(N4_DATA,1,6) AS ANOMES,N4_CONTA,N4_TIPOCNT,N4_OCORR, "
cQry	+= "        N4_TIPO,SUM(N4_VLROC1) AS REAL, "
cQry 	+= "        SUM(N4_VLROC3) AS UFIR "
cQry 	+= " FROM " + RetSqlName("SN4") + " SN4 , "
cQry 	+= 			  RetSqlName("SN1") + " SN1   "
cQry 	+= " WHERE SN1.N1_CBASE = SN4.N4_CBASE AND "
cQry 	+= "       SN1.N1_ITEM  = SN4.N4_ITEM  AND "
cQry 	+= "       SN1.N1_FILIAL = '"		 	+ xFilial("SN1")	+ "' AND "
cQry 	+= "       SN1.N1_CBASE BETWEEN '" 	+ mv_par03			+ "' AND '" + mv_par04			+"' AND "
cQry 	+= "       SN1.D_E_L_E_T_ = ' ' AND "
cQry 	+= "       SN4.N4_FILIAL = '"		 	+ xFilial("SN4")	+ "' AND "
cQry 	+= "       SN4.N4_CONTA BETWEEN '" 	+ mv_par01			+ "' AND '" + mv_par02			+"' AND "
cQry 	+= "       SN4.N4_CBASE BETWEEN '" 	+ mv_par03			+ "' AND '" + mv_par04			+"' AND "
cQry 	+= "       SN4.N4_DATA  BETWEEN '" 	+ dtos(mv_par05)	+ "' AND '" + dtos(mv_par06)	+"' AND "
cQry 	+= "       SN4.D_E_L_E_T_ = ' ' "
cQry 	+= " GROUP BY N4_FILIAL,N4_MOTIVO,N4_CONTA,SUBSTRING(N4_DATA,1,6),N4_TIPOCNT,N4_OCORR,N4_TIPO "
cQry 	+=	" ORDER BY N4_FILIAL,N4_CONTA,SUBSTRING(N4_DATA,1,6),N4_OCORR,N4_TIPOCNT "
cQry	:=	ChangeQuery(cQry)

TcQuery cQry New Alias "TRB"

aTipoOco:={ OemToAnsi("Baixa           "),; 					// "Baixa            "  1  - 01
				OemToAnsi("Substituicao    "),;             	// "Substituicao     "  2  - 02
				OemToAnsi("Transf. de "     ),;             	// "Transf. de "        3  - 03
				OemToAnsi("Transf. p/ "     ),;             	// "Transf. p/ "        4  - 04
				OemToAnsi("Implantac no mes"),;             	// "Implantac no mes"   5  - 05
				OemToAnsi("Depreciac no mes"),;             	// "Depreciac no mes"   6  - 06
				OemToAnsi("Correcao no mes "),;             	// "Correcao no mes "   7  - 07
				OemToAnsi("Corr Monet Depre"),;             	// "Corr Monet Depre"   8  - 08
				OemToAnsi("Ampliacao "      ),;             	// "Ampliacao "         9  - 09
				OemToAnsi("Acel. Positiva"  ),;             	// "Acel. Positiva"    10  - 10
				OemToAnsi("Acel. Negativa"  ),;             	// "Acel. Negativa"    11  - 11
				OemToAnsi("Inventario"      ),;             	// "Invent rio"        12  - 13
				OemToAnsi("Baixa por Transf"),;             	// "Baixa por Transf"  13  - 15
				OemToAnsi("Aquis por Transf") }             	// "Aquis por Transf"  14  - 16
				
dbSelectArea("SX5")
dbSeek(cFilial+"16")
While SX5->X5_FILIAL + SX5->X5_TABELA == cFilial + "16"
	aAdd( aMotivo, SubStr(SX5->X5_CHAVE,1,2) + "-" + SubStr(Capital(X5Descri()),01,12))
	dbSkip()
Enddo

pTotCtaGer1  := 0
pTotCtaGer2  := 0
pResumo      := {}
jResumo      := {}

dbselectarea("TRB")
SetRegua(RecCount())
dbGoTop()

WHILE !EOF()

	pConta			:=	TRB->N4_FILIAL+TRB->N4_CONTA
	ImpConta			:= .t.
	pTotCtaMoeda1  := 0
	pTotCtaMoeda2  := 0
	xResumo        := {}
	aResumo        := {}
	
	WHILE !EOF() .AND. TRB->N4_FILIAL+TRB->N4_CONTA == pConta
		
		pAnoMes		:= TRB->ANOMES
		ImpAnoMes	:= .t.
		
		WHILE !Eof() .AND. TRB->N4_FILIAL+TRB->N4_CONTA == pConta .AND. TRB->ANOMES == pAnoMes
			
			IF TRB->REAL > 0 .AND. TRB->UFIR > 0
				
				If nLin > 55
					Cabec(TRIM(Titulo)+'  '+dtoc(mv_par05)+" a "+dtoc(mv_par06),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8

					ImpConta := .t.
					ImpAnoMes:= .t.
				Endif
				
				If Val(TRB->N4_OCORR) >= 13
					If TRB->N4_OCORR == "13"
						cOcorre :=aTipoOco[12]
					ElseIf TRB->N4_OCORR == "15"
						cOcorre :=aTipoOco[13]
					ElseIf TRB->N4_OCORR == "16"
						cOcorre :=	aTipoOco[14] 
						cOcorre +=	iif( TRB->N4_OCORR $ "03/04" , " " + Alltrim(Subst(TRB->N4_CONTA,01,20)) , "" )	
					Else
						cOcorre :=	aTipoOco[15] 
						cOcorre +=	iif( TRB->N4_OCORR $ "03/04" , " " + Alltrim(Subst(TRB->N4_CONTA,01,20)) , "" )
					Endif
				Else
					cOcorre := 	Alltrim(aTipoOco[Val(TRB->N4_OCORR)])
					cOcorre +=	iif( TRB->N4_OCORR $ "03/04" , " " + Alltrim(Subst(TRB->N4_CONTA,01,20)) , "" )
				Endif

				cOcorre :=	Alltrim(cOcorre)
				cMotivo := 	iif(Empty(TRB->N4_MOTIVO)," ",aMotivo[Val(TRB->N4_MOTIVO)])
				
				IF ImpConta
					nLin++
					@nLin,005 PSay TRIM(Mascara(TRB->N4_CONTA))+" "+POSICIONE("CT1",1,xFilial("CT1")+TRB->N4_CONTA,"CT1_DESC01")
					nLin+=2
					ImpConta := .f.
				ENDIF
				
				IF ImpAnoMes
					@nLin,011 PSay Substr(TRB->ANOMES,5,2)+"/"+Substr(TRB->ANOMES,1,4)
					ImpAnoMes:= .f.
				ENDIF  
				
				//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
				//0         1         2         3         4         5         6         7         8         9         0         1         2         3
				//"    Conta Contabil                                                             "
				//"          Mes/Ano  Tp Movimento      Motivo Mov.            Real           Ufir"
				//     132.04.0001 - Informatica
				
				//           01/2007  01 Implantacao                  999,999,999.99 9,999,999.9999
				//                    02 Baixa          05-Avaria     999,999,999.99 9,999,999.9999
				//                    06 Depreciacao                  999,999,999.99 9,999,999.9999
				
				//           02/2007  01 Implantacao                  999,999,999.99 9,999,999.9999
				//                    02 Implantacao                  999,999,999.99 9,999,999.9999
				//                    06 Implantacao                  999,999,999.99 9,999,999.9999
				

				if	Len( Alltrim(cOcorre) ) <= 17
					@ nLin,020 PSay Alltrim(cOcorre)
					if	!Empty(Alltrim(cMotivo))
						@ nLin,038 PSay Alltrim(cMotivo)
   				endif
   			elseif Len( cOcorre ) > 18
					if	Empty(Alltrim(cMotivo))
						@ nLin,020 PSay Substr( Alltrim(cOcorre) , 01 , 29 )
					else
						@ nLin,020 PSay cOcorre
						nLin ++
						@ nLin,038 PSay Alltrim(cMotivo)
					endif
				endif	

				@nLin,052 PSay TRB->REAL    PICTURE "@E 99,999,999.99"
				@nLin,067 PSay TRB->UFIR    PICTURE "@E 9,999,999.9999"
				
				nLin ++
				
				i := aScan( aResumo , TRB->N4_CONTA + aTipoOco[Val(TRB->N4_OCORR)] )
				
				IF i > 0
					xResumo[i,2] += TRB->REAL
					xResumo[i,3] += TRB->UFIR
					xResumo[i,4] += 1
				ELSE
					AADD(xResumo,{ aTipoOco[Val(TRB->N4_OCORR)] , TRB->REAL , TRB->UFIR , 0 } )
					AADD(aResumo,TRB->N4_CONTA+aTipoOco[Val(TRB->N4_OCORR)])
				ENDIF
				
				X:= ASCAN(jResumo,aTipoOco[Val(TRB->N4_OCORR)])
				
				IF X > 0
					pResumo[x,2] +=TRB->REAL
					pResumo[x,3] +=TRB->UFIR
					pResumo[x,4] +=1
				ELSE
					AADD(pResumo,{aTipoOco[Val(TRB->N4_OCORR)],TRB->REAL,TRB->UFIR,0})
					AADD(jResumo,aTipoOco[Val(TRB->N4_OCORR)])
				ENDIF				
			ENDIF			
			TRB->(DBSKIP())			
		ENDDO		
	ENDDO
	
	FOR J:= 1 TO LEN(xResumo)
		
		If nLin > 55
			Cabec(TRIM(Titulo)+'  '+dtoc(mv_par05)+" a "+dtoc(mv_par06),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			ImpConta := .t.
			ImpAnoMes:= .t.
		Endif
		
		nLin ++
		
		@nLin,011 PSay "Total :  " + xResumo[j,1]
		@nLin,051 PSay xResumo[j,2]  PICTURE "@E 999,999,999.99"
		if	xResumo[j,3] <= 9999999.9999
			@nLin,067 PSay xResumo[j,3]  PICTURE "@E 9,999,999.9999"
		else
			@nLin,067 PSay xResumo[j,3]  PICTURE "@E 99999,999.9999"
		endif
	next j
	
	nLin ++	
ENDDO

nLin += 2

@ nLin , 011 PSay "======= R E S U M O   D E :( " + DtoC(mv_par05) + " a " + DtoC(mv_par06) + " ) ======"

nLin ++

For iJ:= 1 To Len(pResumo)	
	If nLin > 55
		Cabec(Trim(Titulo) + '  ' + dtoc(mv_par05) + " a " + dtoc(mv_par06),Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		ImpConta := .t.
		ImpAnoMes:= .t.
	Endif
	
	nLin++                              
	
	@nLin,011 PSay pResumo[ij,1]
	@nLin,051 PSay pResumo[iJ,2] Picture "@E 9999,999,999.99"
	@nLin,067 PSay pResumo[iJ,3] Picture iif(pResumo[iJ,3] <= 9999999.9999,"@E 9,999,999.9999","@E 99999,999.9999")
NEXT iJ

nLin ++

IF nLin != 80
	Roda(cbcont,cbtxt,Tamanho)
EndIF

If ( aReturn[5] = 1 ) 	// Se Saida para disco, ativa (desvia para)SPOOL
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()

dbSelectArea( "TRB" )
DBCLOSEAREA()

Return

/*************************************************************************/

Static Function AjustaSX1(cPerg, aPergs)

Local nCondicao
Local nJ				:= 0
Local nX 			:= 0
Local cKey			:= ""
Local lAltera		:= .f.
Local _sAlias		:= Alias()
Local aCposSX1		:=	{ 	"X1_PERGUNT" ,"X1_PERSPA"  ,"X1_PERENG"  ,"X1_VARIAVL" ,"X1_TIPO"  ,;
								"X1_TAMANHO" ,"X1_DECIMAL" ,"X1_PRESEL"  ,"X1_GSC"     ,"X1_VALID" ,;
								"X1_VAR01"   ,"X1_DEF01"   ,"X1_DEFSPA1" ,"X1_DEFENG1" ,"X1_CNT01" ,;
								"X1_VAR02"   ,"X1_DEF02"   ,"X1_DEFSPA2" ,"X1_DEFENG2" ,"X1_CNT02" ,;
								"X1_VAR03"   ,"X1_DEF03"   ,"X1_DEFSPA3" ,"X1_DEFENG3" ,"X1_CNT03" ,;
								"X1_VAR04"   ,"X1_DEF04"   ,"X1_DEFSPA4" ,"X1_DEFENG4" ,"X1_CNT04" ,;
								"X1_VAR05"   ,"X1_DEF05"   ,"X1_DEFSPA5" ,"X1_DEFENG5" ,"X1_CNT05" ,;
								"X1_F3"      , "X1_GRPSXG" , "X1_PYME"   ,"X1_HELP"    }
								              
Aadd(aPergs,{"Da Conta	  ?","","","mv_ch1","C",20,0,0,"G","","MV_PAR01","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
Aadd(aPergs,{"Ate Conta   ?","","","mv_ch2","C",20,0,0,"G","","MV_PAR02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","","CT1"})
Aadd(aPergs,{"Do Bem      ?","","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
Aadd(aPergs,{"Ate o Bem   ?","","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","","SN1"})
Aadd(aPergs,{"Da Data     ?","","","mv_ch5","D",08,0,0,"G","","MV_PAR05","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","","   "})
Aadd(aPergs,{"Ate Data    ?","","","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","      ","","","","","","","","","","","","","","","","","","","","","","","","","   "})

dbSelectArea("SX1")
dbSetOrder(1)

For nX:=1 to Len(aPergs)
	
	lAltera := .f.

	If	MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If ValType(aPergs[nX,Len(aPergs[nx])] == "B" .and. Eval(aPergs[nX,Len(aPergs[nx])],aPergs[nX]))
			aPergs[nX] 	:=	aSize(aPergs[nX],Len(aPergs[nX]) - 1)
			lAltera 		:=	.t.
		Endif
	Endif
	
	If	!lAltera .and. Found() .And. X1_TIPO <> aPergs[nX,5]
		lAltera := .t.		
	Endif
	
	If !Found() .Or. lAltera

		RecLock("SX1",iif(lAltera,.f.,.t.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11],02)
		For nj:=1 to Len(aCposSX1)
			If	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And. FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()

		cKey 		:= "P." + AllTrim(X1_GRUPO) + AllTrim(X1_ORDEM) + "."			
		aHelpSpa := iif(ValType(aPergs[nx][Len(aPergs[nx])])   == "A",aPergs[nx][Len(aPergs[nx])]  ,{})
		aHelpEng := iif(ValType(aPergs[nx][Len(aPergs[nx])-1]) == "A",aPergs[nx][Len(aPergs[nx])-1],{})
		aHelpPor := iif(ValType(aPergs[nx][Len(aPergs[nx])-2]) == "A",aPergs[nx][Len(aPergs[nx])-2],{})
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return

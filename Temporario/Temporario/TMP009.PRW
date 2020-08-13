#include "rwmake.ch"
#include "topconn.ch"

/*
/////////////////////////////////////////////////////////////////////////////
// Programa ³RTCR107   | Autor ³ Claudio Ferreira      | Data ³  23/05/07  //
//=========================================================================//
// Descricao ³ Relatorio realizado dos Titulos por natureza                //
//=========================================================================//
// ATUALIZACOES SOFRIDAS                                                   //
//-------------------------------------------------------------------------//
// 02/06/08 - Rafael - incluido tratamento de multiplas naturezas          //
/////////////////////////////////////////////////////////////////////////////
*/

//User Function RTCR107()
User Function TMP009()

Local nMoeda
Local cTexto
Local cDesc1 	 :=	"Emissao do Relatorio por Natureza"  
Local cDesc2 	 :=  "Realizado"  
Local cDesc3 	 :=	""
Local cString	 :=	""
Local aRegs      :=	{}
Local aPergs     :=	{}

Private Li       :=	80
Private nLin     :=	80
Private m_pag    := 01
Private nColun   :=	00
Private nLastKey := 00
Private aLinha   := {} 
Private Cabec1   := ""
Private Cabec2   := ""
Private Tamanho  := "G"
Private wnrel 	 :=	"RTCR107"  
Private cPerg 	 :=	"RTC107    "
Private NomeProg :=	"RTCR107"
Private Titulo   := "MAPA GERENCIAL FINANCEIRO - REALIZADO"
Private aReturn  := {"Zebrado",01,"Administracao",01,02,01,"",01}

DbSelectArea("SE5")
DbSetOrder(1)

AjustaSx1(cPerg,aPergs)

If !Pergunte(cPerg,.T.)
	Return
Endif

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If	nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := iif( aReturn[4] == 1 , 15 , 18 )

RptStatus( { || RunReport(Cabec1,Cabec2,Titulo,nLin) } , Titulo )

Return

/*
/////////////////////////////////////////////////////////////////////////////
// Programa ³RunReport | Autor ³ Claudio Ferreira      | Data ³  23/05/07  //
//=========================================================================//
// Descricao ³ Efetua impressao do relatorio                               //
/////////////////////////////////////////////////////////////////////////////
*/
Static Function RunReport(Cabec1,Cabec2,Titulo)

Local cDesc
Local nPos  	  := 0
Local nCount	  := 0
Local aImp		  := {}
Local nTam		  := Len(CriaVar("ED_CODIGO",.f.))
Local nPosVal     := 0
Local nPosNat 	  := 0

Private i
Private ColIni
Private cQuery
Private cChave
Private cOrder

Private aQtde  	  := {}
Private aChav  	  := {}
Private aTotSub   := {}
Private aNumped   := {}
Private aCabPed   := {}
Private psub 	  := 00
Private aCabPed2  := {}
Private ImprTotal := .f.
Private pDtIni 	  := mv_par05
Private pDtFim 	  := mv_par06
Private aMAPREG   := {} 
Private aTMPREG   := {} 
Private aNATPREG  := {} 
Private aNATRAT1  := {} 

////////////////////////////////////
//  Monta cabecalho do relatorio  //
////////////////////////////////////

Cabec1	:=	"PERIODO DOS TITULOS :  " + DtoC(pDtIni) + " a " + DtoC(pDtFim) + Space(10)
Cabec1  +=	"Do  Banco: " 	+ mv_par07 	+ Space(05)	+ "Agencia: " 	+ mv_par08	+ Space(05)	+ " Conta: "	+ mv_par09	+ Space(05) 
Cabec1	+=	"ao Banco: " 	+ mv_par10	+ Space(05) + "Agencia: " 	+ mv_par11 	+ Space(05)	+ " Conta: " 	+ mv_par12

//Regua de progresso do relatorio
DbSelectArea("SE5")

cFilterUser	:=	iif( Type("aReturn[7]") == "U" , " " , aReturn[7] )


////////////////////////////////////////////////////////////////////////////////////////////////////
//  Monta consulta temporaria com as movimentacoes bancarias que serao consideradas no relatorio  //
////////////////////////////////////////////////////////////////////////////////////////////////////

cQuery		:= " Select * "
cQuery 		+= " From " + RetSqlName("SE5")
cQuery 		+= " Where E5_FILIAL Between '" + mv_par01 		+ "' and '" + mv_par02 		+ "' and "
//cQuery 		+= 	"	  E5_NATUREZ Between '" + mv_par03		+ "' and '" + mv_par04 		+ "' and " //filtro sera realizado na inclusao do arquivo temporario
cQuery 		+= 	"	  E5_BANCO   Between '" + mv_par07		+ "' and '" + mv_par10		+ "' and "
cQuery 		+= 	"	  E5_AGENCIA Between '" + mv_par08		+ "' and '" + mv_par11		+ "' and "
cQuery 		+= 	"	  E5_CONTA   Between '" + mv_par09		+ "' and '" + mv_par12   	+ "' and "
cQuery 		+= 	"	  E5_DATA 	 Between '" + DtoS(pDtIni)	+ "' and '" + DtoS(pDtFim)	+ "' and "
If mv_par15 == 1
	cQuery 	+=		"	  E5_MOTBX <> '   ' and E5_MOEDA <> 'M1' and E5_CLIFOR <> '     ' and "
Endif	
cQuery 		+=		"    D_E_L_E_T_ = ' ' "
cQuery 		+=	" Order By E5_FILIAL , E5_NATUREZ , E5_DATA "
cQuery 		:=	ChangeQuery(cQuery)

//Verifica se alias estah em uso
If Select("_MAP") > 0
	_MAP->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "_MAP"

//////////////////////////////////////////////////////////////////////
//  MONTA ARQUIVO DE TRABALHO TEMPORARIO DOS MOVIMENTOS SINTETICOS  //
//////////////////////////////////////////////////////////////////////

//Verifica se o alias temporario estah em uso
If chkfile("MAP")
	dbselectArea("MAP")
	dbCloseArea()
EndIf

//Carrega campos a serem criados
aCMPSE5 := {}
SX3->(DbSetOrder(1))
SX3->(DbSeek("SE5"))
While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SE5"

	//Ajusta campos tipo data
	If SX3->X3_TIPO == 'D'
		//Inclui campos no array para criacao do arquivo de trabalho
		AADD(aCMPSE5,{SX3->X3_CAMPO,'C',SX3->X3_TAMANHO,SX3->X3_DECIMAL})	
	Else
		//Inclui campos no array para criacao do arquivo de trabalho
		AADD(aCMPSE5,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	Endif
	
	//Proximo campo
	SX3->(DbSkip())
Enddo

//Cria arquivo de trabalho temporario
cArqTmp := CriaTrab(aCMPSE5,.T.)
DbUseArea(.T.,__LocalDriver,cArqTmp,"MAP",.F.,.F.)

//Cria indice para o arquivo temporario
dbSelectArea("MAP")
cIndex1 := CriaTrab(nil,.f.)
IndRegua("MAP",cIndex1,"E5_FILIAL+E5_NATUREZ+E5_DATA",,,OemToAnsi("Criando indice temporario..."))
dbClearIndex()

//Cria indice para o arquivo temporario
dbSelectArea("MAP")
cIndex2 := CriaTrab(nil,.f.)
IndRegua("MAP",cIndex2,"E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ",,,OemToAnsi("Selecionando Registros..."))
dbClearIndex()

//Testa indices
DbSetIndex(cIndex1 + OrdBagExt())
DbSetIndex(cIndex2 + OrdBagExt())

/////////////////////////////////////////////////////////////
//  Preenche arquivo de trabalho com os dados da consulta  //
/////////////////////////////////////////////////////////////
SEV->(DbSetOrder(1)) //EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ                                                                                     
MAP->(DbSetIndex(cIndex2 + OrdBagExt())) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
MAP->(DbGoTop())
While !_MAP->(BOF()) .and. !_MAP->(EOF())
	
	aMAPREG := {}
	aNATREG := {}
	
	//Preenche array com os dados do registro encontrao no SE5  
	For e:=1 To Len(aCMPSE5)
		
		cCMPTMP := "_MAP->"+Alltrim(aCMPSE5[e][1])
		
		AADD(aMAPREG,{aCMPSE5[e][1],&(cCMPTMP)})   
	
	Next e
	
	//Posicoes a serem guardadas
	nPosVal := aScan( aMAPREG, { |x| Alltrim(x[1])=="E5_VALOR"  } )
	nPosNat := aScan( aMAPREG, { |x| Alltrim(x[1])=="E5_NATUREZ"} )
	
	//////////////////////////////////////////
	// EFETUA RATEIO DE MULTIPLAS NATUREZAS //
	//////////////////////////////////////////
	If MV_PAR16 == 2   //Sim
		//Verifica se existe rateio para esse titulo
		If SEV->(DbSeek(xFilial("SEV")+_MAP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
			
			//Enconta rateios para o titulo
			While !SEV->(BOF()) .and. !SEV->(EOF());
			.and. _MAP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ==  SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
			   		    
			    //Confirma carteira do titulo encontrado
			    If	(!Empty(_MAP->E5_CLIENTE) .and. SEV->EV_RECPAG == 'R') .or. (!Empty(_MAP->E5_FORNECE) .and. SEV->EV_RECPAG == 'P')
					AADD(aNATREG,{SEV->EV_NATUREZ,SEV->EV_PERC})		
				Endif
				
				SEV->(DbSkip())
			Enddo
	    Endif
    Endif
    
    //Caso nao exista, preenche array do rateio com os valores da baixa
    If Len(aNATREG) == 0
    	
    	//Natureza da movimentacao e 100% do valor 
    	AADD(aNATREG,{_MAP->E5_NATUREZ,1})
    Endif
	
	//Grava movimentacoes por multiplas naturezas	
	For e:=1 To Len(aNATREG)

		//Ajusta valores da movimentacao
		aMAPREG[nPosNat][2] := aNATREG[e][1]  //altera natureza
		aMAPREG[nPosVal][2] := Round((_MAP->E5_VALOR * aNATREG[e][2]),2)  //recalcula valor
        
		//Verifica naturezas parametrizadas
		If aMAPREG[nPosNat][2] >= MV_PAR03 .and. aMAPREG[nPosNat][2] <= MV_PAR04
			RecLock("MAP",.T.)
			AEval(aMAPREG, {|x| FieldPut(FieldPos(x[1]), x[2])})
			DbCommit()
			MsUnLock()
		Endif
	Next e
	
	_MAP->(Dbskip())
Enddo

//////////////////////////////////////////////////////////////////////
//  MONTA ARQUIVO DE TRABALHO TEMPORARIO DOS MOVIMENTOS ANALITICOS  //
//////////////////////////////////////////////////////////////////////
If MV_PAR13 == 2 //ANALITICO

	//Verifica se o alias temporario estah em uso
	If chkfile("QANA")
		dbselectArea("QANA")
		dbCloseArea()
	EndIf
	
	//Campos a serem criados
	aCMPSE5 := {}
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SE5"))
	While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "SE5"
	
		//Ajusta campos tipo data
		If SX3->X3_TIPO == 'D'
			//Inclui campos no array para criacao do arquivo de trabalho
			AADD(aCMPSE5,{SX3->X3_CAMPO,'C',SX3->X3_TAMANHO,SX3->X3_DECIMAL})	
		Else
			//Inclui campos no array para criacao do arquivo de trabalho
			AADD(aCMPSE5,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		
		//Proximo campo
		SX3->(DbSkip())
	Enddo
	
	//Cria arquivo de trabalho temporario
	cArqTmp2 := CriaTrab(aCMPSE5,.T.)
	DbUseArea(.T.,__LocalDriver,cArqTmp2,"QANA",.F.,.F.)
	
	//Cria indice para o arquivo temporario
	DbSelectArea("QANA")
	cIndAn1 := CriaTrab(nil,.f.)
	IndRegua("QANA",cIndAn1,"E5_NATUREZ+E5_DATA",,,OemToAnsi("Criando indice temporario..."))
	dbClearIndex()
	
	//Cria indice para o arquivo temporario
	DbSelectArea("QANA")
	cIndAn2 := CriaTrab(nil,.f.)
	IndRegua("QANA",cIndAn2,"E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ",,,OemToAnsi("Selecionando Registros..."))
	dbClearIndex()
	
	//Testa indices
	DbSetIndex(cIndAn1 + OrdBagExt())
	DbSetIndex(cIndAn2 + OrdBagExt())
	
	//////////////////////////////////////////////////////////////////
	//  Preenche arquivo de trabalho com os dados do arquivo "MAP"  //
	//////////////////////////////////////////////////////////////////
	QANA->(DbSetIndex(cIndAn2 + OrdBagExt())) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	MAP->(DbSetIndex(cIndex2 + OrdBagExt())) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
	MAP->(DbGoTop())
	While !MAP->(BOF()) .and. !MAP->(EOF())
		
		aMAPREG := {}
				
		//Preenche array com os dados do registro encontrao no SE5  
		For e:=1 To Len(aCMPSE5)
			
			cCMPTMP := "MAP->"+Alltrim(aCMPSE5[e][1])
			
			AADD(aMAPREG,{aCMPSE5[e][1],&(cCMPTMP)})   
		
		Next e
		
		//Inclui registro		
		RecLock("QANA",.T.)
		AEval(aMAPREG, {|x| FieldPut(FieldPos(x[1]), x[2])})
		DbCommit()
		MsUnLock()
		
		MAP->(Dbskip())
	Enddo
Endif

///////////////////////////
// EXECUCAO DO RELATORIO //
///////////////////////////

DbSelectArea("MAP")
DbSetIndex(cIndex1 + OrdBagExt())
Count To nCount
SetRegua(nCount)          
Alert(nCount)

DbGoTop()                   

Do While !MAP->(Eof())         
	
	aImp		:= {}	
	aCor     	:= {}
	aCor2    	:= {}
	aQtde    	:= {}
	aQtde2   	:= {}
	aChave   	:= {}
	aChave2  	:= {}
	aTotCor  	:= {}
	aNumPed  	:= {}
	aCabPed  	:= {}
	aCabPed2 	:= {}
	aTitulos 	:= {}
	aImprCor 	:= {}
	aImprCor2	:= {}
	aFilial 	:= MAP->E5_FILIAL
		
	Do While !MAP->(Eof()) .and. aFilial == MAP->E5_FILIAL
		
		IncRegua()
		
		IF MAP->E5_TIPODOC $ "TR/DC/JR/MT/CM/D2/J2/M2/C2/TL/CP/BL" .or. MAP->E5_SITUACA $ "C/X/E"
			MAP->(dbSkip())
			Loop
		EndIF		

		If TemBxCanc(MAP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
			MAP->(dbSkip())
			Loop
		EndIf    
		
		If MAP->E5_TIPODOC == "CH"
			if	Alltrim(MAP->E5_NATUREZ) $ "9999999/NTCHEST" 
				MAP->(dbSkip())
				Loop
			EndIF
			dbSelectArea("SEF")
			dbSetOrder(1)
			If dbSeek(xFilial("SEF")+MAP->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ))
				If SEF->EF_ORIGEM != "FINA390AVU"
					dbSelectArea("MAP")
					MAP->(dbSkip())
					Loop
				Endif

			//Tratamento para cheques avulsos que foram sofreram estorno no SE5 e foram deletados do SEF
			ElseIf fValCheq(MAP->E5_FILIAL;
			               ,MAP->E5_BANCO;
			               ,MAP->E5_AGENCIA;
			               ,MAP->E5_CONTA;
			               ,MAP->E5_NUMCHEQ;
			               ,If(Empty(MAP->E5_SEQ),"01",MAP->E5_SEQ);
			               ,MAP->E5_VALOR)
				   
				    dbSelectArea("MAP")
					MAP->(dbSkip())
					Loop
			Endif
		Endif		
		
		If MAP->E5_TIPODOC == "EP"
			aAreaSE5 := MAP->(GetArea())
			dbSelectArea("SEH")
			dbSetOrder(1)
			lAchouEmp := MsSeek( xFilial("SEH") + Substr(MAP->E5_DOCUMEN,1,nTamEH) )
			RestArea(aAreaSE5)
			If !lAchouEmp
				MAP->(dbSkip())
				Loop
			EndIf
		EndIf
		
		If MAP->E5_TIPODOC == "PE"
			aAreaSE5 := MAP->(GetArea())
			dbSelectArea("SEI")
			dbSetOrder(1)
			If	MsSeek(xFilial("SEI")+"EMP"+Substr(MAP->E5_DOCUMEN,1,nTamEI))
				lAchouEst := iif( SEI->EI_STATUS == "C" , .t. , .f. )
			EndIf
			RestArea(aAreaSE5)
			If lAchouEst
				MAP->(dbSkip())
				Loop
			EndIf
		EndIf				
		
		If !Empty(MAP->E5_MOTBX)
			if mv_par14 == 2
				//ALTERADO PARA CONTEMPLAR COMPENSAO DE PERMUTA  E REPASSE
				If !MovBcoBx(MAP->E5_MOTBX) .and. !MAP->E5_MOTBX $ "CEC" 
					MAP->(dbSkip())
					Loop
				endif
			else
				If !MovBcoBx(MAP->E5_MOTBX)
					MAP->(dbSkip())
					Loop
				endif
			endif
		endif

		aMes	:=	StrZero(Month(StoD(MAP->E5_DATA)),2)
		aAno 	:=	StrZero(Year(StoD(MAP->E5_DATA)),4)

		x := aScan(aCabPed2,aAno+aMes)

		if	x == 0
			aAdd( aCabPed2 , aAno + aMes )
		endif
				
		For xI = 1 to 3

			xTam := iif( xI == 1 , 2 , iif( xI == 2 , 4 , 7 ))		

			nValor := MAP->E5_VALOR 

			if ( MAP->E5_RECPAG == 'R' .and. Substr(MAP->E5_NATUREZ,01,02) == '12' ) .or. ;
				( MAP->E5_RECPAG == 'P' .and. Substr(MAP->E5_NATUREZ,01,02) == '11' ) 
				nValor *= -1
			endif

			cDesc	:=	StrZero(Month(StoD(MAP->E5_DATA)),02) 
			cDesc	+=	StrZero( Year(StoD(MAP->E5_DATA)),04) 
			cDesc	+=	Left(MAP->E5_NATUREZ,xTam) + Space( 10 - xTam )
					
			i := aScan( aChave , cDesc )

			If i > 0
				aQtde[i]  += nValor
			Else
				AADD(aQtde 		, nValor )
				AADD(aChave 	, cDesc  )
				AADD(aImprCor	, Left(MAP->E5_NATUREZ,xTam) + Space( 10 - xTam ) )
			Endif
		Next xI

		MAP->(Dbskip())		
	Enddo
	
	aSort(aCabPed2)
	
	ColIni 	:=	1
	l      	:= 0
	nLin	:=	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))

	ImprSubCab(ColIni) 

	While ColIni<= Len(aCabPed2) .and. Len(aCabPed2) > 0
		
		dbSelectArea("SED")
		dbgotop()
		
		aTotRec := {0,0,0,0,0,0,0,0,0,0,0,0,0}
		aTotDes := {0,0,0,0,0,0,0,0,0,0,0,0,0}
		aTotGer := {0,0,0,0,0,0,0,0,0,0,0,0,0} //Acumulador das naturezas genéricas
		
		Do While !SED->(Eof())
			
			if nLin > 55
				nLin++
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,GetMv("MV_COMP"))
				ImprSubCab(ColIni)
			endif
			
			k := aScan( aImprCor , SED->ED_CODIGO )
			
			if k > 0

				Impressa := .T.

				j:= ASCAN(aCor, SED->ED_CODIGO)

				if j > 0
					pSub := aTotCor[j]
					Impressa := .f.
				else
					pSub := 0
					AADD(aCor, SED->ED_CODIGO)
					AADD(aTotCor, 0)
					j:= Len(aTotCor)
				endif

				If Impressa
				
					If Len(alltrim(SED->ED_CODIGO))<=4
						nLin++
					Endif
					If SED->ED_GENERIC <> '2' .or. mv_par13 ==2  //Analitico
						nLin++
						@ nLin,000 PSAY " "
						@ nLin,002 PSAY LEFT(TRIM(SED->ED_CODIGO)+" "+SED->ED_DESCRIC,34)
					Endif

					pColuna := 0

					Do While pColuna < 12
						If SED->ED_GENERIC <>'2' .or. mv_par13==2  //Analitico
							@ nLin,036 + (pColuna * 14) PSAY " "
						Endif
						If Len(aCabPed2) >= ColIni + pColuna							
							I := aScan(aChave,substr(aCabPed2[ColIni + pColuna],5,2)+Left(aCabPed2[ColIni + pColuna],4)+SED->ED_CODIGO)
							IF I > 0 .and. i <= Len(aqtde) .and. aQtde[i] <> 0
								If SED->ED_GENERIC<>'2' .or. mv_par13==2  //Analitico
									@ nLin,037 + (pColuna * 14) PSAY aQtde[i] PICTURE "@E 9,999,999.99"
								Endif
								pSub += aQtde[i]
								If Len(alltrim(SED->ED_CODIGO))>4
									If Substr(SED->ED_CODIGO,1,2) =='11' //Rec
										aTotRec[pColuna+1] += aQtde[i]
										aTotRec[13]        += aQtde[i]
									Else
										aTotDes[pColuna+1] += aQtde[i]
										aTotDes[13]        += aQtde[i]
									Endif
									If SED->ED_GENERIC == '2' .and. mv_par13 ==1  //Sintetico
										aTotGer[ pColuna+1 ] += aQtde[i]
										aTotGer[ 13 ] += aQtde[i]
									Endif
								Endif
							Endif
						Endif
						pColuna++
					EndDo

					if SED->ED_GENERIC <> '2' .or. mv_par13 == 2  //Analitico
						@ nLin,036 + (pColuna * 14) 			PSAY " "
						@ nLin,037 + (pColuna * 14) 			PSAY pSub      PICTURE "@E 99,999,999.99"
						@ nLin,036 + ((pColuna+ 1 ) * 14) 	PSAY " "
					endif

					If Len(alltrim(SED->ED_CODIGO)) == 7 .and. mv_par13 == 2  //Analitico     
						
						nLin ++

						@ ++ nLin,02 PSAY "Prf Numero Par  Tip  Codigo     Beneficiario          Data Bx     Bco  Valor         Mot  Historico                "
						                // XXX-999999-AAA  XXX  999999/99  XXXXXXXXXXXXXXXXXXXX  99/99/9999  999  9,999,999.99  XXX  XXXXXXXXXXXXXXXXXXXXXXXXX
						DbSelectArea("QANA")
						QANA->(DbSetIndex(cIndAn1 + OrdBagExt()))
						QANA->(DbSeek(SED->ED_CODIGO))
						While !QANA->(Eof()) .AND. SED->ED_CODIGO == QANA->E5_NATUREZ
							
							//IncRegua()
							
							If TemBxCanc(QAna->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
								QAna->(dbSkip())
								Loop
							EndIf
							
							If QAna->E5_TIPODOC == "EP"
								aAreaSE5 := QAna->(GetArea())
								dbSelectArea("SEH")
								dbSetOrder(1)
								lAchouEmp := MsSeek(xFilial("SEH")+Substr(QAna->E5_DOCUMEN,1,nTamEH))
								RestArea(aAreaSE5)
								If !lAchouEmp
									QAna->(dbSkip())
									Loop
								EndIf
							EndIf
							
							If QAna->E5_TIPODOC == "PE"
								aAreaSE5 := QAna->(GetArea())
								dbSelectArea("SEI")
								dbSetOrder(1)
								If	MsSeek(xFilial("SEI")+"EMP"+Substr(QAna->E5_DOCUMEN,1,nTamEI))
									If SEI->EI_STATUS == "C"
										lAchouEst := .T.
									EndIf
								EndIf
								RestArea(aAreaSE5)
								If lAchouEst
									QAna->(dbSkip())
									Loop
								EndIf
							EndIf
							
							IF QAna->E5_TIPODOC $ "TR/DC/JR/MT/CM/D2/J2/M2/C2/TL/CP/BL" .or. QAna->E5_SITUACA $ "C/X/E"
								QAna->(dbSkip())
								Loop
							EndIF
							
							IF QAna->E5_NATUREZ $ "9999999   /NTCHEST   "  .and. QAna->E5_TIPODOC == "CH"
								QAna->(dbSkip())
								Loop
							EndIF
							
							If QAna->E5_TIPODOC == "CH"
								dbSelectArea("SEF")
								dbSetOrder(1)
								If dbSeek(xFilial("SEF")+QAna->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ))
									If SEF->EF_ORIGEM != "FINA390AVU"
										dbSelectArea("QAna")
										QAna->(dbSkip())
										Loop
									Endif
								
								//Tratamento para cheques avulsos que foram sofreram estorno no SE5 e foram deletados do SEF
								ElseIf fValCheq(QAna->E5_FILIAL;
								               ,QAna->E5_BANCO;
								               ,QAna->E5_AGENCIA;
								               ,QAna->E5_CONTA;
								               ,QAna->E5_NUMCHEQ;
								               ,If(Empty(QAna->E5_SEQ),"01",QAna->E5_SEQ);
								               ,QAna->E5_VALOR)
									   
									    dbSelectArea("QAna")
										QAna->(dbSkip())
										Loop
								Endif
							Endif
							
							If !Empty(QAna->E5_MOTBX)
								IF MV_PAR14 == 2
									If !MovBcoBx(QAna->E5_MOTBX) .and. !QAna->E5_MOTBX $ "CEC" //ALTERADO PARA CONTEMPLAR COMPENSAO DE PERMUTA  E REPASSE
										QAna->(dbSkip())
										LOOP
									EndIf
								ELSE
									If !MovBcoBx(QAna->E5_MOTBX)
										QAna->(dbSkip())
										LOOP
									EndIf
								ENDIF
							Endif
							
							nValor := QAna->E5_VALOR * iif((QAna->E5_RECPAG='R' .and. SUBSTR(QAna->E5_NATUREZ,1,2)='12') .or. (QAna->E5_RECPAG='P' .and. SUBSTR(QAna->E5_NATUREZ,1,2)='11'),-1,1)
							
							nLin++
							
							@ nLin,02 PSAY QAna->E5_Prefixo+"-"+QAna->E5_Numero+"-"+QAna->E5_Parcela+"  "+QAna->E5_Tipo+"  "+QAna->E5_CLIFOR+"/"+QAna->E5_Loja+"  "+Substr(QAna->E5_Benef,1,20)
							@ nLin,56 PSAY DTOC(STOD(QAna->E5_DATA))
							@ nLin,68 PSAY QAna->E5_BANCO
							@ nLin,pCol()+02 PSAY Transform(nValor,"@e 9,999,999.99")
							@ nLin,pCol()+02 PSAY QAna->E5_MOTBX
							@ nLin,pCol()+02 PSAY Substr(QAna->E5_Histor,1,90)
							
							IF nLin > 55
								nLin:=Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
								ImprSubCab(ColIni)
								nLin++
								@ nLin,000 PSAY " "
								@ nLin,002 PSAY LEFT(TRIM(SED->ED_CODIGO)+" "+SED->ED_DESCRIC,34)+" >> Em continuação << "
								nLin++
								@ ++ nLin,02 PSAY "Prf Numero Par  Tip  Codigo     Beneficiario          Data Bx     Bco  Valor         Mot  Historico                "
							ENDIF
							
							DbSelectArea("QAna")
							DbSkip()
						Enddo
						
						nLin++						
					
						DbSelectArea("QAna")
						 
					endif
					
					DbSelectArea("SED")
					
					aTotCor[j] := pSub
					
					SED->(dbskip())
					
					if SED->(Eof())
						NatProx := '99'
					else
						NatProx := SED->ED_CODIGO
					endif
					
					SED->(dbskip(-1))

					If Len(alltrim(NatProx))=4  .or. len(alltrim(NatProx))=2
						nTotGer := 0
						For nMes := 1 to 12
							If aTotGer[nMes] # 0
								nTotGer += aTotGer[nMes]
							Endif
						Next
						If nTotGer != 0
							nLin++
							@ nLin,000 PSAY "          OUTRAS DESPESAS GENERICAS"
							pColuna := 0
							
							While pColuna <= 12
								@ nLin,036 + (pColuna * 14) PSAY " "
								@ nLin,037 + (pColuna * 14) PSAY aTotGer[pColuna+1]  PICTURE "@EZ 9,999,999.99"
								aTotGer[pColuna+1] := 0
								pColuna++
							EndDo
							@ nLin,036 + (pColuna * 14) PSAY " "
						Endif
					endif
					If Len(alltrim(SED->ED_CODIGO))=4
						nLin++
					endif
				endif
			endif			
			SED->(dbskip())			
		enddo
		
		ColIni += 12
		
		nlin ++
		nlin ++
		
		@ nLin,000 PSAY "     TOTAL RECEITAS "
		
		pColuna := 0
		
		While pColuna <= 12
			@ nLin,036 + (pColuna * 14) PSAY " "
			@ nLin,037 + (pColuna * 14) PSAY aTotRec[pColuna+1]  PICTURE "@ZE 99,999,999.99"
			pColuna++
		EndDo                  
		
		@ nLin,036 + (pColuna * 14) PSAY " "

		nLin++
		nLin++

		@ nLin,000 PSAY "     TOTAL DESPESAS "

		pColuna := 0

		While pColuna <= 12
			@ nLin,036 + (pColuna * 14) PSAY " "
			@ nLin,037 + (pColuna * 14) PSAY aTotDes[pColuna+1]  PICTURE "@ZE 99,999,999.99"
			pColuna++
		EndDo
		@ nLin,036 + (pColuna * 14) PSAY " "
		nLin++
		NLIN++
		@ nLin,000 PSAY "     SALDO          "
		pColuna := 0
		While pColuna <= 12
			@ nLin,036 + (pColuna * 14) PSAY " "
			@ nLin,037 + (pColuna * 14) PSAY aTotRec[pColuna+1]-aTotDes[pColuna+1]  PICTURE "@ZE 99,999,999.99"
			pColuna++
		EndDo
		@ nLin,036 + (pColuna * 14) PSAY " "
		nLin++
		
		aTotCor[j] := {}		
	EndDo	
ENDDO

dbSelectArea("MAP")
dbCloseArea() 

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

Ms_Flush()

Return

/*********************************************************************************/

Static Function ImprSubCab(pInicio)

Local pColuna := 1

@ 09,000 PSAY "                                                                                  RELACAO "+iif(mv_par13==1,"SINTETICA","ANALITICA")+" DOS TITULOS - EM REAIS - REALIZADO "+SPACE(68)+"                "
@ 11,000 PSAY "  Codigo  Descricao da Natureza"
pColuna := 0
While pColuna < 12
	@ 11,036 + (pColuna * 14) PSAY " "
	If LEN(aCabPed2) >= pInicio+pColuna
		@ 11,038 + (pColuna * 14) PSAY Left(MesExtenso(substr(aCabPed2[pInicio + pColuna],5,2)),3)+"/"+substr(aCabPed2[pInicio + pColuna],1,4)
	EndIf
	pColuna++
EndDo
@ 11,036 + (pColuna * 14) PSAY " "
If LEN(aCabPed2) >= pInicio+pColuna
	@ 11,037 + (pColuna * 14) PSAY "SUB-TOTAL"
ELSEif .Not. ImprTotal
	@ 11,037 + (pColuna * 14)  PSAY "   TOTAL"
	ImprTotal := .t.
ELSE
	@ 11,037 + (pColuna * 14)  PSAY "   TOTAL"
EndIf

@ 11,036 + ((pColuna+1) * 14) PSAY " "
@ 12,000 PSAY "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin := 12

RETURN NIL

Static Function AjustaSX1(cPerg,aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
				"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
				"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
				"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
				"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
				"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
				"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
				"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

aAdd(aPergs,{"Filial De        ?","","","mv_ch1","C",02,0,1,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0","",""})
aAdd(aPergs,{"Filial Ate       ?","","","mv_ch2","C",02,0,1,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","XM0","",""})
aAdd(aPergs,{"Natureza De      ?","","","mv_ch3","C",09,0,1,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aPergs,{"Natureza Ate     ?","","","mv_ch4","C",09,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aPergs,{"Data    De       ?","","","mv_ch5","D",08,0,1,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Data    Ate      ?","","","mv_ch6","D",08,0,1,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Banco   De       ?","","","mv_ch7","C",03,0,1,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
aAdd(aPergs,{"Agencia De       ?","","","mv_ch8","C",05,0,1,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Conta   De       ?","","","mv_ch9","C",10,0,1,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Banco   Ate      ?","","","mv_cha","C",03,0,1,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
aAdd(aPergs,{"Agencia Ate      ?","","","mv_chb","C",10,0,1,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Conta   Ate      ?","","","mv_chc","C",10,0,1,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Imprimir Modo    ?","","","mv_chd","N",01,0,1,"C","","mv_par13","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Inclui Compensado?","","","mv_che","N",01,0,1,"C","","mv_par14","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Inclui Mov.Finan ?","","","mv_chf","N",01,0,1,"C","","mv_par15","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Rateio Naturezas ?","","","mv_chg","N",01,0,1,"C","","mv_par16","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .and.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .and. Found() .and. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .and. aPergs[nX][nJ] <> Nil .and.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return()

////////////////////////////////////////////////////////////////
//  VERIFICA SE O CHEQUE AVULSO SOBREU CANCELAMENTO DE BAIXA  //
////////////////////////////////////////////////////////////////
Static Function fValCheq(cChFil,cChBc,cChAg,cChCC,cChNum,cChSeq,nChVal)

Local lRet   := .F.
Local cQuery := ""
Local EOL    := " " + CHR(13) + CHR(10) + " "

cQuery := " SELECT DISTINCT 'S' RESULTADO   " + EOL
cQuery += " FROM %SE5% SE5                  " + EOL
cQuery += " WHERE                           " + EOL
cQuery += "     SE5.E5_FILIAL  = '%cChFil%' " + EOL
cQuery += " AND SE5.E5_BANCO   = '%cChBc%'  " + EOL
cQuery += " AND SE5.E5_AGENCIA = '%cChAg%'  " + EOL
cQuery += " AND SE5.E5_CONTA   = '%cChCC%'  " + EOL
cQuery += " AND SE5.E5_NUMCHEQ = '%cChNum%' " + EOL
cQuery += " AND SE5.E5_SEQ     = '%cChSeq%' " + EOL
cQuery += " AND SE5.E5_VALOR   = %nChVal%   " + EOL
cQuery += " AND SE5.E5_RECPAG  = 'R'        " + EOL
cQuery += " AND SE5.E5_TIPODOC = 'EC'       " + EOL

cQuery := StrTran(cQuery,"%SE5%"   ,RetSqlName("SE5"))
cQuery := StrTran(cQuery,"%cChFil%",cChFil           )
cQuery := StrTran(cQuery,"%cChBc%" ,cChBc            )
cQuery := StrTran(cQuery,"%cChAg%" ,cChAg            )
cQuery := StrTran(cQuery,"%cChCC%" ,cChCC            )
cQuery := StrTran(cQuery,"%cChNum%",cChNum           )
cQuery := StrTran(cQuery,"%cChSeq%",cChSeq           )
cQuery := StrTran(cQuery,"%nChVal%",Alltrim(Str(nChVal))) 

//Log para teste da consulta
Memowrite("\CHQ1.TXT",cQuery)

cQuery 		:=	ChangeQuery(cQuery)

//Verifica se o alias temporario estah em uso
If chkfile("CHQ1")
	dbselectArea("CHQ1")
	dbCloseArea()
End If

//Cria Alias temporario para a consulta
TcQuery cQuery New Alias "CHQ1"

//Verifica se foram encontrados resultados
DbSelectArea("CHQ1")
If Select("CHQ1") > 0
	//Verifica se o resultado eh positivo
	If 	CHQ1->RESULTADO == "S" 
		lRet := .T.
	Endif
Endif

Return lRet
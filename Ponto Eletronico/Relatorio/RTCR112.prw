#Include "RwMake.ch"
#Include "topconn.ch"
#Include "Protheus.ch"
#include "font.ch"

/*ºPrograma  ³RTCR112   º Autor ³ Edmilson Dias Santos  º Data ³  24/05/07º±±
±±ºPrograma  ³          º Autor ³ Claudio Ferreira      º Data ³  01/06/07º±±
±±ºDescricao ³Relatorio de Analise de Horas a Compensar até 90 dias.      º±±
±±ºUso       ³ Clientes Microsiga  -  RECORD                              º*/
                        
User Function RTCR112()

Local aOrd         := {}
Local aPergs       := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Apuracao Mensal de Banco de Horas"
Local cPict        := ""
Local titulo       := "APURACAO MENSAL DE BANCO DE HORAS"
Local Cabec1       := "MATRICULA NOME DO FUNCIONARIO         PERIODO A COMPENSAR     TOTAL DO SALDO"
Local Cabec2       := ""
Local imprime      := .T.
                         
Private nTipo      := 18
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTCR112"
PRIVATE nLin       := 0
Private cString
Private CbTxt      := ""
Private lEnd       := .F.
Private limite     := 220
Private Tamanho    := "M"
Private nomeprog   := "RTCR112"
Private aReturn    := {"Zebrado",1,"Administracao",1,2,1,"",1}  
Private nLastKey   := 0
Private cString    := "SPI"
Private cPerg      := "RTR112"

//dbSelectArea("SPI")
//dbSetOrder(1)

/*
Aadd(aPergs,{"Competencia MMAAAA ?","","","mv_ch1","C",6,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Matricula       ?","","","mv_ch2","C",6,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
Aadd(aPergs,{"Ate Matricula      ?","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
Aadd(aPergs,{"Do C.Custo         ?","","","mv_ch4","C",7,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
Aadd(aPergs,{"Ate C.Custo        ?","","","mv_ch5","C",7,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
Aadd(aPergs,{"Gravar SZA         ?","","","mv_ch6","N",1,0,0,"C","NaoVazio()","MV_PAR06","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","CTT","","","",""})
*/
AjustaSx1("RTR112",aPergs)

Pergunte(cPerg,.f.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//nTipo := iif(aReturn[4]==1,15,18)  

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*************************************************************************/

Static Function RunReport(Cabec1,Cabec2,titulo,nLin)

Local _cNome
Local nCount		:=	0
Local cDados		:=	""
Local aDados		:=	{}

Private j			:= 0
Private nPag  		:= 1
Private lEnc    	:= .f.
Private lPrimPag 	:=	.t.

Private oFont, cCode, oPrn

Private oFont1 	:=	tFont():New( "Arial",,16,,.t.,,,,,.f. )
Private oFont2 	:= tFont():New( "Arial",,16,,.f.,,,,,.f. )
Private oFont3 	:= tFont():New( "Arial",,10,,.t.,,,,,.f. )
Private oFont4 	:= tFont():New( "Arial",,10,,.f.,,,,,.f. )
Private oFont5 	:= tFont():New( "Arial",,08,,.t.,,,,,.f. )
Private oFont6 	:= tFont():New( "Arial",,08,,.f.,,,,,.f. )
Private oFont7 	:= tFont():New( "Arial",,14,,.t.,,,,,.f. )
Private oFont8 	:= tFont():New( "Arial",,14,,.f.,,,,,.f. )
Private oFont9 	:= tFont():New( "Arial",,12,,.t.,,,,,.f. )
Private oFont10	:= tFont():New( "Arial",,12,,.f.,,,,,.f. )
Private oFont11	:= tFont():New( "Arial",,07,,.t.,,,,,.f. )
Private oFont12	:= tFont():New( "Arial",,07,,.f.,,,,,.f. )
Private oFont16	:= tFont():New( "Arial",,16,,.f.,,,,,.f. )

Private oFont1c 	:= tFont():New( "Courier New",,16,,.t.,,,,,.f. )
Private oFont2c 	:= tFont():New( "Courier New",,16,,.f.,,,,,.f. )
Private oFont3c 	:= tFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private oFont4c 	:= tFont():New( "Courier New",,10,,.f.,,,,,.f. )
Private oFont5c 	:= tFont():New( "Courier New",,09,,.t.,,,,,.f. )
Private oFont6c 	:= tFont():New( "Courier New",,09,,.t.,,,,,.f. )
Private oFont7c 	:= tFont():New( "Courier New",,14,,.t.,,,,,.f. )
Private oFont8c 	:= tFont():New( "Courier New",,14,,.f.,,,,,.f. )
Private oFont9c 	:= tFont():New( "Courier New",,12,,.t.,,,,,.f. )
Private oFont10c	:= tFont():New( "Courier New",,12,,.f.,,,,,.f. )

dbSelectArea("SZA")
dbSetOrder(1)

dbSelectArea("SPI")
dbSetOrder(1)

nAno 	:= Val(Substr(mv_par01,3,4))            
nMes 	:= Val(Substr(mv_par01,1,2)) 
nMes	:= nMes - 6 //Rafael

if nMes < 1
	nAno --
	nMes := 12 + nMes
endif  

cMes	:=	Strzero(nMes,2)
cAno	:=	Strzero(nAno,4)

//cInicio=cAno+cMes //Se quiser somente o saldo do periodo
           
cInicio := '      ' // Se quiser saldo anterior

IF MV_PAR06 = 2

	//SRA->RA_SITFOLH == 'D'
	
	_diafim := ALLTRIM(SUBSTR(getmv("MV_PAPONTA"),16,2))
	
	cQuery 	:= " SELECT RA.RA_FILIAL,RA.RA_MAT,RA.RA_CC,RA.RA_NOME,RA.RA_CHAPA, "
	cQuery 	+= 	"	   PI.PI_FILIAL,PI.PI_MAT,PI.PI_CC,PI.PI_QUANT,PI.PI_DATA, "
	cQuery	+=		"     PI.PI_PD,PI.PI_STATUS,PI.PI_DTBAIX  "
	cQuery 	+=	" FROM " + RetSqlName("SRA") + " RA, " + RetSqlName("SPI") + " PI "
	cQuery 	+= " WHERE RA.RA_MAT      = PI.PI_MAT AND "
	cQuery 	+= 	"    RA.RA_SITFOLH <> 'D'       AND "
	cQuery 	+= 	"    RA.D_E_L_E_T_  = ' '       AND "
	cQuery 	+= 	"    RA.RA_FILIAL   = '" + xFilial("SRA") + "' AND "
	cQuery 	+= 	"    RA.RA_MAT     >= '" + mv_par02			+ "' AND "
	cQuery 	+= 	"    RA.RA_MAT     <= '" + mv_par03			+ "' AND "
	cQuery 	+= 	"	  RA.RA_CC      >= '" + mv_par04			+ "' AND "
	cQuery 	+= 	"	  RA.RA_CC      <= '" + mv_par05			+ "' AND "
	cQuery	+=		"    PI.PI_FILIAL   = '" + xFilial("SPI")	+ "' AND "
	cQuery 	+= 	"	  PI.PI_DATA    >= '" + cInicio			+ "' AND "
	cQuery 	+= 	"	  PI.PI_DATA    <= '" + Substr(mv_par01,3,4) + Substr(mv_par01,1,2)	+ _diafim 	+ "' AND "//"15' AND "
	cQuery 	+= 	"    PI.D_E_L_E_T_  = ' ' "
	cQuery 	+=	" ORDER BY RA_FILIAL,RA_CC,RA_MAT,PI_DATA"
	cQuery	:=	ChangeQuery(cQuery)
	
	If Select("MAP") > 0
	   MAP->(DbCloseArea())
	Endif	
	
	TcQuery cQuery New Alias "MAP"
	
	dbSelectArea("MAP")
	dbGoTop()
	
	SetRegua(RecCount())
	
	dbGoTop()
	
	Do While !MAP->(Eof())
		
		nPag			:=	0 		
		cCustoImp 	:= .t.
		nLin			:=	9000
		pCcusto   	:=	MAP->RA_CC
			
		Do While !MAP->(Eof()) .and. MAP->RA_CC == pCcusto
			
			nSaldo	:=	0 	
			MatImp 	:= .t.		
			pMat   	:=	MAP->RA_MAT
			_cNome	:=	MAP->RA_NOME
	
			//Para inicializar com o saldo anterior deixe esse loop aqui
	
			Do While !MAP->(Eof()) .and. MAP->PI_MAT == pMat .and. Substr(MAP->PI_DATA,1,6) < cAno + cMes
	
				PosSP9( MAP->PI_PD ,MAP->RA_FILIAL )
	
				If SP9->P9_TIPOCOD $ "1*3"
					nSaldo := SomaHoras(nSaldo,iif(MAP->PI_STATUS=="B",0,MAP->PI_QUANT))
				Else
					nSaldo := SubHoras (nSaldo,iif(MAP->PI_STATUS=="B",0,MAP->PI_QUANT))
				Endif
				
				dbskip()
			Enddo
	
			//Fim saldo Anterior
	
			Do While !MAP->(Eof()) .and. MAP->RA_CC == pCcusto .and. MAP->RA_MAT == pMat
	
				IncRegua()
	
				if nLin > 2900
					nLin := 100
					
					If !lPrimPag
						oPrn:EndPage()
						oPrn:StartPage()
						nPag ++
					else
						lPrimPag := .f.
						lEnc     := .t.
						oPrn  	:=	TmsPrinter():New()
						oPrn:Setup()
						oPrn:Say( 0020, 0000, " ",oFont,100 ) // Iniciando a impressora
						nPag ++
					endif     
					
					oPrn:Line (nLin,020,nLin,2350)
					nLin += 0025
					oPrn:Say( nLin, 0020, SM0->M0_NOMECOM, oFont10)
					nLin += 0050
					oPrn:Say( nLin, 0020,titulo,oFont10,100)
					oPrn:Say( nLin, 2100,"Pag: "+Str(nPag,3),oFont10,100)
					nLin += 0050
					oPrn:Say( nLin, 0020,cabec1+"    Competência: "+SUBSTR(MV_PAR01,1,2)+"/"+SUBSTR(MV_PAR01,3,4),oFont10,100)
					nLin += 0050
					oPrn:Line (nLin,020,nLin,2350)
					nLin += 0150
					CcustoImp 	:= .t.
					MatImp 		:= .t.
				endif
				
				if cCustoImp
					oPrn:Say( nLin, 0020,MAP->RA_CC+SPACE(5)+POSICIONE("CTT",1,xFilial("CTT")+MAP->RA_CC,"CTT_DESC01"),oFont16,100 )
					nLin+= 0120
					CcustoImp := .f.
				endif
				
				if MatImp
					oPrn:Say( nLin, 0020, MAP->RA_MAT + "        " + MAP->RA_NOME,oFont10,100 )
					nLin+= 0050
					MatImp := .f.
				endif
	
				//Calculo das horas             
	         
				_diafim := ALLTRIM(SUBSTR(getmv("MV_PAPONTA"),16,2))
					
				cRef	:=	Substr(MAP->PI_DATA,1,6) + _diafim//"15"  
	
				If Day(Stod(MAP->PI_DATA)) > val(_diafim)//15
	
					nAno := Val(Substr(cRef,1,4))
					nMes := Val(Substr(cRef,5,2))
					nMes := nMes + 1
					if nMes > 12                         
						nAno ++
						nMes := nMes - 12
					endif                                                            
	
					cRef	:=	Strzero(nAno,4) + Strzero(nMes,2)+ _diafim//"15"  
				Endif
	
				nAno := Val(Substr(cRef,1,4))
				nMes := Val(Substr(cRef,5,2))

				nMes := nMes + 6 //25/04/19 - Alterado de 3 para 6 meses

				if nMes > 12                         
					nAno ++
					nMes := nMes - 12
				endif                                                            
				
				ccMes := Strzero(nMes,2)
				ccAno := Strzero(nAno,4)
	
				Do While !MAP->(Eof()) .and. MAP->PI_MAT == pMat .and. MAP->PI_DATA <= cRef
	
					PosSP9( MAP->PI_PD ,MAP->RA_FILIAL )
	
					If SP9->P9_TIPOCOD $ "1*3"
						nSaldo := SomaHoras(nSaldo,If(MAP->PI_STATUS=="B",0,MAP->PI_QUANT))
					Else      
						nSaldo := SubHoras (nSaldo,If(MAP->PI_STATUS=="B",0,MAP->PI_QUANT))
					Endif
	                
					_dData 		:=	LastDay(Ctod("01/"+ccMes+"/"+ccAno))
					_dDataINI 	:=	( _dData - ( Day(_dData-15) ) )
					
					nAno := Val(Substr(cRef,1,4))
					nMes := Val(Substr(cRef,5,2))
					nMes := nMes + 1
	
					if nMes>12                         
						nAno++
						nMes=nMes-12
					endif                                                            
	
					dbSelectArea("MAP")
					dbskip()
				Enddo
				
				_dData := LastDay(Ctod("01/"+ccMes+"/"+ccAno))
				_cData := DtoC(_dData) //DtoC(_dData(Day(_dData)))
	            
	   			// 28/07/16 Rafael colocada a nova mensagem a pedido da Sra Elenn e Giselly
				//oPrn:Say( nLin, 0500,Space(13) + "HORAS COMPENSAR ATE  " + SUBSTR(MAP->ZA_DATA,7,2)+"/"+SUBSTR(MAP->ZA_DATA,5,2)+"/"+SUBSTR(MAP->ZA_DATA,1,4)+Space(15) + Transform(MAP->ZA_VALOR,"99999999.99") + "      ______________________",oFont10,100 )
				IF (ccAno + ccMes)  <=  "201805" //.OR. (ccAno + ccMes)  >=  "201807"
				oPrn:Say( nLin, 0500,Space(05) + " HORAS COMPENSAR ATE " + DTOC(LastDate(MonthSub(_dData,1))) + Transform(nSaldo,"99999999.99") + "      ______________________",oFont10,100 )
				ELSE
				oPrn:Say( nLin, 0500,Space(05) + " HORAS COMPENSAR ATE " + DTOC(_dData) + Transform(nSaldo,"99999999.99") + "      ______________________",oFont10,100 )				
				ENDIF
				nLin += 045
				oPrn:Say( nLin, 0500,Space(07) + "  PAGAMENTO COMPETÊNCIA " +SUBSTR(DTOS(_dData),5,2) + "/" + SUBSTR(DTOS(_dData),1,4) + Space(05),oFont6,100 )
				nLin += 055
	
				//oPrn:Say( nLin, 0500,Space(13) + "HORAS COMPENSAR ATE  " + _cData + Space(12) + Transform(nSaldo,"99999999.99") + "       ______________________",oFont10,100 )
	
				//nLin += 0100
	
				dbSelectArea("SZA")
				dbsetorder(2)
	
				//ALTERADO EM 16/07/08 - POR RAFAEL COSTA LEITE
				// Alterado DBSEEK() na tabela SZA
				
				//Formato inicial
				//if	!SZA->( dbseek( xFilial("SZA") + mv_par01 + pMat + pCcusto + _cData , .f. ))
				
				//Alteração
				if	!SZA->( dbseek( xFilial("SZA") + mv_par01 + pMat + pCcusto + DTOS(CTOD(_cData)) , .f. ))
					RecLock("SZA",.t.)
						SZA->ZA_FILIAL	:=	xFilial("SZA")
						SZA->ZA_COMPET	:=	mv_par01
						SZA->ZA_MAT		:=	pMat
						SZA->ZA_NOME	:=	_cNome
						SZA->ZA_CC		:=	pCcusto
						SZA->ZA_DATA	:=	DTOS(LastDate(MonthSub(_dData,1)))
						SZA->ZA_VALOR	:=	nSaldo
					MsUnlock("SZA")
				else
					if	nSaldo <> 0 .and. SZA->ZA_VALOR == 0
						RecLock("SZA",.f.)
							SZA->ZA_VALOR	:=	nSaldo			
						MsUnlock("SZA")			
	         	endif
	     		endif
	
				dbSelectArea("MAP")
	
				j ++
	
				nSaldo := 0
			enddo
		enddo

		    nLin+= 150
	 	    oPrn:Say( nLin, 1400,"_________________________________",oFont10,100 )
		    nLin+= 050
	 	    oPrn:Say( nLin, 1400,"             Assinatura do Responsável    ",oFont10,100 )
		    nLin+= 0100


	enddo

Else // if mv_par???

	cQuery 	:= " SELECT RA.RA_FILIAL,RA.RA_MAT,RA.RA_CC,RA.RA_NOME,RA.RA_CHAPA, "
	cQuery 	+= 	"	   ZA.ZA_FILIAL,ZA.ZA_MAT,ZA.ZA_COMPET,ZA.ZA_DATA,ZA.ZA_VALOR  "
	cQuery 	+=	" FROM " + RetSqlName("SRA") + " RA, " + RetSqlName("SZA") + " ZA "
	//cQuery 	+= " WHERE RA.RA_FILIAL = ZA.ZA_FILIAL AND "
	cQuery 	+=  "    WHERE RA.RA_MAT      = ZA.ZA_MAT AND "
	cQuery 	+= 	"    RA.RA_SITFOLH <> 'D'       AND "
	cQuery 	+= 	"    RA.D_E_L_E_T_  = ' '       AND "
	cQuery 	+= 	"    RA.RA_FILIAL   = '" + xFilial("SRA") + "' AND "
	cQuery 	+= 	"    RA.RA_MAT     >= '" + mv_par02			+ "' AND "
	cQuery 	+= 	"    RA.RA_MAT     <= '" + mv_par03			+ "' AND "
	cQuery 	+= 	"	  RA.RA_CC      >= '" + mv_par04			+ "' AND "
	cQuery 	+= 	"	  RA.RA_CC      <= '" + mv_par05			+ "' AND "
	cQuery	+=	   "    ZA.ZA_FILIAL   = '" + xFilial("SZA")	+ "' AND "
	cQuery 	+= 	"	  ZA.ZA_COMPET   = '" + MV_PAR01		+ "' AND "
	cQuery 	+= 	"    ZA.D_E_L_E_T_  = ' ' "
	cQuery 	+=	" ORDER BY RA_FILIAL,RA_CC,RA_MAT,ZA_DATA"
	cQuery	:=	ChangeQuery(cQuery)
	
	If Select("MAP") > 0
	   MAP->(DbCloseArea())
	Endif	
	
	TcQuery cQuery New Alias "MAP"
	
	dbSelectArea("MAP")
	dbGoTop()
	
	SetRegua(RecCount())
	
	dbGoTop()
	
	Do While !MAP->(Eof())
		
		nPag			:=	0 		
		cCustoImp 	:= .t.
		nLin			:=	9000
		pCcusto   	:=	MAP->RA_CC
			
		Do While !MAP->(Eof()) .and. MAP->RA_CC == pCcusto
			
			nSaldo	:=	0 	
			MatImp 	:= .t.		
			pMat   	:=	MAP->RA_MAT
			_cNome	:=	MAP->RA_NOME
	
			//Para inicializar com o saldo anterior deixe esse loop aqui



			if nLin > 2900
				nLin := 100
					
				If !lPrimPag
					oPrn:EndPage()
					oPrn:StartPage()
					nPag ++
				else
					lPrimPag := .f.
					lEnc     := .t.
					oPrn  	:=	TmsPrinter():New()
					oPrn:Setup()
					oPrn:Say( 0020, 0000, " ",oFont,100 ) // Iniciando a impressora
					nPag ++
				endif     
				
				oPrn:Line (nLin,020,nLin,2350)
				nLin += 0025
				oPrn:Say( nLin, 0020, SM0->M0_NOMECOM, oFont10)
				nLin += 0050
				oPrn:Say( nLin, 0020,titulo,oFont10,100)
				oPrn:Say( nLin, 2100,"Pag: "+Str(nPag,3),oFont10,100)
				nLin += 0050
				oPrn:Say( nLin, 0020,cabec1+"    Competência: "+SUBSTR(MV_PAR01,1,2)+"/"+SUBSTR(MV_PAR01,3,4),oFont10,100)
				nLin += 0050
				oPrn:Line (nLin,020,nLin,2350)
				nLin += 0150
				CcustoImp 	:= .t.
				MatImp 		:= .t.
			endif
				
			if cCustoImp
				oPrn:Say( nLin, 0020,MAP->RA_CC+SPACE(5)+POSICIONE("CTT",1,xFilial("CTT")+MAP->RA_CC,"CTT_DESC01"),oFont16,100 )
				nLin+= 0120
				CcustoImp := .f.
			endif
			
			if MatImp
				oPrn:Say( nLin, 0020, MAP->RA_MAT + "        " + MAP->RA_NOME,oFont10,100 )
				nLin+= 0050
				MatImp := .f.
			endif
	
	
			Do While !MAP->(Eof()) .and. MAP->ZA_MAT == pMat 
				// 28/07/16 Rafael colocada a nova mensagem a pedido da Sra Elenn e Giselly
				//oPrn:Say( nLin, 0500,Space(13) + "HORAS COMPENSAR ATE  " + SUBSTR(MAP->ZA_DATA,7,2)+"/"+SUBSTR(MAP->ZA_DATA,5,2)+"/"+SUBSTR(MAP->ZA_DATA,1,4)+Space(15) + Transform(MAP->ZA_VALOR,"99999999.99") + "      ______________________",oFont10,100 )
				
				IF ALLTRIM(SUBSTR(MAP->ZA_COMPET,3,4)) + ALLTRIM(SUBSTR(MAP->ZA_COMPET,1,2))  <=  "201805"// .OR. ALLTRIM(SUBSTR(MAP->ZA_COMPET,3,4)) + ALLTRIM(SUBSTR(MAP->ZA_COMPET,1,2))  >=  "201807"
				oPrn:Say( nLin, 0500,Space(05) + " HORAS COMPENSAR ATE " + DTOC(LastDate(MonthSub(STOD(MAP->ZA_DATA),1))) + Transform(MAP->ZA_VALOR,"99999999.99") + "      ______________________",oFont10,100 )
				ELSE
				oPrn:Say( nLin, 0500,Space(05) + " HORAS COMPENSAR ATE " + DTOC(LastDate(STOD(MAP->ZA_DATA))) + Transform(MAP->ZA_VALOR,"99999999.99") + "      ______________________",oFont10,100 )				
				ENDIF
				nLin += 045
				oPrn:Say( nLin, 0500,Space(07) + "  PAGAMENTO COMPETENCIA " 	+SUBSTR(MAP->ZA_DATA,5,2) + "/" + SUBSTR(MAP->ZA_DATA,1,4) + Space(05),oFont6,100 )
				nLin += 055
	                
				dbSelectArea("MAP")
				dbskip()
			Enddo
				
	
			dbSelectArea("MAP")
	
	
		    nLin+= 150
		    oPrn:Say( nLin, 1400,"_________________________________",oFont10,100 )
		    nLin+= 050
		    oPrn:Say( nLin, 1400,"             Assinatura do Responsável    ",oFont10,100 )
		    nLin+= 0100

			//dbSelectArea("MAP")
			//dbskip()
		Enddo
	
	Enddo

	
Endif

Set Device to Screen

If lEnc
	oPrn:Preview()
	Ms_Flush()
EndIf

MAP->(DbCloseArea())

Return

/*****************************************************************************/

Static Function AjustaSX1(cPerg, aPergs)     


PutSx1(cPerg,'01',' Competencia MMAAAA ','','','mv_ch1','C',6,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','', ,{},{} )
PutSx1(cPerg,'02',' Da Matricula       ?','','','mv_ch2','C',6,0,0,'G','','SRA','','','mv_par02','','','','','','','','','','','','','','','','', ,{},{} )
PutSx1(cPerg,'03',' Ate Matricula      ? ','','','mv_ch3','C',6,0,0,'G','','SRA','','','mv_par03','','','','','','','','','','','','','','','','', ,{},{} )
PutSx1(cPerg,'04',' Do C.Custo         ?','','','mv_ch4','C',7,0,0,'G','','CTT','','','mv_par04','','','','','','','','','','','','','','','','', ,{},{} )
PutSx1(cPerg,'05',' Ate C.Custo        ? ','','','mv_ch5','C',7,0,0,'G','','CTT','','','mv_par05','','','','','','','','','','','','','','','','', ,{},{} )
PutSx1(cPerg,'06',' Gravar SZA         ? ','','','mv_ch6','C',1,0,0,'C','','','','','mv_par06','Nao','','','','Sim','','','','','','','','','','','', ,{},{} )

/*
Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .f.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1 :={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
				"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
				"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
				"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
				"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
				"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
				"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
				"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .f.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .and.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .t.
		Endif
	Endif
	
	If ! lAltera .and. Found() .and. X1_TIPO <> aPergs[nX][5]
		lAltera := .t.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .or. lAltera
		RecLock("SX1",If(lAltera, .f., .t.))
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
*/
Return()                                                            


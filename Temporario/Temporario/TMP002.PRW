#include "topconn.ch"
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTCR114   º Autor ³ Claudio Ferreira   º Data ³  25/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao de funcionario x CC                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TV Record                                                  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rafael      ³17/04/08³Melhor³Incluidas novas verbas para impressao.    ³±±
±±³            ³        ³      ³Alterado o relatorio para paisagem        ³±±
±±³            ³        ³      ³Criados parametros para indentificacao    ³±±
±±³            ³        ³      ³das verbas                                ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TMP002()

Local cPict         := ""
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local nLin         	:= 80
Local Imprime      	:=	.t.
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Colaboradores Efetivos"
Local Titulo       	:= "Colaboradores Efetivos"
Local aOrd       	:= {"C.C + Nome","C.C. + Matrícula","Matrícula","Nome","Função + Nome","Data de Admissão"}

Private lEnd        := .f.
Private lAbortPrint := .f.
Private CbTxt       := ""
Private Limite     	:=	220
Private tamanho    	:= "G"
Private nomeprog   	:= "RTCR114" 
Private nTipo       := 18
Private aReturn    	:= {"Zebrado",01,"Administracao",02,02,01,"",01}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RTCR114" 
Private cPerg 		:=	"RTC114    "
Private cCentros	:=	''
Private cFuncao		:=	''
Private cString 	:=	"SRA"
Private nQuebra  	:= 65
Private cCampos		:=	{{'ESCOLARIDADE'     ,1};
						,{'FUNCAO'           ,1};
						,{'SALARIO'          ,1};
						,{'HEC'              ,1};
						,{'ACUMULO'          ,1};
						,{'COMISSAO'         ,1};
						,{'INSALUBRIDADE'    ,1};
						,{'PERICULOSIDADE'   ,1};
						,{'DSR COMISSAO'     ,1};
						,{'QUINQUENIO  '     ,1};
						,{'SERVICO EVENTUAL' ,1};
						,{'GRAT FUNCAO'      ,1};
						,{'SERVICO ADICIONAL',1}}

ValidPerg()          

Pergunte(cPerg,.t.)       

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.t.,aOrd,.f.,Tamanho,,.t.)

if nLastKey == 27
	Return
endif

SetDefault(aReturn,cString)

if nLastKey == 27
   Return
endif

nTipo := iif( aReturn[4] == 1 , 15 , 18 )

RptStatus( { || RunReport(Cabec1,Cabec2,Titulo,nLin) } , Titulo )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  21/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local w
Local cTexto
Local cQuery
Local nCount	:=	0
Local nPosTot	:=	0
Local sTexto	:=	""
Local lTot		:=	.f.
Local lPuloup	:=	.t.
Local nOrdem  	:=	aReturn[8]
Local aOrdem 	:=	{"RA_CC,RA_NOME","RA_CC,RA_MAT","RA_MAT","RA_NOME","RA_CODFUNC,RA_NOME","RA_ADMISSA"}

Local nTCC		:=	0
Local nTC2		:=	0
Local nSM2		:=	0
Local nIM2		:=	0
Local nTM2		:=	0      	
Local nTCG		:=	0
Local nSMC		:=	0
Local nSMG		:=	0
Local nIMC		:=	0
Local nIMG		:=	0
Local nTMC		:=	0
Local nTMG		:=	0         
Local nLin 		:=  8
Local nTotGG	:=	0
Local nTotSG	:=	0
Local nTotTG	:=	0
Local cCCusto	:= '99'
Local cCCust2	:= '9999999'

cQuery	:= " Select Substr(CTT_CUSTO,1,3) AS MACRO , CTT_CUSTO, CTT_DESC01, "
cQuery	+=		"    RA_MAT, RA_NOME, RA_SALARIO, RA_ADMISSA, RA_NASC, RA_GRINRAI, RA_CODFUNC, RA_SITFOLH "
cQuery 	+= " From " + RetSQLName("SRA") + " A , "
cQuery 	+= 			  RetSQLName("CTT") + " B   "
cQuery 	+=	" Where CTT_CUSTO   = RA_CC and "
cQuery 	+=		"    RA_FILIAL   = '" + xFilial("SRA")	+ "'   and 
cQuery 	+= 	"  ( RA_DEMISSA >= '" + DtoS(mv_par08)	+ "'   or 
cQuery	+=		"    RA_DEMISSA  = '" + Space(08)		+ "' ) and "
cQuery 	+= 	"    RA_ADMISSA <= '" + DtoS(mv_par08)	+ "'   and "
cQuery 	+= 	"    RA_ADMISSA >= '" + DtoS(mv_par05)	+ "'   and " 
cQuery 	+= 	"    RA_ADMISSA <= '" + DtoS(mv_par06)	+ "'   and " 
cQuery 	+= 	"    RA_MAT     >= '" + mv_par01 		+ "'   and " 
cQuery 	+= 	"    RA_MAT     <= '" + mv_par02 		+ "'   and " 

if !Empty(cFuncao)
	cQuery += 	"    RA_CODFUNC IN (" + cFuncao			+ ")   and "
endif

cQuery	+=		"    CTT_FILIAL  = '" + xFilial("CTT")	+ "'   and "

if !Empty(cCentros)
  cQuery += 	"    CTT_CUSTO  IN (" + cCentros			+ ")   and "
endif

cQuery 	+=	" A.D_E_L_E_T_ = ' ' and B.D_E_L_E_T_ = ' ' "
cQuery 	+= " Order By " + aOrdem[nOrdem]
cQuery	:=	ChangeQuery(cQuery)

TcQuery cQuery New Alias "SCTT"

TcSetField("SCTT","RA_ADMISSA","D",08,0)
TcSetField("SCTT","RA_NASC"	,"D",08,0)

dbSelectArea("SCTT")

Count to nCount

SetRegua(nCount)

dbGoTop()

For w := 3 to 6 	
	lTot := iif( cCampos[w,2] == 1 , .t. , lTot )		//Salario , H.Extr.Con , Acumulo , Comissao
Next w

Cabec1	:=	'Matricula Nome                            Admissão  '
//           0123456789012345678901234567890123456789xx/xx/xx



Cabec1 	+=	iif( cCampos[1,2] == 1 	, 'Escolari.  ' , "" )
Cabec1	+=	iif( cCampos[2,2] == 1 	, 'Funcao     ' , "" )
Cabec1	+=	'   '
Cabec1	+=	iif( cCampos[3 ,2] == 1 	, 'Salario    ' , "" )
Cabec1	+=	iif( cCampos[4 ,2] == 1 	, 'H.Extr.Con ' , "" )
Cabec1	+=	iif( cCampos[5 ,2] == 1 	, 'Acumulo    ' , "" )
Cabec1	+=	iif( cCampos[6 ,2] == 1 	, 'Comissao   ' , "" )
Cabec1	+=	iif( cCampos[7 ,2] == 1 	, 'Insalubri  ' , "" )
Cabec1	+=	iif( cCampos[8 ,2] == 1 	, 'Periculos  ' , "" )
Cabec1	+=	iif( cCampos[9 ,2] == 1 	, 'DSR (Com)  ' , "" )
Cabec1	+=	iif( cCampos[10,2] == 1 	, 'Quinquenio ' , "" )
Cabec1	+=	iif( cCampos[11,2] == 1 	, 'Srv Eventu ' , "" )
Cabec1	+=	iif( cCampos[12,2] == 1 	, 'Grat Funca ' , "" )
Cabec1	+=	iif( cCampos[13,2] == 1 	, 'Srv Adicio ' , "" )
Cabec1	+=	iif( lTot 	     			, ' Total     ' , "" )

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

Do While !Eof()

	IncRegua()

   if lAbortPrint
      @ nLin,000 psay "*** CANCELADO PELO OPERADOR ***"
      Exit
   endif  
   
	if	nOrdem == 1 .or. nOrdem == 2

	   if cCCust2 <> Trim(SCTT->CTT_CUSTO)
	   	if	nTC2 <> 0	
	      	cTexto	:=	"(" + cCCust2 + ") Total de Funcionários: " + Str(nTC2,3)
	      	cTexto	+=	" Remuneração Média : "	+ Transform( nSM2 / nTC2 , "@E 999,999.99" ) 
				cTexto	+=	" Idade Média : "			+ Transform( Int( nIM2 / nTC2 ) , "@E 999" ) 
	     		cTexto	+=	" Tempo Médio : "			+ Transform( Int( nTM2 / nTC2 ) , "@E 999" )

   			if	lTot .and. nPosTot <> 0 .and. nTotSG <> 0
            	if	Len(cTexto) >= nPosTot
			      	@ ++ nLin , nPosTot psay "Total : " + Transform(nTotSG,"@E 99,999,999.99")
			      	@ ++ nLin,000 psay cTexto 						            	
               else
			      	@ ++ nLin,000     psay cTexto 						            	
			      	@    nLin,nPosTot psay "Total : " + Transform(nTotSG,"@E 99,999,999.99")
   				endif
				else
		      	@ ++ nLin,00 psay cTexto 
				endif
				
				nTC2		:=	0
	        	nSM2		:=	0
	        	nIM2		:=	0
	        	nTM2		:=	0      	
	   		nLin 		+= 2
				nTotSG	:=	0
	      endif
	   endif   
	
		if cCCusto <> Trim(SCTT->MACRO)
	      if nTCC <> 0 

				cTexto	:=	"(" + cCCusto + ") Total de Funcionários: " + Str(nTCC,3)
			  	cTexto	+=	" Remuneração Média : " + Transform( nSMC / nTCC , "@E 999,999.99" )
	       	cTexto	+=	" Idade Média : "			+ Transform( Int( nIMC / nTCC ) , "@E 999" )
	  			cTexto	+=	" Tempo Médio : "			+ Transform( Int( nTMC / nTCC ) , "@E 999" )

   			if	lTot .and. nPosTot <> 0 .and. nTotGG <> 0
            	if	Len(cTexto) >= nPosTot
			      	@ ++ nLin , nPosTot psay "Total : " + Transform(nTotGG,"@E 99,999,999.99")
			      	@ + nLin,000 psay cTexto 						            	
               else
			      	@ ++ nLin,000     psay cTexto 						            	
			      	@    nLin,nPosTot psay "Total : " + Transform(nTotGG,"@E 99,999,999.99")
   				endif
				else
		      	@ ++ nLin,00 psay cTexto 
				endif

	      	nLin 	++
	      	
				nTCC		:=	0         
	        	nSMC		:=	0
	        	nIMC		:=	0
	        	nTMC		:=	0      	
				nTotGG	:=	0
	      endif
	      
	      cCCusto	:=	Trim(SCTT->MACRO)
	      
	      if	!lPuloup
	      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      	nLin 		:=	08
	      	lPuloup	:=	.t.
	      endif
	      
	      @nLin,00 psay "C. Custo: " + cCCusto + "-" + Posicione("CTT",1,xFilial("CTT") + cCCusto,"CTT_DESC01")
	      
	      nLin ++
	   endif   
   endif   
	
   if nLin > nQuebra 
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 08
		if	nOrdem == 1 .or. nOrdem == 2
      	@ nLin , 000 psay "C. Custo: " + cCCusto + "-" + Posicione("CTT",1,xFilial("CTT") + cCCusto,"CTT_DESC01")
      	nLin ++
      	cCCust2 := '9999999'
	   endif   
   endif   

	if	nOrdem == 1 .or. nOrdem == 2   
	   if cCCust2 <> Trim(SCTT->CTT_CUSTO)
	      cCCust2 := Trim(SCTT->CTT_CUSTO)
	      @nLin,00 psay "C. Custo: " + cCCust2 + "-" + Posicione("CTT",1,xFilial("CTT")+cCCust2,"CTT_DESC01")
	      nLin ++
	   endif	
   endif	
      
   @nLin,002 psay Substr(SCTT->RA_MAT ,01,07) 
   @nLin,010 psay Substr(SCTT->RA_NOME,01,29)
   @nLin,040 psay If(Empty(SCTT->RA_SITFOLH),"A",SCTT->RA_SITFOLH)
   @nLin,042 psay DtoC(SCTT->RA_ADMISSA)
   
   

   if	cCampos[1,2] == 1 	//Escolaridade
   	@nLin,pCol() + 1 psay Substr(Tabela("26",SCTT->RA_GRINRAI),01,10)
   endif

   if cCampos[2,2] == 1 	//Funcao      
     	@nLin,pCol() + 1 psay Substr(Posicione("SRJ",1,xFilial("SRJ") + SCTT->RA_CODFUNC,"RJ_DESC"),01,10)
   endif                   

   nTot := 0
   
   if	cCampos[3,2] == 1 	//Salario
     	nTot += SCTT->RA_SALARIO
     	@nLin,pCol() + 1 psay Transform(SCTT->RA_SALARIO,"@E 999,999.99")
   endif
   
   if	cCampos[4,2] == 1 	//Hec  
     	nHec := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YHEX1')),mv_par07)
     	nHec += RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YHEX2')),mv_par07)
     	nTot += nHec     	
     	@nLin,pCol() + 1 psay Transform(nHec,"@E 999,999.99")
   endif
   
   if	cCampos[5,2] == 1 	//Acumulo
     	nAcm := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YACM')),mv_par07)
     	nTot += nAcm     	
     	@nLin,pCol() + 1 psay Transform(nAcm,"@E 999,999.99")
   endif           
   
   if	cCampos[6,2] == 1 	//Comissao
     	nCom := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YCOM')),mv_par07)
     	nTot += nCom     	
     	@nLin,pCol() + 1 psay Transform(nCom,"@E 999,999.99")
   endif
   
   if	cCampos[7,2] == 1 	//Insalubridade
     	nIns := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YINS')),mv_par07)
     	nTot += nIns     	
     	@nLin,pCol() + 1 psay Transform(nIns,"@E 999,999.99")
   endif
   
   if	cCampos[8,2] == 1 	//Periculosidade
     	nPer := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YPER')),mv_par07)
     	nTot += nPer     	
     	@nLin,pCol() + 1 psay Transform(nPer,"@E 999,999.99")
   endif
   
   if	cCampos[9,2] == 1 	//DSR Comissao
     	nDSR := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YDSR')),mv_par07)
     	nTot += nDSR     	
     	@nLin,pCol() + 1 psay Transform(nDSR,"@E 999,999.99")
   endif
   
   if	cCampos[10,2] == 1 	//Quinquenio
     	nQQN := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YQQN')),mv_par07)
     	nTot += nQQN     	
     	@nLin,pCol() + 1 psay Transform(nQQN,"@E 999,999.99")
   endif
   
   if	cCampos[11,2] == 1 	//Servicos Eventuais
     	nEVN := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YEVN')),mv_par07)
     	nTot += nEVN     	
     	@nLin,pCol() + 1 psay Transform(nEVN,"@E 999,999.99")
   endif
   
   if	cCampos[12,2] == 1 	//Gratificacao de Funcao
     	nGRT := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YGRT')),mv_par07)
     	nTot += nGRT     	
     	@nLin,pCol() + 1 psay Transform(nGRT,"@E 999,999.99")
   endif
   
   if	cCampos[13,2] == 1 	//Servicos Adicionais
     	nADC := RetVlrVerba(SCTT->RA_MAT,Alltrim(GetMV('MV_YADC')),mv_par07)
     	nTot += nADC     	
     	@nLin,pCol() + 1 psay Transform(nADC,"@E 999,999.99")
   endif

   if	lTot 						
		if	nPosTot == 0
			nPosTot := pCol() - 10		// Total : 99,999,999.99
   	endif
     	@nLin,pCol() + 1 psay Transform(nTot,"@E 999,999.99")
   endif   
   
   nTCC ++
   nTC2 ++
   nTCG ++

   nSM2 += nTot	//SCTT->RA_SALARIO
   nSMC += nTot	//SCTT->RA_SALARIO
   nSMG += nTot	//SCTT->RA_SALARIO

	nTotGG += nTot
	nTotSG += nTot
	nTotTG += nTot

   nIMC += Int( ( mv_par08 - SCTT->RA_NASC ) / 365 )
   nIMG += Int( ( mv_par08 - SCTT->RA_NASC ) / 365 )
   nIM2 += Int( ( mv_par08 - SCTT->RA_NASC ) / 365 )
   nTM2 += Int( ( mv_par08 - SCTT->RA_ADMISSA) / 365 )
   nTMC += Int( ( mv_par08 - SCTT->RA_ADMISSA) / 365 )
   nTMG += Int( ( mv_par08 - SCTT->RA_ADMISSA) / 365 )  

   nLin ++

   lPuloup	:=	.f.

   dbSkip() 
EndDo   

dbSelectArea("SCTT")
dbclosearea()

if	nOrdem == 1 .or. nOrdem == 2   
	cTexto	:=	"(" + cCCust2 + ") Total de Funcionários: " + Str(nTC2,3)
	cTexto	+=	" Remuneração Média : "	+ Transform( nSM2 / nTC2 , "@E 999,999.99" ) 
	cTexto	+=	" Idade Média : "			+ Transform( Int( nIM2 / nTC2 ) , "@E 999" ) 
	cTexto	+=	" Tempo Médio : "			+ Transform( Int( nTM2 / nTC2 ) , "@E 999" )
	
 	if	lTot .and. nPosTot <> 0 .and. nTotSG <> 0
  		if	Len(cTexto) >= nPosTot
    		@ nLin , nPosTot psay "Total : " + Transform(nTotSG,"@E 99,999,999.99")
			nLin ++
      	@ nLin,000 psay cTexto 						            	
   	else
      	@ nLin,000 psay cTexto 						            	
      	@ nLin,nPosTot psay "Total : " + Transform(nTotSG,"@E 99,999,999.99")
   	endif
	else
 		@ nLin,00 psay cTexto 
	endif
	
	nLin += 2
	
	cTexto	:=	"(" + cCCusto + ") Total de Funcionários: " + Str(nTCC,3)
	cTexto	+=	" Remuneração Média : "	+ Transform( nSMC / nTCC , "@E 999,999.99" )
	cTexto	+=	" Idade Média : "			+ Transform( Int( nIMC / nTCC ) , "@E 999" )
	cTexto	+=	" Tempo Médio : "			+ Transform( Int( nTMC / nTCC ) , "@E 999" )
	
 	if	lTot .and. nPosTot <> 0 .and. nTotGG <> 0
  		if	Len(cTexto) >= nPosTot
    		@ nLin , nPosTot psay "Total : " + Transform(nTotGG,"@E 99,999,999.99")
			nLin ++
   		@ nLin,000 psay cTexto 						            	
     	else
      	@ nLin,000 psay cTexto 						            	
      	@ nLin,nPosTot psay "Total : " + Transform(nTotGG,"@E 99,999,999.99")
   	endif
	else
 		@ nLin,00 psay cTexto 
	endif

	nLin += 2
else
	nLin ++
endif	

cTexto	:=	"(GERAL)  Total de Funcionários: " + Str(nTCG,3)
cTexto	+=	" Remuneração Média : " + Transform( nSMG / nTCG , "@E 999,999.99" ) 
cTexto	+=	" Idade Média : "			+ Transform( Int( nIMG / nTCG ) , "@E 999" )
cTexto	+=	" Tempo Médio : "			+ Transform( Int( nTMG / nTCG ) , "@E 999" )

if	lTot .and. nPosTot <> 0 .and. nTotTG <> 0
	if	Len(cTexto) >= nPosTot
 		@ nLin , nPosTot psay "Total : " + Transform(nTotTG,"@E 99,999,999.99")
		nLin ++
  		@ nLin,000 psay cTexto 						            	
	else
 		@ nLin,000 psay cTexto 						            	
   	@ nLin,nPosTot psay "Total : " + Transform(nTotTG,"@E 99,999,999.99")
 	endif
else
	@ nLin,00 psay cTexto 
endif

Set Device To Screen

if aReturn[5] == 1
   dbCommitAll()
   Set Printer To
   OurSpool(wnrel)
endif

Ms_Flush()

Return

/*******************************************************************/

Static Function RetVlrVerba(xMatr,xVerba,xRef)

Local	_Ret
Local cQuery
Local xArea		:=	GetArea()

cQuery := " Select Sum(RD_VALOR) As VALOR "
cQuery += " From " + RetSqlName("SRD") 
cQuery += " Where RD_MAT      = '" + xMatr   		+ "' and "
cQuery += 		"  RD_PD      = '" + xVerba	    	+ "' and "
cQuery += 		"  RD_DATARQ  = '" + xRef			+ "' and "
cQuery += 		"  RD_FILIAL  = '" + xFilial("SRD") + "' and "
cQuery += 		"  D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "_Tmp"

dbSelectArea("_Tmp")

_Ret	:=	iif( _Tmp->(!Eof()) .and. _Tmp->(!Bof()) , _Tmp->VALOR , 0 )

_Tmp->(dbCloseArea())

RestArea(xArea)

Return ( _Ret )

/*******************************************************************/

Static Function ValidPerg()

Local aRegs		:=	{}
Local _sAlias	:=	Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg 	:=	Padr(cPerg,10)

aAdd(aRegs,{cPerg,"01","Matricula de     ?",Space(20),Space(20),"mv_ch1","C",06,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
aAdd(aRegs,{cPerg,"02","Matricula ate    ?",Space(20),Space(20),"mv_ch2","C",06,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","","",""})
aAdd(aRegs,{cPerg,"03","C.Custo          ?",Space(07),Space(07),"mv_ch3","C",10,0,0,"G","U_f_CCTMP","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Campos p/Impres. ?",Space(07),Space(07),"mv_ch4","C",10,0,0,"G","U_f_CPTMP","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Admissao de      ?",Space(20),Space(20),"mv_ch5","D",08,0,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Admissao ate     ?",Space(20),Space(20),"mv_ch6","D",08,0,0,"C","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Referen. (AAAAMM)?",Space(20),Space(20),"mv_ch7","C",06,0,0,"C","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Data Base        ?",Space(20),Space(20),"mv_ch8","D",08,0,0,"C","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Funcao           ?",Space(07),Space(07),"mv_ch9","C",10,0,0,"G","U_f_FUNTMP","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	if !dbSeek( cPerg + aRegs[i,2])
		RecLock("SX1",.t.)
		For j := 1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next j
		MsUnlock()
		dbCommit()
	endif
Next i

dbSelectArea(_sAlias)

Return

/*******************************************************************/

Static Function RTCR114Bar(oDlg,bOk,bCancel)                         

Local lVolta :=.f.
Local oBar, bSet15, bSet24, lOk

Define BUTTONBAR oBar Size 25,25 3D Top Of oDlg
oBar:nGroups += 6
Define Button oBtOk 	Resource "OK" 		Of oBar Group 	Action ( lLoop := lVolta , lOk := Eval(bOk) ) Tooltip "Ok"
Define Button oBtCan Resource "CANCEL" Of oBar 			Action ( lLoop := .f. , Eval(bCancel) , ButtonOff(bSet15,bSet24,.t.) ) Tooltip "Cancelar"
SetKey(15,oBtOk:bAction)
SetKey(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := { || AllwaysTrue() }

Return ( Nil )

/*******************************************************************/

User Function f_CCTMP1( l1Elem , lTipoRet )

Local cArq      
Local oDlg1 
Local MvPar
Local cVirg
Local cRetorna

Local nOpca 	:= 0       
Local aStru 	:= {}
Local aCampos	:= {}    
Local lInverte := .f.
Local _sAlias	:=	Alias()

Private oMark
Private cMarca := GetMark()

mvRet	:=	Alltrim(ReadVar())			 
MvPar	:=	&(Alltrim(ReadVar()))		 

aAdd(aStru,{"TRB_COD"	,"C",07,0})
aAdd(aStru,{"TRB_DESC"	,"C",30,0})
aAdd(aStru,{"TRB_OK"		,"C",02,0})

cArq := CriaTrab(aStru,.t.)
dbUseArea(.t.,,cArq,"TRB",.t.)
cInd := CriaTrab(NIL,.f.)

dbSelectArea("CTT")
dbGoTop()
        
Do While !Eof()
	if CTT_CLASSE == '2'
		RecLock("TRB",.t.)
			TRB->TRB_COD  := Alltrim(CTT->CTT_CUSTO)
			TRB->TRB_DESC := CTT->CTT_DESC01
			TRB->TRB_OK   :=	'  '
		MsUnlock()
	endif	
	dbSelectArea("CTT")
	DbSkip()
enddo		

dbSelectArea("TRB")
dbGoTop() 

aAdd( aCampos, { 'TRB_OK'		,, ' '						, '    '	} )
aAdd( aCampos, { 'TRB_COD'		,, 'Codigo'					, '@S07' } )
aAdd( aCampos, { 'TRB_DESC'	,, 'Centro de Custo'		, '@S30' } )

Define MsDialog oDlg1 Title "Selecione os Centros de Custos " From 09,00 To 28,80 Of oMainWnd
oMark:=MsSelect():New("TRB","TRB_OK",,aCampos,@lInverte,@cMarca,{012,001,143,315})
oMark:oBrowse:Refresh()
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllMark := .f.
Activate MsDialog oDlg1 Center On Init RTCR114Bar(oDlg1, { || nOpca := 1,oDlg1:End() } , { || nOpca := 2,oDlg1:End() })

cVirg		:=	""
cRetorna	:=	""

if nOpca == 1			
	TRB->( dbGoTop() )
	do while !TRB->(Eof())
		if	TRB->TRB_OK == cMarca
			cRetorna	+=	cVirg + "'" + TRB->TRB_COD + "'"
			cVirg		:=	','
		endif
		TRB->(dbskip())
	enddo
endif

TRB->(dbCloseArea())

fErase( cArq + OrdBagExt() )

cCentros :=	cRetorna		
&MvRet 	:=	'Selecao'

dbSelectArea(_sAlias)

Return

/*******************************************************************/

User Function f_CPTMP1( l1Elem , lTipoRet )

Local cArq      
Local oDlg1 
Local MvPar
Local cRetorna

Local nOpca 	:=	0       
Local aStru   	:=	{}
Local aCampos	:= {}
Local lInverte	:=	.f.
Local _sAlias	:=	Alias()

Private oMark
Private cMarca	:= GetMark()

mvRet:=Alltrim(ReadVar())			 
MvPar:=&(Alltrim(ReadVar()))		 

aAdd(aStru,{"TRB_COD"	,"C",07,0})
aAdd(aStru,{"TRB_DESC"	,"C",30,0})
aAdd(aStru,{"TRB_OK"		,"C",02,0})

cArq := CriaTrab(aStru,.t.)

dbUseArea(.t.,,cArq,"TR2",.t.)

cInd := CriaTrab(Nil,.f.)

For II := 1 to Len(cCampos)
	RecLock("TR2",.t.)
		TR2->TRB_COD  	:=	Str(II,2)
		TR2->TRB_DESC 	:=	cCampos[II,1]
		TR2->TRB_OK  	:=	'  '
	MsUnlock()
Next II

dbSelectArea("TR2")
TR2->(dbGoTop())

aAdd( aCampos, { 'TRB_OK'		,, ' '			, '    ' } )
aAdd( aCampos, { 'TRB_COD'		,, 'Codigo'		, '@S07' } )
aAdd( aCampos, { 'TRB_DESC'	,, 'Campos'		, '@S30' } )

Define MsDialog oDlg1 Title "Selecione os Campos para impressao " From 09,00 To 28,80 OF oMainWnd
oMark:=MsSelect():New("TR2","TRB_OK",,aCampos,@lInverte,@cMarca,{012,001,143,315})
oMark:oBrowse:Refresh()
oMark:oBrowse:lHasMark 		:= .t.
oMark:oBrowse:lCanAllMark 	:= .f.
Activate MsDialog oDlg1 Center On Init RTCR114Bar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})

cRetorna	:=	''
xEnt		:=	.f.

if nOpca == 1			

	TR2->(dbGoTop())

	do while !TR2->(eof())
		if TR2->TRB_OK == cMarca
			xEnt	:=	.t.
			cCampos[Val(TR2->TRB_COD),2]	:=	1
		else	
			cCampos[Val(TR2->TRB_COD),2]	:=	0
		endif
		TR2->(dbskip())
	enddo                                  
	
	if !xEnt
	  	For xI := 1 to Len(cCampos)
   		cCampos[xI,2]	:=	1
   	Next xI	  
	endif
endif

TR2->(dbCloseArea())

fErase(cArq + OrdBagExt())

&MvRet :='Selecao'

dbSelectArea(_sAlias)

Return

/*******************************************************************/

User Function f_FunTM1( l1Elem , lTipoRet )

Local cArq      
Local oDlg1 
Local MvPar
Local cVirg
Local cRetorna

Local nOpca 	:= 0       
Local aStru   	:= {}
Local aCampos	:= {}
Local lInverte := .f.
Local _sAlias	:=	Alias()

Private oMark
Private cMarca	:=	GetMark()

mvRet	:=	Alltrim(ReadVar())			 
MvPar	:=	&(Alltrim(ReadVar()))		 

aAdd(aStru,{"TRB_COD"	,"C",07,0})
aAdd(aStru,{"TRB_DESC"	,"C",30,0})
aAdd(aStru,{"TRB_OK"		,"C",02,0})

cArq := CriaTrab(aStru,.t.)

dbUseArea(.t.,,cArq,"TR3",.t.)

cInd := CriaTrab(Nil,.f.)

dbSelectArea("SRJ")
dbGoTop()

Do While !Eof()
	RecLock("TR3",.t.)
		TR3->TRB_COD  	:= Alltrim(SRJ->RJ_FUNCAO)
		TR3->TRB_DESC 	:= SRJ->RJ_DESC
		TR3->TRB_OK   	:=	'  '
	MsUnlock()
	dbSelectArea("SRJ")
	DbSkip()
enddo		

dbSelectArea("TR3")
TR3->(dbGoTop())

aAdd( aCampos, { 'TRB_OK'		,, ' '			, '    ' } )
aAdd( aCampos, { 'TRB_COD'		,, 'Codigo'		, '@S07' } )
aAdd( aCampos, { 'TRB_DESC'	,, 'Campos'		, '@S30' } )

Define MsDialog oDlg1 Title "Selecione os Campos para impressao " From 09,00 To 28,80 OF oMainWnd
oMark:=MsSelect():New("TR3","TRB_OK",,aCampos,@lInverte,@cMarca,{012,001,143,315})
oMark:oBrowse:Refresh()
oMark:oBrowse:lHasMark 		:= .t.
oMark:oBrowse:lCanAllMark 	:= .f.
Activate MsDialog oDlg1 Center On Init RTCR114Bar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})

cVirg		:=	''
cRetorna	:=	''
xEnt		:=	.f.

if nOpca == 1			
	TR3->(dbGoTop())
	
	do while !TR3->(Eof())
		if TR3->TRB_OK == cMarca
			cRetorna	+=	cVirg + "'" + TR3->TRB_COD + "'"
			cVirg		:=	','
		endif
		TR3->(dbskip())
	enddo
endif

TR3->(dbCloseArea())

fErase( cArq + OrdBagExt() )

cFuncao 	:=	cRetorna			

&MvRet 	:=	'Selecao'

dbSelectArea(_sAlias)

Return

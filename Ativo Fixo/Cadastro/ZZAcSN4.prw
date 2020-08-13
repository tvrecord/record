#include 'rwmake.ch'
#include 'topconn.ch'

User Function ZZAcSN4()

Local nOpca		:=	0
Local aSays		:=	{"Rotina para Acerto da Tabela SN4"}
Local aButtons	:=	{ { 1 , .t. , { |o| nOpca := 1 , FechaBatch() } } , { 2 , .t. , { |o| FechaBatch() } } }

FormBatch( "Acerto do SN4" , aSays , aButtons )

if	nOpca == 1
	Processa( { || Exec() } , "Acertando SN4 ..." ) 	
endif

Return

/**********************************************************/

Static Function Exec()

Local nSeq
Local cQuery
Local aErrosSN1	:=	{}
Local aErrosSN3	:=	{}
Local aErrosSN4	:=	{}

cQuery	:=	"Delete From " + RetSQLName("SN4") + " "
cQuery	+=	"Where N4_FILIAL = '" + xFilial("SN4") + "' and N4_DATA   < '20070101' "

TcSQLExec(cQuery)               

dbselectarea("SN1")
SN1->(dbsetorder(1))
SN1->(dbgotop())

dbselectarea("SN4")
SN4->(dbsetorder(1))
SN4->(dbgotop())

dbselectarea("SN3")
SN3->(dbsetorder(1))
SN3->(dbgotop())

ProcRegua( LastRec() )

SN3->(dbgotop())

do while SN3->(!Eof())

	IncProc( "Cod. Ativo " + SN3->N3_CBASE )

	nSeq := 1

	if	SN3->N3_AQUISIC <= StoD("20061231")

		if	!SN1->( dbseek( xFilial("SN1") + SN3->( N3_CBASE + N3_ITEM ) , .f. ))
			aAdd( aErrosSN1 , { SN3->N3_CBASE , SN3->N3_ITEM } )
		else

			// Crio o Registro da Implantação do Bem      
			
			if	!SN4->(dbseek(xFilial("SN4") + SN3->(N3_CBASE + N3_ITEM + N3_TIPO) + DtoS(SN3->N3_AQUISIC) + "05",.f.))
				RecLock("SN4",.t.)			
					SN4->N4_FILIAL		:=	xFilial("SN4")
					SN4->N4_CBASE 		:= SN3->N3_CBASE
					SN4->N4_ITEM  		:= SN3->N3_ITEM
					SN4->N4_TIPO  		:= SN3->N3_TIPO
					SN4->N4_OCORR 		:= "05"
					SN4->N4_DATA  		:=	SN3->N3_AQUISIC
					SN4->N4_QUANTD		:= SN1->N1_QUANTD
					SN4->N4_SERIE 		:= SN1->N1_NSERIE
					SN4->N4_NOTA  		:= SN1->N1_NFISCAL
					SN4->N4_CONTA 		:= SN3->N3_CCONTAB
					SN4->N4_CCUSTO		:= SN3->N3_CUSTBEM
					SN4->N4_VLROC1		:= SN3->N3_VORIG1
					SN4->N4_VLROC2		:= SN3->N3_VORIG2
					SN4->N4_VLROC3		:= SN3->N3_VORIG3
					SN4->N4_VLROC4		:= SN3->N3_VORIG4
					SN4->N4_VLROC5		:= SN3->N3_VORIG5
					SN4->N4_TIPOCNT	:= "1"
					SN4->N4_SUBCTA 	:= SN3->N3_SUBCCON
					SN4->N4_CLVL   	:= SN3->N3_CLVLCON
					SN4->N4_SEQ    	:= "001"
					SN4->N4_SEQREAV	:= SN3->N3_SEQREAV	
				MsUnlock("SN4")				
			else
				RecLock("SN4",.f.)			
					SN4->N4_VLROC1		+= SN3->N3_VORIG1
					SN4->N4_VLROC3		+= SN3->N3_VORIG3
				MsUnlock("SN4")			
			endif

			if	Empty(SN3->N3_DTBAIXA) .and. SN3->N3_ZZVLROR > 0		
			
				// Depreciação na conta de depreciação acumulada

				Reclock ("SN4",.T.)
					SN4->N4_FILIAL 	:= xFilial("SN4")
					SN4->N4_CBASE		:= SN3->N3_CBASE
					SN4->N4_ITEM		:= SN3->N3_ITEM
					SN4->N4_TIPO		:= SN3->N3_TIPO
					SN4->N4_QUANTD 	:= SN1->N1_QUANTD
					SN4->N4_OCORR		:= "06"    
					SN4->N4_MOTIVO 	:=	iif( Empty(SN3->N3_DTBAIXA) , "" , "05" )
					SN4->N4_VLROC1 	:= SN3->N3_ZZVLROR
					SN4->N4_VLROC2 	:= 0
					SN4->N4_VLROC3 	:= ( SN3->N3_ZZVLROR / 0.8287 )
					SN4->N4_VLROC4 	:= 0
					SN4->N4_VLROC5 	:= 0
					SN4->N4_DATA		:= CtoD("31/12/2006")
					SN4->N4_CONTA		:= SN3->N3_CDEPREC
					SN4->N4_TXMEDIA	:= iif( Empty(SN3->N3_DTBAIXA) , 0 , 1 )
					SN4->N4_TXDEPR 	:=	SN3->N3_TXDEPR1
					SN4->N4_TIPOCNT	:=	"3"
					SN4->N4_CCUSTO 	:= SN3->N3_CCDESP
					SN4->N4_SUBCTA 	:= SN3->N3_SUBCDEP
					SN4->N4_CLVL   	:= SN3->N3_CLVLDEP
					SN4->N4_SEQ    	:= SN3->N3_SEQ	
					SN4->N4_SEQREAV	:=	""
				MsUnlock("SN4")

				Reclock ( "SN4",.T. )
					SN4->N4_FILIAL 	:= xFilial("SN4")
					SN4->N4_CBASE		:= SN3->N3_CBASE
					SN4->N4_ITEM		:= SN3->N3_ITEM
					SN4->N4_TIPO		:= SN3->N3_TIPO
					SN4->N4_QUANTD 	:= SN1->N1_QUANTD
					SN4->N4_OCORR		:= "06"    ///06
					SN4->N4_MOTIVO 	:= iif( Empty(SN3->N3_DTBAIXA) , "" , "05" )
					SN4->N4_VLROC1 	:= SN3->N3_ZZVLROR
					SN4->N4_VLROC2 	:= 0
					SN4->N4_VLROC3 	:= ( SN3->N3_ZZVLROR / 0.8287 )
					SN4->N4_VLROC4 	:= 0
					SN4->N4_VLROC5 	:= 0
					SN4->N4_DATA		:= CtoD("31/12/2006")
					SN4->N4_CONTA		:= SN3->N3_CCDEPR
					SN4->N4_TXMEDIA	:= iif( Empty(SN3->N3_DTBAIXA) , 0 , 1 )
					SN4->N4_TXDEPR 	:=	SN3->N3_TXDEPR1
					SN4->N4_SEQ 		:= SN3->N3_SEQ
					SN4->N4_TIPOCNT	:=	"4"
					SN4->N4_CCUSTO 	:= SN3->N3_CCCDEP
					SN4->N4_SUBCTA 	:= SN3->N3_SUBCCDE
					SN4->N4_CLVL   	:= SN3->N3_CLVLCDE
					SN4->N4_SEQREAV	:= ""
				MsUnlock("SN4")
			endif			
			
			if	!Empty(SN3->N3_DTBAIXA) .and. SN3->N3_DTBAIXA < CtoD("01/01/07")

				if	SN3->N3_ZZVLROR > 0

					// Depreciação na conta de depreciação acumulada
	
					Reclock ("SN4",.T.)
						SN4->N4_FILIAL 	:= xFilial("SN4")
						SN4->N4_CBASE		:= SN3->N3_CBASE
						SN4->N4_ITEM		:= SN3->N3_ITEM
						SN4->N4_TIPO		:= SN3->N3_TIPO
						SN4->N4_QUANTD 	:= SN1->N1_QUANTD
						SN4->N4_OCORR		:= "06"    
						SN4->N4_MOTIVO 	:=	iif( Empty(SN3->N3_DTBAIXA) , "" , "05" )
						SN4->N4_VLROC1 	:= SN3->N3_ZZVLROR
						SN4->N4_VLROC2 	:= 0
						SN4->N4_VLROC3 	:= ( SN3->N3_ZZVLROR / 0.8287 )
						SN4->N4_VLROC4 	:= 0
						SN4->N4_VLROC5 	:= 0
						SN4->N4_DATA		:= SN3->N3_DTBAIXA
						SN4->N4_CONTA		:= SN3->N3_CDEPREC
						SN4->N4_TXMEDIA	:= iif( Empty(SN3->N3_DTBAIXA) , 0 , 1 )
						SN4->N4_TXDEPR 	:=	SN3->N3_TXDEPR1
						SN4->N4_TIPOCNT	:=	"3"
						SN4->N4_CCUSTO 	:= SN3->N3_CCDESP
						SN4->N4_SUBCTA 	:= SN3->N3_SUBCDEP
						SN4->N4_CLVL   	:= SN3->N3_CLVLDEP
						SN4->N4_SEQ    	:= SN3->N3_SEQ	
						SN4->N4_SEQREAV	:=	""
					MsUnlock("SN4")
	
					Reclock ( "SN4",.T. )
						SN4->N4_FILIAL 	:= xFilial("SN4")
						SN4->N4_CBASE		:= SN3->N3_CBASE
						SN4->N4_ITEM		:= SN3->N3_ITEM
						SN4->N4_TIPO		:= SN3->N3_TIPO
						SN4->N4_QUANTD 	:= SN1->N1_QUANTD
						SN4->N4_OCORR		:= "06"
						SN4->N4_MOTIVO 	:= iif( Empty(SN3->N3_DTBAIXA) , "" , "05" )
						SN4->N4_VLROC1 	:= SN3->N3_ZZVLROR
						SN4->N4_VLROC2 	:= 0
						SN4->N4_VLROC3 	:= ( SN3->N3_ZZVLROR / 0.8287 )
						SN4->N4_VLROC4 	:= 0
						SN4->N4_VLROC5 	:= 0
						SN4->N4_DATA		:= SN3->N3_DTBAIXA
						SN4->N4_CONTA		:= SN3->N3_CCDEPR
						SN4->N4_TXMEDIA	:= iif( Empty(SN3->N3_DTBAIXA) , 0 , 1 )
						SN4->N4_TXDEPR 	:=	SN3->N3_TXDEPR1
						SN4->N4_SEQ 		:= SN3->N3_SEQ
						SN4->N4_TIPOCNT	:=	"4"
						SN4->N4_CCUSTO 	:= SN3->N3_CCCDEP
						SN4->N4_SUBCTA 	:= SN3->N3_SUBCCDE
						SN4->N4_CLVL   	:= SN3->N3_CLVLCDE
						SN4->N4_SEQREAV	:= ""
					MsUnlock("SN4")
            
				endif
				
				Reclock( "SN4",.T.)
					SN4->N4_FILIAL 	:= xFilial("SN4")
					SN4->N4_CBASE		:= SN3->N3_CBASE
					SN4->N4_ITEM		:= SN3->N3_ITEM
					SN4->N4_TIPO		:= SN3->N3_TIPO
					SN4->N4_QUANTD 	:= SN1->N1_QUANTD
					SN4->N4_OCORR		:= "01"
					SN4->N4_MOTIVO 	:= "05"
					SN4->N4_DATA		:=	SN3->N3_DTBAIXA
					SN4->N4_VLROC1 	:=	SN3->N3_VORIG1
					SN4->N4_VLROC2 	:= 0
					SN4->N4_VLROC3 	:= SN3->N3_VORIG3
					SN4->N4_VLROC4 	:= 0
					SN4->N4_VLROC5 	:= 0
					SN4->N4_TXMEDIA	:= 1
					SN4->N4_TXDEPR 	:= SN3->N3_TXDEPR1
					SN4->N4_VENDA  	:= SN3->N3_VORIG1
					SN4->N4_NOTA		:= ""
					SN4->N4_SERIE		:= ""
					SN4->N4_CONTA		:= SN3->N3_CCONTAB  
					SN4->N4_SEQ 		:= SN3->N3_SEQ
					SN4->N4_TIPOCNT	:=	"1"
					SN4->N4_CCUSTO 	:= SN3->N3_CUSTBEM
					SN4->N4_SUBCTA 	:= SN3->N3_SUBCCON
					SN4->N4_CLVL   	:= SN3->N3_CLVLCON
					SN4->N4_SEQREAV	:= ""
				MsUnlock("SN4")

				if	SN3->N3_ZZVLROR > 0

					Reclock( "SN4",.T. )              //Gerar registro de baixa da depreciacao
						SN4->N4_FILIAL 	:= xFilial("SN4")
						SN4->N4_CBASE		:= SN3->N3_CBASE
						SN4->N4_ITEM		:= SN3->N3_ITEM
						SN4->N4_TIPO		:= SN3->N3_TIPO
						SN4->N4_QUANTD 	:= SN1->N1_QUANTD
						SN4->N4_OCORR		:= "01"
						SN4->N4_MOTIVO 	:= "05"
						SN4->N4_DATA		:=	SN3->N3_DTBAIXA
						SN4->N4_VLROC1 	:= SN3->N3_ZZVLROR
						SN4->N4_VLROC2 	:= 0
						SN4->N4_VLROC3 	:= ( SN3->N3_ZZVLROR / 0.8287 )
						SN4->N4_VLROC4 	:= 0
						SN4->N4_VLROC5 	:= 0
						SN4->N4_TXMEDIA	:= 1
						SN4->N4_TXDEPR 	:= SN3->N3_TXDEPR1
						SN4->N4_VENDA  	:= SN3->N3_VORIG1
						SN4->N4_NOTA		:= ""
						SN4->N4_SERIE		:= ""
						SN4->N4_CONTA		:= SN3->N3_CCDEPR
						SN4->N4_SEQ 		:= SN3->N3_SEQ
						SN4->N4_TIPOCNT	:=	"4"
						SN4->N4_CCUSTO 	:= SN3->N3_CCCDEP
						SN4->N4_SUBCTA 	:= SN3->N3_SUBCCDE
						SN4->N4_CLVL   	:= SN3->N3_CLVLCDE
						SN4->N4_SEQREAV 	:= ""
					MsUnlock("SN4")            
				endif
			endif
		endif
	endif
	SN3->(dbskip())
enddo

Return

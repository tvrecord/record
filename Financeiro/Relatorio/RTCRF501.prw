#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "font.ch"
#include "colors.ch"
#include "winapi.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRF501  บ Autor ณ Paulo Schwind      บ Data ณ  08/08/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Tempo Medio de Recebimentos / Pagamentos      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Radio e TV Capital - Record Brasilia          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑบ13.08.07  ณ Ultima alteracao - Hora : 17:47 - Paulo Schwind            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ*/

User Function RTCRF501()

Local cDesc1       	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3       	:= "Relatorio de Tempo Medio de Recebimentos / Pagamentos"
Local cPict        	:= ""
Local titulo       	:= "" 
Local nLin         	:= 132 
Local Cabec1			:=	""
Local Cabec2       	:= ""
Local imprime      	:= .t.
Local aOrd 				:= {}

Private cPerg        :=	'RTC50X    ' 
Private lEnd         := .f.
Private lAbortPrint  := .f.
Private CbTxt        := ""
Private limite       := 132 
Private tamanho      := "G" 
Private nomeprog     := "RTCRF501" 
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RTCRF501" 
Private cTipos       := ''
Private cString 		:= "SE1"
Private _lExistB		:=	.f.

// Definindo o Cabecalho do Relatorio

Cabec1       := "Titulo  Pref Prc Emissao     Vencimento  Dt Recebim    Valor Titulo   Valor Recebido        Desconto          Juros/           Saldo  Natureza                        Qt Dias   Qt Dias  Eficiencia     Tp Titulo " 
Cabec2       := "                                                                                                              Multas                                                  Em.X Rec. VenXRec.     %                 "           
             //  999999  XXX  99  99/99/9999  99/99/9999  99/99/9999  999,999,999,99   999,999,999,99  999,999,999,99  999,999,999,99  999,999,999,99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99999999  99999999   999.99 %     XXXXXXXXXX
             //  0       8    13  18          29          41          53               70              86              102             118             134                             166       176        187          200                                                           

ValidPerg()

Pergunte(cPerg,.t.)	

if LastKey()=27
   Return
endif

// monta o titulo do relatorio, conforma parametro informado

if mv_par23=1
   titulo += " Tempo Medio de Recebimentos - Emissao :"+DtoC(mv_par09)+" ate "+DtoC(mv_par10)+" - Venc.:"+DtoC(mv_par11)+" ate "+DtoC(mv_par12)+" - Pagam.:"+DtoC(mv_par25)+" ate "+DtoC(mv_par26)
elseif mv_par23=2
   titulo += " Tempo Medio de Pagamentos - Emissao : "+DtoC(mv_par09)+" ate "+DtoC(mv_par10)+" - Venc.:"+DtoC(mv_par11)+" ate "+DtoC(mv_par12)+" - Pagam.:"+DtoC(mv_par25)+" ate "+DtoC(mv_par26)
else
   titulo += " Tempo Medio de Recebimentos e Pagamentos - Emissao : "+DtoC(mv_par09)+" ate "+DtoC(mv_par10)+" - Venc.:"+DtoC(mv_par11)+" ate "+DtoC(mv_par12)+" - Pagam.:"+DtoC(mv_par25)+" ate "+DtoC(mv_par26)
endif

dbSelectArea("SE1")
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.t.,aOrd,.t.,Tamanho,,.t.)

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  23/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local _nRegs   := 0
Local _nRegsE5 := 0
Local _cCODCLI := ''
Local _cCODFOR := ''

// verifica se e para emitir tempo medio de recebimentos ou ambos

if mv_par23 == 1 .or. mv_par23 == 3

	SelTitulosE1()
	
	dbSelectArea("TRE1")
	dbGoTop()

	TRE1->( dbEval( { || _nRegs ++ } ) )
	
	if	_nRegs = 0
		Aviso("Aviso", "Sem registros para a Emissao do Relatorio [SE1]!", {"Ok"} )
	endif
	
	SetRegua(_nRegs)
	dbGoTop()
	
	_nTotCli   := 0
	_nTotRec   := 0
	_nTotJur   := 0
	_nTotDes   := 0
	_nTotSld   := 0
	_nQtdTitCR := 0
	_nQtdTitBX := 0
	_nQtdTitBP := 0
	_nSomatDias:= 0
	_nTotalCli := 0
	_nSaldoCli := 0
	_nTotalRec := 0
	_nSaldoRec := 0
	_nSomaDER  := 0
	_nSomaDVR  := 0
	
	Do While ! TRE1->(EOF())
		
		if lAbortPrint
			@nLin,00 psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		endif
		
		if nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		endif

		SelBaixasE5( TRE1->E1_FILIAL, TRE1->E1_CLIENTE, TRE1->E1_LOJA, TRE1->E1_NUM, TRE1->E1_PREFIXO, TRE1->E1_PARCELA , "R" )

		_nRegsE5 := 0		

		TRE5->(dbEval( { || _nRegsE5 ++ } ) )
		TRE5->(dbGoTop())

		if mv_par18 == 1
			if _cCODCLI <> TRE1->E1_CLIENTE 
				@ ++ nLin,000 psay  "Cliente : " +TRE1->E1_CLIENTE +" "+TRE1->E1_LOJA + " - " + IF( mv_par14=1 , POSICIONE("SA1",1,xFilial("SA1")+TRE1->E1_CLIENTE+TRE1->E1_LOJA,"A1_NOME") , POSICIONE("SA1",1,xFilial("SA1")+TRE1->E1_CLIENTE+TRE1->E1_LOJA,"A1_NREDUZ") )
				@ ++ nLin,000 psay Replicate("-",60)
				nLin += 2
			endif
		endif

		_cCODCLI := TRE1->E1_CLIENTE
		
		if mv_par18 == 1 .and. _nRegsE5 > 0 

			@ nLin,000 psay  TRE1->E1_NUM
			@ nLin,008 psay  TRE1->E1_PREFIXO
			@ nLin,013 psay  TRE1->E1_PARCELA
			
			@ nLin,018 psay  TRE1->E1_EMISSAO
			@ nLin,029 psay  TRE1->E1_VENCREA
			@ nLin,041 psay  TRE1->E1_BAIXA
			
			@ nLin,053 psay  TRE1->E1_VALOR   Picture "@E 999,999,999.99"
			@ nLin,134 psay  Posicione("SED",1,xFilial("SED")+TRE1->E1_NATUREZ,"ED_DESCRIC")
			@ nLin,200 psay  TRE1->E1_TIPO			
		endif

		if _nRegsE5 > 0 
		   _nQtdTitCR ++		
		   _nSaldoCli += TRE1->E1_SALDO		
		   _nTotalRec += TRE1->E1_VALOR
		   _nSaldoRec += TRE1->E1_SALDO
		endif
		
		if mv_par18 == 1
			if _nRegsE5 > 0 
				nLin ++
				@ ++ nLin,000 psay "===== Relacao de Baixas REC " + Replicate("=",191)
				nLin ++
			endif
		endif
		
		Do While ! TRE5->(EOF())			

			if mv_par18 == 1
			
				@ nLin,000 psay TRE5->E5_NUMERO
				@ nLin,008 psay TRE5->E5_PREFIXO
				@ nLin,013 psay TRE5->E5_PARCELA				
				@ nLin,018 psay TRE1->E1_EMISSAO
				@ nLin,029 psay TRE1->E1_VENCREA
				@ nLin,041 psay TRE5->E5_DATA				
				@ nLin,053 psay TRE1->E1_VALOR    Picture "@E 999,999,999.99"
				@ nLin,070 psay TRE5->E5_VALOR    Picture "@E 999,999,999.99"
				@ nLin,086 psay TRE5->E5_VLDESCO  Picture "@E 999,999,999.99"				
				@ nLin,102 psay TRE5->E5_VLJUROS+TRE5->E5_VLMULTA  Picture "@E 999,999,999.99"				
				@ nLin,134 psay POSICIONE("SED",1,xFilial("SED")+TRE5->E5_NATUREZ,"ED_DESCRIC")
				
				if mv_par13 <> 2
					@ nLin,166 psay TRE5->E5_DATA-TRE1->E1_EMISSAO   Picture "99999999"
				endif
				
				if mv_par13 <> 1
					@ nLin,176 psay TRE5->E5_DATA-TRE1->E1_VENCREA   Picture "99999999"
				endif
				
				@ nLin,187 psay ( 1-( TRE5->E5_VALOR / TRE1->E1_VALOR ))*100  Picture TM(( 1 - (TRE5->E5_VALOR / TRE1->E1_VALOR))*100,10,2)
				@ nLin,pcol()+2 psay "%"
				
				nLin ++
			endif
			
			_nQtdTitBX 	++
			_nSomaDER 	+= (TRE5->E5_DATA-TRE1->E1_EMISSAO)
			_nSomaDVR 	+= (TRE5->E5_DATA-TRE1->E1_VENCREA)
			_nTotalCli 	+= TRE5->E5_VALOR
			_nTotRec   	+= TRE5->E5_VALOR
			_nTotJur   	+= TRE5->E5_VLJUROS + TRE5->E5_VLMULTA
			_nTotDes   	+= TRE5->E5_VLDESCO
			
			TRE5->(dbSkip())			
		EndDo
		
		if mv_par18 == 1 .and._nRegsE5 > 0

			@ ++ nLin,000 psay Replicate("-",220)
			@ ++ nLin,046 psay "Totais ---->"
			@    nLin,070 psay _nTotRec  Picture "@E 999,999,999.99"
			@    nLin,086 psay _nTotDes  Picture "@E 999,999,999.99"
			@    nLin,102 psay _nTotJur  Picture "@E 999,999,999.99"
			@ ++ nLin,000 psay Replicate("-",220)

			_nTotRec := 0
			_nTotSld := 0
			_nTotJur := 0
			_nTotDes := 0
			
			nLin += 2
		endif
		
		dbSelectArea("TRE1")

		IncRegua()

		TRE1->(dbSkip())
		
		if mv_par16 == 1  .and.  mv_par18 == 1 
			if _cCODCLI <> TRE1->E1_CLIENTE 
			
				@    nLin,000 psay Replicate("-",220)
				@ ++ nLin,036 psay "Totais do Cliente ---->"
				@    nLin,070 psay _nTotalCli  Picture "@E 999,999,999.99"
				@    nLin,118 psay _nSaldoCli  Picture "@E 999,999,999.99"
				@ ++ nLin,000 psay Replicate("-",220)
	
				nLin ++
				
				_nTotalCli := 0
				_nSaldoCli := 0
				
				if mv_par17 == 1
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				endif
			endif
		endif
		
		if TRE1->(Eof()) .and. mv_par23 == 1 

			nLin ++
			
			@ ++ nLin,000 psay Replicate("-",220)
			@ ++ nLin,46 psay "Total a Receber --> "
			@    nLin,070 psay _nTotalRec  Picture "@E 999,999,999.99"
			@    nLin,118 psay _nSaldoRec  Picture "@E 999,999,999.99"
			@ ++ nLin,000 psay Replicate("-",220)
			@ ++ nLin,027 psay "Titulos Emitidos a Receber --------> "
			@    nLin,070 psay _nQtdTitCR  Picture "9999999999"
			@ ++ nLin,027 psay "Qtde de Baixas a Rceber -----------> "
			@    nLin,070 psay _nQtdTitBX  Picture "9999999999"
			@ ++ nLin,027 psay "Tot Dias Emissao X Recebimento ----> "
			@    nLin,070 psay _nSomaDER   Picture "9999999999"
			@ ++ nLin,027 psay "Tot Dias Vencimen X Recebimento ---> "
			@    nLin,070 psay _nSomaDVR   Picture "9999999999"
			@ ++ nLin,027 psay "Media Dias Emissao X Recebimento --> "
			@    nLin,070 psay _nSomaDER / _nQtdTitCR  Picture "9999999.99"			
			@ ++ nLin,027 psay "Media Dias Vencimen X Recebimento -> "
			@    nLin,070 psay _nSomaDVR / _nQtdTitCR  Picture "9999999.99"
			@ ++ nLin,000 psay Replicate("-",220)			
			@    nLin,pcol() + 1 psay '   '
		endif		
	enddo
endif

if mv_par23 == 2 .or. mv_par23 == 3

	_nTotFor   := 0
	_nTotPaG   := 0
	_nTotJur   := 0
	_nTotDes   := 0
	_nTotSld   := 0
	_nQtdTitCP := 0
	_nQtdTitBP := 0
	_nSomatDias:= 0
	_nTotalFor := 0
	_nSaldoFor := 0
	_nTotalPag := 0
	_nSaldoPag := 0
	_nSomaDEP  := 0
	_nSomaDVP  := 0

	SelTitSE2()
	
   _nRegs := 0

	dbSelectArea("TRE2")
	dbGoTop()

	TRE2->( dbEval( { || _nRegs ++ } ) )
	
	if	_nRegs == 0
		Aviso("Aviso", "Sem registros para a Emissao do Relatorio [SE2]!", {"Ok"})
	endif
	
	if mv_par24 == 1 .and. mv_par18 == 1
		nLin := 56
	endif

	SetRegua(_nRegs)

	dbGoTop()
	
	Do While ! TRE2->(EOF())
		
		if lAbortPrint
			@nLin,00 psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		endif
		
		if nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		endif
		
		SelBaixasE5( TRE2->E2_FILIAL, TRE2->E2_FORNECE, TRE2->E2_LOJA, TRE2->E2_NUM, TRE2->E2_PREFIXO, TRE2->E2_PARCELA,"P")

		_nRegsE5 := 0

		TRE5->( dbEval( { || _nRegsE5 ++ } ) )
		TRE5->(dbGoTop())

		if mv_par18 == 1
			if _cCODFOR <> TRE2->E2_FORNECE 
				@ ++ nLin,000 psay  "Fornecedor : " +TRE2->E2_FORNECE +" "+TRE2->E2_LOJA + " - " + IF( mv_par14=1 , POSICIONE("SA2",1,xFilial("SA2")+TRE2->E2_FORNECE+TRE2->E2_LOJA,"A2_NOME") , POSICIONE("SA2",1,xFilial("SA2")+TRE2->E2_CLIENTE+TRE2->E2_LOJA,"A2_NREDUZ") )
				@ ++ nLin,000 psay Replicate("-",70)
				nLin += 2
			endif
		endif

		_cCODFOR := TRE2->E2_FORNECE
		
		if mv_par18 == 1 .and. _nRegsE5 > 0
			@ nLin,000 psay  TRE2->E2_NUM
			@ nLin,008 psay  TRE2->E2_PREFIXO
			@ nLin,013 psay  TRE2->E2_PARCELA
			@ nLin,018 psay  TRE2->E2_EMISSAO
			@ nLin,029 psay  TRE2->E2_VENCREA
			@ nLin,041 psay  TRE2->E2_BAIXA
			@ nLin,053 psay  TRE2->E2_VALOR   Picture "@E 999,999,999.99"
			@ nLin,134 psay  POSICIONE("SED",1,xFilial("SED")+TRE2->E2_NATUREZ,"ED_DESCRIC")
			@ nLin,200 psay  TRE2->E2_TIPO			
		endif
		
      if _nRegsE5 > 0
		   _nQtdTitCP ++
		   _nSaldoFor += TRE2->E2_SALDO
		   _nTotalPag += TRE2->E2_VALOR
		   _nSaldoPag += TRE2->E2_SALDO
		endif   
		
		if mv_par18 == 1
			if _nRegsE5 > 0 // SE EXISTEM BAIXAS
				nLin ++
				@ ++ nLin,000 psay "===== Relacao de Baixas PAG " + Replicate("=",191)
				nLin++
			endif
		endif
		
		Do While ! TRE5->(Eof())
			
			if mv_par18 == 1
				@ nLin,000 psay TRE5->E5_NUMERO
				@ nLin,008 psay TRE5->E5_PREFIXO
				@ nLin,013 psay TRE5->E5_PARCELA
				@ nLin,018 psay TRE2->E2_EMISSAO
				@ nLin,029 psay TRE2->E2_VENCREA
				@ nLin,041 psay TRE5->E5_DATA
				@ nLin,053 psay TRE2->E2_VALOR    Picture "@E 999,999,999.99"
				@ nLin,070 psay TRE5->E5_VALOR    Picture "@E 999,999,999.99"
				@ nLin,086 psay TRE5->E5_VLDESCO  Picture "@E 999,999,999.99"
				@ nLin,102 psay TRE5->E5_VLJUROS+TRE5->E5_VLMULTA  Picture "@E 999,999,999.99"
				@ nLin,134 psay POSICIONE("SED",1,xFilial("SED")+TRE5->E5_NATUREZ,"ED_DESCRIC")
				
				if mv_par13 <> 2
					@ nLin,166 psay TRE5->E5_DATA-TRE2->E2_EMISSAO   Picture "99999999"
				endif
				
				if mv_par13 <> 1
					@ nLin,176 psay TRE5->E5_DATA-TRE2->E2_VENCREA   Picture "99999999"
				endif
				
				@ nLin,187 psay ( 1-( TRE5->E5_VALOR / TRE2->E2_VALOR ))*100  Picture TM(( 1 - (TRE5->E5_VALOR / TRE2->E2_VALOR))*100,10,2)
				@ nLin,pcol()+2 psay "%"
				
				nLin ++
			endif
			
			_nQtdTitBP 	++
			_nSomaDEP 	+= (TRE5->E5_DATA-TRE2->E2_EMISSAO)
			_nSomaDVP 	+= (TRE5->E5_DATA-TRE2->E2_VENCREA)
			_nTotalFor 	+= TRE5->E5_VALOR
			_nTotPag   	+= TRE5->E5_VALOR
			_nTotJur   	+= TRE5->E5_VLJUROS + TRE5->E5_VLMULTA
			_nTotDes   	+= TRE5->E5_VLDESCO
			
			TRE5->(dbSkip())			
		EndDo
		
		if mv_par18 == 1 .and._nRegsE5 > 0
			@    nLin,000 psay Replicate("-",220)
			@ ++ nLin,046 psay "Totais ---->"
			@    nLin,070 psay _nTotPag  Picture "@E 999,999,999.99"
			@    nLin,086 psay _nTotDes  Picture "@E 999,999,999.99"
			@    nLin,102 psay _nTotJur  Picture "@E 999,999,999.99"
			@ ++ nLin,000 psay Replicate("-",220)

			_nTotPag := 0
			_nTotSld := 0
			_nTotJur := 0
			_nTotDes := 0			

			nLin += 2
		endif
		
		dbSelectArea("TRE2")
		IncRegua()
		TRE2->(dbSkip())
		
		if mv_par16 == 1  .and.  mv_par18 == 1 
			if _cCODFOR <> TRE2->E2_FORNECE
				@    nLin,000 psay Replicate("-",220)
				@ ++ nLin,036 psay "Totais do Fornecedor ->"
				@    nLin,070 psay _nTotalFor  Picture "@E 999,999,999.99"
				@    nLin,118 psay _nSaldoFor  Picture "@E 999,999,999.99"
				@ ++ nLin,000 psay Replicate("-",220)
				nLin ++
				
				_nTotalFor := 0
				_nSaldoFor := 0
				
				if mv_par17 == 1
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				endif
			endif
		endif

		if TRE2->(Eof())
	   	if mv_par23 == 3 
   			nLin ++
		   	@ ++ nLin,000 			psay Replicate("-",220)
   			@ ++ nLin,046     	psay "Total a Receber --> "
	   		@    nLin,070     	psay _nTotalRec  Picture "@E 999,999,999.99"
		   	@    nLin,118     	psay _nSaldoRec  Picture "@E 999,999,999.99"
   			@ ++ nLin,046     	psay "Total a Pagar ----> "
	   		@    nLin,070     	psay _nTotalPag  Picture "@E 999,999,999.99"
		   	@    nLin,118     	psay _nSaldoPag  Picture "@E 999,999,999.99"
	   		@ ++ nLin,000 			psay Replicate("-",220)
			   @ ++ nLin,027    	 	psay "Titulos Emitidos a Receber --------> "
			   @    nLin,027 + 090 	psay "Titulos Emitidos a Pagar ----------> "
			   @    nLin,070     	psay _nQtdTitCR  Picture "9999999999"
			   @    nLin,070 + 090 	psay _nQtdTitCP  Picture "9999999999"
	   		@ ++ nLin,027     	psay "Qtde de Baixas a Receber ----------> "
	   		@    nLin,027 + 090 	psay "Qtde de Baixas a Pagar ------------> "
		   	@    nLin,070     	psay _nQtdTitBX  Picture "9999999999"
		   	@    nLin,070 + 090	psay _nQtdTitBP  Picture "9999999999"
   			@ ++ nLin,027     	psay "Tot Dias Emissao X Recebimento ----> "
   			@    nLin,027 + 090 	psay "Tot Dias Emissao X Pagamento ------> "
	   		@    nLin,070     	psay _nSomaDER   Picture "9999999999"
	   		@    nLin,070 + 090 	psay _nSomaDEP   Picture "9999999999"
   			@ ++ nLin,027     	psay "Tot Dias Vencimen X Recebimento ---> "
   			@    nLin,027 + 090 	psay "Tot Dias Vencimen X Pagamento -----> "
	   		@    nLin,070     	psay _nSomaDVR   Picture "9999999999"
	   		@    nLin,070 + 090 	psay _nSomaDVP   Picture "9999999999"
   			@ ++ nLin,027     	psay "Media Dias Emissao X Recebimento --> "
   			@    nLin,027 + 090 	psay "Media Dias Emissao X Pagamento ----> "
	   		@    nLin,070     	psay _nSomaDER / _nQtdTitCR  Picture "9999999.99"			
	   		@    nLin,070 + 090 	psay _nSomaDEP / _nQtdTitCP  Picture "9999999.99"			
   			@ ++ nLin,027     	psay "Media Dias Vencimen X Recebimento -> "
   			@    nLin,027 + 090 	psay "Media Dias Vencimen X Pagamento ---> "
	   		@    nLin,070     	psay _nSomaDVR / _nQtdTitCR  Picture "9999999.99"
	   		@    nLin,070 + 090 	psay _nSomaDVP / _nQtdTitCP  Picture "9999999.99"
   			@ ++ nLin,000 			psay Replicate("-",220)
	   		@    nLin,pcol() + 1	psay '   '

         elseif mv_par23 = 2 

			   nLin ++
   			@ ++ nLin,000 psay Replicate("-",220)
   			@ ++ nLin,046 psay "Total a Pagar ----> "
   			@    nLin,070 psay _nTotalPag  Picture "@E 999,999,999.99"
   			@    nLin,118 psay _nSaldoPag  Picture "@E 999,999,999.99"
   			nLin ++
   			@ ++ nLin,000 psay Replicate("-",220)
   			@ ++ nLin,027 psay "Titulos Emitidos a Pagar ----------> "
   			@    nLin,070 psay _nQtdTitCP  Picture "9999999999"
   			@ ++ nLin,027 psay "Qtde de Baixas a Pagar ------------> "
   			@    nLin,070 psay _nQtdTitBP  Picture "9999999999"
   			@ ++ nLin,027 psay "Tot Dias Emissao X Pagamento ------> "
   			@    nLin,070 psay _nSomaDEP   Picture "9999999999"
   			@ ++ nLin,027 psay "Tot Dias Vencimen X Pagamento -----> "
   			@    nLin,070 psay _nSomaDVP   Picture "9999999999"
   			@ ++ nLin,027 psay "Media Dias Emissao X Pagamento ----> "
   			@    nLin,070 psay _nSomaDEP / _nQtdTitCP  Picture "9999999.99"
   			@ ++ nLin,027 psay "Media Dias Vencimen X Pagamento ---> "
   			@    nLin,070 psay _nSomaDVP / _nQtdTitCP  Picture "9999999.99"
   			@ ++ nLin,000 psay Replicate("-",220)
   		endif

			@ nLin,pcol() + 1 psay '   '
		endif		
	enddo
endif

Set Device to Screen

if aReturn[5]==1
   dbCommitAll()
   Set Printer To
   OurSpool(wnrel)
endif

Ms_Flush()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelTitulosE1 บAutor  ณPaulo Schwind    บ Data ณ  08/08/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona os Titulos do SE1 (C/Receber), conforme parame-  บฑฑ
ฑฑบ          ณ tos informados.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Radio e TV Capital - Record Brasilia          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SelTitulosE1()                                              

Local cSelect := cFrom := cWhere := cOrder := cQuery := ''

cSelect := 	"E1_FILIAL, E1_NUM, E1_PREFIXO, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR, E1_SALDO, "
cSelect +=	"E1_EMISSAO, E1_VENCREA, E1_BAIXA, E1_DESCONT, E1_JUROS, E1_NATUREZ, E1_TIPO " 

cFrom   := RetSQLName("SE1") 

cWhere  := "D_E_L_E_T_ == ' '      AND " 
cWhere  += "E1_SALDO   <> E1_VALOR AND " 
cWhere  += "E1_FILIAL  >= '" + mv_par01 			+	"' AND "  
cWhere  += "E1_FILIAL  <= '" + mv_par02 			+	"' AND "  
cWhere  += "E1_CLIENTE >= '" + mv_par03 			+	"' AND "  
cWhere  += "E1_LOJA    >= '" + mv_par04 			+	"' AND "  
cWhere  += "E1_CLIENTE <= '" + mv_par05 			+	"' AND "  
cWhere  += "E1_LOJA    <= '" + mv_par06 			+	"' AND "  
cWhere  += "E1_NATUREZ >= '" + mv_par07 			+	"' AND "  
cWhere  += "E1_NATUREZ <= '" + mv_par08 			+	"' AND "  
cWhere  += "E1_EMISSAO >= '" + DtoS(mv_par09) 	+	"' AND "  
cWhere  += "E1_EMISSAO <= '" + DtoS(mv_par10) 	+	"' AND "  
cWhere  += "E1_VENCREA >= '" + DtoS(mv_par11) 	+	"' AND "  
cWhere  += "E1_VENCREA <= '" + DtoS(mv_par12) 	+	"' AND " 
cWhere  += "E1_BAIXA   >= '" + DtoS(mv_par25) 	+	"' AND "  
cWhere  += "E1_BAIXA   <= '" + DtoS(mv_par26) 	+	"' " 

if ! Empty(cTipos)
   cWhere += " AND E1_TIPO IN (" + cTipos + ") "
endif

cOrder  := "E1_CLIENTE, E1_LOJA, E1_NUM, E1_PREFIXO, E1_PARCELA "             

cQuery := "SELECT " + cSelect + " FROM " + cFrom + " WHERE " + cWhere + " ORDER BY " + cOrder

if Select("TRE1") > 0
   DbSelectArea("TRE1")
   TRE1->(DbCloseArea())
endif	

TCQUERY cQuery NEW ALIAS "TRE1"

TcSetField("TRE1","E1_VALOR"		,"N",12,2)
TcSetField("TRE1","E1_SALDO"		,"N",12,2)
TcSetField("TRE1","E1_EMISSAO"	,"D",08,0) 	
TcSetField("TRE1","E1_VENCREA"	,"D",08,0) 	
TcSetField("TRE1","E1_BAIXA"		,"D",08,0) 	
TcSetField("TRE1","E1_DESCONT"	,"N",12,2)
TcSetField("TRE1","E1_JUROS"		,"N",12,2)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SelBaixasE5 บAutor  ณPaulo Schwind    บ Data ณ  08/08/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona os Titulos do SE5 (Mov. Banc), conforme parame-  บฑฑ
ฑฑบ          ณ tos repassados do titulo do SE1.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Radio e TV Capital - Record Brasilia          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SelBaixasE5( _FIL, _CLI, _LOJ, _NUM, _PREF, _PARC, _PR )

Local cFrom 	:= ""
Local cWhere 	:= ""
Local cOrder 	:= ""
Local cQuery 	:=	""
Local cSelect 	:= ""
Local cBcoIni	:=	mv_par27 + mv_par28 + mv_par29
Local cBcoFim	:=	mv_par30 + mv_par31 + mv_par32

cSelect := 	"E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_DATA, E5_MOTBX, E5_VALOR, E5_VLJUROS, E5_VLMULTA,"
cSelect +=	"E5_VLDESCO, E5_TIPODOC,E5_VENCTO, E5_NATUREZ, E5_VLCORRE " 

cFrom   := RetSQLName("SE5")

cWhere  	:=	"D_E_L_E_T_ = ' '          AND " 
cWhere  	+=	"E5_SITUACA NOT IN ('C','E','X') AND " 
cWhere  	+=	"E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND " 
cWhere  	+=	"( ( E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA ) OR ( E5_TIPODOC <> 'CD' ) ) AND "
cWhere	+=	"E5_BANCO + E5_AGENCIA + E5_CONTA  >= '" + cBcoIni + "' AND "
cWhere	+=	"E5_BANCO + E5_AGENCIA + E5_CONTA  <= '" + cBcoFim + "' AND "
cWhere  	+=	"E5_FILIAL  = '"	+ _FIL 	+ "' AND " 
cWhere  	+=	"E5_CLIFOR  = '" 	+ _CLI 	+ "' AND " 
cWhere  	+=	"E5_LOJA    = '" 	+ _LOJ 	+ "' AND " 
cWhere  	+=	"E5_NUMERO  = '" 	+ _NUM 	+ "' AND " 
cWhere  	+=	"E5_PREFIXO = '" 	+ _PREF	+ "' AND " 
cWhere  	+=	"E5_PARCELA = '" 	+ _PARC	+ "' AND " 
cWhere  	+=	"E5_RECPAG  = '" 	+ _PR  	+ "'     " 

cOrder   :=	"E5_CLIFOR, E5_LOJA,E5_NUMERO, E5_PREFIXO, E5_PARCELA" 
	
cQuery	:=	"SELECT " + cSelect + " FROM " + cFrom + " WHERE " + cWhere + " ORDER BY " + cOrder

if Select("TRE5") > 0
   DbSelectArea("TRE5")
   TRE5->(DbCloseArea())
endif	

TcQuery cQuery New Alias "TRE5"

TCSetField("TRE5","E5_DATA"		,"D",08,0) 	
TCSetField("TRE5","E5_VALOR"		,"N",12,2)
TCSetField("TRE5","E5_VLJUROS"	,"N",12,2)
TCSetField("TRE5","E5_VLMULTA"	,"N",12,2)
TCSetField("TRE5","E5_VLDESCO"	,"N",12,2)
TCSetField("TRE5","E5_VENCTO"		,"D",08,0)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelTitulosE2 บAutor  ณPaulo Schwind    บ Data ณ 13/08/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona os Titulos do SE2 (C/Pagar), conforme parametros บฑฑ
ฑฑบ          ณ informados.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Radio e TV Capital - Record Brasilia          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SelTitSE2()

Local cSelect := cFrom := cWhere := cOrder := cQuery := ''

cSelect := "E2_FILIAL, E2_NUM, E2_PREFIXO, E2_PARCELA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_VALOR, E2_SALDO, " +;
           "E2_EMISSAO, E2_VENCREA, E2_BAIXA, E2_DESCONT, E2_JUROS, E2_CORREC, E2_NATUREZ, E2_TIPO " 

cFrom   := RetSQLName("SE2") 
cWhere  := "D_E_L_E_T_ <> '*'      AND " 
cWhere  += "E2_SALDO   <> E2_VALOR AND " 
cWhere  += "E2_FILIAL  >= '" + mv_par01			+ "' AND "  
cWhere  += "E2_FILIAL  <= '" + mv_par02			+ "' AND "  
cWhere  += "E2_FORNECE >= '" + mv_par19 			+ "' AND "  
cWhere  += "E2_LOJA    >= '" + mv_par20 			+ "' AND "  
cWhere  += "E2_FORNECE <= '" + mv_par21 			+ "' AND "  
cWhere  += "E2_LOJA    <= '" + mv_par22 			+ "' AND "  
cWhere  += "E2_NATUREZ >= '" + mv_par07 			+ "' AND "  
cWhere  += "E2_NATUREZ <= '" + mv_par08 			+ "' AND "  
cWhere  += "E2_EMISSAO >= '" + DtoS(mv_par09)	+ "' AND "  
cWhere  += "E2_EMISSAO <= '" + DtoS(mv_par10) 	+ "' AND "  
cWhere  += "E2_VENCREA >= '" + DtoS(mv_par11) 	+ "' AND "  
cWhere  += "E2_VENCREA <= '" + DtoS(mv_par12) 	+ "' AND " 
cWhere  += "E2_BAIXA   >= '" + DtoS(mv_par25) 	+ "' AND "  
cWhere  += "E2_BAIXA   <= '" + DtoS(mv_par26) 	+ "' " 
if ! Empty(cTipos)
   cWhere += "AND E2_TIPO IN ("+cTipos+")"
endif

cOrder  	:= "E2_FORNECE, E2_LOJA, E2_NUM, E2_PREFIXO, E2_PARCELA "             

cQuery	:=	"SELECT " + cSelect + " FROM " + cFrom + " WHERE " + cWhere + " ORDER BY " + cOrder

if Select("TRE2") > 0
   DbSelectArea("TRE2")
   TRE2->(DbCloseArea())
endif	

TcQuery cQuery New Alias "TRE2"

TcSetField("TRE2","E2_VALOR"		,"N",12,2)
TcSetField("TRE2","E2_SALDO"		,"N",12,2)
TcSetField("TRE2","E2_EMISSAO"	,"D",08,0) 	
TcSetField("TRE2","E2_VENCREA"	,"D",08,0) 	
TcSetField("TRE2","E2_BAIXA"		,"D",08,0) 	
TcSetField("TRE2","E2_DESCONT"	,"N",12,2)
TcSetField("TRE2","E2_JUROS"		,"N",12,2)
TcSetField("TRE2","E2_CORREC"		,"N",12,2)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaPerg  บAutor  ณPaulo Schwind       บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cria็ใo das perguntas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()

Local _nI 		:= 0
Local _nJ 		:= 0
Local _aRegs	:=	{}
Local _cPerg 	:= cPerg
Local _aArea 	:=	GetArea()

dbSelectArea('SX1')
dbSetOrder(1)

Aadd(_aRegs,{_cPerg,"01","Filial de                     ","                              ","                              ","mv_ch1","C",02,0,0,"G","                                                            ","mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SM0","S","   ","          "})
Aadd(_aRegs,{_cPerg,"02","Filial Ate                    ","                              ","                              ","mv_ch2","C",02,0,0,"G","                                                            ","mv_par02       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SM0","S","   ","          "})
Aadd(_aRegs,{_cPerg,"03","Cliente de                    ","                              ","                              ","mv_ch3","C",06,0,0,"G","                                                            ","mv_par03       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA1","S","   ","          "})
Aadd(_aRegs,{_cPerg,"04","Loja de                       ","                              ","                              ","mv_ch4","C",02,0,0,"G","                                                            ","mv_par04       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"05","Cliente Ate                   ","                              ","                              ","mv_ch5","C",06,0,0,"G","                                                            ","mv_par05       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA1","S","   ","          "})
Aadd(_aRegs,{_cPerg,"06","Loja Ate                      ","                              ","                              ","mv_ch6","C",02,0,0,"G","                                                            ","mv_par06       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"07","Natureza de                   ","                              ","                              ","mv_ch7","C",10,0,0,"G","                                                            ","mv_par07       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SED","S","   ","          "})
Aadd(_aRegs,{_cPerg,"08","Natureza Ate                  ","                              ","                              ","mv_ch8","C",10,0,0,"G","                                                            ","mv_par08       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SED","S","   ","          "})
Aadd(_aRegs,{_cPerg,"09","Emissao de                    ","                              ","                              ","mv_ch9","D",08,0,0,"G","                                                            ","mv_par09       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"10","Emissao Ate                   ","                              ","                              ","mv_cha","D",08,0,0,"G","                                                            ","mv_par10       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"11","Vencimento de                 ","                              ","                              ","mv_chb","D",08,0,0,"G","                                                            ","mv_par11       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"12","Vencimento Ate                ","                              ","                              ","mv_chc","D",08,0,0,"G","                                                            ","mv_par12       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"13","Qtde dias                     ","                              ","                              ","mv_chd","C",01,0,1,"C","                                                            ","mv_par13       ","Emissao        ","               ","               ","                                                            ","               ","Vencimento     ","               ","               ","                                                            ","               ","Ambos          ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"14","Nome Cliente / Fornecedor     ","                              ","                              ","mv_che","C",01,0,1,"C","                                                            ","mv_par14       ","Razao Social   ","               ","               ","                                                            ","               ","Nome Fantasia  ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"15","Selecao de Tipos a imprimir   ","                              ","                              ","mv_chf","C",10,0,0,"G","U_F_TPT                                                     ","mv_par15       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"16","Totaliza por Cliente/Fornece. ","                              ","                              ","mv_chg","C",01,0,1,"C","                                                            ","mv_par16       ","Sim            ","               ","               ","                                                            ","               ","Nao            ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"17","Salta Pag.ao trocar Cli/Forn. ","                              ","                              ","mv_chh","C",01,0,1,"C","                                                            ","mv_par17       ","Sim            ","               ","               ","                                                            ","               ","Nao            ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"18","Tipo do Relatorio             ","                              ","                              ","mv_chi","C",01,0,1,"C","                                                            ","mv_par18       ","Analitico      ","               ","               ","                                                            ","               ","Sintetico      ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"19","Fornecedor de                 ","                              ","                              ","mv_chj","C",06,0,0,"G","                                                            ","mv_par19       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA2","S","   ","          "})
Aadd(_aRegs,{_cPerg,"20","Loja de                       ","                              ","                              ","mv_chk","C",02,0,0,"G","                                                            ","mv_par20       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"21","Fornecedor Ate                ","                              ","                              ","mv_chl","C",06,0,0,"G","                                                            ","mv_par21       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA2","S","   ","          "})
Aadd(_aRegs,{_cPerg,"22","Loja Ate                      ","                              ","                              ","mv_chm","C",02,0,0,"G","                                                            ","mv_par22       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"23","Emitir Tempo Medio            ","                              ","                              ","mv_chn","C",01,0,1,"C","                                                            ","mv_par23       ","Recebimentos   ","               ","               ","                                                            ","               ","Pagamentos     ","               ","               ","                                                            ","               ","Ambos          ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"24","Separar Receber de Pagar      ","                              ","                              ","mv_cho","C",01,0,1,"C","                                                            ","mv_par24       ","Sim            ","               ","               ","                                                            ","               ","Nao            ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"25","Data Pagamento de             ","                              ","                              ","mv_chp","D",08,0,0,"G","                                                            ","mv_par25       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"26","Data Pagamento Ate            ","                              ","                              ","mv_chq","D",08,0,0,"G","                                                            ","mv_par26       ","               ","               ","               ","DtoC(DDATABASE)                                             ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"27","Do Banco                      ","                              ","                              ","mv_chr","C",03,0,0,"G","                                                            ","mv_par27       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA6","S","   ","          "})
Aadd(_aRegs,{_cPerg,"28","Da Agencia                    ","                              ","                              ","mv_chs","C",05,0,0,"G","                                                            ","mv_par28       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"29","Da Conta                      ","                              ","                              ","mv_cht","C",10,0,0,"G","                                                            ","mv_par29       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"30","At้ o Banco                   ","                              ","                              ","mv_chu","C",03,0,0,"G","                                                            ","mv_par30       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SA6","S","   ","          "})
Aadd(_aRegs,{_cPerg,"31","At้ a Agencia                 ","                              ","                              ","mv_chv","C",05,0,0,"G","                                                            ","mv_par31       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"32","At้ a Conta                   ","                              ","                              ","mv_chx","C",10,0,0,"G","                                                            ","mv_par32       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})

For _nI:=1 to Len(_aRegs)
    if ! dbSeek(_cPerg+_aRegs[_nI,2])
       RecLock('SX1',.t.)
       For _nJ:=1 to FCount()
           if _nJ <= Len(_aRegs[_nI])
              FieldPut(_nJ,_aRegs[_nI,_nJ])
           endif
       Next _nJ
       MsUnlock()
    endif
Next _nI

RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRF501  บAutor  ณPaulo Schwind        บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Selecionar os Tipos de Titulos a serem impres- บฑฑ
ฑฑบ          ณ sos.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function f_TPT(l1Elem,lTipoRet)

Local cArq      
Local MvPar
Local oDlg1
Local nOpca 	:=	0       
Local aStru   	:=	{}
Local aCampos	:= {}
Local cRetorna := .f.
Local lInverte := .t.    
Local _sAlias	:=	Alias()

Private oMark
Private cMarca := GetMark()

MvPar	:=	&(Alltrim(ReadVar()))		 
mvRet	:=	Alltrim(ReadVar())			 

aAdd(aStru,{"TRB_COD" ,"C",07,0})
aAdd(aStru,{"TRB_DESC","C",30,0})
aAdd(aStru,{"TRB_OK"  ,"C",02,0})

cArq := CriaTrab(aStru,.t.)
dbUseArea(.t.,,cArq,"TRB",.t.)
cInd := CriaTrab(NIL,.f.)

dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"05")
While SX5->X5_TABELA = "05" .and. !Eof()
	DBSELECTAREA("TRB")
	RECLOCK("TRB",.t.)
		TRB->TRB_OK   := '  '
		TRB->TRB_COD  := Alltrim(SX5->X5_CHAVE) 
		TRB->TRB_DESC := SX5->X5_DESCRI 
	MSUNLOCK()
	SX5->(DbSkip())
enddo		

dbSelectArea("TRB")

TRB->( dbGoTop() )

aAdd( aCampos, { 'TRB_OK'	,, '  '		          , '@S02' } )
aAdd( aCampos, { 'TRB_COD'	,, 'Codigo'		       , '@S07' } )
aAdd( aCampos, { 'TRB_DESC',, 'Tipo do Titulo'	 , '@S30' } )

Define MsDialog oDlg1 Title "Selecione os Tipos de Titulos " From 9,0 To 28,80 Of oMainWnd

oMark:=MsSelect():New("TRB","TRB_OK",,aCampos,@lInverte,@cMarca,{12,1,143,315})

      oMark:oBrowse:lColDrag := .t.
      oMark:oBrowse:lhasMark = .t.
      oMark:oBrowse:lCanAllmark := .t.

oMark:oBrowse:Refresh()

Activate MsDialog oDlg1 Center On Init RTCR501Bar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})

cRetorna	:=	''
cVirg		:=	''

if nOpca == 1			
	TRB->( dbGoTop() )
	do while !TRB->(eof())
		if TRB->TRB_OK == cMarca
			cRetorna += cVirg + "'" + TRB->TRB_COD + "'"
			cVirg		:= ','
		endif
		TRB->(dbskip())
	enddo
endif

TRB->( dbCloseArea() )

fErase(cArq+OrdBagExt())

cTipos 	:= cRetorna	
&MvRet 	:=	'Selecao'

dbSelectArea(_sAlias)

Return

/*****************************************************************************/

Static Function RTCR501Bar(oDlg,bOk,bCancel)

Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.

Define BUTTONBAR oBar Size 25,25 3D Top Of oDlg
//Define BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
oBar:nGroups += 6
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.t.)) TOOLTIP "Cancelar"

SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}

Return Nil

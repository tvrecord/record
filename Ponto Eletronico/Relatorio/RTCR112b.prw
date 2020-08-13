#include "font.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*ºPrograma  ³RTCR112b  º Autor ³ Edmilson Dias Santos  º Data ³  24/05/07º±±
±±ºPrograma  ³          º Autor ³ Claudio Ferreira      º Data ³  01/06/07º±±
±±ºDescricao ³Relatorio de Analise de Horas a Compensar até 90 dias.      º±±
±±ºUso       ³ Clientes Microsiga  -  RECORD                              º*/

User Function RTCR112b()

Local aOrd         := {}
Local aPergs       := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Apuracao Mensal de Banco de Horas - Base Anterior"
Local cPict        := ""
Local Titulo       := "APURACAO MENSAL DE BANCO DE HORAS"
Local Cabec1       := "MATRICULA NOME DO FUNCIONARIO         PERIODO A COMPENSAR     TOTAL DO SALDO"
Local Cabec2       := " "
Local imprime      := .t.

Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTCR112"
PRIVATE nLin       := 0
Private cString
Private CbTxt      := ""
Private lEnd       := .f.
Private limite     := 220
Private Tamanho    := "M"
Private nomeprog   := "RTCR112"
Private aReturn    := {"Zebrado",01,"Administracao",01,02,01,"",01}
Private nLastKey   := 0
Private cString    := "SZA"
Private cPerg      := "RTR112    "

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

RptStatus( { || RunReport(Cabec1,Cabec2,Titulo) } , Titulo )

Return

/*************************************************************************/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local cTmp
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

cQuery 	:= " SELECT ZA_FILIAL, ZA_COMPET, ZA_MAT, ZA_CC, ZA_DATA, ZA_NOME, ZA_VALOR "
cQuery 	+=	" FROM " + RetSqlName("SZA") 
cQuery 	+= " WHERE ZA_FILIAL   = '" + xFilial("SZA") + "' AND "
cQuery 	+= "	 	  ZA_COMPET   = '" + mv_par01			+ "' AND "
cQuery 	+= "	 	  ZA_MAT     >= '" + mv_par02			+ "' AND "
cQuery 	+= "	 	  ZA_MAT     <= '" + mv_par03			+ "' AND "
cQuery 	+= "	 	  ZA_CC      >= '" + mv_par04			+ "' AND "
cQuery 	+= "	 	  ZA_CC      <= '" + mv_par05			+ "' AND "
cQuery 	+= "	 	  D_E_L_E_T_  = ' ' "
cQuery 	+= "	 	  GROUP BY ZA_FILIAL, ZA_COMPET, ZA_MAT, ZA_CC, ZA_DATA, ZA_NOME, ZA_VALOR "
cQuery 	+= "	 	  HAVING COUNT(*) >= 1 "
cQuery 	+=	" ORDER BY ZA_FILIAL,ZA_CC,ZA_MAT,ZA_DATA"
cQuery	:=	ChangeQuery(cQuery)

If Select("MAP") > 0
   MAP->(DbCloseArea())
Endif	

TcQuery cQuery New Alias "MAP"

dbSelectArea("MAP")

Count to nCount 

SetRegua(nCount)

dbGoTop()

Do While !MAP->(Eof())
	
	nPag			:=	0 		
	cCustoImp 	:= .t.
	nLin			:=	9000
	pCcusto   	:=	MAP->ZA_CC
		
	Do While !MAP->(Eof()) .and. MAP->ZA_CC == pCcusto
		
		nSaldo	:=	0 	
		MatImp 	:= .t.		
		pMat   	:=	MAP->ZA_MAT
		_cNome	:=	MAP->ZA_NOME

		Do While !MAP->(Eof()) .and. MAP->ZA_CC == pCcusto .and. MAP->ZA_MAT == pMat

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
					oPrn:Say(0020,0000," ",oFont,100) 
					nPag ++
				endif     
				
				oPrn:Line(nLin,020,nLin,2350)
				nLin += 0025
				oPrn:Say( nLin, 0020, SM0->M0_NOMECOM, oFont10)
				nLin += 0050
				oPrn:Say( nLin, 0020,titulo,oFont10,100)
				oPrn:Say( nLin, 2100,"Pag: " + Str(nPag,3),oFont10,100)
				nLin += 0050
				oPrn:Say(nLin, 0020,Cabec1 + "    Competência: " + Substr(mv_par01,1,2) + "/" + Substr(mv_par01,3,4),oFont10,100)
				nLin += 0050
				oPrn:Line (nLin,020,nLin,2350)
				nLin += 0150
				cCustoImp 	:= .t.
				MatImp 		:= .t.
			endif
			
			if cCustoImp
				oPrn:Say( nLin, 0020,MAP->ZA_CC+SPACE(5)+POSICIONE("CTT",1,xFilial("CTT")+MAP->ZA_CC,"CTT_DESC01"),oFont16,100 )
				nLin+= 0120
				CcustoImp := .f.
			endif
			
			if MatImp
				oPrn:Say( nLin, 0020, MAP->ZA_MAT + "        " + MAP->ZA_NOME,oFont10,100 )
				nLin+= 0050
				MatImp := .f.
			endif
			
			//cTmp	:=	Space(13) + "HORAS COMPENSAR ATE  " + DtoC(StoD(MAP->ZA_DATA)) + Space(10) // 28/07/16 Rafael colocada a nova mensagem a pedido da Sra Elenn e Giselly
				IF ALLTRIM(SUBSTR(MAP->ZA_COMPET,3,4)) + ALLTRIM(SUBSTR(MAP->ZA_COMPET,1,2))  <=  "201805"
			cTmp	:=	Space(05) + "HORAS COMPENSAR ATE " + DTOC(LastDate(MonthSub(STOD(MAP->ZA_DATA),1)))+ "  PAGAMENTO " +DTOC(STOD(MAP->ZA_DATA)) + Space(05)
			ELSE
			cTmp	:=	Space(05) + "HORAS COMPENSAR ATE " + DTOC(LastDate(STOD(MAP->ZA_DATA)))+ "  PAGAMENTO COMPETÊNCIA " +DTOC(STOD(MAP->ZA_DATA)) + Space(05)		
			ENDIF
			
			cTmp	+=	Transform(MAP->ZA_VALOR,"99999999.99") + "      ______________________"

			oPrn:Say( nLin, 0500, cTmp , oFont10 , 100 )

			nLin += 0100
			
         MAP->(dbskip())
		enddo
	enddo

	nLin+= 150
	oPrn:Say( nLin, 1400,"_________________________________",oFont10,100 )
	nLin+= 050
	oPrn:Say( nLin, 1400,"             Assinatura do Responsável    ",oFont10,100 )
	nLin+= 0100
enddo

Set Device to Screen

If lEnc
	oPrn:Preview()
	Ms_Flush()
EndIf

MAP->(DbCloseArea())

Return

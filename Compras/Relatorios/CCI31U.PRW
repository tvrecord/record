#INCLUDE "rwmake.ch"  
#include "font.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/*/
╠╠╨Programa  ЁCCI301    ╨ Autor Ё Edmilson Dias Santos  ╨ Data Ё  12/07/01   ╨╠╠
╠╠╨Descricao Ё Relatorio de Analise de Cotacao - TOMADA DE PRECOS         ╨╠╠
╠╠╨Uso       Ё Clientes Microsiga                                         ╨╠╠
/*/

User Function CCI31U()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Local aOrd         := {}
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "MAPA COMPARATIVO DE PRECOS"
Local cPict        := ""
Local titulo       := "MAPA DE COTAгцO"
Local Cabec1       := " "
Local Cabec2       := " "
Local imprime      := .T.
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CCI301" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE nLin       := 465
Private cString
Private CbTxt      := ""
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private limite     := 220
Private Tamanho    := "G"
Private nomeprog   := "CCI301" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cString    := "SC8"
Private cPerg      := "MTR210" //"CCI301"

dbSelectArea("SC8")
dbSetOrder(1)


Pergunte("MTR210",.F.) //"CCI301"

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario...                           Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)
Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁRUNREPORT ╨ Autor Ё AP5 IDE            ╨ Data Ё  12/07/01   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ╨╠╠
╠╠╨          Ё monta a janela com a regua de processamento.               ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Programa principal                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo)

Local nOrdem,nRegAtual
PRIVATE aProdutos,aComplemen,aFornCab,aFornece,aPrecos,aSubTotal,aFrete,aDesconto,aIPI,aOrcado
PRIVATE aPrazo,aCondPgto,i,J,cDescri,aMinimos,ij,pMinimo,porcado
private pCotacao,pData
Private oFont, cCode, oPrn
Private lPrimPag :=.t.        
Private lEnc    := .f.
Private  nPag  := 1
Private cCGCPict, cCepPict

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefinir as pictures                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,08,,.t.,,,,,.f. )
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,14,,.t.,,,,,.f. )
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )
oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )

dbSelectArea("SC8")
dbSetOrder(1)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё SETREGUA -> Indica quantos registros serao processados para a regua Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetRegua(RecCount())
pOrcado := 0
SC8->(DBSEEK(xFilial("SC8")+MV_PAR01,.T. ) )
While !SC8->(EOF()).AND.SC8->C8_NUM <= MV_PAR02

   pCotacao := SC8->C8_NUM
   pData    := SC8->C8_EMISSAO

   // Monta a Matriz de Fornecedores participantes
   nRegAtual  := RECNO()
   aProdutos  := {}
   aComplemen := {}
   aFornece   := {}
   aPrecos    := {}
   aMinimos   := {}
   aFrete     := {}
   aDesconto  := {}
   aIPI       := {0,0,0,0,0}
   aPrazo     := {0,0,0,0,0}
   aCondPgto  := {"","","","",""}
   aSubTotal  := {0,0,0,0,0} 
   aFrete     := {0,0,0,0,0} 
   aDesconto  := {0,0,0,0,0}   
   aFornCab  := {}

   While !SC8->(EOF()) .AND. SC8->C8_NUM == pCotacao 

      // Cria Matriz com os Produtos
      DBSELECTAREA("SB1")
      DBSETORDER(1)
      SB1->( DBSEEK(xFilial("SB1")+SC8->C8_PRODUTO,.T.) )

      DBSELECTAREA("SC1")
      DBSETORDER(2)
      SC1->( DBSEEK(xFilial("SC1")+SC8->C8_PRODUTO+SC8->C8_NUMSC+SC8->C8_ITEMSC,.T.) )

      DBSELECTAREA("SB5")
      DBSETORDER(1)
      If DBSEEK(xFilial("SB5")+SC8->C8_PRODUTO,.T.) 
	     cDescri := Alltrim(SB5->B5_CEME)
	  Else
	     cDescri := Alltrim(SC1->C1_DESCRI) + IIF(!EMPTY(SC1->C1_OBS)," Obs.: "+SC1->C1_OBS,SPACE(1))
	  Endif	     
      IF LEFT(SB1->B1_DESC,AT(SPACE(1),SB1->B1_DESC)) <> LEFT(cDescri,AT(SPACE(1),cDescri))
         cDescri := LEFT(ALLTRIM(SB1->B1_DESC),AT(SPACE(1),ALLTRIM(SB1->B1_DESC)))+ " " + cDescri
      ENDIF

      I := ASCAN(aProdutos,SC8->C8_PRODUTO+ALLTRIM(cDescri))
      IF I = 0
         AADD(aProdutos ,SC8->C8_PRODUTO+ALLTRIM(cDescri))
         AADD(aComplemen,{IIF(SC8->C8_QTSEGUM > 0,SC8->C8_QTSEGUM,SC8->C8_QUANT),IIF(SC8->C8_QTSEGUM > 0,SC8->C8_SEGUM,SC8->C8_UM)})
         AADD(aPrecos,{0,0,0,0,0})
         J := LEN(aProdutos)
      ELSE
         J := I
      ENDIF

      // Verifica a Coluna do Preco do Fornecedor
      i :=  ASCAN(aFornCab,SC8->C8_FORNECE+SC8->C8_LOJA)

      IF i == 0
         AADD(aFornCab ,SC8->C8_FORNECE+SC8->C8_LOJA)
         IF LEN(aFornCab) <= 5
            aPrecos[J][LEN(aFornCab)] := IIF(SC8->C8_QTSEGUM > 0,SC8->C8_PRECO,SC8->C8_PRECO)
            aFrete[LEN(aFornCab)]     := SC8->C8_TOTFRE
            aIPI[LEN(aFornCab)]       := SC8->C8_VALIPI
            aDesconto[LEN(aFornCab)]  := SC8->C8_VLDESC
            aPrazo[LEN(aFornCab)]     := SC8->C8_PRAZO
            dbSelectArea("SE4")
            dbSetOrder(1)
            dbSeek(xFilial()+SC8->C8_COND)
            dbSelectArea("SC8")
            aCondPgto[LEN(aFornCab)]  := SubStr(SE4->E4_DESCRI,1,15)		
         ENDIF
      ELSE
         IF I <= 5
            aPrecos[J][I]    := IIF(SC8->C8_QTSEGUM > 0,SC8->C8_PRECO,SC8->C8_PRECO)
            aFrete[i]        := SC8->C8_TOTFRE
            aPrazo[i]        := SC8->C8_PRAZO
            aIPI[I]          += SC8->C8_VALIPI
            aDesconto[I]     += SC8->C8_VLDESC

            dbSelectArea("SE4")
            dbSetOrder(1)
            dbSeek(xFilial()+SC8->C8_COND)         
            aCondPgto[i] := SubStr(SE4->E4_DESCRI,1,15)		
         ENDIF
      ENDIF
      DBSELECTAREA("SC8")
      SC8->(dbSkip())
      
      IncRegua()
   
   ENDDO

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Impressao do cabecalho do relatorio. . .                            Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   ImprCabec()
   
   aSubTotal  := {0,0,0,0,0,0}
   /*
   I := 1
   While I <= LEN(aProdutos)
 	  @nLin,000 PSAY STRZERO(I,2)
      @nLin,002 PSAY "|"
      @nLin,003 PSAY LEFT(aProdutos[i],8)
      @nLin,011 PSAY "|"
      @nLin,012 PSAY aComplemen[i][1]     PICTURE "@E 9999999.99"
      @nLin,022 PSAY "|"
      @nLin,023 PSAY aComplemen[i][2]
      @nLin,025 PSAY "|"
      @nLin,026 PSAY SUBSTR(aProdutos[i],16,48)

      nJ := (Int(Len( ALLTRIM(aProdutos[i]))-15) /48  )
	  nI := 1
	  While nI < nJ 
         IF ni =1
	        @nLin,074 PSAY "|                 |                 |                 |                 |                 |            |            |            |"
            nlin++
         ENDIF
	     @nLin,000 PSAY "  |        |          |  |"
    	 @nLin,026 PSAY SUBSTR(aProdutos[i],16 + (nI * 48 + 1),48)
    	 If nI < nJ - 1
		    @nLin,074 PSAY "|                 |                 |                 |                 |                 |            |            |            |"
    	  	nLin++           
    	 Endif
 		 nI++		 
	  EndDo
	  @nLin,074 PSAY "|"
      @nLin,075 PSAY aPrecos[i][1]       PICTURE "@EZ 999,999,999.99"
      @nLin,092 PSAY "|"
      @nLin,093 PSAY aPrecos[i][2]       PICTURE "@EZ 999,999,999.99"
      @nLin,110 PSAY "|"
      @nLin,111 PSAY aPrecos[i][3]       PICTURE "@EZ 999,999,999.99"
      @nLin,128 PSAY "|"
      @nLin,129 PSAY aPrecos[i][4]       PICTURE "@EZ 999,999,999.99"
      @nLin,146 PSAY "|"
      @nLin,147 PSAY aPrecos[i][5]       PICTURE "@EZ 999,999,999.99"
      @nLin,164 PSAY "|"

      // Verifica o menor preco
      ij := 1
      pMinimo := 0
      DO WHILE ij <= 5
         IF (aPrecos[i][ij] < pMinimo .AND. aPrecos[i][ij] > 0) .OR. pMinimo = 0
            pMinimo := aPrecos[i][ij]
         ENDIF
         ij := ij + 1
      ENDDO
      @nLin,165 PSAY pMinimo           PICTURE "@EZ 9999,999.99"
      @nLin,177 PSAY "|"

      // Pega o valor do Orcamento
      DBSELECTAREA("SB1")
      DBSETORDER(1)
      SB1->( DBSEEK(xFilial("SB1")+LEFT(aProdutos[i],15),.F.) )
      pOrcado := SB1->B1_CUSTD
      
      //Valor da ultima Compra
      @nLin,178 PSAY SB1->B1_UPRC         PICTURE "@EZ 9999,999.99"
      @nLin,190 PSAY "|"

      //Data da ultima Compra
      //If cNivel > 8
       @nLin,191 PSAY SB1->B1_UCOM     //PICTURE "@EZ 9999,999.99"
      //ENDIF

      @nLin,203 PSAY "|"

      nLin := nLin + 1
      aSubTotal[1] := aSubTotal[1] + (aPrecos[i][1] * aComplemen[i][1])
      aSubTotal[2] := aSubTotal[2] + (aPrecos[i][2] * aComplemen[i][1])
      aSubTotal[3] := aSubTotal[3] + (aPrecos[i][3] * aComplemen[i][1])
      aSubTotal[4] := aSubTotal[4] + (aPrecos[i][4] * aComplemen[i][1])
      aSubTotal[5] := aSubTotal[5] + (aPrecos[i][5] * aComplemen[i][1])
      aSubTotal[6] := aSubTotal[6] + (pMinimo * aComplemen[i][1])

      I := I + 1                
      IF NLIN = 54
         @nLin,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
         NLIN := 2
         ImprCabec()
      ENDIF
   ENDDO

   ImprRodape()
*/   
EndDo

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza a execucao do relatorio...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
*/

If lEnc
	oPrn:Preview()
	MS_FLUSH()
EndIf

//MS_FLUSH()

Return


STATIC FUNCTION ImprCabec()
             
If !lPrimPag
	oPrn:EndPage()
	oPrn:StartPage()
	nPag ++
Else
	lPrimPag := .f.
	lEnc     := .t.
	oPrn  := TMSPrinter():New()
	oPrn:Setup()
EndIF

oPrn:Say( 0020, 0020, " ",oFont,100 ) // startando a impressora

//Cabecalho (Enderecos da Empresa e Fornecedor)
oPrn:Box( 0020, 0000, 0320,3300)
oPrn:Box( 0020, 2550, 0320,3300) //3000

oPrn:Box( 0320, 0000, 0400,3300)
oPrn:Box( 0400, 0000, 0480,3300)
oPrn:Box( 0480, 0000, 2300,3300)

oPrn:Box( 0320, 1300, 2300,3300)
oPrn:Box( 0320, 2300, 2300,3300)

oPrn:SayBitmap( 0100,0040,"logo.bmp",0360,0200 )

oPrn:Say( 0080, 0020,RTRIM(SM0->M0_NOMECOM),oFont9,100 )
oPrn:Say( 0080, 2650,"N╨ COTAгцO: ",oFont9,100 )
oPrn:Say( 0080, 3010,pCotacao,oFont2,100 )
oPrn:Say( 0140, 0020,"SRTVS SUL QD 701 BL. H LT 10R 1╨ E 2╨ ANDAR",oFont9,100 )
oPrn:Say( 0160, 1500,"MAPA DE COTAгцO",oFont1,100 )
oPrn:Say( 0200, 0020,"CNPJ: "+TRANSFORM(RTRIM(SM0->M0_CGC),"@R 99.999.999/9999-99"),oFont9,100 )
oPrn:Say( 0260, 0020,"INSCRIгцO ESTADUAL: "+TRANSFORM(SM0->M0_INSC,"@R 99.999.999/999/99"),oFont9,100 )
oPrn:Say( 0260, 2700,"EMISSAO: ",oFont9,100 )
oPrn:Say( 0260, 3000,DTOC(Date()),oFont9,100 )

oPrn:Say( 0330, 0020,"CONTROLE DE ESTOQUE ",oFont9,100 )
oPrn:Say( 0330, 0580,"SIM  |     |        NцO   |     | ",oFont9,100 )

oPrn:Say( 0330, 1450,"TEL.",oFont3,100 )
oPrn:Say( 0330, 2050,"TEL.",oFont3,100 )
oPrn:Say( 0330, 2650,"TEL.",oFont3,100 )

oPrn:Say( 0420, 0020,"IMOBILIZADO ",oFont9,100 )
oPrn:Say( 0420, 0580,"SIM  |     |        NцO   |     | ",oFont9,100 )


DBSELECTAREA("SA2")
DBSETORDER(1)

@ 05,000 PSAY "I |        |          |  |                                        |Fornec.|"
IF LEN(aFornCab) >= 1
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
  @ 05,075 PSAY LEFT(SA2->A2_NOME,17)
ENDIF
@ 05,092 PSAY "|"
IF LEN(aFornCab) >= 2
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
  @ 05,093 PSAY LEFT(SA2->A2_NOME,17)
ENDIF
@ 05,110 PSAY "|"
IF LEN(aFornCab) >= 3
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
  @ 05,111 PSAY LEFT(SA2->A2_NOME,17)
ENDIF
@ 05,128 PSAY "|"
IF LEN(aFornCab) >= 4
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[4] ))
  @ 05,129 PSAY LEFT(SA2->A2_NOME,17)
ENDIF

@ 05,146 PSAY "|"
IF LEN(aFornCab) >= 5
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[5] ))
  @ 05,147 PSAY LEFT(SA2->A2_NOME,17)
ENDIF

@ 05,164 PSAY "|            |            |            |"

@ 06,000 PSAY "t |        |          |  |                                        |"
IF LEN(aFornCab) >= 1
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
  @ 06,075 PSAY LEFT(SA2->A2_CONTATO,17)
ENDIF
@ 06,092 PSAY "|"
IF LEN(aFornCab) >= 2
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
  @ 06,093 PSAY LEFT(SA2->A2_CONTATO,17)
ENDIF
@ 06,110 PSAY "|"
IF LEN(aFornCab) >= 3
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
  @ 06,111 PSAY LEFT(SA2->A2_CONTATO,17)
ENDIF
@ 06,128 PSAY "|"
IF LEN(aFornCab) >= 4
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[4] ))
  @ 06,129 PSAY LEFT(SA2->A2_CONTATO,17)
ENDIF

@ 06,146 PSAY "|"
IF LEN(aFornCab) >= 5
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[5] ))
  @ 06,147 PSAY LEFT(SA2->A2_CONTATO,17)
ENDIF
			 //          1         2         3         4         5         6         7         8         9        10        11        12        13
    		 //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
@ 06,164 PSAY "|            |            |            |"
@ 07,000 PSAY "e | Codigo |Quant.    |UN|Descricao                               |Tel.   |"
IF LEN(aFornCab) >= 1
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
  @ 07,075 PSAY LEFT(SA2->A2_TEL,17)
ENDIF
@ 07,092 PSAY "|"
IF LEN(aFornCab) >= 2
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
  @ 07,093 PSAY LEFT(SA2->A2_TEL,17)
ENDIF
@ 07,110 PSAY "|"
IF LEN(aFornCab) >= 3
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
  @ 07,111 PSAY LEFT(SA2->A2_TEL,17)
ENDIF
@ 07,128 PSAY "|"
IF LEN(aFornCab) >= 4
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[4] ))
  @ 07,129 PSAY LEFT(SA2->A2_TEL,17)
ENDIF

@ 07,146 PSAY "|"
IF LEN(aFornCab) >= 5
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[5] ))
  @ 07,147 PSAY LEFT(SA2->A2_TEL,17)
ENDIF

@ 07,164 PSAY "|   Minimo   | Val.ultima | Dat.ultima |"

@ 08,000 PSAY "m |        |          |  |                                        |Fax    |"
IF LEN(aFornCab) >= 1
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
  @ 08,075 PSAY LEFT(SA2->A2_FAX,17)
ENDIF
@ 08,092 PSAY "|"
IF LEN(aFornCab) >= 2
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
  @ 08,093 PSAY LEFT(SA2->A2_FAX,17)
ENDIF
@ 08,110 PSAY "|"
IF LEN(aFornCab) >= 3
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
  @ 08,111 PSAY LEFT(SA2->A2_FAX,17)
ENDIF
@ 08,128 PSAY "|"
IF LEN(aFornCab) >= 4
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[4] ))
  @ 08,129 PSAY LEFT(SA2->A2_FAX,17)
ENDIF

@ 08,146 PSAY "|"
IF LEN(aFornCab) >= 5
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[5] ))
  @ 08,147 PSAY LEFT(SA2->A2_FAX,17)
ENDIF
@ 08,164 PSAY "|            |  Compra    |  Compra    |"

@ 09,000 PSAY "  |        |          |  |                                        |E-Mail |"
IF LEN(aFornCab) >= 1
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[1] ))
  @ 09,075 PSAY LEFT(SA2->A2_EMAIL,17)
ENDIF
@ 09,092 PSAY "|"
IF LEN(aFornCab) >= 2
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[2] ))
  @ 09,093 PSAY LEFT(SA2->A2_EMAIL,17)
ENDIF
@ 09,110 PSAY "|"
IF LEN(aFornCab) >= 3
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[3] ))
  @ 09,111 PSAY LEFT(SA2->A2_EMAIL,17)
ENDIF
@ 09,128 PSAY "|"
IF LEN(aFornCab) >= 4
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[4] ))
  @ 09,129 PSAY LEFT(SA2->A2_EMAIL,17)
ENDIF

@ 09,146 PSAY "|"
IF LEN(aFornCab) >= 5
  SA2->(DBSEEK(xFilial("SA2")+aFornCab[5] ))
  @ 09,147 PSAY LEFT(SA2->A2_EMAIL,17)
ENDIF

@ 09,164 PSAY "|            |            |            |"
													  
@ 10,000 PSAY "--|--------|----------|--|------------------------------------------------|-----------------|-----------------|-----------------|-----------------|-----------------|------------|------------|------------|"

nLin := 11
RETURN NIL

STATIC FUNCTION ImprRodape()
 @ nLin,000 PSAY "--------------------------------------------------------------------------|-----------------|-----------------|-----------------|-----------------|-----------------|------------|------------|------------|"
 nLin := nLin + 1
 @nLin,010 PSAY "SUB-TOTAL.............:"
 @nLin,074 PSAY "|"
 @nLin,075 PSAY aSubTotal[1]       PICTURE "@EZ 999,999,999.99"
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aSubTotal[2]       PICTURE "@EZ 999,999,999.99"
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aSubTotal[3]       PICTURE "@EZ 999,999,999.99"
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aSubTotal[4]       PICTURE "@EZ 999,999,999.99"
 @nLin,146 PSAY "|"
 @nLin,147 PSAY aSubTotal[5]       PICTURE "@EZ 999,999,999.99"
 @nLin,164 PSAY "|"
 @nLin,165 PSAY aSubTotal[6]       PICTURE "@EZ 9999,999.99"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"
 nLin := nLin + 1
 @nLin,010 PSAY "FRETE.................:"
 @nLin,074 PSAY "|"
 @nLin,075 PSAY aFrete[1]       PICTURE "@EZ 999,999,999.99"
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aFrete[2]       PICTURE "@EZ 999,999,999.99"
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aFrete[3]       PICTURE "@EZ 999,999,999.99"
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aFrete[4]       PICTURE "@EZ 999,999,999.99"
 @nLin,146 PSAY "|"
 @nLin,147 PSAY aFrete[5]       PICTURE "@EZ 999,999,999.99"
 @nLin,164 PSAY "|"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"
 nLin := nLin + 1
 @nLin,010 PSAY "DESCONTO..............:"
 @nLin,074 PSAY "|"
 @nLin,075 PSAY aDesconto[1]       PICTURE "@EZ 999,999,999.99"
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aDesconto[2]       PICTURE "@EZ 999,999,999.99"
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aDesconto[3]       PICTURE "@EZ 999,999,999.99"
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aDesconto[4]       PICTURE "@EZ 999,999,999.99"
 @nLin,146 PSAY "|"
 @nLin,147 PSAY aDesconto[5]       PICTURE "@EZ 999,999,999.99"
 @nLin,164 PSAY "|"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"
 nLin := nLin + 1
 @nLin,010 PSAY "IPI...................:"
 @nLin,074 PSAY "|"
 @nLin,075 PSAY aIPI[1]       PICTURE "@EZ 999,999,999.99"
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aIPI[2]       PICTURE "@EZ 999,999,999.99"
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aIPI[3]       PICTURE "@EZ 999,999,999.99"
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aIPI[4]       PICTURE "@EZ 999,999,999.99"
 @nLin,146 PSAY "|"
 @nLin,147 PSAY aIPI[5]       PICTURE "@EZ 999,999,999.99"
 @nLin,164 PSAY "|"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"
 nLin := nLin + 1
 @nLin,010 PSAY "PRAZO DE ENTREGA......:"
 @nLin,074 PSAY "|"
 @nLin,076 PSAY IIF(aPrazo[1] > 1,STRZERO(aPrazo[1],2) + " DIAS","IMEDIATO")
 @nLin,092 PSAY "|"
 @nLin,094 PSAY IIF(aPrazo[2] > 1,STRZERO(aPrazo[2],2) + " DIAS","IMEDIATO")
 @nLin,110 PSAY "|"
 @nLin,112 PSAY IIF(aPrazo[3] > 1,STRZERO(aPrazo[3],2) + " DIAS","IMEDIATO")
 @nLin,128 PSAY "|"
 @nLin,130 PSAY IIF(aPrazo[4] > 1,STRZERO(aPrazo[4],2) + " DIAS","IMEDIATO")
 @nLin,146 PSAY "|"
 @nLin,148 PSAY IIF(aPrazo[5] > 1,STRZERO(aPrazo[5],2) + " DIAS","IMEDIATO")
 @nLin,164 PSAY "|"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"
 nLin := nLin + 1
 @nLin,010 PSAY "COND. PAGAMENTO.......:"
 @nLin,074 PSAY "|"                      
 @nLin,075 PSAY aCondPgto[1]     
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aCondPgto[2]     
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aCondPgto[3]     
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aCondPgto[4]     
 @nLin,146 PSAY "|"
 @nLin,148 PSAY aCondPgto[5]
 @nLin,164 PSAY "|"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"

 nLin := nLin + 1

 @ nLin,000 PSAY "--------------------------------------------------------------------------|-----------------|-----------------|-----------------|-----------------|-----------------|------------|------------|------------|"
 nLin := nLin + 1
 @ nLin,003 PSAY "T  O  T  A  L ..............:"
 @nLin,074 PSAY "|"
 @nLin,075 PSAY aSubTotal[1]    PICTURE "@EZ 999,999,999.99"
 @nLin,092 PSAY "|"
 @nLin,093 PSAY aSubTotal[2]    PICTURE "@EZ 999,999,999.99"
 @nLin,110 PSAY "|"
 @nLin,111 PSAY aSubTotal[3]    PICTURE "@EZ 999,999,999.99"
 @nLin,128 PSAY "|"
 @nLin,129 PSAY aSubTotal[4]    PICTURE "@EZ 999,999,999.99"
 @nLin,146 PSAY "|"
 @nLin,147 PSAY aSubTotal[5]    PICTURE "@EZ 999,999,999.99"
 @nLin,164 PSAY "|"
 @nLin,165 PSAY aSubTotal[6]       PICTURE "@EZ 9999,999.99"
 @nLin,177 PSAY "|"
 @nLin,190 PSAY "|"
 @nLin,203 PSAY "|"


 nLin := nLin + 1
 @ nLin,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
 nLin := nLin + 2

 @nLin,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
 nLin := nLin + 1
 @ nLin,000 PSAY "|                                                |                                                 |Observacao:                                                                                            |"
 nLin := nLin + 1
 @ nLin,000 PSAY "|                                                |                                                 |                                                                                                       |"
 nLin := nLin + 1
 @ nLin,000 PSAY "|  -------------------------------------------   |   -------------------------------------------   |                                                                                                       |"
 nLin := nLin + 1
 @ nLin,000 PSAY "|                  D I R E T O R                 |               C O M P R A D O R                 |                                                                                                       |"
 nLin := nLin + 1
 @ nLin,000 PSAY "|                                                |                                                 |                                                                                                       |"
 nLin := nLin + 1
 @ nLin,000 PSAY "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
 nLin := nLin + 1
 @ nLin,000 PSAY ""

RETURN NIL

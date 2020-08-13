#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UNFINR05 º Autor ³ Leandro Camara       Data ³  08/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao dos saldos bancarios e contas a pagar por agenciaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELCC()

Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Contas a Pagar - Por Conta Corrente"
Local cPict      := ""
Local titulo     := "Contas a Pagar - Por Conta Corrente"
Local nLin       := 80
Local Cabec1     := ""
Local Cabec2     := ""
Local imprime    := .T.
Local aOrd       := {}
Local cPerg      := "UFIN05    "
Private limite   := 132
Private tamanho  := "G"
Private nomeprog := "UNFINR05" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo    := 15
Private aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey := 0
Private m_pag    := 1
Private wnrel    := "UNFINR04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString  := "SE2"

//u_TESTE1()

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)
Cabec1 := PADC("Perido de "+Dtoc(mv_par01)+" ate "+Dtoc(mv_par02),Limite)
         //           10        20        30        40        50        60        70        80        90        100
         // 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec2 := " Banco Nome da Conta                        Agencia   C. Corrente   Saldo Atual     Vlr a Pagar     Saldo "


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
   Local cQuery, nSaldo, cUnidade, nProg, cNatureza

   cQuery := "SELECT E2_NATUREZ, E2_PORTADO, E2_AGEDEP, E2_NUMCON, SUM(E2_SALDO) E2_SALDO FROM "+RetSQLName("SE2")
   cQuery += " WHERE E2_PORTADO >= '"+mv_par03+"' AND E2_PORTADO <= '" +mv_par04+"' AND E2_SALDO <> 0 "
   cQuery += "AND E2_VENCREA >= '"+Dtos(mv_par01)+"' AND E2_VENCREA <= '"+Dtos(mv_par02)+"' "
   cQuery += "GROUP BY E2_PORTADO, E2_AGEDEP, E2_NUMCON, E2_NATUREZ "
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.T.)

   dbSelectArea("TMP")
   While !Eof()
      dbSelectArea("SA6")
      dbSetOrder(1)
      dbSeek(XFILIAL("SA6")+TMP->(E2_PORTADO+E2_AGEDEP+E2_NUMCON))
      dbSelectArea("TMP")
      nSaldo := SA6->A6_SALATU - TMP->E2_SALDO

      if nLin > 55
         nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
      Endif
                                                   
     cNatureza := Posicione("SED",1,xFilial("SED")+TMP->E2_NATUREZ,"ED_DESC")
      @ nLin,01  PSAY Alltrim(SE2->E2_NATUREZ)
      @ nLin,15  PSAY cNatureza
      @ nLin,43  PSAY Transform(TMP->E2_SALDO  ,"@E 99,999,999.99")

      
/*    @ nLin,01  PSAY Alltrim(SA6->A6_COD)
      @ nLin,06  PSAY Alltrim(SA6->A6_NREDUZ)
      @ nLin,43  PSAY Alltrim(SA6->A6_AGENCIA)
      @ nLin,53  PSAY Alltrim(SA6->A6_NUMCON)
      @ nLin,67  PSAY Transform(SA6->A6_SALATU ,"@E 99,999,999.99")
      @ nLin,83  PSAY Transform(TMP->E2_SALDO  ,"@E 99,999,999.99")
      @ nLin,99  PSAY Transform(nSaldo         ,"@E 99,999,999.99")
 */
     nLin ++

      dbSkip()
      
   Enddo
   
   dbCloseArea("TMP")

   If aReturn[5]==1
      dbCommitAll()
      SET PRINTER TO
      OurSpool(wnrel)
   Endif
   MS_FLUSH()
Return

Static Function ValidPerg(cPerg)
   Local i, j, aRegs, _sAlias := Alias()
   
   cPerg := PADR(cPerg,10)
   aRegs := {}
   dbSelectArea("SX1")
   dbSetOrder(1)

   AADD(aRegs,{cPerg,"01","Data De                   ?","","","mv_ch1","D",08,0,0,"G",;
               "","mv_par01","","","",""})
   AADD(aRegs,{cPerg,"02","Data Ate                  ?","","","mv_ch2","D",08,0,0,"G",;
               "","mv_par02","","","",""})
   AADD(aRegs,{cPerg,"03","Banco De                  ?","","","mv_ch3","C",03,0,0,"G",;
               "","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
   AADD(aRegs,{cPerg,"04","Banco Ate                 ?","","","mv_ch4","C",03,0,0,"G",;
               "","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA6"})
/* AADD(aRegs,{cPerg,"05","Agencia De                ?","","","mv_ch5","C",07,0,0,"G",;
               "","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"06","Agencia Ate               ?","","","mv_ch6","C",07,0,0,"G",;
               "","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})               
   AADD(aRegs,{cPerg,"07","Conta De                  ?","","","mv_ch7","C",15,0,0,"G",;
               "","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"08","Conta Ate                 ?","","","mv_ch8","C",15,0,0,"G",;               
               "","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
*/             
   For i:=1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
         RecLock("SX1",.T.)
         For j:=1 to Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Next
      Endif
      MsUnlock()
      dbCommit()
   Next
   dbSelectArea(_sAlias)
Return
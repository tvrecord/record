#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"    
#INCLUDE "Topconn.ch"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROTVALFUT ºAutor  ³BRUNO ALVES         º Data ³  10/31/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³INFORMAR A QUANTIDADE DE PARCELAS FALTANTES NO CALCULO     º±±
±±º          ³DA FOLHA DE PAGAMENTO                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROTVALFUT()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS       

Local nValor := 0
           
//aSvAlias :={Alias(),IndexOrd(),Recno()}       

if SELECT("TMP") > 0                                
  TMP->(DBCLOSEAREA())
Endif

cQuery := "SELECT RK_VALORTO, RK_VLRPAGO, RK_VALORPA,RK_PARCPAG,RK_PARCELA, RK_PD" //<===== COLOCAR O CAMPO DA DATA DE NASCIMENTO...
cQuery += " FROM " +RetSqlName("SRK")
cQuery += " WHERE RK_FILIAL = '" + SRA->RA_FILIAL + "' AND"
cQuery += " RK_MAT = '" + SRA->RA_MAT + "' "
cQuery += " AND   D_E_L_E_T_ = ' ' "            
	      
TcQuery :=  ChangeQuery(cQuery) 
TcQuery cQuery New Alias "TMP"

DBSelectArea("TMP")

While !TMP->(Eof())

if TMP->RK_PD == "464"
nValor := FBUSCAPD("464") * -1
FdelPd("464")
fGeraVerba("464",nValor,TMP->RK_PARCPAG+1,,,,,,,,.t.)

ELSEIF TMP->RK_PD == "478"
nValor := FBUSCAPD("478") * -1
FdelPd("478")
fGeraVerba("478",nValor,TMP->RK_PARCPAG+1,,,,,,,,.t.)
EndIf

TMP->(DbSkip())
nValor := 0

Enddo
     

DBCloseArea("TMP")	     
     
	     
//dbSelectArea(aSvAlias[1])
//dbSetOrder(aSvAlias[2])
//dbGoto(aSvAlias[3])


return
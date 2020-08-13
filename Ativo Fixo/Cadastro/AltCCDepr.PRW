#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltCCDepr     บ Autor ณ RAFAEL FRANCA  บ Data ณ  05/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณTroca de contas de despesa de deprecia็ใo de ativos         บฑฑ
ฑฑบ de acordo com o centro de custo.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRECORD DF                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AltCCDepr

Private cQuery 		:= ""
Private cContaAnt	:= ""
Private cContaNov	:= ""
Private cGrupo 		:= ""  
Private nRegistros	:= 0  

/* Altera็ใo contas despesas de deprecia็ใo ativo fixo.
   
cQuery 		:= "SELECT N3_FILIAL,N3_CCONTAB,N3_CBASE,N3_ITEM,N3_TIPO,N3_BAIXA,N3_CCDEPR,N3_CDEPREC,N3_CUSTBEM,CTT_GRUPO " 
cQuery 		+= "FROM SN3010 INNER JOIN CTT010 ON N3_CUSTBEM = CTT_CUSTO AND N3_FILIAL = CTT_FILIAL "
cQuery 		+= "WHERE SN3010.D_E_L_E_T_ = '' AND N3_CDEPREC <> '' AND SUBSTR(N3_CCONTAB,1,3) <> '132' AND N3_CUSTBEM <> '' "
cQuery 		+= "AND CTT010.D_E_L_E_T_ = '' AND SUBSTR(N3_CDEPREC,2,1) <> CTT_GRUPO AND CTT_GRUPO <> '' "
cQuery 		+= "ORDER BY N3_FILIAL,N3_CCONTAB,N3_CBASE,N3_ITEM,N3_TIPO,N3_BAIXA "
                                   
*/ 
     
// Altera็ใo de rateios
 
cQuery 		:= "SELECT CT9_FILIAL,CT9_RAT_ON,CT9_SEQUEN,CT9_DEBITO,CT9_CCD,CT9010.R_E_C_N_O_ AS RECNO1,CTT_GRUPO "
cQuery 		+= "FROM CT9010 INNER JOIN CTT010 ON CTT_CUSTO = CT9_CCD AND CTT_FILIAL = CT9_FILIAL "
cQuery 		+= "WHERE CT9010.D_E_L_E_T_ = '' AND CT9_DEBITO <> '' AND CT9_CCD <> '' AND CTT010.D_E_L_E_T_ = '' AND SUBSTRING(CT9_DEBITO,2,1) <> CTT_GRUPO "
 
     
TcQuery cQuery New Alias "TMPATF"

dbSelectArea("TMPATF")
dbGotop()          	

While !EOF()

cContaAnt 	:= TMPATF->CT9_DEBITO
cGrupo 		:= TMPATF->CTT_GRUPO

If cContaAnt >= '41' .AND. cContaAnt <= '439999999' .AND. cGrupo != ''
	
	If SUBSTR(cContaAnt,2,1) == cGrupo // Verifica se a conta contabil do cadastro estแ OK
		cConta := cContaAnt
	ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cContaAnt, "ZI_CC2"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cContaAnt, "ZI_CC2")
	ElseIf SUBSTR(Posicione("SZI",1,xFilial("SZI") + cContaAnt, "ZI_CC3"),2,1) == cGrupo
		cConta := Posicione("SZI",1,xFilial("SZI") + cContaAnt, "ZI_CC3")
	EndIf	
	
EndIf 

nRegistros	+= 1 

// Altera็ใo contas despesas de deprecia็ใo ativo fixo. 
//TcSqlExec("UPDATE SN3010 SET N3_CDEPREC = '" + cConta + "' WHERE SN3010.D_E_L_E_T_ = '' AND N3_CDEPREC = '" + TMPATF->N3_CDEPREC + "' AND N3_FILIAL = '" + TMPATF->N3_FILIAL + "' AND N3_CCONTAB = '" + TMPATF->N3_CCONTAB + "' AND N3_CBASE = '" + TMPATF->N3_CBASE + "' AND N3_ITEM = '" + TMPATF->N3_ITEM + "' AND N3_TIPO = '" + TMPATF->N3_TIPO + "' AND N3_CUSTBEM = '" + TMPATF->N3_CUSTBEM + "' ")
 
//TcSqlExec("UPDATE CT9010 SET CT9_DEBITO = '" + cConta + "' WHERE CT9010.D_E_L_E_T_ = '' AND CT9_DEBITO = '" + TMPATF->CT9_DEBITO + "' AND CT9_RAT_ON = '" + TMPATF->CT9_RAT_ON + "' AND CT9_SEQUEN = '" + TMPATF->CT9_SEQUEN + "' AND CT9_FILIAL = '" + TMPATF->CT9_FILIAL + "' AND CT9_CCD = '" + TMPATF->CT9_CCD + "' ") 
	dbSkip()
	
Enddo 



dbSelectArea("TMPATF")
dbCloseArea("TMPATF")  

Alert("Registros CT9 alterados com sucesso!")

Return
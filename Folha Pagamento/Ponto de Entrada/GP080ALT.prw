#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
O ponto de entrada permite manipular as variaveis "nMes", "nDia" e "nHor",
que contém o valor do salário/mês, salário/dia e salário/hora do funcionário.
*/

// Rafael França - 23/04/18 -  Ponto de Entrada para mudar as variaveis nMes, nDia e nHora de acordo com o modelo de pagamento Record

User Function GP080ALT()  

/*

Local cQuerySRH := ""
Local cQuerySRR := ""  

IF SRA->RA_SINDICA == "02" .AND. MV_PAR10 == 3   //Jornalistas = Salario base + Quinquenio, Rescisão

cQuerySRR := "SELECT SUM(RR_VALOR) AS VALOR FROM SRR010 WHERE D_E_L_E_T_ = '' AND RR_MAT = '"+AllTrim(SRA->RA_MAT) +"' AND RR_PERIODO = '"+AnoMes(MV_PAR01)+"' AND RR_FILIAL = '"+xFilial("SRD", SRA->RA_FILIAL)+"' AND RR_PD IN ('282','330') GROUP BY RR_MAT" 

tcQuery cQuerySRR New Alias "TMP1"   

If Eof() 
	nMes := SRA->RA_SALARIO
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
else
	DBSelectArea("TMP1")
	DBGotop()
	
	While !EOF()
		
		nMes 	:= ROUND(SRA->RA_SALARIO + TMP1->VALOR,2) 
		nDia 	:= ROUND(nMes/30,2)
		nHor 	:= ROUND(nMes/180,2)
		
		dbSkip()
		
	Enddo
	
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	
Endif     

ELSEIF SRA->RA_SINDICA == "01" .AND. MV_PAR10 == 1 //Radialistas = Salario valorizado com todas as verbas, pega o valor do salario no calculo da ultima ferias

//cQuerySRH := "SELECT RH_SALMES FROM SRH010 WHERE D_E_L_E_T_ = '' AND RH_MAT = '"+AllTrim(SRA->RA_MAT) +"' AND RH_PERIODO = '"+AnoMes(MV_PAR01)+"' AND RH_FILIAL = '"+xFilial("SRD", SRA->RA_FILIAL)+"'"
			cQuerySRH := "SELECT RH_SALMES AS SALMES FROM SRH010 WHERE D_E_L_E_T_ = '' AND RH_MAT = '"+SRA->RA_MAT+"' " 
			cQuerySRH += "AND RH_DTRECIB IN(SELECT MAX(RH_DTRECIB) FROM SRH010 WHERE D_E_L_E_T_ = '' AND RH_MAT = '"+SRA->RA_MAT+"')"

tcQuery cQuerySRH New Alias "TMP1"

If Eof() 
	nMes 	:= ROUND(SRA->RA_SALARIO,2) 
	nDia 	:= ROUND(nMes/30,2)
	nHor 	:= ROUND(nMes/180,2)
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	Return
else
	DBSelectArea("TMP1")
	DBGotop()
	
	While !EOF()
		
		nMes 	:= TMP1->SALMES
		nDia 	:= ROUND(nMes/30,2)
		nHor 	:= ROUND(nMes/180,2)
		
		dbSkip()
		
	Enddo
	
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
	
Endif     

ENDIF
  
*/

Return
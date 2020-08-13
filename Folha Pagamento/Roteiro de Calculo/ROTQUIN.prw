#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROTRDSR  º Autor ³ Rorilson        º Data ³  10/12/08		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ ALTERAR VALOR HORA DA MEDIA DE 13 SALARIO                  º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROTQUIN()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS

/*
Private aSvAlias 		:={Alias(),IndexOrd(),Recno()}
Private nQuinquenio		:= 0 
Private nDiasRes := (M->RG_DTAVISO - FirstDate(M->RG_DTAVISO)) + 1


      
//Calculo de Quinquenio
If SUBSTR(SRA->RA_ADTPOSE,5,1) ==  "Q"
	nAno := ROUND(((DATE() - SRA->RA_ADMISSA) / 365),1)
	nPerc := nAno / 5
	If nPerc < 10
		nTot := Val(SUBSTR(cValTOChar(nPerc),1,1))
	else
		nTot := Val(SUBSTR(cValTOChar(nPerc),1,2))
	EndIf
	
	nQuinquenio := SRA->RA_SALARIO * ((nTot * 3)/100)
	 If nQuinquenio > 0
	 nDiasRes := IIF(nDiasRes > 30,30,nDiasRes)    
	 	salmes := salmes - nQuinquenio
   		FdelPd("007")     		
   		fGeraVerba("007",(nQuinquenio/30)*nDiasRes,nDiasRes,,,,,,,,.T.) 
  	EndIf
	
EndIf  



If SUBSTR(SRA->RA_ADTPOSE,5,1) ==  "Q"
	nAno := ROUND(((DATE() - SRA->RA_ADMISSA) / 365),1)
	nPerc := nAno / 5
	If nPerc < 10
		nTot := Val(SUBSTR(cValTOChar(nPerc),1,1))
	else
		nTot := Val(SUBSTR(cValTOChar(nPerc),1,2))
	EndIf
	
	nQuinquenio := SRA->RA_SALARIO * ((nTot * 3)/100)
	
EndIf    

fGeraVerba("007",74.48,,,,,,,,,.T.) 


dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

*/

Return

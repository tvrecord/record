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
User Function ROTRDSR()    //CALCULO DO VALOR DE ISS DOS AUTONOMOS

//Private aSvAlias 		:={Alias(),IndexOrd(),Recno()}
Public _HorasExtras		:= 0
Public _DsrHorasExtra	:= 0
Private _Salbrutob		:= 0
Private _Salbrutoa		:= 0
Private nAcumulo  		:= 0
Private nAdicional 		:= 0
Private nGratificacao	:= 0
Private nQuinquenio		:= 0
Private nPericu			:= 0
Private nInsalub      	:= 0
Private nDiasRes 		:= (M->RG_DTAVISO - FirstDate(M->RG_DTAVISO)) + 1


//IF ALLTRIM(FUNNAME()) <> "GPEM040"

nBase := SRA->RA_SALARIO

// Calculo do Acumulo de Funcao

If SRA->RA_ACFUNC == "S" .AND. SRA->RA_ACUMULA == 0
	nAcumulo := SRA->RA_SALARIO * 0.40
	fGeraVerba("117",Round(nAcumulo / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("990",Round(nAcumulo,2),40,,,,,,,,.T.)
ElseIf SRA->RA_ACFUNC == "N" .AND. SRA->RA_ACUMULA != 0
	nAcumulo := SRA->RA_SALARIO * (SRA->RA_ACUMULA / 100)
	fGeraVerba("117",Round(nAcumulo / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("990",Round(nAcumulo,2),SRA->RA_ACUMULA,,,,,,,,.T.)
EndIf

// Calculo do Serviço Adicional

If SRA->RA_CALCADI == "S"
	nAdicional := SRA->RA_SALARIO * 0.40
	fGeraVerba("169",Round(nAdicional / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("988",Round(nAdicional,2),40,,,,,,,,.T.)
EndIf

// Calculo de Gratificacao

If SRA->RA_GRATFUN == "S"
	nGratificacao := SRA->RA_SALARIO * 0.40
	fGeraVerba("100",Round(nGratificacao / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("989",Round(nGratificacao,2),40,,,,,,,,.T.)
EndIF

//Calculo de Quinquenio

//If SUBSTR(SRA->RA_ADTPOSE,5,1) ==  "Q"
//	nAno := ROUND(((DATE() - SRA->RA_ADMISSA) / 365),1)
//	nPerc := nAno / 5
//	If nPerc < 10
//		nTot := Val(SUBSTR(cValTOChar(nPerc),1,1))
//	else
//		nTot := Val(SUBSTR(cValTOChar(nPerc),1,2))
//	EndIf
//
//	nQuinquenio := SRA->RA_SALARIO * ((nTot * 3)/100)

//EndIf

//fGeraVerba("007",(nQuinquenio/30)*nDiasRes,nDiasRes,,,,,,,,.T.)

//Calculo de Periculosidade

	If !EMPTY(SRA->RA_PERICUL)
		nPericu := SRA->RA_SALARIO * 0.30
	EndIf

//Calculo de Insalubridade

	If !EMPTY(SRA->RA_INSMED)
		nInsalub := Val_SalMin * 0.20
	EndIf

nBase 	+= nAcumulo + nAdicional + nGratificacao

If SRA->RA_HEFIX25="S"
	_HorasExtras:=((((nBase + nPericu + nInsalub)/SRA->RA_HRSMES) * 1.7)*25)
	_DsrHorasExtra:=((_HorasExtras/RG_NORMAL)*RG_DESCANS)

	//	_Salbrutob:=((((SALMES/SRA->RA_HRSMES) * 1.7)*25)/30)*(DiasTrab)
	//	FdelPd("118")
	fGeraVerba("118",Round(_HorasExtras / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("991",_HorasExtras,,,,,,,,,.T.)
	fGeraVerba("060",Round(_DsrHorasExtra / 30 * Diastrab,2),Diastrab,,,,,,,,.T.)
	fGeraVerba("998",_DsrHorasExtra,,,,,,,,,.T.)
	nBase += (_HorasExtras +  _DsrHorasExtra)
//	Salmes += (_HorasExtras +  _DsrHorasExtra)
Endif

//dbSelectArea(aSvAlias[1])
//dbSetOrder(aSvAlias[2])
//dbGoto(aSvAlias[3])

Return

#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROT012    º Autor ³ JACKSON MACIEL     ³      |  22/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ ROTEIRO DE CALCULO                                         º±±
±±º          ³ - H.E FIXA CONTRATUAL 25 (VERBA 118)                       º±±
±±º          ³ - H.E FIXA CONTRATUAL 50 (VERBA 122)                       º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROT012()

// Salva alias, indice e Recno da rotina principal

aSvAlias:={Alias(),IndexOrd(),Recno()}

IF SRA->RA_HEFIX25="S" // H.E FIXA CONTRATUAL 25 (VERBA 118)
	
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH = "A" .OR. SUBSTR(DTOS(SRA->RA_ADMISSA),1,6) = RCH->RCH_PER  //   IF ALLTRIM(FUNNAME()) =  "GPEM020"
		fGeraVerba("118",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(DiasTrab),,,,,,,,,.T.)
	Else
		fGeraVerba("118",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*25)/30)*(DiasTrab+nDiasAfas),,,,,,,,,.T.)
	ENDIF

ENDIF

IF SRA->RA_HEFIX50="S" // H.E FIXA CONTRATUAL 50 (VERBA 122)
	
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH = "A" .OR. SUBSTR(DTOS(SRA->RA_ADMISSA),1,6) = RCH->RCH_PER //   IF ALLTRIM(FUNNAME()) = "GPEM020"
		fGeraVerba("122",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*50)/30)*(DiasTrab),,,,,,,,,.T.)
	Else
		fGeraVerba("122",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V"))/SRA->RA_HRSMES) * 1.7)*50)/30)*(DiasTrab+nDiasAfas),,,,,,,,,.T.)
	ENDIF
	
ENDIF

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return

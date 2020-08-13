#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//Rafael França - 17/12/18 - Passa todas as verbas customizadas da folha de pagamente para um só programa.

User Function ROTFOLREC()

//Calcula Acumulo de função
IF SRA->RA_ACFUNC == "S"
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A" //Verifica se houve ferias ou está afastado
		fGeraVerba("117",Round(((SRA->RA_SALARIO/30)*(DiasTrab) * 0.40),2),DiasTrab,,,,,,,,.F.)
	ELSE
		fGeraVerba("117",Round(((SRA->RA_SALARIO) * 0.40),2),40,,,,,,,,.F.)
	ENDIF
	fGeraVerba("582",Round(((SRA->RA_SALARIO) * 0.40),2),40,,,,,,,,.F.)
ENDIF

IF SRA->RA_ACUMULA > 0  // Proporcional
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A" //Verifica se houve ferias ou está afastado
		fGeraVerba("127",Round(((SRA->RA_SALARIO/30)*(DiasTrab)*(SRA->RA_ACUMULA)/100),2),DiasTrab,,,,,,,,.F.)
	ELSE
		fGeraVerba("127",Round(((SRA->RA_SALARIO)*(SRA->RA_ACUMULA)/100),2),40,,,,,,,,.F.)
	ENDIF
	fGeraVerba("582",Round(((SRA->RA_SALARIO)*(SRA->RA_ACUMULA)/100),2),40,,,,,,,,.F.)
ENDIF

//Calcula Adcional
IF SRA->RA_CALCADI == "S"
	//IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A" //Verifica se houve ferias ou está afastado - Retirado por Bruno Alves 27/08/2019 - Não precisa do IF, sempre será calculado em cima dos dias trabalhados
		fGeraVerba("169",Round(((SRA->RA_SALARIO/30)*(DiasTrab)*0.40),2),DiasTrab,,,,,,,,.F.)
	//ELSE -  Retirado por Bruno Alves 27/08/2019 - Não precisa do IF, sempre será calculado em cima dos dias trabalhados
	//	fGeraVerba("169",Round(((SRA->RA_SALARIO)*0.40),2),40,,,,,,,,.F.) -  Retirado por Bruno Alves 27/08/2019 - Não precisa do IF, sempre será calculado em cima dos dias trabalhados
	//ENDIF -  Retirado por Bruno Alves 27/08/2019 - Não precisa do IF, sempre será calculado em cima dos dias trabalhados
	fGeraVerba("583",Round(((SRA->RA_SALARIO)*0.40),2),40,,,,,,,,.F.)
ENDIF

// Calcula Gratificação
IF SRA->RA_GRATFUN == "S"
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A" //Verifica se houve ferias ou está afastado
		fGeraVerba("100",Round(((SRA->RA_SALARIO/30)*(DiasTrab)*0.40),2),DiasTrab,,,,,,,,.F.)
	ELSE
		fGeraVerba("100",Round(((SRA->RA_SALARIO)*0.40),2),DiasTrab,,,,,,,,.F.)
	ENDIF
	fGeraVerba("584",Round(((SRA->RA_SALARIO)*0.40),2),DiasTrab,,,,,,,,.F.)
ENDIF

// Horas Contratuais
IF SRA->RA_HEFIX25="S" // H.E FIXA CONTRATUAL 25 (VERBA 118)
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A"  .OR. SUBSTR(DTOS(SRA->RA_ADMISSA),1,6) = RCH->RCH_PER//Verifica se houve ferias ou está afastado ou adimissao no mes
		fGeraVerba("118",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,1527,169", "V")+((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100))/SRA->RA_HRSMES) * 1.7)*25)/30)*(DiasTrab),DiasTrab,,,,,,,,.T.)
	ELSE
		fGeraVerba("118",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V")+((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100))/SRA->RA_HRSMES) * 1.7)*25)),,,,,,,,,.T.)
	ENDIF
ENDIF

IF SRA->RA_HEFIX50="S" // H.E FIXA CONTRATUAL 50 (VERBA 122)
	IF FBUSCAPD("023") > 0 .OR. SRA->RA_SITFOLH == "A" .OR. SUBSTR(DTOS(SRA->RA_ADMISSA),1,6) = RCH->RCH_PER //Verifica se houve ferias ou está afastado ou admissao no mes
		fGeraVerba("122",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V")+((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100))/SRA->RA_HRSMES) * 1.7)*50)/30)*(DiasTrab),DiasTrab,,,,,,,,.T.)
	ELSE
		fGeraVerba("122",(((((SRA->RA_SALARIO+fBuscaPd("003,007,008,100,117,127,169", "V")+((SRA->RA_SALARIO*SRA->RA_PERCQ) / 100))/SRA->RA_HRSMES) * 1.7)*50)),,,,,,,,,.T.)
	ENDIF
ENDIF

Return
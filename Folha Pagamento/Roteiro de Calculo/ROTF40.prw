#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROTF40  � Autor � Rorilson        � Data �  10/12/08		  ���
�������������������������������������������������������������������������͹��
���MONTA O VALOR DO SALARIO(COMPOSICAO)DO FUNCION�RIO NAS FERIAS,CONSIDERAN���
���DO O VALOR DAS HORAS CONTRATUAIS                                       ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//23/07/18 - Rafael Fran�a - Alterado o programa para gerar verbas personalizadas da Record DF no roterio de calculo das ferias. Antes era feita a composi��o do salario por meio da variavel SalMes

User Function ROTF40()

Local _nDUteis		:= 25 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DUTEIS")  // Rafael - Ajuste Protheus 12
Local _nDiasDSR		:= 5 //Posicione("RCF", 2,xFilial("RCH") + RCH->RCH_PROCESS + RCH->RCH_PER,"RCF_DIADSR")  // Rafael - Ajuste Protheus 12
Local nQuinquenio   := 0

HorasExtras:=0
DsrHorasExtra:=0
nCalcAdi:=0
nDiasFer := 0
lMesSeguinte := .F.

IF FBUSCAPD("282") > 0 .OR. SRA->RA_PERCQ > 0
nQuinquenio := (SRA->RA_SALARIO*SRA->RA_PERCQ) / 100
ENDIF

nBase 	:= Salmes // SRA->RA_SALARIO

If Month2Str(RH_DATAINI) != Month2Str(RH_DATAFIM) //Verifica os dias de ferias no mes e no mes seguinte
	nDiasFer := LastDate(RH_DATAINI) - RH_DATAINI + 1
	lMesSeguinte := .T.
else
	nDiasFer := RH_DFERIAS
EndIf

IF SRA->RA_ACFUNC == "S" .AND. SRA->RA_ACUMULA == 0 // ACUMULO DE FUNCAO PADRAO 40%
	fGeraVerba("115", (SRA->RA_SALARIO * 0.40 / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("369", (SRA->RA_SALARIO * 0.40 / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("995", (SRA->RA_SALARIO * 0.40) ,40,,,,,,,,.T.)
	//Salmes +=  (SRA->RA_SALARIO * 0.40)
	nBase +=  (SRA->RA_SALARIO * 0.40)
ELSEIF SRA->RA_ACUMULA > 0 // ACUMULO DE FUNCAO VARIAVEL
	fGeraVerba("115", ((SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("369", ((SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("995", (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100) ,SRA->RA_ACUMULA,,,,,,,,.T.)
	//Salmes +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100)
	nBase +=  (SRA->RA_SALARIO * SRA->RA_ACUMULA / 100)
EndIf

IF SRA->RA_CALCADI == "S"  // SERVI�O ADICIONAL 40%
	fGeraVerba("116", (SRA->RA_SALARIO * 0.40 / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("367", (SRA->RA_SALARIO * 0.40 / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("993", (SRA->RA_SALARIO * 0.40) ,40,,,,,,,,.T.)
	//Salmes +=  (SRA->RA_SALARIO * 0.40)
	nBase +=  (SRA->RA_SALARIO * 0.40)
EndIf

If SRA->RA_GRATFUN = "S" // GRATIFICA��O DE FUN��O 40%
	fGeraVerba("102", (SRA->RA_SALARIO * 0.40 / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("368", (SRA->RA_SALARIO * 0.40 / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("994", (SRA->RA_SALARIO * 0.40) ,40,,,,,,,,.T.)
	//Salmes +=  (SRA->RA_SALARIO * 0.40)
	nBase +=  (SRA->RA_SALARIO * 0.40)
EndIf


If SRA->RA_HEFIX25 == "S" // H.E FIXA CONTRATUAL 25
	HorasExtras:=((((nBase + nQuinquenio + fbuscapd("333") + fbuscapd("334"))/SRA->RA_HRSMES) * 1.7)*25)
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
	fGeraVerba("562", (HorasExtras / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("564", (HorasExtras / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("996", (HorasExtras),70,,,,,,,,.T.)
	fGeraVerba("563", (DsrHorasExtra / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("565", (DsrHorasExtra / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("998", (DsrHorasExtra),,,,,,,,,.T.)

	//Salmes +=  (HorasExtras +  DsrHorasExtra)
	//nBase +=  (HorasExtras +  DsrHorasExtra)
Endif

IF SRA->RA_HEFIX50 == "S" // H.E FIXA CONTRATUAL 50
	HorasExtras:=((((nBase + nQuinquenio) / SRA->RA_HRSMES) * 1.7)*50)
	DsrHorasExtra:=((HorasExtras/_nDUteis)*_nDiasDSR)
	fGeraVerba("562", (HorasExtras / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("564", (HorasExtras / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("997", (HorasExtras),70,,,,,,,,.T.)
	fGeraVerba("563", (DsrHorasExtra / 30) * nDiasFer,nDiasFer,,,,,,,,.T.)
	fGeraVerba("565", (DsrHorasExtra / 30) * (RH_DFERIAS - nDiasFer),(RH_DFERIAS - nDiasFer),,,,,,,,.T.)
	fGeraVerba("998", (DsrHorasExtra),,,,,,,,,.T.)
	//Salmes +=  (HorasExtras +  DsrHorasExtra)
	//nBase +=  (HorasExtras +  DsrHorasExtra)
Endif

//Corrige campos do cabe�ario (SRH) com o novo salario incorporado

	RH_SALMES := nBase
	RH_SALDIA := ROUND(nBase/30,2)
	RH_SALHRS := ROUND(nBase/SR6->R6_HRNORMA,2)
	RH_SALARIO := nBase
	RH_SALDIA1 := ROUND(nBase/30,2)
	RH_SALHRS1 := ROUND(nBase/SR6->R6_HRNORMA,2)


Return
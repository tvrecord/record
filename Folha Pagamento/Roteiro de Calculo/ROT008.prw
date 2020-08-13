#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROT008    º Autor ³ Hermano Nobre      º Data ³  29*11.06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ PROGRAMA PARA CALCULO DO VALOR DO ADIANTAMENTO             º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º	A empresa concederá um beneficio ao empregado que tiver acima de 5anos ±
±±º   de empresa no momento da aposentadoria.                             º±±
±±º                                                                       º±±
±±º																          º±±
±±º   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00365 -       º±±
±±º          EXECBLOCK("ROT008",.F.,.F.) 						          º±±
±±º                													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ Rede Record                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROT008()

Local _nBaseSal		:= SRA->RA_SALARIO
Local _nBasePre		:= SRA->RA_PREMIO
Local _nBaseRem		:= SRA->RA_REMUNEN
Local _DaAdemisa		:= SRA->RA_ADMISSA
Local _nBaseSadic    := SRA->RA_ADICION
Local _nValorAdto		:= 0
Local xnValorAdto		:= 0
Local _nPercAdto		:= 0
Local _cDescFun     	:= Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
local _cMesAno      	:= Alltrim(GETMV("MV_FOLMES"))    
Local _nValorIR		:= 0    //ultima data do mes   Firstaday - primeira data do mes
Local aAnoMes			:= STRZERO(Month(SRA->RA_ADMISSA),2)+STRZERO(YEAR(SRA->RA_ADMISSA),4)
Local xdDatabase		:= STRZERO(Month(dDataBase),2)+STRZERO(YEAR(dDataBase),4)  
Local xDiasProc		:= 0            

//If Empty(SRA->RA_SITFOLH) .And. SRA->RA_PERCADT > 0
IF (DiasTb >=15 .AND.!SRA->RA_SITFOLH$"D/A") //.OR. (SRA->RA_SITFOLH ="A" .AND. SRA->RA_AFASFGT="D".AND.cPgSalMat="S")
   
   IF aAnoMes == xdDatabase .OR. DiasTb < 30 
	   //xDiasProc     := LastDay(SRA->RA_ADMISSA)- dDataBase
   	IF (Substr(aAnoMes,1,2) == "02" .AND. xDiasProc == 28) .OR. (Substr(aAnoMes,1,2) == "02" .AND. xDiasProc == 29)
      	xDiasProc := 30
   	ELSE
      	xDiasProc := DiasTb
   	ENDIF
   ENDIF	
   

	_nValorAdto	:= _nBaseSal + _nBasePre + _nBaseRem + _nBaseSadic

   IF (DiasTb < 30 )
      xnValorAdto := ((_nValorAdto / 30) * xDiasProc )
		_nPercAdto	:= Round((xnValorAdto * SRA->RA_PERCADT) / 100,2)	
	ELSE 
	   _nPercAdto	:= Round((_nValorAdto * SRA->RA_PERCADT) / 100,2)		
	ENDIF   
	
	dbSelectArea("SZ5")
	dbsetOrder(1)
	If DbSeek(xFilial("SZ5")+SRA->RA_MAT+_cMesAno)
		Reclock("SZ5",.F.)
		SZ5->Z5_DTPAGTO	:= dDataBase
		SZ5->Z5_BASESAL	:= _nBaseSal
		SZ5->Z5_VLRSAL	   := Round((_nBaseSal * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_BASEPRE	:= _nBasePre
		SZ5->Z5_VLRPRE	   := Round((_nBasePre * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_BASEREM	:= _nBaseRem
		SZ5->Z5_VLRREM	   := Round((_nBaseRem * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_VLRADT	   := _nPercAdto                                  
		SZ5->Z5_ADICION   := Round((_nBaseRem * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_CODFUNC	:= SRA->RA_CODFUNC
		SZ5->Z5_DESCFUN   := _cDescFun
		MsUnlock()
	Else
		Reclock("SZ5",.T.)
		SZ5->Z5_FILIAL		:= SRA->RA_FILIAL
		SZ5->Z5_MAT			:= SRA->RA_MAT
		SZ5->Z5_NOME	   := SRA->RA_NOME               
		SZ5->Z5_CC			:= SRA->RA_CC
		SZ5->Z5_MESFOL		:= _cMesAno
		SZ5->Z5_DTPAGTO	:= dDataBase
		SZ5->Z5_BASESAL	:= _nBaseSal
		SZ5->Z5_VLRSAL		:= Round((_nBaseSal * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_BASEPRE	:= _nBasePre
		SZ5->Z5_VLRPRE		:= Round((_nBasePre * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_BASEREM	:= _nBaseRem
		SZ5->Z5_VLRREM		:= Round((_nBaseRem * SRA->RA_PERCADT) / 100,2)
		SZ5->Z5_VLRADT		:= _nPercAdto
		SZ5->Z5_CODFUNC	:= SRA->RA_CODFUNC
		SZ5->Z5_DESCFUN  	:= _cDescFun
		MsUnlock()
	EndIf
	//	fGeraVerba("074",_nPercAdto,1,,,,,,,,.t.)    IR 977,05 VL ADTO 2.722,17
	//	_nValorIR := CALC_IR(2031, @VAL_PEAL,27, @BASE_RED, @VAL_DEDDEP, @VAL_DEPEAL,1313)  
	
   //IR_CALC
   //VLR_RES 
   //_nValorIR := Val_Adto + SRA->RA_PREMIO + SRA->RA_REMUNEN
   Val_Adto := _nPercAdto
  // BASE_INI := _nPercAdto
  	//CALC_IR(@BASE_INI, @VAL_PEAL, @IR_CALC, @BASE_RED, @VAL_DEDDEP, @VAL_DEPEAL, aTabIr )
   //fGeraVerba("410",_nPercAdto,1,,,,,,,,.T.) //Retirado para gerar a verba 379 na virada de versão - 08/04/2018 - Bruno Alves
   //  fGeraVerba("379",_nPercAdto,1,,,,,,,,.T.) //Retirado para gerar a verba 379 na virada de versão - 08/04/2018 - Bruno Alves
   //fGeraVerba("708",_nPercAdto,1,,,,,,,,.t.)
   //fGeraVerba("470",Val_Adto,1,,,,,,,,.t.)
EndIf
Return
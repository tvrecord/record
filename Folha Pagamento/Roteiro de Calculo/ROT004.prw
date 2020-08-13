#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROT004    º Autor ³ Hermano Nobre      º Data ³  23.11.06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ PROGRAMA PARA CALCULO DO GANHO EVENTUAL.            		  º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º	A empresa concederá ao funcionario o ganho eventual conforme          l)±
±±º configuração do cadastro de sindicatos e verbas.                      º±±
±±º                                                                       º±±
±±º																		  º±±
±±º   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00665 -       º±±
±±º          EXECBLOCK("ROT004",.F.,.F.) 							      º±±
±±º                														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ Rede Record                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROT004()

Local aArea		:= GetArea()
Local _nPerc	:= 0
Local _cMesAno	:= ""
Local _nQtdParc	:= 0
Local _nTeto	:= 0
Local _dDtLim	:= CTOD('  /  /  ')
Local cVerbas	:= ""
Local nValor	:= 0
Local nMeses	:= 12
Local _nValGanho	:= 0
// verificar com a Glauce questão do salário de abril?

dbSelectArea("RCE") // Abre cadastro de sindicatos
DbSetOrder(1)
DbSeek(SRA->RA_FILIAL + SRA->RA_SINDICA)

_nPerc		:= RCE->RCE_PERGAN
_cMesAno		:= RCE->RCE_MESANO
_nQtdParc	:= RCE->RCE_QNTPAR
_nTeto		:= RCE->RCE_VLTETO
_dDtIni		:= RCE->RCE_DTINI
_dDtLim		:= RCE->RCE_DTLIMI

nMeses := fMesesTrab(SRA->RA_ADMISSA,_dDtLim)  // Numero de meses trabalhados 

If nMeses > 12
	nMeses := 12
EndIf

_cMesFim	:= Strzero(Val(Substr(_cMesAno,1,2)) + _nQtdParc - 1,2)

// Query que consulta quais verbas possui mensalidade associativa igual a SIM
// para calculo do valor quando tipo de base igual a 2 (remuneracao).
cQuery := " SELECT RV_COD FROM "+RetSqlName("SRV")
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND RV_GEVENTU = 'S'"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QSRV',.T.,.T.)
//TcQuery cQuery New Alias "QSRV"
DbSelectArea("QSRV")
While QSRV->(!Eof())
	cVerbas += QSRV->RV_COD+","
	QSRV->(DbSkip())
EndDo
cVerbas := Substr(cVerbas,1,(Len(cVerbas)-1)) //- PARA TIRAR A ULTIMA VIRGULA
nValor	:= fBuscaPd(cVerbas)

If Str(Year(dDataBase),4) == Substr(_cMesAno,4,4) .And.;
	StrZero(Month(dDatabase),2) >= Substr(_cMesAno,1,2) .And. ;
	StrZero(Month(dDatabase),2) <= _cMesFim .And. SRA->RA_ADMISSA <= _dDtLim  
	If SRA->RA_SINDICA == "02"
		_nValGanho := Round((((nValor/12) * nMeses)*_nPerc)/100,2)
	Else
		_nValGanho := Round((nValor * _nPerc)/100,2)
	EndIf
	If _nTeto > 0 .And. _nValGanho > _nTeto
		_nValGanho	:= _nTeto
	EndIf         
	If _nValGanho > 0
		fDelPd("120")
		fGeraVerba("120",_nValGanho,_nPerc,,,,,,,,.t.)
	EndIf
	_nValGanho := 0
EndIf
QSRV->(DbCloseArea())
RestArea(aArea)
Return
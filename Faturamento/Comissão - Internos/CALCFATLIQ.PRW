#include "rwmake.ch"
#include "topconn.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CALCFATLIQ� Autor � Klaus S. Peres     � Data �  27/06/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera as informacoes do Faturamento Liquido do mes inform.  ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento - Record Brasilia                              ���
�������������������������������������������������������������������������͹��
���Ajustes   � Alexandre Zapponi - 11-02-2007                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function CalcFatLiq()

Local cTxt
Local cTmp
Local nPos
Local dDataIni
Local dDataFim
Local dDataIniA
Local dDataFimA

Local _Qry			:=	""
Local	_lRet			:= .f.
Local	_nCom			:= 0
Local	_nRep			:= 0
Local	_nBsCom		:= 0
Local	_nTotal		:= 0
//Local	nTotBruto		:= 0
Local	_nFatLiq		:= 0
Local aMeses		:=	{	{"01","Jan"},{"02","Fev"},{"03","Mar"},{"04","Abr"},{"05","Mai"},{"06","Jun"},;
								{"07","Jul"},{"08","Ago"},{"09","Set"},{"10","Out"},{"11","Nov"},{"12","Dez"} }

Private	cPerg		:= "CALFLR" // Calculo Faturamento Liquido Record
Private cTipo       := ""

ValidPerg()

if !Pergunte(cPerg,.t.)
	Return
endif

if	Empty(Alltrim(mv_par01)) .or. Len(Alltrim(mv_par01)) <> 2 .or. !( mv_par01 $ "01-02-03-04-05-06-07-08-09-10-11-12")
	Alert("Ajuste o M�s de In�cio. Dever� ter 2 algarismos")
	Return
endif

if	Empty(Alltrim(mv_par02)) .or. Len(Alltrim(mv_par02)) <> 4 .or. mv_par02 < "2006" .or. mv_par02 > "2050"
	Alert("Ajuste o Ano de In�cio. Dever� ter 4 algarismos")
	Return
endif

if	mv_par02 == "2007" .and. mv_par01 $ "03/04"
	if mv_par01 == "04"
		cTxt	:=	"N�o ser� possivel alterar o valor do mes de Abril de 2007!" + Chr(10) + Chr(13)
		cTxt	+=	"O m�s de Abril de 2007 foi a Data de Corte para o in�cio das atividades de comiss�o pelo Sistema..."
	else
		cTxt	:=	"N�o ser� possivel alterar o valor do mes de Mar�o de 2007!" + Chr(10) + Chr(13)
		cTxt	+=	"O m�s de Mar�o de 2007 foi a Data de Corte da Bonifica��o para o in�cio das atividades de comiss�o pelo Sistema..."
	endif

	Aviso( "A T E N � � O ! ! !" , cTxt , { "Ok" } )

	Return
endif

nPos := aScan( aMeses , { |x| x[1] == mv_par01 } )

cTxt := "De Acordo com os par�metros informados, ser� gerado o Faturamento L�quido do per�odo de "
cTxt += aMeses[nPos,2] + "/" + mv_par02 + ". Confirma a Gera��o ?"

if Aviso( "A T E N � � O ! ! !" , cTxt , { "Sim" , "N�o" } ) == 2
	Return
endif

dDataIni		:=	StoD(mv_par02 + mv_par01 + "01")
dDataFimA	:=	( dDataIni - 1 )
dDataIniA	:=	StoD( Substr( DtoS(dDataFimA) , 01 , 06 ) + "01" )
dDataFim		:=	mv_par02 + mv_par01

if	mv_par01 == "02"
	dDataFim += iif( ( Val(mv_par02) / 4 ) == Int( Val(mv_par02) / 4 ) , "29" , "28" )
else
	dDataFim += iif( mv_par01 $ "04/06/09/11" , "30" , "31" )
endif

if mv_par05 == 2
cTipo	:= "CV" //Comiss�o Varejo
elseif mv_par05 == 1
cTipo	:= "CI" //Comiss�o Geral
elseif mv_par05 == 3
cTipo	:= "CD" //Comiss�o Por Data
elseif mv_par05 == 4
cTipo	:= "CT" //Comiss�o de Teste
endif

dDataFim		:= StoD(dDataFim)

_Qry += " select d2_filial, d2_serie, d2_doc, d2_pedido, sum(d2_total) total, c5_comis1, c5_repasse, c5_naturez "
_Qry += " from " + RetSqlName("SD2") + " sd2, " + RetSqlName("SC5") + " sc5, sed010 sed"
_Qry += " where sd2.d2_emissao between '" + DtoS(dDataIni) + "' and '" + DtoS(dDataFim) + "' "
_Qry += "   and sd2.d2_filial   = sc5.c5_filial "
_Qry += "   and sd2.d2_pedido   = sc5.c5_num    "
_Qry += "   and sed.ed_codigo   = sc5.c5_naturez   "
_Qry += "   and sed.d_e_l_e_t_  = ' ' "
_Qry += "   and sc5.c5_calccom  = 'S' "
_Qry += "   and sc5.c5_repasse <> 'S' "
_Qry += "   and sd2.d_e_l_e_t_  = ' ' "
_Qry += "   and sc5.d_e_l_e_t_  = ' ' "
_Qry += "   and sc5.c5_filial   = '" + xFilial("SC5") + "' "
_Qry += "   and sd2.d2_filial   = '" + xFilial("SD2") + "' "
if mv_par05 == 4
_Qry += " 	and sc5.c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
endif
if mv_par05 == 2
_Qry += "   and sed.ed_tipnat  in ('3','4') "
endif
_Qry += " group by d2_filial, d2_serie, d2_doc, d2_pedido, c5_comis1, c5_repasse, c5_naturez "
_Qry += " order by d2_filial, d2_serie, d2_doc"
_Qry := ChangeQuery(_Qry)

TcQuery _Qry New Alias "TSUM"

TSUM->(dbGoTop())

Do While !TSUM->(Eof())

	//Existem vendas com comissoes zeradas
	If TSUM->C5_COMIS1 > 0 .AND. TSUM->C5_COMIS1 < 99.99
		//Neste momento abato as comiss�es dos vendedores externos
		//_nCom		:= Round(((TSUM->TOTAL * TSUM->C5_COMIS1)/100),2)	//Comiss�o Agencia (Externos)
		//_nBsCom	:= Round((TSUM->TOTAL - _nCom),2)						//Base comiss�o Internos
		_nBsCom 	:= TSUM->TOTAL
	ElseIf TSUM->C5_COMIS1 == 99.99
		_nBsCom 	:= 0
	Else //Caso n�o tenha comiss�o, entra para o Faturamento l�quido.
		_nBsCom 	:= TSUM->TOTAL
	EndIf

	_nTotal += _nBsCom  // Recebe os valores para Faturamento total
//	nTotBruto += TSUM->TOTAL

	TSUM->(dbSkip())
	Loop
EndDo

TSUM->(dbCloseArea())

_Qry := " select sum(d2_total) total "
_Qry += " from " + RetSqlName("SD2") + " sd2 , " + RetSqlName("SC5") + " sc5 , sed010 sed "
_Qry += " where sd2.d2_emissao between '" + DtoS(dDataIniA) + "' and '" + DtoS(dDataFimA) + "' "
_Qry += "   and sd2.d2_pedido   = sc5.c5_num "
_Qry += "   and sed.ed_codigo   = sc5.c5_naturez   "
_Qry += "   and sc5.c5_calccom  = 'S' "
_Qry += "   and sc5.c5_repasse  = 'S' "
_Qry += "   and sc5.c5_filial   = '" + xFilial("SC5") + "' "
_Qry += "   and sd2.d2_filial   = '" + xFilial("SD2") + "' "
_Qry += "   and sd2.d_e_l_e_t_  = ' ' "
_Qry += "   and sc5.d_e_l_e_t_  = ' ' "
_Qry += "   and sed.d_e_l_e_t_  = ' ' "
if mv_par05 == 4
_Qry += " 	and sc5.c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
endif
if mv_par05 == 2
_Qry += "   and sed.ed_tipnat in ('3','4') "
endif
_Qry := ChangeQuery(_Qry)

TcQuery _Qry New Alias "TREP"

_nRep	:= iif( !TREP->(Bof()) .and. !TREP->(Eof()) , TREP->TOTAL , 0 )

TREP->(dbCloseArea())

If	SZ8->( dbSeek( xFilial("SZ8") + mv_par01 + mv_par02 + cTipo, .f. ))
	_lRet		:= .f.
	_cStatus	:= "R"  //Rec�lculo
Else
	_lRet		:= .t.
	_cStatus	:= "C"  //C�lculo
EndIf

if _cStatus == "R"

	cTmp	:=	"C�lculo Existente Para o Per�odo "

	cTxt	:=	Chr(10) + Chr(13)
	cTxt	+=	"O Faturamento L�quido Gravado � de : R$ " + Transform( SZ8->Z8_VALOR  , "@E 999,999,999.99" ) 	+ Chr(10) + Chr(13)
	cTxt	+=	"A Bonifica��o Gravada � de : R$ " + Transform( SZ8->Z8_BONIVOL , "@E 999,999,999.99" ) 			+ Chr(10) + Chr(13)
	cTxt	+=	"O Repasse Gravado � de : R$ " + Transform( SZ8->Z8_REPASSE , "@E 999,999,999.99" ) 				+ Chr(10) + Chr(13)	+ Chr(10) + Chr(13)
	cTxt	+=	"O Valor do C�lculo Atual foi de : R$ " + Transform( _nTotal , "@E 999,999,999.99" ) 				+ Chr(10) + Chr(13)
	cTxt	+=	"A Bonifica��o foi de : R$ " + Transform( mv_par03 , "@E 999,999,999.99" ) 							+ Chr(10) + Chr(13)
	cTxt	+=	"O Imposto PIS e COFINS foi de : R$ " + Transform( mv_par04 , "@E 99.99" ) 				+ Chr(10) + Chr(13)
//	cTxt	+=	"O Repasse Net foi de : R$ " + Transform( mv_par05 , "@E 999,999,999.99" ) 				+ Chr(10) + Chr(13)
	cTxt	+=	"O Repasse Calculado foi de : R$ " + Transform( _nRep , "@E 999,999,999.99" )

	if Aviso( "A T E N � � O ! ! !" , cTxt , { "Gravar" , "Sair" } , 3 , cTmp ) == 2
		Return
	endif
endif

//Grava o Faturamento mensal

RecLock("SZ8",_lRet)
	SZ8->Z8_MESANO 	:= mv_par01 + mv_par02
	SZ8->Z8_VALOR		:= _nTotal
	SZ8->Z8_REPASSE	:= _nRep
	SZ8->Z8_BONIVOL	:= mv_par03
	SZ8->Z8_IMPOSTO	:= mv_par04
//	SZ8->Z8_DESCNET	:= mv_par04
//	SZ8->Z8_REPNET	:= mv_par05
	SZ8->Z8_STATUS	:= _cStatus
//	SZ8->Z8_DESCOM	:= nTotBruto - _nTotal
	SZ8->Z8_TIPO	:= cTipo
MsUnlock()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Funcao   � GeraSX1  � Autor � Klaus S. Peres     � Data �  27/06/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera as Perguntas se nao existirem                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function ValidPerg()

Local	i
Local	j
Local	aRegs		:= {}
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PadR(cPerg,10)

aAdd(aRegs,{cPerg,"01","M�s de Refer�ncia:	","","","mv_ch1","C",02,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ano de Refer�ncia:	","","","mv_ch2","C",04,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","BV/DESC ou ABAT:	","","","mv_ch3","N",14,02,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","PIS e COFINS %:		","","","mv_ch4","N",05,02,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo comiss�o:		","","","mv_ch5","N",01,00,1,"C","","mv_par05","Geral","","","","","Varejo","","","","","Por Data","","","","","Teste","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Descontos ?","","","mv_ch4","N",14,02,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"05","Repasse Net ?","","","mv_ch5","N",14,02,0,"C","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.t.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next j
		MsUnlock()
	Endif
Next i

dbSelectArea(_sAlias)

Return
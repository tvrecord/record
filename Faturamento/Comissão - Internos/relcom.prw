#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELCOM   º Autor ³ Cristiano D. Alves º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relacao de comissoes para vendedores internos.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rede Record - Brasilia-DF                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterado  ³ Klaus Schneider Peres   / Valtenio Moura                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RELCOM()

	Local cDesc1			:= "Relação de Comissões Internas"
	Local cDesc2			:= "Este programa tem como objetivo imprimir relatório  "
	Local cDesc3			:= "de acordo com os parâmetros informados pelo usuário."
	Local cPict    	   		:= ""
	Local imprime   	   	:= .t.
	Local aOrd 				:= {}

	Private nLin         	:= 80
	Private titulo       	:= "Relação de Comissões Internas"
	Private Cabec1       	:= "CODIGO LJ CLIENTE                         NF-SERIE-PARC EMISSAO   VENCTO             SALDO  % AG.           VALOR  DT BAIXA"
	Private Cabec2       	:= ""
	Private lEnd        	:= .f.
	Private lAbortPrint		:= .f.
	Private CbTxt      		:= ""
	Private limite      	:= 132
	Private tamanho     	:= "M"
	Private nomeprog    	:= "RELCOM"
	Private nTipo       	:= 18
	Private aReturn     	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
	Private nLastKey    	:= 0
	Private cbtxt      		:= Space(10)
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "RELCOM"
	Private cPerg			:= "RELCON"
	Private _nBase 			:= 0
	Private	_aVend	   		:= {}
	Private	_aFaixa	   		:= {}
	Private	nPos	   		:= 0
	Private cString	   		:= "SE1"
	Private cNatSpot		:= ""
	Private nNatSpot		:= 0
	Private cRecSpot		:= ""
	Private nRecSpot		:= 0
	Private nSpotLoc 		:= 0
	Private nTipoC			:= ""
	Private cDtIniV			:= ""
	Private _aMeses 		:= {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}

	ValidPerg()

	Pergunte(cPerg,.t.)

	if	Len(Alltrim(mv_par24)) <> 7    			.or. ;
	Val(Substr(mv_par24,06,02)) < 01   		.or. ;
	Val(Substr(mv_par24,06,02)) > 12   		.or. ;
	Val(Substr(mv_par24,01,04)) < 2005		.or. ;
	Val(Substr(mv_par24,01,04)) > 2025

		Alert("Ajuste o Parâmetro de Ano/Mês de Gravação de Comissão")

	else

		if MV_PAR25 == 2 //Rafael França - Verifica o tipo da comissão
			nTipoC			:= "CV" //Comissao Varejo
		elseif MV_PAR25 == 1
			nTipoC			:= "CI" //Comissao Interna
		elseif MV_PAR25 == 3
			nTipoC			:= "CD" //Comissao com data de inicio
		elseif MV_PAR25 == 4
			nTipoC			:= "CT" //Comissao de Teste
		endif

		if MV_PAR07 == MV_PAR08
			titulo := UPPER("Comissão " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4) + " - " + Alltrim(Posicione("SA3",1,xFilial("SA3")+MV_PAR08,"A3_NREDUZ")))
			if !EMPTY(Posicione("SA3",1,xFilial("SA3")+MV_PAR08,"A3_DTINI"))
				cDtIniV	:= DTOS(Posicione("SA3",1,xFilial("SA3")+MV_PAR08,"A3_DTINI"))
			endif
		endif

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.t.,Tamanho,,.f.)

		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := iif( aReturn[4] == 1 , 15 , 18 )

		RptStatus( { || RunReport(Cabec1,Cabec2,Titulo,nLin) } , Titulo )
	endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Função auxiliar chamada pela RPTSTATUS. A Função RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local		nOrdem

	Private _cQuery
	Private _cTit			:= ""
	Private _aTitPend		:=	{}		// Incluido por Klaus em 31/05/07 - Separacao dos Titulos Inadimplentes
	Private _aTitulos		:= {}		// Esse Array Irah conter apenas os Titulos Inadimplentes Recebidos
	Private _aRecebe		:= {}
	Private _cMesAno		:= ""
	Private _nTotMes		:= 0
	Private _nTotGer		:= 0
	Private _nFat			:= 0
	Private _nValNf	   		:= 0
	Private _nRepas			:= 0
	Private _nImposto   	:= 0
	Private _nDescIm    	:= 0
	Private _cQueryspot		:= ""
	Private _cQueryRec		:= ""
	Private _nContrato	 	:= 0
	Private _cResumo		:= ""
	Private _E1_VALOR  		:= 0
	Private nValorIna		:= 0
	Private _nBaseCalc		:= 0

	if mv_par21 == 1	// Primeira Geracao no Mes
		if mv_par09 == 1	// Por Emissao
			_cTit	:= " - C L T - (Por Emissao)"
		else 					// Por Baixa
			_cTit	:= " - P J - (Por Baixa)"
		endif
	else					// Segunda Geracao no Mes
		if mv_par09 == 2	// Por Baixa
			_cTit	:= " - C L T - (Por Baixa)"
		else					// Por Emissao nao deve ser impresso o relatorio
			_cTit	:= ""
		endif
	endif

	Titulo += _cTit

	dbSelectArea("SZ8")
	dbSetOrder(1)

	If dbSeek( xFilial("SZ8") + Substr(DtoS(mv_par05),5,2) + Substr(DtoS(mv_par05),1,4) + nTipoC )
		_nFat		:= SZ8->Z8_VALOR
		_nBoniVl	:= SZ8->Z8_BONIVOL
		_nRepas	    := SZ8->Z8_REPASSE
		_nImposto   := SZ8->Z8_IMPOSTO
	Else
		_nFat 	:= 0
		_nBoniVl	:= 0
		_nRepas		:= 0
	EndIf

	SetRegua(RecCount())

	If mv_par09 == 2 // Por Baixa

		//Query de titulos não pagos - inadimplentes

		_cQuery := "select e1_prefixo,"
		_cQuery += "       e1_num,"
		_cQuery += "       e1_parcela,"
		_cQuery += "       e1_cliente,"
		_cQuery += "       e1_loja,"
		_cQuery += "       e1_emissao,"
		_cQuery += "       e1_vencto,"
		_cQuery += "       e1_vencrea,"
		_cQuery += "       e1_valor,"
		_cQuery += "       e1_vend1,"
		_cQuery += "       e1_naturez,"
		_cQuery += "       e1_baixa,"
		_cQuery += "       e1_comis1,"
		_cQuery += "       e1_naturez,"
		_cQuery += "       e1_tipo"
		_cQuery += " from " + 	RetSqlName("SE1")	+ " se1, "
		_cQuery +=           	RetSqlName("SC5")	+ " sc5,  "
		_cQuery += " sed010 sed  "
		_cQuery += " where e1_emissao BETWEEN '"	+ DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'"
		_cQuery += "   and e1_vencto  BETWEEN '"	+ DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
		//_cQuery += "   and E1_NATUREZ not LIKE '1101017%'"  // Rafael - Retira o faturamento spot para calculo
		_cQuery += "   and e1_baixa       = ' '"
		_cQuery += "   and e1_filial      = c5_filial and e1_filial = '01' " // Rafael França - Processa apenas filial 01
		_cQuery += "   and e1_pedido      = c5_num"
		_cQuery += "   and c5_calccom     = 'S'"
		_cQuery += "   and c5_repasse    <> 'S'"
		_cQuery += "   and ed_codigo      = e1_naturez   "
		if mv_par25 == 4
		_cQuery += " 	and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
		endif
		if mv_par25 == 2
			_cQuery += "   and sed.ed_tipnat   in ('3','4') "
		endif
		if cDtIniV <> ""
			_cQuery += " and se1.e1_emissao >= " + cDtIniV + " "
		endif
		_cQuery += "   and sed.d_e_l_e_t_ = ' '"
		_cQuery += "   and se1.d_e_l_e_t_ = ' '"
		_cQuery += "   and sc5.d_e_l_e_t_ = ' '"
		_cQuery += " order by e1_emissao, e1_prefixo, e1_num, e1_parcela"
		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "QRY1"

		Do While !QRY1->(Eof())

			SE1->(DbSeek(xFilial("SE1") + QRY1->E1_PREFIXO + QRY1->E1_NUM + QRY1->E1_PARCELA + QRY1->E1_TIPO))
			SA1->(DbSeek(xFilial("SA1") + QRY1->E1_CLIENTE + QRY1->E1_LOJA))

			_nSaldoTit := SaldoTit(SE1->E1_PREFIXO ,SE1->E1_NUM ,SE1->E1_PARCELA ,SE1->E1_TIPO ,SE1->E1_NATUREZ ,"R",SE1->E1_CLIENTE,1,Min(dDataBase,mv_par06),Min(dDataBase,mv_par06),SE1->E1_LOJA,xFilial("SE1"))

			IF ALLTRIM(QRY1->E1_NATUREZ) == '1101008' .OR. ALLTRIM(QRY1->E1_NATUREZ) == '1101050'   //.AND. QRY1->E1_NATUREZ <= '110101799' //  Rafael - Filtra titulos Receita spot

				IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559" // Rafael - 16/05/18 - Receita Spot apenas para o vendedor 000211

					aAdd(_aTitPend, {	QRY1->E1_PREFIXO	,;	// 01
					QRY1->E1_NUM		,;	// 02
					QRY1->E1_PARCELA	,;	// 03
					QRY1->E1_CLIENTE	,;	// 04
					QRY1->E1_LOJA		,;	// 05
					QRY1->E1_EMISSAO	,;	// 06
					QRY1->E1_VENCTO		,;	// 07
					QRY1->E1_VENCREA	,;	// 08
					(_nSaldoTit * 0.7 ) 	,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
					QRY1->E1_VEND1		,;	// 10
					QRY1->E1_BAIXA		,;	// 11
					QRY1->E1_COMIS1	,;	// 12
					(QRY1->E1_VALOR  * 0.7 )	})	// 13 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

				ENDIF

			ELSEIF  (QRY1->E1_NATUREZ >= '1101017' .AND. QRY1->E1_NATUREZ <= '110101799' .OR. ALLTRIM(QRY1->E1_NATUREZ) == "1101046")  .AND. QRY1->E1_EMISSAO <= "20170430" //  Rafael - Filtra titulos faturamento spot //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

				aAdd(_aTitPend, {	QRY1->E1_PREFIXO	,;	// 01
				QRY1->E1_NUM		,;	// 02
				QRY1->E1_PARCELA	,;	// 03
				QRY1->E1_CLIENTE	,;	// 04
				QRY1->E1_LOJA		,;	// 05
				QRY1->E1_EMISSAO	,;	// 06
				QRY1->E1_VENCTO		,;	// 07
				QRY1->E1_VENCREA	,;	// 08
				(_nSaldoTit * 0.3 ) 	,;	// 09
				QRY1->E1_VEND1		,;	// 10
				QRY1->E1_BAIXA		,;	// 11
				QRY1->E1_COMIS1	,;	// 12
				(QRY1->E1_VALOR  * 0.3 )	})	// 13

			ELSE

				aAdd(_aTitPend, {	QRY1->E1_PREFIXO	,;	// 01
				QRY1->E1_NUM		,;	// 02
				QRY1->E1_PARCELA	,;	// 03
				QRY1->E1_CLIENTE	,;	// 04
				QRY1->E1_LOJA		,;	// 05
				QRY1->E1_EMISSAO	,;	// 06
				QRY1->E1_VENCTO	,;	// 07
				QRY1->E1_VENCREA	,;	// 08
				_nSaldoTit			,;	// 09
				QRY1->E1_VEND1		,;	// 10
				QRY1->E1_BAIXA		,;	// 11
				QRY1->E1_COMIS1	,;	// 12
				QRY1->E1_VALOR	})	// 13

			ENDIF

			QRY1->(dbSkip())

		EndDo

		QRY1->(dbCloseArea())

		//Re
		_cQuery := " select e1_prefixo,"
		_cQuery += "        e1_num,"
		_cQuery += "        e1_parcela,"
		_cQuery += "        e1_cliente,"
		_cQuery += "        e1_loja,"
		_cQuery += "        e1_emissao,"
		_cQuery += "        e1_vencto,"
		_cQuery += "        e1_vencrea,"
		_cQuery += "        e1_valor,"
		_cQuery += "        e1_vend1,"
		_cQuery += "        e1_baixa,"
		_cQuery += "        e1_comis1,"
		_cQuery += "        e1_naturez,"
		_cQuery += "        e1_tipo"
		_cQuery += "  from " + RetSqlName("SE1")	+ " se1,"
		_cQuery +=             RetSqlName("SC5")	+ " sc5,"
		_cQuery += " sed010 sed  "
		_cQuery += "  where e1_emissao BETWEEN '"	+ DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'"
		_cQuery += "    and e1_vencto BETWEEN '"	+ DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
		_cQuery += "    and e1_baixa       > '"		+ DtoS(mv_par06) + "'"
		_cQuery += "    and e1_cancomi     <> 'S' " //Bruno - Comissao cancelada
		_cQuery += "    and e1_pedido      = c5_num and e1_filial = '01' " // Rafael França - Processa apenas filial 01
		_cQuery += "    and c5_calccom     = 'S'"
		_cQuery += "    and c5_repasse    <> 'S'"
		_cQuery += "   and ed_codigo      = e1_naturez   "
		if mv_par25 == 4
		_cQuery += " 	and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
		endif
		if mv_par25 == 2
			_cQuery += "   and sed.ed_tipnat   in ('3','4') "
		endif
		if cDtIniV <> ""
			_cQuery += "   and se1.e1_emissao >= " + cDtIniV + " "
		endif
		_cQuery += "   and sed.d_e_l_e_t_ = ' '"
		_cQuery += "    and se1.d_e_l_e_t_ = ' '"
		_cQuery += "    and sc5.d_e_l_e_t_ = ' '"
		_cQuery += "  order by e1_emissao, e1_prefixo, e1_num, e1_parcela"
		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "QRY2"

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSelectArea("SA1")
		DbSetOrder(1)

		Do While !QRY2->(EOF())

			SE1->(DbSeek(xFilial("SE1") + QRY2->E1_PREFIXO + QRY2->E1_NUM + QRY2->E1_PARCELA + QRY2->E1_TIPO))
			SA1->(DbSeek(xFilial("SA1") + QRY2->E1_CLIENTE + QRY2->E1_LOJA))

			_nSaldoTit := SaldoTit(SE1->E1_PREFIXO ,SE1->E1_NUM ,SE1->E1_PARCELA ,SE1->E1_TIPO ,SE1->E1_NATUREZ ,"R",SE1->E1_CLIENTE,1,Min(dDataBase,mv_par06),Min(dDataBase,mv_par06),SE1->E1_LOJA,xFilial("SE1"))

			//Verifica se o titulo sofreu baixa parcial
			If _nSaldoTit <> SE1->E1_VALOR .and. _nSaldoTit > 0
				_nSaldoTit := SaldoTit(SE1->E1_PREFIXO ,SE1->E1_NUM ,SE1->E1_PARCELA ,SE1->E1_TIPO ,SE1->E1_NATUREZ ,"R",SE1->E1_CLIENTE,1,Min(dDataBase,mv_par06),Min(dDataBase,mv_par06),SE1->E1_LOJA,xFilial("SE1")) - SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			Endif

			IF ALLTRIM(QRY2->E1_NATUREZ) == '1101008' .OR. ALLTRIM(QRY2->E1_NATUREZ) == '1101050'  // .AND. QRY2->E1_NATUREZ <= '110101799'

				IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559" // Rafael - 16/05/18 - Receita Spot apenas para o vendedor 000211

					aAdd(_aTitPend,{	QRY2->E1_PREFIXO	,;	// 01
					QRY2->E1_NUM		,;	// 02
					QRY2->E1_PARCELA	,;	// 03
					QRY2->E1_CLIENTE	,;	// 04
					QRY2->E1_LOJA		,;	// 05
					QRY2->E1_EMISSAO	,;	// 06
					QRY2->E1_VENCTO	,;	// 07
					QRY2->E1_VENCREA	,;	// 08
					(_nSaldoTit * 0.7)			,;	// 09
					QRY2->E1_VEND1		,;	// 10
					QRY2->E1_BAIXA		,;	// 11
					QRY2->E1_COMIS1	,;	// 12
					(QRY2->E1_VALOR * 0.7)	})	// 13

				ENDIF

			ELSEIF (QRY2->E1_NATUREZ >= '1101017' .AND. QRY2->E1_NATUREZ <= '110101799' .OR. ALLTRIM(QRY2->E1_NATUREZ) == '1101046') .AND. QRY2->E1_EMISSAO <= "20170430" //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores, a partir de 01/05/2017

				aAdd(_aTitPend,{	QRY2->E1_PREFIXO	,;	// 01
				QRY2->E1_NUM		,;	// 02
				QRY2->E1_PARCELA	,;	// 03
				QRY2->E1_CLIENTE	,;	// 04
				QRY2->E1_LOJA		,;	// 05
				QRY2->E1_EMISSAO	,;	// 06
				QRY2->E1_VENCTO	,;	// 07
				QRY2->E1_VENCREA	,;	// 08
				(_nSaldoTit * 0.3)			,;	// 09
				QRY2->E1_VEND1		,;	// 10
				QRY2->E1_BAIXA		,;	// 11
				QRY2->E1_COMIS1	,;	// 12
				(QRY2->E1_VALOR * 0.3)	})	// 13

			ELSE

				aAdd(_aTitPend,{	QRY2->E1_PREFIXO	,;	// 01
				QRY2->E1_NUM		,;	// 02
				QRY2->E1_PARCELA	,;	// 03
				QRY2->E1_CLIENTE	,;	// 04
				QRY2->E1_LOJA		,;	// 05
				QRY2->E1_EMISSAO	,;	// 06
				QRY2->E1_VENCTO	,;	// 07
				QRY2->E1_VENCREA	,;	// 08
				_nSaldoTit			,;	// 09
				QRY2->E1_VEND1		,;	// 10
				QRY2->E1_BAIXA		,;	// 11
				QRY2->E1_COMIS1	,;	// 12
				QRY2->E1_VALOR		})	// 13

			ENDIF

			QRY2->(dbSkip())

		EndDo

		QRY2->(dbCloseArea())

		//Query de inadimplentes RELCOM - BPARC
		_cQuery := "select e1_prefixo,"
		_cQuery += "       e1_num,"
		_cQuery += "       e1_parcela,"
		_cQuery += "       e1_cliente,"
		_cQuery += "       e1_loja,"
		_cQuery += "       e1_emissao,"
		_cQuery += "       e1_vencto,"
		_cQuery += "       e1_vencrea,"
		_cQuery += "       e1_saldo,"
		_cQuery += "       e1_vend1,"
		_cQuery += "       e1_baixa,"
		_cQuery += "       e1_comis1,"
		_cQuery += "       e1_naturez,"
		_cQuery += "       e1_tipo"
		_cQuery += "  from " + RetSqlName("SE1")	+ " se1,"
		_cQuery +=             RetSqlName("SC5")	+ " sc5,"
		_cQuery += " sed010 sed  "
		_cQuery += " where e1_emissao BETWEEN '"	+ DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'"
		_cQuery += "   and e1_vencto BETWEEN '"	+ DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
		_cQuery += "   and e1_baixa      <> ' '"
		_cQuery += "   and e1_cancomi     <> 'S' " //Bruno - Comissao cancelada
		_cQuery += "   and e1_filial = '01' "
		_cQuery += "   and e1_saldo       > 0"
		_cQuery += "   and e1_pedido      = c5_num"
		_cQuery += "   and c5_calccom     = 'S'"
		_cQuery += "   and c5_repasse    <> 'S'"
		_cQuery += "   and ed_codigo      = e1_naturez   "
		if mv_par25 == 4
		_cQuery += "   and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
		endif
		if mv_par25 == 2
			_cQuery += "   and sed.ed_tipnat   in ('3','4') "
		endif
		if cDtIniV <> ""
			_cQuery += "  and se1.e1_emissao >= " + cDtIniV + " "
		endif
		_cQuery += "   and sed.d_e_l_e_t_ = ' '"
		_cQuery += "   and se1.d_e_l_e_t_ = ' '"
		_cQuery += "   and sc5.d_e_l_e_t_ = ' '"
		_cQuery += "   and exists (select 1"
		_cQuery += "                 from " + RetSqlName("SE5")
		_cQuery += "                where e5_filial  = e1_filial and e1_filial = '01' " // Rafael França - Processa apenas filial 01
		_cQuery += "                  and e5_prefixo = e1_prefixo"
		_cQuery += "                  and e5_numero  = e1_num"
		_cQuery += "                  and e5_tipo    = e1_tipo"
		_cQuery += "                  and e5_parcela = e1_parcela"
		_cQuery += "                  and e5_clifor  = e1_cliente"
		_cQuery += "                  and e5_loja  = e1_loja"
		_cQuery += "                  and e5_data  <= '"	+ DtoS(mv_par06) + "' " //incluido pois na query acima sao considerados somente e1_baixa       > DtoS(mv_par06)
		_cQuery += "                  and d_e_l_e_t_ = ' ')"
		_cQuery += " order by e1_emissao, e1_prefixo, e1_num, e1_parcela"
		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "BPARC"

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSelectArea("SA1")
		DbSetOrder(1)

		Do While !BPARC->(EOF())

			SE1->(DbSeek(xFilial("SE1") + BPARC->E1_PREFIXO + BPARC->E1_NUM + BPARC->E1_PARCELA + BPARC->E1_TIPO))
			SA1->(DbSeek(xFilial("SA1") + BPARC->E1_CLIENTE + BPARC->E1_LOJA))

			_nSaldoTit 	:=	SaldoTit(SE1->E1_PREFIXO ,SE1->E1_NUM ,SE1->E1_PARCELA ,SE1->E1_TIPO ,SE1->E1_NATUREZ ,"R",SE1->E1_CLIENTE,1,Min(dDataBase,mv_par06),Min(dDataBase,mv_par06),SE1->E1_LOJA,xFilial("SE1"))

			_E1_VALOR	:=	SE1->E1_VALOR

			IF ALLTRIM(BPARC->E1_NATUREZ) == '1101008' .OR. ALLTRIM(BPARC->E1_NATUREZ) == '1101050' // .AND. BPARC->E1_NATUREZ <= '110101799'

				IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559" // Rafael - 16/05/18 - Receita Spot apenas para o vendedor 000211

					aAdd(_aTitPend,{	BPARC->E1_PREFIXO		,;	// 01
					BPARC->E1_NUM		,;	// 02
					BPARC->E1_PARCELA	,;	// 03
					BPARC->E1_CLIENTE	,;	// 04
					BPARC->E1_LOJA		,;	// 05
					BPARC->E1_EMISSAO	,;	// 06
					BPARC->E1_VENCTO	,;	// 07
					BPARC->E1_VENCREA	,;	// 08
					(_nSaldoTit *0.7)	,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
					BPARC->E1_VEND1		,;	// 10
					BPARC->E1_BAIXA		,;	// 11
					BPARC->E1_COMIS1	,;	// 12
					(_E1_VALOR * 0.7)			})	// 13  ESTAVA -->BPARC->E1_SALDO // ALTERADO POR VALTENIO 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

				ENDIF

			ELSEIF (BPARC->E1_NATUREZ >= '1101017' .AND. BPARC->E1_NATUREZ <= '110101799' .OR. ALLTRIM(BPARC->E1_NATUREZ) == '1101046') .AND. BPARC->E1_EMISSAO <= "20170430"

				aAdd(_aTitPend,{	BPARC->E1_PREFIXO		,;	// 01
				BPARC->E1_NUM		,;	// 02
				BPARC->E1_PARCELA	,;	// 03
				BPARC->E1_CLIENTE	,;	// 04
				BPARC->E1_LOJA		,;	// 05
				BPARC->E1_EMISSAO	,;	// 06
				BPARC->E1_VENCTO	,;	// 07
				BPARC->E1_VENCREA	,;	// 08
				(_nSaldoTit *0.3)	,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
				BPARC->E1_VEND1		,;	// 10
				BPARC->E1_BAIXA		,;	// 11
				BPARC->E1_COMIS1	,;	// 12
				(_E1_VALOR * 0.3)			})	// 13  ESTAVA -->BPARC->E1_SALDO // ALTERADO POR VALTENIO 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

			ELSE

				aAdd(_aTitPend,{	BPARC->E1_PREFIXO		,;	// 01
				BPARC->E1_NUM		,;	// 02
				BPARC->E1_PARCELA	,;	// 03
				BPARC->E1_CLIENTE	,;	// 04
				BPARC->E1_LOJA		,;	// 05
				BPARC->E1_EMISSAO	,;	// 06
				BPARC->E1_VENCTO	,;	// 07
				BPARC->E1_VENCREA	,;	// 08
				_nSaldoTit			,;	// 09
				BPARC->E1_VEND1		,;	// 10
				BPARC->E1_BAIXA		,;	// 11
				BPARC->E1_COMIS1	,;	// 12
				_E1_VALOR			})	// 13  ESTAVA -->BPARC->E1_SALDO // ALTERADO POR VALTENIO

			ENDIF

			BPARC->(dbSkip())

		EndDo

		BPARC->(dbCloseArea())

		if mv_par21 == 1 // Primeira Emissao do Relatorio - Inicio do Mes

			//Mensagem para informar quantidade de dias considerados no relatorio
			MsgInfo('Dias subtraidos do parametro "Ate Emissao ?" :  ' +  Alltrim(Str(F_ULTDIA(mv_par02))) + ' .';
			+ Chr(13) + Chr(10);
			+ 'Emissao ajustada :  ' + DTOC(mv_par02 - F_ULTDIA(mv_par02)) + ' .')

			//Seleciona titulos que foram baixados no periodo da comissao

			_cQuery := "select distinct"
			_cQuery += "       e1_prefixo,"
			_cQuery += "       e1_num,"
			_cQuery += "       e1_parcela,"
			_cQuery += "       e1_tipo,"
			_cQuery += "       e1_cliente,"
			_cQuery += "       e1_loja,"
			_cQuery += "       e1_emissao,"
			_cQuery += "       e1_vencto,"
			_cQuery += "       e1_vencrea,"
			_cQuery += "       e1_valor,"
			_cQuery += "       e1_vend1,"
			_cQuery += "       e1_baixa,"
			_cQuery += "       e1_comis1,"
			_cQuery += "       e1_naturez,"
			_cQuery += "       (select sum(e5_valor-e5_vlmulta - e5_vljuros)" // Retirar do valor recebido, o valor da multa, que tambem esta incorporado ao valor recebido
			_cQuery += "          from " + RetSqlName("SE5")
			_cQuery += "         where e5_filial  = e1_filial"
			_cQuery += "           and e5_prefixo = e1_prefixo"
			_cQuery += "           and e5_numero  = e1_num"
			_cQuery += "           and e5_parcela = e1_parcela"
			_cQuery += "           and e5_cliente = e1_cliente"
			_cQuery += "           and e5_loja    = e1_loja"
			_cQuery += "           and e5_data between '" + DtoS(mv_par05) + "' and '" + DtoS(mv_par06) + "'"
			_cQuery += "           and e5_tipodoc <> 'MT'" // Nao considerar Cobranca dos Juros
			_cQuery += "           and e5_situaca <> 'C'"  // Nao considerar movimentos cancelados
			_cQuery += "           and d_e_l_e_t_ = ' ') VALRECMES,"
			_cQuery += "       (e1_irrf+e1_csll+e1_pis+e1_cofins) VALIMP" // Valor dos Impostos para outra Tratativa (BackLog de Parametro errado anteriormente)
			_cQuery += "  from " + RetSqlName("SE1")	+ " se1,"
			_cQuery +=             RetSqlName("SC5")	+ " sc5,"
			_cQuery +=             RetSqlName("SE5")	+ " se5,"
			_cQuery += " sed010 sed  "
			//	_cQuery += " where se1.e1_emissao BETWEEN '"	+ DtoS(mv_par01) + "' and '" + DtoS(mv_par02 - 30) + "'"
			_cQuery += " where se1.e1_emissao BETWEEN '"	+ DtoS(mv_par01) + "' and '" + DtoS(mv_par02 - F_ULTDIA(mv_par02)) + "'"
			_cQuery += "   and se1.e1_vencto  BETWEEN '"	+ DtoS(mv_par03) + "' and '" + DtoS(mv_par04) + "'"
			_cQuery += "   and se1.e1_baixa   BETWEEN '"	+ DtoS(mv_par05) + "' and '" + DtoS(mv_par06) + "'"
			_cQuery += "   and se1.e1_baixa    > e1_vencrea"
			_cQuery += "   and se1.e1_cancomi     <> 'S' " //Bruno - Comissao cancelada
			_cQuery += "   and se1.e1_pedido   = c5_num"
			_cQuery += "   and sc5.c5_calccom  = 'S'"
			_cQuery += "   and sc5.c5_repasse  = 'N'"
			_cQuery += "   and se1.e1_filial   = '01'"
			_cQuery += "   and se5.e5_filial   = se1.e1_filial"
			_cQuery += "   and se5.e5_prefixo  = se1.e1_prefixo"
			_cQuery += "   and se5.e5_numero   = se1.e1_num"
			_cQuery += "   and se5.e5_parcela  = se1.e1_parcela"
			_cQuery += "   and se5.e5_cliente  = se1.e1_cliente"
			_cQuery += "   and se5.e5_loja     = se1.e1_loja"
			_cQuery += "   and se5.e5_tipodoc <> 'MT'"
			_cQuery += "   and se5.e5_situaca <> 'C'" // Nao considerar movimentos cancelados
			_cQuery += "   and ed_codigo      = e1_naturez   "
			if mv_par25 == 4
				_cQuery += " 	and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
			endif
			if mv_par25 == 2
				_cQuery += "   and sed.ed_tipnat   in ('3','4') "
			endif
			if cDtIniV <> ""
				_cQuery += "   and se1.e1_emissao >= " + cDtIniV + " "
			endif
			_cQuery += "   and sed.d_e_l_e_t_ = ' '"
			_cQuery += "   and se5.d_e_l_e_t_  = ' '"
			_cQuery += "   and se1.d_e_l_e_t_  = ' '"
			_cQuery += "   and sc5.d_e_l_e_t_  = ' '"
			_cQuery += " order by se1.e1_emissao, se1.e1_prefixo, se1.e1_num, se1.e1_parcela"
			_cQuery := ChangeQuery(_cQuery)

			TcQuery _cQuery New Alias "QRY3"

			Do While !QRY3->(EOF())

				//Calcula saldo das movimentacoes para a data
				nCalcTmp := 0
				SE5->(DbSetOrder(7))
				SE5->(DbSeek(xFilial("SE5")+QRY3->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)),.T.)
				Do While (xFilial("SE5")+QRY3->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

					If SE5->E5_TIPODOC $ "JR/MT/CM/D2/J2/M2/C2/V2/TL/TR/TE/RA" //"DC/JR/MT/CM/D2/J2/M2/C2/V2/TL/TR/TE/RA"
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_SITUACA $ "C/E/X"
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_DATA < mv_par05 .or. SE5->E5_DATA > mv_par06
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_RECPAG == "R"
						nCalcTmp += (SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->e5_vljuros)
					Else
						nCalcTmp -= (SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->e5_vljuros)
					Endif

					SE5->(DbSkip())
				EndDo


				if round(QRY3->E1_VALOR,2) == round(nCalcTmp,2)
					_nVal := round(QRY3->E1_VALOR,2)
				else
					if round(nCalcTmp,2) > QRY3->E1_VALOR // Se o Valor recebido no mes for maior que o Valor do Titulo, considero apenas o valor do titulo pois o resto são juros/impostos
						_nVal := round(QRY3->E1_VALOR,2)
					elseif  round(QRY3->VALIMP,2) + round(nCalcTmp,2) == round(QRY3->E1_VALOR,2) // Se verdadeiro, houve problemas na baixa, entao trata de outra forma aqui no relatorio.
						_nVal := round(QRY3->E1_VALOR,2)
					else
						_nVal := round(nCalcTmp,2)
					endif
				endif

				IF ALLTRIM(QRY3->E1_NATUREZ) == '1101008' .OR. ALLTRIM(QRY3->E1_NATUREZ) == '1101050'  // .AND. QRY3->E1_NATUREZ <= '110101799'

					IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559" // Rafael - 16/05/18 - Receita Spot apenas para o vendedor 000211

						aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
						QRY3->E1_NUM		,;	// 02
						QRY3->E1_PARCELA	,;	// 03
						QRY3->E1_CLIENTE	,;	// 04
						QRY3->E1_LOJA		,;	// 05
						QRY3->E1_EMISSAO	,;	// 06
						QRY3->E1_VENCTO	,;	// 07
						QRY3->E1_VENCREA	,;	// 08
						(_nVal	* 0.7)				,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
						QRY3->E1_VEND1		,;	// 10
						QRY3->E1_BAIXA		,;	// 11
						QRY3->E1_COMIS1	,;	// 12
						(QRY3->E1_VALOR	* 0.7)	})	// 13 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

					ENDIF

				ELSEIF (QRY3->E1_NATUREZ >= '1101017' .AND. QRY3->E1_NATUREZ <= '110101799' .OR. ALLTRIM(QRY3->E1_NATUREZ) == "1101046") .AND. QRY3->E1_EMISSAO <= "20170430"

					aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
					QRY3->E1_NUM		,;	// 02
					QRY3->E1_PARCELA	,;	// 03
					QRY3->E1_CLIENTE	,;	// 04
					QRY3->E1_LOJA		,;	// 05
					QRY3->E1_EMISSAO	,;	// 06
					QRY3->E1_VENCTO	,;	// 07
					QRY3->E1_VENCREA	,;	// 08
					(_nVal	* 0.3)				,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
					QRY3->E1_VEND1		,;	// 10
					QRY3->E1_BAIXA		,;	// 11
					QRY3->E1_COMIS1	,;	// 12
					(QRY3->E1_VALOR	* 0.3)	})	// 13 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

				ELSE

					aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
					QRY3->E1_NUM		,;	// 02
					QRY3->E1_PARCELA	,;	// 03
					QRY3->E1_CLIENTE	,;	// 04
					QRY3->E1_LOJA		,;	// 05
					QRY3->E1_EMISSAO	,;	// 06
					QRY3->E1_VENCTO	,;	// 07
					QRY3->E1_VENCREA	,;	// 08
					_nVal					,;	// 09
					QRY3->E1_VEND1		,;	// 10
					QRY3->E1_BAIXA		,;	// 11
					QRY3->E1_COMIS1	,;	// 12
					QRY3->E1_VALOR		})	// 13

				ENDIF

				QRY3->(dbSkip())

			EndDo
			QRY3->(dbCloseArea())

		else 	// Segunda Emissao do Relatorio - Fim do Mes

			// Altero para o mes Anterior para encontrar os titulos inadimplentes ate o mes anterior ao da consulta

			_nDtMes	:= iif(Month(mv_par02)-1 == 0, 12, Month(mv_par02)-1)
			_nDtAno	:= iif(Month(mv_par02)-1 == 0, Year(mv_par02)-1,Year(mv_par02) )
			_cData	:= strzero(_nDtAno,4) + strzero(_nDtMes,2) + "31"


			_cQuery := "select e1_prefixo,"
			_cQuery += "       e1_num,"
			_cQuery += "       e1_parcela,"
			_cQuery += "       e1_tipo,"
			_cQuery += "       e1_cliente,"
			_cQuery += "       e1_loja,"
			_cQuery += "       e1_emissao,"
			_cQuery += "       e1_vencto,"
			_cQuery += "       e1_vencrea,"
			_cQuery += "       e1_valor,"
			_cQuery += "       e1_vend1,"
			_cQuery += "       e1_baixa,"
			_cQuery += "       e1_comis1,"
			_cQuery += "       e1_naturez,"
			_cQuery += "       (select sum(e5_valor-e5_vlmulta-E5_VLJUROS) " //sum(e5_valor)" ALTERADO POR VALBERG
			_cQuery += "          from " + RetSqlName("SE5")
			_cQuery += "         where e5_filial  = e1_filial"
			_cQuery += "           and e5_prefixo = e1_prefixo"
			_cQuery += "           and e5_numero  = e1_num"
			_cQuery += "           and e5_parcela = e1_parcela"
			_cQuery += "           and e5_cliente = e1_cliente"
			_cQuery += "           and e5_loja    = e1_loja"
			_cQuery += "           and e5_data between '" + DtoS(mv_par05) + "' and '" + DtoS(mv_par06) + "'"
			_cQuery += "           and e5_tipodoc <> 'MT'"//INCLUIDO POR VALBERG
			_cQuery += "           and e5_situaca <> 'C'" //Nao considera movimentos cancelados
			_cQuery += "           and d_e_l_e_t_ = ' ') VALRECMES,"
			_cQuery += "       (e1_irrf+e1_csll+e1_pis+e1_cofins) VALIMP" // Valor dos Impostos para outra Tratativa (BackLog de Parametro errado anteriormente)
			_cQuery += " from " + RetSqlName("SE1")	+ " se1, " + RetSqlName("SC5") + " sc5, "
			_cQuery += " sed010 sed  "
			_cQuery += " where e1_emissao between '"	+ DtoS(mv_par01) + "' and '" + _cData 				+ "'"
			_cQuery += "   and e1_pedido      = c5_num "
			_cQuery += "   and e1_filial      = '01' "
			_cQuery += "   and e1_saldo       < e1_valor "
			_cQuery += "   and e1_cancomi     <> 'S' " //Bruno - Comissao cancelada
			_cQuery += "   and c5_calccom     = 'S' "
			_cQuery += "   and c5_repasse     = 'N' "
			_cQuery += "   and e1_pedido     <> ' ' "
			_cQuery += "   and ed_codigo      = e1_naturez   "
			if mv_par25 == 4
			_cQuery += " 	and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
			endif
			if mv_par25 == 2
				_cQuery += "   and sed.ed_tipnat   in ('3','4') "
			endif
			if cDtIniV <> ""
				_cQuery += "   and se1.e1_emissao >= " + cDtIniV + " "
			endif
			_cQuery += "   and sed.d_e_l_e_t_ = ' '"
			_cQuery += "   and se1.d_e_l_e_t_ = ' ' "
			_cQuery += "   and sc5.d_e_l_e_t_ = ' ' "
			_cQuery += "   and exists (select 1"
			_cQuery += "                 from " + RetSqlName("SE5")
			_cQuery += "                where e5_filial  = e1_filial"
			_cQuery += "                  and e5_prefixo = e1_prefixo"
			_cQuery += "                  and e5_numero  = e1_num"
			_cQuery += "                  and e5_tipo    = e1_tipo"
			_cQuery += "                  and e5_parcela = e1_parcela"
			_cQuery += "                  and e5_clifor  = e1_cliente"
			_cQuery += "                  and e5_loja  = e1_loja"
			_cQuery += "                  and e5_data between '" + DtoS(mv_par05) + "' and '" +  DtoS(mv_par06) + "' "
			_cQuery += "                  and d_e_l_e_t_ = ' ')"

			_cQuery := ChangeQuery(_cQuery)

			TcQuery _cQuery New Alias "QRY3"

			Do While !QRY3->(EOF())

				//Calcula saldo das movimentacoes para a data
				nCalcTmp := 0
				SE5->(DbSetOrder(7))
				SE5->(DbSeek(xFilial("SE5")+QRY3->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)),.T.)
				Do While (xFilial("SE5")+QRY3->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

					If SE5->E5_TIPODOC $ "JR/MT/CM/D2/J2/M2/C2/V2/TL/TR/TE/RA" //"DC/JR/MT/CM/D2/J2/M2/C2/V2/TL/TR/TE/RA"
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_SITUACA $ "C/E/X"
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_DATA < mv_par05 .or. SE5->E5_DATA > mv_par06
						SE5->(DbSkip())
						Loop
					Endif

					If SE5->E5_RECPAG == "R"
						nCalcTmp += (SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->e5_vljuros)
					Else
						nCalcTmp -= (SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->e5_vljuros)
					Endif

					SE5->(DbSkip())
				EndDo
				if round(QRY3->E1_VALOR,2) == round(nCalcTmp,2)
					_nVal := round(QRY3->E1_VALOR,2)
				else
					if round(nCalcTmp,2) > QRY3->E1_VALOR // Se o Valor recebido no mes for maior que o Valor do Titulo, considero apenas o valor do titulo pois o resto são juros/impostos
						_nVal := round(QRY3->E1_VALOR,2)
					elseif  round(QRY3->VALIMP,2) + round(nCalcTmp,2) == round(QRY3->E1_VALOR,2) // Se verdadeiro, houve problemas na baixa, entao trata de outra forma aqui no relatorio.
						_nVal := round(QRY3->E1_VALOR,2)
					else
						_nVal := round(nCalcTmp,2)
					endif
				endif

				IF ALLTRIM(QRY3->E1_NATUREZ) == '1101008' .OR. ALLTRIM(QRY3->E1_NATUREZ) == '1101050'  // .AND. QRY3->E1_NATUREZ <= '110101799'

					IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559" // Rafael - 16/05/18 - Receita Spot apenas para o vendedor 000211

						aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
						QRY3->E1_NUM		,;	// 02
						QRY3->E1_PARCELA	,;	// 03
						QRY3->E1_CLIENTE	,;	// 04
						QRY3->E1_LOJA		,;	// 05
						QRY3->E1_EMISSAO	,;	// 06
						QRY3->E1_VENCTO		,;	// 07
						QRY3->E1_VENCREA	,;	// 08
						(_nVal	* 0.7)		,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
						QRY3->E1_VEND1		,;	// 10
						QRY3->E1_BAIXA		,;	// 11
						QRY3->E1_COMIS1		,;	// 12
						(QRY3->E1_VALOR	* 0.7)	})	// 13 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

					ENDIF

				ELSEIF (QRY3->E1_NATUREZ >= '1101017' .AND. QRY3->E1_NATUREZ <= '110101799' .OR. ALLTRIM(QRY3->E1_NATUREZ) == "1101046") .AND. QRY3->E1_EMISSAO <= "20170430"

					aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
					QRY3->E1_NUM		,;	// 02
					QRY3->E1_PARCELA	,;	// 03
					QRY3->E1_CLIENTE	,;	// 04
					QRY3->E1_LOJA		,;	// 05
					QRY3->E1_EMISSAO	,;	// 06
					QRY3->E1_VENCTO		,;	// 07
					QRY3->E1_VENCREA	,;	// 08
					(_nVal	* 0.3)		,;	// 09 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores
					QRY3->E1_VEND1		,;	// 10
					QRY3->E1_BAIXA		,;	// 11
					QRY3->E1_COMIS1		,;	// 12
					(QRY3->E1_VALOR	* 0.3)	})	// 13 06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores


				ELSE

					aAdd(_aTitulos,{	QRY3->E1_PREFIXO	,;	// 01
					QRY3->E1_NUM		,;	// 02
					QRY3->E1_PARCELA	,;	// 03
					QRY3->E1_CLIENTE	,;	// 04
					QRY3->E1_LOJA		,;	// 05
					QRY3->E1_EMISSAO	,;	// 06
					QRY3->E1_VENCTO	    ,;	// 07
					QRY3->E1_VENCREA	,;	// 08
					_nVal				,;	// 09
					QRY3->E1_VEND1		,;	// 10
					QRY3->E1_BAIXA		,;	// 11
					QRY3->E1_COMIS1	    ,;	// 12
					QRY3->E1_VALOR		})	// 13

				ENDIF

				QRY3->(dbSkip())
			EndDo
			QRY3->(dbCloseArea())
		endif

		Imp_Inadim() 	// Imprime primeiro os Titulos Inadimplementes -- Comentado por Rafael Franca
		Imp_Recebi() 	// Imprime posteriormente os Titulos Recebidos que estavam inadimplentes no periodo informado nos parametros -- Comentado por Rafael Franca

	Else // Por Emissao

		_nTotal := 0

		_cQuery := "select d2_filial,"
		_cQuery += "       d2_serie,"
		_cQuery += "       d2_doc,"
		_cQuery += "       d2_pedido,"
		_cQuery += "       sum(d2_total) TOTAL,"
		_cQuery += "       c5_comis1,"
		_cQuery += "       c5_repasse,"
		_cQuery += "       d2_cliente,
		_cQuery += "       d2_loja,
		_cQuery += "       d2_emissao"
		_cQuery += "  from " + RetSqlName("SD2") + " sd2, " + RetSqlName("SC5") + " sc5, sed010 sed "
		_cQuery += " where d2_emissao between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "'"
		_cQuery += "   and d2_pedido      = c5_num"
		_cQuery += "   and d2_filial      = '01'"   //rafael
		_cQuery += "   and c5_calccom     = 'S'"
		_cQuery += "   and c5_filial      = '01'"  //rafael
		_cQuery += "   and c5_repasse    <> 'S'"
		_cQuery += "   and ed_codigo      = c5_naturez   "
		if mv_par25 == 4
		_cQuery += " 	and c5_naturez in ('1101007','110101701','110101702','1101046','1101050') "
		endif
		if mv_par25 == 2
			_cQuery += "   and sed.ed_tipnat   in ('3','4') "
		endif
		if cDtIniV <> ""
			_cQuery += "   and d2_emissao >= " + cDtIniV + " "
		endif
		_cQuery += "   and sed.d_e_l_e_t_ = ' '"
		_cQuery += "   and sd2.d_e_l_e_t_ = ' '"
		_cQuery += "   and sc5.d_e_l_e_t_ = ' '"
		_cQuery += " group by d2_filial, d2_serie, d2_doc, d2_pedido, c5_comis1, c5_repasse, d2_cliente, d2_loja, d2_emissao"
		_cQuery += " order by d2_filial, d2_serie, d2_doc"
		_cQuery := ChangeQuery(_cQuery)

		TcQuery _cQuery New Alias "EMI"

		Do While !EMI->(Eof())

			IncProc()

			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			If EMI->C5_COMIS1 > 0 .AND. EMI->C5_COMIS1 < 99.99															// Abato as comissoes dos vendedores externos
				//_nCom		:= Round(((EMI->TOTAL * EMI->C5_COMIS1)/100),2)		// Comissão Agencia (Externos)
				//_nValNf	:= Round((EMI->TOTAL - _nCom),2)  							// Base comissão Internos
				_nValNf 	:= EMI->TOTAL
			ElseIF EMI->C5_COMIS1 == 99.99
				_nValNf		:= 0
			ELSE																				// Caso nao tenha comissao, entra para o Faturamento Liquido.
				_nValNf 	:= EMI->TOTAL
			EndIf

			_nTotal += _nValNf //Recebe os valores para Faturamento Total

			@nLin,000 psay EMI->D2_CLIENTE																												// Codigo cliente
			@nLin,007 psay EMI->D2_LOJA																													// Loja cliente
			@nLin,010 psay substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+EMI->D2_CLIENTE+EMI->D2_LOJA,"A1_NOME")),1,30)	// Nome cliente
			@nLin,042 psay EMI->D2_DOC																														// Numero
			@nLin,049 psay EMI->D2_SERIE																													// Prefixo
			@nLin,053 psay ""																																	// Parcela
			@nLin,055 psay StoD(EMI->D2_EMISSAO)																										// Emissao
			@nLin,096 psay _nValNf Picture "@E 999,999,999.99"																						// Valor

			nLin ++

			dbSkip()
		EndDo

		@ ++ nLin,000 psay "TOTAL DO MES ----------------> "
		@    nLin,090 psay _nTotal Picture "@E 999,999,999.99"

		nLin ++

		EMI->(dbCloseArea())

	EndIf
	If mv_par09 == 1 // Emissao
		RatNat()    // Imprime rateio de natureza sobre o faturamento do mes -- Bruno Alves
	EndIf
	Resumo()		// Imprime o Resumo na ultima pagina
	if mv_par09 == 2
		ImpVend()	// Imprime a Comissao de cada vendedor dependendo do parametro escolhido (CLT ou PJ) -- Comentado por Rafael Franca
	Endif
	ImpDel()		// Imprime as Notas Deletadas no periodo
	ImpAssi()	// Imprime as Assinaturas
	ImpParam()	// Imprime a Pagina de parametros

	Set Device To Screen

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	Endif

	Ms_Flush()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Resumo   º Autor ³                    º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Impressao do Resumo da Comissao                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RatNat()

	Local _cQuery := ""
	Local nTotal  := 0
	Local nNat 	  := 0
	Local cNat 	  := ""
	Local cDesc   := ""

	_cQuery := "SELECT C5_FILIAL AS FILIAL, C5_NATUREZ AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(E1_VALOR) AS TOTAL FROM SC5010 "
	_cQuery += "INNER JOIN SF2010 ON "
	_cQuery += "C5_FILIAL = F2_FILIAL AND "
	_cQuery += "C5_CLIENTE = F2_CLIENTE AND "
	_cQuery += "C5_LOJACLI = F2_LOJA AND "
	_cQuery += "C5_NOTA = F2_DOC AND "
	_cQuery += "C5_SERIE = F2_SERIE "
	_cQuery += "INNER JOIN SE1010 ON "
	_cQuery += "C5_FILIAL = E1_FILIAL AND "
	_cQuery += "C5_CLIENTE = E1_CLIENTE AND "
	_cQuery += "C5_LOJACLI = E1_LOJA AND "
	_cQuery += "C5_NOTA = E1_NUM AND "
	_cQuery += "C5_SERIE = E1_SERIE "
	_cQuery += "INNER JOIN SED010 ON "
	_cQuery += "C5_NATUREZ = ED_CODIGO "
	_cQuery += "WHERE "
	_cQuery += "F2_EMISSAO between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' AND "
	_cQuery += "C5_FILIAL    = '01'   AND "
	_cQuery += "C5_CALCCOM   = 'S'   AND "
	_cQuery += "C5_REPASSE   <> 'S'   AND "
	_cQuery += "E1_MULTNAT <> '1' AND "
	if mv_par25 == 4
		_cQuery += " AND C5_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') "
	endif
	if mv_par25 == 2
		_cQuery += "ED_TIPNAT IN ('3','4') AND "
	endif
	if cDtIniV <> ""
		_cQuery += "  F2_EMISSAO >= " + cDtIniV + " AND "
	endif
	_cQuery += "SC5010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SF2010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SE1010.D_E_L_E_T_ <> '*' "
	_cQuery += "GROUP BY C5_FILIAL, C5_NATUREZ, ED_DESCRIC "

	_cQuery += "UNION "

	_cQuery += "SELECT C5_FILIAL AS FILIAL, EV_NATUREZ AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(EV_VALOR) AS TOTAL FROM SC5010 "
	_cQuery += "INNER JOIN SF2010 ON "
	_cQuery += "C5_FILIAL = F2_FILIAL AND "
	_cQuery += "C5_CLIENTE = F2_CLIENTE AND "
	_cQuery += "C5_LOJACLI = F2_LOJA AND "
	_cQuery += "C5_NOTA = F2_DOC AND "
	_cQuery += "C5_SERIE = F2_SERIE "
	_cQuery += "INNER JOIN SEV010 ON "
	_cQuery += "C5_FILIAL = EV_FILIAL AND "
	_cQuery += "C5_CLIENTE = EV_CLIFOR AND "
	_cQuery += "C5_LOJACLI = EV_LOJA AND "
	_cQuery += "C5_NOTA = EV_NUM AND "
	_cQuery += "C5_SERIE = EV_PREFIXO "
	_cQuery += "INNER JOIN SED010 ON "
	_cQuery += "EV_NATUREZ = ED_CODIGO "
	_cQuery += "WHERE "
	_cQuery += "F2_EMISSAO between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' AND "
	_cQuery += "C5_FILIAL    = '01'   AND "
	_cQuery += "C5_CALCCOM   = 'S'   AND "
	_cQuery += "C5_REPASSE   <> 'S'   AND "
	_cQuery += "EV_RECPAG = 'R' AND "
	if mv_par25 == 4
		_cQuery += " AND EV_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') "
	endif
	if mv_par25 == 2
		_cQuery += "ED_TIPNAT IN ('3','4') AND "
	endif
	if cDtIniV <> ""
		_cQuery += "  F2_EMISSAO >= " + cDtIniV + " AND "
	endif
	_cQuery += "SC5010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SF2010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "SEV010.D_E_L_E_T_ <> '*' "
	_cQuery += "GROUP BY C5_FILIAL, EV_NATUREZ, ED_DESCRIC "
	_cQuery += "ORDER BY NATUREZ "
	_cQuery := ChangeQuery(_cQuery)

	TcQuery _cQuery New Alias "NAT"

	Cabec(titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

	nLin := 8

	DBSelectArea("NAT")
	DBGotop()

	@nLin,000 psay "APURACAO DO FATURAMENTO - COMISSAO PJ"
	nLin++
	nLin++

	While !EOF()

		IF ALLTRIM(NAT->NATUREZ) == "1101008" .OR. ALLTRIM(NAT->NATUREZ) == "1101050"
			IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559"
				nNat  := NAT->TOTAL * 0.7
			ELSE
				nNat  := 0
			ENDIF
		ELSE
			nNat  := NAT->TOTAL
		ENDIF
		cNat  := NAT->NATUREZ
		IF ALLTRIM(NAT->NATUREZ) == "1101008" .OR. ALLTRIM(NAT->NATUREZ) == "1101050"
			cDesc := ALLTRIM(NAT->DESCRIC) + " 70%"
		ELSE
			cDesc := NAT->DESCRIC
		ENDIF

		DbSkip()

		If cNat == NAT->NATUREZ
			IF ALLTRIM(NAT->NATUREZ) == "1101008" .OR. ALLTRIM(NAT->NATUREZ) == "1101050"
				IF MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559"
					nNat += NAT->TOTAL * 0.7
				ELSE
					nNat += 0
				ENDIF
			ELSE
				nNat += NAT->TOTAL
			ENDIF
			DBSkip()
		EndIf

		IF nNat <> 0
			@nLin,000 psay cDesc
			@nLin,045 psay nNat Picture "@E 999,999,999.99"	+ " (+)"
		ENDIF
		nLin++

		nTotal += nNat

		//ENDIF

	EndDo

	DBSelectARea("NAT")
	DBCloseArea("NAT")

	nLin ++
	@nLin,000 psay "TOTAL ---->"
	@nLin,045 psay nTotal Picture "@E 999,999,999.99" + " (T)"
	@ ++ nLin, 000 psay Replicate("-",132)
	nLin += 2

Return

Static Function Resumo()

	Local _nRecebe 	:= 0
	Local _nInadip 	:= 0
	Local aArea		:=	SZ8->(GetArea())
	Local nTotNat 	:= 0
	Local nTotPend 	:= 0
	Local _cQuerySpot := ""
	Local nComiss20 := 0

	If mv_par09 == 2 // Emissao
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

		nLin := 8
	EndIf

	_cMesIni	:= Alltrim(StrZero((Month(mv_par05)-1),2))
	_cMesFim	:= Alltrim(StrZero((Month(mv_par06)-1),2))
	_cAnoIni	:= Year(mv_par05)
	_cAnoFim	:= Year(mv_par06)

	If _cMesIni == "00"
		_cMesIni	:= "12"
		_cAnoIni := ( _cAnoIni - 1 )
	EndIf

	If _cMesFim == "00"
		_cMesFim	:= "12"
		_cAnoFim := ( _cAnoFim - 1 )
	EndIf

	_cMesRep := _aMeses[Val(_cMesIni)]



	If mv_par09 == 2 // Por Baixa

		IF mv_par25 <> 2 // Não executar apenas quando for comissao de varejo.

			_cQuerySpot := "SELECT C5_FILIAL AS FILIAL, SUBSTRING(C5_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(E1_VALOR) AS TOTAL FROM SC5010 "
			_cQuerySpot += "INNER JOIN SF2010 ON "
			_cQuerySpot += "C5_FILIAL = F2_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = F2_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = F2_LOJA AND "
			_cQuerySpot += "C5_NOTA = F2_DOC AND "
			_cQuerySpot += "C5_SERIE = F2_SERIE "
			_cQuerySpot += "INNER JOIN SE1010 ON "
			_cQuerySpot += "C5_FILIAL = E1_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = E1_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = E1_LOJA AND "
			_cQuerySpot += "C5_NOTA = E1_NUM AND "
			_cQuerySpot += "C5_SERIE = E1_SERIE "
			_cQuerySpot += "INNER JOIN SED010 ON "
			_cQuerySpot += "SUBSTRING(C5_NATUREZ,1,7) = ED_CODIGO "
			_cQuerySpot += "WHERE "
			_cQuerySpot += "SUBSTRING(C5_NATUREZ,1,7) IN ('1101017','1101046') AND SUBSTRING(E1_NATUREZ,1,7) IN ('1101017','1101046')  AND "
			_cQuerySpot += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' and "
	if mv_par25 == 4
		_cQuerySpot += " C5_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
	endif
			IF cDtIniV <> ""
				_cQuerySpot += "F2_EMISSAO >= " + cDtIniV + " AND "
			ENDIF
			_cQuerySpot += "C5_FILIAL    = '01'   AND "
			_cQuerySpot += "C5_CALCCOM   = 'S'   AND "
			_cQuerySpot += "C5_REPASSE   <> 'S'   AND "
			_cQuerySpot += "E1_MULTNAT <> '1' AND "
			_cQuerySpot += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SE1010.D_E_L_E_T_ <> '*' "
			_cQuerySpot += "GROUP BY C5_FILIAL, SUBSTRING(C5_NATUREZ,1,7), ED_DESCRIC "

			_cQuerySpot += "UNION "
			// Union com dados de titulos com rateio SEV
			_cQuerySpot += "SELECT C5_FILIAL AS FILIAL, SUBSTRING(EV_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(EV_VALOR) AS TOTAL FROM SC5010 "
			_cQuerySpot += "INNER JOIN SF2010 ON "
			_cQuerySpot += "C5_FILIAL = F2_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = F2_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = F2_LOJA AND "
			_cQuerySpot += "C5_NOTA = F2_DOC AND "
			_cQuerySpot += "C5_SERIE = F2_SERIE "
			_cQuerySpot += "INNER JOIN SEV010 ON "
			_cQuerySpot += "C5_FILIAL = EV_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = EV_CLIFOR AND "
			_cQuerySpot += "C5_LOJACLI = EV_LOJA AND "
			_cQuerySpot += "C5_NOTA = EV_NUM AND "
			_cQuerySpot += "C5_SERIE = EV_PREFIXO "
			_cQuerySpot += "INNER JOIN SED010 ON "
			_cQuerySpot += "SUBSTRING(EV_NATUREZ,1,7) = ED_CODIGO "
			_cQuerySpot += "WHERE "
			_cQuerySpot += "SUBSTRING(EV_NATUREZ,1,7) IN ('1101017','1101046') AND "
			_cQuerySpot += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' AND "
			if mv_par25 == 4
				_cQuerySpot += " EV_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
			endif
			IF cDtIniV <> ""
				_cQuerySpot += "F2_EMISSAO >= " + cDtIniV + " AND "
			ENDIF
			//_cQuerySpot += "F2_EMISSAO between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' AND "
			_cQuerySpot += "C5_FILIAL    = '01'   AND "
			_cQuerySpot += "C5_CALCCOM   = 'S'   AND "
			_cQuerySpot += "C5_REPASSE   <> 'S'   AND "
			_cQuerySpot += "EV_RECPAG = 'R' AND "
			_cQuerySpot += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SEV010.D_E_L_E_T_ <> '*' "
			_cQuerySpot += "GROUP BY C5_FILIAL, SUBSTRING(EV_NATUREZ,1,7), ED_DESCRIC "
			_cQuerySpot += "ORDER BY NATUREZ "
			_cQuerySpot := ChangeQuery(_cQuerySpot)

			TcQuery _cQuerySpot New Alias "QSPOT"

			If Eof()

				dbSelectArea("QSPOT")
				dbCloseArea("QSPOT")

			ELSE

				DBSelectArea("QSPOT")
				DBGotop()
				While !EOF()

					nNatSpot += QSPOT->TOTAL

					QSPOT->(dbSkip())
				ENDDO

				dbSelectArea("QSPOT")
				dbCloseArea("QSPOT")

			ENDIF

			_cQueryRec := "SELECT C5_FILIAL AS FILIAL, SUBSTRING(C5_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(E1_VALOR) AS TOTAL FROM SC5010 "
			_cQueryRec += "INNER JOIN SF2010 ON "
			_cQueryRec += "C5_FILIAL = F2_FILIAL AND "
			_cQueryRec += "C5_CLIENTE = F2_CLIENTE AND "
			_cQueryRec += "C5_LOJACLI = F2_LOJA AND "
			_cQueryRec += "C5_NOTA = F2_DOC AND "
			_cQueryRec += "C5_SERIE = F2_SERIE "
			_cQueryRec += "INNER JOIN SE1010 ON "
			_cQueryRec += "C5_FILIAL = E1_FILIAL AND "
			_cQueryRec += "C5_CLIENTE = E1_CLIENTE AND "
			_cQueryRec += "C5_LOJACLI = E1_LOJA AND "
			_cQueryRec += "C5_NOTA = E1_NUM AND "
			_cQueryRec += "C5_SERIE = E1_SERIE "
			_cQueryRec += "INNER JOIN SED010 ON "
			_cQueryRec += "SUBSTRING(C5_NATUREZ,1,7) = ED_CODIGO "
			_cQueryRec += "WHERE "
			_cQueryRec += "SUBSTRING(C5_NATUREZ,1,7) IN ('1101008','1101050') AND "
			_cQueryRec += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' and "
			_cQueryRec += "C5_FILIAL    = '01'   AND "
			_cQueryRec += "C5_CALCCOM   = 'S'   AND "
			_cQueryRec += "C5_REPASSE   <> 'S'   AND "
			_cQueryRec += "E1_MULTNAT <> '1' AND "
			if mv_par25 == 4
				_cQueryRec += " C5_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
			endif
			if mv_par25 == 2
				_cQueryRec += "ED_TIPNAT IN ('3','4') AND "
			endif
			IF cDtIniV <> ""
				_cQueryRec += "F2_EMISSAO >= " + cDtIniV + " AND "
			ENDIF
			_cQueryRec += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SE1010.D_E_L_E_T_ <> '*' "
			_cQueryRec += "GROUP BY C5_FILIAL, SUBSTRING(C5_NATUREZ,1,7), ED_DESCRIC "

			_cQueryRec += "UNION "

			_cQueryRec += "SELECT C5_FILIAL AS FILIAL, SUBSTRING(EV_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(EV_VALOR) AS TOTAL FROM SC5010 "
			_cQueryRec += "INNER JOIN SF2010 ON "
			_cQueryRec += "C5_FILIAL = F2_FILIAL AND "
			_cQueryRec += "C5_CLIENTE = F2_CLIENTE AND "
			_cQueryRec += "C5_LOJACLI = F2_LOJA AND "
			_cQueryRec += "C5_NOTA = F2_DOC AND "
			_cQueryRec += "C5_SERIE = F2_SERIE "
			_cQueryRec += "INNER JOIN SEV010 ON "
			_cQueryRec += "C5_FILIAL = EV_FILIAL AND "
			_cQueryRec += "C5_CLIENTE = EV_CLIFOR AND "
			_cQueryRec += "C5_LOJACLI = EV_LOJA AND "
			_cQueryRec += "C5_NOTA = EV_NUM AND "
			_cQueryRec += "C5_SERIE = EV_PREFIXO "
			_cQueryRec += "INNER JOIN SED010 ON "
			_cQueryRec += "SUBSTRING(EV_NATUREZ,1,7) = ED_CODIGO "
			_cQueryRec += "WHERE "
			_cQueryRec += "SUBSTRING(EV_NATUREZ,1,7) IN ('1101008','1101050') AND "
			_cQueryRec += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' and "
			if mv_par25 == 4
				_cQueryRec += " EV_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
			endif
			IF cDtIniV <> ""
				_cQueryRec += "F2_EMISSAO >= " + cDtIniV + " AND "
			ENDIF
			//_cQueryRec += "F2_EMISSAO between '" + DtoS(mv_par01) + "' and '" + DtoS(mv_par02) + "' AND "
			_cQueryRec += "C5_FILIAL    = '01'   AND "
			_cQueryRec += "C5_CALCCOM   = 'S'   AND "
			_cQueryRec += "C5_REPASSE   <> 'S'   AND "
			_cQueryRec += "EV_RECPAG = 'R' AND "
			if mv_par25 == 2
				_cQueryRec += "ED_TIPNAT IN ('3','4') AND "
			endif
			_cQueryRec += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQueryRec += "SEV010.D_E_L_E_T_ <> '*' "
			_cQueryRec += "GROUP BY C5_FILIAL, SUBSTRING(EV_NATUREZ,1,7), ED_DESCRIC "
			_cQueryRec += "ORDER BY NATUREZ "
			_cQueryRec := ChangeQuery(_cQueryRec)

			TcQuery _cQueryRec New Alias "QREC"

			If Eof()

				dbSelectArea("QREC")
				dbCloseArea("QREC")

			ELSE

				DBSelectArea("QREC")
				DBGotop()
				While !EOF()

					nRecSpot += QREC->TOTAL

					QREC->(dbSkip())
				ENDDO

				dbSelectArea("QREC")
				dbCloseArea("QREC")

			ENDIF

		ELSE

			_cQuerySpot := "SELECT C5_FILIAL AS FILIAL, SUBSTRING(C5_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(E1_VALOR) AS TOTAL FROM SC5010 "
			_cQuerySpot += "INNER JOIN SF2010 ON "
			_cQuerySpot += "C5_FILIAL = F2_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = F2_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = F2_LOJA AND "
			_cQuerySpot += "C5_NOTA = F2_DOC AND "
			_cQuerySpot += "C5_SERIE = F2_SERIE "
			_cQuerySpot += "INNER JOIN SE1010 ON "
			_cQuerySpot += "C5_FILIAL = E1_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = E1_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = E1_LOJA AND "
			_cQuerySpot += "C5_NOTA = E1_NUM AND "
			_cQuerySpot += "C5_SERIE = E1_SERIE "
			_cQuerySpot += "INNER JOIN SED010 ON "
			_cQuerySpot += "SUBSTRING(C5_NATUREZ,1,7) = ED_CODIGO "
			_cQuerySpot += "WHERE "
			_cQuerySpot += "C5_NATUREZ IN ('1101017') AND E1_NATUREZ IN ('1101017')  AND "
			if mv_par25 == 4
				_cQuerySpot += " C5_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
			endif
			_cQuerySpot += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' AND "
			_cQuerySpot += "C5_FILIAL    = '01'   AND "
			_cQuerySpot += "C5_CALCCOM   = 'S'   AND "
			_cQuerySpot += "C5_REPASSE   <> 'S'   AND "
			_cQuerySpot += "E1_MULTNAT <> '1' AND "
			_cQuerySpot += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SE1010.D_E_L_E_T_ <> '*' "
			_cQuerySpot += "GROUP BY C5_FILIAL, SUBSTRING(C5_NATUREZ,1,7), ED_DESCRIC "

			_cQuerySpot += "UNION "

			_cQuerySpot += "SELECT C5_FILIAL AS FILIAL, SUBSTRING(EV_NATUREZ,1,7) AS NATUREZ, ED_DESCRIC AS DESCRIC, SUM(EV_VALOR) AS TOTAL FROM SC5010 "
			_cQuerySpot += "INNER JOIN SF2010 ON "
			_cQuerySpot += "C5_FILIAL = F2_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = F2_CLIENTE AND "
			_cQuerySpot += "C5_LOJACLI = F2_LOJA AND "
			_cQuerySpot += "C5_NOTA = F2_DOC AND "
			_cQuerySpot += "C5_SERIE = F2_SERIE "
			_cQuerySpot += "INNER JOIN SEV010 ON "
			_cQuerySpot += "C5_FILIAL = EV_FILIAL AND "
			_cQuerySpot += "C5_CLIENTE = EV_CLIFOR AND "
			_cQuerySpot += "C5_LOJACLI = EV_LOJA AND "
			_cQuerySpot += "C5_NOTA = EV_NUM AND "
			_cQuerySpot += "C5_SERIE = EV_PREFIXO "
			_cQuerySpot += "INNER JOIN SED010 ON "
			_cQuerySpot += "SUBSTRING(EV_NATUREZ,1,7) = ED_CODIGO "
			_cQuerySpot += "WHERE "
			_cQuerySpot += "EV_NATUREZ IN ('1101017') AND "
			if mv_par25 == 4
				_cQuerySpot += " EV_NATUREZ IN ('1101007','110101701','110101702','1101046','1101050') AND "
			endif
			_cQuerySpot += "SUBSTRING(F2_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' AND "
			_cQuerySpot += "C5_FILIAL    = '01'   AND "
			_cQuerySpot += "C5_CALCCOM   = 'S'   AND "
			_cQuerySpot += "C5_REPASSE   <> 'S'   AND "
			_cQuerySpot += "EV_RECPAG = 'R' AND "
			_cQuerySpot += "SC5010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SF2010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SED010.D_E_L_E_T_ <> '*' AND "
			_cQuerySpot += "SEV010.D_E_L_E_T_ <> '*' "
			_cQuerySpot += "GROUP BY C5_FILIAL, SUBSTRING(EV_NATUREZ,1,7), ED_DESCRIC "
			_cQuerySpot += "ORDER BY NATUREZ "
			_cQuerySpot := ChangeQuery(_cQuerySpot)

			TcQuery _cQuerySpot New Alias "QSPOT"

			If Eof()

				dbSelectArea("QSPOT")
				dbCloseArea("QSPOT")

			ELSE

				DBSelectArea("QSPOT")
				DBGotop()
				While !EOF()

					nSpotLoc += QSPOT->TOTAL

					QSPOT->(dbSkip())
				ENDDO

				dbSelectArea("QSPOT")
				dbCloseArea("QSPOT")

			ENDIF

		ENDIF

		_nFat := _nFat - nNatSpot - nRecSpot - nSpotLoc

		@nLin,000 psay "M E T A   P A R A   A P U R A Ç Ã O"

		nLin += 2

		@nLin,000 psay "FATURAMENTO LIQUIDO " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
		@nLin,055 psay "-------->"
		@nLin,065 psay _nFat Picture "@E 999,999,999.99" + " (+)"

		nLin ++

		IF nNatSpot > 0

			@nLin,000 psay "FATURAMENTO SPOT 100% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
			@nLin,055 psay "-------->"
			@nLin,065 psay nNatSpot Picture "@E 999,999,999.99" + " (+)"

			nLin ++

		ENDIF

		IF MV_PAR25 == 2 .AND. nSpotLoc > 0

			@nLin,000 psay "FATURAMENTO SPOT LOCAL " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
			@nLin,055 psay "-------->"
			@nLin,065 psay nSpotLoc Picture "@E 999,999,999.99" + " (+)"

			nLin ++

		ENDIF

		IF (MV_PAR07 == "000211" .AND. MV_PAR08 == "000211" .OR. MV_PAR07 == "000559" .AND. MV_PAR08 == "000559") .AND. nRecSpot <> 0

			@nLin,000 psay "REC. SPOT / ESPAÇO CEDIDO 70% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
			@nLin,055 psay "-------->"
			@nLin,065 psay (nRecSpot * 0.7) Picture "@E 999,999,999.99" + " (+)"

			nLin ++

		ELSE

			nRecSpot := 0

		ENDIF

		@nLin,000 psay "TOTAL "
		@nLin,055 psay "-------->"
		@nLin,065 psay  _nFat + nSpotLoc + nNatSpot + (nRecSpot * 0.7) Picture "@E 999,999,999.99" + " (+)"

		nLin ++

		@ ++ nLin, 000 psay Replicate("-",132)

		nLin += 2

		@nLin,000 psay "R E S U M O  C O M I S S A O"

		nLin += 2
		if mv_par10 == 1

			@nLin,000 psay "FATURAMENTO LIQUIDO " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
			@nLin,055 psay "-------->"
			@nLin,065 psay _nFat Picture "@E 999,999,999.99" + " (+)"

			IF nNatSpot <> 0

				nLin ++

				@nLin,000 psay "FATURAMENTO SPOT - 100% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay (nNatSpot * 1) Picture "@E 999,999,999.99" + " (+)"  //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

			ENDIF

			IF nRecSpot <> 0

				nLin ++

				@nLin,000 psay "REC. SPOT / ESPAÇO CEDIDO - 70% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay (nRecSpot * 0.7) Picture "@E 999,999,999.99" + " (+)"  //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn pagamento de 70% Receita spot para o vendedor 000211

			ENDIF

			IF MV_PAR25 == 2 .AND. nSpotLoc > 0

				@nLin,000 psay "FATURAMENTO SPOT LOCAL " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay nSpotLoc Picture "@E 999,999,999.99" + " (+)"

				nLin ++

			ENDIF

			nLin ++

			@nLin,000 psay "REPASSE " + _cMesRep + "/" + Alltrim(Str(_cAnoIni))
			@nLin,055 psay "-------->"
			@nLin,065 psay _nRepas Picture "@E 999,999,999.99" + " (+)"


		ELSE

			@nLin,000 psay "FATURAMENTO LIQUIDO " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
			@nLin,055 psay "-------->"
			@nLin,065 psay _nFat Picture "@E 999,999,999.99" + " (+)"

			IF nNatSpot <> 0

				nLin ++

				@nLin,000 psay "FATURAMENTO SPOT - 100% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay (nNatSpot * 1) Picture "@E 999,999,999.99" + " (+)"  //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

			ENDIF

			IF nRecSpot <> 0

				nLin ++

				@nLin,000 psay "REC. SPOT / ESPAÇO CEDIDO - 70% " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay (nRecSpot * 0.7) Picture "@E 999,999,999.99" + " (+)"  //06/06/2017 - Rafael França - Alterado a pedido de Sra. Elenn de 30% para 100% para todos os vendedores

			ENDIF

			IF MV_PAR25 == 2 .AND. nSpotLoc > 0

				nLin ++

				@nLin,000 psay "FATURAMENTO SPOT LOCAL " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4)
				@nLin,055 psay "-------->"
				@nLin,065 psay nSpotLoc Picture "@E 999,999,999.99" + " (+)"

			ENDIF

		ENDIF

		nLin ++

		IF MV_PAR09 == 2

			_cQuery := "SELECT SUM((E1_VALOR * (E1_COMIS1/100))) AS COMISSAO  FROM SE1010 WHERE "
			_cQuery += "E1_COMIS1 <> 0 AND "
			_cQuery += "E1_FILIAL = '01' AND "
			_cQuery += "SUBSTRING(E1_EMISSAO,1,6) = '" + SUBSTR(MV_PAR24,1,4) + SUBSTR(MV_PAR24,6,2) + "' AND "
			_cQuery += "D_E_L_E_T_ <> '*' "
			_cQuery := ChangeQuery(_cQuery)
			TcQuery _cQuery New Alias "NAT"

			nComiss20 := NAT->COMISSAO

			@nLin,000 psay "COMISSAO DE AGENCIA - 20%"
			@nLin,055 psay "-------->"
			@nLin,065 psay nComiss20 Picture "@E 999,999,999.99" + " (-)"

			nLin ++

			DBSelectARea("NAT")
			DBCloseArea("NAT")

		ENDIF

		@nLin,000 psay "BV/DESC OU ABAT " + DTOC(mv_par05) + " a " + DTOC(mv_par06)
		//	@nLin,000 psay "BV/REPASSES/DESC OU ABAT " + _aMeses[Month(mv_par05)] + "/" + Substr(DtoS(mv_par05),1,4) + " a " + _aMeses[Month(mv_par06)] + "/" + Substr(DtoS(mv_par06),1,4) Alterado Bruno
		@nLin,055 psay "-------->"
		@nLin,065 psay _nBoniVl Picture "@E 999,999,999.99" + " (-)"

		nLin ++

		if mv_par21 == 2 // Encontro a inadimplencia do mes anterior
			_nTempMes 	:= iif(Month(mv_par05)-1 == 0, 12, Month(mv_par05)-1)
			_cTempAno	:= iif(Month(mv_par05)-1 == 0, StrZero(Year(mv_par05)-1,4), StrZero(Year(mv_par05),4))
			_cTemp		:= "INADIMPLENCIA DE " +  _aMeses[_nTempMes] + "/" + _cTempAno
			_nTempPos	:= aScan(_aRecebe, { |x| x[01] == _cTemp } )
		else	// Encontro a Inadimplencia do mes atual
			_nTempMes 	:= Month(mv_par05)
			_cTempAno	:= StrZero(Year(mv_par05),4)
			_cTemp		:= "INADIMPLENCIA DE " +  _aMeses[_nTempMes] + "/" + _cTempAno
			_nTempPos	:= aScan(_aRecebe, { |x| x[01] == _cTemp } )
		endif

		For _J := 1 To Len(_aRecebe)
			if "RECEBIMENTO" $ _aRecebe[_J,1] .or. ( _J == _nTempPos .and. "INADIMPLENCIA" $ _aRecebe[_J,1])
				@nLin,000 psay _aRecebe[_J,1]
				@nLin,055 psay "-------->"
				@nLin,065 psay _aRecebe[_J,2] Picture "@E 999,999,999.99"  + iif("RECEBIMENTO" $ _aRecebe[_J,1], " (+)", " (-)")
				If "RECEBIMENTO" $ _aRecebe[_J,1]
					_nRecebe += _aRecebe[_J,2]
				Else
					_nInadip += _aRecebe[_J,2]
				EndIf
				nLin ++
			endif
		Next _J


		_nBase := _nFat + _nRecebe - nComiss20 - _nBoniVl - _nInadip + iif(mv_par21 == 2,_nRepas,0) + (nNatSpot * 1) + (nRecSpot * 0.7) + nSpotLoc

		@nLin,000 psay "BASE PARA CALCULO - IMPOSTO "
		@nLin,055 psay "-------->"
		@nLin,065 psay _nBase Picture "@E 999,999,999.99" + " (T)"
		nLin ++

		_nDescImp := _nBase * (_nImposto/100)

		@nLin,000 psay "PIS e COFINS " + cValtoChar(_nImposto) + " %"
		@nLin,055 psay "-------->"
		@nLin,065 psay _nDescImp Picture "@E 999,999,999.99" + " (-)"


		nLin ++

		_nBase -= _nDescImp // Desconta + o imposto

		@nLin,000 psay "BASE PARA CALCULO - COMISSAO"
		@nLin,055 psay "-------->"
		@nLin,065 psay _nBase Picture "@E 999,999,999.99" + " (T)"
		nLin ++


		//U_CalcCom1(_nFat + _nRecebe - _nBoniVl - _nInadip,_nRepas) // Parametros: (Base de Calculo, Repasse)
		U_TMPCom1(_nFat + nSpotLoc + (nNatSpot * 1) + (nRecSpot * 0.7) + _nRecebe - _nBoniVl - _nDescImp - _nInadip - nComiss20,_nRepas,_nBaseCalc) // Parametros: (Base de Calculo, Repasse)

	EndIf

	@ ++ nLin, 000 psay Replicate("-",132)

	nLin += 2

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ ImpVend  º Autor ³                    º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime a Comissao dos Vendedores Internos                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpVend()

	/*
	0         1         2         3         4         5         6         7         8         9         10        11        12
	012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	CODIGO  NOME                                      % COMIS   VL. COMISSAO*/

	Local _nPerc 		:= 0
	Local _nComVend 	:= 0
	Local CabecVend 	:= "CODIGO  NOME                                      % COMIS   VL. COMISSAO      VL. CONTRATO      VL.TOTAL         META"
	Local	LinhaCbVe 	:= "------  ----------------------------------------- --------  ------------     --------------   ----------------  -------"
	Local _nTotVen  	:= 0
	Local _nTotCon  	:= 0
	Local _nTotVenCon  	:= 0

	//Seleciona Vendedores

	_cQuery := "select z9_emissao,"
	_cQuery += "       z9_vend,"
	_cQuery += "       z9_base,"
	_cQuery += "       z9_perc,"
	_cQuery += "       z9_valor,"
	_cQuery += "       z9_origem,"
	_cQuery += "       a3_fxcomis,"
	_cQuery += "       a3_nome"
	_cQuery += "  from " + RetSqlName("SZ9") + " sz9, " + RetSqlName("SA3") + " a3"
	_cQuery += " where a3.d_e_l_e_t_  = ' '"
	_cQuery += "   and sz9.d_e_l_e_t_ = ' '"
	_cQuery += "   and a3_filial      = z9_filial"
	_cQuery += "   and a3_cod         = z9_vend"
	if mv_par10 == 1
		_cQuery += "   and a3_tipvend  = '2'"
	else
		_cQuery += "   and a3_tipvend <> '2'"
	endif
	If mv_par09 == 1
		_cQuery += "   and z9_origem   = 'E' "
	Else
		_cQuery += "   and z9_origem   = 'B' "
	EndIf
	if mv_par21 == 1
		_cQuery += "   and z9_geracao  = 'P' "
	else
		_cQuery += "   and z9_geracao  = 'S' "
	endif
	//_cQuery += "   and z9_emissao    >= '" + DtoS(mv_par01) + "'"
	//_cQuery += "   and z9_emissao    <= '" + DtoS(mv_par02) + "'"
	_cQuery += "   and SUBSTRING(z9_emissao,1,6) = '" + substr(mv_par24,1,4) + Substr(mv_par24,06,02) + "' "  //Colocado por Rafael Franca a pedido da srta. Elisangela.
	if mv_par07 == mv_par08
		_cQuery += "   and z9_vend     = '" + mv_par07 + "'"
	else
		_cQuery += "   and z9_vend    >= '" + mv_par07 + "'"
		_cQuery += "   and z9_vend    <= '" + mv_par08 + "'"
	endif
	_cQuery += " order by z9_emissao, z9_vend"



	TcQuery _cQuery New Alias "QRY"
	// Impressao das tabelas usadas para realizar o calculo da comissao - cadastro de faixas : Bruno alves 28/02/2013

	DBSelectArea("QRY")
	While !QRY->(Eof())

		nPos := aScan( _aFaixa , { |x| x[1] == QRY->A3_FXCOMIS } )
		If EMPTY(nPos)
			aadd(_aFaixa, {QRY->A3_FXCOMIS} )
		EndIf

		dbSkip()

	Enddo


	@nLin, 000 psay "M E T A   C O M I S S Ã O"
	nLin += 2

	For i := 1 To Len(_aFaixa)

		DBSelectArea("SZ7")
		DBSetOrder(1)
		DBSeek(xFilial("SZ7") + _aFaixa[i][1])


		@nLin, 000 psay "-----------------------------------------------"
		nLin++
		@nLin, 020 psay "META: " + _aFaixa[i][1] + ""
		nLin++
		@nLin, 000 psay "-----------------------------------------------"
		nLin++

		If !EMPTY(SZ7->Z7_PERC01)
			@nLin, 001 psay SZ7->Z7_FTINI01 	Picture "@E 999,999,999.99"
			@nLin, 017 psay "Até"
			@nLin, 023 psay SZ7->Z7_FTFIM01 	Picture "@E 999,999,999.99"
			@nLin, 040 psay SZ7->Z7_PERC01 	Picture "@E 99.9999%"
			nLin++
		EndIf

		If !EMPTY(SZ7->Z7_PERC02)
			@nLin, 001 psay SZ7->Z7_FTINI02 	Picture "@E 999,999,999.99"
			@nLin, 017 psay "Até"
			@nLin, 023 psay SZ7->Z7_FTFIM02 	Picture "@E 999,999,999.99"
			@nLin, 040 psay SZ7->Z7_PERC02 	Picture "@E 99.9999%"
			nLin++
		EndIf

		If !EMPTY(SZ7->Z7_PERC03)
			@nLin, 001 psay SZ7->Z7_FTINI03 	Picture "@E 999,999,999.99"
			@nLin, 017 psay "Até"
			@nLin, 023 psay SZ7->Z7_FTFIM03 	Picture "@E 999,999,999.99"
			@nLin, 040 psay SZ7->Z7_PERC03 	Picture "@E 99.9999%"
			nLin++
		EndIf

		If !EMPTY(SZ7->Z7_PERC04)
			@nLin, 001 psay SZ7->Z7_FTINI04 	Picture "@E 999,999,999.99"
			@nLin, 017 psay "Até"
			@nLin, 023 psay SZ7->Z7_FTFIM04 	Picture "@E 999,999,999.99"
			@nLin, 040 psay SZ7->Z7_PERC04 	Picture "@E 99.9999%"
			nLin++
		EndIf

		If !EMPTY(SZ7->Z7_PER05)
			@nLin, 001 psay SZ7->Z7_FTINI05 	Picture "@E 999,999,999.99"
			@nLin, 017 psay "Até"
			@nLin, 023 psay SZ7->Z7_FTFIM05 	Picture "@E 999,999,999.99"
			@nLin, 040 psay SZ7->Z7_PER05 	Picture "@E 99.9999%"
			nLin++
		EndIf

		nLin+=3


	Next i
	DBSelectArea("SZ7")
	DbCloseArea("SZ7")

	If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif


	if ! Empty(mv_par22)
		@nLin, 000 psay mv_par22
		nLin ++
	endif

	if ! Empty(mv_par23)
		@nLin, 000 psay mv_par23
		nLin += 2
	endif

	@nLin, 000 psay "C O M I S S A O  V E N D E D O R E S"
	nLin += 2

	// Rafael Franca
	@nLin, 000 psay CabecVend
	nLin ++
	@nLin, 000 psay LinhaCbVe
	nLin++

	DBSelectArea("QRY")
	DBGotop()
	While !QRY->(Eof())
		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		@nLin, 000 psay QRY->Z9_VEND
		@nLin, 008 psay Alltrim(Posicione("SA3",1,xFilial("SA3")+QRY->Z9_VEND,"A3_NOME"))
		@nLin, 050 psay QRY->Z9_PERC Picture "@E 999.9999"
		@nLin, 060 psay QRY->Z9_VALOR Picture "@E 999,999,999.99"
		@nLin, 076 psay Posicione("SA3",1,xFilial("SA3")+QRY->Z9_VEND,"A3_CONTRAT") Picture "@E 999,999,999.99"
		@nLin, 092 psay (QRY->Z9_VALOR + Posicione("SA3",1,xFilial("SA3")+QRY->Z9_VEND,"A3_CONTRAT")) Picture "@E 999,999,999.99"
		@nLin, 114 psay QRY->A3_FXCOMIS

		nLin ++

		_nTotVen += QRY->Z9_VALOR
		_nTotCon += Posicione("SA3",1,xFilial("SA3")+QRY->Z9_VEND,"A3_CONTRAT")
		_nTotVenCon += (QRY->Z9_VALOR + Posicione("SA3",1,xFilial("SA3")+QRY->Z9_VEND,"A3_CONTRAT"))
		QRY->(dbSkip())
	EndDo

	QRY->(dbCloseArea())

	nLin ++
	@nLin, 000 psay "TOTAL ------>"
	@nLin, 060 psay _nTotVen 	Picture "@E 999,999,999.99"
	@nLin, 076 psay _nTotCon 	Picture "@E 999,999,999.99"
	@nLin, 092 psay _nTotVenCon Picture "@E 999,999,999.99"

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ ImpDel   º Autor ³ Klaus S. Peres     º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime as Notas Canceladas no Periodo e que nao foram re- º±±
±±º          ³ impressas novamente o que caracteriza o efetivo cancelame- º±±
±±º          ³ to.                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpDel()

	//0         1         2         3         4         5         6         7         8         9        10        11
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//  99/99/99   999999  ZZZ  999.999.999.999,99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

	Local CabecNf	:= " DT EMISSAO  NF      SER  VALOR               NOME"
	Local	LinhaNf	:= "-----------  ------  ---  ------------------  ----------------------------------------"
	Local _cQry		:= ""
	Local lCont		:=	.f.

	_cQry := "select distinct"
	_cQry += "       f2_emissao,"
	_cQry += "       f2_doc,"
	_cQry += "       f2_serie,"
	_cQry += "       f2_valbrut,"
	_cQry += "       f2_cliente,"
	_cQry += "       f2_loja "
	_cQry += " from " + RetSqlName("SF2") + " sf2"
	_cQry += " where f2_filial   = '" + xFilial("SF2") + "'"
	_cQry += "   and f2_emissao >= '" + DtoS(mv_par01) + "'"
	_cQry += "   and f2_emissao <= '" + DtoS(mv_par02) + "'"
	_cQry += "   and d_e_l_e_t_  = '*'"
	_cQry += "   and not exists ( select 1
	_cQry += "                      from sf2010 f2
	_cQry += "                     where f2.f2_filial = sf2.f2_filial
	_cQry += "                       and f2.f2_doc = sf2.f2_doc
	_cQry += "                       and f2.f2_serie = sf2.f2_serie
	_cQry += "                       and f2.d_e_l_e_t_ = ' ')
	_cQry += " order by f2_emissao, f2_doc, f2_serie"
	_cQry	:=	ChangeQuery(_cQry)

	TcQuery _cQry New Alias "QRY"

	if !QRY->(Eof())
		nLin += 2
		@nLin, 000 psay Replicate("-",132)
		nLin += 2

		//Rafael
		//@nLin, 000 psay "N O T A S   C A N C E L A D A S   N O   P E R I O D O"
		//nLin += 2
		//@nLin, 000 psay CabecNf
		//nLin ++
		//@nLin, 000 psay LinhaNf
		//nLin++
	endif

	While ! QRY->(Eof())

		lCont := .t.

		_cQry := " select distinct d2_pedido , d2_cliente , d2_loja "
		_cQry += " from " + RetSqlName("SD2")
		_cQry += " where d2_filial   = '" + xFilial("SD2")		+ "' and "
		_cQry += 	"    d2_doc      = '" + QRY->F2_DOC			+ "' and "
		_cQry += 	"    d2_serie    = '" + QRY->F2_SERIE		+ "' and "
		_cQry += 	"    d2_cliente  = '" + QRY->F2_CLIENTE	+ "' and "
		_cQry += 	"    d2_loja     = '" + QRY->F2_LOJA 		+ "' and "
		_cQry += 	"    d_e_l_e_t_  = '*' "
		_cQry	:=	ChangeQuery(_cQry)

		TcQuery _cQry New Alias "TQRY"

		if	Empty(TQRY->D2_PEDIDO)
			lCont := .f.
		else
			_cQry := " select * "
			_cQry += " from " + RetSqlName("SC5") + " "
			_cQry += " where c5_filial   = '" + xFilial("SC5")		+ "' and "
			_cQry += 	"    c5_num      = '" + TQRY->D2_PEDIDO	+ "' and "
			_cQry += 	"    c5_cliente  = '" + TQRY->D2_CLIENTE	+ "' and "
			_cQry += 	"    c5_lojacli  = '" + TQRY->D2_LOJA		+ "'  "
			_cQry	+=	" order by d_e_l_e_t_ desc "
			_cQry	:=	ChangeQuery(_cQry)

			TQRY->(dbclosearea())

			TcQuery _cQry New Alias "TQRY"

			if	Upper(Alltrim(TQRY->C5_CALCCOM)) == "N"
				lCont := .f.
			elseif Upper(Alltrim(TQRY->C5_CALCCOM)) == "S"
				if	Empty(TQRY->C5_VEND1) .and. Empty(TQRY->C5_VEND2) .and. Empty(TQRY->C5_VEND3) .and. Empty(TQRY->C5_VEND4) .and. Empty(TQRY->C5_VEND5)
					lCont := .f.
				endif
			endif
		endif

		TQRY->(dbclosearea())

		if	lCont
			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				@nLin, 000 psay "N O T A S   C A N C E L A D A S   N O   P E R I O D O"
				nLin += 2

				//Rafael Franca
				//@nLin, 000 psay CabecNf
				//nLin ++
				//@nLin, 000 psay LinhaNf
				//nLin++
			Endif
			//@nLin, 001 psay DtoC(StoD(QRY->F2_EMISSAO))
			//@nLin, 013 psay QRY->F2_DOC
			//@nLin, 021 psay QRY->F2_SERIE
			//@nLin, 026 psay QRY->F2_VALBRUT Picture "@E 999,999,999,999.99"
			//@nLin, 046 psay Posicione("SA1",1,xFilial("SA1") + QRY->F2_CLIENTE + QRY->F2_LOJA,"A1_NOME")
			//nLin ++
		endif
		QRY->(dbSkip())
	enddo

	QRY->(DbCloseArea())


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ ImpAssi  º Autor ³ Klaus S. Peres     º Data ³  03/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Imprime as Assinaturas no final do relatorio               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpAssi()

	nLin += 8

	// Imprime a secao das assinaturas que foram preenchidas nos parametros

	@nLin, 000 psay Replicate("-",20)
	@nLin, 023 psay Replicate("-",20)
	@nLin, 053 psay Replicate("-",20)
	If !EMPTY(MV_PAR17)
		@nLin, 083 psay Replicate("-",20)
	EndIf
	If !EMPTY(MV_PAR19)
		@nLin, 113 psay Replicate("-",20)
	EndIf

	nLin++
	@nLin, 000 psay PadC(alltrim(mv_par11),20)
	@nLin, 023 psay PadC(alltrim(mv_par13),20)
	@nLin, 053 psay PadC(alltrim(mv_par15),20)
	@nLin, 083 psay PadC(alltrim(mv_par17),20)
	@nLin, 113 psay PadC(alltrim(mv_par19),20)


	nLin++
	@nLin, 000 psay PadC(alltrim(mv_par12),20)
	@nLin, 023 psay PadC(alltrim(mv_par14),20)
	@nLin, 053 psay PadC(alltrim(mv_par16),20)
	@nLin, 083 psay PadC(alltrim(mv_par18),20)
	@nLin, 113 psay PadC(alltrim(mv_par20),20)



Return

/*
0         1         2         3         4         5         6         7         8         9         10        11        12       13        14
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
CODIGO LJ CLIENTE                         NF-SERIE-PARC EMISSAO   VENCTO             SALDO  % AG.           VALOR  DT BAIXA
Inadimplencia: Outubro/2006
999999 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999999-XXX-99 99/99/99  99/99/99  999.999.999,99  99,99  999.999.999,99  99/99/99
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ImpParam     ³Autor ³ Klaus S Peres        ³Data³ 27/08/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime Pagina de Parametros                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpParam()

	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

	nLin := 8

	@nLin, 000 psay PadC("P Á G I N A   D E   P A R Â M E T R O S",132)
	nLin += 4
	@nLin++, 005 psay "01 - Da Emissão Titulos   : " + DtoC(mv_par01)
	@nLin++, 005 psay "02 - Até Emissão Titulos  : " + DtoC(mv_par02)
	@nLin++, 005 psay "03 - Do Venc. Titulos     : " + DtoC(mv_par03)
	@nLin++, 005 psay "04 - Até Venc. Titulos    : " + DtoC(mv_par04)
	@nLin++, 005 psay "05 - Dt da Baixa Inicial  : " + DtoC(mv_par05)
	@nLin++, 005 psay "06 - Dt da Baixa Final    : " + DtoC(mv_par06)
	@nLin++, 005 psay "07 - Do Vendedor Interno  : " + mv_par07
	@nLin++, 005 psay "08 - Ate Vendedor Interno : " + mv_par08
	@nLin++, 005 psay "09 - Emissão/Baixa        : " + iif(mv_par09==1,"1-Emissao","2-Baixa")
	@nLin++, 005 psay "10 - Tipo Vendedor        : " + iif(mv_par10==1,"1-Vendedor CLT","2-Vendedor PJ")
	@nLin++, 005 psay "11 - Assinatura 1         : " + mv_par11
	@nLin++, 005 psay "12 - Função 1             : " + mv_par12
	@nLin++, 005 psay "13 - Assinatura 2         : " + mv_par13
	@nLin++, 005 psay "14 - Função 2             : " + mv_par14
	@nLin++, 005 psay "15 - Assinatura 3         : " + mv_par15
	@nLin++, 005 psay "16 - Função 3             : " + mv_par16
	@nLin++, 005 psay "17 - Assinatura 4         : " + mv_par17
	@nLin++, 005 psay "18 - Função 4             : " + mv_par18
	@nLin++, 005 psay "19 - Geracao no Mes       : " + iif(mv_par21==1,"1-Primeira","2-Segunda")
	@nLin++, 005 psay "20 - Informacao 1         : " + mv_par22
	@nLin++, 005 psay "21 - Informacao 2         : " + mv_par23
	@nLin++, 005 psay "22 - Ano/Mes Grava Comis. : " + mv_par24

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Imp_Inadim   ³Autor ³ Klaus S Peres        ³Data³ 31/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime Inadimplencia                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Imp_Inadim()

	Local cFornc1 	:= ""
	Local cPrefi1	:= ""
	Local cNumer1	:= ""
	Local cParce1  := ""
	Local nValor1 	:= 0

	_aTitPend := aSort(_aTitPend,,, { |x,y| x[06]+x[02]+x[03]+x[04]+x[05] < y[06]+y[02]+y[03]+y[04]+y[05] }) // Ordena os Titulos Inadimplentes por data de emissao

	For _I := 1 To Len(_aTitPend)

		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IF 	cFornc1 	== _aTitPend[_I,4] .AND. cPrefi1 == _aTitPend[_I,2] .AND. cNumer1 == _aTitPend[_I,1] .AND. cParce1 == _aTitPend[_I,3] .AND. nValor1 	== _nValLiq
			_I ++
		ENDIF

		If _cMesAno <> Substr(_aTitPend[_I,6],5,2) + Substr(_aTitPend[_I,6],1,4) .and. _I > 1 // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			nLin ++
			@nLin,00 psay "TOTAL DO MES ----------------> "
			@nLin,099 psay _nTotMes Picture "@E 999,999,999.99"
			nLin ++
			aAdd(_aRecebe, {_cResumo,_nTotMes})
			@nLin, 000 psay Replicate("-",132)
			_nTotMes := 0
			nLin += 2
		EndIf

		If _cMesAno <> Substr(_aTitPend[_I,6],5,2) + Substr(_aTitPend[_I,6],1,4)  // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			//			If Empty(_aTitPend[_I,11]) .or. _aTitPend[_I,11] > DtoS(mv_par06)
			@nLin,00 psay "INADIMPLENCIA DE "+_aMeses[Val(Substr(_aTitPend[_I,6],5,2))]+"/"+Substr(_aTitPend[_I,6],1,4) // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			nLin += 2
			_cResumo := "INADIMPLENCIA DE "+_aMeses[Val(Substr(_aTitPend[_I,6],5,2))]+"/"+Substr(_aTitPend[_I,6],1,4) // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			//			Else
			//				@nLin,00 psay "RECEBIMENTO DE "+_aMeses[Val(Substr(_aTitPend[_I,6],5,2))]+"/"+Substr(_aTitPend[_I,6],1,4) // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			//				nLin += 2
			//				_cResumo := "RECEBIMENTO DE "+_aMeses[Val(Substr(_aTitPend[_I,6],5,2))]+"/"+Substr(_aTitPend[_I,6],1,4) // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			//			EndIf
		EndIf

		if _aTitPend[_I,12] > 0
			_nValLiq	:= _aTitPend[_I,9] - ( _aTitPend[_I,9] * _aTitPend[_I,12] / 100 )
		else
			_cPed		:= Posicione("SD2",3,xFilial("SD2") + _aTitPend[_I,2],"D2_PEDIDO")
			_nComis1	:= Posicione("SC5",1,xFilial("SC5") + _cPed, "C5_COMIS1")
			if _nComis1 > 0
				_nValLiq	:= _aTitPend[_I,9] - ( _aTitPend[_I,9] * _nComis1 / 100 )
			else
				_nValLiq	:= _aTitPend[_I,9]
			endif
		endif

		//		Retirado por Klaus em 29/08/2007 - Nao vi nenhuma utilidade
		//		if StoD(_aTitPend[_I,11]) = StoD("") // Se nao tiver sido baixado ainda
		//			_nDAtrasa := abs(dDataBase - StoD(_aTitPend[_I,7]))
		//		else // Se ja foi baixado
		//			_nDAtrasa := abs(StoD(_aTitPend[_I,11]) - StoD(_aTitPend[_I,7]))
		//		endif

		@nLin,000 psay _aTitPend[_I,4]																													// Codigo cliente
		@nLin,007 psay _aTitPend[_I,5]																													// Loja cliente
		@nLin,010 psay substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+_aTitPend[_I,4]+_aTitPend[_I,5],"A1_NOME")),1,30)	// Nome cliente
		@nLin,042 psay _aTitPend[_I,2] + "-"																											// Numero
		@nLin,049 psay _aTitPend[_I,1] + "-"																											// Prefixo
		@nLin,053 psay _aTitPend[_I,3]																													// Parcela
		@nLin,056 psay StoD(_aTitPend[_I,6])																											// Emissao
		@nLin,066 psay StoD(_aTitPend[_I,7])																											// Vencimento
		@nLin,076 psay _aTitPend[_I,13]	Picture "@E 999,999,999.99"																			// Saldo //ESTAVA 09--VALTENIO
		@nLin,092 psay _aTitPend[_I,12]	Picture "@E 99.9999"																						// Valor
		@nLin,099 psay _nValLiq				Picture "@E 999,999,999.99"																			// Valor
		IF _nValLiq > 0
			@nLin,115 psay "  /  /  "
		ELSE
			@nLin,115 psay StoD(_aTitPend[_I,11])       //BAIXA
		ENDIF

		_nTotMes += _nValLiq //Total do mes
		_cMesAno := Substr(_aTitPend[_I,6],5,2)+Substr(_aTitPend[_I,6],1,4) // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos

		cFornc1 	:= _aTitPend[_I,4]
		cPrefi1		:= _aTitPend[_I,2]
		cNumer1		:= _aTitPend[_I,1]
		cParce1  	:= _aTitPend[_I,3]
		nValor1 	:= _nValLiq

		nLin := nLin + 1 // Avanca a linha de impressao

		If _I == Len(_aTitPend) //totaliza o último mes processado
			nLin ++
			@nLin,00 psay "TOTAL DO MES ----------------> "
			@nLin,099 psay _nTotMes Picture "@E 999,999,999.99"
			nLin ++
			aAdd(_aRecebe, {_cResumo,_nTotMes})
			@nLin, 000 psay Replicate("-",132)
			_nTotMes := 0
			nLin += 2
		EndIf
	Next _I

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Imp_Recebi   ³Autor ³ Klaus S Peres        ³Data³ 31/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime Recebidos                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Imp_Recebi()

	//Local	_nAtraso := 0

	nLin := 80

	_aTitulos := aSort(_aTitulos,,, { |x,y| x[06]+x[02]+x[03]+x[04]+x[05] < y[06]+y[02]+y[03]+y[04]+y[05] }) // Ordena os Titulos Recebidos por data de emissao

	For _I := 1 To Len(_aTitulos)

		//		_nAtraso	:= abs(StoD(_aTitulos[_I,11])- StoD(_aTitulos[_I,7])) // Baixa - Vencto

		//		if _nAtraso >= 1 .or. (_nAtraso >= 1 .and. mv_par19 == 2)
		//		if _nAtraso >= 1 .or. (_nAtraso >= 0 .and. mv_par19 == 2) // Alterei pois um titulo nao entrou no relatorio e a linha acima que removeu, pois o atraso foi 0 (zero) - Por Klaus em 27/08/2007

		If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		If _cMesAno <> Substr(_aTitulos[_I,6],5,2) + Substr(_aTitulos[_I,6],1,4) .and. _I > 1 // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			nLin ++
			@nLin,00 psay "TOTAL DO MES ----------------> "
			@nLin,099 psay _nTotMes Picture "@E 999,999,999.99"
			nLin ++
			aAdd(_aRecebe, {_cResumo,_nTotMes})
			@nLin, 000 psay Replicate("-",132)
			_nTotMes := 0
			nLin += 2
		EndIf

		If _cMesAno <> Substr(_aTitulos[_I,6],5,2)+Substr(_aTitulos[_I,6],1,4)  // Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			@nLin,00 psay "RECEBIMENTO DE "+_aMeses[Val(Substr(_aTitulos[_I,6],5,2))]+"/"+Substr(_aTitulos[_I,6],1,4)		// Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
			nLin += 2
			_cResumo := "RECEBIMENTO DE "+_aMeses[Val(Substr(_aTitulos[_I,6],5,2))]+"/"+Substr(_aTitulos[_I,6],1,4)		// Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
		EndIf

		if _aTitulos[_I,12] > 0
			_nValLiq	:= _aTitulos[_I,9] - ( _aTitulos[_I,9] * _aTitulos[_I,12] / 100 )
		else
			_cPed		:= Posicione("SD2",3,xFilial("SD2") + _aTitulos[_I,2],"D2_PEDIDO")
			_nComis1	:= Posicione("SC5",1,xFilial("SC5") + _cPed, "C5_COMIS1")
			if _nComis1 > 0
				_nValLiq	:= _aTitulos[_I,9] - ( _aTitulos[_I,9] * _nComis1 / 100 )
			else
				_nValLiq	:= _aTitulos[_I,9]
			endif
		endif

		@nLin,000 psay _aTitulos[_I,4]																													// Codigo cliente
		@nLin,007 psay _aTitulos[_I,5]																													// Loja cliente
		@nLin,010 psay substr(Alltrim(Posicione("SA1",1,xFilial("SA1")+_aTitulos[_I,4]+_aTitulos[_I,5],"A1_NOME")),1,30)	// Nome cliente
		@nLin,042 psay _aTitulos[_I,2]																													// Numero
		@nLin,049 psay _aTitulos[_I,1]																													// Prefixo
		@nLin,053 psay _aTitulos[_I,3]																													// Parcela
		@nLin,056 psay StoD(_aTitulos[_I,6])																											// Emissao
		@nLin,066 psay StoD(_aTitulos[_I,7])																											// Vencimento
		@nLin,076 psay _aTitulos[_I,09] Picture "@E 999,999,999.99"																				// Saldo
		@nLin,092 psay _aTitulos[_I,12] Picture "@E 99.9999"																							// Valor
		@nLin,099 psay _nValLiq Picture "@E 999,999,999.99"																						// Valor
		//			@nLin,106 psay _nAtraso Picture "@R 999" + " DIAS"																							// Dias em Atraso
		@nLin,115 psay StoD(_aTitulos[_I,11])																											// Baixa

		_nTotMes += _nValLiq																		// Total do mes
		_cMesAno := Substr(_aTitulos[_I,6],5,2)+Substr(_aTitulos[_I,6],1,4)	// Alterado por Klaus em 31/05/07 - Da Coluna 7 para a Coluna 6 do Vetor _aTitulos
		nLin++																						// Avanca a linha de impressao
		//		endif // Retirado os _nAtraso em 29/08/2007 por Klaus

		If _I == Len(_aTitulos) //totaliza o ultimo mes processado
			nLin ++
			@nLin,00 psay "TOTAL DO MES ----------------> "
			@nLin,099 psay _nTotMes Picture "@E 999,999,999.99"
			nLin ++
			aAdd(_aRecebe, {_cResumo,_nTotMes})
			@nLin, 000 psay Replicate("-",132)
			_nTotMes := 0
			nLin += 2
		endIf
	next _I

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcCom1  º Autor ³ Cristiano D. Alves º Data ³  08/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Recálculo de comissões para vendedores Internos.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento - Record Brasilia                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlterado  ³ Klaus Schneider Peres                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//User Function CalcCom1(_nBaseCom,_nRepasse)
User Function TMPCom1(_nBaseCom,_nRepasse,_nBaseCalc)

	Local cSeek

	Private	_nBsCom		:= 0
	Private	_cOrigem		:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Calcular a Comissao no mes teremos as seguintes possibilidades:                       ³
	//³      Primeira Geracao no Mes:	Por Emissao CLT                                           ³
	//³      Primeira Geracao no Mes:	Por Baixa   PJ                                            ³
	//³      Segunda Geracao  no Mes:	Por Baixa   CLT                                           ³
	//³      Segunda Geracao  no Mes:	Por Emissao -> Nao Existe, devera ser informado ao usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_cOrigem := iif( mv_par09 == 1 , "E" , "B" )

	// Verifica Vendedores

	SZ7->(dbSetOrder(1))
	SZ9->(dbSetOrder(1))
	SA3->(dbSetOrder(1))

	Vend()

	if mv_par21 == 1			// Se for a Primeira Geracao do Mes

		If mv_par09 == 1 		// Primeiro e Por Emissao - CLT

			For _I := 1 To Len(_aVend)

				// Somente funcionarios CLT

				SA3->(dbSeek(xFilial("SA3")+_aVend[_I,1]))

				if SA3->A3_TIPVEND == "2"

					cSeek 	:= xFilial("SZ9") + substr(mv_par24,1,4) + Substr(mv_par24,06,02)
					cSeek 	+= iif( Substr(mv_par24,06,02) == "02" , "28" , "30" )
					cSeek		+=	_aVend[_I,1] + _cOrigem + "P"

					_lGrava	:=	iif( SZ9->( dbSeek( cSeek , .f. )) , .f. , .t. )
					_nBsCom	:=	_nBaseCom + IIf( _aVend[_I,3] == "S" , _nRepasse , 0 ) 	//Verifica se o vendedor entra repasse ou nao
					_lAchou 	:=	iif( _nBsCom > 0 .and. _aVend[_I,4] > 0 , .t. , .f. )

					if _lAchou
						RecLock("SZ9",_lGrava)
						SZ9->Z9_FILIAL 	:= xFilial("SZ9")
						if	Substr(mv_par24,06,02) == "02"
							SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "28")
						else
							SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "30")
						endif
						SZ9->Z9_VEND		:= _aVend[_I,1]
						SZ9->Z9_BASE		:= _nBsCom
						SZ9->Z9_PERC		:= _aVend[_I,4]
						SZ9->Z9_VALOR		:= Round(((_nBsCom * _aVend[_I,4])/100),2)
						SZ9->Z9_ORIGEM		:= "E" 			// Emissao
						SZ9->Z9_GERACAO	:= "P" 			// Primeira
						SZ9->Z9_TIPO	:= "CI"
						SZ9->(MsUnlock())
					endIf
				endIf
			next _I

		else // Primeiro e Por Baixa - PJ -----------------------------------------------------------------------------------------------------------

			For _I := 1 To Len(_aVend)

				_nFatLiq	:= _nFat

				DbSelectArea("SZ9")
				DbSetOrder(2)

				cSeek		:=	xFilial("SZ9") + substr(mv_par24,1,4) + Substr(mv_par24,06,02)
				cSeek		+=	iif( substr(mv_par24,06,02) == "02" , "28" , "30" )
				cSeek		+=	_aVend[_I,1] + _cOrigem + "P"

				_lGrava	:= iif( SZ9->( dbSeek( cSeek , .f. )) , .f. , .t. )
				_nBsCom	:=	_nBaseCom + IIf( _aVend[_I,3] == "S" , _nRepasse , 0 )							//Verifica se o vendedor entra repasse ou nao
				_lAchou	:=	iif( _nBsCom > 0 .and. _aVend[_I,4] > 0 , .t. , .f. )

				If _lAchou
					RecLock("SZ9",_lGrava)
					SZ9->Z9_FILIAL 	:= xFilial("SZ9")
					if	Substr(mv_par24,06,02) == "02"
						SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "28")
					else
						SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "30")
					endif
					SZ9->Z9_VEND		:= _aVend[_I,1]
					SZ9->Z9_BASE		:= _nBsCom
					SZ9->Z9_PERC		:= _aVend[_I,4]
					SZ9->Z9_VALOR		:= Round(((_nBsCom * _aVend[_I,4])/100),2)
					SZ9->Z9_ORIGEM		:= "B" 		// Baixa
					SZ9->Z9_GERACAO	:= "P" 		// Primeira
					SZ9->Z9_TIPO	:= "CI"
					SZ9->(MsUnlock())
				EndIf
			Next _I
		endif

	else 	// Se for a Segunda Geracao do Mes - CLT ------------------------------------------------------------------------------------------------

		If mv_par09 == 2 // Segundo e Por Baixa

			_nFatLiq	:= _nFat // + nNatSpot

			// Grava os registros das Comissoes

			For _I := 1 To Len(_aVend)

				SZ9->(DbSetOrder(2))

				cSeek 	:= xFilial("SZ9") + substr(mv_par24,1,4) + Substr(mv_par24,06,02)
				cSeek		+=	iif( substr(mv_par24,6,2) == "02" , "28" , "30" )
				cSeek		+=	_aVend[_I,1] + _cOrigem + "S"

				_lGrava	:=	iif( SZ9->( dbSeek( cSeek , .f. )) , .f. , .t. )
				_nBsCom	:= _nBaseCom + IIf(_aVend[_I,3] == "S" , _nRepasse , 0 )			//Verifica se o vendedor entra repasse ou nao
				_lAchou	:= iif( _nBsCom > 0 .and. _aVend[_I,4] > 0 , .t. , .f. )

				If _lAchou
					RecLock("SZ9",_lGrava)
					SZ9->Z9_FILIAL 	:= xFilial("SZ9")
					if	substr(mv_par24,06,02) == "02"
						SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "28")
					else
						SZ9->Z9_EMISSAO	:= StoD(substr(mv_par24,1,4) + substr(mv_par24,6,2) + "30")
					endif
					SZ9->Z9_VEND		:= _aVend[_I,1]
					SZ9->Z9_BASE		:= _nBsCom
					SZ9->Z9_PERC		:= _aVend[_I,4]
					SZ9->Z9_VALOR		:= NoRound(((_nBsCom * _aVend[_I,4])/100),2)
					SZ9->Z9_ORIGEM		:= "B" 			// Baixa
					SZ9->Z9_GERACAO	:= "S" 			// Segunda
					SZ9->Z9_TIPO	:= "CI"
					SZ9->(MsUnlock())
				EndIf
			Next _I
		endif
	endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VEND     º Autor ³Cristiano D. Alves  º Data ³  20/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona vendedores e suas respectivas faixas de comissao.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Vend()

	Local _cQryVend := ""

	//Seleciona vendedores internos
	_cQryVend	+= "select a3_cod,"
	_cQryVend	+= "       a3_fxcomis,"
	_cQryVend	+= "       a3_repasse,"
	_cQryVend	+= "       a3_tipvend"
	_cQryVend	+= "  from " + RetSqlName("SA3")
	_cQryVend	+= " where a3_filial  = ' '"
	_cQryVend	+= "   and a3_msblql <> '1' "
	_cQryVend	+= "   and d_e_l_e_t_ = ' '"
	_cQryVend	+= " order by a3_cod"

	TcQuery _cQryVend New Alias "QRV"

	_nRepass	:= _nRepas
	//_nFatLiq	:= _nFat + nNatSpot //Alterado conforme Elisangela solicitou Bruno Alves 07/03/2013
	_nFatLiq	:= _nBase
	_nFatLiq	:= _nFat + nNatSpot + nSpotLoc + (nRecSpot * 0.7) // Rafael França - 17/12/18 - Correção da base para calcular o percentual da comissão.

	While !QRV->(Eof())

		//Cadastro de Faixa de comissões
		If SZ7->(dbSeek(xFilial("SZ7")+QRV->A3_FXCOMIS)) //Posiciona para verificar o cod. da faixa de comissao
			//Verifica em qual faixa os vendedores estão enquadrado em relação ao Faturamento
			Do Case
				Case _nFatLiq >= SZ7->Z7_FTINI01 .and. _nFatLiq <= SZ7->Z7_FTFIM01 //Primeira faixa
				_nPerc	:= SZ7->Z7_PERC01
				Case _nFatLiq >= SZ7->Z7_FTINI02 .and. _nFatLiq <= SZ7->Z7_FTFIM02 //Segunda faixa
				_nPerc	:= SZ7->Z7_PERC02
				Case _nFatLiq >= SZ7->Z7_FTINI03 .and. _nFatLiq <= SZ7->Z7_FTFIM03 //Terceira faixa
				_nPerc	:= SZ7->Z7_PERC03
				Case _nFatLiq >= SZ7->Z7_FTINI04 .and. _nFatLiq <= SZ7->Z7_FTFIM04 //Quarta faixa
				_nPerc	:= SZ7->Z7_PERC04
				Case _nFatLiq >= SZ7->Z7_FTINI05 .and. _nFatLiq <= SZ7->Z7_FTFIM05 //Quinta faixa
				_nPerc	:= SZ7->Z7_PER05
				OtherWise
				_nPerc	:= SZ7->Z7_PERC01
			EndCase
		Else
			_nPerc := 0
		EndIf

		aadd(_aVend, { QRV->A3_COD, QRV->A3_FXCOMIS, QRV->A3_REPASSE, _nPerc, QRV->A3_TIPVEND } )

		QRV->(dbSkip())

	EndDo
	QRV->(dbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ValidPerg    ³Autor ³  Cristiano D. Alves  ³Data³ 03/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","Da Emissão:			","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Até a Emissão:		","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Do Vencimento:		","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Até o Vencimento:	","","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Da Baixa:		 	","","","mv_ch5","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Até a Baixa:		","","","mv_ch6","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Do Vendedor:		","","","mv_ch7","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	aAdd(aRegs,{cPerg,"08","Até o Vendedor:		","","","mv_ch8","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
	aAdd(aRegs,{cPerg,"09","Emissão/Baixa:      ","","","mv_ch9","N",01,00,1,"C","","mv_par09","Emissao","","","","","Baixa","","","","","","","","","","","","","","","","","","","" })
	aAdd(aRegs,{cPerg,"10","Tipo Vendedor:      ","","","mv_cha","N",01,00,1,"C","","mv_par10","Vendedor CLT","","","","","Vendedor PJ","","","","","","","","","","","","","","","","","","","" })
	aAdd(aRegs,{cPerg,"11","Assinatura 1:       ","","","mv_chb","C",20,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Função 1:           ","","","mv_chc","C",20,00,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","Assinatura 2:       ","","","mv_chd","C",20,00,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Função 2:           ","","","mv_che","C",20,00,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Assinatura 3:       ","","","mv_chf","C",20,00,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Função 3:           ","","","mv_chg","C",20,00,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Assinatura 4:       ","","","mv_chh","C",20,00,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Função 4:           ","","","mv_chi","C",20,00,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","Assinatura 5:       ","","","mv_chj","C",20,00,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Função 5:           ","","","mv_chk","C",20,00,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"21","Geração no Mês:     ","","","mv_chl","N",01,00,1,"C","","mv_par21","Primeira","","","","","Segunda","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"22","Informação 1:       ","","","mv_chm","C",50,00,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"23","Informação 2:       ","","","mv_chn","C",50,00,0,"G","","mv_par23","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"24","Ano/Mês Comissão:	","","","mv_cho","C",07,00,0,"G","","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"25","Tipo Comissão:      ","","","mv_chp","N",01,00,1,"C","","mv_par25","Geral","","","","","Varejo","","","","","Por Data","","","","","Teste","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.t.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return
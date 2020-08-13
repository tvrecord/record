#INCLUDE "PONM080.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PONCALEN.CH"
#INCLUDE "TOPCONN.CH"  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PONM080R � Autor � Alvaro Camillo Neto   � Data � 07/05/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechamento Banco de Horas Espec�fico                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso  	 � SIGAPON da empresa Record								  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function PONM080R()

Local aArea				:= GetArea()
Local aAreaSPI			:= SPI->( GetArea() )
Local aSays 			:= {}
Local aButtons			:= {}                            

Local cPerg				:= "PN080R101"
Local cSvFilAnt		:= cFilAnt
Local lBarG1ShowTm 	:= .F.
Local lBarG2ShowTm 	:= .F.
Local nOpcA				:= 0.00
Private lAbortPrint	:= .F.
Private cCadastro		:= OemToAnsi( STR0001 ) // 'Fechamento Banco de Horas'

/*
��������������������������������������������������������������Ŀ
� So Executa se os Modos de Acesso dos Arquivos Relacionados es�
� tiverm OK													   �
����������������������������������������������������������������*/
IF (ValidArqPon())
	aAdd(aSays,OemToAnsi( STR0003 ) )// 'Este programa tem como objetivo apurar o resultado ou Eventos'
	aAdd(aSays,OemToAnsi( STR0004 ) )// 'finais do periodo para a Compensa��o ou Pagamento de Horas.'
	
	aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(),FechaBatch(),nOpcA:=0 ) }} )
	aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	IF ( nOpcA == 1 )
		/*
		��������������������������������������������������������������������Ŀ
		� Verifica se deve Mostrar Calculo de Tempo nas BarGauge			 �
		����������������������������������������������������������������������*/
		lBarG1ShowTm := ( SuperGetMv("MV_PNSWTG1",NIL,"N") == "S" )
		lBarG2ShowTm := ( SuperGetMv("MV_PNSWTG2",NIL,"S") == "S" )
		/*
		��������������������������������������������������������������������Ŀ
		� Executa o Processo de Fechamento do Banco de Horas				 �
		����������������������������������������������������������������������*/
		Proc2BarGauge(  {|| PNM080Processa( cPerg ) } ,STR0001 , NIL , NIL , .T. , lBarG1ShowTm , lBarG2ShowTm )  // 'Fechamento Banco de Horas'
	EndIF
	RestArea( aAreaSPI )
EndIF

cFilAnt := cSvFilAnt
RestArea( aArea )

Return( NIL )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PONM080Processa � Autor � Aldo Marini jr � Data � 03/12/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa o Fechamento do Banco de Horas                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso  	 � SIGAPON							             			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function PNM080Processa( cPerg )
Local aArea		   	:= SRA->(GetArea())
Local aAreaSRA			:= SRA->( GetArea() )
Local aAreaSPI			:= SPI->( GetArea() )
Local aRecsSR6			:= {}
Local aRecsBarG		:= {}
Local bSraScope		:= { || .F. }
Local cFilMat	 		:= ""
Local cLastFil	 		:= "__cLastFil__"
Local cEveProv	 		:= SPACE(3)
Local cEveDesc	 		:= SPACE(3)
Local cAcessaSRA		:= &("{ || " + ChkRH("PONM080R","SRA","2") + "}")
Local cCc		 		:= ""
Local cPd 		 		:= ""
Local cOldFilTnoSeq	:= "__cOldFilTnoSeq__"
Local cAtuFilTnoSeq	:= "__cAtuFilTnoSeq__"
Local cFilTnoAtu		:= "__cFilTnoAtu__"
Local cFilTnoOld		:= "__cFilTnoOld__"
Local cFilTnoDe		:= ""
Local cFilTnoAte		:= ""
Local cSvFilAnt		:= cFilAnt
Local cTimeIni			:= Time()
Local cMsgBarG1		:= ""
Local dDtLacto	 		:= Ctod("//")
Local lSR6Comp			:= Empty( xFilial( "SR6" ) )
Local lIncProcG1		:= .T.
Local nT		 			:= 0.00
Local nValN		 		:= 0.00
Local nValV				:= 0.00
Local nValorN			:= 0.00
Local nValorV			:= 0.00
Local nSinal			:= 0.00
Local nLastRec	 		:= 0.00
Local nRecsSR6			:= 0.00
Local nIncPercG1		:= 0.00
Local nIncPercG2		:= 0.00
Local nCount1Time		:= 0.00
Local uRet

#IFDEF TOP
	Local aStruSRA		:= {}
	Local aCposSRA		:= {}
	Local aTempSRA		:= SRA->( dbStruct() )
	Local cQuery	 	:= ""
	Local cQueryCond	:= ""
	Local lSraQryOpened	:= .F.
	Local nContField	:= Len( aTempSRA	)
	Local nX
#ENDIF

Private aLogDet		:= {}
Private aLogTitle		:= {}

//CriaSx1(cPerg) TODO: Fazer

Pergunte( cPerg , .F. )
//��������������������������������������������������������������Ŀ
//� Carregando as Perguntas                                      �
//����������������������������������������������������������������
Private cFilialDe		:= mv_par01
Private cFilialAte	:= mv_par02
Private cCCDe			:= mv_par03
Private cCCAte			:= mv_par04
Private cTurnoDe		:= mv_par05
Private cTurnoAte		:= mv_par06
Private cMatDe			:= mv_par07
Private cMatAte		:= mv_par08
Private cNomeDe		:= mv_par09
Private cNomeAte		:= mv_par10
Private cRegraDe		:= mv_par11
Private cRegraAte		:= mv_par12
Private cSit			:= If(!Empty(mv_par13),mv_par13,' ADFT' )
Private cCat			:= If(!Empty(mv_par14),mv_par14,'CDHMST' )
Private cEveDe			:= mv_par15
Private cEveAte		:= mv_par16
Private cSinRad		:= GetMV("MV_SINRAD")
Private cSindJor		:= GetMV("MV_SINJOR")
Private nUtiliz		:= mv_par17		//-- 1=Normais - 2=Valorizadas
Private dDtPagto		:= mv_par18
Private nTpEvento		:= mv_par19  	//-- 1=Autorizados 2=Nao Autorizados 3=Ambos
//-- Periodo p/ Proventos
Private dPerIniP		:= mv_par20
Private dPerFimP		:= mv_par21
Private dPerIni		:= Ctod("//")
Private dPerFim		:= Ctod("//")
Private aSPI			:= {}		//Vetor com todos os apontamentos do banco de horas
Private aDelSPI	 	:= {}		//Array com os Registros a serem Baixados
Private aSPIProMes 	:= {}		//Vetor com os proventos do periodo aberto
Private aSPIDesMes	:= {}		//Vetor com os descontos do periodo aberto
Private aSPIProSal 	:= {}		//Vetor com os proventos dos periodos anteriores ao aberto
Private aSPIDesSal	:= {}		//Vetor com os descontos dos periodos anteriores ao aberto

dbSelectArea('SPI')
dbSetOrder(2)
dbSelectArea( 'SRA' )
dbSetOrder( 4 )

/*
��������������������������������������������������������������Ŀ
� Inicializa Filial/Turno De/Ate							   �
����������������������������������������������������������������*/
cFilTnoDe	:= ( cFilialDe + cTurnoDe )
cFilTnoAte	:= ( cFilialAte + cTurnoAte )

/*/
��������������������������������������������������������������Ŀ
� Cria o Bloco dos Funcionarios que atendam ao Scopo	   	   �
����������������������������������������������������������������/*/
bSraScope := { || (;
( RA_TNOTRAB	>= cTurnoDe		.and. RA_TNOTRAB	<= cTurnoAte	)	.and. ;
( RA_FILIAL		>= cFilialDe	.and. RA_FILIAL	<= cFilialAte	)	.and. ;
( RA_REGRA		>= cRegraDe		.and. RA_REGRA		<= cRegraAte	)	.and. ;
( RA_NOME		>= cNomeDe		.and. RA_NOME		<= cNomeAte		)	.and. ;
( RA_MAT			>= cMatDe		.and. RA_MAT		<= cMatAte		)	.and. ;
( RA_CC			>= cCCDe			.and. RA_CC			<= cCCAte		)	.and. ;
( RA_SINDICA	== cSinRad		.Or.  RA_SINDICA	== cSindJor		)		   ;
);
}


/*
�������������������������������������������������������������Ŀ
� Seta apenas os Campos do SRA que serao Utilizados           �
���������������������������������������������������������������*/
aAdd( aCposSRA , "RA_FILIAL"	)
aAdd( aCposSRA , "RA_MAT" 		)
aAdd( aCposSRA , "RA_NOME"		)
aAdd( aCposSRA , "RA_CC"		)
aAdd( aCposSRA , "RA_TNOTRAB"	)
aAdd( aCposSRA , "RA_SEQTURN"	)
aAdd( aCposSRA , "RA_REGRA"  	)
aAdd( aCposSRA , "RA_ADMISSA" )
aAdd( aCposSRA , "RA_DEMISSA" )
aAdd( aCposSRA , "RA_CATFUNC" )
aAdd( aCposSRA , "RA_SITFOLH" )
aAdd( aCposSRA , "RA_SINDICA" )
aAdd( aCposSRA , "RA_BHFOL" 	)
For nX := 1 To nContField
	/*
	��������������������������������������������������������������Ŀ
	� Carrega os Campos do SRA para a Montagem da Query			   �
	����������������������������������������������������������������*/
	IF aScan( aCposSRA , { |x| Upper(AllTrim(x)) == Upper( AllTrim( aTempSRA[ nX , 1 ] ) ) } ) > 0.00
		aAdd( aStruSRA , aClone( aTempSRA[ nX ] ) )
	EndIF
Next nX
aCposSRA	:= aTempSRA := NIL
nContField	:= Len( aStruSRA )
cQuery := "SELECT DISTINCT "
For nX := 1 To nContField
	/*
	��������������������������������������������������������������Ŀ
	� Inclui os Campos na Montagem da Query						   �
	����������������������������������������������������������������*/
	cQuery += aStruSRA[ nX , 1 ] + ", "
Next nX
cQuery := SubStr( cQuery , 1 , Len( cQuery ) - 2 )

cQueryCond	+= " FROM "
cQueryCond	+= InitSqlName("SRA")+" SRA "
cQueryCond	+= "WHERE "
cQueryCond	+= "SRA.RA_FILIAL>='"+cFilialDe+"' AND "
cQueryCond	+= "SRA.RA_FILIAL<='"+cFilialAte+"' AND "
cQueryCond	+= "SRA.RA_TNOTRAB>='"+cTurnoDe+"' AND "
cQueryCond	+= "SRA.RA_TNOTRAB<='"+cTurnoAte+"' AND "
cQueryCond	+= "SRA.RA_MAT>='"+cMatDe+"' AND "
cQueryCond	+= "SRA.RA_MAT<='"+cMatAte+"' AND "
cQueryCond	+= "SRA.RA_NOME>='"+cNomeDe+"' AND "
cQueryCond	+= "SRA.RA_NOME<='"+cNomeAte+"' AND "
cQueryCond	+= "SRA.RA_REGRA>='"+cRegraDe+"' AND "
cQueryCond	+= "SRA.RA_REGRA<='"+cRegraAte+"' AND "
cQueryCond	+= "SRA.RA_CC>='"+cCCDe+"' AND "
cQueryCond	+= "SRA.RA_CC<='"+cCCAte+"' AND "
cQueryCond	+= "(SRA.RA_SINDICA='"+cSinRad+"' OR "
cQueryCond	+= "SRA.RA_SINDICA='"+cSindJor+"') AND "
cQueryCond	+= "SRA.D_E_L_E_T_=' ' "

cQuery		+= cQueryCond
cQuery		+= "ORDER BY "+SqlOrder( SRA->( IndexKey() ) )
cQuery		:= ChangeQuery(cQuery)
SRA->( dbCloseArea() ) //Fecha o SRA para uso da Query
IF ( lSraQryOpened := MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),"SRA",.T.,.T.) )
	For nX := 1 To nContField
		IF ( aStruSRA[nX,2] <> "C" )
			TcSetField("SRA",aStruSRA[nX,1],aStruSRA[nX,2],aStruSRA[nX,3],aStruSRA[nX,4])
		EndIF
	Next nX
	/*
	��������������������������������������������������������������Ŀ
	� Verifica o Total de Registros a Serem Processados            �
	����������������������������������������������������������������*/
	cQuery := "SELECT COUNT(*) NLASTREC "
	cQuery += cQueryCond
	cQuery := ChangeQuery(cQuery)
	IF ( MsOpenDbf(.T.,"TOPCONN",TcGenQry(,,cQuery),"__QRYCOUNT",.T.,.T.) )
		nLastRec := __QRYCOUNT->NLASTREC
		__QRYCOUNT->( dbCloseArea() )
	Else
		MsAguarde( { || SRA->( dbEval( { || ++nLastRec } ) ) } , STR0027 + STR0028 )	//'Aguarde...'###'Selecionaldo Funcionarios'
		SRA->( dbGotop() )
	EndIF
Else
	/*
	�������������������������������������������������������������Ŀ
	� Restaura Arquivo Padrao e Ordem                             �
	���������������������������������������������������������������*/
	ChkFile( "SRA" )
	SRA->( dbSetOrder( 04 ) )
	/*
	��������������������������������������������������������������Ŀ
	� Verifica o Total de Registros a Serem Processados            �
	����������������������������������������������������������������*/
	aRecsBarG := {}
	CREATE SCOPE aRecsBarG FOR Eval( bSraScope )
	SRA->( dbSeek( cFilialDe , .T. ) )
	nLastRec := SRA->( ScopeCount( aRecsBarG ) )
	/*
	�������������������������������������������������������������Ŀ
	� Procura primeiro funcion�rio.                               �
	���������������������������������������������������������������*/
	SRA->( dbSeek( cFilTnoDe , .T. ) )
EndIF

/*
��������������������������������������������������������������Ŀ
� Inicializa a Mensagem para a IncProcG2() ( Funcionarios )	   �
����������������������������������������������������������������*/
IncProcG2( OemToAnsi( STR0017 ) , .F. )	//"Fechando Banco de Horas..."

/*
��������������������������������������������������������������Ŀ
� Inicia regua de processamento.                               �
����������������������������������������������������������������*/
BarGauge2Set( nLastRec )

Begin Sequence

/*
��������������������������������������������������������������Ŀ
� Processa o Calculo Mensal                                    �
����������������������������������������������������������������*/
While SRA->( !Eof() .and. ( ( cFilTnoAtu := ( RA_FILIAL + RA_TNOTRAB ) ) >= cFilTnoDe ) .and. ;
	( cFilTnoAtu <= cFilTnoAte ) )
	
	/*
	��������������������������������������������������������������Ŀ
	� Consiste filtro do intervalo De / Ate                        �
	����������������������������������������������������������������*/
	IF SRA->( !Eval( bSraScope ) )
		SRA->(dbSkip())
		Loop
	EndIF
	
	/*
	��������������������������������������������������������������Ŀ
	� Aborta o processamento caso seja pressionado Alt + A         �
	����������������������������������������������������������������*/
	IF ( lAbortPrint )
		aAdd( aLogDet , STR0021 ) //"O processo de Fechamento de Banco de Horas foi cancelado pelu usuario."
		Break
	EndIF
	
	/*
	��������������������������������������������������������������Ŀ
	� Atualiza a Mensagem para a IncProcG1() ( Turnos )			   �
	����������������������������������������������������������������*/
	cAtuFilTnoSeq :=  ( cFilTnoAtu + SRA->RA_SEQTURN )
	IF !( cOldFilTnoSeq == cAtuFilTnoSeq )
		/*
		��������������������������������������������������������������Ŀ
		� Atualiza o Filial/Turno/Sequencias Anteriores				   �
		����������������������������������������������������������������*/
		cOldFilTnoSeq := cAtuFilTnoSeq
		/*
		��������������������������������������������������������������Ŀ
		� Atualiza a Mensagem para a BarGauge do Turno 				   �
		����������������������������������������������������������������*/
		//"Filial:"###"Turno:"###"Sequencia:"
		cMsgBarG1 := SRA->( STR0014 + " " + RA_FILIAL + " - " + STR0015 + " " + RA_TNOTRAB + " - " + Left(AllTrim(fDesc( "SR6" , RA_TNOTRAB , "R6_DESC" , NIL , RA_TNOTRAB , 01 ) ),50) + " " + STR0016 + " " + RA_SEQTURN )
		/*
		��������������������������������������������������������������Ŀ
		� Verifica se Houve Troca de Filial para Verificacai dis Turnos�
		����������������������������������������������������������������*/
		IF !( cLastFil == SRA->RA_FILIAL )
			/*
			��������������������������������������������������������������Ŀ
			� Atualiza o Filial Anterior								   �
			����������������������������������������������������������������*/
			cLastFil := SRA->RA_FILIAL
			cFilAnt	 := cLastFil
			/*
			��������������������������������������������������������������Ŀ
			� Obtem o % de Incremento da 2a. BarGauge					   �
			����������������������������������������������������������������*/
			nIncPercG1 := SuperGetMv( "MV_PONINC1" , NIL , 5 , cLastFil )
			/*
			��������������������������������������������������������������Ŀ
			� Obtem o % de Incremento da 2a. BarGauge					   �
			����������������������������������������������������������������*/
			nIncPercG2 := SuperGetMv( "MV_PONINCP" , NIL , 5 , cLastFil )
			/*
			��������������������������������������������������������������Ŀ
			� Verifica Periodo de Apontamento							   �
			����������������������������������������������������������������*/
			IF !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .T. , cLastFil )
				aAdd( aLogDet , STR0026 ) //"Periodo para o Fechamento do Banco de Horas invalido"
				Break
			EndIF
			/*
			��������������������������������������������������������������Ŀ
			� Realimenta a Barra de Gauge para os Turnos de Trabalho       �
			����������������������������������������������������������������*/
			IF ( !lSR6Comp .or. ( nRecsSR6 == 0.00 ) )
				CREATE SCOPE aRecsSR6 FOR ( R6_FILIAL == cLastFil .or. Empty( R6_FILIAL ) )
				nRecsSR6 := SR6->( ScopeCount( aRecsSR6 ) )
			EndIF
			/*
			��������������������������������������������������������������Ŀ
			� Define o Contador para o Processo 1                          �
			����������������������������������������������������������������*/
			--nCount1Time
			/*
			��������������������������������������������������������������Ŀ
			� Define o Numero de Elementos da BarGauge                     �
			����������������������������������������������������������������*/
			BarGauge1Set( nRecsSR6 )
			/*
			��������������������������������������������������������������Ŀ
			� Inicializa Mensagem na 1a BarGauge                           �
			����������������������������������������������������������������*/
			IncProcG1( cMsgBarG1 , .F. )
			/*
			��������������������������������������������������������������Ŀ
			� Reinicializa a Filial/Turno Anterior                         �
			����������������������������������������������������������������*/
			cFilTnoOld := "__cFilTnoOld__"
		EndIF
		/*
		��������������������������������������������������������������Ŀ
		�Verifica se Deve Incrementar a Gauge ou Apenas Atualizar a Men�
		�sagem														   �
		����������������������������������������������������������������*/
		IF ( lIncProcG1 := !( cFilTnoOld == cFilTnoAtu ) )
			cFilTnoOld := cFilTnoAtu
		EndIF
		/*
		��������������������������������������������������������������Ŀ
		�Incrementa a Barra de Gauge referente ao Turno				   �
		����������������������������������������������������������������*/
		IncPrcG1Time( cMsgBarG1 , nRecsSR6 , cTimeIni , .F. , nCount1Time , nIncPercG1 , lIncProcG1 )
	EndIF
	
	/*
	��������������������������������������������������������������Ŀ
	� Movimenta a R�gua de Processamento do Processamento Principal�
	����������������������������������������������������������������*/
	IncPrcG2Time( OemToAnsi( STR0017 ) , nLastRec , cTimeIni , .T. , 2 , nIncPercG2 )	//"Fechando Banco de Horas..."
	
	/*
	��������������������������������������������������������������Ŀ
	� Verifica Situacao e Categoria do Funcionario                 �
	����������������������������������������������������������������*/
	IF	!(SRA->RA_SITFOLH $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat)
		SRA->(dbSkip())
		Loop
	EndIF
	
	IF SRA->RA_BHFOL == "N"
		SRA->(dbSkip())
		Loop
	EndIF
	
	/*
	��������������������������������������������������������������Ŀ
	� Consiste controle de acessos e filiais validas               �
	����������������������������������������������������������������*/
	IF SRA->( !(RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA) )
		SRA->(dbSkip())
		Loop
	EndIF
	
	/*
	��������������������������������������������������������������Ŀ
	� Verifica a existencia dos Identificadores 023/024            �
	����������������������������������������������������������������*/
	IF !P080_IDPON(@cEveProv,@cEveDesc,SRA->RA_FILIAL)
		/*
		��������������������������������������������������������������Ŀ
		� Aborta o processamento caso seja pressionado Alt + A         �
		����������������������������������������������������������������*/
		IF ( lAbortPrint )
			aAdd( aLogDet , STR0021 ) //"O processo de Fechamento de Banco de Horas foi cancelado pelu usuario."
			Break
		EndIF
		SRA->( dbSkip() )
		Loop
	EndIF

	//-- Efetua o fechamento dos eventos
	cFilMat	:= SRA->( RA_FILIAL + RA_MAT )

	_aAreaSRA := SRA->(GetArea())

	// Zera as variaveis para novo funcionario - Por Klaus em 25/06/2010
	aSPI		:= {}
	aDelSPI		:= {}
	aSPIProMes 	:= {}
	aSPIDesMes	:= {}
	aSPIProSal 	:= {}
	aSPIDesSal	:= {}
	aSPIDesc    := {}	

	IF SPI->(dbSeek( cFilMat ,.F. ))
		MontVetor(cFilMat) // Monta os vetores a serem manipulados nas outras rotinas
		RestArea(_aAreaSRA)
		FechaMes()
		RestArea(_aAreaSRA)
		FechaTri()
		RestArea(_aAreaSRA)
		fGrava_BH(cEveProv,cEveDesc,aSPI,aDelSPI,dPerFim)
	EndIF
	
	RestArea(_aAreaSRA)
	
	//��������������������������������������������������������������Ŀ
	//� Pr�ximo funcion�rio.                                         �
	//����������������������������������������������������������������
	SRA->( dbSkip() )
Enddo

End Sequence

/*
�������������������������������������������������������������Ŀ
� Fecha a Query do SRA e Restaura o Padrao                    �
���������������������������������������������������������������*/
#IFDEF TOP
	IF ( lSraQryOpened )
		SRA->( dbCloseArea() )
		ChkFile( "SRA" )
	EndIF
#ENDIF

/*
��������������������������������������������������������������Ŀ
� Gera o Log de Inconsistencias                                �
����������������������������������������������������������������*/
IF !Empty( aLogDet )
	aAdd( aLogTitle , STR0018 )	//"Log de Ocorrencias na Geracao de Marcacoes"
	fMakeLog( { aLogDet } , aLogTitle , cPerg )
EndIF

cFilAnt	:= cSvFilAnt

RestArea( aAreaSPI )
RestArea( aAreaSRA )

Return( NIL )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �P080_IDPON� Autor � Equipe Advanced RH	� Data �18/05/2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Codigo dos Eventos dos Identificadores 023/024	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � p080_idpon(cEveProv,cEveDesc,cFil)						  ���
���			 � 															  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cEveProv = Codigos Provento - Resultado do B.H.(023)		  ���
���          � cEveDesc = Codigos Desconto - Resultado do B.H.(024)		  ���
���          � cFil     = Filial Para Pesquisa            	          	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � PONM080													  ���
��������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������*/
Static Function P080_IDPON(cEveProv,cEveDesc,cFil)
Local aInfo	:= {}
Local aArea := SP9->( GetArea() )
Local cMsg	:= ""
Local lRet  := .T.

Begin Sequence

IF ( ( cEveProv := PosSP9("023",cFil,"P9_CODIGO", 2 ) ) == "@" .or. Empty( cEveProv ) ) // Provento
	cMsg := ( STR0019 + " - 023A" ) //"Nao Existe Evento vinculado ao Identificador de Ponto:"
	IF ( aScan( aLogDet , { |x| Upper( AllTrim( x ) ) == Upper( AllTrim( cMsg ) ) } ) == 0.00 )
		aAdd( aLogDet , cMsg  )
	EndIF
	lRet := .F.
	Break
EndIF

IF ( ( cEveDesc := PosSP9("024",cFil,"P9_CODIGO", 2 ) ) == "@" .or. Empty( cEveDesc ) ) // Desconto
	cMsg := ( STR0019 + " - 024A" ) //"Nao Existe Evento vinculado ao Identificador de Ponto:"
	IF ( aScan( aLogDet , { |x| Upper( AllTrim( x ) ) == Upper( AllTrim( cMsg ) ) } ) == 0.00 )
		aAdd( aLogDet , cMsg  )
	EndIF
	lRet := .F.
	Break
EndIF

End Sequence

IF !( lRet )
	fInfo( @aInfo , cFil )
	cMsg := ( STR0020 + " " + cFil + " - " + aInfo[3] )//"Nao foi possivel efetuar o Fechamento do Banco de Horas para a Filial:"
	IF ( aScan( aLogDet , { |x| Upper( AllTrim( x ) ) == Upper( AllTrim( cMsg ) ) } ) == 0.00 )
		aAdd( aLogDet , cMsg  )
	EndIF
EndIF

RestArea( aArea )

Return( lRet )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fGrava_BH � Autor � Amauri Bailon         � Data � 09.01.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechamento do banco de horas                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Record                                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGrava_BH(cEveProv,cEveDesc,aSPI,aDelSPI,dDataGrv)
Local aSPIAux	:= aClone( aSPI )
Local bAsCan	:= { || NIL }
Local cFilMat	:= SRA->( RA_FILIAL + RA_MAT )
Local cMsgErr	:= ""
Local lRet	  	:= .T.
Local lAddNew	:= .F.
Local nPos		:= 0.00
Local nX		:= 0.00
Local nLenX		:= 0.00
Local uRetBlock
Local lExecPad	:= .T.
Local cQueryDesc := ""
Local lFals      := .F.
Local nDesc      := 0
Local aSPIDesc   := {}
//Local lOk		:= .F. //Inserido para validar as informa��es na tabela SPB - Relatorio Resultados Bruno 29/06/2010

aSPI := {}

bAsCan := { |x| x[5] == aDelSPI[ nX ] }
nLenX := Len( aDelSPI )

For nX := 1 To nLenX
	IF ( nPos := aScan( aSPIAux , bAsCan ) ) > 0.00
		aAdd( aSPI , aClone( aSPIAux[ nPos ] ) )
	EndIF
Next nX

aSPIAux	:= aClone( aSPI ) ; aSPI := {}

bAsCan  := { |x| x[1]+x[3] + IF( x[4] == "3" , "1" , x[4] ) == aSPIAux[ nX , 1 ] + aSPIAux[ nX , 3 ] + IF( aSPIAux[ nX , 4 ] == "3" , "1" , aSPIAux[ nX , 4 ] ) }
nLenX	:= Len( aSPIAux )

For nX := 1 To nLenX
	IF ( nPos := aScan( aSPI , bAsCan ) ) > 0.00
		aSPI[ nPos , 2 ] := __TimeSum( aSPI[ nPos , 2 ] , aSPIAux[ nX , 2 ] )
	Else
		aAdd( aSPI , aClone( aSPIAux[ nX ] ) )
	EndIF
Next nX

nLenX := Len( aSPI )

// Inclu�do por Klaus em 27/08/2010
// Verifica qual a margem de acumulo para a categoria. Se o valor for maior que a margem, paga a diferen�a.
//If SRA->RA_SINDICA == cSinRad
//	nBHate := GetMV("MV_RADIALI")
//Else
//	nBHate := GetMV("MV_JORNALI")
//EndIF

// Efetua o somatorio dos eventos de provento - Por Klaus em 27/08/2010
//_nSomaProv := 0
//aEval(aSPI, { |x| If( x[4] $ "1*3", __TimeSum(_nSomaProv,x[02]),) })
//_nContSald := nBHate // Variavel que ir� controlar o saldo at� que ultrapasse o teto para deixar lancar a diferen�a

// Encontra os valores de provento e de desconto para verificar a diferen�a entre eles e somente pagar se for maior que zero - Por Klaus em 27/08/2010
//_nValProv := 0
//_nValDesc := 0
_nValDife := 0

//aEval(aSPI, { |x| If( x[4] $ "1*3", __TimeSum(_nValProv,x[02]),__TimeSum(_nValDesc,x[02])) })

For _nK := 1 to Len(aSPI)
	if ! aSPI[_nK][04] $ "1*3"
	_nValDife := __TimeSum(_nValDife,aSPI[_nK][02])
	endif
Next _nK

//_nValDife := _nValDesc

For nX := 1 To nLenX
		If aSPI[ nX , 4 ] $ "1*3"
			cEveProv := AllTrim( PosSP9( aSPI[ nX , 1 ] , SRA->RA_FILIAL , "P9_CODFOL" , 1 ) )
		Else
			cEveDesc := AllTrim( PosSP9( aSPI[ nX , 1 ] , SRA->RA_FILIAL , "P9_CODFOL" , 1 ) )
		EndIf                                                    ponto
		
		if !(aSPI[nX][04] $ "1*3") .or. ( (aSPI[nX][04] $ "1*3") .and. __TimeSub(aSPI[nX,2],_nValDife) > 0 ) // Incluido por Klaus em 27/08/2010 - Verifica se a quantidade de horas ultrapassou o teto
			
			if aSPI[nX][04] $ "1*3"
    			_nResto := Abs(__TimeSub(aSPI[nX,2],_nValDife)) // Incluido por Klaus em 27/08/2010
    			_nValDife := 0 // Incluido por Klaus em 27/08/2010
			endif
			//_nResto := Abs(__TimeSub(aSPI[nX,2],_nValDife)) // Incluido por Klaus em 27/08/2010
			//_nValDife := 0 // Incluido por Klaus em 27/08/2010
			lAddNew := !SPB->( dbSeek( cFilMat + IF( aSPI[ nX , 4 ] $ "1*3" , cEveprov , cEveDesc ) + aSPI[ nX , 3 ] ) )
			IF RecLock("SPB",lAddNew)
				IF SPB->PB_TIPO2 == "I"
					SPB->PB_HORAS := ( SPB->PB_HORAS + fConvHr( aSPI[ nX , 2 ] , "D" ) )
				Else
					SPB->PB_FILIAL := SRA->RA_FILIAL
					SPB->PB_CC     := aSPI[ nX , 3 ]
					SPB->PB_MAT    := SRA->RA_MAT
					SPB->PB_PD     := IF( aSPI[ nX , 4 ] $ "1*3" , cEveprov , cEveDesc )
					//SPB->PB_HORAS  := fConvHr( aSPI[ nX , 2 ] , "D" )
					SPB->PB_HORAS  := Round((SPB->PB_HORAS + if(!(aSPI[nX][04] $ "1*3"),fConvHr(aSPI[nX,2],"D"),fConvHr(_nResto,"D"))),2) // Alterado por Klaus em 27/08/2010 - Subtraio o teto do valor abatido do BH
					SPB->PB_DATA   := dDataGrv
					SPB->PB_TIPO1  := "H"
					SPB->PB_TIPO2  := "G"
				EndIF
				SPB->( MsUnlock() )
			endif
		else // Incluido por Klaus em 27/08/2010
			_nValDife := Abs(__TimeSub(aSPI[nX,2],_nValDife)) // Incluido por Klaus em 27/08/2010
		endIF
Next nX

nLenX := Len( aDelSPI )

For nX := 1 To nLenX
	SPI->( dbGoto( aDelSPI[ nX ] ) )
	IF RecLock("SPI")
		// Baixa
		SPI->PI_STATUS := "B"
		SPI->PI_DTBAIX := dDtPagto
		SPI->( MsUnlock() )
	EndIF
Next nX



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Autor: Bruno Alves   		�Microsiga           � Data �  15/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Implementacao do programa para descontar horas negativas   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


cQueryDesc += " SELECT PI_FILIAL,PI_MAT,PI_DATA,PI_PD,P9_TIPOCOD,PI_QUANT,PI_DTBAIX,PI_CC, " + InitSqlName("SPI") + ".R_E_C_N_O_ AS R_E_C_N_O_ FROM "
cQueryDesc += InitSqlName("SPI")+ " "
cQueryDesc += "INNER JOIN "
cQueryDesc += InitSqlName("SP9") + " ON "
cQueryDesc += "SPI010.PI_PD = SP9010.P9_CODIGO "
cQueryDesc += "WHERE "
cQueryDesc += InitSqlName("SPI") + ".PI_MAT = '" + (SRA->RA_MAT) + "' AND "
cQueryDesc += InitSqlName("SPI") + ".PI_FILIAL BETWEEN '" + (MV_PAR01) + "'  AND '" + (MV_PAR02) + "' AND "
cQueryDesc += InitSqlName("SPI") + ".PI_DATA BETWEEN '" + DTOS(MV_PAR20) + "'  AND '" + DTOS(MV_PAR21) + "' AND "
cQueryDesc += InitSqlName("SPI") + ".PI_DTBAIX = '' AND "
cQueryDesc += InitSqlName("SPI") + ".PI_STATUS = '' AND "
cQueryDesc += InitSqlName("SPI") + ".D_E_L_E_T_ <> '*' AND "
cQueryDesc += InitSqlName("SP9") + ".D_E_L_E_T_ <> '*' "
cQueryDesc += "ORDER BY " + InitSqlName("SPI") + ".R_E_C_N_O_"

TcQuery cQueryDesc New Alias "DESC"

DbSelectArea("DESC")
DbGotop()


If EOF()
	DbSelectArea("DESC")
	DbCloseArea("DESC")
	Return( lRet )
Else
	While !EOF() .AND. SRA->RA_MAT == DESC->PI_MAT
		
		If DESC->P9_TIPOCOD $ "1*3"
			lFals := .T.
		Else
			aAdd(aSPIDesc,{})
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_MAT)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_DATA)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_PD)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->P9_TIPOCOD)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_QUANT)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->R_E_C_N_O_)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_CC)
			aAdd(aSPIDesc[Len(aSPIDesc)],DESC->PI_FILIAL)
		Endif
		
		DbSelectArea("DESC")
		Dbskip()
		
	Enddo
	
Endif


//Caso tenha horas negativas para serem descontadas, execute o IF.
If lFals != .T.
	
	nLenX	:= Len(aSPIDesc)
	
	For nX := 1 To nLenX
		
		SPI->( dbGoto( aSPIDesc[ nX, 6 ] ) )
		IF RecLock("SPI")
			// Baixa
			SPI->PI_STATUS := "B"
			SPI->PI_DTBAIX := dDtPagto
			SPI->( MsUnlock() )
		EndIF
		 //Soma das horas que serao descontadas
		nDesc := __TimeSum( aSPIDesc[ nX , 5 ] , nDesc )
		
	Next nX
	
	
	 //Grava as horas que serao descontadas na verba conforme informado no parametro
	RecLock("SPB",.T.)
	SPB->PB_FILIAL := aSPIDesc[ 1 , 8 ]
	SPB->PB_CC     := aSPIDesc[ 1 , 7 ]
	SPB->PB_MAT    := aSPIDesc[ 1 , 1 ]
	SPB->PB_PD     := GETMV("MV_DESCPO",.F.,)
	SPB->PB_HORAS  := nDesc
	SPB->PB_DATA   := dDataGrv
	SPB->PB_TIPO1  := "H"
	SPB->PB_TIPO2  := "G"
	SPB->(msUnlock())
	
	                      	
EndIf

DbSelectArea("DESC")
DbCloseArea("DESC")


Return( lRet )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontVetor �Autor  �Alvaro Camillo Neto � Data � 21/11/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que monta os vetores com os apontamentos do BH do fun���
���          �para o tratamento no restante das rotina anterior           ���
�������������������������������������������������������������������������͹��
���Uso       � Customizazao para empresa Record                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MontVetor(cFilMat)

While SPI->( !Eof() .and. PI_FILIAL + PI_MAT == cFilMat )
	
	//��������������������������������������������������������������Ŀ
	//� Aborta o processamento caso seja pressionado Alt + A         �
	//����������������������������������������������������������������
	IF ( lAbortPrint )
		aAdd( aLogDet , STR0021 ) //"O processo de Fechamento de Banco de Horas foi cancelado pelu usuario."
		Break
	EndIF
	
	//-- Limita a Leitura somente do intervalo de Eventos.
	IF !SPI->(PI_PD >= cEveDe .And. PI_PD <= cEveAte)
		SPI->(dbSkip())
		Loop
	EndIF
	
	//-- Desconsidera Lancamentos j� baixados
	IF SPI->PI_STATUS == "B"
		SPI->(dbSkip())
		Loop
	EndIF
	
	
	//-- Verifica tipo de Evento quando for diferente de Ambos
	IF nTpEvento <> 3
		IF !fBscEven(SPI->PI_PD,2,nTpEvento)
			SPI->(dbSkip())
			Loop
		EndIF
	Else
		PosSP9(SPI->PI_PD,SRA->RA_FILIAL)
	EndIF
	
	//-- Se o Evento for Provento/Base
	IF (PosSP9( SPI->PI_PD , SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" )
		//Verifica se o apontamento est� no periodo aberto
		IF (SPI->PI_DATA>=dPerIni .AND. SPI->PI_DATA<=dPerFim)
			aAdd(aSPIProMes,{})
			aAdd(aSPIProMes[Len(aSPIProMes)],SPI->PI_PD)
			aAdd(aSPIProMes[Len(aSPIProMes)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
			aAdd(aSPIProMes[Len(aSPIProMes)],SPI->PI_CC)
			aAdd(aSPIProMes[Len(aSPIProMes)],SP9->P9_TIPOCOD)
			aAdd(aSPIProMes[Len(aSPIProMes)],SPI->(Recno()))
			aAdd(aSPIProMes[Len(aSPIProMes)],SPI->PI_DATA)
		Else
			//se n�o ele est� abaixo do periodo
			If (SPI->PI_DATA<dPerIni)
				aAdd(aSPIProSal,{})
				aAdd(aSPIProSal[Len(aSPIProSal)],SPI->PI_PD)
				aAdd(aSPIProSal[Len(aSPIProSal)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
				aAdd(aSPIProSal[Len(aSPIProSal)],SPI->PI_CC)
				aAdd(aSPIProSal[Len(aSPIProSal)],SP9->P9_TIPOCOD)
				aAdd(aSPIProSal[Len(aSPIProSal)],SPI->(Recno()))
				aAdd(aSPIProSal[Len(aSPIProSal)],SPI->PI_DATA)
			Else
				SPI->(dbskip())
				Loop
			EndIf
		EndIf
	Else
		//-- Se o Evento for Desconto
		IF (SPI->PI_DATA>=dPerIni .AND. SPI->PI_DATA<=dPerFim)
			aAdd(aSPIDesMes,{})
			aAdd(aSPIDesMes[Len(aSPIDesMes)],SPI->PI_PD)
			aAdd(aSPIDesMes[Len(aSPIDesMes)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
			aAdd(aSPIDesMes[Len(aSPIDesMes)],SPI->PI_CC)
			aAdd(aSPIDesMes[Len(aSPIDesMes)],SP9->P9_TIPOCOD)
			aAdd(aSPIDesMes[Len(aSPIDesMes)],SPI->(Recno()))
			aAdd(aSPIDesMes[Len(aSPIDesMes)],SPI->PI_DATA)
		Else
			//se n�o ele est� abaixo do periodo
			If (SPI->PI_DATA<dPerIni)
				aAdd(aSPIDesSal,{})
				aAdd(aSPIDesSal[Len(aSPIDesSal)],SPI->PI_PD)
				aAdd(aSPIDesSal[Len(aSPIDesSal)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
				aAdd(aSPIDesSal[Len(aSPIDesSal)],SPI->PI_CC)
				aAdd(aSPIDesSal[Len(aSPIDesSal)],SP9->P9_TIPOCOD)
				aAdd(aSPIDesSal[Len(aSPIDesSal)],SPI->(Recno()))
				aAdd(aSPIDesSal[Len(aSPIDesSal)],SPI->PI_DATA)
			Else
				SPI->(dbskip())
				Loop
			EndIf
		EndIf
	Endif
	
	aAdd(aSPI,{})
	aAdd(aSPI[Len(aSPI)],SPI->PI_PD)
	aAdd(aSPI[Len(aSPI)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
	aAdd(aSPI[Len(aSPI)],SPI->PI_CC)
	aAdd(aSPI[Len(aSPI)],SP9->P9_TIPOCOD)
	aAdd(aSPI[Len(aSPI)],SPI->(Recno()))
	aAdd(aSPI[Len(aSPI)],SPI->PI_DATA)
	SPI->(dbSkip())
Enddo

Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FechaMes  �Autor  �Alvaro Camillo Neto � Data � 08/05/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que realiza o fechamento do perido atual descontando ���
���          �as horas do periodo anterior                                ���
�������������������������������������������������������������������������͹��
���Uso       � Customizazao para empresa Record                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function FechaMes()
//���������������������������������������������������������������������������������Ŀ
//�O primeiro passo � compensar os debitos do periodo em aberta com o saldo no banco�
//�Depois compenso os creditos atuais com os debito do banco                        �
//�Caso sobre descontos e proventos desse periodo em aberto eu compeso entre eles   �
//�no fim caso sobre proventos eu aplico o limite a ele.                            �
//�����������������������������������������������������������������������������������
DescBH(@aSPIProSal,@aSPIDesMes)
DescBH(@aSPIProMes,@aSPIDesSal)

// Caso ainda haja saldo nos descontos
If !EMPTY(aSPIProMes) .And. !EMPTY(aSPIDesMes)
	DescBH(@aSPIProMes,@aSPIDesMes)
EndIf

If !Empty(aSPIProMes)
	SepBHTot(aSPIProMes)
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DescBH    �Autor  �Alvaro Camillo Neto � Data �  05/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz a compensacao entre um vetor de provento e desconto    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Record                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DescBH(aProvento,aDesconto)

/*
//�����������������������������������������������������������������oremH/�H/��
//�O algoritmo abaixo e passado dois vetores, um de desconto       �
//�e um de proventos.                                              �
//�Elemento a elemento ele subtrai os descontos dos proventos      �
//�e dependendo do resultado acontecera tres situacoes :           �
//�                                                                �
//�a) o resultado foi 0                                            �
//�                                                                �
//�Entao e acrescentado no vetor de baixa o recno dos elementos    �
//�atuais de ambos os vetores, e depois eles sao deletados dos     �
//�vetores                                                         �
//�                                                                �
//�b) o resultado foi maior que 0                                  �
//�                                                                �
//�E o recno dos dois elementos tambem sao adicionados ao vetor de �
//�baixa  porem apenas o elemento do vetor de desconto e           �
//�eliminado enquanto no vetore de proventos eh feita a quebra     �
//�do apontamento                                                  �
//�                                                                �
//�a) o resultado foi menor que 0                                  �
//�                                                                �
//�E o recno dos dois elementos tambem sao adicionados ao vetor de �
//�baixa  porem apenas o elemento do vetor de provento e           �
//�eliminado enquanto no vetor de desconto eh feita a quebra       �
//�                                                                �
//�E ele vai fazendo essa operacao ate um dos vetores terminarem   �
//�����������������������������������������������������������������orem�
*/

Local nSaldo	:= 0.00 //saldo dos proventos menos descontos
While !Empty(aDesconto) .AND. !Empty(aProvento)
	nSaldo:=Round(__TimeSub(aProvento[1,2],aDesconto[1,2]),2) // Arredondado por Klaus em 25/06/2010 BRUNO
	
	If Empty(nSaldo) //se o saldo for vazio eu zero tanto o desconto como o provento redimensiono os arrays
		aAdd(aDelSPI,aProvento[1,5])
		aAdd(aDelSPI,aDesconto[1,5])
		aDel(aProvento,1)
		aSize(aProvento,Len(aProvento)-1)
		aDel(aDesconto,1)
		aSize(aDesconto,Len(aDesconto)-1)
	Else
		If nSaldo>0.00 //se o nSaldo for positivo significa que ainda h� saldo no Provento
			aAdd(aDelSPI,aDesconto[1,5])
			aDel(aDesconto,1)
			aSize(aDesconto,Len(aDesconto)-1)
			aProvento[1,2]:=nSaldo
			If Empty(aDesconto)
				CriaRegSPI(aProvento[1,5],nSaldo)//cria um registro de provento com as horas do provento-saldo e retorna o recno do novo registro
			EndIf
		Else //se o nSaldo for negativo significa que ainda h� saldo no Desconto
			aAdd(aDelSPI,aProvento[1,5])
			aDel(aProvento,1)
			aSize(aProvento,Len(aProvento)-1)
			nSaldo *=-1
			aDesconto[1,2]:=(nSaldo)
			If Empty(aProvento)
				CriaRegSPI(aDesconto[1,5],nSaldo)//cria um registro de desconto com as horas de desconto-saldo e retorna o recno do novo registro
			EndIf
		EndIf
	EndIf
	nSaldo:=0
END
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaRegSPI�Autor  �Alvaro Camillo Neto � Data �  08/05/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a quebra do apontamento                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Record                                                     ���
�������������������������������������������������������������������������͹��
���PArametros�rAnt-recno do registro a ser alterado                       ���
���          �nSaldo - Saldo que fica no banco	                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaRegSPI(recAnt,nSaldo,lret)
Local nValorN	:= 0
Local nValorV	:= 0
Local aArea		:= GetArea()
Local nT			:= 0
Local cCc		:= 0
Local cPd 		:= 0
Local dDtLacto	:= 0
Local recNovo	:= 0

DEFAULT lret := .T. //ira retorna o recno do registro criado

SPI->(dbGoTo(recAnt))
nT = aScan(aSPI,{|x| x[5] == recAnt})
//if nt <= 0
//  nt := 1
//Endif

nValorN := SPI->PI_QUANT
nValorV := SPI->PI_QUANTV

If nUtiliz == 1	// Horas Normais
	nValorN := nSaldo
	nValorV := Round(fConvHr(nValorN,"D")*(fBscEven(aSPI[nT,1],1)/100),2)
	nValorV := fConvhr(nValorV,"H")
	aSPI[nT,2] := nValorN
Else					// Horas Valorizadas
	nValorV := nSaldo
	nValorN := Round(fConvHr(nValorV,"D")/(fBscEven(aSPI[nT,1],1)/100),2)
	nValorN := fConvhr(nValorN,"H")
	aSPI[nT,2] := nValorV
Endif
nValN	:= Round(__TimeSub(SPI->PI_QUANT,nValorN),2) // Arredondado Por Klaus em 25/06/2010
nValV   := Round(fConvHr(nValN,"D")*(fBscEven(aSPI[nT,1],1)/100),2)
nValV   := fConvhr(nValV,"H")

Begin Transaction
// Grava Lacto atual
IF SPI->( RecLock("SPI") )
	SPI->PI_QUANT	:= nValorN
	SPI->PI_QUANTV	:= nValorV
	SPI->( MsUnlock() )
EndIF
cCc			:= SPI->PI_CC
cPd 			:= SPI->PI_PD
dDtLacto		:= SPI->PI_DATA
// Cria Lacto com valor restante
IF nValN > 0
	IF SPI->( RecLock("SPI",.T.) )
		SPI->PI_FILIAL	:= SRA->RA_FILIAL
		SPI->PI_MAT		:= SRA->RA_MAT
		SPI->PI_PD		:= cPd
		SPI->PI_DATA	:= dDtLacto
		SPI->PI_QUANT	:= nValN
		SPI->PI_QUANTV	:= nValV
		SPI->PI_FLAG	:= "G"
		SPI->PI_CC		:= cCc
		SPI->( MsUnlock() )
	EndIF
	//-- Cria o novo elemento em aSPI (Eventos do B.H.)
	aAdd(aSPI,{})
	aAdd(aSPI[Len(aSPI)],SPI->PI_PD)
	aAdd(aSPI[Len(aSPI)],IF( nUtiliz == 1 , SPI-> PI_QUANT , SPI->PI_QUANTV ) )
	aAdd(aSPI[Len(aSPI)],SPI->PI_CC)
	aAdd(aSPI[Len(aSPI)],SP9->P9_TIPOCOD)
	aAdd(aSPI[Len(aSPI)],SPI->(Recno()))
	aAdd(aSPI[Len(aSPI)],SPI->PI_DATA)
	//-- Acrescenta o novo elemento na relacao de registros a serem abaixados
	aAdd(aDelSPI,SPI->(Recno()))
ENDIF
End Transaction

recNovo = SPI->(Recno())
RestArea(aArea)
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SepBHTot � Autor � Alvaro Camillo Neto   � Data � 02.02.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo distribui as horas extra entre o banco de horas    ���
���          � e a folha de pagamento                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Record                                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SepBHTot(aProvento)
Local nP      := 0
Local nSaldo  := 0
Local nTotal  := 0
Local nFolha  := 0
Local nAux	  := 0
Local nBHate  := 0
Local lLimite := .F. //indica que passou o limite e todas as horas a partir de ent�o ir�o para o resultado

If SRA->RA_SINDICA == cSinRad
	nBHate := GetMV("MV_RADIALI") // Parametro para verificar limite horas mensal para o banco de horas
Else
	nBHate := GetMV("MV_JORNALI") // Parametro para verificar limite horas mensal para o banco de horas
EndIF

For nP:=1 To Len(aProvento)
	If !(lLimite)
		nSaldo := aProvento[nP,2]
		nAux := __TimeSum(nTotal,nSaldo)
		If nAux < nBHAte
			nTotal :=nAux
		Else
			nFolha:=Round(__TimeSub(nAux,nBHAte),2) // Arredondado por Klaus em 25/06/2010
			nBH := Round(__TimeSub(nSaldo,nFolha),2) // Arredondado por Klaus em 25/06/2010
			If nFolha>0.00
				CriaRegSPI(aProvento[nP,5],nBH)
			EndIf
			lLimite=.T.
		EndIf
	Else
		aAdd(aDelSPI,aProvento[nP,5])
	EndIf
Next nP

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FechaTri � Autor � Alvaro Camillo Neto   � Data � 09.05.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Baixa todos os proventos do periodo que o usuario informa  ���
���          � na pergunta data de proventos                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Record                                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FechaTri()
Local ni := 0
If !Empty(dPerIniP) .AND. !Empty(dPerFimP)
	For ni := 1 to Len(aSPI)
		// Se ele for provento e n�o tiver sido baixado e estiver compreendido no periodo informado eu baixo ele
		IF( aSPI[ni,4] $ "1*3" ) .AND. (aScan(aDelSPI,aSPI[ni,5])==0) .AND. (aSPI[ni,6]>= dPerIniP .AND. aSPI[ni,6] <= dPerFimP)
			aAdd(aDelSPI,aSPI[ni,5])
		EndIf
	Next i
EndIf
Return()

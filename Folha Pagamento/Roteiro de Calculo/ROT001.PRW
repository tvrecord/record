#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROT001    � Autor � Hermano Nobre      � Data �  20.11.06   ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DA MENSALIDADE ASSOCIATIVA           ���
�������������������������������������������������������������������������͹��
���	A empresa descontar� do funcion�rio a mensalidade associativa  conf.  ���
��� percentuais identificados no cadastro do sindicato. Limitado          ���
��� ao teto de desconto configurado no mesmo cadastros.                   ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00667 -       ���
���          EXECBLOCK("ROT001",.F.,.F.) 							      ���
���                														  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/          

User Function ROT001()

Local aArea			:= GetArea()
Local _nValDesc		:= 0
Local _nTeto    	:= 0
Local _nPercMens	:= 0
Local _cTpbase		:= ""
Local cVerbas		:= ""
Local nValor  		:= 0
       
If SRA->RA_MENSALI == "S" // Funcionario tem mensalidade associativa
	
	DbSelectArea("RCE") // Abre cadastro de sindicatos
	DbSetOrder(1)
	DbSeek(SRA->RA_FILIAL + SRA->RA_SINDICA)
	_cTpBase	:= RCE->RCE_TPBASE  	// 1= SALARIO BASE   2= REMUNERACAO
	_nPercMens	:= RCE->RCE_PERMEN
	_nTeto 		:= RCE->RCE_TETOME
	
	// Query que consulta quais verbas possui mensalidade associativa igual a SIM
	// para calculo do valor quando tipo de base igual a 2 (remuneracao).
	cQuery  := " SELECT RV_COD FROM "+RetSqlName("SRV")
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND RV_MENSASS = 'S'"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QSRV',.T.,.T.)
	//TcQuery cQuery New Alias "QSRV"
	DbSelectArea("QSRV")
	While QSRV->(!Eof())
		cVerbas += QSRV->RV_COD+","
		QSRV->(DbSkip())
	EndDo
	
	cVerbas := Substr(cVerbas,1,(Len(cVerbas)-1)) //- PARA TIRAR A ULTIMA VIRGULA
	nValor	:= fBuscaPd(cVerbas)
		
	If _nPercMens > 0
		_nValDesc := Round((IIF(_cTpBase=="1",SRA->RA_SALARIO,nValor) * _nPercMens)/100,2)
		If _nTeto > 0  .And. _nValDesc > _nTeto  // valor do desconto calculado maior que teto
				_nValDesc := _nTeto
		EndIf
		If _nValDesc > 0
			fDelPd("408")
			fGeraVerba("408",_nValDesc,1,,,,,,,,.t.)
		EndIf
		_nValDesc := 0
	EndIf
	QSRV->(DbCloseArea())
EndIf
RestArea(aArea)

Return
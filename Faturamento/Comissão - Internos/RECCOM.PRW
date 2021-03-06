#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RECCOM    � Autor � Cristiano D. Alves � Data �  08/03/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Rec�lculo de comiss�es para vendedores Internos.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento - Record Brasilia                              ���
�������������������������������������������������������������������������ͼ��
���Campos Personalizados: A3_TPVEND = I=Interno, E=Externo                ���
���						  A3_FXCOMIS= Informar c�digo da faixa de comiss�o���
���Tabela Personalizada : SZ7 - Faixa de valores para comiss�o			  ���
���Campos Personalizados: Z7_FILIAL = Filial do sistema					  ���
���						  Z7_COD    = Codigo da faixa                     ���
���						  Z7_FATINI = Faturamento de? (Faixa Inicial)     ���
���						  Z7_FATFIM = Faturamento at�? (Faixa Final)	  ���
���						  Z7_PERC   = Percentual de comiss�o.       	  ���
���               Indice: Z7_FILIAL+Z7_COD			                      ���
���      Consulta Padr�o: SZ7               							  ���
���Campos Personalizados: C5_CALCCOM = Calcula Comiss�o? "S/N"            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RECCOM()

Local _cQryBx	:= ""
Local _nBase, _nComEx
Local _nFatLiq	:= 0

Private cPerg	:= "RECCOM"

ValidPerg()
pergunte(cPerg,.T.)

//Verifica faturamento liquido
FatLiq()

_cQryBx	+= "SELECT "
_cQryBx	+= "E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_PEDIDO, "
_cQryBx	+= "E1_VALOR, E1_BAIXA, E1_SALDO, C5_VEND1, C5_COMIS1 "
_cQryBx	+= "FROM "
_cQryBx	+= " "+RetSqlName("SE1")+" SE1, "
_cQryBx	+= " "+RetSqlName("SC5")+" SC5 "
_cQryBx	+= "WHERE E1_BAIXA BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR03)+"' "
_cQryBx	+= "AND E1_PEDIDO = C5_NUM "
_cQryBx	+= "AND C5_CALCCOM = 'S' "
_cQryBx	+= "AND E1_PEDIDO <> '' "
_cQryBx	+= "AND SE1.D_E_L_E_T_ = '' "
_cQryBx	+= "AND SC5.D_E_L_E_T_ = '' "
_cQryBx	+= "ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA"

//TcQuery _cQryCom New Alias "TBX"
//TcQuery _cQryBX New Alias "TBX"

//Cadastro de Vendedores
SA3->(dbSetOrder(1))
//Cadastro de Faixa de comiss�es
SZ7->(dbSetOrder(1))

dbSelectArea("TBX")
dbGoTop()

While !TBX->(Eof())
	
	_nBase := 0
	
	//Verifica se houve comiss�o para ag�ncia
	If TBX->C5_COMIS1 > 0
		_nComEx	:= Round(((TBX->E1_VALOR * TBX->C5_COMIS1)/100),2) //Comiss�o Agencia (Externos)
		_nBase 	:= Round((TBX->E1_VALOR - _nComEx),2)  //Base comiss�o Internos
	Else
		_nBase 	:= TBX->E1_VALOR
	EndIf
	
	//�������������������������������������������������������������������������������������������Ŀ
	//�Posiciona no arquivo de vendedores. Ir� gravar registros para todos os vendedores internos.�
	//���������������������������������������������������������������������������������������������
	
	While !SA3->(Eof()) .and. A3_TPVEND == "I"                       
	
		dbSelectArea("SZ8")
		dbSetOrder(1)
//		If dbSeek(xFilial()+Substr(DtoS(MV_PAR03,1,4))+Substr(DtoS(MV_PAR03,5,2)))  
			_nFatLiq	:= SZ8->Z8_VALOR
//		EndIf
		
		SZ7->(dbSeek(xFilial()+A3_FXCOMIS)) //Posiciona para verificar o cod. da faixa de comissao
		//Verifica em qual faixa o vendedor est� enquadrado em rela��o ao faturamento
		Do Case
			Case _nFatLiq >= Z7_FATINI01 .or. _nFatLiq <= Z7_FATFIM01 //Primeira faixa
				_nPerc	:= Z7_PERC01
			Case _nFatLiq >= Z7_FATINI02 .or. _nFatLiq <= Z7_FATFIM02 //Segunda faixa
				_nPerc	:= Z7_PERC02
			Case _nFatLiq >= Z7_FATINI03 .or. _nFatLiq <= Z7_FATFIM03 //Terceira faixa
				_nPerc	:= Z7_PERC03
			Case _nFatLiq >= Z7_FATINI04 .or. _nFatLiq <= Z7_FATFIM04 //Quarta faixa
				_nPerc	:= Z7_PERC04
			Case _nFatLiq >= Z7_FATINI05 .or. _nFatLiq <= Z7_FATFIM05 //Quinta faixa
				_nPerc	:= Z7_PERC05
			Case _nFatLiq >= Z7_FATINI06 .or. _nFatLiq <= Z7_FATFIM06 //Sexta faixa
				_nPerc	:= Z7_PERC06
		EndCase
		
		//Grava registros na tabela de comiss�es espec�fica
		dbSelectArea("SZ7")
		dbSetOrder(1)
		
		RecLock("SZ7",.T.)
		SZ7->Z7_FILIAL 	:= xFilial("SZ7")                  
		SZ7->Z7_NUM		:= TBX->E1_NUM
		SZ7->Z7_EMISSAO	:= CtoD(TBX->E1_EMISSAO)
		SZ7->Z7_PREFIXO := TBX->E1_PREFIXO
		SZ7->Z7_CODCLI	:= TBX->E1_CLIENTE
		SZ7->Z7_LOJA	:= TBX->E1_LOJA
		SZ7->Z7_BASE	:= _nBase
		SZ7->Z7_PORC	:= _nPerc
		SZ7->Z7_COMIS	:= Round(((_Base * _nPerc)/100),2) 
		SZ7->Z7_DATA	:= dDataBase
		SZ7->Z7_PARCELA	:= TBX->E1_PARCELA
		SZ7->Z7_VENCTO	:= TBX->E1_VENCREA
		SZ7->Z7_DTBAIXA	:= TBX->E1_BAIXA	
		SZ7->(MsUnlock)
		
		SA3->(dbSkip())
		Loop
	EndDo
	
	TBX->(dbSkip())
	Loop
	
EndDo

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATLIQ    �Autor  �Cristiano D. Alves  � Data �  09/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel para buscar o faturamento liquido do mes���
���          � para verificar qual % de comissao sera aplicado.           ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record - Financeiro                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function FatLiq()

Local _cQrySum 	:= ""
Local _nCom, _nBsCom, _nTotal, _nFatLiq
Local _lRet 	:= .F.

dbSelectArea("SZ8")
dbSetOrder(1)
//If !(dbSeek(xFilial()+Substr(DtoS(MV_PAR03,1,4))+Substr(DtoS(MV_PAR03,5,2))))
	_lRet	:= .T.
//Else
	_lRet	:= MsgYesNo("M�s j� calculado! Deseja recalcular?")
//EndIf

If _lRet
	_cQrySum += "SELECT D2_FILIAL, D2_SERIE, D2_DOC, D2_PEDIDO, SUM(D2_TOTAL) TOTAL, C5_COMIS1 "
	_cQrySum += "FROM "
	_cQrySum += " "+RetSqlName("SD2")+" SD2, "
	_cQrySum += " "+RetSqlName("SC5")+" SC5 "
	_cQrySum += "WHERE D2_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR03)+"' "
	_cQrySum += "AND D2_PEDIDO = C5_NUM "
	_cQrySum += "AND C5_CALCCOM = 'S' "
	_cQrySum += "AND SD2.D_E_L_E_T_ = ' ' "
	_cQrySum += "AND SC5.D_E_L_E_T_ = ' ' "
	_cQrySum += "GROUP BY D2_FILIAL, D2_SERIE, D2_DOC, D2_PEDIDO, C5_COMIS1 "
	_cQrySum += "ORDER BY D2_FILIAL, D2_SERIE, D2_DOC"
	
//	TcQuery _cQrySum New Alias "SUM"
	
	dbSelectArea("SUM")
	dbGoTop()
	
	While !SUM->(Eof())
		//Existem vendas com comissoes zeradas
		If SUM->C5_COMIS1 > 0
			_nCom	:= Round(((SUM->TOTAL * SUM->C5_COMIS1)/100),2) //Comiss�o Agencia (Externos)
			_nBsCom 	:= Round((SUM->TOTAL - _nCom),2)  //Base comiss�o Internos
		Else
			_nBsCom 	:= SUM->TOTAL
		EndIf
		
		_nTotal += _nBsCom //Recebe os valores para faturmento total
		
		SUM->(dbSkip())
		Loop
	EndDo
	
	RecLock("SZ8",.T.)
	//SZ8->Z8_MESANO 	:= Substr(DtoS(MV_PAR03,1,4)+Substr(DtoS(MV_PAR03,5,2)))
	SZ8->Z8_VALOR	:= _nTotal
	SZ8->(MsUnlock())
		
	SUM->(dbCloseArea)
Else
//	Exit
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ValidPerg    �Autor �  Cristiano D. Alves  �Data� 13.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Do Vendedor        ?","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"02","Ate o Vendedor     ?","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"03","Da Emissao         ?","","","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Emissao      ?","","","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
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

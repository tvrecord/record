#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROT006    � Autor � Hermano Nobre      � Data �  24.11.06   ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DO AUXILIO DOENCA.            		  ���
�������������������������������������������������������������������������͹��
���	A empresa conceder� ao funcionario a partir do 16� dia e at� o 90�   l)�
��� de afastamento a complementa��o do salario base.                      ���
���                                                                       ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00661 -       ���
���          EXECBLOCK("ROT006",.F.,.F.) 							      ���
���                														  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROT006()

Local nDiasMov		:= 0
Local nDiasAfastado := 0
Local nDias			:= 0
Local nValor		:= 0
Local nCompl		:= 0        
Local nVezes		:= 0
Local nPeriodo		:= 1
Local dDataIni		:= CTOD('  /  /  ')
Local dDataFim		:= CTOD('  /  /  ')
Local dDataMov		:= CTOD('  /  /  ')
Private aArea		:= GetArea()

IF nDiasAfas > 0
	dbSelectArea("RCE") // Abre cadastro de sindicatos
	DbSetOrder(1)
	DbSeek(SRA->RA_FILIAL + SRA->RA_SINDICA)
	If RCE->RCE_AUXDOE == "S"
		dbSelectArea("SR8")
		dbSetOrder(2)
		dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"001",.T.)
		While !Eof() .And. SR8->R8_FILIAL + SR8->R8_MAT == SRA->RA_FILIAL+SRA->RA_MAT
			If SR8->R8_TIPO == "004" // tipo doen�a
				AADD(aAfast,{SR8->R8_MAT,;	// [1] matricula
				SR8->R8_SEQ,; 				// [2] sequencia
				SR8->R8_DATA,;				// [3] data do afastamento
				SR8->R8_COMPAUX,;			// [4] complemento aux. Doenca
				SR8->R8_DURACAO,;			// [5] dura��o do afastamento
				SR8->R8_CONTINU,;			// [6] se � continuacao
				SR8->R8_CONTAFA,;			// [7] Numero seq afastamento anterior
				SR8->R8_ULTRECE,;			// [8] Ultimo receb. auxilio doenca
				SR8->R8_DATAINI,;			// [9] Data Inicio do afastamento
				SR8->R8_DATAFIM})			// [10] Data fim do afastamento
			EndIf
			dbSelectArea("SR8")
			dBSkip()
			Loop
		EndDo
		
		nLen 	:= Len(aAfast)
		// Calculo do periodo tem que ser maior que 12 meses
		If nLen > 1
			nLin	:= nLen + 1
			While nLin > 1
				nLin --
				If aAfast[nLin][7] == Space(03)
					nVezes ++
					If nVezes == 2
						If Empty(aAfast[nLin][8])
							nPeriodo := U_CalcAnos(aAfast[nlin][8],dDataBase)
						Else
							nVezes --
						EndIf
					EndIf
				EndIf
				dbSkip()
			End
		EndIf
		
		// Se for continua��o do anterior entra p/ calculo do total de dias
		If aAfast[nLen][6] == "1"
			nLin	:= Len(aAfast)
			nDias := aAfast[nLin][5]
			While aAfast[nLin][7] >= "001"  // Busca total de dias do afastamento
				nLin --
				nDias	 += aAfast[nLin][5]
				dDataIni := aAfast[nLin][9]
				dbSkip()
			End
		Else
			nDias	 := aAfast[nLen][5]
			dDataIni := aAfast[nLen][9]
		EndIf
		If Empty(aAfast[nLen][10])
			dDataFim := dDataBase
		Else
			dDataFim := aAfast[nLen][10]
		EndIf
		dDataMov	:= dDataIni
		While dDataMov <= dDataFim
			nDiasMov	++
			If dDataMov >= CTOD('01/'+Strzero(Month(dDataBase),2)+"/"+Str(Year(dDataBase),4)) .And. ;
				nDiasMov > 15 .And. nDiasMov <= 90
				nDiasAfastado	++
			EndIf
			dDataMov += 1
		End
		If nDiasAfastado > 0
			nValor	:= Round((SRA->RA_SALARIO / 30) * nDiasAfastado,2)
			nCompl	:= nValor - aAfast[nLen][4]
			If nCompl > 0
				If nPeriodo >= 1
					fDelPd("291")
					fGeraVerba("291",nCompl,nDiasAfastado,,,,,,,,.t.)
					AtuSR8(aAfast[nLen][2],aAfast[nLen][3])  // Atualiza data do ultimo
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return

*******************************************
* Rotina para atualizacao no SR8
*******************************************

Static Function AtuSR8(nSeq,dData)

dbSelectArea("SR8")
dbSetOrder(2)
If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+nSeq+DTOS(dData)+"P")
	Reclock("SR8",.F.)
	SR8->R8_ULTRECE := dDataBase
	MsUnlock()
EndIf

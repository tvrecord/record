#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �ROT003    � Autor � Hermano Nobre      � Data �  21.11.06   ���
�������������������������������������������������������������������������͹��
��� Desc.    � PROGRAMA PARA CALCULO DA CONTRIBUICAO SOCIAL(ASSISTENCIAL) ���
�������������������������������������������������������������������������͹��
���	A empresa descontar� do funcion�rio a contribuicao social (assistencial)�
��� conforme os percentuais indicados no cadastro de  sindicatos          ���
���                                                                       ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00675 -       ���
���          EXECBLOCK("ROT003",.F.,.F.) 							      ���
���                														  ���
�������������������������������������������������������������������������͹��
��� Uso      � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROT003()

Local aArea			:= GetArea()
Local _nValDesc		:= 0
Local cVerbas		:= ""
Local _cDiaTrab		:= ""
Local _nPerc		:= 0
Local _cMes     	:= 0
Local nValor  		:= 0

If SRA->RA_ASSISTE == "S" // Funcionario autorizou desconto da contrib. social (assistencial)
	
	DbSelectArea("RCE") // Abre cadastro de sindicatos
	DbSetOrder(1)
	DbSeek(SRA->RA_FILIAL + SRA->RA_SINDICA)
	_cDiaTrab	:= RCE->RCE_DIATRA  	// S = contrib calculada s/ 1 dia de trabalho
	_nPerc		:= RCE->RCE_PERASS
	_cMes  		:= RCE->RCE_MESASS
	
	If StrZero(Val(_cMes),2) == StrZero(Month(dDataBase),2) //verifica se esta dentro do mes
		If _cDiaTrab == "S"  // se calcula sobre 1 dia trabalhado 
			_nValDesc := Round(SRA->RA_SALARIO/30,2)
		Else 				// se calcula por %
			_nValDesc := Round((SRA->RA_SALARIO * _nPerc)/100,2)
		EndIf
		If _nValDesc > 0
			fDelPd("423")
			fGeraVerba("423",_nValDesc,1,,,,,,,,.t.)
		EndIf
		_nValDesc := 0
	EndIf

EndIf 

RestArea(aArea)

Return
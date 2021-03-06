#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RTCTBA04     �Autor  �Edmilson D. Santos � Data �  22/01/08 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa executado atrav�s do ponto de entrada FA080TIT(), ���
���          � Gravando o proximo n�mero de cheque no cadastro de Banco.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RTCTBA11()

Local xCheque
Local aSvAlias
Local lRetorno := .T.

Private cArqTxt := "C:\ATIVO.TXT"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  21/01/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo
Local _Sep    := "|"

ProcRegua(RecCount()) // Numero de registros a processar

DBSELECTAREA("SN4")
DBSETORDER(1)

While !SN4->(EOF())
	
	IF !TRIM(SN4->N4_CONTA) $ "132040001/132050001/132090002/132900003" .AND. !SN4->N4_OCORR $ "05"
		DBSKIP()
		LOOP
	ENDIF
	
	cBaseAnt := SN4->N4_CBASE
	I := 1
	While !SN4->(EOF()) .AND. SN4->N4_CBASE == cBaseAnt
		
		IF !TRIM(SN4->N4_CONTA) $ "132040001/132050001/132090002/132900003" .AND. !SN4->N4_OCORR $ "05"
			DBSKIP()
			LOOP
		ENDIF
		
		
		IF cBaseAnt == SN4->N4_CBASE .AND. I > 1
			
			cLin    := ""
			
			cLin := Alltrim(SN4->CT7_CONTA)+_Sep
			cLin += SN4->N4_CBASE +_Sep
			cLin += SN4->N4_VALOR +_Sep
			
			cLin += cEOL
			
			
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif
			Endif
			
		ENDIF
		
		I++
		
		SN4->(dbSkip())
		
	END
	
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oGeraTxt)

Return

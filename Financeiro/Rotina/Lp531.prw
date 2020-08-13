#include 'rwmake.ch'
                           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP531     �Autor  �Alexandre Zapponi   � Data �  19/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o valor a ser contabilizado no cancelamento ou ex- ���
���          � clus�o da baixa a pagar.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro / LP 531                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Lp531(cSeq)

Local nValor	:= 0
Local nRecno	:=	SE5->(Recno())

if	cSeq == "001"
	if	Upper(Alltrim(FunName())) == "FINA080"

		//Inverso LP 530-01
		//IF(SE5->E5_MOTBX$"DEB,DOC,TED".OR.!EMPTY(SE2->E2_NUMBCO).OR.LEFT(SE5->E5_BANCO,1)$"C",SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->E5_VLJUROS+SE5->E5_VLDESCO-SE5->E5_VLCORRE,0)                                                      

		if SE5->E5_MOTBX $ "DEB,DOC,TED" .or. !Empty(SE2->E2_NUMBCO) .or. Left(SE5->E5_BANCO,1) == "C"
		   nValor := SE5->(E5_VALOR-E5_VLMULTA-E5_VLJUROS+E5_VLDESCO-E5_VLCORRE)
		endif
	else
	
		//LP 531-01
		//IF(TRIM(SE5->E5_TIPODOC)$"ES".OR.!EMPTY(SE2->E2_NUMBCO).OR.LEFT(SE5->E5_BANCO,1,1)$"C",SE5->E5_VALOR-SE5->E5_VLMULTA-SE5->E5_VLJUROS+SE5->E5_VLDESCO-SE5->E5_VLCORRE,0)                                                     
	
		if	Alltrim(SE5->E5_TIPODOC) == "ES" .or. !Empty(SE2->E2_NUMBCO) .or. Left(SE5->E5_BANCO,1) == "C"
		   nValor := SE5->(E5_VALOR-E5_VLMULTA-E5_VLJUROS+E5_VLDESCO-E5_VLCORRE)
		endif
	endif
	
elseif cSeq == "002"
	if	Upper(Alltrim(FunName())) == "FINA080"

		// Inveros LP 530-02
		//IF(SE5->E5_MOTBX$"DEB,TED,DOC".OR.!EMPTY(SE2->E2_NUMBCO).OR.LEFT(SE5->E5_BANCO,1)$"C",SE5->E5_VALOR,0)

		if SE5->E5_MOTBX $ "DEB,TED,DOC" .or. !Empty(SE2->E2_NUMBCO) .or. Left(SE5->E5_BANCO,1) == "C"
			nValor := SE5->E5_VALOR
		endif	
	else

		//LP 531-02 
		//IF(ALLTRIM(SE5->E5_TIPODOC)=="ES".OR.!EMPTY(SE2->E2_NUMBCO).OR.LEFT(SE5->E5_BANCO,1)$"C",SE5->E5_VALOR,0)
	
		if	Alltrim(SE5->E5_TIPODOC) == "ES" .or. !Empty(SE2->E2_NUMBCO) .or. Left(SE5->E5_BANCO,1) == "C"
			nValor := SE5->E5_VALOR
		endif
	endif
endif

Return ( nValor )

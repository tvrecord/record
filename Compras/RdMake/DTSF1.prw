#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

User Function DTSF1()

//Rafael - Grava datas reais de lançamentos das NFs

Local cQuery   := ""
Local dData	   := CTOD("//")

If MsgYesNo("Deseja gravar data de lançamento das Notas Fiscais?")
	
	cQuery := "SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DTREAL,R_E_C_N_O_ "
	cQuery += "FROM SF1010 WHERE D_E_L_E_T_ = '' AND F1_FILIAL = '01' AND R_E_C_N_O_ >= 46000 AND F1_DTREAL = '' "
	cQuery += "ORDER BY R_E_C_N_O_ "
	
	TcQuery cQuery New Alias "TMPSF1"
	
	dbSelectArea("TMPSF1")
	dbGotop()
	
	While !EOF()
		
		DbSelectArea("SF1")
		DbSetOrder(1)
		IF DbSeek(TMPSF1->F1_FILIAL + TMPSF1->F1_DOC + TMPSF1->F1_SERIE + TMPSF1->F1_FORNECE + TMPSF1->F1_LOJA)
			
			dData	 := CTOD(FWLeUserlg("F1_USERLGI", 2))
			
			RECLOCK("SF1",.F.)
			F1_DTREAL := dData
			MSUNLOCK()
			
		ENDIF
		
		DBSelectArea("TMPSF1")
		DBSKIP()
		
	Enddo
	
	dbSelectArea("TMPSF1")
	dbCloseARea("TMPSF1")
	
	MsgInfo(" Datas inseridas com sucesso!")
	
ENDIF

Return

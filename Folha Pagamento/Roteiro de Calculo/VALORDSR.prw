#INCLUDE "PROTHEUS.CH"

//Rafael França - 20/06/18 - Valoriza DSR com SALMES para verbas de hora extra 

User Function VALORDSR()

IF fBuscaPD("014") != 0 .OR. fBuscaPD("009") != 0  //Verifica se recebe hora extra
	
	IF fBuscaPD("016") != 0 //VErifica se paga DSR sobre HE    
	
	aPd[fLocaliaPd("016"),5] := (((fBuscaPD("014") + fBuscaPD("009"))/SRG->RG_NORMAL) * SRG->RG_DESCANS)
	
	ENDIF
		
ENDIF

Return
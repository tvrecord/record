#INCLUDE "PROTHEUS.CH"

//Rafael França - 12/06/18 - Ajusta saldo do salario ("065") sem as verbas "118" e "060" para

User Function AJUSSALDO25()

Local nSaldoAnt := fBuscaPD("065")

IF fBuscaPD("065") != 0 .AND. fBuscaPD("118") != 0 .AND. SRA->RA_HEFIX25="S"  //Retira o calculo da hora contratual 25 proporcinal do saldo do salario
	
	IF fBuscaPD("060") != 0
		nSaldoAnt := fBuscaPD("065")-fBuscaPD("118")-fBuscaPD("060")
	ELSE
		nSaldoAnt :=	fBuscaPD("065")-fBuscaPD("118")
	ENDIF
	
	fGeraVerba("065",nSaldoAnt,diastrab,,,,,,,,.T.)
	
ELSEIF fBuscaPD("065") != 0 .AND. fBuscaPD("122") != 0 .AND. SRA->RA_HEFIX50="S"
	
	IF fBuscaPD("060") != 0
		nSaldoAnt := fBuscaPD("065")-fBuscaPD("122")-fBuscaPD("060")
	ELSE
		nSaldoAnt :=	fBuscaPD("065")-fBuscaPD("122")
	ENDIF
	
	fGeraVerba("065",nSaldoAnt,diastrab,,,,,,,,.T.)
	
//ELSE
	
//	fGeraVerba("065",(SRA->RA_SALARIO/30) * DIASTRAB,,,,,,,,,.T.)
	
ENDIF

Return
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//Rafael França - 19/04/18 - Programa para ajustar a media de ferias protheus 12

User Function AJUSMEDFER()    

//aSvAlias :={Alias(),IndexOrd(),Recno()}     

//Atualmente o sistema considera o salalario base (SRA->RA_SALARIO) para pagar as medias, ajuste feito para pegar o valor do salmes + quinquenio.

IF SRA->RA_SINDICA == "02"
//NMEDIAHRS := ROUND(NMEDIAHRS / SRA->RA_SALARIO * (SALMES + fBuscaPd("282") + fBuscaPd("330") - fBuscaPd("118") - fBuscaPd("060")),2)   
NMEDIAHRS := ROUND(NMEDIAHRS / SRA->RA_SALARIO * (SRA->RA_SALARIO + fBuscaPd("282") + fBuscaPd("330")),2) 
ELSE
NMEDIAHRS := ROUND(NMEDIAHRS / SRA->RA_SALARIO * (SALMES + fBuscaPd("282") + fBuscaPd("330")),2)    
ENDIF

IF SRA->RA_SINDICA == "02" 
//NMEDIAOUT := ROUND(NMEDIAOUT / SRA->RA_SALARIO * (SALMES + fBuscaPd("282") + fBuscaPd("330") - fBuscaPd("118") - fBuscaPd("060")),2)
NMEDIAOUT := ROUND(NMEDIAOUT / SRA->RA_SALARIO * (SRA->RA_SALARIO + fBuscaPd("282") + fBuscaPd("330")),2)   
ELSE     
NMEDIAOUT := ROUND(NMEDIAOUT / SRA->RA_SALARIO * (SALMES + fBuscaPd("282") + fBuscaPd("330")),2)  
ENDIF

//dbSelectArea(aSvAlias[1])                                
//dbSetOrder(aSvAlias[2])
//dbGoto(aSvAlias[3])

Return
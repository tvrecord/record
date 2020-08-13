#INCLUDE "rwmake.ch"

user function GP410DES()    

//Rafael - Programa para filtro no CNAB Folha - Giselly      

Local URET := .T.     

IF SRA->RA_MAT $ "001450/001264/001483/001495"
URET := .T.  
END

Return URET
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "Topconn.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROT012    º Autor ³ JACKSON MACIEL     ³      |  22/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ ROTEIRO DE CALCULO                                         º±±
±±º          ³	                                                           º±±
±±º          ³	                                                           º±±
±±º          ³ - H.E FIXA CONTRATUAL 25 (VERBA 118)                       º±±
±±º          ³	- H.E FIXA CONTRATUAL 50 (VERBA 122)                       º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ROTF21()                                   
Local _Salbruto:=FbuscaPd("023","V")

// Salva alias, indice e Recno da rotina principal

aSvAlias:={Alias(),IndexOrd(),Recno()}
 _Saxbrutoa:= 0                               
 _Saybrutob:= 0

IF SRA->RA_HEFIX25="S" // H.E FIXA CONTRATUAL 25 (VERBA 118)      
    
 	_Saxbrutoa:= FBUSCAPD("053")
    IF _Saxbrutoa > 0  
       _Saxbrutoa:= 	_Saxbrutoa
     ENDIF
ENDIF


IF SRA->RA_HEFIX50=="S" // H.E FIXA CONTRATUAL 50 (VERBA 122)      
       
     
 	_Saybrutob:= FBUSCAPD("053")
    IF _Saybrutob > 0  
       _Saybrutob:= _Saybrutob
     ENDIF
ENDIF



IF  _Saxbrutoa > 0 .or._Saybrutob > 0
	FdelPd("023")
	FdelPd("118")
	FdelPd("122")
	FdelPd("053")
fGeraVerba("023", _Salbruto,,,,,,,,,.T.)

 ENDIF
 
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

Return
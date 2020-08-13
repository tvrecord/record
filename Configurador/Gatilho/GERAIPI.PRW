#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAIPI   ºAutor  ³Rafael Franca       º Data ³  04/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica descricao da posicao do inciso IPI no cadastro de º±±
±±º          ³ produtos            									      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Record DF                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION GERAIPI_()

Local cCodIPI := ""

IF M->B1_TIPO == "CM"
cCodIPI := "62052000"  
ELSEIF M->B1_TIPO == "BS"
cCodIPI := "62059000" 
ELSEIF M->B1_TIPO == "BZ"
cCodIPI := "62043900"
ELSEIF M->B1_TIPO == "CL"
cCodIPI := "61034900"
ELSEIF M->B1_TIPO == "GR"
cCodIPI := "61172000"
ELSEIF M->B1_TIPO == "ST"
cCodIPI := "64032000"
ELSEIF M->B1_TIPO == "OI"
cCodIPI := "61045900"
ELSEIF M->B1_TIPO == "CT"
cCodIPI := "61034900"
ELSEIF M->B1_TIPO == "CO"
cCodIPI := "62069000"
ELSEIF M->B1_TIPO == "LE"
cCodIPI := "62139000"
ELSEIF M->B1_TIPO == "TE"
cCodIPI := "61031900"  
ELSEIF M->B1_TIPO == "CS"
cCodIPI := "62033100"           
ELSEIF M->B1_TIPO == "RG"
cCodIPI := "62063000"          
ELSEIF M->B1_TIPO == "VE"
cCodIPI := "61044100"         
ELSEIF M->B1_TIPO == "CI"
cCodIPI := "42033000"                                                                                             
ELSEIF M->B1_TIPO == "SA"
cCodIPI := "61045100"                                                                                          
ELSEIF M->B1_TIPO == "LG"
cCodIPI := "62121000"                                                                                          
ENDIF

Return(cCodIPI)
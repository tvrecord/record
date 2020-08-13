#INCLUDE "rwmake.ch"      
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERACOD   ºAutor  ³Rafael Franca       º Data ³  06/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar codigo automatico quando o produto for do departamen º±±
±±º          ³ to de maquiagem                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function XIDCNAB()

Local cSeqCNAB	:= "" 

cSeqCNAB  	:= StrZero(Val(Posicione("SEE",1,xFilial("SEE")+"237"+"34169","EE_ULTDSK"))+1,9)

	dbSelectArea("SEE")
	dbsetOrder(1)
	dbSeek (xFilial("SEE")+ "237" + "34169")
	RECLOCK("SEE",.F.)
	SEE->EE_ULTDSK := StrZero(Val(SEE->EE_ULTDSK)+1,6)
	MSUNLOCK()         

Return(cSeqCNAB) 

// ID unico do registro    

User Function XIDCNAB1()

Local cSeqCNAB1	:= "" 

cSeqCNAB1  	:= StrZero(Val(Posicione("SEE",1,xFilial("SEE")+"237"+"34169","EE_ULTDSK")),10) + SRA->RA_MAT

Return(cSeqCNAB1) 
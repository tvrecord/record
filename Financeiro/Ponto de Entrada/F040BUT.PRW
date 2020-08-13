#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Rafael Franca       º Data ³  01/30/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para validar a conta contabil                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RECORD DF                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F040BUT()

Local aButtons := {}
    
    IF (SE1->E1_MULTNAT <> "1" ) 
    AADD(aButtons,{'EDITABLE', {||aUsaRateio()},"Utilizar Rateio", "Usa Rateio"})  
    ENDIF 
    
	IF(SE1->E1_MULTNAT == "1" .And. (U×pper(Trim(SE1->E1_ORIGEM)) = "MATA460") )
	Aadd(aButtons, {'S4WB013N',{||	oTela:=GetWndDefault(),	oTela:CommitControls(),MultNat( "SE1",0,M->E1_VALOR,"",.F.,If(SE1->E1_LA != "S", 4, 4),IF(mv_par04 == 1,0,((SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)) * -1)),	.T.,aHeader, aCols, aRegs) },"Rateio das Naturezas do titulo"} )
    
    //MultNat("SE1",@nHdlPrv,@nTotal,@cArquivo,mv_par03==1,,IF(mv_par04 == 1,0,((SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)) * -1)),;
	//				,,,,,,lF040Auto)
    ENDIF

Return(aButtons) 

Static Function aUsaRateio

Local cRateioNat := "1"     

IF MsgYesNo ("Deseja usar rateio de Naturezas?")

RecLock("SE3",.F.)
M->E1_MULTNAT := cRateioNat
MsUnLock()          

EndIf 

Return
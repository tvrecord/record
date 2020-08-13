#include "protheus.ch"

// Bruno Alves de Oliveira
// Dispara o gatilho do campo RV_NATUREZ
/*----------------------------------------------------------------------------*/
User Function ESOCSRV()
/*----------------------------------------------------------------------------*/
   
    Static oSay
 
    If Aviso("ESOCSRV",OemToAnsi("Confirma a atualização das incidências parar o eSocial?"),{"OK","Cancelar"}) == 1
        FWMsgRun(, {|oSay| Execute(oSay) }, "Processando", "Processando a rotina...")
    EndIf
 
Return        
 
/*----------------------------------------------------------------------------*/
Static Function Execute(oSay)
/*----------------------------------------------------------------------------*/
 
dbSelectArea("SRV")
SRV->(dbGoTop())  
 
   
 
While SRV->( .NOT. Eof())
   
    If RecLock("SRV", .F.) .AND. !Empty(SRV->RV_NATUREZ)
   
        RegToMemory( "SRV" , .F. )
       
        M->RV_INCIRF    := ""
        M->RV_INCFGTS   := ""
        M->RV_INCSIND   := ""
        M->RV_INCCP     := ""
       
        fValNatur() // Funcao padrao executada no x3_valid do campo RV_NATUREZ
       
        If SRV->RV_INCIRF != M->RV_INCIRF
            SRV->RV_INCIRF := M->RV_INCIRF
        EndIf
 
        If SRV->RV_INCFGTS != M->RV_INCFGTS
            SRV->RV_INCFGTS := M->RV_INCFGTS
        EndIf
       
        If SRV->RV_INCSIND != M->RV_INCSIND
            SRV->RV_INCSIND := M->RV_INCSIND
        EndIf
       
        If SRV->RV_INCCP != M->RV_INCCP
            SRV->RV_INCCP := M->RV_INCCP
        EndIf
 
        SRV->(MsUnLock())
   
    EndIf
 
    SRV->(dbSkip())
 
EndDo  
 
SRV->(dbCloseArea())          
 
Return
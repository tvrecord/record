#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RTCTBA04     ºAutor  ³Edmilson D. Santos º Data ³  22/01/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa executado através do ponto de entrada FA080TIT(), º±±
±±º          ³ Gravando o proximo número de cheque no cadastro de Banco.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RTCTBA04()

Local xCheque
Local xChequeAdt  
Local aSvAlias       
Local lRetorno := .T. 

/*

IF ALLTRIM(FUNNAME()) $ "FINA080/FINA750/FINA050"   
   IF (ALLTRIM(FUNNAME()) $ "FINA080" ).OR. (ALLTRIM(FUNNAME()) $ "FINA750" .AND. ALLTRIM(aRotina[3,1]) $ "Baixar")   
	   Dbseek(xFilial("SA6")+cBanco+cAgencia+cConta)
	ELSEIF (ALLTRIM(FUNNAME()) $ "FINA050") .OR. (ALLTRIM(FUNNAME()) $ "FINA750" .AND. TRIM(M->E2_TIPO) $ "PA"  )
		Dbseek(xFilial("SA6")+cBancoAdt+cAgenciaAd+cNumCon)	
	ENDIF   
ELSEIF ALLTRIM(FUNNAME()) $ "FINA190"  //geracao de cheque 
	Dbseek(xFilial("SA6")+cBanco190+cAgencia190+cConta190)
ELSEIF ALLTRIM(FUNNAME()) $ "FINA390"  //cheque avulso
	Dbseek(xFilial("SA6")+cBanco390+cAgencia390+cConta390)
//Else  //quando for PA
//	 Dbseek(xFilial("SA6")+cBanco+cAgencia+cConta)
ENDIF	

*/
             
IF ALLTRIM(FUNNAME()) $ "FINA080/FINA750/FINA050"

	IF (ALLTRIM(FUNNAME()) $ "FINA080" ).OR. (ALLTRIM(FUNNAME()) $ "FINA750" .AND. ALLTRIM(aRotina[3,1]) $ "Baixar") 
	  _cCheque := cCheque
	ELSEIF (ALLTRIM(FUNNAME()) $ "FINA050") //.OR. (ALLTRIM(FUNNAME()) $ "FINA750" .AND. TRIM(M->E2_TIPO) $ "PA"  )
	  _cCheque := cChequeAdt
	ELSE
	  _cCheque := cChequeAdt	  
	Endif
	
	IF !Empty(_cCheque)  

		Dbselectarea("SA6")
		DbSetOrder(1)       
		   
      IF ALLTRIM(FUNNAME()) $ "FINA080/FIAN750"
		  Dbseek(xFilial("SA6")+cBanco+cAgencia+cConta)
		Endif

      IF ALLTRIM(FUNNAME()) $ "FINA050"
		  Dbseek(xFilial("SA6")+cBancoAdt+cAgenciaAd+cNumCon)
		Endif

		IF FOUND()               
		
		   IF _cCheque > SA6->A6_XULTCHE
      		xCheque := STRZERO(VAL(_cCheque)+1,6)
      	ELSE
      		xCheque := STRZERO(VAL(SA6->A6_XULTCHE)+1,6)
      	ENDIF
      	RecLock("SA6",.F.)
      	SA6->A6_XULTCHE := xCheque
      	MsUnLock()
   	ENDIF
	
	Endif          

ENDIF
//ENDIF	
Return lRetorno

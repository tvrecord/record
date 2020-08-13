#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   º Autor ³ Edmilson Santos    º Data ³  01/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada utilizado na geracao das NFs de Saida     º±±
±±º          ³ onde eh calculado e gravado o Nosso Numero nos Titulos     º±±
±±º          ³ do SE1 gerados, facilitando a geracao do CNAB.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rede Record-DF - modulo Financeiro                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±  
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF2460I()        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

LOCAL aPgto  := {}
LOCAL nDias  := 0
LOCAL dData0 := dDataBase
LOCAL dProx  := dDataBase
LOCAL lOk    := .T.

// Grava a Posicao atual
aSvAlias :={Alias(),IndexOrd(),Recno()}
cBanco 	:= SC5->C5_BANCO

DBSELECTAREA("SE1")
DBSETORDER(2)
SE1->(DBSEEK(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC,.T.))

WHILE !EOF().AND.SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_SERIE+SE1->E1_NUM ==;
	SF2->F2_FILIAL+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC
	
	IF cBanco  == "237"
		cAgencia := "34169"
		//cConta   := SC5->C5_CONTA
		cNosso   := SPACE(15)
		
		dbSelectArea("SA6")
		dbsetOrder(1)
		SA6->(DBSEEK(xFilial()+cBanco+cAgencia))
		w_num	 := ALLTRIM(SA6->A6_NOSNUM)
		
		cTam=LEN(cNosso)
		cTitulo:= ALLTRIM(STR(VAL(SUBSTR(w_num,1,cTam-2))+1))
		cTam	 := Len(cTitulo)
		cAcm	 := 0
		vlat	 := 0
		X		 := cTam
		y		 := 2
		WHILE X >= 1
			vLat := Val(substr(cTitulo,x,1))*y
			cAcm := cAcm + vlat
			IF y =7
				y :=2
			Else
				y=y+1
			ENDIF
			X=X-1
		ENDDO
		
		cRest	 := MOD( cAcm,11 )
		cDig	 := 11 - crest
		
		IF cBanco = "237"
			npict = "@R 99/99/999999999-X"
			npict2= "@R 99/99/999999999-X"
			//cTitulo = '02'+cTitulo
			cTitulo := "0"+cTitulo
			IF cRest == 1
				cNosso  := cTitulo+"P"
			ELSEIF cRest == 0
				cNosso  := cTitulo+"0"
			Else
				cNosso  := cTitulo+strzero(cDig,1)
			Endif
			
		Endif
		
		dbSelectArea("SA6")
		dbsetOrder(1)
		RecLock("SA6",.F.)
		REPLACE SA6->A6_NOSNUM WITH cNosso  //No cadastro de Banco é necessário o cógido da
		SA6->(MsUnLock())                   //Carteira para a composição do calculo do digito.
		
		RecLock("SE1",.F.)
		REPLACE SE1->E1_NUMBCO WITH SUBSTR(cNosso,3,12) //No Cadastro de Titulos a Receber é gravado
		SE1->(MSUNLOCK())                               //apenas o código do nosso numero sem o código
		//carteira no inicio.
		/*
		@ 200,1 TO 430,410 DIALOG oGera TITLE OemToAnsi("Digitacao de Nosso Numero Boleto")
		@ 02,10 TO 100,205
		@ 10,018 Say " Este e o local onde se lança o Nosso Numero do"
		@ 18,018 Say " Boleto, conforme Nota Fiscal nº "+Transform(SF2->F2_DOC,"999999")
		@ 30,018 Say " A ser cobrado pelo banco: "+SA6->A6_COD+' Agencia: '+SA6->A6_AGENCIA+' '+SA6->A6_NREDUZ
		@ 53,018 SAY "No.Anterior ?"
		@ 53,058 SAY W_NUM PICTURE npict SIZE 70,20
		
		@ 70,018 SAY "Numero Atual?"
		@ 70,058 GET cNosso PICTURE npict2 SIZE 70,20
		
		@ 90,158 BMPBUTTON TYPE 01 ACTION OkGera()
		Activate Dialog oGera Centered*/
	Endif
	
	SE1->(DBSKIP())
	
ENDDO



/*
BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inserir automaticamente os dados no complemento das notas fiscais, ³
//³gerando automaticamente as linhas d405 e d450 no arquivo COTEPE    ³BRUNO ALVES
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

If SF2->F2_ESPECIE == "NFSC" .OR. SF2->F2_ESPECIE == "SPED" .OR. SF2->F2_ESPECIE == "NTSC"
	
	DBSelectArea("SFX")
	DBSetOrder(1)
	DBSeek(xFilial("SF2") + "S" + SF2->F2_SERIE + SF2->F2_DOC + SF2->F2_CLIENTE + SF2->F2_LOJA + "01")
	If Found()
		lOk := .F.
	Else
		lOk := .T.
	EndIf
	
	RecLock("SFX",lOk)
	SFX->FX_FILIAL 		:= xFilial("SF2")
	SFX->FX_TIPOMOV    	:= "S"
	SFX->FX_DOC        	:=	SF2->F2_DOC
	SFX->FX_SERIE      	:=  SF2->F2_SERIE
	SFX->FX_LOJA       	:=  SF2->F2_LOJA
	SFX->FX_CLASCON 	:= "99"
	SFX->FX_TIPSERV 	:= "9"
	SFX->FX_CLIFOR    	:= SF2->F2_CLIENTE
	SFX->FX_ITEM       	:= "01"
	SFX->FX_COD        	:= SD2->D2_COD
	SFX->FX_GRPCLAS 	:= "10"
	SFX->FX_CLASSIF 	:= "99"
	SFX->FX_RECEP 		:= SF2->F2_CLIENTE
	SFX->FX_LOJAREC    	:= SF2->F2_LOJA
	SFX->FX_TIPOREC    	:= "0"
	SFX->FX_DTINI    	:= Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO, "C5_PREFINI")
	SFX->FX_DTFIM    	:= Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO, "C5_PREFFIM")
	SFX->FX_PERFIS    	:= SUBSTR(DTOS(SF2->F2_EMISSAO),5,2) + SUBSTR(DTOS(SF2->F2_EMISSAO),1,4)
	SFX->FX_AREATER    	:= "21"
	SFX->FX_TERMINA    	:= "0000000000"
	SFX->(MSUNLOCK())
	
	
	
EndIf



// Retorna a Posicao atual Gravada
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])

RETURN NIL
//*-----------------------------------------------------------------------------*
/*
STATIC FUNCTION OkGera()

dbSelectArea("SA6")
dbsetOrder(1)
RECLOCK("SA6",.F.)
REPLACE SA6->A6_NOSNUM WITH cNosso
MSUNLOCK()

DBSELECTAREA("SE1")
DBSETORDER(2)
SE1->(DBSEEK(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC,.t.))

WHILE !EOF() .AND.SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_SERIE+SE1->E1_NUM  ==;
SF2->F2_FILIAL+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC
RECLOCK("SE1",.F.)
REPLACE SE1->E1_NUMBCO WITH cNosso
SE1->(MSUNLOCK())
SE1->(DBSKIP())
ENDDO

Close(oGera)
*/
//RETURN(.T.)


#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 11/03/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CORATIVO  º Autor ³ Edmilson Santos    º Data ³  27/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa destinado ao cadastro de bem, onde o mesmo ira    º±±
±±º          ³ efetuar correção de inconsistencia no SN3, esta base foi   º±±
±±º          ³ importada e veio com muita inconsistencia de dados.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rede Record-DF - modulo Ativo Fixo                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CORATIVO()

//LOCAL aDesc := M->N1_DESCRIC
SetPrvt("CDESCR,OLBX,NX,ACOLS,LCONSLOJA,NLBXNAT")

DBSELECTAREA("SN1")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	
  	AITEM := SN1->N1_CBASE+SN1->N1_ITEM
	AGRUPO:= SN1->N1_GRUPO
	
	DBSELECTAREA("SN3")
	DBSETORDER(1)
	DBSEEK(xFilial("SN3")+AITEM,.T.)
	
	WHILE !EOF() .AND. SN1->N1_CBASE+SN1->N1_ITEM == SN3->N3_CBASE+SN3->N3_ITEM
		/*
		DBSELECTAREA("SNG")
		DBSETORDER(1)
		DBSEEK(xFilial("SNG")+AGRUPO)
		
		IF EMPTY(AGRUPO)
		DBSKIP()
		LOOP
		ENDIF
		
		DBSELECTAREA("SN3")
		RECLOCK("SN3",.F.)
		SN3->N3_CDEPREC := SNG->NG_CDEPREC
		SN3->N3_CCDEPR  := SNG->NG_CCDEPR
		IF EMPTY(SN3->N3_HISTOR)
		SN3->N3_HISTOR  := SN1->N1_DESCRIC
		ENDIF
		IF !EMPTY(SN3->N3_DTBAIXA) //.AND. SN3->N3_BAIXA == "8"
		SN3->N3_BAIXA := "1"
		ENDIF
		SN3->(MSUNLOCK())
		/*
		IF SN3->N3_BAIXA <> "1"
		dbSelectArea('SN4')
		dbsetorder(4)
		SN4->(dbSeek(xFilial()+SN3->N3_CBase+SN3->N3_Item+SN3->N3_Tipo+Dtos(SN1->N1_Aquisic)))
		IF ! SN4->(Found())
		RecLock("SN4",.T.)
		End
		SN4->N4_Filial := xFilial("SN4")
		SN4->N4_Cbase  := SN1->N1_CBASE
		SN4->N4_Item   := SN1->N1_Item
		SN4->N4_Tipo   := "01" //cTipoSN3
		
		SN4->N4_Ocorr  := '05'
		SN4->N4_Motivo := ' '
		SN4->N4_Conta  := SN3->N3_cContab
		SN4->N4_Data   := SN1->N1_Aquisic
		SN4->N4_Quantd := SN1->N1_Quantd
		SN4->N4_Vlroc1 := SN3->N3_VOrig1
		SN4->N4_Vlroc2 := SN3->N3_VOrig2
		SN4->N4_Vlroc3 := SN3->N3_VOrig3
		SN4->N4_Vlroc4 := SN3->N3_VOrig4
		SN4->N4_Vlroc5 := SN3->N3_VOrig5
		SN4->N4_Serie  := SN1->N1_Nserie
		SN4->N4_Nota   := SN1->N1_NFiscal
		SN4->N4_Venda  := 0
		SN4->N4_TxMedia:= 0
		SN4->N4_TxDepr := 0
		SN4->(MSUNLOCK())
		End
		*/
		IF EMPTY(SN3->N3_HISTOR)         
			Reclock("SN3",.F.)
		   SN3->N3_HISTOR  := SN1->N1_DESCRIC
			MsUnlock()		
		ENDIF
		
		DBSELECTAREA("SN4")
		DBSETORDER(1)
		DBSEEK(xFilial("SN4")+SN3->N3_CBASE+SN3->N3_ITEM,.T.)
		IF FOUND()
			IF SN4->N4_VENDA > 0
				reclock("SN4",.F.)
				SN4->N4_DATA  := SN3->N3_DTBAIXA
            SN4->N4_CONTA := SN3->N3_CCONTAB
				SN4->N4_SEQ   := "001"
				SN4->N4_TXDEPR:= SN3->N3_TXDEPR1
				MsUnlock()
			ENDIF
		ENDIF
		
		SN3->(DBSKIP())
		
	ENDDO
	
	SN1->(DBSKIP())
	
ENDDO
/*
dbselectarea("SN4")
DBSETORDER(4)
DBGOTOP()
WHILE !EOF()
	
	pBem2:= SN4->N4_CBASE
	pBem := SN4->N4_CBASE
	pTipo:= SN4->N4_TIPO
	
	IF pTipo <> "02"
		DBSKIP()
		LOOP
	ENDIF
	
	pBem := ALLTRIM(pBem2)+"0001"
	
	DBSELECTAREA("SN1")
	DBSETORDER(1)
	SN1->(DBSEEK(xFilial("SN4")+pBem+SN4->N4_ITEM))
	IF !FOUND()
		RECLOCK("SN4",.F.)
		DBDELETE()
		SN4->(MSUNLOCK())
	ENDIF
	
	IF pTipo $ "02"
		RECLOCK("SN4",.F.)
		SN4->N4_CBASE := pBem
		SN4->N4_TIPO  := "01"
		SN4->(MSUNLOCK())
	ENDIF
	
	SN4->(DBSKIP())
	
ENDDO
*/
RETURN 

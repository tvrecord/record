#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#include "font.ch"
#INCLUDE "protheus.CH"

//23/05/17 - Rafael França - Tela de pagamento de cachê, rotina com o objetivo que não seja pago o mesmo cachê duas vezes

User Function TelaZAD() 
                       
//Variaveis unicas
Private cCodigo 	:= SPACE(6) //ZAD_CODIGO
Private cNF	   		:= SPACE(6) //ZAD_NF
Private cRP			:= SPACE(6) //ZAD_RP
Private cComuni		:= SPACE(6) //ZAD_COMUNI  
Private cNome		:= SPACE(40)
Private dData		:= CTOD("//") //ZAD_DATA 
Private nValor 		:= 0
Private cObs		:= SPACE(70)  
//Programa 1
Private cCodPro1	:= SPACE(3) //ZAD_CODPRO
Private cNomePro1	:= SPACE(40) //ZAD_NOMPRO
Private dData11		:= CTOD("//") //ZAD_DATA1
Private dData12		:= CTOD("//") //ZAD_DATA2
Private dData13		:= CTOD("//") //ZAD_DATA3
Private dData14		:= CTOD("//") //ZAD_DATA4
Private dData15		:= CTOD("//") //ZAD_DATA5
Private dData16		:= CTOD("//") //ZAD_DATA6
Private dData17		:= CTOD("//") //ZAD_DATA7
Private dData18		:= CTOD("//") //ZAD_DATA8 
Private nQTD1		:= 0 //ZAD_QTDINS
Private nVlunit1	:= 0 //ZAD_VLUNIT
Private nDesc1		:= 0 //ZAD_PERDES
Private nTotal1 	:= 0 //ZAD_VLTOT 
//Programa 2  
Private cCodPro2	:= SPACE(3) //ZAD_CODPRO
Private cNomePro2	:= SPACE(40) //ZAD_NOMPRO
Private dData21		:= CTOD("//") //ZAD_DATA1
Private dData22		:= CTOD("//") //ZAD_DATA2
Private dData23		:= CTOD("//") //ZAD_DATA3
Private dData24		:= CTOD("//") //ZAD_DATA4
Private dData25		:= CTOD("//") //ZAD_DATA5
Private dData26		:= CTOD("//") //ZAD_DATA6
Private dData27		:= CTOD("//") //ZAD_DATA7
Private dData28		:= CTOD("//") //ZAD_DATA8
Private nQTD2		:= 0 //ZAD_QTDINS
Private nVlunit2	:= 0 //ZAD_VLUNIT
Private nDesc2		:= 0 //ZAD_PERDES
Private nTotal2 	:= 0 //ZAD_VLTOT 
//Programa 3
Private cCodPro3	:= SPACE(3) //ZAD_CODPRO
Private cNomePro3	:= SPACE(40) //ZAD_NOMPRO
Private dData31	:= CTOD("//") //ZAD_DATA1
Private dData32	:= CTOD("//") //ZAD_DATA2
Private dData33	:= CTOD("//") //ZAD_DATA3
Private dData34	:= CTOD("//") //ZAD_DATA4
Private dData35	:= CTOD("//") //ZAD_DATA5
Private dData36	:= CTOD("//") //ZAD_DATA6
Private dData37	:= CTOD("//") //ZAD_DATA7
Private dData38	:= CTOD("//") //ZAD_DATA8       

cCodigo 	:= SZS->ZS_CODIGO 
cNF	 		:= SZS->ZS_NFISCAL
dData		:= SZS->ZS_DATA  
cNome		:= SZS->ZS_NOME
nValor		:= SZS->ZS_VALOR
                                          
//Tela de pagamento cache
@ 000,000 TO 0420,1050 DIALOG oDlg TITLE "Pagamento de Cachê"
@ 001,001 SAY "Autorização de Pagamento Nº :  " + cCodigo
@ 001,020 SAY "Nota Fiscal : " + cNF 
@ 001,032 SAY "Data :  " + DTOC(dData) 
@ 002,001 SAY "Fornecedor : " +  cNome 
@ 002,032 SAY "Valor :  " + cValtochar(nValor)  
@ 003,001 SAY "Numero RP :  " 
@ 003,007 MSGET cRP
//@ 004,001 SAY "Comunicador : " 
//@ 004,007 MSGET cComuni F3 "SRA" Picture "@!"   
//@ 004,013 SAY Posicione("SRA",1,xFilial("SRA")+cComuni,"RA_NOME") 

@ 005,001 SAY "Programa 1 : "
@ 005,007 MSGET cCodPro1 F3 "ZW" Picture "@!" 
@ 005,013 SAY Posicione("SX5",1,xFilial("SX5") + "ZW" + cCodPro1,"X5_DESCRI") 
@ 006,001 SAY "Data 1"
@ 006,006 SAY "Data 2"
@ 006,011 SAY "Data 3"
@ 006,016 SAY "Data 4"
@ 006,021 SAY "Data 5"
@ 006,026 SAY "Data 6"
@ 006,031 SAY "Data 7"
@ 006,036 SAY "Data 8" 
@ 006,042 SAY "QTD" 
@ 006,045 SAY "Vl Líquido" 
@ 006,051 SAY "% Desc"
@ 006,055 SAY "Vl Cachê"
@ 007,001 MSGET dData11 
@ 007,006 MSGET dData12  
@ 007,011 MSGET dData13
@ 007,016 MSGET dData14 
@ 007,021 MSGET dData15 
@ 007,026 MSGET dData16  
@ 007,031 MSGET dData17 
@ 007,036 MSGET dData18 
@ 007,042 MSGET nQTD1	  	PICTURE "@E 99" 
@ 007,045 MSGET nVlunit1	PICTURE "@E 999,999.99"
@ 007,051 MSGET nDesc1   	PICTURE "@E 99.99"  
@ 007,055 MSGET nTotal1 :=  ROUND((nVlunit1/100) * nDesc1,2)  	PICTURE "@E 999,999.99"  

@ 009,001 SAY "Programa 2 : "
@ 009,007 MSGET cCodPro2
@ 009,011 MSGET cNomePro2 
@ 010,001 SAY "Data 1"
@ 010,006 SAY "Data 2"
@ 010,011 SAY "Data 3"
@ 010,016 SAY "Data 4"
@ 010,021 SAY "Data 5"
@ 010,026 SAY "Data 6"
@ 010,031 SAY "Data 7"
@ 010,036 SAY "Data 8"
@ 010,042 SAY "QTD" 
@ 010,045 SAY "Vl Líquido" 
@ 010,051 SAY "% Desc"
@ 010,055 SAY "Vl Cachê"
@ 011,001 MSGET dData21 
@ 011,006 MSGET dData22  
@ 011,011 MSGET dData23 
@ 011,016 MSGET dData24 
@ 011,021 MSGET dData25 
@ 011,026 MSGET dData26  
@ 011,031 MSGET dData27 
@ 011,036 MSGET dData28 
@ 011,042 MSGET nQTD2	  	PICTURE "@E 99" 
@ 011,045 MSGET nVlunit2	PICTURE "@E 999,999.99"
@ 011,051 MSGET nDesc2   	PICTURE "@E 99.99" 
nTotal2 := ROUND((nVlunit2/100) * nDesc2,2)
@ 011,055 MSGET nTotal2 := ROUND((nVlunit2/100) * nDesc2,2) 	PICTURE "@E 999,999.99" 

@ 013,001 SAY "Observação : "
@ 013,007 MSGET cObs
@ 019,110 BUTTON "Gravar" SIZE 35,10 ACTION GravaZAD()
@ 019,120 BUTTON "Fechar" 	SIZE 35,10 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return

Static Function GravaZAD() 

RecLock("SZS",.F.)
SZS->ZS_CACHE 	:= "1"
MsUnLock()
  
dbSelectArea("ZAD") 
dBSetOrder(1)  
IF !dbSeek(xFilial("ZAD") + cCodigo) 
Reclock("ZAD",.T.)
ZAD->ZAD_CODIGO	:= cCodigo
ZAD->ZAD_NF		:= cNF
ZAD->ZAD_RP		:= cRP
ZAD->ZAD_COMUNI := cComuni
ZAD->ZAD_DATA 	:= dData
ZAD->ZAD_CODPRO	:= cCodPro1
ZAD->ZAD_NOMPRO	:= cNomePro1
ZAD->ZAD_DATA1	:= dData11
ZAD->ZAD_DATA2	:= dData12
ZAD->ZAD_DATA3	:= dData13
ZAD->ZAD_DATA4	:= dData14
ZAD->ZAD_DATA5	:= dData15
ZAD->ZAD_DATA6	:= dData16
ZAD->ZAD_DATA7	:= dData17
ZAD->ZAD_DATA8 	:= dData18
ZAD->ZAD_QTDINS	:= nQTD1
ZAD->ZAD_VLUNIT	:= nVlUnit1
ZAD->ZAD_PERDES	:= nDesc1
ZAD->ZAD_VLTOT 	:= nTotal1
MsUnlock()
MsgInfo("Pagamento de cachê gravado com sucesso","Sucesso")  
//M->ZS_CACHE := "1" 
Close(oDlg) 
Else
MsgInfo("Já existe registro para essa autorização de pagamento","Verificar")
//M->ZS_CACHE := "1"   
Close(oDlg)                                                               
ENDIF

Return()
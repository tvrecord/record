//#INCLUDE "Protheus.CH"
#INCLUDE "IMPRESG.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FETICR01 � Autor � JACKSON MACIEL     � Data �  26/11/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � RELATORIO GERENCIAL RETORNO CNAB FOLHA DE PAGAMENTO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RTGPER01
SetPrvt("cRet1,cret2,")

PRIVATE aCheque,aCartao,aCupom,aDepPgto,OrdemPgto,CancEletro,CancManual,RecBruta,RecLiquida,QtdCupons
PRIVATE aOrdPgto :={},nDinheiro,nChequeBom
PRIVATE cTpSangria, aSangria:={},NPOS1
PRIVATE QtdCliente,VlrCanc,VlrCancM,VlrFundo,VlrSagria
Private dData, cData
Private aEmpresa := {"1=1� Semana","2=2� Semana","3=3� Semana","4=4�Semana"}
Private _Nomebanco,_NomeAgencia
Private oPrint

//Objetos p/ Impresssao Grafica
Private oFont07,oFont08, oFont10, oFont15, oFont10n, oFont21,oFont12,oFont16
//Private oPrint
//cFileLogo	:= GetSrvProfString('Startpath','') + 'SEBRAE' + '.BMP' Impressao do Logomarca da empressa retirado Jackson
oFont07	 := TFont():New("Courier New",07,07,,.F.,,,,.T.,.F.)
oFont08	 := TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)		//negrito
oFont10	 := TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont10n := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont11  := TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
oFont11n := TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)
oFont12	 := TFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)		//Normal s/negrito
oFont12n := TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)		//Normal c/negrito
oFont14	 := TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)
oFont15	 := TFont():New("Courier New",15,15,,.T.,,,,.T.,.F.)
oFont21  := TFont():New("Courier New",21,21,,.T.,,,,.T.,.F.)
oFont19  := TFont():New("Courier New",19,19,,.T.,,,,.T.,.F.)
oFont16	 := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)


aDriver   		:= LeDriver()
cCompac 		:= aDriver[1]
cNormal			:= aDriver[2]
lNull   		:= .F.
nContar 		:= 0
lPrimeira		:= .T.
//����������������������������������������������������������Ŀ
//�Define Variaveis PRIVATE utilizadas para Impressao Grafica�
//������������������������������������������������������������
PRIVATE nPos	:= 0					   				 		   					//LINHA DE IMPRESSAO DO RELATORIO GRAFICO
Private cFont	:= ""					 				 							//FONTES UTILIZADAS NO RELATORIO
Private cFontm	:= ""					 				 							//FONTES UTILIZADAS NO RELATORIO
Private cFontp	:= ""					 				 							//FONTES UTILIZADAS NO RELATORIO
PRIVATE CONTFL	:= 1									  							//CONTA PAGINA
PRIVATE nPosCab := 0
PRIVATE ImpOK := .t.
private oGeraTxt              

Private _Bordero  := Space(6)



//������������������������������������������������������������������Ŀ
//�Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.�
//��������������������������������������������������������������������
Private oFont07,oFont08,oFont09, oFont09n,oFont06
Private nTot	:= 17
Private _cEmpresa


oFont06	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont07	:= TFont():New("Tahoma",06,06,,.F.,,,,.T.,.F.)
oFont08	:= TFont():New("Tahoma",08,08,,.F.,,,,.T.,.F.)
oFont09	:= TFont():New("Tahoma",09,09,,.F.,,,,.T.,.F.)
oFont09n:= TFont():New("Tahoma",09,09,,.T.,,,,.T.,.F.)     //Negrito//

nEpoca:= SET(5,1910)

//-- Objeto para impressao grafica
oPrint 	:= TMSPrinter():New("BORDERO DE PAGAMENTO")
//oPrint:SetPortrait() // DEFINE IMPRESSAO RETRATO
oPrint:SetLandscape() // DEFINE IMPRESSAO PAISAGEM


//--MUDAR ANO PARA 4 DIGITOS
SET CENTURY ON


dbSelectArea("SEA")
dbSetOrder(1)

// Processa o Relatorio

@ C(200),C(1) TO C(320),C(385) DIALOG oGeraTxt TITLE OemToAnsi("RELATORIO GERENCIAL RETORNO CNAB - BRADESCO")
//@ C(02),C(00) TO C(005),C(100)
//@ 020,018 SAY "Bordero:"
//@ 020,050 Get _Bordero  Size 20,15
@ C(040),C(080) BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ C(040),C(120) BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ C(040),C(160) BMPBUTTON TYPE 5 ACTION _cArquivo := SelArq()
Activate Dialog oGeraTxt Centered


RETURN


STATIC FUNCTION OkGeraTxt()

Processa({|| RunRelatorio() },"Processando...")
  ImprRel()
Return
                     

Static Function RunRelatorio

Local nTamFile, nTamLin, cBuffer, nBtLidos


Public _TotProv := 0
Public _TotDesc := 0

Private cArqTxt := _cArquivo//"C:\IMPORTACAO\GPE\CNAB.TXT"
Private nHdl    := fOpen(cArqTxt,68)

Private cEOL    := "CHR(13)+CHR(10)"


cFont	:=oFont09
cFontn	:=oFont09n
cFont8	:=oFont08
cFontp	:=oFont07
cFont21  :=oFont21
cFont12  :=oFont12
cFont12n  :=oFont12n
cFont14  :=oFont14
cFont15  :=oFont15
cFont16  :=oFont16
cFont10  :=oFont10
cFont10n  :=oFont10n
cFont11  :=oFont11
cFont11n  :=oFont11n

// Verifica os Registros tipo 13

aOper := {}
ASIZE(aOper,999)

TotGeralA := 0 
TotGeralR := 0
TotGeralA1 := 0 
TotGeralR1 := 0


_TotalA := 0
_TotalR := 0                     

nLin := 500              

_TotalA := 0
_TotalB := 0                       

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif
  
    
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 200+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar

_ToTal := 0  
_Cont  := 0
While nBtLidos >= nTamLin
   
    IF Substr(cBuffer,01,01) == "0"
     _NomeEmp  := Substr(cBuffer,01,02)           
     _AgenEmp  := Substr(cBuffer,27,05)
     _ContEmp  := SubStr(cBuffer,37,07)
     _DataDeb  := StoD(SubStr(cBuffer,99,04)+SubStr(cBuffer,97,02)+SubStr(cBuffer,95,02))
     _DataGra  := StoD(SubStr(cBuffer,115,04)+SubStr(cBuffer,113,02)+SubStr(cBuffer,111,02))
     
     fCabecalho()                          
     
     oPrint:Say( 250, 1500,"AGENCIA: " +_AgenEmp,cFont12n)
     oPrint:Say( 300, 1500,"CONTA  : " +_ContEmp,cFont12n)

     //_DigtEmp  :=
     //_DtGrava  := 
     //_DtDebit  :=                                                                                    
    Endif
    
    IF Substr(cBuffer,01,01) == "1"   
          
	    //If nLin >= 2400 
	    If nLin >= 2350 
	      oPrint:EndPage()
	      fCabecalho()                                                            
	      nLin := 500
	    Endif 
      
      _MatrFun  := Substr(cBuffer,121,06)
      DbSelectArea("SRA") 
      DbSetOrder(13)
	   IF DbSeek(ALLTRIM(_MatrFun))
		  _BancFun := SUBSTR(SRA->RA_BCDEPSA,1,3) 
	   Endif
      _NomeFun  := Substr(cBuffer,083,38) 
      _AgenFun  := Substr(cBuffer,063,5)
      _ContFun  := Substr(cBuffer,073,7) 
      _ValrFun  := Val(Substr(cBuffer,127,13))/100
      
      oPrint:say (nLin,060 ,_MatrFun,cFont12) 
      oPrint:say (nLin,300 ,_NomeFun,cFont12)  
      oPrint:say (nLin,1300 ,_BancFun,cFont12)   
      oPrint:say (nLin,1600 ,_AgenFun,cFont12) 
      oPrint:say (nLin,2000 ,_ContFun,cFont12)    
      oPrint:say (nLin,2400 ,TRANSFORM(_ValrFun,"@E 999,999,999.99"),cFont12)
       
      nLin := nLin + 50
      oPrint:line(nLin,050 ,nLin ,3300) //Linha Horizontal                 
      nLin := nLin + 10      

      _Cont++
      _ToTal := _ToTal + _ValrFun 
    Endif
    
    IF Substr(cBuffer,01,01) == "9"   
          
      //If nLin >= 2400 
     If nLin >= 2350 
        oPrint:EndPage()
        fCabecalho()                                                            
        nLin := 500
      Endif 
      _DebiEmp := Val(Substr(cBuffer,02,13))/100 
      oPrint:Say( 200, 1500,"VALOR DEBITADO EMPRESA: " +ALLTRIM(TRANSFORM(_DebiEmp,"@E 999,999.99")),cFont12n,100 )
    Endif
    
    
  //If nLin >= 2400 
  If nLin >= 2350 
    oPrint:EndPage()
    fCabecalho()                                                            
    nLin := 500
  Endif       
 	  
 
	  

  nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
  dbSkip()
EndDo

    
//If nLin >= 2400 
If nLin >= 2350 
   oPrint:EndPage()
   fCabecalho()                                                            
   nLin := 500
Endif 

nLin := nLin + 060 

oPrint:Say( nLIn, 0040,"TOTAL DE FUNCIONARIOS: " +ALLTRIM(TRANSFORM(_Cont,"@E 9999")),cFont12n,100 ) 
oPrint:Say( nLin, 2400,TRANSFORM(_ToTal,"@E 999,999,999.99"),cFont12n,100 ) 



oPrint:EndPage()
CONTFL:=1

MS_FLUSH()


Return



STATIC FUNCTION ImprRel()

Set(5,nEpoca)
If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif

oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir
Close(oGeraTxt)


Return


Static Function fCabecalho()

Local cStartPath:= GetSrvProfString("Startpath","")
Local nPos1 	:= 0
Local nPosM 	:= 0
Local cCateg	:= fCateg(0)
oPrint:StartPage() 			//Inicia uma nova pagina

//cBitmap    := "SEBRAE.bmp"

cFont	:=oFont09
cFontn	:=oFont09n
cFont8	:=oFont08
cFontp	:=oFont07
cFont21  :=oFont21
cFont12  :=oFont12
cFont12n  :=oFont12n
cFont14  :=oFont14                   
cFont15  :=oFont15
cFont16  :=oFont16
cFont10  :=oFont10
cFont10n  :=oFont10n

nPos1 := 400

L1 = 050
C1 = 2000
Tam = 300
Lar = 160                  
nPos := 30

//cFileLogo	:= GetSrvProfString('Startpath','') + 'EMURB' + '.BMP'
//oPrint:SayBitmap(040,080,cFileLogo,500,260)
                              
oPrint:Box( 0010, 0050, 0350,3300)    

//oPrint:SayBitmap( 0100,0040,"logo.bmp",0360,0200 )
oPrint:Say( nPos, 0060,RTRIM(SM0->M0_NOMECOM),cFont12n,100 )
oPrint:Say( nPos, 2620,"EMISSAO: ",cFont12n,100 )
oPrint:Say( nPos, 2910,DTOC(Date()),cFont12n,100 )
nPos := nPos + 060       
oPrint:Say( nPos, 2620,"GRAVACAO: ",cFont12n,100 )
oPrint:Say( nPos, 2910,DTOC(_DataGra),cFont12n,100 )

oPrint:Say( nPos, 0060,RTRIM(SM0->M0_ENDCOB),cFont12n,100 )            
oPrint:Say( nPos, 1500,"RELAT�RIO RETORNO CNAB - BRADESCO",cFont12n,100 )
nPos := nPos + 060
oPrint:Say( nPos, 2620,"DEBITO: ",cFont12n,100 )
oPrint:Say( nPos, 2910,DTOC(_DataDeb),cFont12n,100 )

oPrint:Say( nPos, 0060,"CNPJ: "+TRANSFORM(RTRIM(SM0->M0_CGC),"@R 99.999.999/9999-99"),cFont12n,100 )
nPos := nPos + 060

oPrint:Say( nPos, 0060,"INSCRI��O ESTADUAL: "+TRANSFORM(SM0->M0_INSC,"@R 99.999.999/999/99"),cFont12n,100 )
//oPrint:Say( nPos, 1500,"VALOR DEBITADO EMPRESA: " +ALLTRIM(TRANSFORM(_DebiEmp,"@E 999,999,99")),cFont12n,100 )


//oPrint:Say( nPos, 1500,"PERC. TEMPO: " +ALLTRIM(TRANSFORM(SZ8->Z8_RATEIO1,"@E 999,999,99")) + " %"  ,cFont12n,100 )  
//oPrint:Say( nPos, 2100,"COEF. TEMPO: " +ALLTRIM(TRANSFORM(SZ8->Z8_COEFMES,"@E  999.9999")) ,cFont12n,100 ) 
//oPrint:line(nPos ,035 ,nPos ,2350) //Linha Horizontal                 
//oPrint:line(nPos ,035,nPos+120 ,035) //Linha Vertical direita
//oPrint:line(nPos ,2350,nPos+120,2350) //Linha Vertical direita    
nPos := nPos + 200
oPrint:say (nPos,060 ,"MATR�CULA",cFont12n)
oPrint:say (nPos,300 ,"FUNCION�RIO",cFont12n)
oPrint:say (nPos,1300 ,"BANCO",cFont12n)
oPrint:say (nPos,1600 ,"AG�NCIA",cFont12n)
oPrint:say (nPos,2000 ,"CONTA",cFont12n) 
oPrint:say (nPos,2600 ,"VALOR DEPOSITADO",cFont12n)
//oPrint:say (nPos,1800 ,"SALARIO",cFont12n)
//oPrint:say (nPos,2100 ,"PRO RATA",cFont12n)

nPos := nPos + 60
oPrint:line(nPos ,050 ,nPos ,3300) //Linha Horizontal
nPos := nPos + 2200


Return Nil       


Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)           
                                  
Static Function SelArq()
Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"
_cRet := cGetFile(_cExtens, "Selecione o Arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
_cRet := ALLTRIM(_cRet)
Return _cRet                                 	
  	
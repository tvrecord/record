#include 'rwmake.ch'
#include 'protheus.ch'

#define STR0001 "Limpeza do banco de horas"
#define STR0002 "RTCA001"
#define STR0003 "Essa rotina tem como objetivo efetuar a limpeza das tabelas do banco de horas."
#define STR0004 "Durante o processamento da rotina, seraão manipulados os registros das tabelas:"
#define STR0005 "     - SPI / SPB / SZA "
#define STR0006 ""
#define STR0007 "Antes de efetuar o processamento da rotina, verifique os parâmetros iniciais!"
#define STR0008 "As tabelas SZA, SPI e SPB terão seus dados alterados ou apagados. Você confirma o processamento da rotina?"
#define STR0009 "Fim do processamento."

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |RTCA001   | Autor |MICROSIGA BRASILIA     | Data |22.07.2008  |
+----------+----------+-------+-----------------------+------+------------+
|Descricao |Rotina de limpeza do banco de horas.                          |
|          | Rotina efetua a limpeza dos registros das tabelas SPI/SPB/SZA|
+----------+--------------------------------------------------------------+
|Retorno   |#                                                             |
+----------+--------------------------------------------------------------+
|Parametros|#                                                             |
+----------+--------------------------------------------------------------+
|Uso       |RECORD -> PONTO ELETRONICO                                    |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descricao                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

User Function RTCA001

//Declaracao das variaveis
Local cPerg     := 'RTCA01    '                                
Local nOpca     := 0
LOCAL aButtons  := {}
Local aSays     := {}  
Local lPergunta := .F.

Private cCadastro := OemToAnsi(STR0001)  //'Cadastro de Trumas'
                       
//////////////////////////////////////////
//  Inicializa o tela de processamento  //
//////////////////////////////////////////
AADD(aSays, OemToAnsi(STR0003))  
AADD(aSays, OemToAnsi(STR0004))  
AADD(aSays, OemToAnsi(STR0005))  
AADD(aSays, OemToAnsi(STR0006))  
AADD(aSays, OemToAnsi(STR0007))  

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.), lPergunta:= .T.}})
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

FormBatch( cCadastro, aSays, aButtons ,,,)

////////////////////////////////////
//  Carrega parametros da rotina  //
////////////////////////////////////

// Caso nao tenha passado pela tela de parametros
If !lPergunta .and. nOpca == 1
	If !Pergunte(cPerg,.T.)
		Return
	Endif
Elseif !lPergunta .and. nOpca <> 1
	Return
Endif

////////////////////////////////
//  Inicializa processamento  //
////////////////////////////////	
If nOpcA == 1 .and. MsgYesNo(STR0008,STR0001)
	RptStatus({|lEnd| U_RTCA001A(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05) },STR0002 + " - " + STR0001)
Endif

Return

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |RTCA001A  | Autor |MICROSIGA BRASILIA     | Data |22.07.2008  |
+----------+----------+-------+-----------------------+------+------------+
|Descricao |Processamento das tabelas a serem processadas.                |
+----------+--------------------------------------------------------------+
|Retorno   |#                                                             |
+----------+--------------------------------------------------------------+
|Parametros|#                                                             |
+----------+--------------------------------------------------------------+
|Uso       |RECORD -> PONTO ELETRONICO                                    |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descricao                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

User Function RTCA001A(cDeMat,cAteMat,dComp,dProc,dBaixa)

//Declaracao das variaveis
Local aLog := {} //Array de controle do Log de alterações

//Regua de processamento
SetRegua(SRA->(RecCount()))

//Localiza primeiro registro parametrizado
SRA->(DbSetOrder(1))
SRA->(DbSeek(xFilial("SRA")+cDeMat,.T.))

//Percorre toda a tabela
While !SRA->(EOF());
 .and. xFilial("SRA")+cAteMat >= SRA->RA_FILIAL+SRA->RA_MAT
   
   IncRegua()
   
	//Processamento da tabale SZA
	SZA->(DbSetOrder(2))
	If SZA->(Dbseek(xFilial("SZA")+dComp+SRA->RA_MAT))	
		
		//Primeira linha do Log de controle da tabela SZA
		AADD(aLog,{"SZA","SZA->ZA_FILIAL","SZA->ZA_MAT","SZA->ZA_COMPET","SZA->ZA_DATA","SZA->ZA_VALOR","PROCESSAMENTO"})

		While !SZA->(EOF());
 		 .and. xFilial("SZA")+dComp+SRA->RA_MAT == SZA->ZA_FILIAL+SZA->ZA_COMPET+SZA->ZA_MAT
 		 	
 		 	//Confirma que registro deve ser processado
 		 	If xFilial("SZA")+dComp+SRA->RA_MAT == SZA->ZA_FILIAL+SZA->ZA_COMPET+SZA->ZA_MAT 
	 		  
	 		 	//Apagar registro do SZA
 			 	Reclock("SZA",.F.)
 			 		DbDelete()
 		 		SZA->(MsUnlock()) 			 
 		 	
 		 	   //Log de controle
 		 	   AADD(aLog,{"SZA",SZA->ZA_FILIAL,SZA->ZA_MAT,SZA->ZA_COMPET,STOD(SZA->ZA_DATA),SZA->ZA_VALOR,"APAGADO"})
 		 	
 		 	Endif
 		
 			SZA->(DbSkip())
 		EndDo  
	
	EndIf
 
	//Processamento da tabale SPB
	SPB->(DbOrderNickName("PB_DATA"))
	If SPB->(Dbseek(xFilial("SPB")+SRA->RA_MAT+DTOS(dProc)))	
		
		//Primeira linha do Log de controle da tabela SZA
		AADD(aLog,{"SPB","SPB->PB_FILIAL","SPB->PB_MAT","SPB->PB_DATA","SPB->PB_PD","SPB->PB_HORAS","PROCESSAMENTO"})


		While !SPB->(EOF());
 		 .and. xFilial("SPB")+SRA->RA_MAT+DTOS(dProc) == SPB->PB_FILIAL+SPB->PB_MAT+DTOS(SPB->PB_DATA)
 		 	
 		 	//Confirma que registro deve ser processado
	 		If xFilial("SPB")+SRA->RA_MAT+DTOS(dProc) == SPB->PB_FILIAL+SPB->PB_MAT+DTOS(SPB->PB_DATA) 
	 		  
 		 		//Apagar registro do SZA
	 		 	Reclock("SPB",.F.)
	 		 		DbDelete()
	 		 	SPB->(MsUnlock()) 			 
	 		
	 		//Log de controle
			AADD(aLog,{"SPB",SPB->PB_FILIAL,SPB->PB_MAT,SPB->PB_DATA,SPB->PB_PD,SPB->PB_HORAS,"APAGADO"})

	 		Endif
	 		
	 		SPB->(DbSkip())	 		
 		EndDo  
	
	EndIf

	//Processamento da tabale SPI                                       
	SPI->(DbOrderNickName("PI_DTBAIX"))
	If SPI->(Dbseek(xFilial("SPI")+SRA->RA_MAT+DTOS(dBaixa)))	
		
		//Primeira linha do Log de controle da tabela SZA
		AADD(aLog,{"SPI","SPI->PI_FILIAL","SPI->PI_MAT","SPI->PI_DATA","SPI->PI_PD","SPI->PI_QUANT","PROCESSAMENTO"})

		
		While !SPI->(EOF());
 		 .and. xFilial("SPI")+SRA->RA_MAT+DTOS(dBaixa) == SPI->PI_FILIAL+SPI->PI_MAT+DTOS(SPI->PI_DTBAIX)
 		 	
 		 	//Confirma que registro deve ser processado
 		 	If xFilial("SPI")+SRA->RA_MAT+DTOS(dBaixa) == SPI->PI_FILIAL+SPI->PI_MAT+DTOS(SPI->PI_DTBAIX)
	 		  
	 		 	//Apagar registro do SZA
 			 	Reclock("SPI",.F.)
 			 		SPI->PI_STATUS := Space(1)
 			 		SPI->PI_DTBAIX := STOD('')
 		 		SPI->(MsUnlock()) 			 
 		 	
 		 	//Primeira linha do Log de controle da tabela SZA
			AADD(aLog,{"SPI",SPI->PI_FILIAL,SPI->PI_MAT,SPI->PI_DATA,SPI->PI_PD,SPI->PI_QUANT,"ALTERADO"})

 		 	Endif
 		
 	  		SPI->(Dbseek(xFilial("SPI")+SRA->RA_MAT+DTOS(dBaixa)))		//SPI->(DbSkip())
 		EndDo  
	
	EndIf

	SRA->(DbSkip())
EndDo

MsgInfo(STR0009,STR0001)  

//Impressao do log de processamento
U_RTCA001B(aLog)

Return

/*
+----------+----------+-------+-----------------------+------+------------+
|Função    |RTCA001B  | Autor |MICROSIGA BRASILIA     | Data |22.07.2008  |
+----------+----------+-------+-----------------------+------+------------+
|Descricao |Impressao do log de processamento.                            |
+----------+--------------------------------------------------------------+
|Retorno   |#                                                             |
+----------+--------------------------------------------------------------+
|Parametros|#                                                             |
+----------+--------------------------------------------------------------+
|Uso       |RECORD -> PONTO ELETRONICO                                    |
+----------+--------------------------------------------------------------+
| Atualizacoes sofridas desde a Construcao Inicial.                       |
+----------+--------------------------------------------------------------+
| Data     | Descricao                                                    |
+----------+--------------------------------------------------------------+
|          |                                                              |
+----------+--------------------------------------------------------------+
*/

User Function RTCA001B(aDet)
                       
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Log de controle da limpeza do banco de horas"
Local cPict          := ""
Local titulo         := "Log de controle da limpeza do banco de horas"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RTCA001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LOG" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SRA"

//Controle da numeração do log
PutMv("MV_YLOG",Soma1(Alltrim(GetMV("MV_YLOG")),10))

nomeprog := wnrel += Alltrim(GetMV("MV_YLOG")) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,aDet) },Titulo)
Return
                       
// >>>>>>>..........

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,aDadosImp)

Local nX        := 0
Local nY        := 0
Local aDetalhes := {}

//Efetua tratamento dos dados do array de impressao
For nX:=1 To Len(aDadosImp)

	For nY:=1 To Len(aDadosImp[nX])
		
		Do Case
			Case Valtype(aDadosImp[nX][nY]) == "C"
				
				aDadosImp[nX][nY] := aDadosImp[nX][nY]
				
			Case Valtype(aDadosImp[nX][nY]) == "D"
				
				aDadosImp[nX][nY] := DTOC(aDadosImp[nX][nY])

			Case Valtype(aDadosImp[nX][nY]) == "N"
				
				aDadosImp[nX][nY] := Transform(aDadosImp[nX][nY],"@e 999,999,999.99")
	
			Otherwise
				
				aDadosImp[nX][nY] := "#####"	
		EndCase					                          	
	Next nY

Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(aDadosImp))

For nX:=1 To Len(aDadosImp)

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
	/*
   @nLin,00 PSAY ""

	For nY:=1 To Len(aDadosImp[nX])
		
		@nLin,PCol()+1 PSAY aDadosImp[nX][nY]

	Next nY
   */
   
   @nLin,000 PSAY aDadosImp[nX][1]
   @nLin,016 PSAY aDadosImp[nX][2]
   @nLin,032 PSAY aDadosImp[nX][3]
   @nLin,048 PSAY aDadosImp[nX][4]
   @nLin,064 PSAY aDadosImp[nX][5]
   @nLin,080 PSAY Padl(aDadosImp[nX][6],15)
   @nLin,100 PSAY aDadosImp[nX][7]

   nLin := nLin + 1 // Avanca a linha de impressao
   
	If nX+1 <= Len(aDadosImp)
		If aDadosImp[nX][1] <> aDadosImp[nX+1][1]    
		   nLin := nLin + 1 // Avanca a linha de impressao
		Endif
	Endif
	
Next Nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
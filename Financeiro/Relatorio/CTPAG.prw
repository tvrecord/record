#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍ ÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTPG     º Autor ³ Bruno Alves        º Data ³  14/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Titulo a Pagar					  	                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTPG


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Contas a Pagar"
Local nLin         := 80

Local Cabec1       := "Cod.    Nome do Fornecedor              Titulo     Par  Emissao      Venc.      Venc Real        Valor          Baixa            Saldo    Natureza    Descrição                      C. Custo   Observação"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "CTPAG" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CTPAG1"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CTPAG" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cQuery	   := ""
Private cString := "SE2"
Private _aRatNat := {}
Private _aRatFin := {}
Private _aRatDoc := {}
Private _aRatCC  := {}
Private	nPerc := 0
Private	nVal  := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

cQuery := "SELECT "
cQuery += "E2_FILIAL,E2_FORNECE,E2_LOJA,A2_NREDUZ,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALOR,"
cQuery += "E2_BAIXA,E2_SALDO,E2_HIST,E2_MULTNAT,E2_NATUREZ,ED_DESCRIC,E2_RATEIO,E2_ARQRAT,E2_CCD,E2_ORIGEM FROM SE2010 "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
cQuery += "INNER JOIN SED010 ON "
cQuery += "SE2010.E2_NATUREZ = SED010.ED_CODIGO "
cQuery += "WHERE "
cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' AND "
cQuery += "SE2010.E2_FILIAL = '" + (MV_PAR01) + "'  AND "
cQuery += "SE2010.E2_NUM BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "SE2010.E2_PARCELA  BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
cQuery += "SE2010.E2_EMISSAO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' AND "
cQuery += "SE2010.E2_VENCREA  BETWEEN '" + DTOS(MV_PAR08) + "' AND '" + DTOS(MV_PAR09) + "' AND "
cQuery += "SE2010.E2_FORNECE BETWEEN '" + (MV_PAR10) + "' AND '" + (MV_PAR11) + "' AND "
cQuery += "SE2010.E2_NATUREZ BETWEEN '" + (MV_PAR12) + "' AND '" + (MV_PAR13) + "' "
cQuery += "ORDER BY E2_FORNECE,E2_NUM,E2_PARCELA"

tcQuery cQuery New Alias "TMP"





If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  14/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ relatorio. Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DBSelectArea("TMP")
dbGoTop()
While !EOF()
	
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
	
	If nLin > 62 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	@nLin,000 PSAY TMP->E2_FORNECE
	@nLin,008 PSAY TMP->A2_NREDUZ
	@nLin,040 PSAY TMP->E2_NUM
	@nLin,051 PSAY TMP->E2_PARCELA
	@nLin,055 PSAY STOD(TMP->E2_EMISSAO)
	@nLin,069 PSAY STOD(TMP->E2_VENCTO)
	@nLin,081 PSAY STOD(TMP->E2_VENCREA)
	@nLin,093 PSAY TMP->E2_VALOR Picture "@E 999,999,999.99"
	@nLin,111 PSAY STOD(TMP->E2_BAIXA)
	@nLin,123 PSAY TMP->E2_SALDO Picture "@E 999,999,999.99"
	@nLin,138 PSAY TMP->E2_NATUREZ
	@nLin,150 PSAY TMP->ED_DESCRIC
	If TMP->E2_RATEIO == "S"
		@nLin,182 PSAY "-------"
		@nLin,192 PSAY "Rateio Centro de Custo"
	ElseIf TMP->E2_RATEIO == "N"
		@nLin,182 PSAY TMP->E2_CCD
		@nLin,192 PSAY Substr(Posicione("CTT",1,xFilial("CTT")+TMP->E2_CCD,"CTT_DESC01"),1,27)
	ElseIf EMPTY(TMP->E2_RATEIO) .AND. EMPTY(TMP->E2_CCD)
		@nLin,182 PSAY "-------"
		@nLin,192 PSAY "Rateio Documento de Entrada"
	EndIf
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//Adiciona no Vetor o Rateio de Natureza, CASO exista
	
	
	DbSelectArea("SEV")
	DBSetOrder(1)
	DBSeek(TMP->E2_FILIAL + TMP->E2_PREFIXO + TMP->E2_NUM + TMP->E2_PARCELA + TMP->E2_TIPO + TMP->E2_FORNECE + TMP->E2_LOJA)
	If Found()
		
		While !EOF() .AND. TMP->E2_PREFIXO == SEV->EV_PREFIXO .AND. TMP->E2_NUM == SEV->EV_NUM .AND. TMP->E2_PARCELA == SEV->EV_PARCELA .AND. TMP->E2_FORNECE == SEV->EV_CLIFOR .AND. TMP->E2_LOJA == SEV->EV_LOJA
			
			
			IF aScan(_aRatNat, { |x| x[1] == SEV->EV_NATUREZ } ) == 0
				aAdd(_aRatNat,{SEV->EV_NATUREZ,;
				Posicione("SED",1,xFilial("SED") + SEV->EV_NATUREZ,"ED_DESCRIC")})
			EndIf
			
			DbSkip()
		Enddo
		
	EndIf
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//Adiciona no Vetor o Rateio de centro de custo gerado pela rotina do Financeiro, CASO exista
	
	
	DBSelectARea("CV4")
	DBSetOrder(1)
	DBSeek(Substr(TMP->E2_ARQRAT,1,2) + Substr(TMP->E2_ARQRAT,3,8) + Substr(TMP->E2_ARQRAT,11,10))
	If Found()
		
		While !EOF() .AND. Substr(TMP->E2_ARQRAT,1,2) == CV4->CV4_FILIAL .AND. Substr(TMP->E2_ARQRAT,3,8) == DTOS(CV4->CV4_DTSEQ) .AND. Substr(TMP->E2_ARQRAT,11,10) == CV4->CV4_SEQUEN
			
			aAdd(_aRatFin,{CV4->CV4_SEQUEN,;
			CV4->CV4_PERCEN,;
			CV4->CV4_VALOR,;
			CV4->CV4_CCD,;
			Posicione("CTT",1,xFilial("CTT")+CV4->CV4_CCD,"CTT_DESC01")})
			
			
			DbSkip()
		Enddo
		
	EndIf
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//Adiciona no Vetor o Rateio do documento de entrada, CASO exista
	
	
	DBSelectARea("SDE")
	DBSetOrder(1)
	DBSeek(TMP->E2_FILIAL + TMP->E2_NUM + TMP->E2_PREFIXO + TMP->E2_FORNECE + TMP->E2_LOJA)
	If Found()
		
		IF aScan(_aRatDoc, { |x| x[1] == TMP->E2_NUM } ) == 0
			
			While !EOF() .AND. TMP->E2_FILIAL == SDE->DE_FILIAL .AND. TMP->E2_NUM == SDE->DE_DOC .AND. TMP->E2_PREFIXO == SDE->DE_SERIE .AND. TMP->E2_FORNECE == SDE->DE_FORNECE .AND. TMP->E2_LOJA == SDE->DE_LOJA
				
				
				aAdd(_aRatDoc,{SDE->DE_DOC,;
				SDE->DE_SERIE,;
				SDE->DE_FORNECE,;
				SDE->DE_LOJA,;
				SDE->DE_PERC,;
				SDE->DE_CUSTO1,;
				SDE->DE_CC,;
				Posicione("CTT",1,xFilial("CTT")+SDE->DE_CC,"CTT_DESC01")})
				
				
				
				DbSkip()
			Enddo
			
		EndIf
		
	EndIf
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	//Adiciona no Vetor os Centro de Custos utilizados no documento de entrada sem rateio
	
	
	DBSelectARea("SD1")
	DBSetOrder(1)
	DBSeek(TMP->E2_FILIAL + TMP->E2_NUM + TMP->E2_PREFIXO + TMP->E2_FORNECE + TMP->E2_LOJA)
	If Found()
		
		IF aScan(_aRatCC, { |x| x[1] == TMP->E2_NUM } ) == 0
			
			While !EOF() .AND. TMP->E2_FILIAL == SD1->D1_FILIAL .AND. TMP->E2_NUM == SD1->D1_DOC .AND. TMP->E2_PREFIXO == SD1->D1_SERIE .AND. TMP->E2_FORNECE == SD1->D1_FORNECE .AND. TMP->E2_LOJA == SD1->D1_LOJA .AND. !EMPTY(SD1->D1_CC)
				
				
				aAdd(_aRatCC,{SD1->D1_DOC,;
				SD1->D1_SERIE,;
				SD1->D1_FORNECE,;
				SD1->D1_ITEM,;
				SD1->D1_COD,;
				SD1->D1_DESCRI,;
				SD1->D1_CUSTO,;
				SD1->D1_CC,;
				Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_DESC01")})
				
				
				
				DbSkip()
			Enddo
			
		EndIf
		
	EndIf
	
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	cNum := TMP->E2_NUM
	
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	DBSelectArea("TMP")
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	// Impressão do Rateio de Natureza
	If cNum != TMP->E2_NUM
		
		If Len(_aRatNat) != 0
			
			For I := 1 to Len(_aRatNat)
				@nLin,138 PSAY _aRatNat[i][1]
				@nLin,150 PSAY _aRatNat[i][2]
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 67 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
			Next I
			
			nLin := nLin + 1 // Avanca a linha de impressao
			_aRatNat := {}
			
		EndIf
		
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		
		
		
		
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		// Impressão do Rateio do centro de custo Financeiro
		
		If Len(_aRatFin) != 0
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Rateio do Centro de Custo do Título: " + cNum
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			
			For I := 1 to Len(_aRatFin)
				@nLin,008 PSAY _aRatFin[i][4]
				@nLin,019 PSAY _aRatFin[i][5]
				@nLin,060 PSAY _aRatFin[i][2] Picture "@E 999.99%"
				@nLin,070 PSAY _aRatFin[i][3] Picture "@E 999,999,999.99"
				nPerc += _aRatFin[i][2]
				nVal  += _aRatFin[i][3]
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 67 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
			Next I
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Totalizador:"
			@nLin,060 PSAY nPerc Picture "@E 999.99%"
			@nLin,070 PSAY nVal Picture "@E 999,999,999.99"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			
			nLin := nLin + 2 // Avanca a linha de impressao
			_aRatFin := {}
			nPerc := 0
			nVal  := 0
			
		EndIf
		
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		// Impressão do Rateio do centro de custo do Documento de Entrada
		
		If Len(_aRatDoc) != 0
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Rateio do Centro de Custo do Título: " + cNum
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			
			For I := 1 to Len(_aRatDoc)
				@nLin,008 PSAY _aRatDoc[i][7]
				@nLin,019 PSAY _aRatDoc[i][8]
				@nLin,060 PSAY _aRatDoc[i][5] Picture "@E 999.99%"
				@nLin,070 PSAY _aRatDoc[i][6] Picture "@E 999,999,999.99"
				nPerc += _aRatDoc[i][5]
				nVal  += _aRatDoc[i][6]
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 67 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
			Next I
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Totalizador:"
			@nLin,060 PSAY nPerc Picture "@E 999.99%"
			@nLin,070 PSAY nVal Picture "@E 999,999,999.99"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			
			nLin := nLin + 2 // Avanca a linha de impressao
			_aRatDoc := {}
			nPerc := 0
			nVal  := 0
			
			
			
		EndIf
		
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		
		//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		// Impressão dos Centro de Custo dos documentos de entrada sem rateio
		
		If Len(_aRatCC) != 0
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Centro de Custos do Documento de Entrada: " + cNum
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			
			For I := 1 to Len(_aRatCC)
				@nLin,008 PSAY _aRatCC[i][4]
				@nLin,014 PSAY _aRatCC[i][5]
				@nLin,024 PSAY _aRatCC[i][6]
				@nLin,064 PSAY _aRatCC[i][7] Picture "@E 999,999,999.99"
				@nLin,080 PSAY _aRatCC[i][8]
				@nLin,090 PSAY _aRatCC[i][9]
				nVal  += _aRatCC[i][7]
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 67 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
			Next I
			
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "Totalizador:"
			@nLin,064 PSAY nVal Picture "@E 999,999,999.99"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,000 PSAY "-------------------------------------------------------------------------------------------------------------------"
			
			nLin := nLin + 2 // Avanca a linha de impressao
			_aRatCC := {}
			nVal  := 0
			
		EndIf
		
	EndIf
	
	//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	
	
	
EndDo

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

DBSelectARea("TMP")
DBCloseArea("TMP")

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Filial			?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Do  Numero 		?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"03","Ate Numero 		?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"04","Da  Parcela 	?","","","mv_ch04","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Ate Parcela 	?","","","mv_ch05","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Da  Emissao		?","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ate Emissao		?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Do  Vencimento	?","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Ate Vencimento	?","","","mv_ch09","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Do  Fornecedor	?","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"11","Ate Fornecedor	?","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"12","Da  Natureza	?","","","mv_ch12","C",10,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"13","Ate Natureza	?","","","mv_ch13","C",10,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","SED"})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

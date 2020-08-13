#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRATEREF   บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Visualiza o valor e a porcentagem pago de vale de refeicao บฑฑ
ฑฑ          ฑฑ  por centro de custo   									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VALEREFE

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Valores de Refeicao"
Local nLin           := 100
Local cTpVal		 := ""
Local Cabec1         := "Mat.    Nome                                                Valor    Tp. Refeicao"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "VALEREFE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "VALEREFE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "VALEREFE7"
Private cString      := "SRC"
Private cQuery       := ""
Private	nVal	 	 := 0
Private cTpVal		 := ""
Private aDias 		 := {}
Private aFast 		 := {}
Private aDem 		 := {}
Private aAdm 		 := {}
Private aSZO		 := {}
Private	nFunc 	     := 0
Private	nApnd 		 := 0
Private lDem		 := .F.
Private cNomeTp		 := ""
Private	nValRef  	 := 0
Private	nValAlim     := 0
Private nValTotRef   := 0
Private nValTotAlim  := 0
Private nValTotCest  := 0


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)


If MV_PAR06 == 1 // Vale Refei็ใo e Alimenta็ใo
	
	cQuery := "SELECT "
	cQuery += "RA_FILIAL,RA_MAT,RA_NOME,RA_VALREF,RA_ADMISSA,RA_DEMISSA,RA_CIC,RA_NASC,RA_SEXO,RA_DESCMED,RA_PERCREF,RA_CC,CTT_DESC01, "
	/*
	cQuery += "SUBSTR(RX_TXT,34,2) AS DIAS, "
	cQuery += "SUBSTR(RX_TXT,28,5) AS VALOR "
	*/
	
	cQuery += "RFO_DIAFIX AS DIAS, "
	cQuery += "RFO_VALOR AS VALOR "
	
	
	cQuery += "FROM SRA010 "
	/*
	cQuery += "INNER JOIN SRX010 ON "
	cQuery += "SRA010.RA_VALREF = SUBSTR(RX_COD,13,2) "
	*/
	cQuery += "INNER JOIN RFO010 ON "
	cQuery += "SRA010.RA_VALREF = RFO010.RFO_CODIGO "
	
	cQuery += "INNER JOIN CTT010 ON "
	cQuery += "SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND "
	cQuery += "SRA010.RA_CC = CTT010.CTT_CUSTO "
	cQuery += "WHERE "
	cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
	cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
	cQuery += "SRA010.RA_DESCMED <> '4' AND " //Refeicao ou Alimentacao
	cQuery += "SRA010.RA_VALREF <> '' AND "
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	/*
	cQuery += "SRX010.RX_TIP = '26' AND "
	cQuery += "SRX010.D_E_L_E_T_ <> '*' AND "
	*/                  
	cQuery += "RFO_TPVALE = '1'	AND "
	cQuery += "RFO010.D_E_L_E_T_ <> '*' AND "
	cQuery += "CTT010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY RA_NOME"
	
Else    // Cesta Alimenta็ใo
	
	cQuery := "SELECT "
	cQuery += "RA_FILIAL,RA_MAT,RA_NOME,RA_VALREF,RA_ADMISSA,RA_DEMISSA,RA_CIC,RA_NASC,RA_SEXO,RA_DESCMED,RA_PERCREF,RA_CC,CTT_DESC01, "
	/*
	cQuery += "(SELECT SUBSTR(RX_TXT,34,2) FROM SRX010 WHERE SUBSTR(RX_COD,13,2) = '10' AND D_E_L_E_T_ <> '*' AND RX_TIP = '26') AS DIAS, "
	cQuery += "(SELECT SUBSTR(RX_TXT,27,6)  FROM SRX010 WHERE SUBSTR(RX_COD,13,2) = '10' AND D_E_L_E_T_ <> '*' AND RX_TIP = '26') AS VALOR "
	*/	
	
	cQuery += "(SELECT RFO_DIAFIX FROM RFO010 WHERE RFO_CODIGO = '10' AND RFO_TPVALE = '1' AND D_E_L_E_T_ <> '*'  ) AS DIAS, "
	cQuery += "(SELECT RFO_VALOR  FROM RFO010 WHERE RFO_CODIGO = '10' AND RFO_TPVALE = '1' AND D_E_L_E_T_ <> '*'  ) AS VALOR "
	
	cQuery += "FROM SRA010 "
	cQuery += "INNER JOIN CTT010 ON "
	cQuery += "SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND "
	cQuery += "SRA010.RA_CC = CTT010.CTT_CUSTO "
	cQuery += "WHERE "
	cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
	cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
	cQuery += "SRA010.RA_DESCMED <> '4' AND " //Refeicao ou Alimentacao
	cQuery += "SRA010.RA_VALREF <> '' AND "
	cQuery += "SRA010.RA_CATFUNC <> 'E' AND " // Estagiario nใo recebe cesta Alimenta็ใo
	cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
	cQuery += "CTT010.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY RA_NOME "
	
EndIf




tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//Verifica as seguintes ocasioes:
// - Busca quantos dias os funcionarios e os menores aprendizes trabalham - IMPORTANTE: Essa informacao e para somente validar com o cadastro dos parametros REFEICAO
// - Preenche um Array com todos os dias do mes, diferenciando os dias da semana: Segunda, Terca, Quarta, Quinta, Sexta, Sabado e Domingo


DBSelectArea("RCG")
DBSetOrder(1)
DBSeek(xFilial("RCG") + SUBSTR(DTOS(MV_PAR04),1,4) + SUBSTR(DTOS(MV_PAR04),5,2))


While !EOF() .AND. RCG->RCG_ANO == SUBSTR(DTOS(MV_PAR04),1,4) .AND. RCG->RCG_MES == SUBSTR(DTOS(MV_PAR04),5,2)
	                 
	                                                                                                    
	If EMPTY(RCG->RCG_TNOTRA) 
	aAdd(aDias,{RCG->RCG_DIAMES,;
	RCG->RCG_TIPDIA})         
	
	IIF(RCG->RCG_TIPDIA != "3",nFunc += 1,nFunc += 0)
	IIF(RCG->RCG_TIPDIA == "1",nApnd += 1,nApnd += 0)
	
	EndIf
	

	
	DBSKIP()
	
Enddo

dIniDia := STOD(SUBSTR(DTOS(MV_PAR04),1,4) + SUBSTR(DTOS(MV_PAR04),5,2) + "01")  //1 dia do mes do pagamento
dFimDia := STOD(SUBSTR(DTOS(MV_PAR04),1,4) + SUBSTR(DTOS(MV_PAR04),5,2) + cValTOChar(len(aDias)))  //Ultimo dia do mes do pagamento




DBSelectArea("TMP")
DBGotop()

While !EOF()
	
	SetRegua(RecCount())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	
	//Caso a pessoa se encontra de ferias ou de afastamento, aki ira somar quantos dias devera ser descontado no calculo do valor do vale refeicao ou alimentacao
	
	
	DBSelectARea("SR8")
	DBSetOrder(1)
	DBSeek(TMP->RA_FILIAL + TMP->RA_MAT)
	If Found()
		
		While !EOF() .AND. SR8->R8_MAT == TMP->RA_MAT
			
			If SR8->R8_TIPOAFA == "001"
				DBSkip()
				Loop
			EndIf
			
			/*
			If EMPTY(SR8->R8_DATAFIM)
			DBSkip()
			Loop
			EndIf
			*/
			
			If (SR8->R8_DATAINI >= dIniDia .AND. SR8->R8_DATAINI <= dFimDia) .OR. (SR8->R8_DATAFIM >= dIniDia .AND. SR8->R8_DATAFIM <= dFimDia) .OR. (SR8->R8_DATAINI <= dIniDia .AND. SR8->R8_DATAFIM >= dFimDia) .OR. EMPTY(SR8->R8_DATAFIM)
				
				If EMPTY(SR8->R8_DATAFIM)//Nao tem previsao de volta
					
					dFimDiaMat := dFimDia
					
				else
					
					If SR8->R8_DATAFIM > dFimDia
						dFimDiaMat := dFimDia
					else
						dFimDiaMat := SR8->R8_DATAFIM
					EndIf
					
				Endif
				
				If SR8->R8_DATAINI < dIniDia
					dIniDiaMat := dIniDia
				else
					dIniDiaMat := SR8->R8_DATAINI
				EndIf
				
				
				If TMP->DIAS == nFunc
					
					For _J := dIniDiaMat To dFimDiaMat
						nPos := aScan(aDias, { |x| x[1] == _J} )
						If aDias[nPos][2] != "3"
							aAdd(aFast,{SUBSTR(DTOS(_J),7,2)})
						Endif
						
					Next _J
					
				else
					
					For _J := dIniDiaMat To dFimDiaMat
						nPos := aScan(aDias, { |x| x[1] == _J} )
						If aDias[nPos][2] == "1"
							aAdd(aFast,{SUBSTR(DTOS(_J),7,2)})
						Endif
						
					Next _J
					
				endIf
				
				
			endif
			
			
			dbSkip()
			
		eNDDO
		
	Endif
	
	If !EMPTY(TMP->RA_DEMISSA)
		//Pula os funcinarios demitidos
		If STOD(TMP->RA_DEMISSA) < dIniDia .OR. STOD(TMP->RA_DEMISSA) > dFimDia
			DBSELECTAREA("TMP")
			dbskip()
			Loop
		else
			
			//Calcula os vales ate a data que o funcionario foi demitido
			//Regra utilizada para funcionarios
			If TMP->DIAS == nFunc
				
				For _J := STOD(TMP->RA_DEMISSA) To  dFimDia
					nPos := aScan(aDias, { |x| x[1] == _J} )
					If aDias[nPos][2] != "3"
						aAdd(aDem,{SUBSTR(DTOS(_J),7,2)})
					Endif
					
				Next _J
				
			else
				//Regra utilizada para Menores Aprendizes
				For _J := STOD(TMP->RA_DEMISSA) To  dFimDia
					nPos := aScan(aDias, { |x| x[1] == _J} )
					If aDias[nPos][2] == "1"
						aAdd(aDem,{SUBSTR(DTOS(_J),7,2)})
					Endif
					
				Next _J
				
				
			endIf
			
		endif
		
	endif
	
	
	//Calcula os vales ate a data que o funcionario foi Admitido
	If STOD(TMP->RA_ADMISSA) > dIniDia .AND. STOD(TMP->RA_ADMISSA) < dFimDia
		
		
		//Regra utilizada para funcionarios
		If TMP->DIAS == nFunc
			
			For _J := dIniDia To  (STOD(TMP->RA_ADMISSA) - 1) // Alterado para corrigir os dias trabalhados
				nPos := aScan(aDias, { |x| x[1] == _J} )
				If aDias[nPos][2] != "3"
					aAdd(aAdm,{SUBSTR(DTOS(_J),7,2)})
				Endif
				
			Next _J
			
		else
			//Regra utilizada para Menores Aprendizes
			For _J := dIniDia To  (STOD(TMP->RA_ADMISSA) - 1) // Alterado para corrigir os dias trabalhados
				nPos := aScan(aDias, { |x| x[1] == _J} )
				If aDias[nPos][2] == "1"
					aAdd(aAdm,{SUBSTR(DTOS(_J),7,2)})
				Endif
				
			Next _J
			
			
		endIf
		
	endIf
	
	IF MV_PAR06 == 1	// Vale Refei็ใo
		// Valor total que sera pago do vale de refeicao ou alimentacao ao funcionario obedecendo data de admissao e demissao
		nVal := (TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))) * (TMP->VALOR)
		
	ELSE // Cesta Alimenta็ใo
		
		nVal := (TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))) * (TMP->VALOR/TMP->DIAS)
		
	EndIf
	
	
	If TMP->RA_DESCMED == "1"
		cNomeTp := "Refeicao"
	ElseIf TMP->RA_DESCMED == "2"
		cNomeTp := "Alimentacao"
	EndIf
	
	//Realiza o rateio de um funcionario que tem o cartใo de alimentacao e o refeicao
	
	If MV_PAR06 == 1
		
		If TMP->RA_DESCMED == "3"
			
			nValRef  := (nVal * TMP->RA_PERCREF)/100
			nValAlim := nVal - nValRef
			
			For _J := 1 To 2
				
				@nLin, 000 PSAY TMP->RA_MAT
				@nLin, 008 PSAY TMP->RA_NOME
				
				If  _J == 1
					@nLin, 060 PSAY nValRef PICTURE "@E 999.99"
					@nLin, 070 PSAY "Refeicao"
					nLin += 1
					
					//Grava no Vetor as informacoes que serao gravadas na tabela SZO quando solicitado pelo usuario
					
					aAdd(aSZO,{TMP->RA_FILIAL,;
					TMP->RA_MAT,;
					TMP->RA_NOME,;
					TMP->RA_CC,;
					TMP->CTT_DESC01,;
					cValtoChar(_J),; // Tipo 1= Refeicao; 2= Alimentacao; 3= Ambos
					TMP->RA_PERCREF,;
					nValRef,;
					(TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))),; //Dias Calculado
					SUBSTR(DTOS(MV_PAR04),5,2),; // Mes
					SUBSTR(DTOS(MV_PAR04),1,4)}) // Ano
					
					
					
				else
					
					@nLin, 060 PSAY nValAlim PICTURE "@E 999.99"
					@nLin, 070 PSAY "Alimentacao"
					
					//Grava no Vetor as informacoes que serao gravadas na tabela SZO quando solicitado pelo usuario
					
					aAdd(aSZO,{TMP->RA_FILIAL,;
					TMP->RA_MAT,;
					TMP->RA_NOME,;
					TMP->RA_CC,;
					TMP->CTT_DESC01,;
					cValtoChar(_J),; // Tipo 1= Refeicao; 2= Alimentacao; 3= Ambos
					(100 - TMP->RA_PERCREF),;
					nValAlim,;
					(TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))),; //Dias Calculado
					SUBSTR(DTOS(MV_PAR04),5,2),; // Mes
					SUBSTR(DTOS(MV_PAR04),1,4)}) // Ano
					
				endIf
				
				
				
			Next _J
			
			
			
		else
			
			//Iprimi os funcionarios que nใo quiseram realizar o  raterio
			
			@nLin, 000 PSAY TMP->RA_MAT
			@nLin, 008 PSAY TMP->RA_NOME
			@nLin, 060 PSAY nVal PICTURE "@E 999.99"
			@nLin, 070 PSAY cNomeTp
			
			aAdd(aSZO,{TMP->RA_FILIAL,;
			TMP->RA_MAT,;
			TMP->RA_NOME,;
			TMP->RA_CC,;
			TMP->CTT_DESC01,;
			TMP->RA_DESCMED,; // Tipo 1= Refeicao; 2= Alimentacao; 3= Ambos
			100,;
			nVal,;
			(TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))),; //Dias Calculado
			SUBSTR(DTOS(MV_PAR04),5,2),; // Mes
			SUBSTR(DTOS(MV_PAR04),1,4)}) // Ano
			
		EndIf
		
	else // Grava ou imprimi a cesta Alimenta็ใo
		
		@nLin, 000 PSAY TMP->RA_MAT
		@nLin, 008 PSAY TMP->RA_NOME
		@nLin, 060 PSAY nVal PICTURE "@E 999.99"
		@nLin, 070 PSAY "Cesta Alimenta็ใo"
		
		aAdd(aSZO,{TMP->RA_FILIAL,;
		TMP->RA_MAT,;
		TMP->RA_NOME,;
		TMP->RA_CC,;
		TMP->CTT_DESC01,;
		"3",; // Cesta Alimenta็ใo
		100,;
		nVal,;
		(TMP->DIAS - (LEN(aFast) + LEN(aDem) + LEN(aAdm))),; //Dias Calculado,; //Dias Calculado
		SUBSTR(DTOS(MV_PAR04),5,2),; // Mes
		SUBSTR(DTOS(MV_PAR04),1,4)}) // Ano
		
		
		
		
	EndIf
	
	
	
	
	/*
	@nLin, 000 PSAY "%"
	@nLin, 005 PSAY TMP->RA_NOME
	@nLin, 056 PSAY TMP->RA_CIC
	@nLin, 068 PSAY STOD(TMP->RA_NASC)
	@nLin, 078 PSAY TMP->RA_SEXO
	@nLin, 082 PSAY nVal PICTURE "@E 999.99"
	@nLin, 092 PSAY "FI"
	@nLin, 104 PSAY "169"
	@nLin, 116 PSAY TMP->RA_MAT
	@nLin, 125 PSAY "%"
	
	*/
	
	
	
	DBSelectArea("TMP")
	dbskip()
	
	nLin 			+= 1 // Avanca a linha de impressao
	
	
	
	//Zera as variaveis, caso contrario poderemos ter problemas quando filtrado varios funcionarios
	dFimDiaMat := "//"
	dIniDiaMat := "//"
	aFast := {}
	aDem  := {}
	aAdm  := {}
	nPos := 0
	nVal := 0
	lDem := .F.
	
	
ENDDO

If len(aSZO) > 0  .AND. MV_PAR05 == 1
	
	For _J := 1 To len(aSZO)
		
		
		DBSelectArea("SZO")
		DBSetOrder(1)
		DBSeek(aSZO[_J][1] + aSZO[_J][2] + aSZO[_J][10] + aSZO[_J][11] + alltrim(aSZO[_J][6]) )
		If !Found()
			
			
			
			RecLock("SZO",.T.)
			SZO->ZO_FILIAL	  := aSZO[_J][1]
			SZO->ZO_MAT		  := aSZO[_J][2]
			SZO->ZO_NOME	  := aSZO[_J][3]
			SZO->ZO_CC		  := aSZO[_J][4]
			SZO->ZO_NOMECC	  := aSZO[_J][5]
			SZO->ZO_TPREF	  := alltrim(aSZO[_J][6])
			SZO->ZO_PERC	  := aSZO[_J][7]
			SZO->ZO_DIAS	  := aSZO[_J][9]
			SZO->ZO_VALOR	  := aSZO[_J][8]
			SZO->ZO_MES		  := aSZO[_J][10]
			SZO->ZO_ANO		  := aSZO[_J][11]
			SZO->ZO_USERLGI	  := "SISTEMA"
			MsUnlock()
			
			
			
		else
			
			RecLock("SZO",.F.)
			SZO->ZO_FILIAL	  := aSZO[_J][1]
			SZO->ZO_MAT		  := aSZO[_J][2]
			SZO->ZO_NOME	  := aSZO[_J][3]
			SZO->ZO_CC		  := aSZO[_J][4]
			SZO->ZO_NOMECC	  := aSZO[_J][5]
			SZO->ZO_TPREF	  := alltrim(aSZO[_J][6])
			SZO->ZO_PERC	  := aSZO[_J][7]
			SZO->ZO_DIAS	  := aSZO[_J][9]
			SZO->ZO_VALOR	  := aSZO[_J][8]
			SZO->ZO_MES		  := aSZO[_J][10]
			SZO->ZO_ANO		  := aSZO[_J][11]
			SZO->ZO_USERLGI	  := "SISTEMA"
			SZO->ZO_USERLGA	  := "SISTEMA"
			MsUnlock()
			
		EndIf
		
		
		
	Next _J
	
EndIf

IF MV_PAR06 == 1 //Soma dos valores totais do vale transporte e refeicao
	
	For _J := 1 To len(aSZO)
		
		If alltrim(aSZO[_J][6]) == "1"
			nValTotRef  += aSZO[_J][8]
		else
			nValTotAlim += aSZO[_J][8]
		endIf
		
	Next _J
	
	@nLin, 000 PSAY "------------------------------------------------------------------------------------------"
	nLin += 1
	@nLin, 000 PSAY "Refeicao:"
	@nLin, 016 PSAY nValTotRef PICTURE "@E 999,999,999.99"
	nLin += 1
	@nLin, 000 PSAY "Alimentacao:"
	@nLin, 016 PSAY nValTotAlim PICTURE "@E 999,999,999.99"
	nLin += 1
	@nLin, 000 PSAY "------------------------------------------------------------------------------------------"
	
ELSE //Soma dos valores totais da Cesta Alimenta็ใo
	
	
	For _J := 1 To len(aSZO)
		
		nValTotCest  += aSZO[_J][8]
		
	Next _J
	
	@nLin, 000 PSAY "------------------------------------------------------------------------------------------"
	nLin += 1
	@nLin, 000 PSAY "Cesta Alimenta็ใo:"
	@nLin, 016 PSAY nValTotCest PICTURE "@E 999,999,999.99"
	nLin += 1
	@nLin, 000 PSAY "------------------------------------------------------------------------------------------"
	
ENDIF







//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

DBSelectArea("TMP")
DBCloseArea("TMP")
DBSelectArea("RCG")
DBCloseArea("RCG")
DBSelectArea("SR8")
DBCloseArea("SR8")

Return




Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Filial ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Matricula De ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Matricula Ate ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Dt. Referente ?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Grava Tabela ?","","","mv_ch05","N",01,0,2,"C","","mv_par05","Sim",ฌ"","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Tipo Refeicao ?","","","mv_ch06","N",01,0,2,"C","","mv_par06","Refeicao/Alimentacao","","","","","Cesta Alimenta็ใo","","","","","","","","","","","","","","","","","","",""})







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

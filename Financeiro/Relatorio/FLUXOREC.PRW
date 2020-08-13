#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    14/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FLUXO A RECEBER						                        ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FLUXOREC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := ""
Private cPict          := ""
Private nLin           := 100

Private Cabec1         := ""
Private Cabec2         := ""
Private Cabec3         := ""
Private imprime        := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "FLUXOREC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FLUXOREC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "FLUXOREC3"
Private cString      := "SE1"
Private cQuery       := ""
Private cfiltro      := ""
Private titulo       := "Previsão a Receber"
Private aTitulos 	 := {}
Private aRegistros	 := {}
Private cNatGer 	 := ""
Private nSubTotal  	 := 0
Private nTotal 		 := 0
Private nTotalDesp	 := 0
Private aRegistro 	:= {}
Private cDias	 	:= ""
Private cNatureza	:= ""
Private nVec     	:= 0
Private nRec 		:= 0
Private nUlDia		:= 0
Private nDias		:= 0
Private nPos		:= 0
Private nCol		:= 0
Private cCampo		:= ""
Private nNum		:= 0
Private nNum1		:= 0
Private nTotGer		:= 0
Private	lOk 		:= .F.
Private nValor		:= 0
Private aNatureza	:= {}
Private nVend		:= ""
Private dVencto	    := CTOD("  /  /  ")
Private dVencrea	:= CTOD("  /  /  ")
Private dEmissao    := CTOD("  /  /  ")
Private dData	    := CTOD("  /  /  ")

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando Relatório")

Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Relatorio()

//Query para titulos a receber - SE1

cQuery := "SELECT E1_EMISSAO AS EMISSAO,ED_CONTSIG,E1_NUM AS TITULO,E1_VENCREA AS VENCREAL,E1_VENCTO AS VENCTO, "
cQuery += "(SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA) AS NOME, "
cQuery += "(SELECT A3_NOME FROM SA3010 WHERE A3_COD = E1_VEND1 AND D_E_L_E_T_ = '') AS NOMEVEND, "
cQuery += "E1_HIST AS HISTORICO, "
IF MV_PAR02 == 1
	cQuery += "ED_NATGER AS NATGER, "
ELSEIF MV_PAR02 == 2
	cQuery += "ED_NATFLUX AS NATGER, "
ELSEIF MV_PAR02 == 3
	cQuery += "E1_NATUREZ AS NATGER, "
ELSEIF MV_PAR02 == 4
	cQuery += "ED_CONTSIG AS NATGER, "
ENDIF
cQuery += "E1_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRICAO, "
cQuery += "(E1_SALDO - E1_IRRF - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL + E1_JUROS + E1_ACRESC) AS VALOR "
cQuery += "FROM SE1010 INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE1010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E1_SALDO > 0 "
//cQuery += "AND E1_VENCREA < '"+DTOS(MV_PAR13)+"' "
cQuery += "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-') "
cQuery += "AND E1_PORTADO NOT IN ('JUR','CAR') "
cQuery += "AND E1_FILIAL = '01' "
cQuery += "AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR06)+"' "
cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
cQuery += "AND E1_NUM BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
cQuery += "AND E1_VENCNOV = '' "
cQuery += "AND E1_MULTNAT <> '1' "   

cQuery += "UNION "  //Titulos SE1 com rateio - 03/03/2016 - Elisangela

cQuery := "SELECT E1_EMISSAO AS EMISSAO,ED_CONTSIG,E1_NUM AS TITULO,E1_VENCREA AS VENCREAL,E1_VENCTO AS VENCTO, "
cQuery += "(SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA) AS NOME, "
cQuery += "(SELECT A3_NOME FROM SA3010 WHERE A3_COD = E1_VEND1 AND D_E_L_E_T_ = '') AS NOMEVEND, "
cQuery += "E1_HIST AS HISTORICO, "
IF MV_PAR02 == 1
	cQuery += "ED_NATGER AS NATGER, "
ELSEIF MV_PAR02 == 2
	cQuery += "ED_NATFLUX AS NATGER, "
ELSEIF MV_PAR02 == 3
	cQuery += "E1_NATUREZ AS NATGER, "
ELSEIF MV_PAR02 == 4
	cQuery += "ED_CONTSIG AS NATGER, "
ENDIF
cQuery += "EV_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRICAO, "
cQuery += "((E1_SALDO - E1_IRRF - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL + E1_JUROS + E1_ACRESC) * EV_PERC) AS VALOR "  
cQuery += "FROM SE1010 " 
cQuery += "INNER JOIN SEV010 ON E1_PREFIXO = EV_PREFIXO AND E1_NUM = EV_NUM AND E1_PARCELA = EV_PARCELA " 
cQuery += "AND E1_TIPO = EV_TIPO AND E1_CLIENTE = EV_CLIFOR AND E1_LOJA = EV_LOJA AND EV_RECPAG = 'R' "
cQuery += "INNER JOIN SED010 ON EV_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE1010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' AND SEV010.D_E_L_E_T_ = ''"
cQuery += "AND E1_SALDO > 0 "
//cQuery += "AND E1_VENCREA < '"+DTOS(MV_PAR13)+"' "
cQuery += "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-') "
cQuery += "AND E1_PORTADO NOT IN ('JUR','CAR') "
cQuery += "AND E1_FILIAL = '01' "
cQuery += "AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR06)+"' "
cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
cQuery += "AND E1_NUM BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
cQuery += "AND E1_VENCNOV = '' "
cQuery += "AND E1_MULTNAT = '1' "

cQuery += "UNION "  //Separa os titulos com data de vencimento alterada

cQuery += "SELECT E1_EMISSAO AS EMISSAO,ED_CONTSIG,E1_NUM AS TITULO,E1_VENCNOV AS VENCREAL,E1_VENCTO AS VENCTO, "
cQuery += "(SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA) AS NOME, "
cQuery += "(SELECT A3_NOME FROM SA3010 WHERE A3_COD = E1_VEND1 AND D_E_L_E_T_ = '') AS NOMEVEND, "
cQuery += "E1_HIST AS HISTORICO, "

IF MV_PAR02 == 1
	cQuery += "ED_NATGER AS NATGER, "
ELSEIF MV_PAR02 == 2
	cQuery += "ED_NATFLUX AS NATGER, "
ELSEIF MV_PAR02 == 3
	cQuery += "E1_NATUREZ AS NATGER, "
ELSEIF MV_PAR02 == 4
	cQuery += "ED_CONTSIG AS NATGER, "
ENDIF

cQuery += "E1_NATUREZ AS NATUREZA,ED_DESCRIC AS DESCRICAO, "
cQuery += "(E1_SALDO - E1_IRRF - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL + E1_JUROS + E1_ACRESC) AS VALOR "
cQuery += "FROM SE1010 INNER JOIN SED010 ON E1_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE1010.D_E_L_E_T_ = '' AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E1_SALDO > 0 "
//cQuery += "AND E1_VENCREA < '"+DTOS(MV_PAR13)+"' "
cQuery += "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-') "
cQuery += "AND E1_PORTADO NOT IN ('JUR','CAR') "
cQuery += "AND E1_FILIAL = '01' "
cQuery += "AND E1_VENCNOV BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR06)+"' "
cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
cQuery += "AND E1_NUM BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
cQuery += "AND E1_VENCNOV <> '' " 
cQuery += "AND E1_MULTNAT <> '1' "

tcQuery cQuery New Alias "TMPSE1"

//Movimento bancario a receber - SE5

cQuery := "SELECT E5_FILIAL,E5_DATA,E5_NATUREZ,ED_DESCRIC,ED_CONTSIG,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_FILIAL, "
cQuery += "E5_PREFIXO,E5_NUMERO,E5_TIPO,E5_PARCELA,E5_RECPAG,E5_CLIFOR,E5_LOJA,E5_HISTOR, "
cQuery += "(SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = E5_CLIFOR AND A1_LOJA = E5_LOJA) AS NOME, "
cQuery += "(SELECT A3_NOME FROM SA3010 WHERE A3_COD = (SELECT E1_VEND1 FROM SE1010 WHERE D_E_L_E_T_ = '' AND E1_NUM = E5_NUMERO "
cQuery += "AND E5_FILIAL = E1_FILIAL AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIFOR = E1_CLIENTE "
cQuery += "AND E5_LOJA = E1_LOJA AND E5_TIPO = E1_TIPO) AND D_E_L_E_T_ = '') AS NOMEVEND, "
cQuery += "(SELECT E1_VENCTO FROM SE1010 WHERE D_E_L_E_T_ = '' AND E1_NUM = E5_NUMERO "
cQuery += "AND E5_FILIAL = E1_FILIAL AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIFOR = E1_CLIENTE  "
cQuery += "AND E5_LOJA = E1_LOJA AND E5_TIPO = E1_TIPO) AS VENCTO, "
cQuery += "(SELECT E1_EMISSAO FROM SE1010 WHERE D_E_L_E_T_ = '' AND E1_NUM = E5_NUMERO "
cQuery += "AND E5_FILIAL = E1_FILIAL AND E5_PREFIXO = E1_PREFIXO AND E5_PARCELA = E1_PARCELA AND E5_CLIFOR = E1_CLIENTE  "
cQuery += "AND E5_LOJA = E1_LOJA AND E5_TIPO = E1_TIPO) AS EMISSAO, "
IF MV_PAR02 == 1
	cQuery += "ED_NATGER AS NATGER, "
ELSEIF MV_PAR02 == 2
	cQuery += "ED_NATFLUX AS NATGER, "
ELSEIF MV_PAR02 == 3
	cQuery += "E5_NATUREZ AS NATGER, "
ELSEIF MV_PAR02 == 4
	cQuery += "ED_CONTSIG AS NATGER, "
ENDIF
cQuery += "E5_VALOR,E5_SEQ "
cQuery += "FROM SE5010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "E5_NATUREZ = ED_CODIGO "
cQuery += "WHERE SE5010.D_E_L_E_T_ = '' "
cQuery += "AND SED010.D_E_L_E_T_ = '' "
cQuery += "AND E5_FILIAL = '01' "
cQuery += "AND E5_DATA BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
cQuery += "AND E5_RECPAG = 'R' "

IF MV_PAR20 == 1
	cQuery += "AND E5_RECONC = 'x' "
ENDIF

cQuery += "AND E5_NATUREZ <> '1503001' "
cQuery += "AND E5_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "

IF !EMPTY(MV_PAR16) //Filtra Bancos
	cQuery += "AND E5_BANCO IN " + FormatIn(MV_PAR16,";") + " "
ENDIF

IF !EMPTY(MV_PAR17) //Filtra Agencia
	cQuery += "AND E5_AGENCIA IN " + FormatIn(MV_PAR17,";") + " "
ENDIF

IF !EMPTY(MV_PAR18) //Filtra Conta
	cQuery += "AND E5_CONTA IN " + FormatIn(MV_PAR18,";") + " "
ENDIF

tcQuery cQuery New Alias "TMPSE5"

IF MV_PAR19 == 1
	
	// Cadastro de previsoes
	
	cQuery := "SELECT ZA7_VENCRE AS EMISSAO, ZA7_CODIGO AS TITULO,ZA7_VENCRE AS VENCREAL, ZA7_NOMCLI AS NOME,ZA7_HIST AS HISTORICO,ZA7_VENC AS VENCTO, "
	cQuery += "ZA7_NATURE AS NATUREZA,ED_DESCRIC,ED_CONTSIG, "
	IF MV_PAR02 == 1
		cQuery += "ED_NATGER AS NATGER, "
	ELSEIF MV_PAR02 == 2
		cQuery += "ED_NATFLUX AS NATGER, "
	ELSEIF MV_PAR02 == 3
		cQuery += "E5_NATUREZ AS NATGER, "
	ELSEIF MV_PAR02 == 4
		cQuery += "ED_CONTSIG AS NATGER, "
	ENDIF
	cQuery += "ZA7_NATGER AS NATGER, ZA7_VALOR AS VALOR,ED_DESCRIC "
	cQuery += "FROM ZA7010  "
	cQuery += "INNER JOIN SED010 ON "
	cQuery += "ZA7_NATURE = ED_CODIGO "
	cQuery += "WHERE ZA7010.D_E_L_E_T_ = '' "
	cQuery += "AND SED010.D_E_L_E_T_ = '' "
	//cQuery += "AND ZA7_NATGER BETWEEN '"+(MV_PAR13)+"' AND '"+(MV_PAR14)+"' "
	cQuery += "AND ZA7_VENCRE BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
	//cQuery += "AND ZA7_EMISSA BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
	//cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
	cQuery += "AND ZA7_CODIGO BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' "
	cQuery += "AND ZA7_NATURE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += "ORDER BY ZA7_NATGER,ZA7_VENCRE"
	
	tcQuery cQuery New Alias "TMPPR"
	
ENDIF

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DBSelectArea("TMPSE1")
DBGotop()

While !TMPSE1->(EOF())
	
	IF MV_PAR02 == 1
		cNatureza		:= Posicione("SX5",1,xFilial("SX5") + "ZV" +TMPSE1->NATGER,"X5_DESCRI")
	ELSEIF MV_PAR02 == 2
		cNatureza	:= Posicione("SX5",1,xFilial("SX5") + "ZL" + TMPSE1->NATGER,"X5_DESCRI")
	ELSEIF MV_PAR02 == 3
		cNatureza	:= ALLTRIM(TMPSE1->DESCRICAO)
	ELSEIF MV_PAR02 == 4
		cNatureza	:= 	ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMPSE1->NATGER,"X5_DESCRI"))
	ENDIF
	
	IF TMPSE1->NOMEVEND == "(null)"
		cVend := ""
	ELSE
		cVend := TMPSE1->NOMEVEND
	ENDIF
	
	IF TMPSE1->NATGER == "1001"  //Vencimento de 1 dia a mais por se tratar de boletos - Edna / Elenn 04/11/15
		dVencrea := DATAVALIDA(STOD(TMPSE1->VENCTO) + 1)
	ELSEIF ALLTRIM(TMPSE1->NATUREZA) == "1101007" .OR. ALLTRIM(TMPSE1->NATUREZA) == "1101008"
		dVencrea := STOD(TMPSE1->VENCREAL)
	ELSE
		dVencrea := DATAVALIDA(STOD(TMPSE1->VENCREAL))
	ENDIF
	
	aAdd(aTitulos,{STOD(TMPSE1->EMISSAO),;
	TMPSE1->TITULO,;
	dVencrea,;
	TMPSE1->NOME,;
	TMPSE1->HISTORICO,;
	TMPSE1->VALOR,;
	TMPSE1->NATUREZA,;
	TMPSE1->DESCRICAO,;
	TMPSE1->NATGER,;
	cNatureza,;
	TMPSE1->ED_CONTSIG,;
	cVend,;
	STOD(TMPSE1->VENCTO),;
	"TMPSE1"})
	
	
	DBSelectArea("TMPSE1")
	DBSkip()
	
Enddo

DBSelectArea("TMPSE1")
dbCloseArea("TMPSE1")

DBSelectArea("TMPSE5")
DBGotop()

While !TMPSE5->(EOF())
	
	IF MV_PAR02 == 1
		cNatureza	:= Posicione("SX5",1,xFilial("SX5") + "ZV" +TMPSE5->NATGER,"X5_DESCRI")
	ELSEIF MV_PAR02 == 2
		cNatureza	:= Posicione("SX5",1,xFilial("SX5") + "ZL" + TMPSE5->NATGER,"X5_DESCRI")
	ELSEIF MV_PAR02 == 3
		cNatureza	:= ALLTRIM(TMPSE5->ED_DESCRIC)
	ELSEIF MV_PAR02 == 4
		cNatureza	:= 	ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMPSE5->NATGER,"X5_DESCRI"))
	ENDIF
	
	IF TMPSE5->NOMEVEND == "(null)"
		cVend := ""
	ELSE
		cVend := TMPSE5->NOMEVEND
	ENDIF
	
	IF TMPSE5->VENCTO == "(null)"
		dVencto := STOD(TMPSE5->E5_DATA)
	ELSE
		dVencto := STOD(TMPSE5->VENCTO)
	ENDIF
	
	IF TMPSE5->EMISSAO == "(null)"
		dEmissao := STOD(TMPSE5->E5_DATA)
	ELSE
		dEmissao := STOD(TMPSE5->EMISSAO)
	ENDIF
	
	
	aAdd(aTitulos,{dEmissao,;
	TMPSE5->E5_NUMERO,;
	STOD(TMPSE5->E5_DATA),;
	TMPSE5->NOME,;
	TMPSE5->E5_HISTOR,;
	TMPSE5->E5_VALOR,;
	TMPSE5->E5_NATUREZ,;
	TMPSE5->ED_DESCRIC,;
	TMPSE5->NATGER,;
	cNatureza,;
	TMPSE5->ED_CONTSIG,;
	cVend,;
	dVencto,;
	"TMPSE5",;
	})
	
	DBSelectArea("TMPSE5")
	DBSkip()
	
Enddo

DBSelectArea("TMPSE5")
dbCloseArea("TMPSE5")

IF MV_PAR19 == 1
	
	DBSelectArea("TMPPR")
	DBGotop()
	
	While !TMPPR->(EOF())
		
		IF MV_PAR02 == 1
			cNatureza	:= Posicione("SX5",1,xFilial("SX5") + "ZV" +TMPPR->NATGER,"X5_DESCRI")
		ELSEIF MV_PAR02 == 2
			cNatureza	:= Posicione("SX5",1,xFilial("SX5") + "ZL" + TMPPR->NATGER,"X5_DESCRI")
		ELSEIF MV_PAR02 == 3
			cNatureza	:= ALLTRIM(TMPPR->ED_DESCRIC)
		ELSEIF MV_PAR02 == 4
			cNatureza	:= 	ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"Z8"+TMPPR->NATGER,"X5_DESCRI"))
		ENDIF
		
		nValor := TMPPR->VALOR
		
		For i:=1 to Len(aTitulos)
			
			IF ALLTRIM(aTitulos[i][7]) == ALLTRIM(TMPPR->NATUREZA)
				nValor := nValor - aTitulos[i][6]
			ENDIF
			
		Next
		
		IF nValor > 0
			
			aAdd(aTitulos,{STOD(TMPPR->EMISSAO),;  // 1
			TMPPR->TITULO,; // 2
			STOD(TMPPR->VENCREAL),; // 3
			TMPPR->NOME,; // 4
			TMPPR->HISTORICO,; // 5
			nValor,; // 6
			TMPPR->NATUREZA,; // 7
			TMPPR->ED_DESCRIC,; // 8
			TMPPR->NATGER,; // 9
			cNatureza,; // 10
			TMPPR->ED_CONTSIG,; //11
			"",; // 12
			STOD(TMPPR->VENCTO),; // 13
			"TMPPR"}) // 14
			
		endif
		
		DBSelectArea("TMPPR")
		DBSkip()
		
	Enddo
	
	DBSelectArea("TMPPR")
	dbCloseArea("TMPPR")
	
ENDIF

IF MV_PAR01 == 1  //Analitico
	
	// **************************** Cria Arquivo Temporario
	_aStru1:={}//SPCSQL->(DbStruct())
	aadd( _aStru1 , {"CTSIG"      		, "C" , 006 , 00 } )
	aadd( _aStru1 , {"EMISSAO"      	, "D" , 010 , 00 } )
	aadd( _aStru1 , {"DOC	"			, "C" , 010 , 00 } )
	aadd( _aStru1 , {"CLIENTE"		    , "C" , 050 , 00 } )
	aadd( _aStru1 , {"VENCREAL"		    , "D" , 010 , 00 } )
	aadd( _aStru1 , {"VALOR"			, "N" , 014 , 02 } )
	aadd( _aStru1 , {"VENCTO"		    , "D" , 010 , 00 } )
	aadd( _aStru1 , {"VALORNF"			, "N" , 014 , 02 } )
	aadd( _aStru1 , {"NOMEVEND"			, "C" , 040 , 00 } )
	aadd( _aStru1 , {"NATUREZA"		    , "C" , 010 , 00 } )
	aadd( _aStru1 , {"DESCRICAO"		, "C" , 040 , 00 } )
	
	_cTemp := CriaTrab(_aStru1, .T.)
	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	ASORT(aTitulos,,,{|x,y|x[9]+DTOS(x[3]) < y[9]+DTOS(y[3])})
	
	For i:=1 to Len(aTitulos)
		
		If i == 1
			IF aTitulos[i][3] >= MV_PAR05 .AND.  aTitulos[i][3] <= MV_PAR06
				cNatGer := aTitulos[i][09]
				Reclock("TMP1",.T.)
				IF MV_PAR02 == 1
					TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][9],"X5_DESCRI")
				ELSEIF MV_PAR02 == 2
					TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "ZL" + aTitulos[i][9],"X5_DESCRI")
				ELSEIF MV_PAR02 == 3
					TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][7]) + " " + ALLTRIM(aTitulos[i][8])
				ELSEIF MV_PAR02 == 4
					TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "Z8" + aTitulos[i][9],"X5_DESCRI")
				ENDIF
				MsUnlock()
				
			ENDIF
		EndIf
		
		If cNatGer != aTitulos[i][09] .AND. aTitulos[i][3] >= MV_PAR05 .AND.  aTitulos[i][3] <= MV_PAR06
			
			//SubTotal
			Reclock("TMP1",.T.)
			IF MV_PAR02 == 1
				TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "ZV" + cNatGer,"X5_DESCRI")
			ELSEIF MV_PAR02 == 2
				TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "ZL" + cNatGer,"X5_DESCRI")
			ELSEIF MV_PAR02 == 3
				TMP1->CLIENTE		:= ALLTRIM(aTitulos[i][8])
			ELSEIF MV_PAR02 == 4
				TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "Z8" + cNatGer,"X5_DESCRI")
			ENDIF
			TMP1->VALOR 		:= nSubTotal
			MsUnlock()
			
			// Pula Linha
			Reclock("TMP1",.T.)
			MsUnlock()
			
			//Cabeçalho
			Reclock("TMP1",.T.)
			IF MV_PAR02 == 1
				TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "ZV" + aTitulos[i][9],"X5_DESCRI")
			ELSEIF MV_PAR02 == 2
				TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "ZL" + aTitulos[i][9],"X5_DESCRI")
			ELSEIF MV_PAR02 == 3
				TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][7]) + " " + ALLTRIM(aTitulos[i][8])
			ELSEIF MV_PAR02 == 4
				TMP1->CLIENTE	:= ALLTRIM(aTitulos[i][9]) + " " + Posicione("SX5",1,xFilial("SX5") + "Z8" + aTitulos[i][9],"X5_DESCRI")
			ENDIF
			MsUnlock()
			
			nSubTotal := 0
			
		EndIf
		
		IF aTitulos[i][3] >= MV_PAR05 .AND.  aTitulos[i][3] <= MV_PAR06
			
			Reclock("TMP1",.T.)
			TMP1->CTSIG			:= aTitulos[i][11]
			TMP1->EMISSAO		:= aTitulos[i][1]
			TMP1->DOC			:= aTitulos[i][2]
			TMP1->CLIENTE   	:= aTitulos[i][4]
			TMP1->VENCREAL		:= aTitulos[i][3]
			TMP1->VALOR 		:= aTitulos[i][6]
			TMP1->VENCTO		:= aTitulos[i][13]
			TMP1->NOMEVEND		:= aTitulos[i][12]
			TMP1->NATUREZA		:= aTitulos[i][7]
			TMP1->DESCRICAO 	:= aTitulos[i][8]
			MsUnlock()
			
			nSubTotal 	+= aTitulos[i][6]
			nTotal 		+= aTitulos[i][6]
			cNatGer 	:= aTitulos[i][9]
			
		ENDIF
		
	Next
	
	// Subtotal do ultimo registro que não será impresso no FOR
	Reclock("TMP1",.T.)
	IF MV_PAR02 == 1
		TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "ZV" + cNatGer,"X5_DESCRI")
	ELSEIF MV_PAR02 == 2
		TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "ZL" + cNatGer,"X5_DESCRI")
	ELSEIF MV_PAR02 == 3
		TMP1->CLIENTE		:= ALLTRIM(aTitulos[i][8])
	ELSEIF MV_PAR02 == 4
		TMP1->CLIENTE		:= Posicione("SX5",1,xFilial("SX5") + "Z8" + cNatGer,"X5_DESCRI")
	ENDIF
	TMP1->VALOR 		:= nSubTotal
	MsUnlock()
	
	// Pula Linha
	Reclock("TMP1",.T.)
	MsUnlock()
	
	// Total
	Reclock("TMP1",.T.)
	TMP1->CLIENTE		:= UPPER("Total previsto:")
	TMP1->VALOR 		:= nTotal
	MsUnlock()
	
	
ELSEIF MV_PAR01 == 2  //Analitico por dia
	
	// **************************** Cria Arquivo Temporario
	_aStru1:={}//SPCSQL->(DbStruct())
	aadd( _aStru1 , {"CTSIG"      		, "C" , 006 , 00 } )
	aadd( _aStru1 , {"EMISSAO"      	, "D" , 010 , 00 } )
	aadd( _aStru1 , {"DOC	"			, "C" , 010 , 00 } )
	aadd( _aStru1 , {"CLIENTE"		    , "C" , 050 , 00 } )
	aadd( _aStru1 , {"VENCREAL"		    , "D" , 010 , 00 } )
	aadd( _aStru1 , {"VALOR"			, "N" , 014 , 02 } )
	aadd( _aStru1 , {"VENCTO"		    , "D" , 010 , 00 } )
	aadd( _aStru1 , {"VALORNF"			, "N" , 014 , 02 } )
	aadd( _aStru1 , {"NOMEVEND"			, "C" , 040 , 00 } )
	aadd( _aStru1 , {"NATUREZA"			, "C" , 020 , 00 } )	
	
	_cTemp := CriaTrab(_aStru1, .T.)
	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	lOk := .F.
	
	ASORT(aTitulos,,,{|x,y|DTOS(x[3])+x[2] < DTOS(y[3])+y[2]})
	
	For i:=1 to Len(aTitulos)
		
		If dData != aTitulos[i][03] .AND. aTitulos[i][3] >= MV_PAR05 .AND.  aTitulos[i][3] <= MV_PAR06 .AND. lOk
			
			//SubTotal
			Reclock("TMP1",.T.)
			TMP1->CLIENTE		:= "SUBTOTAL"
			TMP1->VALOR 		:= nSubTotal
			MsUnlock()
			
			// Pula Linha
			Reclock("TMP1",.T.)
			MsUnlock()
			
			nSubTotal := 0
			
		EndIf
		
		IF aTitulos[i][3] >= MV_PAR05 .AND.  aTitulos[i][3] <= MV_PAR06
			
			Reclock("TMP1",.T.)
			TMP1->CTSIG			:= aTitulos[i][11]
			TMP1->EMISSAO		:= aTitulos[i][1]
			TMP1->DOC			:= aTitulos[i][2]
			TMP1->CLIENTE   	:= aTitulos[i][4]
			TMP1->VENCREAL		:= aTitulos[i][3]
			TMP1->VALOR 		:= aTitulos[i][6]
			TMP1->VENCTO		:= aTitulos[i][13]
			TMP1->NOMEVEND		:= aTitulos[i][12] 
			TMP1->NATUREZA		:= aTitulos[i][8]			
			MsUnlock()
			
			nSubTotal 	+= aTitulos[i][6]
			nTotal 		+= aTitulos[i][6]
			dData 		:= aTitulos[i][03]
			lOk 		:= .T.
			
		ENDIF
		
	Next
	
	// Subtotal do ultimo registro que não será impresso no FOR
	Reclock("TMP1",.T.)
	TMP1->CLIENTE		:= "SUBTOTAL"
	TMP1->VALOR 		:= nSubTotal
	MsUnlock()
	
	// Pula Linha
	Reclock("TMP1",.T.)
	MsUnlock()
	
	// Total
	Reclock("TMP1",.T.)
	TMP1->CLIENTE		:= "TOTAL"
	TMP1->VALOR 		:= nTotal
	MsUnlock()
	
ELSEIF MV_PAR01 == 3 //Previsao Fluxo Diario
	
	IF MV_PAR02 == 1
		cQuery := "SELECT * FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'ZV' AND SUBSTRING(X5_CHAVE,1,2) = '10' ORDER BY X5_CHAVE"
		tcQuery cQuery New Alias "TMPSX5"
	ELSEIF MV_PAR02 == 2
		cQuery := "SELECT * FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'ZL' AND SUBSTRING(X5_CHAVE,1,2) = '10' ORDER BY X5_CHAVE"
		tcQuery cQuery New Alias "TMPSX5"
	ELSEIF MV_PAR02 == 3
		cNatureza	:= ALLTRIM(TMPSE1->DESCRICAO)
	ELSEIF MV_PAR02 == 4
		cQuery := "SELECT * FROM SX5010 WHERE D_E_L_E_T_ = '' AND X5_TABELA = 'Z8' AND SUBSTRING(X5_CHAVE,1,2) = '01' ORDER BY X5_CHAVE"
		tcQuery cQuery New Alias "TMPSX5"
	ENDIF
	
	DBSelectArea("TMPSX5")
	DBGotop()
	
	While !TMPSX5->(EOF())
		
		aAdd(aNatureza,{TMPSX5->X5_CHAVE,;
		TMPSX5->X5_DESCRI })
		
		DBSelectArea("TMPSX5")
		DBSkip()
		
	Enddo
	
	DBSelectArea("TMPSX5")
	dbCloseArea("TMPSX5")
	
	ASORT(aTitulos,,,{|x,y|x[9]+DTOS(x[3]) < y[9]+DTOS(y[3])})
	
	nNum := 1
	nNum1 := 1
	
	For i:=1 to Len(aNatureza)
		
		IF ALLTRIM(aNatureza[i][1]) <> cNatGer
			
			aAdd(aRegistro,{ALLTRIM(aNatureza[i][1]),aNatureza[i][2],;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,;
			0,0,0,0,0,0,0,0,0,0,0,0})
			
			nNum += 1
			nNum1 += 1
			
		ENDIF
		
		cNatGer := ALLTRIM(aNatureza[i][1])
		
	Next
	
	aAdd(aRegistro,{"VAZIO","--------->",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})
	
	nNum1 += 1
	
	aAdd(aRegistro,{"TOTAL   ","--------->",;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,;
	0,0,0,0,0,0,0,0,0,0,0,0})
	
	
	
	For i:=1 to Len(aTitulos)
		
		IF aTitulos[i][3] >= MV_PAR05 .AND. aTitulos[i][3] <= MV_PAR06
			
			nPos := aScan(aRegistro, { |x| x[1] == ALLTRIM(aTitulos[i][9])})
			nCol := (day(aTitulos[i][3]) + 2)
			
			IF nPos == 0
				nPos := nNum
			ENDIF
			
			IF month(aTitulos[i][3]) == month(mv_par15)
				
				aRegistro[nPos][nCol] 	+= aTitulos[i][6]
				aRegistro[nNum1][nCol] 	+= aTitulos[i][6]
				aRegistro[nPos][34]   	+= aTitulos[i][6]
				aRegistro[nNum1][34]	+= aTitulos[i][6]
				
			ENDIF
			
		ENDIF
		
	Next
	
	//Monta Estrutura da planilha
	
	nUlDia := Day(LastDay(MV_PAR15,0)) //Verifica o ultimo dia
	
	_aStru1:={}//SPCSQL->(DbStruct())
	aadd( _aStru1 , {"CODNAT"       	, "C" , 010 , 00 } )
	aadd( _aStru1 , {"DESCRICAO"		, "C" , 030 , 00 } )
	
	For i := 1  to nUlDia
		nDias += 1
		aadd( _aStru1 ,{"DIA_" + STRZERO(nDias,2)	, "N" , 010 , 02 } )
	Next
	
	aadd( _aStru1 ,{"TOTAL"	, "N" , 012 , 02 } )
	
	_cTemp := CriaTrab(_aStru1,.T.)
	DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)
	
	nDias 	:= 0
	nCol 	:= 2
	
	For i:=1 to Len(aRegistro)
		
		Reclock("TMP1",.T.)
		TMP1->CODNAT		:= aRegistro[i][1]
		TMP1->DESCRICAO		:= aRegistro[i][2]
		TMP1->DIA_01        := aRegistro[i][3]
		TMP1->DIA_02        := aRegistro[i][4]
		TMP1->DIA_03        := aRegistro[i][5]
		TMP1->DIA_04        := aRegistro[i][6]
		TMP1->DIA_05        := aRegistro[i][7]
		TMP1->DIA_06        := aRegistro[i][8]
		TMP1->DIA_07        := aRegistro[i][9]
		TMP1->DIA_08        := aRegistro[i][10]
		TMP1->DIA_09        := aRegistro[i][11]
		TMP1->DIA_10        := aRegistro[i][12]
		TMP1->DIA_11        := aRegistro[i][13]
		TMP1->DIA_12        := aRegistro[i][14]
		TMP1->DIA_13        := aRegistro[i][15]
		TMP1->DIA_14        := aRegistro[i][16]
		TMP1->DIA_15        := aRegistro[i][17]
		TMP1->DIA_16        := aRegistro[i][18]
		TMP1->DIA_17        := aRegistro[i][19]
		TMP1->DIA_18        := aRegistro[i][20]
		TMP1->DIA_19        := aRegistro[i][21]
		TMP1->DIA_20        := aRegistro[i][22]
		TMP1->DIA_21        := aRegistro[i][23]
		TMP1->DIA_22        := aRegistro[i][24]
		TMP1->DIA_23        := aRegistro[i][25]
		TMP1->DIA_24        := aRegistro[i][26]
		TMP1->DIA_25        := aRegistro[i][27]
		TMP1->DIA_26        := aRegistro[i][28]
		TMP1->DIA_27        := aRegistro[i][29]
		TMP1->DIA_28        := aRegistro[i][30]
		IF nUlDia > 28
			TMP1->DIA_29        := aRegistro[i][31]
			IF nUlDia > 29
				TMP1->DIA_30        := aRegistro[i][32]
				IF nUlDia > 30
					TMP1->DIA_31        := aRegistro[i][33]
				END
			END
		END
		TMP1->TOTAL       := aRegistro[i][34]
		MsUnlock()
		
	Next
	
ENDIF

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado."
	DBSelectArea("TMP1")
	DBCloseARea("TMP1")
	Return
EndIf

cArq     := _cTemp+".DBF"

DBSelectArea("TMP1")
DBCloseARea("TMP1")

__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")


oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
oExcelApp:SetVisible(.T.)

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Modelo      	 	","","","mv_ch01","N",01,0,2,"C","","mv_par01","Analitico","","","","","Analitico Dia","","","","","Sintetico Dia","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Natureza    		","","","mv_ch02","N",01,0,2,"C","","mv_par02","Gerencial","","","","","Fluxo","","","","","Natureza","","","","","Cta. SIG","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Natureza  	  	","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"04","Ate Natureza      	","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"05","Do Vencimento 	  	","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Vencimento 	  	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da Emissao     	  	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Emissao    	  	","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Cliente 	  		","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"10","Ate Cliente    		","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"11","Do Titulo  	  		","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Titulo      	","","","mv_ch12","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Mes		   			","","","mv_ch13","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Ano		 			","","","mv_ch14","C",04,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Dia Realiz/Previsao	","","","mv_ch15","D",08,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Filtra Bancos		","","","mv_ch16","C",20,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Filtra Agencia		","","","mv_ch17","C",20,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"18","Filtra Contas		","","","mv_ch18","C",20,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"19","Impri. Previsao    	","","","mv_ch19","N",01,0,2,"C","","mv_par19","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"20","Filtra Conciliados	","","","mv_ch20","N",01,0,2,"C","","mv_par20","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","",""})

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

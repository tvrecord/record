#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPOSPAG    บ Autor ณ Bruno Alves        บ Data ณ 14/01/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Posicao Fornecedor referente ao Contas a Pagar	          บฑฑ
ฑฑ          ฑฑ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function POSPAG()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Pagamento Fornecedor"
Local nLin           := 80

Local Cabec1         := "Prf. Numero   Tp.        Valor    Emissao     Vencimento   Situacao                Vr. Bx.          Saldo         Vr. Pago     Motivo"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Local cTipo		:= "Arquivos Retorno (*.TXT)	|*.TXT |"
Local aCampos
Local cArqTemp
Private _aCab := {}
Private _aMtv := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "POSPAG" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { 	"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 1
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "POSPAG1"
Private cString      := "SE2"
Private cQuery       := ""
Private nCont	    := 0
Private nErros := 0
Private nRecalls := 0
Private cRegistro := ""
Private nVaLiq := 0



ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)



//Imprimir relatorio com dados Financeiros ou de Clientes



cQuery := "SELECT "
cQuery += "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO, "
cQuery += "E2_NATUREZ,E2_FORNECE,E2_LOJA,A2_NOME, "
cQuery += "E2_EMISSAO,E2_VENCREA,E2_VALOR,E2_BAIXA, "
cQuery += "E2_MOVIMEN,E2_BCOPAG,E2_LOTE,E2_SALDO,E2_VALLIQ,E2_IRRF,E2_INSS,E2_ISS,E2_PIS,E2_COFINS,E2_CSLL "
cQuery += "FROM SE2010 "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "SE2010.E2_FORNECE = SA2010.A2_COD AND "
cQuery += "SE2010.E2_LOJA = SA2010.A2_LOJA "
cQuery += "WHERE "
cQuery += "SE2010.E2_FILIAL  = '" + xFilial("SE2") + "' AND "
cQuery += "SE2010.E2_PREFIXO BETWEEN '" + (MV_PAR01) + "' AND '" + (MV_PAR02) + "' AND "
cQuery += "SE2010.E2_NUM     BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery += "SE2010.E2_PARCELA BETWEEN '" + (MV_PAR05) + "' AND '" + (MV_PAR06) + "' AND "
cQuery += "SE2010.E2_VENCREA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' AND "
cQuery += "SE2010.E2_FORNECE = '" + (MV_PAR09) + "' AND "
cQuery += "SE2010.E2_LOJA    = '" + (MV_PAR10) + "' AND "
cQuery += "SE2010.E2_EMISSAO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' AND "
cQuery += "SE2010.D_E_L_E_T_ <> '*' AND "
cQuery += "SA2010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY SE2010.E2_TIPO,SE2010.E2_PREFIXO,SE2010.E2_NUM"

tcQuery cQuery New Alias "TMP"




If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

//Criando os campos que serao criados em uma tabela virtual para buscar os motivos de baixa que se encontra no system/sigaadv.mot
aCampos	:=	{{"MOTBX","C",3,0},{"DESC","C",10,0},{"REGRA","C",4,0}}
cArqTemp	:=	CriaTrab(aCampos)
Use &cArqTemp Alias "MOTBAIX" New

cFile		:=	"SIGAADV.MOT"
nErros 		:=	0
arqhandle	:= fOpen(cFile)

IF arqhandle == -1
	MsgStop("Erro na abertura do arquivo!")
	dbSelectArea("MOTBAIX")
	dbCloseArea("MOTBAIX")
	
	Return
Endif

DbSelectArea("MOTBAIX") // Abre Arquivo Principal de Trabalho

Append From &cFile SDF // Joga o conteudo do arquivo do cFile dentro da tabela ArqRet para tratamento

Dbgotop()

//Adiciona as informacoes buscadas no txt que foram jogadas na tabela virtual MOTBAIX no vetor _aCab

While !eof()
	aAdd(_aCab,{MOTBAIX->MOTBX,;  		    //01.Motivo da baixa - Sigla
	MOTBAIX->DESC,;				//02.Descricao do Motivo da Baixa
	MOTBAIX->REGRA})			//03.Regra do Motivo da Baixa
	
	dbSkip()
End


If nLastKey == 27
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

dbSelectArea("MOTBAIX")
dbCloseArea("MOTBAIX")


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
Local cSituaca 	:= ""
Local nValPg   	:= 0
Local nValBx   	:= 0
Local cMotivo  	:= ""
Local lOk	   	:= .T.
Local nTotVal   := 0
Local nTotSd    := 0
Local nTotValPg := 0
Local nTotValBx := 0

DBSelectArea("TMP")
DBGotop()

If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

//Imprime o codigo e o nome do fornecedor logo apos a impressao do cabecalho
@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin, 000 PSAY "Fornecedor: " + TMP->E2_FORNECE + " - " + TMP->A2_NOME
nLin++
@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

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
	
	//Localiza as movimentacoes bancarias do Titulo a Pagar
	
	DBSelectArea("SE5")
	DBSetOrder(7)
	DBSeek(TMP->E2_FILIAL + TMP->E2_PREFIXO + TMP->E2_NUM + TMP->E2_PARCELA + TMP->E2_TIPO + TMP->E2_FORNECE + TMP->E2_LOJA)
	
	
	If Found()
		
		While !Eof() .and. TMP->E2_PREFIXO == SE5->E5_PREFIXO .AND. TMP->E2_NUM == SE5->E5_NUMERO .AND. TMP->E2_SALDO != TMP->E2_VALOR .AND. TMP->E2_FORNECE == SE5->E5_FORNECE .AND. TMP->E2_PARCELA == SE5->E5_PARCELA 
			
			If EMPTY(SE5->E5_SEQ)
				dbSkip()
				Loop
			EndIf
			
			If SE5->E5_TIPODOC == "VL" 
			nValBx += SE5->E5_VALOR
			EndIf
			     
			
			If SE5->E5_MOTBX == "DEB" .AND. SE5->E5_TIPODOC == "VL"
				nValPg += SE5->E5_VALOR
			EndIf
			
			
			//Adiciona no Vetor somente os Motivo das baixas que foram utilizadas nas movimentacoes bancarias do titulo posicionado
			If Len(_aMtv)  == 0
				aAdd(_aMtv,{SE5->E5_MOTBX})
			ElseIf ASCAN(_aMtv,{|x|x[1] = SE5->E5_MOTBX }) == 0
				aAdd(_aMtv,{SE5->E5_MOTBX})
			EndIf
			
			
			dbSkip()
			
		EndDo
	EndiF
	
	If TMP->E2_SALDO == 0
		cSituaca := "Baixado"
	ElseIf TMP->E2_SALDO != TMP->E2_VALOR
		cSituaca := "Baixado Parc."
	ElseIf TMP->E2_SALDO == TMP->E2_VALOR
		cSituaca := "Em Aberto"
	EndIf
	
	
	//Regra: Sera informado com titulo pago, caso ele seja do Tipo PA ou baixado como Motivo de Baixa DEB - Debico Conta Corrente,
	// como somanda a cima na linha	261
	
	If Alltrim(TMP->E2_TIPO) == "PA"
		nValPg := TMP->E2_VALOR
	EndIF
	
	If lOk == .T.
		nLin += 2// Avanca a linha de impressao
		lOk := .F.
	EndIF
	
	nVaLiq := TMP->(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_PIS+E2_COFINS+E2_CSLL)
	
	@nLin, 000 PSAY TMP->E2_PREFIXO
	@nLin, 005 PSAY TMP->E2_NUM
	@nLin, 014 PSAY TMP->E2_TIPO
	@nLin, 018 PSAY nVaLiq Picture "@E 999,999,999.99"
	@nLin, 034 PSAY STOD(TMP->E2_EMISSAO)
	@nLin, 046 PSAY STOD(TMP->E2_VENCREA)
	@nLin, 059 PSAY cSituaca //Baixado ou em Aberto
	@nLin, 075 PSAY nValBx Picture "@E 999,999,999.99"
	@nLin, 091 PSAY TMP->E2_SALDO Picture "@E 999,999,999.99"
	@nLin, 107 PSAY nValPg Picture "@E 999,999,999.99"
	
	
	//Localiza o Motivo da Baixa e imprime a descricao.Obs: "CMP" nao existe cadastrado no motivo da baixa e sim na SX5 - UNICA QUE NAO ESTA CADASTRADA.
	
	For I := 1 To Len(_aMtv)
		nPos := ASCAN(_aCab,{|x|x[1] = _aMtv[I][1] })
		If nPos == 0 .AND. _aMtv[I][1] == "CMP"
			IIf(Len(_aMtv)!= I,cMotivo += "Compensacao - ",cMotivo += "Compensacao")
		Else
			IIf(Len(_aMtv)!= I,cMotivo += Alltrim(_aCab[nPos][2]) + " - ",cMotivo += Alltrim(_aCab[nPos][2]))
		Endif
		
	Next
	
	@nLin, 126 PSAY cMotivo
	
	
	nLin := nLin + 1 // Avanca a linha de impressao
	//Soma os valores para imprimir a totalizacao de cada um.
	nTotVal   += nVaLiq
	nTotSd    += TMP->E2_SALDO
	nTotValBx += nValBx
	nTotValPg += nValPg
	
	
	
	
	DBSelectArea("TMP")
	nValBx   := 0
	nValPg   := 0
	_aMtv    := {}
	cMotivo  := ""
	cSituaca := ""
	
	dbskip()
	
	
	
ENDDO

@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin, 000 PSAY "T O T A L --->"
@nLin, 018 PSAY nTotVal   Picture "@E 999,999,999.99"
@nLin, 075 PSAY nTotValBx Picture "@E 999,999,999.99"
@nLin, 091 PSAY nTotSd    Picture "@E 999,999,999.99"
@nLin, 107 PSAY nTotValPg Picture "@E 999,999,999.99"
nLin++
@nLin, 000 PSAY "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"


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

Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do  Prefixo		?","","","mv_ch01","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Preifxo		?","","","mv_ch02","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do  Numero 		?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"04","Ate Numero 		?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SE2"})
AADD(aRegs,{cPerg,"05","Da  Parcela 	?","","","mv_ch05","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Parcela 	?","","","mv_ch06","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Do  Vencimento	?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Vencimento	?","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Fornecedor 		?","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA2"})
AADD(aRegs,{cPerg,"10","Loja	 		?","","","mv_ch10","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Da Emissao 		?","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Emissao 	?","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})

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



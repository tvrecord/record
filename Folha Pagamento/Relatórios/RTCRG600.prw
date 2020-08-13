#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#Include "FONT.CH"
#Include "COLORS.CH"
#Include "winapi.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRG600 บ Autor ณ Paulo Cesar P. Schwind ณ Data :15/08/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo Nominal do INSS Retido Folha em Ordem de Nome.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Microsiga                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCRG600()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Rela็ใo Nominal do INSS Retido Folha"
Local cPict        := ""
Private titulo       := "Rela็ใo Nominal do INSS Retido Folha"
Private nLin         := 80

Private imprime      := .T.
Private aOrd := {}

Private Cabec1  := " Fil C. Custo   Matr.   Nome Funcionario                        Salario Contr.   Salario Contr.   Salario Contr.            I.N.S.S"
Private Cabec2  := "                                                                Ate  o  Limite    Acima  Limite        T o t a l        R e t i d o"
// 99  999999999  999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999,999,99   99,999,999,99     99,999,999,99     99,999,999,99
// 2   6          17     24                                        66              82                100               118

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "RTCRG600"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RTCRG600"
Private cCateg       := ''
Private cSituaca     := ''
Private cString      := "SRD
Private cPerg        :=	'RTC60X'

ValidPerg()
Pergunte(cPerg,.T.)
if LastKey()=27
	Return
Endif

If MV_PAR12 = 1
	titulo += " - Ordem : Nome "
ElseIf MV_PAR12 = 2
	titulo += " - Ordem : Centro de Custo "
ElseIf MV_PAR12 = 3
	titulo += " - Ordem : Matricula "
Endif

dbSelectArea("SRD")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  15/08/07   บฑฑ
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

Private nOrdem
Private _nTotSAteP    := 0  // TOTAL SALARIO ATE LIMITE PARCIAL
Private _nTotSAteG    := 0  // TOTAL SALARIO ATE LIMITE GERAL

Private _nTotSAciP    := 0  // TOTAL SALARIO ACIMA LIMITE PARCIAL
Private _nTotSAciG    := 0  // TOTAL SALARIO ACIMA LIMITE GERAL

Private _nTotSConP    := 0  // TOTAL SALARIO CONTRIBUIDO PARCIAL
Private _nTotSConG    := 0  // TOTAL SALARIO CONTRIBUIDO GERAL

Private _nInssRetP    := 0  // TOTAL INSS RETIDO PARCIAL
Private _nInssRetG    := 0  // TOTAL INSS RETIDO PARCIAL

Private _cCusto    := ''
Private _cMatric   := ''
Private _cFilial   := ''

// VERIFICA SE O MES SOLICITADO == FOLHA
IF GETMV("MV_FOLMES") == SUBSTR(MV_PAR11,3,4)+SUBSTR(MV_PAR11,1,2)
	// SELECIONA OS DADOS DO SRC
	Selec_SRC()
	ImprimeSRC()
ELSE
	// SELECIONA OS DADOS DO SRD.
	Selec_SRD()
	ImprimeSRD()
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

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRG600 บ Autor ณ Paulo Cesar P. Schwind ณ Data :15/08/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo Nominal do INSS Retido Folha em Ordem de Nome.     บฑฑ
ฑฑบ          ณ ImprimeSRC                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Microsiga                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImprimeSRC()
_nRegs := 0
dbSelectArea("TBSRC")
dbGoTop()
TBSRC->(dbEval({|| _nRegs++}))

//VERIFICANDO SE EXISTEM REGISTROS A SEREM IMPRESSOS
IF _nRegs = 0
	Aviso("Aviso", "Sem registros para a Emissao do Relatorio [SRC]!", {"Ok"})
EndIf

SetRegua(_nRegs)
dbGoTop()

While ! TBSRC->(EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 66 //55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin,002 PSAY TBSRC->RC_FILIAL
	@ nLin,006 PSAY TBSRC->RC_CC
	@ nLin,017 PSAY TBSRC->RC_MAT
	@ nLin,024 PSAY TBSRC->RA_NOME
	
	// GUARDA O CENTRO DE CUSTO PARA CHECAR SE O PROXIMO Eh DIFERENTE
	_cCusto := TBSRC->RC_CC
	_cFilial:= TBSRD->RD_FILIAL
	
	// GUARDA O CODIGO DA MATRICULA
	_cMatric   := TBSRC->RC_MAT
	
	_nCol1 := _nCol2 := _nCol3 := _nSalContr := 0
	
	// LOOP NA TABELA PARA A MESMA MATRICULA
	While ! TBSRC->(EOF()) .AND. TBSRC->RC_MAT == _cMatric
		IF TBSRC->COLUNA == '1'
			_nCol1	  += TBSRD->RC_VALOR
			_nSalContr += TBSRC->RC_VALOR
			_nTotSAteP += TBSRC->RC_VALOR
			_nTotSAteG += TBSRC->RC_VALOR
		ELSEIF TBSRD->COLUNA == '2'
			_nCol2	  += TBSRD->RC_VALOR
			_nSalContr += TBSRC->RC_VALOR
			_nTotSAciP += TBSRC->RC_VALOR
			_nTotSAciG += TBSRC->RC_VALOR
		ELSEIF TBSRD->COLUNA == '3'
			_nCol3	  += TBSRD->RC_VALOR
			_nInssRetP += TBSRC->RC_VALOR
			_nInssRetG += TBSRC->RC_VALOR
		ENDIF
		TBSRC->(dbSkip())
	End
	
	//Imprime salarios do funcionแrio
	@ nLin,066 PSAY _nCol1 PICTURE "@EZ 99,999,999.99" //Salario ate o limite
	@ nLin,082 PSAY _nCol2 PICTURE "@EZ 99,999,999.99" //Salario acima do limite
	@ nLin,118 PSAY _nCol3 PICTURE "@EZ 99,999,999.99" //Salario total
	
	_nTotSConP += _nSalContr
	_nTotSConG += _nTotSConP
	
	@ nLin,100 PSAY _nSalContr PICTURE "@EZ 99,999,999.99"
	nLin ++
	
	if MV_PAR12 = 2 // ORDEM DE CENTRO DE CUSTO
		if _cCusto <> TBSRC->RD_CC
			@ nLin,002 PSAY REPLICATE("-",130)
			nLin ++
			@ nLin,002 PSAY "Total C. Custo : " +POSICIONE("CTT",1,xFilial("CTT")+TBSRD->RD_CC ,"CTT_DESC01")
			@ nLin,066 PSAY _nTotSAteP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
			@ nLin,082 PSAY _nTotSAciP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ACIMA LIMITE PARCIAL
			@ nLin,100 PSAY _nTotSConP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
			@ nLin,118 PSAY _nInssRetP PICTURE "@EZ 99,999,999.99"
			nLin ++
			@ nLin,002 PSAY REPLICATE("-",130)
			nLin ++
			
			_nTotSAteP := 0  // ZERA O TOTAL SALARIO ATE LIMITE PARCIAL
			_nTotSAciP := 0  // ZERA O TOTAL SALARIO ACIMA LIMITE PARCIAL
			_nTotSConP := 0  // ZERA O TOTAL SALARIO CONTRIBUIDO PARCIAL
			_nInssRetP := 0  // ZERA O TOTAL INSS RETIDO PARCIAL
			
			// SE CENTRO DE CUSTO EM OUTRA PAGINA
			if MV_PAR10 = 1
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
		Endif
	Endif
	
	IF EOF()
		@ nLin,002 PSAY REPLICATE("-",130)
		nLin ++
		@ nLin,002 PSAY "Total Empresa : " +SM0->M0_CODIGO + " - "+SM0->M0_NOMECOM
		@ nLin,066 PSAY _nTotSAteG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
		@ nLin,082 PSAY _nTotSAciG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ACIMA LIMITE PARCIAL
		@ nLin,100 PSAY _nTotSConG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
		@ nLin,118 PSAY _nInssRetG PICTURE "@EZ 99,999,999.99"
		nLin ++
		@ nLin,002 PSAY REPLICATE("-",130)
		nLin ++
	ENDIF
	
EndDo

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCRG600 บ Autor ณ Paulo Cesar P. Schwind ณ Data :15/08/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo Nominal do INSS Retido Folha em Ordem de Nome.     บฑฑ
ฑฑบ          ณ ImprimeSRD                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - Microsiga                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImprimeSRD()

Local _aLinha	:= {}
Local _nLinCol1 := _nLinCol2 := _nLinCol3 := _nCont := 0

_nRegs := 0

dbSelectArea("TBSRD")
dbGoTop()
TBSRD->(dbEval({|| _nRegs++}))

//VERIFICANDO SE EXISTEM REGISTROS A SEREM IMPRESSOS
IF _nRegs = 0
	Aviso("Aviso", "Sem registros para a Emissao do Relatorio [SRD]!", {"Ok"})
EndIf

SetRegua(_nRegs)
dbGoTop()

X:=1
While !TBSRD->(EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 66 //55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	IF TBSRD->RD_MAT == "000248"
		X:=1
	ENDIF
	
	
	@ nLin,002 PSAY TBSRD->RD_FILIAL
	@ nLin,006 PSAY TBSRD->RD_CC
	@ nLin,017 PSAY TBSRD->RD_MAT
	@ nLin,024 PSAY TBSRD->RA_NOME
	
	// GUARDA O CENTRO DE CUSTO PARA CHECAR SE O PROXIMO Eh DIFERENTE
	_cCusto := TBSRD->RD_CC
	
	// GUARDA O CODIGO DA MATRICULA
	_cMatric   := TBSRD->RD_MAT
	
	_nCol1 := _nCol2 := _nCol3 := _nSalContr := 0
	
	// LOOP NA TABELA PARA A MESMA MATRICULA
	While ! TBSRD->(EOF()) .AND. TBSRD->RD_MAT == _cMatric
		IF TBSRD->COLUNA == '1' 				//Verbas 721 e 723
			_nCol1	  += TBSRD->RD_VALOR
			_nSalContr += TBSRD->RD_VALOR
			_nTotSAteP += TBSRD->RD_VALOR
			_nTotSAteG += TBSRD->RD_VALOR
		ELSEIF TBSRD->COLUNA == '2'        //Verbas 722 e 724
			_nCol2	  += TBSRD->RD_VALOR
			_nSalContr += TBSRD->RD_VALOR
			_nTotSAciP += TBSRD->RD_VALOR
			_nTotSAciG += TBSRD->RD_VALOR
		ELSEIF TBSRD->COLUNA == '3'        //Verbas 401 e 402
			_nCol3	  += TBSRD->RD_VALOR
			_nInssRetP += TBSRD->RD_VALOR
			_nInssRetG += TBSRD->RD_VALOR
		ENDIF
		TBSRD->(dbSkip())
	EndDo
	
	//Imprime salarios do funcionแrio
	@ nLin,066 PSAY _nCol1 PICTURE "@EZ 99,999,999.99" //Salario ate o limite
	@ nLin,082 PSAY _nCol2 PICTURE "@EZ 99,999,999.99" //Salario acima do limite
	@ nLin,118 PSAY _nCol3 PICTURE "@EZ 99,999,999.99" //Salario total
	
	_nTotSConP += _nSalContr
	_nTotSConG += _nTotSConP
	
	@ nLin,100 PSAY _nSalContr PICTURE "@EZ 99,999,999.99"
	nLin ++
	
	if MV_PAR12 = 2 // ORDEM DE CENTRO DE CUSTO
		if _cCusto <> TBSRD->RD_CC
			@ nLin,002 PSAY REPLICATE("-",130)
			nLin ++
			@ nLin,002 PSAY "Total C. Custo : " +POSICIONE("CTT",1,xFilial("CTT")+TBSRD->RD_CC,"CTT_DESC01")
			@ nLin,066 PSAY _nTotSAteP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
			@ nLin,082 PSAY _nTotSAciP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ACIMA LIMITE PARCIAL
			@ nLin,100 PSAY _nTotSConP PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
			@ nLin,118 PSAY _nInssRetP PICTURE "@EZ 99,999,999.99"
			nLin ++
			@ nLin,002 PSAY REPLICATE("-",130)
			nLin ++
			
			_nTotSAteP := 0  // ZERA O TOTAL SALARIO ATE LIMITE PARCIAL
			_nTotSAciP := 0  // ZERA O TOTAL SALARIO ACIMA LIMITE PARCIAL
			_nTotSConP := 0  // ZERA O TOTAL SALARIO CONTRIBUIDO PARCIAL
			_nInssRetP := 0  // ZERA O TOTAL INSS RETIDO PARCIAL
			
			// SE CENTRO DE CUSTO EM OUTRA PAGINA
			if MV_PAR10 = 1
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
		Endif
	Endif
	
	IF EOF()
		@ nLin,002 PSAY REPLICATE("-",130)
		nLin ++
		@ nLin,002 PSAY "Total Empresa : " +SM0->M0_CODIGO+" - "+SM0->M0_NOMECOM
		@ nLin,066 PSAY _nTotSAteG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
		@ nLin,082 PSAY _nTotSAciG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ACIMA LIMITE PARCIAL
		@ nLin,100 PSAY _nTotSConG PICTURE "@EZ 99,999,999.99"   //TOTAL SALARIO ATE LIMITE PARCIAL
		@ nLin,118 PSAY _nInssRetG PICTURE "@EZ 99,999,999.99"   //TOTAL INSS RETIDO
		nLin ++
		@ nLin,002 PSAY REPLICATE("-",130)
		nLin ++
	ENDIF
	
EndDo

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaPerg  บAutor  ณPaulo Schwind       บ Data ณ  09/23/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaPerg()
Local _aArea := GetArea()
Local _cPerg := cPerg
Local _aRegs:={}
Local _nI := 0
Local _nJ := 0

dbSelectArea('SX1')
dbSetOrder(1)
Aadd(_aRegs,{_cPerg,"01","Filial de                     ","                              ","                              ","mv_ch1","C",02,0,0,"G","                                                            ","mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"02","Filial Ate                    ","                              ","                              ","mv_ch2","C",02,0,0,"G","                                                            ","mv_par02       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"03","Dt. Carregamento de           ","                              ","                              ","mv_ch3","D",08,0,0,"G","                                                            ","mv_par13       ","               ","               ","               ","'01/04/04'                                                  ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"04","Dt. Carregamento Ate          ","                              ","                              ","mv_ch4","D",08,0,0,"G","                                                            ","mv_par13       ","               ","               ","               ","'01/04/04'                                                  ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"05","UF de                         ","                              ","                              ","mv_ch5","C",02,0,0,"G","                                                            ","mv_par05       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"06","UF Ate                        ","                              ","                              ","mv_ch6","C",02,0,0,"G","                                                            ","mv_par06       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"07","Sucursal                      ","                              ","                              ","mv_ch7","C",04,0,0,"G","                                                            ","mv_par07       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"08","Apolice                       ","                              ","                              ","mv_ch8","C",15,0,0,"G","                                                            ","mv_par08       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"09","Segurado                      ","                              ","                              ","mv_ch9","C",40,0,0,"G","                                                            ","mv_par09       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})

For _nI:=1 to Len(_aRegs)
	If ! dbSeek(_cPerg+_aRegs[_nI,2])
		RecLock('SX1',.T.)
		For _nJ:=1 to FCount()
			If _nJ <= Len(_aRegs[_nI])
				FieldPut(_nJ,_aRegs[_nI,_nJ])
			Endif
		Next _nJ
		MsUnlock()
	Endif
Next _nI
RestArea(_aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRRDPS01PC บAutor  ณMicrosiga           บ Data ณ  09/24/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Selec_SRD()
cSelect :=  " SRD.RD_FILIAL, SRD.RD_CC, SRD.RD_MAT, SRA.RA_NOME, SRD.RD_VALOR,SRD.RD_PD, SRD.RD_DATPGT, " + ;
				" CASE SRD.RD_PD " + ;
				"      WHEN '721' THEN '1' " + ;
				"      WHEN '723' THEN '1' " + ;
				"      WHEN '722' THEN '2' " + ;
				"      WHEN '724' THEN '2' " + ;
				"      WHEN '401' THEN '3' " + ;
				"      WHEN '402' THEN '3' " + ;
				" END AS COLUNA "

cFrom  := RetSQLName("SRD") + " SRD, " + RetSQLName("SRA") + " SRA "

cWhere := 	" SRD.D_E_L_E_T_ <> '*' AND " + ;
				" SRA.D_E_L_E_T_ <> '*' AND  " + ;
				" SRD.RD_MAT = SRA.RA_MAT AND " + ;
				" SRD.RD_PD IN ('721','722','401','723','724','402')   AND " + ;
				" SRD.RD_FILIAL >= '" + MV_PAR01 +"' AND " + ;
				" SRD.RD_FILIAL <= '" + MV_PAR02 +"' AND " + ;
				" SRD.RD_MAT    >= '" + MV_PAR05 +"' AND " + ;
				" SRD.RD_MAT    <= '" + MV_PAR06 +"' AND " + ;
				" SRD.RD_CC     >= '" + MV_PAR03 +"' AND " + ;
				" SRD.RD_CC     <= '" + MV_PAR04 +"' AND " + ;
				" SRD.RD_DATARQ  = '" + SUBSTR(MV_PAR11,3,4)+SUBSTR(MV_PAR11,1,2) +"' "

if ! Empty(cSituaca)
	cWhere += "AND SRA.RA_SITFOLH IN ("+cSituaca+")"
endif
if ! Empty(cCateg)
	cWhere += "AND SRA.RA_CATFUNC IN ("+cCateg+")"
endif

if MV_PAR12 = 1
	cOrder := " SRD.RD_FILIAL, SRA.RA_NOME, COLUNA "
Elseif MV_PAR12 = 2
	cOrder := " SRD.RD_FILIAL, SRD.RD_CC, SRA.RA_NOME, COLUNA "
Elseif MV_PAR12 = 3
	cOrder := " SRD.RD_FILIAL, SRD.RD_MAT, COLUNA "
Endif

cQuery:="SELECT "+cSelect+" FROM "+cFrom+" WHERE "+cWhere+" ORDER BY "+cOrder

If Select("TBSRD") > 0
	DbSelectArea("TBSRD")
	TBSRD->(DbCloseArea())
EndIF

//MemoWrite("c:\TBSRD.SQL",cQuery)

TCQUERY cQuery NEW ALIAS "TBSRD"

TCSetField("TBSRD","RD_VALOR" ,"N",12,2)
//TCSetField("TBSRD","RD_DATPGT","C",8,0)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRRDPS01PC บAutor  ณMicrosiga           บ Data ณ  09/24/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Selec_SRC()
cSelect :=  " SRC.RC_FILIAL, SRC.RC_CC, SRC.RC_MAT, SRA.RA_NOME, SRC.RC_VALOR,SRC.RC_PD, SRC.RC_DATA, " + ;
				" CASE SRC.RC_PD " + ;
				"      WHEN '721' THEN '1' " + ;
				"      WHEN '723' THEN '1' " + ;
				"      WHEN '722' THEN '2' " + ;
				"      WHEN '724' THEN '2' " + ;
				"      WHEN '401' THEN '3' " + ;
				"      WHEN '402' THEN '3' " + ;
				" END AS COLUNA "

cFrom  := RetSQLName("SRC") + " SRC, " + RetSQLName("SRA") + " SRA "

cWhere := 	" SRC.D_E_L_E_T_ <> '*' AND " + ;
				" SRA.D_E_L_E_T_ <> '*' AND  " + ;
				" SRC.RC_MAT = SRA.RA_MAT AND " + ;
				" SRC.RC_PD IN ('721','722','401')   AND " + ;
				" SRC.RC_FILIAL >= '" + MV_PAR01 +"' AND " + ;
				" SRC.RC_FILIAL <= '" + MV_PAR02 +"' AND " + ;
				" SRC.RC_MAT    >= '" + MV_PAR05 +"' AND " + ;
				" SRC.RC_MAT    <= '" + MV_PAR06 +"' AND " + ;
				" SRC.RC_CC     >= '" + MV_PAR03 +"' AND " + ;
				" SRC.RC_CC     <= '" + MV_PAR04 +"' AND " + ;
				" SUBSTRING(SRC.RC_DATA,1,6) >= '" + SUBSTR(MV_PAR11,3,4)+SUBSTR(MV_PAR11,1,2) +"' AND " + ;
				" SUBSTRING(SRC.RC_DATA,1,6) <= '" + SUBSTR(MV_PAR11,3,4)+SUBSTR(MV_PAR11,1,2) +"' "

if ! Empty(cSituaca)
	cWhere += "AND SRA.RA_SITFOLH IN ("+cSituaca+")"
endif
if ! Empty(cCateg)
	cWhere += "AND SRA.RA_CATFUNC IN ("+cCateg+")"
endif

if MV_PAR12 = 1
	cOrder := " SRC.RC_FILIAL, SRA.RA_NOME, COLUNA "
Elseif MV_PAR12 = 2
	cOrder := " SRC.RC_FILIAL, SRC.RC_CC, SRA.RA_NOME, COLUNA "
Elseif MV_PAR12 = 3
	cOrder := " SRC.RC_FILIAL, SRC.RC_MAT, COLUNA "
Endif

cQuery:="SELECT "+cSelect+" FROM "+cFrom+" WHERE "+cWhere+" ORDER BY "+cOrder

If Select("TBSRC") > 0
	DbSelectArea("TBSRC")
	TBSRD->(DbCloseArea())
EndIF

TCQUERY cQuery NEW ALIAS "TBSRC"

TCSetField("TBSRC","RC_VALOR" ,"N",12,2)
TCSetField("TBSRC","RC_DATA","C",8,0)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaPerg  บAutor  ณPaulo Schwind       บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local _aArea := GetArea()
Local _cPerg := cPerg
Local _aRegs:={}
Local _nI := 0
Local _nJ := 0

dbSelectArea('SX1')
dbSetOrder(1)
Aadd(_aRegs,{_cPerg,"01","Filial de                     ","                              ","                              ","mv_ch1","C",02,0,0,"G","                                                            ","mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SM0","S","   ","          "})
Aadd(_aRegs,{_cPerg,"02","Filial Ate                    ","                              ","                              ","mv_ch2","C",02,0,0,"G","                                                            ","mv_par02       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SM0","S","   ","          "})
Aadd(_aRegs,{_cPerg,"03","Centro de Custo de            ","                              ","                              ","mv_ch3","C",09,0,0,"G","                                                            ","mv_par03       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","CTT","S","   ","          "})
Aadd(_aRegs,{_cPerg,"04","Centro de Custo Ate           ","                              ","                              ","mv_ch4","C",09,0,0,"G","                                                            ","mv_par04       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","CTT","S","   ","          "})
Aadd(_aRegs,{_cPerg,"05","Matricula de                  ","                              ","                              ","mv_ch5","C",06,0,0,"G","                                                            ","mv_par05       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SRA","S","   ","          "})
Aadd(_aRegs,{_cPerg,"06","Matricula Ate                 ","                              ","                              ","mv_ch6","C",06,0,0,"G","                                                            ","mv_par06       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","SRA","S","   ","          "})
Aadd(_aRegs,{_cPerg,"07","Rela็ใo de I.N.S.S            ","                              ","                              ","mv_ch7","C",01,0,1,"C","                                                            ","mv_par07       ","Folha          ","               ","               ","                                                            ","               ","13บ Salario    ","               ","               ","                                                            ","               ","Totalizado     ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"08","Situa็๕es                     ","                              ","                              ","mv_ch8","C",10,0,0,"G","U_F_SIT                                                     ","mv_par08       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"09","Categorias                    ","                              ","                              ","mv_ch9","C",10,0,0,"G","U_F_CAT                                                     ","mv_par09       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"10","Centro de Custo em outra pag. ","                              ","                              ","mv_chA","C",01,0,1,"C","                                                            ","mv_par10       ","Sim            ","               ","               ","                                                            ","               ","Nao            ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"11","Mes / Ano Competencia         ","                              ","                              ","mv_chB","C",06,0,0,"G","                                                            ","mv_par11       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
Aadd(_aRegs,{_cPerg,"12","Ordem do Relatorio            ","                              ","                              ","mv_chC","C",01,0,1,"C","                                                            ","mv_par12       ","Nome           ","               ","               ","                                                            ","               ","Centro de Custo","               ","               ","                                                            ","               ","Matricula      ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})

For _nI:=1 to Len(_aRegs)
	If ! dbSeek(_cPerg+_aRegs[_nI,2])
		RecLock('SX1',.T.)
		For _nJ:=1 to FCount()
			If _nJ <= Len(_aRegs[_nI])
				FieldPut(_nJ,_aRegs[_nI,_nJ])
			Endif
		Next _nJ
		MsUnlock()
	Endif
Next _nI
RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_SIT     บAutor  ณPaulo Schwind        บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Selecionar as Situacoes do funcionario.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function f_SIT(l1Elem,lTipoRet)
Local aStru   := {}
Local nOpca := 0
Local cArq
Local oDlg1
Local MvPar
Local cRetorna := .F.
Local lInverte := .T.
Local aCampos	:= {}
Local _sAlias	:=	Alias()
Private cMarca := GetMark()
Private oMark

MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

//Cria Arq TRB
aAdd(aStru,{"TRB_COD" ,"C",07,0})
aAdd(aStru,{"TRB_DESC","C",30,0})
aAdd(aStru,{"TRB_OK"  ,"C",02,0})

cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,"TRB",.T.)
cInd := CriaTrab(NIL,.F.)
//Gera as opcoes
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"31")
While SX5->X5_TABELA = "31" .And. !Eof()
	DBSELECTAREA("TRB")
	RECLOCK("TRB",.T.)
	TRB->TRB_OK   := '  '
	TRB->TRB_COD  := Alltrim(SX5->X5_CHAVE)
	TRB->TRB_DESC := SX5->X5_DESCRI
	MSUNLOCK()
	SX5->(DbSkip())
enddo
dbSelectArea("TRB")
TRB->( dbGoTop() )
aAdd( aCampos, { 'TRB_OK'	,, '  '		          , '@S02' } )
aAdd( aCampos, { 'TRB_COD'	,, 'Codigo'		       , '@S07' } )
aAdd( aCampos, { 'TRB_DESC',, 'Tipo do Titulo'	 , '@S30' } )
DEFINE MSDIALOG oDlg1 TITLE "Selecione os Tipos de Titulos " From 9,0 To 28,80 OF oMainWnd

oMark:=MsSelect():New("TRB","TRB_OK",,aCampos,@lInverte,@cMarca,{12,1,143,315})

oMark:oBrowse:lColDrag := .F.
oMark:oBrowse:lhasMark = .F.
oMark:oBrowse:lCanAllmark := .F.

//oMark:oBrowse:Refresh()

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT RTCR600Bar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})
cRetorna:=''
cVirg:=''
if nOpca=1
	TRB->( dbGoTop() )
	do while !TRB->(eof())
		if TRB->TRB_OK=cMarca
			cRetorna+=cVirg+"'"+TRB->TRB_COD+"'"
			cVirg:=','
		endif
		TRB->(dbskip())
	enddo
endif
TRB->( dbCloseArea() )
fErase(cArq+OrdBagExt())

cSituaca := cRetorna			// Devolve Resultado
&MvRet :='Selecao'
dbSelectArea(_sAlias)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_CAT     บAutor  ณPaulo Schwind        บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Selecionar as Categorias.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function f_CAT(l1Elem,lTipoRet)
Local aStru   := {}
Local nOpca := 0
Local cArq
Local oDlg1
Local MvPar
Local cRetorna := .F.
Local lInverte := .T.
Local aCampos	:= {}
Local _sAlias	:=	Alias()
Private cMarca := GetMark()
Private oMark

MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

//Cria Arq TRB
aAdd(aStru,{"TRB_COD" ,"C",07,0})
aAdd(aStru,{"TRB_DESC","C",30,0})
aAdd(aStru,{"TRB_OK"  ,"C",02,0})

cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,"TRB",.T.)
cInd := CriaTrab(NIL,.F.)
//Gera as opcoes
dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"28")
While SX5->X5_TABELA = "28" .And. !Eof()
	DBSELECTAREA("TRB")
	RECLOCK("TRB",.T.)
	TRB->TRB_OK   := '  '
	TRB->TRB_COD  := Alltrim(SX5->X5_CHAVE)
	TRB->TRB_DESC := SX5->X5_DESCRI
	MSUNLOCK()
	SX5->(DbSkip())
enddo
dbSelectArea("TRB")
TRB->( dbGoTop() )
aAdd( aCampos, { 'TRB_OK'	,, '  '		          , '@S02' } )
aAdd( aCampos, { 'TRB_COD'	,, 'Codigo'		       , '@S07' } )
aAdd( aCampos, { 'TRB_DESC',, 'Tipo do Titulo'	 , '@S30' } )
DEFINE MSDIALOG oDlg1 TITLE "Selecione os Tipos de Titulos " From 9,0 To 28,80 OF oMainWnd

oMark:=MsSelect():New("TRB","TRB_OK",,aCampos,@lInverte,@cMarca,{12,1,143,315})

oMark:oBrowse:lColDrag := .F.
oMark:oBrowse:lhasMark = .F.
oMark:oBrowse:lCanAllmark := .F.

//oMark:oBrowse:Refresh()

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT RTCR600Bar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})
cRetorna:=''
cVirg:=''
if nOpca=1
	TRB->( dbGoTop() )
	do while !TRB->(eof())
		if TRB->TRB_OK=cMarca
			cRetorna+=cVirg+"'"+TRB->TRB_COD+"'"
			cVirg:=','
		endif
		TRB->(dbskip())
	enddo
endif
TRB->( dbCloseArea() )
fErase(cArq+OrdBagExt())

cCateg := cRetorna			// Devolve Resultado
&MvRet :='Selecao'
dbSelectArea(_sAlias)
Return


Static Function RTCR600Bar(oDlg,bOk,bCancel)
Local oBar, bSet15, bSet24, lOk
Local lVolta :=.f.
Define BUTTONBAR oBar Size 25,25 3D Top Of oDlg
oBar:nGroups += 6
DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok"
SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION ( lLoop:=.f.,Eval(bCancel),ButtonOff(bSet15,bSet24,.T.)) TOOLTIP "Cancelar"
SetKEY(24,oBtCan:bAction)
oDlg:bSet15 := oBtOk:bAction
oDlg:bSet24 := oBtCan:bAction
oBar:bRClicked := {|| AllwaysTrue()}
Return nil

#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MAPACOT   � Autor � Fabricio Cistolo   � Data �  09/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Mapa de Cotacao Especifico para Rede Record Brasilia       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Rede Record Brasilia                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MAPACOT()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local imprime        := .T.
Local aOrd           := {}
Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2       := "de acordo com os parametros informados pelo usuario."
Private cDesc3       := "MAPA DE COTACOES"
Private cPict        := ""
Private titulo       := "MAPA DE COTACOES"
Private Cabec1       := ""
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MAPACOT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MAPACOT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "MAPACO    "
Private nLin         := 80

Private cString := "SC8"

Private _xForCod  := {}
Private _xForNom  := {}
Private _xForTel  := {}
Private _xContato := {}
Private _xPrazo   := {}
Private _xCond    := {}
Private _xDescri  := {}
Private _xNumPed  := {}
Private _xCod     := {}
Private _xDesc	  := {}
Private _xUn	  := {}
Private _xValor   := {}
Private _xPreco	  := {}
Private _xQuant   := {}
Private _xVal     := {}
Private aVlTot    := {}


Pergunte(cPerg,.F.)

//dbSelectArea("SC8")
//dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������



wnrel := SetPrint(cString,NomeProg,cperg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)


cabec1 := "                                                                        FONECEDOR 1                      FORNECEDOR 2                     FORNECEDOR 3                     FORNECEDOR 4                     FORNECEDOR 5     "
cabec2 := "CODIGO    DESCRICAO DOS MATERIAIS         UN     QUANT             PRECO            TOTAL           PRECO            TOTAL           PRECO            TOTAL           PRECO            TOTAL           PRECO           TOTAL "
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22
// XXXXXXX@@@JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ@@@MM@@@999999@@@@@99.999.999.99@@@999.999.999.99@@@99.999.999.99@@@999.999.999.99@@@99.999.999.99@@@999.999.999.99@@@99.999.999.99@@@999.999.999.99@@@99.999.999.99@@@999.999.999.99
//                                        DDDDDDDDDDDDDDDDDDDDDDDDD@@@1111111111111111111111@@@@@@@@@@@2222222222222222222222@@@@@@@@@@@3333333333333333333333@@@@@@@@@@@4444444444444444444444@@@@@@@@@@@5555555555555555555555

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  14/07/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local  _cCodPro  := ""
Local  _cCotacao := ""
Local  _nTotFn   := 0

dbSelectArea("SC8")
dbSetOrder(1)
dbSeek(xFilial("SC8")+MV_PAR01,.T.)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())
_cCodPro :=SC8->C8_PRODUTO
_cCoForn :=SC8->C8_FORNECE
_Mult:= .F.

While !EOF() .and. SC8->C8_NUM == MV_PAR01
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//Armazena Fornecedores
	
	If ASCAN(_xForCod,SC8->C8_FORNECE) == 0
		AADD(_xForCod,SC8->C8_FORNECE)
		AADD(_xForNom,Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE,"A2_NOME"))
		AADD(_xForTel,Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE,"A2_TEL"))
		AADD(_xContato,SC8->C8_CONTATO)
		AADD(_xPrazo,SC8->C8_VALIDA)
		AADD(_xCond,SC8->C8_COND)
		AADD(_xDescri,Posicione("SE4",1,xFilial("SE4")+SC8->C8_COND,"E4_DESCRI"))
		AADD(_xNumPed,SC8->C8_NUMPED)
	Endif
	
	If ASCAN(_xCod,SC8->C8_PRODUTO) == 0
		AADD(_xCod,SC8->C8_PRODUTO)
		AADD(_xDesc,Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_DESC"))
		AADD(_xUn,SC8->C8_UM)
		AADD(_xQuant,SC8->C8_QUANT)
	Endif
	
	If SC8->C8_FORNECE == _cCoForn
		_nTotFn:= _nTotFn+(SC8->C8_QUANT * SC8->C8_PRECO)
	Else
		AADD(aVLTot,{_cCoForn,_nTotFn})
		_nTotFn:= (SC8->C8_QUANT * SC8->C8_PRECO)
	Endif
	
	IF SC8->C8_PRODUTO == _cCodPro
		AADD(_xPreco,SC8->C8_PRECO)
		AADD(_xVal,_xPreco)
		_Mult:= .T.
	Else
		AADD(_xVal,_xPreco)
		_xPreco:={}
		AADD(_xPreco,SC8->C8_PRECO)
		_Mult:= .T.
	Endif
	
	_cCodPro :=SC8->C8_PRODUTO
	_cCoForn :=SC8->C8_FORNECE
	
	
	dbSkip()
	
	If SC8->C8_NUM == MV_PAR01
		AADD(_xVal,_xPreco)
		_Mult:= .T.
	Endif
	
	
EndDo
AADD(aVLTot,{_cCoForn,_nTotFn})
ImpCab()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �IMPCAB    � Autor � Rogerio Ferreira   � Data �  21/07/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Imprime o Cabecalho com os Fornecedores                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Earth Tech Brasil                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ImpCab

Local _nQtdFor := Len(_xForCod)
Local _lCab    := .T.
Local _nColCab := 0

If _nQtdFor > 5
	_nQtdFor := 5
Endif

If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin  := 8
Endif

nLin := nLin + 1

@nLin,039 Psay "Cotacao Numero........:"
@nLin,067 Psay mv_par01
nLin := nLin + 2



For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "Nome Fornecedor.......:"
		_lCab := .F.
		@nLin,067 Psay Substr(_xForNom[x],1,22)
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay Substr(_xForNom[x],1,30)
	Endif
Next

_nColCab:=0
nLin:=nLin + 1
_lCab:= .T.

For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "Telefone..............:"
		_lCab := .F.
		@nLin,067 Psay Substr(_xForTel[x],1,20)
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay Substr(_xForTel[x],1,20)
	Endif
Next
_nColCab:=0
nLin:=nLin + 1
_lCab:= .T.
For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "Contato...............:"
		_lCab := .F.
		@nLin,067 Psay _xContato[x]
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay _xContato[x]
	Endif
Next
_nColCab:=0
nLin:=nLin + 1
_lCab:= .T.
For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "Prazo de Entrega......:"
		_lCab := .F.
		@nLin,067 Psay _xPrazo[x]
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay _xPrazo[x]
	Endif
Next
_nColCab:=0
nLin:=nLin + 1
_lCab:= .T.
For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "Condicoes Pagto.......:"
		_lCab := .F.
		@nLin,067 Psay _xCond[x]+"-"+_xDescri[x]
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay _xCond[x]+"-"+_xDescri[x]
	Endif
Next
_nColCab:=0
nLin:=nLin + 1
_lCab:= .T.
For x:= 1 to _nQtdFor
	If _lCab
		@nLin,039 Psay "N� Proposta Fornecedor:"
		_lCab := .F.
		@nLin,067 Psay _xNumPed[x]
	Else
		_nColCab :=_nColCab + 33
		@nLin,067+_nColCab Psay _xNumPed[x]
	Endif
Next
_nColCab:=0
_lCab:= .T.

nLin:= nLin + 2

ImpDet()
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �IMPDET    � Autor � Rogerio Ferreira   � Data �  21/07/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Imprime o Detalhe do Itens                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Rede Record Brasilia                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpDet()

Local _nColDet := 0
Local _nCont   := 0

For j:= 1 To Len(_xCod)
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		ImpCab()
		nLin  := 8
	Endif
	@nLin,001 Psay Substr(_xCod[j],1,7)
	@nLin,010 Psay Substr(_xDesc[j],1,30)
	@nLin,044 Psay _xUn[j]
	@nLin,048 Psay _xQuant[j] Picture "@E 999999"
	If _Mult
		For i:=1 To Len(_xForCod)//Len(_xVal[j])
			@nLin,059+_nColDet Psay Posicione("SC8",3,xFilial("SC8")+mv_par01+_xCod[j]+_xForCod[i],"SC8->C8_PRECO") Picture "@E 99,999,999.99"
			@nLin,075+_nColDet Psay _xQuant[j]*Posicione("SC8",3,xFilial("SC8")+mv_par01+_xCod[j]+_xForCod[i],"SC8->C8_PRECO") Picture "@E 999,999,999.99"
			_nColDet := _nColDet + 33
			_nCont   := _nCont + 1
			If _nCont >= 5
				Exit
			Endif
		Next
	Else
		@nLin,059+_nColDet Psay _xPreco[j] Picture "@E 99,999,999.99"
		@nLin,075+_nColDet Psay _xQuant[j]*_xPreco[j]Picture "@E 999,999,999.99"
		_nColDet := _nColDet + 33
		_nCont   := _nCont + 1
		If _nCont >= 5
			Exit
		Endif
	Endif
	nLin:= nLin + 1
	_nColDet := 0
	_nCont := 0
Next

nLin:= nLin + 1
_nColDet := 75
_nCont := 0

// Rotina para totalizar o Mapa de Cotacoes
For y:=1 To Len(_xForCod)
	@nLin,_nColDet Psay aVlTot[y,2] Picture "@E 999,999,999.99"
	_nColDet := _nColDet + 33
	_nCont   := _nCont + 1
	If _nCont >= 5
		Exit
	Endif
Next y

Return

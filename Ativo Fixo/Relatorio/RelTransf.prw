#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CustoReq  � Autor � AP6 IDE            � Data �  26/02/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Custo da Requisi��o por Produto                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelTransf


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Transfer�ncia do Imobilizado"
Local nLin         := 80

Local Cabec1       := "  Ativo      Item Tipo Descri��o                                  Do Centro de Custo                  Para Centro de Custo"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}


Private cMemoDesc
Private nMemoDesc
Private _aTxTDesc
Private cMemoObs
Private nMemoObs
Private _aTxTObs
Private _nLimDesc := 80
Private nLastLnDesc := 0


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RelTransf" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelTransf" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "ZA2"
Private lOk := .T.




//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


cQuery := "SELECT * FROM ZA2010 "
cQuery += "INNER JOIN ZA1010 ON "
cQuery += "ZA2_FILIAL = ZA1_FILIAL AND "
cQuery += "ZA2_CODIGO = ZA1_CODIGO "
cQuery += "WHERE "
cQuery += "ZA2_CODIGO = '" + (ZA1->ZA1_CODIGO) +"' AND "
cQuery += "ZA1010.D_E_L_E_T_ <> '*' AND "
cQuery += "ZA2010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ZA2_SEQ "

TcQuery cQuery New Alias "TMP"

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

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  24/08/12   ���
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




//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

DBSelectArea("TMP")
DBGotop()

While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	
	If lOk == .T.
		
		@nLin,001 PSAY "Codigo: " + TMP->ZA2_CODIGO + "    Solicitante: " + TMP->ZA1_SOLICI + "   C. Custo Solicitante: " + TMP->ZA1_CCDESC + ""
		nLin++
		@nLin,001 PSAY "Emiss�o: " + DTOC(STOD(TMP->ZA1_EMISSA)) + "   Dt. Transferencia: " + DTOC(STOD(TMP->ZA1_PROCES)) + ""
		nLin++
		@nLin,001 PSAY 	"Lib. Ger. Administrativo/Financeiro: " + DTOC(STOD(TMP->ZA1_ADM)) + "    Lib. Gerente Executivo: " + DTOC(STOD(TMP->ZA1_EXEC)) + ""
		nLin+=2
		@nLin,001 PSAY Replicate("-",132)
		nLin+=2
		@nLin,001 PSAY 	"Motivo da Transferencia:"
		nLin+=2
		
		
		DBSelectArea("ZA1")
		DBSEtOrder(1)
		DBSeek(TMP->ZA1_FILIAL + TMP->ZA1_CODIGO)
		
		cMemoDesc := alltrim(ZA1->ZA1_MOTIVO)
		nMemoDesc := MlCount( cMemoDesc , _nLimDesc )
		_aTxTDesc := memoFormata( cMemoDesc, _nLimDesc, nMemoDesc )
		
		For D:=1 to Len(_aTxTDesc)
			@nLin,001 PSAY ALLTRIM(UPPER(_aTxtDesc[D]))
			nLin ++
		Next
		
		nLin+= 2
		
		@nLin,001 PSAY Replicate("-",132)
		
		nLin+= 2
		
		lOk := .F.
		
		
		DBSelectArea("ZA1")
		DBCloseArea("ZA1")
		
	EndIf
	
	DBSelecTArea("TMP")

	
	@nLin,001 PSAY TMP->ZA2_CBASE
	@nLin,013 PSAY TMP->ZA2_ITEM
	@nLin,018 PSAY TMP->ZA2_TIPO
	@nLin,022 PSAY TMP->ZA2_DESCRI
	@nLin,067 PSAY TMP->ZA2_DESC
	@nLin,103 PSAY TMP->ZA1_CCDEST
	
	
	nLin++
	

	DBSkip()
	
EndDo



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

DBSelectARea("TMP")
DBCloseArea("TMP")

MS_FLUSH()

Return



Static Function memoFormata ( cMemo, _nLimite, nMemCount )

_nLenCar    := 0
_nPosSpace  := 0
_aTxt  := {}

If !Empty( nMemCount )
	For nLoop := 1 To nMemCount
		cLinha := MemoLine( cMemo, _nLimite, nLoop )
		_nLenCar := Iif(Len(AllTrim(cLinha))<_nLimite-20,21,1)
		While ( Len(Trim(cLinha)) <> _nLimite )
			_nPosSpace := At(' ',SubStr(cLinha,_nLenCar,Len(cLinha)))
			If ( _nPosSpace == 0 )
				Exit
			EndIf
			_nLenCar	+= _nPosSpace
			cLinha	:= SubStr(cLinha,1,_nLenCar-1)+" "+SubStr(cLinha,_nLenCar,Len(cLinha))
			_nLenCar++ // Proxima palavra.
		End
		aAdd(_aTxt,cLinha)
		
	Next nLoop
EndIf

Return ( _aTxt )

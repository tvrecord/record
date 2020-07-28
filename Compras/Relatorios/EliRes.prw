#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EliRes    � Autor � Bruno Alves        � Data �  29/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio que mostra quais pedidos foram eliminados        ���
���          � os Residuos                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function EliRes


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := "Produto   Descri��o                             Qtd            Valor           Total    Elimina��o  Responsavel
Local Cabec2       := "Pedido  Emiss�o     For.       Nome                           Motivo"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "ELIRES" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "ELIRES"
Private cString := "SC7"
Private cPedido := ""
Private lOk := .F.
Private nVal := 0
Private nTot := 0
Private aUser := ALLUSERS()
Private nPos := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF



//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

titulo       := "Elimina Residuos - " + DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02) + ""

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

cQuery := "SELECT C7_NUM,C7_PRODUTO,B1_DESC,(C7_QUANT - C7_QUJE) AS QUANTIDADE,C7_PRECO, (C7_PRECO * (C7_QUANT - C7_QUJE)) AS TOTAL, C7_FORNECE,C7_LOJA,A2_NREDUZ,C7_EMISSAO,C7_DTMOT,C7_MOTIVO,C7_USERLGA,C7_RESIDUO FROM SC7010 "
cQuery += "INNER JOIN SA2010 ON "
cQuery += "SA2010.A2_COD = SC7010.C7_FORNECE AND "
cQuery += "SA2010.A2_LOJA = SC7010.C7_LOJA "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "SB1010.B1_COD = SC7010.C7_PRODUTO "
cQuery += "WHERE "
cQuery += "C7_DTMOT BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
cQuery += "SC7010.C7_RESIDUO = 'S' AND "
cQuery += "SC7010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY C7_NUM"



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

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/05/12   ���
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

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

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

dbGoTop()

DbSelectArea("TMP")

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
	
	If nLin > 65 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	
	If cPedido != TMP->C7_NUM
		
		If lOk == .T.
			@nLin,73 PSAY nVal PICTURE "@E 999,999,999.99"		
			nVal := 0
			nLin := nLin + 2 // Avanca a linha de impressao
		EndIf


		
		@nLin,00 PSAY ALLTRIM(TMP->C7_NUM)
		@nLin,08 PSAY STOD(TMP->C7_EMISSAO)
		@nLin,20 PSAY ALLTRIM(TMP->C7_FORNECE)
		@nLin,30 PSAY ALLTRIM(TMP->A2_NREDUZ)
		@nLin,62 PSAY ALLTRIM(TMP->C7_MOTIVO)
		@nLin,00 PSAY "__________________________________________________________________________________________________________________________________________"
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		
	EndIf

// Busca o nome de quem eliminou o Residuo
 
 nPos := aScan(aUser, { |x| x[1,1]  ==  SUBSTR(EMBARALHA(TMP->C7_USERLGA,1),3,6) } )		
	
	@nLin,00 PSAY TMP->C7_PRODUTO
	@nLin,11 PSAY TMP->B1_DESC
	@nLin,50 PSAY TMP->QUANTIDADE
	@nLin,57 PSAY TMP->C7_PRECO PICTURE "@E 999,999,999.99"
	@nLin,73 PSAY TMP->TOTAL PICTURE "@E 999,999,999.99"
	@nLin,90 PSAY STOD(TMP->C7_DTMOT)
	If !empty(nPos)
	@nLin,100 PSAY aUser[nPos][1][2]  // Nome da pessoa que executou a rotina Eliminar Residuo
	EndIf
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	cPedido := TMP->C7_NUM
	lOk := .T.  
	
	nVal += TMP->TOTAL
	nTot += TMP->TOTAL
	
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo
     
   	@nLin,73 PSAY nVal PICTURE "@E 999,999,999.99"
    nLin := nLin + 2 
	@nLin,00 PSAY "__________________________________________________________________________________________________________________________________________"
	nLin := nLin + 1 // Avanca a linha de impressao
	@nLin,00 PSAY "Total Geral:"
	@nLin,73 PSAY nTot PICTURE "@E 999,999,999.99"

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

DBSelectArea("TMP")
DBCloseArea("TMP")

MS_FLUSH()

Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Data ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Data ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

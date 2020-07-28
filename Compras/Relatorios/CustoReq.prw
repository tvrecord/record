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

User Function CustoReq


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Custo Almoxarifado por Conta SIG"
Local nLin         := 80

Local Cabec1       := "  Codigo Quant. Descri��o                            Ct. Contabil   Nome                              Custo             Documento"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CustoReq" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CustoReq" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "CustoReq3"
Private cString    := "SD3"
Private aImpres    := {}
Private aTot := {}
Private nTotSig := 0
Private nTotal  := 0
Private lOk := .T.


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


If MV_PAR07 == 1
	cQuery := "SELECT D3_COD,SUM(D3_QUANT) AS D3_QUANT, B1_DESC,SUM(D3_CUSTO1) AS CUSTO,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI, "
ELSE
	cQuery := "SELECT D3_DOC,D3_COD,D3_QUANT,B1_DESC,D3_CUSTO1 AS CUSTO,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI, "
EndIf
cQuery += "ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
cQuery += "FROM SD3010 "
cQuery += "INNER JOIN SB1010 ON "
cQuery += "B1_COD = D3_COD "
cQuery += "INNER JOIN CT1010 ON "
cQuery += "B1_CONTA = CT1_CONTA "
cQuery += "INNER JOIN SZY010 ON "
cQuery += "ZY_CODIGO = CT1_SIG "
cQuery += "WHERE "
cQuery += "SZY010.D_E_L_E_T_ <> '*' AND "
cQuery += "CT1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SB1010.D_E_L_E_T_ <> '*' AND "
cQuery += "SD3010.D_E_L_E_T_ <> '*' AND "
cQuery += "D3_ESTORNO = '' AND "
cQuery += "D3_TM > '500' AND "
cQuery += "CT1_SIG BETWEEN '" + (MV_PAR05) + "' AND  '" + (MV_PAR06) + "' AND "
cQuery += "D3_COD BETWEEN '" + (MV_PAR01) + "' AND  '" + (MV_PAR02) + "' AND "
cQuery += "D3_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
If MV_PAR07 == 1
	cQuery += "GROUP BY D3_COD,B1_DESC,B1_CONTA,CT1_DESC01,CT1_SIG,ZY_DESCRI,ZY_MES01,ZY_MES02,ZY_MES03,ZY_MES04,ZY_MES05,ZY_MES06,ZY_MES07,ZY_MES08,ZY_MES09,ZY_MES10,ZY_MES11,ZY_MES12 "
	cQuery += "ORDER BY CT1_SIG,D3_COD"
ELSE
	cQuery += "ORDER BY CT1_SIG,D3_COD,D3_DOC "
EndIf


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
	
	If lOk == .T.
		
		@nLin,001 PSAY TMP->CT1_SIG
		@nLin,010 PSAY TMP->ZY_DESCRI
		@nLin,000 PSAY Replicate("_",132)
		
		nLin += 2
		
		lOk := .F.
		
	EndIf
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	
	@nLin,001 PSAY  TMP->D3_COD
	@nLin,012 PSAY  TMP->D3_QUANT
	@nLin,017 PSAY 	TMP->B1_DESC
	@nLin,057 PSAY 	TMP->B1_CONTA
	@nLin,070 PSAY 	TMP->CT1_DESC01
	@nLin,100 PSAY 	TMP->CUSTO PICTURE "@E 9,999,999.99"
	If MV_PAR07 == 2
	@nLin,122 PSAY 	TMP->D3_DOC
	Endif
	
	//	aAdd(aPedidos,{TMP->CT1_SIG,TMP->D3_COD,"AM",,,,TMP->B1_DESC,TMP->B1_CONTA,TMP->CT1_DESC01,TMP->D3_QUANT,,,TMP->CUSTO,})
	
	nTotal  += TMP->CUSTO
	nTotSig += TMP->CUSTO
	
	
	nLin++
	
	cSig := TMP->CT1_SIG
	
	DBSkip()
	
	If cSig != TMP->CT1_SIG
		
		@nLin,099 PSAY 	nTotSig PICTURE "@E 9,999,999.99"
		
		lOk := .T.
		nTotSig := 0
		
		nLin+=2
		
	Endif
	
	
EndDo

@nLin,100 PSAY 	nTotal PICTURE "@E 999,999,999.99"













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


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Do 	Codigo?	","","","mv_ch01","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"02","Ate Codigo?	","","","mv_ch02","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"03","Da  Emiss�o ?","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate Emiss�o ?","","","mv_ch04","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"05","Da Conta SIG?	","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SZY"})
AADD(aRegs,{cPerg,"06","Ate Conta SIG?	","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SZY"})
aAdd(aRegs,{cPerg,"07","Tipo? 	","","","mv_ch7","N",01,00,1,"C","","mv_par07","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","" })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)
Return

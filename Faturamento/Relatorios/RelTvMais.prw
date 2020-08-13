#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RelTvMais � Autor � Bruno Alves        � Data �  25/08/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio dos arquivos que ser�o importados para o pedido  ���
���          � de venda atravez do arquivo exportado pelo tv+             ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelTvMais


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Relat�rio de Valida��o Importa��o TV+"
Local nLin         := 80

Local Cabec1       := "Num. RP  Cliente Nome                                                  Valor"
Local Cabec2       := "Motivo"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RelTvMais" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelTvMais" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "RelTvMai1"
Private cString    := "ZA9"
Private aImpres    := {}
Private aTot := {}
Private aMotivo := {}
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


cQuery := "SELECT ZA9_CLIENT,ZA9_LOJA,ZA9_NOME,ZA9_VENDED,ZA9_NMVEND,ZA9_NUMRP,ZA9_NOTA,ZA9_PEDIDO,ZA9_VALOR,ZA9_IMPORT,ZA9_MOTIVO,ZA9_DESCMO,ZA9_IDCLI FROM ZA9010 WHERE "
cQuery += "ZA9_CLIENT BETWEEN '" + (MV_PAR01) + "' AND  '" + (MV_PAR02) + "' AND "
cQuery += "ZA9_VENDED BETWEEN '" + (MV_PAR03) + "' AND  '" + (MV_PAR04) + "' AND "
cQuery += "ZA9_NUMRP BETWEEN '" + (MV_PAR05) + "' AND  '" + (MV_PAR06) + "' AND "
cQuery += "D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY ZA9_NUMRP"

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
		nLin := 9
	Endif
	
	
		@nLin,001 PSAY TMP->ZA9_NUMRP
		@nLin,010 PSAY TMP->ZA9_CLIENT		
		@nLin,018 PSAY TMP->ZA9_NOME
		@nLin,069 PSAY TMP->ZA9_VALOR PICTURE "@E 9,999,999.99"
		
		nLin ++
	         
	
		//Verifico se j� existe o pedido para a RP, se houver, n�o importa.
		dbSelectArea("SC5")			
		dbSetOrder(6)
		If(dbSeek(xFilial("SC5")+TMP->ZA9_NUMRP))
		aAdd(aMotivo,{"01",;  		//01.Codigo do Motivo
		Posicione("SX5",1,xFilial("SX5") + "ZX" + "01","X5_DESCRI")}) // 02 Descri��o do Motivo
		Endif
		
		
		//Nao importa pedido com valor zerado
			If TMP->ZA9_VALOR == 0
		aAdd(aMotivo,{"02",;  		//01.Codigo do Motivo
		Posicione("SX5",1,xFilial("SX5") + "ZX" + "02","X5_DESCRI")}) // 02 Descri��o do Motivo
			EndIf

		//Verifica se existe o cliente cadastrado
			If EMPTY(TMP->ZA9_IDCLI)
		aAdd(aMotivo,{"03",;  		//01.Codigo do Motivo
		Posicione("SX5",1,xFilial("SX5") + "ZX" + "03","X5_DESCRI")}) // 02 Descri��o do Motivo
			Endif			


		
		//Verifica se existe o cliente cadastrado
			If EMPTY(TMP->ZA9_CLIENT)
		aAdd(aMotivo,{"04",;  		//01.Codigo do Motivo
		Posicione("SX5",1,xFilial("SX5") + "ZX" + "04","X5_DESCRI")}) // 02 Descri��o do Motivo
			Endif    
			
			
If !EMPTY(aMotivo)
		@nLin,001 PSAY "Arquivo n�o ser� importado pelo(s) seguinte(s) motivo(s):"
		nLin++    
		
		For I := 1 to LEN(aMotivo)
		@nLin,001 PSAY "- " + aMotivo[I][2]
		nLin++
		
		Next

ELSE

		@nLin,001 PSAY "Arquivo ser� importado com sucesso!"
		
EndIf


nLin++
@nLin,000 PSAY Replicate("_",132)
nLin++

DBSelectArea("TMP")
DBSkip()

aMotivo := {}
	
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


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Do 	Cliente?	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"02","Ate Cliente?	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"03","Do Vendedor ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"04","Ate Vendedor ?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"}) 
AADD(aRegs,{cPerg,"05","Do NUMRP?	","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate NUMRP?	","","","mv_ch06","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

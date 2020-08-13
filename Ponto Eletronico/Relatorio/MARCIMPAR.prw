#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MARCIMPAR   � Autor � Bruno Alves        � Data �  22/05/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Demonstrar as marca��es impares do periodo em aberto       ���
���            			                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MARCIMPAR


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Funcion�rios - Marca��es Impares"
Local nLin         := 80

Local Cabec1       := "Mat       Nome                                                 Data "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "MARCIMPAR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "MARCIMPAR"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "MARCIMPAR" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SRA"
Private cQuery := ""


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)



cQuery := "SELECT COUNT(P8_DATAAPO) AS NUMERO,P8_DATAAPO,P8_MAT,RA_NOME FROM SP8010 "
cQuery += "INNER JOIN SRA010 ON "
cQuery += "RA_FILIAL = P8_FILIAL AND "
cQuery += "RA_MAT = P8_MAT "
cQuery += "WHERE "
cQuery += "P8_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "P8_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "P8_TPMCREP = '' AND "
cQuery += "SP8010.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "P8_DATAAPO <> '' "
cQuery += "GROUP BY P8_DATAAPO,P8_MAT,RA_NOME "
cQuery += "HAVING  COUNT(P8_DATAAPO) = 1 OR COUNT(P8_DATAAPO) = 3 OR COUNT(P8_DATAAPO) = 5 OR COUNT(P8_DATAAPO) = 7 OR COUNT(P8_DATAAPO) = 9 OR COUNT(P8_DATAAPO) = 11 "
cQuery += "ORDER BY RA_NOME,P8_DATAAPO "


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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  06/09/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
15267���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

dbSelectARea("TMP")
dbGoTop()

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
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	
	
	
	@nLin, 000 PSAY TMP->P8_MAT
	@nLin, 010 PSAY TMP->RA_NOME
	@nLin, 060 PSAY STOD(TMP->P8_DATAAPO)

nLin++
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
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

MS_FLUSH()

DBSelectAREa("TMP")
DBCloseARea("TMP")

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Filial ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Da  Matricula ?","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Ate Matricula ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})


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

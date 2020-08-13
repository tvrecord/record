#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DUPREV    � Autor � Bruno Alves        � Data �  22/04/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime as duplicidades exisstentes no cadastro de previsao���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DUPREV


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := "Natureza    Nome da Natureza                       For.      Nome do Fornecedor                      Vencimento"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 130
Private tamanho          := "M"
Private nomeprog         := "DUPREV" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DUPREV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "DUPREV"
Private cString := "SC7"
Private cPedido := ""
Private lOk := .F.
Private nVal := 0
Private nTot := 0
Private aUser := ALLUSERS()
Private nPos := 0
Private nRec  := 0
Private nVec := 0
Private lVal  := .T.
Private lVenc := .T.

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF


titulo := "Duplicidade do cadastro de Previsao do Mes: " + MV_PAR01 + " e do Ano: " + MV_PAR02 + ""



//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)


cQuery := "SELECT ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR,ZA6_VENC FROM ZA6010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "ZA6_NATURE = ED_CODIGO "
cQuery += "WHERE "
cQuery += "ZA6_MES = '" + (MV_PAR01) + "' AND "
cQuery += "ZA6_ANO = '" + (MV_PAR02) + "' AND "
cQuery += "ED_PREVISA = '2' AND "
cQuery += "ZA6010.D_E_L_E_T_ <> '*'  AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR,ZA6_VENC "
cQuery += "HAVING COUNT(ZA6_MES) > 1 "

tcQuery cQuery New Alias "TMP" // Previsao Vencimento

COUNT TO nVec

DBSelectArea("TMP")
DBGotop()


cQuery := "SELECT ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR FROM ZA6010 "
cQuery += "INNER JOIN SED010 ON "
cQuery += "ZA6_NATURE = ED_CODIGO "
cQuery += "WHERE "
cQuery += "ZA6_MES = '" + (MV_PAR01) + "' AND "
cQuery += "ZA6_ANO = '" + (MV_PAR02) + "' AND "
cQuery += "ED_PREVISA = '1' AND "
cQuery += "ZA6010.D_E_L_E_T_ <> '*'  AND "
cQuery += "SED010.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY ZA6_MES,ZA6_ANO,ZA6_NATURE,ZA6_NMNAT,ZA6_FORNEC,ZA6_NMFOR "
cQuery += "HAVING COUNT(ZA6_MES) > 1 "

tcQuery cQuery New Alias "TMP1" // Previsao Valor

COUNT TO nRec

DBSelectArea("TMP1")
DBGotop()

If nRec == 0 .AND. nVec == 0
	MsgInfo("Nao existem dados duplicados!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
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


If nVec != 0 // Imprime Previs�es que as naturezas est�o configuradas pelo vencimento
	
	DbSelectArea("TMP")
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
		
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		If lVenc == .T.
			@nLin,000 PSAY  "Naturezas configuradas pelo Vencimento"
			nLin+=2
			lVenc := .F.
		EndIf
		
		
		@nLin,000 PSAY  TMP->ZA6_NATURE
		@nLin,012 PSAY  TMP->ZA6_NMNAT
		@nLin,052 PSAY  TMP->ZA6_FORNEC
		@nLin,062 PSAY  TMP->ZA6_NMFOR
		@nLin,102 PSAY  STOD(TMP->ZA6_VENC)
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		DBSelectARea("TMP")
		
		
		
		dbSkip() // Avanca o ponteiro do registro no arquivo
		
	EndDo
	
EndIf


If nRec != 0 // Imprime Previs�es que as naturezas est�o configuradas pelo Valor
	
	DbSelectArea("TMP1")
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
		
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		If lVal == .T.
			@nLin,000 PSAY  "Naturezas configuradas pelo Valor"
			nLin+=2
			lVal := .F.
		EndIf
		
		
		
		@nLin,000 PSAY  TMP1->ZA6_NATURE
		@nLin,012 PSAY  TMP1->ZA6_NMNAT
		@nLin,052 PSAY  TMP1->ZA6_FORNEC
		@nLin,062 PSAY  TMP1->ZA6_NMFOR
		//		@nLin,102 PSAY  STOD(TMP->ZA6_VENC)
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		DBSelectARea("TMP1")
		
		
		
		dbSkip() // Avanca o ponteiro do registro no arquivo
		
	EndDo
	
EndIf



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
dbSelectArea("TMP1")
dbCloseArea("TMP1")

MS_FLUSH()

Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Previsao do Mes?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Previsao do Ano?","","","mv_ch02","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

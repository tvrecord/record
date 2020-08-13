#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "PROTHEUS.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FREQEST   � Autor � Bruno Alves        � Data �  06/09/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprimir um relatorio para que a estagiaria informe sua    ���
���            Frequencia                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FREQEST


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "FREQEST" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "FREQEST"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
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

If MV_PAR08 == 1
	titulo       := " Controle de Frequ�ncia de Estagi�rio"
else
	titulo		 := " Controle de Ponto Manual"
EndIf

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)



cQuery := "SELECT RA_MAT,RA_NOME,RA_CC,CTT_DESC01 FROM SRA010 "
cQuery += "INNER JOIN CTT010 ON "
cQuery += "SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND "
cQuery += "SRA010.RA_CC = CTT010.CTT_CUSTO "
cQuery += "WHERE "
cQuery += "SRA010.RA_FILIAL = '" + (MV_PAR01) + "' AND "
cQuery += "SRA010.RA_MAT BETWEEN '" + (MV_PAR02) + "' AND '" + (MV_PAR03) + "' AND "
cQuery += "SRA010.RA_CC BETWEEN '" + (MV_PAR04) + "' AND '" + (MV_PAR05) + "' AND "
If MV_PAR08 == 1
	cQuery += "SRA010.RA_CATFUNC = 'E' AND "
EndIf
If MV_PAR09 == 2
cQuery += "RA_DEMISSA = '' AND "
EndIf
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "CTT010.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY RA_CC,RA_MAT "

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
	
	
	
	
	@nLin, 000 PSAY "Empresa: R�DIO E TELEVIS�O CAPITAL LTDA"
	nLin += 1
	@nLin, 000 PSAY "Nome: " + UPPER(TMP->RA_NOME)
	@nLin, 060 PSAY "Matr.: " + TMP->RA_MAT
	nLin += 1
	@nLin, 000 PSAY "Departamento: " + UPPER(TMP->CTT_DESC01)
	nLin += 1
	@nLin, 000 PSAY "Per�odo: " + DTOC(MV_PAR06) + " a " + DTOC(MV_PAR07)
	nLin += 3
	@nLin, 000 PSAY "DIA DA SEMANA"
	@nLin, 000 PSAY REPLICATE("_",Limite)
	@nLin, 017 PSAY	"|"
	
	@nLin, 021 PSAY	"DATA"
	@nLin, 029 PSAY	"|"
	
	@nLin, 033 PSAY	"1� ENTR"
	@nLin, 043 PSAY	"|"
	
	@nLin, 045 PSAY	"1� SAIDA"
	@nLin, 055 PSAY	"|"
	
	@nLin, 057 PSAY	"2� ENTR"
	@nLin, 067 PSAY	"|"
	
	@nLin, 069 PSAY	"2� SAIDA"
	
	nLin += 1
	
	
	//Impress�o dos dias do periodo informado
	For _I := MV_PAR06 To MV_PAR07
		@nLin, 000 PSAY	alltrim(DiaSemana(_I))
		@nLin, 021 PSAY	STRZERO(DAY(_I),2)
		@nLin, 000 PSAY REPLICATE("_",Limite)
		@nLin, 017 PSAY	"|"
		@nLin, 029 PSAY	"|"
		@nLin, 043 PSAY	"|"
		@nLin, 055 PSAY	"|"
		@nLin, 067 PSAY	"|"
		
		nLin += 1
	Next _I
	
	
	
	//Impress�o das assinaturas
	
	
	nLin := 50
	@nLin, 002 PSAY	"_________________________________"
	@nLin, 045 PSAY	"_________________________________"
	nLin += 1
	If MV_PAR08 == 1
		@nLin, 002 PSAY	"    Assinatura do Estagi�rio     "
	else
		@nLin, 002 PSAY	"    Assinatura do Funcin�rio     "
	endIf
	@nLin, 045 PSAY	"  Assinatura do Ger./Supervisor  "
	
	nLin := 55 // Saltar a Pagina, pois cada funcionario e necessario de pagina EXCLUSIVA
	nLin := nLin + 1 // Avanca a linha de impressao
	
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
AADD(aRegs,{cPerg,"04","De  C. Custo ?","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"05","Ate C. Custo ?","","","mv_ch05","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"06","Da  Data ?","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Ate Data ?","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Estagiario ?","","","mv_ch08","N",01,0,2,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Demitido ?","","","mv_ch09","N",01,0,2,"C","","mv_par09","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})

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

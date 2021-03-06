#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RTCR122   � Autor � Cristiano D. Alves � Data �  18/07/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Rela��o de afastamento, o tipo do afastamento e os aponta- ���
���          � mentos do periodo.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Record - DF                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RTCR122()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de afastamentos"
Local cPict          := ""
Local titulo       	:= "Relatorio de afastamentos"
Local nLin         	:= 80

Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Private aOrd         := {"Matricula","Centro de Custo","Nome"}
Private lEnd         := .F.
Private lAbortPrint	:= .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RTCR122" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RTCR122" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SRA"
Private cPerg			:= "RTC02"

ValidPerg()
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  18/07/07   ���
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

Local nOrdem 	:= aReturn[8]
Local _cQuery	:= ""
Local cTAfaFer := GetMv( "MV_TAFAFER" )
Local nAvosAf := nDiasAf := 0

_cQuery += "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CC "
_cQuery += " "+RetSqlName("SRA")+"  FROM "
_cQuery += "WHERE D_E_L_E_T_ = '' "
_cQuery += "AND RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQuery += "AND RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
If nOrdem == 1
	_cQuery += "ORDER BY RA_FILIAL, RA_MAT"
ElseIf nOrdem == 2
	_cQuery += "ORDER BY RA_FILIAL, RA_CC"
ElseIf nOrdem == 3
	_cQuery += "ORDER BY RA_FILIAL, RA_NOME"
EndIf

TcQuery _cQuery New Alias "TRB"


SetRegua(RecCount())

TRB->(dbGoTop())
While !TRB->(EOF())
	
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
	dFimPeriodo := MV_PAR05
	dIniPeriodo := dFimPeriodo + 1
	dFimPeriodo := fCalcFimAq(dIniPeriodo)
	nAvosAf := nDiasAf := 0
	fRetAfas(dIniPeriodo,dFimPeriodo,If(cTAfaFer=="S","O*P*Q*R*X*W",cTAfaFer),@nAvosAf,@nDiasAf,,.F.)
	/*
	SR8->(dbSetOrder(1))
	If dbSeek(xFilial("SR8")+TRB->RA_FILAL+TRB->RA_MAT)
	While !SR8->(Eof()) .and. SR8->R8_FILIAL+SR8->R8_MAT == TRB->RA_FILAL+TRB->RA_MAT
	If SR8->R8_DATAINI == "01/02/07" .and.    R8_DATAFIM
	"23/02/07" >= "01/02/07"
	SR8->(dbSkip())
	EndDo
	
	EndIf
	*/
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

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDPERG �Autor  �Cristiano D. Alves  � Data �  06/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria as perguntas no SX1.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Record - DF                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Da Matricula       ?","","","mv_ch1","C",06,00,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"02","Ate a Matricula    ?","","","mv_ch2","C",06,00,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"03","Centro de Custo de ?","","","mv_ch3","C",06,00,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT","" })
aAdd(aRegs,{cPerg,"04","Centro de Custo ate?","","","mv_ch4","C",06,00,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"05","Data de            ?","","","mv_ch5","D",08,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Data ate           ?","","","mv_ch6","D",08,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

/*
0         10        20        30        40        50        60        70        80        90        100       110       120       130
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

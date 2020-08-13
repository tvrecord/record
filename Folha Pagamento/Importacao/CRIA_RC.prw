#INCLUDE "rwmake.ch"   
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  14/08/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CRIA_RC()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt           
Private cPerg := "CRIARC"

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeSRD TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ir� ler o conteudo do arquivo SRD e criar� os   "
@ 18,018 Say " os arquivos RC?????? conforme parametriza��o do usu�rio.      "
@ 26,018 Say " Aten��o!!! Fa�a um backup da base antes de gerar esta rotina. "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeSRD()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeSRD)

Activate Dialog oLeSRD Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OkLeSRD  � Autor � AP6 IDE            � Data �  14/08/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeSRD

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������  

ValidPerg()
Pergunte(cPerg,.T.)

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  14/08/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                             
Static Function RunCont     

//Deve-se ter os RC�s vazios dentro do system
dbUseArea(.T.,__LocalDriver,"RC"+SM0->M0_CODIGO+Substr(MV_PAR01,5,2)+Substr(MV_PAR01,1,2)+".DBF","TRC",.T.,.F.)

_cQry := "SELECT * "
_cQry += "FROM "+RetSqlName("SRD")+" SRD "
_cQry += "WHERE RD_DATARQ = '"+Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"' " 
_cQry += "AND SRD.D_E_L_E_T_ = ''"
TcQuery _cQry New Alias "QRY"

While !QRY->(Eof())

	IncProc("Gravando matricula: "+QRY->RD_MAT)
	RecLock("TRC",.T.)
	TRC->RC_FILIAL		:= QRY->RD_FILIAL
	TRC->RC_MAT			:= QRY->RD_MAT
	TRC->RC_PD     	:= QRY->RD_PD
	TRC->RC_TIPO1  	:= QRY->RD_TIPO1
	TRC->RC_QTDSEM		:= QRY->RD_QTDSEM
	TRC->RC_HORAS		:= QRY->RD_HORAS
	TRC->RC_VALOR		:= QRY->RD_VALOR
	TRC->RC_DATA		:= STOD(QRY->RD_DATPGT)
	TRC->RC_SEMANA		:= QRY->RD_SEMANA
	TRC->RC_CC     	:= QRY->RD_CC
	TRC->RC_PARCELA	:= 0
	TRC->RC_TIPO2		:= QRY->RD_TIPO2
	TRC->RC_SEQ			:= QRY->RD_SEQ
	TRC->RC_VALORBA	:= 0
   MsUnlock()
                            
	QRY->(dbSkip())
EndDo   

TRC->(dbCloseArea()) 
QRY->(dbCloseArea())

Close(oLeSRD)

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
aAdd(aRegs,{cPerg,"01","Mes/Ano Referencia ?","","","mv_ch1","C",06,00,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","" })

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
//Cria tabela para o backup dos SRC�s que ser�o atualizados
_cQuery	:= "CREATE TABLE RC"+SM0->M0_CODIGO+Substr(MV_PAR01,5,2)+Substr(MV_PAR01,1,2)+"CENTES AS "
_cQuery	+= "(SELECT * FROM " + RetSqlName("SRD") + ") WITH NO DATA "
TcSqlExec(_cQuery)
_cQueryIndex1 := "CREATE INDEX CLIENTES1 ON CLIENTES (A1_FILIAL, A1_CGC, D_E_L_E_T_) "
RD_FILIAL+RD_MAT+RD_CC+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ
TcSqlExec(_cQueryIndex1)     

//Insere na tabela temporaria CLIENTES os registros do SA1010
_cQuery	:= "INSERT INTO CLIENTES ("
_cQuery	+= "SELECT * "
_cQuery	+= "FROM SA10" + _cEmp + "0 AS SA1 "
_cQuery	+= "WHERE A1_FILIAL = '' AND A1_CGC <> '' AND SUBSTR(A1_CGC,1,6) <> '000000' AND "
_cQuery += "SA1.D_E_L_E_T_ = ' ' ) "
msAguarde({|| TCSQLExec(_cQuery)}, "Aguarde", "Inserindo clientes de SA10"+_cEmp+"0...")
*/
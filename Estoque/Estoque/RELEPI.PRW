#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELEPI    � Autor � Rafael Franca      � Data � 06/07/2011  ���
�������������������������������������������������������������������������͹��
���Descricao �RELATORIO DE EPI PARA FUNCIONARIOS DE OUTRAS FILIAIS        ���
��|          |     														  ���
�������������������������������������������������������������������������͹��
���Uso       �RELEPI                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RELEPI        

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "EPI para funcionarios de outras filiais"
Local nLin           := 100

Local Cabec1         := " Produto   Descricao                                           QTD        Entrega     Situacao         Devolucao       "
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RELEPI"// Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELEPI"// Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RELEPI9"
Private cString      := "TNF"
Private cQuery       := ""
Private nCont	    := 0


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������


wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)


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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  28/09/09   ���
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

Local cCustos	:= ""
Local cMat	 	:= ""
Local cMatFun 	:= ""
Local cMatNome	:= "" 
Local nItens	:= 0
Local nItensTot := 0
Local nItensFun := 0
Local nItensCC	:= 0 

cQuery	:= "SELECT TNF_FILIAL,TNF_CODEPI,TNF_MAT,TNF_DTENTR,TNF_QTDENT,TNF_INDDEV,TNF_DTDEVO,TNF_MATFUN,TNF_FUNNAM,B1_DESC,RA_CC,TNF_OBS "
cQuery	+= "FROM TNF010 "
cQuery	+= "INNER JOIN SB1010 ON TNF010.TNF_CODEPI = SB1010.B1_COD " 
cQuery	+= "INNER JOIN SRA010 ON TNF_FILIAL = RA_FILIAL AND TNF_MAT = RA_MAT "
cQuery	+= "WHERE TNF010.D_E_L_E_T_ <> '*' AND SB1010.D_E_L_E_T_ <> '*' AND SRA010.D_E_L_E_T_ <> '*'"  
IF 		MV_PAR10 == 2
	cQuery	+= "AND TNF010.TNF_INDDEV = '1' "
ELSEIF 	MV_PAR10 == 3
	cQuery	+= "AND TNF010.TNF_INDDEV = '2' "
ENDIF  

IF 	   !EMPTY(MV_PAR17)
	cQuery	+= "AND SB1010.B1_DESC LIKE '%"+ALLTRIM(MV_PAR17)+"%' "
ENDIF
cQuery	+= "AND TNF010.TNF_CODEPI BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " 
cQuery	+= "AND TNF010.TNF_MAT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
//cQuery	+= "AND TNF010.TNF_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "  
cQuery	+= "AND TNF010.TNF_DTENTR BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "
IF MV_PAR10 == 2
cQuery	+= "AND TNF010.TNF_DTDEVO BETWEEN '" + DTOS(MV_PAR11) + "' AND '" + DTOS(MV_PAR12) + "' "
ENDIF
cQuery	+= "AND SB1010.B1_LOCPAD BETWEEN '" + MV_PAR14 + "' AND '" + MV_PAR15 + "' "
IF 		MV_PAR09 == 1
	cQuery	+= "ORDER BY SRA010.RA_CC,TNF010.TNF_MAT,TNF010.TNF_MATFUN,TNF010.TNF_CODEPI"
ELSEIF 	MV_PAR09 == 2
	cQuery	+= "ORDER BY SRA010.RA_CC,TNF010.TNF_MAT,TNF010.TNF_MATFUN,SB1010.B1_DESC"
ELSEIF 	MV_PAR09 == 3
	cQuery	+= "ORDER BY SRA010.RA_CC,TNF010.TNF_MAT,TNF010.TNF_MATFUN,TNF010.TNF_DTENTR"
ENDIF  

tcQuery cQuery New Alias "TMP"
                               

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif


DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	SetRegua(RecCount())
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"   
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Exit                                             
		
		
	Endif
	
	If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
  

	IF (TMP->RA_CC != cCustos) .AND. MV_PAR13 == 1
		nLin := nLin + 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao    
		@nLin, 001 PSAY TMP->RA_CC
		@nLin, 015 PSAY Posicione("CTT",1,xFilial("CTT")+RA_CC,"CTT_DESC01")
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nITens	 	:= 0          
	Endif

	If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	IF (TMP->TNF_MAT != cMat) 
		//@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao    
		@nLin, 001 PSAY UPPER("Matricula:") 
		@nLin, 015 PSAY TMP->TNF_MAT
		@nLin, 026 PSAY SUBSTR(Posicione("SRA",1,xFilial("SRA")+TMP->TNF_MAT,"RA_NOME"),1,35) 
		@nLin, 065 PSAY "FUN�AO:"
		@nLin, 073 PSAY Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
		IF MV_PAR13 == 2
		@nLin, 098 PSAY "C. CUSTO:" 
		@nLin, 107 PSAY Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") 
		ENDIF
		nLin := nLin + 1 // Avanca a linha de impressao            "
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
		nLin := nLin + 1 // Avanca a linha de impressao
		nITens	 	:= 0          
	Endif
	
	If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin, 001 PSAY Alltrim(TMP->TNF_CODEPI)
	@nLin, 012 PSAY SUBSTR(TMP->B1_DESC,1,40)   
	@nLin, 061 PSAY TMP->TNF_QTDENT PICTURE "@E 999"                                    
	@nLin, 074 PSAY STOD(TMP->TNF_DTENTR) 
	IF TMP->TNF_INDDEV == "1"
	@nLin, 086 PSAY "Devolvido"
	ELSE 
	@nLin, 086 PSAY "Com Funcionario"
	ENDIF 
	
	IF !EMPTY(TMP->TNF_OBS) 
	nLin += 1
	@nLin, 001 PSAY "OBS: "
	@nLin, 006 PSAY ALLTRIM(TMP->TNF_OBS)
	ENDIF
	
	nItens   	+= TMP->TNF_QTDENT
	nItensTot 	+= TMP->TNF_QTDENT
	nItensFun 	+= TMP->TNF_QTDENT
	nItensCC	+= TMP->TNF_QTDENT
	cCustos		:= TMP->RA_CC
	cMat 		:= TMP->TNF_MAT 
	cMatFun		:= TMP->TNF_MATFUN
	cFunName    := TMP->TNF_FUNNAM  
	

	dbSelectArea ("TMP")
	dbskip()
	
	
	IF (TMP->TNF_MATFUN != cMatFun) .AND. !EMPTY(cMatFun)
	nLin += 2
	@nLin, 000 PSAY UPPER("Funcionario -->")
	@nLin, 018 PSAY Alltrim(cMatFun)	
	@nLin, 028 PSAY Alltrim(cFunName) 
	@nLin, 062 PSAY nItensFun PICTURE "@E 999"  
	//@nLin, 099 PSAY "ASS: ______________________"   
	nItensFun := 0
	nLin += 1
	ENDIF

	
	IF (TMP->TNF_MAT != cMat)
		nLin += 2
		@nLin, 001 PSAY "Total do Matricula -->"  
		@nLin, 026 PSAY Posicione("SRA",1,xFilial("SRA")+ cMat ,"RA_NOME")
		@nLin, 062 PSAY nItens	  PICTURE "@E 999"   
		//@nLin, 100 PSAY "ASS: ______________________"
		nLin += 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	ENDIF   
	
		If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
		IF (TMP->RA_CC != cCustos) .AND. MV_PAR13 == 1
		nLin += 2
		@nLin, 001 PSAY "Total Centro de Custo -->"  
		@nLin, 027 PSAY SUBSTR(Posicione("CTT",1,xFilial("CTT")+ cCustos,"CTT_DESC01"),1,32)
		@nLin, 062 PSAY nItensCC	  PICTURE "@E 999"   
		//@nLin, 100 PSAY "ASS: ______________________"
		nLin += 1
		@nLin, 000 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	ENDIF
	 
	nLin 		+= 1 // Avanca a linha de impressao
	
ENDDO

@nLin, 001 PSAY UPPER("Total de Itens ") 
@nLin, 061 PSAY nItensTot PICTURE "@E 999"   

IF MV_PAR16 == 1

nLin 		+= 3

@nLin, 001 PSAY "    Ocorrendo desligamento por parte do colaborador ou pela empresa, todos os documentos, R�dio Nextel, Telefone Celular, uniforme," 
nLin 		+= 1
@nLin, 001 PSAY "crach�, equipamentos, ferramentas e os EPIs que pertence a emissora e estiver sob sua responsabilidade, dever� ser devolvido at�"
nLin 		+= 1
@nLin, 001 PSAY "a data prevista abaixo com ciencia na assinatura de seu desligamento, caso isso n�o ocorra os valores correspondentes ser�o " 
nLin 		+= 1
@nLin, 001 PSAY "descontados na rescis�o."
nLin 		+= 2
@nLin, 001 PSAY "Data prevista para devolu��o: _____/_____/________"
nLin 		+= 2
@nLin, 001 PSAY "Ciente:  _____/_____/________"      

ENDIF 

dbSelectArea("TMP")
dbCloseArea("TMP")                                                           
                    

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

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do  Funcionario	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Funcionario	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Do  Supervisor	","","","mv_ch03","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""}) // Campo Retirado
AADD(aRegs,{cPerg,"04","Ate Supervisor	","","","mv_ch04","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da  Emissao 	","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Emissao 	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"07","Da  EPI		    ","","","mv_ch07","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","TN3"})
AADD(aRegs,{cPerg,"08","Ate EPI			","","","mv_ch08","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","TN3"})
AADD(aRegs,{cPerg,"09","Ordem			","","","mv_ch09","N",01,0,2,"C","","mv_par09","Produto","","","","","Descricao","","","","","Dt Entrega","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Imprime:		","","","mv_ch10","N",01,0,2,"C","","mv_par10","Ambos","","","","","Devolvidos","","","","","Com Funcionario","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Da  Devolucao 	","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Devolucao 	","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"13","Totais por CC?  ","","","mv_ch13","N",01,0,2,"C","","mv_par13","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Do  Armazem	    ","","","mv_ch14","C",02,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Ate Armazem	    ","","","mv_ch15","C",02,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Termo Desligamento?","","","mv_ch16","N",01,0,2,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Filtro Descri��o:","","","mv_ch17","C",50,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","",""}) 

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
#INCLUDE "rwmake.ch"
#INCLUDE "FileIO.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  23/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADSZQ()

LOCAL aCores  		:= {;
{"ZQ_OK == 'S'","BR_VERDE"		},;
{"ZQ_OK == 'N'","BR_VERMELHO"	}}


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private nHdl
Private cFile		:= "C:\temp\DEPARAATU05.txt"
Private cCadastro 	:= "Cadastro De-Para"
Private lSql		:= .F.
Private aRotina 	:= { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5} ,;
{"Legenda","U_LegSZQ",0,6} ,;
{"Importar TXT","u_ImpDePara()",0,3},;
{"Processa 004","u_AltPlanoCtb()",0,3}}

Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString 	:= "SZQ"

dbSelectArea("SZQ")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �AltPlanoCTB �Autor  �Julio Cesar Nobre   � Data �  23/02/10   ���
���������������������������������������������������������������������������͹��
���Desc.     � Rotina de Alteracao dos dados do plano de contas (CT1)       ���
���          �baseado no cadastro efetuado na tabela ZZ1 (De-Para)          ���
���������������������������������������������������������������������������͹��
���Uso       � ARCA                                                         ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function AltPlanoCTB
Local cMsgInfo
Local cEol		:= Chr(13) + Chr(10)
Private aItens 	:= {}
Private cQuery 	:= ""

cMsgInfo := "A V I S O" + cEol + cEol
cMsgInfo += "ESTA ROTINA IRA EFETUAR DOIS PROCESSAMENTOS DISTINTOS" + cEol + cEol
cMsgInfo += "1 - Todas os campos do sistema que tenham controle pela tabela SXG" + cEol
cMsgInfo += "exceto a tabela CT5 (Lancamentos Padroes)." + cEol + cEol
cMsgInfo += "2 - A tabela CT5 sera processada separadamente, apenas nos campos" + cEol
cMsgInfo += "CT5_DEBITO e CT5_CREDIT, e somente para os registros da tabela" + cEol
cMsgInfo += "DE-PARA (SZQ) que tiverem apenas o campo SZQ_DE preenchido." + cEol + cEol

MsgInfo(cMsgInfo,"INFO")


If MsgYesNo("Deseja gravar LOG de auditoria da instrucao SQL que sera executada? (C:\De_ParaSQL.txt)")
	
	lSql := .T.
	
	nHdl := fCreate(cFile, FC_NORMAL)
	
	fClose(nHDL)
	
	nHdl := fOpen(cFile, FO_READWRITE)
	
Endif

// Captura todas tabelas que tem o X3_GRPSXG igual a 003 - Conta Contabil

Processa({|| LoadSx3Sxg()}, "Processando tabelas grupo 004")

Processa({|| AjustaTAB()},"Alterando tabelas...")

//Processa({|| AjustaCT5()},"Alterando lancamentos padroes...")

If lSql
	
	fClose(nHDL)
	
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LoadSX3SXG�Autor  �Julio Cesar Nobre   � Data �  23/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta array com os campos que contem o grupo de campos     ���
���          �de plano de contas em uso, inclusive de usuario.            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LoadSX3SXG()
Local	cGrupo  := "004" // C Custo  
Local	nTotReg := 0
Local	aAreaX3 := GetArea("SX3")

DbSelectArea("SX3")
DbSetOrder(3)
DbSeek(cGrupo)

While !Eof() .and. SX3->X3_GRPSXG == cGrupo
	
	nTotReg ++
	
	DbSkip()
	
End

IncProc(nTotReg)

dbGoTop()

DbSeek(cGrupo)

While !Eof() .and. SX3->X3_GRPSXG == cGrupo
	
	// Exclui a tabela CT5 - Lancamentos Padroes - A mesma necessita de tratamento diferenciado na rotina DE-PARA
	If SX3->X3_ARQUIVO $ "CTT%SH9" // Lancamentos Padroes e Plano de Contas sao processados separadamente - SH9 Problema na tabela.
	dbSkip()
	Loop
	//ELSE
	
   	Endif
	
	//If SX3->X3_ARQUIVO $ "CT2" // Caso queira processar apenas algumas tabelas utilize esse filtro.
		
		Aadd(aItens,{SX3->X3_ARQUIVO,SX3->X3_CAMPO})
		
		IncProc()
		
	//ENDIF
	
	DbSkip()
	
End

RestArea(aAreaX3)

aItens := Asort(aItens,,,{|x,y| x[1] < y[1]})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZQ    �Autor  �Microsiga           � Data �  02/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaTAB
Local nRegs := 0

dbSelectArea("SZQ")

dbGoTop()

While !eof()
	nRegs ++
	dbSkip()
End

nRegs := nRegs * Len(aItens)

ProcRegua(nRegs)

dbGoTop()

While !eof()
	
	If SZQ->ZQ_OK == "S"
		dbSkip()
		Loop
	Endif
	
	For k:=1 to Len(aItens)
		
		IncProc()
		
			cQuery := "UPDATE " + RetSqlName(aItens[k][1]) + " SET " + aItens[k][2] + " = '" + SZQ->ZQ_PARA + "' WHERE " + aItens[k][2] + " = '" + SZQ->ZQ_DE + "' AND D_E_L_E_T_ = '' "
		
		
		TcSqlExec(cQuery)
		
		If lSql
			
			fWrite(nHdl, cQuery + Chr(13) + Chr(10))
			
		Endif
		
		// Atualiza Tabela do Novo Plano de Contas
		//cQuery := "UPDATE " + RetSqlName("ZZ1") + " SET ZZ1_UPDOK = 'S' WHERE ZZ1_CODIGO = '" + SZQ->ZQ_PARA + "'"
		
		//tcSqlExec(cQuery)
		
	Next
	
	dbSelectArea("SZQ")
	
	RecLock("SZQ",.F.)
	
	SZQ->ZQ_OK := 'S'
	
	MsUnLock()
	
	dbSkip()
	
	k:=0
	
End

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZQ    �Autor  �Microsiga           � Data �  03/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LegSZQ
BrwLegenda("Legenda","Cadastro de Romaneios",{;
{ "BR_VERDE"    , "Registro processado"}	,;
{ "BR_VERMELHO"	, "Registro nao processado"}	})
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZQ    �Autor  �Microsiga           � Data �  03/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaCT5
Local cContaDe 	:= ""
Local cContaTo	:= ""
Local cConteudo	:= ""

dbSelectArea("SZQ")

dbGoTop()

While !eof()
	
	// Nao serao processados registros preenchidos DE e ATE, porque nao ha como localizar um registro que esteja dentro do range
	//If !Empty(SZQ->ZQ_ATE)
	
	//	dbSkip()
	
	//	Loop
	
	//Endif
	
	cContaDe := SZQ->ZQ_DE
	
	cContaTo := SZQ->ZQ_PARA
	
	dbSelectArea("CT5")
	
	dbGoTop()
	
	While !eof()
		
		If cContaDe $ CT5->CT5_DEBITO
			
			cConteudo := CT5->CT5_DEBITO
			
			cConteudo := StrTran(cConteudo,cContaDe,cContaTo)
			
			RecLock("CT5",.F.)
			
			CT5->CT5_DEBITO := cConteudo
			
			MsUnLock()
			
		Endif
		
		If cContaDe $ CT5->CT5_CREDIT
			
			cConteudo := CT5->CT5_CREDIT
			
			cConteudo := StrTran(cConteudo,cContaDe,cContaTo)
			
			RecLock("CT5",.F.)
			
			CT5->CT5_CREDIT := cConteudo
			
			MsUnLock()
			
		Endif
		
		dbSelectArea("CT5")
		
		dbSkip()
		
	End
	
	dbSelectArea("SZQ")
	
	dbSkip()
	
End

Return


/*
�����������������������������������������������������������������������������
������������������������������������������ADMIN�����������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZZ1    �Autor  �Microsiga           � Data �  02/23/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ImpDePara
Local cFile 	:= ""
Local cLinha 	:= FT_FReadLN()
Local cCodDe    := ""
Local cCodPara  := ""
Local cDesc		:= ""
Local cClasse	:= ""
Local cCond		:= ""

cFile := cGetFile("Arquivos CSV (*.CSV) | *.CSV", "Selecione o arquivo", 0, "C:\", .F., GETF_LOCALHARD, .F.)

MsgInfo("Importacao do arquivo com De - Para - Formato CSV","CADSZQ")

If !Empty(cFile)
	
	If MsgYesNo("Confirma importacao do arquivo " + AllTrim(cFile) + " ?")
		
		// remove os registros antes de efetuar a importacao de dados.
		If MsgYesNo("Deseja limpar a tabela De-Para?","CADSZQ")
			TcSqlExec("UPDATE " + RetSqlName("SZQ") + " SET D_E_L_E_T_ = '*'")
		EndIf
		
		FT_FUSE(cFile)
		
		FT_FGOTOP()
		
		While !FT_FEOF()
			
			cLinha 		:= FT_FReadLN()
			
			cCodDe		:= SubsTr(cLinha,1,At(";",cLinha)-1)
			
			cLinha		:= SubsTr(cLinha,At(";",cLinha)+1,Len(cLinha))
			
			cCodPara	:= SubsTr(cLinha,1,At(";",cLinha)-1)
			
			cLinha		:= SubsTr(cLinha,At(";",cLinha)+1,Len(cLinha))
			
			cCodDe 		:= StrTran(cCodDe,".","")
			cCodPara	:= StrTran(cCodPara,".","")
			
			If Len(cCodDe + cCodPara) > 2 // Caso seja linha em branco, veio como ";;;;"
				RecLock("SZQ",.T.)
				SZQ->ZQ_FILIAL 		:= xFilial("SZQ")
				SZQ->ZQ_DE    	 	:= cCodDe
				SZQ->ZQ_PARA	 	:= cCodPara
				SZQ->ZQ_OK			:= "N"
				MsUnLock()
			Endif
			
			FT_FSKIP()
			
		End
		
		FT_FUSE()
		
	Else
		
		MsgStop("Operacao cancelada!")
		
	Endif
	
Else
	
	MsgStop("Nao foi selecionado arquivo algum!")
	
Endif

dbSelectArea("SZQ")
dbGoTop()

Return

// #########################################################################################
// Projeto: Implantação eSocial
// Modulo : TAF
// Fonte  : TAFREL01
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/02/19 | Bruno Alves       | Relatório TAF - GPE vs TAF (S-1200 e S-1210) 
// ---------+-------------------+-----------------------------------------------------------
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"


User Function TAFREL01()	



	Private cDtDemissao := ""
	Private cDtPeriodo := ""
	Private nRec := 0
	Private cPerg	     := "TRGPER041" // Nome do grupo de perguntas na SX6.
	Private cQuery       := ""
	Private lMesAberto	 := .F.

	//Excel
	Private _aCExcel := {}
	Private _aIExcel := {}
	Private _lRet := .T.

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAÇÃO CANCELADA")
		return
	ENDIF

	cDtDemissao := SUBSTRING(DTOS(MONTHSUM(MV_PAR01,1)),1,6) + "01"
	cDtPeriodo  := Substring(DTOS(MV_PAR01),1,6)
	If MesAberto()// Verifica se o Mes está aberto ou fechado
		lMesAberto := .T.
	EndIf





	//----------------------------------------------------------------------
	//³ Processamento. Monta janela com a regua de processamento.
	//----------------------------------------------------------------------
	processa({|| BuscaFunc() },"Buscando informações no cadastro dos funcionários...")


Return	


Static Function BuscaFunc()

	procregua(1)

	IncProc("Buscando...")		


	cQuery := "SELECT RA_FILIAL,RA_DEMISSA,RA_SITFOLH,RA_ADMISSA,RA_CATEFD,RA_CIC,RA_MAT,RA_NOME,PERIODO,R8_MAT,C9V_ID,C9V_PROTUL,C91_PERAPU,C91_PROTUL,T3P_PROTUL FROM SRA010 " 
	cQuery += "LEFT JOIN C9V010 ON "
	cQuery += "C9V_FILIAL = RA_FILIAL AND "
	cQuery += "RA_CIC = C9V_CPF AND "
	cQuery += "C9V_PROTPN = '' AND "
	cQuery += "C9V010.D_E_L_E_T_ = '' " 

	cQuery += "LEFT JOIN C91010 ON "
	cQuery += "C91_FILIAL = C9V_FILIAL AND "
	cQuery += "C91_TRABAL = C9V_ID AND "
	cQuery += "C91_PERAPU = '" + cDtPeriodo + "' AND "
	cQuery += "C91_EVENTO <> 'E' AND "
	cQuery += "C91_ATIVO = '1' AND "
	cQuery += "C91010.D_E_L_E_T_ = '' "

	cQuery += "LEFT JOIN T3P010 ON "
	cQuery += "T3P_FILIAL = C9V_FILIAL AND "
	cQuery += "T3P_BENEFI = C9V_ID AND "
	cQuery += "T3P_PERAPU = '" + cDtPeriodo + "' AND "
	cQuery += "T3P_STATUS = '4' AND "
	cQuery += "T3P_EVENTO <> 'E' AND "
	cQuery += "T3P_ATIVO = '1' AND "
	cQuery += "T3P010.D_E_L_E_T_ = '' "

	//Responsavel por verificar se o periodo da folha de pagamento está aberto ou fechado
	If lMesAberto 

		cQuery += "LEFT JOIN (SELECT DISTINCT RC_FILIAL,RC_MAT,RC_PERIODO AS PERIODO FROM SRC010 WHERE RC_PERIODO = '" + cDtPeriodo + "' AND D_E_L_E_T_ = '') AS MOVIMENTO ON "
		cQuery += "MOVIMENTO.RC_FILIAL = RA_FILIAL AND "
		cQuery += "MOVIMENTO.RC_MAT = RA_MAT "

	Else 

		cQuery += "LEFT JOIN (SELECT DISTINCT RD_FILIAL,RD_MAT,RD_DATARQ AS PERIODO FROM SRD010 WHERE RD_DATARQ = '" + cDtPeriodo + "' AND D_E_L_E_T_ = '') AS MOVIMENTO ON "
		cQuery += "MOVIMENTO.RD_FILIAL = RA_FILIAL AND "
		cQuery += "MOVIMENTO.RD_MAT = RA_MAT "

	EndIf

	// Verifica os afastados por invalidez
	cQuery += "LEFT JOIN (SELECT R8_FILIAL,R8_MAT FROM SR8010 WHERE R8_TIPOAFA = '017' AND R8_DATAFIM >= '" + (cDtPeriodo + "01") + "' AND D_E_L_E_T_ = '') AS AFASTADO ON "
	cQuery += "AFASTADO.R8_FILIAL = RA_FILIAL AND "
	cQuery += "AFASTADO.R8_MAT = RA_MAT "

	cQuery += "WHERE "
	cQuery += "(RA_DEMISSA = '' OR RA_DEMISSA >= '" + cDtDemissao + "') AND " 
	cQuery += "RA_FILIAL BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' AND "
	cQuery += "RA_MAT BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' AND "
	cQuery += "SRA010.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY RA_FILIAL,RA_MAT "

	tcQuery cQuery New Alias "TMP"

	COUNT TO nRec // quantidade de registros

	TMP->(dbGoTop())

	If TMP->(Eof())
		MsgInfo("Nao existem dados a serem impressos!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return
	Endif

	processa({|| ExportExcel() },"Aplicando as regras para exportar as informações para o Excel...")

Return


Static Function ExportExcel()


	DbSelectArea("TMP")
	TMP->(dbGoTop())

	procregua(nRec)


	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(_aCExcel, {"FILIAL"				,"C", 5, 0})
	AADD(_aCExcel, {"DT DEMISSAO"			,"C", 10, 0})
	AADD(_aCExcel, {"AFASTAMENTO " 			,"C", 10, 0})
	AADD(_aCExcel, {"ADMISSAO" 				,"C", 10, 0})
	AADD(_aCExcel, {"CATEGORIA TAF"			,"C", 15, 0})
	AADD(_aCExcel, {"CPF"					,"C", 25, 0})
	AADD(_aCExcel, {"MATRICULA"				,"C", 12, 0})
	AADD(_aCExcel, {"NOME"					,"C", 40, 0})
	AADD(_aCExcel, {"MOVIMENTO"				,"C", 12, 0})
	AADD(_aCExcel, {"ID TAF"				,"C", 12, 0})
	AADD(_aCExcel, {"PROTOCOLO FUNCIONARIO"	,"C", 30, 0})
	AADD(_aCExcel, {"PROTOCOLO S1200"		,"C", 30, 0})
	AADD(_aCExcel, {"PROTOCOLO S1210"		,"C", 30, 0})


	While !TMP->(EOF())



		IncProc("Matricula: " + TMP->RA_MAT + " - Funcionario: " + TMP->RA_NOME + "")

		// Tratativa - Considera afastados
		If MV_PAR06 == 2
			If !Empty(TMP->R8_MAT)
				TMP->(dbSkip())
				Loop  
			EndIf
		EndIf

		// Tratativa - Considera movimentação
		If MV_PAR07 == 1
			If Empty(TMP->PERIODO)
				TMP->(dbSkip())
				Loop  
			EndIf
		EndIf




		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01] := Chr(160) + TMP->RA_FILIAL
		_aItem[02] := DTOC(STOD(TMP->RA_DEMISSA))
		_aItem[03] := Posicione("SX5",1,(xFilial("SX5")+"31"+TMP->RA_SITFOLH),"X5_DESCRI")
		_aItem[04] := DTOC(STOD(TMP->RA_ADMISSA))
		_aItem[05] := TMP->RA_CATEFD
		_aItem[06] := Chr(160) + TMP->RA_CIC
		_aItem[07] := Chr(160) + TMP->RA_MAT
		_aItem[08] := TMP->RA_NOME
		_aItem[09] := Chr(160) + TMP->PERIODO
		_aItem[10] := Chr(160) + TMP->C9V_ID
		_aItem[11] := TMP->C9V_PROTUL
		_aItem[12] := TMP->C91_PROTUL
		_aItem[13] := TMP->T3P_PROTUL			


		AADD(_aIExcel,_aItem)
		_aItem := {}


		TMP->(dbSkip())

	EndDo


	//-----------------------------------------------------------------------
	//³ Finaliza a execucao do relatorio...
	//-----------------------------------------------------------------------	

	cCab := "Validacao Gestao Pessoal vs TAF vs eSocial "

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", cCab, _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","TRGPER04")
		_lRet := .F.
	ENDIF	

	DBSelectArea("TMP")
	DBCloseArea("TMP")	

Return

//-----------------------------------------------------------------------
//³ Finaliza a execucao do relatorio...
//-----------------------------------------------------------------------



Static Function MesAberto()

	Local cQuery1 := ""
	Local lOk := .F.

	cQuery1 := "SELECT MAX(RFQ_DTFIM) AS PERIODO FROM RFQ010 WHERE RFQ_STATUS = '2' AND D_E_L_E_T_ = ''"

	tcQuery cQuery1 New Alias "TMP1"

	TMP1->(dbGoTop())

	//Verifica o ultimo dia fechado e soma mais 10 dias para passar pro proximo mes que é o periodo em aberto.
	//Após soma dos dias descubro qual o periodo em aberto e comparo com a data informada nos parametros do relatório
	If SUBSTRING(DTOS(DaySum(STOD(TMP1->PERIODO),10)),1,6) == cDtPeriodo
		lOk := .T.
	EndIf


	dbSelectArea("TMP1")
	dbCloseArea("TMP1")

Return(lOk)



Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Periodo?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Da Filial?","","","mv_ch02","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Ate Filial?","","","mv_ch03","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Da Matricula?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	AADD(aRegs,{cPerg,"05","Ate Matricula?","","","mv_ch05","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
	aAdd(aRegs,{cPerg,"06","Considera Afast.Invalidez?","","","mv_ch06","N",01,00,1,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Considera Movimentacao?","","","mv_ch07","N",01,00,1,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","",""})


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




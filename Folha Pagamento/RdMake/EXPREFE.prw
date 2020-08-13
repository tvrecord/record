#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLBPedido  บ Autor ณ Bruno Alves        บ Data ณ 06/04/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Informa ao usuario quais os pedidos que foram liberados    บฑฑ
ฑฑ          ฑฑ pelo aprovador informado nos parametros					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDEs                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EXPREFE

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Rela็ใo dos pedidos de vale de refeicao"
Local nLin           := 100
Local Cabec1         := ""
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private cTpVal		 := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "EXPREFE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "EXPREFE2"
Private cString      := "SRC"
Private cQuery       := ""
Private nVal		 := 0

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู



wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

IF MV_PAR02 == 1
cTpVal := "VR"
ELSEIF MV_PAR02 == 2             
cTpVal := "VA"
ELSEIF MV_PAR02 == 3
cTpVal := "CALI"
ENDIF



Cabec1         := "      Nome                                              CPF         Dt. Nasc Sexo  " + (cTpVal) + "     Tp Ent     Local Ent     Matricula"



//Imprimir relatorio com dados Financeiros ou de Clientes

cQuery := "SELECT RA_MAT,RA_NOME,RA_CIC,RA_NASC,RA_SEXO,ZO_VALOR,ZO_TPREF FROM SZO010 "
cQuery += "INNER JOIN SRA010 ON "
cQuery += "SRA010.RA_FILIAL = SZO010.ZO_FILIAL AND "
cQuery += "SRA010.RA_MAT = SZO010.ZO_MAT "
cQuery += "WHERE "
cQuery += "SRA010.D_E_L_E_T_ <> '*' AND "
cQuery += "SZO010.D_E_L_E_T_ <> '*' AND "
cQuery += "SZO010.ZO_MES = '" + SUBSTR(DTOS(MV_PAR01),5,2) + "' AND "
cQuery += "SZO010.ZO_ANO = '" + SUBSTR(DTOS(MV_PAR01),1,4) + "' AND "
cQuery += "SZO010.ZO_MAT BETWEEN '" + (MV_PAR03) + "' AND '" + (MV_PAR04) + "' AND "
cQuery += "SZO010.ZO_TPREF = '" + CvalTOChar(MV_PAR02) + "' "
cQuery += "ORDER BY ZO_NOME "



tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif                                      

If nLastKey == 27
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Imprime na tela ou Excel?
	If MV_PAR05 == 1
		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	Else
		RunExcel()
	EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


//Bruno Alves de Oliveira - 12/02/2020
//Implementado a impressใo em excel
Static Function RunExcel()


	//Excel
	Private _aCExcel := {}
	Private _aIExcel := {}
	Private _lRet := .T.


	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(_aCExcel, {"%"					 		,"C", 5, 0})  //01
	AADD(_aCExcel, {"NOME DO USUARIO"    		,"C", 60, 0}) //02
	AADD(_aCExcel, {"CPF" 				 		,"C", 30, 0}) //03
	AADD(_aCExcel, {"DATA DE NASCIMENTO" 		,"C", 20, 0}) //04
	AADD(_aCExcel, {"CODIGO SEXO"        	   	,"C", 15, 0}) //05
	AADD(_aCExcel, {cTpVal				 	   	,"N", 10, 2}) //06
	AADD(_aCExcel, {"TIPO DE LOCAL ENTREGA"    	,"C", 15, 0}) //07
	AADD(_aCExcel, {"LOCAL DE ENTREGA"		   	,"C", 10, 0}) //08
	AADD(_aCExcel, {"MATRICULA"				   	,"C", 15, 0}) //09
	AADD(_aCExcel, {"%"						   	,"C", 10, 0}) //10

	DBSelectArea("TMP")
	DBGotop()

	While !EOF()


		_aItem := ARRAY(LEN(_aCExcel) + 1)
		_aItem[01] := ""
		_aItem[02] := ALLTRIM(SUBSTR(TMP->RA_NOME,1,42))
		_aItem[03] := TMP->RA_CIC
		_aItem[04] := STOD(TMP->RA_NASC)
		_aItem[05] := TMP->RA_SEXO		
		_aItem[06] := TMP->ZO_VALOR
		_aItem[07] := "FI"
		_aItem[08] := "169"
		_aItem[09] := Chr(160) + TMP->RA_MAT
		_aItem[10] := ""

		AADD(_aIExcel,_aItem)
		_aItem := {}			


		DBSELECTAREA("TMP")	
		dbskip()	


	ENDDO


	//-----------------------------------------------------------------------
	//ณ Finaliza a execucao do relatorio...
	//-----------------------------------------------------------------------	

	cCab := "Rela็ใo dos pedidos de vale de refei็ใo"

	IF (LEN(_aIExcel) > 0)
		MSGRUN("Favor Aguardar...", "Exportando os Registros para o Excel",;
		{ ||CURSORWAIT(), DLGTOEXCEL( {{"GETDADOS", cCab, _aCExcel, _aIExcel}} ), CURSORARROW() } )
	ELSE
		MSGALERT("Nenhum Registro foi encontrado.","GPEREL001")
		_lRet := .F.
	ENDIF	


Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	SetRegua(RecCount())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	

	If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	

	@nLin, 000 PSAY "%"
	@nLin, 006 PSAY ALLTRIM(SUBSTR(TMP->RA_NOME,1,42))
	@nLin, 056 PSAY TMP->RA_CIC
	@nLin, 068 PSAY STOD(TMP->RA_NASC)
	@nLin, 078 PSAY TMP->RA_SEXO
	@nLin, 082 PSAY TMP->ZO_VALOR PICTURE "@E 999,999.99"
	@nLin, 094 PSAY "FI"
	@nLin, 106 PSAY "169"
	@nLin, 118 PSAY TMP->RA_MAT
	@nLin, 127 PSAY "%"
   

	dbskip()
	
	nLin 			+= 1 // Avanca a linha de impressao 


ENDDO



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

DBSelectArea("TMP")
DBCloseArea("TMP")

Return




Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Dt Pagamento ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Tp Refeicao ?","","","mv_ch02","N",01,0,2,"C","","mv_par02","Refeicao","","","","","Alimentacao","","","","","Cesta Alimenta็ใo","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Matricula De ?","","","mv_ch03","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"04","Matricula Ate ?","","","mv_ch04","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
aAdd(aRegs,{cPerg,"05","Tp Impressao?   	","","","mv_ch05","N",01,00,1,"C","","mv_par05","Tela","","","","","Excel","","","","","","","","","","","","","","","","","","","" })




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
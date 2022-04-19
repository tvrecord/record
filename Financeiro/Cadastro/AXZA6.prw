#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAXZA6     บ Autor ณ BRUNO ALVES        บ Data ณ  15/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CADASTRO DE PREVISAO PARA ALIMENTAR O FLUXO                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AXZA6

Private cPerg := "AXZA6"
Private cQuery       := ""
Private cCadastro := "Cadastro de Previsao"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","AxInclui",0,3,} ,;
{"Alterar","AxAltera",0,4} ,;
{"Excluir","AxDeleta",0,5},;
{"Duplicar","u_Duplicar()",0,2},;
{"Relatorio de Duplicidade","u_DUPREV()",0,2}}


Private cString := "ZA6"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,)

Return


User Function Duplicar()

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF


cQuery := "SELECT * FROM ZA6010 WHERE "
cQuery += "ZA6_MES = '" + (MV_PAR01) + "' AND "
cQuery += "ZA6_ANO = '" + (MV_PAR02) + "' AND "
cQuery += "D_E_L_E_T_ <> '*' "

tcQuery cQuery New Alias "TMP"

If Eof()
	MsgInfo("Nao existem dados a serem duplicados, verifique os parametros.","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If LEN(ALLTRIM(MV_PAR03)) < 2 .OR. LEN(ALLTRIM(MV_PAR04)) < 4
	MsgInfo("O Parametro PARA MES deve conter 2 digitos e o parametro PARA ANO deve conter 4 digitos.","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
EndIf


DBSelectArea("ZA6")
DBSetOrder(2)
iF(DBSeek(TMP->ZA6_FILIAL + MV_PAR03 + MV_PAR04))
	Alert("Jแ existe registro no periodo informado nos parametros, favor altera-los")
	Return
EndIf





DBSelectARea("TMP")
DBGotop()

While !EOF()

	dVenc 	  := STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2))
	dVencR1   := DATAVALIDA(STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2)))

	If EMPTY(dVenc)   // Se a data nใo existir

		dVenc 		:= LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01"))
		dVencR1	    := DATAVALIDA(LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01")))

		If SUBSTR(DTOC(dVencR1),4,2) != MV_PAR03

			FOR i:= 1 to 10

				if SUBSTR(DTOC((LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01"))) -i ) ,4,2) == MV_PAR03
					if SUBSTR(DTOC(DATAVALIDA((LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01"))) - i)),4,2) == MV_PAR03 // VERIFICA SE REALMENTE ษ O ULTIMA DIA UTIL DO MES

						dVenc 	  := DATAVALIDA((LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01"))) - i)
						dVencR1   := DATAVALIDA((LASTDATE(STOD(MV_PAR04 + MV_PAR03 + "01"))) - i)

						Exit
					EndIf

				EndIf

			next

		Endif



	ELSE // VERIFICA SE A DATA ษ O ULTIMO DIA UTIL DO MES SEM PULAR PARA O PROXIMO MES CORRENTE


		If SUBSTR(DTOC(dVencR1),4,2) != MV_PAR03

			FOR i:= 1 to 10

				if SUBSTR(DTOC(((STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2))) - i)),4,2) == MV_PAR03
					if SUBSTR(DTOC(DATAVALIDA((STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2))) - i)),4,2) == MV_PAR03

						dVenc 	  := DATAVALIDA((STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2))) - i)
						dVencR1   := DATAVALIDA((STOD(MV_PAR04 + MV_PAR03 + SUBSTR(TMP->ZA6_VENC,7,2))) - i)

						Exit
					EndIf
				Endif

			next

		Endif

	ENDIF


	Reclock("ZA6",.T.)
	ZA6_FILIAL  := TMP->ZA6_FILIAL
	ZA6_CODIGO  := EXECBLOCK("ZA6NUMSEQ")
	ZA6_MES     := MV_PAR03
	ZA6_ANO     := MV_PAR04
	ZA6_NATURE  := TMP->ZA6_NATURE
	ZA6_NMNAT   := TMP->ZA6_NMNAT
	ZA6_FORNEC  := TMP->ZA6_FORNEC
	ZA6_LOJA    := TMP->ZA6_LOJA
	ZA6_NMFOR   := TMP->ZA6_NMFOR
	ZA6_VENC    := dVenc
	ZA6_VENCRE  := dVencR1
	ZA6_VALOR   := TMP->ZA6_VALOR
	ZA6_HIST    := TMP->ZA6_HIST
	ZA6_NATGER  := POSICIONE("SED",1,xFilial("SED")+TMP->ZA6_NATURE,"ED_NATGER")
	MsUnlock()

	dbSelectArea("TMP")
	DBSkip()


EndDo

dbSelectArea("TMP")
dbCloseArea("TMP")

MsgInfo("Duplica็ใo realizada com sucesso!!")

Return


Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}


AADD(aRegs,{cPerg,"01","Duplicar Mes ?","","","mv_ch01","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Duplicar Ano ?","","","mv_ch02","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Para Mes  	 ?","","","mv_ch03","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Para Ano     ?","","","mv_ch04","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})



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

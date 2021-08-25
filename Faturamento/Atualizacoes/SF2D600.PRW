#include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2D600    บAutor  ณBruno Alves         บ Data ณ  04/11/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInseri linha no complemento da nota fiscal de saida.        บฑฑ
ฑฑบ          ณ para gerar o arquivo d600 e d605 no arquvi sped pis/cofins บฑฑ
บฑฑ             (Comunica็ใo e Telecomunica็ใo)                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF2D600

	Local nRec := 0
	Local cQuery := ""
	Local cPerg	     := "SF2D600"


	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		alert("OPERAวรO CANCELADA")
	return
	ENDIF

	Processa({|| Ajustar()},"Ajustando linha d600 e d605....")

Return

Static Function Ajustar()


	cQuery	:= "SELECT F2_FILIAL,F2_SERIE,F2_DOC,(SELECT FX_DOC FROM SFX010 WHERE FX_DOC = F2_DOC AND FX_CLIFOR = F2_CLIENTE AND D_E_L_E_T_ <> '*') AS FXDOC, "
	cQuery	+= "F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_VALBRUT,F2_VALFAT,F2_ESPECIE,D2_PEDIDO,D2_COD FROM SF2010 "
	cQuery	+= "INNER JOIN SD2010 ON "
	cQuery	+= "D2_DOC = F2_DOC AND "
	cQuery	+= "D2_SERIE = F2_SERIE AND "
	cQuery	+= "D2_CLIENTE = F2_CLIENTE "
	cQuery	+= "WHERE "
	cQuery	+= "F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND "
	cQuery	+= "SF2010.D_E_L_E_T_ <> '*' AND "
	cQuery	+= "SD2010.D_E_L_E_T_ <> '*' AND "
	cQuery	+= "F2_ESPECIE IN ('NFSC','NTSC') "
	cQuery	+= "ORDER BY F2_EMISSAO,F2_DOC "

	TcQuery cQuery New Alias "TMP"

	COUNT TO nRec

	dbSelectArea("TMP")
	dbGoTop()

	If Eof()
		MsgInfo("Nao existem dados a serem ajustados!","Verifique")
		dbSelectArea("TMP")
		dbCloseArea("TMP")
	Return
	Endif


	procregua(nRec)

	While !TMP->(Eof())

		IncProc("Ajustando linha d600 e d605....")

		If EMPTY(TMP->FXDOC)

			RecLock("SFX",.T.)
			SFX->FX_FILIAL 		:= TMP->F2_FILIAL
			SFX->FX_TIPOMOV    	:= "S"
			SFX->FX_DOC        	:=	TMP->F2_DOC
			SFX->FX_SERIE      	:=  TMP->F2_SERIE
			SFX->FX_LOJA       	:=  TMP->F2_LOJA
			SFX->FX_CLASCON 	:= "99"
			SFX->FX_TIPSERV 	:= "9"
			SFX->FX_CLIFOR    	:= TMP->F2_CLIENTE
			SFX->FX_ITEM       	:= "01"
			SFX->FX_COD        	:= TMP->D2_COD
			SFX->FX_GRPCLAS 	:= "10"
			SFX->FX_CLASSIF 	:= "99"
			SFX->FX_RECEP 		:= TMP->F2_CLIENTE
			SFX->FX_LOJAREC    	:= TMP->F2_LOJA
			SFX->FX_TIPOREC    	:= "0"
			SFX->FX_DTINI    	:= Posicione("SC5",1,xFilial("SC5") + TMP->D2_PEDIDO, "C5_PREFINI")
			SFX->FX_DTFIM    	:= Posicione("SC5",1,xFilial("SC5") + TMP->D2_PEDIDO, "C5_PREFFIM")
			SFX->FX_PERFIS    	:= SUBSTR(TMP->F2_EMISSAO,5,2) + SUBSTR(TMP->F2_EMISSAO,1,4)
			SFX->FX_AREATER    	:= "21"
			SFX->FX_TERMINA    	:= "0000000000"
			//SFX->FX_TPASSIN    	:= "1"
			SFX->(MSUNLOCK())

		EndIf

		TMP->(dbSkip())

	EndDo


	MsgInfo("Notas Fiscais Ajustadas com sucesso!!!")
	dbCloseArea("TMP")

Return


Static Function ValidPerg(cPerg)

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Da  Emissao ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Ate Emissao ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

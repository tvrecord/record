#INCLUDE "rwmake.ch"      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BTCTB009  ºAutor  ³Microsiga           º Data ³  1          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BTCT010A() // 13/04/12 Rafael França - Programa revisado para atender a nova condição da Record

Local _cNatuImpo:= AllTrim(GetMv("MV_PISNAT"))+","+AllTrim(GetMv("MV_COFINS"))+","+AllTrim(GetMv("MV_CSLL"))
Local _cContEnco:= "" 
Local _nCheque := SEF->EF_NUM
Local _Prefixo := SEF->EF_PREFIXO
Local _Parcela := SEF->EF_PARCELA
Local _nVlTit  := SEF->EF_VALOR
Local _nFornece:= SEF->EF_FORNECE
Local _Loja    := SEF->EF_LOJA 
Local _Titulo  := SEF->EF_TITULO
Local _Tipo    := SEF->EF_TIPO
Local _OrigCheq:= ORIGCHEQ

_aArea := GetArea()
//adicionado isto, pois estava com a tabela desposicionada.
DBSELECTAREA("SA2")
_aOrdSA2 := IndexOrd()
_aRecSA2 := Recno()

DBSELECTAREA("SE2")
_aOrdSE2 := IndexOrd()
_aRecSE2 := Recno()

DBSELECTAREA("SE1")
_aOrdSE1 := IndexOrd()
_aRecSE1 := Recno()

DBSELECTAREA("SE5")
_aOrdSE5 := IndexOrd()
_aRecSE5 := Recno()

DBSELECTAREA("SEF")
_aOrdSEF := IndexOrd()
_aRecSEF := Recno() 

//EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE+EF_LOJA     (8)                                                                                                               
//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA        (1)
DbSelectArea("SA2")
DBSETORDER(1)
IF !EMPTY(_nCheque)
   SA2->(DBSEEK(xFilial("SA2")+_nFornece+_Loja))
   DBSELECTAREA("SE2")
   DBSETORDER(1)
   DBSEEK(xFilial("SE2")+_Prefixo+_Titulo+_Parcela+_Tipo+_nFornece+_Loja)
ELSE
	IF ALLTRIM(_OrigCheq) <> "FINA190"
		DBSELECTAREA("SE2")
		DBSETORDER(17) 	//INDICE DE CHEQUE PARA SER UTILIZADO NO LP 590 QUANDO FOR BAIXA ATRAVÉS DA IMPRESSAO DE CHEQUE
		DBSEEK(xFilial("SE2")+NUMCHEQUE)
		IF Found()
		   DBSELECTAREA("SA2")
		   DBSETORDER(1)
		   SA2->(DBSEEK(xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA)) 
		   //SA2->(DBSEEK("  "+_nFornece+_Loja) )
		ENDIF	
	ENDIF
ENDIF

If AllTrim(SE2->e2_tipo) == "PA"
	_cContEnco := SA6->a6_conta
Else
	Do Case
		Case AllTrim(SE2->e2_naturez)$_cNatuImpo
			_cContEnco := "215010011"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_INSS"))
			_cContEnco := "214040001"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_ISS"))
			_cContEnco := "215010005"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_IRF"))
			_cContEnco := "215010004"
			//IRRF PF A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1201005"
			_cContEnco := "215010001"
			// IRRF ASSALARIADO
		Case AllTrim(SE2->e2_naturez)=="1203009"
			_cContEnco := "215010003"
			// ISS PF
		Case AllTrim(SE2->e2_naturez)=="1203012"
			_cContEnco := "215010005"
			// INSS A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1203007"
			_cContEnco := "214040001"
			// FGTS A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1203008"
			_cContEnco := "214040002"
			// SALARIO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201001" .AND. SE2->E2_FORNECE == "000131"
			_cContEnco := "214010001"
			//RESCISOES A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201012"
			_cContEnco := "214010002"
			//PENSAO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201016"
			_cContEnco := "214010003"
			//INDENIZACAO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1203015"
			_cContEnco := "214010004"
			//PRO-LABORE
		Case AllTrim(SE2->e2_naturez)=="1201006" //PRO LABORE
			_cContEnco := "214020001"
		Case AllTrim(SE2->e2_naturez)=="1201003"// FERIAS
			_cContEnco := "112040002"
		Case AllTrim(SE2->e2_naturez)=="1201004" //13 SALARIO
			_cContEnco := "112040003"
		Case AllTrim(SE2->e2_naturez)=="1203001" //COFINS S/FATURAMENTO
			_cContEnco := "215010007"
		Case AllTrim(SE2->e2_naturez)=="1203002" //PIS S/FATURAMENTO
			_cContEnco := "215010006"
		Case AllTrim(SE2->e2_naturez)=="1203003" //IRPJ EMPRESA
			_cContEnco := "215010001"
		Case AllTrim(SE2->e2_naturez)=="1203005" //IRPJ EMPRESA
			_cContEnco := "215010002"
		Case AllTrim(SE2->e2_naturez)=="1205007" //SEGUROS
			_cContEnco := "217020011"
		//Case AllTrim(SE2->e2_naturez)=="1202006" //MULTAS DE TRANSITO   13/04/12 Rafael França -> Não se aplica mais
		//	_cContEnco := "461200005"
		Case Alltrim(SE2->E2_TIPO)   =="FI"
			_cContEnco := "212010001"
		Case AllTrim(SE2->E2_NATUREZ)$"1202005,1203022" //IPVA ou IPTU
			_cContEnco := "211010126"
		Case AllTrim(SE2->E2_NATUREZ)$"1203013" //Outros Tributos
			_cContEnco := "211010263"
		OtherWise
			_cContEnco := SA2->A2_CONTA // POSICIONE("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
	EndCase
EndIf      

DBSELECTAREA("SA2")
DBSETORDER(_aOrdSA2) 
DBGOTO(_aRecSA2)

DBSELECTAREA("SE2")
DBSETORDER(_aOrdSE2) 
DBGOTO(_aRecSE2)

DBSELECTAREA("SE1")
DBSETORDER(_aOrdSE1) 
DBGOTO(_aRecSE1)
                
DBSELECTAREA("SE5")
DBSETORDER(_aOrdSE5) 
DBGOTO(_aRecSE5)
               
DBSELECTAREA("SEF")
DBSETORDER(_aOrdSEF) 
DBGOTO(_aRecSEF)

_aArea	:= RestArea(_aArea)

Return(_cContEnco)
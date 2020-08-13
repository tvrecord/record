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

User Function BTCTB009()

Local _cNatuImpo := AllTrim(GetMv("MV_PISNAT"))+","+AllTrim(GetMv("MV_COFINS"))+","+AllTrim(GetMv("MV_CSLL"))
Local _cContEnco := "" 

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If AllTrim(SE2->e2_tipo) == "PA"
	_cContEnco := SA6->a6_conta
Else
	Do Case
		Case AllTrim(SE2->e2_naturez)$_cNatuImpo
			_cContEnco := "215200005"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_INSS"))//pendente
   //			_cContEnco := "216100001"
   			_cContEnco := "216100004"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_ISS"))
//			_cContEnco := "215030001"
			_cContEnco := "215200001"
		Case AllTrim(SE2->e2_naturez)$AllTrim(GetMv("MV_IRF"))
			_cContEnco := "215100005"
            //INSS FOLHA DE PAGAMENTO
		Case AllTrim(SE2->e2_naturez)=="1201022"
			_cContEnco := "216100001"			
   			//IRRF PF A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1201005"
			_cContEnco := "215100003"
			// IRRF ASSALARIADO
		Case AllTrim(SE2->e2_naturez)=="1203009"
			_cContEnco := "215100001"
			// ISS PF
		Case AllTrim(SE2->e2_naturez)=="1203012"
			_cContEnco := "215030001"
			// INSS A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1203007"
			_cContEnco := "216100001"
			// FGTS A RECOLHER
		Case AllTrim(SE2->e2_naturez)=="1203008"
			_cContEnco := "216100002"
			// SALARIO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201001" .AND. SE2->E2_FORNECE == "000131"
			_cContEnco := "216010001"
			//RESCISOES A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201012"
			_cContEnco := "216010004"
			//PENSAO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1201016"
			_cContEnco := "216010007"
			//INDENIZACAO A PAGAR
		Case AllTrim(SE2->e2_naturez)=="1203015"
			_cContEnco := "216010002"
			//PRO-LABORE
		Case AllTrim(SE2->e2_naturez)=="1201006" //PRO LABORE
//			_cContEnco := "216010002"
			_cContEnco := "217460001"
		Case AllTrim(SE2->e2_naturez)=="1201003"// FERIAS
			_cContEnco := "115100002"
		Case AllTrim(SE2->e2_naturez)=="1201004" //13 SALARIO
			_cContEnco := "115100003"
		Case AllTrim(SE2->e2_naturez)=="1203001" //COFINS S/FATURAMENTO
			_cContEnco := "215150003"
		Case AllTrim(SE2->e2_naturez)=="1203002" //PIS S/FATURAMENTO
			_cContEnco := "215150001"
		Case AllTrim(SE2->e2_naturez)=="1203003" //IRPJ EMPRESA
			_cContEnco := "215100003"
		Case AllTrim(SE2->e2_naturez)=="1203005" //IRPJ EMPRESA
			_cContEnco := "215100003"
//		Case AllTrim(SE2->e2_naturez)=="1205007" //SEGUROS: INSERIR NA CONTA DO FORNECEDOR 10/01/2013 DECISÃO DA EURILENE E PASQUALLE
//			_cContEnco := "217020011"
		Case AllTrim(SE2->e2_naturez)=="1202006" //MULTAS DE TRANSITO
			_cContEnco := "471900001"
		//Case Alltrim(SE2->E2_TIPO)   =="FI"
		//	_cContEnco := "212010001"
//		Case AllTrim(SE2->E2_NATUREZ)$"1202005,1203022" //IPVA ou IPTU    // Retirado no dia 29/05/2014 a pedido da Eurilene via TELEFONA as 11:25h
//			_cContEnco := "211010126"
		Case AllTrim(SE2->E2_NATUREZ)$"1203013" //Outros Tributos
			_cContEnco := "211010263"
		OtherWise
			_cContEnco := SA2->A2_CONTA
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
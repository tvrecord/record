#INCLUDE "rwmake.ch"     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA020ALT  º Autor ³ Fabricio             º Data ³ 25/10/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica preenchimento nao preenchimento do CGC para       º±±
±±º          ³ fornecedores do exterior                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - disparado na alteração                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  

User Function MA020ALT()

Local _lRetorno := .T.

If M->A2_TIPO<>"X" .AND. EMPTY(M->A2_CGC)
	MsgBox("Quando fornecedor NAO for TIPO=X o campo CGC deve ser informado! ","Verifique!","INFO")
	_lRetorno := .F. 
Endif

Do Case 
  Case (M->A2_EST=="EX" .and. M->A2_TIPO <> "X") .or. (M->A2_EST<>"EX" .and. M->A2_TIPO == "X")
    MsgBox("Quando o fornecedor for extrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!")//Mensagem alterada por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.
  Case (M->A2_EST=="EX" .and. M->A2_TIPO == "X" .and. EMPTY(M->A2_BAIRRO)) .or. (M->A2_EST=="EX" .and. M->A2_TIPO == "X" .and. EMPTY(M->A2_CEP))
    MsgBox("Quando o fornecedor for extrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!") //Condicao inclusa por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.  
  Case M->A2_EST<>"EX" .and. EMPTY(M->A2_MUN) 
    MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Municipio")
   	_lRetorno := .F.  
   	
/*  
	Case M->A2_EST<>"EX" .and. EMPTY(M->A2_BAIRRO) 
    MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Bairro")     Bairro e CEP passaram a ser obrigatorios mesmo
   	_lRetorno := .F.                                                                          para fornecedores extrangeiros
  Case M->A2_EST<>"EX" .and. EMPTY(M->A2_CEP) 
    MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: CEP")
   	_lRetorno := .F.  
*/         

  Case M->A2_EST<>"EX" .and. EMPTY(M->A2_COD_MUN) 
    MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Cod. Municipio")
   	_lRetorno := .F.
EndCase

If !EMPTY(M->A2_BANCO) .OR. !EMPTY(M->A2_AGENCIA) .OR. !EMPTY(M->A2_DGAGEN) .OR. !EMPTY(M->A2_NUMCON) .OR. !EMPTY(M->A2_DGCONTA) .OR. !EMPTY(M->A2_DESCBAN)
	If EMPTY(M->A2_BANCO) .OR. EMPTY(M->A2_AGENCIA) .OR. EMPTY(M->A2_DGAGEN) .OR. EMPTY(M->A2_NUMCON) .OR. EMPTY(M->A2_DGCONTA) .OR. EMPTY(M->A2_DESCBAN)
		MsgBox("Quando os dados bancarios do fornecedor forem preenchidos, é obirgatório alimentar os seguintes campos: Agencia, Digito da Agencia, Conta e Digito da Conta")
		_lRetorno := .F.
	EndIf
EndIf

Return(_lRetorno)
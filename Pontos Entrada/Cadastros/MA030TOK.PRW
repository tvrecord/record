#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK  º Autor ³ Fabricio           º Data ³  23/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica preenchomento dos cadastros basicos obrigatorios  º±±
±±º          ³ ao livro eletronico                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - disparado na inclusao                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA030TOK()
Local _lRetorno := .T.
If M->A1_TIPO<>"X" .AND. EMPTY(M->A1_CGC)
	MsgBox("Quando cliente NAO for TIPO=X o CGC deve ser informado! ","Verifique!","INFO")
	_lRetorno := .F.  
Endif

Do Case 
  Case (M->A1_EST=="EX" .and. M->A1_TIPO <> "X") .or. (M->A1_EST<>"EX" .and. M->A1_TIPO == "X")
    MsgBox("Quando o cliente for extrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!")//Mensagem alterada por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.  
  Case (M->A1_EST=="EX" .and. M->A1_TIPO == "X" .and. EMPTY(M->A1_BAIRRO)) .or. (M->A1_EST=="EX" .and. M->A1_TIPO == "X" .and. EMPTY(M->A1_CEP))
    MsgBox("Quando o cliente for extrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!") //Condicao inclusa por Marcio T. Suzaki em 23/04/08
   	_lRetorno := .F.  
  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_MUN) 
    MsgBox("Quando cliente NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio")
   	_lRetorno := .F.  
/*  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_BAIRRO) 
    MsgBox("Quando cliente NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio") Bairro e CEP passaram a ser obrigatorios mesmo 
   	_lRetorno := .F.                                                                                       para clientes extrangeiros
  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_CEP) 
    MsgBox("Quando cliente NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio")
   	_lRetorno := .F.  */
  Case M->A1_EST<>"EX" .and. EMPTY(M->A1_COD_MUN) 
    MsgBox("Quando cliente NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio")
   	_lRetorno := .F.  
   	
   	
   	
EndCase

Return(_lRetorno)
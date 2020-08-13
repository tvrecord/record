#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA020TOK  º Autor ³ Fabricio           º Data ³  23/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica preenchimento da inscr.INSS quando pessoa fisica  º±±
±±º          ³                                                       ?     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico - disparado na inclusao                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC

User Function MA020TOK()

Private _lRetorno := .T.

If M->A2_TIPO<>"X" .AND. EMPTY(M->A2_CGC)
	MsgBox("Quando fornecedor NAO for TIPO=X o CGC deve ser informado! ","Verifique!","INFO")
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
		MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio!")
		_lRetorno := .F.
		/*  Case M->A2_EST<>"EX" .and. EMPTY(M->A2_BAIRRO)
		MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio!") Bairro e CEP passaram a ser obrigatorios mesmo
		_lRetorno := .F.                                                                                           para fornecedores extrangeiros
		Case M->A2_EST<>"EX" .and. EMPTY(M->A2_CEP)
		MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio!")
		_lRetorno := .F.          */
	Case M->A2_EST<>"EX" .and. EMPTY(M->A2_COD_MUN)
		MsgBox("Quando fornecedor NAO for do exterior ESTADO=EX, deve ser informado: Municipio e Cod. Municipio!")
		_lRetorno := .F.
EndCase

If (M->A2_PENS == "1")
	IF (EMPTY(M->A2_AGENCIA) .OR. EMPTY(M->A2_NUMCON) .OR. EMPTY(M->A2_TPPAG) .OR. EMPTY(M->A2_TPCTFOR))
		MsgBox("Quando o fornecedor for PENSIONISTA, o preenchimento dos campos: Agencia, Conta e Tipo Conta são obrigatórios")
		_lRetorno := .F.
	Endif
ENDIF

If !EMPTY(M->A2_AGENCIA)
	If LEN(ALLTRIM(M->A2_AGENCIA)) != 5
		MsgBox("É preciso inserir o digito da agencia no campo AGENCIA")
		_lRetorno := .F.
	EndIf
EndIf

If !EMPTY(M->A2_BANCO) .OR. !EMPTY(M->A2_AGENCIA) .OR. !EMPTY(M->A2_DGAGEN) .OR. !EMPTY(M->A2_NUMCON) .OR. !EMPTY(M->A2_DGCONTA) .OR. !EMPTY(M->A2_DESCBAN)
	If EMPTY(M->A2_BANCO) .OR. EMPTY(M->A2_AGENCIA) .OR. EMPTY(M->A2_DGAGEN) .OR. EMPTY(M->A2_NUMCON) .OR. EMPTY(M->A2_DGCONTA) .OR. EMPTY(M->A2_DESCBAN)
		MsgBox("Quando os dados bancarios do fornecedor forem preenchidos, é obirgatório alimentar os seguintes campos: Agencia, Digito da Agencia, Conta e Digito da Conta")
		_lRetorno := .F.
	EndIf
EndIf

//Cadastra conta cotabil do fornecedor.

IF _lRetorno 

//M->A2_CONTA := '211' + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4)
	
	ModelCT1()
	
ENDIF

Return(_lRetorno)


//Exemplo de rotina automática para inclusão de contas contábeis no ambiente Contabilidade Gerencial (SigaCTB).
/// ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB     

Static Function ModelCT1() 

Local nOpcAuto :=0
Local nX
Local oCT1
Local aLog
Local cLog :=""
Local lRet := .T.

If __oModelAut == Nil //somente uma unica vez carrega o modelo CTBA020-Plano de Contas CT1
	__oModelAut := FWLoadModel('CTBA020')
EndIf

nOpcAuto:=3

__oModelAut:SetOperation(nOpcAuto) // 3 - Inclusão | 4 - Alteração | 5 - Exclusão
__oModelAut:Activate() //ativa modelo

//---------------------------------------------------------
// Preencho os valores da CT1
//---------------------------------------------------------

oCT1 := __oModelAut:GetModel('CT1MASTER') //Objeto similar enchoice CT1
oCT1:SETVALUE('CT1_CONTA','211' + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4))
oCT1:SETVALUE('CT1_DESC01',SUBSTR(M->A2_NOME,1,40))
oCT1:SETVALUE('CT1_CLASSE','2')
oCT1:SETVALUE('CT1_NORMAL' ,'2')
oCT1:SETVALUE('CT1_NTSPED','02') 
oCT1:SETVALUE('CT1_INDNAT','2') 

//---------------------------------------------------------
// Preencho os valores da CVD
//---------------------------------------------------------

oCVD := __oModelAut:GetModel('CVDDETAIL') //Objeto similar getdados CVD
oCVD:SETVALUE('CVD_FILIAL' ,xFilial('CVD')) 
//oCVD:SETVALUE('CVD_CONTA','211' + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4))
oCVD:SETVALUE('CVD_ENTREF','10')
oCVD:SETVALUE('CVD_CODPLA','003')
oCVD:SETVALUE('CVD_CTAREF','2.01.01.01.00')
oCVD:SETVALUE('CVD_TPUTIL','A')
oCVD:SETVALUE('CVD_CLASSE','2')
//oCVD:SETVALUE('CVD_VERSAO',)
//oCVD:SETVALUE('CVD_CUSTO' ,)

//---------------------------------------------------------
// Preencho os valores da CTS
//---------------------------------------------------------


//oCTS := __oModelAut:GetModel('CTSDETAIL') //Objeto similar getdados CTS
//oCTS:SETVALUE('CTS_FILIAL' ,CTS->(xFilial('CTS')))
//oCTS:SETVALUE('CTS_CODPLA' ,'001')
//oCTS:SETVALUE('CTS_CONTAG' ,'0000021')


If __oModelAut:VldData() //validacao dos dados pelo modelo
	
	__oModelAut:CommitData() //gravacao dos dados
	
Else
	
	aLog := __oModelAut:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData
	
	//laco para gravar em string cLog conteudo do array aLog
	For nX := 1 to Len(aLog)
		If !Empty(aLog[nX])
			cLog += Alltrim(aLog[nX]) + CRLF
		EndIf
	Next nX
	
	lMsErroAuto := .T. //seta variavel private como erro
	AutoGRLog(cLog) //grava log para exibir com funcao mostraerro
	mostraerro()
	lRet := .F. //retorna false
	
EndIf

__oModelAut:DeActivate() //desativa modelo

//SA2->A2_CONTA := "211" + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4)

AVISOFOR1()//Manda e-mail avisando a contabilidade

Return( lRet )

//Manda e-mail avisando a contabilidade

Static Function AVISOFOR1()

Local lOk
Local cBody 	:= ""
Local cEmail  	:= ""
Local cTitulo	:= ""

cEmail := "rfranca@recordtvdf.com.br;contabilidade@recordtvdf.com.br;wsbezerra@recordtvdf.com.br"//;Controladoria@recordtvdf.com.br;Almoxarifado@recordtvdf.com.br;COMPRAS@recordtvdf.com.br;jdosilva@recordtvdf.com.br"
cTitulo	:= 	"Um novo Fornecedor foi incluído! " //+ SZP->ZP_COD + ""

cBody   += "Codigo: " + M->A2_COD + "" + Chr(13) + Chr(10)
cBody 	+= "Descrição: " + M->A2_NOME + "" + Chr(13) + Chr(10)
cBody 	+= "Grupo: " + M->A2_GRUPC + " - " + ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZU" + M->A2_GRUPC,"X5_DESCRI")) + "" + Chr(13) + Chr(10) 	+ Chr(13) + Chr(10)  + Chr(13) + Chr(10)  + Chr(13) + Chr(10)  + Chr(13) + Chr(10)

// Conecta com o Servidor SMTP
CONNECT SMTP SERVER "Outlook.office365.com" ; //"smtp.recordtvdf.com.br" ;
ACCOUNT "microsiga" PASSWORD "record@10" ;
RESULT lOk
If lOk
	//   MsgStop( "Conexão OK" )
	SEND MAIL FROM "microsiga@recordtvdf.com.br" ;
	TO cEmail ;
	SUBJECT cTitulo ;
	BODY cBody ;
	RESULT lOk
	If lOk
		MsgInfo( "E-mail enviado com sucesso" )
	Else
		GET MAIL ERROR cSmtpError
		MsgSTop( "Erro de envio : " + cSmtpError)
	Endif
	// Desconecta do Servidor
	DISCONNECT SMTP SERVER
Else
	GET MAIL ERROR cSmtpError
	MsgStop( "Erro de conexão : " + cSmtpError)
Endif

Return

Return
#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*/
�����������������������������������������������������������������������������
���Programa  �MA020TOK  � Autor � Fabricio           � Data �  23/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica preenchimento da inscr.INSS quando pessoa fisica  ���
�������������������������������������������������������������������������͹��
���Uso       � Generico - disparado na inclusao                           ���
�����������������������������������������������������������������������������
/*/
// Rafael Fran�a - Atualizado para valida��o dos dados bancarios
// Rafael Fran�a - Envia e-mail de aviso de cadastro

Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC

User Function MA020TOK()

	Private _lRetorno := .T.

	If M->A2_TIPO <> "X" .AND. EMPTY(M->A2_CGC)
		MsgBox("Quando fornecedor n�o for TIPO=X o CPF/CNPJ deve ser informado! ","Verifique!","Aviso")
		_lRetorno := .F.
	Endif

    Do Case
        Case (M->A2_EST=="EX" .and. M->A2_TIPO <> "X") .or. (M->A2_EST<>"EX" .and. M->A2_TIPO == "X")
        MsgBox("Quando o fornecedor for estrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!") //Mensagem alterada por Marcio T. Suzaki em 23/04/08
        _lRetorno := .F.
        Case (M->A2_EST=="EX" .and. M->A2_TIPO == "X" .and. EMPTY(M->A2_BAIRRO)) .or. (M->A2_EST=="EX" .and. M->A2_TIPO == "X" .and. EMPTY(M->A2_CEP))
        MsgBox("Quando o fornecedor for estrangeiro, informar TIPO=X, ESTADO=EX, Bairro e CEP=00000-000!") //Condi��o inclusa por Marcio T. Suzaki em 23/04/08
        _lRetorno := .F.
        Case M->A2_EST<>"EX" .and. EMPTY(M->A2_MUN)
        MsgBox("Quando fornecedor n�o for do exterior ESTADO=EX, deve ser informado: Munic�pio e Cod. Munic�pio!")
        _lRetorno := .F.
        Case M->A2_EST<>"EX" .and. EMPTY(M->A2_COD_MUN)
        MsgBox("Quando fornecedor n�o for do exterior ESTADO=EX, deve ser informado: Munic�pio e Cod. Munic�pio!")
        _lRetorno := .F.
    EndCase

    If (M->A2_PENS == "1")
        IF (EMPTY(M->A2_AGENCIA) .OR. EMPTY(M->A2_NUMCON) .OR. EMPTY(M->A2_TPPAG) .OR. EMPTY(M->A2_TPCTFOR))
            MsgBox("Quando o fornecedor for PENSIONISTA, o preenchimento dos campos: Ag�ncia, Conta e Tipo Conta s�o obrigat�rios")
            _lRetorno := .F.
        Endif
    ENDIF

    If !EMPTY(M->A2_AGENCIA)
        If LEN(ALLTRIM(M->A2_AGENCIA)) != 5
            MsgBox("� preciso inserir o d�gito verificador no campo Ag�ncia")
            _lRetorno := .F.
        EndIf
    EndIf

    If !EMPTY(M->A2_BANCO) .OR. !EMPTY(M->A2_AGENCIA) .OR. !EMPTY(M->A2_DGAGEN) .OR. !EMPTY(M->A2_NUMCON) .OR. !EMPTY(M->A2_DGCONTA) .OR. !EMPTY(M->A2_DESCBAN)
        If EMPTY(M->A2_BANCO) .OR. EMPTY(M->A2_AGENCIA) .OR. EMPTY(M->A2_DGAGEN) .OR. EMPTY(M->A2_NUMCON) .OR. EMPTY(M->A2_DGCONTA) .OR. EMPTY(M->A2_DESCBAN)
            MsgBox("Quando os dados banc�rios do fornecedor forem preenchidos, � obrigat�rio alimentar os seguintes campos: Ag�ncia, Digito da Ag�ncia, Conta e D�gito da Conta")
            _lRetorno := .F.
        EndIf
    EndIf

	//Rafael Fran�a - Cadastra conta contabil do fornecedor por meio do padr�o MVC.

	IF _lRetorno

		//M->A2_CONTA := '211' + M->A2_GRUPC + SUBSTR(M->A2_COD,3,4)

		ModelCT1()

	ENDIF

Return(_lRetorno)

//Exemplo de rotina autom�tica para inclus�o de contas cont�beis no ambiente Contabilidade Gerencial (SigaCTB).
//ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB

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

	__oModelAut:SetOperation(nOpcAuto) // 3 - Inclus�o | 4 - Altera��o | 5 - Exclus�o
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
	oCVD:SETVALUE('CVD_CODPLA','2018')
	oCVD:SETVALUE('CVD_CTAREF','2.01.01.03.01')
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

	U_AvisoFor1()//Manda e-mail avisando a contabilidade

Return(lRet)

User Function AvisoFor1()

Local aArea     := GetArea()
Local cPara  	:= ""
Local cAssunto	:= ""
Local cCorpo 	:= ""

	cPara 		:= "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br;Contabilidade@recordtvdf.com.br"
	cAssunto	:= "Fornecedor inclu�do: " + M->A2_COD + " - " + M->A2_NOME
	cCorpo 		:= "C�digo: " + M->A2_COD + "<br>"
	cCorpo 		+= "Descri��o: "+ M->A2_NOME + "<br>"
	cCorpo 		+= "Grupo: " + M->A2_GRUPC + " - " + ALLTRIM(Posicione("SX5",1,xFilial("SX5")+"ZU" + M->A2_GRUPC,"X5_DESCRI")) + "<br>"
	cCorpo 		+= "Conta Cont�bil: "+ M->A2_CONTA + "<br>"
	cCorpo 		+= "CPF/CNPJ: "+ M->A2_CGC + "<br>"
	cCorpo 		+= "Munic�pio: "+ "(" + M->A2_COD_MUN + ") " + A2_MUN +"<br>"
	cCorpo 		+= "Estado: "+ M->A2_EST + "<br>"
	cCorpo 		+= "Pa�s Bacen: "+ M->A2_CODPAIS + "<br>"

	If PswSeek(RetCodUsr(), .T. )
		aUsuario := PswRet() // Retorna vetor com informa��es do usu�rio
		cCorpo 	+= "Inclu�do por: " + Alltrim(aUsuario[1][4]) + "<br>" //Nome do casdastro de usu�rio
		//cCorpo 	+= Alltrim(aUsuario[1][13])  //Cargo do usu�rio
	EndIf

	u_zEnvMail(cPara, cAssunto, cCorpo, , .T.)

dbSelectArea(aArea)

Return()
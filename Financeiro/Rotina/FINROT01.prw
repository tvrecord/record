#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

STATIC _cRotina := 'Consulta Repasse'

/*/{Protheus.doc} FINROT01
//TODO Função responsavel pela consulta dos calculos do repasse
@author Bruno Alves
@since 22/03/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function FINROT01()

	Local oBrowse
	//Local cFiltro 	:= ""	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZAF')
	oBrowse:SetDescription(_cRotina)


	//Chama função para criar os parametros
	u_Parametro()


	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
//TODO Descrição auto-gerada.
@author Joao Paulo
@since 04/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.FINROT01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Parametros'    ACTION 'u_Parametro()' OPERATION 6 ACCESS 0
	//  ADD OPTION aRotina TITLE 'Reprovar'    ACTION 'u_ReprovPro(1)' OPERATION 6 ACCESS 0
	//	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.COMP011_MVC' OPERATION 4 ACCESS 0
	//	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.COMP011_MVC' OPERATION 5 ACCESS 0
	//	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.COMP011_MVC' OPERATION 8 ACCESS 0
	//	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.COMP011_MVC' OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
//TODO Descrição auto-gerada.
@author Bruno Alves
@since 04/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZAF := FWFormStruct( 1, 'ZAF', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStruZAG := FWFormStruct( 1, 'ZAG' , { |x| ALLTRIM(x) $ 'ZAG_NUMRP|ZAG_EMISSA|ZAG_PERIOD|ZAG_VALOR' } )
	Local oStruZAH := FWFormStruct( 1, 'ZAH' , { |x| ALLTRIM(x) $ 'ZAH_NUMRP|ZAH_DTACUM|ZAH_ACUCAL|ZAH_VLACUM|ZAH_VALOR|ZAH_VLDESC|ZAH_RATEIO|ZAH_VLRAT' } )
	Local oModel


	// Cria o objeto do Modelo de Dúados
	oModel := MPFormModel():New('FIN01M', /*bPreValidacao*/, /*bPosValidacao*/, { |oMdl| FINROT01CMT( oMdl ) }, /*bCancel*/ )

	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZAFMASTER', /*cOwner*/, oStruZAF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ZAGDETAIL', 'ZAFMASTER', oStruZAG )
	oModel:AddGrid( 'ZAHDETAIL', 'ZAGDETAIL', oStruZAH )


	// Faz relacionamento entre os componentes do model 
	oModel:SetRelation( 'ZAGDETAIL', { { 'ZAG_FILIAL', 'xFilial("ZAF")' }, { 'ZAG_PERIOD', 'SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)' } , { 'ZAG_PRACA', 'ZAF_CODIGO'} }, ZAG->( IndexKey( 3 ) ) )
	oModel:SetRelation( 'ZAHDETAIL', { { 'ZAH_FILIAL', 'xFilial("ZAF")' }, { 'ZAH_PERIOD', 'SUBSTRING(DTOS(MV_PAR01),5,2) + SUBSTRING(DTOS(MV_PAR01),1,4)' } , { 'ZAH_PRACA', 'ZAF_CODIGO'} }, ZAH->( IndexKey( 2 ) ) )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( _cRotina )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'ZAFMASTER' ):SetDescription( _cRotina )
	oModel:GetModel( 'ZAGDETAIL' ):SetDescription( 'Cabeçalho Repasse' )
	oModel:GetModel( 'ZAHDETAIL' ):SetDescription( 'Detalhes Repasse' )
	
Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author Joao Paulo
@since 04/05/2019
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'FINROT01' )
	// Cria a estrutura a ser usada na View
	Local oStruZAF := FWFormStruct( 2, 'ZAF' )
	Local oStruZAG := FWFormStruct( 2, 'ZAG' , { |x| ALLTRIM(x) $ 'ZAG_NUMRP|ZAG_EMISSA|ZAG_PERIOD|ZAG_VALOR' } )
	Local oStruZAH := FWFormStruct( 2, 'ZAH' , { |x| ALLTRIM(x) $ 'ZAH_NUMRP|ZAH_DTACUM|ZAH_ACUCAL|ZAH_VLACUM|ZAH_VALOR|ZAH_VLDESC|ZAH_RATEIO|ZAH_VLRAT' } )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZAF', oStruZAF, 'ZAFMASTER' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados) 
	oView:AddGrid( 'VIEW_ZAG', oStruZAG, 'ZAGDETAIL' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados) 
	oView:AddGrid( 'VIEW_ZAH', oStruZAH, 'ZAHDETAIL' )

	oView:EnableTitleView('VIEW_ZAG','Cabeçalho Repasse')
	oView:EnableTitleView('VIEW_ZAH','Detalhes Repasse')

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR' , 16 )
	oView:CreateHorizontalBox( 'INFERIOR1' , 42 )
	oView:CreateHorizontalBox( 'INFERIOR2' , 42 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZAF', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZAG', 'INFERIOR1' )
	oView:SetOwnerView( 'VIEW_ZAH', 'INFERIOR2' )


Return oView


Static Function FINROT01CMT( oModel )

	Local aArea      := GetArea()
	Local aAreaZAF   := ZAF->( GetArea() )
	Local nI         := 0
	Local nOperation := oModel:GetOperation()
	Local lOk        := .T.
	Local aSaveLines := FWSaveRows()

	oModelZAF := FWLoadModel( 'FINROT01' )
	oModelZAF := oModel:GetModel( 'ZAFMASTER' )

	If nOperation == MODEL_OPERATION_UPDATE


	EndIf

Return NIL



// Opção para alterar os parametros


User Function Parametro()

	Local cPerg	:= "FINROT01" // Nome do grupo de perguntas na SX6.

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		MsgAlert("Operação Cancelada")
		return
	ENDIF

Return



//Cria Perguntas

Static Function ValidPerg(cPerg)

	Local i,j

	_sAlias := Alias()
	cPerg := PADR(cPerg,10)
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	AADD(aRegs,{cPerg,"01","Periodo","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})


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


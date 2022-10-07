/*#########################################################################################
Projeto : Afinidade
Modulo  : SIGAFAT
Fonte   : AXZAJ
Objetivo: Cadastro de Comissão
#########################################################################################
*/

#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

STATIC cTitulo := "Cadastro de Comissão"

/*/{Protheus.doc} AXZAJ
    Cadastro de Comissão
    @author  Bruno Alves de Oliveira
    @table   ZAJ,ZAK,ZAL
    @since   27-03-2022
/*/

User Function AXZAJ()

	Local aArea   := GetArea()
	Local oBrowse

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZAJ")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)

Return Nil
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function MenuDef()

	Local aRot := {}

	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.AXZAJ' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.AXZAJ' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.AXZAJ' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.AXZAJ' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Imprimir'   ACTION 'U_FINR008'    OPERATION 9 ACCESS 0 //OPERATION 5

Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ModelDef()

	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'ZAJ')
	Local oStFil1 		:= FWFormStruct( 1, 'ZAK',{ |cCampo| Alltrim(cCampo) $ 'ZAK_ANO/ZAK_GRPNAT/ZAK_TPSUB/ZAK_PERC' } ,/*lViewUsado*/ )
	Local oStFil2 		:= FWFormStruct( 1, 'ZAL',{ |cCampo| Alltrim(cCampo) $ 'ZAL_MES/ZAL_TIPO/ZAL_PERC/ZAL_PERCIN/ZAL_VALOR/ZAL_MTINDI/ZAL_ATINDI/ZAL_MTCOLE/ZAL_ATCOLE/ZAL_CACOLE/ZAL_CAINDI/ZAL_DESCON/ZAL_JUSTIF/ZAL_CATRIC/ZAL_CATRII/ZAL_CAANUC/ZAL_CAANUI' } ,/*lViewUsado*/ )
	Local oStFil3 		:= FWFormStruct( 1, 'ZAM',{ |cCampo| Alltrim(cCampo) $ 'ZAM_GRPNAT/ZAM_NMGRP/ZAM_PERC' } ,/*lViewUsado*/ )


	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('AXZAJM')

	oStFil2:addTrigger( 'ZAL_MES'  , 'ZAL_MES'   , {|| .T. }, {|oModel| oModel:setValue('ZAL_MES',STRZERO(VAL(oModel:getValue('ZAL_MES')),2))   } )

	oModel:AddFields('ZAJMASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('ZAKDETAIL','ZAJMASTER',oStFil1,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:AddGrid('ZALDETAIL','ZAKDETAIL',oStFil2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	oModel:AddGrid('ZAMDETAIL','ZAJMASTER',oStFil3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence


	oModel:SetRelation("ZAKDETAIL", {{ 'ZAK_FILIAL', 'xFilial( "ZAK" )' },{"ZAK_VEND","ZAJ_VEND"}}, ZAK->(IndexKey( 1 )))
	oModel:SetRelation("ZALDETAIL", {{ 'ZAL_FILIAL', 'xFilial( "ZAK" )' },{"ZAL_VEND","ZAJ_VEND"},{"ZAL_GRPNAT","ZAK_GRPNAT"},{"ZAL_ANO","ZAK_ANO"}}, ZAL->(IndexKey( 1 )))
	oModel:SetRelation("ZAMDETAIL", {{ 'ZAM_FILIAL', 'xFilial( "ZAM" )' },{"ZAM_VEND","ZAJ_VEND"}}, ZAM->(IndexKey( 1 )))
	oModel:GetModel('ZAKDETAIL'):SetUniqueLine({"ZAK_ANO","ZAK_GRPNAT"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:GetModel('ZAMDETAIL'):SetUniqueLine({"ZAM_GRPNAT"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:GetModel('ZALDETAIL'):SetUniqueLine({"ZAL_MES"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}

	oModel:SetPrimaryKey({"ZAJ_FILIAL","ZAJ_VEND"})

	//Setando as descrições
	oModel:SetDescription("Cálculo Comissão Contato")
	oModel:GetModel('ZAJMASTER'):SetDescription('Vendedor')
	oModel:GetModel('ZAKDETAIL'):SetDescription('Ano/Natureza')
	oModel:GetModel('ZALDETAIL'):SetDescription('Meses')
	oModel:GetModel('ZAMDETAIL'):SetDescription('Rateio Natureza')

	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_PERC'     , 'XX_PERC'       , 'AVERAGE'    , , , "Média Porcentagem" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_VALOR'    , 'XX_VALOR'      , 'SUM'        , , , "Valor" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_MTINDI'   , 'XX_MTINDI'     , 'SUM'        , , , "Meta Individual" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_ATINDI'   , 'XX_ATINDI'     , 'SUM'        , , , "Atingido Individual" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_MTCOLE'   , 'XX_MTCOLE'     , 'SUM'        , , , "Meta Coletiva" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_ATCOLE'   , 'XX_ATCOLE'     , 'SUM'        , , , "Atingido Coletiva" )
	oModel:AddCalc('TOTAL', 'ZAKDETAIL', 'ZALDETAIL', 'ZAL_PERCIN'   , 'XX_PERCIN'     , 'AVERAGE'    , , , "Média Porcentagem Individual" )

Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
*---------------------------------------------------------------------*/
Static Function ViewDef()

	Local oView		:= Nil
	Local oModel	:= FWLoadModel('AXZAJ')
	Local oStPai	:= FWFormStruct(2, 'ZAJ')
	Local oStFil1 	:= FWFormStruct(2, 'ZAK',{ |cCampo| Alltrim(cCampo) $ 'ZAK_ANO/ZAK_GRPNAT/ZAK_TPSUB/ZAK_PERC' } ,/*lViewUsado*/ )
	Local oStFil2 	:= FWFormStruct(2, 'ZAL',{ |cCampo| Alltrim(cCampo) $ 'ZAL_MES/ZAL_TIPO/ZAL_PERC/ZAL_PERCIN/ZAL_VALOR/ZAL_MTINDI/ZAL_ATINDI/ZAL_MTCOLE/ZAL_ATCOLE/ZAL_CACOLE/ZAL_CAINDI/ZAL_DESCON/ZAL_JUSTIF/ZAL_CATRIC/ZAL_CATRII/ZAL_CAANUC/ZAL_CAANUI' } ,/*lViewUsado*/ )
	Local oStFil3 	:= FWFormStruct(2, 'ZAM',{ |cCampo| Alltrim(cCampo) $ 'ZAM_GRPNAT/ZAM_NMGRP/ZAM_PERC' } ,/*lViewUsado*/ )
	Local oStTot 	:= FWCalcStruct(oModel:GetModel('TOTAL'))

	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_ZAJ',oStPai,'ZAJMASTER')
	oView:AddGrid('VIEW_ZAK',oStFil1,'ZAKDETAIL')
	oView:AddGrid('VIEW_ZAL',oStFil2,'ZALDETAIL')
	oView:AddGrid('VIEW_ZAM',oStFil3,'ZAMDETAIL')
	oView:AddField('VIEW_TOT', oStTot,'TOTAL')

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',15)
	oView:CreateHorizontalBox('INFERIOR',60)
	oView:CreateHorizontalBox('TOTALIZADOR',25)

	oView:CreateVerticalBox("GRID", 20,"INFERIOR")
	oView:CreateVerticalBox("GRID1",80,"INFERIOR")

	oView:CreateVerticalBox("NATUREZA",30,"TOTALIZADOR")
	oView:CreateVerticalBox("TOTAIS"  ,70,"TOTALIZADOR")

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZAJ','CABEC')
	oView:SetOwnerView('VIEW_ZAK','GRID')
	oView:SetOwnerView('VIEW_ZAL','GRID1')
	oView:SetOwnerView('VIEW_ZAM','NATUREZA')
	oView:SetOwnerView('VIEW_TOT','TOTAIS')

	//Habilitando título
	oView:EnableTitleView('VIEW_ZAJ','Vendedor')
	oView:EnableTitleView('VIEW_ZAK','Ano/Grupo Natureza')
	oView:EnableTitleView('VIEW_ZAL','Meses')
	oView:EnableTitleView('VIEW_ZAM','Natureza')
	oView:EnableTitleView('VIEW_TOT','Totalizador')

Return oView

/*/{Protheus.doc} Imprimir
    Rotina responsavel por imprimir o relatório comissão
    @author  Bruno Alves de OLiveira
    @since   27-03-2022

User Function Imprimir()

		MsgAlert("Relatorio em construção. " + CRLF + ;
			"<b>Favor verificar</b>","Imprimir")


Return

/*/
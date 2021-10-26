//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA103BUT
P.E. para adicionar op��es dentro da tela de manipula��o do Doc. de Entrada
@type  Function
@author Rafael Fran�a
@since 26/10/2021
@version version
@see https://tdn.totvs.com/pages/releaseview.action?pageId=102269141
/*/

User Function MA103BUT()

	Local aArea := GetArea()
    Local lEdit
    Local nAba
    Local oCampo
    Public __cCamNovo01 := ""

    //Adiciona uma nova aba no documento de entrada
    oFolder:AddItem("Customizados Record", .T.)
    nAba := Len(oFolder:aDialogs)

    //Se for inclus�o, ir� criar a vari�vel e ser� edit�vel, sen�o ir� buscar do banco e n�o ser� edit�vel
    If INCLUI
        __cCamNovo01 := CriaVar("F1_SALAS",.F.)
        lEdit := .T.
    Else
        __cCamNovo01 := SF1->F1_SALAS
        lEdit := .F.
    EndIf

    //Criando na janela o campo OBS
    @ 003, 003 SAY Alltrim(RetTitle("F1_SALAS")) OF oFolder:aDialogs[nAba] PIXEL SIZE 050,006
    @ 001, 053 MSGET oCampo VAR __cCamNovo01 SIZE 100, 006 OF oFolder:aDialogs[nAba] COLORS 0, 16777215  PIXEL
    oCampo:bHelp := {|| ShowHelpCpo( "F1_SALAS", {GetHlpSoluc("F1_SALAS")[1]}, 5  )}

    //Se n�o houver edi��o, desabilita os gets
    If !lEdit
        oCampo:lActive := .F.
    EndIf

    RestArea(aArea)

Return Nil
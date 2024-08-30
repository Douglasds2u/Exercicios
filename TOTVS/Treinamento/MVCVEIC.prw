//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: MVCMON
Rotina para cadastro de veículos em MVC.
Autor: Douglas Sousa
Data: 23/08/2024
---------------------------------------------------- */

Static cTitulo  := "Veículos"
Static cAliasMVC := "ZA3"


User Function MVCVEIC()

    Local aArea := GetArea()
    Local oBrowse := Nil
    Private aRotina := {}

    //Definição do menu
    aRotina := MenuDef()

    //Instanciando o Browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return

/*Esta é a camada de controle*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.MVCVEIC" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.MVCVEIC" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.MVCVEIC" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.MVCVEIC" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.MVCVEIC" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.MVCVEIC" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAliasMVC)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := Nil
    Local bCancel := Nil

    oModel := MPFormModel():New("MVCVEICM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA3MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZA3MASTER"):SetDescription("Dados de " + cTitulo)
    oModel:SetPrimaryKey({})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel  := FWLoadModel("MVCVEIC")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView   := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA3", oStruct, "ZA3MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZA3", "TELA")

Return oView

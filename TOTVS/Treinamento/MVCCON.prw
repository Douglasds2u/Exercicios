//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: MVCMON
Rotina para cadastro de concession�rias em MVC.
Autor: Douglas Sousa
Data: 23/08/2024
---------------------------------------------------- */

Static cTitulo  := "Concession�rias"
Static cAliasMVC := "ZA2"


User Function MVCCON()

    Local aArea := GetArea()
    Local oBrowse := Nil
    Private aRotina := {}

    //Defini��o do menu
    aRotina := MenuDef()

    //Instanciando o Browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return

/*Esta � a camada de controle*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.MVCCON" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.MVCCON" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.MVCCON" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Exclu�r"      ACTION "VIEWDEF.MVCCON" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.MVCCON" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.MVCCON" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAliasMVC)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := Nil
    Local bCancel := Nil

    oModel := MPFormModel():New("MVCCONM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA2MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Concession�ria")
    oModel:GetModel("ZA2MASTER"):SetDescription("Concession�ria")
    oModel:SetPrimaryKey({})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel  := FWLoadModel("MVCCON")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView   := Nil

    //Cria a visualiza��o do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA2", oStruct, "ZA2MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZA2", "TELA")

Return oView

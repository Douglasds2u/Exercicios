//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: MVCMON
Rotina para cadastro de montadoras de veículos em MVC.
Autor: Douglas Sousa
Data: 23/08/2024
---------------------------------------------------- */

Static cTitulo   := "Montadoras"
Static cTabPai   := "ZA2"
Static cTabFilho := "ZA3"

User Function MVCMON()

    Local aArea := GetArea()
    Local oBrowse := Nil
    Private aRotina := {}

    //Definição do menu
    aRotina := MenuDef()

    //Instanciando o Browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return

/*Esta é a camada de controle*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"    ACTION "VIEWDEF.MVCMON" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"       ACTION "VIEWDEF.MVCMON" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"       ACTION "VIEWDEF.MVCMON" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"       ACTION "VIEWDEF.MVCMON" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"      ACTION "VIEWDEF.MVCMON" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"        ACTION "VIEWDEF.MVCMON" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oStruPai   := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local aRelation  := {}
    Local oModel     := Nil
    Local bPre       := Nil
    Local bPos       := Nil
    Local bCommit    := Nil
    Local bCancel    := Nil

    oModel := MPFormModel():New("MVCMONM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA2MASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("ZA3DETAIL", "ZA2MASTER", oStruFilho)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    oModel:GetModel("ZA2MASTER"):SetDescription("Dados de - " + cTitulo)
    oModel:GetModel("ZA3DETAIL"):SetDescription("Grid de - " + cTitulo)
    oModel:SetPrimaryKey({})

    /*Fazendo o Relacionamento*/
    aAdd(aRelation, {"ZA3_FILIAL", "FWxFilial('ZA3')"})
    aAdd(aRelation, {"ZA3_CODIGO", "ZA2_CODIGO"})
    oModel:SetRelation("ZA3DETAIL", aRelation, ZA3->(IndexKey(2)))

Return oModel

    /*Camada visual (interface)*/
    Static Function ViewDef()

    Local oModel     := FWLoadModel("MVCMON")
    Local oStruPai   := FWFormStruct(2, cTabPai)
    Local oStruFilho := FWFormStruct(2, cTabFilho)
    Local oView      := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA2", oStruPai, "ZA2MASTER")
    oView:AddGrid("VIEW_ZA3", oStruFilho, "ZA3DETAIL")

    /*Partes da Tela*/
    oView:CreateHorizontalBox("CABEC", 60)
    oView:CreateHorizontalBox("GRID", 40)
    oView:SetOwnerView("VIEW_ZA2", "CABEC")
    oView:SetOwnerView("VIEW_ZA3", "GRID")

    /*Titulos*/
    oView:EnableTitleView("VIEW_ZA2", "Montadoras")
    oView:EnableTitleView("VIEW_ZA3", "Veiculos")

    oView:AddIncrementField("VIEW_ZA3", "ZA3_VEIC")

Return oView

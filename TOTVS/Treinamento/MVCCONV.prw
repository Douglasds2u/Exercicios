//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: MVCMON
Rotina para cadastro de concessionárias x veículos em MVC.
Autor: Douglas Sousa
Data: 23/08/2024
---------------------------------------------------- */

Static cTitulo   := "Concessionária X Veículos"
Static cTabPai   := "ZA4"
Static cTabFilho := "ZA3"

User Function MVCCONV()

    Local aArea := GetArea()
    Local oBrowse := Nil
    Private aRotina := {}

    //Definição do menu
    aRotina := MenuDef()

    //Instanciando o Browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription("Concessionárias")
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return

/*Esta é a camada de controle*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.MVCCONV" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.MVCCONV" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.MVCCONV" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.MVCCONV" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "u_RelConVe"      OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.MVCCONV" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel     := Nil
    Local oStruPai   := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local aRelation  := {}
    Local bPre       := Nil
    Local bPos       := Nil
    Local bCommit    := Nil
    Local bCancel    := Nil

    oModel := MPFormModel():New("MVCCONVM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZA4MASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("ZA3DETAIL", "ZA4MASTER", oStruFilho) 
    oModel:SetDescription(cTitulo)
    oModel:GetModel("ZA4MASTER"):SetDescription(cTitulo)
    oModel:GetModel("ZA3DETAIL"):SetDescription("Veículos")
    oModel:SetPrimaryKey({})

    /*Fazendo o relacionamento das tabelas*/
    aAdd(aRelation, {"ZA3_FILIAL", "FWxFilial('ZA3')"})
    aAdd(aRelation, {"ZA3_CODIGO", "ZA4_COD"})
    oModel:SetRelation("ZA3DETAIL", aRelation, ZA3->(IndexKey(1)))

    oModel:AddCalc('TOTAIS', 'ZA4MASTER', 'ZA3DETAIL', 'ZA3_VEIC', 'XX_TOTVEIC', 'COUNT', , , "Total de Veículos:")

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel     := FWLoadModel("MVCCONV")
    Local oStruPai   := FWFormStruct(2, cTabPai)
    Local oStruFilho := FWFormStruct(2, cTabFilho)
    Local oStruTot   := FWCalcStruct(oModel:GetModel('TOTAIS'))
    Local oView      := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA4", oStruPai, "ZA4MASTER")
    oView:AddGrid("VIEW_ZA3", oStruFilho, "ZA3DETAIL")
    oView:AddField("VIEW_TOT", oStruTot, "TOTAIS")

    oView:CreateHorizontalBox("CABEC", 35)
    oView:CreateHorizontalBox("GRID", 50)
    oView:CreateHorizontalBox("ENCH_TOT", 15)
    oView:SetOwnerView("VIEW_ZA4", "CABEC")
    oView:SetOwnerView("VIEW_ZA3", "GRID")
    oView:SetOwnerView("VIEW_TOT", "ENCH_TOT")

    //Titulos
    oView:EnableTitleView("VIEW_ZA4", "Concessionária")
	oView:EnableTitleView("VIEW_ZA3", "Veículos")

    oStruFilho:RemoveField("ZA3_CODIGO")

    oView:AddIncrementField("VIEW_ZA3", "ZA3_VEIC")

Return oView


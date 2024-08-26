//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------------
Nome: MVCMON
Rotina para cadastro de montadoras de veículos em MVC.
Autor: Douglas Sousa
Data: 23/08/2024
---------------------------------------------------- */

Static cTitulo  := "Montadoras"
Static cAliasMVC := "ZA2"


User Function MVCMON()

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

ADD OPTION aRotina TITLE "Visualizar"     ACTION "VIEWDEF.MVCMON" OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"     ACTION "VIEWDEF.MVCMON" OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"     ACTION "VIEWDEF.MVCMON" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Excluír"     ACTION "VIEWDEF.MVCMON" OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.MVCMON" OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.MVCMON" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

Local oModel  := Nil
Local oStruct := FWFormStruct(1, cAliasMVC)
Local bPre    := Nil
Local bPos    := Nil
Local bCommit := Nil
Local bCancel := Nil

oModel := MPFormModel():New("MVCMONM", bPre, bPos, bCommit, bCancel)
oModel:AddFields("ZA2MASTER", /*cOwner*/, oStruct)
oModel:SetDescription("Modelo de dados - " + cTitulo)
oModel:GetModel("ZA2MASTER"):SetDescription("Dados de " + cTitulo)
oModel:SetPrimaryKey({})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

Local oModel  := FWLoadModel("MVCMON")
Local oStruct := FWFormStruct(2, cAliasMVC)
Local oView   := Nil

//Cria a visualização do Cadastro
oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField("VIEW_ZA2", oStruct, "ZA2MASTER")
oView:CreateHorizontalBox("TELA", 100)
oView:SetOwnerView("VIEW_ZA2", "TELA")

Return oView

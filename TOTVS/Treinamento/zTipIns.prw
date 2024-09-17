//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* -----------------------------------------------------------
Nome: zTipIns
Rotina para cadastro de Tipos de Instrumentos musicais em MVC.
Autor: Douglas Sousa
Data: 04/09/2024
----------------------------------------------------------- */

Static cTitulo   := "Tipos de Instrumentos Músicais"
Static cAliasMVC := "ZC1"


User Function zTipIns()

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

    ADD OPTION aRotina TITLE "Visualizar"           ACTION "VIEWDEF.zTipIns" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"              ACTION "VIEWDEF.zTipIns" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"              ACTION "VIEWDEF.zTipIns" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"              ACTION "VIEWDEF.zTipIns" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Impr. Rel. Audit"     ACTION "u_RaudIns()"     OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"               ACTION "VIEWDEF.zTipIns" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAliasMVC)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := {|oMld| u_GrvAcaoI(oModel)}
    Local bCancel := Nil

    oModel := MPFormModel():New("zTipInsM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZC1MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Tipos de Instrumentos")
    oModel:GetModel("ZC1MASTER"):SetDescription("Tipos de Instrumentos")
    oModel:SetPrimaryKey({})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel  := FWLoadModel("zTipIns")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView   := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZC1", oStruct, "ZC1MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZC1", "TELA")

Return oView

/*Função de auditoria para gravar operação realizada na tabela ZC1*/
User Function GrvAcaoI(oModel)
    Local nOperation := oModel:GetOperation()
    Local cAcao      := ''
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local nRecno     := 0
    Local lRet       := .T.
    Local cServer    := GetClientIp()


    lRet := FwFormCommit(oModel)
    nRecno := ZC1->(RecNo())

    If nOperation == MODEL_OPERATION_INSERT
        cAcao := 'Inclusão'

    ElseIf nOperation == MODEL_OPERATION_UPDATE
        cAcao := 'Alteração'

    ElseIF nOperation == MODEL_OPERATION_DELETE
        cAcao := 'Exclusão'

    EndIf 

    DbSelectArea("ZZ1")
    RecLock("ZZ1", .T.)
        ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
        ZZ1->ZZ1_COD    := GETSXENUM("ZZ1","ZZ1_COD")
        ZZ1->ZZ1_ACAO   := cAcao
        ZZ1->ZZ1_DATA   := dData
        ZZ1->ZZ1_HORA   := cHora
        ZZ1->ZZ1_USER   := cCodUsr
        ZZ1->ZZ1_IP     := cServer
        ZZ1->ZZ1_RECNO  := nRecno
    MsUnLock() // Comfirma e finaliza a operação

Return lRet

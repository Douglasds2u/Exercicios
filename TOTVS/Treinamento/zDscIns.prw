//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* -------------------------------------------
Nome: zCadForn
Rotina para Descrição de Instrumentos Músicais.
Autor: Douglas Sousa
Data: 02/09/2024
--------------------------------------------- */

Static cTitulo  := "Descrição Instrumentos Músicais"
Static cAliasMVC := "ZC3"


User Function zDscIns()

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

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zDscIns" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zDscIns" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zDscIns" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.zDscIns" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.zDscIns" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.zDscIns" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel  := Nil
    Local oStruct := FWFormStruct(1, cAliasMVC)
    Local bPre    := Nil
    Local bPos    := Nil
    Local bCommit := {|oMdl| u_GrvAcaoD(oModel)}
    Local bCancel := Nil

    oModel := MPFormModel():New("zDscInsM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZC3MASTER", /*cOwner*/, oStruct)
    oModel:SetDescription("Descrição Instrumentos Músicais")
    oModel:GetModel("ZC3MASTER"):SetDescription("Descrição Instrumentos Músicais")
    oModel:SetPrimaryKey({})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel  := FWLoadModel("zDscIns")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView   := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZC3", oStruct, "ZC3MASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_ZC3", "TELA")

Return oView


/*Função de auditoria para gravar operação realizada na tabela ZC1*/
User Function GrvAcaoD(oModel)
    Local nOperation := oModel:GetOperation()
    Local cAcao      := ''
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local nRecno     := 0
    Local lRet       := .T.
    Local cServer    := GetClientIp()


    lRet := FwFormCommit(oModel)
    nRecno := ZC3->(RecNo())

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

//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* -------------------------------------------------------------------------
Nome: zCadIns
Rotina para cadastro Instrumentos (Tipos X Marcas X Descrição Instrumentos).
Autor: Douglas Sousa
Data: 05/09/2024
------------------------------------------------------------------------- */

Static cTitulo   := "Tipos X Marcas X Instrumentos"
Static cTabPai   := "ZC1"
Static cTabFilho := "ZC2"
Static cTabNeto  := "ZC3"


User Function zCadIns()

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

/*Esta é a camada de controle (Adicionando os botões no browse)*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zCadIns" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zCadIns" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zCadIns" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"      ACTION "VIEWDEF.zCadIns" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF.zCadIns" OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF.zCadIns" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel     := Nil
    Local oStruPai   := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho, { |x| ! Alltrim(x) $ 'ZC2_NOME' })
    Local oStruNeto  := FWFormStruct(1, cTabNeto)
    Local aRelFilho  := {}
    Local aRelNeto   := {}
    Local bPre       := Nil
    Local bPos       := Nil
    Local bCommit    := {|oMdl| u_FGrvAcao(oModel)}
    Local bCancel    := Nil

    oModel := MPFormModel():New("zCadInsM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZC1MASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("ZC2DETAIL", "ZC1MASTER", oStruFilho, , , , ,)
    oModel:AddGrid("ZC3DETAIL", "ZC2DETAIL", oStruNeto, , , , ,)
    oModel:SetPrimaryKey({})

    //Fazendo o relacionamento Pai e Filho
    oStruFilho:SetProperty("ZC2_TPINS", MODEL_FIELD_OBRIGAT, .F.)
    aAdd(aRelFilho, {"ZC2_FILIAL", "FWxFilial('ZC2')"})
    aAdd(aRelFilho, {"ZC2_TPINS", "ZC1_COD"})
    oModel:SetRelation("ZC2DETAIL", aRelFilho, ZC2->(IndexKey(1)))

    //Fazendo o relacionamento Filho e Neto
    aAdd(aRelNeto, {"ZC3_FILIAL", "FWxFilial('ZC3')"})
    aAdd(aRelNeto, {"ZC3_COD", "ZC2_COD"})
    oModel:SetRelation("ZC3DETAIL", aRelNeto, ZC3->(IndexKey(1)))

    //Definindo campos unicos da linha
    oModel:GetModel("ZC2DETAIL"):SetUniqueLine({'ZC2_MARCA'})
    oModel:GetModel("ZC3DETAIL"):SetUniqueLine({'ZC3_DESC'})

    //Adicionando totalizadores de campos
    oModel:AddCalc('TOTAIS', 'ZC1MASTER', 'ZC2DETAIL', 'ZC2_COD',  'XX_TOTMRC', 'COUNT', , , "Total de Marcas:")
    oModel:AddCalc('TOTAIS', 'ZC2DETAIL', 'ZC3DETAIL', 'ZC3_DESC', 'XX_TOTINS', 'COUNT', , , "Total de Instrumentos:")
    
Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local oModel     := FWLoadModel("zCadIns")
    Local oStruPai   := FWFormStruct(2, cTabPai)
    Local oStruFilho := FWFormStruct(2, cTabFilho, { |x| ! Alltrim(x) $ 'ZC2_NOME' })
    Local oStruNeto  := FWFormStruct(2, cTabNeto)
    Local oStruTot   := FWCalcStruct(oModel:GetModel('TOTAIS'))
    Local oView      := Nil

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZC1", oStruPai, "ZC1MASTER")
    oView:AddGrid("VIEW_ZC2", oStruFilho, "ZC2DETAIL")
    oView:AddGrid("VIEW_ZC3", oStruNeto, "ZC3DETAIL")
    oView:AddField("VIEW_TOT", oStruTot, "TOTAIS")

    //Criando as Grids Horizontais uma embaixo da outra
    oView:CreateHorizontalBox("CABEC_PAI", 30)
    oView:CreateHorizontalBox("ESPACO_MEIO", 60)
        oView:CreateVerticalBox("MEIO_ESQUERDA", 50, "ESPACO_MEIO")
        oView:CreateVerticalBox("MEIO_DIREITA", 50, "ESPACO_MEIO")
    oView:CreateHorizontalBox("ENCH_TOT", 10)

    //Definindo a visualização das estruturas em cada Grid
    oView:SetOwnerView("VIEW_ZC1", "CABEC_PAI")
    oView:SetOwnerView("VIEW_ZC2", "MEIO_ESQUERDA")
    oView:SetOwnerView("VIEW_ZC3", "MEIO_DIREITA")
    oView:SetOwnerView("VIEW_TOT", "ENCH_TOT")

    //Definindo os Títulos das Grids
    oView:EnableTitleView("VIEW_ZC1", "Tipo de Instrumento Músical")
	oView:EnableTitleView("VIEW_ZC2", "Marca do Instrumento")
    oView:EnableTitleView("VIEW_ZC3", "Descrição do Instrumento")

    //Removendo campos
    oStruFilho:RemoveField("ZC2_TPINS")
    oStruFilho:RemoveField("ZC2_NOME")
    oStruNeto:RemoveField("ZC3_COD")

    //Adicionando campo incremental na grid
    oView:AddIncrementField("VIEW_ZC3", "ZC3_ITEM")

    //Adiciona botões direto no outras ações na ViewDef
    oView:addUserButton("Imprimir", "MAGIC_BMP", {|| Alert("Em construção")               }, , , , .F.)

Return oView


User Function FGrvAcao(oModel)
    Local nOperation := oModel:GetOperation()
    Local cAcao      := ''
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local nRecno     := 0
    Local lRet       := .T.
    Local cServer    := GetClientIp()

    Local cNum := GETSXENUM("ZZ1","ZZ1_COD")
 
    DbSelectArea("ZZ1")
    ZZ1->(DbSetOrder(1))
        While (DbSeek(xFilial("ZZ1")+cNum))
        ConfirmSX8()
        
        cNum := GETSXENUM("ZZ1","ZZ1_COD")
        Enddo
    
    DbCloseArea()
    RollbackSx8()

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
        ZZ1->ZZ1_COD    := cNum
        ZZ1->ZZ1_ACAO   := cAcao
        ZZ1->ZZ1_DATA   := dData
        ZZ1->ZZ1_HORA   := cHora
        ZZ1->ZZ1_USER   := cCodUsr
        ZZ1->ZZ1_IP     := cServer
        ZZ1->ZZ1_RECNO  := nRecno
    MsUnLock() // Comfirma e finaliza a operação

Return lRet

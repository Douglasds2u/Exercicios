//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* ---------------------------------------------
Nome: zCadHar
Rotina para cadastro de marcas de instrumentos.
Autor: Douglas Sousa
Data: 04/09/2024
---------------------------------------------- */

Static cTitulo   := "Instrumentos Músicais"
Static cTabPai   := "ZC2"
Static cTabFilho := "ZC3"


User Function zCadMrc()

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

    ADD OPTION aRotina TITLE "Visualizar"        ACTION "VIEWDEF.zCadMrc" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"           ACTION "VIEWDEF.zCadMrc" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"           ACTION "VIEWDEF.zCadMrc" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluír"           ACTION "VIEWDEF.zCadMrc" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Imp.Rel.Audit"     ACTION "u_RaudMrc()"     OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar"            ACTION "VIEWDEF.zCadMrc" OPERATION 9 ACCESS 0

Return aRotina

/*Camada do modelo de dados*/
Static Function ModelDef()

    Local oModel     := Nil
    Local oStruPai   := FWFormStruct(1, cTabPai)
    Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local aRelation  := {}
    Local bPre       := {|| u_MrcbPre()}
    Local bPos       := {|| u_MrcbPos()}
    Local bCommit    := {|oMdlAcao| u_GrvAcaoM(oModel)}
    Local bCancel    := Nil
    Local bLinePos   := {|oMdl| u_MrcbLPos(oModel)}

    oModel := MPFormModel():New("zCadMrcM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("ZC2MASTER", /*cOwner*/, oStruPai)
    oModel:AddGrid("ZC3DETAIL", "ZC2MASTER", oStruFilho, /*bLinePre*/, bLinePos,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
    oModel:SetDescription("Marcas de Instrumentos")
    oModel:GetModel("ZC2MASTER"):SetDescription("Marcas de Instrumentos")
    oModel:GetModel("ZC3DETAIL"):SetDescription("Instrumentos Músicais")
    oModel:SetPrimaryKey({})

    //Fazendo o relacionamento
	aAdd(aRelation, {"ZC3_FILIAL", "FWxFilial('ZC3')"} )
	aAdd(aRelation, {"ZC3_COD", "ZC2_COD"})
	oModel:SetRelation("ZC3DETAIL", aRelation, ZC3->(IndexKey(1)))

    //Definindo campos unicos da linha
	oModel:GetModel("ZC3DETAIL"):SetUniqueLine({'ZC3_DESC'})

Return oModel

/*Camada visual (interface)*/
Static Function ViewDef()

    Local cCamposPrin := "ZC2_COD|ZC2_MARCA"
    Local cCamposTipo := "ZC2_TPINS|ZC2_NOME"
    Local oModel      := FWLoadModel("zCadMrc")
    Local oStructPrin := FWFormStruct(2, cTabPai, {|cCampo| AllTrim(cCampo) $ cCamposPrin})
    Local oStructTipo := FWFormStruct(2, cTabPai, {|cCampo| AllTrim(cCampo) $ cCamposTipo})
    Local oStruFilho  := FWFormStruct(2, cTabFilho)
    Local oView       := Nil

    //Retira as abas padrões
    oStructPrin:SetNoFolder()
    oStructTipo:SetNoFolder()

    //Cria a visualização do Cadastro
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_PRIN", oStructPrin, "ZC2MASTER")
    oView:AddField("VIEW_TIPO", oStructTipo, "ZC2MASTER")
    oView:AddGrid("VIEW_FILHO", oStruFilho, "ZC3DETAIL")

    //Cria o controle das abas
    oView:CreateFolder('ABAS')
    oView:AddSheet('ABAS', 'ABA_PRIN', 'Aba Principal do Cadastro')
    oView:AddSheet('ABAS', 'ABA_TIPO', 'Aba com Tipo de Instrumento')

    oView:CreateHorizontalBox("BOX_PRIN", 40, /*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_PRIN')
    oView:CreateHorizontalBox("GRID_PRIN", 60, /*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_PRIN')
    oView:CreateHorizontalBox("BOX_TIPO", 100, /*owner*/, /*lUsePixel*/, 'ABAS', 'ABA_TIPO')

    //Amarra as abas aos views de struct criados
    oView:SetOwnerView("VIEW_PRIN", "BOX_PRIN")
    oView:SetOwnerView("VIEW_FILHO", "GRID_PRIN")
    oView:SetOwnerView("VIEW_TIPO", "BOX_TIPO")

Return oView

//Função para validar se o campo pode ser alterado
User Function MrcbPre()

    Local oModelPad := FWModelActive()
    Local lRet      := .T.
    oModelPad:GetModel('ZC2MASTER'):GetStruct():SetProperty('ZC2_MARCA', MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, 'INCLUI'))

Return lRet

//Função para validar se o campo está vazio ou contem menos de 3 caracteres na inclusão/alteração
User Function MrcbPos()

    Local oModelPad := FWModelActive()
    Local cMarcaIns := oModelPad:GetValue('ZC2MASTER', 'ZC2_MARCA')
    Local lRet      := .T.

    If Empty(cMarcaIns) .or. Len(Alltrim(cMarcaIns)) < 3
        Help(, , "Help", , "Nome da marca inválida!", 1, 0, , , , , , {"Insira um nome válido que tenha mais que 3 caracteres"})
        lRet := .F.
    EndIf

Return lRet

//Valida a inclusão ou alteração na linha da grid
User Function MrcbLPos(oModel)

    Local oModelZC3  := oModel:GetModel('ZC3DETAIL')
    Local nOperation := oModel:GetOperation()
    Local lRet       := .T.
    Local cInstr     := oModelZC3:GetValue("ZC3_DESC")

    //Se não for exclusão e nem visualização
    If 	nOperation != MODEL_OPERATION_DELETE .And. nOperation != MODEL_OPERATION_VIEW

        //Se a música tiver vazia, ou for menor que 3    
        If Empty(cInstr) .Or. Len(Alltrim(cInstr)) < 3
            Help(, , "Help", , "Nome do Instrumento Inválido!", 1, 0, , , , , , {"Insira um nome válido que tenha mais que 3 caracteres"})
            lRet := .F.
        EndIf
    EndIf

Return


/*Função de auditoria para gravar operação realizada na tabela ZC1*/
User Function GrvAcaoM(oModel)
    Local nOperation := oModel:GetOperation()
    Local cAcao      := ''
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local nRecno     := 0
    Local lRet       := .T.
    Local cServer    := GetClientIp()


    lRet := FwFormCommit(oModel)
    nRecno := ZC2->(RecNo())

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

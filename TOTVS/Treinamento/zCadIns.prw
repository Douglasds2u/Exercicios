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

/*Função de auditoria para gravar operação realizada na tabela ZC1*/
User Function FGrvAcao(oModel)
    
    Local aArea := GetArea()
    Local nOperation := oModel:GetOperation() //Pega as operações executadas nas tabelas
    Local lRet  := .T.
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr() // Retorna o Código do usuário logado
    Local cAcao      := ""
    Local nRecno  := 0
    Local cServer    := GetClientIp() // Pega o IP da máquina local
    //Variáveis usadas na tratativa de percorrer a grid
    Local nLinha     := 0
    Local aAreaZC1   := {}
    Local aAreaZC2   := {}
    Local aAreaZC3   := {}
    Local aSaveLines := {}
    Local oModelPad  := Nil
    Local oMdlField  := Nil
    Local oModelGrid := Nil
    Local oMdlGridN  := Nil
    
    //Define as variáveis que serão usadas
    aAreaZC1   := ZC1->(FWGetArea())
    aAreaZC2   := ZC2->(FWGetArea())
    aAreaZC3   := ZC3->(FWGetArea())
    aSaveLines := FWSaveRows()
    lRet := FwFormCommit(oModel)

    //Pegando os modelos de dados
    oModelPad  := FWModelActive()
    oMdlField  := oModelPad:GetModel('ZC1MASTER')
    oModelGrid := oModelPad:GetModel('ZC2DETAIL')
    oMdlGridN  := oModelPad:GetModel('ZC3DETAIL')
    //cCodTab    := oModelPad:GetValue("ZC1MASTER", "ZC1_COD")

    DbSelectArea("ZC1")
    ZC1->(DbSetOrder(1)) //ZC1_FILIAL + ZC1_COD
    ZC1->(DbGoTop())

    If oMdlField:IsModified() // Valida se o modelo foi modificado

        //Verifica as operações executadas nos registros
        If nOperation == MODEL_OPERATION_INSERT
            cAcao := 'Inclusão'

        ElseIf nOperation == MODEL_OPERATION_UPDATE
            cAcao := 'Alteração'

        EndIf
    EndIf

    If nOperation == MODEL_OPERATION_DELETE
        cAcao := 'Exclusão'
    EndIf
        
    Set Deleted Off
    //Posiciona na tabela ZC1
    If !(Empty(cAcao)) .and. ZC1->(DbSeek(FWxFilial('ZC1') + oMdlField:GetValue("ZC1_COD") ))

        nRecno := ZC1->(RecNo())

        //Grava as operações executadas na Tabela customizada de auditoria ZZ1
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
        ZZ1->(MsUnLock()) // Comfirma e finaliza a operação
    EndIf 
    Set Deleted On  

    ZC1->(DbCloseArea())       

    DbSelectArea("ZC2")
    ZC2->(DbSetOrder(1)) //ZC2_FILIAL + ZC2_COD + ZC2_MARCA
    ZC2->(DbGoTop())

    If oModelGrid:IsModified()
  
        For nLinha := 1 To oModelGrid:Length()//Percorrendo a grid com os itens

            cAcao := ""

            oModelGrid:GoLine(nLinha)//Posicionando na linha atual
        
            If oModelGrid:IsInserted()
                cAcao := 'Inclusão'
                
            ElseIf oModelGrid:IsUpdated()
                cAcao := 'Alteração'

            ElseIf oModelGrid:IsDeleted()
                cAcao := 'Exclusão'
                          
            EndIf 

            Set Deleted Off

            //Se a variável não estiver vazia e o campo estiver Posicionado na tabela ZC2
            If !(Empty(cAcao)) .and. ZC2->(DbSeek(FWxFilial('ZC2') + oModelGrid:GetValue("ZC2_COD") + oModelGrid:GetValue("ZC2_MARCA") ))

                nRecno := ZC2->(RecNo())

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
                ZZ1->(MsUnLock()) // Comfirma e finaliza a operação

            EndIf
            Set Deleted On
        Next   
    EndIf

    For nLinha := 1 To oModelGrid:Length()//Percorrendo a grid com os itens

        cAcao := ""

        oModelGrid:GoLine(nLinha)//Posicionando na linha atual

        If nOperation == MODEL_OPERATION_DELETE
            cAcao := 'Exclusão'

            Set Deleted Off

            If ZC2->(DbSeek(FWxFilial('ZC2') + oModelGrid:GetValue("ZC2_COD") + oModelGrid:GetValue("ZC2_MARCA") ))

                nRecno := ZC2->(RecNo())
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
                ZZ1->(MsUnLock()) // Comfirma e finaliza a operação

            EndIf
            Set Deleted On
        EndIf
    Next
    ZC2->(DbCloseArea())

    /*--------------------------------------------------------------------
    Validando e gravando as operações da Grid ZC3 - Tabela de Instrumentos
    ---------------------------------------------------------------------*/

    DbSelectArea("ZC3")
    ZC3->(DbSetOrder(1))//ZC3_FILIAL + ZC3_CODINS + ZC3_ITEM
    ZC3->(DbGoTop())

    If oMdlGridN:IsModified()
  
        For nLinha := 1 To oMdlGridN:Length()//Percorrendo a grid com os itens

            cAcao := ""

            oMdlGridN:GoLine(nLinha)//Posicionando na linha atual
        
            If oMdlGridN:IsInserted()
                cAcao := 'Inclusão'
                
            ElseIf oMdlGridN:IsUpdated()
                cAcao := 'Alteração'

            ElseIf oMdlGridN:IsDeleted()
                cAcao := 'Exclusão'
                          
            EndIf 

            Set Deleted Off

            //Se a variável não estiver vazia e encontrar o valor do campo Posicionado na tabela ZC3 
            If !(Empty(cAcao)) .and. ZC3->(DbSeek(FWxFilial('ZC3') + oMdlGridN:GetValue("ZC3_CODINS") + oMdlGridN:GetValue("ZC3_ITEM") ))

                nRecno := ZC3->(RecNo())

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
                ZZ1->(MsUnLock()) // Comfirma e finaliza a operação

            EndIf
            Set Deleted On
        Next   
    EndIf

    For nLinha := 1 To oMdlGridN:Length()//Percorrendo a grid com os itens

        cAcao := ""

        oMdlGridN:GoLine(nLinha)//Posicionando na linha atual

        If nOperation == MODEL_OPERATION_DELETE
            cAcao := 'Exclusão'

            Set Deleted Off

            If ZC3->(DbSeek(FWxFilial('ZC3') + oMdlGridN:GetValue("ZC3_CODINS") + oMdlGridN:GetValue("ZC3_ITEM") ))

                nRecno := ZC3->(RecNo())
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
                ZZ1->(MsUnLock()) // Comfirma e finaliza a operação

            EndIf
            Set Deleted On
        EndIf
    Next
    ZC3->(DbCloseArea())
    FWRestRows(aSaveLines)
    FWRestArea(aAreaZC1)
    FWRestArea(aAreaZC2)
    FWRestArea(aAreaZC3)
    RestArea(aArea)

Return lRet
    
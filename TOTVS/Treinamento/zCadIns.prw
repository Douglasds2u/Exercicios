//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

/* -------------------------------------------------------------------------
Nome: zCadIns
Rotina para cadastro Instrumentos (Tipos X Marcas X Descri��o Instrumentos).
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

    //Defini��o do menu
    aRotina := MenuDef()

    //Instanciando o Browse
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cTabPai)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()

    oBrowse:Activate()

    RestArea(aArea)

Return

/*Esta � a camada de controle (Adicionando os bot�es no browse)*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.zCadIns" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.zCadIns" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.zCadIns" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Exclu�r"      ACTION "VIEWDEF.zCadIns" OPERATION 5 ACCESS 0
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

    //Cria a visualiza��o do Cadastro
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

    //Definindo a visualiza��o das estruturas em cada Grid
    oView:SetOwnerView("VIEW_ZC1", "CABEC_PAI")
    oView:SetOwnerView("VIEW_ZC2", "MEIO_ESQUERDA")
    oView:SetOwnerView("VIEW_ZC3", "MEIO_DIREITA")
    oView:SetOwnerView("VIEW_TOT", "ENCH_TOT")

    //Definindo os T�tulos das Grids
    oView:EnableTitleView("VIEW_ZC1", "Tipo de Instrumento M�sical")
	oView:EnableTitleView("VIEW_ZC2", "Marca do Instrumento")
    oView:EnableTitleView("VIEW_ZC3", "Descri��o do Instrumento")

    //Removendo campos
    oStruFilho:RemoveField("ZC2_TPINS")
    oStruFilho:RemoveField("ZC2_NOME")
    oStruNeto:RemoveField("ZC3_COD")

    //Adicionando campo incremental na grid
    oView:AddIncrementField("VIEW_ZC3", "ZC3_ITEM")

    //Adiciona bot�es direto no outras a��es na ViewDef
    oView:addUserButton("Imprimir", "MAGIC_BMP", {|| Alert("Em constru��o")               }, , , , .F.)

Return oView

/*Fun��o de auditoria para gravar opera��o realizada na tabela ZC1*/
User Function FGrvAcao(oModel)
    
    Local aArea := GetArea()
    Local nOperation := oModel:GetOperation()
    Local lRet  := .T.
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local cAcao      := ""
    Local nRecnoZC1  := 0
    Local nRecnoZC2  := 0
    Local cServer    := GetClientIp()
    //Vari�veis usadas na tratativa de percorrer a grid
    Local nLinha     := 0
    Local aAreaZC1   := {}
    Local aAreaZC2   := {}
    Local aSaveLines := {}
    Local oModelPad  := Nil
    Local oMdlField  := Nil
    Local oModelGrid := Nil
    //Local cCodTab    := ""
    
    //Define as vari�veis que ser�o usadas
    aAreaZC2   := ZC2->(FWGetArea())
    aAreaZC1   := ZC1->(FWGetArea())
    aSaveLines := FWSaveRows()
    lRet := FwFormCommit(oModel)

    //Pegando os modelos de dados
    oModelPad  := FWModelActive()
    oMdlField  := oModelPad:GetModel('ZC1MASTER')
    oModelGrid := oModelPad:GetModel('ZC2DETAIL')
    //cCodTab    := oModelPad:GetValue("ZC1MASTER", "ZC1_COD")

    DbSelectArea("ZC1")
    ZC1->(DbSetOrder(1)) //ZC1_FILIAL + ZC1_COD

    nRecnoZC1 := ZC1->(RecNo())

    If oMdlField:IsModified()

        If nOperation == MODEL_OPERATION_INSERT
            cAcao := 'Inclus�o'

        ElseIf nOperation == MODEL_OPERATION_UPDATE
            cAcao := 'Altera��o'

        ElseIF nOperation == MODEL_OPERATION_DELETE
            cAcao := 'Exclus�o'

        EndIf
        
        //Posiciona na tabela ZC1
        ZC1->(DbSeek(FWxFilial('ZC1') + oMdlField:GetValue("ZC1_COD") ))

        DbSelectArea("ZZ1")
        RecLock("ZZ1", .T.)
            ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
            ZZ1->ZZ1_COD    := GETSXENUM("ZZ1","ZZ1_COD")
            ZZ1->ZZ1_ACAO   := cAcao
            ZZ1->ZZ1_DATA   := dData
            ZZ1->ZZ1_HORA   := cHora
            ZZ1->ZZ1_USER   := cCodUsr
            ZZ1->ZZ1_IP     := cServer
            ZZ1->ZZ1_RECNO  := nRecnoZC1
        MsUnLock() // Comfirma e finaliza a opera��o
    EndIf


    DbSelectArea("ZC2")
    ZC2->(DbSetOrder(1)) //ZC2_FILIAL + ZC2_COD + ZC2_MARCA

    nRecnoZC2 := ZC2->(RecNo())

    If oModelGrid:IsModified()
  
        For nLinha := 1 To oModelGrid:Length()//Percorrendo a grid com os itens

            oModelGrid:GoLine(nLinha)//Posicionando na linha atual
        
            If oModelGrid:IsInserted()
                cAcao := 'Inclus�o'
                
            ElseIf oModelGrid:IsUpdated()
                cAcao := 'Altera��o'
                
            ElseIF oModelGrid:IsDeleted()
                cAcao := 'Exclus�o'
                          
            EndIf 
        
        Next 

        //Posiciona na tabela ZC2
        ZC2->(DbSeek(FWxFilial('ZC2') + oModelGrid:GetValue("ZC2_COD") + oModelGrid:GetValue("ZC2_MARCA") ))

        
        DbSelectArea("ZZ1")
        RecLock("ZZ1", .T.)
            ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
            ZZ1->ZZ1_COD    := GETSXENUM("ZZ1","ZZ1_COD")
            ZZ1->ZZ1_ACAO   := cAcao
            ZZ1->ZZ1_DATA   := dData
            ZZ1->ZZ1_HORA   := cHora
            ZZ1->ZZ1_USER   := cCodUsr
            ZZ1->ZZ1_IP     := cServer
            ZZ1->ZZ1_RECNO  := nRecnoZC2
        MsUnLock() // Comfirma e finaliza a opera��o  
    EndIf

    FWRestRows(aSaveLines)
    FWRestArea(aAreaZC1)
    FWRestArea(aAreaZC2)
    RestArea(aArea)

Return lRet
    
    
    
    

    
    /*Local aArea      := GetArea()
    Local nOperation := oModel:GetOperation()
    Local cAcao      := ''
    Local dData      := Date()
    Local cHora      := Time()
    Local cCodUsr    := RetCodUsr()
    Local nRecno     := 0
    Local lRet       := .T.
    Local cServer    := GetClientIp()
    Local nGridZC2   := 0
    Local oZC1Master := oModel:GetModelStruct("ZC1MASTER")[3]
    Local oZC2Detail := oModel:GetModelStruct("ZC2DETAIL")[3]

    lRet := FwFormCommit(oModel)
    nRecno := ZC1->(RecNo())
        
    If nOperation == MODEL_OPERATION_INSERT
        cAcao := 'Inclus�o'

    ElseIf nOperation == MODEL_OPERATION_UPDATE
        cAcao := 'Altera��o'

    ElseIF nOperation == MODEL_OPERATION_DELETE
        cAcao := 'Exclus�o'

    EndIf

    If (oZC1Master:IsModified("ZC1MASTER")) 
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
        MsUnLock() // Comfirma e finaliza a opera��o
    EndIf


    DbSelectArea("ZC2")
    ZC2->(DBSetOrder(2))
        
    For nGridZC2 := 1 to oZC2Detail:Length()
        
        If ZC2->(DBSeek(xFilial("ZC2") + oZC2Detail:GetValue("ZC2_COD") + oZC2Detail:GetValue("ZC2_MARCA")))
           nRecno := ZC2->(RecNo())

            If(oZC2Detail:IsFieldUpdated("ZC2_MARCA")) 

                If nOperation == MODEL_OPERATION_INSERT
                    cAcao := 'Inclus�o'

                ElseIf nOperation == MODEL_OPERATION_UPDATE
                    cAcao := 'Altera��o'

                ElseIF nOperation == MODEL_OPERATION_DELETE
                    cAcao := 'Exclus�o'

                EndIf                 
            EndIf   
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
        MsUnLock() // Comfirma e finaliza a opera��o  
    Next nGridZC2                  
RestArea(aArea)
Return lRet*/

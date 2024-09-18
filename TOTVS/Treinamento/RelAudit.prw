#INCLUDE "TOTVS.CH"

/* -----------------------------------------------------------------
Nome: RelAudit
Rotina para impressão de relatório de Auditoria Cad. de Instrumentos
Autor: Douglas Sousa
Data: 09/09/2024
------------------------------------------------------------------*/


User Function RelAudit()
    
    Local oReport := Nil
    Local cPerg   := 'RELAUDIT'
        
        If Pergunte(cPerg, .T.)        
            oReport := ReportDef(cPerg)       
            oReport:PrintDialog()
        EndIf
Return

// Definição da estrutura do relatório
Static Function ReportDef(cPerg)
        
    Local oReport   := Nil
    Local oSection1 := Nil
    Local cTitulo   := 'Relatório de auditoria Cad. de Instrumentos'

    oReport := Treport():New('RelAudit', cTitulo, cPerg, {|oReport| PrintReport(oReport)})

    oReport:SetCOlSpace(10)

    // Definição da seção 1 - Dados das COncessionárias de veículos
    oSection1 := TRSection():New(oReport, 'Auditoria')

    TRCell():New(oSection1, 'ZZ1_COD'        , , 'Cod. Auditoria'    , '', TamSX3('ZZ1_COD')[1])
    TRCell():New(oSection1, 'ZZ1_ACAO'       , , 'Ação'              , '', TamSX3('ZZ1_ACAO')[1])
    TRCell():New(oSection1, 'ZZ1_RECNO'      , , 'Recno'             , '', TamSX3('ZZ1_RECNO')[1])
    TRCell():New(oSection1, 'ZZ1_DATA'       , , 'Data'              , '', TamSX3('ZZ1_DATA')[1])
    TRCell():New(oSection1, 'ZZ1_HORA'       , , 'Hora'              , '', TamSX3('ZZ1_HORA')[1])
    TRCell():New(oSection1, 'ZZ1_CODUSU'     , , 'Código do Usuário' , '', TamSX3('ZZ1_CODUSU')[1])
    TRCell():New(oSection1, 'ZZ1_NOMUSU'     , , 'Nome do Usuário'   , '', TamSX3('ZZ1_NOMUSU')[1])
    TRCell():New(oSection1, 'ZZ1_IP'         , , 'Ip'                , '', TamSX3('ZZ1_IP')[1])

Return oReport


Static Function PrintReport(oReport)       
    Local oSection1 := oReport:Section(1)
    Local cAliasIns  := GetNextAlias()

    /*---------------------------------------
    Fazendo uma query utilizando Embedded SQL
    ---------------------------------------*/
    BeginSql ALias cAliasIns

        SELECT  ZZ1.ZZ1_COD, ZZ1.ZZ1_RECNO, ZZ1.ZZ1_ACAO, ZZ1.ZZ1_DATA, ZZ1.ZZ1_HORA, ZZ1.ZZ1_CODUSU, ZZ1.ZZ1_NOMUSU, ZZ1.ZZ1_IP
        FROM %Table:ZZ1% AS ZZ1
        WHERE ZZ1_FILIAL = %xFilial:ZZ1% // Usando o where na ordem de algum índice da tabela, no caso o ZZ1_FILIAL+ZZ1_COD
            AND ZZ1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND ZZ1.%NotDel%
    EndSql

    If !((cAliasIns)->(EoF()))
        //Enquanto não for o fim dos registros
        While !((cAliasIns)->(EoF()))
            //Pegando os dados e inicializando a section
            oSection1:Init()

            oSection1:Cell('ZZ1_COD'):SetValue(Alltrim((cAliasIns)->ZZ1_COD))
            oSection1:Cell('ZZ1_ACAO'):SetValue(Alltrim((cAliasIns)->ZZ1_ACAO))
            oSection1:Cell('ZZ1_RECNO'):SetValue(cValToChar((cAliasIns)->ZZ1_RECNO))
            oSection1:Cell('ZZ1_DATA'):SetValue(Alltrim((cAliasIns)->ZZ1_DATA))
            oSection1:Cell('ZZ1_HORA'):SetValue(Alltrim((cAliasIns)->ZZ1_HORA))
            oSection1:Cell('ZZ1_CODUSU'):SetValue(Alltrim((cAliasIns)->ZZ1_CODUSU))
            oSection1:Cell('ZZ1_NOMUSU'):SetValue(Alltrim((cAliasIns)->ZZ1_NOMUSU))
            oSection1:Cell('ZZ1_IP'):SetValue(Alltrim((cAliasIns)->ZZ1_IP))

            oSection1:PrintLine()
            oReport:ThinLine()
            oReport:SkipLine(2)
            (cAliasIns) -> (DbSkip())                        
        endDo
        oSection1:Finish()
    EndIf
    (cAliasIns)->(DbCloseArea())
Return

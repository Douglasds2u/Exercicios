#INCLUDE "TOTVS.CH"

/* -----------------------------------------------------------------------------------------
Nome: RelConVe
Rotina para impress�o de relat�rio de concession�rias X ve�culos
Autor: Douglas Sousa
Data: 30/08/2024
------------------------------------------------------------------------------------------ */


User Function RelConVe()
    
    Local oReport := Nil
    Local cPerg   := 'RELCONVE'
        
        If Pergunte(cPerg, .T.)        
            oReport := ReportDef(cPerg)       
            oReport:PrintDialog()
        EndIf
Return


// Defini��o da estrutura do relat�rio
Static Function ReportDef(cPerg)
        
    Local oReport   := Nil
    Local oSection1 := Nil
    Local oSection2 := Nil
    Local cTitulo   := 'Concession�rias X Ve�culos'

    oReport := Treport():New('RelConVe', cTitulo, cPerg, {|oReport| PrintReport(oReport)})

    // Defini��o da se��o 1 - Dados das COncession�rias de ve�culos
    oSection1 := TRSection():New(oReport, 'Concession�rias')

    TRCell():New(oSection1, 'ZA2_CODIGO'     , , 'Cod.Concession�ria'   , '', TamSX3('ZA2_CODIGO')[1])
    TRCell():New(oSection1, 'ZA2_NOME'       , , 'Nome'                 , '', TamSX3('ZA2_NOME')[1])
    TRCell():New(oSection1, 'ZA2_LOJA'       , , 'Loja'                    , '', TamSX3('ZA2_LOJA')[1])

    // Defini��o da se��o 2 - Ve�culos
    oSection2 := TRSection():New(oReport, 'Ve�culos')

    TRCell():New(oSection2, 'ZA3_VEIC'     , , 'Ve�culo'        , '', TamSX3('ZA3_VEIC')[1])
    TRCell():New(oSection2, 'ZA3_NOME'     , , 'Modelo'         , '', TamSX3('ZA3_NOME')[1])
    TRCell():New(oSection2, 'ZA3_DESC'     , , 'Descri��o'      , '', TamSX3('ZA3_DESC')[1])
    TRCell():New(oSection2, 'ZA3_COR'      , , 'Cor'            , '', TamSX3('ZA3_COR')[1])

Return oReport


    // Impress�o do relat�rio de acordo com o filtro informado
Static Function PrintReport(oReport)
        
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)
    Local cAliasCo  := GetNextAlias()
    Local cAliasVe  := GetNextAlias()

    /*---------------------------------------
    Fazendo uma query utilizando Embedded SQL
    ---------------------------------------*/
    BeginSql ALias cAliasCo

        SELECT  ZA2.ZA2_CODIGO,
                ZA2.ZA2_NOME,
                ZA2.ZA2_LOJA
        FROM %Table:ZA2% AS ZA2
        WHERE ZA2_FILIAL = %xFilial:ZA2% // Usando o where na ordem de algum �ndice da tabela, no caso o A1_FILIAL+A1_COD+A1_LOJA
            AND ZA2_CODIGO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
            AND ZA2.%NotDel%
    EndSql


    If !((cAliasCo)->(EoF()))
        //Enquanto n�o for o fim dos registros
        While !((cAliasCo)->(EoF()))
            //Pegando os dados e inicializando a section
            oSection1:Init()

            oSection1:Cell('ZA2_CODIGO'):SetValue( Alltrim( (cAliasCo)->ZA2_CODIGO ))
            oSection1:Cell('ZA2_NOME'):SetValue( Alltrim( (cAliasCo)->ZA2_NOME ))
            oSection1:Cell('ZA2_LOJA'):SetValue( Alltrim( (cAliasCo)->ZA2_LOJA ))

            oSection1:PrintLine()
            oReport:ThinLine()

            BeginSql Alias cAliasVe

                SELECT  ZA3.ZA3_VEIC, // Adicionado para usar no filtro da SC6
                        ZA3.ZA3_NOME,
                        ZA3.ZA3_DESC,
                        ZA3.ZA3_COR
                FROM %Table:ZA3% AS ZA3
                WHERE ZA3.ZA3_FILIAL = %Exp:xFilial("ZA3")%
                    AND ZA3.ZA3_CODIGO = %Exp:(cAliasCo)->ZA2_CODIGO%
                    AND ZA3.%NotDel%

            EndSql

            If !((cAliasVe)->(EoF()))

                    while !((cAliasVe)->(EoF()))

                        oSection2:Init()
                        oSection2:Cell('ZA3_VEIC'):SetValue((cAliasVe)->ZA3_VEIC)
                        oSection2:Cell('ZA3_NOME'):SetValue((cAliasVe)->ZA3_NOME)
                        oSection2:Cell('ZA3_DESC'):SetValue((cAliasVe)->ZA3_DESC)
                        oSection2:Cell('ZA3_COR'):SetValue((cAliasVe)->ZA3_COR)

                        oSection2:PrintLine()

                        (cAliasVe)->(DbSkip())

                    endDo

                    oSection2:Finish()
                    
            EndIf

            (cAliasVe)->(DbCloseArea()) // Esse closeArea � referente a se��o anterior que j� foi encerrada.
            (cAliasCo)->(DbSkip())
            oSection1:Finish()
        endDo
    EndIf
Return

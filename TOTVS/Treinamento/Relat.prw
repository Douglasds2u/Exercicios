#INCLUDE "TOTVS.CH"


// Relat�rio de impress�o de Pedidos por cliente com produtos
User Function Relat()
    Local oReport := Nil
    Local cPerg   := 'RELAT'

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
    Local oSection3 := Nil
    Local cTitulo   := 'Pedidos por Cliente'

    oReport := Treport():New('Relat', cTitulo, cPerg, {|oReport| PrintReport(oReport)})

    // Defini��o da se��o 1 - Dados do cliente
    oSection1 := TRSection():New(oReport, 'Cliente')

    TRCell():New(oSection1, 'A1_COD'     , , 'Cod.Cliente'   , '', TamSX3('A1_COD')[1])
    TRCell():New(oSection1, 'A1_LOJA'    , , 'Loja'          , '', TamSX3('A1_LOJA')[1])
    TRCell():New(oSection1, 'A1_NOME'    , , 'Nome:'         , '', TamSX3('A1_NOME')[1])

    // Defini��o da se��o 2 - Pedidos do cliente
    oSection2 := TRSection():New(oReport, 'Pedidos')

    TRCell():New(oSection2, 'C5_NUM'    , , 'Pedido:'     , '', TamSX3('C5_NUM')[1])

    // Defini��o da se��o 3 - Itens dos Pedidos do cliente
    oSection3 := TRSection():New(oReport, 'Produtos')

    TRCell():New(oSection3, 'C6_PRODUTO'   , , 'Produto:'       , '', TamSX3('C6_PRODUTO')[1])
    TRCell():New(oSection3, 'C6_DESCRI'    , , 'Descri��o:'     , '', TamSX3('C6_DESCRI')[1])
    TRCell():New(oSection3, 'C6_QTDVEN'    , , 'Quantidade:'    , '@E 9999', TamSX3('C6_QTDVEN')[1])
    TRCell():New(oSection3, 'C6_VALOR'     , , 'Vlr Total:'     , '@E 9,999,999.99', TamSX3('C6_VALOR')[1])
Return oReport

// Impress�o do relat�rio de acordo com o filtro informado
Static Function PrintReport(oReport)
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)
    Local oSection3 := oReport:Section(3)
    Local cAliasCl  := GetNextAlias()
    Local cAliasPd  := GetNextAlias()
    Local cAliasPr  := GetNextAlias()
    //Local nRegs     := 0

    BeginSql ALias cAliasCl

        SELECT SA1.A1_COD,
               SA1.A1_lOJA,
               SA1.A1_NOME
        FROM %Table:SA1% AS SA1
        WHERE A1_FILIAL = %xFilial:SA1% // Usando o where na ordem de algum �ndice da tabela, no caso o A1_FILIAL+A1_COD+A1_LOJA
            AND A1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR03%
            AND A1_LOJA BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR04%
            AND SA1.%NotDel%

    EndSql

    // Count To nRegs // Recomendo s� usar se precisar saber a quantidade de linha para mostrar em algum lugar, para saber se registros foram encontrados pode usar o EOF()

    If !((cAliasCl)->(EoF())) //nRegs > 0

        // (cAliasCl)->( DbGoTop()) // N�o � necess�rio pois j� est� no come�o, por�m se usar o "Count To nRegs", a� precisa usar

        While !((cAliasCl)->(EoF()))

            oSection1:Init()

            oSection1:Cell('A1_COD'):SetValue( Alltrim( (cAliasCl)->A1_COD ))
            oSection1:Cell('A1_LOJA'):SetValue( Alltrim( (cAliasCl)->A1_LOJA ))
            oSection1:Cell('A1_NOME'):SetValue( Alltrim( (cAliasCl)->A1_NOME ))

            oSection1:PrintLine()
            oReport:ThinLine()

            BeginSql Alias cAliasPd

                SELECT SC5.C5_FILIAL, // Adicionado para usar no filtro da SC6
                       SC5.C5_NUM
                FROM %Table:SC5% AS SC5
                WHERE SC5.C5_FILIAL = %Exp:xFilial("SC5")% // Sempre importante usar filial em todos os filtros, al�m da organiza��o de �ndices comentado na linha 81
                    AND SC5.C5_CLIENTE = %Exp:(cAliasCl)->A1_COD%
                    AND SC5.C5_LOJACLI = %Exp:(cAliasCl)->A1_LOJA%
                    AND SC5.%NotDel%

            EndSql

            // nRegs := 0

            // Count To nRegs // Mesmo coment�rio da linha 68

    If !((cAliasPd)->(EoF())) // nRegs > 0

        // (cAliasPd)->( DbGoTop() ) // Mesmo coment�rio da linha 72

        While !((cAliasPd)->(EoF()))

            oSection2:Init()
            oSection2:Cell('C5_NUM'):SetValue( Alltrim( (cAliasPd)->C5_NUM ) )

            oSection2:PrintLine()

            BeginSql Alias cAliasPr

                SELECT SC6.C6_PRODUTO,
                       SC6.C6_QTDVEN,
                       SC6.C6_DESCRI,
                       SC6.C6_VALOR
                FROM %Table:SC6% AS SC6
                WHERE SC6.C6_FILIAL = %Exp:(cAliasPd)->C5_FILIAL% // Mesmo coment�rio da linha 90
                    AND SC6.C6_NUM = %Exp:(cAliasPd)->C5_NUM%
                    AND SC6.%NotDel%

            EndSql

            // nRegs := 0

            // Count To nRegs // Mesmo coment�rio da linha 68

    If !((cAliasPr)->(EoF())) // nRegs > 0

        // (cAliasPr)->(DbGoTop()) // Mesmo coment�rio da linha 72

        while !((cAliasPr)->(EoF()))

            oSection3:Init()
            oSection3:Cell('C6_PRODUTO'):SetValue( Alltrim( (cAliasPr)->C6_PRODUTO ) )
            oSection3:Cell('C6_DESCRI'):SetValue( (cAliasPr)->C6_DESCRI )
            oSection3:Cell('C6_QTDVEN'):SetValue( (cAliasPr)->C6_QTDVEN )
            oSection3:Cell('C6_VALOR'):SetValue( (cAliasPr)->C6_VALOR )

            oSection3:PrintLine()

            (cAliasPr)->(DbSkip())

        endDo

        oSection3:Finish()
        oReport:SkipLine(1)

    EndIf

            oSection2:Finish()
            (cAliasPr)->(DbCloseArea()) // Esse closeArea � referente a se��o anterior que j� foi encerrada na linha 147, sendo assim faz sentido

            (cAliasPd)->(DbSkip())

        EndDo

    EndIf

            (cAliasPd)->(DbCloseArea()) // Coment�rio semelhante na linha 153

            (cAliasCl)->(DbSkip())

            oReport:SkipLine(2)
            oSection1:Finish()

        EndDo

    Else
        // Aqui pode colocar um aviso que nenhum cliente foi encontrado no filtro.
    EndIf

    (cAliasCl)->(DbCloseArea())

Return

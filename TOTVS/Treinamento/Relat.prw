#INCLUDE "TOTVS.CH"


User Function Relat()

Local oReport
Local cPerg := 'RELAT'

Pergunte(cPerg, .T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cTitulo := 'Pedidos por Cliente'

oReport := Treport():New('Relat', cTitulo, cPerg, {|oReport| PrintReport(oReport)})

oSection1 := TRSection():New(oReport, 'Cliente')

TRCell():New(oSection1, 'A1_COD'    , , 'Cod.Cliente'   , '', TamSX3('A1_COD')[1])
TRCell():New(oSection1, 'A1_LOJA'    , , 'Loja'   , '', TamSX3('A1_LOJA')[1])
TRCell():New(oSection1, 'A1_NOME'    , , 'Nome:'   , '', TamSX3('A1_NOME')[1])

oSection2 := TRSection():New(oReport, 'Pedidos')

TRCell():New(oSection2, 'C5_NUM'    , , 'Pedido:'     , '', TamSX3('C5_NUM')[1])

oSection3 := TRSection():New(oReport, 'Produtos')

TRCell():New(oSection3, 'C6_PRODUTO'   , , 'Produto:'    , '', TamSX3('C6_PRODUTO')[1])
TRCell():New(oSection3, 'C6_DESCRI'   , , 'Descrição'    , '', TamSX3('C6_DESCRI')[1])
TRCell():New(oSection3, 'C6_QTDVEN'   , , 'Quantidade:'    , '@E 9999', TamSX3('C6_QTDVEN')[1])
TRCell():New(oSection3, 'C6_VALOR'   , , 'Vlr Total:'    , '@E 9,999,999.99', TamSX3('C6_VALOR')[1])

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local cAliasCl  := GetNextAlias()
Local cAliasPd  := GetNextAlias()
Local cAliasPr  := GetNextAlias()
Local nRegs     := 0

BeginSql ALias cAliasCl

    SELECT  SA1.A1_COD,
            SA1.A1_lOJA,
            SA1.A1_NOME
    FROM %Table:SA1% AS SA1
    WHERE SA1.%NotDel%
    AND A1_FILIAL = %xFilial:SA1%
    AND A1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR03%
    AND A1_LOJA BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR04%

EndSql

Count To nRegs

If nRegs > 0

    (cAliasCl)->( DbGoTop())

    While (cAliasCl)->(!EoF())

        oSection1:Init()

        oSection1:Cell('A1_COD'):SetValue( Alltrim( (cAliasCl)->A1_COD ))
        oSection1:Cell('A1_LOJA'):SetValue( Alltrim( (cAliasCl)->A1_LOJA ))
        oSection1:Cell('A1_NOME'):SetValue( Alltrim( (cAliasCl)->A1_NOME ))

        oSection1:PrintLine()
        oReport:ThinLine()

BeginSql Alias cAliasPd

    SELECT SC5.C5_NUM
    FROM %Table:SC5% AS SC5
    WHERE SC5.%NotDel%
    AND SC5.C5_CLIENTE = %Exp:(cAliasCl)->A1_COD%
    AND SC5.C5_LOJACLI = %Exp:(cAliasCl)->A1_LOJA%

EndSql

nRegs := 0

Count To nRegs

If nRegs > 0

    (cAliasPd)->( DbGoTop() )

    While (cAliasPd)->(!EoF())

        oSection2:Init()
        oSection2:Cell('C5_NUM'):SetValue( Alltrim( (cAliasPd)->C5_NUM ) )

        oSection2:PrintLine()

BeginSql Alias cAliasPr

    SELECT  SC6.C6_PRODUTO,
            SC6.C6_QTDVEN,
            SC6.C6_DESCRI,
            SC6.C6_VALOR
    FROM %Table:SC6% AS SC6
    WHERE SC6.%NotDel%
    AND SC6.C6_NUM = %Exp:(cAliasPd)->C5_NUM%

EndSql

nRegs := 0

Count To nRegs

If nRegs > 0

    (cAliasPr)->(DbGoTop())

    while (cAliasPr)->(!EoF())

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
    (cAliasPr)->(DbCloseArea())

    (cAliasPd)->(DbSkip())

EndDo

EndIf

    (cAliasPd)->(DbCloseArea())

    (cAliasCl)->(DbSkip())
    oReport:SkipLine(2)
    oSection1:Finish()

EndDo

EndIf

    (cAliasCl)->(DbCloseArea())

Return

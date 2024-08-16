#INCLUDE "TOTVS.CH"


User Function Relat()

Local oReport
Local cPerg := 'RELAT'

Pergunte(cPerg, .F.)

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
TRCell():New(oSection1, 'A1_COD'    , , 'Nome:'   , '', TamSX3('A1_NOME')[1])

oSection2 := TRSection():New(oReport, 'Pedidos')

TRCell():New(oSection2, 'C5_NUM'    , , 'Pedido:'     , '', TamSX3('C5_NUM')[1])

oSection3 := TRSection():New(oReport, 'Produtos')

TRCell():New(oSection3, 'C6_PRODUTO'   , , 'Produto:'    , '', TamSX3('C6_PRODUTO')[1])
TRCell():New(oSection3, 'C6_DESCRI'   , , 'Descrição'    , '', TamSX3('C6_DESCRI')[1])
TRCell():New(oSection3, 'C6_QTDVEN'   , , 'Quantidade:'    , '', TamSX3('C6_QTDVEN')[1])
TRCell():New(oSection3, 'C6_VALOR'   , , 'Vlr Total:'    , '', TamSX3('C6_VALOR')[1])

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
    WHERE SA1.%NotDeL%
    AND A1_FILIAL = %xFilial:SA1%
    AND A1_COD BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR03%
    AND A1_LOJA BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR04%

EndSql



Return

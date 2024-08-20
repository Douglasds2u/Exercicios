#INCLUDE "TOTVS.CH"


User Function RelPvenda()

Local oReport := RptDef()
oReport:PrintDialog() // Exibe a tela de configuração para impressão do relatório


Return NIL

Static Function RptDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relatório, guarda a função PrintReport onde irá retornar os dados da primeira página do relatório
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelPvenda", "Ficha de pedido de venda", /*cPerg*/, {|oReportRet| PrintReport(oReportRet)}, "Impressão de ficha de pedido de venda em TReport simples.")
Local oSection1  := NIL
//Local oSection2  := NIL

oReportRet:SetPortrait(.T.) //Define por padrão começar o relatorio com a opção retrato
oReportRet:SetColSpace(2) //Define o espaçamento entre colunas


/*-------------------------------------------------------------------------------------
 Cria o layout do relatório com as colunas e campos que definimos da respectiva tabela
-------------------------------------------------------------------------------------*/
oSection1 := TRSection():New(oReportRet, "Dados do cliente", {"SC5"})


TRCell():New(oSection1, "C5_NUM", "SC5", , ,10, ,)
TRCell():New(oSection1, "C5_CLIENTE", "SC5", , ,10, ,)
TRCell():New(oSection1, "C5_LOJACLI", "SC5", , ,5, ,)
TRCell():New(oSection1, "C5_EMISSAO", "SC5", , ,20, ,)
TRCell():New(oSection1, "C6_PRODUTO", "SC6", , ,20, ,)
TRCell():New(oSection1, "C6_DESCRI", "SC6", , ,25 , ,)
TRCell():New(oSection1, "C6_QTDVEN", "SC6", , ,10, ,)
TRCell():New(oSection1, "C6_VALOR", "SC6", , ,20 , ,)
TRCell():New(oSection1, "C6_ENTREG", "SC6", , ,20, ,)

/*oSection2 := TRSection():New(oReportRet, "Dados dos pedidos", {"SC6"})


TRCell():New(oSection2, "C6_PRODUTO", "SC6", , ,15, ,)
TRCell():New(oSection2, "C6_DESCRI", "SC6", , ,30, ,)
TRCell():New(oSection2, "C6_UM", "SC6", , ,15, ,)
TRCell():New(oSection2, "C6_QTDVEN", "SC6", , ,15, ,)
TRCell():New(oSection2, "C6_PRCVEN", "SC6", , ,15, ,)
TRCell():New(oSection2, "C6_VALOR", "SC6", , ,30, ,)
TRCell():New(oSection2, "C6_ENTREG", "SC6", , ,50, ,)
*/
Return oReportRet


Static Function PrintReport(oReportRet)

Local oSecPrint1 := oReportRet:Section(1)
//Local oSecPrint2 := oReportRet:Section(2)
/*-----------------------------------------------------------------
Inicializa as configurações e define a primeira página do relatório
------------------------------------------------------------------*/

//Iniciando a sessão e alimentando as colunas com os dados
oSecPrint1:Init()

oSecPrint1:Cell("C5_NUM"):SetValue(SC5->C5_NUM)
oSecPrint1:Cell("C5_CLIENTE"):SetValue(SC5->C5_CLIENTE)
oSecPrint1:Cell("C5_LOJACLI"):SetValue(SC5->C5_LOJACLI)
oSecPrint1:Cell("C5_EMISSAO"):SetValue(SC5->C5_EMISSAO)
oSecPrint1:Cell("C6_PRODUTO"):SetValue(SC6->C6_PRODUTO)
oSecPrint1:Cell("C6_DESCRI"):SetValue(SC6->C6_DESCRI)
oSecPrint1:Cell("C6_QTDVEN"):SetValue(SC6->C6_QTDVEN)
oSecPrint1:Cell("C6_VALOR"):SetValue(SC6->C6_VALOR)
oSecPrint1:Cell("C6_ENTREG"):SetValue(SC6->C6_ENTREG)

oSecPrint1:PrintLine() //Imprime os dados dos campos


/*---------------------------------------------------------------------------------------------------------------------------------------------
Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint1:Finish()

// Inicializa e alimenta a segunda sessão com os dados
/*oSecPrint2:Init()

oSecPrint2:Cell("C6_PRODUTO"):SetValue(SC6->C6_PRODUTO)
oSecPrint2:Cell("C6_DESCRI"):SetValue(SC6->C6_DESCRI)
oSecPrint2:Cell("C6_UM"):SetValue(SC6->C6_UM)
oSecPrint2:Cell("C6_QTDVEN"):SetValue(SC6->C6_QTDVEN)
oSecPrint2:Cell("C6_PRCVEN"):SetValue(SC6->C6_PRCVEN)
oSecPrint2:Cell("C6_VALOR"):SetValue(SC6->C6_VALOR)
oSecPrint2:Cell("C6_ENTREG"):SetValue(SC6->C6_ENTREG)

oSecPrint2:PrintLine()

oSecPrint2:Finish()*/

Return NIL

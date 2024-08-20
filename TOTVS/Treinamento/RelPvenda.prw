#INCLUDE "TOTVS.CH"


User Function RelPvenda()

Local oReport := RptDef()
oReport:PrintDialog() // Exibe a tela de configura��o para impress�o do relat�rio


Return NIL

Static Function RptDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relat�rio, guarda a fun��o PrintReport onde ir� retornar os dados da primeira p�gina do relat�rio
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelPvenda", "Ficha de pedido de venda", /*cPerg*/, {|oReportRet| PrintReport(oReportRet)}, "Impress�o de ficha de pedido de venda em TReport simples.")
Local oSection1  := NIL
//Local oSection2  := NIL

oReportRet:SetPortrait(.T.) //Define por padr�o come�ar o relatorio com a op��o retrato
oReportRet:SetColSpace(2) //Define o espa�amento entre colunas


/*-------------------------------------------------------------------------------------
 Cria o layout do relat�rio com as colunas e campos que definimos da respectiva tabela
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
Inicializa as configura��es e define a primeira p�gina do relat�rio
------------------------------------------------------------------*/

//Iniciando a sess�o e alimentando as colunas com os dados
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
Finaliza a impress�o do relat�rio, imprime os totalizadores, fecha as querys e �ndices tempor�rios, entre outros tratamentos do componente.
N�o � necess�rio executar o m�todo Finish se for utilizar o m�todo Print, j� que este faz o controle de inicializa��o e finaliza��o da impress�o.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint1:Finish()

// Inicializa e alimenta a segunda sess�o com os dados
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

#INCLUDE 'totvs.ch'
#INCLUDE 'topconn.ch'


User Function RelFirst()

Local oReport := NIL

oReport := FReportDef()
oReport:PrintDialog()



Return Nil 



Static Function FReportDef()



Local oReportRet := TReport():New("RelFirst","Ficha do Produto", /*cPerg*/ ,{|oReportRet| PrintReport(oReportRet)},"Impressão de ficha de produtos em TReport simples.")
Local oSection   := NIL

oReportRet:SetLandscape(.T.)

oSection := TRSection():New( oReportRet , "Dados do Produto", {"SB1"} )

TRCell():New( oSection, "B1_COD"      , "SB1")
TRCell():New( oSection, "B1_DESC"     , "SB1")
TRCell():New( oSection, "B1_TIPO"     , "SB1")
TRCell():New( oSection, "B1_UM"       , "SB1")
TRCell():New( oSection, "USUÁRIO"     , "SB1")
TRCell():New( oSection, "DATA"     , "SB1")
TRCell():New( oSection, "HORA: "     , "SB1")


Return oReportRet 


Static Function PrintReport(oReportRet)

Local oSecPrint := oReportRet:Section(1)
Local cCodUsr  := ""
Local cNomeUsr := ""
Local dData    := Date()
Local cHora    := Time()

cCodUsr   := RetCodUsr() //Retorna o código de usuário do Protheus
cNomeUsr  := UsrRetName(cCodUsr)
/*---------------------------------------------------------------------+
| Inicializa as configurações e define a primeira página do relatório |
+---------------------------------------------------------------------+*/
//Init()

// Iniciamos a nossa sessão 
oSecPrint:Init()

oSecPrint:Cell("B1_COD"):SetValue( SB1->B1_COD )
oSecPrint:Cell("B1_DESC"):SetValue( SB1->B1_DESC )
oSecPrint:Cell("B1_TIPO"):SetValue( SB1->B1_TIPO )
oSecPrint:Cell("B1_UM"):SetValue( SB1->B1_UM )
oSecPrint:Cell("USUÁRIO"):SetValue( cNomeUsr )
oSecPrint:Cell("DATA"):SetValue( dData )
oSecPrint:Cell("HORA: "):SetValue( cHora )

oSecPrint:PrintLine()

/*
Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
*/
oSecPrint:Finish()


Return NIL


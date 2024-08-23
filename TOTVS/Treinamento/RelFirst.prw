#INCLUDE 'totvs.ch'
#INCLUDE 'topconn.ch'

/* ------------------------------------------------------------
Nome: RelFirst
Rotina para impressão de ficha de produtos em TReport simples.
Autor: Douglas Sousa
Data: 20/08/2024
------------------------------------------------------------- */

User Function RelFirst()

Local oReport := NIL

oReport := FReportDef()
oReport:PrintDialog() // Exibe a tela de configuração para impressão do relatório

Return Nil 


Static Function FReportDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relatório, guarda a função PrintReport onde irá retornar os dados da primeira página do relatório
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelFirst","Ficha do Produto", /*cPerg*/ ,{|oReportRet| PrintReport(oReportRet)},"Impressão de ficha de produtos em TReport simples.")
Local oSection   := NIL

oReportRet:SetPortrait(.T.) //Define por padrão começar o relatorio com a opção retrato
oReportRet:SetColSpace(5) //Define espaçamento entre as colunas

/*-------------------------------------------------------------------------------------
 Cria o layout do relatório com as colunas e campos que definimos da respectiva tabela
 ------------------------------------------------------------------------------------*/
oSection := TRSection():New( oReportRet , "Dados do Produto", {"SB1"} )

TRCell():New( oSection, "B1_COD"      , "SB1")
TRCell():New( oSection, "B1_DESC"     , "SB1")
TRCell():New( oSection, "B1_TIPO"     , "SB1")
TRCell():New( oSection, "B1_UM"       , "SB1")
TRCell():New( oSection, "USUÁRIO"     , "SB1", , , 15, ,) // O parâmetro numérico está difinindo a quantidade de caracteres do dado a ser impresso no relatório
TRCell():New( oSection, "DATA"     , "SB1", , , 10, ,)
TRCell():New( oSection, "HORA"     , "SB1", , , 8, ,)

Return oReportRet 



Static Function PrintReport(oReportRet)

Local oSecPrint := oReportRet:Section(1)
Local cCodUsr  := RetCodUsr() //Retorna o código de usuário do Protheus
Local cNomeUsr := UsrRetName(cCodUsr) //Retorna o nome do usuário logado no sistema
Local dData    := Date()
Local cHora    := Time()

/*-------------------------------------------------------------------
Inicializa as configurações e define a primeira página do relatório 
--------------------------------------------------------------------*/

//Iniciando a sessão e alimentando as colunas com os dados
oSecPrint:Init()


oSecPrint:Cell("B1_COD"):SetValue( SB1->B1_COD )
oSecPrint:Cell("B1_DESC"):SetValue( SB1->B1_DESC )
oSecPrint:Cell("B1_TIPO"):SetValue( SB1->B1_TIPO )
oSecPrint:Cell("B1_UM"):SetValue( SB1->B1_UM )
oSecPrint:Cell("USUÁRIO"):SetValue( cNomeUsr )
oSecPrint:Cell("DATA"):SetValue( dData )
oSecPrint:Cell("HORA"):SetValue( cHora )


oSecPrint:PrintLine() // Imprime as linhas 

/*---------------------------------------------------------------------------------------------------------------------------------------------
Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint:Finish()


Return NIL

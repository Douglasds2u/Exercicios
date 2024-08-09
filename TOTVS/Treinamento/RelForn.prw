#INCLUDE 'totvs.ch'
#INCLUDE 'topconn.ch'



User Function RelForn()

Local oReport := Nil

oReport := ReportDef()
oReport:PrintDialog() // Exibe a tela de configuração para impressão do relatório

Return Nil


Static Function ReportDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relatório, guarda a função PrintReport onde irá retornar os dados da primeira página do relatório
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelForn", "Ficha de Fornecedores", /*cPerg*/, {|oReportRet| PrintReport(oReportRet)}, "Impressão de ficha de fornecedores em TReport simples.")
Local oSection := Nil

oReportRet:SetPortrait(.T.) //Define por padrão começar o relatorio com a opção retrato
oReportRet:SetColSpace(1) //Define o espaçamento entre colunas

/*-------------------------------------------------------------------------------------
 Cria o layout do relatório com as colunas e campos que definimos da respectiva tabela
-------------------------------------------------------------------------------------*/
oSection := TRSection():New(oReportRet, "Dados de fornecedores", {"SA2"})

TRCell():New(oSection, "A2_COD"      ,"SA2")
TRCell():New(oSection, "A2_NOME"     ,"SA2", , , 30, ,) // O parâmetro numérico está difinindo a quantidade de caracteres do dado a ser impresso no relatório
TRCell():New(oSection, "A2_END"      ,"SA2", , , 30, ,)
TRCell():New(oSection, "A2_BAIRRO"   ,"SA2")
TRCell():New(oSection, "A2_EST"      ,"SA2")
TRCell():New(oSection, "A2_MUN"      ,"SA2", , , 30, ,)
TRCell():New(oSection, "USUÁRIO"     ,"SA2", , , 15, ,)
TRCell():New(oSection, "DATA"        ,"SA2", , , 10, ,)
TRCell():New(oSection, "HORA"        ,"SA2", , , 8, ,)

Return oReportRet


Static Function PrintReport(oReportRet)

Local oSecPrint := oReportRet:Section(1)
Local cCodUsr   := RetCodUsr()  // Retorna código do usuário
Local cNameUsr  := UsrRetName(cCodUsr) // Retorna o nome do usuário
Local dData     := Date() // Data padrão do sistema
Local cHora     := Time()// Hora padrão do sistema

/*-----------------------------------------------------------------
Inicializa as configurações e define a primeira página do relatório
------------------------------------------------------------------*/

//Iniciando a sessão e alimentando as colunas com os dados
oSecPrint:Init()

oSecPrint:Cell("A2_COD"):SetValue(SA2->A2_COD)
oSecPrint:Cell("A2_NOME"):SetValue(SA2->A2_NOME)
oSecPrint:Cell("A2_END"):SetValue(SA2->A2_END)
oSecPrint:Cell("A2_BAIRRO"):SetValue(SA2->A2_BAIRRO)
oSecPrint:Cell("A2_EST"):SetValue(SA2->A2_EST)
oSecPrint:Cell("A2_MUN"):SetValue(SA2->A2_MUN)
oSecPrint:Cell("USUÁRIO"):SetValue(cNameUsr)
oSecPrint:Cell("DATA"):SetValue(dData)
oSecPrint:Cell("HORA"):SetValue(cHora)


oSecPrint:PrintLine() // Imprime as linhas 


/*---------------------------------------------------------------------------------------------------------------------------------------------
Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint:Finish()


Return Nil

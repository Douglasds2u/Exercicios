#INCLUDE 'totvs.ch'
#INCLUDE 'topconn.ch'



User Function RelForn()

Local oReport := Nil

oReport := ReportDef()
oReport:PrintDialog() // Exibe a tela de configura��o para impress�o do relat�rio

Return Nil


Static Function ReportDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relat�rio, guarda a fun��o PrintReport onde ir� retornar os dados da primeira p�gina do relat�rio
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelForn", "Ficha de Fornecedores", /*cPerg*/, {|oReportRet| PrintReport(oReportRet)}, "Impress�o de ficha de fornecedores em TReport simples.")
Local oSection := Nil

oReportRet:SetPortrait(.T.) //Define por padr�o come�ar o relatorio com a op��o retrato
oReportRet:SetColSpace(1) //Define o espa�amento entre colunas

/*-------------------------------------------------------------------------------------
 Cria o layout do relat�rio com as colunas e campos que definimos da respectiva tabela
-------------------------------------------------------------------------------------*/
oSection := TRSection():New(oReportRet, "Dados de fornecedores", {"SA2"})

TRCell():New(oSection, "A2_COD"      ,"SA2")
TRCell():New(oSection, "A2_NOME"     ,"SA2", , , 30, ,) // O par�metro num�rico est� difinindo a quantidade de caracteres do dado a ser impresso no relat�rio
TRCell():New(oSection, "A2_END"      ,"SA2", , , 30, ,)
TRCell():New(oSection, "A2_BAIRRO"   ,"SA2")
TRCell():New(oSection, "A2_EST"      ,"SA2")
TRCell():New(oSection, "A2_MUN"      ,"SA2", , , 30, ,)
TRCell():New(oSection, "USU�RIO"     ,"SA2", , , 15, ,)
TRCell():New(oSection, "DATA"        ,"SA2", , , 10, ,)
TRCell():New(oSection, "HORA"        ,"SA2", , , 8, ,)

Return oReportRet


Static Function PrintReport(oReportRet)

Local oSecPrint := oReportRet:Section(1)
Local cCodUsr   := RetCodUsr()  // Retorna c�digo do usu�rio
Local cNameUsr  := UsrRetName(cCodUsr) // Retorna o nome do usu�rio
Local dData     := Date() // Data padr�o do sistema
Local cHora     := Time()// Hora padr�o do sistema

/*-----------------------------------------------------------------
Inicializa as configura��es e define a primeira p�gina do relat�rio
------------------------------------------------------------------*/

//Iniciando a sess�o e alimentando as colunas com os dados
oSecPrint:Init()

oSecPrint:Cell("A2_COD"):SetValue(SA2->A2_COD)
oSecPrint:Cell("A2_NOME"):SetValue(SA2->A2_NOME)
oSecPrint:Cell("A2_END"):SetValue(SA2->A2_END)
oSecPrint:Cell("A2_BAIRRO"):SetValue(SA2->A2_BAIRRO)
oSecPrint:Cell("A2_EST"):SetValue(SA2->A2_EST)
oSecPrint:Cell("A2_MUN"):SetValue(SA2->A2_MUN)
oSecPrint:Cell("USU�RIO"):SetValue(cNameUsr)
oSecPrint:Cell("DATA"):SetValue(dData)
oSecPrint:Cell("HORA"):SetValue(cHora)


oSecPrint:PrintLine() // Imprime as linhas 


/*---------------------------------------------------------------------------------------------------------------------------------------------
Finaliza a impress�o do relat�rio, imprime os totalizadores, fecha as querys e �ndices tempor�rios, entre outros tratamentos do componente.
N�o � necess�rio executar o m�todo Finish se for utilizar o m�todo Print, j� que este faz o controle de inicializa��o e finaliza��o da impress�o.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint:Finish()


Return Nil

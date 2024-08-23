#INCLUDE 'totvs.ch'
#INCLUDE 'topconn.ch'

/* ------------------------------------------------------------
Nome: RelFirst
Rotina para impress�o de ficha de produtos em TReport simples.
Autor: Douglas Sousa
Data: 20/08/2024
------------------------------------------------------------- */

User Function RelFirst()

Local oReport := NIL

oReport := FReportDef()
oReport:PrintDialog() // Exibe a tela de configura��o para impress�o do relat�rio

Return Nil 


Static Function FReportDef()

/*------------------------------------------------------------------------------------------------------------------------------------
Cria a primeira tela para imprimir o relat�rio, guarda a fun��o PrintReport onde ir� retornar os dados da primeira p�gina do relat�rio
------------------------------------------------------------------------------------------------------------------------------------*/
Local oReportRet := TReport():New("RelFirst","Ficha do Produto", /*cPerg*/ ,{|oReportRet| PrintReport(oReportRet)},"Impress�o de ficha de produtos em TReport simples.")
Local oSection   := NIL

oReportRet:SetPortrait(.T.) //Define por padr�o come�ar o relatorio com a op��o retrato
oReportRet:SetColSpace(5) //Define espa�amento entre as colunas

/*-------------------------------------------------------------------------------------
 Cria o layout do relat�rio com as colunas e campos que definimos da respectiva tabela
 ------------------------------------------------------------------------------------*/
oSection := TRSection():New( oReportRet , "Dados do Produto", {"SB1"} )

TRCell():New( oSection, "B1_COD"      , "SB1")
TRCell():New( oSection, "B1_DESC"     , "SB1")
TRCell():New( oSection, "B1_TIPO"     , "SB1")
TRCell():New( oSection, "B1_UM"       , "SB1")
TRCell():New( oSection, "USU�RIO"     , "SB1", , , 15, ,) // O par�metro num�rico est� difinindo a quantidade de caracteres do dado a ser impresso no relat�rio
TRCell():New( oSection, "DATA"     , "SB1", , , 10, ,)
TRCell():New( oSection, "HORA"     , "SB1", , , 8, ,)

Return oReportRet 



Static Function PrintReport(oReportRet)

Local oSecPrint := oReportRet:Section(1)
Local cCodUsr  := RetCodUsr() //Retorna o c�digo de usu�rio do Protheus
Local cNomeUsr := UsrRetName(cCodUsr) //Retorna o nome do usu�rio logado no sistema
Local dData    := Date()
Local cHora    := Time()

/*-------------------------------------------------------------------
Inicializa as configura��es e define a primeira p�gina do relat�rio 
--------------------------------------------------------------------*/

//Iniciando a sess�o e alimentando as colunas com os dados
oSecPrint:Init()


oSecPrint:Cell("B1_COD"):SetValue( SB1->B1_COD )
oSecPrint:Cell("B1_DESC"):SetValue( SB1->B1_DESC )
oSecPrint:Cell("B1_TIPO"):SetValue( SB1->B1_TIPO )
oSecPrint:Cell("B1_UM"):SetValue( SB1->B1_UM )
oSecPrint:Cell("USU�RIO"):SetValue( cNomeUsr )
oSecPrint:Cell("DATA"):SetValue( dData )
oSecPrint:Cell("HORA"):SetValue( cHora )


oSecPrint:PrintLine() // Imprime as linhas 

/*---------------------------------------------------------------------------------------------------------------------------------------------
Finaliza a impress�o do relat�rio, imprime os totalizadores, fecha as querys e �ndices tempor�rios, entre outros tratamentos do componente.
N�o � necess�rio executar o m�todo Finish se for utilizar o m�todo Print, j� que este faz o controle de inicializa��o e finaliza��o da impress�o.
-----------------------------------------------------------------------------------------------------------------------------------------------*/
oSecPrint:Finish()


Return NIL

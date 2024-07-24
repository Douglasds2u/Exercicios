#INCLUDE "TOTVS.CH"


/* --------------------------------------------------------
Nome: HelloWorld 
Minha primeira funcao em advpl que exibe um texto na tela
Autor: Douglas Sousa
Data: 08/08/2024
-------------------------------------------------------- */
User Function HelloWorld()

Local cVarLoc    := " "
Local cTitMsg    := " ---- Mensagem Inicial ---- "

cVarLoc := FuncOne()

FWAlertSuccess( cVarLoc , cTitMsg )


Return NIL




Static Function FuncOne()

Local cRetorno := "Meu primeiro programa ADVPL - Hello World - P12Local"

Return cRetorno

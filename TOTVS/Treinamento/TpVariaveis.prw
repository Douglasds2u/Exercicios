#INCLUDE "TOTVS.CH"


/* --------------------------------------------------------
Nome: HelloWorld 
Minha primeira funcao em advpl que exibe um texto na tela
Autor: Douglas Sousa
Data: 08/08/2024
-------------------------------------------------------- */
User Function TpVar()

Local dDtNasc   := ctoD("")
Local cNome     := ""
Local nIdade    := 0
Local lMaiorId  := .F.

// Alimenta variaveis
dDtNasc := cTod("29/06/1995")
cNome   := "Douglas Sousa do Nascimento"


nIdade   := ( Date() - dDtNasc )               // Retorna calculo em dias
nIdade   := ( nIdade / 30 )                    // Divido por 30 para ter média de meses
nIdade   := Round( ( nIdade / 12 ) , 0 )       // Divido em 12 para resultado em anos

If nIdade >= 18
    lMaiorId := .T.
Else 
    lMaiorId := .F. 
EndIf 

FExibDados(dDtNasc, cNome , nIdade , lMaiorId )

Return 


Static Function FExibDados( dDtNasc, cNome , nIdade , lMaiorId )

Local cMsg    := ""
Local cMMId   := ""

If lMaiorId == .T. 
    cMMId := "MAIOR de idade"
Else 
    cMMId := "MENOR de idade" 
EndIf


cMsg := " A pessoa " + cNome + " nasceu em " + dToC(dDtNasc) + ", tem " + Str(nIdade) + " anos e é " + cMMId

Alert(cMsg)


Return NIL 

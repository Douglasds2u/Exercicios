#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: Exerc01
Meu Primeiro desafio em ADVPL com fun��es que me dir�o meus dados, regi�o do Brasil e o signo.
Autor: Douglas Sousa
Data: 08/08/2024
-------------------------------------------------------- */

User Function Exerc01()

local cNome    := ""
local dDtNasc  := ctoD("")
local cSex     := ""
local cCid     := ""
local cEst     := ""
local cReg     := ""
local cMsg     := ""


/*----------------
Alimenta Variaveis
-----------------*/

cNome    := "Ronaldo Miller"
dDtNasc  := ctoD("11/04/1970")
cSex     := "Masculino"
cCid     := "S�o bernardo do campo"
cEst     := "RO"

cEst := Upper(cEst)  // Tratando para garantir tudo maiusculo para minhas compara��es abaixo. 
cReg := u_FRegEst(cEst) // Fun��o para exibir a regi�o de cada estado.
cSign := u_FSign(dDtNasc) // Fun��o que exibe o signo atrav�s da data de anivers�rio.

cMsg := "Nome: " + cNome + ", nascido em: " + dToC(dDtNasc) + ", do sexo " + cSex + ", da regi�o " + cReg + " do Brasil, do signo de " + cSign + "."
FWAlertInfo(cMsg)

Return


/*------------------------------
Retorna a regi�o de cada estado.
-------------------------------*/

User Function FRegEst(cEst)

Local cRet := ""


if ( cEst  ==  "AC" ) .OR. ( cEst  ==  "AP" ) .OR. ( cEst  ==  "AM" ) .OR. ( cEst  ==  "PA" ) .OR. ( cEst  ==  "RO" ) .OR. ( cEst  ==  "RR" ) .OR. ( cEst  ==  "TO" )
    cRet := "Norte"
Elseif ( cEst == "MA" ) .OR. ( cEst == "PI" ) .OR. ( cEst == "CE" ) .OR. ( cEst == "RN" ) .OR. ( cEst == "PB" ) .OR. ( cEst == "PE" ) .OR. ( cEst == "AL" ) .OR. ( cEst == "SE" ) .OR. ( cEst == "BA" )
    cRet := "Nordeste"
Elseif ( cEst == "MT" ) .OR. ( cEst == "GO" ) .OR. ( cEst == "MS" ) .OR. ( cEst == "DF" )
    cRet := "Centro-Oeste"
Elseif ( cEst == "MG" ) .OR. ( cEst == "ES" ) .OR. ( cEst == "SP" ) .OR. ( cEst == "RJ" )
    cRet := "Sudeste"
Elseif ( cEst == "PR" ) .OR. ( cEst == "SC" ) .OR. ( cEst == "RS" )
    cRet := "Sul"
Else
    cRet := "N�o identificado"
EndIf


Return cRet

/*---------------------------------------------
Retorna o Signo atrav�s da data de anivers�rio.
----------------------------------------------*/

User Function FSign(dDtNasc)

Local cSign := ""
Local nAno := Year(dDtNasc)


if ( dDtNasc >= CtoD("21/01/"+str(nAno)) ) .and. ( dDtNasc < CToD("19/02/"+str(nAno)) )
    cSign := "Aqu�rio"
Elseif ( dDtNasc >= CtoD("19/02/"+str(nAno)) ) .and. ( dDtNasc < CToD("21/03/"+str(nAno)) )
    cSign := "Peixes"
Elseif ( dDtNasc >= CtoD("21/03/"+str(nAno)) ) .and. ( dDtNasc < CToD("21/04/"+str(nAno)) )
    cSign := "�ries"
Elseif ( dDtNasc >= CtoD("21/04/"+str(nAno)) ) .and. ( dDtNasc < CToD("21/05/"+str(nAno)) )
    cSign := "Touro"
Elseif ( dDtNasc >= CtoD("21/05/"+str(nAno)) ) .and. ( dDtNasc < CToD("21/06/"+str(nAno)) )
    cSign := "G�meos"
Elseif ( dDtNasc >= CtoD("21/06/"+str(nAno)) ) .and. ( dDtNasc < CToD("23/07/"+str(nAno)) )
    cSign := "C�ncer"
Elseif ( dDtNasc >= CtoD("23/07/"+str(nAno)) ) .and. ( dDtNasc < CToD("23/08/"+str(nAno)) )
    cSign := "Le�o"
Elseif ( dDtNasc >= CtoD("23/08/"+str(nAno)) ) .and. ( dDtNasc < CToD("23/09/"+str(nAno)) )
    cSign := "Virgem"
Elseif ( dDtNasc >= CtoD("23/09/"+str(nAno)) ) .and. ( dDtNasc < CToD("23/10/"+str(nAno)) )
    cSign := "Libra"
Elseif ( dDtNasc >= CtoD("23/10/"+str(nAno)) ) .and. ( dDtNasc < CToD("22/11/"+str(nAno)) )
    cSign := "Escorpi�o"
Elseif ( dDtNasc >= CtoD("22/11/"+str(nAno)) ) .and. ( dDtNasc < CToD("22/12/"+str(nAno)) )
    cSign := "Sagit�rio"
Elseif ( dDtNasc >= CtoD("22/12/"+str(nAno)) ) .and. ( dDtNasc < CToD("21/01/"+str(nAno)) )
    cSign := "Capric�rnio"


EndIf


Return cSign

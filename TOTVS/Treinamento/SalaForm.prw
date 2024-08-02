#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: SalaForm
Rotina para cadastrar salas de forma��o
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */



User Function SalaForm()

AxCadastro("ZB3", "Sala de Forma��o", , )

Return


User Function VDtForm()

Local lRet := .T.

If !Empty(M->ZB3_DTINI) .and. !EMPTY(M->ZB3_DTFIM)

    If (M->ZB3_DTINI) > (M->ZB3_DTFIM)
        lRet := .F.
        alert("ERRO! a data final prevista est� incorreta!")
    Endif
Endif

Return

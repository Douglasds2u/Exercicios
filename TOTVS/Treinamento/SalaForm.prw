#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: SalaForm
Rotina para cadastrar salas de formação
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */



User Function SalaForm()

AxCadastro("ZB3", "Sala de Formação", , )

Return

/*------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo verifica a data inicial da formação e a data final inserida no cadastro, se a data inicial for maior que a final segue o cadastro,
senão retorna FALSE e impede o usuário prosseguir o cadastro com a data final menor do que a data de início.
-----------------------------------------------------------------------------------------------------------*/
User Function VDtForm()

Local lRet := .T.

If !Empty(M->ZB3_DTINI) .and. !EMPTY(M->ZB3_DTFIM)

    If (M->ZB3_DTINI) >= (M->ZB3_DTFIM)
        lRet := .F.
        alert("ERRO! a data final prevista está incorreta!")
    Endif
Endif

Return

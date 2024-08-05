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

/*------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo verifica a data inicial da forma��o e a data final inserida no cadastro, se a data inicial for maior que a final segue o cadastro,
sen�o retorna FALSE e impede o usu�rio prosseguir o cadastro com a data final menor do que a data de in�cio.
-----------------------------------------------------------------------------------------------------------*/
User Function VDtForm()

Local lRet := .T.

If !Empty(M->ZB3_DTINI) .and. !EMPTY(M->ZB3_DTFIM)

    If (M->ZB3_DTINI) >= (M->ZB3_DTFIM)
        lRet := .F.
        alert("ERRO! a data final prevista est� incorreta!")
    Endif
Endif

Return

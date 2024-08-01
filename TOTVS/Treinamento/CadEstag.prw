#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: CadEstag
Rotina para cadastro de estagiários
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */




User Function CadEstag()


AxCadastro("ZB1", "Cadastro de estagiários", 'u_FVexc()', 'u_FValt()' )


Return

/*----------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para o estagiário cadastrado, se houver a função retorna .F. e não permite ser excluido.
----------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexc()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel excluí-lo!")

Endif


Return lRet


/*--------------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para o estagiário cadastrado, se houver a função retorna .F. e não permite fazer alterações.
--------------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValt()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If !(INCLUI)
    
    If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
        lRet := .F.
        alert("Existe uma amarração para este cadastro, não será possivel fazer alterações!")

    Endif

Endif

Return lRet

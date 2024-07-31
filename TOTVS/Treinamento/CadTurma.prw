#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: CadTurma
Rotina para cadastro de Turmas
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */




User Function CadTurma()

AxCadastro("ZB2", "Cadastro de turmas para estágio", "u_FVexcT()", "u_FValtT()" )




Return

/*----------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para a turma cadastrada, se houver a função retorna .F. e não permite ser excluido.
-----------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexcT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel excluí-lo!")

Endif


Return lRet

/*---------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para a turma cadastrada, se houver a função retorna .F. e não permite fazer alterações.
---------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValtT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If !(INCLUI)
    If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
        lRet := .F.
        alert("Existe uma amarração para este cadastro, não será possivel fazer alterações!")
    Endif
Endif

Return lRet

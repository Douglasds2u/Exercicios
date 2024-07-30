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




User Function FVexcT()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lValida := .F.
    alert("Existe uma amarração para este cadastro, não é possivel excluír este registro!")

Endif


Return



User Function FValtT()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lValida := .F.
    alert("Existe uma amarração para este cadastro, não é possivel alterar este registro!")


Endif

Return

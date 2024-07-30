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



User Function FVexc()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lValida := .F.
    alert("Existe uma amarração para este cadastro, não é possivel excluír este registro!")

Endif


Return lValida




User Function FValt()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lValida := .F.
    alert("Existe uma amarração para este cadastro, não é possivel alterar informações!")


Endif

Return lValida

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

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel excluí-lo!")

Endif


Return lRet



User Function FValt()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel fazer alterações!")


Endif

Return lRet

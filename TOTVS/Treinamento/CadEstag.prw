#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: CadEstag
Rotina para cadastro de estagi�rios
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */




User Function CadEstag()


AxCadastro("ZB1", "Cadastro de estagi�rios", 'u_FVexc()', 'u_FValt()' )


Return



User Function FVexc()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lValida := .F.
    alert("Existe uma amarra��o para este cadastro, n�o � possivel exclu�r este registro!")

Endif


Return lValida




User Function FValt()

Local lValida := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lValida := .F.
    alert("Existe uma amarra��o para este cadastro, n�o � possivel alterar informa��es!")


Endif

Return lValida

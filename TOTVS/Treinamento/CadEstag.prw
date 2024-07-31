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

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet



User Function FValt()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(2))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel fazer altera��es!")


Endif

Return lRet

#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: CadTurma
Rotina para cadastro de Turmas
Autor: Douglas Sousa
Data: 29/07/2024
-------------------------------------------------------- */




User Function CadTurma()

AxCadastro("ZB2", "Cadastro de turmas para est�gio", "u_FVexcT()", "u_FValtT()" )




Return




User Function FVexcT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet



User Function FValtT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(DBSEEK(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel fazer altera��es!")


Endif

Return lRet

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

/*----------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para a turma cadastrada, se houver a fun��o retorna .F. e n�o permite ser excluido.
-----------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexcT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet

/*---------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para a turma cadastrada, se houver a fun��o retorna .F. e n�o permite fazer altera��es.
---------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValtT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(3))

If !(INCLUI)
    If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_TANO))
        lRet := .F.
        alert("Existe uma amarra��o para este cadastro, n�o ser� possivel fazer altera��es!")
    Endif
Endif

Return lRet

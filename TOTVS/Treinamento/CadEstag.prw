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

/*----------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para o estagi�rio cadastrado, se houver a fun��o retorna .F. e n�o permite ser excluido.
----------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexc()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet


/*--------------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para o estagi�rio cadastrado, se houver a fun��o retorna .F. e n�o permite fazer altera��es.
--------------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValt()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If !(INCLUI)
    
    If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_NOME))
        lRet := .F.
        alert("Existe uma amarra��o para este cadastro, n�o ser� possivel fazer altera��es!")

    Endif

Endif

Return lRet

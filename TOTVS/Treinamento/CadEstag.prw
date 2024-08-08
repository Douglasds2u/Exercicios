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

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_COD))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet


/*--------------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para o estagi�rio cadastrado, se houver a fun��o retorna .F. e n�o permite fazer altera��es.
--------------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValt()

Local cAliasGen := ""
Local lRet      := .F. 
Local aFildsVal := {"ZB1_COD", "ZB1_NOME", "ZB1_DNASC", "ZB1_CPF"}

cAliasGen := "ZB1"

lRet := u_VFields( cAliasGen , aFildsVal )

Return lRet

/*Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If !(INCLUI)
    
    If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_COD))
        lRet := .F.
        alert("Existe uma amarra��o para este cadastro, n�o ser� possivel fazer altera��es!")

    Endif

Endif*/

/*--------------------------------------------------------------------------------------
A fun��o abaixo est� validando se o n�mero digitado � compativel com um n�mero de cpf.
---------------------------------------------------------------------------------------*/
User Function VldCpf()

Local lRet := .F.
Local cCpf := M->ZB1_CPF

cCpf := StrTran(cCpf , ".", "")
cCpf := StrTran(cCpf , "-", "")

If !Empty(cCpf)

    If ChkCPF(cCpf)
    lRet := .T.
    
    Endif

Endif

Return lRet

/*----------------------------------------------------------------------------------------
A fun��o abaixo est� validando se a idade do estagi�rio a ser cadastro � maior de 18 anos.
-----------------------------------------------------------------------------------------*/
User Function VDtNasc()

Local dDtNasc   := M->ZB1_DNASC
Local nIdade    := 0
Local lRet      := .T.
Local cIdadMin  := SuperGetMv( "MV_XIDAMIN", .T. , "18", /*cFilial*/ )

nIdade := DateDiffYear(dDtNasc, dDataBase)


If !Empty(dDtNasc)

    If nIdade < Val(cIdadMin)
    lRet := .F.
    alert("Estagi�rio deve ter idade minima de  "  + cIdadMin + " anos!")

    EndIf

EndIf

Return lRet

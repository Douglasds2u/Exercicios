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

/*----------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para o estagiário cadastrado, se houver a função retorna .F. e não permite ser excluido.
----------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexc()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB1->ZB1_COD))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel excluí-lo!")

Endif


Return lRet


/*--------------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para o estagiário cadastrado, se houver a função retorna .F. e não permite fazer alterações.
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
        alert("Existe uma amarração para este cadastro, não será possivel fazer alterações!")

    Endif

Endif*/

/*--------------------------------------------------------------------------------------
A função abaixo está validando se o número digitado é compativel com um número de cpf.
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
A função abaixo está validando se a idade do estagiário a ser cadastro é maior de 18 anos.
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
    alert("Estagiário deve ter idade minima de  "  + cIdadMin + " anos!")

    EndIf

EndIf

Return lRet

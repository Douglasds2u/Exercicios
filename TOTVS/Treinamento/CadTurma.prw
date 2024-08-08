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

/*----------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para a turma cadastrada, se houver a função retorna .F. e não permite ser excluido.
-----------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FVexcT()

Local lRet := .T.
dbSelectArea("ZB3")
ZB3->(dbSetOrder(1))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_COD))
    lRet := .F.
    alert("Existe uma amarração para este cadastro, não será possivel excluí-lo!")

Endif


Return lRet

/*---------------------------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se existe um registro amarrado para a turma cadastrada, se houver a função retorna .F. e não permite fazer alterações.
---------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValtT()

Local lRet          := .F.
Local aFildsVal     := {"ZB2_COD","ZB2_TANO","ZB2_PERIOD"} 
Local cAliasGen     := ""

cAliasGen           := "ZB2"

lRet:= u_VFields(cAliasGen, aFildsVal)

Return lRet

/*

// Validaçao de alteraçào - não permitir alterar esses campos abaixo 
// Validando se estou alterando Codigo 
If ZB2->ZB2_COD <> M->ZB2_COD
    lRet := .F.
    alert("Nao é permitido alterar o código da turma!") 
    lContinua := .F.
// Validando se estou alterando Ano 
ElseIf ZB2->ZB2_TANO <> M->ZB2_TANO
    lRet := .F.
    alert("Nao é permitido alterar o ano da turma!") 
    lContinua := .F.
// Validando se estou alterando Periodo 
ElseIf ZB2->ZB2_PERIOD<> M->ZB2_PERIOD
    lRet := .F.
    alert("Nao é permitido alterar o periodo da turma!") 
    lContinua := .F.
EndIf 
*/



/*-------------------------------------------------------------------------------------------------------------------------------
A função abaixo está validando se o ano digitado na tela é compativel com o ano que a empresa começou a abrir vagas para estágio.
-------------------------------------------------------------------------------------------------------------------------------*/
User Function FVano()

Local lRet := .T.
Local nAnoAtual := cValToChar(Year(dDataBase))
Local nAnoTela := M->ZB2_TANO

If !Empty(nAnoTela)

    If (nAnoTela < "2018") .or. (nAnoTela > nAnoAtual)
        lRet := .F.
        alert("Digite um ano válido para cadastro de turmas de estágio!")
    EndIf

EndIf

Return lRet

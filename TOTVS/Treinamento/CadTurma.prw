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
ZB3->(dbSetOrder(1))

If ZB3->(MsSeek(FWXFILIAL("ZB3")+ZB2->ZB2_COD))
    lRet := .F.
    alert("Existe uma amarra��o para este cadastro, n�o ser� possivel exclu�-lo!")

Endif


Return lRet

/*---------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se existe um registro amarrado para a turma cadastrada, se houver a fun��o retorna .F. e n�o permite fazer altera��es.
---------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function FValtT()

Local lRet          := .F.
Local aFildsVal     := {"ZB2_COD","ZB2_TANO","ZB2_PERIOD"} 
Local cAliasGen     := ""

cAliasGen           := "ZB2"

lRet:= u_VFields(cAliasGen, aFildsVal)

Return lRet

/*

// Valida�ao de altera��o - n�o permitir alterar esses campos abaixo 
// Validando se estou alterando Codigo 
If ZB2->ZB2_COD <> M->ZB2_COD
    lRet := .F.
    alert("Nao � permitido alterar o c�digo da turma!") 
    lContinua := .F.
// Validando se estou alterando Ano 
ElseIf ZB2->ZB2_TANO <> M->ZB2_TANO
    lRet := .F.
    alert("Nao � permitido alterar o ano da turma!") 
    lContinua := .F.
// Validando se estou alterando Periodo 
ElseIf ZB2->ZB2_PERIOD<> M->ZB2_PERIOD
    lRet := .F.
    alert("Nao � permitido alterar o periodo da turma!") 
    lContinua := .F.
EndIf 
*/



/*-------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando se o ano digitado na tela � compativel com o ano que a empresa come�ou a abrir vagas para est�gio.
-------------------------------------------------------------------------------------------------------------------------------*/
User Function FVano()

Local lRet := .T.
Local nAnoAtual := cValToChar(Year(dDataBase))
Local nAnoTela := M->ZB2_TANO

If !Empty(nAnoTela)

    If (nAnoTela < "2018") .or. (nAnoTela > nAnoAtual)
        lRet := .F.
        alert("Digite um ano v�lido para cadastro de turmas de est�gio!")
    EndIf

EndIf

Return lRet

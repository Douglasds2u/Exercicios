#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: CadCor
Rotina para cadastro de cores
Autor: Douglas Sousa
Data: 25/07/2024
-------------------------------------------------------- */

User Function CadCor()

AxCadastro("ZA1","Cadastro de Cores", /*Func. Validar Exclusao*/ , /*Funcao para validao inclusao / alteracao */ )

Return 



/*------------------------------------------------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� validando o campo c�digo da cor para ver se o c�digo digitado j� foi cadastrado, se n�o encontar nenhum registro com o mesmo c�digo 
ele segue o cadastro, se encontrar ele retorna um alert impedindo dar sequ�ncia no cadastro.
---------------------------------------------------------------------------------------------*/
User Function FVCodC()

Local lRet := .T.
Local cCodTela   := M->ZA1_COD

dbSelectArea("ZA1")         // abrindo minha tabelo no meu fonte advpl 
ZA1->(dbSetOrder(1))        // determina o indice que quer utilizar // Filial + Cod
ZA1->(dbGoTop())            // posiciona ponteiro no primeiro registro da tabela


If ZA1->(MsSeek(  FWxFilial("ZA1") + cCodTela )) 
    lRet := .F. 
    Alert("O C�digo " + cCodTela +  " j� est� sendo usado para a cor " + ZA1->ZA1_NOME ) 
Endif


//lRet := !( ZA1->(MsSeek(  FWxFilial("ZA1") + cCodTela )) )

Return lRet 


/*--------------------------------------------------------------------------------------------------------------
A fun��o abaixo est� fazendo o mesmo trabalho da fun��o acima, por�m neste caso ela est� validando o campo NOME.
--------------------------------------------------------------------------------------------------------------*/
User Function FVnomeC()
Local lRet := .T.
Local cNomeTela   := M->ZA1_NOME

dbSelectArea("ZA1")         // abrindo minha tabelo no meu fonte advpl 
ZA1->(dbSetOrder(2))        // determina o indice que quer utilizar // Filial + descricao 
ZA1->(dbGoTop())            // posiciona ponteiro no primeiro registro da tabela


If ZA1->(MsSeek(  FWxFilial("ZA1") + cNomeTela )) 
    lRet := .F. 
    Alert("O nome " + AllTrim(cNomeTela) +  " j� existe e est� sendo usado pelo c�digo " + ZA1->ZA1_COD + ", para continuar digite outro nome!" ) 
Endif


//lRet := !( ZA1->(MsSeek(  FWxFilial("ZA1") + cCodTela )) )



Return lRet 



User Function FExistCor()
Local lRet := .F.
Local cExistCor := M->ZA1_COD

dbSelectArea("ZA1")
ZA1->(dbSetOrder(1))
ZA1->(dbGoTop())

If ExistCpo("ZA1", cExistCor)
lRet := .T.
Else
    Alert("C�digo n�o encontrado!")

Endif


Return lRet

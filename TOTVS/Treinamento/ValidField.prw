#INCLUDE "TOTVS.CH"



User Function VFields( cAliasGen , aFildsVal  )

Local lRet      := .T.
Local cCposMsg  := ""
Local nCOnt     := 0
// Prote��o 
Default cAliasGen := ""
Default aFildsVal := {}


If !Empty(aFildsVal) .AND. !Empty(cAliasGen)

    dbSelectArea('SX3')
    SX3->( dbSetOrder(2) )

    For nCont:=1 to Len(aFildsVal)

        If (cAliasGen)->&(aFildsVal[nCont]) <> M->&(aFildsVal[nCont])
            lRet := .F.
            SX3->(dbGoTop())
            SX3->( dbSeek( aFildsVal[nCont] ) )
            cCposMSg += X3Titulo() + CRLF
        EndIf 

    Next nCont 

    If !lRet

        Alert("Os campos abaixo n�o podem ser alterados: " + CRLF + CRLF + cCposMSg )

    EndIf 

EndIf 

Return lRet 

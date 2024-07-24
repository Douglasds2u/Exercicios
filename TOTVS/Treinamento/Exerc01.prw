#INCLUDE "TOTVS.CH"



User Function Exerc01()

    Local cMsg       := ""
    Local aExibDados := {}

    /*-------------------------------------------------------
    Add > adiciona os elementos na variável aExibdados acima.
    ---------------------------------------------------------*/
    aAdd(aExibDados, {"Jaqueline Souza do Nascimento", ctoD("03/09/1994"), , "Feminino",  "São Bernardo do Campo", Upper("sp"), , } )
    aAdd(aExibDados, {"Douglas Sousa do Nascimento",   ctoD("02/02/1995"), , "Masculino", "São Bernardo do Campo", Upper("mg"), , } )
    aAdd(aExibDados, {"Antonio Pereira do Nascimento", ctoD("20/01/1949"), , "Masculino",  "Poções",               Upper("ba"), , } )
    aAdd(aExibDados, {"Maria Silva Correa",            ctoD("09/03/1987"), , "Feminino",   "Brasilia",             Upper("df"), , } )
    aAdd(aExibDados, {"Alef da Silva Carvalho",        ctoD("20/07/1992"), , "Masculino",  "Fortaleza",            Upper("ce"), , } )
    aAdd(aExibDados, {"Fernando Soares Ferreira",      ctoD("28/11/1990"), , "Masculino",  "Goiania",              Upper("go"), , } )
    aAdd(aExibDados, {"Paulo Gonçalves Neto",          ctoD("17/10/2000"), , "Masculino",  "Florianópolis",        Upper("sc"), , } )

    Local nCont := 0
    For nCont := 1 to Len(aExibDados)

        /*--------------------------------------------------------------------------------------------------------------
        DateDiffYear > pega a data atribuida na array e diferencia em anos com base na data do sistema local (dDataBase)
        ---------------------------------------------------------------------------------------------------------------*/
        aExibDados[nCont,3] := DateDiffYear(aExibDados[nCont,2], dDataBase)
        
        DeterminaRegiao(aExibDados[nCont]) //Retorno da Static function
        DeterminaSigno(aExibDados[nCont]) //Retorno da Static function
        
        cMsg := "Nome: " + aExibDados[nCont,1] + ", nascido(a) em: " + dtoC(aExibDados[nCont,2]) + ", tem " + cValToChar(aExibDados[nCont,3]) + " anos, é do sexo " + aExibDados[nCont,4] + ", do signo de " + aExibDados[nCont,7] + ", e mora na região " + aExibDados[nCont,8] + " do Brasil."
        FWAlertInfo(cMsg)

    Next nCont

Return 

Static Function DeterminaRegiao(aExibDados)
    
        //AllTrim retira os espaços em branco das strings, $ > Função que diz se o elemento das arrays estão contidos nas strings abaixo.
        If AllTrim(Upper(aExibDados[6])) $ "AC/AP/AM/PA/RO/RR/TO"
            aExibDados[8] := "Norte"
        ElseIf AllTrim(Upper(aExibDados[6])) $ "AL/BA/CE/MA/PB/PE/PI/RN/SE"
            aExibDados[8] := "Nordeste"
        ElseIf AllTrim(Upper(aExibDados[6])) $ "DF/GO/MT/MS"
            aExibDados[8] := "Centro-Oeste"
        ElseIf AllTrim(Upper(aExibDados[6])) $ "ES/MG/RJ/SP"
            aExibDados[8] := "Sudeste"
        ElseIf AllTrim(Upper(aExibDados[6])) $ "PR/RS/SC"
            aExibDados[8] := "Sul"           
        Else
            aExibDados[8] := "Outra Região"           
        EndIf    

Return

Static Function DeterminaSigno(aExibDados)

    Local nAno := Year(aExibDados[2])

        If (aExibDados[2] >= CtoD("21/01/"+str(nAno))) .and. (aExibDados[2] < CToD("19/02/"+str(nAno)))
        aExibDados[7] := "Aquário"

        ElseIf (aExibDados[2] >= CtoD("19/02/"+str(nAno))) .and. (aExibDados[2] < CToD("21/03/"+str(nAno)))
        aExibDados[7] := "Peixes"

        ElseIf (aExibDados[2] >= CtoD("21/03/"+str(nAno))) .and. (aExibDados[2] < CToD("21/04/"+str(nAno)))
        aExibDados[7] := "Aries"

        ElseIf (aExibDados[2] >= CtoD("21/04/"+str(nAno))) .and. (aExibDados[2] < CToD("21/05/"+str(nAno)))
        aExibDados[7] := "Touro"

        ElseIf (aExibDados[2] >= CtoD("21/05/"+str(nAno))) .and. (aExibDados[2] < CToD("21/06/"+str(nAno)))
        aExibDados[7] := "Gêmeos"

        ElseIf (aExibDados[2] >= CtoD("21/06/"+str(nAno))) .and. (aExibDados[2] < CToD("23/07/"+str(nAno)))
        aExibDados[7] := "Câncer"

        ElseIf (aExibDados[2] >= CtoD("21/07/"+str(nAno))) .and. (aExibDados[2] < CToD("23/08/"+str(nAno)))
        aExibDados[7] := "Leão"

        ElseIf (aExibDados[2] >= CtoD("23/08/"+str(nAno))) .and. (aExibDados[2] < CToD("23/09/"+str(nAno)))
        aExibDados[7] := "Virgem"

        ElseIf (aExibDados[2] >= CtoD("23/09/"+str(nAno))) .and. (aExibDados[2] < CToD("23/10/"+str(nAno)))
        aExibDados[7] := "Libra"

        ElseIf (aExibDados[2] >= CtoD("23/10/"+str(nAno))) .and. (aExibDados[2] < CToD("22/11/"+str(nAno)))
        aExibDados[7] := "Escorpião"

        ElseIf (aExibDados[2] >= CtoD("22/11/"+str(nAno))) .and. (aExibDados[2] < CToD("22/12/"+str(nAno)))
        aExibDados[7] := "Sagitário"

        ElseIf (aExibDados[2] >= CtoD("22/12/"+str(nAno))) .or. (aExibDados[2] < CToD("21/01/"+str(nAno)))
        aExibDados[7] := "Capricórnio"

    Else
        aExibDados[7] := "Não Definido"

    EndIf

Return

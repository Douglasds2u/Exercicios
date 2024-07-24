#INCLUDE "TOTVS.CH"



User Function Exerc01()

    Local cMsg       := ""
    Local aExibDados := {}

    /*-------------------------------------------------------
    Add > adiciona os elementos na vari�vel aExibdados acima.
    ---------------------------------------------------------*/
    aAdd(aExibDados, {"Jaqueline Souza do Nascimento", ctoD("03/09/1994"), , "Feminino",  "S�o Bernardo do Campo", Upper("sp"), , } )
    aAdd(aExibDados, {"Douglas Sousa do Nascimento",   ctoD("02/02/1995"), , "Masculino", "S�o Bernardo do Campo", Upper("mg"), , } )
    aAdd(aExibDados, {"Antonio Pereira do Nascimento", ctoD("20/01/1949"), , "Masculino",  "Po��es",               Upper("ba"), , } )
    aAdd(aExibDados, {"Maria Silva Correa",            ctoD("09/03/1987"), , "Feminino",   "Brasilia",             Upper("df"), , } )
    aAdd(aExibDados, {"Alef da Silva Carvalho",        ctoD("20/07/1992"), , "Masculino",  "Fortaleza",            Upper("ce"), , } )
    aAdd(aExibDados, {"Fernando Soares Ferreira",      ctoD("28/11/1990"), , "Masculino",  "Goiania",              Upper("go"), , } )
    aAdd(aExibDados, {"Paulo Gon�alves Neto",          ctoD("17/10/2000"), , "Masculino",  "Florian�polis",        Upper("sc"), , } )

    Local nCont := 0
    For nCont := 1 to Len(aExibDados)

        /*--------------------------------------------------------------------------------------------------------------
        DateDiffYear > pega a data atribuida na array e diferencia em anos com base na data do sistema local (dDataBase)
        ---------------------------------------------------------------------------------------------------------------*/
        aExibDados[nCont,3] := DateDiffYear(aExibDados[nCont,2], dDataBase)
        
        DeterminaRegiao(aExibDados[nCont]) //Retorno da Static function
        DeterminaSigno(aExibDados[nCont]) //Retorno da Static function
        
        cMsg := "Nome: " + aExibDados[nCont,1] + ", nascido(a) em: " + dtoC(aExibDados[nCont,2]) + ", tem " + cValToChar(aExibDados[nCont,3]) + " anos, � do sexo " + aExibDados[nCont,4] + ", do signo de " + aExibDados[nCont,7] + ", e mora na regi�o " + aExibDados[nCont,8] + " do Brasil."
        FWAlertInfo(cMsg)

    Next nCont

Return 

Static Function DeterminaRegiao(aExibDados)
    
        //AllTrim retira os espa�os em branco das strings, $ > Fun��o que diz se o elemento das arrays est�o contidos nas strings abaixo.
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
            aExibDados[8] := "Outra Regi�o"           
        EndIf    

Return

Static Function DeterminaSigno(aExibDados)

    Local nAno := Year(aExibDados[2])

        If (aExibDados[2] >= CtoD("21/01/"+str(nAno))) .and. (aExibDados[2] < CToD("19/02/"+str(nAno)))
        aExibDados[7] := "Aqu�rio"

        ElseIf (aExibDados[2] >= CtoD("19/02/"+str(nAno))) .and. (aExibDados[2] < CToD("21/03/"+str(nAno)))
        aExibDados[7] := "Peixes"

        ElseIf (aExibDados[2] >= CtoD("21/03/"+str(nAno))) .and. (aExibDados[2] < CToD("21/04/"+str(nAno)))
        aExibDados[7] := "Aries"

        ElseIf (aExibDados[2] >= CtoD("21/04/"+str(nAno))) .and. (aExibDados[2] < CToD("21/05/"+str(nAno)))
        aExibDados[7] := "Touro"

        ElseIf (aExibDados[2] >= CtoD("21/05/"+str(nAno))) .and. (aExibDados[2] < CToD("21/06/"+str(nAno)))
        aExibDados[7] := "G�meos"

        ElseIf (aExibDados[2] >= CtoD("21/06/"+str(nAno))) .and. (aExibDados[2] < CToD("23/07/"+str(nAno)))
        aExibDados[7] := "C�ncer"

        ElseIf (aExibDados[2] >= CtoD("21/07/"+str(nAno))) .and. (aExibDados[2] < CToD("23/08/"+str(nAno)))
        aExibDados[7] := "Le�o"

        ElseIf (aExibDados[2] >= CtoD("23/08/"+str(nAno))) .and. (aExibDados[2] < CToD("23/09/"+str(nAno)))
        aExibDados[7] := "Virgem"

        ElseIf (aExibDados[2] >= CtoD("23/09/"+str(nAno))) .and. (aExibDados[2] < CToD("23/10/"+str(nAno)))
        aExibDados[7] := "Libra"

        ElseIf (aExibDados[2] >= CtoD("23/10/"+str(nAno))) .and. (aExibDados[2] < CToD("22/11/"+str(nAno)))
        aExibDados[7] := "Escorpi�o"

        ElseIf (aExibDados[2] >= CtoD("22/11/"+str(nAno))) .and. (aExibDados[2] < CToD("22/12/"+str(nAno)))
        aExibDados[7] := "Sagit�rio"

        ElseIf (aExibDados[2] >= CtoD("22/12/"+str(nAno))) .or. (aExibDados[2] < CToD("21/01/"+str(nAno)))
        aExibDados[7] := "Capric�rnio"

    Else
        aExibDados[7] := "N�o Definido"

    EndIf

Return

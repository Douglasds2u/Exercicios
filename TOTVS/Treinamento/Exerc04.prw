#INCLUDE "protheus.ch"

Static POS_NOME := 1
Static POS_NASC := 2
Static POS_SIGN := 3
Static POS_SEXO := 4
Static POS_CIDA := 5
Static POS_ESTA := 6
Static POS_REGI := 7

//Função principal
User Function Teste()
    Local cMsg := ""
    Local aExibDados := ConsultaDados()

    If Empty(aExibDados)
        cMsg := "Nenhum dado encontrado"
    else
        

        AjustaRegiao(@aExibDados)

        //Aqui pode ajustar o signo como na função a cima
    Endif

    FWAlertinfo(cMsg)
Return

Static Function ConsultaDados()
    Local aRet := {}


    aAdd(aRet, {"Jaqueline Souza do Nascimento", ctoD("03/09/1994"), "N/D", "Feminino", "São Bernardo do Campo", Upper("sp"), "N/D" })
    aAdd(aRet, {"Douglas Sousa do Nascimento", ctoD("29/06/1995"), "N/D", "Masculino", "São Bernardo do Campo", Upper("mg"), "N/D" })
    aAdd(aRet, {"Antonio Pereira do Nascimento", ctoD("07/01/1949"), "N/D", "Masculino", "Poções", Upper("ba"), "N/D" } )
Return aRet

//Função de controle para ajuste da região
Static Function AjustaRegiao(aExibDados)
    Local nX := 0

    Default aExibDados := {}

    For nX := 1 To Len(aExibDados)
        aExibDados[nX, POS_REGI] := DeParaRegiao(aExibDados[nX, POS_ESTA])
    Next nX
Return

// Função auxiliar para de/para de estado x região
Static Function DeParaRegiao(cEstado)
    Local cRegiao := ""

    Default cEstado := ""

    Do case

        Case AllTrim(Upper(cEstado)) $ "AC/AP/AM/PA/RO/RR/TO"
            cRegiao := "Norte"
        Case AllTrim(Upper(cEstado)) $ "AL/BA/CE/MA/PB/PE/PI/RN/SE"
            cRegiao := "Nordeste"
        Case AllTrim(Upper(cEstado)) $ "DF/GO/MT/MS"
            cRegiao := "Centro-Oeste"
        Case AllTrim(Upper(cEstado)) $ "ES/MG/RJ/SP"
            cRegiao := "Sudeste"
        Case AllTrim(Upper(cEstado)) $ "PR/RS/SC"
            cRegiao := "Sul"
        Otherwise
            cRegiao := "Não Definido"

    Endcase
Return cRegiao

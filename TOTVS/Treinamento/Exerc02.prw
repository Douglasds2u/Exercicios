#INCLUDE "TOTVS.CH"

/* --------------------------------------------------------
Nome: Exerc02
Trabalhando com Arrays
Autor: Douglas Sousa
Data: 16/08/2024
-------------------------------------------------------- */

User Function Exerc02()

Local nCont      := 0 
Local cMsg       := " "
Local aTorcedor  := {}
/*Local aMeuArray  := {}
Local aArray7    := Array(7)
Local aListNomes := {}*/


aAdd(aTorcedor,  {"Nicolas",     Upper("Corinthians"),                ctoD("11/11/2002"), } )
aAdd(aTorcedor,  {"Demetrio",    Upper("Palmeiras"),                  ctoD("22/06/1987"), } )
aAdd(aTorcedor,  {"Sergio",      Upper("Corinthians        "),        ctoD("05/10/1989"), } )
aAdd(aTorcedor,  {"Ronaldo",     Upper("Palmeiras"),                  ctoD("15/08/1985"), } )
aAdd(aTorcedor,  {"Gabriel",     Upper("Palmeiras"),                  ctoD("03/04/2000"), } )
aAdd(aTorcedor,  {"Antonio",     Upper("esporte Clube Corinthians "), ctoD("07/01/1949"), } )
aAdd(aTorcedor,  {"Fernando",    Upper("corinthians"),                ctoD("21/05/1980"), } )
aAdd(aTorcedor,  {"Paulo César", Upper("Flamengo"),                   ctoD("15/09/1979"), } )
aAdd(aTorcedor,  {"Leandro",     Upper(" Corinthians"),               ctoD("23/09/1973"), } )
aAdd(aTorcedor,  {"Matheus",     Upper("Santos"),                     ctoD("05/12/1999"), } ) 
aAdd(aTorcedor,  {"Michael",     Upper("Esporte Clube Corinthians"),  ctoD("02/07/1995"), } )
aAdd(aTorcedor,  {"Marcelo",     Upper("Fluminense"),                 ctoD("17/05/1981"), } )
aAdd(aTorcedor,  {"Hailton",     Upper("São Paulo"),                  ctoD("22/03/2001"), } )
aAdd(aTorcedor,  {"Caique",      Upper("CORINTHIANS") ,               ctoD("14/09/1992"), } )
aAdd(aTorcedor,  {"Heber",       Upper("Palmeiras"),                  ctoD("25/11/1988"), } )

/*-------------------------------------------------------------------------------------------------------------------------------------------------------
aSort coloca em ordem crescente os elementos de um array, este bloco de código abaixo está retornando o torcedor ordenado do mais velho para o mais novo.
-------------------------------------------------------------------------------------------------------------------------------------------------------*/
aSort(aTorcedor, , , {|x, y| x[3] < y[3]})


For nCont:=1 to Len(aTorcedor)

    /*--------------------------------------------------------------------------------
    O DateDIffYear calcula a diferença em anos da data de nascimento para a data atual
    Esta condição IF diz se "corinthians" está contido $ na segunda coluna do array
    -------------------------------------------------------------------------------*/
    aTorcedor[nCont,4] := DateDiffYear(aTorcedor[nCont,3], dDataBase)

if Upper("corinthians") $ (aTorcedor[nCont,2]) 

    cMsg:= "O torcedor " + aTorcedor[nCont,1] + " torce para o " + Lower(Alltrim(aTorcedor[nCont,2])) + ", nasceu em " + dtoC(aTorcedor[nCont,3]) + " e tem " + cValToChar(aTorcedor[nCont,4]) + " anos de idade."
        
    FWAlertInfo(cMsg)

EndIf

next nCont

    FWAlertSuccess("Estes são todos os torcedores do Corinthians contidos neste sistema, obrigado!")

Return NIL





/* 
// atribuir informacoes num array vazio 
aAdd(aMeuArray,"Palmeiras")                 // 1
aAdd(aMeuArray,1951)                        // 2
aAdd(aMeuArray,.T.)                         // 3 
aAdd(aMeuArray, Date() )                    // 4  
aAdd(aMeuArray, {1,2,3,4} )                 // 5 

 
// atribuir informacoes em arrays ja criados
aArray7[1] := "Ä"
aArray7[7] := "F"


// Navegando pelo Array 
For nCont:=1 to Len(aListNomes)

    Alert("Ö nome da vez é: " + aListNomes[nCont] )

Next nCont 


// Add e encontrar 
aAdd(aTorcedor, {"Douglas","Corinthians"} )
aAdd(aTorcedor, {"Vitor","Santos"} )


For nCont:=1 To Len(aTorcedor)

    cMsg := "Ö " + aTorcedor[nCont,1] + " torce para o " + aTorcedor[nCont,2]

Next nCont

*/


// Exercicio - com base em um array tendo como padrão 1-Nome, 2-Time, 3-Data de Nascimento 
// exibir em uma mensagem unica, somente os torcedores corinthianos - Nome e data de Nasicmento ordenado do mais velho para mais novo. 
// Array de pelo menos 15 
// Dicas - Existem funcoes para procurar um dado dentro de um array, chamadad aScan() e existem funcoes para ordenar um array chamada aSort()

//Return NIL


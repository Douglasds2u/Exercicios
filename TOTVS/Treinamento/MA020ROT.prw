#INCLUDE "TOTVS.CH"


User Function MA020ROT() // Ponto de entrada para um bot�o no menu de cadastro de fornecedores

Local aNewBut := {}

Aadd(aNewBut, {"Imp. Ficha Forn.", "u_RelForn()", 0, 9})

Return aNewBut

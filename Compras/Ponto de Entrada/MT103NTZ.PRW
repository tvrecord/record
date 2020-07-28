#INCLUDE "rwmake.ch"

user function MT103NTZ()          

Local ExpC1 := ParamIxb[1]     // Rotina do usuário para geração das Pré-Requisições.   
Local nPosNat  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_NATUREZ'})  

IF LEN(aCols[1]) > 140 
aCols[1][nPosNat] := ExpC1 
ENDIF

//MsgInfo("Digite o numero de uma autorização de pagamento do mesmo fornecedor liberada!", "Validação - Autorização")

Return ExpC1    
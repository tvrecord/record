#INCLUDE "rwmake.ch"

user function MT103NTZ()          

Local ExpC1 := ParamIxb[1]     // Rotina do usu�rio para gera��o das Pr�-Requisi��es.   
Local nPosNat  	 := Ascan(aHeader,{|x| Alltrim(x[2]) == 'D1_NATUREZ'})  

IF LEN(aCols[1]) > 140 
aCols[1][nPosNat] := ExpC1 
ENDIF

//MsgInfo("Digite o numero de uma autoriza��o de pagamento do mesmo fornecedor liberada!", "Valida��o - Autoriza��o")

Return ExpC1    
//Bibliotecas
#Include "Protheus.ch"

/*  Pedro Leonardo - 10/03/2022
	Converte valor numérico (ex.: 15.30) para hora (ex.: 15:30)
    u_zHoraAbnt(1.50, 'h') //01h30
    u_zHoraAbnt(1.50, ':') //01:30
	Se eu quero mostrar 13h45, teria que fazer u_zVal2Hora(13.45, ‘h’).
/*/

User Function zHoraAbnt(nValor, cSepar)
    Local cHora := ""		//Variável que irá armazenar as horas
    Local cMinutos := ""
    Default cSepar := ":"	//Caracter, Caracter de separação (ex.: 'h', ':', etc)
    Default nValor := -1	//Numérico, Valor numérico correspondente as horas

    //Se for valores negativos, retorna a hora atual
    If nValor < 0
        cHora := SubStr(Time(), 1, 5)
        cHora := StrTran(cHora, ':', cSepar)

    //Senão, transforma o valor numérico
    Else
        cHora := Alltrim(Transform(nValor, "@E 99.99"))

        //Se o tamanho da hora for menor que 5, adiciona zeros a esquerda
        If Len(cHora) < 5
            cHora := Replicate('0', 5-Len(cHora)) + cHora
        EndIf

        //Fazendo tratamento para minutos
        cMinutos := SubStr(cHora, At(',', cHora)+1, 2)
        cMinutos := StrZero((Val(cMinutos)*60)/100, 2)

        //Atualiza a hora com os novos minutos
        cHora := SubStr(cHora, 1, At(',', cHora))+cMinutos

        //Atualizando o separador
        cHora := StrTran(cHora, ',', cSepar)
    EndIf

    ConOut("> zHoraAbnt: "+cHora)
Return cHora
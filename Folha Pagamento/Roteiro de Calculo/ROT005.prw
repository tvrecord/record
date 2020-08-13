#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ROT005    º Autor ³ Hermano Nobre      º Data ³  23.11.06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ PROGRAMA PARA CALCULO DE INDENIZACAO COMPENSAVEL.  		  º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º	A empresa concederá ao funcionario maior de 45 anos de idade e        l)±
±±º com mais de 5 anos de empresa uma indenizacao compensavel.            º±±
±±º                                                                       º±±
±±º																		  º±±
±±º   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVES DO ROTEIRO 00366 -       º±±
±±º          EXECBLOCK("ROT005",.F.,.F.) 							      º±±
±±º                														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ Rede Record                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROT005()

Local aArea			:= GetArea()
Private dDataIni	:= CTOD('  /  /  ')
Private dDataFim	:= CTOD('  /  /  ')

If cTipRes $ "09/10/11/12/13/14/15/16"
	If U_CalcAnos(SRA->RA_NASC,dDataDem1) >= 45  // Funcionario tem mais de 45 anos de idade
		If U_CalcAnos(SRA->RA_ADMISSA,dDataDem1) >= 5  // Funcionario tem pelo menos 5 anos de empresa
			fDelPd("121")
			fGeraVerba("121",SRA->RA_SALARIO,1,,,,,,,,.t.)
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return

*******************************************************
* Funcao para calcular anos conf parametro inicio e fim
*******************************************************

User Function CalcAnos(dDataIni,dDataFim)

Local nRet	:= 0

nRet := Year(dDataFim) - Year(dDataIni)
If Month(dDataIni) > Month(dDataFim)
	nRet -= 1
ElseIf Month(dDataIni) == Month(dDataFim)
	If Day(dDataIni) > Day(dDataFim)
		nRet -= 1
	EndIf
EndIf

Return(nRet)

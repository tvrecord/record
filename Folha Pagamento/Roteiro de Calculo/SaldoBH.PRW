#INCLUDE "RWMAKE.CH"                                         
                   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSALDOBH   บAutora  ณGlauce Prestes Nogueiraบ Data ณ28/09/06 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PROGRAMA PARA CALCULO DO SALDO DE BANCO DE HORAS NA FOLHA  บฑฑ
ฑฑบ 		   DE PAGAMENTO.		     								  บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ																		  บฑฑ
ฑฑบ O sistema irแ buscar as verbas: 283- Base Result.BH Prov              บฑฑ
ฑฑบ 								438- Base Result.BH Desc              บฑฑ
ฑฑบ 														              บฑฑ
ฑฑบ Executar calculo do SALDO = Base Result.BH Prov - Base Result.BH Desc บฑฑ
ฑฑบ								        					              บฑฑ
ฑฑบ Se o resultado SALDO for POSITIVO, o sistema irแ gerar na Folha de    บฑฑ
ฑฑบ Pagamento a verba: 282- Bco Horas (Prov)					          บฑฑ
ฑฑบ 																	  บฑฑ
ฑฑบ Se o resultado SALDO for NEGATIVO, o sistema irแ gerar na Folha de    บฑฑ
ฑฑบ Pagamento a verba: 436- Bco Horas (Desc)					          บฑฑ
ฑฑบ																		  บฑฑ
ฑฑบ   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAVษS DO ROTEIRO 00455 -       บฑฑ
ฑฑบ          EXECBLOCK("SALDOBH",.F.,.F.)								  บฑฑ
ฑฑบ                														  บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rede Record                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SALDOBH()

Local BaseBHprov:= 0
Local BaseBHdesc:= 0   
Local Saldo     := 0   

DbSelectArea("SRA")
DbSetOrder(1)  
DbSelectArea("SPI")
DbSetOrder(1)

BaseBHprov := FBuscaPd("283","H",,)
BaseBHdesc := FBuscaPd("438","H",,)
Saldo:= ROUND(BaseBHprov - BaseBHdesc,2)

If Saldo <> 0
	If Saldo > 0
	   fGeraVerba("282",Saldo,Saldo,,,"H",,,,,.t.)
    Else	
       fGeraVerba("436",Saldo * (-1),Saldo * (-1),,,"H",,,,,.t.)
    EndIf   
EndIf

Return        
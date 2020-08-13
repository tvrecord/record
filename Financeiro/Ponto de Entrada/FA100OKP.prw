#include 'rwmake.ch'

User Function FA100OKP()

//Alert("Aqui")

if	Type("Debito") == "U"
	Public Debito := ""
endif

if	Type("Credito") == "U"
	Public Credito 	:= ""
endif

if	Type("CustoD") == "U"
	Public CustoD		:= ""
endif

if	Type("CustoC") == "U"
	Public CustoC		:= ""
endif

if	Type("ItemD") == "U"
	Public ItemD 		:= ""
endif

if	Type("ItemC") == "U"
	Public ItemC 		:= ""
endif

if	Type("CLVLD") == "U"
	Public CLVLD		:= ""
endif

if	Type("CLVLC") == "U"
	Public CLVLC		:= ""
endif

if	Type("Conta") == "U"
	Public Conta		:= ""
endif

if	Type("Custo") == "U"
	Public Custo 		:= ""
endif

if	Type("Historico") == "U"
	Public Historico 	:= ""
endif

if	Type("ITEM") == "U"
	Public ITEM		:= ""
endif

if	Type("CLVL") == "U"
	Public CLVL		:= ""
endif

if	Type("Valor") == "U"
	Public Valor	:= 0
endif

if	Type("VlrInStr") == "U"
	Public VlrInStr := 0
endif

Return ( .t. )

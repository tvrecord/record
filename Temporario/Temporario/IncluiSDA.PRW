#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncluiSB9 บ Autor ณ Rafael Fran็a      บ Data ณ  26/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณInclusao de saldo inicial nos produtos da maquiagem         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


//**********************
User Function IncluiSDB()    ๚
Local aVetor 	:= {}
Local cProduto 	:= ""
Local cQuery	:= ""  
Local aCab := {}
Local aItem:= {}

cQuery	:= "SELECT * FROM SDA010 WHERE D_E_L_E_T_ <> '*' AND DA_PRODUTO BETWEEN '0900405' AND '0900413' ORDER BY DA_PRODUTO"

tcQuery cQuery New Alias "TMP"

DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	// INCLUSรO  
	
	
lMsErroAuto := .F.

aCab := {     {"DA_PRODUTO",TMP->DA_PRODUTO,NIL},;
          {"DA_LOCAL",TMP->DA_LOCAL,NIL}}

aAdd(aItem, {     {"DB_ITEM","001",NIL},;
          {"DB_LOCALIZ","ACV7",NIL},;
          {"DB_DATA",dDataBase,NIL},;
          {"DB_QUANT",1,NIL}})



MSExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItem,3) //Distribui 

aCab := {}
aItem := {}
	
	//*************
	// ALTERAวรO
	//*************
	/*
	aVetor := { {"E1_PREFIXO" ,"   " ,Nil},;
	{"E1_NUM"        ,"000001" ,Nil},;
	{"E1_PARCELA" ," " ,Nil},;
	{"E1_TIPO" ,"DP " ,Nil},;
	{"E1_NATUREZ" ,"001" ,Nil},;
	{"E1_VALOR" ,250 ,Nil }}
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,4) //Alteracao
	*/
	
	//*************
	//   EXCLUIR
	//*************
	/*
	aVetor := {     {"E1_PREFIXO" ,"   " ,Nil},;
	{"E1_NUM" ,"000001" ,Nil},;
	{"E1_PARCELA" ," " ,Nil},;
	{"E1_TIPO" , "DP " ,Nil},;
	{"E1_NATUREZ" , "001" , Nil}}
	
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,5) //Exclusao
	*/
	
	dbSelectArea ("TMP")
	dbskip()
	
EndDo



If lMsErroAuto
	Alert("Erro")
Else
	Alert("Cadastro feito com sucesso")
Endif
Return 
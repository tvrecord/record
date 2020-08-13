#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncluiSB9 º Autor ³ Rafael França      º Data ³  26/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Inclusao de saldo inicial nos produtos da maquiagem         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


//**********************
User Function IncluiSB9()
Local aVetor 		:= {}
Local cProduto 		:= ""
Local cQuery		:= ""   
Local lMsErroAuto 	:= .T.

DBSelectArea("SB9")
DBGotop()

//cQuery	:= "SELECT B1_COD,B1_LOCPAD,B1_PESO FROM SB1010 WHERE B1_COD BETWEEN '2000000' AND '2999999' AND B1_LOCPAD = 'T1' AND D_E_L_E_T_ = '' ORDER BY B1_COD"

cQuery	:= "SELECT B1_COD,B1_LOCPAD,B1_PESO FROM SB1010 "
//cQuery	+= "WHERE (B1_COD BETWEEN '2080011' AND '2080999' OR B1_COD BETWEEN '2040061' AND '2040999' OR  B1_COD = '2060013' OR B1_COD = '2010019' OR B1_COD = '2100001') " // Almoxerifado Tecnico 2
cQuery	+= "WHERE B1_COD BETWEEN '3000000' AND '3999999' "
cQuery	+= "AND B1_LOCPAD = 'T1' AND D_E_L_E_T_ = '' ORDER BY B1_COD "

tcQuery cQuery New Alias "TMP"


DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()  
	
	aVetor := {{"B9_COD" , TMP->B1_COD, Nil},;
	{"B9_LOCAL" ,TMP->B1_LOCPAD, Nil},;
	{"B9_MCUSTD" ,"1", Nil},; 
	{"B9_QINI" ,TMP->B1_PESO, Nil},;
	{"B9_DATA" ,dDataBase, Nil }}   
	
	
MsAguarde( {||MSExecAuto({|x,y|Mata220(x,y)},aVetor,3)}, 'AGUARDE, PROCESSANDO...' ) //Inclusao
	
	//*************
	// ALTERAÇÃO
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

If lMSErroAuto
    MostraErro()
Else
    Alert("Concluido com Sucesso !! ")
EndIf


dbSelectArea ("TMP")
dbCloseArea ("TMP")

Return
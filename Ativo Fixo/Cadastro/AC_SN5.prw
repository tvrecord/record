#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACSN5     º Autor ³ Alexandre Zapponi  º Data ³  21/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fonte para alterar o Saldo Inicial da tabela SN5           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AC_SN5()

Private cDelFunc	:=	".t." 
Private cString 	:=	"SN5"
Private bAltera	:=	{ || AlteraSN5() }
Private bInclui	:=	{ || IncluiSN5() }
Private cCadastro :=	"Cadastro de Saldos por Conta"
Private aRotina 	:=	{  {"Pesquisar"  	,"AxPesqui"			,0,1},;
								{"Visualizar" 	,"AxVisual"			,0,2},;
								{"Incluir"		,"Eval(bInclui)"	,0,3},;
								{"Alterar"		,"Eval(bAltera)"	,0,4}}

dbSelectArea("SN5")
dbSetOrder(1)

Set Filter To N5_TIPO = "0"	

mBrowse(06,01,22,75,"SN5") 	

Set Filter To
	
Return       

/*************************************************/

Static Function AlteraSN5()
                           
Local aAltera	:=	{"N5_VALOR1","N5_VALOR2","N5_VALOR3"}
Local aCampos	:=	{"N5_CONTA","N5_DATA","N5_VALOR1","N5_VALOR2","N5_VALOR3"}

AxAltera("SN5",SN5->(Recno()),4,aCampos,aAltera,,,".t.",,,,,,,.f.)

Return

/*************************************************/

Static Function IncluiSN5()
                           
Local aInclui	:=	{}
Local aCampos	:=	{}
Local aStruct	:=	SN5->(dbstruct())

For t := 1 to Len(aStruct)
	if	!( Alltrim(aStruct[t,1]) $ "N5_FILIAL/N5_VALOR4/N5_VALOR5/N5_DC" )
		aAdd( aInclui , Alltrim(aStruct[t,1]) )
		aAdd( aCampos , Alltrim(aStruct[t,1]) )
	endif
Next t

AxInclui("SN5",SN5->(Recno()),3,aCampos,,aInclui,".t.",,,,,,,.f.)

Return

#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³REALI  º Autor ³ Rafael França      º Data ³    14/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ INDADIMPLENTES						                        ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RECORD DF                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INADIMP()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := ""
Private cPict          := ""
Private nLin           := 100

Private Cabec1         := ""
Private Cabec2         := ""
Private Cabec3         := ""
Private imprime        := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "INADIMP" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "INADIMP" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "INADIMP"
Private cString      := "SE1"
Private cQuery       := "" 
Private cfiltro      := ""
Private titulo       := "Inadimplentes"
Private aTitulos 	 := {} 
Private cNatGer 	 := ""
Private nSubTotal  	 := 0
Private nTotal 		 := 0 
Private nTotalDesp	 := 0


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAÇÃO CANCELADA")
	return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa({|| Relatorio()},"Gerando Relatório")

Return

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Entrada dos ultimos 3 meses via Nota Fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Relatorio()   

cQuery := "SELECT E1_EMISSAO AS EMISSAO,E1_NUM AS TITULO,E1_VENCREA AS VENCREAL, "
cQuery += "(SELECT A1_NOME FROM SA1010 WHERE D_E_L_E_T_ = '' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA) AS NOME, "
cQuery += "(SELECT ED_DESCRIC FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_CODIGO = E1_NATUREZ) AS NATUREZA, "
cQuery += "(E1_SALDO - E1_IRRF - E1_ISS - E1_PIS - E1_COFINS - E1_CSLL + E1_JUROS + E1_ACRESC) AS VALOR "
cQuery += "FROM SE1010 WHERE D_E_L_E_T_ = '' "
cQuery += "AND E1_SALDO > 0 "
//cQuery += "AND E1_VENCREA < '"+DTOS(MV_PAR13)+"' "
cQuery += "AND E1_TIPO NOT IN ('CS-','IR-','PI-','CF-','RA') "
cQuery += "AND E1_PORTADO NOT IN ('JUR','CAR') "  
cQuery += "AND E1_NATUREZ NOT IN ('1101006','1101015') " //Fabyana - 01/08/14 - Retira as naturezas de permutas e permutas de ativo.
cQuery += "AND E1_FILIAL = '01' " 
cQuery += "AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " 
cQuery += "AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
cQuery += "AND E1_CLIENTE BETWEEN '"+(MV_PAR09)+"' AND '"+(MV_PAR10)+"' "
cQuery += "AND E1_NUM BETWEEN '"+(MV_PAR11)+"' AND '"+(MV_PAR12)+"' " 

IF MV_PAR02 == 1
cQuery += "ORDER BY E1_EMISSAO,E1_NUM,E1_CLIENTE "
ELSEIF MV_PAR02 == 2
cQuery += "ORDER BY E1_VENCREA,E1_NUM,E1_CLIENTE "
ELSEIF MV_PAR02 == 3
cQuery += "ORDER BY NATUREZA,E1_NUM,E1_CLIENTE "
ELSEIF MV_PAR02 == 4
cQuery += "ORDER BY NOME,E1_NUM,E1_EMISSAO "
ENDIF

tcQuery cQuery New Alias "TMP"                                

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif       

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin)},titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

// **************************** Cria Arquivo Temporario
_aStru1:={}//SPCSQL->(DbStruct())
aadd( _aStru1 , {"EMISSAO"      	, "D" , 010 , 00 } )
aadd( _aStru1 , {"DOC	"			, "C" , 010 , 00 } )
aadd( _aStru1 , {"VENCREAL"		    , "D" , 010 , 00 } )
aadd( _aStru1 , {"CLIENTE"		    , "C" , 050 , 00 } )
aadd( _aStru1 , {"HISTORICO"		, "C" , 030 , 00 } )
aadd( _aStru1 , {"VALOR"			, "N" , 014 , 02 } )

_cTemp := CriaTrab(_aStru1, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP1",.F.,.F.)

DBSelectArea("TMP")
DBGotop()

While !TMP->(EOF())

			aAdd(aTitulos,{STOD(TMP->EMISSAO),;
			TMP->TITULO,;
			STOD(TMP->VENCREAL),;
			TMP->NOME,; 
			TMP->NATUREZA,; 
			TMP->VALOR})   
									
	DBSelectArea("TMP")
	DBSkip()
	
Enddo  

//ASORT(aTitulos,,,{|x,y|x[10]+DTOS(x[4]) < y[10]+DTOS(y[4])})

For i:=1 to Len(aTitulos)        

	
	Reclock("TMP1",.T.)
	TMP1->EMISSAO		:= aTitulos[i][1]
	TMP1->DOC			:= aTitulos[i][2]
	TMP1->VENCREAL		:= aTitulos[i][3]
	TMP1->CLIENTE   	:= aTitulos[i][4]
	TMP1->HISTORICO		:= aTitulos[i][5]
	TMP1->VALOR 		:= aTitulos[i][6]
	MsUnlock() 
	
Next

If !ApOleClient("MsExcel")
	MsgStop("Microsoft Excel nao instalado.")  //"Microsoft Excel nao instalado." 
	DBSelectArea("TMP")
	DBCloseARea("TMP")
	Return
EndIf

cArq     := _cTemp+".DBF"

DBSelectArea("TMP1")
DBCloseARea("TMP1")
DBSelectArea("TMP")
DBCloseARea("TMP")

__CopyFIle(cArq , AllTrim(GetTempPath())+_ctemp+".XLS")

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".XLS")
oExcelApp:SetVisible(.T.)

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Modelo      	 	","","","mv_ch01","N",01,0,2,"C","","mv_par01","Napoli","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ordem	     		","","","mv_ch02","N",01,0,2,"C","","mv_par02","Emissao","","","","","Vencimento","","","","","Natureza","","","","","Cliente","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Natureza  	  	","","","mv_ch03","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"04","Ate Natureza      	","","","mv_ch04","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"05","Do Vencimento 	  	","","","mv_ch05","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate Vencimento 	  	","","","mv_ch06","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Da Emissao     	  	","","","mv_ch07","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate Emissao    	  	","","","mv_ch08","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Do Cliente 	  		","","","mv_ch09","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"10","Ate Cliente    		","","","mv_ch10","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SA1"})
AADD(aRegs,{cPerg,"11","Do Titulo  	  		","","","mv_ch11","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Ate Titulo      	","","","mv_ch12","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
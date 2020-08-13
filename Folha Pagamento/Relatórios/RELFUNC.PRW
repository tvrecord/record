#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFUNC   บ Autor ณ Rafael Franca      บ Data ณ 16/08/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRELAวAO DE FUNCIONARIOS LIMITE DE COMPRAS                   บฑฑ
ฑฑ|          |     														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRELFUNC                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELFUNC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "RELAวAO DE FUNCIONARIOS - LIMITE DE COMPRAS - "
Local nLin           := 100

Local Cabec1         := " Matr.    Nome                                   CPF            RG             Endere็o                           Complemento       Bairro            Municipio      UF  CEP         Nascimento  Admissao             Valor"
Local Cabec2         := ""
Local Cabec3         := ""
Local imprime        := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RELFUNC"// Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELFUNC"// Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg	     := "RELFUNC2"
Private cString      := "SRA"
Private cQuery       := ""
Private nCont	    := 0
Private dData	    := ("//")


ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERAวรO CANCELADA")
	return
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   

dData := (STOD(SUBSTR(DTOS(MV_PAR03),1,6) + "28") + 10) 

IF MV_PAR07 == 2
Cabec1         := " Matr.  C. Custo    Nome                                    Nascimento    Premio          Numero   Filial  Sexo       Admissao      Competencia     CPF              Cargo"
ENDIF   

IF MV_PAR07 == 1             
Titulo := Titulo + UPPER(Mes(dData)) + "/" + SUBSTR(DTOS(dData),1,4)
ELSE
Titulo := "COMPETสNCIA - " + SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4) + " TV CAPITAL"
ENDIF

wnrel := SetPrint("",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)    

cQuery	:= "SELECT RA_FILIAL,RA_SITFOLH,RA_TPCONTR,RA_MAT,RA_CC,RA_SEXO,RA_NOME,RA_CIC,RA_RG,RA_CODFUNC, RA_ENDEREC,RA_COMPLEM,RA_BAIRRO,RA_MUNICIP,RA_ESTADO,RA_CEP, "
cQuery	+= "SUBSTRING(RA_NASC,7,2) + '/' + SUBSTRING(RA_NASC,5,2) + '/'+  SUBSTRING(RA_NASC,1,4) AS NASCIMENTO, "
cQuery	+= "SUBSTRING(RA_ADMISSA,7,2) + '/' + SUBSTRING(RA_ADMISSA,5,2) + '/'+  SUBSTRING(RA_ADMISSA,1,4) AS ADMISSAO "
IF MV_PAR07 == 1 
cQuery	+= ",SUM(RD_VALOR) * 0.3 AS VALOR " 
ENDIF
cQuery	+= "FROM SRA010 "  
IF MV_PAR07 == 1 
cQuery	+= "INNER JOIN SRD010 ON RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT "
ENDIF
cQuery	+= "WHERE SRA010.D_E_L_E_T_ <> '*' AND SRA010.RA_MAT BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
IF !EMPTY(MV_PAR12) .AND. !EMPTY(MV_PAR13) // Rafael Fran็a - parametro ira funcionar apenas quando forem preenchidas as duas datas de demissao.
cQuery	+= "AND (RA_SITFOLH NOT IN ('D') OR RA_SITFOLH = 'D' AND RA_DEMISSA BETWEEN '" + DTOS(MV_PAR12) + "' AND '" + DTOS(MV_PAR13) + "') " 
ELSE
cQuery	+= "AND RA_SITFOLH NOT IN ('D') "
ENDIF
cQuery	+= "AND RA_CATFUNC <> 'E' "
cQuery	+= "AND RA_ADMISSA BETWEEN '" + DTOS(MV_PAR10) + "' AND '" + DTOS(MV_PAR11) + "' "
IF MV_PAR07 == 1 
cQuery	+= "AND SRD010.D_E_L_E_T_ <> '*' AND SRD010.RD_PD = '799' AND SRD010.RD_DATARQ = '" + SUBSTR(DTOS(MV_PAR03),1,6) + "' "
cQuery	+= "AND RA_TPCONTR <> '2' "
ENDIF
cQuery	+= "AND SRA010.RA_FILIAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
cQuery	+= "GROUP BY RA_FILIAL,RA_SITFOLH,RA_CODFUNC,RA_TPCONTR,RA_MAT,RA_CC,RA_SEXO,RA_NOME,RA_CIC,RA_RG,RA_ENDEREC,RA_COMPLEM,RA_BAIRRO, "
cQuery	+= "RA_MUNICIP,RA_ESTADO,RA_CEP,RA_NASC,RA_ADMISSA "   
IF 		MV_PAR06 == 1
	cQuery	+= "ORDER BY RA_MAT "
ELSEIF 	MV_PAR06 == 2
	cQuery	+= "ORDER BY RA_NOME "
ENDIF

tcQuery cQuery New Alias "TMP"
                               

If Eof()
	MsgInfo("Nao existem dados a serem impressos!","Verifique")
	dbSelectArea("TMP")
	dbCloseArea("TMP")
	Return
Endif

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

dbSelectArea("TMP")
dbCloseArea("TMP")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  28/09/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nItensTot := 0
Local nValorTot := 0


DBSelectArea("TMP")
DBGotop()

//DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD

While !EOF()
	
	SetRegua(RecCount())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit                                             
		
		
	Endif
	
	If nLin > 70 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

    IF MV_PAR07 == 1 
				
	@nLin, 000 PSAY Alltrim(TMP->RA_MAT)
	@nLin, 008 PSAY SUBSTR(TMP->RA_NOME,1,38)   
	@nLin, 048 PSAY TMP->RA_CIC 
	@nLin, 061 PSAY TMP->RA_RG
	@nLin, 078 PSAY TMP->RA_ENDEREC
	@nLin, 110 PSAY TMP->RA_COMPLEM
	@nLin, 127 PSAY TMP->RA_BAIRRO
	@nLin, 148 PSAY TMP->RA_MUNICIP
	@nLin, 170 PSAY TMP->RA_ESTADO
	@nLin, 174 PSAY TMP->RA_CEP //PICTURE "@R 99.999-999" 
	@nLin, 184 PSAY TMP->NASCIMENTO
	@nLin, 198 PSAY TMP->ADMISSAO
	@nLin, 210 PSAY TMP->VALOR PICTURE "@E 999,999.99"   
	
	nValorTot  	+= TMP->VALOR
	
	ELSE
	
	@nLin, 000 PSAY Alltrim(TMP->RA_MAT)  
	@nLin, 008 PSAY TMP->RA_CC 
	@nLin, 020 PSAY SUBSTR(TMP->RA_NOME,1,38) 
	@nLin, 060 PSAY TMP->NASCIMENTO   
	@nLin, 074 PSAY MV_PAR08
	@nLin, 090 PSAY MV_PAR09 
	@nLin, 103 PSAY TMP->RA_FILIAL 
	IF TMP->RA_SEXO == "F"  
	@nLin, 107 PSAY "FEMININO"	
	ELSEIF TMP->RA_SEXO == "M"
	@nLin, 107 PSAY "MASCULINO" 
	ENDIF  
	@nLin, 118 PSAY TMP->ADMISSAO 
	@nLin, 132 PSAY SUBSTR(DTOS(MV_PAR03),5,2) + "/" +  SUBSTR(DTOS(MV_PAR03),1,4) 
	@nLin, 148 PSAY TMP->RA_CIC 
	@nLin, 165 PSAY Posicione("SRJ",1,xFilial("SRJ")+ TMP->RA_CODFUNC,"RJ_DESC")
	ENDIF

	nItensTot 	+= 1

	dbSelectArea ("TMP")
	dbskip()

	 
	nLin 		+= 1 // Avanca a linha de impressao
	
ENDDO 

@nLin, 001 PSAY UPPER("Total Geral:") 
@nLin, 020 PSAY nItensTot PICTURE "@E 999"  

IF MV_PAR07 == 1   
@nLin, 210 PSAY nValorTot PICTURE "@E 999,999.99"
ENDIF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg(cPerg)

_sAlias := Alias()
cPerg := PADR(cPerg,10)
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Matricula	","","","mv_ch01","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"02","Ate Matricula	","","","mv_ch02","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA"})
AADD(aRegs,{cPerg,"03","Mes				","","","mv_ch03","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Da  Filial 		","","","mv_ch04","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})
AADD(aRegs,{cPerg,"05","Ate Filial 		","","","mv_ch05","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0"})                                  
AADD(aRegs,{cPerg,"06","Ordem			","","","mv_ch06","N",01,0,2,"C","","mv_par06","Matricula","","","","","Nome","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Relatorio		","","","mv_ch07","N",01,0,2,"C","","mv_par07","Limite Compras","","","","","Compet๊ncia","","","","","","","","","","","","","","","","","","","","","","",""})   
AADD(aRegs,{cPerg,"08","Premio			","","","mv_ch08","C",14,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Numero			","","","mv_ch09","C",07,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Da  Admissao	","","","mv_ch10","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Ate Admissao	","","","mv_ch11","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"12","Da Dt Demissao	","","","mv_ch12","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Ate Dt Demissao	","","","mv_ch13","D",08,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
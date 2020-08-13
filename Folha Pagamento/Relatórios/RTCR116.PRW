#include "RWMAKE.CH"  // Padrใo
#include "TOPCONN.CH" // Para usar o TCQUERY
#include "VKEY.CH"    // Teclas Virtuais

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณICAR103    บ Autor ณ EDMILSON D. STOS   บ Data ณ  16/02/07  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relacao Sintetica dos Grupos de Verbas, relacionados ao    บฑฑ
ฑฑบ            Gestใo Pessoal
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cliente Microsiga - IICA                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RTCR116()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aOrd 				:= {}
LOCAL	aPergs 			:= {}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Posicao de Clientes que mais compraram no Periodo"
Local cPict          := ""
Local imprime        := .T.
Local Cabec1         := "CENTRO DE CUSTO                                                            "
Local Cabec2         := "     NOME DO FUNCIONARIO                                              V A L O R"

Private nLin           := 80
Private cString
Private aTotCont:=aTotDia:=aTotVlic:=aTotBase:=aTotIcmc:=0
Private CbTxt        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "ICAR104" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RTR116"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 1
Private wnrel        := "RTCR116" // Coloque aqui o nome do arquivo usado para impressao em disco

Aadd(aPergs,{"Da Filial","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","XM0","","","",""})
Aadd(aPergs,{"Ate Filial","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZ","","","","","","","","","","","","","","","","","","","","","XM0","","","",""})
Aadd(aPergs,{"Mes/Ano","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Imprime Folha","","","mv_ch4","N",1,0,0,"C","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Da Matricula","","","mv_ch5","C",6,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
Aadd(aPergs,{"Ate Matricula","","","mv_ch6","C",6,0,0,"G","","MV_PAR06","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SRA","","","",""})
Aadd(aPergs,{"Do C.Custo","","","mv_ch7","C",9,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
Aadd(aPergs,{"Ate C.Custo","","","mv_ch8","C",9,0,0,"G","","MV_PAR08","","","","ZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","CTT","","","",""})
Aadd(aPergs,{"Ordem ","","","mv_ch9","N",1,0,0,"C","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1("RTR116",aPergs)

Pergunte(cPerg, .F.)

Titulo         := "RELACAO DE LIQUIDOS "+ALLTRIM(MESEXTENSO(VAL(SUBSTR(MV_PAR03,1,2)))+"/"+SUBSTR(MV_PAR03,3,4))
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP5 IDE            บ Data ณ  21/05/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

/*/
Static Function RunReport(Cabec1,Cabec2,Titulo)

Local pTotGeral
Local cQuery
Local pTipoAnt
Local titulo := "RELACAO DE LIQUIDOS - "+ALLTRIM(MESEXTENSO(VAL(SUBSTR(MV_PAR03,1,2)))+"/"+SUBSTR(MV_PAR03,3,4))

DbSelectArea("SRC")
IF RDDName() <> "TOPCONN"
	MsgStop("Este relatorio somente podera ser executado na versao SQL do SIGA Advanced.")
	Return nil
ENDIF

IF MONTH(DDATABASE) == VAL(SUBSTR(MV_PAR03,1,2))
	cQuery := " SELECT RV.RV_FILIAL,RV.RV_CODFOL,RA.RA_FILIAL,RA.RA_MAT,RA.RA_NOME,RC.RC_FILIAL,"
	cQuery += "	RC.RC_PD,RC.RC_CC AS CCUSTO,RC.RC_MAT,RC.RC_VALOR AS VALOR,RC.RC_DATA"
	cQuery += "	FROM "+RetSqlName("SRC")+" RC,"+RetSqlName("SRV")+" RV,"+RetSqlName("SRA")+" RA"
	cQuery += "	WHERE "
	cQuery += "	RC.RC_PD       = RV.RV_COD    AND "
	cQuery += "	RC.RC_FILIAL   = RA.RA_FILIAL AND "
	cQuery += " RC.RC_MAT      = RA.RA_MAT    AND "
	cQuery += "	RC.RC_FILIAL   = '"+xFilial("SRC")+"' AND "
	cQuery += "	RA.RA_FILIAL   = '"+xFilial("SRA")+"' AND "
	cQuery += "	RV.RV_FILIAL   = '"+xFilial("SRV")+"' AND "
	cQuery += " RA.RA_CATFUNC != 'A' AND "
	cQuery += "	RC.D_E_L_E_T_ != '*' AND"
	cQuery += " RV.D_E_L_E_T_ != '*' AND"
	cQuery += " RA.D_E_L_E_T_ != '*' AND RA.RA_SITFOLH != 'D' AND "
	cQuery += "	RC.RC_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
	cQuery += "	RC.RC_MAT     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQuery += "	RC.RC_CC      BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
   IF MV_PAR04 <> 1 //Adiantamento
		cQuery += " SUBSTRING(RC.RC_DATA,5,2) = '"+IIF(STRZERO(VAL(SUBSTR(MV_PAR03,1,2))+1,2)=="12","01",STRZERO(VAL(SUBSTR(MV_PAR03,1,2))+1,2))+"' AND "
		cQuery += "	SUBSTRING(RC.RC_DATA,1,4) = '"+IIF(STRZERO(VAL(SUBSTR(MV_PAR03,1,2))+1,2)=="12",STRZERO(VAL(SUBSTR(MV_PAR03,3,4)+1)),SUBSTR(MV_PAR03,3,4))+"' AND "
	ELSE 
		cQuery += " SUBSTRING(RC.RC_DATA,5,2) = '"+SUBSTR(MV_PAR03,1,2)+"' AND "
		cQuery += "	SUBSTRING(RC.RC_DATA,1,4) = '"+SUBSTR(MV_PAR03,3,4)+"' AND "	
	ENDIF	
	IF MV_PAR04 == 1 //Adiantamento
		cQuery += "	RV.RV_CODFOL ='007' AND "
		cQuery += "	RV.RV_CODFOL ='009' AND 
	ELSEIF MV_PAR04 == 2	//Folha Mensal
		cQuery += "	RV.RV_CODFOL = '047'"
	ELSEIF MV_PAR04 == 3 // 1ช Parc. 13 salario
		cQuery += "	RV.RV_CODFOL = '022'"
	ELSE // 2ช Parc. 13 salario
		cQuery += "	RV.RV_CODFOL = '021'"
	ENDIF
	IF mv_par09 == 2
	   cQuery += " ORDER BY RC_FILIAL,RC_CC,RA_NOME"
	ELSE                                            
	   cQuery += " ORDER BY RC_FILIAL,RA_NOME"
	ENDIF   
ELSE
	cQuery := " SELECT RV.RV_FILIAL,RV.RV_CODFOL,RA.RA_FILIAL,RA.RA_MAT,RA.RA_NOME,RD.RD_FILIAL,"
	cQuery += "	RD.RD_PD,RD.RD_CC,RD.RD_MAT,RD.RD_VALOR AS VALOR,RD.RD_DATARQ"
	cQuery += "	FROM "+RetSqlName("SRD")+" RD,"+RetSqlName("SRV")+" RV,"+RetSqlName("SRA")+" RA "
	cQuery += "	WHERE "
	cQuery += "	RD.RD_PD  = RV.RV_COD AND "
	cQuery += "	RD.RD_FILIAL   = RA.RA_FILIAL AND RD.RD_MAT = RA.RA_MAT AND RA.RA_CATFUNC != 'A' AND "
	cQuery += "	RD.RD_FILIAL   = '"+xFilial("SRD")+"' AND "
	cQuery += "	RD.D_E_L_E_T_ != '*' AND RV.D_E_L_E_T_ != '*' AND RA.D_E_L_E_T_ != '*' AND RA.RA_SITFOLH != 'D'AND "
	cQuery += "	RD.RD_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SUBSTRING(RD.RD_DATARQ,5,2) = '"+SUBSTR(MV_PAR03,1,2)+"' AND"
	cQuery += "	SUBSTRING(RD.RD_DATARQ,1,4)  = '"+SUBSTR(MV_PAR03,3,4)+"' AND "
	cQuery += "	RD.RD_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	cQuery += "	RD.RD_CC  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
	IF MV_PAR04 == 1 //Adiantamento
		cQuery += "	RV.RV_CODFOL IN ('007')"
	ELSEIF MV_PAR04 == 2	//Folha Mensal
		cQuery += "	RV.RV_CODFOL IN ('047')"
	ELSEIF MV_PAR04 == 3 // 1ช Parc. 13 salario
		cQuery += "	RV.RV_CODFOL IN ('022')"
	ELSE // 2ช Parc. 13 salario
		cQuery += "	RV.RV_CODFOL IN ('021')"
	ENDIF     
	IF mv_par09 == 2
	   cQuery += " ORDER BY RD_FILIAL,RD_CC,RA_NOME"
	ELSE
	   cQuery += " ORDER BY RD_FILIAL,RA_NOME"
	ENDIF   
	
ENDIF

TCQUERY cQUERY NEW ALIAS "QSRC"

IF MV_PAR09 == 2
	
	dbselectarea("QSRC")
	SetRegua(RecCount())
	dbGoTop()
	
	pTotGeral := 0
	pTotFunc  := 0
	
	WHILE !QSRC->(EOF())
		
		IncRegua()
		
		pCCusto := QSRC->CCUSTO
		
		pImpCC  := .T.
		pTotCC  := 0
		nReg	  := 0
		
		WHILE !QSRC->(EOF()) .AND.QSRC->CCUSTO == pCCusto
			
			IF nLin > 60
				Cabec(Titulo+" "+IIF(MV_PAR04==1,"Adto.",IIF(MV_PAR04==2,"Folha",IF(MV_PAR04==3,"1a.Parc.13 Sal","2a Parc.13o.Sal."))),cabec1,cabec2,nomeprog,tamanho,nTipo)
				nLin:= 9
				pImpCC := .T.
			EndIF
			
			IF pImpCC
				@ nLin,10 PSAY QSRC->CCUSTO+" - "+POSICIONE("CTT",1,xFilial("CTT")+QSRC->CCUSTO,"CTT_DESC01")
				nLin+=2
				pImpCC := .F.
			ENDIF
			
			@ nLin, 10 PSAY LEFT(QSRC->RA_NOME,45)
			@ nLin, 68 PSAY QSRC->VALOR PICTURE "@E 9,999,999.99"
			nLin++
			
			pTotCC  +=QSRC->VALOR
			nReg++
			
			pTipoAnt := QSRC->CCUSTO
			
			QSRC->(dbskip())
			
		ENDDO
		
		pTotGeral += pTotCC
		pTotFunc  += nReg
		
		IF nReg > 1
			nLin++
			@ nLin, 10 PSAY "Func.: "+Transform(nReg, "@R 999")
			@ nLin, 30 PSAY "Total Centro Custo :"+pTipoAnt
			@ nLin, 68 PSAY pTotCC PICTURE "@E 9,999,999.99"
			nLin+=2
		ENDIF
		
	ENDDO
	
	IF nLin > 60
		Cabec(Titulo+" "+IIF(MV_PAR04==1,"Adto.",IIF(MV_PAR04==2,"Folha",IF(MV_PAR04==3,"1a.Parc.13 Sal","2a Parc.13o.Sal."))),cabec1,cabec2,nomeprog,tamanho,nTipo)
		nLin:= 9
		pImpCC := .T.
	EndIF
	nLin++
	@ nLin, 10 PSAY "Func.: "+Transform(pTotFunc, "@R 9,999")
	@ nLin, 30 PSAY "Total Geral........:"
	@ nLin, 68 PSAY pTotGeral PICTURE "@E 9,999,999.99"
	
ELSE
	dbselectarea("QSRC")
	SetRegua(RecCount())
	dbGoTop()
	
	pTotGeral := 0
	pTotFunc  := 0
	
	WHILE !QSRC->(EOF())
		
		IncRegua()
   
		IF nLin > 60
			Cabec(Titulo+" "+IIF(MV_PAR04==1,"Adto.",IIF(MV_PAR04==2,"Folha",IF(MV_PAR04==3,"1a.Parc.13 Sal","2a Parc.13o.Sal."))),cabec1,cabec2,nomeprog,tamanho,nTipo)
			nLin:= 9
			pImpCC := .T.
		EndIF
	
		@ nLin, 10 PSAY LEFT(QSRC->RA_NOME,45)
		@ nLin, 68 PSAY QSRC->VALOR PICTURE "@E 9,999,999.99"
		nLin++
	
		pTotGeral += QSRC->VALOR
		pTotFunc  ++
	
		QSRC->(dbskip())
	
	ENDDO	

	nLin++
   IF nLin > 60
		Cabec(Titulo+" "+IIF(MV_PAR04==1,"Adto.",IIF(MV_PAR04==2,"Folha",IF(MV_PAR04==3,"1a.Parc.13 Sal","2a Parc.13o.Sal."))),cabec1,cabec2,nomeprog,tamanho,nTipo)
		nLin:= 9
		pImpCC := .T.
	EndIF
	
   @ nLin, 00 PSAY REPLICATE("-",80)
	@ ++nLin, 10 PSAY "Func.: "+Transform(pTotFunc, "@R 9,999")
	@ nLin, 30 PSAY "Total Geral........:"
	@ nLin, 68 PSAY pTotGeral PICTURE "@E 9,999,999.99"
	nLin++
   @ nLin, 00 PSAY REPLICATE("-",80)

ENDIF

IF nLin <> 80
	Roda()
ENDIF

IF (aReturn[5] = 1) 	// Se Saida para disco, ativa (desvia para)SPOOL
	SET PRINTER TO
	OurSpool(wnrel)
ENDIF

MS_FLUSH()
dbSelectArea( "QSRC" )
DBCLOSEAREA()

Return

/*
VERPERG - Valida a existencia dos parametros do Relatorio e Cria
*/
/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ AjustaSx1    ณ Autor ณ Microsiga            	ณ Data ณ 13/10/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica/cria SX1 a partir de matriz para verificacao          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Especifico para Clientes Microsiga                    	  		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

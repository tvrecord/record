#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

//VLSPOT CALCULA O VALOR DO SPOT COM BASE NAS NFS - RAFAEL FRANÇA - 15/04/16

User Function VLSPOT()

Local nVlspot	:= 0   
Local nVlspot1	:= 0
Local nPerc		:= (M->ZAB_PERC / 100)
Local nPerc1	:= (M->ZAB_PERC2 / 100) 
Local cQuery	:= ""

IF !EMPTY(M->ZAB_PERC) .AND. !EMPTY(M->ZAB_NOTAS) //Verifica se os campos necessarios estao preenchidos
	
	cQuery	:= "SELECT SUM(SPOT) AS SPOT FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS SPOT FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' AND E1_NATUREZ IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('2','4')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTAS," ")
	IF !EMPTY(M->ZAB_NOTAS1)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS1," ") 
	ENDIF  
	IF !EMPTY(M->ZAB_NOTAS2)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS2," ") 	 
	ENDIF 
	IF !EMPTY(M->ZAB_NOTAS3)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS3," ") 	 
	ENDIF
	IF !EMPTY(M->ZAB_NOTAS4)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS4," ") 	 
	ENDIF	
	cQuery	+= ")GROUP BY E1_COMIS1)"

	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVlspot)
	Endif
	
	dbSelectArea("TMP")		
	nVlspot	:= TMP->SPOT * nPerc	
	dbCloseArea("TMP")
	
ENDIF

IF !EMPTY(M->ZAB_PERC2) .AND. !EMPTY(M->ZAB_NOTASR)  // Separa o calculo para calcular 2 porcentagens diferentes Edna/Elisangela - 15/04/16
	
	cQuery	:= "SELECT SUM(SPOT1) AS SPOT1 FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS SPOT1 FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' AND E1_NATUREZ IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('2','4')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTASR," ")  
	IF !EMPTY(M->ZAB_NOTASA)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTASA," ")  
	ENDIF  
	cQuery	+= ")GROUP BY E1_COMIS1)"

	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVlspot)
	Endif
	
	dbSelectArea("TMP")		
	nVlspot1	:= TMP->SPOT1 * nPerc1	
	dbCloseArea("TMP")
	
ENDIF

nVlspot := nVlspot1 +nVlspot 

Return(nVlspot) 

//VLLOCAL CALCULA O VALOR DO LOCAL COM BASE NAS NFS - RAFAEL FRANÇA - 15/04/16

User Function VLLOCAL()

Local nVllocal	:= 0 
Local nVllocal1	:= 0
Local nPerc		:= (M->ZAB_PERC / 100)  
Local nPerc1 	:= (M->ZAB_PERC2 / 100) 
Local cQuery	:= ""

IF !EMPTY(M->ZAB_PERC) .AND. !EMPTY(M->ZAB_NOTAS)
	
	cQuery	:= "SELECT SUM(LOCAL) AS LOCAL FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS LOCAL FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' AND E1_NATUREZ IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('1','3')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTAS," ") 
	IF !EMPTY(M->ZAB_NOTAS1)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS1," ")
	ENDIF  
	IF !EMPTY(M->ZAB_NOTAS2)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS2," ") 	 
	ENDIF 
	IF !EMPTY(M->ZAB_NOTAS3)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS3," ") 	 
	ENDIF
	IF !EMPTY(M->ZAB_NOTAS4)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS4," ") 	 
	ENDIF 	
	cQuery	+= ")GROUP BY E1_COMIS1)"
	
	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVllocal)
	Endif
	
	dbSelectArea("TMP")
	nVllocal	:= TMP->LOCAL * nPerc
	dbCloseArea("TMP")
	
ENDIF  

IF !EMPTY(M->ZAB_PERC2) .AND. !EMPTY(M->ZAB_NOTASR)  // Separa o calculo para calcular 2 porcentagens diferentes Edna/Elisangela - 15/04/16
	
cQuery	:= "SELECT SUM(LOCAL1) AS LOCAL1 FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS LOCAL1 FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' AND E1_NATUREZ IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('1','3')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTASR," ")  
	IF !EMPTY(M->ZAB_NOTASA)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTASA," ")  
	ENDIF 
	cQuery	+= ")GROUP BY E1_COMIS1)"

	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVllocal)
	Endif
	
	dbSelectArea("TMP")		
	nVllocal1	:= TMP->LOCAL1 * nPerc1	
	dbCloseArea("TMP")
	
ENDIF

nVlLocal := nVlLocal1 + nVlLocal

Return(nVllocal)  

//VLTOTAL CALCULA O VALOR TOTAL COM BASE NAS NFS - RAFAEL FRANÇA - 15/04/16

User Function VLTOTAL()

Local nVlTotal	:= 0  
//Local nPerc		:= (M->ZAB_PERC / 100)
Local cQuery	:= ""

IF !EMPTY(M->ZAB_NOTAS)
	
cQuery	:= "SELECT SUM(TOTAL) AS TOTAL FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS TOTAL FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' " //AND E1_NATUREZ NOT IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('1','3')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTAS," ") 
	IF !EMPTY(M->ZAB_NOTAS1)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS1," ")
	ENDIF  
	IF !EMPTY(M->ZAB_NOTAS2)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS2," ") 	 
	ENDIF 
	IF !EMPTY(M->ZAB_NOTAS3)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS3," ") 	 
	ENDIF
	IF !EMPTY(M->ZAB_NOTAS4)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS4," ") 	 
	ENDIF
	IF !EMPTY(M->ZAB_NOTASR)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTASR," ") 
	ENDIF 
	IF !EMPTY(M->ZAB_NOTASA)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTASA," ")
	ENDIF	
	cQuery	+= ")GROUP BY E1_COMIS1)"
	
	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVlTotal)
	Endif
	
	dbSelectArea("TMP")
	nVlTotal	:= TMP->TOTAL 
	dbCloseArea("TMP")
	
ENDIF

Return(nVlTotal)

User Function VLCOMISSAO()

Local nVlComiss	:= 0
Local nVlComiss1 := 0
Local nPerc		:= (M->ZAB_PERC / 100)
Local nPerc1	:= (M->ZAB_PERC2 / 100)
Local cQuery	:= ""

IF !EMPTY(M->ZAB_PERC) .AND. !EMPTY(M->ZAB_NOTAS)
	
cQuery	:= "SELECT SUM(COMISSAO) AS COMISSAO FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS COMISSAO FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' " //AND E1_NATUREZ NOT IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('1','3')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTAS," ") 
	IF !EMPTY(M->ZAB_NOTAS1)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS1," ") 
	ENDIF  
	IF !EMPTY(M->ZAB_NOTAS2)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS2," ") 
	ENDIF 	
	IF !EMPTY(M->ZAB_NOTAS3)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS3," ") 
	ENDIF 
	IF !EMPTY(M->ZAB_NOTAS4)
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTAS4," ") 
	ENDIF 		
	cQuery	+= ")GROUP BY E1_COMIS1)"
	
	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVlComiss)
	Endif
	
	dbSelectArea("TMP")
	nVlComiss	:= TMP->COMISSAO * nPerc
	dbCloseArea("TMP")
	
ENDIF  

IF !EMPTY(M->ZAB_PERC2) .AND. !EMPTY(M->ZAB_NOTASR)  // Separa o calculo para calcular 2 porcentagens diferentes Edna/Elisangela - 15/04/16
	
cQuery	:= "SELECT SUM(COMISSAO1) AS COMISSAO1 FROM (SELECT SUM(E1_VALOR) * (1 - (E1_COMIS1 / 100)) AS COMISSAO1 FROM SE1010 "
	cQuery	+= "WHERE D_E_L_E_T_ = '' "//AND E1_NATUREZ IN (SELECT ED_CODIGO FROM SED010 WHERE D_E_L_E_T_ = '' AND ED_TIPNAT IN ('1','3')) "
	cQuery	+= "AND E1_TIPO = 'NF' AND E1_PREFIXO = 'UNI' "
	cQuery	+= "AND (E1_NUM IN " + FormatIn(M->ZAB_NOTASR," ") + " " 
	IF !EMPTY(M->ZAB_NOTASA)  // Acresenta maior espaço para gravação dos numeros das NFs
	cQuery	+= " OR E1_NUM IN " + FormatIn(M->ZAB_NOTASA," ")  
	ENDIF 	
	cQuery	+= ")GROUP BY E1_COMIS1)"	

	tcQuery cQuery New Alias "TMP"
	
	If Eof()
		dbSelectArea("TMP")
		dbCloseArea("TMP")
		Return(nVlComiss)
	Endif
	
	dbSelectArea("TMP")		
	nVlComiss1	:= TMP->COMISSAO1 * nPerc1	
	dbCloseArea("TMP")
	
ENDIF

nVlComiss	:= nVlComiss + nVlComiss1	

Return(nVlComiss)
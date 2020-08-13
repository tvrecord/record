#include 'rwmake.ch'
#include 'topconn.ch'

User Function RetLP810()

Local cQuery    := ""
Local nRet		:=	0

cQuery 	:= " Select N4_VLROC1 "
cQuery 	+= " From " + RetSQLName("SN4")
cQuery	+=	" Where N4_FILIAL  = '" + xFilial("SN4") 		+ "' and "
cQuery	+=		"    N4_CBASE   = '" + SN3->N3_CBASE		+ "' and "
cQuery	+=		"    N4_ITEM    = '" + SN3->N3_ITEM 		+ "' and "
cQuery	+=		"    N4_TIPO    = '" + SN3->N3_TIPO 		+ "' and "
cQuery	+=		"    N4_DATA    = '" + DtoS(dDatabase)		+ "' and "
IF SN3->N3_TIPO == "01"
	cQuery	+=		"    N4_OCORR   = '06' and "
ELSEIF SN3->N3_TIPO == "10"
	cQuery	+=		"    N4_OCORR   = '20' and "
ELSE
	cQuery	+=		"    N4_OCORR   = '06' and "
ENDIF
cQuery	+=		"    N4_TIPOCNT = '3'  and "
cQuery	+=		"    D_E_L_E_T_ = ' '  "

TcQuery cQuery New Alias "TTTQRY"

TcSetField( "TTTQRY" , "N4_VLROC1" , "N" , 14 , 2 )

nRet := TTTQRY->N4_VLROC1

TTTQRY->(dbclosearea())

Return ( nRet ) 
#INCLUDE "RWMAKE.CH"
#INCLUDE "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORTSA2 ºAutor  ³Bruno Alves Oliveiraº Data ³  05/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exporta o codigo do Fornecedor para o campo Z1_COD e cria  º±±
±±º          ³ um novo Codigo no campo Z1_CODNV                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       

User Function IMPORTDESC()

Local cQuery := ""

cQuery := "SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC FROM SRA010 INNER JOIN CTT010 ON SRA010.RA_FILIAL = CTT010.CTT_FILIAL AND SRA010.RA_CC = CTT010.CTT_CUSTO  INNER JOIN SRJ010 ON SRA010.RA_CODFUNC = SRJ010.RJ_FUNCAO ORDER BY SRA010.RA_FILIAL,SRA010.RA_MAT"
TcQuery cQuery New Alias "TMP"

If EOF()
MsgInfo("Nenhum Registro Encontrado!")
return()
Endif

dbSelectArea("TMP")
dbGotop()


WHILE !EOF()

dBSelectArea("SRA")
dBSetOrder(1)
dbSeek(TMP->RA_FILIAL + TMP->RA_MAT)

dBSelectArea("SRA")
RECLOCK("SRA",.F.)
SRA->RA_DCCUSTO := TMP->CTT_DESC01
SRA->RA_DECARGO := TMP->RJ_DESC
MSUNLOCK()



dBSelectArea("TMP")
dBSkip()

end

Alert("Campos Alimentados com sucesso!!")

dBCloseArea("TMP")
dBCloseArea("SRA")

Return
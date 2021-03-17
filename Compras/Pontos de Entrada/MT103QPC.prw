#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103QPC   �Autor  �Rafael Franca      � Data �  16/03/21   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para selecionar pedidos de lojas diferentes        ���
�������������������������������������������������������������������������͹��
���Uso       �RECORD DF                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT103QPC

Local cQry:=ParamIxb[1] //Query padr�o do sistema
Local nOpc:=ParamIxb[2]
Local cQryRet   := ""
Local cBaseCNPJ := SUBSTRING(Posicione("SA2",1,xFilial("SA2")+ cA100FOR + CLOJA,"A2_CGC"),1,8) //Busco a base do cnpj do fornecedor

If nOpc	== 1 // Montar a Query ao pressionar F5
cQryRet := "SELECT R_E_C_N_O_ RECSC7 FROM SC7010 SC7 "
cQryRet += "WHERE C7_FILENT = '01' AND C7_FORNECE IN (SELECT A2_COD FROM SA2010 WHERE SA2010.D_E_L_E_T_ = '' AND SUBSTRING(A2_CGC,1,8) = '"+cBaseCNPJ+"') "
cQryRet += "AND (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND C7_RESIDUO=' ' AND C7_TPOP<>'P' AND C7_CONAPRO <> 'B' AND C7_CONAPRO <> 'R' AND D_E_L_E_T_ = ' ' "
cQryRet += "ORDER BY C7_FILENT,C7_FORNECE,C7_LOJA,C7_NUM "

Else // Montar a Query ao pressionar F6
cQryRet := "SELECT C7_FILIAL,C7_TIPO,C7_ITEM,C7_PRODUTO,C7_UM,C7_SEGUM,C7_QUANT,C7_CODTAB,C7_PRECO,C7_TOTAL,C7_QTSEGUM,C7_IPI,C7_NUMSC,C7_ITEMSC,C7_DATPRF,C7_LOCAL,C7_OBS,C7_FORNECE,C7_CC,C7_CONTA,C7_ITEMCTA,C7_LOJA,C7_COND,C7_CONTATO,C7_FILENT,C7_DESC1,C7_DESC2,C7_DESC3,C7_EMISSAO,C7_NUM,C7_QUJE,C7_REAJUST,C7_FRETE,C7_EMITIDO,C7_DESCRI,C7_TPFRETE,C7_QTDREEM,C7_CODLIB,C7_RESIDUO,C7_NUMCOT,C7_MSG,C7_TX,C7_CONTROL,C7_IPIBRUT,C7_ENCER,C7_OP,C7_VLDESC,C7_SEQUEN,C7_NUMIMP,C7_ORIGEM,C7_QTDACLA,C7_VALEMB,C7_FLUXO,C7_TPOP,C7_APROV,C7_CONAPRO,C7_GRUPCOM,C7_USER,C7_STATME,C7_OK,C7_QTDSOL,C7_VALIPI,C7_VALICM,C7_TES,C7_DESC,C7_PICM,C7_BASEICM,C7_BASEIPI,C7_SEGURO,C7_DESPESA,C7_VALFRE,C7_MOEDA,C7_TXMOEDA,C7_PENDEN,C7_CLVL,C7_BASEIR,C7_ALIQIR,C7_VALIR,C7_ICMCOMP,C7_ICMSRET,C7_SEQMRP,C7_CODORCA,C7_DTLANC,C7_CODCRED,C7_TIPOEMP,C7_ESPEMP,C7_CONTRA,C7_CONTREV,C7_PLANILH,C7_MEDICAO,C7_ITEMED,C7_BASESOL,C7_VALSOL,C7_USERLGI,C7_USERLGA,C7_FREPPCC,C7_POLREPR,C7_DT_IMP,C7_PERREPR,C7_AGENTE,C7_GRADE,C7_ITEMGRD,C7_FORWARD,C7_TIPO_EM,C7_ORIGIMP,C7_DEST,C7_COMPRA,C7_PESO_B,C7_INCOTER,C7_IMPORT,C7_CONSIG,C7_CONF_PE,C7_DESP,C7_EXPORTA,C7_LOJAEXP,C7_CONTAIN,C7_MT3,C7_CONTA20,C7_CONTA40,C7_CON40HC,C7_ARMAZEM,C7_FABRICA,C7_LOJFABR,C7_DT_EMB,C7_TEC,C7_EX_NCM,C7_EX_NBM,C7_DIACTB,C7_NODIA,C7_FILCEN,C7_DTMOT,C7_MOTIVO,C7_ESTOQUE,C7_CODED,C7_PO_EIC,C7_NUMPR,C7_RATEIO,C7_ACCPROC,C7_ACCNUM,C7_ACCITEM,C7_DINICQ,C7_DINITRA,C7_DINICOM,C7_RESREM,C7_NUMSA,C7_REVISAO,C7_IDTSS,C7_TPCOLAB,C7_ALIQISS,C7_VALISS,C7_BASECSL,C7_ALQCSL,C7_VALINS,C7_ALIQINS,C7_CODRDA,C7_LOTPLS,C7_VALCSL,C7_BASEISS,C7_FISCORI,C7_RATFIN,C7_BASEINS,C7_OBSM,C7_BASIMP5,C7_BASIMP6,C7_SOLICIT,C7_VALIMP5,C7_VALIMP6,C7_FILEDT,C7_GCPIT,C7_GCPLT,C7_TIPCOM,C7_CODNE,C7_ITEMNE,C7_PLOPELT,C7_DIREITO,C7_OBRIGA,C7_DEDUCAO,C7_QUJERET,C7_TRANSP,C7_QUJEFAT,C7_RETENCA,C7_QUJEDED,C7_FRETCON,C7_FATDIRE,C7_TRANSLJ,C7_IDTRIB,R_E_C_N_O_ RECSC7 FROM SC7010 SC7 "
cQryRet += "WHERE  C7_FILENT = '01' AND C7_FORNECE IN (SELECT A2_COD FROM SA2010 WHERE SA2010.D_E_L_E_T_ = '' AND SUBSTRING(A2_CGC,1,8) = '"+cBaseCNPJ+"') AND C7_TPOP <> 'P' AND (C7_CONAPRO = 'L' OR C7_CONAPRO = ' ') AND SC7.C7_ENCER =' ' AND SC7.C7_RESIDUO =' ' AND SC7.D_E_L_E_T_ = ' '  "
cQryRet += "ORDER BY  C7_FILENT,C7_FORNECE,C7_LOJA,C7_NUM"

EndIf

Return cQryRet
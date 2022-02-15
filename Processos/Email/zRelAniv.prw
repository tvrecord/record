//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

Static nCorCinza := RGB(110, 110, 110)
Static nCorAzul  := RGB(193, 231, 253)

/*/{Protheus.doc} User Function zRelAniv
Fun��o que gera o relat�rio de aniversariantes do dia
@type  Function
@author Pedro Leonardo
@since 03/09/2021
@version version
/*/

User Function zRelAniv()

    Local aArea
    Local lContinua   := .F.
    Private lJob      := .F.
    Private dDataRef  := Date()
    Private cDiretorio := "\x_aniversariantes\"

	//u_zEnvMail("rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br", "Teste", "Teste TMailMessage - Protheus", , .T.)

    //Se o ambiente n�o estiver em p�, sobe para usar de maneira autom�tica
    If Select("SX2") == 0
        lJob := .T.
        lContinua := .T.
		RPCSetEnv("99", "01", "", "", "", "")
    EndIf
    aArea := GetArea()

    //Se n�o for modo autom�tico, mostra uma pergunta
    If ! lJob
        lContinua := MsgYesNo("Deseja gerar o relat�rio de aniversariantes do dia?", "Aten��o")
    EndIf

    //Se for continuar, faz a chamada para a realiza��o das baixas
    If lContinua
        //Se a pasta n�o existir, cria
        If ! ExistDir(cDiretorio)
            MakeDir(cDiretorio)
        EndIf

        Processa({|| fMontaRel()}, "Processando...")
    EndIf
Return

Static Function fMontaRel()

    Local aArea        := GetArea()
	Local nAtual       := 0
    Local nTotal       := 0
    Local cQuerySRA    := ""
	Local cArquivo     := "zRelAniv_"+RetCodUsr()+"_" + dToS(Date()) + "_" + StrTran(Time(), ':', '-') + ".pdf"
    Local cFotoFunc    := ""
    Local cPastaTemp   := GetTempPath()
	Private oPrintPvt
	Private cHoraEx    := Time()
	Private nPagAtu    := 1
	//Linhas e colunas
	Private nLinAtu    := 0
	Private nLinFin    := 820
	Private nColIni    := 010
	Private nColFin    := 580
	Private nEspCol    := (nColFin-(nColIni+150))/13
	Private nColMeio   := (nColFin-nColIni)/2
	//Declarando as fontes
	Private cNomeFont  := "Arial"
	Private oFontDet   := TFont():New(cNomeFont, 9, -15, .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN  := TFont():New(cNomeFont, 9, -15, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontRod   := TFont():New(cNomeFont, 9, -8,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontMin   := TFont():New(cNomeFont, 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
	Private oFontMinN  := TFont():New(cNomeFont, 9, -7,  .T., .T., 5, .T., 5, .T., .F.)
	Private oFontTit   := TFont():New(cNomeFont, 9, -20, .T., .T., 5, .T., 5, .T., .F.)

    //Busca os funcion�rios que nasceram no mesmo dia de hoje
    cQuerySRA := " SELECT " + CRLF
    cQuerySRA += "     SRA.R_E_C_N_O_ AS SRAREC " + CRLF
    cQuerySRA += " FROM " + CRLF
    cQuerySRA += " 	" + RetSQLName("SRA") + " SRA " + CRLF
    cQuerySRA += " WHERE " + CRLF
    cQuerySRA += " 	RA_FILIAL = '" + FWxFilial("SRA") + "' " + CRLF
    cQuerySRA += " 	AND RA_SITFOLH NOT IN ('D', 'T') " + CRLF
    cQuerySRA += " 	AND SUBSTRING(RA_NASC, 5, 4) = '" + SubStr(dToS(dDataRef), 5) + "' " + CRLF
    cQuerySRA += " 	AND SRA.D_E_L_E_T_ = ' ' " + CRLF
    TCQuery cQuerySRA New Alias "QRY_SRA"

    //Se houver dados
    If ! QRY_SRA->(EoF())
		 //Criando o objeto de impressao
		If lJob
			oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., '', .T., .F., , ,.T., .T., ,.F.)
			oPrintPvt:cPathPDF := cDiretorio
		Else
			oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., ,   .T., ,    @oPrintPvt, ,   ,    , ,.T.)
			oPrintPvt:cPathPDF := cPastaTemp
		EndIf
		oPrintPvt:SetResolution(72)
		oPrintPvt:SetPortrait()
		oPrintPvt:SetPaperSize(DMPAPER_A4)
		oPrintPvt:SetMargin(0, 0, 0, 0)

        //Define o tamanho da r�gua
        Count To nTotal
        ProcRegua(nTotal)
        QRY_SRA->(DbGoTop())

        //Enquanto houver funcion�rios
        fImpCab()
        While ! QRY_SRA->(EoF())
            //Atualiza a r�gua
            nAtual++
            IncProc("Imprimindo funcion�rio " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")

            //Se atingiu o limite, quebra de pagina
            fQuebra()

            //Posiciona no funcion�rio
            DbSelectArea("SRA")
            SRA->(DbGoTo(QRY_SRA->SRAREC))

            //Se o funcion�rio tiver foto
            If ! Empty(SRA->RA_BITMAP)
                //Define o nome da foto
                cFotoFunc := cPastaTemp + "matricula_" + SRA->RA_MAT + ".bmp"

                //Se a foto j� existir na tempor�ria do S.O., exclui
                If File(cFotoFunc)
                    FErase(cFotoFunc)
                EndIf

                //Faz a extra��o da imagem do Protheus
                RepExtract(Alltrim(SRA->RA_BITMAP), cFotoFunc)

                //Se deu certo de extrair a imagem, ser� impressa
                If File(cFotoFunc)
                    //A imagem do funcion�rio, tem aproximadamente 235 x 258 (largura x altura),
                    //  iremos manter a propor��o (no caso dividimos por 4)
                    oPrintPvt:SayBitmap(nLinAtu, nColIni + 100, cFotoFunc, 58.75, 64.5)
                EndIf
            EndIf

            //Imprime agora os dados do funcion�rio
            oPrintPvt:SayAlign(nLinAtu, nColIni + 180, SRA->RA_NOME, oFontDetN,  nColFin - (nColIni + 180),  10, , PAD_LEFT,  )
            nLinAtu += 25
            oPrintPvt:SayAlign(nLinAtu, nColIni + 180, "Nasceu no dia " + dToC(SRA->RA_NASC), oFontDet,  nColFin - (nColIni + 180),  10, nCorAzul, PAD_LEFT,  )
            nLinAtu += 25
            oPrintPvt:SayAlign(nLinAtu, nColIni + 180, "Esta completando " + cValToChar(DateDiffYear(dDataRef, SRA->RA_NASC)) + " anos", oFontDet,  nColFin - (nColIni + 180),  10, nCorAzul, PAD_LEFT,  )
            nLinAtu += 25
            oPrintPvt:Line(nLinAtu-3, nColIni + 80, nLinAtu-3, nColFin - 80, nCorCinza)

            QRY_SRA->(DbSkip())

        EndDo

        fImpRod()

        //Se for via Job, ir� disparar um e-Mail
        // zEnvMail dispon�vel em https://terminaldeinformacao.com/2017/10/17/funcao-dispara-e-mail-varios-anexos-em-advpl/

        If lJob

            oPrintPvt:Print()

            aAnexos  := {}
            aAdd(aAnexos, cDiretorio + cArquivo)
            cPara	 := "rfranca@recordtvdf.com.br;plpontes@recordtvdf.com.br"
            cAssunto := "Testes do dia"
            cCorpo   := "Ol�.<br>"
            cCorpo   += "Segue em anexo o relat�rio com os aniversariantes do dia.<br>"
            cCorpo   += "e-Mail gerado automaticamente no dia " + dToC(Date()) + " �s " + Time() + "."
            //u_zEnvMail(cPara, cAssunto, cCorpo, aAnexos)
			u_zEnvMail(cPara, cAssunto, cCorpo, ,.T.)

        //Sen�o, se for manual, ir� abrir o PDF
        Else
            oPrintPvt:Preview()
        EndIf

    //Sen�o, se n�o for job, mostra mensagem
    Else
        If ! lJob
            MsgStop("N�o foi encontrado funcion�rio(s) aniversariante(s) na data de hoje!", "Aten��o")
        EndIf
    EndIf
    QRY_SRA->(DbCloseArea())

	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fImpCab                                                      |
 | Desc:  Funcao que imprime o cabecalho                               |
 *---------------------------------------------------------------------*/

Static Function fImpCab()

	Local cTexto   := ""
	Local nLinCab  := 015

	//Iniciando Pagina
	oPrintPvt:StartPage()

	//Cabecalho
	cTexto := "Aniversariantes - " + dToC(dDataRef)
	oPrintPvt:SayAlign(nLinCab, nColMeio-200, cTexto, oFontTit, 400, 20, , PAD_CENTER, )

	//Linha Separatoria
	nLinCab += 025
	oPrintPvt:Line(nLinCab,   nColIni, nLinCab,   nColFin)

	//Atualizando a linha inicial do relatorio
	nLinAtu := nLinCab + 5

Return

/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Funcao que imprime o rodape                                  |
 *---------------------------------------------------------------------*/

Static Function fImpRod()
	Local nLinRod:= nLinFin
	Local cTexto := ''

	//Linha Separatoria
	oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
	nLinRod += 3

	//Dados da Esquerda
	cTexto := dToC(dDataBase) + "     " + cHoraEx + "     " + FunName() + " (zRelAniv)     " + UsrRetName(RetCodUsr())
	oPrintPvt:SayAlign(nLinRod, nColIni, cTexto, oFontRod, 500, 10, , PAD_LEFT, )

	//Direita
	cTexto := "Pagina "+cValToChar(nPagAtu)
	oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 10, , PAD_RIGHT, )

	//Finalizando a pagina e somando mais um
	oPrintPvt:EndPage()
	nPagAtu++
Return

Static Function fQuebra()
	If nLinAtu + 75 >= nLinFin-10
		fImpRod()
		fImpCab()
	EndIf
Return


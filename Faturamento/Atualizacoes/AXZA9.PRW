#Include "rwmake.ch"
#Include "protheus.ch"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXZA9     �Autor  �Bruno Alves          � Data �  19/08/14  ���
�������������������������������������������������������������������������͹��
���Desc.     �IMporta��o de pedido de venda                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AXZA9

Private cCadastro := "Importa��o do Pedido de Venda"
Private nOpca := 0
Private aParam := {}

Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Incluir","U_ZA9Inclui",0,3},;
{"Alterar","U_ZA9Altera",0,4},;
{"Excluir","AxDeleta",0,5},;
{"Importar TV+","U_PEDTVMAIS",0,3},;
{"Relatorio","U_RelTvMais",0,3},;
{"Legenda","u_ZA9Legend",0,4}}
Private aCores := {{'ZA9_IMPORT == "S"' ,'BR_VERDE'},{'ZA9_IMPORT == "N"','BR_VERMELHO'}}
Private cString := "ZA9"
Private aParam := {}
Private  aButtons := {}
Private cCadastro := "Importa��o do Pedido de Venda" // t�tulo da tela
Private lOk1 := .T.
Private lImporta := .T.


//adiciona botoes na Enchoice
//aAdd( aButtons, { "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Bot�o Teste" } )

//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam,  {|| U_ZA9Before() } )  //antes da abertura
aAdd( aParam,  {|| U_ZA9TudoOK() } )  //ao clicar no botao ok
aAdd( aParam,  {|| U_ZA9Transaction() } )  //durante a transacao
aAdd( aParam,  {|| U_ZA9Fim() } )       //termino da transacao

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return

User Function ZA9Inclui()
Private nOpca := 3
aParam := {}
aButtons := {}
lOk1 := .T.


dbSelectArea("ZA9")
//AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
nOpca := AxInclui("ZA9",ZA9->(Recno()), 3,, "U_ZA9Before",, "U_ZA9TudoOk()", .F., "U_ZA9Transaction", aButtons, aParam,,,.T.,,,,,)

Return nOpca

User Function ZA9ALTERA

Private nOpca := 4
aParam := {}
aButtons := {}


dbSelectArea("ZA9")
nOpca := AxAltera("ZA9",ZA9->(Recno()), 4,,,,,"U_ZA9TudoOk()","U_ZA9TransactionZS","U_ZA9Before",aButtons,aParam,,.T.,,,,,)
Return nOpca


User function ZA9Before()
Return .T.

User function ZA9TudoOK()

nRecno := ZA9->(RECNO())

DBSelectArea("ZA9")
DBSetOrder(1)
If DBSeek(xFilial("ZA9") + M->ZA9_NUMRP)
	If nOpca == 3 // Se Inclusao
		Alert("� necess�rio alterar o numero do RP para evitar duplicidade na Gera��o dos Pedidos de Venda!!")
		Return(.F.)
	ElseIf nOpca == 4 // Se Altera��o
		If nRecno != ZA9->(RECNO())
			Alert("� necess�rio alterar o numero do RP para evitar duplicidade na Gera��o dos Pedidos de Venda!!")
			Return(.F.)
		EndIf
	EndiF
EndIf

DBSelectArea("ZA9")
DBSetOrder(2)
If DBSeek(xFilial("ZA9") + M->ZA9_NOTA)
	If nOpca == 3 // Se Inclusao
		Alert("� necess�rio alterar o numero da Nota Fiscal para evitar duplicidade na Gera��o dos Pedidos de Venda!!")
		Return(.F.)
	ElseIf nOpca == 4 // Se Altera��o
		If nRecno != ZA9->(RECNO())
			Alert("� necess�rio alterar o numero da Nota Fiscal para evitar duplicidade na Gera��o dos Pedidos de Venda!!")
			Return(.F.)
		eNDiF
	EndIf
EndIf


Return(.T.)

User function ZA9Transaction()
Return .T.

User function ZA9Fim()
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PEDTVMAIS �Autor  �Bruno Alves          � Data �  08/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Importa��o dos pedidos que buscados pelo sistema TV+      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PEDTVMAIS()
Local _cArqPed		:= ""
//Local _lGrava		:= .F.
Local 	_cComp		:= StrTran(DToC(dDataBase),"/")
Local 	_aCab		:= {}
Local 	_aItens		:= {}
Local 	_cVend		:= ""
Local 	_lNovo		:= .F.
Private cQuery 		:= ""

Private _cArqTxt 	:= "C:\Pedidos.log" //Arquivo onde ser�o gravadas as ocorr�ncias...
Private _cMsg 		:= ""
Private _nCont		:= 0

Private cPerg := "IMPRPN2   "

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	alert("OPERA��O CANCELADA")
	return
ENDIF

_dDtIni		:= MV_PAR01 //Data inicial
_dDtFim		:= MV_PAR02 //Data final
_cArqPed	:= Alltrim(MV_PAR03)+"VENDA.DBF"


If MsgYesNo("Tem certeza que deseja realizar a importa��o? ")
	
	dbSelectArea("SA1")
	dbSetOrder(3)
	
	dbSelectArea("SA3")
	dbSetOrder(2)
	
	dbSelectArea("SED")
	dbSetOrder(1)
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	
	dbSelectArea("SC5")
	dbSetOrder(6)
	
	//Verifico se existe o arquivo no caminho informado
	If File(@_cArqPed)
		//Efetua a c�pia da m�quina local para o servidor. Servir� para processamento do temporario e tambem como backup
		__CopyFile(@_cArqPed,"\system\tvm\tv+\VENDA"+_cComp+".DBF")
	Else
		MsgStop("N�o existe o arquivo " + _cArqPed + ". Verifique!","FRVPED")
		Return
	EndIf
	
	//Cria arquivo tempor�rio
	dbUseArea(.T.,__LocalDriver,"\system\tvm\tv+\VENDA"+_cComp+".DBF","PED",.T.)
	
	dbGoTop()
	
	ProcRegua(RecCount())
	
	While !PED->(EOF())
		
		lImporta := .T.                         
		cMotivo := ""
		
		IncProc("CPF/CNPJ: "+PED->Z1_CPFCGC+" RP: "+PED->Z1_NUMRP)
		
		//Importa��o conforme periodo inicial e final. Per�odo de veicula��o sistema TV+
		If PED->Z1_PREFINI < _dDtIni .or. PED->Z1_PREFFIM > _dDtFim
			PED->(DbSkip())
			Loop
		Endif
		
		
		//Verifico se j� existe o pedido para a RP, se houver, n�o importa.
		SC5->(dbSetOrder(6))
		If SC5->(dbSeek(xFilial("SC5")+PED->Z1_NUMRP))
			_nCont ++
			lImporta := .F.
			cMotivo := "01"//Pedido de Venda duplicado
		Endif
		
		
		If lImporta == .T.
			//Nao importa pedido com valor zerado
			If PED->Z1_PARC1 == 0
				_cMsg := "O pedido de venda para o CGC/CNPJ: "+PED->Z1_CPFCGC+" RP: "+PED->Z1_NUMRP+". Est� com a parcela igual a zero."
				_nCont ++
				lImporta := .F.
				cMotivo := "02"//Valor igual a zero
			EndIf
		eNDiF
		
		//Verifica se existe o cliente cadastrado
		If lImporta == .T.
			SA1->(dbSetOrder(3))
			If !SA1->(DbSeek(xFilial("SA1")+PED->Z1_CPFCGC,.F.))
				_cMsg := "O pedido de venda para o CGC/CNPJ: "+PED->Z1_CPFCGC+" RP: "+PED->Z1_NUMRP+". Sem cadastro de cliente."
				_nCont ++
				lImporta := .F.
				cMotivo := "04"//Cliente n�o localizado
			Endif
		eNDiF
		
		//Nao importa pedido com idcli vazio
		If lImporta == .T.
			If Empty(PED->Z1_IDCLI)
				_cMsg := "O pedido de venda para o CGC/CNPJ: "+PED->Z1_CPFCGC+" RP: "+PED->Z1_NUMRP+". N�o foi importado (sem c�d. externo)."
				_nCont ++
				lImporta := .F.
				cMotivo := "03"//Sem codigo externo
			Endif
		eNDiF
		
		//Cadastro de vendedores
		SA2->(dbSetOrder(2))
		If SA3->(dbSeek(xFilial("SA3")+PED->Z1_CNPJAGE,.F.))
			_cVend 	:= SA3->A3_COD
		Else
			_cVend	:= ""
		EndIf
		
		//Ser� importado para o pedido de venda?
		If lImporta == .T.
			cImporta := "S"
		Else
			cImporta := "N"
		EndIf
		
		
		//Array com o cabe�alho do pedido
		aAdd(_aCab,{SA1->A1_COD,;  		//01.Codigo do cliente
		SA1->A1_LOJA,;				//02.Loja do cliente
		_cVend,;     				//03.Vendedor
		PED->Z1_NUMRP,;   		//04.RP TV+
		PED->Z1_PREFINI,;			//05.Periodo de veicula��o De
		PED->Z1_PREFFIM,;   		//06.Periodo de veicula��o ate
		PED->Z1_MENNOTA,;			//07.Mensagem para nota fiscal
		PED->Z1_NUMPED,;//08.N�mero da NF do TV+ que ser� o num do ped. no Protheus
		PED->Z1_PRCVEN,;  	// 09 Preco Unitario
		cImporta,; // 10 Ser� Importado
		cMotivo,; // 11 Motivo caso n�o seja importado
		PED->Z1_IDCLI}) // 12 Id do Cliente
		
		PED->(dbSkip())
		
	EndDo
	
	PED->(DbCloseArea())
	
	//���������������������Ŀ
	//�Grava Pedido de Venda�
	//�����������������������
	
	cQuery := "DELETE FROM	" + RetSqlName("ZA9") + ""
	
	If TcSqlExec(cQuery) < 0
		MsgStop("Ocorreu um erro na exclus�o da tabela ZA9!")
		Final()
		REturn
	EndIf
	
	_aCab 	:= aSort(_aCab,,,     { |x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4] })
	
	DBSelectArea("ZA9")
	dbsetOrder(1)
	
	
	For I := 1 To Len(_aCab)
		
		IncProc( "Importando Pedido de Venda...." + StrZero(I,5) + " de " + StrZero(Len(_aCab),5) )
		
		RecLock("ZA9",.T.)
		ZA9->ZA9_FILIAL := xFilial("ZA9")
		ZA9->ZA9_CLIENT := _aCab[I][1]
		ZA9->ZA9_LOJA   := _aCab[I][2]
		ZA9->ZA9_NOME   := Posicione("SA1",1,xFilial("SA1")+_aCab[I][1]+_aCab[I][2],"A1_NOME")
		ZA9->ZA9_VENDED := _aCab[I][3]
		ZA9->ZA9_NMVEND := Iif(!empty(_aCab[I][3]),Posicione("SA3",1,xFilial("SA3") + _aCab[I][3],"A3_NOME"),"")
		ZA9->ZA9_NUMRP  := _aCab[I][4]
		ZA9->ZA9_PREFIN := _aCab[I][5]
		ZA9->ZA9_PREFFI := _aCab[I][6]
		ZA9->ZA9_NOTA   := _aCab[I][7]
		ZA9->ZA9_PEDIDO := _aCab[I][8]
		ZA9->ZA9_VALOR  := _aCab[I][9]
		ZA9->ZA9_IMPORT := _aCab[I][10]
		ZA9->ZA9_MOTIVO := _aCab[I][11]
		ZA9->ZA9_DESCMO := iif(Empty(_aCab[I][11]),"",Posicione("SX5",1,xFilial("SX5") + "ZX" + _aCab[I][11],"X5_DESCRI"))
		ZA9->ZA9_IDCLI := _aCab[I][12]
		ZA9->(MsUnLock())
		
	Next
	
	
	If _nCont > 0 //Verifica se houveram inconsist�ncias
		Alert("Houveram inconsist�ncias na importa��o. Verifique as inconsistencias!")
	EndIf
	
	
	MsgInfo("Importa��o realizada com sucesso!!")
	
EndIf


Return

User Function ZA9Legend

Local aLegenda := {{"ENABLE","Ser� Importado"},{"DISABLE","N�o Ser� Importado"}}

BrwLegenda("Cadastro de Importa��o TV MAIS","Legenda",aLegenda)

Return(.t.)


Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Veiculacao De       ?","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Veiculacao Ate      ?","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Diret�rio Arq. Imp. ?","","","mv_ch3","C",60,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

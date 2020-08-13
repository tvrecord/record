/*/
��������������������������������������������������������������Ŀ
�"PROTHEUS.CH" eh Utilizado para substituir a constante CRLF pe�
�lo seu valor real e os comandos para criacao de DIALOG em suas�
�respectivas chamadas de funcao								   �
����������������������������������������������������������������/*/
#INCLUDE "PROTHEUS.CH"

/*/
��������������������������������������������������������������Ŀ
�"TBICONN.CH" Traduzir os comandos PREPARE ENVIRONMENT e  RESET�
�ENVIRONMENT nas respectivas chamadas de funcao 			   �
����������������������������������������������������������������/*/
#INCLUDE "TBICONN.CH"

/*/
��������������������������������������������������������������Ŀ
�Define as opcoes para a cGetFile							   �
� 															   �
�Obs.: As constantes do tipo GETF_???... estao definidas no  ar�
�      quivo de cabecalho "PRCONST.CH"						   �
����������������������������������������������������������������/*/
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �U_ImgSra      �Autor�Marinaldo de Jesus   � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Importar as Fotos dos Funcionarios                          �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
User Function ImgSra( cEmp , cFil )

Local aEmpresas
Local aRecnos

Local bWindowInit
Local bDialogInit

Local cTitle
Local cEmpresa

Local lConfirm

Local nEmpresa
Local nRecEmpresa

Local oDlg
Local oFont
Local oEmpresas

/*/
��������������������������������������������������������������Ŀ
� Verifica se a Variavel Publica oMainWnd esta declarada e se o�
� seu tipo eh objeto 										   �
����������������������������������������������������������������/*/
Local lExecInRmt	:= ( Type( "oMainWnd" ) == "O" )

/*/
��������������������������������������������������������������Ŀ
�Coloca o Ponteiro do Cursos do Mouse em estado de Espera	   �
����������������������������������������������������������������/*/
CursorWait()

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	� Monta o Titulo para o Dialogo								   �
	����������������������������������������������������������������/*/
	cTitle := "Importa��o das Fotos dos Funcion�rios"

	/*/
	��������������������������������������������������������������Ŀ
	� Monta Bloco para o Init da Window							   �
	����������������������������������������������������������������/*/
	bWindowInit	:= { ||;
	  					Proc2BarGauge(	{ || GetSraImg( lExecInRmt ) }	,;	//Variavel do Tipo Bloco de Codigo com a Acao ser Executada
										cTitle							,;	//Variavel do Tipo Texto ( Caractere/String ) com o Titulo do Dialogo
										NIL								,;	//Variavel do Tipo Texto ( Caractere/String ) com a Mensagem para a 1a. BarGauge
										NIL								,;	//Variavel do Tipo Texto ( Caractere/String ) com a Mensagem para a 2a. BarGauge
										.F.								,;	//Variavel do Tipo Logica que habilitara o botao para "Abortar" o processo
										.T.								,;	//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo na 1a. BarGauge
										.F.								,;	//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo 2a. BarGauge
										.F.				 				 ;	//Variavel do Tipo Logica que definira se a 2a. BarGauge devera ser mostrada
  									 ),;
						MsgInfo( OemToAnsi( "Importa��o Finalizada" ) , cTitle );
					}

	/*/
	��������������������������������������������������������������Ŀ
	� Se a Execucao nao for a partir do Menu do SIGA 			   �
	����������������������������������������������������������������/*/
	IF !( lExecInRmt )

		/*/
		��������������������������������������������������������������Ŀ
		�Declara a Variavel oMainWnd que vai ser utilizada para a   mon�
		�tagem da Caixa de Dialogo ( Janela de Abertura ) do programa  �
		����������������������������������������������������������������/*/
		Private oMainWnd

		IF (;
				( cEmp == NIL );
				.or.;
				( cFil == NIL );
			)

			/*/
			��������������������������������������������������������������Ŀ
			� Verifica se existe uma area reservada para o Alias SM0	   �
			����������������������������������������������������������������/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				��������������������������������������������������������������Ŀ
				�Declara e inicializa a variavel cArqEmp que sera utilizada  in�
				�ternamente pela funcao OpenSM0()							   �
				����������������������������������������������������������������/*/
				Private cArqEmp := "sigamat.emp"
				/*/
				��������������������������������������������������������������Ŀ
				�Abre o Cadastro de Empresas								   �
				����������������������������������������������������������������/*/
				OpenSM0()
			EndIF

			/*/
			��������������������������������������������������������������Ŀ
			� Verifica se existe uma area reservada para o Alias SM0	   �
			����������������������������������������������������������������/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				���������������������������������������������������������������Ŀ
				�Utilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usua�
				�rio															�
				�����������������������������������������������������������������/*/
				MsgInfo( "N�o foi poss�vel abrir o Cadastro de Empresas" )
				/*/
				���������������������������������������������������������������Ŀ
				�Desviamos o controle do programa para a primeira instrucao apos�
				�o End Sequence													�
				�����������������������������������������������������������������/*/
				Break
			EndIF

			/*/
			���������������������������������������������������������������Ŀ
			�Inicializamos as Variavels aEmpresas e a Recnos como um   Array�
			�"vazio" que serao utilizados durante o "Laco" While para armaze�
			�nar informacoes da Tabela referenciada pelo Alias SM0.         �
			�����������������������������������������������������������������/*/
			aEmpresas	:= {}
			aRecnos		:= {}

			/*/
			���������������������������������������������������������������Ŀ
			�Utiliza a Funcao dbGoTop() para posicionar no Primeiro Registro�
			�da Tabela referenciada pelo Alias SM0.							�
			�����������������������������������������������������������������/*/
			SM0->( dbGoTop() )

			/*/
			���������������������������������������������������������������Ŀ
			�Executa o Laco While enquanto a funcao Eof() retornar .F. carac�
			�terizando que ainda nao chegou ao final de arquivo.			�
			�����������������������������������������������������������������/*/
			While SM0->( !Eof() )
				/*/
				��������������������������������������������������������������Ŀ
				�Carrega apenas os n Primeiros Registros nao repetidos		   �
				����������������������������������������������������������������/*/
				IF SM0->( UniqueKey( "M0_CODIGO" , "SM0" ) )
					/*/
					���������������������������������������������������������������Ŀ
					�Carrega informacoes da Empresa na Variavel cEmpresa.			�
					�Obs.: A funcao AllTrim() retira todos os espacos a Direita e  a�
					�Esquerda de uma Variavel do Tipo Caractere.					�
					�����������������������������������������������������������������/*/
					cEmpresa := SM0->( M0_CODIGO + " - " + AllTrim( M0_NOME ) + " / " + AllTrim( M0_FILIAL ) )
					/*/
					���������������������������������������������������������������Ŀ
					�Adiciona o Conteudo da variavel cEmpresa ao Array aEmpresas    �
					�����������������������������������������������������������������/*/
					aAdd( aEmpresas , cEmpresa )
					/*/
					���������������������������������������������������������������Ŀ
					�Adiciona o Recno Atual da Tabela referenciada pelo Alias SM0 ao�
					�array aRecnos.													�
					�����������������������������������������������������������������/*/
					SM0->( aAdd( aRecnos , Recno() ) )
				EndIF
				/*/
				���������������������������������������������������������������Ŀ
				�A funcao dbSkip() e utilizada para Mover o Ponteiro da Tabela. �
				�Por padrao ela sempre ira mover para o proximo registro. Porem,�
				�temos a opcao de mover n Registros Tanto "para baixo"    quanto�
				�"para cima". Ex: dbSkip( 1 ) salta para o registro  imediatamen�
				�te posterior e eh o mesmo que dbSkip(), dbSkip( 2 ) salta  dois�
				�registros; dbSkip( 10 ) salta 10 registros; dbSkip( -1 )  salta�
				�para o registro imediatamente anterior; dbSkip( -2 ) salta dois�
				�registros "acima"; dbSkip( -10 ) para 10 registros acima...    �
				�����������������������������������������������������������������/*/
				SM0->( dbSkip() )
			End While

			/*/
			���������������������������������������������������������������Ŀ
			�Utilizamos a funcao Empty() para verificar se o Array aEmpresas�
			�esta vazio. Se estiver vazio eh porque nao exitem registros  na�
			�Tabela referenciada pelo Alias SM0								�
			�����������������������������������������������������������������/*/
			IF Empty( aRecnos )
				/*/
				���������������������������������������������������������������Ŀ
				�Utilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usua�
				�rio															�
				�����������������������������������������������������������������/*/
				MsgInfo( "N�o Existem Empresas Cadastradas no SIGAMAT.EMP" )
				/*/
				���������������������������������������������������������������Ŀ
				�Desviamos o controle do programa para a primeira instrucao apos�
				�o End Sequence													�
				�����������������������������������������������������������������/*/
				Break
			EndIF

			/*/
			��������������������������������������������������������������Ŀ
			�Atribuimos aa variavel lConfirm o valor .F. ( Falso )		   �
			����������������������������������������������������������������/*/
			lConfirm	:= .F.

			/*/
			��������������������������������������������������������������Ŀ
			�Declara a Variavel __cInterNet								   �
			����������������������������������������������������������������/*/
			__cInterNet		:= NIL

			/*/
			��������������������������������������������������������������Ŀ
			�Define o tipo de fonte a ser utilizado no Objeto Dialog	   �
			����������������������������������������������������������������/*/
			DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
			/*/
			��������������������������������������������������������������Ŀ
			�Disponibiliza Dialog para a Escolha da Empresa				   �
			����������������������������������������������������������������/*/
			DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Selecione a Empresa" ) From 0,0 TO 100,430 OF GetWndDefault() STYLE DS_MODALFRAME STATUS  PIXEL
				/*/
				���������������������������������������������������������������Ŀ
				�Define o Objeto ComboBox                                       �
				�����������������������������������������������������������������/*/
				@ 020,010 COMBOBOX oEmpresas VAR cEmpresa ITEMS aEmpresas SIZE 200,020 OF oDlg PIXEL FONT oFont
				/*/
				��������������������������������������������������������������Ŀ
				�Redefine o Ponteiro oEmpresas:nAt							   �
				����������������������������������������������������������������/*/
				oEmpresas:nAt		:= 1
				/*/
				��������������������������������������������������������������Ŀ
				�Define a Acao para o Bloco bChange do objeto do Tipo ComboBox �
				����������������������������������������������������������������/*/
				oEmpresas:bChange	:= { || ( nEmpresa := oEmpresas:nAt ) }
				/*/
				��������������������������������������������������������������Ŀ
				�Inicializa a Variavel nEmpresa							       �
				����������������������������������������������������������������/*/
				Eval( oEmpresas:bChange )
				/*/
				��������������������������������������������������������������Ŀ
				�Nao permite sair ao se pressionar a tecla ESC.				   �
				����������������������������������������������������������������/*/
				oDlg:lEscClose := .F.
				/*/
				��������������������������������������������������������������Ŀ
				�Define o Bloco para a Inicializacao do Dialog.				   �
				����������������������������������������������������������������/*/
				bDialogInit := { || EnchoiceBar( oDlg , { || lConfirm := .T. , oDlg:End() } , { || lConfirm := .F. , oDlg:End() } ) }
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDialogInit )

			/*/
			���������������������������������������������������������������Ŀ
			�Se nao Clicou no Botao OK da EnchoiceBar abandona o processo   �
			�����������������������������������������������������������������/*/
			IF !( lConfirm )
				/*/
				���������������������������������������������������������������Ŀ
				�Desviamos o controle do programa para a primeira instrucao apos�
				�o End Sequence													�
				�����������������������������������������������������������������/*/
				Break
			EndIF

			/*/
			���������������������������������������������������������������Ŀ
			�Atribuimos aa variavel nEmpresa o Conteudo ( Recno ) armazenado�
			�no Array aRecnos para o Elemento nRecEmpresa.					�
			�����������������������������������������������������������������/*/
			nRecEmpresa := aRecnos[ nEmpresa ]
			
			/*/
			���������������������������������������������������������������Ŀ
			�Utilizamos a funcao MsGoto() para efetuarmos Garantirmos que  o�
			�ponteiro da Tabela referenciada pelo Alias SM0 esteja posiciona�
			�do no Registro armazenado na variavel nEmpresa. MsGoto() verifi�
			�ca se o registro ja esta posicionado e, se nao estiver, executa�
			�a Funcao dbGoto( n ) passando como parametro o conteudo de  nEm�
			�presa como parametro. Eh a funcao dbGoto() quem    efetivamente�
			�ira efetuar o posicionamento do Ponteiro da Tabela no registro.�
			�����������������������������������������������������������������/*/
			SM0->( MsGoto( nRecEmpresa ) )

			/*/
			���������������������������������������������������������������Ŀ
			�Atribuimos aa variavel cEmp o conteudo do campo M0_CODIGO da Ta�
			�bela referenciada pelo Alias SM0								�
			�����������������������������������������������������������������/*/
			cEmp	:= SM0->M0_CODIGO
			/*/
			���������������������������������������������������������������Ŀ
			�Atribuimos aa variavel cFil o conteudo do campo M0_CODIGO da Ta�
			�bela referenciada pelo Alias SM0								�
			�����������������������������������������������������������������/*/
			cFil	:= SM0->M0_CODFIL

			/*/
			���������������������������������������������������������������Ŀ
			�Concatenamos, ao conteudo ja existente na variavel cTitle,   as�
			�informacoes da Empresa.										�
			�����������������������������������������������������������������/*/
			cTitle	+= " Empresa: "
			cTitle	+= aEmpresas[ nEmpresa ]

		EndIF

		/*/
		��������������������������������������������������������������Ŀ
		�Coloca o Ponteiro do Cursos do Mouse em estado de Espera	   �
		����������������������������������������������������������������/*/
		CursorWait()

		/*/
		��������������������������������������������������������������Ŀ
		�Preparando o ambiente para trabalhar com as Tabelas do SIGA.  �
		�Abrindo a empresa Definida na Variavel cEmp e para a Filial de�
		�finida na variavel cFil									   �
		����������������������������������������������������������������/*/
		PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) MODULO "CFG"

			/*/
			��������������������������������������������������������������Ŀ
			�Inicializando as Variaveis Publicas						   �
			����������������������������������������������������������������/*/
			InitPublic()

			/*/
			��������������������������������������������������������������Ŀ
			�Carregando as Configuracoes padroes ( Variaveis de Ambiente ) �
			����������������������������������������������������������������/*/
			SetsDefault()

			/*/
			��������������������������������������������������������������Ŀ
			�Redefine nModulo de forma a Garantir que o Modulo seja SIGAGE �
			����������������������������������������������������������������/*/
			SetModulo( "SIGACFG" , "CFG" )

			/*/
			��������������������������������������������������������������Ŀ
			�Refefine __cInterNet para que nao ocorra erro na SetPrint()   �
			����������������������������������������������������������������/*/
			__cInterNet	:= NIL

			/*/
			��������������������������������������������������������������Ŀ
			�Refefine lMsHelpAuto para que a MsgNoYes() Seja Executada	   �
			����������������������������������������������������������������/*/
			lMsHelpAuto		:= .T.

			/*/
			��������������������������������������������������������������Ŀ
			�Refefine lMsFinaAuto para que a Final() seja executada    como�
			�se estivesse no Remote										   �
			����������������������������������������������������������������/*/
			lMsFinalAuto	:= .T.

			/*/
			��������������������������������������������������������������Ŀ
			�Utiliza o Comando DEFINE WINDOW para criar uma nova janela. Es�
			�te comando sera convertido em Chamada de funcao pelo   pre-pro�
			�cessador que utilizara o "PROTHEUS.CH" para identificar em que�
			�ou em qual arquivo .CH ( Clipper Header ) esta definida a  tra�
			�ducao para o comando.										   �
			�															   �
			�DEFINE WINDOW cria a janela								   �
			�FROM 001,001 define as coordenadas da Janela ( Linha Inicial ,�
			�Coluna Inicial)											   �
			�TO 400,500 define as coordenadas da Janela ( Linha Final ,  Co�
			�luna Final )												   �
			�TITLE OemToAnsi( cTitle ) Define o titulo para a Janela       �
			�OemToAnsi() converte o conteudo do texto da string cTitle   do�
			�Padrao Oem para o Ansi.									   �
			����������������������������������������������������������������/*/
			DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( cTitle )
			/*/
			��������������������������������������������������������������Ŀ
			�ACTIVATE WINDOW ativa a Janela ( Caixa de Dialogo ou Dialog ) �
			�MAXIMIZED define que a forma sera Maximixada				   �
			�ON INIT define o programa que sera executado na  Inicializacao�
			�da Janela 													   �
			����������������������������������������������������������������/*/
		  	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

		RESET ENVIRONMENT

	Else

		/*/
		��������������������������������������������������������������Ŀ
		� Processa a Importacao										   �
		����������������������������������������������������������������/*/
  		Eval( bWindowInit )

	EndIF

End Sequence

Return( NIL )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �GetSraImg	  �Autor�Marinaldo de Jesus   � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Importar as Fotos dos Funcionarios                          �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function GetSraImg( lShowLog )

Local aLogTitle		:= {}
Local aLogFile		:= {}

Local a_fOpcoesGet

Local b_fOpcoes
Local bMakeLog

/*/
��������������������������������������������������������������Ŀ
�Disponibiliza Dialog para a Escolha do Diretorio              �
����������������������������������������������������������������/*/
Local cPath 		:= cGetFile( "Fotos dos Funcionarios |????????.JPG| Fotos dos Funcionarios |????????.JPEG| Fotos dos Funcionarios |????????.BMP|" , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )
Local cTime			:= Time()

Local cMaskJPG		:= "????????.JPG"
Local cMaskJPEG		:= "????????.JPEG"
Local cMaskBMP		:= "????????.BMP"

Local aFiles
Local aFilesJPG
Local aFilesJPEG
Local aFilesBMP

Local cFil
Local cMat
Local cFile
Local cTitulo
Local cPathFile
Local cMsgIncProc
Local c_fOpcoesGet
Local cPathLogFile

Local lf_Opcoes

Local nFile
Local nFiles
Local nFilesJPG
Local nFilesJPEG
Local nFilesBMP
Local nSraOrder

Local u_fOpcoesRet

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	�Verifica se o Diretorio Foi Selecionado					   �
	����������������������������������������������������������������/*/
	IF Empty( cPath )
		MsgInfo( OemToAnsi( "N�o foi poss�vel encontrar o diret�rio de imagens" ) )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	�Obtem os arquivos a serem importados .JPG					   �
	����������������������������������������������������������������/*/
	cPathFile	:= ( cPath + cMaskJPG )
	aFilesJPG	:= Array( aDir( cPathFile ) )
	nFilesJPG	:= aDir( cPathFile , aFilesJPG )

	/*/
	��������������������������������������������������������������Ŀ
	�Obtem os arquivos a serem importados .JPEG					   �
	����������������������������������������������������������������/*/
	cPathFile	:= ( cPath + cMaskJPEG )
	aFilesJPEG	:= Array( aDir( cPathFile ) )
	nFilesJPEG	:= aDir( cPathFile , aFilesJPEG )

	/*/
	��������������������������������������������������������������Ŀ
	�Obtem os arquivos a serem importados .BMP					   �
	����������������������������������������������������������������/*/
	cPathFile	:= ( cPath + cMaskBMP )
	aFilesBMP	:= Array( aDir( cPathFile ) )
	nFilesBMP	:= aDir( cPathFile , aFilesBMP )

	nFiles		:= ( nFilesJPG + nFilesJPEG + nFilesBMP )

	/*/
	��������������������������������������������������������������Ŀ
	�Se nao existirem arquivos a serem importados abandona         �
	����������������������������������������������������������������/*/
	IF ( nFiles == 0 )
		MsgInfo( "N�o Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	�Unifica os arquivos                                           �
	����������������������������������������������������������������/*/
	aFiles := {}
	aEval( aFilesJPG  , { |cFile| aAdd( aFiles , cFile ) } )
	aEval( aFilesJPEG , { |cFile| aAdd( aFiles , cFile ) } )
	aEval( aFilesBMP  , { |cFile| aAdd( aFiles , cFile ) } )
	aFilesJPG	:= NIL
	aFilesJPEG	:= NIL
	aFilesBMP	:= NIL

	IF ( MsgNoYes( "Deseja Selecionar as Imagens a Serem Importadas?" ) )

		b_fOpcoes := { ||;
							a_fOpcoesGet	:= {},;
							u_fOpcoesRet	:= "",;
							aEval( aFiles , { |cFile,cAlias| cAlias := SubStr( cFile , 1 , 8 ) , c_fOpcoesGet := ( cAlias + " - " + cFile ) , aAdd( a_fOpcoesGet , c_fOpcoesGet ) , u_fOpcoesRet += cAlias } ),;
							c_fOpcoesGet	:= u_fOpcoesRet,;
							nFiles			:= Len( aFiles ),;
							lf_Opcoes		:= f_Opcoes(	@u_fOpcoesRet				,;	//Variavel de Retorno
															"Imagens"					,;	//Titulo da Coluna com as opcoes
															a_fOpcoesGet				,;	//Opcoes de Escolha (Array de Opcoes)
															c_fOpcoesGet				,;	//String de Opcoes para Retorno
															NIL							,;	//Nao Utilizado
															NIL							,;	//Nao Utilizado
															.F.							,;	//Se a Selecao sera de apenas 1 Elemento por vez
															8							,;	//Tamanho da Chave
															nFiles						,;	//No maximo de elementos na variavel de retorno
															.T.							,;	//Inclui Botoes para Selecao de Multiplos Itens
															.F.							,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
															NIL							,;	//Qual o Campo para a Montagem do aOpcoes
															.F.							,;	//Nao Permite a Ordenacao
															.F.							,;	//Nao Permite a Pesquisa
															.T.			    			,;	//Forca o Retorno Como Array
															NIL				 			 ;	//Consulta F3
					  									);
					 }

		MsAguarde( b_fOpcoes )

		IF !( lf_Opcoes )
			MsgInfo( OemToAnsi( "Importa��o Cancelada Pelo Usu�rio." ) )
			Break
		EndIF

		a_fOpcoesGet	:= {}

		For nFile := 1 To nFiles
            IF ( aScan( u_fOpcoesRet , { |cElem| ( cElem == SubStr( aFiles[ nFile ] , 1 , 8 ) ) } ) > 0 )
            	aAdd( a_fOpcoesGet , aFiles[ nFile ] )
            EndIF
		Next nFile

		aFiles 			:= a_fOpcoesGet
		a_fOpcoesGet	:= NIL

	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	�Se nao existirem arquivos a serem importados abandona         �
	����������������������������������������������������������������/*/
	nFiles	:= Len( aFiles )
	IF ( nFiles == 0 )
		MsgInfo( "N�o Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Seta o Numero de Elementos da 1a BarGauge					   �
	����������������������������������������������������������������/*/
	BarGauge1Set( nFiles )

	/*/
	��������������������������������������������������������������Ŀ
	� Seta o Repositorio de Imagens que sera utilizado			   �
	����������������������������������������������������������������/*/
	SetRepName( "SIGAADV" )

		/*/
		��������������������������������������������������������������Ŀ
		� Libera imagens Pendentes									   �
		����������������������������������������������������������������/*/
		FechaReposit()	//For�o o Fechamento o Repositorio de Imangens
			PackRepository()
		FechaReposit()	//For�o o Fechamento o Repositorio de Imangens

	/*/
	��������������������������������������������������������������Ŀ
	� Seta o Repositorio de Imagens que sera utilizado			   �
	����������������������������������������������������������������/*/
	SetRepName( "SIGAADV" )

	/*/
	��������������������������������������������������������������Ŀ
	� Retorna a Ordem do Indice a ser utilizado conforme expressao �
	����������������������������������������������������������������/*/
	nSraOrder := RetOrder( "SRA" , "RA_FILIAL+RA_MAT" )

	/*/
	��������������������������������������������������������������Ŀ
	� Seta a Ordem para o SRA									   �
	����������������������������������������������������������������/*/
	SRA->( dbSetOrder( nSraOrder ) )

	/*/
	��������������������������������������������������������������Ŀ
	� Efetua um Laco para processar Todos os arquivos a serem impor�
	� tados														   �
	����������������������������������������������������������������/*/
	For nFile := 1 To nFiles
		/*/
		��������������������������������������������������������������Ŀ
		� Obtem o Nome do arquivo a ser Importado					   �
		����������������������������������������������������������������/*/
		cFile		:= aFiles[ nFile ]
		/*/
		��������������������������������������������������������������Ŀ
		� Concatena o "Path" do arquivo com o proprio arquivo		   �
		����������������������������������������������������������������/*/
		cPathFile	:= ( cPath + cFile )
		/*/
		��������������������������������������������������������������Ŀ
		�Monsta o Texto que sera apresentado no Dialog de processamento�
		����������������������������������������������������������������/*/
		cMsgIncProc	:= "Importando Imagem: "
		cMsgIncProc	+= cPathFile
		/*/
		��������������������������������������������������������������Ŀ
		�Incrementa a Regua de Processamento						   �
		����������������������������������������������������������������/*/
		IncPrcG1Time( cMsgIncProc	,;	//01 -> Inicio da Mensagem
					  nFiles		,;	//02 -> Numero de Registros a Serem Processados
					  cTime			,;	//03 -> Tempo Inicial
					  .T.			,;	//04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
					  1				,;	//05 -> Contador de Processos
					  1		 		,;	//06 -> Percentual para Incremento
					  NIL			,;	//07 -> Se Deve Incrementar a Barra ou Apenas Atualizar a Mensagem
					  .T.			 ;	//08 -> Se Forca a Atualizacao das Mensagens
					)
		/*/
		��������������������������������������������������������������Ŀ
		� Efetiva a Importacao das Imagens							   �
		����������������������������������������������������������������/*/
		IF !( DlgPutImg( cPathFile , cPath , cFile ) )
			/*/
			��������������������������������������������������������������Ŀ
			� Se nao conseguiu importar a imagem adiciona ao Log		   �
			����������������������������������������������������������������/*/
			aAdd( aLogFile , ( "Nao foi Possivel Adicionar a Imagem: " + cPathFile ) )
		EndIF
	Next nFile

	/*/
	��������������������������������������������������������������Ŀ
	� Libera imagens Pendentes									   �
	����������������������������������������������������������������/*/
	FechaReposit()	//For�o o Fechamento o Repositorio de Imangens
		PackRepository()
	FechaReposit()	//For�o o Fechamento o Repositorio de Imangens

End Sequence

/*/
��������������������������������������������������������������Ŀ
� Se ocorreu alguma inconsistencia na importacao das imagens   �
����������������������������������������������������������������/*/
IF !Empty( aLogFile )

	/*/
	��������������������������������������������������������������Ŀ
	� Define o Titulo para o Relatorio de LOG					   �
	����������������������������������������������������������������/*/
	cTitulo := "Inconsistencias na Importacao de Fotos"
	aAdd( aLogTitle , cTitulo )
	/*/
	��������������������������������������������������������������Ŀ
	� Monta o Bloco para a Geracao do Log           			   �
	����������������������������������������������������������������/*/
	bMakeLog := { || cPathLogFile := fMakeLog(	{ aLogFile }	,;	//Array que contem os Detalhes de Ocorrencia de Log
												aLogTitle		,;	//Array que contem os Titulos de Acordo com as Ocorrencias
												NIL				,;	//Pergunte a Ser Listado
												lShowLog		,;	//Se Havera "Display" de Tela
												NIL				,;	//Nome Alternativo do Log
												cTitulo			,;	//Titulo Alternativo do Log
												"M"				,;	//Tamanho Vertical do Relatorio de Log ("P","M","G")
												"L"				,;	//Orientacao do Relatorio ("P" Retrato ou "L" Paisagem )
												NIL				,;	//Array com a Mesma Estrutura do aReturn
												.T.				 ;	//Se deve Manter ( Adicionar ) no Novo Log o Log Anterior
			  								);
				}
	/*/
	��������������������������������������������������������������Ŀ
	� Disponibiliza o Log de Inconsistencias			   		   �
	����������������������������������������������������������������/*/
	MsAguarde( bMakeLog , "Gerando o Log" )

	IF !( lShowLog )
		MsgInfo( OemToAnsi( "O Arquivo de Log foi gerado em: " + cPathLogFile ) )
	EndIF

EndIF

Return( NIL )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �DlgPutImg     �Autor�Marinaldo de Jesus   � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Importar as Fotos dos Funcionarios                          �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function DlgPutImg( cPathFile , cPath , cFile )

Local bDialogInit

Local oDlg
Local oRepository

Local lPutOk := .T.

/*/
��������������������������������������������������������������Ŀ
� Monta Dialogo "Escondido" para possibilitar a importacao  das�
� imagens													   �
����������������������������������������������������������������/*/
DEFINE MSDIALOG oDlg FROM 0,0 TO 0,0 PIXEL

	/*/
	��������������������������������������������������������������Ŀ
	� Cria um Objeto do Tipo Repositorio						   �
	����������������������������������������������������������������/*/
	@ 000,000 REPOSITORY oRepository SIZE 0,0 OF oDlg

	/*/
	��������������������������������������������������������������Ŀ
	� Efetiva a importacao da imagem     						   �
	����������������������������������������������������������������/*/
	lPutOk		:= PutImg( oRepository , cPathFile , cPath , cFile )
	bDialogInit	:= { || oRepository:lStretch := .T. , oDlg:End() , oRepository := NIL , oDlg:= NIL }

/*/
��������������������������������������������������������������Ŀ
� Ativa e Fecha o Dialogo									   �
����������������������������������������������������������������/*/
ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit )

Return( lPutOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �PutImg        �Autor�Marinaldo de Jesus   � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Gravar a Imagem no Repositorio de Imagens e Vincula-la    ao�
�          �funcionario													�
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function PutImg( oRepository , cPathFile , cPath , cFile )

Local cSraBitMap

Local lPutOk	:= .F.
Local lPut		:= .F.
Local lLock		:= .F.
Local lAllOk	:= .F.
Local lFound	:= .F.

Local nRecno

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	� Verifica se o arquio de Imagem existe						   �
	����������������������������������������������������������������/*/
	IF !( lPutOk := File( cPathFile ) )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Utiliza a funcao RetFileName() para retinar o Nome do arquivo�
	� sem o "path" e sem o Extenso								   �
	����������������������������������������������������������������/*/
   	cSraBitMap := RetFileName( cPathFile )

	/*/
	��������������������������������������������������������������Ŀ
	� Procura o Funcionario										   �
	����������������������������������������������������������������/*/
	lFound := SRA->( dbSeek( cSraBitMap , .F. ) )
	/*/
	��������������������������������������������������������������Ŀ
	� Se nao Encontrou o Funcionario, abandona					   �
	����������������������������������������������������������������/*/
	IF !( lFound )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Armazena o Recno   										   �
	����������������������������������������������������������������/*/
	nRecno := SRA->( Recno() )

	/*/
	��������������������������������������������������������������Ŀ
	� Utiliza o "Method" :IsertBmp para inserir a imagem no  Reposi�
	� torio de Imagens do Protheus								   �
	����������������������������������������������������������������/*/
	lPutOk	:= ( cSraBitMap == oRepository:InsertBmp( cPathFile , NIL , @lPut ) )

	/*/
	��������������������������������������������������������������Ŀ
	� Se adicionou a Imagem no Repositorio, vincula a imagem ao Fun�
	� cionario													   �
	����������������������������������������������������������������/*/
	IF (;
			( lPutOk );	//Obtido a partir do Teste de Retorno do Metodo :InsertBmp()
			.and.;
			( lPut );	//Retornado por referencia pelo Metodo :InsertBmp() .T. Inseriu a Nova Imagem, caso contrario, .F.
		)	
		/*/
		��������������������������������������������������������������Ŀ
		� Garante o Posicionamento no Registro						   �
		����������������������������������������������������������������/*/
	   	SRA->( MsGoto( nRecno ) )
	 	/*/
		��������������������������������������������������������������Ŀ
		� Lock no Registro     										   �
		����������������������������������������������������������������/*/
		IF SRA->( lLock := RecLock( "SRA" , .F. ) )
			/*/
			��������������������������������������������������������������Ŀ
			� Vincula a Imagem     										   �
			����������������������������������������������������������������/*/
			SRA->RA_BITMAP := cSraBitMap
			/*/
			��������������������������������������������������������������Ŀ
			� Atualiza o Vinculo da Imagem								   �
			����������������������������������������������������������������/*/
	    	oRepository:LoadBmp( cSraBitMap )
			oRepository:Refresh()
			/*/
			��������������������������������������������������������������Ŀ
			� Libera o Registro    										   �
			����������������������������������������������������������������/*/
			SRA->( MsUnLock() )
			/*/
			��������������������������������������������������������������Ŀ
			� Move a Imagem para um Diretorio "Backup"					   �
			����������������������������������������������������������������/*/
			MoveFile( cPathFile , cPath , cFile )
		EndIF
	EndIF

End Sequence

/*/
��������������������������������������������������������������Ŀ
� Retona se Conseguiu Gravar a Imagem     					   �
����������������������������������������������������������������/*/
lAllOk := (;
				( lFound );	//Verifica se Encontrou o Funcionario
				.and.;
				( lPutOk );	//Obtido a partir do Teste de Retorno do Metodo :InsertBmp()
				.and.;
				( lPut );	//Retornado por referencia pelo Metodo :InsertBmp() .T. Inseriu a Nova Imagem, caso contrario, .F.
				.and.;
				( lLock );	//Gravou a Referencia da Imagem no SRA ( Cadastro de Funcionarios )
			)	

Return( lAllOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �MoveFile	  �Autor�Marinaldo de Jesus   � Data �13/05/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Mover as Imagens que foram importadas para o Repositorio   e�
�          �vinculadas ao Funcionario para um diretorio "BackUp"		�
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function MoveFile( cPathFile , cPath , cFile )

Local cNewPath
Local cNewPathFile

Begin Sequence

	/*/
	��������������������������������������������������������������Ŀ
	� Define o "Path" para "Backup" das imagens					   �
	����������������������������������������������������������������/*/
	cNewPath := ( cPath + "BACK\" )

	/*/
	��������������������������������������������������������������Ŀ
	� Verifica se o "Path" para "Backup" existe e, se nao  existir,�
	� cria-o													   �
	����������������������������������������������������������������/*/
	IF !( DirMake( cNewPath ) )
		Break
	EndIF

	/*/
	��������������������������������������������������������������Ŀ
	� Define o novo "Path" e nome do arquivo. 					   �
	����������������������������������������������������������������/*/
	cNewPathFile := ( cNewPath + cFile )

	/*/
	��������������������������������������������������������������Ŀ
	� Move o arquivo para o "Path" de "Backup"					   �
	����������������������������������������������������������������/*/
	FileMove( cPathFile , cNewPathFile )

End Sequence

Return( NIL )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �EqualFile     �Autor�Marinaldo de Jesus   � Data �29/03/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Verifica se Dois Arquivos sao Iguais                        �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function EqualFile( cFile1 , cFile2 )

Local lIsEqualFile	:= .F.

Local nfhFile1	:= fOpen( cFile1 )
Local nfhFile2	:= fOpen( cFile2 )

Begin Sequence

	IF (;
			( nfhFile1 <= 0 );
			.or.;
			( nfhFile2 <= 0 );
		)
		Break
	EndIF

	lIsEqualFile := ArrayCompare( GetAllTxtFile( nfhFile1 ) , GetAllTxtFile( nfhFile2 ) )

	fClose( nfhFile1 )
	fClose( nfhFile2 )

End Sequence

Return( lIsEqualFile )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �DirMake       �Autor�Marinaldo de Jesus   � Data �29/03/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Cria um Diretorio                                           �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function DirMake( cMakeDir , nTimes , nSleep )

Local lMakeOk
Local nMakeOk

IF !( lMakeOk := lIsDir( cMakeDir ) )
	MakeDir( cMakeDir )
	nMakeOk			:= 0
	DEFAULT nTimes	:= 10
	DEFAULT nSleep	:= 1000
	While (;
			!( lMakeOk := lIsDir( cMakeDir ) );
			.and.;
			( ++nMakeOk <= nTimes );
	   )
		Sleep( nSleep )
		MakeDir( cMakeDir )
	End While
EndIF

Return( lMakeOk )

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �FileMove      �Autor�Marinaldo de Jesus   � Data �29/03/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Mover um arquivo de Diretorio                               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                      								�
�������������������������������������������������������������������������/*/
Static Function FileMove( cOldPathFile , cNewPathFile , lErase )

Local lMoveFile

Begin Sequence

	IF !(;
			lMoveFile := (;
							( __CopyFile( cOldPathFile , cNewPathFile ) );
							.and.;
							File( cNewPathFile );
							.and.;
							EqualFile( cOldPathFile , cNewPathFile );
						 );
		)
		Break
	EndIF

	DEFAULT lErase := .T.
	IF ( lErase )
		fErase( cOldPathFile )
	EndIF	

End Sequence

Return( lMoveFile )

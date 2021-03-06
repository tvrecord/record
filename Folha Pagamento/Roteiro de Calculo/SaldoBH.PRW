#INCLUDE "RWMAKE.CH"                                         
                   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SALDOBH   �Autora  �Glauce Prestes Nogueira� Data �28/09/06 ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA PARA CALCULO DO SALDO DE BANCO DE HORAS NA FOLHA  ���
��� 		   DE PAGAMENTO.		     								  ���
�������������������������������������������������������������������������ͻ��
���																		  ���
��� O sistema ir� buscar as verbas: 283- Base Result.BH Prov              ���
��� 								438- Base Result.BH Desc              ���
��� 														              ���
��� Executar calculo do SALDO = Base Result.BH Prov - Base Result.BH Desc ���
���								        					              ���
��� Se o resultado SALDO for POSITIVO, o sistema ir� gerar na Folha de    ���
��� Pagamento a verba: 282- Bco Horas (Prov)					          ���
��� 																	  ���
��� Se o resultado SALDO for NEGATIVO, o sistema ir� gerar na Folha de    ���
��� Pagamento a verba: 436- Bco Horas (Desc)					          ���
���																		  ���
���   ESTE PROGRAMA ESTA SENDO UTILIZADO ATRAV�S DO ROTEIRO 00455 -       ���
���          EXECBLOCK("SALDOBH",.F.,.F.)								  ���
���                														  ���
���                                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Rede Record                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SALDOBH()

Local BaseBHprov:= 0
Local BaseBHdesc:= 0   
Local Saldo     := 0   

DbSelectArea("SRA")
DbSetOrder(1)  
DbSelectArea("SPI")
DbSetOrder(1)

BaseBHprov := FBuscaPd("283","H",,)
BaseBHdesc := FBuscaPd("438","H",,)
Saldo:= ROUND(BaseBHprov - BaseBHdesc,2)

If Saldo <> 0
	If Saldo > 0
	   fGeraVerba("282",Saldo,Saldo,,,"H",,,,,.t.)
    Else	
       fGeraVerba("436",Saldo * (-1),Saldo * (-1),,,"H",,,,,.t.)
    EndIf   
EndIf

Return        
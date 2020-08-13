#INCLUDE "rwmake.CH"

User Function 810001()   

//Rafael FranÁa - 26/05/20 - Colocado a pedido do Sr. Igleson para controlar a conta contabil de acordo com o motivo da baixa

Private cConta := "321100006"

_aArea := GetArea()

IF 		SN4->N4_MOTIVO = "01"
cConta 	:= "321100006" //RECEITA DE VENDAS DE IMOBILIZADO        
ELSEIF 	SN4->N4_MOTIVO = "02" .OR. SN4->N4_MOTIVO = "03" .OR. SN4->N4_MOTIVO = "04" .OR. SN4->N4_MOTIVO = "05"
cConta 	:= "461100001" //PERDAS COM SINISTROS                    
ELSEIF 	SN4->N4_MOTIVO = "06"
cConta 	:= "461100002" //PERDAS COM BENS OBSOLETOS                       
ELSEIF 	SN4->N4_MOTIVO = "07"
cConta 	:= "461100003" //PERDAS COM BENS SUCATEADOS
ENDIF

/* TABELA DE MOTIVOS
01    	VENDA                                                  
02    	EXTRAVIO                                               
03    	ROUBO                                                  
04    	DOAÁ„O                                                 
05    	AVARIA                                                 
06    	OBSOLESCÍNCIA                                          
07    	SUCATEAMENTO                                           
08    	PROCESSO INTERNO DO SISTEMA                            
09    	REAVALIA«√O A MENOR                                    
10    	TRANSFERÍNCIA                                          
12    	PENHORA                                                
13    	CONVERS√O                                              
14    	NOTAS DE CR…DITO                                       
15    	TERM.LOCACAO                                           
16    	TERM.EMPRESTIMO                                        
17    	TERM.CONCESSAO                                         
18    	TRANSFERÍNCIA INTERNA ENTRE FILIAIS                    
20    	REVISAO DE PROJETO                                     
21    	ENCERRAMENTO DE PROJETO                                
22    	REVISAO DO AJUSTE A VALOR PRESENTE                     
23    	DevoluÁ„o   
*/                                           

_aArea	:= RestArea(_aArea)

Return(cConta)
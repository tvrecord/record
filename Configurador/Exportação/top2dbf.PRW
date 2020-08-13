/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ S2D      ³ Autor ³ Cristiano D. Alves    ³ Data ³ 25/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Converte tabelas do SQL para DBF                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
#include "rwmake.ch"
*-----------------*
user function top2dbf()
*-----------------*
_cperg:="S2D000    "
_pergsx1()
if pergunte(_cperg,.t.) .and.;
	msgbox("Confirma a conversao das tabelas de SQL para DBF?","Atencao","YESNO")
	processa({|| _converte()})
	msgstop("Conversao completada com sucesso.")
endif
return
*-------------------------*
static function _converte()
*-------------------------*
aStru:={}
cString:="TMP"
aAdd(aStru,{"ARQUIVO",    "C",08,00})
aAdd(aStru,{"CHAVE",    	"C",03,00})
cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,cString,.T.)
cInd := CriaTrab(NIL,.F.)
IndRegua(cString,cInd,"ARQUIVO",,,"Selecionando Registros...")

For _x := val(mv_par04) to val(mv_par05)
	_SX2:= "sx2"+strzero(_x,2)+"0.dbf"
	If file(_sx2)
		dbUseArea(.T.,,_sx2,"TMX2")
		DbSelectArea("TMX2")                                      
		TMX2->(DbSetOrder(1))
	  	tmx2->(dbseek(mv_par01,.t.))
		do while !TMX2->(eof()) .and. tmx2->x2_chave<=mv_par02
			If TMX2->x2_chave<mv_par01 .or. TMX2->x2_chave>mv_par02
				TMX2->(dBskip())
			Endif 
			If tmp->(!dBseek(tmx2->x2_arquivo))
				RECLOCK("TMP",.T.)
				Replace ;
				TMP->ARQUIVO with tmx2->x2_arquivo,;
				TMP->CHAVE   With tmx2->x2_chave
				Msunlock()
			Endif             
			TMX2->(dBskip())
		Enddo	
		TMX2->(dBcloseArea())
	Endif
Next

_cdir:=alltrim(mv_par03)+"\"
_cfiltro:=tmp->(dbfilter())
tmp->(dbclearfil())
tmp->(dBgotop())
procregua(tmp->(lastrec()))
//sx2->(dbseek(mv_par01,.t.))

while !tmp->(eof())  
	incproc("Processando arquivo "+tmp->arquivo)
	if tccanopen(tmp->arquivo)
		_carq:=_cdir+alltrim(tmp->arquivo)
		if if(file(_carq+".dtc"),msgyesno("Arquivo "+_carq+".DBF ja existe! Sobrebor?"),.t.)
			dbusearea(.t.,"TOPCONN",alltrim(tmp->arquivo),"NEW",.t.,.t.)
    		dbselectarea("NEW")
			copy to &_carq
			dbclosearea()
		endif
	endif
	tmp->(dbskip())
end
//tmp->(dbsetfilter({|| _cfiltro},_cfiltro))
tmp->(dBcloseArea())
return

*------------------------*
static function _pergsx1()
*------------------------*
_agrpsx1:={}
aadd(_agrpsx1,{_cperg,"01","Do arquivo         ?","mv_ch1","C",03,0,0,"G",space(60),"mv_par01"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"02","Ate o arquivo      ?","mv_ch2","C",03,0,0,"G",space(60),"mv_par02"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"03","Diretorio          ?","mv_ch3","C",30,0,0,"G",space(60),"mv_par03"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"04","Da Empresa         ?","mv_ch3","C",02,0,0,"G",space(60),"mv_par04"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
aadd(_agrpsx1,{_cperg,"05","Ate a Empresa      ?","mv_ch4","C",02,0,0,"G",space(60),"mv_par05"       ,space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),space(15),space(15)        ,space(30),"   "})
for i:=1 to len(_agrpsx1)
	if !sx1->(dbseek(_agrpsx1[i,1]+_agrpsx1[i,2]))
		sx1->(reclock("SX1",.t.))
		sx1->x1_grupo  :=_agrpsx1[i,01]
		sx1->x1_ordem  :=_agrpsx1[i,02]
		sx1->x1_pergunt:=_agrpsx1[i,03]
		sx1->x1_variavl:=_agrpsx1[i,04]
		sx1->x1_tipo   :=_agrpsx1[i,05]
		sx1->x1_tamanho:=_agrpsx1[i,06]
		sx1->x1_decimal:=_agrpsx1[i,07]
		sx1->x1_presel :=_agrpsx1[i,08]
		sx1->x1_gsc    :=_agrpsx1[i,09]
		sx1->x1_valid  :=_agrpsx1[i,10]
		sx1->x1_var01  :=_agrpsx1[i,11]
		sx1->x1_def01  :=_agrpsx1[i,12]
		sx1->x1_cnt01  :=_agrpsx1[i,13]
		sx1->x1_var02  :=_agrpsx1[i,14]
		sx1->x1_def02  :=_agrpsx1[i,15]
		sx1->x1_cnt02  :=_agrpsx1[i,16]
		sx1->x1_var03  :=_agrpsx1[i,17]
		sx1->x1_def03  :=_agrpsx1[i,18]
		sx1->x1_cnt03  :=_agrpsx1[i,19]
		sx1->x1_var04  :=_agrpsx1[i,20]
		sx1->x1_def04  :=_agrpsx1[i,21]
		sx1->x1_cnt04  :=_agrpsx1[i,22]
		sx1->x1_var05  :=_agrpsx1[i,23]
		sx1->x1_def05  :=_agrpsx1[i,24]
		sx1->x1_cnt05  :=_agrpsx1[i,25]
		sx1->x1_f3     :=_agrpsx1[i,26]
		sx1->(msunlock())
	endif
next
return

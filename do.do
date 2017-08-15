log using "unionbases.log", replace
*****1 punto: Uni�n de las bases de datos
******* Se importa a stata la base 1 que se encuentra en formato excel
import excel " Copia de Base1(4).xls", sheet("base1") firstrow
******* Se hace una descripci�n inicial de esta base verificando el total de observaciones y varibles y tipo de �stas
d
******* se guarda esta base de datos en formato stata
save "base1.dta"
******* Se cierra esta base de datos para proceder a importar la base 2 que se encuentra en un archivo separado por comas
clear
import delimited " base2.csv", delimiter(comma) 
******* Se hace una descripci�n inicial de esta base verificando el total de observaciones y varibles y tipo de �stas
d
******* se guarda esta base de datos que contiene el resto de pacientes incluidos en el estudio, como base2 y en formato stata
save "base2.dta"
*******Se procede a juntar las bases de datos 1 y 2 que ya se encuentran en formato stata. Se utiliza el comando append para adicionar los nuevos casos una vez verificado que las dos bases de datos tienen el mismo n�mero y tipo de variables
clear
use "base1.dta", clear
append using "base2.dta"
******* Se hace una descripci�n inicial de esta base verificando el total de observaciones y varibles y tipo de �stas

******* La anterior verificaci�n permite ver que ahora el archivo resultante tiene 303 observaciones y 7 variables de las cuales dos son alfanum�ricas (v4) y (v5)
******* Llamamos esta base base23 en formato stata y la guardamos
save "base23.dta"
******* Finalmente, se pega a esta base23, la base 3 dada que contiene dos variaables nuevas m�s la identificaci�n del paciente (v1)
merge 1:1 var1 using "base3.dta"
***** El uso del comando merge para pegar las bases, indica que se pegaron 1 a 1 los 303 casos y se tienen ahora 9 variables en la base resultante que se llamar� basefinal
save "Basefinal.dta"

***** Una vez obtenida la base final, se hace una descripci�n de ella
***** De esta descripci�n se debe notar que las variables 4 (presion sistolica) y 5 (colesterol en suero son alfanum�ricas. Se hace el cambio a variables numericas
 destring var4, replace force float
destring var5, replace force float
d
***** En la base final tambi�n se tienen diferentes formatos para las variables 7 (fecha de nacimiento) y la varible 9 (fecha de la angiografia coronaria. Se cambiar�n m�s adel
***** En la base final tambi�n se tienen diferentes formatos para las variables 7 (fecha de nacimiento) y la varible 9 (fecha de la angiografia coronaria. se cambian adelante
***** 2 punto:  Asignaci�n de nombres y r�tulos a las variables en la base de datos
label variable var1 "Identificacion del paciente"
rename var1 id
label variable var2 "sexo del paciente"
rename var2 sexo
label variable sexo "sexo del paciente"
label variable var3 "Tipo de dolor tor�cico"
rename var3 dolortor
 label variable var4 "Presion sist�lica"
rename var4 sbp
label variable var5 "Colesterol en suero"
rename var5 colesterol
label variable var6 "Resultados Eelectrocardiograficos"
 rename var6 electro
label variable var7 "Fecha de nacimiento"
rename var7 fechanac
 label variable var8 "Diagnostico enfermedad cardiaca"
 rename var8 diagn�stico
label variable var9 "Fecha angiografia coronaria"
rename var9 fechaangio
***** Se guardan los cambios en la base de datos
save, replace
***** 3 punto: Asignaci�n de r�tulos a los valores de las variables categ�ricas segun la tabla dada
label define lblsexo  0 "femenino" 1 "masculino"
label values sexo lblsexo
tab sexo
label define lbldolortor 1 "angina tipica" 2 "angina atipica" 3 "dolor sin angina" 4 "asintomatico"
 label values dolortor lbldolortor
tab dolortor
label define lblelectro 0 "normal" 1 "onda ST-T anormal" 2 "probable hipert. ventr. izq"
label values electro lblelectro
tab electro
label define lbldiagnostico 0 "<50% de estrech. del di�metro" 1 ">50% estrech.del di�metro"
label define lbldiagn�stico 0 "<50% de estrech. del di�metro" 1 ">50% estrech.del di�metro"
label values diagn�stico lbldiagn�stico
. tab diagn�stico
***** 4 punto : Asignacion de rotulos a los valores de las variables categoricas segun la tabla dada, considerando la referencia (5)
***** Se revisan los valores de la variable sbp
 tab sbp
***** Se genera una nueva variable a partir de la original que es sbp
egen float sbprec = cut(sbp), at(0 90 130 140 160 180 500) icodes
label variable sbprec "Presi�n sist�lica agrupada"
***** Para la nueva variable de la presion sistolica categorizada, se asignan los rotulos a las categorias definidas
label define lblsbprec 0 "Hipotension" 1 "Deseada/Normal" 2 "Prehipertension" 3 "Hipert.Grado 1" 4 "Hipert.Grado 2" 5 "Crisis Hipert."
label values sbprec lblsbprec
tab sbprec
 ***** 5 Punto: Generaci�n de una variable que contenga la edad de los pacientes al momento de la angiografia coronaria
******* Para generar esta variable, primero se revisan los formatos de las variables fecha de nacimiento y fecha de la angiografia
******* Se genera la variable fechanac1
gen fechanac1=date( fechanac,"MDY")
******* Se genera la variable fechaangio1
gen fechaangio1=date( fechaangio,"DMY")
label variable fechaangio1 "Fecha de la angiografia"
******* Generaci�n de la variable edadpac al momento de la angiografia coronaria
 gen edadpac= int(((fechaangio1- fechanac1)/365.25))
label variable edadpac "edad del paciente"
******* Descripcion de la variable edadpac
d edadpac
tab edadpac
save, replace
***** 6 Punto: Descripci�n de los pacientes de acuerdo a la edad y al sexo
******* Descripci�n de acuerdo a la edad.
sum edad,d
******* Descripci�n de los pacientes de acuerdo al sexo
tab sexo
 ****** Descripci�n gr�fica de la distribuci�n de la edad de los pacientes seg�n la variable sexo
graph box edadpac, by(, title("Edad de los pacientes seg�n  sexo ")) by(sexo)
graph export "edadporsexo.pdf", as(pdf) replace
histogram edadpac, normal by(, title("Edad de los pacientes seg�n sexo")) by(sexo)
graph export "edadsexnor.pdf", as(pdf) replace
 ***** 7 Punto: Descripci�n del diagn�stico de la enfermedad coronaria seg�n el dolor tor�cico
tab dolortor diagn�stico, row
 ******* En la anterior tabla se muestra para cada grupo de dolor tor�cico c�mo se distribuye el diagn�stico de la enfermedad, lo cual permitir�a la comparaci�n entre los grupos
 ******* Otras exploraciones 
 ******* Medidas de Tendencia central de la edad del paciente seg�n sexo  
tabstat edadpac, statistics( count mean median sd iqr ) by(sexo)
******* Distribuci�n de la presi�n sist�lica seg�n el sexo
tab sexo sbprec,row
******* Distribuci�n del dolor tor�ciso seg�n el sexo 
tab sexo dolortor ,row
log close
/*Pregunta 1
Doneu una seqüència d'operacions d'algebra relacional per obtenir el nom del departament on treballa i el nom del projecte on està assignat l'empleat número 2.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Nom_dpt		Nom_proj
MARKETING		IBDVID
*/

A=empleats(num_empl = 2)
B= A * departaments
C= B * projectes
D = C[nom_dpt,nom_proj]

/*Pregunta 2
Doneu una seqüència d'operacions d'algebra relacional per obtenir el número i nom dels departaments tals que tots els seus empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING

*/

A = empleats * departaments
R = A[num_dpt,nom_dpt]
B= A(ciutat_empl<>'MADRID')
E = B[num_dpt,nom_dpt]
C= R - E
D= C[num_dpt,nom_dpt]

/*Pregunta 3
Doneu una seqüència d'operacions de l'àlgebra relacional per obtenir el número i nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING
*/

A = empleats*departaments
B = A[num_dpt,nom_dpt,ciutat_empl]
C = B{ciutat_empl -> ciutat_empl2,num_dpt->num_dpt2,nom_dpt->nom_dpt2}
D = B[ciutat_empl <> ciutat_empl2,num_dpt = num_dpt2]C 
E = D[nom_dpt,num_dpt]

/*Pregunta 4
Donar una seqüència d'operacions d'àlgebra relacional per obtenir informació sobre els despatxos que només han estat ocupats per professors amb sou igual a 100000. Es vol obtenir el modul i el numero d'aquests despatxos.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

Modul	Numero
Omega	128
*/
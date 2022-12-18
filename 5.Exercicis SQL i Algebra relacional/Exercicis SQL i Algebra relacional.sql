/*Pregunta 1
Donar una sentència SQL per obtenir per cada mòdul on hi hagi despatxos, la suma de les durades de les assignacions finalitzades (instantFi diferent de null) a despatxos del mòdul. El resultat ha d'estar ordenat ascendentment pel nom del mòdul.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

MODUL		SUMAA
Omega		235
*/

Select a.modul, sum(a.instantFi-a.instantInici)
From  assignacions a
Where a.instantFi is not null
Group by a.modul
order by a.modul asc

/*Pregunta 2
Doneu una sentència SQL per obtenir els departaments tals que tots els empleats del departament estan assignats a un mateix projecte.
No es vol que surtin a la consulta els departaments que no tenen cap empleet.
Es vol el número, nom i ciutat de cada departament.

Cal resoldre l'exercici sense fer servir funcions d'agregació.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt		Ciutat_dpt
1		DIRECCIO		BARCELONA
*/

select distinct d.num_dpt, d.nom_dpt, d.ciutat_dpt
from empleats e,  departaments d
where  d.num_dpt = e.num_dpt and not exists (select * from empleats e2 where e.num_dpt = e2.num_dpt and e2.num_proj <> e.num_proj)

/*Pregunta 3
Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de la taula següent:
presentacioTFG(idEstudiant, titolTFG, dniDirector, dniPresident, dniVocal, instantPresentacio, nota)

Hi ha una fila de la taula per cada treball final de grau (TFG) que estigui pendent de ser presentat o que ja s'hagi presentat.

En la creació de la taula cal que tingueu en compte que:
- No hi pot haver dos TFG d'un mateix estudiant.
- Tot TFG ha de tenir un títol.
- No hi pot haver dos TFG amb el mateix títol i el mateix director.
- El director, el president i el vocal han de ser professors que existeixin a la base de dades, i tot TFG té sempre director, president i vocal.
- El director del TFG no pot estar en el tribunal del TFG (no pot ser ni president, ni vocal).
- El president i el vocal no poden ser el mateix professor.
- L'identificador de l'estudiant i el títol del TFG són chars de 100 caràcters.
- L'instant de presentació ha de ser un enter diferent de nul.
- La nota ha de ser un enter entre 0 i 10.
- La nota té valor nul fins que s'ha fet la presentació del TFG.

Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms s'han de posar en majúscues/minúscules com surt a l'enunciat.
*/

create table presentacioTFG (
	idEstudiant char(100),
	titolTFG char(100) not null,
	dniDirector char(50) not null,
	dniPresident char(50) not null,
		check (dniPresident != dniDirector),
	dniVocal char(50) not null,
		check (dniVocal != dniDirector),
		check (dniVocal != dniPresident),
	instantPresentacio integer not null,
	nota integer default null,
		check (nota >= 0),
		check (nota <= 10),
	primary key(idEstudiant),
	foreign key (dniDirector) references professors(dni),
	foreign key (dniPresident) references professors(dni),
	foreign key (dniVocal) references professors(dni),
	unique(titolTFG,dniDirector));

/*Pregunta 4
Doneu una seqüència d'operacions en àlgebra relacional per obtenir el nom dels professors que o bé tenen un sou superior a 2500, o bé que cobren menys de 2500 i no tenen cap assignació a un despatx amb superfície inferior a 20..

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NomProf
toni
*/

A = professors(sou > 2500)
B = professors * despatxos
C = B * assignacions
D = C(superficie < 20)
E = A[NomProf]
F = D[NomProf]
G = professors[NomProf]
H = G - F
R = E_u_H

/*Pregunta 5
Doneu una sentència d'inserció de files a la taula cost_ciutat que l'ompli a partir del contingut de la resta de taules de la base de dades. Tingueu en compte el següent:

Cal inserir una fila a la taula cost_ciutat per cada ciutat on hi ha un o més departaments, però no hi ha cap departament que tingui empleats.

Per tant, només s'han d'inserir les ciutats on cap dels departaments situats a la ciutat tinguin empleats.

El valor de l'atribut cost ha de ser 0.

Pel joc de proves públic del fitxer adjunt, un cop executada la sentència d'inserció, a la taula cost_ciutat hi haurà les tuples següents:

CIUTAT_DPT		COST
BARCELONA		0
*/

insert into cost_ciutat 
	(select distinct d.ciutat_dpt, 0 
	 from departaments d where not exists (select * 
	 										from empleats e natural inner join departaments d2 
	 										where d.ciutat_dpt = d2.ciutat_dpt))
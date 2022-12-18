--Pregunta 1
/*
Doneu una sentència SQL per obtenir el nom dels professors que o bé se sap el seu número de telèfon (valor diferent de null) i tenen un sou superior a 2500, o bé no se sap el seu número de telèfon (valor null) i no tenen cap assignació a un despatx amb superfície inferior a 20.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NomProf
toni
*/

select p.nomprof 
from professors p 
where (p.telefon is not null and p.sou > 2500) or (p.telefon is null and not exists 
															(select * from despatxos d, assignacions a where a.dni = p.dni and a.modul = d.modul and a.numero = d.numero and d.superficie < 20))

/*Pregunta 2
Donar una sentència SQL per obtenir els professors que tenen alguna assignació finalitzada (instantFi diferent de null) a un despatx amb superfície superior a 15 i que cobren un sou inferior o igual a la mitjana del sou de tots els professors. En el resultat de la consulta ha de sortir el dni del professor, el nom del professor, i el darrer instant en què el professor ha estat assignat a un despatx amb superfície superior a 15.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

DNI	NomProf	Darrer_instant
111	toni	344
*/

select p.dni, p.nomprof, a.instantfi as "Darrer_instant"
from professors p natural inner join assignacions a natural inner join despatxos d
where  a.instantfi is not null and d.superficie > 15 and
					p.sou <= (select avg(p2.sou) from professors p2)

/*Pregunta 3
Suposem la base de dades que podeu trobar al fitxer adjunt.
Suposem que aquesta base de dades està en un estat on no hi ha cap fila.
Doneu una seqüència de sentències SQL d'actualització (INSERTs i/o UPDATEs) sobre la taula que assignacions que violi la integritat referencial de la clau forana que referencia la taula Despatxos.
Les sentències NOMÉS han de violar aquesta restricció.

*/

insert into professors values('2','JOSE','434',324);
insert into despatxos values('9','5', 14);
insert into assignacions values('2','3','4',23,42);
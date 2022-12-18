
--Pregunta 1
--Doneu una sentència SQL per obtenir el número i el nom dels departaments que no tenen cap empleat que visqui a MADRID.

--Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

--NUM_DPT		NOM_DPT
--3		MARKETING
select  d.num_dpt, d.nom_dpt 
from departaments d
where not exists (select * from empleats e where ciutat_empl = 'MADRID' and d.num_dpt = e.num_dpt)

--Pregunta 2
--Doneu una sentència SQL per obtenir les ciutats on hi viuen empleats però no hi ha cap departament.

--Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

--CIUTAT_EMPL
--GIRONA

select distinct e.ciutat_empl
from empleats e
where not exists (select * from departaments d where d.ciutat_dpt = e.ciutat_empl)

--Pregunta 3
--Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents.

--Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

--NUM_DPT		NOM_DPT
--3		MARKETING
select d.num_dpt, d.nom_dpt
from departaments d
where 2 <= (select count(*) from empleats e,empleats e2 where e.ciutat_empl <> e2.ciutat_empl and e.num_dpt = d.num_dpt and e2.num_dpt = d.num_dpt)


--Pregunta 4
create table comandes
			( numComanda integer,
			instantComanda integer not null,
			client char(30), 
			encarregat integer not null,
			supervisor integer,
			primary key (numComanda),
			unique (instantComanda,client),
			foreign key (encarregat) references empleats(NUM_EMPL),
			foreign key (supervisor) references empleats(NUM_EMPL));
		
	create table productesComprats 
			(  numComanda integer,
			producte char(20),
			quantitat integer not null default 1,
			preu integer,
			primary key (numComanda,producte),
			foreign key (numComanda) references comandes(numComanda));


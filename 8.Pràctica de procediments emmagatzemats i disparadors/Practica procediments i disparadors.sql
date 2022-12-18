/*Pregunta 1
En aquest exercici es tracta definir els disparadors necessaris sobre empleats2 (veure definició de la base de dades al fitxer adjunt) per mantenir la restricció següent:
Els valors de l'atribut ciutat1 de la taula empleats1 han d'estar inclosos en els valors de ciutat2 de la taula empleats2
Per mantenir la restricció, la idea és que:

En lloc de treure un missatge d'error en cas que s'intenti executar una sentència sobre empleats2 que pugui violar la restricció,
cal executar operacions compensatories per assegurar el compliment de l'asserció. En concret aquestes operacions compensatories ÚNICAMENT podran ser operacions DELETE.

Pel joc de proves que trobareu al fitxer adjunt, i la sentència:
DELETE FROM empleats2 WHERE nemp2=1;
La sentència s'executarà sense cap problema,i l'estat de la base de dades just després ha de ser:

Taula empleats1
nemp1	nom1	ciutat1
1	joan	bcn
2	maria	mad

Taula empleats2
nemp2	nom2	ciutat2
2	pere	mad
3	enric	bcn
*/
CREATE FUNCTION esborrarEmpleats() returns trigger AS $$   
    BEGIN
        IF (not exists(SELECT * FROM empleats2 WHERE ciutat2 = old.ciutat2)) THEN
            delete from empleats1 where ciutat1 = old.ciutat2;
        END IF;
    return null;
END;
$$LANGUAGE plpgsql;


create trigger mantenirCiuD after delete on  empleats2 for each row execute procedure esborrarEmpleats();

create trigger mantenirCiuU after update of ciutat2 on empleats2 for each row execute procedure esborrarEmpleats();
/*Pregunta 2
Disposem de la base de dades del fitxer adjunt que gestiona clubs esportius i socis d'aquests clubs.
Cal implementar un procediment emmagatzemat "assignar_individual(nomSoci,nomClub)".

El procediment ha de:
- Enregistrar l'assignació del soci nomSoci al club nomClub, inserint la fila corresponent a la taula Socisclubs.
- Si el club nomClub passa a tenir més de 5 socis, inserir el club a la taula Clubs_amb_mes_de_5_socis.
- El procediment no retorna cap resultat.

Les situacions d'error que cal identificar són les tipificades a la taula missatgesExcepcions.
Quan s'identifiqui una d'aquestes situacions cal generar una excepció:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 .. 5, depenent de l'error)
RAISE EXCEPTION '%',missatge; (missatge ha de ser una variable definida al vostre procediment)

Suposem el joc de proves que trobareu al fitxer adjunt i la sentència
select * from assignar_individual('anna','escacs');
La sentència s'executarà sense cap problema, i l'estat de la base de dades just després ha de ser:

Taula Socisclubs
anna	escacs
joanna	petanca
josefa	petanca
pere	petanca
Taula clubs_amb_mes_de_5_soci
sense cap fila
*/
create or replace function assignar_individual(nom_soci socis.nsoci%type, nom_club clubs.nclub%TYPE) returns void as $$
declare
	missatge varchar(50);
	contador integer;
	num_F	integer;
begin
	insert into socisclubs values (nom_soci, nom_club);
	select count(*) into contador from socisclubs where nom_club = nclub;
	if (contador > 10) then
		 select texte into missatge from missatgesexcepcions where num = 1;
		 raise exception '%', missatge;
	else
		if (contador > 5) and not exists(select * from clubs_amb_mes_de_5_socis where nclub = nom_club) then
			insert into clubs_amb_mes_de_5_socis values(nom_club);
		end if;
		select count(*) into num_F from socis s, socisclubs c where s.sexe = 'F' and s.nsoci = c.nsoci and nom_club = c.nclub;
		if (contador - num_F > num_F) then
			select texte into missatge from missatgesexcepcions where num = 2;
			raise exception '%', missatge;
		end if;
	end if;
	exception
		when raise_exception then
			raise exception '%', SQLERRM;
		when unique_violation then
			select texte into missatge from missatgesexcepcions where num = 3;
			raise exception '%', missatge;
		when foreign_key_violation then
			select texte into missatge from missatgesexcepcions where num = 4;
			raise exception '%', missatge;
		when others then
			select texte into missatge from missatgesexcepcions where num = 5;
			raise exception '%', missatge;
end;
$$ language plpgsql;
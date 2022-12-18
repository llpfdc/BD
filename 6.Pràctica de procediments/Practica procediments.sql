/*Pregunta 1
Donat un intèrval de DNIs, programar un procediment emmagatzemat "llistat_treb(dniIni,dniFi)" per obtenir la informació de cadascun dels treballadors amb un DNI d'aquest interval.

Per cada treballador de l'interval cal obtenir:
- Les seves dades personals: dni, nom, sou_base i plus

- En cas que el treballador tingui 5 o més lloguers actius, al llistat hi ha de sortir una fila per cadascun dels cotxes que té llogats.
- En qualsevol altre cas, al llistat hi ha de sortir una única fila amb les dades del treballador, i nul a la matrícula.

Tingueu en compte que:
- Es vol que retorneu els treballadors ordenats per dni i matricula de forma ascendent.
- El tipus de les dades que s'han de retornar han de ser els mateixos que hi ha a la taula on estan definits els atributs corresponents.

El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que heu d'identificar són les tipificades a la taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents al fitxer adjunt. En el vostre procediment heu d'incloure, on s'identifiquin aquestes situacions, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 o 2, depenent de l'error)
RAISE EXCEPTION '%',missatge;
On la variable missatge ha de ser una variable definida al vostre procediment.

Pel joc de proves que trobareu al fitxer adjunt i la crida següent,
SELECT * FROM llistat_treb('11111111','33333333');
el resultat ha de ser:

DNI		Nom		Sou		Plus		Matricula
22222222		Joan		1700		150		1111111111
22222222		Joan		1700		150		2222222222
22222222		Joan		1700		150		3333333333
22222222		Joan		1700		150		4444444444
22222222		Joan		1700		150		5555555555

*/
CREATE TYPE treballador as (
    dni varchar(8),
    nom varchar(30),
    sou_base real,
    sou_plus real,
    matricula varchar(30));

CREATE FUNCTION llistat_treb(dni_min char(8), dni_max char(8)) returns setof treballador AS $$
    DECLARE
        missatge varchar(50);
        t treballador;

    BEGIN
        for t IN SELECT * FROM treballadors WHERE (dni <= dni_max and dni >= dni_min) ORDER BY dni ASC
        LOOP
        IF ((select count(*) from lloguers_actius where dni = t.dni) > 4) THEN
            for t.matricula in select matricula from lloguers_actius WHERE dni = t.dni ORDER BY matricula ASC
        LOOP
        return next t;
        END loop;
        ELSE
            t.matricula := null;
            return next t;
        END IF;
        END LOOP;

    IF NOT found THEN
        SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
        RAISE EXCEPTION '%',missatge;
    END IF;

    EXCEPTION
       WHEN raise_exception THEN
            RAISE EXCEPTION '%',sqlerrm;
        WHEN others THEN
            SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2;
            RAISE EXCEPTION '%',missatge;
    return;
END;
$$LANGUAGE plpgsql;


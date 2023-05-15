
--Vista para sacar todos los jugadores de draft
CREATE OR REPLACE VIEW JUGADORES_DRAFT AS
(

	SELECT J.POSICION, J.NUMDRAFT, J.TIPO , P.*
	FROM JUGADORES J , PERSONAS P
	WHERE J.ID = P.ID 
    and UPPER(TIPO) = 'DRAFT'
    
);


--Vista para sacar todos los WildCard

CREATE OR REPLACE VIEW JUGADORES_WILDCARD AS
(
    SELECT J.POSICION, J.TIPO , P.*
	FROM JUGADORES J , PERSONAS P
	WHERE J.ID = P.ID 
    and UPPER(TIPO) = 'WILDCARD'
	
);



-- Vista para ver la clasificacion

CREATE OR REPLACE VIEW CLASIFICACION
AS(
SELECT COUNT(P.IDEQUIPO) AS PARTIDOSGANADOS, SUM(P1.GOLESEQUIPO1 + P2.GOLESEQUIPO2)
GOLESTOTALES,E.NOMBRE NOMBRE
FROM PARTIDOS P, PARTIDOEQUIPO1 P1, PARTIDOEQUIPO2 P2, EQUIPOS E
WHERE P.ID = P1.IDPARTIDO AND P2.IDPARTIDO = P1.IDPARTIDO AND
P1.IDPARTIDO = E.ID
AND p1.idEquipo = (SELECT ID FROM EQUIPOS)
AND p2.idEquipo = (SELECT ID FROM EQUIPOS)
GROUP BY E.NOMBRE
);


-- Vista para ver los resultados de cada partido

CREATE OR REPLACE VIEW RESULTADOPARTIDO
as(

    SELECT E.NOMBRE AS NOMBRELOCAL , A.NOMBRE AS NOMBREVISITANTE, P1.GOLESEQUIPO1 
    GOLESLOCAL, P2.GOLESEQUIPO2 AS GOLESVISITANTE
    FROM EQUIPOS E, EQUIPOS A, PARTIDOEQUIPO1 P1, PARTIDOEQUIPO2 P2
    WHERE E.ID = A.ID AND E.ID = P1.IDEQUIPO AND P1.IDPARTIDO = P2.IDPARTIDO

);



CREATE OR REPLACE VIEW EMPAREJAMIENTOS AS
(

    SELECT J.ID AS "JORNADA",P1.IDPARTIDO AS "PARTIDO", P1.IDEQUIPO AS "EQUIPO1"
    , P2.IDEQUIPO AS "EQUIPO2"
    FROM JORNADAS J, PARTIDOEQUIPO1 P1, PARTIDOEQUIPO2 P2, PARTIDOS P
    WHERE J.ID = P.IDJORNADA AND P.ID = P1.IDPARTIDO AND P.ID = P2.IDPARTIDO

);






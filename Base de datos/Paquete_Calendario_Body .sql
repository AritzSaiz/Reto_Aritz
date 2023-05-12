
-- PAQUETE REFERENTE AL CALENDARIO (BODY) --

CREATE OR REPLACE PACKAGE BODY DatosCalendario AS

--------------------------------------------------------------------------------
--****************************************************************************--
--------------------------------------------------------------------------------

    PROCEDURE EmparejarLigaRegular
    AS
    
    V_FechaJornada  DATE := SYSDATE;
    V_HoraPartido   NUMBER := 10.00;
    V_CursorJornada SYS_REFCURSOR;
    V_CursorEquipo1 SYS_REFCURSOR;
    V_CursorEquipo2 SYS_REFCURSOR;
    V_IdJornada     JORNADAS.ID%TYPE;
    V_IdPartido     PARTIDOS.ID%TYPE;
    V_IdEquipo1     EQUIPOS.ID%TYPE;
    V_IdEquipo2     EQUIPOS.ID%TYPE;
    V_PartidoExiste NUMBER(2);
    
    BEGIN
    
        OPEN V_CursorEquipo1 FOR
        SELECT ID FROM EQUIPOS;
        
        OPEN V_CursorEquipo2 FOR
        SELECT ID FROM EQUIPOS;
    
    --CREAR 11 JORNADAS PARA EL ULTIMO SPLIT
        FOR NumJornadas IN 1..11
        LOOP
        
        INSERT INTO JORNADAS (FECHA, TIPO, IDSPLIT)
        VALUES(V_FechaJornada, 'regular', (SELECT MAX(ID) FROM SPLIT));
        
        V_FechaJornada := V_FechaJornada + 7;
        
        END LOOP;
    
    --OBTENER LOS ID DE LAS JORNADAS
        OPEN V_CursorJornada FOR
        SELECT ID FROM JORNADAS;
        
    --CREAR LOS PARTIDOS PARA CADA JORNADA
        LOOP
        
            FETCH V_CursorJornada INTO V_IdJornada;
            
            EXIT WHEN V_CursorJornada%NOTFOUND;
        
        --CREAR LOS 3 EMPAREJAMIENTOS
            FOR NumPartidos IN 1..6
            LOOP
            
                INSERT INTO PARTIDOS (HORA, IDJORNADA)
                VALUES (TO_CHAR(V_HoraPartido), V_IdJornada);
        
                V_HoraPartido := V_HoraPartido + 02.00;
                
                SELECT MAX(ID) INTO V_IdPartido
                FROM PARTIDOS;
                
                LOOP
                
                    FETCH V_CursorEquipo1 INTO V_IdEquipo1;
                    
                    LOOP
                    
                        FETCH V_CursorEquipo2 INTO V_IdEquipo2;
                        EXIT WHEN V_IdEquipo2 != V_IdEquipo1;
                    
                    END LOOP;
                    
                    SELECT NVL(COUNT(*),0) INTO V_PartidoExiste
                    FROM EMPAREJAMIENTOS
                    WHERE JORNADA IN
                           (SELECT JORNADA 
                            FROM EMPAREJAMIENTOS
                            WHERE EQUIPO1 = V_IdEquipo1 and EQUIPO2 = V_IdEquipo2
                            OR EQUIPO1 = V_IdEquipo2 and EQUIPO2 = V_IdEquipo1);
                    
                    IF V_partidoExiste = 0 THEN  
                    
                    INSERT INTO PARTIDOEQUIPO1 (IDPARTIDO, IDEQUIPO)
                    VALUES (V_IdPartido, V_IdEquipo1);
                    
                    INSERT INTO PARTIDOEQUIPO2 (IDPARTIDO, IDEQUIPO)
                    VALUES (V_IdPartido, V_IdEquipo2);
                    
                    END IF;
                    
                EXIT WHEN V_PartidoExiste = 0;
                
                END LOOP;
                
            END LOOP;
            
            CLOSE V_CursorEquipo1;
            CLOSE V_CursorEquipo2;
            
            OPEN V_CursorEquipo1 FOR
            SELECT ID FROM EQUIPOS;
        
            OPEN V_CursorEquipo2 FOR
            SELECT ID FROM EQUIPOS;
            
        END LOOP;
    
    CLOSE V_CursorEquipo1;
    CLOSE V_CursorEquipo2;
    
    END EmparejarLigaRegular;

--------------------------------------------------------------------------------
--****************************************************************************--
--------------------------------------------------------------------------------

    PROCEDURE EmparejarPlayOff
    AS
    
    BEGIN
    
        NULL;
    
    END EmparejarPlayOff;

--------------------------------------------------------------------------------
--****************************************************************************--
--------------------------------------------------------------------------------

END DatosCalendario;
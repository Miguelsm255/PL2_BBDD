\pset pager off

BEGIN;
\echo 'creando un esquema'
CREATE SCHEMA IF NOT EXISTS ddbb;

\echo 'creando la tabla películas'
CREATE TABLE IF NOT EXISTS ddbb.películas(
     año           TEXT 
    ,título        TEXT 
    ,géneros       TEXT
    ,puntuación    TEXT
    ,duración      TEXT
    ,idioma        TEXT
    ,calificación  TEXT
);

\echo 'Cargando datos'
\COPY ddbb.películas    FROM peliculas.csv WITH (FORMAT csv, HEADER, DELIMITER E',', NULL 'NULL', ENCODING 'UTF-8');

\echo "Mostrar cuantas películas hay" 
SELECT
    count(*) as Número_de_películas
    FROM ddbb.películas                                                            -- from películas
    ;
\echo "Mostrar las películas en idioma español" 
SELECT
    *
    FROM ddbb.películas                                                            -- from películas
    WHERE películas.idioma='es' 
;
ROLLBACK;                       -- importante! permite correr el script multiples veces...p
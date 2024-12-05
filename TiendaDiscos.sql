\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
\echo ''
\echo '###~Crearemos un esquema.~###'
\echo ''
CREATE SCHEMA IF NOT EXISTS TiendaDiscos;

--SET search_path='nombre del esquema o esquemas utilizados';

\echo ''
\echo '###~Creamos a continuación las tablas temporales.~###'
\echo ''
CREATE TABLE IF NOT EXISTS Disco_temp(
    id_disco INT,
    "Nombre del disco" TEXT,
    "fecha de lanzamiento" INT,
    id_grupo INT,
    "Nombre del grupo" TEXT,
    "url del grupo" TEXT,
    géneros TEXT,
    "url portada" TEXT 
);

CREATE TABLE IF NOT EXISTS Canción_temp(
    "id del disco" INT,
    "Título de la canción" TEXT,
    duración TEXT
);

CREATE TABLE IF NOT EXISTS Usuario_desea_temp(
    "nombre de usuario" TEXT,
    "títuloo del disco" TEXT,
    "año lanzamiento del disco" INT 
);

CREATE TABLE IF NOT EXISTS Usuario_tiene_temp(
    "nombre de usuario" TEXT,
    "titulo del disco" TEXT,
    "año lanzamiento del disco" INT,
    "año edición" INT,
    "país de edición" TEXT,
    formato TEXT,
    estado TEXT 
);

CREATE TABLE IF NOT EXISTS Usuario_temp(
    "Nombre completo" TEXT,
    "Nombre de usuario" TEXT,
    email TEXT,
    contraseña TEXT 
);

CREATE TABLE IF NOT EXISTS Ediciones_temp(
    "id del disco" INT,
    "año de la edición" INT,
    "país de la edición" TEXT,
    formato TEXT 
);

\echo ''
\echo '###~Tablas temporales creadas. Procedemos a definir las tablas definitivas.~###'
\echo ''
CREATE TABLE IF NOT EXISTS Usuario(
    Nombre_Usuario TEXT,
    Nombre TEXT,
    Contraseña TEXT,
    Email TEXT,
    CONSTRAINT Usuario_pk PRIMARY KEY(Nombre_Usuario)
);

CREATE TABLE IF NOT EXISTS Grupo(
    Nombre_Grupo TEXT,
    URL_Imagen TEXT,
    CONSTRAINT Grupo_pk PRIMARY KEY(Nombre_Grupo)
);

CREATE TABLE IF NOT EXISTS Disco(
    Título_Disco TEXT,
    Año_publicación INT,
    URL_Portada TEXT,
    Nombre_Grupo TEXT,
    CONSTRAINT Disco_pk PRIMARY KEY(Título_Disco, Año_publicación),
    CONSTRAINT Grupo_fk FOREIGN KEY(Nombre_Grupo) REFERENCES Grupo(Nombre_Grupo)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Géneros_Disco(
    Nombre_Género TEXT,
    Título_Disco TEXT,
    Año_publicación INT,  
    CONSTRAINT Géneros_Disco_pk PRIMARY KEY(Nombre_Género, Título_Disco, Año_publicación),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Desea(
    Nombre_Usuario TEXT,
    Título_Disco TEXT,
    Año_publicación INT,
    CONSTRAINT Desea_pk PRIMARY KEY(Nombre_Usuario, Título_Disco, Año_publicación),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Canción(
    Título_Canción TEXT,
    Duración TIME,
    Título_Disco TEXT,
    Año_publicación INT, 
    CONSTRAINT Canción_pk PRIMARY KEY(Título_Canción, Título_Disco, Año_publicación),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Ediciones(
    Formato TEXT,    
    País TEXT,
    Año_Edición INT,
    Título_Disco TEXT,
    Año_publicación INT,
    CONSTRAINT Ediciones_pk PRIMARY KEY(Formato, Año_Edición, País, Título_Disco, Año_publicación),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Tiene(
    Estado TEXT,
    Nombre_Usuario TEXT,
    Título_Disco TEXT,
    Año_publicación INT, 
    Año_Edición INT,
    País TEXT,
    Formato TEXT,
    CONSTRAINT Tiene_pk PRIMARY KEY(Nombre_Usuario, Título_Disco, Año_publicación, Año_Edición, País, Formato),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Ediciones_fk FOREIGN KEY (Formato, Año_Edición, País, Título_Disco, Año_publicación) REFERENCES Ediciones(Formato, Año_Edición, País, Título_Disco, Año_publicación)
);

\echo ''
\echo '###~Cargando datos.~###'
\echo ''
\COPY Disco_temp FROM 'Datos_de_discos/discos.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Ediciones_temp FROM 'Datos_de_discos/ediciones.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_desea_temp FROM 'Datos_de_discos/usuario_desea_disco.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_tiene_temp FROM 'Datos_de_discos/usuario_tiene_edicion.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_temp FROM 'Datos_de_discos/usuarios.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Canción_temp FROM 'Datos_de_discos/canciones.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL 'NULL', ENCODING 'UTF-8');

\echo ''
\echo '###~Tablas creadas. Procedemos a unirlas.~###'
\echo ''

INSERT INTO Grupo(Nombre_Grupo, URL_Imagen)
SELECT DISTINCT 
    "Nombre del grupo", 
    "url del grupo"
FROM Disco_temp;

INSERT INTO Disco(Título_Disco, Año_publicación, URL_Portada, Nombre_Grupo)
SELECT DISTINCT 
    "Nombre del disco", 
    COALESCE("fecha de lanzamiento", 1) AS Año_publicación, 
    "url portada", 
    "Nombre del grupo"
FROM Disco_temp;

INSERT INTO Géneros_Disco (Nombre_Género, Título_Disco, Año_publicación)
SELECT DISTINCT
    TRIM(BOTH ' ' FROM regexp_replace(género, '''', '', 'g')) AS Nombre_Género,
    Disco_temp."Nombre del disco" AS Título_Disco,
    COALESCE(Disco_temp."fecha de lanzamiento", 1) AS Año_publicación
FROM Disco_temp, 
    regexp_split_to_table(
        TRIM(BOTH '[]' FROM Disco_temp.géneros), ', '
    ) AS género;


INSERT INTO Usuario(Nombre_Usuario, Nombre, Contraseña, Email)
SELECT DISTINCT 
    "Nombre de usuario", 
    "Nombre completo", 
    "contraseña", 
    "email"
FROM Usuario_temp;

INSERT INTO Desea(Nombre_Usuario, Título_Disco, Año_publicación)
SELECT DISTINCT 
    "nombre de usuario", 
    "títuloo del disco", 
    COALESCE("año lanzamiento del disco", 1) AS Año_publicación
FROM Usuario_desea_temp
JOIN Usuario_temp ON Usuario_desea_temp."nombre de usuario" = Usuario_temp."Nombre de usuario";

INSERT INTO Ediciones(Formato, País, Año_Edición, Título_Disco, Año_publicación)
SELECT DISTINCT 
    et."formato", 
    et."país de la edición", 
    COALESCE("año de la edición", 1) AS Año_Edición,
    dt."Nombre del disco",
    COALESCE(dt."fecha de lanzamiento", 1) AS Año_publicación
FROM Ediciones_temp et
JOIN Disco_temp dt ON et."id del disco" = dt.id_disco
ON CONFLICT (Formato, País, Año_Edición, Título_Disco, Año_publicación) DO NOTHING;

INSERT INTO Tiene(Nombre_Usuario, Título_Disco, Año_publicación, Año_Edición, País, Formato, Estado)
SELECT DISTINCT 
    "nombre de usuario", 
    "titulo del disco", 
    COALESCE("año lanzamiento del disco", 1) AS Año_publicación, 
    COALESCE("año edición", 1) AS Año_Edición, 
    "país de edición", 
    et."formato", 
    "estado"
FROM Usuario_tiene_temp ut
JOIN Ediciones_temp et 
    ON ut."país de edición" = et."país de la edición"
    AND ut.formato = et.formato
JOIN Usuario_temp um ON ut."nombre de usuario" = um."Nombre de usuario";

INSERT INTO Canción(Título_Canción, Duración, Título_Disco, Año_publicación)
SELECT DISTINCT 
    COALESCE("Título de la canción", 'Untitled') AS Título_Canción,              
    MAKE_INTERVAL(
        mins => SPLIT_PART(CAST(Canción_temp.duración AS TEXT), ':', 1)::INTEGER, 
        secs => SPLIT_PART(CAST(Canción_temp.duración AS TEXT), ':', 2)::INTEGER 
    )::TIME AS duración,
    Disco_temp."Nombre del disco",
    COALESCE(Disco_temp."fecha de lanzamiento", 1) AS Año_publicación
FROM Canción_temp JOIN Disco_temp ON Canción_temp."id del disco" = Disco_temp.id_disco
ON CONFLICT (Título_Canción, Título_Disco, Año_publicación) DO NOTHING;

\echo ''
\echo '###~Datos cargados. Procedemos a eliminar las tablas temporales.~###'
\echo ''

DROP TABLE Disco_temp;
DROP TABLE Canción_temp;
DROP TABLE Usuario_desea_temp;
DROP TABLE Usuario_tiene_temp;
DROP TABLE Usuario_temp;
DROP TABLE Ediciones_temp;

\echo ''
\echo '###~Tablas temporales eliminadas con éxito.~###'
\echo ''
\echo 'FASE 1 TERMINADA'
\echo ''
\echo '###~INICIO FASE 2: CONSULTAS~###'
\echo ''













COMMIT; 
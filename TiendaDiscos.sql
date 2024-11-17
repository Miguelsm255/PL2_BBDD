\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
\echo '###~Crearemos un esquema.~###'
CREATE SCHEMA IF NOT EXISTS TiendaDiscos;


--SET search_path='nombre del esquema o esquemas utilizados';


\echo '###~Creamos a continuación las tablas temporales.~###'
CREATE TABLE IF NOT EXISTS Disco_temp(
    id_disco INT,
    "Nombre del disco" TEXT,
    "fecha de lanzamiento" INT DEFAULT 1,
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

\echo '###~Tablas temporales creadas. Procedemos a definir las tablas definitivas.~###'
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
    Año_publicación INT DEFAULT 1,
    URL_Portada TEXT,
    Nombre_Grupo TEXT,
    CONSTRAINT Disco_pk PRIMARY KEY(Título_Disco, Año_publicación),
    CONSTRAINT Grupo_fk FOREIGN KEY(Nombre_Grupo) REFERENCES Grupo(Nombre_Grupo)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Géneros_Disco(
    Nombre_Género TEXT,
    Título_Disco TEXT,
    Año_publicación INT DEFAULT 1,  
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Desea(
    Nombre_Usuario TEXT,
    Título_Disco TEXT,
    Año_publicación INT DEFAULT 1,
    CONSTRAINT Desea_pk PRIMARY KEY(Nombre_Usuario, Título_Disco, Año_publicación),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Canción(
    Título_Canción TEXT,
    Duración TIME,
    Título_Disco TEXT,
    Año_publicación INT DEFAULT 1, 
    CONSTRAINT Canción_pk PRIMARY KEY(Título_Canción),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Ediciones(
    Formato TEXT,    
    País TEXT,
    Año_Edición INT DEFAULT 1,
    Título_Disco TEXT,
    Año_publicación INT DEFAULT 1,
    CONSTRAINT Ediciones_pk PRIMARY KEY(Formato, Año_Edición, País),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Tiene(
    Estado TEXT,
    Nombre_Usuario TEXT,
    Título_Disco TEXT,
    Año_publicación INT DEFAULT 1, 
    Año_Edición INT,
    País TEXT,
    Formato TEXT,
    CONSTRAINT Tiene_pk PRIMARY KEY(Estado, Nombre_Usuario, Título_Disco, Año_publicación, Año_Edición, País, Formato),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Ediciones_fk FOREIGN KEY (Formato, Año_Edición, País) REFERENCES Ediciones(Formato, Año_Edición, País)
);

\echo '###~Cargando datos.~###'
\COPY Disco_temp FROM 'Datos_de_discos/discos.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Ediciones_temp FROM 'Datos_de_discos/ediciones.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_desea_temp FROM 'Datos_de_discos/usuario_desea_disco.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_tiene_temp FROM 'Datos_de_discos/usuario_tiene_edicion.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Usuario_temp FROM 'Datos_de_discos/usuarios.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL '0', ENCODING 'UTF-8');

\COPY Canción_temp FROM 'Datos_de_discos/canciones.csv' WITH (FORMAT csv, HEADER, DELIMITER E';', NULL 'NULL', ENCODING 'UTF-8');

\echo '###~Tablas creadas. Procedemos a unirlas.~###'
INSERT INTO Grupo(Nombre_Grupo, URL_Imagen)
SELECT DISTINCT 
    "Nombre del grupo", 
    "url del grupo"
FROM Disco_temp;

INSERT INTO Disco(Título_Disco, Año_publicación, URL_Portada, Nombre_Grupo)
SELECT DISTINCT 
    "Nombre del disco", 
    COALESCE("fecha de lanzamiento", 1), 
    "url portada", 
    "Nombre del grupo"
FROM Disco_temp;

INSERT INTO Géneros_Disco(Nombre_Género, Título_Disco, Año_publicación)
SELECT DISTINCT 
    "géneros", 
    "Nombre del disco", 
    COALESCE("fecha de lanzamiento", 1)
FROM Disco_temp;

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
    COALESCE("año lanzamiento del disco", 1)
FROM Usuario_desea_temp 
JOIN Usuario_temp ON Usuario_desea_temp."nombre de usuario" = Usuario_temp."Nombre de usuario";

INSERT INTO Ediciones(Formato, País, Año_Edición, Título_Disco, Año_publicación)
SELECT DISTINCT 
    et."formato", 
    et."país de la edición", 
    COALESCE(et."año de la edición", 1) AS Año_Edición,
    dt."Nombre del disco",
    COALESCE(dt."fecha de lanzamiento", 1) AS Año_publicación
FROM Ediciones_temp et
JOIN Disco_temp dt ON et."id del disco" = dt.id_disco
ON CONFLICT (Formato, País, Año_Edición) DO NOTHING;

INSERT INTO Tiene(Nombre_Usuario, Título_Disco, Año_publicación, Año_Edición, País, Formato, Estado)
SELECT DISTINCT 
    "nombre de usuario", 
    "titulo del disco", 
    COALESCE("año lanzamiento del disco", 1), 
    COALESCE("año edición", 1),
    "país de edición", 
    Ediciones_temp."formato", 
    "estado"
FROM Usuario_tiene_temp 
JOIN Ediciones_temp ON Usuario_tiene_temp."año edición" = Ediciones_temp."año de la edición"
AND Usuario_tiene_temp."país de edición" = Ediciones_temp."país de la edición"
AND Usuario_tiene_temp.formato = Ediciones_temp.formato
JOIN Usuario_temp ON Usuario_tiene_temp."nombre de usuario" = Usuario_temp."Nombre de usuario";

INSERT INTO Canción(Título_Canción, Duración, Título_Disco, Año_publicación)
SELECT DISTINCT 
    COALESCE("Título de la canción", 'Untitled'),              
    MAKE_INTERVAL(
        mins => SPLIT_PART(CAST(Canción_temp.duración AS TEXT), ':', 1)::INTEGER, -- Extraer los minutos
        secs => SPLIT_PART(CAST(Canción_temp.duración AS TEXT), ':', 2)::INTEGER  -- Extraer los segundos
    )::TIME AS duración,
    Disco_temp."Nombre del disco",
    COALESCE(Disco_temp."fecha de lanzamiento", 1)
FROM Canción_temp JOIN Disco_temp ON Canción_temp."id del disco" = Disco_temp.id_disco
ON CONFLICT (Título_Canción) DO NOTHING;

ROLLBACK; 
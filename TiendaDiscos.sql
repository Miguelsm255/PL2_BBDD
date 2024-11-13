\pset pager off

SET client_encoding = 'UTF8';

BEGIN;
\echo 'Crearemos un esquema.'
CREATE SCHEMA IF NOT EXISTS TiendaDiscos;


\echo 'Creamos a continuación las tablas temporales.'
CREATE TABLE IF NOT EXISTS Disco_temp(
    id_disco INT NOT NULL,
    Nombre del disco TEXT NOT NULL,
    fecha de lanzamiento INT,
    id_grupo INT NOT NULL,
    Nombre del grupo TEXT NOT NULL,
    url del grupo TEXT, NOT NULL,
    géneros TEXT, NOT NULL,
    url portada TEXT, NOT NULL,
    CONSTRAINT Disco_temp_pk PRIMARY KEY(id_disco)
);

CREATE TABLE IF NOT EXISTS Canción_temp(
    id del disco INT NOT NULL,
    Título de la Canción TEXT NOT NULL,
    duración TIME, 
    CONSTRAINT Canción_temp_pk PRIMARY KEY(Título de la Canción, id del disco),
);

CREATE TABLE IF NOT EXISTS Ediciones_temp(
    id del disco INT NOT NULL,
    año de la edición INT,
    país de la edición TEXT,
    formato TEXT NOT NULL,
    CONSTRAINT Ediciones_temp_pk PRIMARY KEY(id del disco),
);

CREATE TABLE IF NOT EXISTS Usuario_quiere_temp(
    nombre de usuario TEXT NOT NULL,
    tituloo del disco TEXT NOT NULL,
    año lanzamiento del disco INT NOT NULL,
    CONSTRAINT Usuario_temp_pk PRIMARY KEY(nombre de usuario, titulo del disco),
);

CREATE TABLE IF NOT EXISTS Usuario_tiene_temp(
    nombre de usuario TEXT NOT NULL,
    tituloo del disco TEXT NOT NULL,
    año lanzamiento del disco INT NOT NULL,
    año edición INT,
    país de edición TEXT,
    formato TEXT NOT NULL,
    estado TEXT NOT NULL,
    CONSTRAINT Usuario_temp_pk PRIMARY KEY(nombre de usuario, titulo del disco),
)

CREATE TABLE IF NOT EXISTS Usuario_temp(
    Nombre completo TEXT NOT NULL,
    Nombre de usuario TEXT NOT NULL,
    email TEXT NOT NULL,
    contraseña TEXT NOT NULL,
    CONSTRAINT Usuario_temp_pk PRIMARY KEY(Nombre de usuario),
);


\echo 'Tablas temporales creadas. Procedemos a definir las tablas definitivas.'
CREATE TABLE IF NOT EXISTS Disco(
    Título_Disco TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    URL_Portada TEXT,
    Nombre_Grupo TEXT NOT NULL,
    CONSTRAINT Disco_pk PRIMARY KEY(Título_Disco, Año_publicación)
    CONSTRAINT Grupo_fk FOREIGN KEY(Nombre_Grupo) REFERENCES Grupo(Nombre_Grupo)
    ON DELETE CASCADE ON UPDATE CASCADE;
);

CREATE TABLE IF NOT EXISTS Canción(
    Título_Canción TEXT NOT NULL,
    Duración TIME,
    Título_Disco TEXT NOT NULL,
    CONSTRAINT Canción_pk PRIMARY KEY(Título_Canción)
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco) REFERENCES Disco(Título_Disco)
);

CREATE TABLE IF NOT EXISTS Géneros_Disco(
    Nombre_Género TEXT NOT NULL,
    Título_Disco TEXT NOT NULL,
    Año_publicación INT NOT NULL,  
    CONSTRAINT Géneros_Disco_pk PRIMARY KEY(Nombre_Género),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Grupo(
    Nombre_Grupo TEXT NOT NULL,
    URL_Imagen TEXT, NOT NULL,
    CONSTRAINT Grupo_pk PRIMARY KEY(Nombre_Grupo)
);

CREATE TABLE IF NOT EXISTS Desea(
    Nombre_Usuario TEXT NOT NULL,
    Título_Disco TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    CONSTRAINT Desea_pk PRIMARY KEY(Nombre_Usuario, Título_Disco, Año_publicación),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación),
);

CREATE TABLE IF NOT EXISTS Tiene(
    Estado TEXT NOT NULL,
    Nombre_Usuario TEXT NOT NULL,
    Título_Disco TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    CONSTRAINT Tiene PRIMARY KEY(Nombre_Usuario, Título_Disco, Año_publicación),
    CONSTRAINT Usuario_fk FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario), 
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación), 
);

CREATE TABLE IF NOT EXISTS Usuario(
    Nombre_Usuario TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Contraseña TEXT NOT NULL,
    Email TEXT NOT NULL,
    CONSTRAINT Usuario_pk PRIMARY KEY(Nombre_Usuario)
);

CREATE TABLE IF NOT EXISTS Ediciones(
    Formato TEXT NOT NULL,    
    País TEXT NOT NULL,
    Año_Edición INT NOT NULL,
    Título_Disco TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    CONSTRAINT Ediciones_pk PRIMARY KEY(Formato, Año_Edición, País),
    CONSTRAINT Disco_fk FOREIGN KEY(Título_Disco, Año_publicación) REFERENCES Disco(Título_Disco, Año_publicación)
);

\echo 'Tablas creadas. Procedemos a unirlas.'
INSERT INTO Disco(Título_Disco, Año_publicación, URL_Portada, Nombre_Grupo)
SELECT DISTINCT "Nombre del disco", "fecha de lanzamiento", "url portada", "Nombre del grupo"
FROM Disco_temp;

INSERT INTO Canción(Título_Canción, Duración, Título_Disco)
SELECT DISTINCT "Título de la Canción", duración, Canción_temp."Nombre del disco"
FROM Canción_temp JOIN Disco_temp ON Canción_temp."Nombre del disco" = Disco_temp."Nombre del disco";

INSERT INTO Géneros_Disco(Nombre_Género, Título_Disco, Año_publicación)
SELECT DISTINCT "géneros", "Nombre del disco", "fecha de lanzamiento"
FROM Disco_temp;

INSERT INTO Grupo(Nombre_Grupo, URL_Imagen)
SELECT DISTINCT "Nombre del grupo", "url del grupo"
FROM Disco_temp;

INSERT INTO Desea(Nombre_Usuario, Título_Disco, Año_publicación)
SELECT DISTINCT "nombre de usuario", "tituloo del disco", "año lanzamiento del disco"
FROM Usuario_quiere_temp;

INSERT INTO Tiene(Nombre_Usuario, Título_Disco, Año_publicación, Año_Edición, País, Formato, Estado)
SELECT DISTINCT "nombre de usuario", "tituloo del disco", "año lanzamiento del disco", "año edición", "país de la edición", "formato", "estado"
FROM Usuario_tiene_temp;

INSERT INTO Usuario(Nombre_Usuario, Nombre, Contraseña, Email)
SELECT DISTINCT "Nombre de usuario", "Nombre completo", "contraseña", "email"
FROM Usuario_temp;

INSERT INTO Ediciones(Formato, País, Año_Edición, Título_Disco, Año_publicación)
SELECT DISTINCT "formato", "país de la edición", "año de la edición", Ediciones_temp."Nombre del disco", Disco_temp."fecha de lanzamiento"
FROM Ediciones_temp JOIN Disco_temp ON Ediciones_temp."Nombre del disco" = Disco_temp."Nombre del disco";

\echo 'Cargando datos.'
\COPY Disco FROM 'Disco.csv' DELIMITER ',' CSV HEADER;
\COPY Canción FROM 'Canciones.csv' DELIMITER ',' CSV HEADER;
\COPY Géneros FROM 'Géneros.csv' DELIMITER ',' CSV HEADER;


ROLLBACK; 
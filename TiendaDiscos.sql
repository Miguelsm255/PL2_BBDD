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
    duración INT, 
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
    país de edición TEXT,ç
    formato TEXT NOT NULL,
    estado TEXT NOT NULL,
    CONSTRAINT Usuario_temp_pk PRIMARY KEY(nombre de usuario, titulo del disco),
)

CREATE TABLE IF NOT EXISTS Usuario_temp(
    Nombre completo TEXT NOT NULL,
    Nombre de usuario TEXT NOT NULL,
    email TEXT NOT NULL,
    contraseña TEXT NOT NULL,
    CONSTRAINT Usuario_temp_pk PRIMARY KEY(nombre de usuario),
);



\echo 'Tablas temporales creadas. Procedemos a definir las tablas definitivas.'
CREATE TABLE IF NOT EXISTS Disco(
    Título TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    URL_Portada TEXT,
    CONSTRAINT Disco_pk PRIMARY KEY(Título, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Canción(
    Título TEXT NOT NULL,
    Duración INT,
    CONSTRAINT Canción_pk PRIMARY KEY(Título)
);

CREATE TABLE IF NOT EXISTS Géneros(
    Nombre_Género TEXT NOT NULL,
    CONSTRAINT Géneros_pk PRIMARY KEY(Nombre_Género)
);

CREATE TABLE IF NOT EXISTS Géneros_Disco(
    Título TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    Nombre_Género TEXT NOT NULL,
    CONSTRAINT Géneros_Disco_pk PRIMARY KEY(Título, Año_publicación, Nombre_Género),
    CONSTRAINT fk_Disco FOREIGN KEY(Título, Año_publicación) REFERENCES Disco(Título, Año_publicación),
    CONSTRAINT fk_Géneros FOREIGN KEY(Nombre_Género) REFERENCES Géneros(Nombre_Género)
);

CREATE TABLE IF NOT EXISTS Grupo(
    Nombre_Grupo TEXT NOT NULL,
    URL_Imagen TEXT,
    CONSTRAINT Grupo_pk PRIMARY KEY(Nombre_Grupo)
);


CREATE TABLE IF NOT EXISTS Desea(
    CONSTRAINT fk_Usuario FOREIGN KEY(Nombre_Usuario) REFERENCES Usuario(Nombre_Usuario),
    CONSTRAINT fk_Disco FOREIGN KEY(Título, Año_publicación) REFERENCES Disco(Título, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Usuario(
    Nombre_Usuario TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Contraseña TEXT NOT NULL,
    Email TEXT NOT NULL,
    CONSTRAINT Usuario_pk PRIMARY KEY(Nombre_Usuario)
);

CREATE TABLE IF NOT EXISTS Ediciones(
    Formato TEXT NOT NULL,    anio           TEXT 

    País TEXT NOT NULL,
    Año_Edición INT NOT NULL,
    Título TEXT NOT NULL,
    CONSTRAINT Ediciones_pk PRIMARY KEY(Formato, Año_Edición),
    CONSTRAINT fk_Disco FOREIGN KEY(Título, Año_publicación) REFERENCES Disco(Título, Año_publicación)
);

\echo 'Cargando datos.'
\COPY Disco FROM 'Disco.csv' DELIMITER ',' CSV HEADER;
\COPY Canción FROM 'Canciones.csv' DELIMITER ',' CSV HEADER;
\COPY Géneros FROM 'Géneros.csv' DELIMITER ',' CSV HEADER;
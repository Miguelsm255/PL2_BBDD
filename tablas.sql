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
    URL_Imagen INT,
    CONSTRAINT Grupo_pk PRIMARY KEY(Nombre_Grupo)
)


CREATE TABLE IF NOT EXISTS Usuario(
    Nombre_Usuario TEXT NOT NULL,
    Nombre TEXT NOT NULL,
    Contraseña TEXT NOT NULL,
    Email TEXT NOT NULL,
    CONSTRAINT Usuario_pk PRIMARY KEY(Nombre_Usuario)
)

CREATE TABLE IF NOT EXISTS Ediciones(
    Formato TEXT NOT NULL,
    País TEXT NOT NULL,
    Año_publicación INT NOT NULL,
    CONSTRAINT 

)


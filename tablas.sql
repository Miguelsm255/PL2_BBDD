CREATE TABLE IF NOT EXISTS Disco(
    Título INT NOT NULL,
    Año_publicación INT NOT NULL,
    URL_Portada TEXT,
    CONSTRAINT Disco_pk PRIMARY KEY(Título, Año_publicación)
);

CREATE TABLE IF NOT EXISTS Canción(
    Título INT NOT NULL,
    Duración INT,
    CONSTRAINT Canción_pk PRIMARY KEY(Título)
);

CREATE TABLE IF NOT EXISTS Géneros(
    Nombre_Género TEXT NOT NULL,
    CONSTRAINT Géneros_pk PRIMARY KEY(Nombre_Género)
);

CREATE TABLE IF NOT EXISTS Géneros_Disco(
    Título INT NOT NULL,
    Año_publicación INT NOT NULL,
    Nombre_Género TEXT NOT NULL,
    CONSTRAINT Géneros_Disco_pk PRIMARY KEY(Título, Año_publicación, Nombre_Género),
    CONSTRAINT fk_Disco FOREIGN KEY(Título, Año_publicación) REFERENCES Disco(Título, Año_publicación),
    CONSTRAINT fk_Géneros FOREIGN KEY(Nombre_Género) REFERENCES Géneros(Nombre_Género)
);


/*Se supone que esto está implementado correctamente, aunque aún tengo que ver cómo se hace lo de los atributos multievaluados*/
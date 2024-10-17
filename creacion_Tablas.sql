    CREATE TABLE IF NO EXISTS Persona(
        DNI CHAR [9] NOT NULL,
        Nombre TEXT UNIQUE,
        Edad INT,
        CONSTRAINT Persona_pk PRIMARY KEY(DNI)
    );






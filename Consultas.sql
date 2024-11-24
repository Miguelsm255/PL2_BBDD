--1.Mostrar los discos que tengan más de 5 canciones. Construir la expresión equivalente en álgebra relacional.

SELECT DISTINCT 
    Disco.Título_Disco, Disco.Año_publicación
FROM Disco 
JOIN Canción 
    ON Disco.Título_Disco = Canción.Título_Disco
    AND Disco.Año_publicación = Canción.Año_publicación
GROUP BY Disco.Título_Disco, Disco.Año_publicación
HAVING COUNT(Canción.Título_Canción) > 5;

--1'.Mostrar los discos que tengan más de 5 canciones. Construir la expresión equivalente en álgebra relacional.

SELECT DISTINCT 
    Disco.Título_Disco, Disco.Año_publicación
FROM Disco 
JOIN Canción 
    ON Disco.Título_Disco = Canción.Título_Disco
    AND Disco.Año_publicación = Canción.Año_publicación
WHERE Disco.Año_publicación != 1
GROUP BY Disco.Título_Disco, Disco.Año_publicación
HAVING COUNT(Canción.Título_Canción) > 5;

--ESTA ES LA MANERA DE SOLVENTAR LAS CONSULTAS CON LOS DATOS NULOS.

--2.Mostrar los vinilos que tiene el usuario Juan García Gómez junto con el título del disco, y el país y año de edición del mismo.

SELECT DISTINCT
    Tiene.Formato, 
    Tiene.País, 
    Tiene.Año_Edición, 
    Tiene.Título_Disco
FROM Tiene
JOIN Usuario ON Tiene.Nombre_Usuario = Usuario.Nombre_Usuario
WHERE Usuario.Nombre = 'Juan García Gómez' AND Tiene.Formato = 'Vinyl';

--3. Disco con mayor duración de la colección. Construir la expresión equivalente en álgebra relacional.

SELECT 
    Disco.Título_Disco, 
    Disco.Año_publicación
FROM Disco
JOIN Canción ON Disco.Título_Disco = Canción.Título_Disco
AND Disco.Año_publicación = Canción.Año_publicación
GROUP BY Disco.Título_Disco, Disco.Año_publicación
HAVING SUM(Canción.Duración) = (
    SELECT 
        MAX(TotalDuración)
    FROM (
        SELECT SUM(Canción.Duración) AS TotalDuración
        FROM Canción
        JOIN Disco ON Canción.Título_Disco = Disco.Título_Disco
        GROUP BY Canción.Título_Disco, Disco.Año_publicación
    ) AS DuracionesTotales
);


--4. De los discos que tiene en su lista de deseos el usuario Juan García Gómez, indicar el nombre de los grupos musicales que los interpretan.

SELECT DISTINCT 
    Grupo.Nombre_Grupo
FROM Desea
JOIN Disco ON Desea.Título_Disco = Disco.Título_Disco
AND Desea.Año_publicación = Disco.Año_publicación
JOIN Grupo ON Disco.Nombre_Grupo = Grupo.Nombre_Grupo
JOIN Usuario ON Desea.Nombre_Usuario = Usuario.Nombre_Usuario
WHERE Usuario.Nombre = 'Juan García Gómez';

--5. Mostrar los discos publicados entre 1970 y 1972 junto con sus ediciones ordenados por el año de publicación. 

SELECT 
    Disco.Título_Disco, 
    Disco.Año_publicación, 
    Ediciones.Formato, 
    Ediciones.País, 
    Ediciones.Año_Edición
FROM Disco
JOIN Ediciones ON Disco.Título_Disco = Ediciones.Título_Disco
AND Disco.Año_publicación = Ediciones.Año_publicación
WHERE Disco.Año_publicación BETWEEN 1970 AND 1972
ORDER BY Disco.Año_publicación;

--5'. Mostrar los discos publicados entre 1970 y 1972 junto con sus ediciones ordenados por el año de publicación. 

SELECT 
    Disco.Título_Disco, 
    Disco.Año_publicación, 
    Ediciones.Formato, 
    Ediciones.País, 
    Ediciones.Año_Edición
FROM Disco
JOIN Ediciones ON Disco.Título_Disco = Ediciones.Título_Disco
AND Disco.Año_publicación = Ediciones.Año_publicación
WHERE Disco.Año_publicación BETWEEN 1970 AND 1972
AND Ediciones.Año_Edición != 1
ORDER BY Disco.Año_publicación;

--ESTA ES LA MANERA DE SOLVENTAR LAS CONSULTAS CON LOS DATOS NULOS.

--6.Listar el nombre de todos los grupos que han publicado discos del género ‘Electronic’. Construir la expresión equivalente en álgebra relacional.

SELECT DISTINCT 
    Grupo.Nombre_Grupo 
FROM Grupo
JOIN Disco ON Grupo.Nombre_Grupo = Disco.Nombre_Grupo
JOIN Géneros_Disco ON Disco.Título_Disco = Géneros_Disco.Título_Disco
AND Disco.Año_publicación = Géneros_Disco.Año_publicación
WHERE Géneros_Disco.Nombre_Género LIKE '%Electronic%';

--7. Lista de discos con la duración total del mismo, editados antes del año 2000.

SELECT 
    Disco.Título_Disco, 
    Disco.Año_publicación, 
    TO_CHAR( 
        SUM(Canción.Duración), 
        'MI:SS'
    ) AS "Duración total del disco."
FROM Disco
JOIN Canción ON Disco.Título_Disco = Canción.Título_Disco
AND Disco.Año_publicación = Canción.Año_publicación
JOIN Ediciones ON Disco.Título_Disco = Ediciones.Título_Disco
WHERE Ediciones.Año_Edición < 2000
GROUP BY Disco.Título_Disco, Disco.Año_publicación
ORDER BY Disco.Año_publicación;

--7'. Lista de discos con la duración total del mismo, editados antes del año 2000.

SELECT 
    Disco.Título_Disco, 
    Disco.Año_publicación, 
    TO_CHAR( 
        SUM(Canción.Duración), 
        'MI:SS'
    ) AS "Duración total del disco."
FROM Disco
JOIN Canción ON Disco.Título_Disco = Canción.Título_Disco
AND Disco.Año_publicación = Canción.Año_publicación
JOIN Ediciones ON Disco.Título_Disco = Ediciones.Título_Disco
WHERE Ediciones.Año_Edición < 2000 
  AND Disco.Año_publicación != 1 
  AND Ediciones.Año_Edición != 1
  AND Canción.Duración IS NOT NULL
GROUP BY Disco.Título_Disco, Disco.Año_publicación
ORDER BY Disco.Año_publicación;

--ESTA ES LA MANERA DE SOLVENTAR LAS CONSULTAS CON LOS DATOS NULOS.

--8. Lista de ediciones de discos deseados por el usuario Lorena Sáez Pérez que tiene el usuario Juan García Gómez.

SELECT DISTINCT 
    e.Título_Disco AS "Título del Disco", 
    e.Año_publicación AS "Año de Publicación",
    e.Año_Edición AS "Año de Edición", 
    e.País AS "País de Edición", 
    e.Formato AS "Formato"
FROM Desea d
JOIN Usuario u1 ON d.Nombre_Usuario = u1.Nombre_Usuario
JOIN Tiene t ON d.Título_Disco = t.Título_Disco 
    AND d.Año_publicación = t.Año_publicación
JOIN Usuario u2 ON t.Nombre_Usuario = u2.Nombre_Usuario
JOIN Ediciones e ON t.Título_Disco = e.Título_Disco 
    AND t.Año_publicación = e.Año_publicación 
    AND t.Año_Edición = e.Año_Edición
    AND t.País = e.País
    AND t.Formato = e.Formato
WHERE u1.Nombre = 'Lorena Sáez Pérez'
  AND u2.Nombre = 'Juan García Gómez';

--9. Lista todas las ediciones de los discos que tiene el usuario Gómez García en un estado NM o M. Construir la expresión equivalente en álgebra relacional.

SELECT DISTINCT 
    Tiene.Formato, 
    Tiene.País, 
    Tiene.Año_Edición, 
    Tiene.Año_publicación,
    Tiene.Título_Disco
FROM Tiene
JOIN Usuario ON Tiene.Nombre_Usuario = Usuario.Nombre_Usuario
WHERE Usuario.Nombre = 'Luis Gómez García' AND Tiene.Estado IN ('NM', 'M');

--10. Listar todos los usuarios junto al número de ediciones que tiene de todos los discos junto al año de lanzamiento de su disco más antiguo, el año de lanzamiento de su disco más nuevo, y el año medio de todos sus discos de su colección.

SELECT 
    Usuario.Nombre, 
    COUNT(Tiene.Título_Disco) AS "Número de ediciones",
    MIN(Disco.Año_publicación) AS "Año de lanzamiento del disco más antiguo",
    MAX(Disco.Año_publicación) AS "Año de lanzamiento del disco más nuevo",
    ROUND(AVG(Disco.Año_publicación), 2) AS "Año medio de lanzamiento de los discos"
FROM Usuario
JOIN Tiene ON Usuario.Nombre_Usuario = Tiene.Nombre_Usuario
JOIN Disco ON Tiene.Título_Disco = Disco.Título_Disco
AND Tiene.Año_publicación = Disco.Año_publicación
GROUP BY Usuario.Nombre;

--10'. Listar todos los usuarios junto al número de ediciones que tiene de todos los discos junto al año de lanzamiento de su disco más antiguo, el año de lanzamiento de su disco más nuevo, y el año medio de todos sus discos de su colección.

SELECT 
    Usuario.Nombre, 
    COUNT(Tiene.Título_Disco) AS "Número de ediciones",
    MIN(Disco.Año_publicación) AS "Año de lanzamiento del disco más antiguo",
    MAX(Disco.Año_publicación) AS "Año de lanzamiento del disco más nuevo",
    ROUND(AVG(Disco.Año_publicación), 2) AS "Año medio de lanzamiento de los discos"
FROM Usuario
JOIN Tiene ON Usuario.Nombre_Usuario = Tiene.Nombre_Usuario
JOIN Disco ON Tiene.Título_Disco = Disco.Título_Disco
AND Tiene.Año_publicación = Disco.Año_publicación
WHERE Disco.Año_publicación != 1
GROUP BY Usuario.Nombre;

--ESTA ES LA MANERA DE SOLVENTAR LAS CONSULTAS CON LOS DATOS NULOS.

--11. Listar el nombre de los grupos que tienen más de 5 ediciones de sus discos en la base de datos.

SELECT DISTINCT 
    Grupo.Nombre_Grupo
FROM Grupo
JOIN Disco ON Grupo.Nombre_Grupo = Disco.Nombre_Grupo
JOIN Ediciones ON Disco.Año_publicación = Ediciones.Año_publicación AND Disco.Título_Disco = Ediciones.Título_Disco
GROUP BY Grupo.Nombre_Grupo
HAVING COUNT(Ediciones.Título_Disco) > 5;

--12. Lista el usuario que más discos, contando todas sus ediciones, tiene en la base de datos.

SELECT 
    Usuario.Nombre, 
    COUNT(Tiene.Título_Disco) AS "Número de discos"
FROM Usuario
JOIN Tiene ON Usuario.Nombre_Usuario = Tiene.Nombre_Usuario
GROUP BY Usuario.Nombre
HAVING COUNT(Tiene.Título_Disco) = (
    SELECT MAX(ContadorDiscos)
    FROM (
        SELECT COUNT(Título_Disco) AS ContadorDiscos
        FROM Tiene
        GROUP BY Nombre_Usuario
    ) AS DiscosMaximos
);
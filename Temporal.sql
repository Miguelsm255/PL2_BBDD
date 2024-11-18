--1.Mostrar los discos que tengan más de 5 canciones. Construir la expresión equivalente en álgebra relacional.

SELECT DISTINCT 
    Disco.Título_Disco, Disco.Año_publicación
FROM Disco 
JOIN Canción 
    ON Disco.Título_Disco = Canción.Título_Disco
    AND Disco.Año_publicación = Canción.Año_publicación
GROUP BY Disco.Título_Disco, Disco.Año_publicación
HAVING COUNT(Canción.Título_Canción) > 5;

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
ORDER BY SUM(EXTRACT(EPOCH FROM Canción.Duración)) DESC
LIMIT 1;

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
        INTERVAL '1 second' * SUM(EXTRACT(EPOCH FROM Canción.Duración)), 
        'MI:SS'
    ) AS "Duración total"
FROM Disco
JOIN Canción ON Disco.Título_Disco = Canción.Título_Disco
AND Disco.Año_publicación = Canción.Año_publicación
JOIN Ediciones ON Disco.Título_Disco = Ediciones.Título_Disco
WHERE Ediciones.Año_Edición < 2000
GROUP BY Disco.Título_Disco, Disco.Año_publicación
ORDER BY Disco.Año_publicación;

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT TITLE AS Titulo, RATING AS r
FROM FILM AS f
WHERE rating  = 'R'

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT	CONCAT(a.FIRST_NAME,' ',a.LAST_NAME) AS Nombre, a.ACTOR_ID AS id
FROM Actor AS a
WHERE a.actor_id BETWEEN 30 AND 40
--250510 CORREGIDO

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title AS TITULO, LANGUAGE_ID AS Idioma
FROM film
WHERE LANGUAGE_ID = ORIGINAL_LANGUAGE_ID
-- No devuelve ningún resultado, porque la columna original_id vale null en todos sus componentes


-- 5. Ordena las películas por duración de forma ascendente.
SELECT title AS TITULO, film.LENGTH AS duracion
FROM film
ORDER BY film.LENGTH 


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT CONCAT(a.FIRST_NAME, ' ',a.LAST_NAME) AS Nombre
FROM ACTOR AS A 
WHERE A.LAST_NAME LIKE '%ALLEN%'


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
SELECT f.rating AS Clasif, COUNT(f.RATING) AS Conteo
FROM film AS f
GROUP BY f.RATING


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
-- La duración está en minutos por lo que tendremos que buscar que sea > 180min
SELECT f.TITLE AS Titulo, f.RATING AS Clasificacion, f.LENGTH AS Duracion
FROM film AS f
WHERE (f.RATING = 'PG-13') OR (f.LENGTH > 180)
--250510 CORREGIDO

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT MIN(f.REPLACEMENT_COST) AS PrecioMinimo, MAX(f.REPLACEMENT_COST) AS PrecioMaximo, 
		MAX(f.REPLACEMENT_COST) - MIN(f.REPLACEMENT_COST) AS DifMaxima
FROM film AS f

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
-- Encuentro la duración minima y máxima total
SELECT MIN(f.LENGTH) AS MenorDuracion, MAX(f.LENGTH) AS MayorDuracion
FROM film AS f

--Encuentro el primer título con la duración mínima que me devuelve
SELECT f.TITLE AS MenorDuracion, f.LENGTH AS duracion
FROM film AS f
ORDER BY f.LENGTH,f.TITLE
LIMIT 1

--Encuentro el primer título con la duración máxima que me devuelve
SELECT f.TITLE AS MenorDuracion, f.LENGTH AS duracion
FROM film AS f
ORDER BY f.LENGTH DESC, f.TITLE
LIMIT 1;





-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
/*VOLVER AQUI*/

-- comprobamos en la tabla rental cual es el id del alquiler solicitado
--SELECT r.rental_id AS RentalID
--FROM rental AS r
--ORDER BY r.RENTAL_DATE DESC
--LIMIT 1
--OFFSET 2;
--Da como resultado rental_id= 11676

-- Hacemos un Left Join de la tabla rental y la tabla payment para obtener el precio de ese alquiler
-- ordenamos por fecha descendiente limitando el resultado a 1 y con un offset de 2 para sacar el antepenultimo
SELECT r.RENTAL_ID AS FilmID, r.RENTAL_DATE AS fecha, p.AMOUNT AS Precio
FROM rental AS r
LEFT JOIN PAYMENT AS P 
ON r.RENTAL_ID = p.RENTAL_ID
ORDER BY fecha DESC
LIMIT 1 
OFFSET 2;
-- El resultado es 0, pero comprobando en la tabla ese es el valor que tengo guardado.


-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC- 17’ ni ‘G’ en cuanto a su clasificación.
SELECT f.TITLE AS Titulo, f.RATING AS Clasificacion
FROM film AS f
WHERE f.RATING NOT IN ('NC-17','G')

SELECT f.TITLE AS Titulo, f.RATING AS Clasificacion
FROM film AS f
WHERE f.RATING <> 'NC-17' AND F.RATING <> 'G'

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
--		y muestra la clasificación junto con el promedio de duración.
SELECT f.RATING AS clasificacion, ROUND(AVG(f.length),2) AS PromedioDuracion
FROM FILM AS f
GROUP BY f.RATING

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT f.TITLE AS Titulo, f.LENGTH AS Duracion
FROM film AS f
WHERE f.LENGTH  > 180
ORDER BY f.LENGTH


-- 15. ¿Cuánto dinero ha generado en total la empresa?
SELECT sum(p.AMOUNT) AS Ingresos
FROM PAYMENT AS P 


-- 16. Muestra los 10 clientes con mayor valor de id.
SELECT concat(c.FIRST_NAME,' ',c.LAST_NAME) AS Nombre, c.CUSTOMER_ID AS ID 
FROM Customer AS c
ORDER BY c.CUSTOMER_ID DESC 
LIMIT 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
-- DOS OPCIONES
-- OPC 1: HACER UN JOIN DE LA TABLA ACTOR Y FILM_ACTOR Y BUSCAR CON UNA SUBCONSULTA EN EL WHERE QUE BUSQUE EN 
--        LA TABLE FILM EL Film_ID de la película buscada

SELECT concat(a.FIRST_NAME,' ',a.LAST_NAME) AS NombreActor, FA.ACTOR_ID AS ActorID, FA.FILM_ID AS FILMID
FROM actor AS a
INNER JOIN FILM_ACTOR AS FA  
ON a.ACTOR_ID  = fa.ACTOR_ID 
WHERE fa.FILM_ID = (SELECT f.film_id AS ID_Peli
					FROM FILM AS f
					WHERE f.TITLE = 'EGG IGBY');

-- OPC 2: HACER DOS JOIN entre actor y film_Actor que relaciona el actor_id con su nombre y apellidos,
--		 para buscar el la tabla film el film_id de la película que participaron los actores
SELECT concat(a.FIRST_NAME,' ',a.LAST_NAME) AS NombreActor, F.TITLE AS TituloPeli
FROM actor AS a
INNER JOIN FILM_ACTOR AS FA  
ON a.ACTOR_ID  = fa.ACTOR_ID 
LEFT JOIN FILM AS f
ON fa.FILM_ID = f.FILM_ID
WHERE f.TITLE = 'EGG IGBY';
--250510 CORREGIDO

-- 18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT(f.TITLE) AS titulo
FROM film AS f
ORDER BY f.TITLE;


-- 19. Encuentra el título de las películas que son comedias y tienen una
--     duración mayor a 180 minutos en la tabla “film”.
SELECT f.TITLE AS Titulo, f.LENGTH AS duracion, c.name AS Categoria
FROM FILM AS f
INNER JOIN FILM_CATEGORY AS FC 
ON f.FILM_ID = fc.FILM_ID
LEFT JOIN CATEGORY AS C 
ON fc.CATEGORY_ID = C.CATEGORY_ID 
WHERE (f.length > 180) AND (c."name"  = 'Comedy')
-- 250510 CORREGIDO


-- 20. Encuentra las categorías de películas que tienen un promedio de
--     duración superior a 110 minutos y muestra el nombre de la categoría
--     junto con el promedio de duración.

SELECT c.name AS Categoria, ROUND(AVG(f.length),2) AS MediaDuracion
FROM Film AS f
INNER JOIN FILM_CATEGORY AS FC 
ON f.FILM_ID = fc.FILM_ID
INNER JOIN CATEGORY AS C 
ON fc.CATEGORY_ID = c.CATEGORY_ID
GROUP BY c.name 
HAVING AVG(f.length) > 110
--250510 CORREGIDO

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(r.RETURN_DATE - r.RENTAL_DATE) AS MediaDuracion
FROM rental AS r
--CORREGIDO 250510

-- 22. Crea una columna con el nombre y apellidos de todos los actores y
--    actrices.
SELECT CONCAT(a.FIRST_NAME,' ',a.LAST_NAME)
FROM ACTOR AS a


-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de
--     forma descendente.
SELECT date_trunc('day',r.RENTAL_DATE) AS dia, COUNT(r.RENTAL_ID) AS n_alquileres
FROM rental AS r
GROUP BY date_trunc('day',r.RENTAL_DATE)
ORDER BY N_ALQUILERES DESC

-- 24. Encuentra las películas con una duración superior al promedio.
SELECT f.TITLE AS Titulo, f.LENGTH AS Duracion
FROM film AS f
WHERE f.LENGTH > (SELECT AVG(tabla.LENGTH)
					FROM film AS tabla)
ORDER BY f.length

-- 25. Averigua el número de alquileres registrados por mes.
SELECT date_trunc('month',r.RENTAL_DATE) AS mes, COUNT(r.RENTAL_ID) AS n_alquileres
FROM rental AS r
GROUP BY date_trunc('month',r.RENTAL_DATE)
ORDER BY N_ALQUILERES DESC


-- 26. Encuentra el promedio, la desviación estándar y varianza del total
--     pagado.
SELECT ROUND(AVG(P.AMOUNT),2) AS MediaPagado, stddev(p.AMOUNT) AS DesviacionStandart, var_samp(p.AMOUNT) AS varianza
FROM payment AS p

-- 27. ¿Qué películas se alquilan por encima del precio medio?
--Miramos cual es el precio medio de los alquilres
SELECT ROUND(AVG(p.amount),2)
FROM payment AS p
-- resultado 4,20

-- Unimos las tablas payment con rental luego con inventory y luego con film para relacionar 
-- el rental_id con el inventory_id que se relaciona con el film_id
SELECT f.title AS Titulo, p.AMOUNT AS PrecioAlquiler
FROM payment AS p
INNER JOIN rental AS r
ON p.RENTAL_ID = r.RENTAL_ID
LEFT JOIN inventory AS i
ON r.INVENTORY_ID = i.INVENTORY_ID
LEFT JOIN film AS f
ON i.FILM_ID = f.FILM_ID  
--Buscamos que el precio de alquiler sea mayor que la media de alquileres
WHERE p.AMOUNT > (SELECT AVG(payment.amount)
				  FROM payment)
--Ordenamos por p.AMOUNT en orden creciente para comprobar que lo hace bien
ORDER BY p.AMOUNT
--250510 CORREGIDO

-- 28. Muestra el id de los actores que hayan participado en más de 40
-- películas.
SELECT fa.ACTOR_ID AS ActorID, COUNT(fa.ACTOR_ID) AS NumPeliculas
FROM film_Actor AS fa
GROUP BY fa.ACTOR_ID
HAVING COUNT(fa.ACTOR_ID) > 40
ORDER BY fa.ACTOR_ID

-- 29. Obtener todas las películas y, si están disponibles en el inventario,
-- mostrar la cantidad disponible.

--Unimos los datos de la tabla Film con los datos de la table inventory por el campo film_id
--Recopilamos los distintos títulos que tenemos y contamos cuantos registros hay para saber la cantidad
SELECT f.TITLE AS Titulo, COUNT(I.INVENTORY_ID) AS CantidadDisponible
FROM Film AS f
LEFT JOIN INVENTORY AS I  
ON f.FILM_ID = I.FILM_ID
GROUP BY f.FILM_ID, f.TITLE
ORDER BY CantidadDisponible DESC;
--250510 CORREGIDO



-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT CONCAT(a.FIRST_NAME,' ',a.last_name) AS NombreActor, COUNT(fa.ACTOR_ID) AS NumPeliculas
FROM film_Actor AS fa
LEFT JOIN actor AS a
ON fa.ACTOR_ID = a.actor_id
GROUP BY a.FIRST_NAME, a.LAST_NAME
ORDER BY NumPeliculas
--250510 CORREGIDO


-- 31. Obtener todas las películas y mostrar los actores que han actuado en
--    ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.TITLE AS TituloPeli,concat(a.first_name,' ',a.last_name) AS NombreActor
FROM Film AS f
FULL JOIN FILM_ACTOR AS FA 
ON f.FILM_ID = fa.FILM_ID
FULL JOIN ACTOR AS A 
ON fa.ACTOR_ID = a.ACTOR_ID
ORDER BY NOMBREACTOR 
--Hay 3 peliculas sin actores 'Drumlie Cyclone', 'Flight lies', 'Slacker Liaisons'

-- 32. Obtener todos los actores y mostrar las películas en las que han
-- actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT CONCAT(a.FIRST_NAME,' ',a.LAST_NAME) AS Nombre, f.TITLE AS TituloPeli
FROM ACTOR AS a
FULL JOIN FILM_ACTOR AS FA 
ON a.ACTOR_ID = fa.ACTOR_ID
FULL JOIN FILM AS F 
ON f.FILM_ID = fa.FILM_ID
ORDER BY TITULOPELI  

-- 33. Obtener todas las películas que tenemos y todos los registros de
-- alquiler.
SELECT f.title AS Titulo, r.RENTAL_ID AS IDAlquiler
FROM film AS f
LEFT JOIN INVENTORY AS I 
ON f.FILM_ID = i.FILM_ID
LEFT JOIN RENTAL AS R 
ON i.INVENTORY_ID = r.INVENTORY_ID
ORDER BY  Titulo


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT C.CUSTOMER_ID AS IDCliente,concat(C.NOMBRE,' ',c.APELLIDO) AS NombreCLiente,SUM(P.AMOUNT) AS TotalGastado
FROM CUSTOMER AS C
LEFT JOIN RENTAL AS R  
ON r.CUSTOMER_ID = c.CUSTOMER_ID
INNER JOIN PAYMENT AS P 
ON R.RENTAL_ID = P.RENTAL_ID 
GROUP BY C.CUSTOMER_ID 
ORDER BY TOTALGASTADO DESC
LIMIT 5
--250510 CORREGIDO

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
--Los datos están en mayúsculas
SELECT *
FROM actor AS a
WHERE a.FIRST_NAME LIKE 'JOHNNY'


-- 36. Renombra la columna “first_name” como Nombre y “last_name” como
-- Apellido.
ALTER TABLE CUSTOMER RENAME COLUMN first_name TO Nombre;
ALTER TABLE CUSTOMER RENAME COLUMN last_name TO Apellido;
--250510 CORREGIDO

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN(a.ACTOR_ID) AS ID_Bajo, MAX(a.ACTOR_ID) AS ID_Alto 
FROM ACTOR AS a
 
	-- id_bajo = 1 //id_alto = 200



-- 38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT COUNT(a.ACTOR_ID) AS NumActores
FROM ACTOR AS a
	-- hay 200



-- 39. Selecciona todos los actores y ordénalos por apellido en orden
--   ascendente.
SELECT *
FROM ACTOR AS a
ORDER BY a.LAST_NAME ASC

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM FILM AS f
ORDER BY f.FILM_ID
LIMIT 5

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
-- mismo nombre. ¿Cuál es el nombre más repetido?
SELECT  a.FIRST_NAME, COUNT(a.ACTOR_ID) AS NumActores --Contamos los actores
FROM ACTOR AS a							
GROUP BY a.FIRST_NAME 					--agrupados por el nombre
ORDER BY NUMACTORES DESC				--y ordenamos según lo contado en descendente para hallar el mas repetido
	--Kenneth, Penelope y Julia se repiten 4 veces


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los
-- realizaron.
SELECT r.RENTAL_ID AS ID_Alquiler, r.RENTAL_DATE AS "Fecha Alquiler", Concat(c.NOMBRE,' ',c.APELLIDO) AS Cliente
FROM RENTAL AS r
INNER JOIN CUSTOMER AS C 
ON r.CUSTOMER_ID = c.CUSTOMER_ID
--250510 CORREGIDO

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo
-- aquellos que no tienen alquileres.
SELECT CONCAT(c.NOMBRE,' ',c.APELLIDO) AS Cliente, c.CUSTOMER_ID AS ID, r.RENTAL_ID AS ID_Alquiler
FROM CUSTOMER AS c
LEFT JOIN RENTAL AS R 
ON c.CUSTOMER_ID = r.CUSTOMER_ID
ORDER BY CLIENTE 


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
-- esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film AS f
CROSS JOIN CATEGORY AS C 
	-- No aporta nada, ya que una película solo puede pertenecer a una categoría en concreto


-- 45. Encuentra los actores que han participado en películas de la categoría
--     'Action'.
SELECT DISTINCT CONCAT(a.first_name,' ',a.LAST_NAME) AS Actor--, f.TITLE  AS Titulo, c."name" AS categoria
FROM ACTOR AS a
INNER JOIN FILM_ACTOR AS FA  	--Unimos la tabla actor con la tabla que guarda las peliculas de cada actor film_Actor
ON a.ACTOR_ID = fa.ACTOR_ID
INNER JOIN FILM AS F 			--unimos con la tabla film
ON fa.FILM_ID = f.FILM_ID
INNER JOIN FILM_CATEGORY AS FC  --que está relacionada con la tabla film_category
ON f.film_ID = fc.FILM_ID
INNER JOIN CATEGORY AS C 		--que se relaciona con la tabla category
ON fc.CATEGORY_ID = c.CATEGORY_ID
WHERE c."name" = 'Action'		--donde buscamos que la categoría sea 'Action'
ORDER BY Actor
 

-- 46. Encuentra todos los actores que no han participado en películas.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Actor
FROM actor AS a
LEFT JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL
ORDER BY Actor
  --Aparentemente TODOS los actores han participado al menos en una película


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las
-- que han participado.

	--Unimos la tabla actor con film_actor a través de actor_id para contar cuantas film_id
	-- tiene cada actor_id registradas
SELECT CONCAT(a.FIRST_NAME,' ',a.LAST_NAME) AS Nombre,COUNT(fa.film_id) AS "Numero Peliculas"
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.ACTOR_ID = fa.ACTOR_ID
GROUP BY a.FIRST_NAME, A.LAST_NAME  
ORDER BY "Numero Peliculas" 
--250510 CORREGIDO

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
-- de los actores y el número de películas en las que han participado.
		--Repetimos la consulta del ejercicio anterior, pero creando una vista 
CREATE VIEW actor_num_peliculas AS
	SELECT CONCAT(a.FIRST_NAME,' ',a.LAST_NAME) AS Nombre,COUNT(fa.film_id) AS "Numero Peliculas"
	FROM actor AS a
	LEFT JOIN film_actor AS fa
	ON a.ACTOR_ID = fa.ACTOR_ID
	GROUP BY a.FIRST_NAME,A.LAST_NAME 
	ORDER BY "Numero Peliculas"
--250510 CORREGIDO


-- 49. Calcula el número total de alquileres realizados por cada cliente.
SELECT CONCAT(c.NOMBRE,' ',c.APELLIDO) AS Cliente, COUNT(r.RENTAL_ID) AS "Numero Alquileres"
FROM customer AS c
INNER JOIN rental AS r
ON C.CUSTOMER_ID = r.CUSTOMER_ID
GROUP BY C.NOMBRE,C.APELLIDO
ORDER BY "Numero Alquileres"
--250510 CORREGIDO

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(f.LENGTH) AS SumaDuraciones	-- Seleccionamos la suma de todas las duraciones
FROM CATEGORY AS C 						-- Unimos la tabla category
INNER JOIN FILM_CATEGORY AS FC 			-- con la tabla film_category
ON c.CATEGORY_ID = fc.CATEGORY_ID		-- para unir la tabla film
LEFT JOIN FILM AS F
ON FC.FILM_ID = F.FILM_ID 
WHERE c."name" = 'Action'				-- donde el nombre de la categoria es 'Action'
	--7143 minutos de películas de 'Action'

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
-- almacenar el total de alquileres por cliente.
WITH cliente_rentas_temporal AS (
	SELECT CONCAT(c.NOMBRE,' ',c.APELLIDO) AS Cliente, COUNT(r.RENTAL_ID) AS "Numero Alquileres"
	FROM customer AS c
	INNER JOIN rental AS r
	ON C.CUSTOMER_ID = r.CUSTOMER_ID
	GROUP BY C.NOMBRE,C.APELLIDO
)

SELECT * 
FROM cliente_rentas_temporal AS temp
ORDER BY "Numero Alquileres"

-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
-- películas que han sido alquiladas al menos 10 veces.
WITH peliculas_alquiladas AS (
	SELECT F.TITLE AS Titulo,COUNT(i.inventory_ID) AS "Numero Alquileres"
	FROM rental AS r
	INNER JOIN INVENTORY AS I 
	ON r.INVENTORY_ID = i.INVENTORY_ID
	LEFT JOIN FILM AS F 
	ON I.FILM_ID = F.FILM_ID
	GROUP BY f.TITLE
)

SELECT *
FROM peliculas_alquiladas AS pa
WHERE "Numero Alquileres" > 10



-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente
-- con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
-- los resultados alfabéticamente por título de película.
SELECT f.title AS Titulo, r.RETURN_DATE
FROM customer AS c
INNER JOIN RENTAL AS R 
ON C.CUSTOMER_ID = R.CUSTOMER_ID
INNER JOIN INVENTORY AS I
ON r.INVENTORY_ID = i.INVENTORY_ID
INNER JOIN film AS f	
ON i.FILM_ID = f.FILM_ID
WHERE c.NOMBRE = 'TAMMY' AND c.APELLIDO = 'SANDERS' AND r.RETURN_DATE IS NULL
ORDER BY TITULO 


-- 54. Encuentra los nombres de los actores que han actuado en al menos una
-- película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
-- alfabéticamente por apellido.
		--Unimos todas las tablas desde actor--film_actor--film--film_category--category
SELECT DISTINCT a.FIRST_NAME AS Nombre, a.LAST_NAME AS Apellido
FROM actor AS a
INNER JOIN FILM_ACTOR AS FA 
ON a.ACTOR_ID = fa.ACTOR_ID
INNER JOIN FILM AS f
ON fa.FILM_ID = f.FILM_ID
INNER JOIN FILM_CATEGORY AS FC 
ON f.FILM_ID = fc.FILM_ID
INNER JOIN CATEGORY AS C 
ON fc.CATEGORY_ID = c.CATEGORY_ID
WHERE c."name" = 'Sci-Fi'
ORDER BY Apellido 
--250510 CORREGIDO

-- 55. Encuentra el nombre y apellido de los actores que han actuado en
-- películas que se alquilaron después de que la película ‘Spartacus
-- Cheaper’ se alquilara por primera vez. Ordena los resultados
-- alfabéticamente por apellido.

--Creamos un CTE para que nos devuelva los id_inventario de las copias de la película
WITH Lista_id_Inventario AS (
	SELECT I.INVENTORY_ID AS ID_INVENTARIO
	FROM INVENTORY AS I
	WHERE I.FILM_ID = ( -- Esta subconsulta obtiene el film_id de la película
						SELECT f.FILM_ID AS ID
						FROM film AS f
						WHERE f.TITLE = 'SPARTACUS CHEAPER'
						)
),
-- Creamos otro CTE que usa el anterior para obtener la primera fecha de alquiler de cualquier copia
PrimeraFechaAlquiler AS (
						SELECT r.RENTAL_DATE AS FechaAlquiler
						FROM Lista_id_Inventario AS lid
						INNER JOIN RENTAL AS R 
						ON lid.id_inventario = r.INVENTORY_ID
						ORDER BY FECHAALQUILER ASC 
						LIMIT 1
),
--Creamos otro CTE para hallar el listado de películas que se alquilaron después de la primera fecha del 
-- CTE PrimeraFechaAlquiler. Aparecen que hay 958 películas que cumplen con esa premisa
ListaPeliculas AS (
					SELECT DISTINCT i.FILM_ID AS IDFILM
					FROM RENTAL AS R 
					INNER JOIN INVENTORY AS I 
					ON R.INVENTORY_ID = I.INVENTORY_ID
					WHERE R.RENTAL_DATE > (	SELECT *
											FROM PrimeraFechaAlquiler
										  )
)
--Ahora que en ListaPeliculas tenemos los film_id de las películas que cumplen nuestros requisitos
-- buscamos a traves de la tabla film_Actor los actores que corresponden al listado de peliculas
-- y con el actor_id que recuperamos buscamos su nombre. Lo ponemos en formato last_name, first_name para que 
-- lo ordenemos de forma natural por el apellido
SELECT DISTINCT a.ACTOR_ID, CONCAT(a.LAST_NAME,', ',a.FIRST_NAME) AS Nombre
FROM ListaPeliculas AS lp
INNER JOIN FILM_ACTOR AS FA 
ON lp.idfilm = FA.FILM_ID 
INNER JOIN ACTOR AS a
ON fa.ACTOR_ID = a.ACTOR_ID
ORDER BY Nombre


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en
-- ninguna película de la categoría ‘Music’.
SELECT DISTINCT(FA.ACTOR_ID) AS ID_Actor, CONCAT(a.FIRST_NAME,' ',a.LAST_NAME) -- Consulta ppal para encontrar aquellos actores que NO han actuado en peliculas
FROM FILM_ACTOR AS FA 					 -- de categoría 'Music'
INNER JOIN ACTOR AS A 				--Unimos con tabla actor para hallar el nombre y apellidos
ON fa.ACTOR_ID = a.ACTOR_ID
WHERE fa.ACTOR_ID NOT IN ( -- Subconsulta para hallar el listado de actores que han actuado el pelis de categoría 'Music'
						SELECT DISTINCT(fa.ACTOR_ID) AS ID_Actor 
						FROM film_actor AS fa
						WHERE fa.film_id IN ( --Subconsulta para hallar las películas de categoría 'Music'
											SELECT fc.FILM_ID AS PeliculaID
											FROM film_category AS fc
											INNER JOIN CATEGORY AS C 
											ON c.CATEGORY_ID = fc.CATEGORY_ID
											WHERE c."name" = 'Music'
											)

						)
ORDER BY ID_Actor
 

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más
-- de 8 días.
SELECT DISTINCT(f.film_ID) AS ID_Pelicula, f.TITLE AS Titulo
FROM rental AS r     --Buscamos en la tabla rental, para sacar el id de inventario
INNER JOIN INVENTORY AS I 
ON r.INVENTORY_ID = i.INVENTORY_ID
INNER JOIN FILM AS F -- con el inventory_id, obtenemos el film_id y obtenemos el título correspondiente
ON i.film_id = f.FILM_ID
WHERE r.return_date - r.rental_date > INTERVAL '8 days' --Ponemos como condición que hayan pasado 8 dias entre las fechas de alquiler
ORDER BY id_pelicula


-- 58. Encuentra el título de todas las películas que son de la misma categoría
-- que ‘Animation’.
SELECT f.FILM_ID AS ID_Pelicula, f.TITLE AS Titulo
FROM category AS c
INNER JOIN film_category AS fc
ON c.CATEGORY_ID = fc.CATEGORY_ID
INNER JOIN film AS f
ON fc.FILM_ID = f.FILM_ID
WHERE c."name" = 'Animation'
ORDER BY ID_PELICULA 


-- 59. Encuentra los nombres de las películas que tienen la misma duración
-- que la película con el título ‘Dancing Fever’. Ordena los resultados
-- alfabéticamente por título de película.

SELECT f.title AS Titulo -- Seleccionamos los títulos de las películas que cumplan nuestra condición
FROM film AS f
WHERE f.length = ( --Realizamos una subconsulta para obtener el valor de la duración de la película 'Dancing Fever'
				SELECT pelis.length AS Duracion
				FROM film AS pelis
				WHERE pelis.title = 'DANCING FEVER'
				)
ORDER BY Titulo


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7
-- películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT Concat(c.NOMBRE,' ',c.APELLIDO) AS Nombre
FROM customer AS c
INNER JOIN rental AS r 
ON c.customer_id = r.customer_id
INNER JOIN inventory AS i 
ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.NOMBRE, c.APELLIDO 
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.apellido ASC;


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y
-- muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c."name" AS categoria, COUNT(r.RENTAL_ID) AS NumAlquileres
FROM RENTAL AS r					-- Desde rental relacionamos las tablas
INNER JOIN INVENTORY AS I 			-- inventory, film, film_category y category
ON r.INVENTORY_ID = i.INVENTORY_ID
INNER JOIN FILM AS F 
ON i.FILM_ID = f.FILM_ID
INNER JOIN FILM_CATEGORY AS FC 
ON f.FILM_ID = fc.FILM_ID			-- para obtener el nombre de las categorías
INNER JOIN CATEGORY AS C 			-- y contar los alquileres agrupando por  las
ON fc.CATEGORY_ID = c.CATEGORY_ID	-- categorías existentes
GROUP BY c."name"



-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT c."name" AS categoria, COUNT(DISTINCT f.FILM_ID) AS NumPeliculas
FROM FILM AS F 							-- DEsde film relacionamos con film_category
INNER JOIN film_category AS fc 			-- y category para obtener los nombre de las
ON f.film_id = fc.film_id				-- categorías y contar las películas que se 
INNER JOIN category AS c 				-- estrenaron en el año 2006
ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name



-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
-- que tenemos.

SELECT CONCAT(s.FIRST_NAME,' ',s.LAST_NAME) AS NombreEmpleado, s2.STORE_ID AS Tienda
FROM staff AS s
CROSS JOIN STORE AS S2 




-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
-- muestra el ID del cliente, su nombre y apellido junto con la cantidad de
-- películas alquiladas.
SELECT r.CUSTOMER_ID AS ID_Cliente, CONCAT(c.NOMBRE,' ',c.APELLIDO) AS Nombre, COUNT(r.RENTAL_ID) AS NumAlquileres
FROM RENTAL AS r
INNER JOIN CUSTOMER AS C 
ON r.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY r.CUSTOMER_ID, CONCAT(c.Nombre, ' ', c.APELLIDO)
ORDER BY ID_CLiente
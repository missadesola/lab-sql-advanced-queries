-- List each pair of actors that have worked together.
CREATE VIEW act1 AS SELECT ac.actor_id AS actor_id, CONCAT(ac.first_name, ' ', ac.last_name) AS actor_1, f.title AS title, f.film_id AS film_id
FROM actor AS ac
JOIN film_actor AS fa
ON fa.actor_id = ac.actor_id
JOIN film AS f
ON f.film_id = fa.film_id;

CREATE VIEW act2 AS SELECT ac.actor_id AS actor_id, CONCAT(ac.first_name, ' ', ac.last_name) AS actor_2, f.title AS title, f.film_id AS film_id
FROM actor AS ac
JOIN film_actor AS fa
ON fa.actor_id = ac.actor_id
JOIN film AS f
ON f.film_id = fa.film_id;

SELECT act1.actor_1, act2.actor_2, act1.title
FROM act1
JOIN act2
ON act1.film_id = act2.film_id
AND act1.actor_id <> act2.actor_id;


-- For each film, list actor that has acted in more films.
CREATE VIEW scene1 AS SELECT f.title AS title, CONCAT(ac.first_name, ' ', ac.last_name) AS actors, ac.actor_id AS actor_id
FROM film AS f
JOIN film_actor AS fa
ON fa.film_id = f.film_id
JOIN actor AS ac
ON ac.actor_id = fa.actor_id;

CREATE VIEW scene2 AS SELECT fa.actor_id AS actor_id, COUNT(fa.film_id) AS count
FROM film_actor AS fa
GROUP BY actor_id;

SELECT *
FROM (
	SELECT scene1.title, scene1.actors, scene2.count, ROW_NUMBER() OVER (PARTITION BY scene1.title ORDER BY scene2.count DESC) AS ranks
	FROM scene1
	JOIN scene2
	ON scene1.actor_id = scene2.actor_id
	ORDER BY scene1.title) AS sub_query1
WHERE ranks = 1;
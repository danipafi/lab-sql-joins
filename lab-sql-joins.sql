-- 1. List the number of films per category.
USE sakila;
SELECT c.name, COUNT(f.film_id)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
GROUP BY c.name;

-- 2. Retrieve the store ID, city, and country for each store.
SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id;

-- 3. Calculate the total revenue generated by each store in dollars.
SELECT s.store_id, SUM(p.amount)
FROM store s
JOIN inventory i
ON s.store_id = i.store_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY s.store_id;

-- 4. Determine the average running time of films for each category.
SELECT c.name, AVG(f.length)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
GROUP BY c.name;

-- 5. Identify the film categories with the longest average running time.
SELECT c.name, AVG(f.length)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
GROUP BY c.name
ORDER BY AVG(f.length) DESC;

-- 6. Display the top 10 most frequently rented movies in descending order.

SELECT film.title, COUNT(rental.rental_id) AS frequency
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY frequency DESC
LIMIT 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT f.title, s.store_id 
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
JOIN store s
ON s.store_id = i.store_id
WHERE f.title = 'ACADEMY DINOSAUR'
AND s.store_id = 1;

-- 8. Provide a list of all distinct film titles, along with their availability status in the inventory. Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL.

SELECT DISTINCT f.title, 
	CASE 
		WHEN r.return_date IS NULL AND i.film_id IS NOT NULL THEN 'NOT Available'
        WHEN r.return_date IS NOT NULL AND i.film_id IS NOT NULL THEN 'Available'
        ELSE 'NOT Available'
	END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id;

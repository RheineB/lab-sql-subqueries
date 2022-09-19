-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;

SELECT f.title, COUNT(i.inventory_id)
FROM film f
JOIN inventory i
ON f.film_id=i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- 2. List all films whose length is longer than the average of all the films.
  
  SELECT f.title, f.length
FROM film as f
WHERE f.length > (SELECT
    avg(f.length)
	FROM film as f)
ORDER BY f.length DESC;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name, a.last_name, f.title
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip';

SELECT first_name, last_name
FROM (SELECT a.first_name, a.last_name, f.title
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip') sub1;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
WHERE c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
	-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

SELECT first_name, last_name, email
FROM (SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada') sub1;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
	-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT COUNT(fa.film_id) AS Films, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
ORDER BY COUNT(fa.film_id) DESC;

SELECT *
FROM (SELECT COUNT(fa.film_id) AS Films, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
ORDER BY COUNT(fa.film_id) DESC) sub1;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT customer_id, sum(amount) as total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 1;


SELECT c.first_name, c.last_name, f.title
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
JOIN customer as c
ON r.customer_id = c.customer_id
WHERE r.customer_id = (SELECT customer_id
FROM(
SELECT customer_id, sum(amount) as total_amount
FROM payment
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 1) sub1);

-- 8. Customers who spent more than the average payments.
SELECT AVG(amount) FROM payment;

SELECT AVG(p.amount), c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING AVG(p.amount) > (SELECT AVG(amount) FROM payment)
ORDER BY AVG(p.amount) DESC;
-- sql homework

use sakila;

-- 1a. display the actors first and last names
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
select concat(first_name, " ", last_name) as ActorName
from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name 
from actor
where first_name like "Joe";

-- 2b. Find all actors whose last name contain the letters GEN
select * from actor
where last_name like ("%GEN%");

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
select last_name, first_name from actor
where last_name like ("%LI%")
order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor
add column description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as countofactors
from actor 
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as countname 
from actor 
group by last_name
having countname >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" AND last_name = "WILLIAMS";

select * 
from actor
where first_name = "HARPO";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = "GROUCHO"
where first_name = "HARPO";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from staff;
select * from address;

select staff.first_name, staff.last_name, address.address, address.address2, address.city_id, address.postal_code
from staff
join address on staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select * from staff;
select * from payment;
 
select sum(payment.amount) as totalpaid, staff.first_name, staff.last_name
from payment
left join staff
on payment.staff_id=staff.staff_id
where payment.payment_date like '2005-08-%'
group by staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select film.title, count(film_actor.actor_id)  as actorcount
from film
inner join film_actor on film.film_id=film_actor.film_id
group by film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film;

select film.title, count(inventory.film_id) as countoffilm
from film
join inventory
on inventory.film_id = film.film_id
group by film.title
having film.title = 'Hunchback Impossible'
;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;

select sum(payment.amount) as totalpaid, customer.first_name, customer.last_name
from customer
join payment
on customer.customer_id=payment.customer_id
group by customer.customer_id
order by customer.last_name ;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from language;
select * from film;

select title
from film
where (title like 'K%' or title like 'Q%')
and language_id in (
		select language_id
		from language
		where name = 'English'
        );

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) as ActorName
from actor
where actor_id in (
    select actor_id 
	from film_actor
	where film_id in (	
		select film_id 
		from film
		where title = 'Alone Trip'
        )
	);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from customer;
select * from country;
select * from address;
select * from city;

select customer.first_name, customer.last_name, customer.email
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id=city.city_id
join country
on city.country_id = country.country_id
where country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film
where film_id in (	
    select film_id
	from film_category
	where category_id in (
		select category_id 
		from category
		where name = 'Family'
        )
	)
;

-- 7e. Display the most frequently rented movies in descending order.
select count(rental.inventory_id) as TimesRented, film.title, inventory.inventory_id
from rental
join inventory
on inventory.inventory_id=rental.inventory_id
join film
on inventory.film_id=film.film_id
group by inventory_id
order by TimesRented DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from payment;
select * from staff;

select sum(payment.amount) as 'Total Sold ($)', store.store_id as 'Store Number'
from payment
join staff
on staff.staff_id = payment.staff_id
join store
on staff.store_id = store.store_id
group by store.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from country;
select * from city;
select * from address;

select store.store_id, city.city, country.country
from store
join address
on store.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on country.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select sum(payment.rental_id) as GrossRevenue, category.name
from category
join film_category
on category.category_id=film_category.category_id
join inventory 
on film_category.film_id = inventory.film_id
join rental
on inventory.inventory_id = rental.inventory_id
join payment
on rental.rental_id = payment.rental_id
group by category.category_id
order by GrossRevenue DESC
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view `Top 5 Grossing Genres` as
select sum(payment.rental_id) as GrossRevenue, category.name
from category
join film_category
on category.category_id=film_category.category_id
join inventory 
on film_category.film_id = inventory.film_id
join rental
on inventory.inventory_id = rental.inventory_id
join payment
on rental.rental_id = payment.rental_id
group by category.category_id
order by GrossRevenue DESC
limit 5;

-- 8b. How would you display the view that you created in 8a?
 select * from `top 5 grossing genres`;
 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view `top 5 grossing genres`;

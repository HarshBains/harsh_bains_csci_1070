-- Q1:
select *
from customer
where first_name LIKE 'T%'
order by first_name;

-- Q2:
select *
from rental
where return_date between '2005-05-28' and '2005-06-01 23:59:59';

-- Q3:
/* My line of thinking: the 'film' table has a 'film_id' column, where a numerical value denotes what a specific film is. 
The 'inventory' table has a matching 'film_id' column, but also has an 'inventory_id' column. 
The 'rental' table has a 'rental_id' for each movie, as well as a matching 'inventory_id'. 
If we join these tables by matching the common columns, we can count the number of times an inventory or rental id occurs 
in the 'rental' table, thus finding how often a film is rented. To this end, we must use the count() aggregate function, which
finds how many instances exist of the given parameters. We will use rental.rental_id, as this will return how many rentals exist
for the film at hand.
*/
select title, count(rental.rental_id)
from film
left join inventory 
on film.film_id = inventory.film_id
left join rental 
on inventory.inventory_id = rental.inventory_id
group by title -- This line is necessary since we're using an aggregate function in count(), which requires that rows with the same values be grouped into summarized rows.
order by count(rental.rental_id) desc
limit 10;

-- Q4:
-- We can use a similar approach to Q3, joining tables on matching columns to create the required directory.
select customer.customer_id, first_name, last_name, sum(film.rental_rate)
from customer
left join rental 
on customer.customer_id = rental.customer_id
left join inventory 
on rental.inventory_id = inventory.inventory_id
left join film
on inventory.film_id = film.film_id
group by customer.customer_id
order by sum(film.rental_rate);

-- Q5:
-- We can use a similar approach to Q3 and Q4, but I will alias and concatenate columns for linguistic purposes.
select concat(first_name, ' ', last_name) as actor_name, count(film_actor.film_id) as appearances
from actor
left join film_actor 
on actor.actor_id = film_actor.actor_id
left join film 
on film_actor.film_id = film.film_id
where film.release_year = 2006
group by actor.actor_id
order by appearances desc;

-- Q6:

	-- Q4 explain plan:
	explain analyze
	select customer.customer_id, first_name, last_name, sum(film.rental_rate)
	from customer
	left join rental 
	on customer.customer_id = rental.customer_id
	left join inventory 
	on rental.inventory_id = inventory.inventory_id
	left join film
	on inventory.film_id = film.film_id
	group by customer.customer_id
	order by sum(film.rental_rate);

	/* Essentially, the explain analyze command allows us to view exactly how the query is executed at each stage.
	Notably, for this query, the explain plan allows to see the startup cost for the query-- 813.70 ms-- which is
	how long it takes to fetch the first row. Additionally, the explain plan shows us that the sorting method used
	was quicksort, which used 51 kB of memory. This same data is displayed for every step of the process; namely,
	sorting, as explained above, aggregating, joining, sequential scanning (which actually finds the records we
	require), and compilation. */

	-- Q5 explain plan:
	explain analyze
	select concat(first_name, ' ', last_name) as actor_name, count(film_actor.film_id) as appearances
	from actor
	left join film_actor 
	on actor.actor_id = film_actor.actor_id
	left join film 
	on film_actor.film_id = film.film_id
	where film.release_year = '2006'
	group by actor.actor_id
	order by appearances desc;

	/* Like the Q4 explain plan above, here, the explain plan allows to see the startup cost for the query-- 270.61 ms-- which is
	how long it takes to fetch the first row. Additionally, the explain plan shows us that the sorting method used
	was quicksort, which used 34 kB of memory. This same data is displayed for every step of the process; namely,
	sorting, as explained above, aggregating, joining, sequential scanning (which actually finds the records we
	require), and compilation. */

-- Q7:
select category.name as genre, avg(rental_rate) as average_rental_rate
from film
left join film_category 
on film.film_id = film_category.film_id
left join category 
on film_category.category_id = category.category_id
group by genre; 

-- Q8:
select category.name as genre, count(rental.rental_id) as rentals, sum(film.rental_rate) as sales
from film
left join inventory 
on film.film_id = inventory.film_id
left join rental
on inventory.inventory_id = rental.inventory_id
left join film_category 
on film.film_id = film_category.film_id
left join category 
on film_category.category_id = category.category_id
group by category.name
order by rentals desc
limit 5;
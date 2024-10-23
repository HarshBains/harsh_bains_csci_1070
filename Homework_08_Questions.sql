-- Q1:
/* alter table rental
add column status varchar(64); 
Commented because this is a permanent column; running this code again will throw up an error as the column
already exists. */


update rental
set status = case
	when return_date > rental_date + interval '1 day' * (
		select rental_duration 
		from film 
		join inventory 
		on film.film_id = inventory.film_id
		where inventory.inventory_id = rental.inventory_id) then 'Returned Late'
	when return_date < rental_date + interval '1 day' * (
		select rental_duration 
		from film 
		join inventory 
		on film.film_id = inventory.film_id
		where inventory.inventory_id = rental.inventory_id) then 'Returned Early'
	else 'Returned On Time' end;


-- Q2:
select sum(payment.amount)
from payment
inner join customer 
on customer.customer_id = payment.customer_id
inner join address 
on address.address_id = customer.address_id
inner join city 
on city.city_id = address.city_id
where city.city in ('Saint Louis');


-- Q3:
select category.name, count(film.film_id)
from film
inner join film_category 
on film.film_id = film_category.film_id
inner join category 
on film_category.category_id = category.category_id
group by category.name;


-- Q4:

/* While category contains the names of categories as well as their ID, film_category relates the category ID to
a specific film ID, allowing the category table and film table to be connected; in other words, the film_category
is the bridge connecting a film and its category, as the name would suggest. */


-- Q5:
select film.film_id, film.title, film.length
from rental
inner join inventory 
on rental.inventory_id = inventory.inventory_id
inner join film 
on inventory.film_id = film.film_id
where rental.return_date between '2005-05-15' and '2005-05-31';


-- Q6:
select film.film_id, film.title, film.rental_rate
from film
where film.rental_rate < (select avg(film.rental_rate) from film); -- This is a subquery as one of the conditions
-- is a query, in and of itself. As the question says, we could've also used a join here, but I've inner joined
-- too much, recently :)


-- Q7:
select status, count(*)
from rental
group by status;


-- Q8: 
select film.title, film.length, percent_rank() over (order by film.length) as percentile
from film; -- I opted to use the percent_rank() function instead of dense_rank() as I found it a little easier.


-- Q9:
	-- Query 1:
explain analyze
select status, count(*)
from rental
group by status;

/* The query above performs a sequential scan of the rental table, aiming to perform an aggregate function on the
entries meeting our condition. The group key is stated to be status, but since there is only one batch of grouping
needed, the search only ended up using 24 kB of memory, taking about 2.1 ms to execute. */

	-- Query 2:
explain analyze
select film.film_id, film.title, film.rental_rate
from film
where film.rental_rate < (select avg(film.rental_rate) from film);

/* This is a more complicated query, as one of the conditional statements is a subquery. The preliminary 
sequential scan on the film table took a little bit, as there were about 659 rows removed by our filter.
Interestingly, it seems as though the subquery is treated by SQL as "InitPlan 1," which itself has an aggregate
function that required a sequential scan looping through 1000 rows. Ultimately, this took about 0.182 ms to 
execute. Although both queries share a sequential scan, they differ in execution, as one is a nested query. */


-- EC:

-- I am unsure what relationship is incorrect in the data model; could you explain? I am interested to know the 
-- flaws in the data.

/* Set-based programming is exemplified by SQL, and involves by performing large operations on datasets all at 
once. It treats data in large batches instead of individual, chronological entries. Of course, this can be seen
when executing a SQL query, as what is returned is a filtered set of data.
Conversely, procedural programming, exemplified by Python, works instead on a chronological basis; code executes
one after another. Unlike SQL queries which have a hierarchy in keyword execution, procedural programming executes
top-down, resulting in a myriad of granular data manipulations. */











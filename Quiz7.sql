-- Q1
select * 
from payment
where amount >= 9.99;

-- Q2
select max(amount)
from payment;

-- Q3
select first_name, last_name, email, address, city, country
from staff
left join address 
on staff.address_id = address.address_id
left join city
on address.city_id = city.city_id
left join country
on city.country_id = country.country_id

/* Q4:

I have been interested in becoming a laywer for as long as I can remember; dually, however, I have always had a passion for
computers and technology, as I grew up on video games and they are my favorite form of media. Thus, I wanted to find a way to
marry these two vastly different passions somehow, and I eventually landed on the possibility of becoming an intellectual 
property attorney specializing in the digital realm. I am hoping to graduate with a computer science degree and enter law school,
but time will tell if this comes to fruition! */

/* Extra Credit:

Crow's Foot notation is a way of visualizing how different elements (tables) of a database connect; for our purposes, in the 
dvdrental database, there is a "one and only one" mark denoting how the 'rental' table connects to the 'customer' table. 
This essentially means that for a specific 'rental' entry, there is only one corresponding 'customer' entry; this makes
sense, as a specific item can only be rented by one customer at a time. However, there is a "zero or one" mark denoting how
the 'customer' table connects back to the 'rental' table. This makes sense, as a customer can choose to rent nothing; however,
if they do, they can only rent a maximum of one specific item.



--Question 1:
select product_code, product_name, list_price, discount_percent
from products
order by list_price desc;

--Question 2:
select last_name ||', '|| first_name as "full_name"
from customers
where last_name like 'E%' or last_name like 'G%' or last_name like 'H%'
order by last_name;

--Question 3:
select product_name, list_price, date_added
from products
where list_price between 500 and 2000
order by date_added desc;

--Question 4:
select product_name, list_price, discount_percent, (list_price * discount_percent/100) as "discount_amount", (list_price - (list_price * discount_percent/100)) as "discount_price"
from products
where rownum <= 5
order by (list_price - (list_price * discount_percent/100)) desc;

--Question 5:
select item_id, item_price, discount_amount, quantity, (item_price * quantity) as "price_total", (discount_amount * quantity) as "discount_total", ((item_price - discount_amount) * quantity) as "item_total"
from order_items
where item_total > 500
order by ((item_price - discount_amount) * quantity) desc;

--Question 6:
select order_id, order_date, ship_date
from orders 
where ship_date is null;

--Question 7:
select sysdate as "today_unformatted", to_char(sysdate, 'MM/DD/YYYY') as "today_formatted"
from dual;

--Question 8:
select 100 as "price", 0.07 as "tax_rate", (100 * 0.07) as "tax_amount", (100 + (100 * 0.07)) as "total"
from dual;

--Question 9:
select category_name, product_name, list_price
from categories c join products p
on c.category_id = p.category_id
order by c.category_name, p.product_name asc;

--Question 10:
select first_name, last_name, line1, city, state, zip_code
from customers c join addresses a
    on c.customer_id = a.customer_id
where c.email_address = 'allan.sherwood@yahoo.com';

--Question 11:
select first_name, last_name, line1, city, state, zip_code
from customers c join addresses a 
    on c.shipping_address_id = a.address_id;

--Question 12:
select last_name, first_name, order_date, product_name, item_price, discount_amount, quantity
from customers c
    join orders o 
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
    join products p 
        on oi.product_id = p.product_id
order by last_name, order_date, product_name;

--Question 14:
select c.category_name, p.product_id
from categories c full outer join products p
    on c.category_id = p.category_id
where p.product_id is null;

--Question 15:
select 'SHIPPED' as "ship_status", order_id, order_date
from orders
where ship_date is not null
    union
select 'NOT SHIPPED' as "ship_status", order_id, order_date
from orders
where ship_date is null
order by "ship_status" desc, order_date







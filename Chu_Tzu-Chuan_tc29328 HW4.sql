--Question 1:
select count(order_id), sum(tax_amount)
from orders;

--Question 2:
select c.category_name, count(p.product_id), max(p.list_price)
from products p 
    join categories c
        on p.category_id = c.category_id
group by category_name;

--Question 3:
select c.category_name, count(p.product_id), max(p.list_price), round(avg(list_price),2) as average_price
from products p 
    join categories c
        on p.category_id = c.category_id
group by c.category_name;

--Question 4:
select email_address, sum(item_price * quantity) as item_price_total, sum(discount_amount * quantity) as discount_total
from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
group by email_address
order by item_price_total desc;

--Question 5:
select email_address, count(o.order_id), sum((item_price - discount_amount) * quantity) as total_amount
from customers c 
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
group by c.email_address
having count(o.order_id) > 1
order by total_amount desc;

--Question 6:
select email_address, count(o.order_id), sum((item_price - discount_amount) * quantity) as total_amount
from customers c 
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
where item_price > 400
group by c.email_address
having count(o.order_id) > 1
order by total_amount desc;

--Question 7:
select product_name, sum((item_price - discount_amount) * quantity) as total_amount
from products p
    join order_items oi
        on p.product_id = oi.product_id
group by rollup(product_name);

--Question 8:
select c.email_address, count(distinct oi.product_id)
from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
group by c.email_address
having count(distinct oi.product_id) > 1;

--Question 9:
select category_name
from categories
where category_id in
    (select distinct category_id
    from products)
order by category_name;
        
--Question 10:
select product_name, list_price
from products
where list_price > 
    (select avg(list_price)
    from products)
order by list_price desc;

--Question 11:
select c.category_name
from categories c
where not exists
    (select *
    from products p
    where p.category_id = c.category_id);

--Question 12****************:
select email_address, oi.order_id, sum((item_price - discount_amount) * quantity) as order_total
from order_items oi
    join orders o
        on oi.order_id = o.order_id
    join customers c
        on c.customer_id = o.customer_id
group by email_address, oi.order_id;

select email_address, max(order_total)
from
    (select email_address, oi.order_id, sum((item_price - discount_amount) * quantity) as order_total
    from order_items oi
        join orders o
            on oi.order_id = o.order_id
        join customers c
            on c.customer_id = o.customer_id
    group by email_address, oi.order_id)
group by email_address;

--Question 13:
select product_name, discount_percent
from products
where discount_percent in
    (select distinct discount_percent
    from products
    having count(discount_percent) = 1
    group by discount_percent)
order by product_name;

--Question 14:
select email_address, order_date
from customers c 
    join
        (select customer_id, min(order_date) as order_date
        from orders
        group by customer_id) sub
            on c.customer_id = sub.customer_id
    




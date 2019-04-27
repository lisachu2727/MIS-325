--Question 1:
select sysdate, to_char(sysdate, 'DD-MON-YY HH:MI:SS') as sysdate_with_time, to_char(sysdate, 'DayMonthDD, YYYY HH24:MI:SS AM') as full_date, to_char(sysdate, 'Dy Mon DD, YY HH:MI:SS AM') as abbreviated_full_date, to_char(sysdate, 'MM/DD/YY HH:MI') as date_in_numbers, to_char(sysdate, 'DDMMYY HHMMSS') as date_time_without_separators
from dual;

--Question 2:
select product_id, product_name, to_char(list_price, '$999,999.99') as formatted_price, to_char(date_added, 'Mon DD, YYYY') as formatted_date_added
from products
order by product_id;

--Question 3:
select distinct(upper(card_type)) as card_types
from orders;

--Question 4:
select list_price, discount_percent, round(list_price * (discount_percent/100), 2) as discount_amount
from products;

--Question 5:
select order_id, order_date, (order_date + 2) as approx_ship_date, ship_date, round(ship_date - order_date) as days_to_ship
from orders
where order_date >= '01-MAR-12'
    and order_date < '01-APR-12';
    
--Question 6:
select order_id, order_date, (order_date + 2) as approx_ship_date, ship_date, round(ship_date - order_date) as days_to_ship,
nvl(to_char(ship_date), 'Not shipped yet') as ship_date,
nvl(to_char((round(ship_date - order_date))), ' ') as days_to_ship
from orders
where order_date >= '01-MAR-12'
    and order_date < '01-APR-12';
    
--Question 7:
select card_number, length(card_number) as card_number_length, substr(card_number, -4) as last_four_digits, concat('XXXX-XXXX-XXXX-',substr(card_number, -4)) as card_number_hidden
from orders;

--Question 8:
select product_id, product_name, substr(product_name, 1, instr(product_name, ' ') - 1) as brand, substr(product_name, instr(product_name, ' ') + 1) as instrument
from products;

--Question 9:
select c.customer_id, first_name ||' '|| last_name as customer_name, sum(quantity) as products_purchased,
    case sum(quantity)
        when 1 then 'Bronze Member'
        when 2 then 'Silver Member'
        when 3 then 'Gold Member'
    end as shopper_tier
from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
group by c.customer_id, first_name ||' '|| last_name;

--Question 10:
select email_address, to_char(sum((item_price - discount_amount) * quantity), '$999,999') as revenue, rank() over (order by sum((item_price - discount_amount) * quantity) desc) as revenue_rank
from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi. order_id
group by email_address

--Question 1:
create view customer_addresses as

select c.customer_id, email_address, last_name, first_name,
    a_bill.line1 as bill_line1, a_bill.line2 as bill_line2,
    a_bill.city as bill_city, a_bill.state as bill_state,
    a_bill.zip_code as bill_zip, a_ship.line1 as ship_line1, 
    a_ship.line2 as ship_line2, a_ship.city as ship_city,
    a_ship.state as ship_state, a_ship.zip_code as ship_zip
from customers c
    join addresses a_ship
        on c.shipping_address_id = a_ship.address_id
    join addresses a_bill
        on c.billing_address_id = a_bill.address_id
order by last_name, first_name;

--Question 2:
select customer_id, last_name, first_name, bill_line1
from customer_addresses;

--Question 3:
create view order_item_products as 

select o.order_id, order_date, tax_amount, ship_date,
    item_price, discount_amount, (item_price - discount_amount) as final_price,
    quantity, ((item_price - discount_amount) * quantity) as item_total,
    product_name
from orders o
    join order_items oi
        on o.order_id = oi.order_id
    join products p
        on oi.product_id = p.product_id;
        
--Question 4:
create view product_summary as

select product_name, sum(quantity) as order_count, sum(final_price) as order_total
from order_item_products 
group by product_name;

--Question 5:
select *
from (select *
    from product_summary
    order by order_total desc)
where rownum < 6;

--Question 6:
create sequence user_id_seq;
create sequence download_id_seq;

CREATE TABLE users (
  user_id       NUMBER        default USER_ID_SEQ.nextval PRIMARY KEY,
  email_address VARCHAR2(100) UNIQUE,
  first_name    VARCHAR2(45)  NOT NULL,
  last_name     VARCHAR2(45)  NOT NULL
);

CREATE TABLE downloads (
  download_id   NUMBER       default DOWNLOAD_ID_SEQ.nextval PRIMARY KEY,
  user_id       NUMBER       NOT NULL,
  download_date DATE         NOT NULL,
  filename      VARCHAR2(50) NOT NULL,
  product_id    NUMBER       NOT NULL,
  CONSTRAINT fk_downloads_users
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
);

insert into users (email_address, first_name, last_name)
values ('email_one@gmail.com', 'first', 'first');

insert into users (email_address, first_name, last_name)
values ('email_two@gmail.com', 'second', 'second');

insert into downloads (user_id, download_date, filename, product_id)
values (1, '22-MAY-2019', 'file1', 1);

insert into downloads (user_id, download_date, filename, product_id)
values (2, '22-MAY-2019', 'file2', 2);

--Question 7:
SET SERVEROUTPUT ON;

declare 
    count_of_products      number;
begin
    select count(*)
    into count_of_products
    from products;
    
    if count_of_products >= 7
    then
        dbms_output.put_line('The number of products is greater than or equal to 7.');
    else
        dbms_output.put_line('The number of products is less than 7.');
    end if;
end;
/

--Question 8:
declare
    count_of_products       number;
    avg_list_price          number;
begin 
    select count(*), avg(list_price)
    into count_of_products, avg_list_price
    from products;
    
    if count_of_products >= 7
    then
        dbms_output.put_line('Product count: ' || count_of_products);
        dbms_output.put_line('Average list price: ' || avg_list_price);
    else
        dbms_output.put_line('The number of products is less than 7.');
    end if;
end;
/

--Question 9:
declare
    cursor products_cursor is
       select product_name, list_price
       from products
       where list_price > 700
       order by list_price desc;
    
    product_list        varchar(1000);
begin
    for products in products_cursor
    loop
        product_list := product_list || '"' || products.product_name || '",';
        product_list := product_list || '"' || products.list_price || '"';
        product_list := product_list || '|';
    end loop;   
    dbms_output.put_line(product_list);
end;
/

--Question 10:
begin
    insert into categories (category_name, category_id)
    values ('Guitars', 5);
    
    dbms_output.put_line('1 row was inserted.');
exception
    when dup_val_on_index 
    then
        dbms_output.put_line('You attempted to insert a duplicate value.');
end;
/
    

        
    
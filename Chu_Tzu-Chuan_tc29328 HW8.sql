drop table customer_dw;

--data warehouse table for customer tables
create table customer_DW
(
    data_source         varchar2(300),
    customer_id         number,
    first_name          varchar2(300),
    last_name           varchar2(300),
    shipping_address    varchar2(300),
    customer_city       varchar2(300),
    customer_state      varchar2(300),
    customer_zip        varchar2(300),
    customer_phone      varchar2(300),
    
    constraint source_id_pk primary key(data_source, customer_id)
);

--views of customers tables to format
create or replace view customers_ex_view as
    select 'EX' as data_source, customer_id, customer_first_name, customer_last_name, customer_address, customer_city, customer_state,
        customer_zip, replace(replace(replace(customer_phone, '(', ''),')',''), ' ', '-') as customer_phone
    from customers_ex;
    
create or replace view customers_om_view as
    select 'OM' as data_source, customer_id, customer_first_name, customer_last_name, customer_address, customer_city, customer_state, 
        customer_zip, substr(customer_phone, 1, 3) || '-' || substr(customer_phone, 4, 3) || '-' || substr(customer_phone, 7, 4) as customer_phone
    from customers_om;
    
create or replace view customers_mgs_view as
    select 'MGS' as data_source, c.customer_id, first_name as customer_first_name, last_name as customer_last_name, line1 || ' ' || line2 as customer_address,
        city as customer_city, state as customer_state, zip_code as customer_zip, phone as customer_phone
    from customers_mgs c
        join addresses a
            on c.customer_id = a.customer_id and
               c.shipping_address_id = a.address_id;

--procedure that inserts data and updates data warehouse
create or replace procedure customer_etl_proc
as
begin
    insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
    (
        select cov.data_source, cov.customer_id, cov.customer_first_name, cov.customer_last_name, cov.customer_address, cov.customer_city, cov.customer_state,
           cov.customer_zip, cov.customer_phone 
        from customers_om_view cov
            left join customer_dw dw
            on cov.data_source = dw.data_source and
                cov.customer_id = dw.customer_id
        where dw.data_source is null and dw.customer_id is null
    );

    insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
    (
        select cev.data_source, cev.customer_id, cev.customer_first_name, cev.customer_last_name, cev.customer_address, cev.customer_city, cev.customer_state,
            cev.customer_zip, cev.customer_phone 
        from customers_ex_view cev
            left join customer_dw dw
            on cev.data_source = dw.data_source and
                cev.customer_id = dw.customer_id 
        where dw.data_source is null and dw.customer_id is null
    );

    insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
    (
        select cmv.data_source, cmv.customer_id, cmv.customer_first_name, cmv.customer_last_name, cmv.customer_address, cmv.customer_city, cmv.customer_state,
            cmv.customer_zip, cmv.customer_phone
        from customers_mgs_view cmv
            left join customer_dw dw
            on cmv.data_source = dw.data_source and
                cmv.customer_id = dw.customer_id
    where dw.data_source is null and dw.customer_id is null
    );
    
    merge into customer_dw dw
    using customers_ex_view cev
    on (dw.data_source = cev.data_source and
       dw.customer_id = cev.customer_id)
    when matched then
       update set dw.first_name = cev.customer_first_name, dw.last_name = cev.customer_last_name, dw.shipping_address = cev.customer_address,
                  dw.customer_city = cev.customer_city, dw.customer_state = cev.customer_state, dw.customer_zip = cev.customer_zip,
                  dw.customer_phone = cev.customer_phone;
                  
    merge into customer_dw dw
    using customers_mgs_view cmv
    on (dw.data_source = cmv.data_source and
       dw.customer_id = cmv.customer_id)
    when matched then
       update set dw.first_name = cmv.customer_first_name, dw.last_name = cmv.customer_last_name, dw.shipping_address = cmv.customer_address,
                  dw.customer_city = cmv.customer_city, dw.customer_state = cmv.customer_state, dw.customer_zip = cmv.customer_zip,
                  dw.customer_phone = cmv.customer_phone;

    merge into customer_dw dw
    using customers_om_view cov
    on (dw.data_source = cov.data_source and
       dw.customer_id = cov.customer_id)
    when matched then
       update set dw.first_name = cov.customer_first_name, dw.last_name = cov.customer_last_name, dw.shipping_address = cov.customer_address,
                  dw.customer_city = cov.customer_city, dw.customer_state = cov.customer_state, dw.customer_zip = cov.customer_zip,
                  dw.customer_phone = cov.customer_phone;
                  
    commit;
    
exception
    when others then
        rollback;
end;
/

call customer_etl_proc();

/* BELOW IS THE CODE FOR JUST THE 3 INSERT STATEMENTS AND UPDATE STATEMENTS

insert data from views that are currently not in data warehouse   

insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
(
    select cov.data_source, cov.customer_id, cov.customer_first_name, cov.customer_last_name, cov.customer_address, cov.customer_city, cov.customer_state,
           cov.customer_zip, cov.customer_phone 
    from customers_om_view cov
        left join customer_dw dw
            on cov.data_source = dw.data_source and
               cov.customer_id = dw.customer_id
where dw.data_source is null and dw.customer_id is null
);

insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
(
select cev.data_source, cev.customer_id, cev.customer_first_name, cev.customer_last_name, cev.customer_address, cev.customer_city, cev.customer_state,
       cev.customer_zip, cev.customer_phone 
from customers_ex_view cev
    left join customer_dw dw
        on cev.data_source = dw.data_source and
           cev.customer_id = dw.customer_id 
where dw.data_source is null and dw.customer_id is null
);

insert into customer_dw (data_source, customer_id, first_name, last_name, shipping_address, customer_city, customer_state, customer_zip, customer_phone)
(
select cmv.data_source, cmv.customer_id, cmv.customer_first_name, cmv.customer_last_name, cmv.customer_address, cmv.customer_city, cmv.customer_state,
       cmv.customer_zip, cmv.customer_phone
from customers_mgs_view cmv
    left join customer_dw dw
        on cmv.data_source = dw.data_source and
           cmv.customer_id = dw.customer_id
where dw.data_source is null and dw.customer_id is null
);


update data warehouse using merge

merge into customer_dw dw
    using customers_ex_view cev
    on (dw.data_source = cev.data_source and
       dw.customer_id = cev.customer_id)
    when matched then
       update set dw.first_name = cev.customer_first_name, dw.last_name = cev.customer_last_name, dw.shipping_address = cev.customer_address,
                  dw.customer_city = cev.customer_city, dw.customer_state = cev.customer_state, dw.customer_zip = cev.customer_zip,
                  dw.customer_phone = cev.customer_phone;
                  
merge into customer_dw dw
    using customers_mgs_view cmv
    on (dw.data_source = cmv.data_source and
       dw.customer_id = cmv.customer_id)
    when matched then
       update set dw.first_name = cmv.customer_first_name, dw.last_name = cmv.customer_last_name, dw.shipping_address = cmv.customer_address,
                  dw.customer_city = cmv.customer_city, dw.customer_state = cmv.customer_state, dw.customer_zip = cmv.customer_zip,
                  dw.customer_phone = cmv.customer_phone;

merge into customer_dw dw
    using customers_om_view cov
    on (dw.data_source = cov.data_source and
       dw.customer_id = cov.customer_id)
    when matched then
       update set dw.first_name = cov.customer_first_name, dw.last_name = cov.customer_last_name, dw.shipping_address = cov.customer_address,
                  dw.customer_city = cov.customer_city, dw.customer_state = cov.customer_state, dw.customer_zip = cov.customer_zip,
                  dw.customer_phone = cov.customer_phone;
*/


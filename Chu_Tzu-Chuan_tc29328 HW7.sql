--Question 1:
create or replace procedure insert_category
(
    category_name_param     varchar2
)
as
begin
    insert into categories
    values (CATEGORY_ID_SEQ.nextval, category_name_param);
    
    commit;
exception
    when others then
        rollback;
end;
/

call insert_category('Flutes');
call insert_category('Saxophones');

--Questions 2:
create or replace procedure insert_products
(
    category_id_param           number,
    product_code_param          varchar2,
    product_name_param          varchar2,
    list_price_param            number,
    discount_percent_param      number
)
as 
begin  
    insert into products
    values (product_id_seq.nextval, category_id_param, product_code_param, product_name_param, ' ', list_price_param,
            discount_percent_param, sysdate);
            
    if list_price_param < 0 then
        dbms_output.put_line('List price cannot be a negative number.');
    end if;
    
    if discount_percent_param < 0 then
        dbms_out.put_line('Discount percent cannot be a negative number.');
    end if;
end;
/
    

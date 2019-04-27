/* drop tables section
Lisa Chu tc29328 */

drop table ordersProducts;
drop table orders;
drop table customerAddresses;
drop table products;
drop table categories;
drop table employees;
drop table customers;

/* create tables section
Lisa Chu tc29328 */

create table customers
(
    customerID          number          not null        primary key,
    email               varchar(50)     not null        unique,
    customerPassword    varchar(50)     not null,
    firstName           varchar(20)     not null,
    lastName            varchar(20)     not null,
    phonePrimary        char(12)        not null,
    phoneSecond         char(12)        
);

--adding password length minimum constraint
alter table customers
    add constraint password_length_check check (length(customerPassword) >= 8);

create table customerAddresses
(
    addressID       number          primary key      not null,
    addressLine1    varchar(50)     not null,
    addressLine2    varchar(20),
    city            char(20)        not null,
    customerState   char(2)         not null,
    zip             char(5)         not null,
    addressStatus   char(1)         default 'A',
                    check (addressStatus in('A','I')),      --check for status to be either active or inactive
    customerID      number          not null,
    constraint      customerAddresses_customerID_FK    foreign key(customerID) references customers(customerID)
);

create table employees
(
    employeeID      number          not null        primary key,
    firstName       varchar(20)     not null,
    lastName        varchar(20)     not null,
    birthday        date,
    taxID           varchar(20)     unique,
    streetName      varchar(20)     not null,
    city            char(20)        not null,
    employeeState   char(2)         not null,
    zip             char(5)         not null
);

create table orders
(
    orderNumber     number          not null        primary key,
    orderDate       date            not null,
    subtotal        number          not null,
                    check (subtotal > 0),   
    taxAmount       number          not null,
                    check (taxAmount > 0),
    invoiceTotal    number          not null,
                    check (invoiceTotal > 0),
                    check (invoiceTotal > subtotal),
    customerID      number          not null,
    employeeID      number          not null,
    constraint      orders_customerIDFK    foreign key(customerID) references customers(customerID),
    constraint      orders_employeeIDFK    foreign key(employeeID) references employees(employeeID)
);

create table categories
(
    categoryID      number          not null        primary key,
    categoryName    varchar(50)     not null        unique,
    categoryDesc    varchar(50)     not null
);

create table products
(
    productID       number          not null        primary key,
    UPCBarcode      varchar(20)     not null        unique,
    productName     varchar(50)     not null        unique,
    productDesc     varchar(50)     not null,
    price           number          not null,
    onHandAmount    number          not null,
    categoryName    varchar(50)     not null,
    constraint  products_categoryName_FK foreign key(categoryName) references categories(categoryName)
);

create table ordersProducts
(
    orderNumber     number      not null,
    productID       number      not null,
    quantity        number      not null,
                    check (quantity > 0),
    constraint      orderNumber_productID_PK primary key(orderNumber, productID),
    constraint      ordersProducts_orderNumber_FK    foreign key(orderNumber) references orders(orderNumber),
    constraint      ordersProducts_productID_FK      foreign key(productID) references products(productID)
);

/* insert data section 
Lisa Chu tc29328 */

insert into customers
values (1, 'tc29328@utexas.edu', 'password123', 'Lisa', 'Chu', '123-456-7890', null);

insert into customers
values (2, 'fake@utexas.edu', 'password321', 'Hello', 'There', '098-765-4321', null);

insert into customerAddresses
values (1, '123 lisa road', '123', 'austin', 'tx', '78705', 'A', 1);

insert into customerAddresses
values (2, '321 fake road', '321', 'austin', 'tx', '78705', 'I', 1);

insert into customerAddresses
values (3, '123 hello street', '123', 'austin', 'tx', '78705', 'A', 2);

insert into customerAddresses
values (4, '321 hello road', '321', 'austin', 'tx', '78705', 'I', 2);

insert into employees (employeeID, firstName, lastName, taxID, streetName, city, employeeState, zip)
values (1, 'angie', 'tran', '999', '123 lisa road', 'austin', 'tx', '78705');

insert into employees (employeeID, firstName, lastName, taxID, streetName, city, employeeState, zip)
values (2, 'rachel', 'bae', '888', '123 lisa road', 'austin', 'tx', '78705');

insert into categories
values (1, 'ice cream', 'cold dessert with eggs');

insert into categories
values (2, 'gelato', 'cold dessert without eggs');

insert into products
values (1, '100', 'pistachio gelato', 'gelato with pistachio', 4, 100, 'gelato');

insert into products
values (2, '101', 'green tea ice cream', 'green tea flavored', 5, 95, 'ice cream');

insert into products 
values (3, '103', 'cookie dough ice cream', 'ice cream with cookie dough chunks', 3, 50, 'ice cream');

insert into products
values (4, '104', 'red bean mochi', 'ice cream in mochi', 8, 20, 'ice cream');

insert into orders
values (1, '23-feb-2019', 12, 0.99, 12.99, 1, 1);

insert into orders
values (2, '23-feb-2019', 8, 0.66, 8.66, 2, 2);

insert into ordersProducts
values (1, 1, 1);

insert into ordersProducts
values (1, 4, 1);

insert into ordersProducts
values (2, 2, 1);

insert into ordersProducts
values (2, 3, 1);

commit




    
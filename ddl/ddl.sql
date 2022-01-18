CREATE TABLE IF NOT EXISTS TRANSACTION
(
transaction_id integer PRIMARY key,
customer_id integer,
store_id integer,
product_id integer,
price integer,
total_trx integer,
total_amount bigint,
transaction_date date,
process_date timestamp
);

CREATE TABLE IF NOT EXISTS STORE
(
store_id integer PRIMARY key,
store_name varchar,
city varchar,
status varchar,
created_date date
);

CREATE TABLE IF NOT EXISTS CUSTOMER
(
store_id integer PRIMARY key,
store_name varchar,
city varchar,
status varchar,
created_date date
);

CREATE TABLE IF NOT EXISTS PRODUCT_REF
(
product_id integer PRIMARY key,
product_name varchar,
product_category varchar,
normal_price integer,
create_date date
);
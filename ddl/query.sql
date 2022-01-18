SELECT
a.TRANSACTION_id,
a.customer_id,
b.customer_firstname,
b.customer_lastname,
a.product_id,
c.product_name,
c.product_category,
a.store_id,
d.store_name,
d.city,
a.total_trx,
a.total_amount,
a.TRANSACTION_date
FROM
TRANSACTION a,
customer b,
product_ref c,
store d
WHERE 
a.customer_id = b.customer_id AND 
a.product_id = c.product_id AND 
a.store_id = d.store_id
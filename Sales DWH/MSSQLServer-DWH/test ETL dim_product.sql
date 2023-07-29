
----------test SCD for dim_product ETL

use Salescase
go 

select count(*) from dim_product

select product_id , product_id % 10
from dim_product

delete from dim_product where product_id % 10=6

update dim_product set color = 'Black'
where product_id % 10=3

update dim_product set reorder_point = round(reorder_point*1.1 , 0)
where product_id % 10=4
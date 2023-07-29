use Salescase
go 

if exists ( select * from sys.objects where name = 'fact_sales')
drop table fact_sales
go

create table fact_sales (
product_key int not null,
customer_key int not null,
territory_key int not null,
order_date_key int not null,
sales_order_id nvarchar(50) not null,
line_number int not null,
quantity int,
unit_price money,
unit_cost money,
tax_ammount money,
freight money,
extended_sales money,
extend_cost money,
created_at datetime not null default(getdate()),

constraint pk_fact_sales 
primary key clustered(sales_order_id , line_number),

constraint fk_fact_sales_dim_product 
foreign key (product_key) references dim_product(product_key),

constraint fk_fact_sales_dim_customer
foreign key (customer_key) references dim_customer(customer_key),

constraint fk_fact_sales_dim_territory
foreign key (territory_key) references dim_territory(territory_key),

constraint fk_fact_sales_dim_date
foreign key (order_date_key) references dim_date(date_key)
);

-- create indexes
if exists (
			select * from sys.indexes 
			where name = 'ix_fact_sales_product_key'
			and object_id = object_id('fact_sales') 
			)
drop index fact_sales.ix_fact_sales_product_key

create index ix_fact_sales_product_key on fact_sales(product_key);
-------
if exists (
			select * from sys.indexes 
			where name = 'ix_fact_sales_customer_key'
			and object_id = object_id('fact_sales') 
			)
drop index fact_sales.ix_fact_sales_customer_key

create index ix_fact_sales_customer_key on fact_sales(customer_key);

---------------
if exists (
			select * from sys.indexes 
			where name = 'ix_fact_sales_territory_key'
			and object_id = object_id('fact_sales') 
			)
drop index fact_sales.ix_fact_sales_territory_key

create index ix_fact_sales_territory_key on fact_sales(territory_key);

--------------

if exists (
			select * from sys.indexes 
			where name = 'ix_fact_sales_order_date_key'
			and object_id = object_id('fact_sales') 
			)
drop index fact_sales.ix_fact_sales_order_date_key

create index ix_fact_sales_order_date_key on fact_sales(order_date_key);






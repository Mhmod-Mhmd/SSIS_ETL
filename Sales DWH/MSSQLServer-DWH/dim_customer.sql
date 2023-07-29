use Salescase
go 

-- drop foreign key 
if exists (
			select * from sys.foreign_keys 
			where name = 'Fk_Fact_sales_dim_customer' 
			and parent_object_id = object_id('Fact_sales') 
           )
alter table Fact_sales 
drop constraint Fk_Fact_sales_dim_customer ;

--check if table dim_customer exist or no 
if exists(select * from sys.objects where name='dim_customer' and type = 'U')
drop table dim_customer ;
go

-- create customer dimension 
create table dim_customer (
customer_key int not null identity(1,1),
customer_id int not null ,
customer_name nvarchar(150) ,
address1 nvarchar(300),
address2 nvarchar(300),
city nvarchar(30),
phone nvarchar(25) , 

--metadata
source_system_code tinyint ,

--scd 'Slowly Changing Dimension'
start_date datetime not null default (getdate()),
end_date datetime ,
is_current tinyint not null default(1),

constraint pk_dim_customer
primary key clustered(customer_key)
);


--Create Forerign key
if exists ( select * from sys.tables where name = 'Fact_sales')
alter table Fact_sales 
add constraint Fk_Fact_sales_dim_customer
foreign key (customer_key)
references dim_customer (customer_key);

--insert unknown row
set identity_insert dim_customer on

insert into dim_customer(customer_key,customer_id,customer_name, address1 , address2, city, phone ,source_system_code,start_date,end_date,is_current) 
values(0,0,'Unkown','Unkown','Unkown','Unkown','Unkown',0,'1900-01-01',null,1)

set identity_insert dim_customer off ;


-- Create customer id Index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_customer_customer_id'
			and object_id = object_id('dim_customer') 
			)
drop index dim_customer.ix_dim_customer_customer_id 

create index ix_dim_customer_customer_id on dim_customer(customer_id) ;

-- Create city index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_customer_city'
			and object_id = object_id('dim_customer')
		   )
drop index dim_customer.ix_dim_customer_city

create index ix_dim_customer_city on dim_customer(city) ;








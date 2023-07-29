use Salescase
go 

--drop dim_product foreign key in fact tables  
if exists ( 
			select * from sys.foreign_keys 
			where name = 'Fk_Fact_sales_dim_product'
			and parent_object_id = object_id('Fact_sales')
		  )
Alter table fact_table 
drop constraint Fk_fact_sales_dim_product ;

--check if table dim_product exist or no 
if exists(select * from sys.objects where name='dim_product' and type = 'U')
drop table dim_product

go 

-- Create product dimension 
create table dim_product (
product_key int not null identity(1,1),
product_id int not null ,
product_name nvarchar(50),
product_description nvarchar(400),
product_subcategory nvarchar(50),
product_category nvarchar(50),
color nvarchar(15),
model_name nvarchar(50),
reorder_point smallint,
standard_cost money ,

--metadata
source_system_code tinyint ,

--scd 'Slowly Changing Dimension'
start_date datetime not null default (getdate()),
end_date datetime ,
is_current tinyint not null default(1),

constraint pk_dim_product
primary key clustered(product_key)
);

--Create Forerign key
if exists ( select * from sys.tables where name = 'Fact_sales')
alter table Fact_sales 
add constraint Fk_Fact_sales_dim_product 
foreign key (product_key)
references dim_prodect (product_key);

--insert unknown row
set identity_insert dim_product on

insert into dim_product(product_key,product_id,product_name,product_description ,product_subcategory,product_category,color,model_name,reorder_point,standard_cost,source_system_code,start_date,end_date,is_current) 
values(0,0,'Unkown','Unkown','Unkown','Unkown','Unkown','Unkown',0,0,0,'1900-01-01',null,1)

set identity_insert dim_product off ;


-- Create profuct_id Index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_product_product_id'
			and object_id = object_id('dim_product') 
			)
drop index dim_product.ix_dim_product_product_id  

create index ix_dim_product_product_id on dim_product(product_id) ;

-- Create profuct_catogery index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_product_product_category'
			and object_id = object_id('dim_product')
		   )
drop index dim_product.ix_dim_product_product_category

create index ix_dim_product_product_category on dim_product(product_category) ;








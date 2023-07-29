use Salescase
go 

-- drop foreign key 
if exists (
			select * from sys.foreign_keys 
			where name = 'Fk_Fact_sales_dim_date' 
			and parent_object_id = object_id('Fact_sales') 
           )
alter table Fact_sales 
drop constraint Fk_Fact_sales_dim_date ;

--check if table dim_date exist or no 
if exists(select * from sys.objects where name='dim_date' and type = 'U')
drop table dim_date ;
go

-- create territory dimension 
create table dim_date(
date_key int not null, -- surrogate key
full_date date not null,
calender_year int not null,
calender_quarter int not null,
calender_month_num int not null,
calender_month_name nvarchar(15) not null,

constraint pk_dim_date
primary key clustered(date_key)
);


--Create Forerign key
if exists ( select * from sys.tables where name = 'Fact_sales')
alter table Fact_sales 
add constraint Fk_Fact_sales_dim_date
foreign key (date_key)
references dim_date(date_key);

-- Create date id Index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_date_full_date'
			and object_id = object_id('dim_date') 
			)
drop index dim_date.ix_dim_date_full_date

create index ix_dim_date_full_date on dim_date(full_date) ;


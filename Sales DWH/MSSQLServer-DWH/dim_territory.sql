use Salescase
go 

-- drop foreign key 
if exists (
			select * from sys.foreign_keys 
			where name = 'Fk_Fact_sales_dim_territory' 
			and parent_object_id = object_id('Fact_sales') 
           )
alter table Fact_sales 
drop constraint Fk_Fact_sales_dim_territory ;

--check if table dim_customer exist or no 
if exists(select * from sys.objects where name='dim_territory' and type = 'U')
drop table dim_territory ;
go

-- create territory dimension 
create table dim_territory (
territory_key int not null identity(1,1), -- surrogate key
territory_id int not null , -- alternative key , bussness key 
territory_name nvarchar(50) ,
territory_country nvarchar(400),
territory_group nvarchar(50),

--metadata
source_system_code tinyint ,

--scd 'Slowly Changing Dimension'
start_date datetime not null default (getdate()),
end_date datetime ,
is_current tinyint not null default(1),

constraint pk_dim_territory
primary key clustered(territory_key)
);


--Create Forerign key
if exists ( select * from sys.tables where name = 'Fact_sales')
alter table Fact_sales 
add constraint Fk_Fact_sales_dim_territory
foreign key (territory_key)
references dim_territory (territory_key);

--insert unknown row
set identity_insert dim_territory on

insert into dim_territory(territory_key,territory_id,territory_name, territory_country , territory_group, source_system_code,start_date,end_date,is_current) 
values(0,0,'Unkown','Unkown','Unkown',0,'1900-01-01',null,1)

set identity_insert dim_territory off ;


-- Create territory id Index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_territory_territory_id'
			and object_id = object_id('dim_territory') 
			)
drop index dim_territory.ix_dim_territory_territory_id 

create index ix_dim_territory_territory_id on dim_territory(territory_id) ;

-- Create territory name index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_territory_territory_name'
			and object_id = object_id('dim_territory')
		   )
drop index dim_territory.ix_dim_territory_territory_name

create index ix_dim_territory_territory_name on dim_territory(territory_name) ;

-- Create territory country index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_territory_territory_country'
			and object_id = object_id('dim_territory')
		   )
drop index dim_territory.ix_dim_territory_territory_country

create index ix_dim_territory_territory_country on dim_territory(territory_country) ;

-- Create territory group index 
if exists (
			select * from sys.indexes 
			where name = 'ix_dim_territory_territory_group'
			and object_id = object_id('dim_territory')
		   )
drop index dim_territory.ix_dim_territory_territory_group

create index ix_dim_territory_territory_group on dim_territory(territory_group) ;




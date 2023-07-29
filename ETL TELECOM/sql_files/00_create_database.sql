USE master
go

if exists (select * from sys.databases where name = 'ETL_Telecom')
drop database ETL_Telecom
go

create database ETL_Telecom
go
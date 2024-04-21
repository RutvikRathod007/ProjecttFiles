create database BankDB
use BankDB
use master
drop database BankDB


--Creating Customers Table
create table Customer(
customer_id bigint primary key identity(1,1) ,
first_name varchar(500) not null,
last_name varchar(500) not null,
dob date not null,
mobile_number varchar(10) not null unique,
city varchar(100)  not null,
customer_image nvarchar(2000) not null
);


drop table Customer
insert into Customer values('Rutvik','Rathod','2003-02-15','7878756746','jasdan','c:/users/images/rutvik.jpg')
select * from Customer;


--Creating Account Table
create table Account(
acc_number bigint primary key identity(54321987611320,1),
acc_type varchar(20) not null check (acc_type in ('saving','current')),
acc_balance bigint not null,
acc_created_at datetime default current_timestamp ,
is_active bit not null default 1,
customer_id bigint  not null,
foreign key(customer_id) references Customer(customer_id),
 constraint unique_acc_record unique(acc_type,customer_id)
);
drop table Account
insert into Account (acc_type,acc_balance,customer_id) values('saving',100,1)
select * from Account
delete from Account Where acc_number=54321987611332
create table TransactionTbl(
t_id bigint primary key identity(1,1),
acc_number bigint not null check(acc_number>=54321987611320),
t_type varchar(200) not null check(t_type in ('deposite','withdraw','transfer')),
t_amount bigint not null,
t_time datetime not null,
summary varchar(max) not null,
foreign key(acc_number) references Account(acc_number)
);


drop table TransactionTbl;
select * from TransactionTbl
insert into TransactionTbl values (54321987611337,'deposite',3000,'2005-01-01 13:12:17:000','suammerter')
truncate table Customer
truncate table TransactionTbl
--Creating table Loan
create table Loan(
loan_id int primary key identity(1,1),
customer_id int not null,
loan_type varchar(200) not null,
loan_amount bigint not null,
interest_rate decimal(3,2) not null,
loan_duration_month int not null,
status varchar(200) not null
);

drop table Loan
insert into Loan values(1,'Personal',50000,5.34,12,'Active');

select * from Loan;
drop procedure sp_insert_customer

--PROCEDURE TO CREATE A CUSTOMER'S ACCOUNT
--PROCEDURE WILL INSERT DATA TO ACCOUNT TABLE AS WELL IN CUSTOMER TABLE
--IF IT FAIL T0 INSERT DATA INTO CUSTOMER TABLE IT WILL ROLL BACK
--AND WANT ADD DATA TO ACCOUNT TABLE AS WELL

CREATE PROCEDURE sp_insert_customer
    @cust_first_name varchar(500),
    @cust_last_name varchar(500),
    @cust_dob date,
    @cust_mobile_number varchar(10),
    @cust_city varchar(100),
	@cust_image nvarchar(2000),
    @acc_type varchar(200),
	@acc_balance bigint,
    @acc_number bigint OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
	DECLARE @customer_id bigint;
        INSERT INTO Customer (first_name, last_name, dob, mobile_number, city,customer_image)
        VALUES (@cust_first_name, @cust_last_name, @cust_dob, @cust_mobile_number, @cust_city,@cust_image);

        SET @customer_id = SCOPE_IDENTITY();
        INSERT INTO Account (acc_type,acc_balance,customer_id)
        VALUES (@acc_type,@acc_balance,@customer_id);
		SET @acc_number=SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;

END;
update Account set acc_balance=5000 where acc_number='54321987611337'
dbcc checkident('Customer',reseed,18);


declare @returned_cust_id bigint;
exec @returned_cust_id= sp_insert_customer 'sdffsd','Kakkad','2000-02-10','6965575646','Rajkot','C:Users/BankApp/CustImages/rutvik.jpg','current';
print @returned_cust_id
select * from Customer;
delete from Customer where customer_id=10002
delete from Account where customer_id=10002




create function fn_join_tables() returns table
as
return(select cust.first_name,cust.last_name,acc.acc_number from Customer as cust inner join
Account as acc on
cust.customer_id=acc.customer_id );


drop function fn_join_tables
 drop procedure sp_join_tables


select * from  fn_join_tables()



DECLARE @returned_cust_acc_number bigint;
EXEC sp_insert_customer 
    @cust_first_name = 'John', 
    @cust_last_name = 'Doe', 
    @cust_dob = '2000-02-10', 
    @cust_mobile_number = '1234567890', 
    @cust_city = 'New York', 
	@cust_image='C:Users/BankApp/CustImages/john.jpg',
    @acc_type = 'current',
	@acc_balance=100,
    @acc_number = @returned_cust_acc_number OUTPUT;
PRINT @returned_cust_acc_number;

update Account set acc_balance=1000 where customer_id=1;
update Account set acc_type='current' where customer_id=1;

delete from Account where  customer_id=1;
delete from Customer where customer_id=1;









update Account set is_active=0 where customer_id=2;

delete from Account where customer_id=13;



create table Users(
user_id bigint primary key identity(1,1),
username varchar(1000) not null,
mobile_number varchar(10) unique not null,
email varchar(1000) unique,
password varchar(max) not null,
salt varchar(max) not null,
role varchar(100) check(role in ('customer','employee','admin')) not null
);
drop table Users


select * from Users
insert into Users values('Rutvik Rathod','9510897848','rutvikrathod2324@gmail.com','Rutik@10292','qwecqweqw','admin');


select * from Customer as cust
inner join Account as acc on cust.customer_id=acc.customer_id
inner join TransactionTbl as t on acc.acc_number=t.acc_number

delete from Customer where customer_id=15

select * from Customer
delete from TransactionTbl where acc_number=54321987611337
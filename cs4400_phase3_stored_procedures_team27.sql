-- CS4400: Introduction to Database Systems (Spring 2024) 

-- Phase III: Stored Procedures & Views [v0] Sunday, March 24, 2024 @ 8:00pm EST 

  

-- Team 27  

-- Benjamin Colton (bcolton8)  

-- Sheikh Munim Riddhi (sriddhi3)  

-- Colin Naughton (cnaughton7)  

-- Ryan Otsuka (rotsuka6)   

-- Joshua Buchsbaum (jbuchsbaum3)  

  

-- Directions: 

-- Please follow all instructions for Phase III as listed on Canvas. 

-- Fill in the team number and names and GT usernames for all members above. 

-- Create Table statements must be manually written, not taken from an SQL Dump file. 

-- This file must run without error for credit. 

  

/* This is a standard preamble for most of our scripts.  The intent is to establish 

a consistent environment for the database behavior. */ 

set global transaction isolation level serializable; 

set global SQL_MODE = 'ANSI,TRADITIONAL'; 

set names utf8mb4; 

set SQL_SAFE_UPDATES = 0; 

  

set @thisDatabase = 'drone_dispatch'; 

drop database if exists drone_dispatch; 

create database if not exists drone_dispatch; 

use drone_dispatch; 

  

-- ----------------------------------------------- 

-- table structures 

-- ----------------------------------------------- 

  

create table users ( 

uname varchar(40) not null, 

first_name varchar(100) not null, 

last_name varchar(100) not null, 

address varchar(500) not null, 

birthdate date default null, 

primary key (uname) 

) engine = innodb; 

  

create table customers ( 

uname varchar(40) not null, 

rating integer not null, 

credit integer not null, 

primary key (uname) 

) engine = innodb; 

  

create table employees ( 

uname varchar(40) not null, 

taxID varchar(40) not null, 

service integer not null, 

salary integer not null, 

primary key (uname), 

unique key (taxID) 

) engine = innodb; 

  

create table drone_pilots ( 

uname varchar(40) not null, 

licenseID varchar(40) not null, 

experience integer not null, 

primary key (uname), 

unique key (licenseID) 

) engine = innodb; 

  

create table store_workers ( 

uname varchar(40) not null, 

primary key (uname) 

) engine = innodb; 

  

create table products ( 

barcode varchar(40) not null, 

pname varchar(100) not null, 

weight integer not null, 

primary key (barcode) 

) engine = innodb; 

  

create table orders ( 

orderID varchar(40) not null, 

sold_on date not null, 

purchased_by varchar(40) not null, 

carrier_store varchar(40) not null, 

carrier_tag integer not null, 

primary key (orderID) 

) engine = innodb; 

  

create table stores ( 

storeID varchar(40) not null, 

sname varchar(100) not null, 

revenue integer not null, 

manager varchar(40) not null, 

primary key (storeID) 

) engine = innodb; 

  

create table drones ( 

storeID varchar(40) not null, 

droneTag integer not null, 

capacity integer not null, 

remaining_trips integer not null, 

pilot varchar(40) not null, 

primary key (storeID, droneTag) 

) engine = innodb; 

  

create table order_lines ( 

orderID varchar(40) not null, 

barcode varchar(40) not null, 

price integer not null, 

quantity integer not null, 

primary key (orderID, barcode) 

) engine = innodb; 

  

create table employed_workers ( 

storeID varchar(40) not null, 

uname varchar(40) not null, 

primary key (storeID, uname) 

) engine = innodb; 

  

-- ----------------------------------------------- 

-- referential structures 

-- ----------------------------------------------- 

  

alter table customers add constraint fk1 foreign key (uname) references users (uname) 

on update cascade on delete cascade; 

alter table employees add constraint fk2 foreign key (uname) references users (uname) 

on update cascade on delete cascade; 

alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname) 

on update cascade on delete cascade; 

alter table store_workers add constraint fk4 foreign key (uname) references employees (uname) 

on update cascade on delete cascade; 

alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname) 

on update cascade on delete cascade; 

alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag) 

on update cascade on delete cascade; 

alter table stores add constraint fk11 foreign key (manager) references store_workers (uname) 

on update cascade on delete cascade; 

alter table drones add constraint fk5 foreign key (storeID) references stores (storeID) 

on update cascade on delete cascade; 

alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname) 

on update cascade on delete cascade; 

alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID) 

on update cascade on delete cascade; 

alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode) 

on update cascade on delete cascade; 

alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID) 

on update cascade on delete cascade; 

alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname) 

on update cascade on delete cascade; 

  

-- ----------------------------------------------- 

-- table data 

-- ----------------------------------------------- 

  

insert into users values 

('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'), 

('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'), 

('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'), 

('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'), 

('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'), 

('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'), 

('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'), 

('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'), 

('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'), 

('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'), 

('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'), 

('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'), 

('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28'); 

  

insert into customers values 

('jstone5', 4, 40), 

('sprince6', 5, 30), 

('awilson5', 2, 100), 

('lrodriguez5', 4, 60), 

('bsummers4', 3, 110), 

('cjordan5', 3, 50); 

  

insert into employees values 

('awilson5', '111-11-1111', 9, 46000), 

('lrodriguez5', '222-22-2222', 20, 58000), 

('tmccall5', '333-33-3333', 29, 33000), 

('eross10', '444-44-4444', 10, 61000), 

('hstark16', '555-55-5555', 20, 59000), 

('echarles19', '777-77-7777', 3, 27000), 

('csoares8', '888-88-8888', 26, 57000), 

('agarcia7', '999-99-9999', 24, 41000), 

('bsummers4', '000-00-0000', 17, 35000), 

('fprefontaine6', '121-21-2121', 5, 20000); 

  

insert into store_workers values 

('eross10'), 

('hstark16'), 

('echarles19'); 

  

insert into stores values 

('pub', 'Publix', 200, 'hstark16'), 

('krg', 'Kroger', 300, 'echarles19'); 

  

insert into employed_workers values 

('pub', 'eross10'), 

('pub', 'hstark16'), 

('krg', 'eross10'), 

('krg', 'echarles19'); 

  

insert into drone_pilots values 

('awilson5', '314159', 41), 

('lrodriguez5', '287182', 67), 

('tmccall5', '181633', 10), 

('agarcia7', '610623', 38), 

('bsummers4', '411911', 35), 

('fprefontaine6', '657483', 2); 

  

insert into drones values 

('pub', 1, 10, 3, 'awilson5'), 

('pub', 2, 20, 2, 'lrodriguez5'), 

('krg', 1, 15, 4, 'tmccall5'), 

('pub', 9, 45, 1, 'fprefontaine6'); 

  

insert into products values 

('pr_3C6A9R', 'pot roast', 6), 

('ss_2D4E6L', 'shrimp salad', 3), 

('hs_5E7L23M', 'hoagie sandwich', 3), 

('clc_4T9U25X', 'chocolate lava cake', 5), 

('ap_9T25E36L', 'antipasto platter', 4); 

  

insert into orders values 

('pub_303', '2024-05-23', 'sprince6', 'pub', 1), 

('pub_305', '2024-05-22', 'sprince6', 'pub', 2), 

('krg_217', '2024-05-23', 'jstone5', 'krg', 1), 

('pub_306', '2024-05-22', 'awilson5', 'pub', 2); 

  

insert into order_lines values 

('pub_303', 'pr_3C6A9R', 20, 1), 

('pub_303', 'ap_9T25E36L', 4, 1), 

('pub_305', 'clc_4T9U25X', 3, 2), 

('pub_306', 'hs_5E7L23M', 3, 2), 

('pub_306', 'ap_9T25E36L', 10, 1), 

('krg_217', 'pr_3C6A9R', 15, 2); 

  

-- ----------------------------------------------- 

-- stored procedures and views 

-- ----------------------------------------------- 

  

-- add customer 

delimiter //  

create procedure add_customer 

(in ip_uname varchar(40), in ip_first_name varchar(100), 

in ip_last_name varchar(100), in ip_address varchar(500), 

    in ip_birthdate date, in ip_rating integer, in ip_credit integer) 

sp_main: begin 

-- place your solution here 
if (ip_uname is Null or ip_first_name is Null or ip_last_name is Null or ip_address is Null or ip_rating is Null or ip_credit is Null)
	then leave sp_main;
elseif (ip_uname = '' or ip_first_name = '' or ip_last_name = '' or ip_address = '' or  ip_rating < 1 or ip_rating > 5 or ip_credit < 0 )
	then leave sp_main;
end if;
if ip_uname IN (select uname from customers)
    
    then leave sp_main;
    
    end if;
if (ip_uname in (select uname from users)) then 
	if ((ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate) in (select * from users))
    
		then INSERT INTO customers (uname, rating, credit) VALUES (ip_uname, ip_rating, ip_credit); 
		else leave sp_main;
    
		end if;
else
INSERT INTO users (uname, first_name, last_name, address, birthdate) VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate); 

INSERT INTO customers (uname, rating, credit) VALUES (ip_uname, ip_rating, ip_credit); 
end if;

end // 

delimiter ; 

  

-- add drone pilot 

delimiter //  

create procedure add_drone_pilot 

(in ip_uname varchar(40), in ip_first_name varchar(100), 

in ip_last_name varchar(100), in ip_address varchar(500), 

    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer,  

    in ip_salary integer, in ip_licenseID varchar(40), 

    in ip_experience integer) 

sp_main: begin 
if (ip_uname is Null or ip_first_name is Null or ip_last_name is Null or ip_address is Null or ip_taxID is Null or ip_service is Null or ip_salary is Null or ip_licenseID is Null or ip_experience is Null)
	then leave sp_main;
elseif (ip_uname = '' or ip_first_name = '' or ip_last_name = '' or ip_address = '' or ip_taxID = '' or ip_service < 0 or ip_salary < 0 or ip_licenseID = '' or ip_experience < 0)
	then leave sp_main;
end if;
if (ip_uname IN (select uname from store_workers) OR 

    #ip_taxID IN (select taxID from employees) OR 

    ip_licenseID IN (select licenseID from drone_pilots)) 

    then leave sp_main; 

    end if; 
if (ip_uname in (select uname from users)) then 
	if (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate) not in (select * from users) then 
		leave sp_main;
    end if;
else INSERT into users values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
end if;

if (ip_taxID in (select taxID from employees)) then 
	if (ip_uname, ip_taxID, ip_service, ip_salary) not in (select * from employees) then 
		delete from users where uname = ip_uname;
		leave sp_main;
    end if;     
else INSERT into employees values (ip_uname, ip_taxID, ip_service, ip_salary); 
end if;
-- INSERT into users values 

--     (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate); 

--      

--     INSERT into employees values 

--     (ip_uname, ip_taxID, ip_service, ip_salary); 

     

    INSERT into drone_pilots values (ip_uname, ip_licenseID, ip_experience); 

     

end // 

delimiter ; 

  

-- add product 

delimiter //  

create procedure add_product 

(in ip_barcode varchar(40), in ip_pname varchar(100), 

    in ip_weight integer) 

sp_main: begin 

-- place your solution here 
	if (ip_barcode is Null or ip_pname is Null or ip_barcode = '' or ip_pname = '' or ip_weight <= 0)
    then leave sp_main;
    end if;

	if ip_barcode in (select barcode from drone_dispatch.products)
    then leave sp_main;
    end if;
    

    insert into products values (ip_barcode, ip_pname, ip_weight); 

end // 

delimiter ; 

  

-- add drone  

delimiter //   

create procedure add_drone  

(in ip_storeID varchar(40), in ip_droneTag integer,  

    in ip_capacity integer, in ip_remaining_trips integer,  

    in ip_pilot varchar(40))  

  

sp_main: begin  
if (ip_droneTag is Null or ip_capacity is Null or ip_remaining_trips is Null)
	then leave sp_main;
elseif (ip_capacity <= 0 or ip_remaining_trips < 0)
	then leave sp_main;
end if;  

if (ip_storeID not in (select storeID from stores)) then leave sp_main; 

end if; 

  

if (ip_droneTag in (select droneTag from drones where storeID = ip_storeID)) then leave sp_main; 

end if; 

  

if (ip_pilot NOT IN (select uname from drone_pilots)) then leave sp_main; 

end if; 

  

if (ip_pilot IN (select pilot from drones)) then leave sp_main; 

end if; 

  

INSERT into drones values 

(ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot); 

  

end //  

  

delimiter ; 

  

-- increase customer credits 

delimiter //  

create procedure increase_customer_credits 

(in ip_uname varchar(40), in ip_money integer) 

sp_main: begin 

-- place your solution here 

if ip_money > 0  

then update customers set credit = credit + ip_money where uname = ip_uname; 

end if; 

end // 

delimiter ; 

  

-- swap drone control 

delimiter //  

create procedure swap_drone_control 

(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40)) 

sp_main: begin     

if (ip_incoming_pilot NOT IN (select uname from drone_pilots) OR 

    ip_outgoing_pilot NOT IN (select uname from drone_pilots) OR 

    ip_incoming_pilot NOT IN (select uname from drone_pilots left join drones on uname = pilot where droneTag is NULL) OR 

    ip_outgoing_pilot IN (select uname from drone_pilots left join drones on uname = pilot where droneTag is NULL)) 

    then leave sp_main; 

    end if; 

     

    UPDATE drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot; 

  

end // 

delimiter ; 

  

-- repair and refuel a drone 

delimiter //  

create procedure repair_refuel_drone 

(in ip_drone_store varchar(40), in ip_drone_tag integer, 

    in ip_refueled_trips integer) 

sp_main: begin 

-- place your solution here 

    if ip_refueled_trips > 0 

then update drone_dispatch.drones set remaining_trips = remaining_trips + ip_refueled_trips 

        where storeID = ip_drone_store and droneTag = ip_drone_tag; 

    end if; 

end // 

delimiter ; 

 

-- begin order 

delimiter //  

create procedure begin_order 

(in ip_orderID varchar(40), in ip_sold_on date, 

    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40), 

    in ip_carrier_tag integer, in ip_barcode varchar(40), 

    in ip_price integer, in ip_quantity integer) 

sp_main: begin 

-- place your solution here 

    declare cost int; 

    declare capacity int; 

    declare item_weight int; 

	declare allocated_credit int;
    
    select credit_already_allocated into allocated_credit from customer_credit_check where customer_name = ip_purchased_by;

    select ip_price * ip_quantity into cost; 

    select drones.capacity into capacity from drones where droneTag = ip_carrier_tag and storeID = ip_carrier_store limit 1; 

    select products.weight into item_weight from products where barcode = ip_barcode limit 1; 

	if ip_orderID in (select orderID from orders)
    then leave sp_main;
    end if;
    if (ip_orderID is Null or ip_sold_on is Null or ip_purchased_by is Null or ip_carrier_store is Null or ip_carrier_tag is Null or ip_barcode is Null or ip_price is Null or ip_quantity is Null)
		then leave sp_main;
	elseif (ip_orderID = '' or ip_carrier_store = '' or ip_barcode = '' or ip_purchased_by = '')
		then leave sp_main;
    end if;

    if ip_price >= 0 and ip_quantity > 0  

    and (select credit from customers where uname = ip_purchased_by) >= cost + allocated_credit

    and capacity >= ip_quantity * item_weight 

    then 

insert into orders values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag); 

        insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity); 



    end if; 

end // 

delimiter ; 

  

-- add order line 

delimiter //  

create procedure add_order_line 

(in ip_orderID varchar(40), in ip_barcode varchar(40), 

    in ip_price integer, in ip_quantity integer) 

sp_main: begin 

-- place your solution here 

    declare cost int; 

    declare customer_uname varchar(40); 

    declare drone_weight int; 

	declare allocated_credit int;

    select ip_price * ip_quantity into cost; 

    select purchased_by into customer_uname from orders where orderID = ip_orderID limit 1; 

    select sum(quantity*weight) into drone_weight from order_lines join products on products.barcode = order_lines.barcode  

    group by orderID having orderID = ip_orderID; 

	select credit_already_allocated into allocated_credit from customer_credit_check where customer_name = customer_uname;
    
    if (ip_orderID is Null or ip_barcode is Null or ip_orderID = '' or ip_barcode = '')
		then leave sp_main;
	end if;

    if ip_barcode not in (select barcode from order_lines where orderID = ip_orderID) 

    and ip_price >= 0 and ip_quantity > 0  

    and (select credit from customers where uname = customer_uname) >= cost + allocated_credit

    and drone_weight + (select weight from products where barcode = ip_barcode) * ip_quantity <=  

    (select capacity from orders join drones on (carrier_store, carrier_tag) = (storeID, droneTag) where ip_orderID = orderID) 

    then  

insert into order_lines values (ip_orderID, ip_barcode, ip_price, ip_quantity); 


end if; 

end // 

delimiter ; 

  

-- deliver order 

delimiter //  

create procedure deliver_order 

(in ip_orderID varchar(40)) 

sp_main: begin 

DECLARE tripsLeft int; 

    DECLARE droneNum int; 

    DECLARE store varchar(40); 

    DECLARE dronePilot varchar(40); 

    DECLARE buyer varchar(40); 

    DECLARE cost int; 

     

if (ip_orderID NOT IN (select orderID from orders)) then leave sp_main; 

    end if;      

    select droneTag, storeID, remaining_trips, purchased_by, pilot into droneNum, store, tripsLeft, buyer, dronePilot 

    from orders join drones on carrier_store = storeID and carrier_tag = droneTag 

where orderID = ip_orderID; 

     

    if (tripsLeft <= 0) then leave sp_main; 

    end if; 

     

    select temp.cost into cost from (select orderID, sum(price * quantity) 

    as 'cost' from orders natural join order_lines group by orderID) as temp 

where orderID = ip_orderID; 

     

    UPDATE customers set credit = (credit - cost) where uname = buyer; 

     

    if ((select rating from customers where uname = buyer) < 5 and cost > 25) then 

    UPDATE customers set rating = rating + 1 where uname = buyer; 

    end if; 

     

    UPDATE stores set revenue = (revenue + cost) where storeID = store; 

     

    UPDATE drones set remaining_trips = (remaining_trips - 1) where (storeID = store AND droneTag = droneNum); 

     

    UPDATE drone_pilots set experience = (experience + 1) where uname = dronePilot; 

     

    DELETE from orders where orderID = ip_orderID; 

     

end // 

delimiter ; 

  

-- cancel an order  

delimiter //   

 

create procedure cancel_order  

(in ip_orderID varchar(40))  

sp_main: begin  

  

-- place your solution here  

DECLARE orderCost INTEGER;  

  

-- Calculate the total cost of the order to refund to the customer  

SELECT SUM(price * quantity) INTO orderCost   

FROM order_lines WHERE orderID = ip_orderID;  

  

  

-- Decrease the customer's rating by one, if permitted   

UPDATE customers JOIN orders ON customers.uname = orders.purchased_by   

SET rating = CASE WHEN rating > 1 THEN rating - 1 ELSE rating END   

WHERE orders.orderID = ip_orderID;   

  

-- Remove all records of the order from `order_lines` and `orders`     

DELETE FROM orders WHERE orderID = ip_orderID;  

  

end //  

  

delimiter ; 

  

-- display persons distribution across roles 

create or replace view role_distribution (category, total) as 

Select 'users' as category,count(*) From users union Select 'customers',count(*) From customers 

union Select 'employees',count(*) From employees union Select 'customer_employer_overlap',count(*) From employees natural join customers 

union Select 'drone_pilots',count(*) From drone_pilots union Select 'store_workers',count(*) From store_workers union 

Select 'other_employee_roles',count(*) From employees where employees.uname not in ( select drone_pilots.uname from drone_pilots) and employees.uname not in ( select store_workers.uname from store_workers); 

 

  

-- display customer status and current credit and spending activity 

create or replace view customer_credit_check (customer_name, rating, current_credit, 

credit_already_allocated) as 

SELECT uname as customer_name,rating,credit as current_credit, COALESCE(C.z,0) as credit_already_allocated FROM drone_dispatch.customers left join (SELECT purchased_by, sum(y) as z from drone_dispatch.orders natural join (SELECT orderID,sum(A.x) as y from (SELECT orderID,price * quantity as x from drone_dispatch.order_lines) as A group by orderID) as B group by purchased_by) as C on drone_dispatch.customers.uname = C.purchased_by; 

 

  

-- display drone status and current activity  

create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,   

total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as   

select storeID, droneTag, pilot, capacity, coalesce(sum(quantity * weight), 0) as 'total_weight', remaining_trips, count(distinct orderID) as 'current_orders'  

from orders natural join order_lines natural join products   

right join drones on drones.storeID = orders.carrier_store AND drones.droneTag = orders.carrier_tag group by storeID, droneTag; 

 

  

-- display product status and current activity including most popular products 

create or replace view most_popular_products (barcode, product_name, weight, lowest_price, highest_price, lowest_quantity, highest_quantity, total_quantity) as 

select  

products.barcode,  

products.pname,  

    products.weight, 

    min(order_lines.price), 

    max(order_lines.price), 

    coalesce(min(order_lines.quantity),0), 

    coalesce(max(order_lines.quantity),0), 

    coalesce(sum(order_lines.quantity),0) 

from products  

left join order_lines on products.barcode = order_lines.barcode 

group by products.barcode; 

  

-- display drone pilot status and current activity including experience 

create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store, 

drone_tag, successful_deliveries, pending_deliveries) as 

select uname, licenseID, storeID, droneTag, experience, count(orderID) from 

drone_pilots left join drones on uname = pilot  

left join orders on droneTag = carrier_tag AND storeID = carrier_store group by uname, licenseID, storeID, droneTag, experience; 

  

-- display store revenue and activity 

create or replace view store_sales_overview (store_id, sname, manager, revenue, 

incoming_revenue, incoming_orders) as 

select storeID as store_id, sname, manager, revenue, sum(r) as incoming_revenue, count(distinct orderID) as incoming_orders from stores  

join (select orderID,carrier_store,price*quantity as r from orders natural join order_lines) as A on storeID = carrier_store group by storeID; 

 

  

-- display the current orders that are being placed/in progress 

create or replace view orders_in_progress (orderID, cost, num_products, payload, 

contents) as 

-- replace this select query with your solution 

select  

orders.orderID,  

    sum(quantity*price) as cost,  

    count(*) as num_products,  

    sum(quantity*weight) as payload, 

    group_concat(products.pname SEPARATOR ', ') as contents 

from orders 

join order_lines on orders.orderID = order_lines.orderID 

join products on order_lines.barcode = products.barcode 

group by orders.orderID; 

 

 

-- remove customer 

delimiter //  

create procedure remove_customer 

(in ip_uname varchar(40)) 

sp_main: begin 

-- place your solution here 

 

DECLARE pendingOrders INT; 

 

-- Check for pending orders 

SELECT COUNT(*) INTO pendingOrders FROM orders WHERE purchased_by = ip_uname; 
 

IF pendingOrders = 0 THEN -- No pending orders so remove customer  

DELETE FROM customers WHERE uname = ip_uname;  

 

-- Check if the user is employee before deleting from users 	 

IF NOT EXISTS (SELECT 1 FROM employees WHERE uname = ip_uname) THEN  

DELETE FROM users WHERE uname = ip_uname; 

END IF;  

END IF; 

 

end // 

delimiter ; 

 

-- remove drone pilot  

delimiter //   

create procedure remove_drone_pilot  

	(in ip_uname varchar(40))  

  

sp_main: begin  

	if (ip_uname IN (select uname from drone_pilots join drones on uname = pilot))  

    then leave sp_main;  

    end if;  

	if (ip_uname not in (select uname from drone_pilots)) 
		then leave sp_main;
	end if;

    DELETE from drone_pilots where uname = ip_uname; 

    DELETE from employees where uname = ip_uname; 

     

    if (ip_uname in (select uname from customers)) then leave sp_main; 

    end if; 

     

    DELETE from users where uname = ip_uname; 

end //  

delimiter ; 

  

-- remove product 

delimiter //  

create procedure remove_product (in ip_barcode varchar(40)) 

sp_main: begin 

-- place your solution here 

    if ip_barcode not in (select barcode from order_lines) then 

delete from products where barcode = ip_barcode; 

else select 'Error: Product currently in pending order'; 

    end if; 

end // 

delimiter ; 

  

-- remove drone  

delimiter //   

  

create procedure remove_drone (in ip_storeID varchar(40), in ip_droneTag int)  

sp_main: begin  

  

if (concat(ip_storeID, ip_droneTag) IN  

(select distinct concat(storeID, droneTag) from drones join orders on droneTag = carrier_tag and storeID = carrier_store)) 

then leave sp_main; 

end if; 

  

delete from drones where storeID = ip_storeID and droneTag = ip_droneTag; 

  

end //  

  

delimiter ; 

 

 
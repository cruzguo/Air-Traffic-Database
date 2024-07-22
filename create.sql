drop database if exists SAMS;
create database if not exists SAMS;
use SAMS;

-- alter table table1 add constraint variable_name1 foreign key (variable_name2) 
-- reference table2 (variable_name2) on update set (null/default); 
-- can cascade or delete too!

-- alter table table1 add constraint variable_name1 foreign key 
-- (variable_name2) reference table2 (variable_name2) on delete restrict
-- can cascade or set as well

-- DECIMAL CANT BE ABOVE 100

-- Error Code: 3780. Referencing column 'airlineID' and referenced column 'airlineID' in foreign key constraint 'fk_airplane_airlineID' are incompatible.

-- Error Code: 3780. Referencing column 'departure' and referenced column 'airportID' in foreign key constraint 'fk_leg_departure' are incompatible.



create table airline (
	airlineID varchar(50),
	revenue decimal(50, 2) default 0,
	primary key (airlineID)
);

create table location (
	locID varchar(50),
	primary key (locID)
);

create table airplane (
	airlineID varchar(50),
	tail_num varchar(50),
	seat_cap int,
	speed int, -- mph
	locID varchar(50), -- null indicates it is in flight
	plane_type varchar(100) not null default 'other', -- jet, propeller, other
	skids boolean default false, -- should only be true if propeller type
	props int default 0, -- number of propellers for propeller type -- null if not propeller type
	engines int default 0, -- number of engines for jet type -- null if not jet type
	primary key (airlineID, tail_num),
	constraint fk_airplane_airlineID foreign key (airlineID) references airline(airlineID) on delete cascade on update cascade, 
	constraint fk_airplane_locID foreign key (locID) references location(locID) on delete cascade on update cascade
);

create table airport (
	airportID varchar(50),
	name varchar (200) not null,
	city varchar(100),
	state varchar(100),
	country varchar(100),
	locID varchar(50) not null,
	primary key (airportID),
	constraint fk_airport_locID foreign key (locID) references location(locID) on delete cascade on update cascade
);

create table leg (
	legID int,
	distance int default 0,
	departure varchar(50) not null,
	arrival varchar(50) not null,
	primary key (legID),
	constraint fk_leg_departure foreign key (departure) references airport(airportID) on delete cascade on update cascade,
	constraint fk_leg_arrival foreign key (arrival) references airport(airportID) on delete cascade on update cascade
);

create table route (
	routeID varchar(50),
	primary key(routeID)
);

create table route_path (
	routeID varchar(50),
	legID int,
	sequence int, 
	primary key (routeID, legID, sequence),  -- Not sure what modifying the primary key to prioritize the sequence/ordering attribute
	constraint fk_route_path_routeID foreign key (routeID) references route(routeID) on delete cascade on update cascade,
	constraint fk_route_path_legID foreign key (legID) references leg(legID) on delete cascade on update cascade
);
-- add constraints to make sequence number is correct (likely based on progress number / # of legs)

create table flight (
	flightID varchar(50),
	routeID varchar(50) not null,
	support_airline varchar(50),
	support_tail varchar(50),
	progress int default 0,
	status enum('on_ground', 'in_flight') default 'on_ground',
	next_time time,
	cost decimal (50, 2) default 0,
	primary key (flightID),
	constraint fk_flight_routeID foreign key (routeID) references route(routeID) on delete cascade on update cascade,
	constraint fk_flight_support foreign key (support_airline, support_tail) references airplane(airlineID, tail_num) on delete cascade on update cascade
);

-- delimiter //
-- create trigger check_progress_before_insert
-- before insert on flight
-- for each row
-- begin
-- 	declare leg_count int;
-- 	select count(*) into leg_count from route_path where routeID = route.routeID; 
-- 	if progress > leg_count then
-- 		signal sqlstate '69420'
--         set message_text = 'progress number is greater than the number of legs';
-- 	end if;
-- end //
-- delimiter ;

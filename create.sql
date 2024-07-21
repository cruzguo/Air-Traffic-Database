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

create table airline (
airlineID int,
revenue decimal(50, 2) default 0,
primary key (airlineID)
);

create table location (
locID int,
primary key (locID)
);

create table airplane (
airlineID int,
tail_num int,
seat_cap int default 0,
speed int default 0, -- mph
locID int, -- null indicates it is in flight
plane_type varchar(100) not null, -- jet, propeller, special
skids boolean default False, -- should be false if jet type
props int default 0, -- number of propellers for propeller type
engines int default 0, -- number of engines for jet type
primary key (airlineID, tail_num),
constraint fk_airplane_airlineID foreign key (airlineID) references airline(airlineID) on delete cascade on update cascade, 
constraint fk_airplane_locID foreign key (locID) references location(locID) on delete cascade on update cascade
);

create table airport (
airportID int,
name varchar (100) not null,
city varchar(100) not null,
state varchar(100) not null,
country varchar(100) not null,
locID int not null,
primary key (airportID),
constraint fk_airport_locID foreign key (locID) references location(locID) on delete cascade on update cascade
);

create table leg (
legID int,
distance decimal (50, 2) default 0, -- int or decimal?
departure int not null,
arrival int not null,
primary key (legID),
constraint fk_leg_departure foreign key (departure) references airport(airportID) on delete cascade on update cascade,
constraint fk_leg_arrival foreign key (arrival) references airport(airportID) on delete cascade on update cascade
);

create table route (
routeID int,
primary key(routeID)
);

create table route_path (
routeID int,
legID int,
sequence int, -- WTF
primary key (routeID, legID, sequence),  -- Not sure what modifying the primary key to prioritize the sequence/ordering attribute
constraint fk_route_path_routeID foreign key (routeID) references route(routeID) on delete cascade on update cascade,
constraint fk_route_path_legID foreign key (legID) references leg(legID) on delete cascade on update cascade
);

create table flight (
flightID int,
routeID int not null,
support_airline int,
support_tail int,
progress int default 0,
status char(9) default 'on_ground',
next_time time default null,
cost decimal (50, 2) default 0,
primary key (flightID),
constraint fk_flight_routeID foreign key (routeID) references route(routeID) on delete cascade on update cascade,
constraint fk_flight_support foreign key (support_airline, support_tail) references airplane(airlineID, tail_num) on delete cascade on update cascade
);

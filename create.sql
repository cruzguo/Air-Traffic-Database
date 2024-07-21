create database if not exists SAMS;
use SAMS;

-- alter table table1 add constraint variable_name1 foreign key (variable_name2) 
-- reference table2 (variable_name2) on update set (null/default); 
-- can cascade or delete too!

-- alter table table1 add constraint variable_name1 foreign key 
-- (variable_name2) reference table2 (variable_name2) on delete restrict
-- can cascade or set as well

-- DECIMAL CANT BE ABOVE 100



drop table if exists airline;
create table airline (
airlineID int,
revenue decimal(50, 2) default 0,
primary key (airlineID)
);

drop table if exists airplane;
create table airplane (
airlineID int,
tail_num int,
seat_cap int default 0,
speed int default 0, -- int or decimal?
locID int, -- null indicates it is in flight
plane_type varchar(100), -- jet, propeller, special
skids boolean default False,
props int default 0,
engines int default 0,
primary key (airlineID, tail_num),
constraint foreign key (airlineID) references airline(airlineID), 
constraint foreign key (locID) references location(locID)
);

drop table if exists location;
create table location (
locID int,
primary key (locID)
);


-- CANT HAVE DUPLICATE CONSTRAINT NAMES FIX IT

alter table airplane add constraint delete_airlineID_error foreign key 
(airlineID) references airline (airlineID) on delete cascade;

alter table airplane add constraint update_airlineID_error foreign key 
(airlineID) references airline (airlineID) on update set null;

alter table airplane add constraint delete_locID_error foreign key
(locID) references location(locID) on delete cascade;

-- if location is changed, then should the airplane location too?
alter table airplane add constraint update_locID_error foreign key
(locID) references location(locID) on update cascade; 

drop table if exists airport;
create table airport (
airportID int,
name varchar (100) not null,
city varchar(100) not null,
state varchar(100) not null,
country varchar(100) not null,
locID int not null,
primary key (airportID),
constraint foreign key (locID) references location(locID)
);

-- CANT HAVE DUPLICATE CONSTRAINT NAMES FIX IT

alter table airport add constraint delete_locID_error foreign key
(locID) references location(locID) on delete cascade;

-- if location is changed, then should the airport location too?
alter table airport add constraint update_locID_error foreign key
(locID) references location(locID) on update cascade;

drop table if exists leg;
create table leg (
legID int,
distance decimal (50, 2) default 0, -- int or decimal?
departure int not null,
arrival int not null,
primary key (legID),
constraint foreign key (departure) references airport(airportID),
constraint foreign key (arrival) references airport(airportID)
);

-- if an endpoint is deleted, then should the endpoint change or should the arrival location
-- also be deleted?
alter table leg add constraint delete_departure_error foreign key
(departure) references airport(airportID) on delete cascade;

-- if airport is changed, then should the departure location too?
alter table leg add constraint update_departure_error foreign key
(departure) references airport(airportID) on update cascade;

-- if an endpoint is deleted, then should the endpoint change or should the arrival location
-- also be deleted?
alter table leg add constraint delete_arrival_error foreign key
(arrival) references airport(airportID) on delete cascade;

-- if airport is changed, then should the arrival location too?
alter table leg add constraint update_arrival_error foreign key
(arrival) references airport(airportID) on update cascade;

drop table if exists route;
create table route (
routeID int,
primary key(routeID)
);

drop table if exists route_path;
create table route_path (
routeID int,
legID int,
sequence int, -- WTF
primary key (routeID, legID, sequence),  -- Not sure what modifying the primary key to prioritize the sequence/ordering attribute
constraint foreign key (routeID) references route(routeID),
constraint foreign key (legID) references leg(legID)
);

-- if route is deleted, then so should the associated legs but how do we do that?
alter table route_path add constraint delete_routeID_error foreign key
(routeID) references route(routeID) on delete cascade;

-- I think
alter table route_path add constraint update_routeID_error foreign key
(routeID) references route(routeID) on update cascade;

-- What should happen to the corresponding legs in a route if a legID is deleted
alter table route_path add constraint delete_legID_error foreign key
(legID) references route(legID) on delete cascade;

-- What should happen to the corresponding legs in a route if a legID is updated
alter table route_path add constraint delete_legID_error foreign key
(legID) references route(legID) on update cascade;

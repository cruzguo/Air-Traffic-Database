create database if not exists SAMS;

drop table if exists airline;
create table airline (
airlineID int,
revenue decimal(100, 2),
primary key (airlineID)
);

drop table if exists location;
create table location (
locID int,
primary key (locID)
);

drop table if exists airplane;
create table airplane (
airlineID int,
tail_num int,
seat_cap int default 0,
speed int, -- int or decimal?
locID int, -- null indicates it is in flight
plane_type varchar(100), -- jet, propeller, special
skids boolean default False,
props int default 0,
engines int default 0,
primary key (airlineID, tail_num),
foreign key (airlineID) references airline(airlineID), 
foreign key (locID) references location(locID)
);

drop table if exists airport;
create table airport (
airportID int,
name varchar (100),
city varchar(100),
state varchar(100),
country varchar(100),
locID int not null,
primary key (airportID),
foreign key (locID) references location(locID)
);

drop table if exists leg;
create table leg (
legID int,
distance decimal (100, 2) default 0, -- int or decimal?
departure int not null,
arrival int not null,
primary key (legID),
foreign key (departure) references airport(airportID),
foreign key (arrival) references airport(airportID)
);

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
foreign key (routeID) references route(routeID),
foreign key (legID) references leg(legID)
);



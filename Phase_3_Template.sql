
-- CS4400: Introduction to Database Systems: Simple Airline Management System
-- Stored procedures for Phase 3 of the Summer 2024 Semester
-- Modify this file and rename it for your own purposes.
-- Implement the below procedures and ensure they execute correctly.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'flight_tracking';
use flight_tracking;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [_] supporting functions, views and stored procedures
-- -----------------------------------------------------------------------------
/* Helpful library capabilities to simplify the implementation of the required
views and procedures. */
-- -----------------------------------------------------------------------------
drop function if exists leg_time;
delimiter //
create function leg_time (ip_distance integer, ip_speed integer)
	returns time reads sql data
begin
	declare total_time decimal(10,2);
    declare hours, minutes integer default 0;
    set total_time = ip_distance / ip_speed;
    set hours = truncate(total_time, 0);
    set minutes = truncate((total_time - hours) * 60, 0);
    return maketime(hours, minutes, 0);

end //
delimiter ;

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a new and database-wide unique location
since it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin
    declare airline_count int;
    declare location_count int;

    select count(*) into airline_count
    from airline
    where airlineID = ip_airlineID;

    if airline_count = 0 then
        leave sp_main;
    end if;

    select count(*) into location_count
    from location
    where locID = ip_locationID;

    if location_count > 0 then
        leave sp_main;
    end if;

    insert into airplane (airlineID, tail_num, seat_cap, speed, locID, plane_type, skids, props, engine)
    values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);

    insert into location (locID)
    values (ip_locationID);

end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a new and database-wide unique location if it will be used
to support airplane takeoffs and landings.  An airport may have a longer, more
descriptive name.  An airport must also have a city, state, and country designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state varchar(100), in ip_country char(3), in ip_locationID varchar(50))
sp_main: begin
    declare location_count int;

    select count(*) into location_count
    from location
    where locID = ip_locationID;

    if location_count > 0 then
        leave sp_main;
    end if;

    insert into airport (airportID, name, city, state, country, locID)
    values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_country, ip_locationID);

    insert into location (locID)
    values (ip_locationID);

end //
delimiter ;


-- [3] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  And
the airplane, if designated, must not be in use by another flight.  The flight
can be started at any valid location along the route except for the final stop,
and it will begin on the ground.  You must also include when the flight will
takeoff along with its cost. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_next_time time, in ip_cost integer)
sp_main: begin
    declare route_count int;
    declare airplane_count int;

    select count(*) into route_count
    from route
    where routeID = ip_routeID;

    if route_count = 0 then
        leave sp_main;
    end if;

    select count(*) into airplane_count
    from flight
    where support_airline = ip_support_airline and support_tail = ip_support_tail and status = 'in_flight';

    if airplane_count > 0 then
        leave sp_main;
    end if;

    insert into flight (flightID, routeID, support_airline, support_tail, progress, status, next_time, cost)
    values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, 'on_ground', ip_next_time, ip_cost);

end //
delimiter ;

-- [4] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
    declare _routeID int;
    declare _progress int;
    declare _leg_count int;
    declare _current_time time;
    declare _new_time time;

    select routeID, progress, next_time into _routeID, _progress, _current_time
    from flight
    where flightID = ip_flightID;

    select count(*) into _leg_count
    from route_path
    where routeID = _routeID;

    if progress >= _leg_count then
        signal sqlstate '45000'
        set message_text = 'Flight has already completed its route';
        leave sp_main;
    end if;

    update flight
    set progress = _progress + 1,
        status = 'on_ground',
        next_time = addtime(_current_time, '01:00:00')
    where flightID = ip_flightID;

end //
delimiter ;


-- [5] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route. */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
    declare _status enum('on_ground', 'in_flight');
    declare _progress int;
    declare _routeID int;
    declare _leg_count int;

    select status, progress, routeID into _status, _progress, _routeID
    from flight
    where flightID = ip_flightID;

    if _status != 'on_ground' then
        leave sp_main;
    end if;

    select count(*) into _leg_count
    from route_path
    where routeID = _routeID;

    if _progress != 0 and _progress != _leg_count then
        leave sp_main;
    end if;

    delete from flight
    where flightID = ip_flightID;
end //
delimiter ;

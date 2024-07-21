
create or replace view flights_in_the_air as
select flight.flightID as flightID, leg.departure as departure, 
leg.arrival as arrival, flight.next_time as arrival_time, 
concat('Airline: ', support_airline, ' Tail Num: ', support_tail) as airplane, 
count(*) over (partition by leg.departure, leg.arrival) as total_airport_flights
from airplane join flight on (support_airline, support_tail) = (airlineID, tail_num) 
join route_path on flight.routeID = route_path.routeID
join leg  on route_path.legID = leg.legID
where locID is null;

select * from flights_in_the_air;

create or replace view flights_on_the_ground as
select flight.flightID as flightID, airport.city as departure_city, 
concat('Airline: ', support_airline, ' Tail Num: ', support_tail) as airplane, 
count(*) over (partition by airport.city) as total_flights_from_city
from flight join airplane on (support_airline, support_tail) = (airlineID, tail_num)
join airport on airplane.locID = airport.locID;

select * from flights_on_the_ground;

create or replace view alternative_airports as 
select airport.city as city, airport.state as state,  
count(*) over (partition by airport.city, airport.state) as number_of_airports,
airport.airportID as airportID, airport.name as name
from airport;

select * from alternative_airports;

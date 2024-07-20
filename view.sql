create or replace view flights_in_the_air as
select flight.flightID as flightID, leg.departure as departure, 
leg.arrival as arrival, flight.next_time as arrival_time, 
(support_airline, support_tail) as airplane, 
count(*) as total_airport_flights
from airplane join flight on (support_airline, support_tail) = (airlineID, tail_num) 
join route_path on flight.routeID = route_path.routeID
join leg  on route_path.legID = leg.legID
where locID is null
group by (departure, arrival);

create or replace view flights_on_the_ground as
select flight.flightID as flightID, airport.city as departure_city, 
(airlineID, tail_num) as airplane, 
count(*) as total_flights_from_city
from flight join airplane on (support_airline, support_tail) = (airlineID, tail_num)
join airport on airplane.locID = airport.locID
group by airport.city;

create or replace view alternative_airports as 
select airport.city as city, airport.state as state,  
count(*) as number_of_airports,
airport.airportID as airportID, airport.name as name
from airport
group by (airport.city, airport.state);

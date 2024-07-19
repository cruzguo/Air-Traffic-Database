create or replace view flights_in_the_air as
select flightID, departure, arrival, next_time, support_airline, support_tail, count(*)
from leg, flight, airplane
where locID is null;

-- select flightID, support_airline, support_tail, count(*) from flight, airplane
-- where locID is null and ;
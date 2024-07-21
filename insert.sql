use SAMS;

insert into airline (airlineID, revenue) values
('DL', 400000.00), -- Delta Airlines
('SW', 200000.00), -- Southwest Airlines
('UA', 300000.00); -- United Airlines

insert into location (locID) values
('LOC1'), -- Location ID for BWI
('LOC2'), -- Location ID for ATL
('LOC3'); -- Location ID for NYC

insert into airport (airportID, name, city, state, country, locID) values
('BWI', 'Baltimore/Washington International Thurgood Marshall Airport', 'Baltimore', 'Maryland', 'USA', 'LOC1'),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'Georgia', 'USA', 'LOC2'),
('JFK', 'John F. Kennedy International Airport', 'New York', 'New York', 'USA', 'LOC3');

insert into airplane (airlineID, tail_num, seat_cap, speed, locID, plane_type, props, engines) values
('DL', 'N123DL', 150, 560, 'LOC1', 'jet', NULL, 2),
('DL', 'N456DL', 180, 580, 'LOC2', 'jet', NULL, 2),
('SW', 'N789SW', 140, 500, 'LOC3', 'jet', NULL, 2),
('UA', 'N101UA', 160, 550, 'LOC1', 'jet', NULL, 2),
('UA', 'N202UA', 200, 600, 'LOC2', 'jet', NULL, 2);

insert into leg (legID, distance, departure, arrival) values
(1, 300, 'BWI', 'ATL'),
(2, 750, 'ATL', 'JFK'),
(3, 300, 'JFK', 'BWI'),
(4, 600, 'BWI', 'JFK');

insert into route (routeID) values
(1), -- Route from BWI to ATL to JFK
(2); -- Route from BWI to JFK

insert into route_path (routeID, legID, sequence) values
(1, 1, 1), -- Route 1 includes leg 1 (BWI to ATL)
(1, 2, 2), -- Route 1 includes leg 2 (ATL to JFK)
(2, 4, 1); -- Route 2 includes leg 4 (BWI to JFK)

insert into flight (flightID, routeID, support_airline, support_tail, progress, status, next_time, cost) values
('FL001', 1, 'DL', 'N123DL', 1, 'on_ground', '14:00:00', 500.00),
('FL002', 1, 'DL', 'N456DL', 2, 'on_ground', '15:00:00', 600.00),
('FL003', 2, 'UA', 'N101UA', 1, 'in_flight', '16:00:00', 550.00);

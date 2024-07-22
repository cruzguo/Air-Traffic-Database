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
('DL', 'N123DL', 150, 560, 'LOC1', 'jet', 0, 2),
('DL', 'N456DL', 180, 580, 'LOC2', 'jet', 0, 2),
('SW', 'N789SW', 140, 500, 'LOC3', 'jet', 0, 2),
('UA', 'N101UA', 160, 550, 'LOC2', 'jet', 0, 2),
('UA', 'N202UA', 200, 600, 'LOC2', 'jet', 0, 2);

insert into leg (legID, distance, departure, arrival) values
(1, 300, 'BWI', 'ATL'),
(2, 750, 'ATL', 'JFK'),
(3, 300, 'JFK', 'BWI'),
(4, 600, 'BWI', 'JFK');

insert into route (routeID) values
('BWI-ATL-JFK'), -- Route from BWI to ATL to JFK
('BWI-JFK'); -- Route from BWI to JFK

insert into route_path (routeID, legID, sequence) values
('BWI-ATL-JFK', 1, 1), -- Route 1 includes leg 1 (BWI to ATL)
('BWI-ATL-JFk', 2, 2), -- Route 1 includes leg 2 (ATL to JFK)
('BWI-JFK', 4, 1); -- Route 2 includes leg 4 (BWI to JFK)

insert into flight (flightID, routeID, support_airline, support_tail, progress, status, next_time, cost) values
('FL001', 'BWI-ATL-JFK', 'DL', 'N123DL', 1, 'on_ground', '14:00:00', 500.00),
('FL002', 'BWI-ATL-JFK', 'DL', 'N456DL', 2, 'on_ground', '15:00:00', 600.00),
('FL003', 'BWI-JFK', 'UA', 'N101UA', 1, 'on_ground', '16:00:00', 550.00);

-- insert stuff below
insert into airline values
('AA', 1000000.00),
('BB', 20000000.00),
('CC', 98983832),
('DD', 322.25),
('EE', 4334344222.19);

insert into location values
('LOC4'),
('LOC5'),
('LOC6'),
('LOC7'),
('LOC8');

insert into airplane values
('DL', 'N789DL', 150, 717, 'LOC5', 'jet', False, 0, 20),
('AA', 'N111AA', 300, 300, null, 'big helicopter', False, 1, 2),
('BB', 'N111BB', 211, 1589, 'LOC2', 'jet', False, 0, 40),
('UA', 'N301UA', 10, 269, 'LOC7', 'propeller', True, 3, 0),
('CC', 'N111CC', 709, 678, 'LOC8', 'jet', False, 0, 62);

insert into airport values
('BCA', 'Big Chungus Airport', 'Atlanta', 'Georgia', 'USA', 'LOC2'),
('AAA', 'Amogus Airport', 'Bacon Level', 'Alabama', 'USA', 'LOC5'),
('TTA', 'Tilted Towers Airport', 'Batman', 'Batman', 'Turkey', 'LOC6'),
('RO', 'Residencia Onix', 'Barcelona', 'Cataluyna', 'Spain', 'LOC4'),
('GAN', 'Good Airport Name', 'Boring', 'Tennessee', 'USA', 'LOC8');

insert into leg values
(78, 424.67, 'BCA', 'AAA'),
(17, 111.11, 'AAA', 'BWI'),
(12111, 673.56, 'JFK', 'ATL'),
(2233, 901.20, 'TTA', 'TTA'),
(900, 200.33, 'RO', 'GAN');

insert into route values
('BCA-AAA-BWI'),
('RO-GAN'),
('JFK-ATL'),
('AAA-TTA-GAN'),
('GAN-BWI-BCA'),
('BCA-BWI-JFK'),
('BCA-BWI');

insert into route_path values
('JFK-ATL', 12111, 69),
('BCA-AAA-BWI', 78, 1),
('BCA-BWI', 17, 2),
('AAA-TTA-GAN', 2233, 1),
('RO-GAN', 900, 1),
('BCA-BWI-JFK', 4, 2);

insert into flight values
('FL008', 'BCA-AAA-BWI', 'AA', 'N111AA', 1, 'in_flight', '05:22:17', 1.50),
('FL004', 'BCA-BWI-JFK', 'BB', 'N111BB', 1, 'on_ground', '12:57:10', 982.22),
('FL005', 'JFK-ATL', 'CC', 'N111CC', 2, 'on_ground', '13:33:00', 2000.00),
('FL006', 'AAA-TTA-GAN', 'DL', 'N789DL', 1, 'on_ground', '22:01:22', 100.50),
('FL007', 'GAN-BWI-BCA', 'UA', 'N301UA', 3, 'on_ground', '20:12:09', 4440.10);

-- insert stuff below
insert into airline values
(1, 1000000.00),
(2, 20000000.00),
(3, 98983832),
(4, 322.25),
(5, 4334344222.19);

insert into location values
(12),
(3478),
(727),
(007),
(12287);

insert into airplane values
(1, 45, 150, 717, 12, 'jet', False, 0, 20),
(4, 111, 300, 300, null, 'big helicopter', False, 1, 2),
(5, 88, 211, 1589, 3478, 'jet', False, 0, 40),
(2, 9843, 10, 269, 007, 'propeller', True, 3, 1),
(3, 2, 709, 678, null, 'jet', True, 0, 62);

insert into airport values
(4578, 'Big Chungus Airport', 'Accident', 'Maryland', 'USA', 727),
(666, 'Amogus Airport', 'Bacon Level', 'Alabama', 'USA', 3478),
(2349, 'Tilted Towers Airport', 'Batman', 'Batman', 'Turkey', 12),
(8765, 'Residencia Onix', 'Barcelona', 'Cataluyna', 'Spain', 007),
(5, 'Good Airport Name', 'Boring', 'Tennessee', 'USA', 12287);

insert into leg values
(78, 424.67, 5, 666),
(17, 111.11, 2349, 8765),
(12111, 673.56, 666, 4578),
(2233, 901.20, 8765, 4578),
(900, 200.33, 4578, 5);

insert into route values
(23),
(66),
(92),
(1),
(45);

insert into route_path values
(23, 12111, 69),
(66, 78, 69),
(92, 17, 69),
(1, 2233, 69),
(45, 900, 69);
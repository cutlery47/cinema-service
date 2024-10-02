\connect cinema_service


INSERT INTO service_schema.cinema_category (category, capacity) VALUES 
    ('premium', 1000),
    ('family', 300),
    ('children', 500),
    ('default', 400);


INSERT INTO service_schema.cinema (category_id, name, district, street, building) VALUES 
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'premium'),   'Киномакс',      'Московский',       'пр-кт Новоизмайловский', '7'),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'default'),   'Дом Кино',      'Василеостровский', 'ул. В.Дудки',            '69'),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'children'),  'Кино Плюс',     'Московский',       'ул. И.Ванермонда',       '228'),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'family'),    'Супер Кино',    'Богдановский',     'ул. Голангова',          '23');


INSERT INTO service_schema.movie (name, production, director, genre, length) VALUES
    ('Лесная Братва 3D',        'Columbia Pictures',  'Стивен Спилберг', 'Триллер', '01:30:15'),
    ('Шитов и Все Его Друзья',  'Shitov Studios',     'Шитов Богдан',    'Комедия', '00:15:12'),
    ('Большой Побег Шичковых',  'Cutlery Animations', 'Леонид Усачев',   'Боевик',  '3:30:47');


INSERT INTO service_schema.cinema_movies (cinema_id, movie_id) VALUES
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Супер Кино'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'));


INSERT INTO service_schema.ticket_price (category_id, movie_id, price) VALUES 
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'premium'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'), 1000),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'premium'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'), 900),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'premium'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'), 800),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'default'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'), 700),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'default'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'), 600),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'default'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'), 500),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'family'),  (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'), 400),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'family'),   (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'), 300),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'family'),   (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'), 200),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'children'), (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'), 100),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'children'), (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'), 50),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'children'), (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'), 25);


INSERT INTO service_schema.session (cinema_id, movie_id, price_id, starts_at, hall, remaining) VALUES
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'),    (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'),        (SELECT id FROM service_schema.ticket_price WHERE price = 1000),  '2024-10-07 19:30:00+04', 'Синий',      200),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'),    (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'),  (SELECT id FROM service_schema.ticket_price WHERE price = 900),   '2024-10-08 08:23:00+04', 'Черный',     100),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Киномакс'),    (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'),  (SELECT id FROM service_schema.ticket_price WHERE price = 800),   '2004-10-08 10:15:12+04', 'Зеленый',    300),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'),    (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'),        (SELECT id FROM service_schema.ticket_price WHERE price = 700),   '2024-10-07 19:30:00+04', 'Синий',      200),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'),    (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'),  (SELECT id FROM service_schema.ticket_price WHERE price = 600),   '2024-10-08 08:23:00+04', 'Черный',     100),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Дом Кино'),    (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'),  (SELECT id FROM service_schema.ticket_price WHERE price = 500),   '2004-10-08 10:15:12+04', 'Зеленый',    300),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'),   (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'),        (SELECT id FROM service_schema.ticket_price WHERE price = 100),   '2024-10-07 19:30:00+04', 'Синий',      200),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'),   (SELECT id FROM service_schema.movie WHERE name = 'Шитов и Все Его Друзья'),  (SELECT id FROM service_schema.ticket_price WHERE price = 50),    '2024-10-08 08:23:00+04', 'Черный',     100),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Кино Плюс'),   (SELECT id FROM service_schema.movie WHERE name = 'Большой Побег Шичковых'),  (SELECT id FROM service_schema.ticket_price WHERE price = 25),    '2004-10-08 10:15:12+04', 'Зеленый',    300),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Супер Кино'),  (SELECT id FROM service_schema.movie WHERE name = 'Лесная Братва 3D'),        (SELECT id FROM service_schema.ticket_price WHERE price = 400),   '2004-10-08 14:20:10+04', 'Розовый',     2);
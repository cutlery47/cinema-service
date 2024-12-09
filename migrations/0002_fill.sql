\connect cinema_service

INSERT INTO service_schema.cinema_category (category, capacity, price_mult)
VALUES
    ('Luxury', 500, 2.5),
    ('Standard', 300, 1.5),
    ('Economy', 50, 1.0);

INSERT INTO service_schema.cinema (category_id, name, location)
VALUES
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'Luxury'), 'Cinema Palace', 'Downtown'),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'Standard'), 'Movie Square', 'Midtown'),
    ((SELECT id FROM service_schema.cinema_category WHERE category = 'Economy'), 'Budget Movies', 'Uptown');

INSERT INTO service_schema.movie (name, production, director, genre, price)
VALUES
    ('Thrilling Escape', 'Studio A', 'Director X', 'thriller', 500),
    ('Haunted Mansion', 'Studio B', 'Director Y', 'horror', 400),
    ('Laugh Out Loud', 'Studio C', 'Director Z', 'comedy', 300),
    ('Dramatic Tales', 'Studio D', 'Director W', 'drama', 350),
    ('Detective Mystery', 'Studio E', 'Director Q', 'detective', 450),
    ('Comic Adventures', 'Studio F', 'Director R', 'comedy', 320),
    ('Tragic Love Story', 'Studio G', 'Director S', 'tragedy', 370);

INSERT INTO service_schema.repertoire (cinema_id, movie_id)
VALUES
    -- Cinema Palace
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Thrilling Escape')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Haunted Mansion')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Dramatic Tales')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Detective Mystery')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Comic Adventures')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace'), (SELECT id FROM service_schema.movie WHERE name = 'Tragic Love Story')),
    -- Movie Square
    ((SELECT id FROM service_schema.cinema WHERE name = 'Movie Square'), (SELECT id FROM service_schema.movie WHERE name = 'Thrilling Escape')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Movie Square'), (SELECT id FROM service_schema.movie WHERE name = 'Haunted Mansion')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Movie Square'), (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Movie Square'), (SELECT id FROM service_schema.movie WHERE name = 'Dramatic Tales')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Movie Square'), (SELECT id FROM service_schema.movie WHERE name = 'Detective Mystery')),
    -- Budget Movie
    ((SELECT id FROM service_schema.cinema WHERE name = 'Budget Movies'), (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')),
    ((SELECT id FROM service_schema.cinema WHERE name = 'Budget Movies'), (SELECT id FROM service_schema.movie WHERE name = 'Dramatic Tales'));


INSERT INTO service_schema.session (repertoire_id, starts_at, remaining)
VALUES
    -- Cinema Palace
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Thrilling Escape')), '2025-01-04 12:00:00+00', 298),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Haunted Mansion')), '2025-01-04 18:00:00+00', 112),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')), '2025-01-05 14:00:00+00', 350),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Cinema Palace') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Detective Mystery')), '2025-01-05 20:00:00+00', 400),
    -- Movie Square
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Movie Square') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Thrilling Escape')), '2025-01-02 12:00:00+00', 121),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Movie Square') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Haunted Mansion')), '2025-01-03 13:00:00+00', 104),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Movie Square') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Dramatic Tales')), '2025-01-04 14:00:00+00', 97),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Movie Square') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Detective Mystery')), '2025-01-05 15:00:00+00', 21),
    -- Budget Movies
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Budget Movies') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')), '2025-01-02 20:00:00+00', 20),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Budget Movies') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Dramatic Tales')), '2025-01-03 16:00:00+00', 15),
    ((SELECT id FROM service_schema.repertoire WHERE cinema_id = (SELECT id FROM service_schema.cinema WHERE name = 'Budget Movies') AND movie_id = (SELECT id FROM service_schema.movie WHERE name = 'Laugh Out Loud')), '2025-01-04 12:00:00+00', 5);

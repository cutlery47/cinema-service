-- Добавление фильма в репертуар кинотеатра
INSERT INTO 
    service_schema.repertoire (cinema_id, movie_id)
VALUES
    ((SELECT id FROM service_schema.cinema WHERE name = :cinema), (SELECT id FROM service_schema.movie WHERE name = :movie)),
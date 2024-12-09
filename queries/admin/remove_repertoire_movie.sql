-- Удаление фильма из репертуара кинотеатра
DELETE FROM 
    service_schema.repertoire
WHERE 
    cinema_id = (SELECT id FROM service_schema.cinema WHERE name = :cinema)
    AND
    movie_id = (SELECT id FROM service_schema.movie WHERE name = :movie)
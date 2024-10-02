\connect cinema_service

SELECT service_schema.movie.genre, service_schema.movie.production, service_schema.movie.director 
FROM service_schema.movie
WHERE service_schema.movie.name = :movie_name
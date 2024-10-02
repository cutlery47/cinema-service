\connect cinema_service

SELECT 
service_schema.movie.name
FROM
service_schema.movie
INNER JOIN 
service_schema.cinema_movies
ON 
service_schema.movie.id = service_schema.cinema_movies.movie_id
INNER JOIN 
service_schema.cinema
ON
service_schema.cinema.name = $1
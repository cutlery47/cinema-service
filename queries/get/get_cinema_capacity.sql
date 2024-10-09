SELECT
service_schema.movie.name
FROM 
service_schema.cinema_movies
JOIN 
service_schema.cinema
ON 
service_schema.cinema.id = service_schema.cinema_movies.cinema_id
JOIN 
service_schema.movie
ON 
service_schema.movie.id = service_schema.cinema_movies.movie_id
WHERE 
service_schema.cinema.name = $1;
DELETE FROM 
service_schema.cinema_movies
WHERE
service_schema.cinema_movies.cinema_id = $1
AND
service_schmea.cinema_movies.movie_id = $2
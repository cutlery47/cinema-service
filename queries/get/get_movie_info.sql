SELECT
service_schema.movie.production,
service_schema.movie.director
FROM 
service_schema.movie
WHERE 
service_schema.movie.name = $1
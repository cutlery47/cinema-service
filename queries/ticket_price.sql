\connect cinema_service

SELECT service_schema.session.id, service_schema.ticket_price.price 
FROM service_schema.ticket_price 
JOIN  
service_schema.session 
ON service_schema.ticket_price.movie_id = service_schema.session.movie_id
JOIN 
service_schema.movie
ON service_schema.session.movie_id = service_schema.movie.id
WHERE service_schema.movie.name = :movie_name;

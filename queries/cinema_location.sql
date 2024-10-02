\connect cinema_service

SELECT service_schema.cinema.district, service_schema.cinema.street, service_schema.cinema.building
FROM service_schema.cinema 
WHERE service_schema.cinema.name = :cinema_name;

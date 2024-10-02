\connect cinema_service 

SELECT service_schema.cinema_category.capacity 
FROM service_schema.cinema JOIN service_schema.cinema_category
ON service_schema.cinema.category_id = service_schema.cinema_category.id
WHERE service_schema.cinema.name = :cinema_name;
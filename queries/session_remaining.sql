\connect cinema_service 

SELECT service_schema.session.remaining
FROM service_schema.session 
WHERE service_schema.session.id = :session;
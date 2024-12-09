-- Получение местоположения кинотеатра
SELECT 
    location
FROM 
    service_schema.cinema
WHERE 
    name = :name
-- Получение вместимости кинотеатра
SELECT 
    ct.capacity 
FROM 
    service_schema.cinema AS c
    JOIN service_schema.cinema_category AS ct ON c.category_id = ct.id
WHERE 
    c.name = :name;
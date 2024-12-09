--- Получение репертуара кинотеатра
SELECT 
    c.name, m.name 
FROM 
    service_schema.repertoire AS r
    JOIN service_schema.cinema AS c ON r.cinema_id = c.id
    JOIN service_schema.movie AS m ON r.movie_id = m.id
WHERE 
    c.name = :name

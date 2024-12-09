-- Получение оставшихся мест на сеанс
SELECT 
    s.remaining 
FROM 
    service_schema.session AS s 
    JOIN service_schema.repertoire AS r ON s.repertoire_id = r.id 
    JOIN service_schema.movie AS m ON r.movie_id = m.id 
    JOIN service_schema.cinema AS c ON r.cinema_id = c.id 
WHERE 
    c.name = :cinema 
    AND 
    m.name = :movie
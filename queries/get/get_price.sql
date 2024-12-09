--- Получение цены билета на данный сеанс
SELECT 
    m.price * ct.price_mult AS ticket_price
FROM
    service_schema.session AS s
    JOIN service_schema.repertoire AS r ON s.repertoire_id = r.id
    JOIN service_schema.movie AS m ON r.movie_id = m.id
    JOIN service_schema.cinema AS c ON r.cinema_id = c.id
    JOIN service_schema.cinema_category AS ct ON c.category_id = ct.id
WHERE 
    c.name = :cinema
    AND 
    m.name = :movie
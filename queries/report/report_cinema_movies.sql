-- Выдача справки о сеансах фильма в указанном кинотеатре
SELECT 
    m.name AS movie, c.name AS cinema, s.starts_at, s.remaining, m.price * ct.price_mult AS ticket_price
FROM
    service_schema.session AS s 
    JOIN service_schema.repertoire AS r ON s.repertoire_id = r.id
    JOIN service_schema.movie AS m ON r.movie_id = m.id
    JOIN service_schema.cinema AS c ON r.cinema_id = c.id
    JOIN service_schema.cinema_category AS ct ON c.category_id = ct.id
WHERE 
    m.name = :movie
    AND
    c.name = :cinema

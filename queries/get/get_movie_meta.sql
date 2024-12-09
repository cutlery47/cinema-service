-- Получение жанра, производства и режиссера фильма
SELECT 
    name, production, director
FROM 
    service_schema.movie
WHERE 
    name = :name
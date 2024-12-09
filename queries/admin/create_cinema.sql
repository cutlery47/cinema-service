-- Добавление нового кинотеатра
INSERT INTO 
    service_schema.cinema (category_id, name, location)
VALUES 
    ((SELECT id FROM service_schema.cinema_category WHERE category = :category), :name, :location)


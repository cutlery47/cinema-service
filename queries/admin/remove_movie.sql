-- Удаление фильма из общего проката
DELETE FROM
    service_schema.movie
WHERE
    name = :name

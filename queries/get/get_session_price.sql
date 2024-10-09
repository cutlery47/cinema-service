SELECT
service_schema.ticket_price.price
FROM 
service_schema.session
JOIN
service_schema.ticket_price
ON 
service_schema.session.price_id = service_schema.ticket_price.id 
WHERE 
service_schema.session.id = $1

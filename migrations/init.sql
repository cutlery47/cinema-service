CREATE DATABASE cinema_service;

\connect cinema_service

CREATE SCHEMA service_schema;


CREATE TYPE service_schema.category_enum 
AS ENUM ('premium', 'family', 'children', 'default');


CREATE DOMAIN service_schema.positive_int AS integer
CHECK (
    VALUE > 0
) NOT NULL;


CREATE DOMAIN service_schema.non_negative_int AS integer 
CHECK (
    VALUE >= 0
) NOT NULL;


CREATE DOMAIN service_schema.uuid_key AS UUID
DEFAULT gen_random_uuid()
NOT NULL;


CREATE DOMAIN service_schema.string AS VARCHAR(256) NOT NULL;


CREATE TABLE service_schema.cinema_category (
    id       UUID       DEFAULT gen_random_uuid(),
    category service_schema.category_enum,
    capacity service_schema.positive_int,
    PRIMARY KEY (id)
);


CREATE TABLE service_schema.cinema (
    id          service_schema.uuid_key,
    category_id UUID    REFERENCES service_schema.cinema_category NOT NULL,
    name        service_schema.string,
    district    service_schema.string,
    street      service_schema.string,
    building    service_schema.string,
    PRIMARY KEY(id)
);


CREATE TABLE service_schema.movie (
    id          service_schema.uuid_key,
    name        service_schema.string,
    production  service_schema.string,
    director    service_schema.string,
    genre       service_schema.string,
    length      TIME    NOT NULL,
    PRIMARY KEY(id)
);


CREATE TABLE service_schema.cinema_movies (
    id          service_schema.uuid_key,
    cinema_id   UUID REFERENCES service_schema.cinema,
    movie_id    UUID REFERENCES service_schema.movie,
    PRIMARY KEY(id)
);


CREATE TABLE service_schema.ticket_price (
    id          service_schema.uuid_key,
    category_id UUID REFERENCES service_schema.cinema_category NOT NULL,
    movie_id    UUID REFERENCES service_schema.movie           NOT NULL,
    price       service_schema.positive_int,
    PRIMARY KEY(id)
);


CREATE TABLE service_schema.session (
    id          service_schema.uuid_key,
    cinema_id   UUID REFERENCES service_schema.cinema       NOT NULL,
    movie_id    UUID REFERENCES service_schema.movie        NOT NULL,
    price_id    UUID REFERENCES service_schema.ticket_price NOT NULL,
    starts_at   TIMESTAMP WITH TIME ZONE                    NOT NULL,
    hall        service_schema.string,
    remaining   service_schema.non_negative_int,
    PRIMARY KEY(id)
);
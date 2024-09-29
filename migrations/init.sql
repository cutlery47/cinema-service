CREATE DATABASE cinema_service;
\connect cinema_service

CREATE SCHEMA service_schema;

-- extension for storing geolocation and shie
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA service_schema;

CREATE TYPE service_schema.category_enum as ENUM ('premium', 'family', 'children', 'default');

CREATE DOMAIN service_schema.positive_int AS integer CHECK (VALUE > 0);
CREATE DOMAIN service_schema.non_negative_int AS integer CHECK (VALUE >= 0);
CREATE DOMAIN service_schema.string AS VARCHAR(256);

CREATE TABLE service_schema.cinema_category (
    id UUID  DEFAULT gen_random_uuid() PRIMARY KEY,
    category service_schema.category_enum NOT NULL,
    capacity service_schema.positive_int NOT NULL
);

CREATE TABLE service_schema.cinema (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id UUID REFERENCES service_schema.cinema_category NOT NULL,
    name service_schema.string NOT NULL,
    district service_schema.string NOT NULL,
    location service_schema.GEOGRAPHY(Point) NOT NULL
);

CREATE TABLE service_schema.movie (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name service_schema.string NOT NULL,
    production service_schema.string NOT NULL,
    director service_schema.string NOT NULL,
    genre service_schema.string NOT NULL,
    length time NOT NULL
);

CREATE TABLE service_schema.cinema_movies (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    cinema_id UUID REFERENCES service_schema.cinema NOT NULL,
    movie_id UUID REFERENCES service_schema.movie NOT NULL
);

CREATE TABLE service_schema.ticket_price (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id UUID REFERENCES service_schema.cinema_category NOT NULL,
    movie_id UUID REFERENCES service_schema.movie NOT NULL,
    price service_schema.positive_int NOT NULL
);

CREATE TABLE service_schema.session (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    cinema_id UUID REFERENCES service_schema.cinema NOT NULL,
    movie_id UUID REFERENCES service_schema.movie NOT NULL,
    price_id UUID REFERENCES service_schema.ticket_price NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    hall service_schema.string NOT NULL,
    remaining service_schema.non_negative_int NOT NULL
);
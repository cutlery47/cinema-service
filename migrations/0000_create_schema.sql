CREATE DATABASE cinema_service;

\connect cinema_service

CREATE SCHEMA IF NOT EXISTS service_schema;


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

CREATE TYPE service_schema.genre_enum 
AS ENUM ('thriller', 'horror', 'comedy', 'tragedy', 'drama', 'detective');
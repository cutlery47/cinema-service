\connect cinema_service

-- Таблица для хранения категорий кинотеатров
CREATE TABLE IF NOT EXISTS service_schema.cinema_category (
    id              service_schema.uuid_key         PRIMARY KEY,
    -- Название категории
    category        service_schema.string,
    -- Вместимость кинотеатра
    capacity        service_schema.positive_int,
    -- Каждая катеория имеет некоторый множитель цены 
    price_mult      float
);

-- Таблица для хранения кинотеатров
CREATE TABLE IF NOT EXISTS service_schema.cinema (
    id          service_schema.uuid_key     PRIMARY KEY,
    -- Ссылка на категорию
    category_id UUID                        REFERENCES service_schema.cinema_category NOT NULL,
    -- Название кинотеатра
    name        service_schema.string,
    -- Расположение кинотеатра
    location    service_schema.string
);

-- Таблица для хранения фильмов
CREATE TABLE IF NOT EXISTS service_schema.movie (
    id          service_schema.uuid_key     PRIMARY KEY,
    -- Название фильма
    name        service_schema.string,
    -- Производство фильма
    production  service_schema.string,
    -- Режиссер фильма
    director    service_schema.string,
    -- Жанр фильма 
    genre       service_schema.genre_enum,
    -- Прокатная стоимость фильма
    price       service_schema.positive_int
);

-- Таблица для хранения фильмов в репертуаре кинотеатра
CREATE TABLE IF NOT EXISTS service_schema.repertoire (
    id          service_schema.uuid_key                     PRIMARY KEY,
    -- Идентификатор кинотеатра
    cinema_id   UUID REFERENCES service_schema.cinema       NOT NULL,
    -- Идентификатор фильма
    movie_id    UUID REFERENCES service_schema.movie        NOT NULL,

    UNIQUE(cinema_id, movie_id)
);

-- Таблица для хранения сеансов
CREATE TABLE IF NOT EXISTS service_schema.session (
    id              service_schema.uuid_key                     PRIMARY KEY,
    -- Ссылка на пару "Кинотеатр - Фильм"
    repertoire_id   UUID REFERENCES service_schema.repertoire   NOT NULL,
    -- Время начало сеанса
    starts_at       TIMESTAMP WITH TIME ZONE                    NOT NULL,
    -- Число доступных мест на сеанс
    remaining       service_schema.non_negative_int
);
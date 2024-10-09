package storage

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

type Storage struct {
	db *sql.DB
}

func New(user, password, dbname string) (*Storage, error) {
	connStr := fmt.Sprintf("user=%v password=%v dbname=%v", user, password, dbname)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	storage := &Storage{
		db: db,
	}

	return storage, nil
}

func (s Storage) GetCinemaRepertoire(cinemaName string) (res []string, err error) {
	query :=
		`
		SELECT
		service_schema.movie.name
		FROM 
		service_schema.cinema_movies
		JOIN 
		service_schema.cinema
		ON 
		service_schema.cinema.id = service_schema.cinema_movies.cinema_id
		JOIN 
		service_schema.movie
		ON 
		service_schema.movie.id = service_schema.cinema_movies.movie_id
		WHERE 
		service_schema.cinema.name = $1;
		`

	rows, err := s.db.Query(query, cinemaName)
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

	for rows.Next() {
		movie := ""
		rows.Scan(&movie)
		res = append(res, movie)
	}

	return res, nil
}

func (s Storage) GetCinemaLocation(cinemaName string) (res string, err error) {
	query :=
		`
		SELECT 
		service_schema.cinema.district,
		service_schema.cinema.street,
		service_schema.cinema.building
		FROM
		service_schema.cinema
		WHERE
		service_schema.cinema.name = $1
		`

	row := s.db.QueryRow(query, cinemaName)

	var district, street, building string
	err = row.Scan(&district, &street, &building)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	res = fmt.Sprintf("%v, %v, %v", district, street, building)
	return res, nil
}

func (s Storage) GetCinemaCapacity(cinemaName string) (res string, err error) {
	query :=
		`
		SELECT
		service_schema.cinema_category.capacity
		FROM 
		service_schema.cinema
		JOIN 
		service_schema.cinema_category
		ON
		service_schema.cinema.category_id = service_schema.cinema_category.id
		WHERE 
		service_schema.cinema.name = $1
		`

	row := s.db.QueryRow(query, cinemaName)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

func (s Storage) GetSessionRemaining(sessionId string) (res string, err error) {
	query :=
		`
		SELECT
		service_schema.session.remaining
		FROM 
		service_schema.session
		WHERE 
		service_schema.session.id = $1
		`

	row := s.db.QueryRow(query, sessionId)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

func (s Storage) GetSessionPrice(sessionId string) (res string, err error) {
	query :=
		`
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
		`

	row := s.db.QueryRow(query, sessionId)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

func (s Storage) GetMovieInfo(movieName string) (res string, err error) {
	query :=
		`
		SELECT
		service_schema.movie.production,
		service_schema.movie.director
		FROM 
		service_schema.movie
		WHERE 
		service_schema.movie.name = $1
		`

	row := s.db.QueryRow(query, movieName)

	var production, director string
	err = row.Scan(&production, &director)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	res = fmt.Sprintf("%v, %v", production, director)
	return res, nil
}

func (s Storage) AddCinemaRepertoire(cinemaName, movieName string) (res string, err error) {

	cinemaQuery :=
		`
		SELECT 
		service_schema.cinema.id
		FROM 
		service_schema.cinema
		WHERE 
		service_schema.cinema.name = $1
		`
	cinemaRow := s.db.QueryRow(cinemaQuery, cinemaName)

	cinemaId := ""
	err = cinemaRow.Scan(&cinemaId)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	movieQuery :=
		`
		SELECT
		service_schema.movie.id
		FROM 
		service_schema.movie
		WHERE
		service_schema.movie.name = $1
		`
	movieRow := s.db.QueryRow(movieQuery, movieName)

	movieId := ""
	err = movieRow.Scan(&movieId)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	query :=
		`
		INSERT INTO
		service_schema.cinema_movies
		VALUES
		$1,
		$2
		`
	row := s.db.QueryRow(query, cinemaId, movieId)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

func (s Storage) DeleteCinemaRepertoire(cinemaName, movieName string) (res string, err error) {
	cinemaQuery :=
		`
	SELECT 
	service_schema.cinema.id
	FROM 
	service_schema.cinema
	WHERE 
	service_schema.cinema.name = $1
	`
	cinemaRow := s.db.QueryRow(cinemaQuery, cinemaName)

	cinemaId := ""
	err = cinemaRow.Scan(&cinemaId)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	movieQuery :=
		`
		SELECT
		service_schema.movie.id
		FROM 
		service_schema.movie
		WHERE
		service_schema.movie.name = $1
		`
	movieRow := s.db.QueryRow(movieQuery, movieName)

	movieId := ""
	err = movieRow.Scan(&movieId)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	query :=
		`
		DELETE FROM 
		service_schema.cinema_movies
		WHERE
		service_schema.cinema_movies.cinema_id = $1
		AND
		service_schmea.cinema_movies.movie_id = $2
		`
	row := s.db.QueryRow(query, cinemaId, movieId)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

func (s Storage) AddCinema(cinemaName, categoryName, district, street, building string) (res string, err error) {
	categoryQuery :=
		`
	SELECT 
	service_schema.cinema_category.id
	FROM 
	service_schema.cinema_category
	WHERE 
	service_schema.cinema_category.name = $1
	`
	cinemaRow := s.db.QueryRow(categoryQuery, categoryName)

	categoryId := ""
	err = cinemaRow.Scan(&categoryId)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	query :=
		`
		INSERT INTO
		service_schema.cinema
		category_id,
		name,
		district,
		street,
		building
		VALUES
		$1,
		$2,
		$3,
		$4,
		$5
		`
	row := s.db.QueryRow(query, categoryId, cinemaName, district, street, building)

	err = row.Scan(&res)
	if err != nil {
		log.Println("Error:", err)
		if err == sql.ErrNoRows {
			return res, ErrNotFound
		} else {
			return res, ErrInternal
		}
	}

	return res, nil
}

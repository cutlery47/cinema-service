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

func (s Storage) HandleRepertoire(cinemaName string) (res []string, err error) {
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

func (s Storage) HandleLocation(cinemaName string) (res string, err error) {
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

func (s Storage) HandleSessionRemaining(sessionId string) (res string, err error) {
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

func (s Storage) HandleSessionPrice(sessionId string) (res string, err error) {
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

func (s Storage) HandleMovieInfo(movieName string) (res string, err error) {
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

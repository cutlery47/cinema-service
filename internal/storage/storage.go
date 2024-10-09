package storage

import (
	"database/sql"
	"fmt"
	"log"
	"os"

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
	query, err := queryFromFile("queries/get/get_cinema_repertoire.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	query, err := queryFromFile("queries/get/get_cinema_location.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	query, err := queryFromFile("queries/get/get_cinema_capacity.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	query, err := queryFromFile("queries/get/get_session_remaining.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	query, err := queryFromFile("queries/get/get_sesion_price.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	query, err := queryFromFile("queries/get/get_movie_info.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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
	cinemaQuery, err := queryFromFile("queries/get/get_cinema_by_name.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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

	movieQuery, err := queryFromFile("queries/get/get_movie_by_name.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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

	query, err := queryFromFile("queries/get/add_movie.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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
	cinemaQuery, err := queryFromFile("queries/get/get_cinema_by_name.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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

	movieQuery, err := queryFromFile("queries/get/get_movie_by_name.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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

	query, err := queryFromFile("queries/delete/delete_movie.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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
	categoryQuery, err := queryFromFile("queries/get/get_category_by_name.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}

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

	query, err := queryFromFile("queries/add/add_cinema.sql")
	if err != nil {
		log.Println("Error:", err)
		return res, ErrInternal
	}
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

func queryFromFile(path string) (query string, err error) {
	fd, err := os.Open(path)
	if err != nil {
		return "", fmt.Errorf("error when openning getting file desc: %v", err)
	}
	defer fd.Close()

	stat, _ := fd.Stat()

	byteQuery := make([]byte, stat.Size())
	fd.Read(byteQuery)

	return string(byteQuery), nil
}

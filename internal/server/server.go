package server

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/cutlery47/cinema-service/internal/storage"
)

type server struct {
	mux  *http.ServeMux
	addr string
	serv *storage.Storage
}

func New(host, port string, storage *storage.Storage) *server {
	mux := http.NewServeMux()
	addr := fmt.Sprintf("%v:%v", host, port)
	serv := storage

	server := &server{
		mux:  mux,
		addr: addr,
		serv: serv,
	}

	server.setRoutes()

	return server
}

func (s server) setRoutes() {

	s.mux.HandleFunc("GET /api/v1/cinema/{cinemaName}/repertoire/", func(w http.ResponseWriter, r *http.Request) {
		cinemaName := r.PathValue("cinemaName")
		res, err := s.serv.HandleRepertoire(cinemaName)
		if err != nil {
			w.Write([]byte(err.Error()))
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		stringRes := ""
		for _, el := range res {
			stringRes += fmt.Sprintf("%v,", el)
		}

		w.Write([]byte(stringRes))
	})

	s.mux.HandleFunc("GET /api/v1/cinema/{cinemaName}/location/", func(w http.ResponseWriter, r *http.Request) {
		cinemaName := r.PathValue("cinemaName")
		res, err := s.serv.HandleLocation(cinemaName)
		if err != nil {
			res = err.Error()
			if errors.Is(err, storage.ErrNotFound) {
				w.WriteHeader(http.StatusNotFound)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
		}
		w.Write([]byte(res))
	})

	s.mux.HandleFunc("GET /api/v1/cinema/{cinemaName}/capacity/", func(w http.ResponseWriter, r *http.Request) {
		cinemaName := r.PathValue("cinemaName")
		res, err := s.serv.HandleMovieInfo(cinemaName)
		if err != nil {
			res = err.Error()
			if errors.Is(err, storage.ErrNotFound) {
				w.WriteHeader(http.StatusNotFound)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
		}

		w.Write([]byte(res))
	})

	s.mux.HandleFunc("GET /api/v1/session/{sessionId}/remaining/", func(w http.ResponseWriter, r *http.Request) {
		sessionId := r.PathValue("sessionId")
		res, err := s.serv.HandleSessionRemaining(sessionId)
		if err != nil {
			res = err.Error()
			if errors.Is(err, storage.ErrNotFound) {
				w.WriteHeader(http.StatusNotFound)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
		}
		w.Write([]byte(res))
	})

	s.mux.HandleFunc("GET /api/v1/session/{sessionId}/price/", func(w http.ResponseWriter, r *http.Request) {
		sessionId := r.PathValue("sessionId")
		res, err := s.serv.HandleSessionPrice(sessionId)
		if err != nil {
			res = err.Error()
			if errors.Is(err, storage.ErrNotFound) {
				w.WriteHeader(http.StatusNotFound)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
		}
		w.Write([]byte(res))
	})

	s.mux.HandleFunc("GET /api/v1/movie/{movieName}/info/", func(w http.ResponseWriter, r *http.Request) {
		movieName := r.PathValue("movieName")
		res, err := s.serv.HandleMovieInfo(movieName)
		if err != nil {
			res = err.Error()
			if errors.Is(err, storage.ErrNotFound) {
				w.WriteHeader(http.StatusNotFound)
			} else {
				w.WriteHeader(http.StatusInternalServerError)
			}
		}

		w.Write([]byte(res))
	})
}

func (s server) Run() {
	http.ListenAndServe(s.addr, s.mux)
}

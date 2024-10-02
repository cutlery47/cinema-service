package main

import (
	"log"
	"os"

	"github.com/cutlery47/cinema-service/internal/server"
	"github.com/cutlery47/cinema-service/internal/storage"
	_ "github.com/joho/godotenv/autoload"
)

var (
	user     = os.Getenv("POSTGRES_USER")
	password = os.Getenv("POSTGRES_PASSWORD")
)

func main() {
	storage, err := storage.New(user, password, "cinema_service")
	if err != nil {
		log.Fatal("couldn't connect to the database:", err)
	}
	server := server.New("localhost", "6969", storage)
	server.Run()
}

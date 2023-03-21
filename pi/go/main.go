package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

type SensorData struct {
	Temperature float64 `json:"temperature"`
	Humidity    float64 `json:"humidity"`
}

func main() {
	connStr := "host=localhost port=5432 user=postgres password=postgres dbname=testingdb sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	log.Printf("Connection to DB estabilished")
	stmt, err := db.Prepare("INSERT INTO readings (temp, humidity) VALUES ($1, $2)")
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Up and running, listening on port 8080")
	http.HandleFunc("/sensor-data", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			var sensorData SensorData
			err := json.NewDecoder(r.Body).Decode(&sensorData)
			if err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}
			log.Printf("Received sensor data: %+v", sensorData)
			_, err = stmt.Exec(sensorData.Temperature, sensorData.Humidity)
			if err != nil {
				log.Fatal(err)
			}
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}

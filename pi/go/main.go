package main

import (
	//"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

type SensorData struct {
	//sensor values
	Out_Temperature float64 `json:"out_temperature"` //dht22
	Humidity float64 `json:"humidity"` //dht22
	Temperature float64 `json:"temperature"` //ds18b20
	Flow float64 `json:"flow"` //yf-s201
	Turbidity float64 `json:"turbidity"` 
	//static values inserted by keypad
	Before_Temperature float64 `json:"before_temperature"` //cooking thermometer
	Water float64 `json:"water"`
	Food_Oil float64 `json:"food_oil"`
	Engine_Oil float64 `json:"engine_oil"`
	Oil_brand string `json:"oil_brand"`
}

func main() {
	/* 	connStr := "host=localhost port=5432 user=postgres password=postgres dbname=testingdb sslmode=disable"
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
	   	}) */
	log.Printf("Up and running, listening on port 8080")
	http.HandleFunc("/sensor-data", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			var sensorData SensorData
			_ = json.NewDecoder(r.Body).Decode(&sensorData)
			log.Printf("Received sensor data: %+v", sensorData)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}

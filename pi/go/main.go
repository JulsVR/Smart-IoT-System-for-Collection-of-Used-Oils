package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"time"

	_ "github.com/lib/pq"

)

type SensorData struct {
	//sensor values
	Flow            float64 `json:"flow"`            //yf-s201
	Air_Temperature float64 `json:"air_temperature"` //dht22
	Humidity        float64 `json:"humidity"`        //dht22
	Liq_Temperature float64 `json:"liq_temperature"` //ds18b20
	Turbidity       float64 `json:"turbidity"`
	//static values inserted by keypad
	Before_Temperature float64 `json:"before_temperature"` //cooking thermometer
	Water              int32   `json:"water"`
	Food_Oil           int32   `json:"food_oil"`
	Engine_Oil         int32   `json:"engine_oil"`
	Oil_brand		   string  `json:"oil_brand"`
	Timestamp		   time.Time `json:"timestamp"`
}

func main() {
	connStr := "host=localhost port=5432 user=postgres password=postgres dbname=oau_22_23 sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	log.Printf("Connection to DB estabilished")
	stmt, err := db.Prepare("INSERT INTO readings (flow,air_temperature,humidity,liq_temperature,turbidity,before_temperature,water,food_oil,engine_oil,oil_brand,timestamp) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)")
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
				log.Fatal(err)
				return
			}
			sensorData.Timestamp=time.Now().UTC()
			log.Printf("Received sensor data: %+v", sensorData)
			_, err = stmt.Exec(sensorData.Flow, sensorData.Air_Temperature, sensorData.Humidity, sensorData.Liq_Temperature, sensorData.Turbidity, sensorData.Before_Temperature, sensorData.Water, sensorData.Food_Oil, sensorData.Engine_Oil, sensorData.Oil_brand, sensorData.Timestamp)
			if err != nil {
				log.Fatal(err)
			}
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}

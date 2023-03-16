package main

import (
	"encoding/json"
	"log"
	"net/http"
)


type SensorData struct {
	Temperature float64 `json:"temperature"`
	Humidity float64 `json:"humidity"`
}

func main() {
    http.HandleFunc("/sensor-data", func(w http.ResponseWriter, r *http.Request) {
        if r.Method == "POST" {
            var sensorData SensorData
            err := json.NewDecoder(r.Body).Decode(&sensorData)
            if err != nil {
                http.Error(w, err.Error(), http.StatusBadRequest)
                return
            }
            log.Printf("Received sensor data: %+v", sensorData)
            // Do something with the sensor data
        } else {
            http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        }
    })

    log.Fatal(http.ListenAndServe(":8080", nil))
}

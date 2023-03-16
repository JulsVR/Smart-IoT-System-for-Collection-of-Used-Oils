//#include "ESPAsyncWebServer.h"
#include <Arduino.h>
#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>


// Set your access point network credentials
const char* ssid = "ufp";
const char* password = "";

// Create AsyncWebServer object on port 80
// AsyncWebServer server(9500);

unsigned long lastTime = 0;
unsigned long timerDelay = 1000;

const char* serverName = "http://10.10.43.113:8080/sensor-data";


void setup(){
  // Serial port for debugging purposes
  Serial.begin(115200);
  Serial.println();
  
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to WiFi network with IP Address: ");
  Serial.println(WiFi.localIP());
  
  Serial.println("Timer set to 1 seconds (timerDelay variable), it will take 1 seconds before publishing the first reading.");

  bool status;
}
 
void loop() {
  //Send an HTTP POST request every 10 minutes
  if ((millis() - lastTime) > timerDelay) {
    //Check WiFi connection status
    if(WiFi.status()== WL_CONNECTED){
      WiFiClient client;
      HTTPClient http;
    
      // Your Domain name with URL path or IP address with path
      http.begin(client, serverName);
      
      http.addHeader("Content-Type", "application/json");
      int httpResponseCode = http.POST("{\"temperature\":25.0,\"humidity\":50.0}");
     
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
        
      // Free resources
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}
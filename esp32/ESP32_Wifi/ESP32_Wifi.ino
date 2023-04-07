#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>


// Network credentials
const char* ssid = "ufp";
const char* password = "";

unsigned long lastTime = 0;
unsigned long timerDelay = 10000;

const char* serverName = "http://10.10.43.113:8080/sensor-data";


void setup(){

  Serial.begin(115200);
  Serial.println();
  
  WiFi.begin(ssid, password);
  Serial.println("Connecting...");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(" .");
  }
  Serial.println("");
  Serial.print("Connected.");
}
 
void loop() {
  // Send an HTTP POST request every 10 seconds
  if ((millis() - lastTime) > timerDelay) {

    if(WiFi.status()== WL_CONNECTED){
      WiFiClient client;
      HTTPClient http;
    
      http.begin(client, serverName);
      
      http.addHeader("Content-Type", "application/json");
      int httpResponseCode = http.POST("{\"temperature\":25.0,\"humidity\":50.0}");
     
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
        
      http.end();
    }
    else {
      Serial.println("WiFi Disconnected");
    }
    lastTime = millis();
  }
}

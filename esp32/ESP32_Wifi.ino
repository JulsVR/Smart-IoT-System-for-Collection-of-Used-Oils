#include <Arduino.h>
#include "WiFi.h"
#include "ESPAsyncWebServer.h"
#include <Wire.h>


// Set your access point network credentials
const char* ssid = "ufp";
const char* password = "";

// Create AsyncWebServer object on port 80
AsyncWebServer server(8080);

String readTemp() {
  return String(50);
}

void setup(){
  // Serial port for debugging purposes
  Serial.begin(115200);
  Serial.println();
  
  // Setting the ESP as an access point
  Serial.print("Setting AP (Access Point)…");
  // Remove the password parameter, if you want the AP (Access Point) to be open
  WiFi.softAP(ssid, password);

  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/plain", readTemp().c_str());
  });

  
  bool status;

  // Start server
  server.begin();
}
 
void loop(){
  
}
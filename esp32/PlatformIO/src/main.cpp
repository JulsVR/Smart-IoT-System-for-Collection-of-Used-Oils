#include <Arduino.h>
#include <OneWire.h>
#include <Keypad.h>
#include <DallasTemperature.h>
#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "DHT.h"
#define DHTPIN 14 // GPIO14
#define ONE_WIRE_BUS 4
#define DHTTYPE DHT22 // DHT22 (AM2302)
DHT dht(DHTPIN, DHTTYPE);


OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

boolean reading = false;

int flowSensorPin = 2;   
volatile double waterflow;
unsigned long lastTime = 0;
unsigned long timerDelay = 1000;
unsigned long pulseDuration; 

unsigned short water = 90.0;
unsigned short food_oil = 10.0;
unsigned short car_oil = 0.0;
//float calibrationFactor = 1.44;
float calibrationFactor =  0.884;
float before_temperature = 20.0;
unsigned short before_values[2] = {0,0};

const byte ROWS = 4; 
const byte COLS = 3;
const char* ssid = "ufp";
const char* password = "";
const char* serverName = "http://10.10.43.113:8080/sensor-data";

byte rowPins[ROWS] = {22,25,33,19}; 
byte colPins[COLS] = {21,23,32}; 
byte sensorInterrupt = digitalPinToInterrupt(2);

char keys[ROWS][COLS] = { 
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );



void pulseCounter() {
  waterflow +=  1.0 / 450.0;
}

void setup() {
  Serial.begin(9600);
  sensors.begin();
  dht.begin();
  //  gpio_install_isr_service(0);
  //pinMode(flowSensorPin, INPUT);
  //digitalWrite(flowSensorPin, HIGH);
  waterflow = 0;
  attachInterrupt(sensorInterrupt, pulseCounter, RISING);

  /*
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
  */
  
}

void printTime() {
  unsigned long currentMillis = millis();
  unsigned long currentSeconds = (currentMillis / 1000) % 60;
  unsigned long currentMinutes = (currentMillis / (1000 * 60)) % 60;
  unsigned long currentHours = (currentMillis / (1000 * 60 * 60)) % 24;
  Serial.printf("Time : %02lu:%02lu:%02lu :: ", currentHours, currentMinutes, currentSeconds);
}

void dht22() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  Serial.printf("Temperature: %.2f °C, Humidity: %.2f %%", temperature, humidity);

}


void ds18b20() {
  sensors.requestTemperatures(); 
  float tempC = sensors.getTempCByIndex(0);
  Serial.printf("   ---   Fluid Temperature: %.2f (°C)", tempC);
}

void sen0189() {
  int sensorValue = analogRead(0);// read the input on analog pin 0:
  float voltage = sensorValue * (5.0 / 1024.0); // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  Serial.printf("   ---   Turbidity: %.2f (V)", voltage);
}

void yf_s201(){
  pulseDuration = pulseIn(flowSensorPin, HIGH);
  float flowRate = 7.5 / pulseDuration;
  float x = pulseIn(flowSensorPin, LOW);
  float totalFlow = waterflow * 1000 * calibrationFactor;
  Serial.printf("PulseIn: %.2f\tFlow Rate: %.2f (L/min)\tTotal Flow: %.0f (mL)\t\n", x, flowRate, totalFlow);
}


void sync(){
  printTime();
  dht22();
  ds18b20();
  sen0189();
  yf_s201();
  Serial.println();
  delay(1000);
}

void keypad_func(){
  char key = keypad.getKey();
  //Serial.printf("%hu, %hu, %hu, %f\n",water,food_oil,car_oil,before_temperature);
  switch(key){
    case '1':
      Serial.printf("key pressed : %c\n",key);
      if (water == 0 && food_oil == 0){
        water = before_values[0]; food_oil = before_values[1];
      }
      water += 1;
      food_oil -= 1;
      if(car_oil!=0)
        car_oil=0;
      break;
    case '2':
      Serial.printf("key pressed : %c\n",key);
      if (water == 0 && food_oil == 0){
        water = before_values[0]; food_oil = before_values[1];
      }
      water -= 1;
      food_oil += 1;
      if(car_oil!=0)
        car_oil=0;
      break;
    case '3':
      Serial.printf("key pressed : %c\n",key);
      before_values[0] = water;
      before_values[1] = food_oil;
      water = 0.0;
      food_oil = 0.0;
      car_oil = 100.0;
      break;
    case '4':
      Serial.printf("key pressed : %c\n",key);
      before_temperature += 0.5;
      break;
    case '5':
      Serial.printf("key pressed : %c\n",key);
      before_temperature -= 0.5;
      break;
    case '*':
      reading = true;
      Serial.printf("key pressed : %c , reading -> %d\n",key,reading);
      break;
    case '#':
      reading = false;
      Serial.printf("key pressed : %c , reading -> %d\n",key,reading);
      break;
    default:
      break;
  }
}
void http_post(){
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

void loop() {
  //keypad_func();
  //http_post();
  //yf_s201();
  if(reading==true){
    sync();
    keypad_func();
  }
  keypad_func();
}



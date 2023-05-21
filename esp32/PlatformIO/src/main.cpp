#include <Arduino.h>
#include <ArduinoJson.h>
#include <OneWire.h>
#include <Keypad.h>
#include <DallasTemperature.h>
#include <Wire.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include "DHT.h"
#define DHTPIN 14 // GPIO14
#define ONE_WIRE_BUS 5 
#define DHTTYPE DHT22 // DHT22 (AM2302)
DynamicJsonDocument json(256);
DHT dht(DHTPIN, DHTTYPE);


OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

boolean reading = false;

int flowSensorPin = 17;  
volatile double waterflow;
unsigned long lastTime = 0;
unsigned long timerDelay = 800;
unsigned long pulseDuration; 

float readings[30];

float lastTotalFlow = 0.0;
float calibrationFactor =  0.884;

unsigned short before_values[2] = {0,0};

const char* brands[11] = {"FULA", "VAQUEIRO", "VEGE", "FRIGI", "MARCA BRANCA", "CASTROL", "ELF", "MOBIL", "LIQUI MOLY", "SHELL", "TOTAL"};
int brand_atual = 0;

const byte ROWS = 4; 
const byte COLS = 3;
const char* ssid = "ufp";
const char* password = "";
const char* serverName = "http://192.168.1.87:8080/sensor-data";

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
//sensor values to send through http request
float flowrate;
float air_temperature;
float humidity;
float liq_temperature;
float turbidity;
float before_temperature = 20.0;
unsigned short water = 90;
unsigned short food_oil = 10;
unsigned short engine_oil = 0;
const char* oil_brand = NULL;
/////////////////////////

void pulseCounter() {
  waterflow +=  1.0 / 450.0;
}

void setup() {
  Serial.begin(9600);
  sensors.begin();
  dht.begin();
  // gpio_install_isr_service(0);
  //pinMode(flowSensorPin, INPUT);
  //digitalWrite(flowSensorPin, HIGH);
  waterflow = 0;
  attachInterrupt(sensorInterrupt, pulseCounter, RISING);

  
  WiFi.begin(ssid, password);
  Serial.println("Connecting");
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.printf("\nSucessfully connected to Wifi %s.\n", ssid);
  bool status;
  
  
}

float quicksortPartition(float arr[], int low, int high) {
  float pivot = arr[high];
  int i = (low - 1);

  for (int j = low; j <= high - 1; j++) {
    if (arr[j] <= pivot) {
      i++;
      // Swap arr[i] and arr[j]
      float temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }

  // Swap arr[i + 1] and arr[high] (pivot)
  float temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;

  return (i + 1);
}

void quicksort(float arr[], int low, int high) {
  if (low < high) {
    int partitionIndex = quicksortPartition(arr, low, high);
    quicksort(arr, low, partitionIndex - 1);
    quicksort(arr, partitionIndex + 1, high);
  }
}

float getMedian(float arr[], int size) {
  quicksort(arr, 0, size - 1);

  if (size % 2 == 0) {
    return (arr[size / 2] + arr[(size / 2) - 1]) / 2.0;
  } else {
    return arr[size / 2];
  }
}

void printTime() {
  unsigned long currentMillis = millis();
  unsigned long currentSeconds = (currentMillis / 1000) % 60;
  unsigned long currentMinutes = (currentMillis / (1000 * 60)) % 60;
  unsigned long currentHours = (currentMillis / (1000 * 60 * 60)) % 24;
  unsigned long currentMilliseconds = currentMillis % 1000;
  Serial.printf("Time: %02lu:%02lu:%02lu.%03lu :: ", currentHours, currentMinutes, currentSeconds, currentMilliseconds);
}


void dht22() {
  air_temperature = dht.readTemperature();
  humidity = dht.readHumidity();
  Serial.printf("Temperature: %.2f °C, Humidity: %.2f %%", air_temperature, humidity);
}


void ds18b20() {
  sensors.requestTemperatures(); 
  liq_temperature = sensors.getTempCByIndex(0);
  Serial.printf("   ---   Fluid Temperature: %.2f (°C)", liq_temperature);
}

void sen0189() {
  int sensorValue = analogRead(39);
  turbidity = sensorValue * (5.0 / 1024.0);
  Serial.printf("   ---   Turbidity: %.2f (V)", turbidity);
}

void yf_s201(){
  for(int i = 0; i < 30; i++){

 
  static unsigned long startTime = 0;   
  static unsigned long elapsedTime = 0;
  unsigned long long elapsedSeconds = 0;
  float fixedflowRate = 0;  
  
  float totalFlow = waterflow * 1000 * calibrationFactor;
  

    if (totalFlow != lastTotalFlow) {
    if (startTime == 0) {
      startTime = millis();
    } else {
      unsigned long currentTime = millis();
      elapsedTime += currentTime - startTime;
      startTime = currentTime;
    }
    lastTotalFlow = totalFlow;
    }
    elapsedSeconds = elapsedTime / 1000;
    fixedflowRate = ((totalFlow / elapsedSeconds)  * 60.0)/1000.0;

  readings[i] = fixedflowRate;
  }
  flowrate = getMedian(readings, 30);
  Serial.printf("   ---   Flow Rate: %.2f (L/min)\n", flowrate);

}

void getFlowRate(){
  Serial.printf(" --------------- MEDIAN = %.2f ", flowrate);
  printTime();
}

void keypad_func(){
  char key = keypad.getKey();
  switch(key){
    case '1':
      Serial.printf("key pressed : %c\n",key);
      if (water == 0 && food_oil == 0){
        water = before_values[0]; food_oil = before_values[1];
      }
      water += 1;
      food_oil -= 1;
      if(engine_oil!=0)
        engine_oil=0;
      break;
    case '2':
      Serial.printf("key pressed : %c\n",key);
      if (water == 0 && food_oil == 0){
        water = before_values[0]; food_oil = before_values[1];
      }
      water -= 1;
      food_oil += 1;
      if(engine_oil!=0)
        engine_oil=0;
      break;
    case '3':
      Serial.printf("key pressed : %c\n",key);
      before_values[0] = water;
      before_values[1] = food_oil;
      water = 0.0;
      food_oil = 0.0;
      engine_oil = 100.0;
      break;
    case '4':
      Serial.printf("key pressed : %c\n",key);
      before_temperature += 0.5;
      break;
    case '5':
      Serial.printf("key pressed : %c\n",key);
      before_temperature -= 0.5;
      break;
    case '6':
      Serial.printf("key pressed : %c\n",key);
      brand_atual++;
      if(brand_atual > 10)
        brand_atual = 0;
      oil_brand = brands[brand_atual];
      Serial.printf("Oil brand = %s\n",oil_brand);
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
  if(reading == 1){
    if ((millis() - lastTime) > timerDelay) {
      //Check WiFi connection status
      if(WiFi.status()== WL_CONNECTED){
        WiFiClient client;
        HTTPClient http;
      
        
        http.begin(client, serverName);

        json["flow"] = flowrate;
        json["air_temperature"] = air_temperature;
        json["humidity"] = humidity;
        json["liq_temperature"] = liq_temperature;
        json["turbidity"] = turbidity;
        json["before_temperature"] = before_temperature;
        json["water"] = water;
        json["food_oil"] = food_oil;
        json["engine_oil"] = engine_oil;
        json["oil_brand"] = oil_brand;
        String payload;
        serializeJson(json, payload);

        http.addHeader("Content-Type", "application/json");
        int httpResponseCode = http.POST(payload);
        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
          
        // Free resources
        http.end();
      }
      else {
        Serial.println("WiFi Disconnected\n");
      }
      lastTime = millis();
      } 
  }
}

void sync(){
  printTime();
  dht22();
  ds18b20();
  sen0189();
  yf_s201();
  http_post();
}

void loop() {  
  if(reading==true){
    sync();
    keypad_func();
  }
  keypad_func();  
}



#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "DHT.h"
#define DHTPIN 14 // GPIO14
#define DHTTYPE DHT22 // DHT22 (AM2302)
#define ONE_WIRE_BUS 4
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  sensors.begin();
  dht.begin();
}

void dht22() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  Serial.printf("Temperature: %.2f °C, Humidity: %.2f %%", temperature, humidity);

}


void ds18b20() {
  sensors.requestTemperatures(); 

  float tempC = sensors.getTempCByIndex(0);

  Serial.printf("   ---   Fluid Temperature: %.2f (°C)\n", tempC);
}

void loop(){
  dht22();
  ds18b20();
  delay(1000);
}